package fe.game.rendering {

	import flash.display.BitmapData;
	import flash.filesystem.File;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.utils.Dictionary;

	import starling.textures.Texture;

	import fe.engine.utils.Files;

	// The effects in Modules/core/textures/effects.json: catalog textures drawn through modifiers, still or keyed into
	// animations. A texture goes to the GPU, baked through its modifier's ramp, the first time something shows it, and stays.
	public class EffectManager {

		private static const FILE:String	= "Modules/core/textures/effects.json";
		private static const RAMP_SIZE:int	= 256;

		private var grafon:Grafon;
		private var modifiers:Dictionary	= new Dictionary();		// Modifier_Definition by name
		private var animations:Dictionary	= new Dictionary();		// EffectAnimation_Definition by name
		private var effects:Dictionary		= new Dictionary();		// Effect_Definition by name
		private var images:Dictionary		= new Dictionary();		// FlipbookImage by texture and modifier, once on the GPU
		private var flipbooks:Dictionary	= new Dictionary();		// Flipbook_Definition by effect name, once built

		// The colour between two ramp stops, mix of the way from a to b
		private static function mixStops(colorA:uint, alphaA:Number, colorB:uint, alphaB:Number, mix:Number):uint {
			var red:uint	= uint(((colorA >> 16) & 0xFF) + (((colorB >> 16) & 0xFF) - ((colorA >> 16) & 0xFF)) * mix + 0.5);
			var green:uint	= uint(((colorA >> 8) & 0xFF) + (((colorB >> 8) & 0xFF) - ((colorA >> 8) & 0xFF)) * mix + 0.5);
			var blue:uint	= uint((colorA & 0xFF) + ((colorB & 0xFF) - (colorA & 0xFF)) * mix + 0.5);
			var alpha:uint	= uint((alphaA + (alphaB - alphaA) * mix) * 255.0 + 0.5);

			return (alpha << 24) | (red << 16) | (green << 8) | blue;
		}

		// A ramp's colour at each of 256 positions, from its stops: [position from 0 to 1, "#RRGGBB", alpha]. Before its first
		// stop and after its last it holds their colours, as Flash's gradients do.
		private static function readRamp(stops:Array):Vector.<uint> {
			var ramp:Vector.<uint> = new Vector.<uint>(RAMP_SIZE, true);
			var positions:Vector.<Number> = new Vector.<Number>();
			var colors:Vector.<uint> = new Vector.<uint>();
			var alphas:Vector.<Number> = new Vector.<Number>();
			var last:int;
			var stop:Array;
			var next:int;
			var i:int;

			for each (stop in stops) {
				positions.push(Number(stop[0]) * (RAMP_SIZE - 1));
				colors.push(uint(parseInt(String(stop[1]).substr(1), 16)));
				alphas.push(Number(stop[2]));
			}
			last = positions.length - 1;

			for (i = 0; i < RAMP_SIZE; i++) {
				next = 0;
				while (next <= last && positions[next] < i) {
					next++;
				}
				if (next == 0) {
					ramp[i] = mixStops(colors[0], alphas[0], colors[0], alphas[0], 0.0);
				}
				else if (next > last) {
					ramp[i] = mixStops(colors[last], alphas[last], colors[last], alphas[last], 0.0);
				}
				else {
					ramp[i] = mixStops(colors[next - 1], alphas[next - 1], colors[next], alphas[next],
						(i - positions[next - 1]) / (positions[next] - positions[next - 1]));
				}
			}

			return ramp;
		}

		// The texture recoloured by a ramp: each pixel takes the ramp's colour at its red value, faded by its own alpha
		private static function bake(source:BitmapData, ramp:Vector.<uint>):BitmapData {
			var pixels:Vector.<uint> = source.getVector(source.rect);
			var result:BitmapData = new BitmapData(source.width, source.height, true, 0);
			var pixel:uint;
			var color:uint;
			var i:int;

			for (i = 0; i < pixels.length; i++) {
				pixel = pixels[i];
				color = ramp[(pixel >> 16) & 0xFF];
				pixels[i] = (color & 0xFFFFFF) | (uint((color >>> 24) * (pixel >>> 24) / 255) << 24);
			}
			result.setVector(result.rect, pixels);

			return result;
		}

		private static function readTint(values:Array):ColorTransform {
			return values ? new ColorTransform(values[0], values[1], values[2], values[3], values[4], values[5], values[6], values[7]) : null;
		}

		// A tint mix of the way from a to b, where null stands for none; null when both are none
		private static function mixTints(a:ColorTransform, b:ColorTransform, mix:Number):ColorTransform {
			var from:ColorTransform = a || new ColorTransform();
			var to:ColorTransform = b || new ColorTransform();

			if (!a && !b) { return null; }

			return new ColorTransform(
				from.redMultiplier + (to.redMultiplier - from.redMultiplier) * mix,
				from.greenMultiplier + (to.greenMultiplier - from.greenMultiplier) * mix,
				from.blueMultiplier + (to.blueMultiplier - from.blueMultiplier) * mix,
				from.alphaMultiplier + (to.alphaMultiplier - from.alphaMultiplier) * mix,
				from.redOffset + (to.redOffset - from.redOffset) * mix,
				from.greenOffset + (to.greenOffset - from.greenOffset) * mix,
				from.blueOffset + (to.blueOffset - from.blueOffset) * mix,
				from.alphaOffset + (to.alphaOffset - from.alphaOffset) * mix);
		}

		// An animation's keys worked out for every frame. A key leaves out what is at rest: scale 1, no tint, shown.
		// Each key moves in a straight line to the next, unless the next is hidden.
		private static function readAnimation(json:Object):EffectAnimation_Definition {
			var animation:EffectAnimation_Definition = new EffectAnimation_Definition();
			var count:int = int(json.frames);
			var keys:Array = json.keys;
			var key:Object;
			var next:Object;
			var mix:Number;
			var scale:Number;
			var stop:int;
			var k:int;
			var f:int;

			animation.scales	= new Vector.<Number>(count, true);
			animation.tints		= new Vector.<ColorTransform>(count, true);
			animation.hidden	= new Vector.<Boolean>(count, true);
			animation.stops		= new Vector.<Boolean>(count, true);
			for each (stop in json.stops) {
				animation.stops[stop] = true;
			}

			for (f = 0; f < count; f++) {
				k = 0;
				while (k + 1 < keys.length && int(keys[k + 1].frame) <= f) {
					k++;
				}
				key		= keys[k];
				next	= (k + 1 < keys.length && f > int(key.frame) && keys[k + 1].hidden != true) ? keys[k + 1] : key;
				mix		= (next != key) ? (f - int(key.frame)) / (int(next.frame) - int(key.frame)) : 0.0;

				scale	= ("scale" in key) ? Number(key.scale) : 1.0;

				animation.scales[f]	= scale + ((("scale" in next) ? Number(next.scale) : 1.0) - scale) * mix;
				animation.tints[f]	= mixTints(readTint(key.tint), readTint(next.tint), mix);
				animation.hidden[f]	= key.hidden == true;
			}

			return animation;
		}

		private function buildFlipbook(name:String):Flipbook_Definition {
			var effect:Effect_Definition = effects[name];
			var definition:Flipbook_Definition = new Flipbook_Definition();
			var modifier:Modifier_Definition;
			var animation:EffectAnimation_Definition;
			var image:FlipbookImage;
			var tints:Vector.<ColorTransform>;
			var hasTint:Boolean = false;
			var count:int;
			var scale:Number;
			var f:int;

			if (!effect) {
				trace("EffectManager.as/buildFlipbook() - Error: effects.json has no effect \"" + name + "\", so it shows nothing");
				effect = new Effect_Definition();
				effect.texture = "";
			}
			if (effect.animation != "") {
				animation = animations[effect.animation];
				if (!animation) {
					trace("EffectManager.as/buildFlipbook() - Error: effect \"" + name + "\" plays animation \"" + effect.animation + "\", which effects.json lacks, so it stays still");
				}
			}

			image		= viewImage(effect.texture, effect.modifier);
			modifier	= modifiers[effect.modifier];
			count		= animation ? animation.scales.length : 1;

			definition.name		= name;
			definition.density	= image.texture.scale;
			definition.width	= image.texture.width * effect.scale;
			definition.height	= image.texture.height * effect.scale;
			definition.blend	= modifier ? modifier.blend : "normal";
			definition.sheet	= image.texture;
			definition.frames		= new Vector.<Vector.<FlipbookImage>>(count, true);
			definition.shows		= new Vector.<int>(count, true);
			definition.stops		= new Vector.<Boolean>(count, true);
			definition.placements	= new Vector.<Matrix>(count, true);
			tints = new Vector.<ColorTransform>(count, true);

			for (f = 0; f < count; f++) {
				definition.frames[f] = new Vector.<FlipbookImage>();
				if (!animation || !animation.hidden[f]) {
					definition.frames[f].push(image);
				}
				definition.shows[f]			= f;
				definition.stops[f]			= animation ? animation.stops[f] : true;
				scale						= effect.scale * (animation ? animation.scales[f] : 1.0);
				definition.placements[f]	= new Matrix(scale, 0.0, 0.0, scale);
				tints[f]					= animation ? animation.tints[f] : null;
				hasTint						= hasTint || tints[f] != null;
			}
			definition.tints = hasTint ? tints : null;

			return definition;
		}

		public function EffectManager(grafon_:Grafon) {
			var file:File = File.applicationDirectory.resolvePath(FILE);
			var json:Object;
			var source:Object;
			var name:String;
			var modifier:Modifier_Definition;
			var effect:Effect_Definition;

			grafon = grafon_;
			if (!file.exists) {
				trace("EffectManager.as/EffectManager() - Error: no \"" + FILE + "\", so effects show nothing");
				return;
			}

			json = JSON.parse(Files.readText(file));
			for (name in json.modifiers) {
				source		= json.modifiers[name];
				modifier	= new Modifier_Definition();
				if (source.ramp) {
					modifier.ramp = readRamp(source.ramp);
				}
				if (source.blend) {
					modifier.blend = source.blend;
				}
				modifiers[name] = modifier;
			}
			for (name in json.animations) {
				animations[name] = readAnimation(json.animations[name]);
			}
			for (name in json.effects) {
				source				= json.effects[name];
				effect				= new Effect_Definition();
				effect.name			= name;
				effect.texture		= source.texture;
				effect.modifier		= source.modifier || "";
				effect.animation	= source.animation || "";
				effect.scale		= ("scale" in source) ? Number(source.scale) : 1.0;
				effects[name]		= effect;
			}
		}

		// A new flipbook of the named effect, on its first frame
		public function createEffect(name:String):Flipbook {
			if (!flipbooks[name]) {
				flipbooks[name] = buildFlipbook(name);
			}

			return new Flipbook(flipbooks[name]);
		}

		// A catalog texture through a modifier ("" for none) on the GPU, with its pivot. A missing one shows nothing.
		public function viewImage(texture:String, modifier:String):FlipbookImage {
			var key:String = texture + " " + modifier;
			var bitmap:BitmapData;
			var size:Point;
			var pivot:Point;
			var density:Number;

			if (images[key]) { return images[key]; }

			bitmap = grafon.getObj(texture, Grafon.numbMat) as BitmapData;
			if (!bitmap) {
				trace("EffectManager.as/viewImage() - Error: no texture \"" + texture + "\" in textures/manifest.json, so it shows nothing");
				bitmap = new BitmapData(1, 1, true, 0);
			}
			if (modifier != "" && !modifiers[modifier]) {
				trace("EffectManager.as/viewImage() - Error: effects.json has no modifier \"" + modifier + "\", so \"" + texture + "\" shows as it is");
			}
			else if (modifier != "" && Modifier_Definition(modifiers[modifier]).ramp) {
				bitmap = bake(bitmap, Modifier_Definition(modifiers[modifier]).ramp);
			}

			size	= grafon.viewDrawSize(texture) || new Point(bitmap.width, bitmap.height);
			pivot	= grafon.viewPivot(texture);
			density	= bitmap.width / size.x;
			images[key] = new FlipbookImage(Texture.fromBitmapData(bitmap, density > 1.0, false, density), pivot.x * size.x, pivot.y * size.y);

			return images[key];
		}
	}
}
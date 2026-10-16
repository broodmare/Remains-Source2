package fe.game.rendering.weapon {

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	import fe.game.rendering.AtlasClip;
	import fe.game.rendering.ClipAtlas;

	// Resolves exported weapon layers into a caller-owned ClipAtlas. Shared art is cached by its drawing arguments.
	public class WeaponArt {

		private var atlas:ClipAtlas;
		private var catalog:Object;
		private var sheets:Object;
		private var clips:Object = {};

		// catalog: _shared/effects.json; sheets: weapon-root-relative JSON path -> {json, bitmap}.
		public function WeaponArt(atlas_:ClipAtlas, catalog_:Object, sheets_:Object) {
			atlas = atlas_;
			catalog = catalog_;
			sheets = sheets_;
		}

		// Placement, draw order and blendMode belong to the timeline layer and are applied after this texture is resolved.
		public function resolve(layer:Object):AtlasClip {
			var effect:Object;
			var palette:Object;
			var sheet:Object;
			var frame:Object;
			var rect:Object;
			var bitmap:BitmapData;
			var density:Number;
			var key:String;
			var clip:AtlasClip;

			if (layer.animation) { throw new ArgumentError("Resolve animated layers through WeaponTimeline.layers first"); }

			if (layer.effect) {
				effect = catalog.effects[layer.effect];
				if (!effect) { throw new ArgumentError("Unknown weapon effect: " + layer.effect); }
				palette = catalog.palettes[effect.palette];
				return lightSphere(effect.template, palette.colors, palette.alphas, palette.ratios, layer.colorTransform);
			}
			key = "weapon/" + layer.sheet + "/" + layer.sprite + "/" + colorKey(layer.colorTransform);
			if (clips[key] !== undefined) { return clips[key]; }
			sheet = sheets[layer.sheet];
			if (!sheet || !sheet.json.frames[layer.sprite]) {
				throw new ArgumentError("Missing weapon sprite: " + layer.sheet + "/" + layer.sprite);
			}
			frame = sheet.json.frames[layer.sprite];
			rect = frame.frame;
			density = Number(sheet.json.meta.scale);
			bitmap = new BitmapData(rect.w, rect.h, true, 0);
			bitmap.copyPixels(sheet.bitmap, new Rectangle(rect.x, rect.y, rect.w, rect.h), new Point());
			clip = atlas.add(key, new Bitmap(bitmap, "auto", true),
				new Matrix(1.0 / density, 0.0, 0.0, 1.0 / density,
					-frame.pivot.x * rect.w / density, -frame.pivot.y * rect.h / density), color(layer.colorTransform));
			bitmap.dispose();
			clips[key] = clip;
			return clip;
		}

		// Null palette arguments make a neutral white glow. radius defaults to the source template's game-pixel radius.
		public function lightSphere(template:String, colors:Array = null, alphas:Array = null, ratios:Array = null,
			colorTransform:Array = null, radius:Number = NaN):AtlasClip {
			var geometry:Object = catalog.templates[template];
			var neutral:Object = LightSphere.neutralPalette();
			var key:String;

			if (!geometry) { throw new ArgumentError("Unknown light sphere template: " + template); }
			colors = colors || neutral.colors;
			alphas = alphas || neutral.alphas;
			ratios = ratios || neutral.ratios;
			if (isNaN(radius)) { radius = geometry.radius; }
			key = "weapon/sphere/" + template + "/" + radius + "/" + colors.join(",") + "/" +
				alphas.join(",") + "/" + ratios.join(",") + "/" + colorKey(colorTransform);
			if (clips[key] === undefined) {
				clips[key] = atlas.add(key, LightSphere.create(geometry, colors, alphas, ratios, radius), new Matrix(), color(colorTransform));
			}
			return clips[key];
		}

		private static function colorKey(values:Array):String {
			return values ? values.join(",") : "identity";
		}

		private static function color(values:Array):ColorTransform {
			var value:Number;

			if (!values) { return null; }
			if (values.length != 8) { throw new ArgumentError("Weapon colour transform needs eight numbers"); }
			for each (value in values) {
				if (!isFinite(value)) { throw new ArgumentError("Invalid weapon colour transform"); }
			}
			return new ColorTransform(values[0], values[1], values[2], values[3], values[4], values[5], values[6], values[7]);
		}
	}
}

package fe.game.rendering {

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.filesystem.File;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.system.ImageDecodingPolicy;
	import flash.system.LoaderContext;
	import flash.utils.Dictionary;

	import starling.textures.Texture;

	import fe.engine.utils.Files;

	// Every unit sprite sheet in data/core/spritesheets/units.json. A sheet is read, and its PNG starts decoding, when a
	// unit first asks for it; it goes to the GPU the first time it is shown, and keepOnly() frees it once no unit uses it.
	// Decoded PNGs stay on the CPU too, for snapshots and to restore the GPU copy when the context is lost.
	public class UnitSheetManager {

		private static const CATALOG:String	= "data/core/spritesheets/units.json";
		private static const FOLDER:String	= "data/core/spritesheets/units";

		private var folder:File;
		private var entries:Object			= {};					// units.json's entry for each sheet, by name
		private var definitions:Dictionary	= new Dictionary();		// UnitSheet_Definition by name, once read
		private var bitmaps:Dictionary		= new Dictionary();		// Decoded PNGs by file name
		private var textures:Dictionary		= new Dictionary();		// The same PNGs on the GPU, once shown
		private var decoding:Dictionary		= new Dictionary();		// By file name, true while the PNG decodes
		private var failed:Dictionary		= new Dictionary();		// By file name, true for PNGs that can't be shown
		private var pending:int				= 0;					// PNGs still decoding

		// A sheet's frames from its JSON; the sheet itself comes later
		private function readDefinition(name:String):UnitSheet_Definition {
			var definition:UnitSheet_Definition = new UnitSheet_Definition();
			var entry:Object = entries[name];
			var json:Object;
			var values:Array;
			var key:String;
			var source:Object;
			var split:int;
			var column:int;
			var frames:Vector.<FlipbookImage>;
			var frame:FlipbookImage;

			definition.name = name;
			if (!entry) {
				trace("UnitSheetManager.as/readDefinition() - Error: units.json has no sheet \"" + name + "\", so its units show nothing");
				return definition;
			}

			definition.image	= entry.image;
			definition.density	= Number(entry.density);
			values = entry.transform;
			if (values && (values[0] != 1 || values[1] != 0 || values[2] != 0 || values[3] != 1 || values[4] != 0 || values[5] != 0)) {
				definition.transform = new Matrix(values[0], values[1], values[2], values[3], values[4], values[5]);
			}

			json = JSON.parse(Files.readText(folder.resolvePath(entry.animation)));
			for (key in json.frames) {
				source	= json.frames[key];
				split	= key.lastIndexOf("_");
				if (split < 0 || source.rotated) {
					trace("UnitSheetManager.as/readDefinition() - Warning: sheet \"" + name + "\" frame \"" + key + "\" isn't an animation_column frame drawn upright, so it is left out");
					continue;
				}

				column	= int(key.substr(split + 1));
				frame	= new FlipbookImage(null, (source.pivot.x * source.sourceSize.w - source.spriteSourceSize.x) / definition.density,
					(source.pivot.y * source.sourceSize.h - source.spriteSourceSize.y) / definition.density);
				frame.region = new Rectangle(source.frame.x, source.frame.y, source.frame.w, source.frame.h);

				frames = definition.animations[key.substr(0, split)];
				if (!frames) {
					frames = new Vector.<FlipbookImage>();
					definition.animations[key.substr(0, split)] = frames;
				}
				if (frames.length <= column) {
					frames.length = column + 1;
				}
				frames[column] = frame;
			}

			return definition;
		}

		private function decode(image:String):void {
			var file:File;
			var loader:Loader;
			var context:LoaderContext;

			if (!image || decoding[image] || bitmaps[image] || failed[image]) { return; }

			file = folder.resolvePath(image);
			if (!file.exists) {
				trace("UnitSheetManager.as/decode() - Error: no sheet PNG \"" + image + "\", so its units show nothing");
				failed[image] = true;
				return;
			}

			loader = new Loader();
			context = new LoaderContext();
			// Decoded while loading, so the first frame to show it doesn't stall
			context.imageDecodingPolicy = ImageDecodingPolicy.ON_LOAD;
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(event:Event):void {
				onDecoded(image, Bitmap(loader.content).bitmapData);
			});
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, function(event:IOErrorEvent):void {
				trace("UnitSheetManager.as/decode() - Error: sheet PNG \"" + image + "\" could not be decoded, so its units show nothing: " + event.text);
				onDecoded(image, null);
			});
			decoding[image] = true;
			pending++;
			loader.loadBytes(Files.readBytes(file), context);
		}

		private function onDecoded(image:String, bitmap:BitmapData):void {
			var definition:UnitSheet_Definition;

			delete decoding[image];
			pending--;
			if (!bitmap) {
				failed[image] = true;
				return;
			}

			bitmaps[image] = bitmap;
			for each (definition in definitions) {
				if (definition.image == image) {
					definition.bitmap = bitmap;
				}
			}
		}

		// Puts the sheet's PNG on the GPU, unless another sheet already has, and cuts its frames from it
		private function upload(definition:UnitSheet_Definition):void {
			var texture:Texture = textures[definition.image];
			var density:Number = definition.density;
			var frames:Vector.<FlipbookImage>;
			var frame:FlipbookImage;

			if (!texture) {
				if (definition.bitmap.width > Texture.maxSize || definition.bitmap.height > Texture.maxSize) {
					trace("UnitSheetManager.as/upload() - Error: sheet PNG \"" + definition.image + "\" is larger than the GPU's " + Texture.maxSize + " pixels, so its units show nothing");
					failed[definition.image] = true;
					return;
				}
				texture = Texture.fromBitmapData(definition.bitmap, density > 1.0, false, density);
				textures[definition.image] = texture;
			}

			for each (frames in definition.animations) {
				for each (frame in frames) {
					if (frame) {
						frame.texture = Texture.fromTexture(texture, new Rectangle(frame.region.x / density, frame.region.y / density,
							frame.region.width / density, frame.region.height / density));
					}
				}
			}
			definition.texture = texture;
		}

		public function UnitSheetManager() {
			var catalog:File = File.applicationDirectory.resolvePath(CATALOG);

			folder = File.applicationDirectory.resolvePath(FOLDER);
			if (!catalog.exists) {
				trace("UnitSheetManager.as/UnitSheetManager() - Error: no unit sheet catalog \"" + CATALOG + "\", so sheet units show nothing");
				return;
			}
			entries = JSON.parse(Files.readText(catalog)).units;
		}

		// Whether every PNG asked for has finished decoding
		public function get isLoaded():Boolean {
			return pending == 0;
		}

		// The named sheet, read on first ask, with its PNG decoding unless it has; a name units.json lacks gets an empty sheet
		public function viewDefinition(name:String):UnitSheet_Definition {
			var definition:UnitSheet_Definition = definitions[name];

			if (!definition) {
				definition = readDefinition(name);
				definitions[name] = definition;
			}
			decode(definition.image);

			return definition;
		}

		// Puts the sheet on the GPU once its PNG has decoded, and starts decoding a PNG freed since
		public function prepare(definition:UnitSheet_Definition):void {
			if (definition.texture || failed[definition.image]) { return; }

			if (definition.bitmap) {
				upload(definition);
			}
			else {
				decode(definition.image);
			}
		}

		// Frees, on the CPU and the GPU, every PNG that none of the given sheets uses, and decodes those they use
		public function keepOnly(used:Vector.<UnitSheet_Definition>):void {
			var kept:Dictionary = new Dictionary();
			var definition:UnitSheet_Definition;
			var image:String;
			var frames:Vector.<FlipbookImage>;
			var frame:FlipbookImage;

			for each (definition in used) {
				kept[definition.image] = true;
				decode(definition.image);
			}

			for each (definition in definitions) {
				image = definition.image;
				if (!image || kept[image] || !bitmaps[image]) { continue; }

				if (textures[image]) {
					Texture(textures[image]).dispose();
					delete textures[image];
				}
				BitmapData(bitmaps[image]).dispose();
				delete bitmaps[image];
			}

			for each (definition in definitions) {
				if (definition.bitmap && !bitmaps[definition.image]) {
					definition.bitmap	= null;
					definition.texture	= null;
					for each (frames in definition.animations) {
						for each (frame in frames) {
							if (frame) {
								frame.texture = null;
							}
						}
					}
				}
			}
		}
	}
}

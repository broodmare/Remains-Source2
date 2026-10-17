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

	// Every flipbook in data/core/spritesheets/objects. The JSON is read and the sheets decoded at startup; a sheet goes to the GPU the first time something shows its flipbook, and stays there.
	public class FlipbookManager {

		private static const FOLDER:String		= "data/core/spritesheets/objects";
		private static const PLACEHOLDER:String	= "placeholder";	// Shown for anything whose flipbook is missing

		private var definitions:Dictionary	= new Dictionary();		// Flipbook_Definition by name
		private var sources:Dictionary		= new Dictionary();		// By name: {json, bitmap}, until the sheet is on the GPU
		private var pending:int				= 0;					// Sheets still decoding
		private var effects:EffectManager;							// Makes the effects flipbooks place over their images
		private var onLoaded:Function;

		public var isLoaded:Boolean			= false;

		// The playback of a flipbook from its JSON; its images wait for the sheet
		private static function readDefinition(name:String, json:Object):Flipbook_Definition {
			var definition:Flipbook_Definition = new Flipbook_Definition();
			var count:int = json.frames.length;
			var jump:Object;
			var label:String;
			var f:int;

			definition.name		= name;
			definition.density	= Number(json.density);
			definition.width	= Number(json.width);
			definition.height	= Number(json.height);
			definition.blend	= json.blend;
			definition.shows	= new Vector.<int>(count, true);
			definition.stops	= new Vector.<Boolean>(count, true);
			for (f = 0; f < count; f++) {
				definition.shows[f] = f;
			}
			for each (f in json.stops) {
				definition.stops[f] = true;
			}
			for each (jump in json.jumps) {
				definition.shows[jump.at] = jump.to;
				definition.stops[jump.at] = !jump.play;
			}
			for (label in json.labels) {
				definition.labels[label] = int(json.labels[label]);
			}

			return definition;
		}

		// The frames' images as parts of the sheet, per frame and tick, from the given list in each frame
		private static function readFrames(json:Object, images:Dictionary, list:String):Vector.<Vector.<FlipbookImage>> {
			var frames:Vector.<Vector.<FlipbookImage>> = new Vector.<Vector.<FlipbookImage>>();
			var loop:Vector.<FlipbookImage>;
			var source:Object;
			var key:String;

			for each (source in json.frames) {
				loop = new Vector.<FlipbookImage>();
				for each (key in source[list] || []) {
					loop.push(key ? images[key] : null);
				}
				frames.push(loop);
			}

			return frames;
		}

		// The effects the flipbook places over its images: for each, per frame of the flipbook, a matrix and alpha, or null
		// where it doesn't show
		private function readEffects(json:Object):Vector.<FlipbookEffect_Definition> {
			var result:Vector.<FlipbookEffect_Definition> = new Vector.<FlipbookEffect_Definition>();
			var placed:FlipbookEffect_Definition;
			var source:Object;
			var frame:Object;
			var values:Array;
			var f:int;

			for each (source in json.effects) {
				placed			= new FlipbookEffect_Definition();
				placed.effect	= effects.viewFlipbook(source.effect);
				placed.blend	= source.blendMode || "normal";
				placed.matrices	= new Vector.<Matrix>(json.frames.length, true);
				placed.alphas	= new Vector.<Number>(json.frames.length, true);
				for (f = 0; f < json.frames.length; f++) {
					frame = source.frames[f];
					if (!frame) { continue; }

					values = frame.matrix;
					placed.matrices[f]	= new Matrix(values[0], values[1], values[2], values[3], values[4], values[5]);
					placed.alphas[f]	= ("alpha" in frame) ? Number(frame.alpha) : 1.0;
				}
				result.push(placed);
			}

			return result;
		}

		// Puts a decoded sheet on the GPU and cuts its images from it
		private function upload(definition:Flipbook_Definition):void {
			var source:Object = sources[definition.name];
			var json:Object = source.json;
			var density:Number = definition.density;
			var images:Dictionary = new Dictionary();
			var key:String;
			var rect:Object;
			var region:Rectangle;
			var frame:Object;

			definition.sheet = Texture.fromBitmapData(source.bitmap, density > 1.0, false, density);
			for (key in json.images) {
				rect	= json.images[key];
				region	= new Rectangle(rect.x / density, rect.y / density, rect.w / density, rect.h / density);
				images[key] = new FlipbookImage(Texture.fromTexture(definition.sheet, region), rect.pivotX / density, rect.pivotY / density);
			}
			definition.frames = readFrames(json, images, "images");
			for each (frame in json.frames) {
				if (frame.screen) {
					definition.screenFrames = readFrames(json, images, "screen");
					break;
				}
			}
			if (json.effects) {
				definition.effects = readEffects(json);
			}
			delete sources[definition.name];
		}

		private function onSheetDecoded(name:String, bitmap:BitmapData):void {
			sources[name].bitmap = bitmap;
			pending--;
			if (pending == 0) {
				isLoaded = true;
				onLoaded();
			}
		}

		private function decodeSheet(name:String, file:File):void {
			var loader:Loader = new Loader();
			var context:LoaderContext = new LoaderContext();

			// Decoded while loading, so the first room to show it doesn't stall
			context.imageDecodingPolicy = ImageDecodingPolicy.ON_LOAD;

			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(event:Event):void {
				onSheetDecoded(name, Bitmap(loader.content).bitmapData);
			});
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, function(event:IOErrorEvent):void {
				trace("FlipbookManager.as/decodeSheet() - Error: sheet \"" + file.name + "\" could not be decoded: " + event.text);
				onSheetDecoded(name, new BitmapData(1, 1, true, 0));
			});
			loader.loadBytes(Files.readBytes(file), context);
		}

		public function FlipbookManager(effects_:EffectManager, onLoaded_:Function) {
			var folder:File = File.applicationDirectory.resolvePath(FOLDER);
			var file:File;
			var sheet:File;
			var name:String;
			var json:Object;

			effects = effects_;
			onLoaded = onLoaded_;
			if (!folder.exists) {
				trace("FlipbookManager.as/FlipbookManager() - Error: no flipbook folder \"" + FOLDER + "\"");
			}
			else {
				for each (file in folder.getDirectoryListing()) {
					if (file.extension != "json") { continue; }

					name = file.name.substr(0, file.name.length - ".json".length);
					json = JSON.parse(Files.readText(file));
					sheet = folder.resolvePath(json.image);
					if (!sheet.exists) {
						trace("FlipbookManager.as/FlipbookManager() - Error: flipbook \"" + name + "\" has no sheet \"" + json.image + "\"");
						continue;
					}
					definitions[name] = readDefinition(name, json);
					sources[name] = {json: json, bitmap: null};
					pending++;
					decodeSheet(name, sheet);
				}
			}
			isLoaded = pending == 0;
		}

		// The named flipbook, its sheet on the GPU, or the placeholder when there is none
		public function viewDefinition(name:String):Flipbook_Definition {
			var definition:Flipbook_Definition = definitions[name];

			if (!definition) {
				trace("FlipbookManager.as/viewDefinition() - Warning: no flipbook \"" + name + "\", so the placeholder shows");
				definition = definitions[PLACEHOLDER];
			}
			if (!definition) {
				trace("FlipbookManager.as/viewDefinition() - Error: no placeholder flipbook either");
				return null;
			}
			if (!isLoaded) {
				trace("FlipbookManager.as/viewDefinition() - Error: flipbook \"" + name + "\" was asked for before the sheets finished loading");
				return null;
			}
			if (!definition.sheet) {
				upload(definition);
			}

			return definition;
		}
	}
}
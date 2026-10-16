package fe.game.rendering.rig {

	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.filesystem.File;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;

	import fe.engine.utils.Files;

	// One rig's files from its folder: the skeleton and animations (name.gltf), how it is dressed (name.json), and every image.
	// The JSON and glTF are read at once; the images load in the background, then onLoaded is called.
	// The atlas for each look worn is built from the images on first use and kept.
	public class RigAssets {

		private var pending:int		= 0;
		private var onLoaded:Function;
		private var arts:Dictionary	= new Dictionary();		// RigArt by look key

		public var name:String;
		public var definition:Rig_Definition;
		public var art:RigArt_Definition;
		public var bitmaps:Dictionary	= new Dictionary();		// BitmapData by image key
		public var isLoaded:Boolean		= false;

		private static function strings(list:Array):Vector.<String> {
			var result:Vector.<String> = new Vector.<String>();
			var item:String;

			for each (item in list || []) {
				result.push(item);
			}

			return result;
		}

		private static function readArt(json:Object):RigArt_Definition {
			var result:RigArt_Definition = new RigArt_Definition();
			var key:String;
			var source:Object;
			var drawing:RigDrawing_Definition;
			var rigSwitch:RigSwitch_Definition;
			var armor:RigArmor_Definition;
			var style:Array;
			var placement:Array;
			var state:String;

			result.density = Number(json.density) || 1.0;
			for (key in json.pivots) {
				result.pivots[key] = json.pivots[key];
			}
			for (key in json.styles) {
				result.styleCounts[key] = int(json.styles[key]);
			}
			for (key in json.drawings) {
				source = json.drawings[key];
				drawing = new RigDrawing_Definition();
				drawing.name = key;
				for each (style in source.images) {
					drawing.images.push(strings(style));
				}
				if (source.placements) {
					drawing.placements = new Vector.<Vector.<Number>>();
					for each (placement in source.placements) {
						drawing.placements.push(Vector.<Number>(placement));
					}
				}
				drawing.style		= source.style || "";
				drawing.tint		= source.tint || "";
				drawing.isMask		= source.mask == true;
				drawing.maskedBy	= source.maskedBy || "";
				drawing.isArmorOnly	= source.armorOnly == true;
				drawing.loopFrom	= int(source.loopFrom);
				result.drawings[key] = drawing;
			}
			for (key in json.switches) {
				source = json.switches[key];
				rigSwitch = new RigSwitch_Definition();
				rigSwitch.name				= key;
				rigSwitch.initial			= source.initial;
				rigSwitch.isPerAnimation	= source.perAnimation == true;
				for (state in source.states) {
					rigSwitch.states[state] = strings(source.states[state]);
				}
				result.switches.push(rigSwitch);
			}
			for (key in json.armor) {
				source = json.armor[key];
				armor = new RigArmor_Definition();
				armor.id			= key;
				armor.coversBase	= strings(source.coversBase);
				armor.hides			= strings(source.hides);
				for (state in source.images) {
					armor.images[state] = source.images[state];
				}
				result.armor[key] = armor;
			}

			return result;
		}

		// How each animation plays, from the JSON: where its scripts jump and stop, the switches they set, and the colours
		// its bones take. An animation the JSON doesn't describe loops from end to start.
		private static function readPlayback(json:Object, animation:RigAnimation_Definition, definition:Rig_Definition):void {
			var source:Object = json ? json[animation.name] : null;
			var f:int;
			var jump:Object;
			var change:Object;
			var label:String;
			var bone:String;
			var bones:Array = [];
			var values:Array;
			var i:int;

			animation.shows		= new Vector.<int>(animation.frameCount, true);
			animation.stops		= new Vector.<Boolean>(animation.frameCount, true);
			animation.events	= new Vector.<Vector.<String>>(animation.frameCount, true);
			for (f = 0; f < animation.frameCount; f++) {
				animation.shows[f] = f;
			}
			if (!source) { return; }

			for each (f in source.stops) {
				animation.stops[f] = true;
			}
			for each (jump in source.jumps) {
				animation.shows[jump.at] = jump.to;
				animation.stops[jump.at] = !jump.play;
			}
			for each (change in source.switches) {
				if (!animation.events[change.at]) {
					animation.events[change.at] = new Vector.<String>();
				}
				animation.events[change.at].push(change.name, change.state);
			}
			for (label in source.labels) {
				animation.labels[label] = int(source.labels[label]);
			}

			for (bone in source.colors) {
				if (definition.byName[bone] === undefined || source.colors[bone].length != animation.frameCount * 4) {
					trace("RigAssets.as/readPlayback() - Warning: animation \"" + animation.name + "\" colours \"" + bone + "\", which doesn't fit the skeleton, so it is ignored");
					continue;
				}
				bones.push(bone);
				animation.colorNodes.push(definition.byName[bone]);
			}
			animation.colors = new Vector.<Number>(animation.frameCount * bones.length * 4, true);
			for (i = 0; i < bones.length; i++) {
				values = source.colors[bones[i]];
				for (f = 0; f < animation.frameCount; f++) {
					animation.colors[(f * bones.length + i) * 4]		= values[f * 4];
					animation.colors[(f * bones.length + i) * 4 + 1]	= values[f * 4 + 1];
					animation.colors[(f * bones.length + i) * 4 + 2]	= values[f * 4 + 2];
					animation.colors[(f * bones.length + i) * 4 + 3]	= values[f * 4 + 3];
				}
			}
		}

		private function onImage(e:Event):void {
			var info:LoaderInfo = LoaderInfo(e.target);

			bitmaps[info.loader.name] = Bitmap(info.content).bitmapData;
			imageDone();
		}

		private function onImageError(e:IOErrorEvent):void {
			trace("RigAssets.as/onImageError() - Error: rig \"" + name + "\" couldn't load an image: " + e.text);
			imageDone();
		}

		private function imageDone():void {
			pending--;
			if (pending == 0) {
				isLoaded = true;
				onLoaded();
			}
		}

		// folder: the rig's folder, such as data/core/rigs/pony in the game folder
		public function RigAssets(folder:File, name_:String, onLoaded_:Function) {
			var json:Object;
			var gltf:Object;
			var gltfFile:File;
			var animation:RigAnimation_Definition;
			var key:String;
			var loader:Loader;
			var imagesFolder:File;

			name		= name_;
			onLoaded	= onLoaded_;
			json		= JSON.parse(Files.readText(folder.resolvePath(name + ".json")));
			gltfFile	= folder.resolvePath(json.skeleton);
			gltf		= JSON.parse(Files.readText(gltfFile));
			definition	= GltfReader.read(gltf, Files.readBytes(gltfFile.parent.resolvePath(gltf.buffers[0].uri)), Number(json.fps) || 30.0);
			art			= readArt(json);
			for each (animation in definition.animations) {
				readPlayback(json.animations, animation, definition);
			}

			imagesFolder = folder.resolvePath(json.images);
			for (key in art.pivots) {
				pending++;
			}
			for (key in art.pivots) {
				loader = new Loader();
				loader.name = key;
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onImage);
				loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onImageError);
				loader.load(new URLRequest(imagesFolder.resolvePath(key + ".png").url));
			}
			if (pending == 0) {
				trace("RigAssets.as/RigAssets() - Warning: rig \"" + name + "\" has no images");
				pending = 1;
				imageDone();
			}
		}

		// The atlas of every image look wears, built the first time it is asked for. Each call is one more user,
		// and every user hands it back with release() when it stops wearing the look.
		public function artFor(look:RigLook):RigArt {
			var key:String = look.key;

			if (!arts[key]) {
				arts[key] = new RigArt(this, look);
				RigArt(arts[key]).key = key;
			}
			RigArt(arts[key]).users++;

			return arts[key];
		}

		// Frees an atlas's page on the GPU once nothing wears its look
		public function release(art:RigArt):void {
			art.users--;
			if (art.users == 0) {
				delete arts[art.key];
				art.dispose();
			}
		}
	}
}

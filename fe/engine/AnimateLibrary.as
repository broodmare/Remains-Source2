package fe.engine {

	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	import flash.utils.Endian;

	// Animate's build of the game, pfe.swf, loaded as the art library by a build from another compiler, which has none of
	// the library's symbols. Its document class is cut out first, so loading it doesn't start a second game.
	// The symbols join this build's classes, so they are found by name just as in Animate's own build.
	public class AnimateLibrary {

		private static const FILE:String			= "pfe.swf";
		private static const SYMBOL_CLASS:int		= 76;		// The tag naming the classes of a SWF's symbols; character 0 is the document
		private static const LONG_LENGTH:int		= 0x3F;		// A tag length this large means the real length follows in 32 bits
		private static const HEADER_BYTES:int		= 8;		// Signature, version and file length, ahead of the compressed part

		private var loader:Loader = new Loader();
		private var onLoaded:Function;

		private static function readFile(file:File):ByteArray {
			var stream:FileStream = new FileStream();
			var bytes:ByteArray = new ByteArray();

			stream.open(file, FileMode.READ);
			stream.readBytes(bytes);
			stream.close();

			return bytes;
		}

		// The SWF uncompressed, without the SymbolClass entry that makes character 0 its document class, or null if unreadable
		private static function withoutDocumentClass(swf:ByteArray):ByteArray {
			var body:ByteArray = new ByteArray();
			var tags:ByteArray = new ByteArray();
			var kept:ByteArray = new ByteArray();
			var result:ByteArray = new ByteArray();
			var signature:String;
			var version:int;
			var position:int;
			var code:int;
			var length:int;
			var header:int;
			var count:int;
			var keptCount:int;
			var start:int;
			var id:int;
			var nameByte:int;
			var i:int;

			swf.endian = Endian.LITTLE_ENDIAN;
			signature = swf.readUTFBytes(3);
			version = swf.readUnsignedByte();
			swf.position = HEADER_BYTES;
			swf.readBytes(body);
			if (signature == "CWS") {
				body.uncompress();
			}
			else if (signature != "FWS") {
				trace("AnimateLibrary.as/withoutDocumentClass() - Error: " + FILE + " is compressed as \"" + signature + "\", which isn't handled");
				return null;
			}
			body.endian = Endian.LITTLE_ENDIAN;
			tags.endian = Endian.LITTLE_ENDIAN;

			// The stage rectangle packs four fields of the width its first 5 bits give; the frame rate and count follow
			position = Math.ceil((5 + 4 * (body[0] >> 3)) / 8.0) + 4;
			tags.writeBytes(body, 0, position);

			while (position < body.length) {
				body.position = position;
				code	= body.readUnsignedShort();
				length	= code & LONG_LENGTH;
				code	= code >> 6;
				header	= 2;
				if (length == LONG_LENGTH) {
					length = body.readUnsignedInt();
					header = 6;
				}

				if (code != SYMBOL_CLASS) {
					tags.writeBytes(body, position, header + length);
				}
				else {
					count = body.readUnsignedShort();
					kept.length = 0;
					keptCount = 0;
					for (i = 0; i < count; i++) {
						start = body.position;
						id = body.readUnsignedShort();
						// The class name runs to a zero byte
						do {
							nameByte = body.readUnsignedByte();
						} while (nameByte != 0);
						if (id != 0) {
							kept.writeBytes(body, start, body.position - start);
							keptCount++;
						}
					}
					tags.writeShort((SYMBOL_CLASS << 6) | LONG_LENGTH);
					tags.writeUnsignedInt(kept.length + 2);
					tags.writeShort(keptCount);
					tags.writeBytes(kept);
				}
				position += header + length;
			}

			result.endian = Endian.LITTLE_ENDIAN;
			result.writeUTFBytes("FWS");
			result.writeByte(version);
			result.writeUnsignedInt(tags.length + HEADER_BYTES);
			result.writeBytes(tags);

			return result;
		}

		// The library's symbols only exist once its timeline has reached its last frame and a frame has passed
		private function onComplete(event:Event):void {
			var library:MovieClip = MovieClip(loader.content);

			library.gotoAndStop(library.totalFrames);
			library.addEventListener(Event.ENTER_FRAME, onFramePassed);
		}

		private function onFramePassed(event:Event):void {
			event.currentTarget.removeEventListener(Event.ENTER_FRAME, onFramePassed);
			onLoaded();
		}

		private function onError(event:IOErrorEvent):void {
			trace("AnimateLibrary.as/onError() - Error: " + FILE + " could not be loaded: " + event.text);
		}

		// Loads the library from the game's folder, then calls onLoaded_
		public function AnimateLibrary(onLoaded_:Function) {
			var file:File = File.applicationDirectory.resolvePath(FILE);
			var context:LoaderContext = new LoaderContext(false, ApplicationDomain.currentDomain);
			var bytes:ByteArray;

			onLoaded = onLoaded_;
			if (!file.exists) {
				trace("AnimateLibrary.as/AnimateLibrary() - Error: no " + FILE + " in " + File.applicationDirectory.nativePath + "; publish it from Animate");
				return;
			}

			bytes = withoutDocumentClass(readFile(file));
			if (!bytes) { return; }

			context.allowCodeImport = true;
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onError);
			loader.loadBytes(bytes, context);
		}
	}
}

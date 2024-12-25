package fe {

	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.URLLoader; 
	import flash.net.URLRequest; 
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.errors.IOError;
	import flash.events.IOErrorEvent;

    public class XMLLoader extends EventDispatcher {
		
		public var xmlData:XML;
		private var fileURL:String;
		private var loader:URLLoader;

		public static const XML_LOADED:String = "xml_Loaded";

		// Constructor
		public function XMLLoader() {

		}

		// Asynchronous loading (skips while loading)
		public function load(url:String):void {
			fileURL = url;
			//trace("XMLLoader.as/load() - Attempting to load file: " + url);
			var loaderURL:URLRequest = new URLRequest(fileURL);
			loader = new URLLoader();

			loader.addEventListener(Event.COMPLETE, loaderFinished);
			loader.addEventListener(IOErrorEvent.IO_ERROR, loaderFinished);
			loader.load(loaderURL);
		}

		// Synchronous loading (waits until this is finished)
		public function syncLoad(url:String):XML {
			//trace("XMLLoader/syncLoad() - Sync loading file: " + url);
			var file:File = File.applicationDirectory.resolvePath(url);
			var stream:FileStream = new FileStream();
			try {
				// Open the local file synchronously for reading, then parse the entire file into a string
				stream.open(file, FileMode.READ);
				var fileData:String = stream.readUTFBytes(stream.bytesAvailable);
				return new XML(fileData);
			}
			catch (error:Error) {
				trace("XMLLoader/syncLoad() - Error loading file: " + file.nativePath + " Error: " + error.message);
			}
			return null;
		}

		private function loaderFinished(event:Event):void
		{
			event.target.removeEventListener(Event.COMPLETE, loaderFinished);
			event.target.removeEventListener(IOErrorEvent.IO_ERROR, loaderFinished);
			switch (event.type) 
			{
				case Event.COMPLETE:
					//trace('XMLLoader.as/loaderFinished() - File: "' + fileURL + '" loaded!.');
					xmlData = new XML(loader.data);
					dispatchEvent(new Event(XMLLoader.XML_LOADED));
					break;
				
				case IOErrorEvent.IO_ERROR:
					trace('XMLLoader.as/loaderFinished() - File: "' + fileURL + '" failed to load! IO_ERROR.');
					break;
			}
		}
	}
}
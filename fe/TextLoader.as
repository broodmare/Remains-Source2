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

    public class TextLoader extends EventDispatcher {
		
		public var xmlData:XML;
		public var jsonData:Object;

		private var fileURL:String;		// The path of the file
		private var loader:URLLoader;	// Built-in Flash loader 

		public static const TEXT_LOADED:String = "text_Loaded";

		// Constructor
		public function TextLoader() {

		}

		// Asynchronous loading (skips while loading)
		public function load(url:String):void {
			fileURL = url;
			var loaderURL:URLRequest = new URLRequest(fileURL);
			loader = new URLLoader();

			loader.addEventListener(Event.COMPLETE, loaderFinished);
			loader.addEventListener(IOErrorEvent.IO_ERROR, loaderFinished);
			loader.load(loaderURL);
		}

		// Synchronous loading (waits until this is finished)
		public function syncLoad(url:String):* {
			var file:File = File.applicationDirectory.resolvePath(url);
			var stream:FileStream = new FileStream();
			try {
				// Open the local file synchronously for reading, then parse the entire file into a string
				stream.open(file, FileMode.READ);
				var fileData:String = stream.readUTFBytes(stream.bytesAvailable);

				 // Determine the file type
				if (endsWith(url.toLowerCase(), ".xml")) {
					return new XML(fileData); // Parse and return XML data
				}
				else if (endsWith(url.toLowerCase(), ".json")) {
					var parsedData:Object = JSON.parse(fileData);
					
					if (parsedData == null) {
						trace("TextLoader.as/syncLoad() - JSON parsing failed for file: " + url);
					}

					return parsedData;
				}
				else {
					trace("TextLoader/syncLoad() - Unsupported file type: " + url);
				}
			}
			catch (error:Error) {
				trace("TextLoader/syncLoad() - Error loading file: " + file.nativePath + " Error: " + error.message)
			}
			finally {
				stream.close();
			}

			return null; // Failsafe
		}

		private function endsWith(str:String, suffix:String):Boolean {
            if (str == null || suffix == null) {
                return false;
            }
            return str.lastIndexOf(suffix) == (str.length - suffix.length);
        }

		private function loaderFinished(event:Event):void {
			event.target.removeEventListener(Event.COMPLETE, loaderFinished);
			event.target.removeEventListener(IOErrorEvent.IO_ERROR, loaderFinished);
			
			switch (event.type) {
				case Event.COMPLETE:
					try {
						var data:String = loader.data;
						
						// Determine the file type based on URL extension
						if (endsWith(fileURL.toLowerCase(), ".xml")) {
							xmlData = new XML(data);
						}
						else if (endsWith(fileURL.toLowerCase(), ".json")) {
							jsonData = JSON.parse(data);
							
							// Check if JSON parsing failed
							if (jsonData == null) {
								trace("TextLoader.as/loaderFinished() - JSON parsing returned null for file: " + fileURL);
							}
						}
						else {
							trace("TextLoader.as/loaderFinished() - Unsupported file type: " + fileURL);
						}
						
						dispatchEvent(new Event(TextLoader.TEXT_LOADED));
					}
					catch (parseError:Error) {
						trace("TextLoader.as/loaderFinished() - Error parsing file: " + fileURL + " Error: " + parseError.message);
					}
					break;
				case IOErrorEvent.IO_ERROR:
					trace('TextLoader.as/loaderFinished() - File: "' + fileURL + '" failed to load! IO_ERROR.');
					break;
			}
		}
	}
}
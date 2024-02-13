package fe
{
	import flash.net.URLLoader; 
	import flash.net.URLRequest; 
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;

    public class XMLLoader extends EventDispatcher 
    {
		public var xmlData:XML;
		private var fileURL:String;
		private var loaderURL:URLRequest;
		private var loader:URLLoader;

		public static const XML_LOADED:String = "xml_Loaded";

		public function XMLLoader()
		{

		}

		public function load(url:String):void
		{
			fileURL = url;

			loaderURL = new URLRequest(fileURL);
			loader = new URLLoader();
			
			loader.addEventListener(Event.COMPLETE, loaderFinished);
			loader.addEventListener(IOErrorEvent.IO_ERROR, loaderFinished);
			loader.load(loaderURL);
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
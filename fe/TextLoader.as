package fe
{
	import flash.net.URLLoader; 
	import flash.net.URLRequest; 
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	
	public class TextLoader {
		public var id:String;
		public var n:int = 0;
		
		private var defaultLanguage:Boolean = false; // Indicates if the language being loaded is used as the fall-back default language.
		private var filepath:String;

		private var loader_text:URLLoader; 
		public var progressLoad:Number = 0;
		
		public var loaded:Boolean  = false;
		public var errLoad:Boolean = false;
		
		public var xmlData:XML;
		
		public function TextLoader(filePath:String, isDefault:Boolean = false) {
			defaultLanguage = isDefault;
			filepath = 'Modules/core/Language/' + filePath;

			loader_text = new URLLoader();
			var request:URLRequest = new URLRequest(filepath);
			
			loader_text.addEventListener(Event.COMPLETE, onCompleteLoadText);
			loader_text.addEventListener(IOErrorEvent.IO_ERROR, onErrorLoadText);
			loader_text.addEventListener(ProgressEvent.PROGRESS, funProgress);
			
			World.w.load_log += 'Attempting to load language file from: ' + filepath + '.\n';

			loader_text.load(request); 
		}

		private function onCompleteLoadText(event:Event):void
		{
			loader_text.removeEventListener(Event.COMPLETE, onCompleteLoadText);
			loader_text.removeEventListener(IOErrorEvent.IO_ERROR, onErrorLoadText);
			loader_text.removeEventListener(ProgressEvent.PROGRESS, funProgress);

			loaded = true;
			World.w.load_log += filepath + ' loaded\n';
			try {
				xmlData = new XML(loader_text.data);
				if (defaultLanguage) Res.fallbackLanguageData = xmlData; // IF THIS LANGAUGE IS THE DEFAULT, COPY IT TO res.fallbackLanguage TO USE AS A FALLBACK.
				loaded = true;
			} 
			catch(err) {
				trace('ERROR: (00:1F)');
				World.w.load_log += 'Text file error ' + filepath + '\n';
				errLoad = true;
			}

			World.w.textsLoadOk();
		}
		
		private function onErrorLoadText(event:IOErrorEvent):void {
			loader_text.removeEventListener(Event.COMPLETE, onCompleteLoadText);
			loader_text.removeEventListener(IOErrorEvent.IO_ERROR, onErrorLoadText);
			loader_text.removeEventListener(ProgressEvent.PROGRESS, funProgress);

			errLoad = true;
			World.w.load_log += filepath + ' failed to load.\n';
			World.w.textsLoadOk();
        }
		
		private function funProgress(event:ProgressEvent):void {
			progressLoad = event.bytesLoaded / event.bytesTotal;
			World.w.textProgressLoad = progressLoad;
        }	
	}	
}
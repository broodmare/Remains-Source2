package fe.graph {
	
	import flash.net.URLRequest;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	
	public class GrLoader {
		
		public var id:int;
		public var loader:Loader;
		public var progressLoad:Number=0;
		public var isLoad:Boolean=false;
		public var res:*;
		var gr:Grafon;
		
		public static var kol:int=0;
		public static var kolIsLoad:int=0;

		public function GrLoader(nid:int, url:String, ngr:Grafon) {
			kol++;
			gr=ngr;
			id=nid;
			loader = new Loader();
			var urlReq:URLRequest = new URLRequest(url);
			loader.load(urlReq);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, funLoaded);  
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, funProgress);
			
			// constructor code
		}
		
		function funLoaded(event:Event):void {
			res = event.target.content;
			isLoad=true;
			progressLoad=1;
			kolIsLoad++;
			gr.checkLoaded(id);
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, funLoaded);  
			loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, funProgress);
 		}
		function funProgress(event:ProgressEvent):void {
			progressLoad=event.bytesLoaded/event.bytesTotal;
			gr.allProgress();
        }

	}
	
}

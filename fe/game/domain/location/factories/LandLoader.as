package fe.game.domain.location.factories {

	// [Class that loads terrain maps from a file or takes them from variables contained in the world object]
	import flash.net.URLLoader; 
	import flash.net.URLRequest; 
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import fe.engine.text.XMLDataGrabber;
	import fe.game.World;
	import fe.game.GameContainer;
	
	public class LandLoader {

		private static const LAND_PATH:String = 'Rooms/';	// The folder the lands' room maps load from

		public var id:String;
		
		public var roomsFile:String;
		private var loader_rooms:URLLoader; 
		private var request:URLRequest;
		
		public var test:Boolean=false;
		public var loaded:Boolean=false;
		public var errLoad:Boolean=false;
		
		public var allroom:XML;
		
		// Construcctor
		public function LandLoader(nid:String) {
			id = nid;
			var roomNode:XML = XMLDataGrabber.getNodeWithAttributeThatMatches("core", "GameData", "Lands", "id", id);

			roomsFile = roomNode.@file;
			test = (roomNode.@test > 0);

			//источник шаблонов локаций
			if (GameContainer.reference.roomsLoad) {
				loader_rooms = new URLLoader();
				var roomsURL:String = LAND_PATH+roomsFile+".xml";
				request = new URLRequest(roomsURL); 
				loader_rooms.load(request); 
				
				loader_rooms.addEventListener(Event.COMPLETE, onCompleteLoadRooms); 
				loader_rooms.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler); 
			}
			else {
				allroom=World.w.rooms.rooms[roomsFile];
				loaded=true;
				GameContainer.reference.load_log+='Land '+roomsFile+' loaded\n';
				if (!test) World.w.roomsLoadOk();
			}
		}

		private function onCompleteLoadRooms(event:Event):void {
			var loader:URLLoader = URLLoader(event.currentTarget);
            loader.removeEventListener(Event.COMPLETE, onCompleteLoadRooms); 
			loader.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler); 
			loaded=true;
			GameContainer.reference.load_log+='Land '+roomsFile+' loaded\n';
			allroom = new XML(loader_rooms.data);
			if (!test) World.w.roomsLoadOk();
		}
		
		private function ioErrorHandler(event:IOErrorEvent):void {
			var loader:URLLoader = URLLoader(event.currentTarget);
			loader.removeEventListener(Event.COMPLETE, onCompleteLoadRooms); 
			loader.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler); 
			GameContainer.reference.load_log+='IOerror '+roomsFile+'\n';
        }
	}
}
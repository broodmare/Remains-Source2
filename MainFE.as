package {

	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.events.Event;

	import fe.*;
	
	public class MainFE extends MovieClip {
		
		// Constructor
		public function MainFE() {
			stage.scaleMode = "noScale";
			stage.align=StageAlign.TOP_LEFT;
			stage.color = 0;

			this.stop();
			this.addEventListener(Event.ENTER_FRAME, onEnterFrameLoader);
		}
		
		private function onEnterFrameLoader(event:Event):void {
			var bytesLoaded:uint = loaderInfo.bytesLoaded;
			var bytesTotal:uint = loaderInfo.bytesTotal;

			if (bytesLoaded >= bytesTotal) {
				removeEventListener(Event.ENTER_FRAME, onEnterFrameLoader);

				this.nextFrame();
				var mainMenu:fe.MainMenu = new MainMenu(this);
			}
		}
	}
}
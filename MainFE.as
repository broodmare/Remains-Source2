package {

	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.events.Event;
	import flash.system.ApplicationDomain;

	import fe.engine.AnimateLibrary;
	import fe.engine.Engine;

	// Starts the game. Animate's build carries the art library from its second frame; a build from another compiler
	// loads Animate's build to get it first.
	public class MainFE extends MovieClip {

		private static const LIBRARY_SYMBOL:String = "visBlack";	// Any symbol of the art library, to tell whether the library is here

		private var engine:Engine;
		private var library:AnimateLibrary;

		private function onEnterFrameLoader(event:Event):void {
			var bytesLoaded:uint = loaderInfo.bytesLoaded;
			var bytesTotal:uint = loaderInfo.bytesTotal;

			if (bytesLoaded >= bytesTotal) {
				removeEventListener(Event.ENTER_FRAME, onEnterFrameLoader);

				this.nextFrame();
				if (ApplicationDomain.currentDomain.hasDefinition(LIBRARY_SYMBOL)) {
					start();
				}
				else {
					library = new AnimateLibrary(start);
				}
			}
		}

		private function start():void {
			engine = new Engine(this);
		}

		public function MainFE() {
			stage.scaleMode = "noScale";
			stage.align=StageAlign.TOP_LEFT;
			stage.color = 0;

			this.stop();
			this.addEventListener(Event.ENTER_FRAME, onEnterFrameLoader);
		}
	}
}
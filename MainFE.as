package  
{
	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.events.Event;

	import fe.*;
	import fe.stubs.zastavka;
	
	public class MainFE extends MovieClip
	{
		private var mainMenu:MainMenu;
		
		public function MainFE() 
		{
			//	Initialize the stage, the top container that holds all objects.
			stage.scaleMode = "noScale";
			stage.align=StageAlign.TOP_LEFT;
			stage.color = 0;
			this.stop();
			this.addEventListener(Event.ENTER_FRAME, onEnterFrameLoader); // Run every frame
		}
		
		private function onEnterFrameLoader(event:Event):void
		{
			var bLoaded:uint = loaderInfo.bytesLoaded;
			var bTotal:uint = loaderInfo.bytesTotal;
			if (zastavka.alpha < 1) zastavka.alpha += 0.05;
			zastavka.progres.text = 'Loading ' + Math.round(bLoaded / bTotal * 100) + '%';
			if (bLoaded >= bTotal)
			{
				removeEventListener(Event.ENTER_FRAME, onEnterFrameLoader);
				zastavka.visible = false;
				this.nextFrame();
				mainMenu = new MainMenu(this);
			}
		}
	}
}
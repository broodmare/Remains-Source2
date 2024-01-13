package  
{
	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.events.Event;

    import flash.ui.ContextMenu;
    import flash.ui.ContextMenuItem;

	import fe.*;
	import fe.stubs.zastavka;
	
	public class MainFE extends flash.display.MovieClip
	{
		private var mainMenuMovieClip:MainMenu;
		
		public function MainFE() 
		{
			stage.scaleMode = "noScale";
			stage.align=StageAlign.TOP_LEFT;
			stage.color = 0;
			var myMenu:ContextMenu = new ContextMenu();
			myMenu.hideBuiltInItems();
			myMenu.builtInItems.quality=true;
			contextMenu = myMenu;
			myMenu.customItems.push(new ContextMenuItem("Привет!", false, true, false));
			stop();
			addEventListener(Event.ENTER_FRAME, onEnterFrameLoader);
		}
		
		private function onEnterFrameLoader(event:Event):void
		{
			var bLoaded:uint = loaderInfo.bytesLoaded;
			var bTotal:uint = loaderInfo.bytesTotal;
			if (zastavka.alpha<1) zastavka.alpha += 0.05;
			zastavka.progres.text = 'Loading ' + Math.round(bLoaded / bTotal * 100) + '%';
			if (bLoaded >= bTotal)
			{
				zastavka.visible = false;
				removeEventListener(Event.ENTER_FRAME, onEnterFrameLoader);
				nextFrame();
				mainMenuMovieClip = new MainMenu(this);
			}
		}
	}
}
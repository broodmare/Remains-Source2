package  {
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.events.Event;
//	import flash.events.MouseEvent;
//	import flash.ui.Keyboard;
    import flash.ui.ContextMenu;
    import flash.ui.ContextMenuItem;
    import flash.ui.ContextMenuBuiltInItems;
    import flash.events.ContextMenuEvent;
//	import flash.events.TimerEvent;
//	import flash.system.fscommand;
	
	import flash.display.LoaderInfo;
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.system.Security;


	import fe.*;

	//import fe.Editor;
	//import fe.AllData;
	
	public class MainFE extends flash.display.MovieClip{
		
		var mainMenu:MainMenu;
		
//**************************************************************************************		
/*		
		
// Pull the API path from the FlashVars
var paramObj:Object = LoaderInfo(root.loaderInfo).parameters;

// The API path. The "shadow" API will load if testing locally. 
var apiPath:String = paramObj.kongregate_api_path || 
  "http://cdn1.kongregate.com/flash/API_AS3_Local.swf";


// Kongregate API reference
var kongregate:*;

// This function is called when loading is complete
function loadComplete(event:Event):void
{
    // Save Kongregate API reference
    kongregate = event.target.content;

    // Connect to the back-end
    kongregate.services.connect();

    // You can now access the API via:
    // kongregate.services
    // kongregate.user
    // kongregate.scores
    // kongregate.stats
    // etc...
}
*/
//**************************************************************************************		

		public function MainFE() {
			//fscommand("trapallkeys","true");
			stage.scaleMode = "noScale";
			stage.align=StageAlign.TOP_LEFT;
			stage.color=0;
			var myMenu:ContextMenu=new ContextMenu();
			myMenu.hideBuiltInItems();
			myMenu.builtInItems.quality=true;
			contextMenu=myMenu;
			myMenu.customItems.push(new ContextMenuItem("Привет!",false,true,false));
			stop();
			addEventListener(Event.ENTER_FRAME, onEnterFrameLoader);

/*			
			// Allow the API access to this SWF
Security.allowDomain(apiPath);
Security.allowInsecureDomain(apiPath);

// Load the API
var request:URLRequest = new URLRequest(apiPath);
var loader:Loader = new Loader();
loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadComplete);
loader.load(request);
this.addChild(loader);
*/
		}
		
		function onEnterFrameLoader(event:Event)
		{
			var bLoaded:uint = loaderInfo.bytesLoaded;
			var bTotal:uint = loaderInfo.bytesTotal;
			if (zastavka.alpha<1) zastavka.alpha+=0.05;
			zastavka.progres.text = 'Loading '+Math.round(bLoaded / bTotal*100)+'%';
			if (bLoaded >= bTotal)
			{
				zastavka.visible=false;
				removeEventListener(Event.ENTER_FRAME, onEnterFrameLoader);
				nextFrame();
				mainMenu=new MainMenu(this);
			}
		}

	}
}

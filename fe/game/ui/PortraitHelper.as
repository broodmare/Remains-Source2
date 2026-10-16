package fe.game.ui {

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;

	public class PortraitHelper {

		private static const PORTRAIT_PATH:String = "data/core/Portraits/";
		private var pictureHolder:MovieClip;					// The movieclip object containing the shown image
		private var images:Object = {};							// Each portrait's image by name, null while it's still loading
		private var loadNames:Dictionary = new Dictionary();	// The portrait name each pending load is for

		public var currentPortrait:String;						// The name of the portrait being shown

		private function loadImage(imageName:String):void {
			var imageLoader:Loader = new Loader();

			images[imageName] = null;
			loadNames[imageLoader.contentLoaderInfo] = imageName;
			imageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onImageLoaded);
			imageLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onImageLoadError);
			imageLoader.load(new URLRequest(PORTRAIT_PATH + imageName + ".png"));
		}

		// A portrait that arrives after its line has passed is kept but not shown
		private function onImageLoaded(event:Event):void {
			var info:LoaderInfo = LoaderInfo(event.target);
			var imageName:String = finishLoad(info);
			var image:BitmapData = Bitmap(info.content).bitmapData;

			images[imageName] = image;
			if (imageName == currentPortrait) {
				pictureHolder.addChild(new Bitmap(image));
			}
		}

		private function onImageLoadError(event:IOErrorEvent):void {
			delete images[finishLoad(LoaderInfo(event.target))];
			trace("PortraitHelper.as/onImageLoadError() - Error loading image: " + event.text);
		}

		// Stops listening to a load and returns the portrait name it was for
		private function finishLoad(info:LoaderInfo):String {
			var imageName:String = loadNames[info];

			info.removeEventListener(Event.COMPLETE, onImageLoaded);
			info.removeEventListener(IOErrorEvent.IO_ERROR, onImageLoadError);
			delete loadNames[info];

			return imageName;
		}

		public function PortraitHelper(guiMC:MovieClip) {
			var dialogueBox:MovieClip = guiMC.getChildByName("dial") as MovieClip;
			pictureHolder = dialogueBox.portret;
		}

		public function displayPortrait(newPortrait:String):void {
			if (newPortrait == currentPortrait) { return; }

			clearPortrait();
			currentPortrait = newPortrait;

			if (!images.hasOwnProperty(newPortrait)) {
				loadImage(newPortrait);
			}
			else if (images[newPortrait] != null) {
				pictureHolder.addChild(new Bitmap(images[newPortrait]));
			}
		}

		public function clearPortrait():void {
			while (pictureHolder.numChildren > 0) {
				pictureHolder.removeChildAt(0);
			}
			currentPortrait = null;
		}
	}
}

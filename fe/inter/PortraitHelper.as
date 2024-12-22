package fe.inter {

    import flash.display.MovieClip;
    import flash.display.Loader; 
    import flash.net.URLRequest; 
    import flash.events.Event;
    import flash.events.IOErrorEvent;

	public class PortraitHelper {

        private static var pictureHolder:MovieClip;     // The movieclip object containing the loaded image
        public var currentPortrait:String;              // The name of the currently loaded portrait   

        // Constructor
        public function PortraitHelper(guiMC:MovieClip) {
            var dialogueBox:MovieClip = guiMC.getChildByName('dial') as MovieClip;
            pictureHolder = dialogueBox.portret;
        }
        
        public function displayPortrait(newPortrait:String):void  {
            if (currentPortrait != newPortrait) {
                trace('Loading new portrait: "' + newPortrait + '".');
                clearPortrait();
                currentPortrait = newPortrait;
                loadImage(newPortrait);
            }
            else {
                // Do nothing, we already have the correct portait loaded
                //trace('Ignoring request to render duplicate portrait.');
            }
        }

        private static function loadImage(imageName:String):void {
            var imageLoader:Loader = new Loader();
            imageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onImageLoaded);
            imageLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onImageLoadError);

            var imageURL:String = "Modules/core/Portraits/" + imageName + ".png";
            imageLoader.load(new URLRequest(imageURL));
        }

        private static function onImageLoaded(event:Event):void {
            event.target.removeEventListener(Event.COMPLETE, onImageLoaded);
            event.target.removeEventListener(IOErrorEvent.IO_ERROR, onImageLoadError);

            pictureHolder.addChild(event.target.loader.content);
        }

        private static function onImageLoadError(event:IOErrorEvent):void {
            event.target.removeEventListener(Event.COMPLETE, onImageLoaded);
            event.target.removeEventListener(IOErrorEvent.IO_ERROR, onImageLoadError);
            trace("Error loading image: " + event.text);
        }

        public function clearPortrait():void {
            while (pictureHolder.numChildren > 0) {
                pictureHolder.removeChildAt(0);
            }
            currentPortrait = null;
        }
    }
}
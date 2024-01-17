package fe.inter
{
    import flash.display.MovieClip;
    import flash.display.Loader; 
    import flash.net.URLRequest; 
    import flash.events.Event;
    import flash.events.IOErrorEvent;

	public class PortraitHelper
    {
        private static var dialogueBox:MovieClip;
        private static var pictureHolder:MovieClip;

        private static var currentPortrait:String;

        public function PortraitHelper(gui:MovieClip)
        {
            dialogueBox = gui.getChildByName('dial') as MovieClip;
            pictureHolder = dialogueBox.portret;
        }

        public function displayPortrait(imageName:String):void
        {
            if (imageName != currentPortrait) 
            {
                clearPortrait();
                loadImage(imageName);
            }
        }

        private function loadImage(imageName:String):void
        {
            var imageLoader:Loader = new Loader();
            imageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onImageLoaded);
            imageLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onImageLoadError);

            var imageURL:String = "Modules/core/Portraits/" + 'test' + ".png";
            imageLoader.load(new URLRequest(imageURL));
        }

        private function onImageLoaded(event:Event):void
        {
            event.target.removeEventListener(Event.COMPLETE, onImageLoaded);
            event.target.removeEventListener(IOErrorEvent.IO_ERROR, onImageLoadError);

            pictureHolder.addChild(event.target.loader.content);
        }

        private function onImageLoadError(event:IOErrorEvent):void
        {
            trace("Error loading image: " + event.text);
        }

        private function clearPortrait():void
        {
            while (pictureHolder.numChildren > 0)
            {
                pictureHolder.removeChildAt(0);
            }
        }
    }
}
package fe
{
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.net.URLLoader;
    import flash.net.URLRequest;

    public class JSONLoader
    {
        public static function importFile(fileTarget:String, callback:Function):void
        {
            var url:URLRequest      = new URLRequest(fileTarget);
            var loader:URLLoader    = new URLLoader();

            loader.addEventListener(Event.COMPLETE, function(event:Event):void {
                parseJSON(event, callback); // Pass the callback to the parseJSON function
            });
            loader.addEventListener(IOErrorEvent.IO_ERROR, errorDebug);

            loader.load(url);
        }
        
        private static function parseJSON(event:Event, callback:Function):void
        {
            var loader:URLLoader = URLLoader(event.target);
            loader.removeEventListener(Event.COMPLETE, parseJSON);
            loader.removeEventListener(IOErrorEvent.IO_ERROR, errorDebug);

            var jsonString:String = loader.data as String;
            var jsonObject = JSON.parse(jsonString);

            callback(jsonObject); // Call the callback function with the loaded JSON object
        }

        private static function errorDebug(event:IOErrorEvent):void
        {
            trace("ERROR (00:5A): Could not load settings! IO Error: " + event.text);
        }
    }
}
package fe
{
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.net.URLLoader;
    import flash.net.URLRequest;

    public class Settings
    {
        private static const settingsDirectory:String = 'Modules/core/';
        public static var settings:Object = {};

        // GAME SETTINGS
        public static var alwaysFogOfWar:Boolean;
        public static var fogRegenerates:Boolean;
        public static var runForeverOption:Boolean;

        public static function initializeSettings():void
        {
            var settingsFileURL:String = settingsDirectory + 'Settings.json'

            var url:URLRequest = new URLRequest(settingsFileURL);
            var loader:URLLoader = new URLLoader();

            loader.addEventListener(Event.COMPLETE, importSettings);
            loader.addEventListener(IOErrorEvent.IO_ERROR, errorDebug);
            loader.load(url);
        }
        
        private static function importSettings(event:Event):void
        {
            var loader:URLLoader = URLLoader(event.target);

            loader.removeEventListener(Event.COMPLETE, importSettings);
            loader.removeEventListener(IOErrorEvent.IO_ERROR, errorDebug);

            var jsonString:String = loader.data as String;
            settings = JSON.parse(jsonString);

            alwaysFogOfWar = settings.alwaysFogOfWar;
            fogRegenerates = settings.fogRegenerates;
            runForeverOption = settings.runForeverOption;
        }

        private static function errorDebug(event:IOErrorEvent):void
        {
            trace("ERROR: Could not load settings! IO Error: " + event.text);
        }
    }
}
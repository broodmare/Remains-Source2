package fe
{
    public class Settings
    {
        private static const settingsFileTarget:String = 'Modules/core/Settings.json';
        public static var settings:Object = {};

        // GAME SETTINGS
        public static var alwaysFogOfWar:Boolean;
        public static var fogRegenerates:Boolean;
        public static var burningForcesRun:Boolean;

        public static function initializeSettings():void
        {
            // Use the JSONLoader to import settings and handle them with a callback
            JSONLoader.importFile(settingsFileTarget, handleLoadedSettings);
        }
        
        private static function handleLoadedSettings(loadedSettings:Object):void
        {
            settings = loadedSettings;

            alwaysFogOfWar = settings.alwaysFogOfWar;
            fogRegenerates = settings.fogRegenerates;
            burningForcesRun = settings.burningForcesRun;
        }
    }
}
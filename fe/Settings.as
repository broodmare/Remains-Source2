package fe {

    public class Settings {

        private static const settingsDirectory:String = 'Modules/core/';
        public static var settings:Object = {};

        // CONSTANT GAME SETTINGS -- These probably won't change (but can!) during gameplay
        public static var alwaysFogOfWar:Boolean;
        public static var fogRegenerates:Boolean;
        public static var burningForcesRun:Boolean;

        // VARIABLE GAME SETTINGS -- These can and will change depending on user actions/saved settings

        public static function initializeSettings():void {
            
            // Load the settings file as a JSON object
            var path:String = settingsDirectory + 'Settings.json'
            var loader:TextLoader = new TextLoader();
            settings = loader.syncLoad(path);

            // Use the variables from the JSON object to initialize the settings
            alwaysFogOfWar = settings.alwaysFogOfWar;
            fogRegenerates = settings.fogRegenerates;
            burningForcesRun = settings.burningForcesRun;
        }
    }
}
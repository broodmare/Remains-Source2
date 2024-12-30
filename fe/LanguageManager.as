package fe {

	import flash.system.Capabilities;

	public class LanguageManager {

		private var langFolder:String;
		private var languagesFilePath:String;

		private var _languages:Array;			// Array of objects representing each langauge. Eg. [ {"id":"en", "name":"english", "file":"text_en.xml" }, ... ]
		private var _currentLanguage:String;	// Two letter language id, eg. 'en'
		private var _languageData:Object;		// The localization data for the current language

		public static var reference:LanguageManager;	// Publically accessable reference to this instance of the language manager

		// Constructor
		public function LanguageManager(configObj:Object) {
			
			reference = this;

			langFolder = "Modules/core/language/";
			languagesFilePath = "languages.json";

			// Step 1: Load the list of languages from the json file
			trace("LanguageManager.as/Constructor() - Initializing the langauge manager");
			var path:String = langFolder + languagesFilePath;
			var loader:TextLoader = new TextLoader();
			
			var langs:* = loader.syncLoad(path);
			_languages = langs as Array;

			// Step 2: Detect the default user language and previous user language if applicable
			_currentLanguage = Capabilities.language; // Try to detect default langauge for the user.

			if (configObj.data.language != null) {
			    _currentLanguage = configObj.data.language; // If user settings exist, overwrite the default language.
			}

			if (_currentLanguage == "") {
				_currentLanguage = "en"; // Safety check
			}

			// Step 3: Load the current language
			loadLanguage(_currentLanguage);
		}

		private function loadLanguage(id:String):void {

			trace("LanguageManager.as/loadLanguage() - Loading language: " + id);
			// Get the file name for the language
			var languageFile:String = null;
			for each (var lang:Object in _languages) {
				if (lang.id == id) {
					languageFile = lang.file;
					break;
				}
			}

			// Build the path to the file
			var path:String = langFolder + languageFile;
			trace("LanguageManager.as/loadLanguage() - Loading language file: " + path);

			// Load the file at that specified path
			var loader:TextLoader = new TextLoader();
			_languageData = loader.syncLoad(path);
		}

		// TODO: BROKE -- MOVE THIS SO SETTINGS CAN BE SAVED
        // Publically accessable method to change the language
		public function changeLanguage(id:String):void {
			trace("LanguageManager.as/changeLanguage() - Changing langauge to: " + id);
			_currentLanguage = id;
			loadLanguage(id);
			//world.saveConfig();
			//world.pip.updateLang();
		}

		public function get languages():Array {
			return _languages;
		}

		public function get languageCount():int {
			if (_languages == null) {
				return 0;
			}
			return _languages.length;
		}

		public function get currentLanguage():String {
			return _currentLanguage;
		}

		public function get data():Object {
			return _languageData;
		}
    }
}
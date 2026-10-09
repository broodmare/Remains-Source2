package fe {

	import flash.system.Capabilities;

	public class LanguageManager {

		private static const DEFAULT_LANGUAGE:String = "en";	// Fallback for strings a translation doesn't have

		private var langFolder:String;
		private var languagesFilePath:String;

		private var _languages:Array;			// Array of objects representing each langauge. Eg. [ {"id":"en", "name":"english", "file":"text_en.json" }, ... ]
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
			var data:Object = loadLanguageFile(id);

			// Translations can be missing strings (eg. ones added to English after they were made), so fill the gaps with English
			if (id != DEFAULT_LANGUAGE) {
				data = mergeLanguageData(loadLanguageFile(DEFAULT_LANGUAGE), data);
			}

			_languageData = data;
		}

		// Loads the localization files for a language, or returns null if the language isn't in languages.json
		// The dialogues and barks from the language's folder are added as the 'dialogue' (indexed by key) and 'barks' categories
		private function loadLanguageFile(id:String):Object {
			// Get the entry for the language
			var language:Object = null;
			for each (var lang:Object in _languages) {
				if (lang.id == id) {
					language = lang;
					break;
				}
			}

			if (language == null) {
				trace("LanguageManager.as/loadLanguageFile() - No language file found for: " + id);
				return null;
			}

			// Build the path to the file
			var path:String = langFolder + language.file;
			trace("LanguageManager.as/loadLanguageFile() - Loading language file: " + path);

			// Load the file at that specified path
			var loader:TextLoader = new TextLoader();
			var data:Object = loader.syncLoad(path);
			if (data == null || !language.folder) {
				return data;
			}

			var dialogues:Object = loader.syncLoad(langFolder + language.folder + "/dialogues.json");
			if (dialogues != null) {
				var dialogueIndex:Object = {};
				for each (var dialogue:Object in dialogues.dialogue) {
					dialogueIndex[dialogue.Key] = dialogue;
				}
				data.dialogue = dialogueIndex;
			}

			var barks:Object = loader.syncLoad(langFolder + language.folder + "/barks.json");
			if (barks != null) {
				data.barks = barks.barks;
			}

			return data;
		}

		// Copies every entry in 'overlay' onto 'base' one field at a time, so anything 'overlay' is missing keeps the 'base' value
		// Arrays (eg. advice, a bark list or a dialogue's lines) are replaced as a whole
		private static function mergeLanguageData(base:Object, overlay:Object):Object {
			if (base == null) {
				return overlay;
			}
			if (overlay == null) {
				return base;
			}

			for (var category:String in overlay) {
				var overlayCategory:Object = overlay[category];
				var baseCategory:Object = base[category];

				if (baseCategory == null || overlayCategory is Array) {
					base[category] = overlayCategory;
					continue;
				}

				for (var id:String in overlayCategory) {
					if (baseCategory[id] == null || overlayCategory[id] is Array) {
						baseCategory[id] = overlayCategory[id];
						continue;
					}

					for (var field:String in overlayCategory[id]) {
						baseCategory[id][field] = overlayCategory[id][field];
					}
				}
			}

			return base;
		}

        // Publically accessable method to change the language
		// The caller is responsible for saving the config and refreshing the UI (see MainMenu.funLang)
		public function changeLanguage(id:String):void {
			trace("LanguageManager.as/changeLanguage() - Changing langauge to: " + id);
			_currentLanguage = id;
			loadLanguage(id);
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

		// Check if a localized string exists without logging an error (formerly Res.istxt)
		public function hasText(category:String, id:String):Boolean {
			if (_languageData == null || !_languageData.hasOwnProperty(category)) {
				return false;
			}
			
			var entry:Object = _languageData[category][id];
			return entry != null && entry.hasOwnProperty("string") && entry.string;
		}
		
		// Helper function that gets the localized string from the LanguageManager using the passed category and id
		// This still looks/works about the same as the old Res.txt function, until I can flatten the localization JSON using completely unique IDs
		// Once the JSON isn't nested, get rid of this helper function and call the IDs directly
		public function localText(category:String, id:String):String {
			var s:String = "";

			// Check if _languageData exists and has the specified category
			if (_languageData && _languageData.hasOwnProperty(category)) {
				var categoryData:Object = _languageData[category];

				// Check if the category contains the specified ID
				if (categoryData.hasOwnProperty(id)) {
					var entry:Object = categoryData[id];

					// Check if the entry has a 'string' property
					if (entry && entry.hasOwnProperty("string")) {
						s = entry.string;
					}
				}
			}

			// Validate the retrieved string
			if (s == null || s.length == 0) {
				trace("Error: Couldn't find localized string: (" + category + ": " + id + ")");
				s = id; // Fallback to the internal ID if string is missing
			}

			return s;
		}
		
		// Ditto, just grabs the description instead of the string
		public function localDesc(category:String, id:String):String {
			var s:String = "";

			// Check if _languageData exists and has the specified category
			if (_languageData && _languageData.hasOwnProperty(category)) {
				var categoryData:Object = _languageData[category];

				// Check if the category contains the specified ID
				if (categoryData.hasOwnProperty(id)) {
					var entry:Object = categoryData[id];

					// Check if the entry has a 'description' property
					if (entry && entry.hasOwnProperty("description")) {
						s = entry.description;
					}
				}
			}

			// Validate the retrieved description
			if (s == null || s.length == 0) {
				trace("Error: Couldn't find localized description: (" + category + ": " + id + ")");
				s = "Missing description: " + id; // Fallback message if description is missing
			}

			return s;
		}
    }
}
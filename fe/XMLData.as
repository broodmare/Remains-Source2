package fe 
{
	import flash.utils.Dictionary;
	import flash.events.Event;

	public class XMLData 
	{
        private static const moduleDirectory:String = 'Modules/';
        public static var moduleDictionary:Dictionary;
        public static var fileCount:int;
        public static var filesLoaded:int;

        public static function initializeModules():void
        {
            var moduleListURL:String = moduleDirectory + 'Modules.xml'
            var loader:XMLLoader = new XMLLoader();
			
            loader.addEventListener(XMLLoader.XML_LOADED, getAllModuleNames);
            loader.load(moduleListURL);
		}

		private static function getAllModuleNames(event:Event):void
		{
			var currentLoader:Object = event.currentTarget;
            currentLoader.removeEventListener(XMLLoader.XML_LOADED, getAllModuleNames);

            moduleDictionary = new Dictionary();

			var moduleList:XMLList = currentLoader.xmlData.descendants();
            for each (var module:XML in moduleList)                             // Create a list of modules
            {
                var moduleName:String = module.attribute('moduleName')
                trace('Module: "' + moduleName + '" found.');
                moduleDictionary[moduleName] = new Dictionary();
                loadModuleManifest(moduleName);
            }
        }

        private static function loadModuleManifest(moduleName:String):void  // Manifest lists all directories and files
        {
            var moduleManifestURL:String = moduleDirectory + moduleName + '/Manifest.xml';
            var loader:XMLLoader = new XMLLoader();

            trace('Loading manifest for module: "' + moduleName + '" from: "' + moduleManifestURL + '".');
            loader.addEventListener(XMLLoader.XML_LOADED, loadAllModuleFiles);
            loader.load(moduleManifestURL);
        }

        private static function loadAllModuleFiles(event:Event):void
        {
            var currentLoader:Object = event.currentTarget;
            currentLoader.removeEventListener(XMLLoader.XML_LOADED, loadAllModuleFiles);

            var moduleManifest:XML = currentLoader.xmlData;
            var moduleName:String = moduleManifest.@moduleName;

            for each (var directory:XML in moduleManifest.directory)    // Create each directory listed in the manifest as a dictionary.
            {
                var directoryName:String = directory.@directoryName;
                
                trace('Creating directory: "' + directoryName + '" for module: "' + moduleName + '".');
                moduleDictionary[moduleName][directoryName] = new Dictionary();

                for each (var file:XML in directory.file)
                {
                    fileCount++;

                    var fileName:String = file.@fileName;
                    var filePath:String = moduleDirectory + moduleName + '/' + directoryName + '/' + fileName + '.xml';
                    var fileLoader:XMLLoader = new XMLLoader();

                    trace('Attempting to load files from directory: "' + directoryName + '".');
                    fileLoader.addEventListener(XMLLoader.XML_LOADED, createFileLoadHandler(moduleName, directoryName, fileName));
                    fileLoader.load(filePath);
                }
            }
        }

        private static function createFileLoadHandler(moduleName:String, directoryName:String, fileName:String):Function
        {
            return function(event:Event):void
            {
                loadModuleFile(event, moduleName, directoryName, fileName);
            };
        }

        private static function loadModuleFile(event:Event, moduleName:String, directoryName:String, fileName:String):void
        {
            var loader:XMLLoader = XMLLoader(event.currentTarget);
            loader.removeEventListener(XMLLoader.XML_LOADED, arguments.callee);

            filesLoaded++;
            var fileData:XML = loader.xmlData;
            moduleDictionary[moduleName][directoryName][fileName] = fileData;
            trace("Loaded file: " + moduleName + "/" + directoryName + "/" + fileName);
        }
	}
}
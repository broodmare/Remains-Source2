package fe {
    
    import flash.utils.Dictionary;
    import flash.events.Event;

    public class XMLData {

        private static const MODULE_DIRECTORY:String = 'Modules/';
        public static var moduleDictionary:Object; // Changed from Dictionary to Object
        public static var fileCount:int;
        public static var filesLoaded:int;
        private static var loaderMetadata:Dictionary = new Dictionary(); // For mapping loaders to metadata
        private static const DEBUG:Boolean = false; // Toggle debug tracing

        public static function initializeModules():void {
            moduleDictionary = {}; // Initialize the module dictionary
            fileCount = 0;
            filesLoaded = 0;

            var moduleListURL:String = MODULE_DIRECTORY + 'Modules.xml';
            var loader:XMLLoader = new XMLLoader();
            
            loader.addEventListener(XMLLoader.XML_LOADED, getAllModuleNames);
            loader.load(moduleListURL);
        }

        private static function getAllModuleNames(event:Event):void {
            var currentLoader:XMLLoader = XMLLoader(event.currentTarget);
            currentLoader.removeEventListener(XMLLoader.XML_LOADED, getAllModuleNames);

            var moduleList:XMLList = currentLoader.xmlData.descendants("module");
            for each (var module:XML in moduleList) { // Specify 'module' descendants
                var moduleName:String = module.@moduleName;
                if (DEBUG) trace('Module: "' + moduleName + '" found.');
                moduleDictionary[moduleName] = {};
                loadModuleManifest(moduleName);
            }
        }

        private static function loadModuleManifest(moduleName:String):void { // Manifest lists all directories and files
            var moduleManifestURL:String = MODULE_DIRECTORY + moduleName + '/Manifest.xml';
            var loader:XMLLoader = new XMLLoader();

            if (DEBUG) trace('Loading manifest for module: "' + moduleName + '" from: "' + moduleManifestURL + '".');
            loader.addEventListener(XMLLoader.XML_LOADED, loadAllModuleFiles);
            loader.load(moduleManifestURL);
        }

        private static function loadAllModuleFiles(event:Event):void {
            var currentLoader:XMLLoader = XMLLoader(event.currentTarget);
            currentLoader.removeEventListener(XMLLoader.XML_LOADED, loadAllModuleFiles);

            var moduleManifest:XML = currentLoader.xmlData;
            var moduleName:String = moduleManifest.@moduleName;

            for each (var directory:XML in moduleManifest.directory) { // Iterate through directories
                var directoryName:String = directory.@directoryName;
                
                if (DEBUG) trace('Creating directory: "' + directoryName + '" for module: "' + moduleName + '".');
                moduleDictionary[moduleName][directoryName] = {};

                for each (var file:XML in directory.file) {
                    fileCount++;

                    var fileName:String = file.@fileName;
                    var filePath:String = MODULE_DIRECTORY + moduleName + '/' + directoryName + '/' + fileName + '.xml';
                    var fileLoader:XMLLoader = new XMLLoader();

                    if (DEBUG) trace('Attempting to load file: "' + filePath + '".');
                    
                    // Store metadata for the loader
                    loaderMetadata[fileLoader] = { 
                        moduleName: moduleName, 
                        directoryName: directoryName, 
                        fileName: fileName 
                    };

                    // Use a single handler for all file loads
                    fileLoader.addEventListener(XMLLoader.XML_LOADED, handleFileLoaded);
                    fileLoader.load(filePath);
                }
            }
        }

        private static function handleFileLoaded(event:Event):void {
            var loader:XMLLoader = XMLLoader(event.currentTarget);
            loader.removeEventListener(XMLLoader.XML_LOADED, handleFileLoaded);

            var metadata:Object = loaderMetadata[loader];
            delete loaderMetadata[loader]; // Clean up the metadata mapping

            if (metadata) {
                var moduleName:String = metadata.moduleName;
                var directoryName:String = metadata.directoryName;
                var fileName:String = metadata.fileName;

                filesLoaded++;
                var fileData:XML = loader.xmlData;
                moduleDictionary[moduleName][directoryName][fileName] = fileData;
                
                if (DEBUG) trace("Loaded file: " + moduleName + "/" + directoryName + "/" + fileName);
            }
            else {
                if (DEBUG) trace("No metadata found for loader: " + loader);
            }
        }
    }
}
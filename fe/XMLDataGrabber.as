package fe  {

    import flash.utils.Dictionary;

    public class XMLDataGrabber {
        
        private static const data:Object = XMLData.moduleDictionary;
        private static var cache:Dictionary = new Dictionary();

        public static function getNodesWithName(module:String, directory:String, fileName:String, nodeName:String):XMLList {
            const file:XML = getFileFromModuleDictionary(module, directory, fileName);
            return file.child(nodeName);
        }

        public static function getNodeWithAttributeThatMatches(module:String, directory:String, fileName:String, attributeName:String, attributeKey:String):XML {
            const file:XML = getFileFromModuleDictionary(module, directory, fileName);
            const nodeList:XMLList = file..*.(attribute(attributeName) == attributeKey);
            
            if (nodeList.length()) {
                return nodeList[0];
            }
            else {
                return null;
            }
        }

        public static function getNodeFromAllWithAttributeThatMatches(module:String, directory:String, fileName:String, attributeName:String, attributeKey:String):XML {
            const file:XML = getFileFromModuleDictionary(module, directory, fileName);
            const nodeList:XMLList = file.descendants().(attribute(attributeName) == attributeKey);
            return nodeList.length() > 0 ? nodeList[0] : null;
        }

        public static function getNodeByNameWithAttributeThatMatches(module:String, directory:String, fileName:String, nodeName:String, attributeName:String, attributeKey:String):XML {
            const file:XML = getFileFromModuleDictionary(module, directory, fileName);
            const matchingNodes:XMLList = file.descendants(nodeName).(attribute(attributeName) == attributeKey);
            
            if (matchingNodes.length()) {
                return matchingNodes[0];
            }
            else {
                trace('ERROR: Node with name: "' + nodeName + '" and attribute: "' + attributeName + '" that matches: "' + attributeKey + '" returned no results!');
                return null;
            }
        }

        // Module dictionary handler. Handles navigating the dictionary and throwing errors for anything not found.
        private static function getFileFromModuleDictionary(module:String, directory:String, fileName:String):XML {
            const cacheKey:String = module + "/" + directory + "/" + fileName;
            if (cache[cacheKey] != undefined) {
                return cache[cacheKey];
            }

            if (data == null) {
                trace('ERROR: Cannot find XMLData dictionary!');
                return new XML();
            }
            if (data[module] == null) {
                trace('ERROR: Module: "' + module + '" not found!');
                return new XML();
            }
            if (data[module][directory] == null) {
                trace('ERROR: Directory "' + directory + '" not found in module: "' + module + '"!');
                return new XML();
            }
            if (data[module][directory][fileName] == null) {
                trace('ERROR: File "' + fileName + '" not found in directory: "' + directory + '"!');
                return new XML();
            }

            const file:XML = data[module][directory][fileName];
            cache[cacheKey] = file;
            return file;
        }
    }
}

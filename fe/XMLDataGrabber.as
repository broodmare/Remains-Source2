package fe 
{
	import flash.utils.Dictionary;

    public class XMLDataGrabber
    {
        private static var data:Dictionary = XMLData.moduleDictionary;

        public static function getNodesWithName(module:String, directory:String, fileName:String, nodeName:String):XMLList
        {
            var file:XML = getFileFromModuleDictionary(module, directory, fileName);
            var nodeList:XMLList = file.children();
            var filteredNodes:XMLList = new XMLList();

            for each (var node:XML in nodeList)
            {
                if (node.name().localName == nodeName) filteredNodes += node;
            }
            return filteredNodes;
        }

        public static function getNodeWithAttributeThatMatches(module:String, directory:String, fileName:String, attributeName:String, attributeKey:String):XML
        {
            var file:XML = getFileFromModuleDictionary(module, directory, fileName);
            var nodeList:XMLList = file.children().(attribute(attributeName) == attributeKey);
            return nodeList[0];
        }

        //  Search !!ALL!! child nodes in the file that have a matching attribute, eg. '<a id= />' AND a matching key '<a id=attributeKey />'.
        public static function getNodeFromAllWithAttributeThatMatches(module:String, directory:String, fileName:String, attributeName:String, attributeKey:String):XML
        {
            var file:XML = getFileFromModuleDictionary(module, directory, fileName);
            var nodeList:XMLList = file.descendants().(attribute(attributeName) == attributeKey);
            return nodeList[0];
        }

        public static function getNodeByNameWithAttributeThatMatches(module:String, directory:String, fileName:String, nodeName:String, attributeName:String, attributeKey:String):XML
        {
            var file:XML = getFileFromModuleDictionary(module, directory, fileName);
            var nodeList:XMLList = file.descendants(nodeName);
            var matchingNodes:XMLList = nodeList.(attribute(attributeName) == attributeKey);
            var node:XML = new XML();

            if (matchingNodes.length()) node = matchingNodes[0]
            else trace('ERROR: Node with name: "' + nodeName + '" and attribute: "' + attributeName + '" that matches: "' + attributeKey + '" returned no results!');

            return node;
        }

        // Module dictionary handler. Handles navigating the dictionary and throwing errors for anything not found.
        private static function getFileFromModuleDictionary(module:String, directory:String, fileName:String):XML
        {
            trace('Accessing file: "' + module + '/' + directory + '/' + fileName + '".');
            var file:XML = new XML();

            if (data == null) trace('ERROR: Cannot find XMLData dictionary!');
            else if (data[module] == null) trace('ERROR: Module: "' + module + '" not found!');
            else if (data[module][directory] == null) trace('ERROR: Directory "' + directory + '" not found in module: "' + module + '"!');
            else if (data[module][directory][fileName] == null) trace('ERROR: File "' + fileName + '" not found in directory: "' + directory + '"!');
            else file = data[module][directory][fileName];
            return file;
        }
    }
}
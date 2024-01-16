package fe 
{
	import flash.utils.Dictionary;

    public class XMLDataGrabber
    {
        private static var data:Dictionary = XMLData.moduleDictionary;

        //  For returning data from top level nodes
        public static function getAllChildNodes(module:String, directory:String, fileName:String):XMLList
        {
            var file:XML = getFileFromModuleDictionary(module, directory, fileName);
            return file.children();
        }

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

        public static function getNodesWithAttribute(module:String, directory:String, fileName:String, attributeName:String):XMLList
        {
            var file:XML = getFileFromModuleDictionary(module, directory, fileName);
            return file.children().attribute(attributeName);
        }

        public static function getNodeWithAttributeThatMatches(module:String, directory:String, fileName:String, attributeName:String, attributeKey:String):XML
        {
            var file:XML = getFileFromModuleDictionary(module, directory, fileName);
            var nodeList:XMLList = file.children().(attribute(attributeName) == attributeKey);
            return nodeList[0];
        }


        // For return data from a single node
        public static function getNodesFromParentWithName(module:String, directory:String, fileName:String, parent:String, childName:String):XMLList
        {
            var file:XML = getFileFromModuleDictionary(module, directory, fileName);
            return file.parent.childName;
        }

        public static function getNodesFromParentWithAttribute(module:String, directory:String, fileName:String, parent:String, attributeName:String, attributeKey:String):XMLList
        {
            var file:XML = getFileFromModuleDictionary(module, directory, fileName);
            return file.parent.attribute(attributeName);
        }

        public static function getNodeFromParentWithAttributeThatMatches(module:String, directory:String, fileName:String, parent:String, attributeName:String, attributeKey:String):XML
        {
            var file:XML = getFileFromModuleDictionary(module, directory, fileName);
            var nodeList:XMLList = file.parent.(attribute(attributeName) == attributeKey);
            return nodeList[0];
        }


        //  Return !!ALL!! nodes in the file with a spefied name.
        //  eg. nodeName 'a' would return all 3 <a> nodes from '<parent> <a/> <a/> <b/> </parent> <parent> <a/> <b/> </parent>'.
        public static function getNodesFromAllWithName(module:String, directory:String, fileName:String, nodeName:String):XMLList
        {
            var file:XML = getFileFromModuleDictionary(module, directory, fileName);
            return file.descendants(nodeName);
        }

        //  Search !!ALL!! child nodes in the file that have a matching attribute, eg. '<a id= />'.
        public static function getNodesFromAllWithAttribute(module:String, directory:String, fileName:String, attributeName:String):XMLList
        {
            var file:XML = getFileFromModuleDictionary(module, directory, fileName);
            return file.descendants().attribute(attributeName);
        }
        
        //  Search !!ALL!! child nodes in the file that have a matching attribute, eg. '<a id= />' AND a matching key '<a id=attributeKey />'.
        public static function getNodeFromAllWithAttributeThatMatches(module:String, directory:String, fileName:String, attributeName:String, attributeKey:String):XML
        {
            var file:XML = getFileFromModuleDictionary(module, directory, fileName);
            var nodeList:XMLList = file.descendants().(attribute(attributeName) == attributeKey);
            return nodeList[0];
        }

        
        // Oddly specific functions.
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
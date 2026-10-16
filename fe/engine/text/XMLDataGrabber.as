package fe.engine.text  {

	import flash.utils.Dictionary;

	public class XMLDataGrabber {
		
		private static const data:Object = XMLData.moduleDictionary;
		private static var cache:Dictionary = new Dictionary();
		private static var indexes:Object = {};		// Per file and attribute, each top-level entry by its attribute value

		public static function getNodesWithName(module:String, directory:String, fileName:String, nodeName:String):XMLList {
			const file:XML = getFileFromModuleDictionary(module, directory, fileName);
			return file.child(nodeName);
		}

		// Only top-level entries match, so an id repeated inside an earlier entry never shadows the entry itself
		public static function getNodeWithAttributeThatMatches(module:String, directory:String, fileName:String, attributeName:String, attributeKey:String):XML {
			const indexKey:String = module + "/" + directory + "/" + fileName + "@" + attributeName;
			var index:Object = indexes[indexKey];

			if (index == null) {
				index = buildIndex(getFileFromModuleDictionary(module, directory, fileName), attributeName);
				indexes[indexKey] = index;
			}

			return index.hasOwnProperty(attributeKey) ? index[attributeKey] : null;
		}

		// The first descendant named nodeName whose attribute matches, or null when there is none
		public static function getNodeByNameWithAttributeThatMatches(module:String, directory:String, fileName:String, nodeName:String, attributeName:String, attributeKey:String):XML {
			const file:XML = getFileFromModuleDictionary(module, directory, fileName);
			const matchingNodes:XMLList = file.descendants(nodeName).(attribute(attributeName) == attributeKey);
			
			return matchingNodes.length() ? matchingNodes[0] : null;
		}

		// The first top-level entry wins when two share a value
		private static function buildIndex(file:XML, attributeName:String):Object {
			var index:Object = {};
			var node:XML;
			var key:String;

			for each (node in file.children()) {
				if (node.attribute(attributeName).length() == 0) {
					continue;
				}

				key = node.attribute(attributeName);
				if (!index.hasOwnProperty(key)) {
					index[key] = node;
				}
			}

			return index;
		}

		// Module dictionary handler. Handles navigating the dictionary and throwing errors for anything not found.
		private static function getFileFromModuleDictionary(module:String, directory:String, fileName:String):XML {
			const cacheKey:String = module + "/" + directory + "/" + fileName;
			if (cache[cacheKey] != undefined) {
				return cache[cacheKey];
			}

			if (data == null) {
				trace('XMLDataGrabber.as/getFileFromModuleDictionary() - ERROR: Cannot find XMLData dictionary!');
				return new XML();
			}
			if (data[module] == null) {
				trace('XMLDataGrabber.as/getFileFromModuleDictionary() - ERROR: Module: "' + module + '" not found!');
				return new XML();
			}
			if (data[module][directory] == null) {
				trace('XMLDataGrabber.as/getFileFromModuleDictionary() - ERROR: Directory "' + directory + '" not found in module: "' + module + '"!');
				return new XML();
			}
			if (data[module][directory][fileName] == null) {
				trace('XMLDataGrabber.as/getFileFromModuleDictionary() - ERROR: File "' + fileName + '" not found in directory: "' + directory + '"!');
				return new XML();
			}

			const file:XML = data[module][directory][fileName];
			cache[cacheKey] = file;
			return file;
		}
	}
}
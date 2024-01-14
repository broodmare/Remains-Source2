package fe 
{
	import flash.utils.Dictionary;
	import flash.events.Event;

	public class AllData 
	{
		private static var allData:Dictionary;
		private static var fileLocation:String; 
		private static var fileNames:Array; 
		private static var allDataEntryCount:int;
		private static var allDataEntriesLoaded:int;

		public static var allFilesLoaded:Boolean = false;

		public function AllData() 
		{

		}
		
		public static function initializeGameData():void
		{
			allData = new Dictionary();
			fileLocation = 'Data/xml/AllData/';
			fileNames = [
            	'armors', 'backs', 'effs', 'items', 'mats', 'objs',
				'params', 'parts', 'perks', 'skills', 'units', 'weapons'
        	];
			allDataEntryCount = 0;
			allDataEntriesLoaded = 0;


			for each (var filename:String in fileNames)
			{
				allDataEntryCount++;

				var fileURL:String = fileLocation + filename + ".xml";
				var loader:XMLLoader = new XMLLoader();
				
				loader.addEventListener(XMLLoader.XML_LOADED, copyDataToDictionary);
				loader.load(fileURL);
			}
		}

		private static function copyDataToDictionary(event:Event):void
		{
			var currentLoader:Object = event.currentTarget;
            currentLoader.removeEventListener(XMLLoader.XML_LOADED, copyDataToDictionary);
			allDataEntriesLoaded++;

            var currentXML:XML = currentLoader.xmlData
            var currentKey:String = currentXML.name().localName;   // Get the name of the root node in the XML to use as a key in the XmlBook Dictionary, Eg. <armors>
		
			allData[currentKey] = currentXML;
			checkIfAllLoaded();
		}

		private static function checkIfAllLoaded():void
		{
			var totalDictionaryKeys:int = countDictionaryKeys(allData);
            if (allDataEntriesLoaded >= allDataEntryCount) 
			{
				trace('AllData: ALL XML FILES LOADED');
				allFilesLoaded = true;
			}

			function countDictionaryKeys(dictionary:Dictionary):int 
			{
				var dictionaryKeyCount:int = 0;
				for (var key:* in dictionary) 
				{
					dictionaryKeyCount++;
				}
				return dictionaryKeyCount;
			}
		}

		public static function fetchNodeList(key:String, nodeName:String):XMLList
		{
			return allData[key].descendants(nodeName);
		}

		public static function fetchNodesWithMatchingIDs(key:String, nodeID:String):XMLList
		{
			return allData[key].descendants().(attribute('id') == nodeID);
		}

		public static function fetchNodeWithChildID(key:String, nodeID:String):XML
		{
			var nodeList:XMLList = allData[key].descendants().(attribute('id') == nodeID);
			return nodeList[0];
		}

	}
}
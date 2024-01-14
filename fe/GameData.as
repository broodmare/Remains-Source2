package fe
{
	import flash.utils.Dictionary;
	import flash.events.Event;

	public class GameData
	{
		private static var gameData:Dictionary;
		private static var fileLocation:String; 
		private static var fileNames:Array; 
		private static var gameDataEntryCount:int;
		private static var gameDataEntriesLoaded:int;

		public static var allFilesLoaded:Boolean = false;
		
		public function GameData()
		{

		}

		public static function initializeGameData():void
		{
			gameData = new Dictionary();
			fileLocation = 'Data/xml/GameData/';
			fileNames = [
            	"Land1s", "Lands", "Npcs", "Quests", "Scripts", "Vendors"
        	];
			gameDataEntryCount = 0;
			gameDataEntriesLoaded = 0;


			for each (var filename:String in fileNames)
			{
				gameDataEntryCount++;

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
			gameDataEntriesLoaded++;

            var currentXML:XML = currentLoader.xmlData
            var currentKey:String = currentXML.name().localName;   // Get the name of the root node in the XML to use as a key in the XmlBook Dictionary, Eg. <Vendors>
		
			gameData[currentKey] = currentXML;	
			checkIfAllLoaded();
		}

		private static function checkIfAllLoaded():void
		{
			var totalDictionaryKeys:int = countDictionaryKeys(gameData);
            if (gameDataEntriesLoaded >= gameDataEntryCount) 
			{
				trace('GameData: ALL XML FILES LOADED');
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
			return gameData[key].descendants(nodeName);
		}

		public static function fetchNodesWithMatchingIDs(key:String, nodeID:String):XMLList
		{
			return gameData[key].descendants().(attribute('id') == nodeID);
		}

		public static function fetchNodeWithChildID(key:String, nodeID:String):XML
		{
			var nodeList:XMLList = gameData[key].descendants().(attribute('id') == nodeID);
			return nodeList[0];
		}
		
		public static function findProbById(nprob:String):XML
		{
			for each (var land:XML in gameData["Lands"])
			{
				var prob:XMLList = land.prob.(@id == nprob);
			}
			return prob[0];
		}
	}
}
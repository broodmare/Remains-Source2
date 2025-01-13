package fe {

	public class ItemManager {
		
		public static var reference:ItemManager; // Public reference to this instance of an item manager

		private static const itemsPath:String = "Modules/core/AllData/items.json";
		private static const schematicsPath:String = "Modules/core/AllData/schematics.json";

		private var _items:Object		= {};	// A dictionary of items loaded from JSON
		private var _schematics:Object	= {};	// A dictionary of schematics loaded from JSON
		
		public function ItemManager() {
			trace("ItemManager.as/Constructor() - Initializing ItemManager");
			reference = this;

			// Declaring these here so I can re-use it for each item type
			var loader:TextLoader = new TextLoader();
			var path:String; 
			var itemsObject:Object = {};	

			var loadedItems:int = 0;
			// Load all items into memory
			itemsObject = loader.syncLoad(itemsPath);
			for each (var item:Object in itemsObject) {
				_items[item.id] = item;
				loadedItems++;
			}

			var loadedSchematics:int = 0;
			// Load all schematics into memory
			itemsObject = loader.syncLoad(schematicsPath);
			for each (var schematic:Object in itemsObject) {
				_schematics[schematic.id] = schematic;
				loadedSchematics++;
			}

			trace("ItemManager.as/Constructor() - Loaded " + loadedItems + " items, and " + loadedSchematics + " schematics");

		}

		public function get items():Object {
			return _items;
		}

		public function getItem(id:String):Object {
			// Crash for debugging if passed an object 
			if (id == "[object Object]") {
				var obj:Object = null;
				trace(obj.someProperty); // Crashes with a null reference error
			}
			
			if (_items[id]) {
				//trace("ItemManager.as/getItem() - Getting item: " + id);
				return _items[id];
			}
			else {
				trace("ItemManager.as/getItem() - Error: Couldn't find item: " + id);
				return {}; // Return an empty object
			}
		}

		public function getSchematic(id:String):Object {
			// Crash for debugging if passed an object 
			if (id == "[object Object]") {
				var obj:Object = null;
				trace(obj.someProperty); // Crashes with a null reference error
			}
			
			if (_schematics[id]) {
				//trace("ItemManager.as/getSchematic() - Getting schematic: " + id);
				return _schematics[id];
			}
			else {
				trace("ItemManager.as/getSchematic() - Error: Couldn't find schematic: " + id);
				return {}; // Return an empty object
			}
		}
	}
}
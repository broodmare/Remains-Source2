package fe {

	public class ItemManager {
		
		private static const directory:String = "Modules/core/AllData/";
		private static const weaponsFileName:String = "weapons.json";
		private static const armorsFileName:String = "armors.json";
		private static const itemsFileName:String = "items.json";
		private static const schematicsFileName:String = "schematics.json";

		private var _weapons:Object		= {};	// A dictionary of weapons loaded from JSON
		private var _armors:Object		= {};	// A dictionary of armors loaded from JSON
		private var _items:Object		= {};	// A dictionary of items loaded from JSON
		private var _schematics:Object	= {};	// A dictionary of schematics loaded from JSON

		public function ItemManager() {
			trace("ItemManager.as/Constructor() - Initializing ItemManager");

			// Declaring these here so I can re-use it for each item type
			var loader:TextLoader = new TextLoader();
			var path:String; 
			var itemsObject:Object = {};	
			
			// Load all weapons into memory
			path = directory + weaponsFileName;
			trace("ItemManager.as/Constructor() - Loading weapon json file from " + path);
			itemsObject = loader.syncLoad(path);
			for each (var weapon:Object in itemsObject) {
				_weapons[weapon.id] = weapon;
			}

			// Load all armors into memory
			path = directory + armorsFileName;
			trace("ItemManager.as/Constructor() - Loading armor json file from " + path);
			itemsObject = loader.syncLoad(path);
			for each (var armor:Object in itemsObject) {
				_armors[armor.id] = armor;
			}

			// Load all items into memory
			path = directory + itemsFileName;
			trace("ItemManager.as/Constructor() - Loading item json file from " + path);
			itemsObject = loader.syncLoad(path);
			for each (var item:Object in itemsObject) {
				_items[item.id] = item;
			}

			// Load all schematics into memory
			path = directory + schematicsFileName;
			trace("ItemManager.as/Constructor() - Loading schematics json file from " + path);
			itemsObject = loader.syncLoad(path);
			for each (var schematic:Object in itemsObject) {
				_schematics[schematic.id] = schematic;
			}
		}

		public function getWeapon(id:String):Object {
			if (_weapons[id]) {
				return _weapons[id];
			}
			else {
				trace("ItemManager.as/getWeapon() - Error: Couldn't find weapon: " + id);
				return {}; // Return an empty object
			}
		}

		public function getArmor(id:String):Object {
			if (_armors[id]) {
				return _armors[id];
			}
			else {
				trace("ItemManager.as/getArmor() - Error: Couldn't find armor: " + id);
				return {}; // Return an empty object
			}
		}

		public function getItem(id:String):Object {
			if (_items[id]) {
				return _items[id];
			}
			else {
				trace("ItemManager.as/getItem() - Error: Couldn't find item: " + id);
				return {}; // Return an empty object
			}
		}

		public function getSchematic(id:String):Object {
			if (_schematics[id]) {
				return _schematics[id];
			}
			else {
				trace("ItemManager.as/getSchematic() - Error: Couldn't find schematic: " + id);
				return {}; // Return an empty object
			}
		}
	}
}
package fe {

	public class ItemManager {
		
		public static var reference:ItemManager; // Public reference to this instance of an item manager

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

			reference = this;

			// Declaring these here so I can re-use it for each item type
			var loader:TextLoader = new TextLoader();
			var path:String; 
			var itemsObject:Object = {};	
			
			var loadedWeapons:int = 0;
			// Load all weapons into memory
			path = directory + weaponsFileName;
			itemsObject = loader.syncLoad(path);
			for each (var weapon:Object in itemsObject) {
				_weapons[weapon.id] = weapon;
				loadedWeapons++;
			}

			var loadedArmors:int = 0;
			// Load all armors into memory
			path = directory + armorsFileName;
			itemsObject = loader.syncLoad(path);
			for each (var armor:Object in itemsObject) {
				_armors[armor.id] = armor;
				loadedArmors++;
			}

			var loadedItems:int = 0;
			// Load all items into memory
			path = directory + itemsFileName;
			itemsObject = loader.syncLoad(path);
			for each (var item:Object in itemsObject) {
				_items[item.id] = item;
				loadedItems++;
			}

			var loadedSchematics:int = 0;
			// Load all schematics into memory
			path = directory + schematicsFileName;
			itemsObject = loader.syncLoad(path);
			for each (var schematic:Object in itemsObject) {
				_schematics[schematic.id] = schematic;
				loadedSchematics++;
			}

			trace("ItemManager.as/Constructor() - Loaded " + loadedWeapons + " weapons, " + loadedArmors + " armors, " + loadedItems + " items, and " + loadedSchematics + " schematics");
		}

		public function get weapons():Object {
			return _weapons;
		}

		public function get armors():Object {
			return _armors;
		}
		
		public function getWeapon(id:String):Object {
			if (_weapons[id]) {
				trace("ItemManager.as/getWeapon() - Getting weapon: " + id);
				return _weapons[id];
			}
			else {
				trace("ItemManager.as/getWeapon() - Error: Couldn't find weapon: " + id);
				return {}; // Return an empty object
			}
		}

		public function getArmor(id:String):Object {
			if (_armors[id]) {
				trace("ItemManager.as/getArmor() - Getting armor: " + id);
				return _armors[id];
			}
			else {
				trace("ItemManager.as/getArmor() - Error: Couldn't find armor: " + id);
				return {}; // Return an empty object
			}
		}

		public function getItem(id:String):Object {
			if (_items[id]) {
				trace("ItemManager.as/getItem() - Getting item: " + id);
				return _items[id];
			}
			else {
				trace("ItemManager.as/getItem() - Error: Couldn't find item: " + id);
				return {}; // Return an empty object
			}
		}

		public function getSchematic(id:String):Object {
			if (_schematics[id]) {
				trace("ItemManager.as/getSchematic() - Getting schematic: " + id);
				return _schematics[id];
			}
			else {
				trace("ItemManager.as/getSchematic() - Error: Couldn't find schematic: " + id);
				return {}; // Return an empty object
			}
		}
	}
}
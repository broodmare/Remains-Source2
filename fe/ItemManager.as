package fe {

	import fe.serv.Item;
	
	public class ItemManager {
		
		public static var reference:ItemManager; // Public reference to this instance of an item manager

		private static const itemsPath:String = "Modules/core/AllData/items.json";
		private static const ammoPath:String = "Modules/core/AllData/ammo.json";
		private static const schematicsPath:String = "Modules/core/AllData/schematics.json";

		private var _items:Object		= {};	// A dictionary of items loaded from JSON
		private var _schematics:Object	= {};	// A dictionary of schematics loaded from JSON
		private var _itemList:Array		= [];	// All items in the order they were loaded
		
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
				_itemList.push(item);
				loadedItems++;
			}
			
			// Ammo is also an item (its weapon properties are handled by the WeaponManager), the placeholder entry only holds default values
			itemsObject = loader.syncLoad(ammoPath);
			for each (var ammo:Object in itemsObject) {
				if (ammo.id == "placeholder") {
					continue;
				}
				
				if (_items[ammo.id]) {
					trace("ItemManager.as/Constructor() - Error: Ammo \"" + ammo.id + "\" is also defined as an item");
					continue;
				}
				
				// Items store their weight as 'm'
				if (!("m" in ammo) && "weight" in ammo) {
					ammo.m = ammo.weight;
				}
				
				_items[ammo.id] = ammo;
				_itemList.push(ammo);
				loadedItems++;
			}

			var loadedSchematics:int = 0;
			// Load all schematics into memory, they're also items that can be found and sold
			itemsObject = loader.syncLoad(schematicsPath);
			for each (var schematic:Object in itemsObject) {
				if (!("tip" in schematic)) {
					schematic.tip = Item.L_SCHEME;
				}
				
				// [The type of workbench needed to craft it] was called 'work'
				if (!("work" in schematic) && "workbench" in schematic) {
					schematic.work = schematic.workbench;
				}
				
				_schematics[schematic.id] = schematic;
				
				if (!_items[schematic.id]) {
					_items[schematic.id] = schematic;
					_itemList.push(schematic);
				}
				
				loadedSchematics++;
			}

			trace("ItemManager.as/Constructor() - Loaded " + loadedItems + " items, and " + loadedSchematics + " schematics");

		}

		public function get items():Object {
			return _items;
		}

		// All item data in the order it was loaded
		public function get itemList():Array {
			return _itemList;
		}
		
		public function get schematics():Object {
			return _schematics;
		}
		
		// Check if an item is defined without logging an error
		public function hasItem(id:String):Boolean {
			return id != null && _items[id] != null;
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
		
		// The type of any item ID, including weapons and armor which aren't in the item files (formerly Item.itemTip)
		// Returns null if the ID doesn't belong to anything
		public function getItemType(id:String):String {
			if (id == null) {
				return null;
			}
			
			var data:Object = _items[id];
			if (data) {
				return data.tip ? data.tip : Item.L_ITEM;
			}
			
			if (WeaponManager.reference && id in WeaponManager.reference.allWeaponData()) {
				return Item.L_WEAPON;
			}
			
			if (ArmorManager.reference && ArmorManager.reference.hasArmor(id)) {
				return Item.L_ARMOR;
			}
			
			return null;
		}
		
		// [Inventory section] 1 - equipment, 2 - ammo and explosives, 3 - everything else
		public function getInvCat(id:String):int {
			var data:Object = _items[id];
			if (data == null) {
				return 3;
			}
			
			if ("invcat" in data) {
				return data.invcat;
			}
			
			if ("us" in data && data.us > 0 && data.tip != Item.L_FOOD && data.tip != "eda" && data.tip != Item.L_BOOK) {
				return 1;
			}
			
			if (data.tip == Item.L_AMMO || data.tip == Item.L_EXPL) {
				return 2;
			}
			
			return 3;
		}
		
		// The weight of a single item
		public function getWeight(id:String):Number {
			var data:Object = _items[id];
			if (data && "m" in data) {
				return data.m;
			}
			
			return 0;
		}
	}
}

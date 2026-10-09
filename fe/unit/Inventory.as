package fe.unit {

	import flash.utils.Dictionary;

	import fe.ItemManager;
	import fe.weapon.Weapon;

	public class Inventory {

		private var _inventory:Vector.<InventoryItem>;	// Vector that stores a contigious collection of <InventoryItem> references for fast iteration
		private var _inventoryMap:Dictionary;			// Dictionary to map each InventoryItem.id to it's reference (Key-Pair)

		private var _equipment:Equipment;
		private var _favorites:Favorites;

		public var mass:Array = [0, 0, 0, 0];	// Seperate weight totals for each item category
		public var massW:int = 0;				// [Weight of all usable weapons]
		public var massM:int = 0;				// [Weight of all usable spells]

		// [The player's equipment when the game was saved]
		public var cWeaponId:String	= "";
		public var cArmorId:String	= "";
		public var cAmulId:String	= "";
		public var cSpellId:String	= "";
		public var prevArmor:String	= "";

		// Constructor
		public function Inventory() {
			_inventory = new Vector.<InventoryItem>();
			_inventoryMap = new Dictionary();

			_equipment = new Equipment();
			_favorites = new Favorites();
		}

		public function get equipment():Equipment {
			return _equipment;
		}

		public function get favorites():Favorites {
			return _favorites;
		}

		// Increases the quantity of an existing item or adds a new item if it doesn't already exist.
		public function setQuantity(id:String, n:int):void {

			var item:InventoryItem = _inventoryMap[id];
			if (item) {
				item.quantity = n;
			}
			else {
				// Don't bother adding the item to the inventory if the result is negative
				if (n > 0) {
					item = addEntry(id, n);
				}
			}

			// If the result is 0 or less quantity, remove the item
			if (item) {
				removeIfEmpty(item);
			}
		}

		// Increases the quantity of an existing item or adds a new item if it doesn't already exist.
		public function increaseQuantity(id:String, n:int = 1):void {
			if (n <= 0) {
				throw new ArgumentError("Quantity to increase must be positive.");
			}

			var item:InventoryItem = _inventoryMap[id];
			if (item) {
				item.quantity += n;
			}
			else {
				addEntry(id, n);
			}
		}

		// Decrease the quantity of an existing item, remove if quantity drops to zero
		public function decreaseQuantity(id:String, n:int = 1):void {
			if (n <= 0) {
				throw new ArgumentError("Quantity to decrease must be positive.");
			}

			var item:InventoryItem = _inventoryMap[id];
			if (item) {
				item.quantity -= n;
				removeIfEmpty(item);
			}
		}

		// Get item by id
		public function getItem(id:String):InventoryItem {
			return _inventoryMap[id] as InventoryItem;
		}

		// Get item quantity
		public function getQuantity(id:String):int {
			if (!hasItem(id)) {
				return 0;
			}

			return _inventoryMap[id].quantity;
		}

		// Add items the player just acquired, they're marked as new so the inventory can highlight them
		public function addNew(id:String, n:int):void {
			if (n <= 0) {
				return;
			}

			var previous:int = getQuantity(id);
			increaseQuantity(id, n);

			if (id == "money") {
				return;
			}

			var item:InventoryItem = _inventoryMap[id];
			if (previous == 0) {
				item.nov = 1;
			}
			else if (item.nov == 0) {
				item.nov = 2;
			}

			item.dat = new Date().getTime();
		}

		// Retrieves all items in the inventory as a Vector.<InventoryItem>.
		public function getAllItems():Vector.<InventoryItem> {
			return _inventory.concat(); // Return a shallow copy to prevent external modifications
		}

		// Removes an item from the inventory by id.
		public function removeItem(id:String):void {
			var item:InventoryItem = _inventoryMap[id];

			if (item != null) {
				// Find the index of the item in the Vector
				var index:int = _inventory.indexOf(item);

				if (index != -1) {
					// Remove the item from the Vector
					_inventory.splice(index, 1);
				}

				// Remove the item from the Dictionary
				delete _inventoryMap[id];
			}
		}

		// Checks if an item exists in the inventory.
		public function hasItem(id:String):Boolean {
			var item:InventoryItem = _inventoryMap[id];
			return item != null && item.quantity > 0;
		}

		private function addEntry(id:String, n:int):InventoryItem {
			var item:InventoryItem = new InventoryItem(id, n);
			_inventory.push(item);
			_inventoryMap[id] = item;
			return item;
		}

		private function removeIfEmpty(item:InventoryItem):void {
			if (item.quantity <= 0) {
				removeItem(item.id);
			}
		}

		// [Recalculate the weight of each inventory section]
		public function calcMass():void {
			var itemManager:ItemManager = ItemManager.reference;
			mass[1] = 0;
			mass[2] = 0;
			mass[3] = 0;

			for each (var item:InventoryItem in _inventory) {
				if (item.quantity > 0) {
					mass[itemManager.getInvCat(item.id)] += itemManager.getWeight(item.id) * item.quantity;
				}
			}
		}

		// [Recalculate the weight of weapons and spells that aren't stored away]
		public function calcWeaponMass():void {
			massW = 0;
			massM = 0;

			for each (var w:Weapon in _equipment.weapons) {
				if (w.respect != Weapon.WEP_INACTIVE && w.respect != Weapon.WEP_ACTIVE) {
					continue;
				}

				if (w.hasDurability()) {
					massW += w.mass;
				}

				if (w.tip == Weapon.TYPE_MAGIC && (!w.spell || getQuantity(w.id) > 0)) {
					massM += w.mass;
				}
			}
		}

		// Save the inventory, the format is the same as the original game's (Invent.save) so old saves still load
		public function save(currentIds:Object = null):Object {
			var obj:Object = {};
			obj.weapons	= {};
			obj.armors	= {};
			obj.items	= {};
			obj.fav		= _favorites.save();

			for each (var w:Weapon in _equipment.weapons) {
				obj.weapons[w.id] = {id:w.id, hp:w.hp, hold:w.magazineRounds, ammo:(w.ammo ? w.ammo.id : ""), respect:w.respect};
			}

			for each (var a:Armor in _equipment.armors) {
				obj.armors[a.id] = {id:a.id, hp:a.hp, lvl:a.lvl, stored:a.stored};
			}

			for each (var item:InventoryItem in _inventory) {
				obj.items[item.id] = item.quantity;
}

			if (currentIds) {
				for (var key:String in currentIds) {
					obj[key] = currentIds[key];
				}
			}

			return obj;
		}

		// Load the item quantities, favorites and current equipment IDs from a save (Items stored in the vault are loaded by ItemInteraction)
		// Weapons, armor and spells need an owner, ItemInteraction.load() creates those
		public function load(saveData:Object):void {
			_inventory.length = 0;
			_inventoryMap = new Dictionary();

			if (saveData == null) {
				return;
			}

			// Saves made during the item rework stored a list of {id, quantity}
			if (saveData is Array && !("items" in saveData)) {
				for each (var entry:Object in saveData) {
					if (entry && entry.id && entry.quantity > 0) {
						setQuantity(entry.id, entry.quantity);
					}
				}
				return;
			}

			for (var id:String in saveData.items) {
				var n:int = int(saveData.items[id]);
				if (id != "" && n > 0) {
					setQuantity(id, n);
				}
			}

			_favorites.load(saveData.fav);

			cWeaponId	= saveData.cWeaponId || "";
			cArmorId	= saveData.cArmorId || "";
			cAmulId		= saveData.cAmulId || "";
			cSpellId	= saveData.cSpellId || "";
			prevArmor	= saveData.prevArmor || "";
		}
	}
}

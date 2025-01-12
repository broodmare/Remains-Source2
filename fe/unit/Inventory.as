package fe.unit {

	import flash.utils.Dictionary;
	
	/*
	**	This is probably a bit overkill, but the inventory stores everything as simple objects: { "id": "internalID", "quantity": 0 }
	**	The '_inventory' Vector does two things; It ensures type safety so ONLY the correct object format can be stored, and inventory is stored as contiguous memory.
	**	The '_inventoryMap' is the save each InventoryItem's index in the Vector using it's 'id' as a Key. This is so we don't ever have to iterate through _inventory.
	**	in theory this should be the best performance for a potentially large inventories as far as ActionScript 3 goes.
	** 	
	**	The drawback to this is that this is only good for simple items, not anything that dynamically changes (Weapons, Armor, Etc.)
	**		- woons
	*/
	public class Inventory {
		
		private var _inventory:Vector.<InventoryItem>;	// Vector to store InventoryItem instances
		private var _inventoryMap:Dictionary;			// Dictionary to map id to InventoryItem for quick access

		
		public var mass:Array = [0, 0, 0, 0];	// Seperate weight totals for each item category
		public var massW:int = 0;				// 
		public var massM:int = 0;				// 

		// Constructor
		public function Inventory() {
			_inventory = new Vector.<InventoryItem>();
			_inventoryMap = new Dictionary();
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
				item = new InventoryItem(id, n);
				_inventory.push(item);
				_inventoryMap[id] = item;
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
				if (item.quantity <= 0) {
					removeItem(id);
				}
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

		// Import an entire inventory
		public function loadInventory(saveData:Object):void {
			// Clear current inventory
			_inventory.length = 0;
			_inventoryMap = new Dictionary();

			// Store each InventoryItem contained in 'saveData'
			for (var key:String in saveData) {
				var loadedItem:InventoryItem = saveData[key] as InventoryItem;
				
				if (loadedItem) {
					_inventory.push(loadedItem);
					_inventoryMap[key] = loadedItem;
				}
				else {
					throw new Error("Invalid data type in saveData for key: " + key);
				}
			}
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
			return _inventoryMap[id] != null;
		}
	}
}

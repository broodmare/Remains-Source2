package fe.serv {

	import fe.unit.Inventory;
	import fe.unit.InventoryItem;

	public class VendorInventory {

		private var _inventory:Inventory;
		
		// Constructor
		public function VendorInventory() {
			_inventory = new Inventory();
		}

		// Clear how many of each item the vendor bought or sold in the current transaction?
		public function reset():void {
			kolBou = 0;
			for each(var item:InventoryItem in _inventory) {
				buys[i].bou = 0;
			}
		}
	}
}
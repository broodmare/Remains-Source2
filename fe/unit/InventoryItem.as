package fe.unit {
	
	// This is an abstract object that should only be used by Inventory.as
	public class InventoryItem {
		
		public var id:String;						// Internal ID of an item
		public var quantity:int;					// How many of this item are in inventory
		//public var weight:Number;					// The weight of a single item (For speed, I don't want to get the weight for all items from data to recalc total inv weight)
		public var hidden:Boolean = false;			// Whether or not to show this item in the player's inventory
		
		public function InventoryItem(s:String = "", n:int = 1) {
			id = s;
			quantity = n;
		}
	}
}
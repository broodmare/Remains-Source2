package fe.unit {
	
	// This is an abstract object that should only be used by Invent
	public class InventoryItem {
		
		public var id:String;
		public var quantity:int;
		
		public function InventoryItem(s:String = "", n:int = 0) {
			id = s;
			quantity = n;
		}
	}
}
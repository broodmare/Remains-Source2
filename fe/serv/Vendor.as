package fe.serv {
	
	import fe.*;

	// A merchant, its items for sale and money. VendorManager creates and restocks them
	public class Vendor {
		
		// Main vendor data
		private var _id:String;						// Inventory list name
		private var _data:Object;					// The vendor's items for sale and quests
		private var _stock:Vector.<Item>;			// The items the vendor sells
		private var _stockMap:Object;				// The items the vendor sells by ID

		public var money:int				= 0;	// Caps the vendor has to buy items from the player
		public var multPrice:Number			= 1.00;	// Item price multiplier
		public var buyTotal:Number			= 0;	// [kolBou] The price of all items the player wants to buy
		public var sellTotal:Number			= 0;	// [kolSell] The price of all items the player wants to sell

		// Constructor
		public function Vendor(id:String = "Vendor", data:Object = null) {
			_id = id;
			_data = data;
			_stock = new Vector.<Item>();
			_stockMap = {};
		}

		public function get vendorData():Object {
			return _data ? _data : {};
		}

		public function get id():String {
			return _id;
		}

		// Everything the vendor sells
		public function get stock():Vector.<Item> {
			return _stock;
		}
		
		public function getItem(id:String):Item {
			return _stockMap[id] as Item;
		}
		
		public function hasItem(id:String):Boolean {
			var item:Item = _stockMap[id];
			return item != null && item.kol > 0;
		}
		
		// Add an item for sale, if the vendor already sells it the amount is added to it
		public function addItem(item:Item):void {
			var existing:Item = _stockMap[item.id];
			
			if (existing) {
				existing.kol += item.kol;
				return;
			}
			
			_stock.push(item);
			_stockMap[item.id] = item;
		}
		
		// Add more of an item for sale (eg. the player sold it)
		public function addStock(id:String, n:int):void {
			var item:Item = _stockMap[id];
			
			if (item == null) {
				item = new Item(id, 0);
				item.kol = 0;
				_stock.push(item);
				_stockMap[id] = item;
			}
			
			item.kol += n;
		}
		
		// Remove everything the vendor sells
		public function clearStock():void {
			_stock = new Vector.<Item>();
			_stockMap = {};
		}

		// Handling money
		public function increaseMoney(n:int):void {
			money += n;
		}
		public function decreaseMoney(n:int):void {
			money -= n;
		}

		// [Clear how many of each item are being bought in the current trade]
		public function reset():void {
			buyTotal = 0;
			sellTotal = 0;

			for each (var item:Item in _stock) {
				item.bou = 0;
			}
		}

		// The items for sale, in the same format as the original game (Vendor.save)
		public function save():* {
			if (_id == null) {
				return null;
			}
			
			var arr:Array = [];
			for each (var item:Item in _stock) {
				arr.push(item.save());
			}
			
			return arr;
		}
	}
}

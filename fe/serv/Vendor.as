package fe.serv {
	
	import fe.*;
	import fe.TextLoader;
	import fe.unit.Unit;
	import fe.unit.Inventory;
	import fe.unit.InventoryItem;

	public class Vendor {
		
		// Main vendor data
		private var _id:String;						// Inventory list name
		private var _data:Object;					// The vendor's items for sale and quests
		private var _inventory:Inventory;			// The vendor's inventory

		// Working variables
		private var _priceMultiplier:Number;		// Item price multiplier
		private var _currentTrade:Object;			// How much of each item has been bought/sold during this trade

		// Constructor
		public function Vendor(id:String = "Vendor", data:Object = null, inv:Inventory = null) {
			_id = id;
			_data = data;
			_inventory = inv;

			_priceMultiplier = 1.00;
			
			// Initialize the _currentTrade object using the inventory
			reset();
		}

		public function get vendorData():Object {
			return _data;
		}

		public function get id():String {
			return _id;
		}

		public function get multPrice():Number {
			return _priceMultiplier;
		}
		public function set multPrice(n:Number):void {
			_priceMultiplier = n;
		}

		// Handling money
		public function get money():int {
			return _inventory.getQuantity("money");
		}
		public function increaseMoney(n:int):void {
			_inventory.increaseQuantity("money", n);
		}
		public function decreaseMoney(n:int):void {
			_inventory.decreaseQuantity("money", n);
		}
		
		// Swap out the vendor's inventory for a new one
		public function setInventory(inv:Inventory):void {
			_inventory = inv;
		}

		// Inventory wrappers
		public function get inventory():Vector.<InventoryItem> {
			return _inventory.getAllItems();
		}
		public function getQuantity(id:String):int {
			return _inventory.getQuantity(id);
		}
		public function increaseQuantity(id:String, n:int):void {
			_inventory.increaseQuantity(id, n);
		}
		public function decreaseQuantity(id:String, n:int):void {
			_inventory.decreaseQuantity(id, n);
		}
		public function hasItem(id:String):Boolean {
			return _inventory.hasItem(id);
		}

		// Adjusting the _currentTrade counters
		public function getBuyingAmount(id:String):int {
			return _currentTrade[id].bought;
		}
		public function setBuyingAmount(id:String, n:int):void {
			_currentTrade[id].bought = n;
		}
		public function getSellingAmount(id:String):int {
			return _currentTrade[id].sold;
		}
		public function setSellingAmount(id:String, n:int):void {
			_currentTrade[id].sold = n;
		}

		// Finish the trade by adjusting inventory values
		public function finishTrade(playerInventory:Inventory):void {
			// Adjust trader money based on the transaction
			increaseMoney(_currentTrade.buyTotal);
    		decreaseMoney(_currentTrade.sellTotal);

			// Adjust player money based on the transaction
			playerInventory.decreaseQuantity("money", _currentTrade.buyTotal);
    		playerInventory.increaseQuantity("money", _currentTrade.sellTotal);

			// Iterate through each item in the current trade to adjust inventory
			for (var itemId:String in _currentTrade) {
				// Skip the total buy and sell amounts
				if (itemId == "buyTotal" || itemId == "sellTotal") continue;
				
				var tradeData:Object = _currentTrade[itemId];
				if (!tradeData) continue; // Safety check
				
				// Handle items bought by the player from the vendor
				if (tradeData.bought > 0) {
					_inventory.decreaseQuantity(itemId, tradeData.bought);
					playerInventory.increaseQuantity(itemId, tradeData.bought);
				}
				
				// Handle items sold by the player to the vendor
				if (tradeData.sold > 0) {
					_inventory.increaseQuantity(itemId, tradeData.sold);
					playerInventory.decreaseQuantity(itemId, tradeData.sold)
				}
			}

			// Reset the transaction item here??
			//reset();
		}

		// Reset our counter for the amount of each item bought and sold during this trade
		public function reset():void {
			// Set properties to track the value of items current marked for buying/selling
			_currentTrade = { 
				buyTotal: 0,	// Amount of money the player is spending
				sellTotal: 0	// Amount of money the player will recieve
			};

			for each (var item:InventoryItem in _inventory.getAllItems()) {
				_currentTrade[item.id] = { bought: 0, sold: 0 };
			}
		}

		// Total price of all items the player wishes to purchase
		public function get buyTotal():int {
			return _currentTrade.buyTotal;
		}
		

		// How many caps the player will receive from the trader when selling an item
		public function get sellTotal():int {
			return _currentTrade.sellTotal;
		}

		// Lazy fix for now until I can rework pipPageVend
		public function set buyTotal(n:int):void {
			_currentTrade.buyTotal = n;
		}
		public function set sellTotal(n:int):void {
			_currentTrade.sellTotal = n;
		}

		public function save():* {
			// TODO: re-implement this
		}
	}	
}
package fe {

	import fe.util.Calc;
	import fe.serv.Vendor;
	import fe.serv.Item;
	import fe.unit.Inventory;
	import fe.unit.InventoryItem;
	import fe.serv.LootGen;

	public class VendorManager {
		
		private static const directory:String			= "Modules/core/AllData/";
		private static const vendorsFileName:String		= "vendors.json";
		
		private var saveData:Object;								// Vendor inventories if a previous save was loaded
		private static var vendorData:Object			= {};		// Vendor ivnentory types are stored here after being loaded from JSON
		private var _vendors:Object						= {};		// Initialized vendors are stored here

		// Constructor
		public function VendorManager(loadObj:Object = null) {
			
			if (loadObj) {
				saveData = loadObj;
			}

			var loader:TextLoader = new TextLoader();
			var path:String; 
			
			// Load all the vendor inventory lists into memory and store them by id
			path = directory + vendorsFileName;
			trace("Vendor.as/VendorManager() - Initializing vendor inventories from json file at " + path);
			var lists:Object = loader.syncLoad(path);
			for each (var inv:Object in lists) {
				// Store each vendor inventory type
				vendorData[inv.id] = inv; 

				// Build and store a vendor with each inventory type
				createVendor(inv.id);
			}
		}

		public function get vendors():Object {
			return _vendors;
		}

		public function getVendor(id:String):Vendor {
			if (_vendors[id]) {
				return _vendors[id];
			}

			trace("VendorManager.as/getVendor() - Error: Could not find vendor ID: " + id);
			return null;
		}

		// Returns the data for that vendor (What they sell / quests they offer)
		public function getVendorData(id:String):Object {
			if (vendorData[id]) {
				return vendorData[id];
			}

			trace("VendorManager.as/getVendorList() - Error: Could not find VendorList ID: " + id);
			return {};
		}

		private function createVendor(id:String):void {
			
			trace("VendorManager.as/createVendor() - Building vendor type: " + id);
			// Create the vendor object to hold all the data and state for this vendor
			var vendor:Vendor;
			// Load the vendor's items for sale and quests into memory
			var data:Object = vendorData[id];

			if (!isEmpty(data)) {
				
				// Create a new inventory for the vendor
				var inventory:Inventory = new Inventory();
				var currentTradeData:Object = {};

				// Create a new item for each object the vendor trades
				for each (var item:Object in vendorData[id].buys) {
					// Let inventory create it's own InventoryItems
					inventory.increaseQuantity(item.id, item.quantity);
				}

				vendor = new Vendor(id, vendorData[id], inventory);
			}
			else {
				// Fallback if the inventory list isn't found in vendorData
				trace("VendorManager.as/createVendor() - Error: Couldn't locate inventory list for vendor type: " + id);
				inventory = setRndBuys(id);
			}

			// Load vendor inventories from a save file if present
			/*
			if (saveData && saveData[id]) {
				var vendorSaveData:Object = saveData[id];
				
				if (vendorSaveData.buys && !isEmpty(vendorSaveData.buys)) {
					for each(var obj:Object in vendorSaveData.buys) {
						var uniqueId:String = obj.id + (obj.variant > 0 ? "^" + obj.variant : "");
						var existingItem:InventoryItem = vendor.buys2[uniqueId];
						
						if (existingItem) {
							existingItem.quantity = obj.quantity;
							//existingItem.sost = obj.sost;
						}
						else {
							var newItem:InventoryItem = new InventoryItem(obj.id, obj.quantity);
							vendor.buys.push(newItem);
							vendor.buys2[uniqueId] = newItem;
						}
					}
				}
				else {
					//trace("VendorManager.as/createVendor() - No vendor.buys data found in saveData for vendor: " + id);
				}
				
				vendor.kolBou		= vendorSaveData.kolBou;
				vendor.kolSell		= vendorSaveData.kolSell;
				vendor.money		= vendorSaveData.money;
				vendor.multPrice	= vendorSaveData.multPrice;
			}
			*/
			
			// Set the amount of money available to the vendor
			if (vendor.money == 0) { // If money wasn't set from JSON
				vendor.increaseMoney(Calc.intBetween(50, 500));
				
				// 20% chance to double available money
				if (Math.random() < 0.20) {
					vendor.increaseMoney(vendor.money);
				}
			}

			// Store the finished vendor
			_vendors[id] = vendor;
		}

		// Restock all items a vender sells
		public function refillVendor(vendor:Vendor):void {
				
			// Creates a completely random selection of items available for purchase
			if (vendor.id == 'random') {
				vendor.setInventory(setRndBuys('random'));
			} 
			
			// Cache
			var itemManager:ItemManager = ItemManager.reference;
			var buyLimit:int = World.w.pers.limitBuys;
			// Adds 25% of the item limit to each item the vendor sells (Eg. If the limit is 12, 4 of that item would be added)
			for each(var item:Object in vendorData[vendor.id].buys) {
				var itemData:Object = itemManager.getItem(item.id);
				var itemQty:int = item.quantity || 1;
				
				// Don't refill certain items or item types
				if (itemData.noref || itemData.tip == Item.L_ARMOR || itemData.tip == Item.L_WEAPON || 
					itemData.tip == Item.L_SCHEME || itemData.tip == Item.L_UNIQ || itemData.tip == Item.L_IMPL) {
					continue;
				}
				
				// Calculate the maximum amount of this item the vendor can stock
				var itemCap:int = Math.ceil(itemQty * buyLimit);
				
				// Increase the vendors stock of that item by 1/4th of the item cap
				if (vendor.getQuantity(itemData.id) < itemCap) {
					vendor.increaseQuantity(itemData.id, Math.min(itemQty, Math.ceil(0.25 * itemCap)));
				}
			}
		}

		public function refillAllVendors():void {
			for each(var vendor:Vendor in _vendors) {
				refillVendor(vendor);
			}
		}

		// Generate a random set of items for sale
		public function setRndBuys(id:String = "vendor"):Inventory {
			
			var vendor:Vendor = _vendors[id];
			var inv:Inventory = new Inventory();

			// 70% chance to apply a random price modifier
			if (Math.random() < 0.70) {
				vendor.multPrice = Calc.floatBetween(0.70, 1.30);
			}
			
			var num:int;
			var num2:int;
			
			if (id == 'random') {
				num = 30;
			}
			else if (id == 'doctor') {
				num = 5 + 3 * World.w.pers.barterLvl;
			}
			else {
				num = 10 + 6 * World.w.pers.barterLvl;
			}
			
			num = Math.round(num * (0.50 + Math.random() * 0.70));
			num2 = num * (0.10 + Math.random() * 0.30);
			
			

			
			var cid:String;							// Re-useable string to use for item ID
			var lvl:int = World.w.pers.level;		// Get the player level
			
			for (var i:int = 0; i < num; i++) {
				if (i < num2 && id != 'doctor') {
					cid = LootGen.getRandom(Item.L_WEAPON, 1 + lvl * 0.25);
					
					// We don't have this item yet, add it to inventory
					if (!inv.hasItem(cid)) {
						
						/*	?????? FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME 
						if (Math.random() < 0.20) {
							item.barter = Math.floor(Math.random() * lvl * 0.25 + 1);
							
							if (item.barter > 5) {
								item.barter = 5;
							}
						}
						*/

						inv.increaseQuantity(cid);
					}
				}
				else {
					var itemTip:String;
					var t:int = Calc.intBetween(0, 109);
					
					if (id == 'doctor') {
						if (t < 70) {
							itemTip = Item.L_MED;
						}
						else {
							itemTip = Item.L_HIM;
						}
					}
					else {
						if (t < 5) itemTip			= Item.L_UNIQ;
						else if (t < 10) itemTip	= Item.L_SCHEME;
						else if (t < 25) itemTip	= Item.L_MED;
						else if (t < 35) itemTip	= Item.L_HIM;
						else if (t < 55) itemTip	= Item.L_EXPL;
						else if (t < 60) itemTip	= Item.L_COMPA;
						else if (t < 65) itemTip	= Item.L_COMPW;
						else if (t < 70) itemTip	= Item.L_COMPE;
						else if (t < 75) itemTip	= Item.L_COMPM;
						else itemTip				= Item.L_AMMO;
					}
					
					cid = LootGen.getRandom(itemTip, lvl);
					if (cid == null) {
						continue;
					}
					
					/*
					if (Math.random() < 0.30) {
						item.lvl = Math.floor(Math.random() * lvl + 1);
						if (item.lvl > 5) {
							item.lvl = 5;
						}
					}
					*/
					var qty:int = 1;

					if (itemTip == Item.L_AMMO) {
						qty = Calc.intBetween(3, 15);	// TODO: This might be wrong and need to be multipled by the ammo's "Kol" property
					}
					else if (itemTip != Item.L_UNIQ && itemTip != Item.L_SCHEME) {
						qty = Calc.intBetween(1, 5);
					}
					
					inv.increaseQuantity(cid, qty);
				}
			}

			return inv;
		}

		// Check if an object is empty, Eg. '{}'
		private function isEmpty(obj:Object):Boolean {
			for (var key:String in obj) {
				return false; // Found a property, so it's not empty
			}
			
			return true; // No properties found, it's empty
		}
	}
}
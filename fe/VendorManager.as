package fe {

	import fe.util.Calc;
	import fe.serv.Vendor;
	import fe.serv.Item;
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

		// The items a vendor had when the game was saved, unique weapons in the original game's saves were stored as {id:"mont", variant:1}
		private function getSavedStock(id:String):Array {
			if (saveData == null || saveData[id] == null) {
				return null;
			}
			
			var stock:Array = [];
			for each (var obj:Object in saveData[id]) {
				if (obj == null || !obj.id) {
					continue;
				}
				
				var itemId:String = obj.id;
				if (obj.variant > 0 && itemId.indexOf("^") < 0) {
					itemId += "^" + obj.variant;
				}
				
				stock.push({id:itemId, kol:obj.kol, sost:obj.sost});
			}
			
			return stock;
		}
		
		private function createVendor(id:String):void {
			trace("VendorManager.as/createVendor() - Building vendor type: " + id);
			
			// Load the vendor's items for sale and quests into memory
			var data:Object = vendorData[id];
			var vendor:Vendor = new Vendor(id, data);
			var saved:Array = getSavedStock(id);
			var obj:Object;
			var item:Item;

			if (id == "random") {
				// [Random vendors keep what they had]
				if (saved) {
					for each (obj in saved) {
						if (ItemManager.reference.getItemType(obj.id) == null) {
							continue;
						}

						item = new Item(obj.id, obj.kol);
						vendor.addItem(item);
					}
				}
				else {
					setRndBuys(vendor, 100, "random");
				}
			}
			else {
				// Create a new item for each object the vendor trades
				for each (var buy:Object in data.buys) {
					if (ItemManager.reference.getItemType(buy.id) == null) {
						trace("VendorManager.as/createVendor() - Error: Vendor \"" + id + "\" sells an unknown item: " + buy.id);
						continue;
					}
					
					item = new Item(buy.id, ("quantity" in buy) ? buy.quantity : -1);
					
					if ("barter" in buy)	item.barter		= buy.barter;
					if ("lvl" in buy)		item.lvl		= buy.lvl;
					if ("trigger" in buy)	item.trig		= buy.trigger;
					if ("noref" in buy)		item.noref		= Boolean(buy.noref);
					if ("nocheap" in buy)	item.nocheap	= Boolean(buy.nocheap);
					if ("hardinv" in buy)	item.hardinv	= Boolean(buy.hardinv);
					if ("pmult" in buy)		item.pmult		= buy.pmult;
					
					// Load vendor inventories from a save file if present
					if (saved) {
						for each (obj in saved) {
							if (obj.id == item.id) {
								item.kol = obj.kol;
								item.sost = obj.sost;
								break;
							}
						}
					}
					
					vendor.addItem(item);
				}
			}
			
			setStartingMoney(vendor);

			// Store the finished vendor
			_vendors[id] = vendor;
		}

		// A vendor without a list of items, it sells random items (Used by NPCs with vendor types that aren't defined)
		public function createRandomVendor(tip:String, lvl:int):Vendor {
			var vendor:Vendor = new Vendor(tip, null);
			setRndBuys(vendor, lvl, tip);
			setStartingMoney(vendor);
			return vendor;
		}
		
		private static function setStartingMoney(vendor:Vendor):void {
			vendor.money = Math.round(Math.random() * 450 + 50);
			
			// 20% chance to double available money
			if (Math.random() < 0.20) {
				vendor.money *= 2;
			}
		}
		
		// Restock all items a vender sells
		public function refillVendor(vendor:Vendor):void {
			
			// Creates a completely random selection of items available for purchase
			if (vendor.id == "random") {
				vendor.clearStock();
				setRndBuys(vendor, 100, "random");
				return;
			}
			
			var data:Object = vendorData[vendor.id];
			if (data == null) {
				return;
			}
			
			var buyLimit:Number = World.w.pers.limitBuys;
			
			// Adds 25% of the item limit to each item the vendor sells (Eg. If the limit is 12, 4 of that item would be added)
			for each (var buy:Object in data.buys) {
				var item:Item = vendor.getItem(buy.id);
				
				// Don't refill certain items or item types
				if (item == null || item.noref || item.tip == Item.L_ARMOR || item.tip == Item.L_WEAPON ||
					item.tip == Item.L_SCHEME || item.tip == Item.L_UNIQ || item.tip == Item.L_IMPL || !("quantity" in buy)) {
					continue;
				}
				
				// Calculate the maximum amount of this item the vendor can stock
				var itemCap:int = Math.ceil(buy.quantity * buyLimit);
				
				// Increase the vendors stock of that item by 1/4th of the item cap
				if (item.kol < itemCap) {
					item.kol = Math.min(itemCap, item.kol + Math.ceil(0.25 * itemCap));
				}
			}
		}

		public function refillAllVendors():void {
			for each(var vendor:Vendor in _vendors) {
				refillVendor(vendor);
			}
		}

		// Generate a random set of items for sale
		public function setRndBuys(vendor:Vendor, lvl:int = 0, rndtip:String = "vendor"):void {
			// 70% chance to apply a random price modifier
			if (Math.random() < 0.70) {
				vendor.multPrice = Math.floor(Math.random() * 6 + 8) / 10;
			}
			
			var num:int;
			
			if (rndtip == "random") {
				num = 30;
			}
			else if (rndtip == "doctor") {
				num = 5 + 3 * World.w.pers.barterLvl;
			}
			else {
				num = 10 + 6 * World.w.pers.barterLvl;
			}
			
			num = Math.round(num * (0.50 + Math.random() * 0.70));
			var num2:int = num * (0.10 + Math.random() * 0.30);

			var item:Item;
			var cid:String;
			
			for (var i:int = 0; i < num; i++) {
				if (i < num2 && rndtip != "doctor") {
					cid = LootGen.getRandom(Item.L_WEAPON, 1 + lvl / 4);
					
					// We don't have this weapon yet, add it to inventory
					if (cid != null && vendor.getItem(cid) == null) {
						item = new Item(cid, 1, Item.L_WEAPON);
						
						if (Math.random() < 0.20) {
							item.barter = Math.min(Math.floor(Math.random() * lvl / 4 + 1), 5);
						}

						vendor.addItem(item);
					}
				}
				else {
					var itemTip:String;
					var t:int = Math.floor(Math.random() * 110);
					
					if (rndtip == "doctor") {
						itemTip = (t < 70) ? Item.L_MED : Item.L_HIM;
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
					
					item = new Item(cid, -1, itemTip);
					
					if (vendor.getItem(cid) == null) {
						if (Math.random() < 0.30) {
							item.lvl = Math.min(Math.floor(Math.random() * lvl + 1), 5);
						}

						if (itemTip == Item.L_AMMO) {
							item.kol = Math.round(item.kol * (3 + Math.random() * 12));
						}
						else if (itemTip != Item.L_UNIQ && itemTip != Item.L_SCHEME) {
							item.kol = Math.round(item.kol * (1 + Math.random() * 4));
						}
						
						vendor.addItem(item);
					}
					else if (itemTip != Item.L_UNIQ && itemTip != Item.L_SCHEME) {
						vendor.getItem(cid).kol += item.kol;
					}
				}
			}
		}
	}
}

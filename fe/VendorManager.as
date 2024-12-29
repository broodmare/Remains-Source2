package fe {

	import fe.serv.Vendor;
	import fe.serv.Item;
	import fe.serv.LootGen;

	public class VendorManager {
		
		private static const directory:String = "Modules/core/AllData/";
		private static const vendorsFileName:String = "vendors.json";
		
		private var saveData:Object;				// Vendor inventories if a previous save was loaded
		private static var vendorLists:Object = {};		// Vendor ivnentory types are stored here after being loaded from JSON
		private var _vendors:Object	= {};				// Initialized vendors are stored here

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
				vendorLists[inv.id] = inv; 

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

		public function getVendorList(id:String):Object {
			if (vendorLists[id]) {
				return vendorLists[id];
			}

			trace("VendorManager.as/getVendorList() - Error: Could not find VendorList ID: " + id);
			return {};
		}

		private function createVendor(id:String):void {
			
			trace("VendorManager.as/createVendor() - Building vendor type: " + id);
			var vendor:Vendor = new Vendor();

			if (vendorLists[id]) {
				vendor.id = id;
				vendor.vendorData = vendorLists[id];

				// Create new arrays/dictionaries
				vendor.buys = [];
				vendor.buys2 = {};
				
				if (!isEmpty(vendorLists[id].buys)) {
					// Create a new item for each object the vendor trades
					for each (var obj1:Object in vendorLists[id].buys) {
						// Create the item, set the amount for sale, and if it's a variant
						var item:Item = new Item(null, obj1.id, obj1.kol, obj1.variant);	
						// Add it to the array of items this vender trades
						vendor.buys.push(item);
						// If the item is a variant, restore it's original name, eg. "Shotgun^1"
						var uid:String = item.id;
						if (item.variant > 0) {
							uid += '^' + item.variant;
						}
						// Store the item unique or not in buys2
						vendor.buys2[uid] = item;
					}
				}
				else {
					trace("VendorManager.as/createVendor() - Vendor: " + id + " had no valid list of items to trade");
				}
			}
			else {
				// Fallback if the inventory list isn't found in vendorLists
				trace("VendorManager.as/createVendor() - Error: Couldn't locate inventory list for vendor type: " + id);
				setRndBuys(99, id);
			}

			// Load vendor inventories from a save file if present
			if (saveData && saveData[id]) {
				var vendorSaveData:Object = saveData[id];
				
				if (vendorSaveData.buys && !isEmpty(vendorSaveData.buys)) {
					for each(var obj:Object in vendorSaveData.buys) {
						var uniqueId:String = obj.id + (obj.variant > 0 ? "^" + obj.variant : "");
						var existingItem:Item = vendor.buys2[uniqueId];
						
						if (existingItem) {
							existingItem.kol = obj.kol;
							existingItem.sost = obj.sost;
						}
						else {
							var newItem:Item = new Item(null, obj.id, obj.kol, obj.variant);
							vendor.buys.push(newItem);
							vendor.buys2[uniqueId] = newItem;
						}
					}
				}
				else {
					//trace("VendorManager.as/createVendor() - No vendor.buys data found in saveData for vendor: " + id);
				}

				vendor.kolBou = vendorSaveData.kolBou;
				vendor.kolSell = vendorSaveData.kolSell;
				vendor.money = vendorSaveData.money;
				vendor.multPrice = vendorSaveData.multPrice;
			}
			
			// Set the amount of money available to the vendor
			if (vendor.money == 0) { // If money wasn't set from JSON
				vendor.money = Math.round(Math.random() * 450 + 50);
				if (Math.random() < 0.2) {
					vendor.money *= 2;
				}
			}

			// Store the finished vendor
			_vendors[id] = vendor;
		}

		// Generate random items for the vendor
		// THIS IS SUPPOSED TO USE CHARACTER LEVEL, BUT I'D RATHER ALL ITEMS BE SHOWN NORMALLY AND UNAVAILABLE ITEMS JUST HIDDEN INSTEAD
		// THAT SHOULD MAKE THIS ABLE TO KNOW NOTHING ABOUT THE PLAYER
		public function setRndBuys(lvl:int = 99, id:String = "vendor") {
			
			var vendor:Vendor = _vendors[id];

			if (Math.random() < 0.7) {
				vendor.multPrice = Math.floor(Math.random() * 6 + 8) / 10;
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
			
			num = Math.round(num * (0.5 + Math.random() * 0.7));
			num2 = num * (0.1 + Math.random() * 0.3);
			
			var item:Item;
			var cid:String;
			
			for (var i:int = 0; i < num; i++) {
				if (i < num2 && id != 'doctor') {
					cid = LootGen.getRandom(Item.L_WEAPON, 1 + lvl / 4);
					item = new Item(Item.L_WEAPON, cid, 1)
					
					if (vendor.buys2[cid] == null) {
						if (Math.random() < 0.2) {
							item.barter = Math.floor(Math.random() * lvl / 4 + 1);
							
							if (item.barter > 5) {
								item.barter = 5;
							}
						}
						vendor.buys.push(item);
						vendor.buys2[cid] = item;
					}
				}
				else {
					var itemTip:String;
					var t:int = Math.floor(Math.random() * 110);
					
					if (id == 'doctor') {
						if (t < 70) {
							itemTip = Item.L_MED;
						}
						else {
							itemTip = Item.L_HIM;
						}
					}
					else {
						if (t < 5) itemTip = Item.L_UNIQ;
						else if (t < 10) itemTip = Item.L_SCHEME;
						else if (t < 25) itemTip = Item.L_MED;
						else if (t < 35) itemTip = Item.L_HIM;
						else if (t < 55) itemTip = Item.L_EXPL;
						else if (t < 60) itemTip = Item.L_COMPA;
						else if (t < 65) itemTip = Item.L_COMPW;
						else if (t < 70) itemTip = Item.L_COMPE;
						else if (t < 75) itemTip = Item.L_COMPM;
						else itemTip = Item.L_AMMO;
					}
					
					cid = LootGen.getRandom(itemTip, lvl);
					if (cid == null) {
						continue;
					}
					
					item = new Item(itemTip, cid);
					
					if (vendor.buys2[cid] == null) {
						if (Math.random() < 0.3) {
							item.lvl = Math.floor(Math.random() * lvl + 1);
							if (item.lvl > 5) {
								item.lvl = 5;
							}
						}
						
						if (itemTip == Item.L_AMMO) {
							item.kol = Math.round(item.kol * (3 + Math.random() * 12));
						}
						else if (itemTip!=Item.L_UNIQ && itemTip != Item.L_SCHEME) {
							item.kol = Math.round(item.kol * (1 + Math.random() * 4));
						}
						
						vendor.buys.push(item);
						vendor.buys2[cid] = item;
					}
					else if (itemTip != Item.L_UNIQ && itemTip != Item.L_SCHEME) {
						vendor.buys2[cid].kol += item.kol;
					}
				}
			}
		}

		public function refillAllVendors():void {
			
			for each(var vendor:Vendor in _vendors) {
				var vendorData:Object = vendorLists[vendor.id];
				
				if (vendorData == null) {
					return;
				}
				
				if (vendor.id == 'random') {
					vendor.buys = [];
					vendor.buys2 = {};
					setRndBuys(100, 'random');
					
					for each (var item:Item in vendor.buys) {
						var uid:String = item.id;
						if (item.variant > 0) {
							uid += '^' + item.variant;
						}
						vendor.buys2[uid] = item;
					}
					return;
				} 
				
				for each(var item:Item in vendor.buys) {
					if (item.noref || item.tip == Item.L_ARMOR || item.tip == Item.L_WEAPON || 
						item.tip == Item.L_SCHEME || item.tip == Item.L_UNIQ || item.tip == Item.L_IMPL) {
						continue;
					}
					
					var buyData:Object = findBuyData(vendorData, item.id);
					if (buyData == null || !buyData.hasOwnProperty("n")) {
						continue;
					}
					
					var lim:int = Math.ceil(buyData.n * World.w.pers.limitBuys);
					
					if (item.kol < lim) {
						item.kol = Math.min(lim, item.kol + Math.ceil(0.25 * lim));
					}
				}
			}
		}

		private function findBuyData(vendorData:Object, itemId:String):Object {
			for each(var buy:Object in vendorData.buys) {
				if (buy.id == itemId) {
					return buy;
				}
			}
			return null;
		}

		// Check if an object is empty, Eg. '{}'
		private function isEmpty(obj:Object):Boolean {
			for (var key:String in obj) {
				return false; // Found a property, so it's not empty
			}
			return true; // No properties found, it's empty
		}

		private function crash():void {
			var obj:Object = null;
			trace(obj.someProperty); // Crashes with a null reference error
		}
	}
}
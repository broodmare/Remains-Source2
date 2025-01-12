package fe.serv {	
	
	import fe.*;
	import fe.unit.Invent;
	
	
	public class Item {	// [Inventory item]
		
		private static var itemManager:ItemManager;

		// Ghetto AS3 enumeration
		public static const L_ITEM:String = 'item';
		public static const L_ARMOR:String = 'armor';
		public static const L_WEAPON:String = 'weapon';
		public static const L_UNIQ:String = 'uniq';
		public static const L_SPELL:String = 'spell';
		public static const L_AMMO:String = 'a';
		public static const L_EXPL:String = 'e';
		public static const L_MED:String = 'med';
		public static const L_BOOK:String = 'book';
		public static const L_HIM:String = 'him';
		public static const L_POT:String = 'pot';
		public static const L_FOOD:String = 'food';
		public static const L_SCHEME:String = 'scheme';
		public static const L_PAINT:String = 'paint';
		public static const L_COMPA:String = 'compa';
		public static const L_COMPW:String = 'compw';
		public static const L_COMPE:String = 'compe';
		public static const L_COMPM:String = 'compm';
		public static const L_COMPP:String = 'compp';
		public static const L_SPEC:String = 'spec';
		public static const L_INSTR:String = 'instr';
		public static const L_STUFF:String = 'stuff';
		public static const L_ART:String = 'art';
		public static const L_IMPL:String = 'impl';
		public static const L_KEY:String = 'key';

		public static var itemTip:Array=['weapon','spell','a','e','med','book','him','scheme','compa','compw','compe','compm','compp','paint','art','impl','key'];
		
		public var tip:String;					// Item type
		public var wtip:String = "";			// weapon type (0 - internal, 1 - melee, 2 - small (pistols), 3 - large (rifles and more), 4 - throwing, 5 - magic
		public var base:String = "";			// Base version of an item, eg. "p32" and it's variant "p32_1"
		public var id:String;					// Internal item ID
		public var nazv:String;					// Item name
		public var mess:String;					// [Information window that pauses the game]
		public var fc:int = -1;					// [Popup color]
		public var invis:Boolean = false;		// 
		
		public var invCat:int = 3;				// What iventory page this items goes into on your pip-buck
		public var sost:Number = 1;				// [Loot status]
		public var multHP:Number = 1;			// [HP multiplier]
		public var variant:Boolean = false;		// This is a unique weapon variant
		public var mass:Number = 0;				// Item weight
		
		public var imp:int=0;					// [0 - randomly generated, 1 - specified, 2 - critical]
		public var cont:Interact;				// [parent container]
		
		public var nov:int = 0;					// [New thing]
		public var dat:Number = 0;				// [When item was acquired]
		public var bou:int = 0;					// How many of an item we just bought
		public var shpun:int = 0;				// [A sign indicating that a concealed weapon needs to be revealed]
		public var lvl:int = 0;					// [Character level from which the item becomes available]
		public var barter:int = 0;				// [The skill level at which the item becomes available]
		public var trig:String;					// [Trigger that must be set for the item to become available]
		public var price:Number = 0;
		public var pmult:Number = 1;
		public var noref:Boolean = false;		// [Do not replenish]
		public var nocheap:Boolean = false;		// [Don't reduce the price]
		public var hardinv:Boolean = false;		// [only with limited inventory]

		private var _data:Object;				// The objects properties in JSON format
		
		// [nkol -- number of items or weapon/armor condition 0-1-2]
		// [If nkol=-1, the quantity is taken from xml] 
		
		// Constructor
		public function Item(itemID:String, nkol:int = -1) {
			// Grab a reference to the item manager if needed
			if (!itemManager) {
				itemManager = ItemManager.reference;
			}
			
			// Set the ID
			id = itemID;

			// Get the data for the item
			_data = itemManager.getItem(id);
			
			// TODO: This is so stupid
			if (isEmpty(_data)) {
				_data = itemManager.getWeapon(id);
			}
			
			if (isEmpty(_data)) {
				_data = itemManager.getArmor(id);
			}
			
			if (isEmpty(_data)) {
				_data = itemManager.getSchematic(id);
			}

			
			if ("uniqueVariant" in _data) {
				variant = _data.uniqueVariant;
			}

			//	TYPE
			tip = _data.tip;
			
			// All uniques are weapons, change to L_WEAPON (????? When/where would this get set?)
			if (tip == L_UNIQ) {
				tip = L_WEAPON;
			}

			// Get the weapon type if applicable
			if ("wtip" in _data) {
				wtip = _data.tip;
			}
			
			// Only create one of something if it's a weapon or armor (???? Again, when/where is this getting set?)
			if (tip == L_ARMOR || tip == L_WEAPON) {
				kol = 1;

				// If this is an amulet
				if (tip == L_ARMOR && _data.tip == '3') {
					sost = 1;
				}
				// Otherwise
				else {
					if (nkol == 0) {
						sost = 0.05 + Math.random() * 0.15;
					}
					if (nkol == 1) {
						sost = 0.60 + Math.random() * 0.25;
					}
				}
			}
			
			// If there's a manual item count being passed, use it
			if (nkol >= 0) {
				kol = nkol;
			}
			// Otherwise, if this is being called with -1, use data
			else if (nkol < 0 && "kol" in _data) {
				kol = _data.kol
			}
			// or if we still can't find a quantity in data, just use '1'
			else {
				kol = 1;
			}
			
			if (tip == L_WEAPON || tip == L_EXPL) {
				// Get the localized name of the weapon
				nazv = Res.txt('w', id);
				
				if (tip == L_EXPL) {
					wtip = 'w5';
				}
				else {
					wtip = 'w' + _data.skill;
				}
			}
			else if (tip == L_ARMOR) {
				// Get the localized name of the armor
				nazv = Res.txt('a', id);
				
				// Set the armor type?
				if ("tip" in _data) {
					wtip = 'armor' + _data.tip;
				}
				else {
					wtip = 'armor1';
				}
			}
			else if ("ammo_base" in _data) {
				// Ammo variant naming
				base = _data.ammo_base;
				nazv = Res.txt('i', base);
				
				// Get the localizeed name of the ammo variant
				if ("mod" in _data) {
					nazv += ' (' + LanguageManager.reference.localText("pip", 'am_' + _data.mod) + ')';
				}
			}
			else {
				nazv = Res.txt('i', id);
			}

			if (tip == L_ITEM && "tip" in _data) {
				tip = _data.tip;
			}
			
			// If it's a schematic
			if (tip == L_SCHEME) {
				// Remove the first two letters of the id, eg. "s_dartgun" -> "dartgun"
				var wid:String = id.substr(2);

				// Get a formatted localized name based on the workbench type required ("Scheme «xyz»" or "Recipe «xyz»")
				var prefix:String = (_data.work == "work") ? LanguageManager.reference.localText("pip", "scheme1") : LanguageManager.reference.localText("pip", "recipe");
				nazv = prefix + " «" + Res.txt('i', wid) + "»";
			}
			
			// Set the item category
			if (tip == L_AMMO || tip == L_EXPL) {
				invCat = 2;
			}
			
			// Set the item category
			if ("us" in _data && tip != L_FOOD && tip != "eda" && tip != L_BOOK) {
				invCat = 1;
			}
			
			// Set the item category
			if (tip == L_WEAPON) { 
				if (_data.tip != 4) {
					mass = 1;
				}
				if ("phis_m" in _data) {
					mass = _data.phis_m;
				}
			}
			
			if ("invcat" in _data) {
				invCat = _data.invcat;
			}
			
			if ("invis" in _data) {
				invis = true;
			}
			
			if ("fc" in _data) {
				fc = _data.fc;
			}
			
			if ("mess" in _data) {
				mess = _data.mess;
			}
			
			if ("m" in _data) {
				mass = _data.m;
			}

		}

		public function get data():Object {
			return _data;
		}
		
		public function getPrice():void {

			if ("com_price" in _data) {
				price = _data.com_price * sost * multHP * pmult;
			}
			else {
				price = _data.price * sost * multHP * pmult;
			}

		}
		
		public function getMultPrice():Number {
			if ("price" in _data && "sell" in _data) {
				return _data.sell / _data.price;
			}
			else {
				return 0.10;
			}
		}
		
		public function checkAuto(m:Boolean = false):Boolean {
			// Get the player inventory
			var inv:Invent = World.w.invent;
			
			if (tip == L_WEAPON) {
				var w = inv.weapons[id];
				
				// [If auto selection for repair or forced call is enabled]
				if (w != null && (World.w.vsWeaponRep || m)) {
					// [Pick up automatically if there is a weapon, it is faulty and (it is selected or the inventory is infinite)]
					if (w.hp <= w.maxhp && (w.respect==0 || w.respect==2 || !World.w.hardInv)) {	
						return true;
					}
					// [If there was a forced taking with the final inventory, then activate the taken weapon]
					else if (m && World.w.hardInv) {
						shpun=2;
					}
					return false; 
				}
				
				// [if auto-selection of new ones is enabled and there are no weapons yet]
				if (w == null && World.w.vsWeaponNew) {
					// [If inventory is limited, then check the weight]
					if (World.w.hardInv) {
						// The item is weightless, pick the item up
						if (mass == 0) {
							return true;
						}
						if (_data.tip <= 3) {
							// There is enough room in inventory, pick the item up
							if (inv.massW <= World.w.pers.maxmW - mass) {
								return true;
							}
							else {
								if (m) {
									World.w.gui.infoText('fullWeap');
								}
								return false;
							}
						}
						if (_data.tip == 5) {
							// There is enough room in inventory, pick the item up
							if (inv.massM <= World.w.pers.maxmM - mass) {
								return true;
							}
							else {
								if (m) {
									World.w.gui.infoText('fullMagic');
								}
								return false;
							}
						}
						return false;
					}
					return true;
				}
				return false;
			}
			
			if (tip == L_SPELL) {
				if (inv.massM >= World.w.pers.maxmM) {
					World.w.gui.infoText('fullMagic');
				}
				return true;
			}
			
			// Always pick up armor
			if (tip == L_ARMOR) {
				return true;
			}
			
			// Always pick up weightless items
			if (mass == 0) {
				return true;
			}
			
			if (World.w.hardInv) {
				if (inv.mass[invCat] + mass * kol > World.w.pers['maxm' + invCat]) {
					return false;
				}
			}
			
			if (World.w.vsAmmoAll && tip == L_AMMO) {
				return true;
			}
			
			if (World.w.vsAmmoTek && tip == L_AMMO) {
				for each (w in inv.weapons) {
					if (w.tip <= 3 && (w.respect == 0 || w.respect == 2) && w.ammoBase != "" && (w.ammoBase == data.id || w.ammoBase == data.base)) {
						return true;
					}
				}
			}
			
			if (World.w.vsExplAll && tip == L_EXPL) {
				return true;
			}
			
			if (World.w.vsMedAll && (tip == L_MED || tip == L_POT)) {
				return true;
			}
			
			if (World.w.vsHimAll && tip == L_HIM) {
				return true;
			}
			
			if (World.w.vsEqipAll && tip == 'equip') {
				return true;
			}
			
			if (World.w.vsStuffAll && invCat == 3) {
				return true;
			}
			
			if (World.w.vsVal && tip == 'valuables') {
				return true;
			}
			
			if (World.w.vsBook && (tip == 'book' || tip == 'sphera')) {
				return true;
			}
			
			if (World.w.vsFood && (tip == 'food' || tip == 'eda')) {
				return true;
			}
			
			if (World.w.vsComp && (tip == 'stuff' || tip == 'compa' || tip == 'compw' || tip == 'compe' || tip == 'compm')) {
				return true;
			}
			
			if (World.w.vsIngr && tip == 'compp') {
				return true;
			}
			
			return false;
		}
		
		public function save():Object {
			return {tip:tip, id:id, kol:kol, sost:sost, barter:barter, lvl:lvl, trig:trig, variant:variant};
		}
		
		public function trade():void {
			kol -= bou;
			bou = 0;	// How many of an item we just bought
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
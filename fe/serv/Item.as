package fe.serv {	
	
	import fe.World;
	import fe.LanguageManager;
	import fe.ItemManager;
	import fe.WeaponManager;
	import fe.ArmorManager;
	import fe.unit.Armor;
	import fe.unit.Inventory;
	import fe.unit.Pers;
	import fe.weapon.Weapon;
	import fe.weapon.Ammo;
	
	public class Item {

		// Ghetto AS3 enumeration
		public static const L_ITEM:String		= "item";
		public static const L_ARMOR:String		= "armor";
		public static const L_WEAPON:String		= "weapon";
		public static const L_UNIQ:String		= "uniq";
		public static const L_SPELL:String		= "spell";
		public static const L_AMMO:String		= "a";
		public static const L_EXPL:String		= "e";
		public static const L_MED:String		= "med";
		public static const L_BOOK:String		= "book";
		public static const L_HIM:String		= "him";
		public static const L_POT:String		= "pot";
		public static const L_FOOD:String		= "food";
		public static const L_SCHEME:String		= "scheme";
		public static const L_PAINT:String		= "paint";
		public static const L_COMPA:String		= "compa";
		public static const L_COMPW:String		= "compw";
		public static const L_COMPE:String		= "compe";
		public static const L_COMPM:String		= "compm";
		public static const L_COMPP:String		= "compp";
		public static const L_SPEC:String		= "spec";
		public static const L_INSTR:String		= "instr";
		public static const L_STUFF:String		= "stuff";
		public static const L_ART:String		= "art";
		public static const L_IMPL:String		= "impl";
		public static const L_KEY:String		= "key";

		public static var itemTip:Array = ["weapon","spell","a","e","med","book","him","scheme","compa","compw","compe","compm","compp","paint","art","impl","key"];
		
		public var cont:Interact;						// [parent container]
		private var _data:Object;						// The objects properties in JSON format (item, weapon or armor data)
		
		public var id:String;							// Internal item ID (unique weapon variants include their variant, eg. "mont^1")
		public var nazv:String;							// Localized item name
		public var tip:String;							// Item type
		public var wtip:String			= "";			// [Sorting category for vendors]
		public var base:String			= "";			// Base version of an item, eg. "p32" and it's variant "p32_1"
		
		public var mess:String;							// [Information window that pauses the game]
		public var fc:int				= -1;			// [Popup color]
		public var invis:Boolean		= false;		//

		public var kol:int				= 0;			// How many of this item there are
		public var invCat:int			= 3;			// What iventory page this items goes into on your pip-buck
		public var sost:Number			= 1.00;			// [Loot status] Condition of weapons and armor
		public var multHP:Number		= 1.00;			// [HP multiplier]
		public var variant:Boolean		= false;		// This is a unique weapon variant
		public var dropped:Boolean		= false;		// Dropped by the player, weapons don't come with extra ammo when they're picked back up
		public var armorLvl:int			= 0;			// Upgrade level of armor dropped by the player
		public var mass:Number			= 0.00;			// Item weight

		public var imp:int				= 0;			// [0 - randomly generated, 1 - specified, 2 - critical]
		
		public var nov:int				= 0;			// [New thing]
		public var dat:Number			= 0.00;			// [When item was acquired]
		public var bou:int				= 0;			// How many of an item we just bought
		public var shpun:int			= 0;			// [A sign indicating that a concealed weapon needs to be revealed]
		public var lvl:int				= 0;			// [Character level from which the item becomes available]
		public var barter:int			= 0;			// [The skill level at which the item becomes available]
		public var trig:String;							// [Trigger that must be set for the item to become available]
		public var price:Number			= 0.00;
		public var pmult:Number			= 1.00;
		public var noref:Boolean		= false;		// [Do not replenish]
		public var nocheap:Boolean		= false;		// [Don't reduce the price]
		public var hardinv:Boolean		= false;		// [only with limited inventory]
		
		// Constructor
		// nkol - [The number of items or the condition of weapons/armor 0-1-2], if nkol = -1 the item's default amount is used
		// ntip - Forces the item type, eg. a scheme or a spell (normally it's found from the item's ID)
		public function Item(itemID:String, nkol:int = -1, ntip:String = null) {
			
			id = itemID;
			var localize:Function = LanguageManager.reference.localText;

			// Get the type
			tip = ntip;
			if (tip == L_UNIQ) {
				tip = L_WEAPON;
			}
			if (tip == null || tip == "" || tip == L_ITEM) {
				tip = ItemManager.reference.getItemType(id);
			}
			if (tip == null) {
				trace("Item.as/Item() - Error: Unknown item: \"" + id + "\"");
				tip = L_ITEM;
			}
			
			// Get the item's data
			if (tip == L_WEAPON) {
				_data = WeaponManager.reference.weaponData(id);
			}
			else if (tip == L_ARMOR) {
				_data = ArmorManager.reference.armorData(id);
			}
			else {
				_data = ItemManager.reference.hasItem(id) ? ItemManager.reference.getItem(id) : {};
			}
			
			variant = Boolean(_data.variant);
			
			// Weapons and armor are always single items, the amount is used for their condition instead
			if (tip == L_ARMOR || tip == L_WEAPON) {
				kol = 1;
				
				if (tip == L_ARMOR && isAmulet(id)) {
					sost = 1;
				}
				else {
					if (nkol == 0) {
						sost = 0.05 + Math.random() * 0.15;
					}
					if (nkol == 1) {
						sost = 0.60 + Math.random() * 0.25;
					}
				}
			}
			else if (nkol >= 0) {
				kol = nkol;
			}
			else {
				kol = ("kol" in _data) ? _data.kol : 1;
			}
			
			// Names
			nazv = nameOf(id, tip);
			
			if (tip == L_WEAPON) {
				wtip = "w" + _data.skill;
			}
			else if (tip == L_EXPL) {
				wtip = "w5";
			}
			else if (tip == L_ARMOR) {
				wtip = "armor" + (isAmulet(id) ? Armor.TYPE_AMULET : Armor.TYPE_ARMOR);
			}
			else if (tip == L_AMMO) {
				base = WeaponManager.reference.getAmmo(id).base;
			}
			
			// Set the item category
			if (tip == L_WEAPON) {
				invCat = 3;
				
				if (_data.tip != Weapon.TYPE_EXPLOSIVES) {
					mass = 1;
				}
				
				if ("phis_m" in _data) {
					mass = _data.phis_m;
				}
			}
			else if (tip != L_ARMOR) {
				invCat = ItemManager.reference.getInvCat(id);
				mass = ItemManager.reference.getWeight(id);
			}
			
			if ("invis" in _data && _data.invis) {
				invis = true;
			}
			
			if ("fc" in _data) {
				fc = _data.fc;
			}
			
			if ("mess" in _data) {
				mess = _data.mess;
			}
		}
		
		// The localized name of any item, 'tip' is the item's type if it's already known
		public static function nameOf(id:String, tip:String = null):String {
			var lang:LanguageManager = LanguageManager.reference;
			
			if (tip == null) {
				tip = ItemManager.reference.getItemType(id);
			}

			if (tip == L_WEAPON || tip == L_EXPL) {
				return WeaponManager.weaponName(id);
			}
			
			if (tip == L_ARMOR) {
				return lang.localText("armor", id);
			}
			
			// [Ammo variants use their base ammo's name with the variant type]
			if (tip == L_AMMO) {
				return WeaponManager.reference.getAmmo(id).name;
			}
			
			// [Schematics without their own name are named after what they make]
			if (tip == L_SCHEME && !lang.hasText("items", id)) {
				var wid:String = id.substr(2);
				var schematic:Object = ItemManager.reference.hasItem(id) ? ItemManager.reference.getItem(id) : {};
				
				// Get a formatted localized name based on the workbench type required ("Scheme «xyz»" or "Recipe «xyz»")
				var prefix:String = (schematic.work == "work") ? lang.localText("pip", "scheme1") : lang.localText("pip", "recipe");
				return prefix + " «" + nameOf(wid) + "»";
			}
			
			return lang.localText("items", id);
		}

		private static function isAmulet(id:String):Boolean {
			var armor:Armor = ArmorManager.reference.armor(id);
			return armor != null && armor.tip == Armor.TYPE_AMULET;
		}
		
		public function get data():Object {
			return _data;
		}
		
		public function getPrice():void {
			if (tip == L_WEAPON) {
				price = WeaponManager.reference.itemPrice(id) * sost * multHP * pmult;
			}
			else {
				price = (_data.price || 0) * sost * multHP * pmult;
			}
		}
		
		// [How much of an item's price vendors pay for it]
		public function getMultPrice():Number {
			if (_data.price > 0 && _data.sell > 0) {
				return Number(_data.sell) / Number(_data.price);
			}
			
			return 0.1;
		}
		
		// [Check if the item should be picked up automatically, m - the player is picking it up on purpose]
		public function checkAuto(m:Boolean = false):Boolean {
			// Get the player inventory
			var inv:Inventory = World.w.invent;
			var pers:Pers = World.w.pers;
			
			if (tip == L_WEAPON) {
				var w:Weapon = inv.equipment.getWeapon(id);
				
				// A blueprint isn't a weapon the player has yet
				if (w && w.respect == Weapon.WEP_BLUEPRINT) {
					w = null;
				}
				
				// [We already have this weapon, pick it up to repair ours]
				if (w != null && (World.w.vsWeaponRep || m)) {
					if (w.hp <= w.maxhp && (w.respect == Weapon.WEP_INACTIVE || w.respect == Weapon.WEP_ACTIVE || !World.w.hardInv)) {
						return true;
					}
					else if (m && World.w.hardInv) {
						// [The player picked it up on purpose in limited inventory mode, make the weapon usable again]
						shpun = 2;
					}
					
					return false;
				}
				
				if (w == null && World.w.vsWeaponNew) {
					// [Check the weight in limited inventory mode]
					if (World.w.hardInv) {
						if (mass == 0) {
							return true;
						}
						
						if (_data.tip != Weapon.TYPE_EXPLOSIVES && _data.tip != Weapon.TYPE_MAGIC) {
							if (inv.massW <= pers.maxmW - mass) {
								return true;
							}
							
							if (m) {
								World.w.gui.infoText("fullWeap");
							}
							return false;
						}
						
						if (_data.tip == Weapon.TYPE_MAGIC) {
							if (inv.massM <= pers.maxmM - mass) {
								return true;
							}
							
							if (m) {
								World.w.gui.infoText("fullMagic");
							}
							return false;
						}
						
						return false;
					}
					
					return true;
				}
				
				return false;
			}
			
			if (tip == L_SPELL) {
				if (inv.massM >= pers.maxmM) {
					World.w.gui.infoText("fullMagic");
				}
				
				return true;
			}
			
			if (tip == L_ARMOR) {
				return true;
			}
			
			// Always pick up weightless items
			if (mass == 0) {
				return true;
			}
			
			// Check the weight before picking up items in limited inventory mode
			if (World.w.hardInv) {
				if (inv.mass[invCat] + mass * kol > pers["maxm" + invCat]) {
					return false;
				}
			}
			
			if (World.w.vsAmmoAll && tip == L_AMMO) {
				return true;
			}
			
			if (World.w.vsAmmoTek && tip == L_AMMO) {
				// [Pick up ammo for weapons the player is using]
				for each (var weapon:Weapon in inv.equipment.weapons) {
					if (weapon.tip != Weapon.TYPE_EXPLOSIVES && weapon.tip != Weapon.TYPE_MAGIC && (weapon.respect == Weapon.WEP_INACTIVE || weapon.respect == Weapon.WEP_ACTIVE) && weapon.ammoBase && (weapon.ammoBase.id == id || weapon.ammoBase.id == base)) {
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
			
			if (World.w.vsEqipAll && tip == "equip") {
				return true;
			}
			
			if (World.w.vsStuffAll && invCat == 3) {
				return true;
			}
			
			if (World.w.vsVal && tip == "valuables") {
				return true;
			}
			
			if (World.w.vsBook && (tip == L_BOOK || tip == "sphera")) {
				return true;
			}
			
			if (World.w.vsFood && (tip == L_FOOD || tip == "eda")) {
				return true;
			}
			
			if (World.w.vsComp && (tip == L_STUFF || tip == L_COMPA || tip == L_COMPW || tip == L_COMPE || tip == L_COMPM)) {
				return true;
			}
			
			if (World.w.vsIngr && tip == L_COMPP) {
				return true;
			}
			
			return false;
		}
		
		public function save():Object {
			return {tip:tip, id:id, kol:kol, sost:sost, barter:barter, lvl:lvl, trig:trig, variant:variant};
		}
		
		// [The items the player bought are removed from the vendor]
		public function trade():void {
			kol -= bou;
			bou = 0;
		}
	}
}

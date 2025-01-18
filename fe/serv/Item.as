package fe.serv {	
	
	import fe.World;
	import fe.LanguageManager;
	import fe.unit.Inventory;
	import fe.weapon.Weapon;
	
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
		private var _data:Object;						// The objects properties in JSON format
		
		public var id:String;							// Internal item ID
		public var nazv:String;							// Localized item name
		public var tip:String;							// Item type
		public var base:String			= "";			// Base version of an item, eg. "p32" and it's variant "p32_1"
		
		public var mess:String;							// [Information window that pauses the game]
		public var fc:int				= -1;			// [Popup color]
		public var invis:Boolean		= false;		// 

		public var invCat:int			= 3;			// What iventory page this items goes into on your pip-buck
		public var sost:Number			= 1.00;			// [Loot status]
		public var multHP:Number		= 1.00;			// [HP multiplier]
		public var variant:Boolean		= false;		// This is a unique weapon variant
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
		public function Item(itemID:String) {
			
			id = itemID;
			var localize:Function = LanguageManager.reference.localText;

			nazv = localize("item", id);
			
			// Get the type
			tip = _data.tip;

			// ????????
			/*
			if (nkol == 0) {
				sost = 0.05 + Math.random() * 0.15;
			}
			if (nkol == 1) {
				sost = 0.60 + Math.random() * 0.25;
			}
			*/
			
			// If it's a schematic
			if (tip == L_SCHEME) {
				// Remove the first two letters of the id, eg. "s_dartgun" -> "dartgun"
				var wid:String = id.substr(2);

				// Get a formatted localized name based on the workbench type required ("Scheme «xyz»" or "Recipe «xyz»")
				var prefix:String = (_data.work == "work") ? localize("pip", "scheme1") : localize("pip", "recipe");
				nazv = prefix + " «" + localize("item", wid) + "»";
			}
			
			// Set the item category
			if (tip == L_AMMO || tip == L_EXPL) {
				invCat = 2;
			}
			
			// Set the item category
			if ("us" in _data && tip != L_FOOD && tip != "eda" && tip != L_BOOK) {
				invCat = 1;
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
			
			if ("weight" in _data) {
				mass = _data.weight;
			}

		}

		public function get data():Object {
			return _data;
		}
		
		public function checkAuto(m:Boolean = false):Boolean {
			// Get the player inventory
			var inv:Inventory = World.w.invent;
			
			// Always pick up weightless items
			if (mass == 0) {
				return true;
			}
			
			// Check the weight before picking up items in limited inventory mode
			if (World.w.hardInv) {
				if (inv.mass[invCat] + mass * inv.getQuantity(id) > World.w.pers["maxm" + invCat]) {
					return false;
				}
			}
			
			if (World.w.vsAmmoAll && tip == L_AMMO) {
				return true;
			}
			
			if (World.w.vsAmmoTek && tip == L_AMMO) {
				for each (var w:Weapon in inv.equipment.weapons) {
					if (w.tip == "internal" || w.tip == "cryo" || w.tip == "lightGun" || w.tip == "heavyGun" && (w.respect == Weapon.WEP_INACTIVE || w.respect == Weapon.WEP_ACTIVE) && w.ammo.base != "" && (w.ammoBase == data.id || w.ammoBase == data.base)) {
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
			
			if (World.w.vsBook && (tip == "book" || tip == "sphera")) {
				return true;
			}
			
			if (World.w.vsFood && (tip == "food" || tip == "eda")) {
				return true;
			}
			
			if (World.w.vsComp && (tip == "stuff" || tip == "compa" || tip == "compw" || tip == "compe" || tip == "compm")) {
				return true;
			}
			
			if (World.w.vsIngr && tip == "compp") {
				return true;
			}
			
			return false;
		}
		
		public function save():Object {
			return {tip:tip, id:id, sost:sost, barter:barter, lvl:lvl, trig:trig, variant:variant};
		}
	}
}
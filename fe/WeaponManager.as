package fe {

	import flash.utils.Dictionary;

	import fe.weapon.Ammo;
	import fe.weapon.Weapon;
	import fe.weapon.WClub;
	import fe.weapon.WThrow;
	import fe.weapon.WMagic;
	import fe.weapon.WPunch;
	import fe.unit.Unit;
	import fe.unit.Inventory;
	import fe.unit.Resistances;

	public class WeaponManager {

		public static var reference:WeaponManager;		// Publically acessable reference to this instance

		private static const _weaponPath:String	= "Modules/core/AllData/weapons.json";
		private static const _ammoPath:String	= "Modules/core/AllData/ammo.json";
		
		// Ammo variant types mapped to their localization keys ("pip" category), formerly the integer 'mod' attribute
		private static const AMMO_MODS:Object = {
			"AP": "am_1", "HP": "am_2", "Flechette": "am_3", "Incendiary": "am_4", "Magic": "am_5",
			"Overcharge": "am_6", "Optimized": "am_7", "Plasma": "am_8", "Pulse": "am_9"
		};
		
		private static var _ammoData:Object;			// An object containing the JSON data of all ammo types
		private var _ammo:Vector.<Ammo>;				// Vector that stores a contigious collection of <Ammo> references for fast iteration
		private var _ammoMap:Dictionary;				// Dictionary to map each ammo.id to it's reference (Key-Pair)
		
		private static var _weaponData:Object;			// An object containing the JSON data of all weapons

		// Constructor
		public function WeaponManager() {
			trace("WeaponManager.as/Constructor() - Weapon Manager initializing");
			reference	= this;

			_ammo		= new Vector.<Ammo>();
			_ammoMap	= new Dictionary();
			_ammoData = loadData(_ammoPath);
			initializeAllAmmo();

			_weaponData = loadData(_weaponPath);
		}

		private function initializeAllAmmo():void {
			trace("WeaponManager.as/initializeAllAmmo() - Initializing all ammo types");

			// The placeholder entry only holds default values, it's not a real type of ammo
			var defaults:Object = _ammoData.placeholder || {};
			
			for each (var data:Object in _ammoData) {
				if (data == defaults) {
					continue;
				}
				
				var ammo:Ammo = new Ammo();
				
				// Step 1: Assign default properties from the placeholder, then override them with the properties of this ammo type
				applyAmmoData(ammo, defaults);
				applyAmmoData(ammo, data);
				ammo.name = getAmmoName(ammo);
				
				// Store the initialized Ammo object and map it by its ID
				if (_ammoMap[ammo.id]) {
					throw new Error("Duplicate ammo ID found in ammo file: " + ammo.id);
				}
				_ammo.push(ammo);
				_ammoMap[ammo.id] = ammo;
			}

			trace("WeaponManager.as/initializeAllAmmo() - Total ammo types initialized: " + _ammo.length);
		}
		
		private static function applyAmmoData(ammo:Ammo, data:Object):void {
			for (var property:String in data) {
				if (property == "damageType") {
					ammo.damageType = Resistances.parseDamageType(data.damageType, "");
				}
				else if (ammo.hasOwnProperty(property)) {
					ammo[property] = data[property];
				}
			}
		}
		
		// [Ammo variants use the name of their base ammo with their modification added, eg. "9 mm round (ap)"]
		private static function getAmmoName(ammo:Ammo):String {
			var lang:LanguageManager = LanguageManager.reference;
			if (lang == null) {
				return ammo.id;
			}
			
			if (ammo.base != "" && ammo.base != ammo.id && !lang.hasText("items", ammo.id)) {
				var s:String = lang.localText("items", ammo.base);
				if (ammo.mod in AMMO_MODS) {
					s += " (" + lang.localText("pip", AMMO_MODS[ammo.mod]) + ")";
				}
				return s;
			}
			
			// Explosives are their own ammo and use the weapon's name
			if (!lang.hasText("items", ammo.id) && lang.hasText("weapon", ammo.id)) {
				return lang.localText("weapon", ammo.id);
			}
			
			return lang.localText("items", ammo.id);
		}
		
		// Returns the ammo type with the given ID, or null if the ID is empty (the weapon doesn't use ammo).
		// Any other item can still be used as ammo (eg. scrap metal), it'll just have no special properties.
		public function getAmmo(id:String):Ammo {
			if (id == null || id == "") {
				return null;
			}
			
			var ammo:Ammo = _ammoMap[id];
			if (ammo == null) {
				if (!(id in _weaponData) && !(ItemManager.reference && ItemManager.reference.items[id])) {
					trace("WeaponManager.as/getAmmo() - Warning: \"" + id + "\" isn't a known item, using it as ammo with default properties");
				}
				
				ammo = new Ammo(id);
				ammo.name = getAmmoName(ammo);
				_ammo.push(ammo);
				_ammoMap[id] = ammo;
			}
			
			return ammo;
		}
		
		public function get allAmmo():Vector.<Ammo> {
			return _ammo;
		}
		
		// How much ammo a weapon has available in an inventory, counting every variant of its base ammo, eg. "p10" and "p10_1" (formerly Invent.ammos)
		public function getAmmoTotal(inv:Inventory, weapon:Weapon):int {
			if (weapon.ammo == null) {
				return 0;
			}
			
			var total:int = 0;
			var foundVariant:Boolean = false;
			
			if (weapon.ammoBase) {
				for each (var ammo:Ammo in _ammo) {
					if (ammo.base != "" && ammo.base == weapon.ammoBase.id) {
						total += inv.getQuantity(ammo.id);
						foundVariant = true;
					}
				}
			}
			
			// Ammo without variants (eg. explosives, scrap metal) is just counted by itself
			return foundVariant ? total : inv.getQuantity(weapon.ammo.id);
		}

		private function loadData(path:String):Object {
			// Create the JSON loader
			var loader:TextLoader = new TextLoader();

			// Load the data into memory and return it as a single object
			var newData:Object = loader.syncLoad(path);
			if (isEmpty(newData)) {
				throw new Error("Failed to load data from: " + path);
			}
			return newData;
		}

		public function weaponData(id:String):Object {
			if (id in _weaponData) {
				return _weaponData[id];
			}

			return {};
		}

		public function allWeaponData():Object {
			return _weaponData;
		}

		// [Unique variants use their own name if they have one, otherwise the base weapon's name with " - II" added]
		public static function weaponName(id:String):String {
			var lang:LanguageManager = LanguageManager.reference;
			var i:int = id.indexOf("^");
			
			if (i < 0 || lang.hasText("weapon", id)) {
				return lang.localText("weapon", id);
			}
			
			return lang.localText("weapon", id.substr(0, i)) + Weapon.variant2;
		}
		
		// The price of a unique variant when it's sold as an item, they're worth 3 times as much unless they have their own price (Clean Source: Item.getPrice)
		public function itemPrice(id:String):Number {
			var data:Object = _weaponData[id];
			if (data == null) {
				return 0;
			}
			
			var price:Number = data.com_price || 0;
			var i:int = id.indexOf("^");
			
			if (data.variant && i >= 0) {
				var baseData:Object = _weaponData[id.substr(0, i)];
				if (baseData && baseData.com_price == data.com_price) {
					price *= 3;
				}
			}
			
			return price;
		}
		
		/* Former weapon codes
		**	1 - melee, 12 - paint, 4 - throwable,
		**	5 - magic, 0 - punch, other - firearm
		*/

		// Picks which Weapon class should be used for the weapon data
		private static function getWeaponClass(data:Object):Class {
			if (data.tip == Weapon.TYPE_MELEE)		return WClub;
			if (data.tip == Weapon.TYPE_EXPLOSIVES)	return WThrow;
			if (data.tip == Weapon.TYPE_MAGIC)		return WMagic;
			if (data.punch)							return WPunch;
			return Weapon;
		}
		
		// Create a new weapon from its ID (formerly Weapon.create)
		// 'owner' can also be set later with setOwner(), 'weaponClass' overrides the Weapon class picked from the weapon's data (eg. WKick for the player's punch)
		public function cloneWeapon(id:String, owner:Unit = null, weaponClass:Class = null):Weapon {
			var data:Object = _weaponData[id];

			if (data == null) {
				trace("WeaponManager.as/cloneWeapon() - Error: Unknown weapon: \"" + id + "\"");
				return null;
			}

			var weapon:Weapon = new (weaponClass || getWeaponClass(data))();
			WeaponFactory.applyData(weapon, data);	// Shared weapon properties
			weapon.init(data);						// Properties for a specific Weapon subclass

			if (owner) {
				weapon.setOwner(owner);
			}

			return weapon;
		}

		public function setOwner(weapon:Weapon, own:Unit):void {
			weapon.setOwner(own);
		}

		public function repairWeapon(weapon:Weapon, n:int):void {
			weapon.repair(n);
		}

		// Check if an object is empty, Eg. '{}'
		private static function isEmpty(obj:Object):Boolean {
			for (var key:String in obj) {
				return false; // Found a property, so it's not empty
			}
			return true; // No properties found, it's empty
		}
	}
}

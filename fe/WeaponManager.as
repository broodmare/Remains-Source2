package fe {

	import flash.utils.Dictionary;

	import fe.weapon.Ammo;
	import fe.weapon.Weapon;
	import fe.weapon.WClub;
	import fe.weapon.WPaint;
	import fe.weapon.WThrow;
	import fe.weapon.WMagic;
	import fe.weapon.WPunch;
	import fe.unit.Unit;

	public class WeaponManager {

		

		public static var reference:WeaponManager;		// Publically acessable reference to this instance

		private static const _weaponPath:String	= "Modules/core/AllData/weapons.json";
		private static const _ammoPath:String	= "Modules/core/AllData/ammo.json";
		
		private static var _ammoData:Object;			// An object containing the JSON data of all ammo types
		private var _ammo:Vector.<Ammo>;				// Vector that stores a contigious collection of <Ammo> references for fast iteration
		private var _ammoMap:Dictionary;				// Dictionary to map each weapon.id to a reference to the Weapon (Key-Pair)
		
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

			for each (var data:Object in _ammoData) {
				var ammo:Ammo = new Ammo();
        
				// Step 1: Assign default properties from the placeholder
				for each (var property:String in _ammoData.placeholder) {
					if (ammo.hasOwnProperty(property)) {
						ammo[property] = _ammoData.placeholder[property];
					}
				}
				
				// Step 2: Override with specific properties from the current data
				for (property in data) {
					if (ammo.hasOwnProperty(property)) {
						ammo[property] = data[property];
					}
				}
				
				// Store the initialized Ammo object and map it by its ID
				if (_ammoMap[data.id]) {
					throw new Error("Duplicate ammo ID found in ammo file: " + data.id);
				}
				_ammo.push(ammo);
				_ammoMap[ammo.id] = ammo;
			}

			trace("WeaponManager.as/initializeAllAmmo() - Total ammo types initialized: " + _ammo.length);
		}
		
		public function getAmmo(id:String):Ammo {
			var ammo:Ammo;
			
			if (_ammoMap[id] != null) {
				ammo = _ammoMap[id];
				return ammo;
			}
			else {
				ammo = _ammoMap["placeholder"]
			}
			
			if (ammo == null) {
				throw new Error("Failed retrieve ammo type: " + id);
			}
			
			return ammo;
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

		/* Former weapon codes
		**	1 - melee, 12 - paint, 4 - throwable, 
		**	5 - magic, 0 - punch, other - firearm
		*/

		//createWeaponFromID()
		public function cloneWeapon(id:String):Weapon {
			var data:Object = _weaponData[id];
			
			// Create a default weapon
			var weapon:Weapon = WeaponFactory.createWeaponPart1(data);

			// Tries to get either the ammo specified or a placeholder
			weapon.ammo = getAmmo(data.ammo_base);
			weapon.ammoBase = getAmmo(data.ammo_base);

			if (weapon.ammo == null) {
				throw new Error("Failed to assign ammo to weapon " + data.id);
			}

			// Finish the second half of Weapon construction
			WeaponFactory.createWeaponPart2(weapon, data);

			// If needed, continue creating this as a subclass
			// GOD this is so HACKY, but I'm not re-doing the damage yet. 
			// This is a stupid work-around and I hate it 
			if (data.tip == "melee") {
				var wepClub:WClub = new WClub(weapon, data);
				trace("WeaponManager.as/cloneWeapon() - Created new weapon subclass: "  + weapon.id + " wClub vis is " + ((weapon.vis != null) ? "present" : "missing"));
				return weapon = wepClub;
			}
			else if (data.tip == "paint") {	// tip 12 was never used????? 
				var wepPaint:WPaint = new WPaint();
				trace("WeaponManager.as/cloneWeapon() - Created new weapon subclass: "  + weapon.id + " wPaint vis is " + ((weapon.vis != null) ? "present" : "missing"));
				return weapon = wepPaint;
			}
			else if (data.tip == "throwable") {
				var wepThrow:WThrow = new WThrow(weapon, data);
				trace("WeaponManager.as/cloneWeapon() - Created new weapon subclass: "  + weapon.id + " wThrow vis is " + ((weapon.vis != null) ? "present" : "missing"));
				return weapon = wepThrow;
			}
			else if (data.tip == "magic") {
				var wepMagic:WMagic = new WMagic();
				trace("WeaponManager.as/cloneWeapon() - Created new weapon subclass: "  + weapon.id + " wMagic vis is " + ((weapon.vis != null) ? "present" : "missing"));
				return weapon = wepMagic;
			}
			else if ("punch" in data && data["punch"] == true) {
				var wepPunch:WPunch = new WPunch(weapon);
				trace("WeaponManager.as/cloneWeapon() - Created new weapon subclass: "  + weapon.id + " wPunch vis is " + ((weapon.vis != null) ? "present" : "missing"));
				return weapon = wepPunch;
			}

			trace("WeaponManager.as/cloneWeapon() - Created new weapon: " + weapon.id + " vis is " + ((weapon.vis != null) ? "present" : "missing"));
			return weapon;
		}

		public function setOwner(weapon:Weapon, own:Unit):void {
			weapon.owner = own;

			if (own.weaponKrep) {
				weapon.fixedToOwner = own.weaponKrep;
			}
		}

		public function repairWeapon(weapon:Weapon, n:int):void {
			weapon.hp += n;
			
			if (weapon.hp > weapon.maxhp) {
				weapon.hp = weapon.maxhp;
			}
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
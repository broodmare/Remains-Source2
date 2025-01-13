package fe {

	public class WeaponManager {

		private static const _weaponPath:String = "Modules/core/AllData/weapons.json";
		public static var reference:WeaponManager;		// Publically acessable reference to this instance

		private static var _weaponData:Object;			// An object containing the JSON data of all weapons
		private var _weapons:Vector.<Weapon>;			// Vector that stores a contigious collection of <Weapon> references for fast iteration
		private var _weaponMap:Dictionary;				// Dictionary to map each weapon.id to a reference to the Weapon (Key-Pair)

		// Constructor
		public function WeaponManager() {
			
			reference = this;

			loadWeaponData();
			initializeAllWeapons();
		}

		private function loadWeaponData():void {
			
			// Create the JSON loader
			var loader:TextLoader = new TextLoader();
			var data:Object = {};

			// Load all weapons into memory
			data = loader.syncLoad(_weaponPath);
			
			// Store each set of weapon data in the _weaponData Object using it's id property as a key
			for each (var weapon:Object in data) {
				_weapons[weapon.id] = weapon;
			}
		}

		private function initializeAllArmors():void {
			
		}
	}
}
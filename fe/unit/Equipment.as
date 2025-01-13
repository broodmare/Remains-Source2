package fe.unit {

	import flash.utils.Dictionary;
	
	import fe.weapon.Weapon;

	public class Equipment {

		private var _weapons:Vector.<Weapon>;	// Vector that stores a contigious collection of <Weapon> references for fast iteration
		private var _armors:Vector.<Armor>;		// Vector that stores a contigious collection of <Armor> references for fast iteration
		private var _weaponMap:Dictionary;		// Dictionary to map each weapon.id to it's reference (Key-Pair)
		private var _armorMap:Dictionary;		// Dictionary to map each armor.id to it's reference (Key-Pair)

		// Constructor
		public function Equipment() {
			_weapons	= new Vector.<Weapon>;
			_armors		= new Vector.<Armor>;
			_weaponMap	= new Dictionary();
			_armorMap	= new Dictionary();
		}

		public function getArmor(id:String):Armor {
			return _armorMap[id] as Armor;
		}

		public function getWeapon(id:String):Weapon {
			return _weaponMap[id] as Weapon;
		}

		public function addArmor(armor:Armor):void {
			_armors.push(armor);
			_armorMap[armor.id] = armor;
		}

		public function addWeapon(weapon:Weapon):void {
			_weapons.push(weapon);
			_weaponMap[weapon.id] = weapon;
		}

		// Check both maps for an entry and return the result
		public function hasEquipment(id:String):Boolean {
			return (_weaponMap[id] != null || _armorMap[id] != null);
		}
	}
}
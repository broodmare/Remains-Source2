package fe.unit {

	import flash.utils.Dictionary;
	
	import fe.weapon.Weapon;

	public class Equipment {

		private var _weapons:Vector.<Weapon>;	// Vector that stores a contigious collection of <Weapon> references for fast iteration
		private var _armors:Vector.<Armor>;		// Vector that stores a contigious collection of <Armor> references for fast iteration
		private var _spells:Vector.<Spell>		// Vector that stores a contigious collection of <Spell> references for fast iteration

		private var _weaponMap:Dictionary;		// Dictionary to map each weapon.id to it's reference (Key-Pair)
		private var _armorMap:Dictionary;		// Dictionary to map each armor.id to it's reference (Key-Pair)
		private var _spellMap:Dictionary;		// Dictionary to map each spell.id to it's reference (Key-Pair)

		// Constructor
		public function Equipment() {
			_weapons	= new Vector.<Weapon>;
			_armors		= new Vector.<Armor>;
			_spells		= new Vector.<Spell>;
			
			_weaponMap	= new Dictionary();
			_armorMap	= new Dictionary();
			_spellMap	= new Dictionary();
		}

		public function getArmor(id:String):Armor {
			return _armorMap[id] as Armor;
		}

		public function getWeapon(id:String):Weapon {
			return _weaponMap[id] as Weapon;
		}

		public function getSpell(id:String):Spell {
			return _spellMap[id] as Spell;
		}

		public function get spells():Vector.<Spell> {
			return _spells;
		}

		public function get weapons():Vector.<Weapon> {
			return _weapons;
		}

		public function get armors():Vector.<Armor> {
			return _armors;
		}

		public function addArmor(armor:Armor):void {
			_armors.push(armor);
			_armorMap[armor.id] = armor;
		}

		public function addWeapon(weapon:Weapon):void {
			_weapons.push(weapon);
			_weaponMap[weapon.id] = weapon;
		}

		public function deleteArmor(id:String):void {
			var armor:Armor = _armorMap[id];
			
			if (armor != null) {
				// Find the index of the armor in the Vector
				var index:int = _armors.indexOf(armor);

				if (index != -1) {
					// Remove the armor from the Vector
					_armors.splice(index, 1);
				}
				
				// Remove the armor from the Dictionary
				delete _armorMap[id];
			}
		}

		public function deleteWeapon(id:String):void {
			var weapon:Weapon = _weaponMap[id];
			
			if (weapon != null) {
				// Find the index of the weapon in the Vector
				var index:int = _weapons.indexOf(weapon);

				if (index != -1) {
					// Remove the weapon from the Vector
					_weapons.splice(index, 1);
				}
				
				// Remove the weapon from the Dictionary
				delete _weaponMap[id];
			}
		}

		// Check both maps for an entry and return the result
		public function hasEquipment(id:String):Boolean {
			return (_weaponMap[id] != null || _spellMap[id] != null || _armorMap[id] != null);
		}
	}
}
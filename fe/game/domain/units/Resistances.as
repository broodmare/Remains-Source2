package fe.game.domain.units {

	import fe.game.domain.units.enums.E_Resistances;

	public class Resistances {

		// Resistances
		private var _typeResist:Object = {};		// Specific damage type resistances
		private var _resistTypes:Array;            // Array to store resistance type names

		// Initializes all resistances to 0.00, technically accepts a paramter, but use the 'setResistances' wrapper instead
		private function zeroResistances(n:Number = 0):void {
			// Set the resistances as an empty object
			_typeResist = {};

			// Store all the resistance type names
			_resistTypes = [
                E_Resistances.DAM_PIERCE, E_Resistances.DAM_CUT, E_Resistances.DAM_BLUNT, E_Resistances.DAM_BURN, E_Resistances.DAM_EXPLOSION, E_Resistances.DAM_LASER, E_Resistances.DAM_PLASMA,
                E_Resistances.DAM_VENOM, E_Resistances.DAM_EMP, E_Resistances.DAM_ELECTRIC, E_Resistances.DAM_ACID, E_Resistances.DAM_COLD, E_Resistances.DAM_POISON,
				E_Resistances.DAM_BLEED, E_Resistances.DAM_BITE, E_Resistances.DAM_BALEFIRE, E_Resistances.DAM_DEATH, E_Resistances.DAM_PSYCHIC, E_Resistances.DAM_ASTRO, 
				E_Resistances.DAM_PINKCLOUD, E_Resistances.DAM_INTERNAL, E_Resistances.DAM_HARMONY
            ];

			// Add each resistance property as the Number n
			for each (var resistType:String in _resistTypes) {
                _typeResist[resistType] = n;
            }
		}

		public static function damagesArmor(type:String):Boolean {
			return E_Resistances.ARMOR_DAMAGE_TYPES[type] == true;
		}
		
		// Converts a damage type from data into its string ID. Accepts either a string ID (eg. "DAM_LASER") or a legacy integer ID (eg. 5 or "5").
		// Returns 'fallback' if the value is empty or unknown.
		public static function parseDamageType(value:*, fallback:String):String {
			if (value == null) {
				return fallback;
			}
			
			var s:String = String(value);
			if (s == "") {
				return fallback;
			}
			
			if (s in E_Resistances.LEGACY_DAMAGE_TYPES) {
				return E_Resistances.LEGACY_DAMAGE_TYPES[s];
			}
			
			if (s.indexOf("DAM_") == 0) {
				return s;
			}
			
			trace("Resistances.as/parseDamageType() - Unknown damage type: \"" + s + "\"");
			return fallback;
		}

		public function Resistances() {
			zeroResistances();
		}

		public function getResist(type:String):Number {
			if (_typeResist.hasOwnProperty(type)) {
				return _typeResist[type];
			}

			return 0.00;
		}

		public function setResist(type:String, n:Number):void {
			if (_typeResist.hasOwnProperty(type)) {
				_typeResist[type] = n;
			}
		}

		public function changeResist(type:String, n:Number):void {
			if (_typeResist.hasOwnProperty(type)) {
				_typeResist[type] += n;
			}
		}

		public function multiplyResist(type:String, n:Number):void {
			if (_typeResist.hasOwnProperty(type)) {
				_typeResist[type] *= n;
			}
		}

		// Import resistance values from the passed object
		public function importResistances(armorData:Object):void {
			// Reset all resistances to zero
			zeroResistances();

			// Iterate through each resistance type in typeResist
			for (var resistType:String in _typeResist) {
				// Check if armorData has this resistance type
				if (armorData.hasOwnProperty(resistType)) {
					// Retrieve the value from armorData and ensure it's a Number
					var value:Number = Number(armorData[resistType]);
					
					// Update the resistance value
					_typeResist[resistType] = value;
				}
			}
		}

		// Set all resistances to the given number
		public function setResistances(n:Number):void {
			zeroResistances(n);
		}

		// Return all resistance names
		public function getAllResistanceTypes():Array {
			var keys:Array = [];
			
			for (var key:String in _typeResist) {
				keys.push(key);
			}
			
			return keys;
		}

		public function copyFrom(other:Resistances):void {
			for (var resistType:String in other._typeResist) {
				if (_typeResist.hasOwnProperty(resistType)) {
					_typeResist[resistType] = other._typeResist[resistType];
				}
			}
		}

		public function clone():Resistances {
            var newResistances:Resistances = new Resistances();
            newResistances.copyFrom(this);
            return newResistances;
        }
	}
}
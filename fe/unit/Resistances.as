package fe.unit {

	public class Resistances {

		// Define all resistance types in one place as public static constants
		public static const DAM_PIERCE:String		= "DAM_PIERCE";
		public static const DAM_CUT:String			= "DAM_CUT";
		public static const DAM_BLUNT:String		= "DAM_BLUNT";
		public static const DAM_BURN:String			= "DAM_BURN";
		public static const DAM_EXPLOSION:String	= "DAM_EXPLOSION";
		public static const DAM_LASER:String		= "DAM_LASER";
		public static const DAM_PLASMA:String		= "DAM_PLASMA";
		public static const DAM_VENOM:String		= "DAM_VENOM";
		public static const DAM_EMP:String			= "DAM_EMP";
		public static const DAM_ELECTRIC:String		= "DAM_ELECTRIC";
		public static const DAM_ACID:String			= "DAM_ACID";
		public static const DAM_COLD:String			= "DAM_COLD";
		public static const DAM_POISON:String		= "DAM_POISON";
		public static const DAM_BLEED:String		= "DAM_BLEED";
		public static const DAM_BITE:String			= "DAM_BITE";
		public static const DAM_BALEFIRE:String		= "DAM_BALEFIRE";
		public static const DAM_DEATH:String		= "DAM_DEATH";
		public static const DAM_PSYCHIC:String		= "DAM_PSYCHIC";
		public static const DAM_ASTRO:String		= "DAM_ASTRO";
		public static const DAM_PINKCLOUD:String	= "DAM_PINKCLOUD";
		public static const DAM_INTERNAL:String		= "DAM_INTERNAL";
		public static const DAM_HARMONY:String		= "DAM_HARMONY";

		// Resistances
		private var _typeResist:Object = {};		// Specific damage type resistances
		private var _resistTypes:Array;            // Array to store resistance type names

		// Constructor
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

		// Initializes all resistances to 0.00, technically accepts a paramter, but use the 'setResistances' wrapper instead
		private function zeroResistances(n:Number = 0):void {
			// Set the resistances as an empty object
			_typeResist = {};

			// Store all the resistance type names
			_resistTypes = [
                DAM_PIERCE, DAM_CUT, DAM_BLUNT, DAM_BURN, DAM_EXPLOSION, DAM_LASER, DAM_PLASMA,
                DAM_VENOM, DAM_EMP, DAM_ELECTRIC, DAM_ACID, DAM_COLD, DAM_POISON,
				DAM_BLEED, DAM_BITE, DAM_BALEFIRE, DAM_DEATH, DAM_PSYCHIC, DAM_ASTRO, 
				DAM_PINKCLOUD, DAM_INTERNAL, DAM_HARMONY
            ];

			// Add each resistance property as the Number n
			for each (var resistType:String in _resistTypes) {
                _typeResist[resistType] = n;
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
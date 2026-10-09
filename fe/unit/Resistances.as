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

		// Legacy integer damage type IDs (still used by units.xml, weapons.json, etc.) mapped to their new string IDs
		private static const LEGACY_DAMAGE_TYPES:Object = {
			0: DAM_PIERCE,		1: DAM_CUT,			2: DAM_BLUNT,		3: DAM_BURN,		4: DAM_EXPLOSION,
			5: DAM_LASER,		6: DAM_PLASMA,		7: DAM_VENOM,		8: DAM_EMP,			9: DAM_ELECTRIC,
			10: DAM_ACID,		11: DAM_COLD,		12: DAM_POISON,		13: DAM_BLEED,		14: DAM_BITE,
			15: DAM_BALEFIRE,	16: DAM_DEATH,		17: DAM_PSYCHIC,	18: DAM_ASTRO,		19: DAM_PINKCLOUD,
			100: DAM_INTERNAL,	101: DAM_HARMONY
		};
		
		// Damage types that wear down a unit's armor (formerly 'tip <= D_BALE' except EMP, poison and bleeding, plus astro)
		private static const ARMOR_DAMAGE_TYPES:Object = {
			DAM_PIERCE: true,	DAM_CUT: true,		DAM_BLUNT: true,	DAM_BURN: true,		DAM_EXPLOSION: true,
			DAM_LASER: true,	DAM_PLASMA: true,	DAM_VENOM: true,	DAM_ELECTRIC: true,	DAM_ACID: true,
			DAM_COLD: true,		DAM_BITE: true,		DAM_BALEFIRE: true,	DAM_ASTRO: true
		};
		
		public static function damagesArmor(type:String):Boolean {
			return ARMOR_DAMAGE_TYPES[type] == true;
		}
		
		// Resistances
		private var _typeResist:Object = {};		// Specific damage type resistances
		private var _resistTypes:Array;            // Array to store resistance type names
		
		// Converts a damage type from data into its string ID. Accepts either a string ID (eg. "DAM_LASER") or a legacy integer ID (eg. 5 or "5").
		// Returns 'fallback' if the value is empty or unknown.
		public static function parseDamageType(value:*, fallback:String = DAM_PIERCE):String {
			if (value == null) {
				return fallback;
			}
			
			var s:String = String(value);
			if (s == "") {
				return fallback;
			}
			
			if (s in LEGACY_DAMAGE_TYPES) {
				return LEGACY_DAMAGE_TYPES[s];
			}
			
			if (s.indexOf("DAM_") == 0) {
				return s;
			}
			
			trace("Resistances.as/parseDamageType() - Unknown damage type: \"" + s + "\"");
			return fallback;
		}

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
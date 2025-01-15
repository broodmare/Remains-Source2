package fe.unit {

	public class Resistances {

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

		private function zeroResistances():void {
			// Set the resistances as an empty object
			_typeResist = {};

			// Store all the resistance type names
			_resistTypes = [
                "pierce", "cut", "blunt", "fire", "explosive", "laser", "plasma",
                "venom", "emp", "electric", "acid", "cold", "poison", "bleed",
                "bite", "balefire", "necro", "psychic", "astro", "pinkCloud",
                "inside", "friend"
            ];

			// Manually add each resistance property as the Number 0.00
			_typeResist["pierce"]		= 0.00;		// Formerly   0 | D_BUL 
			_typeResist["cut"]			= 0.00;		// Formerly   1 | D_BLADE
			_typeResist["blunt"]		= 0.00;		// Formerly   2 | D_PHIS
			_typeResist["fire"]			= 0.00;		// Formerly   3 | D_FIRE
			_typeResist["explosive"]	= 0.00;		// Formerly   4 | D_EXPL
			_typeResist["laser"]		= 0.00;		// Formerly   5 | D_LASER
			_typeResist["plasma"]		= 0.00;		// Formerly   6 | D_PLASMA
			_typeResist["venom"]		= 0.00;		// Formerly   7 | D_VENOM
			_typeResist["emp"]			= 0.00;		// Formerly   8 | D_EMP
			_typeResist["electric"]		= 0.00;		// Formerly   9 | D_SPARK
			_typeResist["acid"]			= 0.00;		// Formerly  10 | D_ACID
			_typeResist["cold"]			= 0.00;		// Formerly  11 | D_CRIO
			_typeResist["poison"]		= 0.00;		// Formerly  12 | D_POISON
			_typeResist["bleed"]		= 0.00;		// Formerly  13 | D_BLEED
			_typeResist["bite"]			= 0.00;		// Formerly  14 | D_FANG
			_typeResist["balefire"]		= 0.00;		// Formerly  15 | D_BALE
			_typeResist["necro"]		= 0.00;		// Formerly  16 | D_NECRO
			_typeResist["psychic"]		= 0.00;		// Formerly  17 | D_PSY
			_typeResist["astro"]		= 0.00;		// Formerly  18 | D_ASTRO
			_typeResist["pinkCloud"]	= 0.00;		// Formerly  19 | D_PINK
			_typeResist["inside"]		= 0.00;		// Formerly 100 | D_INSIDE
			_typeResist["friend"]		= 0.00;		// Formerly 101 | D_FRIEND
		}

		// Return all resistance names
		public function getAllResistanceTypes():Array {
			var keys:Array = [];
			
			for (var key:String in _typeResist) {
				keys.push(key);
			}
			
			return keys;
		}
	}
}
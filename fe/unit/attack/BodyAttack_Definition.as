package fe.unit.attack {

	// Ramming the target with the unit's own body
	public class BodyAttack_Definition {
		public var rangeX:Number			= 100.0;	// How close the target point must be side to side, 0 for any distance the bodies touch at
		public var rangeY:Number			= 80.0;		// How close the target point must be up and down, 0 likewise
		public var chance:Number			= 1.0;		// Chance per tick to strike
		public var strength:Number			= 1.0;		// Damage multiplier
		public var shockedStrength:Number	= 0.0;		// Damage multiplier while the unit is in shock, 0 to not attack
		public var slowSpeed:Number			= 0.0;		// At or below this horizontal speed the hit lands at slowFactor of its strength
		public var slowFactor:Number		= 1.0;
		public var hop:Number				= 0.0;		// Jump strength for a hop at the target on every attack, 0 for none
		public var whileChasing:Boolean		= true;
		public var whileHolding:Boolean		= false;
		public var whileFleeing:Boolean		= false;
		public var whileDashing:Boolean		= false;	// A hit during a dash ends the dash
	}
}
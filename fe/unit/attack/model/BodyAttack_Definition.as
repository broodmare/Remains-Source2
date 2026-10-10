package fe.unit.attack.model {

	// Ramming the target with the unit's own body
	public class BodyAttack_Definition {
		public var rangeX:Number			= 100.0;	// How close the target point must be, side to side
		public var rangeY:Number			= 80.0;		// How close the target point must be, up and down
		public var strength:Number			= 1.0;		// Damage multiplier
		public var shockedStrength:Number	= 0.0;		// Damage multiplier while the unit is in shock, 0 to not attack
		public var hop:Number				= 0.0;		// Jump strength for a hop at the target on every attack, 0 for none
		public var whileChasing:Boolean		= true;
		public var whileHolding:Boolean		= false;
	}
}
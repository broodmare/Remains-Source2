package fe.game.domain.units.attack {

	// Using the unit's current weapon on its target
	public class WeaponAttack_Definition {
		public var cooldown:int				= 0;		// Ticks between uses, on top of the weapon's own rate of fire
		public var chance:Number			= 1.0;		// Chance per tick to strike
		public var rangeX:Number			= 0.0;		// How close the target point must be side to side, 0 for any distance
		public var rangeY:Number			= 0.0;		// How close the target point must be up and down, 0 for any distance
		public var needsTarget:Boolean		= false;	// Only strikes at a target the unit can see
		public var stopsWhenShocked:Boolean	= false;	// Holds off while the unit is in shock
		public var leapAbove:Number			= 0.0;		// Leap straight up before striking a target further above than this, 0 for never
		public var whileChasing:Boolean		= false;
		public var whileHolding:Boolean		= true;
		public var whileFleeing:Boolean		= false;
	}
}
package fe.unit.attack.model {

	// Using the unit's current weapon on its target
	public class WeaponAttack_Definition {
		public var cooldown:int				= 0;		// Ticks between uses, on top of the weapon's own rate of fire
		public var leapAbove:Number			= 0.0;		// Leap straight up before striking a target further above than this, 0 for never
		public var whileChasing:Boolean		= false;
		public var whileHolding:Boolean		= true;
	}
}
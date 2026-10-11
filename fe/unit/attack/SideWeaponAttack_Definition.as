package fe.unit.attack {

	// A second weapon fired on a timer, such as a grenade or a shoulder-mounted launcher
	public class SideWeaponAttack_Definition {
		public var intervalMin:int			= 50;		// Ticks between shots, picked between these
		public var intervalMax:int			= 200;
		public var chance:Number			= 1.0;		// Chance a shot that is due is fired at a target in sight
	}
}
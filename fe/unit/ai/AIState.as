package fe.unit.ai {

	// The states an AI unit moves between
	public class AIState {
		public static const IDLE:int		= 0;		// Standing still, calm
		public static const PATROL:int		= 1;		// Walking back and forth, calm
		public static const SEARCH:int		= 2;		// Alerted, looking for a target it can't see
		public static const CHASE:int		= 3;		// Closing in on a target and attacking it
		public static const HOLD:int		= 4;		// Standing its ground to attack
		public static const SURPRISED:int	= 5;		// Just noticed a target, about to react
		public static const FLEE:int		= 6;		// Running from a danger such as a grenade
		public static const DASH_PREP:int	= 7;		// Standing still, about to dash at the target
		public static const DASH:int		= 8;		// Charging at the target at full speed
	}
}
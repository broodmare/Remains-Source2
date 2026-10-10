package fe.unit.ai.model {

	// The states an AI unit moves between
	public class AIState {
		public static const IDLE:int		= 0;		// Standing still, calm
		public static const PATROL:int		= 1;		// Walking back and forth, calm
		public static const SEARCH:int		= 2;		// Alerted, looking for a target it can't see
		public static const CHASE:int		= 3;		// Closing in on a target and attacking it
		public static const HOLD:int		= 4;		// Standing its ground to attack
		public static const SURPRISED:int	= 5;		// Just noticed a target, about to react
	}
}
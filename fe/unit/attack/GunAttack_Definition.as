package fe.unit.attack {

	// Shooting the unit's current weapon at its target, in single shots or bursts
	public class GunAttack_Definition {
		public var burst:int				= 0;		// Shots in a burst, 0 to fire single shots
		public var singleChance:Number		= 0.1;		// Chance per tick of a single shot at a target in sight
		public var blindChance:Number		= 0.03;		// The same with no target in sight
		public var isSniper:Boolean			= false;	// Fires bursts only at a target in sight, and its aim doesn't loosen on the move
		public var holdSpread:int			= 5;		// Extra spread (mazil) while holding still
		public var moveSpread:int			= 16;		// Extra spread while on the move
		public var isShakenWhenLifted:Boolean	= true;	// While levitated, fires with levitSpread and only as often as levitAttack allows
		public var levitSpread:int			= 25;
		public var whileClimbing:Boolean	= false;	// Keeps shooting while on a ladder
	}
}
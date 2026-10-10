package fe.unit.motor.model {

	// How a walking unit moves: acceleration, jumping, how it handles ledges and walls, what it can climb
	public class WalkMotor_Definition {

		// Acceleration, as fractions of the unit's accel
		public var patrolAccel:Number		= 1.0;		// While wandering
		public var airControl:Number		= 0.25;		// In the air while chasing
		public var walkFriction:Boolean		= false;	// Ground friction keeps dragging on the unit while it walks, so it builds speed slowly

		// Ledges and walls
		public var ledgeThreshold:Number	= 0.25;		// How far over a ledge (fraction of width) a wandering unit goes before it reacts
		public var ledgeTurnChance:Number	= 1.0;		// Chance per tick a wandering unit over a ledge reacts to it, so low values let it wander off
		public var ledgeHopChance:Number	= 0.1;		// Chance a wandering unit hops to solid ground ahead instead of turning back
		public var stopChance:Number		= 0.1;		// Chance a wandering unit stops after turning around
		public var hopsGaps:Boolean			= true;		// A chasing unit hops over gaps
		public var brakesAtLedges:Boolean	= false;	// A chasing unit that doesn't hop a gap slows down at its edge
		public var turnsToTargetAtWall:Boolean	= true;	// A chasing unit that runs into a wall with its target behind turns around at once
		public var wallGiveUpChance:Number	= 0.03;		// Chance per bump that a chasing unit gives up on a wall it can't get past

		// Jumping
		public var jumpToReach:Boolean		= true;		// Jump toward a target above
		public var reachJumpMin:Number		= 1.0;		// Strength of a jump toward a target above, picked between these
		public var reachJumpMax:Number		= 1.0;
		public var looksBeforeJumping:Boolean	= true;	// Check for headroom, the level's edge and a target far below before jumping at a target or a wall
		public var jumpBoost:Number			= 0.0;		// Forward push on a standing jump, as a multiple of accel

		// Climbing ladders, and with climbsWalls also bare walls
		public var climbsLadders:Boolean	= false;
		public var climbsWalls:Boolean		= false;
		public var climbAccel:Number		= 0.33;		// Fraction of lazSpeed gained per tick while climbing
		public var climbRest:int			= 30;		// Ticks off a ladder before a chasing unit tries another one
		public var climbRangeX:Number		= 0.0;		// Only climb toward a target this close horizontally, 0 for any distance
		public var crouchClimb:Boolean		= false;	// Crouch while climbing
		public var wanderClimb:Boolean		= false;	// Climb up and down at random while wandering

		// Crawling under low ceilings
		public var crawls:Boolean			= false;
		public var crawlSpeed:Number		= 1.0;		// Fraction of walkSpeed while crawling during a chase
	}
}
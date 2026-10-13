package fe.game.domain.units.ai {

	// How an AI unit's brain is tuned: how long it stays in each state, how it notices and follows targets
	public class Brain_Definition {

		// Calm behavior
		public var stroll:Boolean			= true;		// Calm units wander back and forth instead of only standing
		public var idleTimeMin:int			= 40;		// Ticks spent standing still before deciding again
		public var idleTimeMax:int			= 90;
		public var patrolTimeMin:int		= 40;		// Ticks spent wandering before deciding again
		public var patrolTimeMax:int		= 90;
		public var chatterChance:Number		= 0.0;		// Chance per tick a calm unit says something to itself

		// Alert behavior
		public var alertTimeMin:int			= 100;		// Ticks spent searching, chasing or holding before deciding again
		public var alertTimeMax:int			= 200;
		public var surpriseTimeMin:int		= 10;		// Ticks between noticing a target and reacting to it
		public var surpriseTimeMax:int		= 50;
		public var turnsWhenSurprised:Boolean	= true;	// A surprised unit stops and faces its target, otherwise it carries on as it was until it reacts
		public var chasesOnSight:Boolean	= true;		// A searching unit that sees its target chases at once, otherwise only once its timer runs out
		public var sightBonus:int			= 10;		// How far above maxSpok seeing a target raises aiSpok, so the unit stays alert longer
		public var wakeRadius:Number		= 500.0;	// Allies inside this range are woken when the unit becomes alert or is lifted, 0 for none
		public var chasesInWater:Boolean	= true;		// Swimming units without this just wander until they reach land
		public var moves:Boolean			= true;		// An alerted unit that doesn't move holds its ground instead of chasing
		public var dropsInAnyState:Boolean	= false;	// Drops through platforms toward a target below whenever it is alert, not only while chasing
		public var freezesAimInAir:Boolean	= false;	// The target's height is only measured while standing, so jumps and flights keep their aim

		// Senses, as multipliers of the unit's own vision
		public var calmVision:Number		= 1.0;
		public var alertVision:Number		= 1.0;
		public var hearsNoise:Boolean		= true;		// Noises draw the unit toward them
		public var looksBehindWhenAlert:Boolean	= false;	// Sees behind itself while searching, chasing, fleeing or dashing, but not while calm
		public var targetMemory:int			= 0;		// Looks after losing sight of a target during which the unit still knows where it is
		public var driftInterval:int		= 1;		// Looks between each wander of the point a searching unit heads for
		public var driftsVertically:Boolean	= false;	// That point wanders up and down as well as side to side
		public var doubtsNoises:Boolean		= false;	// Until it has seen the player, the unit searches silently and soon gives up

		// Speeds: patrol is a fraction of walkSpeed; search and chase are fractions of runSpeed while the unit runs, else walkSpeed
		public var patrolSpeed:Number		= 1.0;
		public var searchSpeed:Number		= 1.0;
		public var chaseSpeed:Number		= 1.0;
		public var fleeSpeed:Number			= 1.5;		// Fraction of runSpeed
		public var dashSpeed:Number			= 2.5;		// Fraction of runSpeed
		public var runsWhenAlert:Boolean	= true;		// Searches and chases at a run
		public var runsOnceSeen:Boolean		= false;	// Without runsWhenAlert, still runs while aiSpok is at maxSpok or above, as after seeing its target

		// Every reaimInterval ticks, with reaimChance, turn toward a target further than reaimDistance to either side
		public var reaimInterval:int		= 15;
		public var reaimChance:Number		= 0.8;
		public var reaimDistance:Number		= 100.0;

		// Reactions
		public var obeysStun:Boolean		= true;		// A stunned unit stops and does nothing until the stun wears off
		public var wakesWhenLifted:Boolean	= true;		// Being levitated sends a calm unit after its target
		public var levitWakeShock:int		= 15;		// Shock when being levitated wakes the unit
		public var levitHoldShock:int		= 15;		// Shock kept up for as long as the unit is levitated, 0 for none
		public var wakesOnAlarm:Boolean		= true;		// Alarms, allies waking up and being hurt send a calm unit after its target
		public var alarmShockMin:int		= 5;		// Shock when an alarm or an ally wakes the unit
		public var alarmShockMax:int		= 20;
		public var alarmWakeRadius:Number	= 0.0;		// Allies inside this range are woken by an alarm too, 0 for none

		// Stand and shoot: at each decision with a recently seen target inside holdRange, hold with holdChance
		public var holdChance:Number		= 0.0;
		public var holdRange:Number			= 0.0;
		public var holdAlertMargin:int		= 0;		// How far above maxSpok aiSpok must be, so only a target seen within the last few looks counts
		public var holdTimeMin:int			= 100;		// Ticks spent holding before deciding again
		public var holdTimeMax:int			= 200;

		// While holding with a target inside backOffRange, leap back from it with backOffChance, then chase
		public var backOffRange:Number		= 0.0;
		public var backOffChance:Number		= 0.0;

		// At each decision with a seen target, stand still for a moment then dash at it, with dashChance
		public var dashChance:Number		= 0.0;

		// Close in, then stop to attack: each tick while chasing a target inside the range, hold with closeHoldChance
		public var closeHoldChance:Number	= 0.0;
		public var closeRangeXMin:Number	= 0.0;
		public var closeRangeX:Number		= 0.0;
		public var closeRangeAbove:Number	= 0.0;
		public var closeRangeBelow:Number	= 0.0;
		public var closeHoldTimeMin:int		= 15;
		public var closeHoldTimeMax:int		= 15;
		public var closeHoldSearching:Boolean	= true;		// Stops to attack while searching too, not only while chasing
		public var closeHoldReleases:Boolean	= false;	// Goes back to chasing as soon as the target leaves the range side to side
	}
}
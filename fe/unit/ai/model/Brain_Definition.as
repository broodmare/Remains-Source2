package fe.unit.ai.model {

	// How an AI unit's brain is tuned: how long it stays in each state, how it notices and follows targets
	public class Brain_Definition {

		// Calm behavior
		public var stroll:Boolean			= true;		// Calm units wander back and forth instead of only standing
		public var idleTimeMin:int			= 40;		// Ticks spent standing still before deciding again
		public var idleTimeMax:int			= 90;
		public var patrolTimeMin:int		= 40;		// Ticks spent wandering before deciding again
		public var patrolTimeMax:int		= 90;

		// Alert behavior
		public var alertTimeMin:int			= 100;		// Ticks spent searching, chasing or holding before deciding again
		public var alertTimeMax:int			= 200;
		public var surpriseTimeMin:int		= 10;		// Ticks between noticing a target and reacting to it
		public var surpriseTimeMax:int		= 50;
		public var sightBonus:int			= 10;		// How far above maxSpok seeing a target raises aiSpok, so the unit stays alert longer
		public var wakeRadius:Number		= 500.0;	// Allies inside this range are woken when the unit becomes alert or is lifted, 0 for none
		public var chasesInWater:Boolean	= true;		// Swimming units without this just wander until they reach land

		// Senses, as multipliers of the unit's own vision
		public var calmVision:Number		= 1.0;
		public var alertVision:Number		= 1.0;
		public var hearsNoise:Boolean		= true;		// Noises draw the unit toward them

		// Speeds: patrol is a fraction of walkSpeed, search and chase are fractions of runSpeed
		public var patrolSpeed:Number		= 1.0;
		public var searchSpeed:Number		= 1.0;
		public var chaseSpeed:Number		= 1.0;

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

		// Close in, then stop to attack: each tick while chasing a target inside the range, hold with closeHoldChance
		public var closeHoldChance:Number	= 0.0;
		public var closeRangeX:Number		= 0.0;
		public var closeRangeAbove:Number	= 0.0;
		public var closeRangeBelow:Number	= 0.0;
		public var closeHoldTimeMin:int		= 15;
		public var closeHoldTimeMax:int		= 15;
	}
}
package fe.unit.anim.model {

	// Which sprite-sheet animation a unit plays in each situation. An empty name means the unit has no such animation
	public class Animator_Definition {

		// On the ground, picked by horizontal speed
		public var stand:String			= "stay";
		public var walk:String			= "walk";		// Faster than walkFrom
		public var trot:String			= "";			// Faster than trotFrom
		public var run:String			= "run";		// Faster than runFrom
		public var walkFrom:Number		= 0.0;
		public var trotFrom:Number		= 0.0;
		public var runFrom:Number		= 6.0;
		public var sit:String			= "";			// Crouched and still
		public var crawl:String			= "";			// Crouched and moving faster than walkFrom

		// Off the ground
		public var jump:String			= "jump";
		public var climb:String			= "";			// On a ladder or wall and moving
		public var climbStill:String	= "";			// On a ladder or wall and still
		public var levitate:String		= "";
		public var swim:String			= "";

		// Dead: "die" when killed on the ground, "death" while falling, "fall" on landing after a falling death
		public var die:String			= "die";
		public var death:String			= "death";
		public var fall:String			= "fall";

		// Footstep patterns for UnitPon.sndStep, 0 for silent
		public var walkStep:int			= 0;
		public var trotStep:int			= 0;
		public var runStep:int			= 0;
		public var crawlStep:int		= 0;
		public var climbStep:int		= 0;
	}
}
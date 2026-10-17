package fe.game.rendering.rig {

	import flash.utils.Dictionary;

	// One animation, sampled once per frame: the pose of every node it moves, and what each frame does when played
	public class RigAnimation_Definition {
		public var name:String;
		public var frameCount:int							= 0;
		public var nodes:Vector.<int>						= new Vector.<int>();		// The nodes it moves
		public var poses:Vector.<Number>					= new Vector.<Number>();	// Per frame, per moved node: x, y, depth, angle, scaleX, scaleY
		public var heldScales:Vector.<Boolean>				= new Vector.<Boolean>();	// Per moved node, its scale jumps from frame to frame: a drawing shown or hidden
		public var colorNodes:Vector.<int>					= new Vector.<int>();		// The bones it colours: their drawings are multiplied by the colour
		public var colors:Vector.<Number>					= new Vector.<Number>();	// Per frame, per coloured bone: red, green, blue, alpha multipliers
		public var shows:Vector.<int>;													// Per frame, the frame shown when the playhead reaches it: itself, or where its script jumps
		public var stops:Vector.<Boolean>;												// Per frame, whether the playhead stops once it reaches it
		public var events:Vector.<Vector.<String>>;										// Per frame, the switches it sets as pairs of switch and state, or null
		public var labels:Dictionary						= new Dictionary();			// Frame by label
	}
}
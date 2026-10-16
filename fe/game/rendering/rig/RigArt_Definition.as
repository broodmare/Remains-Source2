package fe.game.rendering.rig {

	import flash.utils.Dictionary;

	// How a rig is dressed, read from its JSON: every image's pivot, the drawings and what they wear, the switches and armour
	public class RigArt_Definition {
		public var density:Number							= 1.0;					// Image pixels per game pixel
		public var pivots:Dictionary						= new Dictionary();		// Per image key, [x, y]: its origin, in its pixels
		public var styleCounts:Dictionary					= new Dictionary();		// How many styles each style group has
		public var drawings:Dictionary						= new Dictionary();		// RigDrawing_Definition by name
		public var switches:Vector.<RigSwitch_Definition>	= new Vector.<RigSwitch_Definition>();
		public var armor:Dictionary							= new Dictionary();		// RigArmor_Definition by id
	}
}

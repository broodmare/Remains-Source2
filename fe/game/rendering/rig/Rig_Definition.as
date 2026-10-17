package fe.game.rendering.rig {

	import flash.utils.Dictionary;

	// A rig's nodes and animations, read from glTF. Bones are nodes, and each drawing hangs on its own node under a bone. Positions are in game pixels with y pointing down.
	public class Rig_Definition {
		public var names:Vector.<String>		= new Vector.<String>();	// Per node
		public var byName:Dictionary			= new Dictionary();			// Node index by name
		public var parents:Vector.<int>			= new Vector.<int>();		// Per node, -1 for the root
		public var order:Vector.<int>			= new Vector.<int>();		// Every node after its parent
		public var rest:Vector.<Number>			= new Vector.<Number>();	// Per node, the pose without animation: x, y, depth, angle, scaleX, scaleY
		public var drawings:Vector.<String>		= new Vector.<String>();	// Per node, the drawing it shows, or null for a bone
		public var animations:Dictionary		= new Dictionary();			// RigAnimation_Definition by name
		public var fps:Number					= 30.0;						// Frames per second the animations are sampled and played at
	}
}
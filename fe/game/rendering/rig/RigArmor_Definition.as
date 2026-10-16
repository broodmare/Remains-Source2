package fe.game.rendering.rig {

	import flash.utils.Dictionary;

	// One armour set: the image it lays over each drawing, the bare images it replaces and the drawings it hides
	public class RigArmor_Definition {
		public var id:String;
		public var images:Dictionary			= new Dictionary();		// Image key by drawing
		public var coversBase:Vector.<String>	= new Vector.<String>();
		public var hides:Vector.<String>		= new Vector.<String>();
	}
}

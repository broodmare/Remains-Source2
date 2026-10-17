package fe.game.rendering.rig {

	// What one drawing wears: an image in each style (or a loop of frames), and how it is tinted, placed and clipped
	public class RigDrawing_Definition {
		public var name:String;
		public var images:Vector.<Vector.<String>>		= new Vector.<Vector.<String>>();	// Per style, the image keys of its frames
		public var placements:Vector.<Vector.<Number>>;										// Per style, a matrix (a, b, c, d, tx, ty) placing the image on its node, or null to sit on its origin
		public var style:String							= "";		// The style group that picks among its images, or "" when it has one
		public var tint:String							= "";		// The colour it is multiplied by, by name, or "" for none
		public var isMask:Boolean						= false;	// Never drawn: it clips the drawings masked by it
		public var maskedBy:String						= "";		// The mask drawing that clips it, or ""
		public var isArmorOnly:Boolean					= false;	// Only an armour's image is drawn here
		public var loopFrom:int							= 0;		// For a loop of frames: the frame it goes back to after the last
	}
}
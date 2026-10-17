package fe.game.rendering {

	import flash.geom.Matrix;

	// An effect an object's flipbook shows over its images on some of its frames, placed and faded per frame as Flash placed the clip it stands in for
	public class FlipbookEffect_Definition {
		public var effect:Flipbook_Definition;
		public var blend:String = "normal";		// The Starling blend mode it draws with
		public var matrices:Vector.<Matrix>;		// Per frame of the object, where the effect goes in it; null where it doesn't show
		public var alphas:Vector.<Number>;			// Per frame of the object, how opaque it is
	}
}
package fe.game.rendering {

	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.utils.Dictionary;

	import starling.textures.Texture;

	// One flipbook, from data/core/spritesheets/objects or keyed from an effect in effects.json: its images, and how its frames play
	public class Flipbook_Definition {
		public var name:String;
		public var density:Number								= 1.0;			// Sheet pixels per game pixel
		public var width:Number									= 0.0;			// The first frame's size, in game pixels
		public var height:Number								= 0.0;
		public var blend:String									= "normal";		// The Starling blend mode it draws with
		public var sheet:Texture;												// Every image's texture is part of it
		public var frames:Vector.<Vector.<FlipbookImage>>;						// Per frame, its image on each tick of its own loop; null where a tick draws nothing
		public var screenFrames:Vector.<Vector.<FlipbookImage>>;				// Per frame, its screen-blended images, likewise; null when it has none
		public var shows:Vector.<int>;											// Per frame, the frame shown when the playhead reaches it: itself, or where its script jumps
		public var stops:Vector.<Boolean>;										// Per frame, whether the playhead stops once it reaches it
		public var labels:Dictionary							= new Dictionary();	// Frame by label
		public var placements:Vector.<Matrix>;									// Per frame, where its image goes after its pivot, for keyed flipbooks; else null
		public var tints:Vector.<ColorTransform>;								// Per frame, its own tint or null; null when no frame has one
		public var randomTurns:Vector.<Boolean>;								// Per frame, whether reaching it turns its images to a random angle, as a script turning the clip did; null when none does
		public var effects:Vector.<FlipbookEffect_Definition>;					// Effects drawn over its images on some frames; null when it has none
	}
}
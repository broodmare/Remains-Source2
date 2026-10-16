package fe.game.rendering {

	import flash.utils.Dictionary;

	import starling.textures.Texture;

	// One flipbook from Modules/core/spritesheets/objects: its images on one sheet, and how its frames play
	public class Flipbook_Definition {
		public var name:String;
		public var density:Number								= 1.0;			// Sheet pixels per game pixel
		public var width:Number									= 0.0;			// The first frame's size, in game pixels
		public var height:Number								= 0.0;
		public var blend:String									= "normal";		// The Starling blend mode it draws with
		public var sheet:Texture;												// Every image's texture is part of it
		public var frames:Vector.<Vector.<FlipbookImage>>;						// Per frame, its image on each tick of its own loop; null where a tick draws nothing
		public var screenFrames:Vector.<Vector.<FlipbookImage>>;				// Per frame, its screen-blended images, likewise; null when it has none
		public var shadow:FlipbookImage;										// The drop shadow boxes cast under their first frame, or null
		public var shows:Vector.<int>;											// Per frame, the frame shown when the playhead reaches it: itself, or where its script jumps
		public var stops:Vector.<Boolean>;										// Per frame, whether the playhead stops once it reaches it
		public var labels:Dictionary							= new Dictionary();	// Frame by label
	}
}
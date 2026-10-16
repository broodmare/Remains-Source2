package fe.game.rendering {

	import flash.geom.Rectangle;

	import starling.textures.Texture;

	// One image of a flipbook: its part of the sheet, and where the flipbook's origin lies on it, in game pixels
	public class FlipbookImage {
		public var texture:Texture;
		public var pivotX:Number;
		public var pivotY:Number;
		public var region:Rectangle;	// Its part of the sheet in sheet pixels, for sheets also kept on the CPU; else null

		public function FlipbookImage(texture_:Texture, pivotX_:Number, pivotY_:Number) {
			texture	= texture_;
			pivotX	= pivotX_;
			pivotY	= pivotY_;
		}
	}
}
package fe.game.rendering {

	import flash.geom.Rectangle;

	import starling.textures.SubTexture;
	import starling.textures.Texture;

	// One clip rasterized into a ClipAtlas: its texture, and where that texture sits relative to the clip's origin
	public class AtlasClip {
		public var texture:Texture;
		public var offsetX:Number;		// Left edge of the texture, from the clip's origin
		public var offsetY:Number;		// Top edge of the texture, from the clip's origin
		public var width:Number;
		public var height:Number;
		public var pageLeft:Number;		// The texture's edges in its atlas page's texture coordinates, 0 to 1
		public var pageTop:Number;
		public var pageRight:Number;
		public var pageBottom:Number;

		public function AtlasClip(texture_:SubTexture, offsetX_:Number, offsetY_:Number) {
			var region:Rectangle = texture_.region;

			texture		= texture_;
			offsetX		= offsetX_;
			offsetY		= offsetY_;
			width		= texture.width;
			height		= texture.height;
			pageLeft	= region.left / texture.root.width;
			pageTop		= region.top / texture.root.height;
			pageRight	= region.right / texture.root.width;
			pageBottom	= region.bottom / texture.root.height;
		}
	}
}
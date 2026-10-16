package fe.game.rendering {

	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.geom.Matrix;
	import flash.geom.Point;

	import starling.textures.Texture;
	import starling.utils.MathUtil;

	// A loose texture laid out for repeating on the GPU at its own pixels, whatever its size.
	// Copies of it fill a power-of-two texture so it gets mipmaps. The copy GUTTER pixels in is the one sampled, and the copies around it keep filtering seamless at its edges.
	public class RepeatingTexture {

		private static const GUTTER:int = 4;		// Pixels of the neighbouring copies around the sampled one, enough for the first mip levels

		public var texture:Texture;
		public var drawWidth:Number;				// How big one copy draws in the room
		public var drawHeight:Number;
		public var left:Number;						// The sampled copy, in texture coordinates
		public var top:Number;
		public var width:Number;
		public var height:Number;

		private static function fill(texture:Texture, bitmap:BitmapData):void {
			var canvas:BitmapData = new BitmapData(texture.root.nativeWidth, texture.root.nativeHeight, bitmap.transparent, 0);
			var copies:Shape = new Shape();

			copies.graphics.beginBitmapFill(bitmap, new Matrix(1.0, 0.0, 0.0, 1.0, GUTTER, GUTTER), true, false);
			copies.graphics.drawRect(0.0, 0.0, canvas.width, canvas.height);
			canvas.draw(copies);
			texture.root.uploadBitmapData(canvas);
			canvas.dispose();
		}

		public function RepeatingTexture(bitmap:BitmapData, drawSize:Point) {
			var canvasWidth:int = MathUtil.getNextPowerOfTwo(bitmap.width + GUTTER * 2);
			var canvasHeight:int = MathUtil.getNextPowerOfTwo(bitmap.height + GUTTER * 2);

			texture = Texture.empty(canvasWidth, canvasHeight, true, true, false, 1.0);
			fill(texture, bitmap);
			texture.root.onRestore = function():void { fill(texture, bitmap); };

			drawWidth	= drawSize.x;
			drawHeight	= drawSize.y;
			left		= GUTTER / canvasWidth;
			top			= GUTTER / canvasHeight;
			width		= bitmap.width / canvasWidth;
			height		= bitmap.height / canvasHeight;
		}
	}
}
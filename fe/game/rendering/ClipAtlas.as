package fe.game.rendering {

	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	import starling.textures.SubTexture;
	import starling.textures.Texture;

	// Rasterizes vector clips into GPU textures, packed in rows across fixed-size pages
	public class ClipAtlas {

		private var pageSize:int;					// Width and height of a page, in pixels
		private var scale:Number;					// Pixels per room pixel
		private var mipmapped:Boolean;				// Pages get mipmaps, for clips drawn smaller than they were rasterized
		private var padding:int;					// Transparent border around each clip, so smoothing never samples a neighbour, even in the smaller mipmaps
		private var bitmaps:Vector.<BitmapData>	= new Vector.<BitmapData>();
		private var textures:Vector.<Texture>	= new Vector.<Texture>();
		private var changed:Vector.<Boolean>	= new Vector.<Boolean>();	// Drawn into since the last upload
		private var clips:Object				= {};						// AtlasClip by key
		private var rowX:int;						// Where the next clip goes on the last page
		private var rowY:int;
		private var rowHeight:int;

		private function addPage():void {
			var bitmap:BitmapData = new BitmapData(pageSize, pageSize, true, 0);
			var texture:Texture = Texture.empty(pageSize / scale, pageSize / scale, true, mipmapped, false, scale);

			texture.root.onRestore = function():void { texture.root.uploadBitmapData(bitmap); };
			bitmaps.push(bitmap);
			textures.push(texture);
			changed.push(true);
			rowX		= 0;
			rowY		= 0;
			rowHeight	= 0;
		}

		// The clip's bounds once matrix places it, in room pixels
		private static function placedBounds(clip:DisplayObject, matrix:Matrix):Rectangle {
			var local:Rectangle = clip.getBounds(clip);
			var corner:Point;
			var placed:Rectangle = new Rectangle();
			var left:Number = Number.MAX_VALUE;
			var top:Number = Number.MAX_VALUE;
			var right:Number = -Number.MAX_VALUE;
			var bottom:Number = -Number.MAX_VALUE;
			var i:int;

			for (i = 0; i < 4; i++) {
				corner = matrix.transformPoint(new Point((i & 1) != 0 ? local.right : local.left, (i & 2) != 0 ? local.bottom : local.top));
				left	= Math.min(left, corner.x);
				top		= Math.min(top, corner.y);
				right	= Math.max(right, corner.x);
				bottom	= Math.max(bottom, corner.y);
			}
			placed.setTo(left, top, right - left, bottom - top);

			return placed;
		}

		public function ClipAtlas(pageSize_:int, scale_:Number, mipmapped_:Boolean = false) {
			pageSize	= pageSize_;
			scale		= scale_;
			mipmapped	= mipmapped_;
			padding		= mipmapped ? 8 : 1;
		}

		// Rasterizes clip where matrix places it, cut to area if given, over a background colour if given.
		// Returns the clip already added under key, or null when nothing shows.
		public function add(key:String, clip:DisplayObject, matrix:Matrix, colorTransform:ColorTransform = null, area:Rectangle = null, background:uint = 0):AtlasClip {
			var bounds:Rectangle;
			var left:int;
			var top:int;
			var width:int;
			var height:int;
			var page:int;
			var drawMatrix:Matrix;
			var region:Rectangle;
			var atlasClip:AtlasClip;

			if (clips[key] !== undefined) { return clips[key]; }

			bounds = placedBounds(clip, matrix);
			if (area) {
				bounds = bounds.intersection(area);
			}

			if (bounds.isEmpty()) {
				clips[key] = null;
				return null;
			}

			left	= Math.floor(bounds.left * scale);
			top		= Math.floor(bounds.top * scale);
			width	= Math.ceil(bounds.right * scale) - left + padding * 2;
			height	= Math.ceil(bounds.bottom * scale) - top + padding * 2;

			if (width > pageSize || height > pageSize) {
				trace("ClipAtlas.as/add() - Warning: \"" + key + "\" is " + width + "x" + height + " pixels, larger than a " + pageSize + " page, so it is not drawn");
				clips[key] = null;
				return null;
			}

			if (bitmaps.length == 0) {
				addPage();
			}
			if (rowX + width > pageSize) {
				rowX = 0;
				rowY += rowHeight;
				rowHeight = 0;
			}
			if (rowY + height > pageSize) {
				addPage();
			}
			page = bitmaps.length - 1;

			drawMatrix = matrix.clone();
			drawMatrix.scale(scale, scale);
			drawMatrix.translate(rowX + padding - left, rowY + padding - top);
			region = new Rectangle(rowX, rowY, width, height);
			bitmaps[page].fillRect(region, background);
			bitmaps[page].draw(clip, drawMatrix, colorTransform, null, region, true);
			changed[page] = true;

			region.setTo(rowX / scale, rowY / scale, width / scale, height / scale);
			atlasClip = new AtlasClip(new SubTexture(textures[page], region), (left - padding) / scale, (top - padding) / scale);
			clips[key] = atlasClip;

			rowX += width;
			rowHeight = Math.max(rowHeight, height);

			return atlasClip;
		}

		// Sends the pages drawn into since the last upload to the GPU; nothing added shows until this runs
		public function upload():void {
			var i:int;

			for (i = 0; i < bitmaps.length; i++) {
				if (changed[i]) {
					textures[i].root.uploadBitmapData(bitmaps[i]);
					changed[i] = false;
				}
			}
		}

		public function dispose():void {
			var i:int;

			for (i = 0; i < bitmaps.length; i++) {
				textures[i].dispose();
				bitmaps[i].dispose();
			}
			bitmaps.length	= 0;
			textures.length	= 0;
			changed.length	= 0;
			clips			= {};
		}
	}
}
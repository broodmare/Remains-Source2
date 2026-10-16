package fe.game.rendering {

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.filters.GlowFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;

	import starling.display.Image;
	import starling.display.Sprite;
	import starling.filters.FragmentFilter;
	import starling.textures.TextureSmoothing;

	// A unit's body on the GPU: one frame of its sprite sheet at a time, picked by the unit's code. The unit places, turns
	// and fades the sprite; flipbooks it carries, such as a shield, are children drawn over the body.
	public class UnitArt extends Sprite {

		private static const MIP_BIAS:Number = -0.5;		// Sheets drawn smaller than their pixels sample a little sharp, as Flipbook's do

		private var manager:UnitSheetManager;
		private var body:Image;								// Made once the sheet is on the GPU
		private var shown:FlipbookImage;					// The frame on show, or null before the first
		private var tint:ColorTransform;					// The body's, kept until the body is made
		private var bodyFilter:FragmentFilter;				// Likewise
		private var placement:Matrix	= new Matrix();		// Scratch for sheets with a transform
		private var hasWarned:Boolean	= false;			// A missing frame is reported once

		public var definition:UnitSheet_Definition;
		public var smoothing:String		= TextureSmoothing.BILINEAR;	// How a 1x sheet is sampled; set before the first frame shows

		private function createBody():void {
			var style:TintStyle = new TintStyle();

			body = new Image(shown.texture);
			style.tint = tint;
			if (definition.density > 1.0) {
				style.mipBias = MIP_BIAS;
				body.textureSmoothing = TextureSmoothing.TRILINEAR;
			}
			else {
				body.textureSmoothing = smoothing;
			}
			body.style = style;
			body.filter = bodyFilter;
			body.touchable = false;
			addChildAt(body, 0);
		}

		// Puts the shown frame's pivot on the unit's origin, through the sheet's transform if it has one
		private function place():void {
			if (definition.transform) {
				placement.setTo(1.0, 0.0, 0.0, 1.0, -shown.pivotX, -shown.pivotY);
				placement.concat(definition.transform);
				body.transformationMatrix = placement;
			}
			else {
				body.pivotX = shown.pivotX;
				body.pivotY = shown.pivotY;
			}
		}

		public function UnitArt(manager_:UnitSheetManager, definition_:UnitSheet_Definition) {
			manager		= manager_;
			definition	= definition_;
			touchable	= false;
		}

		// Shows a frame of one of the sheet's animations, by its column on the original sheet. Until the sheet is on the GPU
		// the body stays hidden.
		public function show(animation:String, column:int):void {
			var frames:Vector.<FlipbookImage> = definition.animations[animation];
			var frame:FlipbookImage = (frames && column >= 0 && column < frames.length) ? frames[column] : null;

			if (!frame) {
				if (!hasWarned) {
					trace("UnitArt.as/show() - Warning: sheet \"" + definition.name + "\" has no frame " + column + " of \"" + animation + "\", so the unit keeps its last frame");
					hasWarned = true;
				}
				return;
			}

			if (!definition.texture) {
				manager.prepare(definition);
			}
			if (!definition.texture) {
				if (body) {
					body.visible = false;
				}
				return;
			}

			shown = frame;
			if (!body) {
				createBody();
			}
			else if (body.texture != frame.texture) {
				body.texture = frame.texture;
				body.readjustSize();
			}
			else {
				return;
			}
			body.visible = true;
			place();
		}

		// Draws the body and what it carries through a Flash colour transform, or in their own colours for null
		public function setTint(tint_:ColorTransform):void {
			var flipbook:Flipbook;
			var i:int;

			tint = tint_;
			if (body) {
				TintStyle(body.style).tint = tint;
			}
			for (i = 0; i < numChildren; i++) {
				flipbook = getChildAt(i) as Flipbook;
				if (flipbook) {
					flipbook.setTint(tint);
				}
			}
		}

		// Surrounds the body and what it carries with a glow, or takes it away for null
		public function setGlow(glow:GlowFilter):void {
			if (filter) {
				filter.dispose();
			}
			filter = glow ? GpuFilters.fromFlash([glow], 1.0) : null;
		}

		// Surrounds the body alone, not what it carries, with a glow, or takes it away for null
		public function setBodyGlow(glow:GlowFilter):void {
			if (bodyFilter) {
				bodyFilter.dispose();
			}
			bodyFilter = glow ? GpuFilters.fromFlash([glow], 1.0) : null;
			if (body) {
				body.filter = bodyFilter;
			}
		}

		// Carries a flipbook over the body and anything carried before it, in the art's tint
		public function carry(flipbook:Flipbook):void {
			flipbook.setTint(tint);
			addChild(flipbook);
		}

		// Moves on every flipbook it carries, as Flash moves nested clips on with their parent
		public function advance():void {
			var flipbook:Flipbook;
			var i:int;

			for (i = 0; i < numChildren; i++) {
				flipbook = getChildAt(i) as Flipbook;
				if (flipbook) {
					flipbook.advance();
				}
			}
		}

		// The frame on show as a Flash bitmap, through colorTransform unless null, placed as the art places it before its
		// own position, scale and turn. Empty before the first frame shows.
		public function snapshot(colorTransform:ColorTransform):Bitmap {
			var pixels:BitmapData;
			var result:Bitmap;
			var matrix:Matrix;

			if (!shown || !definition.bitmap) {
				trace("UnitArt.as/snapshot() - Warning: sheet \"" + definition.name + "\" has no frame on show yet, so the snapshot is empty");
				return new Bitmap(new BitmapData(1, 1, true, 0));
			}

			pixels = new BitmapData(shown.region.width, shown.region.height, true, 0);
			pixels.copyPixels(definition.bitmap, shown.region, new Point());
			if (colorTransform) {
				pixels.colorTransform(pixels.rect, colorTransform);
			}

			matrix = new Matrix(1.0 / definition.density, 0.0, 0.0, 1.0 / definition.density, -shown.pivotX, -shown.pivotY);
			if (definition.transform) {
				matrix.concat(definition.transform);
			}
			matrix.translate(-pivotX, -pivotY);
			result = new Bitmap(pixels);
			result.transform.matrix = matrix;

			return result;
		}
	}
}
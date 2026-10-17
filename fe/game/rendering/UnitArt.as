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

	import fe.engine.utils.Numbers;

	// A unit's body on the GPU: one frame of its sprite sheet at a time, picked by the unit's code or played as an
	// animation. The unit places, turns and fades the sprite, and can turn the body inside it about the sheet's hub, as
	// Flash turned a unit clip's inner body. What it carries, such as a shield, is drawn over the body.
	public class UnitArt extends Sprite {

		private static const MIP_BIAS:Number = -0.5;		// Sheets drawn smaller than their pixels sample a little sharp, as Flipbook's do

		private var manager:UnitSheetManager;
		private var body:Image;								// Made once the sheet is on the GPU
		private var shown:FlipbookImage;					// The frame on show, or null before the first
		private var shownTransform:Matrix;					// The shown frame's animation's state transform, if it has one
		private var wanted:FlipbookImage;					// The frame asked for, shown as soon as the sheet is on the GPU
		private var wantedAnimation:String	= "";
		private var playing:Vector.<FlipbookImage>;			// The animation play() started, or null while a frame is held
		private var playingName:String	= "";
		private var playFrame:int		= 0;
		private var playsLeft:int		= 0;				// Plays left before it rests on its last frame, or 0 to loop
		private var bodyRotation:Number	= 0.0;				// In radians, about the hub
		private var bodyScale:Number	= 1.0;				// About the hub
		private var tint:ColorTransform;					// The body's, kept until the body is made
		private var bodyFilter:FragmentFilter;				// Likewise
		private var placement:Matrix	= new Matrix();		// Scratch
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

		// Where the shown frame's game pixels go in the art's space: its pivot on the unit's origin, through its state's
		// transform and the sheet's, then turned and scaled about the hub
		private function placeShown(target:Matrix):void {
			target.setTo(1.0, 0.0, 0.0, 1.0, -shown.pivotX, -shown.pivotY);
			if (shownTransform) {
				target.concat(shownTransform);
			}
			if (definition.transform) {
				target.concat(definition.transform);
			}
			if (bodyRotation != 0.0 || bodyScale != 1.0) {
				target.translate(-definition.hubX, -definition.hubY);
				target.scale(bodyScale, bodyScale);
				target.rotate(bodyRotation);
				target.translate(definition.hubX, definition.hubY);
			}
		}

		private function place():void {
			placeShown(placement);
			body.transformationMatrix = placement;
		}

		// Shows the frame asked for. Until the sheet is on the GPU the body stays hidden, and each advance() tries again.
		private function display():void {
			var stateTransform:Matrix;

			if (!wanted) { return; }

			if (!definition.texture) {
				manager.prepare(definition);
			}
			if (!definition.texture) {
				if (body) {
					body.visible = false;
				}
				return;
			}

			stateTransform = definition.stateTransforms[wantedAnimation];
			if (body && body.visible && body.texture == wanted.texture && stateTransform == shownTransform) { return; }

			shown = wanted;
			shownTransform = stateTransform;
			if (!body) {
				createBody();
			}
			else {
				body.texture = shown.texture;
				body.readjustSize();
			}
			body.visible = true;
			place();
		}

		public function UnitArt(manager_:UnitSheetManager, definition_:UnitSheet_Definition) {
			manager		= manager_;
			definition	= definition_;
			touchable	= false;
		}

		// Holds a frame of one of the sheet's animations, by its column on the original sheet
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

			playing = null;
			playingName = "";
			wanted = frame;
			wantedAnimation = animation;
			display();
		}

		// Plays one of the sheet's animations from frame from, unless it is playing it already. It loops, or rests on its
		// last frame once it has played as often as the sheet says.
		public function play(animation:String, from:int = 0):void {
			var frames:Vector.<FlipbookImage> = definition.animations[animation];

			if (animation == playingName) { return; }

			if (!frames || frames.length == 0) {
				if (!hasWarned) {
					trace("UnitArt.as/play() - Warning: sheet \"" + definition.name + "\" has no animation \"" + animation + "\", so the unit keeps its last frame");
					hasWarned = true;
				}
				return;
			}

			playing			= frames;
			playingName		= animation;
			playFrame		= from;
			playsLeft		= int(definition.repeats[animation]);
			wanted			= frames[from];
			wantedAnimation	= animation;
			display();
		}

		// How many frames one of the sheet's animations has, 0 for one it lacks
		public function frameCount(animation:String):int {
			var frames:Vector.<FlipbookImage> = definition.animations[animation];

			return frames ? frames.length : 0;
		}

		// Turns the body about the sheet's hub, in degrees clockwise as drawn: the unit's facing mirrors the turn too
		public function setBodyRotation(degrees:Number):void {
			bodyRotation = degrees * Numbers.DEG_TO_RAD;
			if (shown) {
				place();
			}
		}

		// Scales the body about the sheet's hub
		public function setBodyScale(scale:Number):void {
			bodyScale = scale;
			if (shown) {
				place();
			}
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

		// Draws the art and what it carries through Flash filters, as near as the GPU's come, or plainly for null
		public function setFilters(filters:Array):void {
			if (filter) {
				filter.dispose();
			}
			filter = filters ? GpuFilters.fromFlash(filters, 1.0) : null;
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

		// One frame: the animation playing moves on, and so does everything carried, as Flash moves nested clips on with
		// their parent
		public function advance():void {
			var flipbook:Flipbook;
			var i:int;

			if (playing) {
				if (playFrame + 1 < playing.length) {
					playFrame++;
				}
				else if (playsLeft != 1) {
					playFrame = 0;
					if (playsLeft > 1) {
						playsLeft--;
					}
				}
				wanted = playing[playFrame];
			}
			display();

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

			matrix = new Matrix(1.0 / definition.density, 0.0, 0.0, 1.0 / definition.density, 0.0, 0.0);
			placeShown(placement);
			matrix.concat(placement);
			matrix.translate(-pivotX, -pivotY);
			result = new Bitmap(pixels);
			result.transform.matrix = matrix;

			return result;
		}
	}
}
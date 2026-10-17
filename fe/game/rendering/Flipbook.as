package fe.game.rendering {

	import flash.geom.ColorTransform;
	import flash.geom.Matrix;

	import starling.display.BlendMode;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.TextureSmoothing;

	import fe.engine.utils.Numbers;

	// An object's art on the GPU: a flipbook played like a Flash timeline. The playhead moves on in advance(), and stops and
	// jumps where the timeline's scripts did. A frame can hold a loop of images, which runs on the flipbook's own clock, and
	// effects drawn over them, each starting over when a frame shows it after one that didn't.
	public class Flipbook extends Sprite {

		private static const MIP_BIAS:Number = -0.5;	// Art drawn smaller than its sheet samples a little sharp, as the rig does: closest to Flash

		private var definition:Flipbook_Definition;
		private var image:Image;						// The frame's image
		private var screenImage:Image;					// The frame's screen-blended image, for flipbooks that have them
		private var effects:Vector.<Flipbook>;			// The definition's effects, in its order; null when it has none
		private var ticks:int = 0;						// advance() calls so far: the clock of each frame's own loop
		private var placement:Matrix = new Matrix();	// Scratch: a keyed frame's placement after its image's pivot
		private var tint:ColorTransform;				// Set by setTint
		private var turn:Number = 0.0;					// In radians, the random angle the last frame with a random turn gave its images
		private var frameTint:ColorTransform = new ColorTransform();	// Scratch: a keyed frame's own tint, then the flipbook's

		public var frame:int = 0;						// The playhead, counted from 0. Read it; move it with goTo().
		public var isPlaying:Boolean = true;			// Whether advance() moves the playhead on. A new flipbook plays, as a new Flash clip does.

		// An image of the definition's sheet, drawn through a tint
		private function createImage(blend:String):Image {
			var created:Image = new Image(definition.sheet);
			var style:TintStyle = new TintStyle();

			if (definition.density > 1.0) {
				style.mipBias = MIP_BIAS;
				created.textureSmoothing = TextureSmoothing.TRILINEAR;
			}
			created.style = style;
			// A normal image takes the flipbook's own blend mode, so a flipbook placed with another draws with it
			created.blendMode = (blend == BlendMode.NORMAL) ? BlendMode.AUTO : blend;
			created.touchable = false;
			addChild(created);

			return created;
		}

		// Shows the loop's image for this tick in target, placed as the frame is, or hides target when the tick draws nothing
		private function show(target:Image, loop:Vector.<FlipbookImage>):void {
			var shown:FlipbookImage = loop.length > 0 ? loop[ticks % loop.length] : null;

			target.visible = shown != null;
			if (!shown) { return; }

			if (target.texture != shown.texture) {
				target.texture = shown.texture;
				target.readjustSize();
				target.pivotX = shown.pivotX;
				target.pivotY = shown.pivotY;
			}
			if (definition.placements) {
				placement.setTo(1.0, 0.0, 0.0, 1.0, -shown.pivotX, -shown.pivotY);
				placement.concat(definition.placements[frame]);
				placement.rotate(turn);
				target.transformationMatrix = placement;
			}
		}

		// The frame's own tint, if it has one, under the flipbook's
		private function applyTint():void {
			var own:ColorTransform = definition.tints ? definition.tints[frame] : null;
			var applied:ColorTransform = tint;

			if (own) {
				frameTint.redMultiplier		= own.redMultiplier;
				frameTint.greenMultiplier	= own.greenMultiplier;
				frameTint.blueMultiplier	= own.blueMultiplier;
				frameTint.alphaMultiplier	= own.alphaMultiplier;
				frameTint.redOffset			= own.redOffset;
				frameTint.greenOffset		= own.greenOffset;
				frameTint.blueOffset		= own.blueOffset;
				frameTint.alphaOffset		= own.alphaOffset;
				if (tint) {
					frameTint.concat(tint);
				}
				applied = frameTint;
			}
			TintStyle(image.style).tint = applied;
			if (screenImage) {
				TintStyle(screenImage.style).tint = applied;
			}
		}

		private function draw():void {
			show(image, definition.frames[frame]);
			if (screenImage) {
				show(screenImage, definition.screenFrames[frame]);
			}
			if (definition.tints) {
				applyTint();
			}
		}

		// Shows, places and fades the effects the frame has, and hides the rest
		private function placeEffects():void {
			var matrix:Matrix;
			var i:int;

			for (i = 0; i < effects.length; i++) {
				matrix = definition.effects[i].matrices[frame];
				if (!matrix) {
					effects[i].visible = false;
					continue;
				}
				if (!effects[i].visible) {
					effects[i].goTo(0, true);
				}
				effects[i].visible = true;
				effects[i].transformationMatrix = matrix;
				effects[i].alpha = definition.effects[i].alphas[frame];
			}
		}

		private function enter(target:int):void {
			frame = definition.shows[target];
			if (definition.stops[target]) {
				isPlaying = false;
			}
			if (definition.randomTurns && definition.randomTurns[frame]) {
				turn = Math.random() * Numbers.TWO_PI;
			}
			draw();
			if (effects) {
				placeEffects();
			}
		}

		public function Flipbook(definition_:Flipbook_Definition) {
			var placed:FlipbookEffect_Definition;
			var effect:Flipbook;

			definition	= definition_;
			image		= createImage(definition.blend);
			if (definition.screenFrames) {
				screenImage = createImage(BlendMode.SCREEN);
			}
			if (definition.effects) {
				effects = new Vector.<Flipbook>();
				for each (placed in definition.effects) {
					effect = new Flipbook(placed.effect);
					effect.blendMode = placed.blend;
					effect.visible = false;
					addChild(effect);
					effects.push(effect);
				}
			}
			touchable = false;
			enter(0);
		}

		public function get frameCount():int {
			return definition.frames.length;
		}

		// Moves the playhead to target (counted from 0), playing on from there or holding it
		public function goTo(target:int, play:Boolean):void {
			if (target < 0 || target >= definition.frames.length) {
				trace("Flipbook.as/goTo() - Warning: flipbook \"" + definition.name + "\" has no frame " + target);
				return;
			}
			isPlaying = play;
			// As in Flash, going to the frame already shown doesn't run its script again
			if (target == frame) {
				draw();
				return;
			}
			enter(target);
		}

		// Moves the playhead to a label's frame, playing on from there or holding it
		public function goToLabel(label:String, play:Boolean):void {
			if (definition.labels[label] === undefined) {
				trace("Flipbook.as/goToLabel() - Warning: flipbook \"" + definition.name + "\" has no label \"" + label + "\"");
				return;
			}
			goTo(int(definition.labels[label]), play);
		}

		// One frame: the playhead and the frames' own loops move on, and so do the effects on show, as nested clips do
		public function advance():void {
			var effect:Flipbook;

			ticks++;
			for each (effect in effects) {
				if (effect.visible) {
					effect.advance();
				}
			}
			if (isPlaying) {
				enter(frame + 1 < definition.frames.length ? frame + 1 : 0);
			}
			else {
				draw();
			}
		}

		// Draws the flipbook through a Flash colour transform, or in its own colours for null
		public function setTint(tint_:ColorTransform):void {
			var effect:Flipbook;

			tint = tint_;
			applyTint();
			for each (effect in effects) {
				effect.setTint(tint);
			}
		}
	}
}
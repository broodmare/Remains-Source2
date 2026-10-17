package fe.game.rendering.rig {

	import flash.geom.ColorTransform;
	import flash.geom.Point;

	import starling.display.Sprite;
	import starling.rendering.Painter;
	import starling.utils.MatrixUtil;

	import fe.game.rendering.GpuFilters;

	// A rig shown in the room. Its owner places, mirrors and fades the view and drives the rig; the rig poses and writes its mesh as the view is drawn, after the game has moved it on for the frame.
	public class RigView extends Sprite {

		private var body:Sprite;									// Holds the mesh, so a filter measures the pose just written
		private var tint:ColorTransform;							// The room's colour, over the body's own
		private var bodyTint:ColorTransform = new ColorTransform();	// The body's own colour and fade
		private var combined:ColorTransform = new ColorTransform();	// The two together, as the rig draws them
		private var local:Point = new Point();						// Scratch

		public var rig:Rig;

		// Sets target to source's values, or to no change for null
		private static function copyTint(target:ColorTransform, source:ColorTransform):void {
			target.redMultiplier	= source ? source.redMultiplier		: 1.0;
			target.greenMultiplier	= source ? source.greenMultiplier	: 1.0;
			target.blueMultiplier	= source ? source.blueMultiplier	: 1.0;
			target.alphaMultiplier	= source ? source.alphaMultiplier	: 1.0;
			target.redOffset		= source ? source.redOffset			: 0.0;
			target.greenOffset		= source ? source.greenOffset		: 0.0;
			target.blueOffset		= source ? source.blueOffset		: 0.0;
			target.alphaOffset		= source ? source.alphaOffset		: 0.0;
		}

		// The body's colour transform, then the room's over it
		private function applyTint():void {
			copyTint(combined, tint);
			combined.redOffset			+= bodyTint.redOffset   * combined.redMultiplier;
			combined.greenOffset		+= bodyTint.greenOffset	* combined.greenMultiplier;
			combined.blueOffset			+= bodyTint.blueOffset  * combined.blueMultiplier;
			combined.alphaOffset		+= bodyTint.alphaOffset * combined.alphaMultiplier;
			combined.redMultiplier		*= bodyTint.redMultiplier;
			combined.greenMultiplier	*= bodyTint.greenMultiplier;
			combined.blueMultiplier		*= bodyTint.blueMultiplier;
			combined.alphaMultiplier	*= bodyTint.alphaMultiplier;
			rig.setTint(combined);
		}

		public function RigView(assets:RigAssets) {
			rig = new Rig(assets);
			body = new Sprite();
			body.touchable = false;
			body.addChild(rig.mesh);
			addChild(body);
			touchable = false;
		}

		override public function render(painter:Painter):void {
			rig.render(0.0);
			super.render(painter);
		}

		// One game frame: the rig's playhead and its drawings' loops move on. Starling redraws an unchanged object from its cache without calling render(), and the rig only poses in render(), so the view asks to be drawn again every frame.
		public function advance():void {
			rig.advance();
			setRequiresRedraw();
		}

		// Draws it through the room's Flash colour transform, or in its own colours for null
		public function setTint(tint_:ColorTransform):void {
			tint = tint_;
			applyTint();
		}

		// The body's own colour transform under the room's, as Flash's inner clip had one; null for none
		public function setBodyTint(bodyTint_:ColorTransform):void {
			copyTint(bodyTint, bodyTint_);
			applyTint();
		}

		// How opaque the body is, 0 to 1, as Flash's alpha on the inner clip set its colour transform's alpha
		public function setBodyAlpha(alpha:Number):void {
			bodyTint.alphaMultiplier = alpha;
			applyTint();
		}

		// Draws the body through Flash filters, as near as the GPU's come, or plainly for null or none
		public function setFilters(filters:Array):void {
			if (body.filter) {
				body.filter.dispose();
			}
			body.filter = filters && filters.length > 0 ? GpuFilters.fromFlash(filters, 1.0) : null;
		}

		// Where a node's origin was when the rig last drew, in the space the view is placed in
		public function pointOf(name:String, out:Point):Point {
			rig.pointOf(name, local);
			MatrixUtil.transformCoords(transformationMatrix, local.x, local.y, out);

			return out;
		}

		// Hands the rig's atlas back; the view can't be shown after this
		override public function dispose():void {
			rig.dispose();
			super.dispose();
		}
	}
}
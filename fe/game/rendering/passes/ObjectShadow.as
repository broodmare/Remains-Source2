package fe.game.rendering.passes {

	import flash.geom.Matrix;

	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.filters.BlurFilter;
	import starling.textures.RenderTexture;

	import fe.game.rendering.GpuFilters;

	// The one shadow cast on the back wall. Each frame the tiles and every caster are drawn into a buffer, which is drawn again lowered, blurred and faded.
	public class ObjectShadow {

		private static const DISTANCE:Number	= 7.0;		// How far below its caster the shadow falls
		private static const ALPHA:Number		= 0.75;
		private static const BLUR:Number		= 16.0;		// As a Flash blur, see GpuFilters.blur
		private static const QUALITY:int		= 3;
		private static const RESOLUTION:Number	= 0.5;		// Buffer pixels per room pixel; the shadow is blurred, so half is enough

		private var width:int;								// The room's size
		private var height:int;
		private var tiles:RenderTexture;					// The tiles' shapes, drawn when the room is and when tiles break
		private var tilesImage:Image;
		private var occluders:RenderTexture;				// The tiles and casters as they stand this frame
		private var occludersImage:Image;
		private var casters:Vector.<DisplayObject> = new Vector.<DisplayObject>();
		private var placement:Matrix = new Matrix();		// Scratch: a caster's part in room space

		public var texture:RenderTexture;					// The shadow itself, the size of the room; null until the first room draws

		// Draws a caster's images where they stand in the room, leaving out filters such as a lifted object's glow:
		// Starling places a filtered object as if it were drawn to the stage, so it would land in the wrong spot
		private function drawCaster(part:DisplayObject, room:DisplayObject):void {
			var container:DisplayObjectContainer = part as DisplayObjectContainer;
			var i:int;

			if (!part.visible) { return; }

			if (container) {
				for (i = 0; i < container.numChildren; i++) {
					drawCaster(container.getChildAt(i), room);
				}
			}
			else {
				part.getTransformationMatrix(room, placement);
				occluders.draw(part, placement);
			}
		}

		private function drawOccluders():void {
			var caster:DisplayObject;

			occluders.draw(tilesImage);
			for each (caster in casters) {
				if (caster.parent) {
					drawCaster(caster, caster.parent);
				}
			}
		}

		// Made with the first room, when the GPU is sure to be ready
		private function allocate():void {
			tiles			= new RenderTexture(width, height, true, RESOLUTION);
			occluders		= new RenderTexture(width, height, false, RESOLUTION);
			texture			= new RenderTexture(width, height, false, RESOLUTION);
			tilesImage		= new Image(tiles);
			occludersImage	= new Image(occluders);

			occludersImage.y		= DISTANCE;
			occludersImage.alpha	= ALPHA;
			occludersImage.filter	= new BlurFilter(GpuFilters.blur(BLUR, QUALITY), GpuFilters.blur(BLUR, QUALITY), RESOLUTION);
		}

		public function ObjectShadow(width_:int, height_:int) {
			width	= width_;
			height	= height_;
		}

		// Draws the shapes of the tiles that cast, replacing the last ones
		public function drawTiles(shapes:DisplayObject):void {
			if (!tiles) {
				allocate();
			}
			tiles.clear();
			tiles.draw(shapes);
		}

		// Casts the shadow of a view in the object layers while it is shown there
		public function addCaster(view:DisplayObject):void {
			if (casters.indexOf(view) < 0) {
				casters.push(view);
			}
		}

		public function removeCaster(view:DisplayObject):void {
			var index:int = casters.indexOf(view);

			if (index >= 0) {
				casters.removeAt(index);
			}
		}

		// Forgets every caster, for the next room
		public function clearCasters():void {
			casters.length = 0;
		}

		// Casts this frame's shadow, just before Starling draws it
		public function render():void {
			if (!tiles) { return; }

			occluders.drawBundled(drawOccluders);
			texture.draw(occludersImage);
		}
	}
}

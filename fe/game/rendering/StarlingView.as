package fe.game.rendering {

	import flash.display.DisplayObject;

	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.filters.BlurFilter;
	import starling.filters.ColorMatrixFilter;
	import starling.filters.FilterChain;

	import fe.game.GameContainer;
	import fe.game.domain.location.tile.Tile;
	import fe.game.rendering.passes.BackWall;
	import fe.game.rendering.passes.ObjectShadow;

	// The room as Starling draws it, under the whole Flash display list. Follows visual's position, scale and visibility every frame.
	public class StarlingView {

		private static const SATS_BLUR:Number = 3.0;	// As a Flash blur, see GpuFilters.blur

		private var visual:DisplayObject;			// The room as Flash draws it, over this view
		private var root:Sprite;
		private var effectMatrix:Vector.<Number>;	// The scripted colour effect on visual, if any
		private var effectBlur:Number = 0.0;		// The scripted blur on visual, as a Flash blur
		private var satsShown:Boolean;				// SATS shows its frozen, blurred copy of the room over this view

		public var shadows:ObjectShadow;				// The shadow the tiles and objects cast on the back wall
		public var backWall:BackWall;
		public var objectLayers:ObjectLayers;		// Over the back layers

		private function prepareFrame():void {
			root.visible	= visual.visible;
			root.x			= visual.x;
			root.y			= visual.y;
			root.scaleX		= visual.scaleX;
			root.scaleY		= visual.scaleY;
			backWall.prepareFrame();
			if (root.visible) {
				shadows.render();
			}
		}

		// Rebuilds the view's filter from the scripted effect and SATS
		private function updateFilter():void {
			var chain:FilterChain = new FilterChain();

			if (root.filter) {
				root.filter.dispose();
			}

			if (effectMatrix) {
				chain.addFilter(new ColorMatrixFilter(effectMatrix));
			}
			else if (effectBlur > 0.0) {
				chain.addFilter(new BlurFilter(GpuFilters.blur(effectBlur, 1), GpuFilters.blur(effectBlur, 1)));
			}
			if (satsShown) {
				chain.addFilter(new BlurFilter(GpuFilters.blur(SATS_BLUR, 1), GpuFilters.blur(SATS_BLUR, 1)));
			}

			if (chain.numFilters > 0) {
				root.filter = chain;
			}
			else {
				root.filter = null;
				chain.dispose();
			}
		}

		public function StarlingView(visual_:DisplayObject, renderer:Renderer) {
			visual			= visual_;
			root			= new Sprite();
			root.touchable	= false;
			shadows			= new ObjectShadow(GameContainer.cellsX * Tile.tileX, GameContainer.cellsY * Tile.tileY);
			backWall		= new BackWall(renderer, root, shadows);
			objectLayers	= new ObjectLayers(root);

			Starling.current.stage.addChild(root);
			Starling.current.addEventListener(Event.RENDER, prepareFrame);
		}

		// Matches the scripted effect on visual: a colour matrix, else a blur above 0, else nothing
		public function setEffect(matrix:Vector.<Number>, blur:Number):void {
			effectMatrix	= matrix;
			effectBlur		= blur;
			updateFilter();
		}

		public function showSats(shown:Boolean):void {
			satsShown = shown;
			updateFilter();
		}
	}
}

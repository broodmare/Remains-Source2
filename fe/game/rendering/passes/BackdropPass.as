package fe.game.rendering.passes {

	import flash.display.BitmapData;

	import starling.core.Starling;
	import starling.display.Image;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.textures.TextureSmoothing;

	import fe.engine.Engine;
	import fe.game.ui.GUIManager;

	public class BackdropPass {

		private var backdrop:Image;			// The backdrop as Starling draws it, under the whole display list
		private var bitmap:BitmapData;		// The backdrop drawn at screen size, uploaded as the backdrop's texture
		private var texture:Texture;

		public var dirty:Boolean;			// The backdrop changed and is drawn again before Starling's next frame

		// Brings Starling's image up to date with the backdrop, just before Starling draws a frame
		private function prepareBackdrop():void {
			if (dirty) {
				drawBackdrop();
			}

			// Hiding the backdrop doesn't mark it dirty, so its visibility is copied every frame
			if (backdrop) {
				backdrop.visible = GUIManager.reference.sky.visible;
			}
		}

		// Draws the backdrop, with its size, tint and blur, into a screen-sized texture for Starling's image
		private function drawBackdrop():void {
			dirty = false;

			if (texture) {
				texture.dispose();
				bitmap.dispose();
			}

			bitmap = new BitmapData(Engine.reference.stage.stageWidth, Engine.reference.stage.stageHeight, true, 0);
			bitmap.draw(GUIManager.reference.sky);
			texture = Texture.fromBitmapData(bitmap);

			if (backdrop) {
				backdrop.texture = texture;
				backdrop.readjustSize();
			}
			else {
				backdrop = new Image(texture);
				backdrop.textureSmoothing = TextureSmoothing.NONE;	// Texels map 1:1 to screen pixels
				backdrop.touchable = false;
				Starling.current.stage.addChildAt(backdrop, 0);	// Under the room's Starling layers
			}
		}

		public function BackdropPass() {
			Starling.current.addEventListener(Event.RENDER, prepareBackdrop);
		}
	}
}

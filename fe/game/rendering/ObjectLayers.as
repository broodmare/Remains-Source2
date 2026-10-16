package fe.game.rendering {

	import starling.display.DisplayObject;
	import starling.display.Sprite;

	// The room's object layers that Starling draws, counted from the back as Grafon's visObjs are: above the back layers,
	// under the whole Flash display list. Flipbooks shown here move on once a frame, as Flash clips do.
	public class ObjectLayers {

		public static const COUNT:int = 3;		// Object layers 0 to 2; the layers above them are still Flash's

		private var layers:Vector.<Sprite> = new Vector.<Sprite>();

		public function ObjectLayers(parent:Sprite) {
			var i:int;

			for (i = 0; i < COUNT; i++) {
				layers.push(new Sprite());
				layers[i].touchable = false;
				parent.addChild(layers[i]);
			}
		}

		// Shows view at the front of the layer
		public function add(view:DisplayObject, layer:int):void {
			if (layer < 0 || layer >= COUNT) {
				trace("ObjectLayers.as/add() - Error: object layer " + layer + " isn't drawn by Starling, so the object isn't shown");
				return;
			}
			layers[layer].addChild(view);
		}

		// Shows or hides one layer and all it holds
		public function showLayer(layer:int, shown:Boolean):void {
			layers[layer].visible = shown;
		}

		// Empties every layer for the next room. What was shown is kept by its owner, not disposed.
		public function clear():void {
			var layer:Sprite;

			for each (layer in layers) {
				layer.removeChildren();
			}
		}

		// Moves on every flipbook shown, units' carried ones too, as Flash moves its clips on at the start of each frame
		public function advance():void {
			var layer:Sprite;
			var flipbook:Flipbook;
			var art:UnitArt;
			var i:int;

			for each (layer in layers) {
				for (i = 0; i < layer.numChildren; i++) {
					flipbook = layer.getChildAt(i) as Flipbook;
					if (flipbook) {
						flipbook.advance();
						continue;
					}
					art = layer.getChildAt(i) as UnitArt;
					if (art) {
						art.advance();
					}
				}
			}
		}
	}
}
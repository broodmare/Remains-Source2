package fe.graph {

    import flash.display.Shape;
	import flash.display.Sprite;

    import fe.World;
    import fe.entities.BoundingBox;

    public class DebugLayer {

        private var spriteContainer:Sprite; // Main sprite container

        // Constructor
        public function DebugLayer() {
            spriteContainer = new Sprite();
        }

        public function drawAllBoundingBoxes():Sprite {
            
			// Clear previous bounding boxes to avoid accumulation
			while (spriteContainer.numChildren > 0) {
				spriteContainer.removeChildAt(0);
			}

			//debugDrawBoundingBoxesForShelfs(spriteContainer, World.w.loc.space, 0x32AA32);
			//debugDrawBoundingBoxesForDiags(spriteContainer, World.w.loc.space, 0x64FFFF);
			//debugDrawBoundingBoxesForStairs(spriteContainer, World.w.loc.space, 0x00FF64);

			// Draw all object bounding boxes (in blue) 
			//debugDrawBoundingBoxesForList(spriteContainer, World.w.loc.objs, 0x6464FF);

			// Draw all unit bounding boxes (in red)
			debugDrawBoundingBoxesForList(spriteContainer, World.w.loc.units, 0xFF0000);
			// Draw player bounding box (in red)
			debugDrawBoundingBoxForObject(spriteContainer, World.w.loc.gg, 0xFF0000);

			// Return the finished debug layer
			return spriteContainer;
		}
		
		private function debugDrawBoundingBoxesForList(container:Sprite, list:*, color:uint):void {
			// `list` can be an Array or a Vector.<Unit> or any iterable collection
			for each (var item:Object in list) {
				
				// Check if the item has an 'active' property and if it's active
				if (item.hasOwnProperty("active") && !item.active) {
					continue; // Skip inactive items
				}
				
				if (item.boundingBox) {
					var bb:BoundingBox = item.boundingBox;
					
					// Create a Shape for each bounding box
					var shape:Shape = new Shape();
					shape.graphics.lineStyle(1, color, 1);  // 1-pixel wide line, 100% alpha
					shape.graphics.drawRect(bb.left, bb.top, bb.width, bb.height);
					shape.graphics.endFill();
					
					container.addChild(shape);
				}
			}
		}

		private function debugDrawBoundingBoxForObject(container:Sprite, object:*, color:uint):void {
			
			// Check if the item has an 'active' property and if it's active
			if (object.hasOwnProperty("active") && !object.active) {
				return; // Skip inactive
			}
			
			if (object.boundingBox) {
				var bb:BoundingBox = object.boundingBox;
				
				// Create a Shape for each bounding box
				var shape:Shape = new Shape();
				shape.graphics.lineStyle(1, color, 1);  // 1-pixel wide line, 100% alpha
				shape.graphics.drawRect(bb.left, bb.top, bb.width, bb.height);
				shape.graphics.endFill();
				
				container.addChild(shape);
			}
		}

		private function debugDrawBoundingBoxesForTiles(container:Sprite, list:*, color:uint):void {
			// `list` can be an Array, Vector, or other iterable
			for each (var item in list) {
				// If the item is "a stair", skip it
				if (!item.hasOwnProperty("shelf")) {
					continue;
				}
				
				// Here we rely on X1, X2, Y1, Y2 existing (instead of item.boundingBox)
				// Optionally, check if these properties exist:
				if (item.hasOwnProperty("phX1") && item.hasOwnProperty("phX2") && 
					item.hasOwnProperty("phY1") && item.hasOwnProperty("phY2")) {
					
					// Create a Shape for each bounding box
					var shape:Shape = new Shape();
					shape.graphics.lineStyle(1, color, 1); 
					shape.graphics.drawRect(
						item.phX1,					// left
						item.phY1,					// top
						item.phX2 - item.phX1,		// width
						item.phY2 - item.phY1		// height
					);
					shape.graphics.endFill();
					
					container.addChild(shape);
				}
			}
		}


		private function debugDrawBoundingBoxesForShelfs(container:Sprite, list:*, color:uint):void {
			// `list` can be an Array, Vector, or other iterable
			for each (var item in list) {
				// If the item is "a stair", skip it
				if (!item.hasOwnProperty("shelf") || !item.shelf) {
					continue;
				}
				
				// Here we rely on X1, X2, Y1, Y2 existing (instead of item.boundingBox)
				// Optionally, check if these properties exist:
				if (item.hasOwnProperty("phX1") && item.hasOwnProperty("phX2") && 
					item.hasOwnProperty("phY1") && item.hasOwnProperty("phY2")) {
					
					// Create a Shape for each bounding box
					var shape:Shape = new Shape();
					shape.graphics.lineStyle(1, color, 1); 
					shape.graphics.drawRect(
						item.phX1,					// left
						item.phY1,					// top
						item.phX2 - item.phX1,		// width
						item.phY2 - item.phY1		// height
					);
					shape.graphics.endFill();
					
					container.addChild(shape);
				}
			}
		}

		private function debugDrawBoundingBoxesForStairs(container:Sprite, list:*, color:uint):void {
			// `list` can be an Array, Vector, or other iterable
			for each (var item in list) {
				// If the item is not a stair, skip it
				if (!item.hasOwnProperty("stair") || item.stair == 0) {
					continue;
				}
				
				// Here we rely on X1, X2, Y1, Y2 existing (instead of item.boundingBox)
				// Optionally, check if these properties exist:
				if (item.hasOwnProperty("phX1") && item.hasOwnProperty("phX2") && 
					item.hasOwnProperty("phY1") && item.hasOwnProperty("phY2")) {
					
					// Create a Shape for each bounding box
					var shape:Shape = new Shape();
					shape.graphics.lineStyle(1, color, 1); 
					shape.graphics.drawRect(
						item.phX1,					// left
						item.phY1,					// top
						item.phX2 - item.phX1,		// width
						item.phY2 - item.phY1		// height
					);
					shape.graphics.endFill();
					
					container.addChild(shape);
				}
			}
		}

		private function debugDrawBoundingBoxesForDiags(container:Sprite, list:*, color:uint):void {
			// `list` can be an Array, Vector, or other iterable
			for each (var item in list) {
				// If the item is not a diagon, skip it
				if (!item.hasOwnProperty("diagon") || item.diagon == 0) {
					continue;
				}
				
				// Here we rely on X1, X2, Y1, Y2 existing (instead of item.boundingBox)
				// Optionally, check if these properties exist:
				if (item.hasOwnProperty("phX1") && item.hasOwnProperty("phX2") && 
					item.hasOwnProperty("phY1") && item.hasOwnProperty("phY2")) {
					
					// Create a Shape for each bounding box
					var shape:Shape = new Shape();
					shape.graphics.lineStyle(1, color, 1); 
					shape.graphics.drawRect(
						item.phX1,					// left
						item.phY1,					// top
						item.phX2 - item.phX1,		// width
						item.phY2 - item.phY1		// height
					);
					shape.graphics.endFill();
					
					container.addChild(shape);
				}
			}
		}
    }
}
package fe.graph {

    import flash.display.Shape;
	import flash.display.Sprite;

    import fe.World;
	import fe.graph.BackObj;
	import fe.loc.Box;
	import fe.unit.Unit;
    import fe.entities.BoundingBox;
	import fe.projectile.Bullet;

    public class DebugLayer {
		
		// Colors 
		private static var COLOR_RED:uint				= 0xFF0000;
		private static var COLOR_ORANGE:uint			= 0xFFAA32;
		private static var COLOR_PURPLE:uint			= 0x6464FF;
		private static var COLOR_LIGHTBLUE:uint			= 0x64FFFF;

        private var spriteContainer:Sprite;								// Main sprite container
		
		// Units and Objects
		private var drawObjectBoundingBoxes:Boolean		= true;
		private var drawUnitBoundingBoxes:Boolean		= true;
		private var drawPlayerBoundingBoxes:Boolean		= true;

		private var drawChainBoundingBoxes:Boolean		= true; 		// Processing chain for the current loc (Bullets, Triggers, ..)

		// Tiles
		private var drawShelfBoundingBoxes:Boolean		= false;		// Draw all beam bounding boxes
		private var drawDiagBoundingBoxes:Boolean		= false;		// Draw all stair bounding boxes
		private var drawStairBoundingBoxes:Boolean		= false;		// Draw all ladder bounding boxes
		private var drawTileBoundingBoxes:Boolean		= false;		// Literally all tiles (will lag)

        // Constructor
        public function DebugLayer() {
            spriteContainer = new Sprite();
        }

        public function drawAllBoundingBoxes():Sprite {
            
			// Clear previous bounding boxes to avoid accumulation
			while (spriteContainer.numChildren > 0) {
				spriteContainer.removeChildAt(0);
			}

			if (drawShelfBoundingBoxes) {
				debugDrawBoundingBoxesForShelfs(spriteContainer, World.w.loc.space, 0x32AA32);
			}

			if (drawDiagBoundingBoxes) {
				debugDrawBoundingBoxesForDiags(spriteContainer, World.w.loc.space, COLOR_LIGHTBLUE);
			}

			if (drawStairBoundingBoxes) {
				debugDrawBoundingBoxesForStairs(spriteContainer, World.w.loc.space, 0x00FF64);
			}

			if (drawTileBoundingBoxes) {
				debugDrawBoundingBoxesForTiles(spriteContainer, World.w.loc.space, 0x57E668);
			}

			// Draw all object bounding boxes (in purple)
			if (drawObjectBoundingBoxes) {
				debugDrawBoundingBoxesForList(spriteContainer, World.w.loc.objs, COLOR_PURPLE);
			}

			// Draw unit bounding box (in red)
			if (drawUnitBoundingBoxes) {
				debugDrawBoundingBoxesForList(spriteContainer, World.w.loc.units, COLOR_RED);
			}
			
			// Draw player bounding box (in red)
			if (drawPlayerBoundingBoxes) {
				debugDrawBoundingBoxForObjects(spriteContainer, World.w.loc.gg, COLOR_RED);
			}

			if (drawChainBoundingBoxes) {
				debugDrawBoundingBoxesForChain(spriteContainer, COLOR_ORANGE);
			}

			// Return the finished debug layer
			return spriteContainer;
		}

		private function debugDrawBoundingBoxesForChain(container:Sprite, color:uint):void {
			var current:Object = World.w.loc.firstObj;
			while (current != null) {

				 // Skip classes
				if (current is BackObj || current is Box || current is Unit) {
					current = current.nobj;
					continue;
				}

				// Draw bounding box if available
				if ("boundingBox" in current && current.boundingBox != null) {
					var bb:BoundingBox = current.boundingBox;
					
					var shape:Shape = new Shape();
					shape.graphics.lineStyle(1, color, 1); // 1-pixel wide line, 100% alpha
					shape.graphics.drawRect(bb.left, bb.top, bb.right - bb.left, bb.bottom - bb.top);
					shape.graphics.endFill();
					
					container.addChild(shape);
				}

				// If the current object is a Bullet, draw a circle at its coordinates
				if (current is Bullet) {
					var bullet:Bullet = current as Bullet;
					var bulletShape:Shape = new Shape();
					bulletShape.graphics.lineStyle(1, COLOR_RED, 1); // Red circle outline
					bulletShape.graphics.beginFill(COLOR_RED, 1); // Red fill
					bulletShape.graphics.drawCircle(bullet.coordinates.X, bullet.coordinates.Y, 5); // Radius of 5
					bulletShape.graphics.endFill();
					
					container.addChild(bulletShape);
				}

				// Check if this is the last object
				if (current == World.w.loc.lastObj) {
					break; // Stop the loop if this is the last object in the location's processing chain
				}

				// Otherwise, move on to the next entity in the chain
				current = current.nobj;
			}
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
					shape.graphics.drawRect(bb.left, bb.top, bb.right - bb.left, bb.bottom - bb.top);
					shape.graphics.endFill();
					
					container.addChild(shape);
				}
			}
		}

		private function debugDrawBoundingBoxForObjects(container:Sprite, object:*, color:uint):void {
			
			// Check if the item has an 'active' property and if it's active
			if (object.hasOwnProperty("active") && !object.active) {
				return; // Skip inactive
			}
			
			if (object.boundingBox) {
				var bb:BoundingBox = object.boundingBox;
				
				// Create a Shape for each bounding box
				var shape:Shape = new Shape();
				shape.graphics.lineStyle(1, color, 1);  // 1-pixel wide line, 100% alpha
				shape.graphics.drawRect(bb.left, bb.top, bb.right - bb.left, bb.bottom - bb.top);
				shape.graphics.endFill();
				
				container.addChild(shape);
			}
		}

		private function debugDrawBoundingBoxesForTiles(container:Sprite, list:*, color:uint):void {
			// `list` can be an Array, Vector, or other iterable
			for each (var item in list) {
				// Don't draw beam collision
				if (!item.hasOwnProperty("shelf")) {
					continue;
				}
				
				if (item.boundingBox) {
					var bb:BoundingBox = item.boundingBox;
					
					// Create a Shape for each bounding box
					var shape:Shape = new Shape();
					shape.graphics.lineStyle(1, color, 1);  // 1-pixel wide line, 100% alpha
					shape.graphics.drawRect(bb.left, bb.top, bb.right - bb.left, bb.bottom - bb.top);
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
				
				if (item.boundingBox) {
					var bb:BoundingBox = item.boundingBox;
					
					// Create a Shape for each bounding box
					var shape:Shape = new Shape();
					shape.graphics.lineStyle(1, color, 1);  // 1-pixel wide line, 100% alpha
					shape.graphics.drawRect(bb.left, bb.top, bb.right - bb.left, bb.bottom - bb.top);
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
				
				if (item.boundingBox) {
					var bb:BoundingBox = item.boundingBox;
					
					// Create a Shape for each bounding box
					var shape:Shape = new Shape();
					shape.graphics.lineStyle(1, color, 1);  // 1-pixel wide line, 100% alpha
					shape.graphics.drawRect(bb.left, bb.top, bb.right - bb.left, bb.bottom - bb.top);
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
				
				if (item.boundingBox) {
					var bb:BoundingBox = item.boundingBox;
					
					// Create a Shape for each bounding box
					var shape:Shape = new Shape();
					shape.graphics.lineStyle(1, color, 1);  // 1-pixel wide line, 100% alpha
					shape.graphics.drawRect(bb.left, bb.top, bb.right - bb.left, bb.bottom - bb.top);
					shape.graphics.endFill();
					
					container.addChild(shape);
				}
			}
		}
    }
}
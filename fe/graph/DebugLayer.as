package fe.graph {

    import flash.display.Shape;
	import flash.display.Sprite;

    import fe.World;
	import fe.util.Vector2;
	import fe.loc.Tile;
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
		private static var COLOR_COLLISION:uint			= 0x00FF00;
    	private static var COLOR_NO_COLLISION:uint		= 0xFF6464; 
		private static var COLOR_DARK_RED:uint			= 0xAA0000;

        private var spriteContainer:Sprite;								// Main sprite container
		
		// Units and Objects
		private var drawObjectBoundingBoxes:Boolean		= false;
		private var drawUnitBoundingBoxes:Boolean		= false;
		private var drawPlayerBoundingBoxes:Boolean		= false;

		private var drawChainBoundingBoxes:Boolean		= false; 		// Processing chain for the current loc (Bullets, Triggers, ..)

		// Tiles
		private var drawShelfBoundingBoxes:Boolean		= false;		// Draw all beam bounding boxes
		private var drawDiagBoundingBoxes:Boolean		= false;		// Draw all stair bounding boxes
		private var drawStairBoundingBoxes:Boolean		= false;		// Draw all ladder bounding boxes
		private var drawTileBoundingBoxes:Boolean		= false;		// Literally all tiles (will lag)

		// NOTE: These two functions are shit garbage and I'm not even sure the top one works, but it'll show the tiles being checked around the player and floor/ceiling tiles being interacted with
		private var drawCollisionChecks:Boolean = false;				// Collision ceheck visualization
		private var drawHorizontalCollisionChecks:Boolean = false;

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
			
			if (drawCollisionChecks) {
				debugDrawCollisionChecks(spriteContainer);
			}

			if (drawHorizontalCollisionChecks) {
			debugDrawHorizontalCollisionChecks(spriteContainer);
		}

			// Return the finished debug layer
			return spriteContainer;
		}

		private function debugDrawCollisionChecks(container:Sprite):void {
			// Iterate through all units in the current location
			for each (var unit:Object in World.w.loc.units) {
				if (unit.hasOwnProperty("active") && !unit.active) continue; // Skip inactive units
				
				// Retrieve the unit's bounding box
				var boundingBox:BoundingBox = unit.boundingBox;
				if (!boundingBox) continue;
				
				// Retrieve the location
				var loc:Object = World.w.loc;
				if (loc.sky) continue; // Skip if location is sky
				
				// Cache reciprocal of tile sizes for faster multiplication
				var invTileX:Number = 1 / Tile.tileX;
				var invTileY:Number = 1 / Tile.tileY;

				// Cache map boundaries
				var maxSpaceX:int = loc.spaceX;
				var maxSpaceY:int = loc.spaceY;

				// Precompute tile index ranges and clamp them to map boundaries
				var startI:int = Math.max(int((boundingBox.left) * invTileX), 0);
				var endI:int = Math.min(int((boundingBox.right) * invTileX), maxSpaceX - 1);

				var startJ:int = Math.max(int((boundingBox.top) * invTileY), 0);
				var endJ:int = Math.min(int((boundingBox.bottom) * invTileY), maxSpaceY - 1);

				// Iterate over the relevant tiles to check for collisions with the unit's bounding box
				for (var i:int = startI; i <= endI; i++) {
					for (var j:int = startJ; j <= endJ; j++) {
						var tile:Tile = loc.getTile(i, j);
						var collisionResult:Object = collisionTileDebug(unit, tile);
						
						if (collisionResult.isColliding) {
							// Determine if it's a horizontal collision based on movement
							if (collisionResult.collisionType == "horizontal") {
								// Determine the side of collision
								var collisionSide:String = collisionResult.side; // "left" or "right"
								var color:uint;
								
								if (collisionSide == "left") {
									color = COLOR_RED;
								}
								else if (collisionSide == "right") {
									color = COLOR_DARK_RED;
								}
								else {
									color = COLOR_COLLISION; // Fallback
								}
								
								// Draw red border around the colliding tile
								if (tile.boundingBox) {
									var bb:BoundingBox = tile.boundingBox;
									
									var shape:Shape = new Shape();
									shape.graphics.lineStyle(2, color, 1); // 2-pixel wide red line
									shape.graphics.drawRect(bb.left, bb.top, bb.right - bb.left, bb.bottom - bb.top);
									shape.graphics.endFill();
									
									container.addChild(shape);
								}
							}
							else {
								// For non-horizontal collisions, use existing visualization
								var generalColor:uint = COLOR_COLLISION;
								if (tile.boundingBox) {
									var bbGeneral:BoundingBox = tile.boundingBox;
									
									var shapeGeneral:Shape = new Shape();
									shapeGeneral.graphics.lineStyle(2, generalColor, 1);
									shapeGeneral.graphics.drawRect(bbGeneral.left, bbGeneral.top, bbGeneral.right - bbGeneral.left, bbGeneral.bottom - bbGeneral.top);
									shapeGeneral.graphics.endFill();
									
									container.addChild(shapeGeneral);
								}
							}
						}
						else {
							// Draw non-colliding tiles in yellow
							if (drawCollisionChecks) { // Ensure that this flag controls the visualization
								var noCollisionColor:uint = COLOR_NO_COLLISION;
								if (tile.boundingBox) {
									var bbNoCollision:BoundingBox = tile.boundingBox;
									
									var shapeNoCollision:Shape = new Shape();
									shapeNoCollision.graphics.lineStyle(1, noCollisionColor, 0.5); // 1-pixel wide yellow line, semi-transparent
									shapeNoCollision.graphics.drawRect(bbNoCollision.left, bbNoCollision.top, bbNoCollision.right - bbNoCollision.left, bbNoCollision.bottom - bbNoCollision.top);
									shapeNoCollision.graphics.endFill();
									
									container.addChild(shapeNoCollision);
								}
							}
						}
					}
				}
			}
		}

		private function debugDrawHorizontalCollisionChecks(container:Sprite):void {
			// Iterate through all units in the current location
			for each (var unit:Object in World.w.loc.units) {
				if (unit.hasOwnProperty("active") && !unit.active) continue; // Skip inactive units
				
				// Retrieve the unit's bounding box
				var boundingBox:BoundingBox = unit.boundingBox;
				if (!boundingBox) continue;
				
				// Retrieve the location
				var loc:Object = World.w.loc;
				if (loc.sky) continue; // Skip if location is sky
				
				// Determine movement direction
				var movingRight:Boolean = unit.velocity.X > 0;
				var movingLeft:Boolean = unit.velocity.X < 0;
				
				// Cache reciprocal of tile sizes for faster multiplication
				var invTileX:Number = 1 / Tile.tileX;
				var invTileY:Number = 1 / Tile.tileY;

				// Cache map boundaries
				var maxSpaceX:int = loc.spaceX;
				var maxSpaceY:int = loc.spaceY;

				// Precompute tile index ranges and clamp them to map boundaries
				var startI:int = Math.max(int((boundingBox.left) * invTileX), 0);
				var endI:int = Math.min(int((boundingBox.right) * invTileX), maxSpaceX - 1);

				var startJ:int = Math.max(int((boundingBox.top) * invTileY), 0);
				var endJ:int = Math.min(int((boundingBox.bottom) * invTileY), maxSpaceY - 1);

				// Iterate over the relevant tiles to check for horizontal collisions
				for (var i:int = startI; i <= endI; i++) {
					for (var j:int = startJ; j <= endJ; j++) {
						var tile:Tile = loc.getTile(i, j);
						var collisionResult:Object = collisionTileDebug(unit, tile);
						
						// Check if a horizontal collision occurred
						if (collisionResult.isColliding && collisionResult.collisionType == "horizontal") {
							var collisionSide:String = collisionResult.side; // "left" or "right"
							var color:uint;
							
							if (collisionSide == "left") {
								color = COLOR_RED;
							}
							else if (collisionSide == "right") {
								color = COLOR_DARK_RED;
							}
							else {
								color = COLOR_COLLISION; // Fallback
							}
							
							// Draw red border around the colliding tile
							if (tile.boundingBox) {
								var bb:BoundingBox = tile.boundingBox;
								
								var shape:Shape = new Shape();
								shape.graphics.lineStyle(2, color, 1); // 2-pixel wide red line
								shape.graphics.drawRect(bb.left, bb.top, bb.right - bb.left, bb.bottom - bb.top);
								shape.graphics.endFill();
								
								container.addChild(shape);
							}
						}
					}
				}
			}
		}

		// Helper method to replicate collisionTile logic
		private function collisionTileDebug(unit:Object, t:Tile):Object {
			if (!t || ((t.phis == 0 || (unit.transT && t.phis == 3)) && !t.shelf)) {
				return { isColliding: false };
			} 
			
			var unitBox:BoundingBox = unit.boundingBox;
			var tileBox:BoundingBox = t.boundingBox;
			
			// Check for horizontal intersection
			if (!unitBox.intersectsHorizontally(tileBox)) {
				return { isColliding: false };
			}
			
			// Check shelf condition
			if (t.shelf && ((t.phis == 0 || (unit.transT && t.phis == 3))) &&
				((unitBox.bottom - (unit.stay ? unit.porog : unit.porog_jump)) > tileBox.top ||
				unit.throu || unit.t_throw > 0 || unit.levit || unit.isFly || 
				(unit.hasOwnProperty("diagon") && unit.diagon != 0))) {
				return { isColliding: false };
			}
			
			// Determine collision side based on bounding box overlap
			var overlapLeft:Number = unitBox.right - tileBox.left;
			var overlapRight:Number = tileBox.right - unitBox.left;
			
			var collisionSide:String = "unknown";
			
			// Determine the side with the minimal overlap
			if (overlapLeft < overlapRight) {
				collisionSide = "left"; // Colliding on the left side of the tile (unit moving right)
			}
			else {
				collisionSide = "right"; // Colliding on the right side of the tile (unit moving left)
			}
			
			return { 
				isColliding: true,
				collisionType: "horizontal",
				side: collisionSide
			};
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
package fe.game.domain.location {

	import flash.display.BitmapData;

	import fe.game.domain.entities.Obj;
	import fe.game.domain.units.Unit;
	import fe.game.domain.location.tile.Tile;
	import fe.game.enums.E_Direction;
	import fe.game.GameContainer;

	// Pip-Buck map of a level, stitched together from rooms
	public class Minimap {

		private static const COLOR_EMPTY:uint		= 0x003323;
		private static const COLOR_WHITE:uint		= 0xFFFFFF;
		private static const COLOR_DOOR:uint		= 0x639104;
		private static const COLOR_STAIR:uint		= 0x666666;
		private static const COLOR_SHELFSTAIR:uint	= 0x7B482F;
		private static const COLOR_WATER:uint		= 0x0066FF;
		private static const COLOR_DAMAGED:uint		= 0x01995A;
		private static const COLOR_WALL:uint		= 0x00FF99;
		private static const COLOR_CONTAINER:uint	= 0xFFCC00;
		private static const COLOR_QUEST:uint		= 0xFF0077;
		private static const COLOR_CHECKPOINT:uint	= 0xFF00FF;
		private static const COLOR_NPC:uint			= 0x5500FF;

		private static var tileX:int = Tile.tileX;
		private static var tileY:int = Tile.tileY;

		private var level:Land;
		private var bitmap:BitmapData;		// One pixel per tile, covering every room slot in the level

		public var playerX:Number = 0;		// Player position in level pixels, for the Pip-Boy player marker
		public var playerY:Number = 0;

		private function drawObj(room:Location, obj:Obj, color:uint):void {
			var worldCellsX:int = GameContainer.cellsX;
			var worldCellsY:int = GameContainer.cellsY;
			var i:int;
			var j:int;

			var startXIndex:int = (room.landX - level.minLocX) * worldCellsX;
			var startYIndex:int = (room.landY - level.minLocY) * worldCellsY;

			var xStart:int	= startXIndex + int(obj.boundingBox.left   / tileX + 0.50);
			var xEnd:int	= startXIndex + int(obj.boundingBox.right  / tileX - 0.50);
			var yStart:int	= startYIndex + int(obj.boundingBox.top    / tileY + 0.40);
			var yEnd:int	= startYIndex + int(obj.boundingBox.bottom / tileY - 0.50);

			for (i = xStart; i <= xEnd; i++) {
				for (j = yStart; j <= yEnd; j++) {
					bitmap.setPixel(i, j, color);
				}
			}
		}

		// Paint one room's tiles and markers into its slot in the level bitmap
		private function drawRoom(room:Location):void {
			var vid:Number = 1.0;
			var neighborVisi:Number;
			var rightX:int = room.spaceX - 1;
			var bottomY:int = room.spaceY - 1;
			var i:int;
			var j:int;
			var color:uint;
			var tile:Tile;
			var obj:Obj;
			var act:Object;
			var unit:Unit;

			for (i = 0; i < room.spaceX; i++) {
				for (j = 0; j < room.spaceY; j++) {
					color = COLOR_EMPTY;
					tile = room.getTile(i, j);

					if (tile.water) {
						color = COLOR_WATER;
					}

					if (tile.platform || tile.definition.slopeSide != E_Direction.NEUTRAL) {
						color = COLOR_SHELFSTAIR;
					}

					if (tile.definition.ladderSide != E_Direction.NEUTRAL) {
						color = COLOR_STAIR;
					}

					if (tile.collision == 1) {
						if (tile.indestructible) {
							color = COLOR_WHITE;
						}
						else if (tile.door) {
							color = COLOR_DOOR;
						}
						else if (tile.hp < 100) {
							color = COLOR_DAMAGED;
						}
						else {
							color = COLOR_WALL;
						}
					}

					if (tile.collision == 2) {
						color = COLOR_DAMAGED;
					}

					if (!GameContainer.reference.drawAllMap) {
						vid = tile.visibility;

						if (i < rightX) {
							neighborVisi = room.getTile(i + 1, j).visibility;
							if (neighborVisi > vid) {
								vid = neighborVisi;
							}

							if (j < bottomY) {
								neighborVisi = room.getTile(i + 1, j + 1).visibility;
								if (neighborVisi > vid) {
									vid = neighborVisi;
								}
							}
						}

						if (j < bottomY) {
							neighborVisi = room.getTile(i, j + 1).visibility;
							if (neighborVisi > vid) {
								vid = neighborVisi;
							}
						}
					}

					color += int(vid * 255) * 0x1000000;
					bitmap.setPixel32((room.landX - level.minLocX) * GameContainer.cellsX + i, (room.landY - level.minLocY) * GameContainer.cellsY + j, color);
				}
			}

			for each (obj in room.objs) {
				if (obj.inter && obj.inter.cont != "" && obj.inter.active) {
					drawObj(room, obj, COLOR_CONTAINER);
				}

				if (obj.inter && obj.inter.prob != "" && obj.inter.prob != null) {
					drawObj(room, obj, COLOR_QUEST);
				}
			}

			for each (act in room.acts) {
				if (act is CheckPoint) drawObj(room, act as Obj, COLOR_CHECKPOINT);
			}

			for each (unit in room.units) {
				if (unit.npc) drawObj(room, unit, COLOR_NPC);
			}
		}

		public function Minimap(level_:Land) {
			level = level_;
			bitmap = new BitmapData(GameContainer.cellsX * (level.maxLocX - level.minLocX), GameContainer.cellsY * (level.maxLocY - level.minLocY), true, 0);
		}

		// Redraw every visited room into the level bitmap and update the player position
		public function drawLevel():BitmapData {
			var i:int;
			var j:int;
			var room:Location;

			bitmap.fillRect(bitmap.rect, 0x00000000);
			for (i = level.minLocX; i < level.maxLocX; i++) {
				for (j = level.minLocY; j < level.maxLocY; j++) {
					room = level.locs[i][j][0];
					if (room != null && (GameContainer.reference.drawAllMap || room.visited)) {
						drawRoom(room);
					}
				}
			}

			playerX = (level.loc.landX - level.minLocX) * GameContainer.cellsX * tileX + level.gg.coordinates.X;
			playerY = (level.loc.landY - level.minLocY) * GameContainer.cellsY * tileY + level.gg.coordinates.Y - level.gg.boundingBox.halfHeight;

			return bitmap;
		}
	}
}
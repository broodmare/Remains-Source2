package fe.loc {

	import flash.display.BitmapData;

	import fe.World;
	import fe.entities.Obj;
	import fe.unit.Unit;

	// Holds a reference to a location and renders a minimap of it
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

		private var location:Location;

		public function Minimap(location:Location) {
			this.location = location;
		}

		private function drawMapObj(map:BitmapData, obj:Obj, color:uint):void {
			var worldCellsX:int = World.cellsX;
			var worldCellsY:int = World.cellsY;

			var startXIndex:int = (location.landX - location.land.minLocX) * worldCellsX;
			var startYIndex:int = (location.landY - location.land.minLocY) * worldCellsY;

			var xStart:int	= startXIndex + int(obj.boundingBox.left   / tileX + 0.50);
			var xEnd:int	= startXIndex + int(obj.boundingBox.right  / tileX - 0.50);
			var yStart:int	= startYIndex + int(obj.boundingBox.top    / tileY + 0.40);
			var yEnd:int	= startYIndex + int(obj.boundingBox.bottom / tileY - 0.50);

			for (var i:int = xStart; i <= xEnd; i++) {
				for (var j:int = yStart; j <= yEnd; j++) {
					map.setPixel(i, j, color);
				}
			}
		}

		// Render the minimap
		public function drawMap(map:BitmapData):void {
			var vid:Number = 1.0;
			var neighborVisi:Number;
			var rightX:int = location.spaceX - 1;
			var bottomY:int = location.spaceY - 1;

			for (var i:int = 0; i < location.spaceX; i++) {
				for (var j:int = 0; j < location.spaceY; j++) {
					var color:uint = COLOR_EMPTY;
					var t:Tile = location.getTile(i, j);

					if (t.water) {
						color = COLOR_WATER;
					}

					if (t.shelf || t.diagon != 0) {
						color = COLOR_SHELFSTAIR;
					}

					if (t.stair != 0) {
						color = COLOR_STAIR;
					}

					if (t.phis == 1) {
						if (t.indestruct) {
							color = COLOR_WHITE;
						}
						else if (t.door) {
							color = COLOR_DOOR;
						}
						else if (t.hp < 100) {
							color = COLOR_DAMAGED;
						}
						else {
							color = COLOR_WALL;
						}
					}

					if (t.phis == 2) {
						color = COLOR_DAMAGED;
					}

					if (!World.w.drawAllMap) {
						vid = t.visi;

						if (i < rightX) {
							neighborVisi = location.getTile(i + 1, j).visi;
							if (neighborVisi > vid) {
								vid = neighborVisi;
							}

							if (j < bottomY) {
								neighborVisi = location.getTile(i + 1, j + 1).visi;
								if (neighborVisi > vid) {
									vid = neighborVisi;
								}
							}
						}

						if (j < bottomY) {
							neighborVisi = location.getTile(i, j + 1).visi;
							if (neighborVisi > vid) {
								vid = neighborVisi;
							}
						}
					}

					color += int(vid * 255) * 0x1000000;
					map.setPixel32((location.landX - location.land.minLocX) * World.cellsX + i, (location.landY - location.land.minLocY) * World.cellsY + j, color);
				}
			}

			for each (var obj:Obj in location.objs) {
				if (obj.inter && obj.inter.cont != "" && obj.inter.active) {
					drawMapObj(map, obj, COLOR_CONTAINER);
				}

				if (obj.inter && obj.inter.prob != "" && obj.inter.prob != null) {
					drawMapObj(map, obj, COLOR_QUEST);
				}
			}

			for each (var act:Object in location.acts) {
				if (act is CheckPoint) drawMapObj(map, act as Obj, COLOR_CHECKPOINT);
			}

			for each (var unit:Unit in location.units) {
				if (unit.npc) drawMapObj(map, unit, COLOR_NPC);
			}
		}
	}
}
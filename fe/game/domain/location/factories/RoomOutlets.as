package fe.game.domain.location.factories {

	import fe.engine.utils.Vec2;
	import fe.game.enums.E_Direction;

	// The outlets a room definition allows in its outer walls, read once from the room's <doors> string.
	// Each outlet holds the largest opening it allows; 0 keeps the wall shut there
	public class RoomOutlets {

		public static const HORIZONTAL_OUTLETS:int	= 6;	// Left and Right walls
		public static const VERTICAL_OUTLETS:int	= 5;	// Floor and Ceiling
		public static const MIN_OPENING_SIZE:int	= 2;	// Room connections must be at least two tiles

		// Largest opening size per outlet on each wall
		private var rightSizes:Vector.<int>;
		private var bottomSizes:Vector.<int>;
		private var leftSizes:Vector.<int>;
		private var topSizes:Vector.<int>;

		private function viewSizes(edge:Vec2):Vector.<int> {
			if (edge == E_Direction.RIGHT)	{ return rightSizes; }
			if (edge == E_Direction.DOWN)	{ return bottomSizes; }
			if (edge == E_Direction.LEFT)	{ return leftSizes; }

			return topSizes;
		}

		// The sizes of count outlets in a row, starting at entry first of the <doors> string
		private static function readSizes(entries:Array, first:int, count:int):Vector.<int> {
			var sizes:Vector.<int> = new Vector.<int>();
			var i:int;

			for (i = first; i < first + count; i++) {
				sizes.push(getSlotSize(entries, i));
			}

			return sizes;
		}

		private static function getSlotSize(entries:Array, i:int):int {
			if (entries == null)		{ return MIN_OPENING_SIZE; }
			if (i >= entries.length)	{ return 0; }

			return int(entries[i]);
		}

		public function RoomOutlets(roomId:String, doors:String) {
			var entries:Array = (doors != null) ? doors.split('.') : null;
			var expected:int = 2 * HORIZONTAL_OUTLETS + 2 * VERTICAL_OUTLETS;

			if (entries != null && entries.length != expected) {
				trace("RoomOutlets.as/RoomOutlets() - Error: Room \"" + roomId + "\" lists " + entries.length + " outlet sizes instead of " + expected + "; missing outlets stay shut");
			}

			rightSizes	= readSizes(entries, 0, HORIZONTAL_OUTLETS);
			bottomSizes	= readSizes(entries, HORIZONTAL_OUTLETS, VERTICAL_OUTLETS);
			leftSizes	= readSizes(entries, HORIZONTAL_OUTLETS + VERTICAL_OUTLETS, HORIZONTAL_OUTLETS);
			topSizes	= readSizes(entries, 2 * HORIZONTAL_OUTLETS + VERTICAL_OUTLETS, VERTICAL_OUTLETS);
		}

		// The largest opening allowed at slot on edge, for a room placed mirrored or not
		public function openingSize(edge:Vec2, slot:int, isMirrored:Boolean):int {
			var definedEdge:Vec2	= edge;
			var definedSlot:int		= slot;

			if (isMirrored) {
				if (edge == E_Direction.LEFT || edge == E_Direction.RIGHT) {
					definedEdge = E_Direction.opposite(edge);
				}
				else {
					definedSlot = VERTICAL_OUTLETS - 1 - slot;
				}
			}

			return viewSizes(definedEdge)[definedSlot];
		}
	}
}
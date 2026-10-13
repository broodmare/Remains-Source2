package fe.game.domain.location.tile.enums {

	// Where a tile piece is drawn, from the back of the room forward
	public class E_TileLayer {
		public static const BACK_WALL:int	= 0;	// Painted onto the room's back wall
		public static const BACKGROUND:int	= 1;	// In front of the back wall, behind units
		public static const MAIN:int		= 2;	// In front of units
		public static const FOREGROUND:int	= 3;	// In front of units and main pieces
	}
}
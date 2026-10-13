package fe.loc.tile {

	import fe.enums.E_Material;
	import fe.enums.E_Direction;

	// What a room places in one tile: its pieces, and the starting values combined from them. Shared by every tile with the same contents
	public class Tile_Definition {
		public var code:String				= "";		// Text from the room's tile rows that this was built from
		public var pieces:Vector.<TilePiece_Definition> = new Vector.<TilePiece_Definition>();	// In the order the row lists them
		public var wall:TilePiece_Definition;			// Wall patch painted behind the tile, null to show the room's back wall
		public var height:int				= 4;		// Height of the tile's collision box in quarter tiles
		public var water:Boolean			= false;

		// Starting values for the live tile
		public var collision:int			= 0;
		public var hp:int					= 1000;
		public var damageThreshold:int		= 0;
		public var indestructible:Boolean	= false;
		public var material:int				= E_Material.NONE;
		public var opacity:Number			= 0.0;
		public var platform:Boolean			= false;

		// Fixed for the tile's whole life
		public var ladderSide:int			= E_Direction.NEUTRAL;	// Side of the tile a ladder hugs, NEUTRAL for no ladder
		public var slopeSide:int			= E_Direction.NEUTRAL;	// Side a slope rises toward, NEUTRAL for no slope
		public var hidingSpot:Boolean		= false;
	}
}
package fe.loc.tile {

	import fe.enums.E_Material;
	import fe.loc.tile.enums.E_TileBehaviour;
	import fe.loc.tile.enums.E_TileLayer;
	import fe.util.Vec2;
	import fe.enums.E_Direction;

	// One thing a room can place in a tile: a block, a wall patch, a beam, steps or a ladder
	public class TilePiece_Definition {
		public var id:String				= "";
		public var code:String				= "";		// Character that places this piece in a room's tile rows
		public var name:String				= "";
		public var layer:int				= E_TileLayer.BACKGROUND;
		public var behaviour:int			= E_TileBehaviour.NONE;
		public var side:Vec2					= E_Direction.NEUTRAL;	// Ladders hug and slopes rise toward this side, LEFT or RIGHT
		public var material:int				= E_Material.NONE;
		public var hp:int					= 0;		// 0 keeps the tile's default
		public var damageThreshold:int		= 0;		// Hits weaker than this do no damage
		public var indestructible:Boolean	= false;
		public var wall:TilePiece_Definition;			// Wall patch shown behind this block where the room places none
		public var leavesWall:Boolean		= false;	// Without it the block shows no wall of its own, so it vanishes entirely when destroyed
		public var mirror:TilePiece_Definition;			// Placed instead in mirrored rooms
		public var spriteFrame:int			= 0;		// Frame of the tile sprite sheet, 0 for pieces drawn from textures

		// Textures, by name in the texture library
		public var texture:String			= "";
		public var textureMask:String		= "";
		public var stableTexture:String		= "";		// Replaces texture in the player's home stable
		public var edgeTexture:String		= "";		// Drawn along the piece's outline
		public var edgeMask:String			= "";
		public var topTexture:String		= "";		// Drawn along the piece's top surface
		public var topMask:String			= "";
		public var filter:String			= "";
	}
}

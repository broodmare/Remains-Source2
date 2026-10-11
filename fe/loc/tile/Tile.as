package fe.loc.tile {

	import fe.util.Vec2;
	import fe.entities.BoundingBox;
	import fe.entities.Obj;
	import fe.loc.Box;

	// One space on a room's grid while the game runs: what its definition placed there, and what has happened to it since
	public class Tile {

		private static var tileSize:int = 40;			// Size in pixels
		public static var tileX:int = tileSize;			// TODO: Replace this better with tileSize
		public static var tileY:int = tileSize;

		public var coords:Vec2;							// (is this raw coords or tilespace coords??)
		public var boundingBox:BoundingBox;				// Bounding box
		public var definition:Tile_Definition;

		public var collision:int			= 0;		// 0 none, 1 solid, 2 grate that bullets only cross from above, 3 ghost wall
		public var hp:int					= 1000;		// Hitpoints before the block breaks
		public var damageThreshold:int		= 0;		// Hits weaker than this do no damage
		public var indestructible:Boolean	= false;
		public var material:int				= Material.NONE;
		public var opacity:Number			= 0.00;		// How much light the tile blocks
		public var platform:Boolean			= false;	// Stood on from above, dropped through from on top
		public var water:int				= 0;
		public var ladderTop:Boolean		= false;	// The ladder ends here, so it shows its top frame and can be stood on
		public var destroyed:Boolean		= false;	// The block and sprites are gone, leaving only the wall patch
		public var isFakeWall:Boolean		= false;	// Crumbles to dust instead of debris
		public var ghostTimer:int			= 0;		// Ticks left before a ghost wall fades
		public var gravity:Number			= 1.00;		// Multiplies gravity for units inside, set by lift areas
		public var canPlaceObjects:Boolean	= true;		// Off near room exits, so containers don't block the way
		public var visibility:Number		= 0.00;		// Fog-of-war visibility as drawn
		public var targetVisibility:Number	= 0.00;		// Visibility the drawn one eases toward

		// Corner frames of the outline masks, for the main layer and for the layers behind units
		public var mainOutline1:int			= 0;
		public var mainOutline2:int			= 0;
		public var mainOutline3:int			= 0;
		public var mainOutline4:int			= 0;
		public var backOutline1:int			= 0;
		public var backOutline2:int			= 0;
		public var backOutline3:int			= 0;
		public var backOutline4:int			= 0;

		public var door:Box;		// Reference to (a door if it's contained in this tile?)
		public var trap:Obj;		// Reference to (a trap if it's contained in this tile?)

		public function Tile(nx:Number, ny:Number) {
			coords = new Vec2(nx, ny);
			boundingBox = new BoundingBox(coords);
			// Empty until the room applies its own; the room's out-of-bounds tile stays this way
			definition = TileRegistry.viewDefinition("", false);

			var l:Number = coords.X * tileSize;
			var r:Number = (coords.X + 1) * tileSize;
			var t:Number = coords.Y * tileSize;
			var b:Number = (coords.Y + 1) * tileSize;
			boundingBox.setBounds(l, r, t, b);
			boundingBox.setSize(40);
		}

		// Sets the tile up as its definition describes
		public function applyDefinition(definition_:Tile_Definition):void {
			definition		= definition_;
			collision		= definition.collision;
			hp				= definition.hp;
			damageThreshold	= definition.damageThreshold;
			indestructible	= definition.indestructible;
			material		= definition.material;
			opacity			= definition.opacity;
			platform		= definition.platform;
			water			= definition.water ? 1 : 0;
			boundingBox.top	= (coords.Y + (4 - definition.height) * 0.25) * tileSize;
		}

		public function hole():Boolean {
			if (collision > 0) {
				collision = 0;
				return true;
			}

			return false;
		}

		public function updVisi():Number {
			visibility += 0.10;

			if (visibility > targetVisibility) {
				visibility = targetVisibility;
			}

			return visibility;
		}

		// Reskins a solid tile on the room's edge with the land's border block
		public function mainFrame(borderCode:String):void {
			definition		= TileRegistry.viewBorderDefinition(borderCode, definition);
			collision		= definition.collision;
			hp				= definition.hp;
			indestructible	= definition.indestructible;
			material		= definition.material;
			opacity			= definition.opacity;
		}

		public function getMaxY(rx:Number):Number {
			if (definition.slopeSide == 0) {
				return boundingBox.top;
			}
			else if (definition.slopeSide > 0) {
				if (rx < boundingBox.left) {
					return boundingBox.bottom;
				}
				else if (rx > boundingBox.right) {
					return boundingBox.top;
				}
				else {
					return boundingBox.bottom - (boundingBox.bottom - boundingBox.top) * ((rx - boundingBox.left) / (boundingBox.right - boundingBox.left));
				}
			}
			else {
				if (rx < boundingBox.left) {
					return boundingBox.top;
				}
				else if (rx > boundingBox.right) {
					return boundingBox.bottom;
				}
				else {
					return boundingBox.bottom - (boundingBox.bottom - boundingBox.top) * ((boundingBox.right - rx) / (boundingBox.right - boundingBox.left));
				}
			}
		}

		// [Cause damage to the block, return true if there was damage]
		public function udar(hit:int):Boolean {
			if (indestructible || damageThreshold > hit) {
				return false;
			}

			hp -= hit;

			return true;
		}

		// [Destroy the block]
		public function die():void {
			// Differs from vanilla, where a fading ghost wall also wiped the sprites of the tile it stood on
			if (collision != 3) {
				destroyed = true;
			}

			collision	= 0;
			opacity		= 0.0;
			ghostTimer	= 0;

			if (trap) {
				trap.die();	// [Destroy bindings]
			}
		}
	}
}
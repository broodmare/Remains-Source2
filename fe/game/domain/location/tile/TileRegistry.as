package fe.game.domain.location.tile {

	import fe.engine.text.TextLoader;
	import fe.game.enums.E_Direction;
	import fe.game.enums.E_Material;
	import fe.game.domain.location.tile.enums.E_TileBehaviour;
	import fe.game.domain.location.tile.enums.E_TileLayer;
	import fe.engine.utils.Vec2;

	// Loads every tile piece, and turns the text in a room's tile rows into definitions shared by every tile with the same text
	public class TileRegistry {

		private static const PIECES_PATH:String = "Modules/core/allData/tilePieces.json";
		private static const BORDER_HP:int = 10000;

		private static const LAYERS:Object = {
			backWall:E_TileLayer.BACK_WALL, background:E_TileLayer.BACKGROUND, main:E_TileLayer.MAIN, foreground:E_TileLayer.FOREGROUND
		};
		private static const BEHAVIOURS:Object = {
			none:E_TileBehaviour.NONE, solid:E_TileBehaviour.SOLID, platform:E_TileBehaviour.PLATFORM,
			ladder:E_TileBehaviour.LADDER, slope:E_TileBehaviour.SLOPE, hidingSpot:E_TileBehaviour.HIDING_SPOT
		};
		private static const MATERIALS:Object = {
			metal:E_Material.METAL, stone:E_Material.STONE, wood:E_Material.WOOD, brick:E_Material.BRICK,
			glass:E_Material.GLASS, earth:E_Material.EARTH, forceField:E_Material.FORCE_FIELD, meat:E_Material.MEAT
		};
		private static const SIDES:Object = {left:E_Direction.LEFT, right:E_Direction.RIGHT};

		private static var pieces:Vector.<TilePiece_Definition> = new Vector.<TilePiece_Definition>();
		private static var piecesById:Object			= {};
		private static var blocksByCode:Object			= {};		// Main-layer pieces, by the code that opens a tile's text
		private static var overlaysByCode:Object		= {};		// Every other piece, by the codes that follow it
		private static var definitions:Object			= {};		// By tile text
		private static var mirroredDefinitions:Object	= {};		// By tile text, for mirrored rooms
		private static var borderDefinitions:Object		= {};		// By block code, height and hiding spot

		// Reads one piece's own fields; links to other pieces are resolved once every piece exists
		private static function readPiece(data:Object):TilePiece_Definition {
			var piece:TilePiece_Definition = new TilePiece_Definition();

			piece.id = data.id;
			piece.code = data.code;
			piece.name = data.name;
			piece.layer = parseName(LAYERS, data.layer, piece.id, "layer");
			piece.behaviour = parseName(BEHAVIOURS, data.behaviour, piece.id, "behaviour");

			if ("side" in data)				{ piece.side = parseSide(data.side, piece.id); }
			if ("material" in data)			{ piece.material = parseName(MATERIALS, data.material, piece.id, "material"); }
			if ("hp" in data)				{ piece.hp = data.hp; }
			if ("damageThreshold" in data)	{ piece.damageThreshold = data.damageThreshold; }
			if ("indestructible" in data)	{ piece.indestructible = data.indestructible; }
			if ("leavesWall" in data)		{ piece.leavesWall = data.leavesWall; }
			if ("spriteFrame" in data)		{ piece.spriteFrame = data.spriteFrame; }
			if ("texture" in data)			{ piece.texture = data.texture; }
			if ("textureMask" in data)		{ piece.textureMask = data.textureMask; }
			if ("stableTexture" in data)	{ piece.stableTexture = data.stableTexture; }
			if ("edgeTexture" in data)		{ piece.edgeTexture = data.edgeTexture; }
			if ("edgeMask" in data)			{ piece.edgeMask = data.edgeMask; }
			if ("topTexture" in data)		{ piece.topTexture = data.topTexture; }
			if ("topMask" in data)			{ piece.topMask = data.topMask; }
			if ("filter" in data)			{ piece.filter = data.filter; }

			return piece;
		}

		private static function parseName(names:Object, name:String, pieceId:String, field:String):int {
			if (name in names) { return names[name]; }
			trace("TileRegistry.as/parseName() - Warning: piece \"" + pieceId + "\" has unknown " + field + " \"" + name + "\"");

			return 0;
		}

		private static function parseSide(name:String, pieceId:String):Vec2 {
			if (name in SIDES) { return SIDES[name]; }
			trace("TileRegistry.as/parseSide() - Warning: piece \"" + pieceId + "\" has unknown side \"" + name + "\"");

			return E_Direction.NEUTRAL;
		}

		private static function findPiece(id:String, ownerId:String):TilePiece_Definition {
			if (id in piecesById) { return piecesById[id]; }
			trace("TileRegistry.as/findPiece() - Warning: piece \"" + ownerId + "\" links to unknown piece \"" + id + "\"");

			return null;
		}

		private static function addCode(table:Object, piece:TilePiece_Definition):void {
			if (piece.code in table) {
				trace("TileRegistry.as/addCode() - Warning: pieces \"" + table[piece.code].id + "\" and \"" + piece.id + "\" share code \"" + piece.code + "\"");
			}
			table[piece.code] = piece;
		}

		// Builds a definition from tile text: a block code or "_" for none, then any heights, water marks and overlay codes
		private static function decode(code:String, mirror:Boolean):Tile_Definition {
			var definition:Tile_Definition = new Tile_Definition();
			var wallPatch:TilePiece_Definition;			// Last wall patch the text places
			var wallOwner:TilePiece_Definition;			// Last piece that brings a wall of its own
			var symbol:String = code.charAt(0);
			var piece:TilePiece_Definition;
			var i:int;

			definition.code = code;

			// Letters and other characters past "@" open the text with a block, "_" stands for none
			if (symbol > "@" && symbol != "_") {
				piece = blocksByCode[symbol];
				if (piece) {
					addPiece(definition, piece);
					if (piece.wall) { wallOwner = piece; }
				}
				else {
					trace("TileRegistry.as/decode() - Warning: tile \"" + code + "\" opens with unknown block \"" + symbol + "\"");
				}
			}

			for (i = 1; i < code.length; i++) {
				symbol = code.charAt(i);
				switch (symbol) {
					case "*": { definition.water = true;	break; }
					case ",": { setHeight(definition, 3);	break; }
					case ";": { setHeight(definition, 2);	break; }
					case ":": { setHeight(definition, 1);	break; }
					default: {
						piece = overlaysByCode[symbol];
						if (piece) {
							if (mirror && piece.mirror) {
								piece = piece.mirror;
							}
							addPiece(definition, piece);
							if (piece.layer == E_TileLayer.BACK_WALL) { wallPatch = piece; }
							if (piece.wall) { wallOwner = piece; }
						}
						else {
							trace("TileRegistry.as/decode() - Warning: tile \"" + code + "\" has unknown piece \"" + symbol + "\"");
						}
						break;
					}
				}
			}

			// Differs from vanilla, where a full-height block's own wall replaced any wall patch the room placed behind it
			if (wallPatch) {
				definition.wall = wallPatch;
			}
			else if (wallOwner && wallOwner.leavesWall && definition.height == 4) {
				definition.wall = wallOwner.wall;
			}

			return definition;
		}

		// Folds one piece's values into a definition, later pieces overriding earlier ones
		private static function addPiece(definition:Tile_Definition, piece:TilePiece_Definition):void {
			definition.pieces.push(piece);

			if (piece.material != E_Material.NONE)	{ definition.material = piece.material; }
			if (piece.hp != 0)						{ definition.hp = piece.hp; }
			if (piece.damageThreshold != 0)			{ definition.damageThreshold = piece.damageThreshold; }
			if (piece.indestructible)				{ definition.indestructible = true; }

			switch (piece.behaviour) {
				case E_TileBehaviour.SOLID:		{ definition.collision = 1;				break; }
				case E_TileBehaviour.PLATFORM:	{ definition.platform = true;			break; }
				case E_TileBehaviour.LADDER:		{ definition.ladderSide = piece.side;	break; }
				case E_TileBehaviour.SLOPE:		{ definition.slopeSide = piece.side;	break; }
				case E_TileBehaviour.HIDING_SPOT:	{ definition.hidingSpot = true;			break; }
			}

			// A solid tile blocks light again even after a lowered height let it through
			if (definition.collision > 0) { definition.opacity = 1.0; }
		}

		// A lowered tile lets light through
		private static function setHeight(definition:Tile_Definition, height:int):void {
			definition.height = height;
			definition.opacity = 0.0;
		}

		public static function load():void {
			var loader:TextLoader = new TextLoader();
			var data:Object = loader.syncLoad(PIECES_PATH);
			var entry:Object;
			var piece:TilePiece_Definition;
			var i:int;

			if (TextLoader.isEmpty(data)) {
				throw new Error("TileRegistry.as/load() - Error: failed to load " + PIECES_PATH);
			}

			for each (entry in data.pieces) {
				piece = readPiece(entry);
				if (piece.texture == "" && piece.spriteFrame == 0) {
					trace("TileRegistry.as/load() - Warning: piece \"" + piece.id + "\" has neither a texture nor a sprite frame, so it draws nothing");
				}
				pieces.push(piece);
				piecesById[piece.id] = piece;
				addCode((piece.layer == E_TileLayer.MAIN) ? blocksByCode : overlaysByCode, piece);
			}

			for (i = 0; i < pieces.length; i++) {
				entry = data.pieces[i];
				if ("wall" in entry) { pieces[i].wall = findPiece(entry.wall, pieces[i].id); }
				if ("mirror" in entry) { pieces[i].mirror = findPiece(entry.mirror, pieces[i].id); }
			}
		}

		public static function viewPieces():Vector.<TilePiece_Definition> {
			return pieces;
		}

		// The shared definition for one entry of a room's tile rows
		public static function viewDefinition(code:String, mirror:Boolean):Tile_Definition {
			var cache:Object = mirror ? mirroredDefinitions : definitions;
			var definition:Tile_Definition = cache[code];

			if (!definition) {
				definition = decode(code, mirror);
				cache[code] = definition;
			}

			return definition;
		}

		// What a solid tile becomes when the room's border reskins it with the land's border block. It keeps its height and hiding spot
		public static function viewBorderDefinition(code:String, previous:Tile_Definition):Tile_Definition {
			var key:String = code + previous.height + (previous.hidingSpot ? "h" : "");
			var definition:Tile_Definition = borderDefinitions[key];
			var block:TilePiece_Definition;

			if (definition) { return definition; }

			block = blocksByCode[code];
			if (!block) {
				trace("TileRegistry.as/viewBorderDefinition() - Error: no block has code \"" + code + "\"");
				return previous;
			}

			definition = new Tile_Definition();
			definition.code = code;
			definition.pieces.push(block);
			if (block.leavesWall) { definition.wall = block.wall; }
			definition.height = previous.height;
			definition.hidingSpot = previous.hidingSpot;
			definition.collision = 1;
			definition.hp = BORDER_HP;
			definition.damageThreshold = block.damageThreshold;
			definition.indestructible = true;
			definition.material = block.material;
			definition.opacity = 1.0;
			borderDefinitions[key] = definition;

			return definition;
		}
	}
}
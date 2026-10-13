package fe.game.rendering {

	import flash.display.BitmapData;
	import flash.filters.BevelFilter;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.utils.getDefinitionByName;

	import fe.game.GameContainer;
	import fe.game.domain.location.tile.TilePiece_Definition;
	import fe.game.stubs.TileMask;

	// The loaded bitmaps, masks and filters Grafon paints one tile piece with
	public class TilePieceTextures {

		private static const FILTERS:Object = {
			"potek"			: [ new BevelFilter(10,270,0,0,0,0.5,1,10,1,3),new GlowFilter(0,2,2,2,2,1,true) ],
			"shad"			: [ new DropShadowFilter(5,90,0,1,12,12,1,3) ],
			"cont"			: [ new GlowFilter(0,1,15,15,1,3,true) ],
			"cont_metal"	: [ new GlowFilter(0,1,2,2,2,1,true), new GlowFilter(0,1,15,15,1,3,true) ],
			"cont_th"		: [ new GlowFilter(0,1,5,5,1,3,true),new GlowFilter(0,2,2,2,2,1,true) ],
			"plitka"		: [ new BevelFilter(2,70,0xFFFFFF,0.5,0,0.5,2,2,1,1),new GlowFilter(0,0.5,5,5,1,3,false) ],
			"dyrka"			: [ new DropShadowFilter(10,70,0,2,10,10,1,3,true),new BevelFilter(2,250,0xFFFFFF,0.7,0,0.7,3,3,1,1) ],
			"cloud"			: [ new DropShadowFilter(5,90,0x375774,1,5,7,1,3,true),new BevelFilter(2,250,0xFFFFFF,0.7,0,0.7,3,3,1,1) ]
		};

		public var piece:TilePiece_Definition;
		public var used:Boolean				= false;	// A tile in the room being drawn shows this piece
		public var texture:BitmapData;
		public var stableTexture:BitmapData;			// Replaces texture in the player's home stable
		public var edgeTexture:BitmapData;
		public var topTexture:BitmapData;
		public var textureMask:Class;
		public var edgeMask:Class;
		public var topMask:Class;
		public var filters:Array;

		private static function loadBitmap(name:String):BitmapData {
			if (name == "") { return null; }

			return GameContainer.reference.grafon.getObj(name, Grafon.numbMat);
		}

		private static function findMask(name:String, pieceId:String):Class {
			if (name == "") { return null; }

			try {
				return getDefinitionByName(name) as Class;
			}
			catch (err:ReferenceError) {
				trace("TilePieceTextures.as/findMask() - Warning: piece \"" + pieceId + "\" names mask class \"" + name + "\", which doesn't exist");
			}

			return null;
		}

		public function TilePieceTextures(piece_:TilePiece_Definition) {
			piece			= piece_;
			texture			= loadBitmap(piece.texture);
			stableTexture	= loadBitmap(piece.stableTexture);
			edgeTexture		= loadBitmap(piece.edgeTexture);
			topTexture		= loadBitmap(piece.topTexture);
			textureMask		= findMask(piece.textureMask, piece.id) || TileMask;
			edgeMask		= findMask(piece.edgeMask, piece.id);
			topMask			= findMask(piece.topMask, piece.id);

			if (piece.filter != "") {
				filters = FILTERS[piece.filter];
				if (!filters) {
					trace("TilePieceTextures.as/TilePieceTextures() - Warning: piece \"" + piece.id + "\" names unknown filter \"" + piece.filter + "\"");
				}
			}
		}
	}
}
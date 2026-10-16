package fe.game.rendering {

	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.display.Bitmap;
	import flash.geom.Matrix;
	import flash.geom.ColorTransform;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.filters.BlurFilter;
	import flash.filters.ColorMatrixFilter;
	import flash.ui.MouseCursorData;
	import flash.ui.Mouse;
	import flash.utils.Dictionary;

	import fe.engine.utils.SymbolFactory;
	import fe.game.World;
	import fe.game.GameContainer;
	import fe.engine.utils.Vec2;
	import fe.game.domain.location.Land;
	import fe.game.domain.location.Location;
	import fe.game.domain.entities.Entity;
	import fe.game.domain.entities.BoundingBox;
	import fe.game.domain.units.Unit;
	import fe.game.enums.E_Material;
	import fe.game.rendering.enums.E_Decal;
	import fe.game.domain.location.tile.Tile;
	import fe.game.domain.location.tile.TilePiece_Definition;
	import fe.game.domain.location.tile.TileRegistry;
	import fe.game.domain.location.tile.enums.E_TileBehaviour;
	import fe.game.domain.location.tile.enums.E_TileLayer;

	public class Grafon {
		
		// colors
		private static const COLOR_TRANSPARENT:uint		= 0xFF000000;
		private static const COLOR_BLACK:uint			= 0x00000000;
		private static const CENTRE:Point				= new Point(0.5, 0.5);

		private var backdrop:Backdrop = new Backdrop();			// The background texture (Manages itself and is rendered by Starling)
		private var starlingView:StarlingView;					// The room's layers drawn by Starling, under visual

		public var objectLayers:ObjectLayers;					// Object layers 0 to 2, drawn by Starling; the rest of visObjs are Flash's
		public var flipbooks:FlipbookManager;					// The objects' art for the object layers
		public var unitSheets:UnitSheetManager;					// The units' sprite sheets for the object layers
		public var effects:EffectManager;						// Catalog textures through modifiers, still or animated
		public var shadows:ShadowPass;							// Objects add their art as casters of the room's shadow

		private var debug:DebugLayer;				// Class to handle all the logic for drawing debug info
		private var visBoundingBoxes:Sprite = null; // Container for bounding boxes

		public var loc:Location;

		public var visual:Sprite;
		public var visObjs:Array;
		private const kolObjs:int = 6;
		public var visVoda:Sprite;
		public var visFront:Sprite;
		private var visForeground:Sprite;
		public var visLight:Sprite;
		public var visSats:Sprite;
		public var skyPicture:MovieClip;				// The land's sky picture, inside GUIManager's sky clip

		private var resX:int;			// Screen pixel width
		private var resY:int;			// Screen pixel height

		public var frontBmp:BitmapData;
		private var frontBitmap:Bitmap;
		private var foregroundBmp:BitmapData;			// Foreground tile pieces, over the main ones
		private var foregroundBitmap:Bitmap;
		private var vodaBmp:BitmapData;
		private var vodaBitmap:Bitmap;
		public var lightBmp:BitmapData;
		private var lightBitmap:Bitmap;
		public var satsBmp:BitmapData;
		private var satsBitmap:Bitmap;
		private var infraTransform:ColorTransform	= new ColorTransform(1, 1, 1, 1, 100);
		private var defTransform:ColorTransform		= new ColorTransform();

		public var brushColor:uint					= 0xFFFFFF;	// The colour paint strokes draw in

		private var voda:MovieClip = SymbolFactory.createInstance("tileVoda");	// .SWF Dependency

		private var m:Matrix;
		
		//рамки
		public var ramT:MovieClip;
		public var ramB:MovieClip;
		public var ramL:MovieClip;
		public var ramR:MovieClip;
		
		private var tileTextures:Vector.<TilePieceTextures>;	// One per tile piece drawn from textures, in data order
		private var texturesByPiece:Dictionary;				// The same, by TilePiece_Definition
		
		private var rectX:int = 1920;
		private var rectY:int = 1000;
		private var allRect:Rectangle = new Rectangle(0, 0, rectX, rectY);
		
		private var lightX:int = 49;
		private var lightY:int = 28;
		private var lightRect:Rectangle = new Rectangle(0, 0, lightX, lightY);
		
		//загрузка
		public var resIsLoad:Boolean			= false;
		public var progressLoad:Number			= 0;
		public static var spriteLists:Array		= [];
		
		// Lack of '.swf' indicates loose textures in a folder
		public static var texUrl:Array = ["texture", "texture1.swf", "sprite.swf", "sprite1.swf"];
		public var grLoaders:Array;
		
		public static const numbMat:int		= 0;		//материалы
		public static const numbFon:int		= 0;		//задники
		public static const numbBack:int	= 1;		//декорации
		public static const numbObj:int		= 1;		//объекты
		public static const numbSprite:int	= 2;	//номер, с которого начинаются файлы спрайтов

		private static var tileX:int = Tile.tileX;
		private static var tileY:int = Tile.tileY;
		
		public function Grafon(nvis:Sprite) {
			// Main container
			visual = nvis;

			// Drawing the room. The back wall and background are drawn by Starling, under all of these.
			starlingView		= new StarlingView(visual, this);
			objectLayers		= starlingView.objectLayers;
			shadows				= starlingView.shadows;
			flipbooks			= new FlipbookManager(updateLoaded);
			unitSheets			= new UnitSheetManager();
			effects				= new EffectManager(this);
			visVoda				= new Sprite();
			visVoda.alpha		= 0.6;
			visFront			= new Sprite();
			visForeground		= new Sprite();
			visLight			= new Sprite();
			visSats				= new Sprite();
			visSats.visible		= false;
			visSats.filters		= [new BlurFilter(3, 3, 1)];

			// Drawing bounding boxes
			debug								= new DebugLayer();
			visBoundingBoxes					= new Sprite();	// Layer to draw all bounding boxes on
			visBoundingBoxes.mouseEnabled		= false; // Prevent bounding boxes from blocking mouse events
			visBoundingBoxes.mouseChildren		= false;
			
			visObjs = [];
			for (var i:int = 0; i < kolObjs; i++) {
				visObjs.push(new Sprite());
			}
			
			visual.addChild(visObjs[0]);	//  1
			visual.addChild(visObjs[1]);	//  2
			visual.addChild(visObjs[2]);	//  3
			visual.addChild(visFront);		//  4
			visual.addChild(visForeground);
			visual.addChild(visObjs[3]);	//  6
			visual.addChild(visVoda);		//  5
			visual.addChild(visLight);		//  7
			visual.addChild(visObjs[4]);	//  8
			visual.addChild(visSats);		//  9
			visual.addChild(visObjs[5]);	// 10
			
			visLight.x = -tileX * 0.50;
			visLight.y = -tileX * 0.50 - Tile.tileY;
			visLight.scaleX = tileX;
			visLight.scaleY = Tile.tileY;
			
			frontBmp = new BitmapData(rectX, rectY, true, COLOR_BLACK)
			frontBitmap = new Bitmap(frontBmp);
			visFront.addChild(frontBitmap);

			foregroundBmp = new BitmapData(rectX, rectY, true, COLOR_BLACK);
			foregroundBitmap = new Bitmap(foregroundBmp);
			visForeground.addChild(foregroundBitmap);

			vodaBmp = new BitmapData(rectX, rectY, true, COLOR_BLACK)
			vodaBitmap = new Bitmap(vodaBmp);
			visVoda.addChild(vodaBitmap);
			
			satsBmp = new BitmapData(rectX, rectY, true, 0);
			satsBitmap = new Bitmap(satsBmp, "auto", true);
			visSats.addChild(satsBitmap);

			lightBmp = new BitmapData(lightX, lightY, true, COLOR_TRANSPARENT);
			lightBitmap = new Bitmap(lightBmp, "auto", true);
			visLight.addChild(lightBitmap);

			ramT = SymbolFactory.createInstance("visBlack");
			ramB = SymbolFactory.createInstance("visBlack");
			ramR = SymbolFactory.createInstance("visBlack");
			ramL = SymbolFactory.createInstance("visBlack");

			ramT.cacheAsBitmap = true;
			ramB.cacheAsBitmap = true;
			ramR.cacheAsBitmap = true;
			ramL.cacheAsBitmap = true;
			
			visual.addChild(ramT);
			visual.addChild(ramB);
			visual.addChild(ramR);
			visual.addChild(ramL);
			
			// START LOADING TEXTURES HERE

			grLoaders = [];
			for (var j:int = 0; j < texUrl.length; j++) {
				var textureURL:String = texUrl[j];
				// Check if 'textureURL' contains '.swf'
				if (textureURL.indexOf(".swf") != -1) {
					grLoaders[j] = new GrLoader(j, textureURL, this, "swf");
				}
				else {
					grLoaders[j] = new GrLoader(j, textureURL, this, "looseImage");
				}
			}
			
			createCursors();
		}
		
		// Checks whether all resources have finished loading
		public function checkLoaded(n:int):void {
			var piece:TilePiece_Definition;
			var textures:TilePieceTextures;

			// 0 is tile and sky textures
			if (n == 0) {
				tileTextures = new Vector.<TilePieceTextures>();
				texturesByPiece = new Dictionary();
				for each (piece in TileRegistry.viewPieces()) {
					if (piece.texture != "") {
						textures = new TilePieceTextures(piece);
						tileTextures.push(textures);
						texturesByPiece[piece] = textures;
					}
				}
			}


			updateLoaded();
		}

		// Whether every texture, sprite sheet and flipbook has loaded
		private function updateLoaded():void {
			resIsLoad = (GrLoader.kolIsLoad >= GrLoader.kol) && flipbooks.isLoaded;
		}
		
		public function allProgress():void {
			progressLoad = 0;
			
			for (var loader:String in grLoaders) {
				progressLoad += grLoaders[loader].progressLoad;
			}
			
			progressLoad /= GrLoader.kol;
		}
		
		private function createCursors():void {
			var fetch:Function = SymbolFactory.fetchSymbolClass;

			createCursor(fetch("visCurArrow"),   "arrow");
			createCursor(fetch("visCurTarget"),  "target", 13, 13);
			createCursor(fetch("visCurTarget1"), "combat", 13, 13);
			createCursor(fetch("visCurTarget2"), "action", 13, 13);
 		}
		
		private function createCursor(vcur:Class, nazv:String, nx:int=0, ny:int=0):void {
			var cursorData:Vector.<BitmapData> = new Vector.<BitmapData>();
			var mouseCursorData:MouseCursorData = new MouseCursorData();
			
			cursorData.push(new vcur());
            mouseCursorData.data = cursorData;
			mouseCursorData.hotSpot = new Point(nx, ny);
            
			Mouse.registerCursor(nazv, mouseCursorData);
		}
		
//============================================================================================		
//							Начальная прорисовка локации
//============================================================================================		
		
		// Draws the bounding box of various objects. Settings for this are in DebugLayer.as
		public function drawDebugLayer():void {
			visual.addChild(debug.drawAllBoundingBoxes());
		}

		// How big one copy of a loose texture draws in the room, in room pixels, or null when the manifest gives no size
		public function viewDrawSize(textureName:String):Point {
			return grLoaders[numbMat].drawSizes[textureName];
		}

		// Where a loose texture's origin lies, as fractions of its size; its centre when the manifest gives none
		public function viewPivot(textureName:String):Point {
			return grLoaders[numbMat].pivots[textureName] || CENTRE;
		}

		// Scales a loose texture's fill from its pixels to the size it draws in the room
		private function fillMatrix(textureName:String, bitmap:BitmapData):Matrix {
			var size:Point = viewDrawSize(textureName);

			if (!size) { return null; }

			return new Matrix(size.x / bitmap.width, 0.0, 0.0, size.y / bitmap.height);
		}

		public function getObj(textureName:String, n:int = 0):* {
			if (grLoaders[n] && grLoaders[n].isLoad) {
				return grLoaders[n].getObj(textureName);
			}
			else {
				trace("GrLoader not loaded or invalid index:", n);
				return null;
			}
		}
		
		// Draw the sky texture
		public function drawSky(sky:MovieClip, tex:String):void {
			// Set default texture if none provided
			if (tex == "" || tex == null) {
				tex = "fonDefault";
			}

			// Remove the existing background if present
			if (skyPicture && sky.contains(skyPicture)) {
				sky.removeChild(skyPicture);
			}

			// Retrieve the sky bitmap
			var obj:Object = getObj(tex);

			if (obj) {
				// Check if the object is already a MovieClip
				if (obj is MovieClip) {
					skyPicture = obj as MovieClip;
				}
				// If it's BitmapData, wrap it inside a Bitmap and then a MovieClip
				else if (obj is BitmapData) {
					var bitmap:Bitmap = new Bitmap(obj as BitmapData);
					var mc:MovieClip = new MovieClip();
					mc.addChild(bitmap);
					skyPicture = mc;
				}
				// Optionally handle other types or throw an error
				else {
					throw new TypeError("Unsupported object type for skyPicture");
				}

				// Add the MovieClip to the backdrop
				sky.addChild(skyPicture);
			}
			else {
				trace("Warning: skyPicture object not found for texture:", tex);
			}

			backdrop.dirty = true;
		}

		public function setSkySize(nx:Number, ny:Number):void {
			if (skyPicture) {
				if (nx>rectX && ny>rectY) {
					skyPicture.x = visual.x;
					skyPicture.y = visual.y;
					skyPicture.width = rectX;
					skyPicture.height = rectY;
				}
				else {
					var koef:Number = skyPicture.width / skyPicture.height;
					skyPicture.x = 0;
					skyPicture.y = 0;

					if (nx >= ny * koef) {
						skyPicture.width = nx;
						skyPicture.height = nx / koef;
					}
					else {
						skyPicture.height = ny;
						skyPicture.width = ny * koef;
					}
				}
			}

			backdrop.dirty = true;
		}

		public function warShadow():void {
			if (GameContainer.reference.pers.infravis) {
				visLight.transform.colorTransform = infraTransform;
				visLight.blendMode = "multiply";
			}
			else {
				visLight.transform.colorTransform = defTransform
				visLight.blendMode = "normal";
			}
		}
	
		// [Location drawing]
		public function drawLoc(nloc:Location):void {
			GameContainer.reference.gr_stage=1;
			loc = nloc;
			loc.grafon = this;
			resX = loc.spaceX * tileX;
			resY = loc.spaceY * Tile.tileY;
			
			GameContainer.reference.gr_stage = 2;
			//рамки
			ramT.x = -50;
			ramB.x = -50;
			ramR.y = 0;
			ramL.y = 0;
			ramT.y = 0;
			ramL.x = 0;
			ramB.y = loc.maxY - 1;
			ramR.x = loc.maxX - 1;
			ramT.scaleX = loc.maxX * 0.01 + 1;
			ramB.scaleX = loc.maxX * 0.01 + 1;
			ramT.scaleY = 2;
			ramB.scaleY = 2;
			ramR.scaleY = loc.maxY * 0.01;
			ramL.scaleY = loc.maxY * 0.01;
			ramR.scaleX = 2;
			ramL.scaleX = 2;
		
			GameContainer.reference.gr_stage = 3;		// [somewhere here] (I assume this means whatever graphical bug)
			frontBmp.lock();
			foregroundBmp.lock();
			vodaBmp.lock();

			frontBmp.fillRect(allRect, 0);
			foregroundBmp.fillRect(allRect, 0);
			vodaBmp.fillRect(allRect,  0);
			satsBmp.fillRect(allRect,  0);
			
			lightBmp.fillRect(lightRect, COLOR_TRANSPARENT);
			setLight();
			visLight.visible = loc.black && GameContainer.reference.black;
			warShadow();

			GameContainer.reference.gr_stage=4;

			m = new Matrix();
			var tile:MovieClip;
			var t:Tile;
			var tileAbove:Tile;
			var front:Sprite	= new Sprite();	// Sprites for the main layer's bitmap
			var fore:Sprite		= new Sprite();	// Sprites for the foreground layer's bitmap
			var voda:Sprite		= new Sprite();	// [fingerprint on the water bitmap]
			
			//отключить все материалы
			var textures:TilePieceTextures;
			var piece:TilePiece_Definition;
			for each (textures in tileTextures) {
				textures.used = false;
			}

			GameContainer.reference.gr_stage=5;
			for (var i:int = 0; i < loc.spaceX; i++) {
				for (var j:int = 0; j < loc.spaceY; j++) {
					t = loc.getTile(i, j);
					loc.tileKontur(i, j, t);

					if (t.definition.wall) {
						markUsed(t.definition.wall);
					}

					for each (piece in t.definition.pieces) {
						if (piece.layer == E_TileLayer.BACK_WALL || !t.showsPiece(piece)) {
							continue;
						}
						if (piece.spriteFrame == 0) {
							markUsed(piece);
							continue;
						}
						// Sprites behind units are drawn by Starling
						if (piece.layer < E_TileLayer.MAIN) {
							continue;
						}

						tile = SymbolFactory.createInstance("tileFront");
						tile.gotoAndStop(piece.spriteFrame + ((t.ladderTop && piece.behaviour == E_TileBehaviour.LADDER) ? 1 : 0));
						if (piece.layer == E_TileLayer.MAIN) {
							front.addChild(tile);
						}
						else {
							fore.addChild(tile);
						}
						tile.x = i * tileX;
						tile.y = j * Tile.tileY;
					}

					if (t.water) {				// [Water]
						tile = SymbolFactory.createInstance("tileVoda");
						tile.gotoAndStop(loc.tipWater + 1);

						tileAbove = loc.getTile(i, j - 1);
						if (tileAbove.water == 0 && tileAbove.collision == 0) {
							tile.voda.gotoAndStop(2);
						}
						
						tile.x = i * tileX;
						tile.y = j * Tile.tileY;
						voda.addChild(tile);
					}
				}
			}

			GameContainer.reference.gr_stage = 6;
			vodaBmp.draw(voda, new Matrix, null, null, null, false);
			frontBmp.draw(front, new Matrix, null, null, null, false);
			foregroundBmp.draw(fore, new Matrix, null, null, null, false);
			
			GameContainer.reference.gr_stage = 7;
			drawTileLayer(E_TileLayer.MAIN);
			drawTileLayer(E_TileLayer.FOREGROUND);

			GameContainer.reference.gr_stage = 8;
			if (nloc.cTransform) {
				frontBmp.colorTransform(frontBmp.rect,nloc.cTransform);
				foregroundBmp.colorTransform(foregroundBmp.rect,nloc.cTransform);
				vodaBmp.colorTransform(vodaBmp.rect,nloc.cTransform);
			}

			GameContainer.reference.gr_stage = 9;
			starlingView.backLayers.draw(loc, tileTextures);

			GameContainer.reference.gr_stage = 10;
			frontBmp.unlock();
			foregroundBmp.unlock();
			vodaBmp.unlock();
			
			if (nloc.cTransform && nloc.cTransformSky) {
				skyPicture.transform.colorTransform = nloc.cTransformSky;
			}
			else if (skyPicture.transform.colorTransform != defTransform) {
				skyPicture.transform.colorTransform = defTransform;
			}

			backdrop.dirty = true;
				
			GameContainer.reference.gr_stage = 11;
			// [Active objects]
			drawAllObjs();

			GameContainer.reference.gr_stage = 0;
		}
		
		// Frees every unit sheet that no unit of the land uses, nor any of the player's pets
		public function keepLandSheets(land:Land):void {
			var used:Vector.<UnitSheet_Definition> = new Vector.<UnitSheet_Definition>();
			var location:Location;
			var unit:Unit;

			for each (location in land.listLocs) {
				for each (unit in location.units) {
					if (unit.art) {
						used.push(unit.art.definition);
					}
				}
			}
			for each (unit in GameContainer.reference.gg.pets) {
				if (unit.art) {
					used.push(unit.art.definition);
				}
			}
			unitSheets.keepOnly(used);
		}

		//прорисовка всей карты затемнения
		public function setLight():void {
			var space:Vector.<Tile> = loc.space;
			var spaceX:int = loc.spaceX;
			var spaceY:int = loc.spaceY;
			var row:int;
			var index:int;
			var i:int;
			var j:int;

			lightBmp.lock();

			for (j = 1; j < spaceY; j++) {
				row = j * spaceX;
				for (i = 1; i < spaceX; i++) {
					index = row + i;
					lightBmp.setPixel32(i, j + 1, int((1.0 - space[index].visibility) * 255.0) << 24);
				}
			}

			lightBmp.unlock();
		}
		
		//добавление всех видимых объектов
		public function drawAllObjs():void {
			objectLayers.clear();
			shadows.clearCasters();
			for (var i:int = 0; i < kolObjs; i++) {
				var n:int = visual.getChildIndex(visObjs[i]);
				visual.removeChild(visObjs[i]);
				visObjs[i] = new Sprite();
				visual.addChildAt(visObjs[i], n);
			}

			var obj:Entity = loc.firstObj;

			while (obj) {
				obj.addVisual();
				obj = obj.nobj;
			}

			loc.gg.addVisual();

			for each (var signpost:MovieClip in loc.signposts) {
				visObjs[3].addChild(signpost);
			}
		}
		
		private function setMovieClipTile(mc:MovieClip, t:Tile):void {
			if (mc.c1) {
				mc.c1.gotoAndStop(t.mainOutline1 + 1);
				mc.c2.gotoAndStop(t.mainOutline2 + 1);
				mc.c3.gotoAndStop(t.mainOutline3 + 1);
				mc.c4.gotoAndStop(t.mainOutline4 + 1);
			}
		}

		// Pieces without textures were reported when the registry loaded, and draw nothing
		private function markUsed(piece:TilePiece_Definition):void {
			var textures:TilePieceTextures = texturesByPiece[piece];

			if (textures) {
				textures.used = true;
			}
		}
		
		// Draws every tile showing a textured piece of the main or foreground layer: its texture cut by its mask, then its edge and top textures cut by theirs
		private function drawPiece(textures:TilePieceTextures):void {
			var piece:TilePiece_Definition = textures.piece;
			var roomPixelWidth:int = resX;
			var roomPixelHeight:int = resY;

			// Cache frequently accessed properties
			var spaceX:int = loc.spaceX;
			var spaceY:int = loc.spaceY;
			var currentTileX:int = tileX;
			var currentTileY:int = tileY;
			var altTexture:BitmapData = textures.stableTexture;
			var texture:BitmapData = textures.texture;
			var borderTexture:BitmapData = textures.edgeTexture;
			var floorTexture:BitmapData = textures.topTexture;
			var borderMaskClass:Class = textures.edgeMask;
			var floorMaskClass:Class = textures.topMask;
			var filters:Array = textures.filters;
			var homeStable:Boolean = loc.homeStable;

			var halfTileX:Number = 0.5 * currentTileX;
			var halfTileY:Number = 0.5 * currentTileY;

			var hasBorderMask:Boolean = (borderMaskClass != null);
			var hasFloorMask:Boolean = (floorMaskClass != null);
			
			var t:Tile;
			var mc:MovieClip;
			var shows:Boolean;

			var kusok:Sprite    = new Sprite();    
			var osn:Sprite      = new Sprite();
			var maska:Sprite    = new Sprite();
			var border:Sprite   = new Sprite();
			var bmaska:Sprite   = new Sprite();
			var floor:Sprite    = new Sprite();
			var fmaska:Sprite   = new Sprite();
			
			// Use cached textures
			if (texture) {
				if (homeStable && altTexture != null) {
					osn.graphics.beginBitmapFill(altTexture, fillMatrix(piece.stableTexture, altTexture));
				}
				else {
					osn.graphics.beginBitmapFill(texture, fillMatrix(piece.texture, texture));
				}
			}
			else {
				osn.graphics.beginFill(0x666666);
			}

			osn.graphics.drawRect(0, 0, roomPixelWidth, roomPixelHeight);

			kusok.addChild(osn);
			kusok.addChild(maska);
			
			if (borderTexture) {
				border.graphics.beginBitmapFill(borderTexture, fillMatrix(piece.edgeTexture, borderTexture));
				border.graphics.drawRect(0, 0, roomPixelWidth, roomPixelHeight);
				kusok.addChild(border);
				kusok.addChild(bmaska);
			}
			
			if (floorTexture) {
				floor.graphics.beginBitmapFill(floorTexture, fillMatrix(piece.topTexture, floorTexture));
				floor.graphics.drawRect(0, 0, roomPixelWidth, roomPixelHeight);
				kusok.addChild(floor);
				kusok.addChild(fmaska);
			}
			
			var isDraw:Boolean = false;
			
			// Cache loop variables
			for (var i:int = 0; i < spaceX; i++) {
				for (var j:int = 0; j < spaceY; j++) {
					t = loc.getTile(i, j);
					// Cache tile properties
					var tLowered:int = 4 - t.definition.height;
					var tBoundingBox:BoundingBox = t.boundingBox;

					shows = t.showsPiece(piece) && t.definition.pieces.indexOf(piece) >= 0;
					
					if (shows) {
						isDraw = true;
						mc = new textures.textureMask();
						setMovieClipTile(mc, t);
						mc.x = (i + 0.5) * currentTileX;
						mc.y = (j + 0.5) * currentTileY;
						maska.addChild(mc);
						if (tLowered > 0) {
							mc.scaleY = (tBoundingBox.bottom - tBoundingBox.top) / currentTileY;
							mc.y = (tBoundingBox.bottom + tBoundingBox.top) / 2;
						}                            
						if (hasBorderMask) {
							mc = new borderMaskClass();
							setMovieClipTile(mc, t);
							mc.x = (i + 0.5) * currentTileX;
							mc.y = (j + 0.5) * currentTileY;
							bmaska.addChild(mc);
							if (tLowered > 0) {
								mc.scaleY = (tBoundingBox.bottom - tBoundingBox.top) / currentTileY;
								mc.y = (tBoundingBox.bottom + tBoundingBox.top) / 2;
							}                            
						}
						if (hasFloorMask) {
							mc = new floorMaskClass();
							if (mc.c1) {
								mc.c1.gotoAndStop(t.mainOutline1 + 1);
								mc.c2.gotoAndStop(t.mainOutline2 + 1);
							}
							fmaska.addChild(mc);
							mc.x = (i + 0.5) * currentTileX;
							mc.y = (j + 0.5 + tLowered / 4) * currentTileY;
						}
					}
				}
			}

			if (!isDraw) {
				return;
			}

			m.tx = 0;
			m.ty = 0;
			
			// Cache setting as Bitmap
			osn.cacheAsBitmap		= true;
			maska.cacheAsBitmap		= true;
			border.cacheAsBitmap	= true;
			bmaska.cacheAsBitmap	= true;
			floor.cacheAsBitmap		= true;
			fmaska.cacheAsBitmap	= true;
			
			// Set masks
			osn.mask				= maska;
			border.mask				= bmaska;
			floor.mask				= fmaska;
			
			// Apply filters if any
			if (filters) {
				kusok.filters = filters;
			}
			
			// Draw to appropriate bitmap
			if (piece.layer == E_TileLayer.FOREGROUND) {
				foregroundBmp.draw(kusok, m, null, null, null, false);
			}
			else {
				frontBmp.draw(kusok, m, null, null, null, false);
			}
		}

		private function drawTileLayer(layer:int):void {
			var textures:TilePieceTextures;

			for each (textures in tileTextures) {
				if (textures.used && textures.piece.layer == layer) {
					drawPiece(textures);
				}
			}
		}
		
//============================================================================================		
//							Время выполнения
//============================================================================================		
		
		public function getSpriteList(id:String, n:int = 0):BitmapData {
			if (spriteLists[id] == null) {
				if (n > 0) {
					spriteLists[id] = getObj(id, numbSprite + n);
				}
				else {
					spriteLists[id] = getObj(id, numbSprite);
					
					if (spriteLists[id] == null) {
						spriteLists[id] = getObj(id, numbSprite + 1);
					}
				}
			}

			if (spriteLists[id] == null) {
				trace("Grafon.as/getSpriteList() - No sprites", id); // (Not my errors message)
			}
			
			return spriteLists[id];
		}
		
		public function drawSats():void {
			satsBmp.fillRect(satsBmp.rect, 0);
			satsBmp.draw(visual, new Matrix);
		}
		
		public function onSats(on:Boolean):void {
			visSats.visible = on;
			visObjs[2].visible =! on;
			objectLayers.showLayer(2, !on);
			starlingView.showSats(on);
		}
		
		//рисование одного блока воды
		public function drawWater(t:Tile, recurs:Boolean = true):void {
			var tileAbove:Tile = loc.getTile(t.coords.X, t.coords.Y - 1);

			m = new Matrix();
			m.tx = t.coords.X * tileX;
			m.ty = t.coords.Y * Tile.tileY;
			voda.gotoAndStop(loc.tipWater + 1);

			if (tileAbove.water == 0 && tileAbove.collision == 0) {
				voda.voda.gotoAndStop(2);
			}
			else {
				voda.voda.gotoAndStop(1);
			}
			
			vodaBmp.draw(voda, m, loc.cTransform, (t.water > 0)? "normal" : "erase", null, false);
			
			if (recurs) {
				drawWater(loc.getTile(t.coords.X, t.coords.Y + 1), false);
			}
		}
		
		public function tileDie(t:Tile,tip:int):void {
			var fetch:Function = SymbolFactory.fetchSymbolClass;

			var erC:Class = fetch("block_dyr");
			var drC:Class = fetch("block_tre");
			
			var nx:Number = (t.coords.X + 0.50) * tileX;
			var ny:Number = (t.coords.Y + 0.50) * tileY;

			if (t.isFakeWall) {
				Emitter.emit("fake", loc, nx, ny);
				drC = fetch("block_bur");		// .SWF Dependency (Class)
			}
			else if (t.material == E_Material.FORCE_FIELD) {
				Emitter.emit("fake", loc, nx, ny);
				Emitter.emit("pole", loc, nx, ny, { kol:10, rx:tileX, ry:tileY });
				//erC = TileMask; ????
				drC = null;
			}
			else if (tip <= E_Decal.EXPLOSION) {
				var emitEffect:Array = ["null", "metal", "kusok", "schep", "kusokB", "steklo", "kusokD"];
				
				if (t.material >= E_Material.METAL && t.material <= E_Material.EARTH) {
					Emitter.emit(emitEffect[t.material],	loc, nx, ny, { kol:6, rx:tileX, ry:tileY });
				}
			}
			else if (tip >= E_Decal.PLASMA) {
				Emitter.emit("plav", loc, nx, ny);
				erC = fetch("block_plav");
				drC = fetch("block_pla");
			}
			else if (tip >= E_Decal.FIRE && tip <= E_Decal.LASER_SMALL) {
				Emitter.emit("bur", loc, nx, ny);
				drC = fetch("block_bur");
			}

			decal(erC, drC, nx, ny, 1, 0, "hardlight");

			starlingView.backLayers.shadowChanged = true;
		}

		// Bullethole
		public function dyrka(nx:int, ny:int, tip:int, mat:int, soft:Boolean = false, ver:Number = 1):void {
			var fetch:Function = SymbolFactory.fetchSymbolClass;
			
			var erC:Class;
			var drC:Class;
			var bl:String = "normal";
			var centr:Boolean = false;
			var sc:Number = Math.random() * 0.50 + 0.50;
			var rc:Number = Math.random() * 360

			if (tip == E_Decal.NONE || mat == E_Material.NONE) {
				return;
			}

			// The hole a hit leaves depends on what the tile is made of
			switch (mat) {
				case E_Material.METAL: {
					if (tip >= E_Decal.BULLET_SMALL && tip <= E_Decal.BLOW_LARGE) {
						drC = fetch("bullet_metal");
					}
					else if (tip == E_Decal.EXPLOSION) {
						if (!soft && Math.random()*0.5<ver) {
							drC = fetch("metal_tre");
						}
						
						centr = true;
					}
					break;
				}
				case E_Material.STONE:
				case E_Material.BRICK:
				case E_Material.EARTH: {
					if (tip >= E_Decal.BULLET_SMALL && tip <= E_Decal.BULLET_LARGE) {
						if (tip != E_Decal.BULLET_SMALL && Math.random() > 0.50) {
							erC = fetch("bullet_dyr");
						}

						drC = fetch("bullet_tre");

						if (tip == E_Decal.BULLET_MEDIUM) {
							sc += 0.50;
						}
						
						if (tip == E_Decal.BULLET_LARGE) {
							sc += 1;
						}
					}
					else if (tip >= E_Decal.BLOW_SMALL && tip <= E_Decal.BLOW_LARGE) {
						if (!soft) {
							drC = fetch("punch_tre");
						}
						
						if (tip == E_Decal.BLOW_MEDIUM) {
							sc+=0.5;
						}
						
						if (tip == E_Decal.BLOW_LARGE) {
							sc+=1;
						}
					}
					else if (tip == E_Decal.EXPLOSION) {
						if (!soft && Math.random() * 0.50 < ver) {
							drC = fetch("expl_tre");
						}

						centr = true;
					}

					if (tip <= E_Decal.EXPLOSION && !soft) {
						if (mat == E_Material.STONE) {
							Emitter.emit("kusoch", loc, nx, ny, { kol:3 });
						}
						else {
							Emitter.emit("kusochB", loc, nx, ny, { kol:3 });
						}
					}
					break;
				}
				case E_Material.WOOD: {
					if (tip >= E_Decal.BULLET_SMALL && tip <= E_Decal.BULLET_LARGE) {
						erC = fetch("bullet_dyr");
						drC = fetch("bullet_wood");
						rc = 0;
						
						if (tip == E_Decal.BULLET_MEDIUM) {
							sc += 0.50;
						}
						
						if (tip == E_Decal.BULLET_LARGE) {
							sc += 1.00;
						}
					}
					else if (tip >= E_Decal.BLOW_SMALL && tip <= E_Decal.BLOW_LARGE) {
						if (!soft) {
							drC = fetch("punch_tre");
						}
						if (tip == E_Decal.BLOW_MEDIUM) {
							sc += 0.50;
						}
						if (tip == E_Decal.BLOW_LARGE) {
							sc += 1;
						}
					}
					else if (tip == E_Decal.EXPLOSION) {
						if (!soft && Math.random() * 0.50 < ver) {
							drC = fetch("expl_tre");
						}

						centr = true;
					}

					if (tip <= E_Decal.EXPLOSION && !soft) {
						Emitter.emit("schepoch",loc,nx,ny,{kol:3});
					}
					break;
				}
				case E_Material.FORCE_FIELD: {
					Emitter.emit("pole",loc,nx,ny,{kol:5});
					break;
				}
				case E_Material.GLASS: {
					break;		// Glass shows no hole
				}
				default: {
					trace("Grafon.as/dyrka() - ERROR: unknown material: \"" + mat + "\" !");
					break;
				}
			}

			// Fire, energy and cold leave a burn mark over any material
			switch (tip) {
				case E_Decal.FIRE: {
					if (Math.random() < 0.10) {
						drC = fetch("fire_soft");
					}
					break;
				}
				case E_Decal.LASER:
				case E_Decal.LASER_SMALL: {
					if (soft && Math.random() * 0.20 > ver) {
						drC = fetch("fire_soft");
					}
					else {
						drC = fetch("laser_tre");
					}

					if (tip == E_Decal.LASER_SMALL) sc *= 0.6;
					bl="hardlight";
					break;
				}
				case E_Decal.PLASMA: {
					if (soft) {
						drC = fetch("plasma_soft");
					}
					else {
						erC = fetch("plasma_dyr");
						drC = fetch("plasma_tre");
					}

					bl = "hardlight";
					break;
				}
				case E_Decal.PLASMA_BLUE: {
					if (soft) {
						drC = fetch("fire_soft");
					}
					else {
						erC = fetch("plasma_dyr");
						drC = fetch("bluplasma_tre");
					}
					bl = "hardlight";
					break;
				}
				case E_Decal.PLASMA_PINK: {
					if (soft) {
						drC = fetch("fire_soft");
					}
					else {
						erC = fetch("plasma_dyr");
						drC = fetch("pinkplasma_tre");
					}
					bl = "hardlight";
					break;
				}
				case E_Decal.CRYO: {
					drC = fetch("cryo_soft");
					bl = "hardlight";
					break;
				}
				case E_Decal.ENERGY_EXPLOSION: {
					if (!soft && Math.random() * 0.50 < ver) {
						drC = fetch("plaexpl_tre");
					}

					centr=true;
					break;
				}
			}
			
			decal(erC, drC, nx, ny, sc, rc, bl);
		}
		
		public function decal(erC:Class, drD:Class, nx:Number, ny:Number, sc:Number = 1.00, rc:Number = 0.00, bl:String = "normal"):void {
			m = new Matrix();
			
			if (sc != 1) {
				m.scale(sc,sc);
			}
			
			if (rc != 0) {
				m.rotate(rc);
			}
			
			m.tx = nx;
			m.ty = ny;
			
			if (erC) {
				var erase:MovieClip = new erC();

				if (erase.totalFrames > 1) {
					erase.gotoAndStop(Math.floor(Math.random() * erase.totalFrames + 1));
				}

				frontBmp.draw(erase, m, null, "erase", null, true);
			}
		
			if (drD) {
				var nagar:MovieClip = new drD();
				
				if (nagar.totalFrames > 1) {
					nagar.gotoAndStop(Math.floor(Math.random() * nagar.totalFrames + 1));
				}
				
				nagar.scaleX = sc;
				nagar.scaleY = sc;
				nagar.rotation = rc;

				var dyrx:int = Math.round(nagar.width  * 0.50 + 2) * 2;
				var dyry:int = Math.round(nagar.height * 0.50 + 2) * 2;
				var res2:BitmapData = new BitmapData(dyrx, dyry, false, COLOR_BLACK);
				var rdx:int = 0;
				var rdy:int = 0;
				
				if (nx-dyrx/2<0) {
					rdx = -(nx - dyrx/2);
				}
				
				if (ny - dyry * 0.50 < 0) {
					rdy = -(ny - dyry * 0.50);
				}
				
				var rect:Rectangle = new Rectangle(nx - dyrx * 0.50 + rdx, ny - dyry * 0.50 + rdy, nx + dyrx * 0.50 + rdx, ny + dyry * 0.50 + rdy);
				var pt:Point = new Point(0, 0);
				res2.copyChannel(frontBmp, rect, pt, BitmapDataChannel.ALPHA, BitmapDataChannel.GREEN);
				frontBmp.draw(nagar, m, (bl == "normal")?World.w.loc.cTransform:null, bl, null, true);
				rect = new Rectangle(0, 0, dyrx, dyry);
				pt = new Point(nx - dyrx * 0.50 + rdx, ny - dyry * 0.50 + rdy);
				frontBmp.copyChannel(res2, rect, pt, BitmapDataChannel.GREEN, BitmapDataChannel.ALPHA);
			}
		}
		
		// Ghost wall spell
		public function gwall(nx:int, ny:int):void {
			var m:Matrix = new Matrix();
			m.tx = nx * tileX;
			m.ty = ny * tileY;
			var wall:MovieClip = SymbolFactory.createInstance("tileGwall");
			frontBmp.draw(wall, m);
		}
		
		// Paints a stroke onto the back wall in brushColor, with the airbrush or the brush
		public function paint(nx1:int, ny1:int, nx2:int, ny2:int, aero:Boolean = false):void {
			starlingView.backLayers.paint(nx1, ny1, nx2, ny2, aero, brushColor);
		}
		
		public function specEffect(n:Number = 0):void {
			// Define the filter lookup table for cases 1 through 6
			const colorMatrixFilters:Array = [
				// Case 0 (unused)
				null,
				// Case 1
				new ColorMatrixFilter([
					 2.0, -0.9, -0.1, 0.0, 0.0,
					-0.4,  1.5, -0.1, 0.0, 0.0,
					-0.4, -0.9,  2.0, 0.0, 0.0,
					 0.0,  0.0,  0.0, 1.0, 0.0
				]),
				// Case 2
				new ColorMatrixFilter([
					-0.574, 1.430,  0.144, 0.0, 0.0,
					 0.426, 0.430,  0.144, 0.0, 0.0,
					 0.426, 1.430, -0.856, 0.0, 0.0,
					 0.000, 0.000,  0.000, 1.0, 0.0
				]),
				// Case 3
				new ColorMatrixFilter([
					0.0, 1.0,  0.0,   0.0, 0.0,
					1.0, 0.0,  0.0,   0.0, 0.0,
					0.0, 0.0, -0.2, 100.0, 0.0,
					0.0, 0.0,  0.0,   1.0, 0.0
				]),
				// Case 4
				new ColorMatrixFilter([
					 0.0, -0.5, -0.5, 0.0, 255.0,
					-0.5,  0.0, -0.5, 0.0, 255.0,
					-0.5, -0.5,  0.0, 0.0, 255.0,
					 0.0,  0.0,  0.0, 1.0,   0.0
				]),
				// Case 5
				new ColorMatrixFilter([
					3.4, 6.70, 0.9, 0.0, -635.0,
					3.4, 6.75, 0.9, 0.0, -635.0,
					3.4, 6.70, 0.9, 0.0, -635.0,
					0.0, 0.00, 0.0, 1.0,    0.0
				]),
				// Case 6
				new ColorMatrixFilter([
					0.33, 0.33, 0.33, 0.0, 0.0,
					0.33, 0.33, 0.33, 0.0, 0.0,
					0.33, 0.33, 0.33, 0.0, 0.0,
					0.00, 0.00, 0.00, 1.0, 0.0
				])
			];

			if (n === 0) {
				// Case 0: Clear filters
				visual.filters = [];
				skyPicture.filters = [];
				starlingView.setEffect(null, 0.0);
				backdrop.dirty = true;
			}
			else if (n >= 1 && n <= 6) {
				// Cases 1-6: Apply the corresponding ColorMatrixFilter from the lookup array
				visual.filters = [colorMatrixFilters[n]];
				starlingView.setEffect(Vector.<Number>(colorMatrixFilters[n].matrix), 0.0);
			}
			else if (n > 100) {
				// Default case for n > 100: Apply BlurFilter
				var blurAmount:Number = n - 100;
				var blur:BlurFilter = new BlurFilter(blurAmount, blurAmount);
				visual.filters = [blur];
				skyPicture.filters = [blur];
				starlingView.setEffect(null, blurAmount);
				backdrop.dirty = true;
			}
			else {
				// Handle unknown cases
				trace("ERROR: Unknown special effect: \"" + n + "\"!");
			}
		}
	}
}
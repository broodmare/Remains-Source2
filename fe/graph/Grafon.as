package fe.graph {

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
	import flash.filters.DropShadowFilter;
	import flash.ui.MouseCursorData;
	import flash.ui.Mouse;
	import flash.utils.Dictionary;
	
	import fl.motion.Color;	// Adobe Animate dependency

	import fe.*;
	import fe.util.Vec2;
	import fe.loc.*;
	import fe.entities.Entity;
	import fe.entities.BoundingBox;
	import fe.enums.E_Material;
	import fe.graph.enums.E_Decal;
	
	// .fla linkages
	import fe.stubs.tileVoda;		
	import fe.stubs.visBlack;
	import fe.stubs.paintaero;
	import fe.stubs.paintbrush;
	import fe.stubs.tileGwall;
	import fe.stubs.tileFront;
	import fe.loc.tile.Tile;
	import fe.loc.tile.TilePiece_Definition;
	import fe.loc.tile.TileRegistry;
	import fe.loc.tile.enums.E_TileBehaviour;
	import fe.loc.tile.enums.E_TileLayer;

	public class Grafon {
		
		// colors
		private static const COLOR_TRANSPARENT:uint		= 0xFF000000;
		private static const COLOR_BLACK:uint			= 0x00000000;
		private static const COLOR_WHITE:uint			= 0xFFFFFFFF;

		private static const SHADOW_REACH:int			= 40;			// How far the drop shadow spreads past a front pixel: its blur plus offset, rounded up to a tile


		private var debug:DebugLayer;				// Class to handle all the logic for drawing debug info
		private var visBoundingBoxes:Sprite = null; // Container for bounding boxes

		public var loc:Location;

		public var visual:Sprite;
		public var visBack:Sprite;
		public var visBack2:Sprite;
		public var visObjs:Array;
		private const kolObjs:int = 6;
		public var visVoda:Sprite;
		public var visFront:Sprite;
		private var visForeground:Sprite;
		public var visLight:Sprite;
		public var visSats:Sprite;
		public var visFon:MovieClip;
		
		private var resX:int;			// Screen pixel width
		private var resY:int;			// Screen pixel height
		private var kusokX:int = 48;	// Room tile width
		private var kusokY:int = 25;	// Room tile height
		
		public var frontBmp:BitmapData;
		private var frontBitmap:Bitmap;
		private var foregroundBmp:BitmapData;			// Foreground tile pieces, over the main ones
		private var foregroundBitmap:Bitmap;
		private var vodaBmp:BitmapData;
		private var vodaBitmap:Bitmap;
		private var backBmp:BitmapData;
		private var backBitmap:Bitmap;
		private var backBmp2:BitmapData;
		private var backBitmap2:Bitmap;
		public var lightBmp:BitmapData;
		private var lightBitmap:Bitmap;
		public var satsBmp:BitmapData;
		private var satsBitmap:Bitmap;
		private var shadBmp:BitmapData;
		private var shadowCasterBmp:BitmapData;			// The main and foreground layers merged, for casting the drop shadow
		private var colorBmp:BitmapData;
		private var transpFon:Boolean;				// The back wall lets the distant background show through; set per room by drawLoc
		private var dsFilter:DropShadowFilter		= new DropShadowFilter(7, 90, 0, 0.75, 16, 16, 1, 3, false, false, true);
		private var infraTransform:ColorTransform	= new ColorTransform(1, 1, 1, 1, 100);
		private var defTransform:ColorTransform		= new ColorTransform();
		
		public var pa:MovieClip;
		public var pb:MovieClip;

		public var brTrans:ColorTransform			= new ColorTransform();
		public var brColor:Color					= new Color();		// Adobe Animate dependency.
		private var brData:BitmapData				= new BitmapData(100, 100, false, COLOR_BLACK);
		private var brPoint:Point					= new Point(0, 0);
		private var brRect:Rectangle				= new Rectangle(0, 0, 50, 50);
		private var pm:Matrix						= new Matrix();
			
		private var voda:MovieClip = new tileVoda();	// .SWF Dependency

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

			// Drawing the room
			visBack				= new Sprite();
			visBack2			= new Sprite();
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
			
			visual.addChild(visBack);		//  0
			visual.addChild(visBack2);		//  0
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

			backBmp = new BitmapData(rectX, rectY, true, COLOR_BLACK)
			backBitmap = new Bitmap(backBmp);
			visBack.addChild(backBitmap);
			
			backBmp2 = new BitmapData(rectX, rectY, true, COLOR_BLACK)
			backBitmap2 = new Bitmap(backBmp2);
			visBack2.addChild(backBitmap2);

			vodaBmp = new BitmapData(rectX, rectY, true, COLOR_BLACK)
			vodaBitmap = new Bitmap(vodaBmp);
			visVoda.addChild(vodaBitmap);
			
			satsBmp = new BitmapData(rectX, rectY, true, 0);
			satsBitmap = new Bitmap(satsBmp, "auto", true);
			visSats.addChild(satsBitmap);
			
			colorBmp = new BitmapData(rectX, rectY, true, 0);
			shadBmp = new BitmapData(rectX, rectY, true, 0);
			shadowCasterBmp = new BitmapData(rectX, rectY, true, 0);
			visBack.addChild(new Bitmap(shadBmp));	// The tiles' drop shadow lies over the back wall as its own layer, so it can be recast when tiles break
			
			lightBmp = new BitmapData(lightX, lightY, true, COLOR_TRANSPARENT);
			lightBitmap = new Bitmap(lightBmp, "auto", true);
			visLight.addChild(lightBitmap);

			ramT = new visBlack();
			ramB = new visBlack();
			ramR = new visBlack();
			ramL = new visBlack();

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


			resIsLoad = (GrLoader.kolIsLoad >= GrLoader.kol);
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
		public function drawFon(vfon:MovieClip, tex:String):void {
			// Set default texture if none provided
			if (tex == "" || tex == null) {
				tex = "fonDefault";
			}
			
			// Remove the existing background if present
			if (visFon && vfon.contains(visFon)) {
				vfon.removeChild(visFon);
			}
			
			// Retrieve the sky bitmap
			var obj:Object = getObj(tex);
			
			if (obj) {
				// Check if the object is already a MovieClip
				if (obj is MovieClip) {
					visFon = obj as MovieClip;
				}
				// If it's BitmapData, wrap it inside a Bitmap and then a MovieClip
				else if (obj is BitmapData) {
					var bitmap:Bitmap = new Bitmap(obj as BitmapData);
					var mc:MovieClip = new MovieClip();
					mc.addChild(bitmap);
					visFon = mc;
				}
				// Optionally handle other types or throw an error
				else {
					throw new TypeError("Unsupported object type for visFon");
				}
				
				// Add the MovieClip to the display list
				vfon.addChild(visFon);
			}
			else {
				trace("Warning: visFon object not found for texture:", tex);
			}
		}
		
		public function setFonSize(nx:Number, ny:Number):void {
			if (visFon) {
				if (nx>rectX && ny>rectY) {
					visFon.x = visual.x;
					visFon.y = visual.y;
					visFon.width = rectX;
					visFon.height = rectY;
				}
				else {
					var koef:int = visFon.width / visFon.height;
					visFon.x = 0;
					visFon.y = 0;
				
					if (nx >= ny * koef) {
						visFon.width = nx;
						visFon.height = nx / koef;
					}
					else {
						visFon.height = ny;
						visFon.width = ny * koef;
					}
				}
			}
		}

		public function warShadow():void {
			if (World.w.pers.infravis) {
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
			World.w.gr_stage=1;
			loc = nloc;
			loc.grafon = this;
			resX = loc.spaceX * tileX;
			resY = loc.spaceY * Tile.tileY;
			
			transpFon = nloc.transpFon;
			
			if (nloc.backwall == "sky") {
				transpFon = true;
			}
			
			World.w.gr_stage = 2;
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
		
			World.w.gr_stage = 3;		// [somewhere here] (I assume this means whatever graphical bug)
			frontBmp.lock();
			foregroundBmp.lock();
			backBmp.lock();
			backBmp2.lock();
			vodaBmp.lock();

			frontBmp.fillRect(allRect, 0);
			foregroundBmp.fillRect(allRect, 0);
			backBmp.fillRect(allRect,  0);
			backBmp2.fillRect(allRect, 0);
			vodaBmp.fillRect(allRect,  0);
			satsBmp.fillRect(allRect,  0);
			
			lightBmp.fillRect(lightRect, COLOR_TRANSPARENT);
			setLight();
			visLight.visible = loc.black && World.w.black;
			warShadow();
			
			var darkness:int = 0xAA + loc.darkness;
			if (darkness > 0xFF) {
				darkness = 0xFF;
			}
			
			if (darkness<0) {
				darkness = 0;
			}
			
			colorBmp.fillRect(allRect, darkness * 0x1000000);
			shadBmp.fillRect(allRect, COLOR_WHITE);

			World.w.gr_stage=4;

			m = new Matrix();
			var tile:MovieClip;
			var t:Tile;
			var tileAbove:Tile;
			var front:Sprite	= new Sprite();	// Sprites for the main layer's bitmap
			var fore:Sprite		= new Sprite();	// Sprites for the foreground layer's bitmap
			var back:Sprite		= new Sprite();	// [fingerprint on the backdrop bitmap]
			var back2:Sprite	= new Sprite();	// [fingerprint on the backdrop bitmap]
			var voda:Sprite		= new Sprite();	// [fingerprint on the water bitmap]
			
			//отключить все материалы
			var textures:TilePieceTextures;
			var piece:TilePiece_Definition;
			for each (textures in tileTextures) {
				textures.used = false;
			}

			var gret:int=0;
			World.w.gr_stage=5;
			for (var i:int = 0; i < loc.spaceX; i++) {
				for (var j:int = 0; j < loc.spaceY; j++) {
					t = loc.getTile(i, j);
					loc.tileKontur(i, j, t);

					if (t.definition.wall) {
						markUsed(t.definition.wall);
					}

					for each (piece in t.definition.pieces) {
						if (piece.layer == E_TileLayer.BACK_WALL || !showsPiece(t, piece)) {
							continue;
						}
						if (piece.spriteFrame == 0) {
							markUsed(piece);
							continue;
						}

						tile = new tileFront();
						tile.gotoAndStop(piece.spriteFrame + ((t.ladderTop && piece.behaviour == E_TileBehaviour.LADDER) ? 1 : 0));
						if (piece.layer < E_TileLayer.MAIN) {
							back2.addChild(tile);
						}
						else if (piece.layer == E_TileLayer.MAIN) {
							front.addChild(tile);
						}
						else {
							fore.addChild(tile);
						}
						tile.x = i * tileX;
						tile.y = j * Tile.tileY;
					}

					if (t.water) {				// [Water]
						tile = new tileVoda();
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

			World.w.gr_stage = 6;
			vodaBmp.draw(voda, new Matrix, null, null, null, false);
			frontBmp.draw(front, new Matrix, null, null, null, false);
			foregroundBmp.draw(fore, new Matrix, null, null, null, false);
			
			
			World.w.gr_stage = 7;
			drawBackWall(nloc.backwall, nloc.backform);	// [Back wall]
			
			World.w.gr_stage = 8;
			drawTileLayer(E_TileLayer.MAIN);
			drawTileLayer(E_TileLayer.FOREGROUND);

			World.w.gr_stage = 9;
			drawTileLayer(E_TileLayer.BACK_WALL);

			World.w.gr_stage = 10;
			satsBmp.copyChannel(backBmp, backBmp.rect, new Point(0 ,0), BitmapDataChannel.ALPHA, BitmapDataChannel.ALPHA);
			var darkness2:Number = 1 - (255 - darkness) / 150;
			// [Background objects]
			var ct:ColorTransform = new ColorTransform();

			World.w.gr_stage = 11;
			for (j = -2; j <= 3; j++) {
				if (j == -1) {
					backBmp.copyChannel(satsBmp, backBmp.rect, new Point(0, 0), BitmapDataChannel.ALPHA, BitmapDataChannel.ALPHA);
				}
				
				for each(var bo:BackObj in loc.backobjs) {	
					if (bo.sloy == j && !bo.er || j == -2 && bo.er) {
						m = new Matrix();
						m.scale(bo.objectWidth, bo.objectHeight);
						m.tx = bo.X;
						m.ty = bo.Y;
						ct.alphaMultiplier = bo.alpha;
						
						if (bo.vis) {
							if (j <= 0) {
								ct.redMultiplier	= 1.00;
								ct.greenMultiplier	= 1.00;
								ct.blueMultiplier	= 1.00;
								backBmp.draw(bo.vis, m, ct, bo.blend, null, true);
							}
							else {
								if (bo.light) {
									if (darkness2>=0.43) {
										ct.redMultiplier	= 1.00;
										ct.greenMultiplier	= 1.00;
										ct.blueMultiplier	= 1.00;
									}
									else {
										ct.redMultiplier	= 0.55 + darkness2;
										ct.greenMultiplier	= 0.55 + darkness2;
										ct.blueMultiplier	= 0.55 + darkness2;
									}
								}
								else {
									ct.redMultiplier	= darkness2;
									ct.greenMultiplier	= darkness2;
									ct.blueMultiplier	= darkness2;
								}
								
								backBmp2.draw(bo.vis, m, ct, bo.blend, null, true);
								
								if (bo.light) {
									ct.redMultiplier	= 1.00;
									ct.greenMultiplier	= 1.00;
									ct.blueMultiplier	= 1.00;
								}
								else {
									ct.redMultiplier	= darkness2;
									ct.greenMultiplier	= darkness2;
									ct.blueMultiplier	= darkness2;
								}
							}
						}
						
						if (bo.erase) {
							satsBmp.draw(bo.erase, m, null, "erase", null, true);
						}
						
						if (bo.light) {
							colorBmp.draw(bo.light, m, ct, "normal", null, true);
						}
					}
				}
			}

			World.w.gr_stage=12;
			m=new Matrix();
		
			if (nloc.cTransform) {
				frontBmp.colorTransform(frontBmp.rect,nloc.cTransform);
				foregroundBmp.colorTransform(foregroundBmp.rect,nloc.cTransform);
				vodaBmp.colorTransform(vodaBmp.rect,nloc.cTransform);
			}

			mergeShadowCasters(frontBmp.rect);
			shadBmp.applyFilter(shadowCasterBmp,shadowCasterBmp.rect,new Point(0,0),dsFilter);

			World.w.gr_stage=13;
			// [Darkening the background]
			if (nloc.cTransform) {
				backBmp.colorTransform(backBmp.rect,nloc.cTransform);
				ct=new ColorTransform();
				darkness2=1+(170-darkness)/33;
				ct.concat(nloc.cTransform);
			
				if (darkness2>1) {
					ct.redMultiplier	*= darkness2;
					ct.greenMultiplier	*= darkness2;
					ct.blueMultiplier	*= darkness2;
				}
			
				backBmp2.colorTransform(backBmp2.rect, ct);
			}

			World.w.gr_stage=14;
			backBmp2.draw(back, new Matrix, nloc.cTransform, null, null, false);
			
			World.w.gr_stage=15;
				
			if (transpFon) {
				satsBmp.copyChannel(backBmp,backBmp.rect,new Point(0,0),BitmapDataChannel.ALPHA,BitmapDataChannel.ALPHA);
			}
			
			backBmp.draw(colorBmp, null, null, "hardlight");

			if (transpFon) {
				backBmp.copyChannel(satsBmp,backBmp.rect,new Point(0,0),BitmapDataChannel.ALPHA,BitmapDataChannel.ALPHA);
				shadBmp.draw(backBmp, null, null, "alpha");	// No shadow where the distant background shows through
			}
			
			// [Pink cloud]
			World.w.gr_stage = 16;
			if (loc.gas > 0) {
				m = new Matrix();
				m.ty=520;
				backBmp2.draw(getObj("back_pink_t",numbBack),m,new ColorTransform(1,1,1,0.3));
			}
			
			World.w.gr_stage = 17;
			drawTileLayer(E_TileLayer.BACKGROUND);
		
			backBmp2.draw(back2, new Matrix, nloc.cTransform, null, null, false);
			
			
			World.w.gr_stage = 18;
			frontBmp.unlock();
			foregroundBmp.unlock();
			backBmp.unlock();
			backBmp2.unlock();
			vodaBmp.unlock();
			
			if (nloc.cTransform && nloc.cTransformFon) {
				visFon.transform.colorTransform = nloc.cTransformFon;
			}
			else if (visFon.transform.colorTransform != defTransform) {
				visFon.transform.colorTransform = defTransform;
			}
				
			World.w.gr_stage = 19;
			// [Active objects]
			drawAllObjs();

			World.w.gr_stage = 0;
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

			for (var j:String in loc.signposts) {
				visObjs[3].addChild(loc.signposts[j]);
			}
		}
		
		public function drawBackWall(tex:String, sposob:int = 0):void {
			// Cache frequently accessed properties
			var localKusokX:int = kusokX;
			var localTileX:int = tileX;
			var localKusokY:int = kusokY;
			var localTileY:int = Tile.tileY;

			var roomPixelWidth:int    = localKusokX * localTileX;
			var roomPixelHeight:int   = localKusokY * localTileY;

			if (tex == "sky") {
				return;
			}

			m = new Matrix();

			// Cache the result of getObj('tBackWall') to avoid multiple calls
			var defaultTex:String = "tBackWall";
			var fill:BitmapData = getObj(tex) || getObj(defaultTex);

			var osn:Sprite = new Sprite();
			osn.graphics.beginBitmapFill(fill);

			// Precompute rectangle dimensions based on 'sposob'
			switch(sposob) {
				case 0:
					osn.graphics.drawRect(0, 0, roomPixelWidth, roomPixelHeight);
					break;
				case 1:
					var rect1Width:int = 11 * localTileX - 10;
					var rect2X:int = 37 * localTileX + 10;
					osn.graphics.drawRect(0, 0, rect1Width, roomPixelHeight);
					osn.graphics.drawRect(rect2X, 0, roomPixelWidth - rect2X, roomPixelHeight);
					break;
				case 2:
					var rectY2:int = 16 * localTileY + 10;
					osn.graphics.drawRect(0, rectY2, roomPixelWidth, roomPixelHeight - rectY2);
					break;
				case 3:
					var rectY3:int = 24 * localTileY + 10;
					osn.graphics.drawRect(0, rectY3, roomPixelWidth, roomPixelHeight - rectY3);
					break;
				default:
					// Handle unexpected 'sposob' values gracefully
					osn.graphics.drawRect(0, 0, roomPixelWidth, roomPixelHeight);
			}

			backBmp.draw(osn, m, null, null, null, false);
		}
		
		private function setMovieClipTile(mc:MovieClip, t:Tile, toFront:Boolean):void {
			if (mc.c1) {
				if (toFront) {
					mc.c1.gotoAndStop(t.mainOutline1 + 1);
					mc.c2.gotoAndStop(t.mainOutline2 + 1);
					mc.c3.gotoAndStop(t.mainOutline3 + 1);
					mc.c4.gotoAndStop(t.mainOutline4 + 1);
				}
				else {
					mc.c1.gotoAndStop(t.backOutline1 + 1);
					mc.c2.gotoAndStop(t.backOutline2 + 1);
					mc.c3.gotoAndStop(t.backOutline3 + 1);
					mc.c4.gotoAndStop(t.backOutline4 + 1);
				}
			}
		}

		// Whether a tile still shows one of its pieces: a destroyed block is gone, a door hides the textures under it
		private function showsPiece(t:Tile, piece:TilePiece_Definition):Boolean {
			// Differs from vanilla, where destroying a block also hid the beams, steps and ladders in its tile once the room was redrawn
			if (t.destroyed && piece.layer == E_TileLayer.MAIN) { return false; }
			if (t.door && piece.spriteFrame == 0) { return false; }

			return true;
		}

		// Pieces without textures were reported when the registry loaded, and draw nothing
		private function markUsed(piece:TilePiece_Definition):void {
			var textures:TilePieceTextures = texturesByPiece[piece];

			if (textures) {
				textures.used = true;
			}
		}
		
		// [Drawing texture materials]
		public function drawKusok(textures:TilePieceTextures):void {
			var piece:TilePiece_Definition = textures.piece;
			var toFront:Boolean = (piece.layer >= E_TileLayer.MAIN);
			var roomPixelWidth:int = kusokX * tileX;
			var roomPixelHeight:int = kusokY * tileY;

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
					osn.graphics.beginBitmapFill(altTexture);
				}
				else {
					osn.graphics.beginBitmapFill(texture);
				}
			}
			else {
				osn.graphics.beginFill(0x666666);
			}

			osn.graphics.drawRect(0, 0, roomPixelWidth, roomPixelHeight);

			kusok.addChild(osn);
			kusok.addChild(maska);
			
			if (borderTexture) {
				border.graphics.beginBitmapFill(borderTexture);
				border.graphics.drawRect(0, 0, roomPixelWidth, roomPixelHeight);
				kusok.addChild(border);
				kusok.addChild(bmaska);
			}
			
			if (floorTexture) {
				floor.graphics.beginBitmapFill(floorTexture);
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

					if (piece.layer == E_TileLayer.BACK_WALL) {
						shows = (t.definition.wall == piece);
					}
					else {
						shows = showsPiece(t, piece) && t.definition.pieces.indexOf(piece) >= 0;
					}
					
					if (shows) {
						isDraw = true;
						mc = new textures.textureMask();
						setMovieClipTile(mc, t, toFront);
						mc.x = (i + 0.5) * currentTileX;
						mc.y = (j + 0.5) * currentTileY;
						maska.addChild(mc);
						if (tLowered > 0 && toFront) {
							mc.scaleY = (tBoundingBox.bottom - tBoundingBox.top) / currentTileY;
							mc.y = (tBoundingBox.bottom + tBoundingBox.top) / 2;
						}                            
						if (hasBorderMask) {
							mc = new borderMaskClass();
							setMovieClipTile(mc, t, toFront);
							mc.x = (i + 0.5) * currentTileX;
							mc.y = (j + 0.5) * currentTileY;
							bmaska.addChild(mc);
							if (tLowered > 0 && toFront) {
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
			else if (piece.layer == E_TileLayer.MAIN) {
				frontBmp.draw(kusok, m, null, null, null, false);
			}
			else if (piece.layer == E_TileLayer.BACKGROUND) {
				backBmp2.draw(kusok, m, loc.cTransform, null, null, false);
			}
			else {
				backBmp.draw(kusok, m, null, null, null, false);
			}
		}

		private function drawTileLayer(layer:int):void {
			var textures:TilePieceTextures;

			for each (textures in tileTextures) {
				if (textures.used && textures.piece.layer == layer) {
					drawKusok(textures);
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
			var hole:Rectangle;

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

			hole = new Rectangle(t.coords.X * tileX, t.coords.Y * tileY, tileX, tileY);
			hole.inflate(tileX, tileY);	// Room for the hole decal reaching past its tile
			recastShadow(hole);
		}

		// Recasts the drop shadow around a changed part of the layers that cast it, so a removed tile stops casting one
		private function recastShadow(changed:Rectangle):void {
			var area:Rectangle = changed.clone();
			var source:Rectangle;
			var cast:BitmapData;

			area.inflate(SHADOW_REACH, SHADOW_REACH);
			area = area.intersection(shadBmp.rect);
			source = area.clone();
			source.inflate(SHADOW_REACH, SHADOW_REACH);	// The pixels that can still shade the area
			source = source.intersection(frontBmp.rect);

			mergeShadowCasters(source);
			cast = new BitmapData(source.width, source.height, true, 0);
			cast.applyFilter(shadowCasterBmp, source, new Point(0, 0), dsFilter);
			shadBmp.copyPixels(cast, new Rectangle(area.x - source.x, area.y - source.y, area.width, area.height), area.topLeft);
			cast.dispose();

			if (transpFon) {
				shadBmp.draw(backBmp, null, null, "alpha", area);
			}
		}

		// The main and foreground layers both cast the drop shadow onto the back wall, so they are merged over the area being cast
		private function mergeShadowCasters(area:Rectangle):void {
			shadowCasterBmp.copyPixels(frontBmp, area, area.topLeft);
			shadowCasterBmp.copyPixels(foregroundBmp, area, area.topLeft, null, null, true);
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
			var wall:MovieClip = new tileGwall();
			frontBmp.draw(wall, m);
		}
		
		public function paint(nx1:int, ny1:int, nx2:int, ny2:int, aero:Boolean = false):void {
			var padding:int = 25;
			var brush:MovieClip;

			// Determine what brush to use
			if (aero) {
				if (!pa) {
					pa = new paintaero();
				}

				brush = pa;
			}
			else {
				if (!pb) {
					pb = new paintbrush();
				}

				brush = pb;
			}	
			
			// Calculate the straight-line distance between two points (start and end positions, I assume how far the mouse moved).
			var rasst:Number = Math.sqrt((nx2 - nx1) * (nx2 - nx1) + (ny2 - ny1) * (ny2 - ny1));

			// Determine how many times to repeat the painting action based on the distance.
			var kol:int = Math.ceil(rasst / 3);

			var dx:Number = (nx2 - nx1) / kol;
			var dy:Number = (ny2 - ny1) / kol;
			
			// Set up an area around the line being drawn.
			var rx1:int, rx2:int, ry1:int, ry2:int;

			// Simplified calculation of bounding rectangle's coordinates. Math.min/Math.max returns the smaller/larger number of the two.
			rx1 = Math.min(nx1, nx2) - padding;
			ry1 = Math.min(ny1, ny2) - padding;
			rx2 = Math.max(nx1, nx2) + padding;
			ry2 = Math.max(ny1, ny2) + padding;
			
			// Prepare the canvas for drawing.
			brPoint.x		= 0;
			brPoint.y		= 0;
			brRect.left		= rx1;
			brRect.right	= rx2;
			brRect.top		= ry1;
			brRect.bottom	= ry2;
			brData.copyChannel(backBmp, brRect, brPoint, BitmapDataChannel.ALPHA, BitmapDataChannel.GREEN);
			
			// Paint along the line, step by step.
			for (var i:int = 1; i <= kol; i++) {
				// Calculate the next point to paint.
				pm.tx = nx1 + dx * i;
				pm.ty = ny1 + dy * i;

				// Perform the painting action at this point.		
				backBmp.draw(brush, pm, brTrans, "normal", null, false);
			}
			
			// Finish up by adjusting the painted area on the canvas.
			brPoint.x = rx1;
			brPoint.y = ry1;
			brRect.left = 0;
			brRect.right = rx2 - rx1;
			brRect.top = 0;
			brRect.bottom = ry2 - ry1;
			backBmp.copyChannel(brData, brRect, brPoint, BitmapDataChannel.GREEN, BitmapDataChannel.ALPHA);
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
				visFon.filters = [];
			}
			else if (n >= 1 && n <= 6) {
				// Cases 1-6: Apply the corresponding ColorMatrixFilter from the lookup array
				visual.filters = [colorMatrixFilters[n]];
			}
			else if (n > 100) {
				// Default case for n > 100: Apply BlurFilter
				var blurAmount:Number = n - 100;
				var blur:BlurFilter = new BlurFilter(blurAmount, blurAmount);
				visual.filters = [blur];
				visFon.filters = [blur];
			}
			else {
				// Handle unknown cases
				trace("ERROR: Unknown special effect: \"" + n + "\"!");
			}
		}
	}
}
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
	
	import fl.motion.Color;

	import fe.*;
	import fe.util.Vector2;
	import fe.loc.*;
	import fe.entities.Entity;
	
	// .fla linkages
	import fe.stubs.tileVoda;		
	import fe.stubs.visBlack;
	import fe.stubs.paintaero;
	import fe.stubs.paintbrush;
	import fe.stubs.tileGwall;
	import fe.stubs.tileFront;

	public class Grafon {
		
		private var debug:DebugLayer;				// Class to handle all the logic for drawing debug info
		private var visBoundingBoxes:Sprite = null; // Container for bounding boxes

		public var loc:Location;

		public var visual:Sprite;
		public var visBack:Sprite;
		public var visBack2:Sprite;
		public var visObjs:Array;
		const kolObjs=6;
		public var visVoda:Sprite;
		public var visFront:Sprite;
		public var visLight:Sprite;
		public var visSats:Sprite;
		public var visFon:MovieClip;
		
		var resX:int;			// Screen pixel width
		var resY:int;			// Screen pixel height
		var kusokX:int = 48;	// Room tile width
		var kusokY:int = 25;	// Room tile height
		
		public var frontBmp:BitmapData;
		var frontBitmap:Bitmap;
		var vodaBmp:BitmapData;
		var vodaBitmap:Bitmap;
		var backBmp:BitmapData;
		var backBitmap:Bitmap;
		var backBmp2:BitmapData;
		var backBitmap2:Bitmap;
		public var lightBmp:BitmapData;
		var lightBitmap:Bitmap;
		public var satsBmp:BitmapData;
		var satsBitmap:Bitmap;
		var shadBmp:BitmapData;
		var colorBmp:BitmapData;
		var dsFilter:DropShadowFilter=new DropShadowFilter(7,90,0,0.75,16,16,1,3,false,false,true);
		var infraTransform:ColorTransform=new ColorTransform(1,1,1,1,100);
		var defTransform:ColorTransform=new ColorTransform();
		
		public var pa:MovieClip;
		public var pb:MovieClip;

		public var brTrans:ColorTransform = new ColorTransform();
		public var brColor:Color = new Color();		// Adobe Animate dependency.
		var brData:BitmapData = new BitmapData(100, 100, false, 0x0);
		var brPoint:Point = new Point(0, 0);
		var brRect:Rectangle = new Rectangle(0,0,50,50);
		var pm:Matrix = new Matrix();
			
		var voda = new tileVoda();

		var m:Matrix;
		
		//рамки
		public var ramT:MovieClip, ramB:MovieClip;
		public var ramL:MovieClip, ramR:MovieClip;
		
		var arrFront:Array;
		var arrBack:Array;
		
		var rectX:int=1920, rectY:int=1000;
		var allRect:Rectangle=new Rectangle(0,0,rectX,rectY);
		
		var lightX:int=49, lightY:int=28;
		var lightRect:Rectangle=new Rectangle(0,0,lightX,lightY);
		
		//загрузка
		public var resIsLoad:Boolean=false;
		public var progressLoad:Number=0;
		public static var spriteLists:Array=[];
		
		// Lack of '.swf' indicates loose textures in a folder
		public static var texUrl:Array = ['texture', 'texture1.swf', 'sprite.swf', 'sprite1.swf'];
		public var grLoaders:Array;
		
		public static const numbMat = 0;		//материалы
		public static const numbFon = 0;		//задники
		public static const numbBack = 1;		//декорации
		public static const numbObj = 1;		//объекты
		public static const numbSprite = 2;	//номер, с которого начинаются файлы спрайтов

		private static var tileX:int = Tile.tileX;
		private static var tileY:int = Tile.tileY;
		
		// Constructor
		public function Grafon(nvis:Sprite) {
			visual = nvis;

			visBack = new Sprite();
			visBack2 = new Sprite();
			visVoda = new Sprite();
			visVoda.alpha = 0.6;
			visFront = new Sprite();
			visLight = new Sprite();
			visSats = new Sprite();
			visSats.visible=false;
			visSats.filters=[new BlurFilter(3,3,1)];

			debug = new DebugLayer();
			visBoundingBoxes = new Sprite();	// Layer to draw all bounding boxes on
			visBoundingBoxes.mouseEnabled = false; // Prevent bounding boxes from blocking mouse events
			visBoundingBoxes.mouseChildren = false;
			
			visObjs = [];
			for (var i = 0; i < kolObjs; i++) {
				visObjs.push(new Sprite());
			}
			
			visual.addChild(visBack);		//0
			visual.addChild(visBack2);		//0
			visual.addChild(visObjs[0]);	//1
			visual.addChild(visObjs[1]);	//2
			visual.addChild(visObjs[2]);	//3
			visual.addChild(visFront);		//4
			visual.addChild(visObjs[3]);	//6
			visual.addChild(visVoda);		//5
			visual.addChild(visLight);		//7
			visual.addChild(visObjs[4]);	//8
			visual.addChild(visSats);		//9
			visual.addChild(visObjs[5]);	//10
			
			visLight.x = -tileX / 2;
			visLight.y = -tileX / 2 - Tile.tileY;
			visLight.scaleX = tileX;
			visLight.scaleY = Tile.tileY;
			
			frontBmp = new BitmapData(rectX, rectY, true, 0x0)
			frontBitmap = new Bitmap(frontBmp);
			visFront.addChild(frontBitmap);
			
			backBmp = new BitmapData(rectX, rectY, true, 0x0)
			backBitmap = new Bitmap(backBmp);
			visBack.addChild(backBitmap);
			
			backBmp2 = new BitmapData(rectX, rectY, true, 0x0)
			backBitmap2 = new Bitmap(backBmp2);
			visBack2.addChild(backBitmap2);

			vodaBmp = new BitmapData(rectX, rectY, true, 0x0)
			vodaBitmap = new Bitmap(vodaBmp);
			visVoda.addChild(vodaBitmap);
			
			satsBmp = new BitmapData(rectX, rectY, true,0);
			satsBitmap = new Bitmap(satsBmp,'auto',true);
			visSats.addChild(satsBitmap);
			
			colorBmp = new BitmapData(rectX, rectY, true,0);
			shadBmp = new BitmapData(rectX, rectY, true,0);
			
			lightBmp = new BitmapData(lightX, lightY,true,0xFF000000);
			lightBitmap = new Bitmap(lightBmp,'auto',true);
			visLight.addChild(lightBitmap);

			ramT = new visBlack();
			ramB = new visBlack();
			ramR = new visBlack();
			ramL = new visBlack();
			ramT.cacheAsBitmap=ramB.cacheAsBitmap=ramR.cacheAsBitmap=ramL.cacheAsBitmap=true;
			visual.addChild(ramT);
			visual.addChild(ramB);
			visual.addChild(ramR);
			visual.addChild(ramL);
			
			// START LOADING TEXTURES HERE

			grLoaders = [];
			for (var i in texUrl) {
				var textureURL:String = texUrl[i];
				// Check if 'textureURL' contains '.swf'
				if (textureURL.indexOf(".swf") != -1) {
					grLoaders[i] = new GrLoader(i, textureURL, this, "swf");
				}
				else {
					grLoaders[i] = new GrLoader(i, textureURL, this, "looseImage");
				}
				
			}
			createCursors();
		}
		
		// Checks whether all resources have finished loading
		public function checkLoaded(n:int):void {
			
			// 0 is tile and sky textures
			if (n == 0) {
				// [Reading their xml materials]
				arrFront = [];
				arrBack  = [];

				var xmlList:XMLList = XMLDataGrabber.getNodesWithName("core", "AllData", "mats", "mat");

				for each (var p:XML in xmlList) {
					if (p.@vid.length() == 0) {
						if (p.@ed == '2') {
							arrBack[p.@id] = new Material(p);
						}
						else {
							arrFront[p.@id] = new Material(p);
						}
					}
				}

				xmlList = null; // Manual cleanup.
			}


			resIsLoad = (GrLoader.kolIsLoad >= GrLoader.kol);
		}
		
		public function allProgress():void {
			progressLoad = 0;
			for (var i in grLoaders) {
				progressLoad += grLoaders[i].progressLoad;
			}
			progressLoad /= GrLoader.kol;
		}
		
		private function createCursors():void {
			createCursor(visCurArrow,'arrow');				// .SWF Dependency
			createCursor(visCurTarget,'target', 13, 13);	// .SWF Dependency
			createCursor(visCurTarget1,'combat', 13, 13);	// .SWF Dependency
			createCursor(visCurTarget2,'action', 13, 13);	// .SWF Dependency
 		}
		
		private function createCursor(vcur:Class, nazv:String, nx:int=0, ny:int=0):void {
			var cursorData:Vector.<BitmapData>;
			var mouseCursorData:MouseCursorData;
			cursorData=new Vector.<BitmapData>();
			cursorData.push(new vcur());
			mouseCursorData = new MouseCursorData();
            mouseCursorData.data = cursorData;
			mouseCursorData.hotSpot=new Point(nx,ny);
            Mouse.registerCursor(nazv, mouseCursorData);
		}
		
//============================================================================================		
//							Начальная прорисовка локации
//============================================================================================		
		
		public function drawDebugLayer():void {
			// Ensure the bounding boxes container exists
			visual.addChild(debug.drawAllBoundingBoxes());
		}

		public function getObj(textureName:String, n:int = 0):* {
			//trace("Getting resource object: " + textureName + " from GrLoader: " + n);
			if (grLoaders[n] && grLoaders[n].isLoad) {
				return grLoaders[n].getObj(textureName);
			}
			else {
				trace("GrLoader not loaded or invalid index:", n);
				return null;
			}
		}
		
		//показать задний фон
		public function drawFon(vfon:MovieClip, tex:String):void {
		// Set default texture if none provided
		if (tex == '' || tex == null) {
			tex = 'fonDefault';
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
					var koef=visFon.width/visFon.height;
					visFon.x=visFon.y=0;
					if (nx>=ny*koef) {
						visFon.width=nx;
						visFon.height=nx/koef;
					}
					else {
						visFon.height=ny;
						visFon.width=ny*koef;
					}
				}
			}
		}
		
		public function warShadow():void {
			if (World.w.pers.infravis) {
				visLight.transform.colorTransform = infraTransform;
				visLight.blendMode = 'multiply';
			}
			else {
				visLight.transform.colorTransform = defTransform
				visLight.blendMode = 'normal';
			}
		}
		
		//прорисовка локации
		public function drawLoc(nloc:Location):void {
			World.w.gr_stage=1;
			loc=nloc;
			loc.grafon=this;
			resX = loc.spaceX * tileX;
			resY = loc.spaceY * Tile.tileY;
			
			var transpFon:Boolean=nloc.transpFon;
			if (nloc.backwall=='sky') transpFon=true;
			
			World.w.gr_stage=2;
			//рамки
			ramT.x=ramB.x=-50;
			ramR.y=ramL.y=0;
			ramT.y=0;
			ramL.x=0;
			ramB.y=loc.maxY-1;
			ramR.x=loc.maxX-1;
			ramT.scaleX=ramB.scaleX=loc.maxX/100+1;
			ramT.scaleY=ramB.scaleY=2;
			ramR.scaleY=ramL.scaleY=loc.maxY/100;
			ramR.scaleX=ramL.scaleX=2;
		
			World.w.gr_stage=3;		// [somewhere here] (I assume this means whatever graphical bug)
			frontBmp.lock();
			backBmp.lock();
			backBmp2.lock();
			vodaBmp.lock();
			
			frontBmp.fillRect(allRect,0);
			backBmp.fillRect(allRect,0);
			backBmp2.fillRect(allRect,0);
			vodaBmp.fillRect(allRect,0);
			satsBmp.fillRect(allRect,0);
			
			lightBmp.fillRect(lightRect,0xFF000000);
			setLight();
			visLight.visible=loc.black&&World.w.black;
			warShadow();
			
			var darkness:int=0xAA+loc.darkness;
			if (darkness>0xFF) darkness=0xFF;
			if (darkness<0) darkness=0;
			colorBmp.fillRect(allRect,darkness*0x1000000);
			shadBmp.fillRect(allRect,0xFFFFFFFF);

			World.w.gr_stage=4;

			m = new Matrix();
			var tile:MovieClip;
			var t:Tile;
			var front:Sprite	= new Sprite();	//отпечаток на битмапе переднего плана
			var back:Sprite		= new Sprite();	//отпечаток на битмапе задника
			var back2:Sprite	= new Sprite();	//отпечаток на битмапе задника
			var voda:Sprite		= new Sprite();	//отпечаток на битмапе воды
			
			//отключить все материалы
			var mat:Material;
			for each (mat in arrFront) mat.used=false;
			for each (mat in arrBack) mat.used=false;
			
			var gret:int=0;
			World.w.gr_stage=5;
			for (var i:int = 0; i<loc.spaceX; i++) {
				for (var j=0; j<loc.spaceY; j++) {
					t = loc.getTile(i, j);
					loc.tileKontur(i,j,t);
					if (arrFront[t.front]) arrFront[t.front].used=true;
					if (arrBack[t.back]) arrBack[t.back].used=true;
					if (t.vid > 0) {				// [Objects with vid]
						tile=new tileFront();
						tile.gotoAndStop(t.vid);
						if (t.vRear) back2.addChild(tile);
						else front.addChild(tile);
						tile.x = i * tileX;
						tile.y = j * Tile.tileY;
					}
					if (t.vid2 > 0) {				// [Objects with vid2]
						tile=new tileFront();
						tile.gotoAndStop(t.vid2);
						if (t.v2Rear) back2.addChild(tile);
						else front.addChild(tile);
						tile.x = i * tileX;
						tile.y = j * Tile.tileY;
					}
					if (t.water) {				// [Water]
						tile=new tileVoda();
						tile.gotoAndStop(loc.tipWater+1);
						if (loc.getTile(i,j-1).water==0 && loc.getTile(i,j-1).phis==0) tile.voda.gotoAndStop(2);
						tile.x = i * tileX;
						tile.y = j * Tile.tileY;
						voda.addChild(tile);
					}
				}
			}
			World.w.gr_stage=6;
			vodaBmp.draw(voda, new Matrix, null, null, null, false);
			frontBmp.draw(front, new Matrix, null, null, null, false);
			
			
			World.w.gr_stage=7;
			drawBackWall(nloc.backwall, nloc.backform);	// [Back wall]
			
			World.w.gr_stage=8;
			for each (mat in arrFront) {
				drawKusok(mat, true);	// [Foreground]
			}
			World.w.gr_stage=9;
			for each (mat in arrBack) {
				drawKusok(mat, false);	// [Background]
			}
			World.w.gr_stage=10;
			satsBmp.copyChannel(backBmp,backBmp.rect,new Point(0,0),BitmapDataChannel.ALPHA,BitmapDataChannel.ALPHA);
			var darkness2 = 1 - (255-darkness) / 150;
			// [Background objects]
			var ct:ColorTransform = new ColorTransform();

			World.w.gr_stage=11;
			for (j=-2; j<=3; j++) {
				if (j==-1) backBmp.copyChannel(satsBmp,backBmp.rect,new Point(0,0),BitmapDataChannel.ALPHA,BitmapDataChannel.ALPHA);
				for each(var bo:BackObj in loc.backobjs) {	
					if (bo.sloy==j && !bo.er || j==-2 && bo.er) {
						m=new Matrix();
						m.scale(bo.objectWidth, bo.objectHeight);
						m.tx=bo.X;
						m.ty=bo.Y;
						ct.alphaMultiplier=bo.alpha;
						if (bo.vis) {
							if (j<=0) {
								ct.redMultiplier=ct.greenMultiplier=ct.blueMultiplier=1;
								backBmp.draw(bo.vis, m, ct, bo.blend, null, true);
							}
							else {
								if (bo.light) {
									if (darkness2>=0.43) ct.redMultiplier=ct.greenMultiplier=ct.blueMultiplier=1;
									else ct.redMultiplier=ct.greenMultiplier=ct.blueMultiplier=0.55+darkness2;
								}
								else {
									ct.redMultiplier=ct.greenMultiplier=ct.blueMultiplier=darkness2;
								}
								backBmp2.draw(bo.vis, m, ct, bo.blend, null, true);
								if (bo.light) {
									ct.redMultiplier=ct.greenMultiplier=ct.blueMultiplier=1;
								}
								else {
									ct.redMultiplier=ct.greenMultiplier=ct.blueMultiplier=darkness2;
								}
							}
						}
						if (bo.erase) satsBmp.draw(bo.erase, m, null, 'erase', null, true);
						if (bo.light) colorBmp.draw(bo.light, m, ct, 'normal', null, true);
					}
				}
			}

			World.w.gr_stage=12;
			m=new Matrix();
			if (nloc.cTransform) {
				frontBmp.colorTransform(frontBmp.rect,nloc.cTransform);
				vodaBmp.colorTransform(vodaBmp.rect,nloc.cTransform);
			}
			shadBmp.applyFilter(frontBmp,frontBmp.rect,new Point(0,0),dsFilter);

			World.w.gr_stage=13;
			// [Darkening the background]
			if (nloc.cTransform) {
				backBmp.colorTransform(backBmp.rect,nloc.cTransform);
				ct=new ColorTransform();
				darkness2=1+(170-darkness)/33;
				ct.concat(nloc.cTransform);
				if (darkness2>1) {
					ct.redMultiplier*=darkness2;
					ct.greenMultiplier*=darkness2;
					ct.blueMultiplier*=darkness2;
				}
				backBmp2.colorTransform(backBmp2.rect,ct);
			}
			World.w.gr_stage=14;
			backBmp2.draw(back, new Matrix, nloc.cTransform, null, null, false);
			
			World.w.gr_stage=15;
			if (transpFon) satsBmp.copyChannel(backBmp,backBmp.rect,new Point(0,0),BitmapDataChannel.ALPHA,BitmapDataChannel.ALPHA);
			backBmp.draw(colorBmp, null, null, 'hardlight');
			backBmp.draw(shadBmp);
			if (transpFon) backBmp.copyChannel(satsBmp,backBmp.rect,new Point(0,0),BitmapDataChannel.ALPHA,BitmapDataChannel.ALPHA);
			
			// [Pink cloud]
			World.w.gr_stage = 16;
			if (loc.gas > 0) {
				m = new Matrix();
				m.ty=520;
				backBmp2.draw(getObj('back_pink_t',numbBack),m,new ColorTransform(1,1,1,0.3));
			}
			
			World.w.gr_stage=17;
			for each (mat in arrFront) drawKusok(mat,false,true);	//добавление на задний план текстур переднего плана, таких как балки
			backBmp2.draw(back2, new Matrix, nloc.cTransform, null, null, false);
			
			
			World.w.gr_stage=18;
			frontBmp.unlock();
			backBmp.unlock();
			backBmp2.unlock();
			vodaBmp.unlock();
			
			if (nloc.cTransform && nloc.cTransformFon) visFon.transform.colorTransform=nloc.cTransformFon;
			else if (visFon.transform.colorTransform!=defTransform) visFon.transform.colorTransform=defTransform;
			World.w.gr_stage = 19;
			// [Active objects]
			drawAllObjs();

			World.w.gr_stage = 0;
		}
		
		//прорисовка всей карты затемнения
		public function setLight():void {
			lightBmp.lock();
			for (var i:int = 1; i < loc.spaceX; i++) {
				for (var j:int = 1; j < loc.spaceY; j++) {
					lightBmp.setPixel32(i, j + 1, int((1 - loc.getTile(i, j).visi) * 255) * 0x1000000);
				}
			}
			lightBmp.unlock();
		}
		
		//добавление всех видимых объектов
		public function drawAllObjs():void {
			for (var i = 0; i < kolObjs; i++) {
				var n = visual.getChildIndex(visObjs[i]);
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

			for (var i in loc.signposts) {
				visObjs[3].addChild(loc.signposts[i]);
			}
		}
		
		//заполнение заднего плана текстурой
		public function drawBackWall(tex:String, sposob:int = 0):void {
			var roomPixelWidth:int	= kusokX * tileX;
			var roomPixelHeight:int	= kusokY * Tile.tileY

			if (tex=='sky') return;
			m=new Matrix();
			var fill:BitmapData=getObj(tex);
			if (fill==null) fill=getObj('tBackWall')
			var osn:Sprite=new Sprite();
			osn.graphics.beginBitmapFill(fill);
			if (sposob==0) {
				osn.graphics.drawRect(0,0,roomPixelWidth,roomPixelHeight);
			}
			else if (sposob == 1) {
				osn.graphics.drawRect(0,0,11*tileX-10, roomPixelHeight);
				osn.graphics.drawRect(37*tileX+10,0,roomPixelWidth, roomPixelHeight);
			}
			else if (sposob == 2) {
				osn.graphics.drawRect(0,16*Tile.tileY+10,roomPixelWidth, roomPixelHeight);
			}
			else if (sposob == 3) {
				osn.graphics.drawRect(0,24*Tile.tileY+10,roomPixelWidth, roomPixelHeight);
			}
			backBmp.draw(osn, m, null, null, null, false);
		}
		
		private function setMovieClipTile(mc:MovieClip, t:Tile, toFront:Boolean):void {
			if (mc.c1) {
				if (toFront) {
					mc.c1.gotoAndStop(t.kont1 + 1);
					mc.c2.gotoAndStop(t.kont2 + 1);
					mc.c3.gotoAndStop(t.kont3 + 1);
					mc.c4.gotoAndStop(t.kont4 + 1);
				}
				else {
					mc.c1.gotoAndStop(t.pont1 + 1);
					mc.c2.gotoAndStop(t.pont2 + 1);
					mc.c3.gotoAndStop(t.pont3 + 1);
					mc.c4.gotoAndStop(t.pont4 + 1);
				}
			}
		}
		
		//рисование текстурных материалов
		public function drawKusok(material:Material, toFront:Boolean, dop:Boolean = false):void
		{
			var roomPixelWidth:int = kusokX * tileX;
			var roomPixelHeight:int = kusokY * tileY;

			if (!material.used) return;
			if (material.rear == toFront) return;
			
			var t:Tile;
			var mc:MovieClip;

			var kusok:Sprite	= new Sprite();	
			var osn:Sprite		= new Sprite();
			var maska:Sprite	= new Sprite();
			var border:Sprite	= new Sprite();
			var bmaska:Sprite	= new Sprite();
			var floor:Sprite	= new Sprite();
			var fmaska:Sprite	= new Sprite();
			
			if (material.texture) {
				if (loc.homeStable && material.alttexture != null) osn.graphics.beginBitmapFill(material.alttexture);
				else osn.graphics.beginBitmapFill(material.texture);
			}
			else {
				osn.graphics.beginFill(0x666666);
			}

			osn.graphics.drawRect(0, 0, roomPixelWidth, roomPixelHeight);

			kusok.addChild(osn);
			kusok.addChild(maska);
			if (material.border) {
				border.graphics.beginBitmapFill(material.border);
				border.graphics.drawRect(0, 0, roomPixelWidth, roomPixelHeight);
				kusok.addChild(border);
				kusok.addChild(bmaska);
			}
			if (material.floor) {
				floor.graphics.beginBitmapFill(material.floor);
				floor.graphics.drawRect(0, 0, roomPixelWidth, roomPixelHeight);
				kusok.addChild(floor);
				kusok.addChild(fmaska);
			}
			
			var isDraw:Boolean = false;
			
			for (var i:int = 0; i < loc.spaceX; i++) {
				for (var j:int = 0; j < loc.spaceY; j++) {
					t = loc.getTile(i, j);
					if (t.front == material.id && (toFront || dop) || t.back == material.id && !toFront) {
						isDraw = true;
						mc = new material.textureMask();
						setMovieClipTile(mc, t, toFront);
						mc.x = (i + 0.5) * tileX;
						mc.y = (j + 0.5) * tileY;
						maska.addChild(mc);
						if (t.zForm && toFront) {
							mc.scaleY = (t.boundingBox.bottom - t.boundingBox.top) / tileY;
							mc.y=(t.boundingBox.bottom + t.boundingBox.top) / 2;
						}							
						if (material.borderMask) {
							mc=new material.borderMask();
							setMovieClipTile(mc,t,toFront);
							mc.x=(i+0.5)*tileX;
							mc.y=(j+0.5)*tileY;
							bmaska.addChild(mc);
							if (t.zForm && toFront) {
								mc.scaleY = (t.boundingBox.bottom - t.boundingBox.top) / tileY;
								mc.y = (t.boundingBox.bottom + t.boundingBox.top) / 2;
							}							
						}
						if (material.floorMask) {
							mc=new material.floorMask();
							if (mc.c1) {
								mc.c1.gotoAndStop(t.kont1 + 1);
								mc.c2.gotoAndStop(t.kont2 + 1);
							}
							fmaska.addChild(mc);
							mc.x=(i+0.5)*tileX;
							mc.y=(j+0.5+t.zForm/4)*tileY;
						}
					}
				}
			}

			if (!isDraw) return;

			m.tx = 0;
			m.ty = 0;
			osn.cacheAsBitmap=maska.cacheAsBitmap=border.cacheAsBitmap=bmaska.cacheAsBitmap=floor.cacheAsBitmap=fmaska.cacheAsBitmap=true;
			osn.mask=maska; border.mask=bmaska; floor.mask=fmaska;
			if (material.F) kusok.filters = material.F;
			if (toFront) frontBmp.draw(kusok, m, null, null, null, false);
			else if (dop) backBmp2.draw(kusok, m, loc.cTransform, null, null, false);
			else backBmp.draw(kusok, m, null, null, null, false); 
		}
		
//============================================================================================		
//							Время выполнения
//============================================================================================		
		
		public function getSpriteList(id:String, n:int=0):BitmapData {
			if (spriteLists[id] == null) {
				if (n > 0) spriteLists[id] = getObj(id, numbSprite + n);
				else {
					spriteLists[id] = getObj(id, numbSprite);
					if (spriteLists[id] == null) spriteLists[id] = getObj(id, numbSprite + 1);
				}
			}

			if (spriteLists[id] == null) {
				trace('нет спрайтов', id)
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
			m=new Matrix();
			m.tx = t.coords.X * tileX;
			m.ty = t.coords.Y * Tile.tileY;
			voda.gotoAndStop(loc.tipWater + 1);
			if (loc.getTile(t.coords.X, t.coords.Y - 1).water == 0 && loc.getTile(t.coords.X, t.coords.Y - 1).phis == 0 ) {
				voda.voda.gotoAndStop(2);
			}
			else {
				voda.voda.gotoAndStop(1);
			}
			
			vodaBmp.draw(voda, m, loc.cTransform, (t.water > 0)? 'normal' : 'erase', null, false);
			
			if (recurs) {
				drawWater(loc.getTile(t.coords.X, t.coords.Y + 1), false);
			}
		}
		
		public function tileDie(t:Tile,tip:int):void {
			var erC:Class = block_dyr;	// .fla linkage
			var drC:Class = block_tre;	// .fla linkage
			
			var nx = (t.coords.X + 0.5) * tileX;
			var ny = (t.coords.Y + 0.5) * tileY;

			if (t.fake) {
				Emitter.emit('fake', loc, nx, ny);
				drC = block_bur;	// .fla linkage
			}
			else if (t.mat == 7) {
				Emitter.emit('fake',loc,nx,ny);
				Emitter.emit('pole',loc,nx,ny,{kol:10, rx:tileX, ry:tileY});
				erC = TileMask;
				drC = null;
			}
			else if (tip < 10) {
				var emitEffect:Array = ["null", "metal", "kusok", "schep", "kusokB", "steklo", "kusokD"];
				if (t.mat >= 1 && t.mat <= 6) {
					Emitter.emit(emitEffect[t.mat],	loc,nx,ny,{kol:6, rx:tileX, ry:tileY});
				}
			}
			else if (tip >= 15) {
				Emitter.emit('plav',loc,nx,ny);
				erC=block_plav;		// .fla linkage
				drC = block_pla;		// .fla linkage
			}
			else if (tip >= 11 && tip <= 13) {
				Emitter.emit('bur',loc,nx,ny);
				drC = block_bur;		// .fla linkage
			}

			decal(erC, drC, nx, ny, 1, 0, 'hardlight');
		}
		
		// Bullethole
		public function dyrka(nx:int,ny:int,tip:int,mat:int, soft:Boolean=false, ver:Number=1):void
		{
			var erC:Class;
			var drC:Class;
			var bl:String = 'normal';
			var centr:Boolean = false;
			var sc = Math.random() * 0.5 + 0.5;
			var rc = Math.random() * 360

			if (tip == 0 || mat == 0) return;

			switch (mat)
			{
				case 1:	//металл
					if (tip >= 1 && tip <= 6) drC = bullet_metal;
					else if (tip==9) //взрыв
					{		
						if (!soft && Math.random()*0.5<ver) drC=metal_tre;
						centr=true;
					}
				break;

				case 2:  //камень
				case 4:
				case 6:
					if (tip>=1 && tip<=3) //пули
					{					
						if (tip>1 && Math.random()>0.5) erC=bullet_dyr;
						drC=bullet_tre;
						if (tip==2) sc+=0.5;
						if (tip==3) sc+=1;
					}
					else if (tip>=4 && tip<=6) //удары
					{
						if (!soft) drC=punch_tre;
						if (tip==5) sc+=0.5;
						if (tip==6) sc+=1;
					}
					else if (tip==9) //взрыв
					{
						if (!soft && Math.random()*0.5<ver) drC=expl_tre;
						centr=true;
					}

					if (tip<10 && !soft)
					{
						if (mat==2) Emitter.emit('kusoch',loc,nx,ny,{kol:3});
						else Emitter.emit('kusochB',loc,nx,ny,{kol:3});
					}
				break;

				case 3: //дерево
					if (tip>=1 && tip<=3) //пули
					{
						erC=bullet_dyr;
						drC=bullet_wood;
						rc=0;
						if (tip==2) sc+=0.5;
						if (tip==3) sc+=1;
					}
					else if (tip>=4 && tip<=6) //удары
					{
						if (!soft) drC=punch_tre;
						if (tip==5) sc+=0.5;
						if (tip==6) sc+=1;
					}
					else if (tip==9) //взрыв
					{
						if (!soft && Math.random()*0.5<ver) drC=expl_tre;
						centr=true;
					}

					if (tip < 10 && !soft)
					{
						Emitter.emit('schepoch',loc,nx,ny,{kol:3});
					}
				break;

				case 7: //поле
					Emitter.emit('pole',loc,nx,ny,{kol:5});
				break;

				case 11:
					if (Math.random() < 0.1) drC=fire_soft;
				break;

				case 12: //лазеры
				case 13:
					if (soft && Math.random()*0.2>ver) drC=fire_soft;
					else drC=laser_tre;

					if (tip == 13) sc *= 0.6;
					bl='hardlight';
				break;

				case 15: //плазма
					if (soft) drC = plasma_soft;
					else {
						erC = plasma_dyr;
						drC = plasma_tre;
					}

					bl = 'hardlight';
				break;

				case 16:
					if (soft) drC=fire_soft;
					else {
						erC = plasma_dyr;
						drC = bluplasma_tre;
					}
					bl = 'hardlight';
				break;

				case 17:
					if (soft) drC=fire_soft;
					else {
						erC = plasma_dyr;
						drC = pinkplasma_tre;
					}
					bl = 'hardlight';
				break;

				case 18:
					drC = cryo_soft;
					bl = 'hardlight';
				break;

				case 19: //взрыв
					if (!soft && Math.random() * 0.5 < ver) drC=plaexpl_tre;
					centr=true;
				break;

				default:
					trace('ERROR: unknown bullethole: "' + mat + '" !');
				break;
			}
			
			decal(erC,drC,nx,ny,sc,rc,bl);
		}
		
		public function decal(erC:Class, drD:Class, nx:Number, ny:Number, sc:Number=1, rc:Number=0, bl:String='normal'):void {
			m=new Matrix();
			if (sc!=1) m.scale(sc,sc);
			if (rc!=0) m.rotate(rc);
			m.tx=nx;
			m.ty=ny;
			if (erC) {
				var erase:MovieClip=new erC();
				if (erase.totalFrames>1) erase.gotoAndStop(Math.floor(Math.random()*erase.totalFrames+1));
				frontBmp.draw(erase, m, null, 'erase', null, true);
			}
			if (drD) {
				var nagar:MovieClip=new drD();
				if (nagar.totalFrames>1) nagar.gotoAndStop(Math.floor(Math.random()*nagar.totalFrames+1));
				nagar.scaleX=nagar.scaleY=sc;
				nagar.rotation=rc;
				var dyrx=Math.round(nagar.width/2+2)*2, dyry=Math.round(nagar.height/2+2)*2;
				var res2:BitmapData = new BitmapData(dyrx, dyry, false, 0x0);
				var rdx=0, rdy=0;
				if (nx-dyrx/2<0) rdx=-(nx-dyrx/2);
				if (ny-dyry/2<0) rdy=-(ny-dyry/2);
				var rect:Rectangle = new Rectangle(nx-dyrx/2+rdx, ny-dyry/2+rdy, nx+dyrx/2+rdx, ny+dyry/2+rdy);
				var pt:Point = new Point(0, 0);
				res2.copyChannel(frontBmp, rect, pt, BitmapDataChannel.ALPHA, BitmapDataChannel.GREEN);
				frontBmp.draw(nagar, m, (bl=='normal')?World.w.loc.cTransform:null, bl, null, true);
				rect = new Rectangle(0, 0, dyrx, dyry);
				pt=new Point(nx-dyrx/2+rdx, ny-dyry/2+rdy);
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
			var br:MovieClip; //brush

			// Determine what brush to use. I moved brush instantiation here was well instead being loaded with the class.
			if (aero) {
				if (!pa) pa = new paintaero();
				br = pa;
			}
			else {
				if (!pb) pb = new paintbrush();
				br = pb;
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
			brPoint.x = 0;
			brPoint.y = 0;
			brRect.left		= rx1;
			brRect.right	= rx2;
			brRect.top		= ry1;
			brRect.bottom	= ry2;
			brData.copyChannel(backBmp, brRect, brPoint, BitmapDataChannel.ALPHA, BitmapDataChannel.GREEN);
			
			// Paint along the line, step by step.
			for (var i = 1; i <= kol; i++)
			{
				// Calculate the next point to paint.
				pm.tx = nx1 + dx * i;
				pm.ty = ny1 + dy * i;

				// Perform the painting action at this point.		
				backBmp.draw(br, pm, brTrans, 'normal', null, false);
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
		
		public function specEffect(n:Number = 0):void
		{
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
				trace('ERROR: Unknown special effect: "' + n + '"!');
			}
		}
	}
}
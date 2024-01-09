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
	import flash.filters.BevelFilter;
	import flash.filters.BlurFilter;
	import flash.filters.GlowFilter;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.DropShadowFilter;
	import flash.utils.*;
	import flash.net.URLRequest;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.ProgressEvent;
    import flash.ui.MouseCursorData;
    import flash.ui.Mouse;
	
	import fe.*;
	import fe.loc.*;	
	import fl.motion.Color;
	
	public class Grafon {
		
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
		
		var resX:int, resY:int;
		var kusokX:int=48, kusokY:int=25;
		
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
		
		public var pa:MovieClip=new paintaero();
		public var pb:MovieClip=new paintbrush();
		public var brTrans:ColorTransform=new ColorTransform();
		public var brColor:Color=new Color();
		var brData:BitmapData = new BitmapData(100, 100, false, 0x0);
		var brPoint:Point = new Point(0, 0);
		var brRect:Rectangle = new Rectangle(0,0,50,50);
		var pm:Matrix=new Matrix();
			
		
		var voda=new tileVoda();
		//********************************************************************************************************************************************************************************************************************
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
		//public var loadTex:Loader, loadTex1:Loader, loadSprite:Loader, loadSprite1:Loader;
		public var resIsLoad:Boolean=false;
		public var progressLoad:Number=0;
		/*progressTex:Number=0, progressSprite:Number=0;
		public static var resTex:*;		//содержимое загруженного файла
		public static var resTex1:*;		//содержимое загруженного файла
		public static var resSprite:*;		//содержимое загруженного файла
		public static var resSprite1:*;		//содержимое загруженного файла
		*/
		public static var spriteLists:Array=new Array();
		public static var texUrl:Array=['texture.swf','texture1.swf','sprite.swf','sprite1.swf'];
		public var grLoaders:Array;
		
		public static const numbMat=0;		//материалы
		public static const numbFon=0;		//задники
		public static const numbBack=1;		//декорации
		public static const numbObj=1;		//объекты
		public static const numbSprite=2;	//номер, с которого начинаются файлы спрайтов
		
		
		public function Grafon(nvis:Sprite) {
			visual=nvis;
			visBack=new Sprite();
			visBack2=new Sprite();
			visVoda=new Sprite();
			visVoda.alpha=0.6;
			visFront=new Sprite();
			visLight=new Sprite();
			visSats=new Sprite();
			visSats.visible=false;
			visSats.filters=[new BlurFilter(3,3,1)];
			
			visObjs=new Array();
			for (var i=0; i<kolObjs; i++) visObjs.push(new Sprite());
			
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
			visLight.x=-Tile.tileX/2;
			visLight.y=-Tile.tileY/2-Tile.tileY;
			visLight.scaleX=Tile.tileX;
			visLight.scaleY=Tile.tileY;
			
			frontBmp=new BitmapData(rectX, rectY, true, 0x0)
			frontBitmap = new Bitmap(frontBmp);
			visFront.addChild(frontBitmap);
			
			backBmp=new BitmapData(rectX, rectY, true, 0x0)
			backBitmap = new Bitmap(backBmp);
			visBack.addChild(backBitmap);
			
			backBmp2=new BitmapData(rectX, rectY, true, 0x0)
			backBitmap2 = new Bitmap(backBmp2);
			visBack2.addChild(backBitmap2);

			vodaBmp=new BitmapData(rectX, rectY, true, 0x0)
			vodaBitmap = new Bitmap(vodaBmp);
			visVoda.addChild(vodaBitmap);
			
			satsBmp=new BitmapData(rectX, rectY, true,0);
			satsBitmap = new Bitmap(satsBmp,'auto',true);
			visSats.addChild(satsBitmap);
			
			colorBmp=new BitmapData(rectX, rectY, true,0);
			shadBmp=new BitmapData(rectX, rectY, true,0);
			
			lightBmp=new BitmapData(lightX, lightY,true,0xFF000000);
			lightBitmap = new Bitmap(lightBmp,'auto',true);
			visLight.addChild(lightBitmap);

			ramT=new visBlack();
			ramB=new visBlack();
			ramR=new visBlack();
			ramL=new visBlack();
			ramT.cacheAsBitmap=ramB.cacheAsBitmap=ramR.cacheAsBitmap=ramL.cacheAsBitmap=true;
			visual.addChild(ramT);
			visual.addChild(ramB);
			visual.addChild(ramR);
			visual.addChild(ramL);
			
			grLoaders=new Array();
			for (var i in texUrl) {
				var textureURL:String=texUrl[i];
				if (World.w.playerMode=='PlugIn') {
					textureURL+='?u='+World.w.fileVersion;
				}
				grLoaders[i]=new GrLoader(i,textureURL,this);
			}
			createCursors();
		}
		
		public function checkLoaded(n:int) {
			if (n==0) {
				//считывание материалов их xml
				arrFront=new Array();
				arrBack=new Array();
				for each (var p:XML in AllData.d.mat) {
					if (p.@vid.length()==0) {
						if (p.@ed=='2') arrBack[p.@id]=new Material(p);
						else arrFront[p.@id]=new Material(p);
					}
				}
			}
			resIsLoad=(GrLoader.kolIsLoad>=GrLoader.kol);
		}
		
		public function allProgress() {
			progressLoad=0;
			for (var i in grLoaders) {
				progressLoad+=grLoaders[i].progressLoad;
			}
			progressLoad/=GrLoader.kol;
		}
		
		function createCursors() {
			createCursor(visCurArrow,'arrow');
			createCursor(visCurTarget,'target',13,13);
			createCursor(visCurTarget1,'combat',13,13);
			createCursor(visCurTarget2,'action',13,13);
			//if (!World.w.sysCur) Mouse.cursor='arrow';
			//Mouse.unregisterCursor('arrow');
 		}
		
		function createCursor(vcur:Class, nazv:String, nx:int=0, ny:int=0) {
			var cursorData:Vector.<BitmapData>;
			var mouseCursorData:MouseCursorData;
			cursorData=new Vector.<BitmapData>();
			cursorData.push(new vcur());
			mouseCursorData = new MouseCursorData();
            mouseCursorData.data = cursorData;
			mouseCursorData.hotSpot=new Point(nx,ny);
            //mouseCursorData.frameRate = 1;
            Mouse.registerCursor(nazv, mouseCursorData);
		}
		
		/*function texLoaded(event:Event):void {
			resTex = event.target.content;
			checkLoaded();
			trace(event.target.loader.x);
		}
		
		function spriteLoaded(event:Event):void {
			resSprite = event.target.content;
			checkLoaded();
 		}
		function sprite1Loaded(event:Event):void {
			resSprite1 = event.target.content;
			checkLoaded();
 		}
		function checkLoaded() {
			if (resTex!=null && resSprite!=null && resSprite1!=null) resIsLoad=true;
		}
		
		private function progressTexHandler(event:ProgressEvent):void {
			progressTex=event.bytesLoaded/event.bytesTotal;
			progressLoad=(progressTex+progressSprite)/2;
        }
		private function progressSpriteHandler(event:ProgressEvent):void {
			progressSprite=event.bytesLoaded/event.bytesTotal;
			progressLoad=(progressTex+progressSprite)/2;
        }*/
		
//============================================================================================		
//							Начальная прорисовка локации
//============================================================================================		
		
		public function getObj(tex:String, n:int=0):* {
			return this.grLoaders[n].res.getObj(tex);
		}
		
		//показать задний фон
		public function drawFon(vfon:MovieClip, tex:String) {
			if (tex=='' || tex==null) tex='fonDefault';
			if (visFon && vfon.contains(visFon)) vfon.removeChild(visFon);
			visFon=getObj(tex);
			if (visFon) vfon.addChild(visFon);
		}
		
		public function setFonSize(nx:Number, ny:Number) {
			if (visFon) {
				if (nx>rectX && ny>rectY) {
					visFon.x=visual.x;
					visFon.y=visual.y;
					visFon.width=rectX;
					visFon.height=rectY;
				} else {
					var koef=visFon.width/visFon.height;
					visFon.x=visFon.y=0;
					if (nx>=ny*koef) {
						visFon.width=nx;
						visFon.height=nx/koef;
					} else {
						visFon.height=ny;
						visFon.width=ny*koef;
					}
				}
			}
		}
		
		public function warShadow() {
			if (World.w.pers.infravis) {
				visLight.transform.colorTransform=infraTransform;
				visLight.blendMode='multiply';
			} else {
				visLight.transform.colorTransform=defTransform
				visLight.blendMode='normal';
			}
		}
		var nn:int=0;
		
		//прорисовка локации
		public function drawLoc(nloc:Location) {
			try {
			//var d1:Date=new Date();
		/* ****** */World.w.gr_stage=1;
			loc=nloc;
			loc.grafon=this;
			resX=loc.spaceX*Tile.tileX, resY=loc.spaceY*Tile.tileY;
			
			var transpFon:Boolean=nloc.transpFon;;
			if (nloc.backwall=='sky') transpFon=true;
			
		/* ****** */World.w.gr_stage=2;
			//рамки
			ramT.x=ramB.x=-50;
			ramR.y=ramL.y=0;
			ramT.y=0;
			ramL.x=0;
			ramB.y=loc.limY-1;
			ramR.x=loc.limX-1;
			ramT.scaleX=ramB.scaleX=loc.limX/100+1;
			ramT.scaleY=ramB.scaleY=2;
			ramR.scaleY=ramL.scaleY=loc.limY/100;
			ramR.scaleX=ramL.scaleX=2;
			
			/*nn++;
			if (nn%3==0) {
				var g;
				g.t=0;
			}*/
		
		/* ****** */World.w.gr_stage=3;		//где-то тут
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
			
			//if (colorBmp) colorBmp.dispose();
			var darkness:int=0xAA+loc.darkness;
			if (darkness>0xFF) darkness=0xFF;
			if (darkness<0) darkness=0;
			colorBmp.fillRect(allRect,darkness*0x1000000);
			shadBmp.fillRect(allRect,0xFFFFFFFF);
			//colorBmp=new BitmapData(resX, resY, true, darkness*0x1000000);
			
			
			//if (shadBmp) shadBmp.dispose();
			//shadBmp=new BitmapData(resX, resY,true,0xFFFFFFFF);
		

		/* ****** */World.w.gr_stage=4;

			m=new Matrix();
			var tile:MovieClip;
			var t:Tile;
			var front:Sprite=new Sprite();	//отпечаток на битмапе переднего плана
			var back:Sprite=new Sprite();	//отпечаток на битмапе задника
			var back2:Sprite=new Sprite();	//отпечаток на битмапе задника
			var voda:Sprite=new Sprite();	//отпечаток на битмапе воды
			
			//отключить все материалы
			var mat:Material;
			for each (mat in arrFront) mat.used=false;
			for each (mat in arrBack) mat.used=false;
			
			var gret:int=0;
		/* ****** */World.w.gr_stage=5;
			for (var i=0; i<loc.spaceX; i++) {
				for (var j=0; j<loc.spaceY; j++) {
					t=loc.getTile(i,j);
					//if (t.phis==1) gret=1;
					//else if (t.back!='' && arrBack[t.back] && arrBack[t.back].slit) gret=2;
					//else gret=0;
					loc.tileKontur(i,j,t);
					if (arrFront[t.front]) arrFront[t.front].used=true;
					if (arrBack[t.back]) arrBack[t.back].used=true;
					if (t.vid>0) {				//объекты, имеющие vid
						tile=new tileFront();
						tile.gotoAndStop(t.vid);
						if (t.vRear) back2.addChild(tile);
						else front.addChild(tile);
						tile.x=i*Tile.tileX;
						tile.y=j*Tile.tileY;
					}
					if (t.vid2>0) {				//объекты, имеющие vid2
						tile=new tileFront();
						tile.gotoAndStop(t.vid2);
						if (t.v2Rear) back2.addChild(tile);
						else front.addChild(tile);
						tile.x=i*Tile.tileX;
						tile.y=j*Tile.tileY;
					}
					if (t.water) {				//вода
						tile=new tileVoda();
						tile.gotoAndStop(loc.tipWater+1);
						if (loc.getTile(i,j-1).water==0 && loc.getTile(i,j-1).phis==0) tile.voda.gotoAndStop(2);
						tile.x=i*Tile.tileX;
						tile.y=j*Tile.tileY;
						voda.addChild(tile);
					}
				}
			}
		/* ****** */World.w.gr_stage=6;
			vodaBmp.draw(voda, new Matrix, null, null, null, false);
			frontBmp.draw(front, new Matrix, null, null, null, false);
			
			
		/* ****** */World.w.gr_stage=7;
			drawBackWall(nloc.backwall, nloc.backform);							//задняя стена
		/* ****** */World.w.gr_stage=8;
			for each (mat in arrFront) {
				try {
					drawKusok(mat,true);	//передний план
				} catch (err) {
					World.w.showError(err,'Ошибка рисования слоя '+mat.id);
				}
			}
		/* ****** */World.w.gr_stage=9;
			for (var e in arrBack) {
				try {
					drawKusok(arrBack[e],false);		//задний план
				} catch (err) {
					World.w.showError(err,'Ошибка рисования слоя '+arrBack[e].id);
				}
			}
							//if (nloc.landX>0) {var d; d.d=0;}
		/* ****** */World.w.gr_stage=10;
			satsBmp.copyChannel(backBmp,backBmp.rect,new Point(0,0),BitmapDataChannel.ALPHA,BitmapDataChannel.ALPHA);
			var darkness2=1-(255-darkness)/150;
			//ct=new ColorTransform(darkness2,darkness2,darkness2);
			//объекты заднего плана
			var ct:ColorTransform=new ColorTransform();
			//var et:ColorTransform=new ColorTransform(1,1,1,1,255,255,255);
		/* ****** */World.w.gr_stage=11;
			for (j=-2; j<=3; j++) {
				if (j==-1) backBmp.copyChannel(satsBmp,backBmp.rect,new Point(0,0),BitmapDataChannel.ALPHA,BitmapDataChannel.ALPHA);
				for each(var bo:BackObj in loc.backobjs) {	
					if (bo.sloy==j && !bo.er || j==-2 && bo.er) {
						m=new Matrix();
						m.scale(bo.scX, bo.scY);
						//trace(m.a,m.b,m.c,m.d);
						m.tx=bo.X;
						m.ty=bo.Y;
						ct.alphaMultiplier=bo.alpha;
						if (bo.vis) {
							if (j<=0) {
								ct.redMultiplier=ct.greenMultiplier=ct.blueMultiplier=1;
								backBmp.draw(bo.vis, m, ct, bo.blend, null, true);
							} else {
								if (bo.light) {
									if (darkness2>=0.43) ct.redMultiplier=ct.greenMultiplier=ct.blueMultiplier=1;
									else ct.redMultiplier=ct.greenMultiplier=ct.blueMultiplier=0.55+darkness2;
								} else ct.redMultiplier=ct.greenMultiplier=ct.blueMultiplier=darkness2;
								//trace(darkness2)
								backBmp2.draw(bo.vis, m, ct, bo.blend, null, true);
								if (bo.light) ct.redMultiplier=ct.greenMultiplier=ct.blueMultiplier=1;
								else ct.redMultiplier=ct.greenMultiplier=ct.blueMultiplier=darkness2;
							}
						}
						if (bo.erase) satsBmp.draw(bo.erase, m, null, 'erase', null, true);
						if (bo.light) colorBmp.draw(bo.light, m, ct, 'normal', null, true);
					}
				}
			}
		/* ****** */World.w.gr_stage=12;
			m=new Matrix();
			if (nloc.cTransform) {
				frontBmp.colorTransform(frontBmp.rect,nloc.cTransform);
				vodaBmp.colorTransform(vodaBmp.rect,nloc.cTransform);
			}
			shadBmp.applyFilter(frontBmp,frontBmp.rect,new Point(0,0),dsFilter);
		/* ****** */World.w.gr_stage=13;
			
			//затемнение заднего плана
			
			if (nloc.cTransform) {
				backBmp.colorTransform(backBmp.rect,nloc.cTransform);
				ct=new ColorTransform();//170,130
				darkness2=1+(170-darkness)/33;
				ct.concat(nloc.cTransform);
				if (darkness2>1) {
					ct.redMultiplier*=darkness2;
					ct.greenMultiplier*=darkness2;
					ct.blueMultiplier*=darkness2;
				}
				backBmp2.colorTransform(backBmp2.rect,ct);
			}
		/* ****** */World.w.gr_stage=14;
			backBmp2.draw(back, new Matrix, nloc.cTransform, null, null, false);
			//backBmp2.colorTransform(backBmp2.rect,ct);
			
		/* ****** */World.w.gr_stage=15;
			if (transpFon) satsBmp.copyChannel(backBmp,backBmp.rect,new Point(0,0),BitmapDataChannel.ALPHA,BitmapDataChannel.ALPHA);
			backBmp.draw(colorBmp,null,null,'hardlight');
			backBmp.draw(shadBmp);
			if (transpFon) backBmp.copyChannel(satsBmp,backBmp.rect,new Point(0,0),BitmapDataChannel.ALPHA,BitmapDataChannel.ALPHA);
			//backBmp.copyChannel(satsBmp,backBmp.rect,new Point(0,0),BitmapDataChannel.ALPHA,BitmapDataChannel.ALPHA);
			
			//розовое облако
		/* ****** */World.w.gr_stage=16;
			if (loc.gas>0) {
				m=new Matrix();
				m.ty=520;
				backBmp2.draw(getObj('back_pink_t',numbBack),m,new ColorTransform(1,1,1,0.3));
				//vodaBmp
			}
			
		/* ****** */World.w.gr_stage=17;
			for each (mat in arrFront) drawKusok(mat,false,true);	//добавление на задний план текстур переднего плана, таких как балки
			backBmp2.draw(back2, new Matrix, nloc.cTransform, null, null, false);
			
			
		/* ****** */World.w.gr_stage=18;
			frontBmp.unlock();
			backBmp.unlock();
			backBmp2.unlock();
			vodaBmp.unlock();
			
			if (nloc.cTransform && nloc.cTransformFon) {
				visFon.transform.colorTransform=nloc.cTransformFon;
			} else if (visFon.transform.colorTransform!=defTransform) {
				visFon.transform.colorTransform=defTransform;
			}
		} catch (err) {World.w.showError(err)}
		/* ****** */World.w.gr_stage=19;
			//активные объекты
			drawAllObjs();
			//var d2:Date=new Date();
			//trace('***',d2.getTime()-d1.getTime(),'ms')
		/* ****** */World.w.gr_stage=0;
		}
		
		//прорисовка всей карты затемнения
		public function setLight() {
			lightBmp.lock();
			for (var i=1; i<loc.spaceX; i++) {
				for (var j=1; j<loc.spaceY; j++) {
					lightBmp.setPixel32(i,j+1,Math.floor((1-loc.space[i][j].visi)*255)*0x1000000);
				}
			}
			lightBmp.unlock();
		}
		
		//добавление всех видимых объектов
		public function drawAllObjs() {
			for (var i=0; i<kolObjs; i++) {
				var n=visual.getChildIndex(visObjs[i]);
				visual.removeChild(visObjs[i]);
				visObjs[i]=new Sprite();
				visual.addChildAt(visObjs[i],n);
			}
			var obj:Pt=loc.firstObj;
			while (obj) {
				obj.addVisual();
				obj=obj.nobj;
			}
			loc.gg.addVisual();
			for (i in loc.signposts) visObjs[3].addChild(loc.signposts[i]);
		}
		
		//заполнение заднего плана текстурой
		public function drawBackWall(tex:String, sposob:int=0) {
			if (tex=='sky') return;
			m=new Matrix();
			var fill:BitmapData=getObj(tex);
			if (fill==null) fill=getObj('tBackWall')
			var osn:Sprite=new Sprite();
			osn.graphics.beginBitmapFill(fill);
			if (sposob==0) {
				osn.graphics.drawRect(0,0,kusokX*Tile.tileX,kusokY*Tile.tileY);
			} else if (sposob==1) {
				osn.graphics.drawRect(0,0,11*Tile.tileX-10,kusokY*Tile.tileY);
				osn.graphics.drawRect(37*Tile.tileX+10,0,kusokX*Tile.tileX,kusokY*Tile.tileY);
			} else if (sposob==2) {
				osn.graphics.drawRect(0,16*Tile.tileY+10,kusokX*Tile.tileX,kusokY*Tile.tileY);
			} else if (sposob==3) {
				osn.graphics.drawRect(0,24*Tile.tileY+10,kusokX*Tile.tileX,kusokY*Tile.tileY);
			}
			backBmp.draw(osn, m, null, null, null, false);
			//backBmp.draw(dyr, m, null, 'erase', null, true);
		}
		
		function setMCT(mc:MovieClip, t:Tile, toFront:Boolean) {
			if (mc.c1) {
				if (toFront) {
					mc.c1.gotoAndStop(t.kont1+1);
					mc.c2.gotoAndStop(t.kont2+1);
					mc.c3.gotoAndStop(t.kont3+1);
					mc.c4.gotoAndStop(t.kont4+1);
				} else {
					mc.c1.gotoAndStop(t.pont1+1);
					mc.c2.gotoAndStop(t.pont2+1);
					mc.c3.gotoAndStop(t.pont3+1);
					mc.c4.gotoAndStop(t.pont4+1);
				}
			}
		}
		
		//рисование текстурных материалов
		public function drawKusok(material:Material, toFront:Boolean, dop:Boolean=false) {
			if (!material.used) return;
			if (material.rear==toFront) return;
			var t:Tile;
			var mc:MovieClip;
			var kusok:Sprite=new Sprite();
			
			var osn:Sprite=new Sprite();
			var maska:Sprite=new Sprite();
			var border:Sprite=new Sprite();
			var bmaska:Sprite=new Sprite();
			var floor:Sprite=new Sprite();
			var fmaska:Sprite=new Sprite();
			
			if (material.texture==null) osn.graphics.beginFill(0x666666);
			else if (loc.homeStable && material.alttexture!=null) osn.graphics.beginBitmapFill(material.alttexture);
			else osn.graphics.beginBitmapFill(material.texture);
			osn.graphics.drawRect(0,0,kusokX*Tile.tileX,kusokY*Tile.tileY);
			kusok.addChild(osn);
			kusok.addChild(maska);
			if (material.border) {
				border.graphics.beginBitmapFill(material.border);
				border.graphics.drawRect(0,0,kusokX*Tile.tileX,kusokY*Tile.tileY);
				kusok.addChild(border);
				kusok.addChild(bmaska);
			}
			if (material.floor) {
				floor.graphics.beginBitmapFill(material.floor);
				floor.graphics.drawRect(0,0,kusokX*Tile.tileX,kusokY*Tile.tileY);
				kusok.addChild(floor);
				kusok.addChild(fmaska);
			}
			
			var isDraw:Boolean=false;
			
			for (var i=0; i<loc.spaceX; i++) {
				for (var j=0; j<loc.spaceY; j++) {
					t=loc.getTile(i,j);
					if (t.front==material.id && (toFront || dop) || t.back==material.id && !toFront) {
						isDraw=true;
						mc=new material.textureMask();
							setMCT(mc,t,toFront);
							mc.x=(i+0.5)*Tile.tileX;
							mc.y=(j+0.5)*Tile.tileY;
							maska.addChild(mc);
							if (t.zForm && toFront) {
								mc.scaleY=(t.phY2-t.phY1)/Tile.tileY;
								mc.y=(t.phY2+t.phY1)/2;
							}							
						if (material.borderMask) {
							mc=new material.borderMask();
							setMCT(mc,t,toFront);
							mc.x=(i+0.5)*Tile.tileX;
							mc.y=(j+0.5)*Tile.tileY;
							bmaska.addChild(mc);
							if (t.zForm && toFront) {
								mc.scaleY=(t.phY2-t.phY1)/Tile.tileY;
								mc.y=(t.phY2+t.phY1)/2;
							}							
						}
						if (material.floorMask) {// && !t.zForm
							mc=new material.floorMask();
							if (mc.c1) {
								mc.c1.gotoAndStop(t.kont1+1);
								mc.c2.gotoAndStop(t.kont2+1);
							}
							fmaska.addChild(mc);
							mc.x=(i+0.5)*Tile.tileX;
							mc.y=(j+0.5+t.zForm/4)*Tile.tileY;	//
						}
					}
				}
			}
			if (!isDraw) return;
			m.tx=0;
			m.ty=0;
			osn.cacheAsBitmap=maska.cacheAsBitmap=border.cacheAsBitmap=bmaska.cacheAsBitmap=floor.cacheAsBitmap=fmaska.cacheAsBitmap=true;
			osn.mask=maska; border.mask=bmaska; floor.mask=fmaska;
			if (material.F) kusok.filters=material.F;
			//trace(material.id,material.F);
			if (toFront) frontBmp.draw(kusok, m, null, null, null, false);
			else if (dop) backBmp2.draw(kusok, m, loc.cTransform, null, null, false);
			else backBmp.draw(kusok, m, null, null, null, false); 
		}
		
//============================================================================================		
//							Время выполнения
//============================================================================================		
		
		public function getSpriteList(id:String, n:int=0):BitmapData {
			if (spriteLists[id]==null) {
				if (n>0) spriteLists[id]=getObj(id,numbSprite+n);
				else {
					spriteLists[id]=getObj(id,numbSprite);
					if (spriteLists[id]==null) spriteLists[id]=getObj(id,numbSprite+1);
				}
			}
			if (spriteLists[id]==null) trace('нет спрайтов', id)
			return spriteLists[id];
		}
		
		public function drawSats() {
			satsBmp.fillRect(satsBmp.rect,0);
			satsBmp.draw(visual,new Matrix);
		}
		
		public function onSats(on:Boolean) {
			visSats.visible=on;
			visObjs[2].visible=!on;
			//for each (var ob in visObjs) ob.visible=!on;
		}
		
		//рисование одного блока воды
		public function drawWater(t:Tile, recurs:Boolean=true) {
			m=new Matrix();
			m.tx=t.X*Tile.tileX;
			m.ty=t.Y*Tile.tileY;
			voda.gotoAndStop(loc.tipWater+1);
			if (loc.getTile(t.X,t.Y-1).water==0 && loc.getTile(t.X,t.Y-1).phis==0 ) voda.voda.gotoAndStop(2);
			else voda.voda.gotoAndStop(1);
			vodaBmp.draw(voda, m, loc.cTransform, (t.water>0)?'normal':'erase', null, false);
			if (recurs) drawWater(loc.getTile(t.X,t.Y+1),false);
		}
		
		public function tileDie(t:Tile,tip:int) {
			var erC:Class=block_dyr, drC:Class=block_tre;
			var nx=(t.X+0.5)*Tile.tileX;
			var ny=(t.Y+0.5)*Tile.tileY;
			if (t.fake) {
				Emitter.emit('fake',loc,nx,ny);
				drC=block_bur;
			} else if (t.mat==7) {
				Emitter.emit('fake',loc,nx,ny);
				Emitter.emit('pole',loc,nx,ny,{kol:10, rx:Tile.tileX, ry:Tile.tileY});
				erC=TileMask;
				drC=null;
			} else if (tip<10) {
				if (t.mat==1) Emitter.emit('metal',loc,nx,ny,{kol:6, rx:Tile.tileX, ry:Tile.tileY})
				else if (t.mat==2) Emitter.emit('kusok',loc,nx,ny,{kol:6, rx:Tile.tileX, ry:Tile.tileY})
				else if (t.mat==3) Emitter.emit('schep',loc,nx,ny,{kol:6, rx:Tile.tileX, ry:Tile.tileY})
				else if (t.mat==4) Emitter.emit('kusokB',loc,nx,ny,{kol:6, rx:Tile.tileX, ry:Tile.tileY})
				else if (t.mat==5) Emitter.emit('steklo',loc,nx,ny,{kol:6, rx:Tile.tileX, ry:Tile.tileY})
				else if (t.mat==6) Emitter.emit('kusokD',loc,nx,ny,{kol:6, rx:Tile.tileX, ry:Tile.tileY})
			} else if (tip>=15) {
				Emitter.emit('plav',loc,nx,ny);
				erC=block_plav;
				drC=block_pla;
			} else if (tip>=11 && tip<=13) {
				Emitter.emit('bur',loc,nx,ny);
				drC=block_bur;
			}
			decal(erC,drC,nx,ny,1,0,'hardlight');
		}
		
		//дырки от выстрелов
		public function dyrka(nx:int,ny:int,tip:int,mat:int, soft:Boolean=false, ver:Number=1) {
			var erC:Class, drC:Class;
			var bl:String='normal';
			var centr:Boolean=false;
			var sc=Math.random()*0.5+0.5;
			var rc=Math.random()*360
			if (tip==0 || mat==0) return;
			if (mat==1) { 			//металл
				if (tip>=1 && tip<=6) drC=bullet_metal;
				else if (tip==9) {		//взрыв
					if (!soft && Math.random()*0.5<ver) drC=metal_tre;
					centr=true;
				}
			} else if (mat==2 || mat==4 || mat==6) {	//камень
				if (tip>=1 && tip<=3) {					//пули
					if (tip>1 && Math.random()>0.5) erC=bullet_dyr;
					drC=bullet_tre;
					if (tip==2) sc+=0.5;
					if (tip==3) sc+=1;
				} else if (tip>=4 && tip<=6) {			//удары
					if (!soft) drC=punch_tre;
					if (tip==5) sc+=0.5;
					if (tip==6) sc+=1;
				} else if (tip==9) {					//взрыв
					if (!soft && Math.random()*0.5<ver) drC=expl_tre;
					centr=true;
				}
				if (tip<10 && !soft) {
					if (mat==2) Emitter.emit('kusoch',loc,nx,ny,{kol:3});
					else Emitter.emit('kusochB',loc,nx,ny,{kol:3});
				}
			} else if (mat==3) {	//дерево
				if (tip>=1 && tip<=3) {					//пули
					erC=bullet_dyr;
					drC=bullet_wood;
					rc=0;
					if (tip==2) sc+=0.5;
					if (tip==3) sc+=1;
				} else if (tip>=4 && tip<=6) {			//удары
					if (!soft) drC=punch_tre;
					if (tip==5) sc+=0.5;
					if (tip==6) sc+=1;
				} else if (tip==9) {					//взрыв
					if (!soft && Math.random()*0.5<ver) drC=expl_tre;
					centr=true;
				}
				if (tip<10 && !soft) {
					Emitter.emit('schepoch',loc,nx,ny,{kol:3});
				}
			} else if (mat==7) {	//поле
				Emitter.emit('pole',loc,nx,ny,{kol:5});
			}
			if (tip==11) {					//огонь
				if (Math.random()<0.1) drC=fire_soft;
			} else if (tip==12 || tip==13) {		//лазеры
				if (soft && Math.random()*0.2>ver) {
					drC=fire_soft;
				} else {
					drC=laser_tre;
				}
				if (tip==13) sc*=0.6;
				bl='hardlight';
			} else if (tip==15) {					//плазма
				if (soft) {
					drC=plasma_soft;
				} else {
					erC=plasma_dyr, drC=plasma_tre;
				}
				bl='hardlight';
			} else if (tip==16) {
				if (soft) {
					drC=fire_soft;
				} else {
					erC=plasma_dyr, drC=bluplasma_tre;
				}
				bl='hardlight';
			} else if (tip==17) {
				if (soft) {
					drC=fire_soft;
				} else {
					erC=plasma_dyr, drC=pinkplasma_tre;
				}
				bl='hardlight';
			} else if (tip==18) {
				drC=cryo_soft;
				bl='hardlight';
			} else if (tip==19) {							//взрыв
				if (!soft && Math.random()*0.5<ver) drC=plaexpl_tre;
				centr=true;
			}			
			/*
			if (centr) {
				nx=(Math.floor(nx/World.tileX)+0.5)*World.tileX;
				ny=(Math.floor(nx/World.tileX)+0.5)*World.tileX;
			}*/
			
			decal(erC,drC,nx,ny,sc,rc,bl);
		}
		
		public function decal(erC:Class, drD:Class, nx:Number, ny:Number, sc:Number=1, rc:Number=0, bl:String='normal') {
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
				//var dyrx=Math.round(nagar.width)+4, dyry=Math.round(nagar.height)+4;
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
		
		public function gwall(nx:int,ny:int) {
			var m:Matrix=new Matrix();
			m.tx=nx*Tile.tileX;
			m.ty=ny*Tile.tileY;
			var wall:MovieClip=new tileGwall();
			frontBmp.draw(wall, m);
		}
		
		public function paint(nx1:int, ny1:int, nx2:int, ny2:int, aero:Boolean=false) {
			var br:MovieClip;
			if (aero) br=pa; else br=pb;
			var rasst:Number=Math.sqrt((nx2-nx1)*(nx2-nx1)+(ny2-ny1)*(ny2-ny1));
			var kol:int=Math.ceil(rasst/3);
			var dx:Number=(nx2-nx1)/kol;
			var dy:Number=(ny2-ny1)/kol;
			
			var rx1:int, rx2:int, ry1:int, ry2:int;
			if (nx1<nx2) {
				rx1=nx1-25, rx2=nx2+25;
			} else {
				rx1=nx2-25, rx2=nx1+25;
			}
			if (ny1<ny2) {
				ry1=ny1-25, ry2=ny2+25;
			} else {
				ry1=ny2-25, ry2=ny1+25;
			}
			
			brPoint.x=0, brPoint.y=0;
			brRect.left=rx1, brRect.right=rx2;
			brRect.top=ry1, brRect.bottom=ry2;
			brData.copyChannel(backBmp, brRect, brPoint, BitmapDataChannel.ALPHA, BitmapDataChannel.GREEN);
			
			for (var i=1; i<=kol; i++) {
				pm.tx=nx1+dx*i;
				pm.ty=ny1+dy*i;				
				backBmp.draw(br, pm, brTrans, 'normal', null, false);
			}
			
			brPoint.x=rx1, brPoint.y=ry1;
			brRect.left=0, brRect.right=rx2-rx1;
			brRect.top=0, brRect.bottom=ry2-ry1;
			backBmp.copyChannel(brData, brRect, brPoint, BitmapDataChannel.GREEN, BitmapDataChannel.ALPHA);
		}
		
		public function specEffect(n:Number=0) {
			if (n==0) {
				visual.filters=[];
				visFon.filters=[]
				//visual.rotation=0;
			} else if (n==1) {
				visual.filters=[new ColorMatrixFilter([2,-0.9,-0.1,0,0,-0.4,1.5,-0.1,0,0,-0.4,-0.9,2,0,0,0,0,0,1,0])];
			} else if (n==2) {
				visual.filters=[new ColorMatrixFilter([-0.574,1.43,0.144,0,0,0.426,0.43,0.144,0,0,0.426,1.430,-0.856,0,0,0,0,0,1,0])];
			} else if (n==3) {
//				visual.filters=[new ColorMatrixFilter([0.5,-1.9,1.1,0,0,0.5,0.5,0.5,0,0,2.4,-1.9,0.5,0,0,0,0,0,1,0])];
				visual.filters=[new ColorMatrixFilter([0,1,0,0,0,1,0,0,0,0,0,0,-0.2,0,100,0,0,0,1,0])];
			} else if (n==4) {
				//visual.filters=[new ColorMatrixFilter([-1,0,0,0,255,0,-1,0,0,255,0,0,-1,0,255,0,0,0,1,0])];
				visual.filters=[new ColorMatrixFilter([0,-0.5,-0.5,0,255,-0.5,0,-0.5,0,255,-0.5,-0.5,0,0,255,0,0,0,1,0])];
			} else if (n==5) {
				visual.filters=[new ColorMatrixFilter([3.4,6.7,0.9,0,-635,3.4,6.75,0.9,0,-635,3.4,6.7,0.9,0,-635,0,0,0,1,0])];
			} else if (n==6) {
				visual.filters=[new ColorMatrixFilter([0.33,0.33,0.33,0,0,0.33,0.33,0.33,0,0,0.33,0.33,0.33,0,0,0,0,0,1,0])];
			} else if (n>100) {
				visual.filters=[new BlurFilter(n-100,n-100)];
				visFon.filters=[new BlurFilter(n-100,n-100)];
			}
		}
		
		
	}
	
}

package fe.loc {
	
	import flash.utils.*;
	import flash.filters.DropShadowFilter;
	import flash.display.MovieClip;
	import flash.geom.ColorTransform;
	
	import fe.*;
	import fe.serv.Interact;
	import fe.unit.Unit;
	import fe.unit.VirtualUnit;
	import fe.graph.Emitter;
	import fe.graph.Grafon;
	import fe.serv.Script;
	import fe.weapon.Bullet;
	import fe.unit.Mine;

	public class Box extends Obj{
		
		public var osnova:Box=null;		//на чём стоит
		public var shelf:Boolean=true;	//на этом можно стоять
		public var isPlav:Boolean=false, isPlav2:Boolean=false, fixPlav:Boolean=false;
		public var id:String;
		public var door:int=0;
		public var begX:Number=-1, begY:Number=-1; 		//исходная точка
		public var stX:Number=0, stY:Number=0;	//положение на начало такта
		public var cdx:Number=0, cdy:Number=0;	//движение того, кто стоит на ящике	
		public var vel2:Number=0; //скорость в квадрате
		
		public var mat:int=0;		//материал	//0 - хз что //1 - металл //2 - камень //3 - дерево
		public var wall:int=0;		//крепится на стену
		public var phis:int=1;
		public var sur:int=0;		//предме на ящике
		//public var trap:int=0;
		public var hp:Number=100;
		public var thre:Number=0;
		public var montdam:int=5;		//насколько будет ломаться монтировка
		public var electroDam:Number=0;	//если больше 0 - является генератором электрозащиты
		public var tiles:Array;			//задействованные блоки
		public var dead:Boolean=false;
		public var invis:Boolean=false;
		public var light:Boolean=false;	//убрать туман войны в этой точке
		public var door_opac:Number=1;
		var massaMult:Number=1;
		
		public var molnDam:Number=0;	//удар разрядом
		public var molnPeriod:int=60;
		public var moln_t:int=0;

		public var bulPlayer:Boolean=false;	//ловить пули игрока
		public var explcrack:Boolean=false;	//открывается взрывом
		public var bulTele:Boolean=false;	//ловить пули врагов при левитации
		public var bulChance:Number=0;
		public var lurk:int=0;				//возможность прятаться
		public var isThrow:Boolean=false;	//был брошен телекинезом
		public var t_throw:int=0;
		
		public var noiseDie:Number=800;

		public var scrDie:Script;
		
		public var sndOn:Boolean=false;
		public var sndFall:String='';
		public var sndOpen:String='';
		public var sndClose:String='';
		public var sndDie:String='';
		
		private var dsf:DropShadowFilter=new DropShadowFilter(0,90,0,0.8,8,8,1,3,false,false,true);
		public var shad:MovieClip;
		
		public var ddyPlav:Number=1; //выталкивающая сила, 1 если нет, <0 если предмет всплывает
		
		public var un:VirtualUnit;	//виртуальный юнит для взаимодействия с пулями;
		
		public function Box(nloc:Location, nid:String, nx:int=0, ny:int=0, xml:XML=null, loadObj:Object=null) {
			loc=nloc;
			id=nid;
			if (loc.land.kolAll) {
				if (loc.land.kolAll[id]>0) loc.land.kolAll[id]++;
				else loc.land.kolAll[id]=1;
				//trace(id, loc.land.kolAll[id])
			}
			prior=1;
			vis=World.w.grafon.getObj('vis'+id, Grafon.numbObj);
			shad=World.w.grafon.getObj('vis'+id, Grafon.numbObj);
			if (vis==null) {
				vis=new visbox0();
				shad=new visbox0();
			}
			/*var vClass:Class;
			try {
				vClass=getDefinitionByName('vis'+id) as Class;
			} catch (err:ReferenceError) {
				vClass=visbox0;
			}
			vis=new vClass();
			shad=new vClass();*/
			vis.stop();
			shad.gotoAndStop(vis.currentFrame);
			shad.filters=[dsf];
			
			var node:XML=AllData.d.obj.(@id==id)[0];
			
			X=begX=nx, Y=begY=ny;
			scX=vis.width;
			scY=vis.height;
			if (node.@scx.length()) scX=node.@scx;
			if (node.@scy.length()) scY=node.@scy;
			X1=X-scX/2, X2=X+scX/2, Y1=Y-scY, Y2=Y;
			
			
			if (node.@mat.length()) mat=node.@mat;
			if (node.@hp.length()) hp=node.@hp;
			if (node.@thre.length()) thre=node.@thre;
			if (node.@shield.length()) bulChance=node.@shield;
			if (node.@lurk.length()) lurk=node.@lurk;
			if (node.@sur.length()) sur=node.@sur;
			if (node.@montdam.length()) montdam=node.@montdam;
			if (node.@electro.length()) electroDam=node.@electro;
			if (node.@moln.length()) molnDam=node.@moln;
			if (node.@period.length()) molnPeriod=node.@period;
			if (node.@rad.length()) radioactiv=node.@rad;
			if (node.@radrad.length()) radrad=node.@radrad;
			if (node.@radtip.length()) radtip=node.@radtip;
			if (node.@wall.length()) wall=node.@wall;
			if (wall>1) shad.alpha=0;
			if (node.@phis.length()) phis=node.@phis;
			if (node.@fall.length()) sndFall=node.@fall;
			if (node.@open.length()) sndOpen=node.@open;
			if (node.@close.length()) sndClose=node.@close;
			if (node.@die.length()) sndDie=node.@die;
			if (node.@plav.length()) ddyPlav=node.@plav;
			if (node.@nazv.length()) nazv=Res.txt('o',node.@nazv);
			else nazv=Res.txt('o',id);
			if (node.@explcrack.length()) explcrack=true;
			if (scX<40 || wall>0) shelf=false;
			if (node.@shelf.length()) shelf=true;
			if (node.@massaMult.length()) massaMult=node.@massaMult;
			massa=scX*scY*scY/250000*massaMult;
			if (node.@massa.length()) massa=node.@massa/50;
			
			if (xml && xml.@indestruct.length()) {
				hp=10000;
				thre=10000;
			}
			//дверь
			if (node.@door.length()) {
				door=node.@door;
				if (node.@opac.length()) door_opac=node.@opac;
				initDoor();
			}
			//интерактивность
			if (node.@inter.length() || (xml && (xml.@inter.length() || xml.scr.length() || xml.@scr.length()))) inter=new Interact(this,node,xml,loadObj);
			if (inter && inter.cont!='' && inter.cont!='empty' && inter.lock && inter.lockTip<=1) bulPlayer=true;
			
			//индивидуальные параметры из xml карты
			if (xml) {
				if (xml.@name.length()) nazv=Res.txt('o',xml.@name);	//название
				//прикреплённые скрипты
				if (xml.scr.length()) {
					for each (var xscr in xml.scr) {
						var scr:Script=new Script(xscr,loc.land);
						if (inter && scr.eve==null) inter.scrAct=scr;
						if (inter && scr.eve=='open') inter.scrOpen=scr;
						if (inter && scr.eve=='close') inter.scrClose=scr;
						if (inter && scr.eve=='touch') inter.scrTouch=scr;
						if (scr.eve=='die') scrDie=scr;
						scr.owner=this;
					}
				}
				if (xml.@scr.length()) inter.scrAct=World.w.game.getScript(xml.@scr,this);
				if (xml.@scropen.length()) inter.scrOpen=World.w.game.getScript(xml.@scropen,this);
				if (xml.@scrclose.length()) inter.scrClose=World.w.game.getScript(xml.@scrclose,this);
				if (xml.@scrtouch.length()) inter.scrTouch=World.w.game.getScript(xml.@scrtouch,this);
				if (xml.@scrdie.length()) scrDie=World.w.game.getScript(xml.@scrdie,this);
				if (xml.@moln.length()) molnDam=xml.@moln;
				if (xml.@period.length()) molnPeriod=xml.@period;
				if (xml.@phase.length()) moln_t=xml.@phase;
				
				if (xml.@prob.length() && id!='exit') {
					nazv=Res.txt('m',xml.@prob);
				}
				if (xml.@light.length()) light=true;
				if (xml.@fun.length()) {
					initFun(xml.@fun);
				}
				if (xml.@radrad.length()) radrad=xml.@radrad;
			}
			
			if (wall>0) {
				levitPoss=false;
				stay=true;
				sloy=0;
			} else sloy=1;
			if (node.@sloy.length()) sloy=node.@sloy;
			
			cTransform=loc.cTransform;
			
			
			vis.cacheAsBitmap=true;
			vis.x=shad.x=X,vis.y=Y,shad.y=Y+(wall?2:6);
			prior+=1/(scX*scY);
			if (node.@actdam.length()) {
				if (xml && xml.@tipdam.length())  bindUnit(xml.@tipdam);
				else bindUnit();
			}
			if (xml && xml.@pokr.length()) {
				sloy=1;
				prior=3;
			}
			
			if (loadObj && loadObj.dead) die(-1);		//если объект был уничтожен
			

			
		}
		
		public override function save():Object {
			var obj:Object=new Object();
			if (dead) obj.dead=true;
			if (inter) inter.save(obj);
			return obj;
		}
		
		public override function command(com:String, val:String=null) {
			super.command(com,val);
			if (com=='die') {
				hp=0;
				die();
			}
			if (inter) inter.command(com,val);
		}
		
		public override function addVisual() {
			if (invis) return;
			if (vis && loc && loc.active) {
				if (shad) World.w.grafon.visObjs[0].addChild(shad);
				World.w.grafon.visObjs[sloy].addChild(vis);
				if (cTransform) {
					vis.transform.colorTransform=cTransform;
				}
			}
		}
		public override function setNull(f:Boolean=false) {
			super.setNull(f);
			if (!dead && invis && f) {
				invis=false;
				X=begX, Y=begY;
				dx=dy=0;
				Y1=Y-scY, Y2=Y, X1=X-scX/2, X2=X+scX/2;
			}
		}
		
		public override function remVisual() {
			if (vis && vis.parent) vis.parent.removeChild(vis);
			if (shad && shad.parent) shad.parent.removeChild(shad);
		}
		
		public override function setVisState(s:String) {
			if ((s=='open' || s=='comein') && sndOpen!='' && !World.w.testLoot) Snd.ps(sndOpen,X,Y);
			if (s=='close' && sndClose!='') Snd.ps(sndClose,X,Y);
			try {
				if (s=='comein') vis.gotoAndPlay(s);
				else vis.gotoAndStop(s);
			} catch (err) {
			}
		}
		
		public override function step() {
			if (dead && invis) {
				onCursor=0;
				return;
			}
			stX=X, stY=Y;
			if (inter) inter.step();
			if (radioactiv) {
				getRasst2()
				ggModum();
			}
			if (molnDam>0) {// && !inter.open
				moln_t++;
				if (moln_t>=molnPeriod) {
					moln_t=0;
					attMoln();
					try {
						vis.gotoAndPlay('moln');
					} catch(err) {};
				}
			}
			if (levit) {
				stay=fixPlav=false;
				osnova=null;
			}
			if (wall==0 && stay && osnova) {
				if (!osnova.stay || osnova.levit) {
					stay=false;
					osnova=null;
				}
				if (osnova &&  (osnova.cdx!=0 || osnova.cdy!=0)) {
					if (collisionAll(osnova.cdx,osnova.cdy)) {
						stay=false;
						osnova=null;
					} else {
						X+=osnova.cdx;
						Y+=osnova.cdy;
						X1=X-scX/2, X2=X+scX/2, Y1=Y-scY, Y2=Y;
						if (vis) runVis()
					}
				}
			}
			if (wall==0 && !(stay && dx==0) && !fixPlav) {
				if (wall==0) forces();		//внешние силы, влияющие на ускорение
				if (Math.abs(dx)<World.maxdelta && Math.abs(dy)<World.maxdelta)	run();
				else {
					var div=Math.floor(Math.max(Math.abs(dx),Math.abs(dy))/World.maxdelta)+1;
					for (var i=0; i<div; i++) run(div);
				}
				checkWater();
				if (!fixPlav && !levit && isPlav&&!isPlav2 && dy<2 && dy>-2 && ddyPlav<0) {
					dy=dx=0;
					fixPlav=true;
				}
				if (!levit && (dy>5 || dy<-5 || dx>5 || dx<-5)) attDrop();
				if (vis) runVis();
				if (inter) {inter.X=X; inter.Y=Y;}
			}
			cdx=X-stX, cdy=Y-stY;
			if (t_throw>0) t_throw--;
			//setVisual();
			onCursor=(X1<World.w.celX && X2>World.w.celX && Y1<World.w.celY && Y2>World.w.celY)?prior:0;
		}
		
		public function initDoor() {
			tiles=new Array();
			for (var i=Math.floor(X1/Tile.tileX+0.5); i<=Math.floor(X2/Tile.tileX-0.5); i++) {
				for (var j=Math.floor(Y1/Tile.tileY+0.5); j<=Math.floor(Y2/Tile.tileY-0.5); j++) {
					 var t:Tile=loc.getTile(i,j);
					 t.front='';
					 t.phis=phis;
					 t.opac=door_opac;
					 t.door=this;
					 t.mat=mat;
					 t.hp=hp;
					 t.thre=thre;
					 tiles.push(t);
				}
			}
		}
		public function setDoor(open:Boolean) {
			for (var i in tiles) {
				(tiles[i] as Tile).phis=(open?0:phis);
				(tiles[i] as Tile).opac=(open?0:door_opac);
			}
			setVisState(open?'open':'close');
			if (open) {
				loc.isRelight=true;
				loc.isRebuild=true;
			}
		}
		//удар закрывающейся дверью
		public function attDoor():Boolean {
			for each (var cel in loc.units) {
				if (cel==null || (cel as Unit).sost==4) continue;
				if (cel is fe.unit.UnitMWall) continue;
				if (cel is fe.unit.Mine && !(cel.X1>=X2 || cel.X2<=X1 || cel.Y1>=Y2 || cel.Y2<=Y1)) {
					cel.fixed=true;
					(cel as fe.unit.Mine).activate();
					continue;
				}
				if (!(cel.X1>=X2 || cel.X2<=X1 || cel.Y1>=Y2 || cel.Y2<=Y1)) {
					trace('Мешает:',cel.nazv);
					return true;
				}
				//cel.udarBox(this);
			}
			for each (cel in loc.objs) {
				if ((cel as Box).wall>0) continue;
				if (!(cel.X-cel.scX/2>=X2 || cel.X+cel.scX/2<=X1 || cel.Y-cel.scY>=Y2 || cel.Y<=Y1)) {
					return true;
				}
			}
			return false;
		}
		
		public function attMoln() {
			for each (var cel in loc.units) {
				if (cel==null || (cel as Unit).sost==4) continue;
				if (!(cel.X1>=X2 || cel.X2<=X1 || cel.Y1>=Y2 || cel.Y2<=Y1)) {
					cel.udarBox(this);
				}
			}
		}
		
		//проверка на попадание пули, наносится урон, если пуля попала, возвращает -1 если не попала
		public override function udarBullet(bul:Bullet, sposob:int=0):int {
			if (sposob==1) {
				if (!bulPlayer) return -1;
				damage(bul.destroy);
				return mat;
			}
			if (sposob==0 && bulChance>0) {
				//if (!bulTele) return -1;
				if (Math.random()<bulChance) {
					var sila=Math.random()*0.4+0.8;
					sila/=massa;
					if (sila>3) sila=3;
					dx+=bul.knockx*bul.otbros*sila;
					dy+=bul.knocky*bul.otbros*sila;
					World.w.gg.otbrosTele(bul.otbros*sila);
					return mat;
				}
			}
			return -1;
		}
		
		public function damage(dam:Number) {
			dam-=thre;
			if (dam>0) hp-=dam;
			if (hp<=0) die();
		}
		
		public override function die(sposob:int=0) {
			if (dead) return;
			if (inter && inter.prize) return;
			dead=true;
			if (door>0) {
				for (var i in tiles) {
					(tiles[i] as Tile).opac=0;
					(tiles[i] as Tile).phis=0;
					(tiles[i] as Tile).hp=0;
				}
				setVisState('die');
				if (inter) {
					if (inter.mine>0) {
						if (inter.fiascoRemine!=null) inter.fiascoRemine();
					}
					inter.off();
				}
				if (sposob>=0 && sposob<10) {
					var kus='iskr';
					if (mat==1) kus='metal';
					if (mat==2) kus='kusok';
					if (mat==3) kus='schep';
					if (mat==5) kus='steklo';
					if (mat==7) kus='pole';
					Emitter.emit(kus,loc,X,Y-scY/2,{kol:12,rx:scX, ry:scY});
					if (sndDie!='') Snd.ps(sndDie,X,Y);
				}
				if (noiseDie) loc.budilo(X,Y-scY/2,noiseDie);
				if (inter) inter.sign=0;
			} else if (un) {
				invis=true;
				un.disabled=true;
				un.sost=4;
				if (vis) remVisual();
			} else {
				if (inter && inter.cont) {
					inter.dieCont();
				}
				bulPlayer=false;
				bulChance*=0.25;
			}
			if (scrDie && sposob>=0) scrDie.start();
		}
		
		
		public function forces() {
			if (!levit) {
				if (!isPlav && dy<World.maxdy) dy+=World.ddy;
				if (isPlav && isPlav2) dy+=World.ddy*ddyPlav;
			}
			if (isPlav) {
				dy*=0.65; dx*=0.65;
			} else if (levit) {
				dy*=0.8; dx*=0.8;
			}
		}
		
		//удар от падения
		public function attDrop() {
			vel2=dx*dx+dy*dy;
			if (vel2<50) return;
			for each(var cel:Unit in loc.units) {
				if (cel==null || fracLevit>0 && cel.fraction==fracLevit) continue;
				if (cel.sost==4 || cel.neujaz>0 || cel.loc!=loc || cel.X1>X2 || cel.X2<X1 || cel.Y1>Y2 || cel.Y2<Y1) continue;
				if (t_throw>0) {
					cel.neujaz=12;
					continue;
				}
				cel.udarBox(this);
				isThrow=false;
				//if (cel.sost==4 || cel.X1>X2 || cel.X2<X1 || cel.Y1>Y2+dy || cel.Y2<Y2) continue;
				//if (dy>5 && cel.Y1>=Y2 && cel.Y1<Y2+dy || dx>5 && cel.X1>=X2 && cel.X1<X2+dx || dx<-5 && cel.X2<=X1 && cel.X2>X1+dx) cel.udarBox(this);
			}
		}
		
		public override function checkStay() {
			if (osnova || wall>0) return true;
			fixPlav=false;
			checkWater();
			if (isPlav&&!isPlav2 && dy<2 && dy>-2) {
				fixPlav=true;
			}
			for (var i=Math.floor(X1/Tile.tileX); i<=Math.floor(X2/Tile.tileX); i++) {
				var t=loc.space[i][Math.floor((Y2+1)/Tile.tileY)];
				if (collisionTile(t,0,1)) {
					return true;
				}
			}
			stay=false;
			return false;
		}
		
		public function run(div:int=1) {
			//движение
			var t:Tile;var i:int;
			
			
			//ГОРИЗОНТАЛЬ
				X+=dx/div;
				if (X-scX/2<0) {
					X=scX/2;
					dx=Math.abs(dx);
				}
				if (X+scX/2>=loc.spaceX*Tile.tileX) {
					X=loc.spaceX*Tile.tileX-1-scX/2;
					dx=-Math.abs(dx);
				}
				X1=X-scX/2, X2=X+scX/2;
				//движение влево
				if (dx<0) {
					for (i=Math.floor(Y1/Tile.tileY); i<=Math.floor(Y2/Tile.tileY); i++) {
						t=loc.space[Math.floor(X1/Tile.tileX)][i];
						if (collisionTile(t)) {
								X=t.phX2+scX/2;
								if (dx<-10) dx=-dx*0.2;
								else dx=0;
								X1=X-scX/2, X2=X+scX/2;
							isThrow=false;
						}
					}
				}
				//движение вправо
				if (dx>0) {
					for (i=Math.floor(Y1/Tile.tileY); i<=Math.floor(Y2/Tile.tileY); i++) {
						t=loc.space[Math.floor(X2/Tile.tileX)][i];
						if (collisionTile(t)) {
								X=t.phX1-scX/2;
								if (dx>10) dx=-dx*0.2;
								else dx=0;
								X1=X-scX/2, X2=X+scX/2;
							isThrow=false;
						}
					}
				}
			
			
			//ВЕРТИКАЛЬ
			//движение вниз
			var newmy:Number=0;
			if (dy>0) {
				stay=false;
				for (i=Math.floor(X1/Tile.tileX); i<=Math.floor(X2/Tile.tileX); i++) {
					t=loc.space[i][Math.floor((Y2+dy/div)/Tile.tileY)];
					if (collisionTile(t,0,dy/div)) {
						newmy=t.phY1;
						break;
					}
				}
				if (newmy==0 && !levit && !isThrow) newmy=checkShelf(dy/div);
				if (Y>=(loc.spaceY-1)*Tile.tileY && !loc.bezdna) newmy=(loc.spaceY-1)*Tile.tileY;
				if (Y>=loc.spaceY*Tile.tileY-1 && loc.bezdna) {
					invis=true;
					if (vis) remVisual();
				}
				if (newmy) {
					Y=newmy;
					Y1=Y-scY, Y2=Y;
					if (loc.active && dy>4 && dy*massa>5) World.w.quake(0,dy*Math.sqrt(massa)/2);
					if (dy>5 && sndFall && sndOn) Snd.ps(sndFall,X,Y,0,dy/15);
					if (dy>5) {
						loc.budilo(X,Y,dy*dy*massa);
					}
					if (dy<5 || massa>1) dy=0;
					else dy*=-0.2;
					if (dx>-5 && dx<5) dx=0;
					else {
						dx*=0.92;
						if (mat==1)	Emitter.emit('iskr_wall',loc,X+(Math.random()-0.5)*scX,Y);
					}
					if (!levit && (!isPlav || ddyPlav>0)) {
						stay=true;
						isThrow=false;
						fracLevit=0;
						//splund();
					}
					sndOn=true;
				} else {
					Y+=dy/div;
					Y1=Y-scY, Y2=Y;
				}
			}
			//движение вверх
			if (dy<0) {
				stay=false;
				Y+=dy/div;
				Y1=Y-scY, Y2=Y;
				if (Y-scY<0) Y=scY;
				for (i=Math.floor(X1/Tile.tileX); i<=Math.floor(X2/Tile.tileX); i++) {
					t=loc.space[i][Math.floor(Y1/Tile.tileY)];
					if (collisionTile(t)) {
						Y=t.phY2+scY;
						Y1=Y-scY, Y2=Y;
						dy=0;
						isThrow=false;
					}
				}
			}
		}
		//поиск жидкости
		public function checkWater():Boolean {
			var pla=isPlav;
			isPlav=isPlav2=false;
			try {
				if ((loc.space[Math.floor(X/Tile.tileX)][Math.floor((Y-scY*0.45)/Tile.tileY)] as Tile).water>0) {
					isPlav=true;
				}
				if ((loc.space[Math.floor(X/Tile.tileX)][Math.floor((Y-scY*0.55)/Tile.tileY)] as Tile).water>0) {
					isPlav2=true;
				}
			} catch (err) {
				
			}
			if (pla!=isPlav && (dy>8 || dy<-8)) Emitter.emit('kap',loc,X,Y-scY*0.25+dy,{dy:-Math.abs(dy)*(Math.random()*0.3+0.3), kol:Math.floor(Math.abs(dy*massa*2)-5)});
			if (pla!=isPlav && dy>5) {
				if (massa>2) sound('fall_water0', 0, dy/10);
				else if (massa>0.4) sound('fall_water1', 0, dy/10);
				else if (massa>0.2) sound('fall_water2', 0, dy/10);
				else sound('fall_item_water', 0, dy/10);
			}
			return isPlav;
		}
		public function checkShelf(dy):Number {
			for (var i in loc.objs) {
				var b:Box=loc.objs[i] as Box;
				if (!b.invis && b.stay && b.shelf && !(X<b.X1 || X>b.X2) && Y2<=b.Y1 && Y2+dy>b.Y1) {
					osnova=b;
					return b.Y1;
				}
			}
			return 0;
		}
		public function collisionAll(gx:Number=0, gy:Number=0):Boolean {
			for (var i=Math.floor((X1+gx)/Tile.tileX); i<=Math.floor((X2+gx)/Tile.tileX); i++) {
				for (var j=Math.floor((Y1+gy)/Tile.tileY); j<=Math.floor((Y2+gy)/Tile.tileY); j++) {
					if (collisionTile(loc.space[i][j],gx,gy)) return true;
				}
			}
			return false;
		}
		/*function splund() { //ищбавится от бага отображения
			if (vis && World.w.gg) {
				vis.transform.colorTransform.concat(Obj.nullTransfom);// =World.w.gg.shineTransform;
				//vis.transform.colorTransform=cTransform;
			}
		}*/
		
		public function bindUnit(n:String='-1') {
			un=new VirtualUnit(n);
			copy(un);
			un.owner=this;
			un.loc=loc;
		}
		
		//принудительное движение
		public override function bindMove(nx:Number, ny:Number, ox:Number=-1, oy:Number=-1) {
			super.bindMove(nx,ny);
			if (this.un) un.bindMove(nx,ny);
			if (vis) runVis()
		}
		
		public function runVis() {
			vis.x=shad.x=X,vis.y=Y,shad.y=Y+(wall?2:6);
		}
		
		public function sound(sid:String, msec:Number=0, vol:Number=1):* {
			return Snd.ps(sid,X,Y,msec,vol);
		}
		
		public function collisionTile(t:Tile, gx:Number=0, gy:Number=0):int {
			if (!t || (t.phis==0 || t.phis==3) && !t.shelf) return 0;  //пусто
			if (X2+gx<=t.phX1 || X1+gx>=t.phX2 || Y2+gy<=t.phY1 || Y1+gy>=t.phY2) {
				return 0;
			} else if ((t.phis==0 || t.phis==3) && t.shelf && (Y2>t.phY1 || levit || isThrow)) {  //полка 
				return 0;
			} else return 1;
		}
		
		//особые функции
		
		function initFun(fun:String) {
			if (fun=='generator') {
				if (inter==null) inter=new Interact(this);
				inter.action=100;
				inter.active=true;
				inter.cont=null;
				inter.knop=1;
				inter.t_action=45;
				inter.needSkill='repair';
				inter.needSkillLvl=4;
				inter.userAction='repair'; 
				inter.actFun=funGenerator;
				inter.update();
			}
		}
		
		public function funGenerator() {
			//inter.setAct('open',1);
			//setVisState('open');
			//trace(inter.scrOpen);
			inter.active=false;
			World.w.gui.infoText('unFixLock');
			World.w.game.runScript('fixGenerator',this);
		}

	}
	
}

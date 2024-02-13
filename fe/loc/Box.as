package fe.loc
{
	import flash.filters.DropShadowFilter;
	import flash.display.MovieClip;

	import fe.*;
	import fe.entities.Obj;
	import fe.serv.Interact;
	import fe.graph.Emitter;
	import fe.graph.Grafon;
	import fe.serv.Script;
	import fe.projectile.Bullet;

	import fe.unit.Unit;
	import fe.unit.VirtualUnit;
	import fe.unit.Mine;
	import fe.unit.unitTypes.UnitMWall;

	public class Box extends Obj
	{
		public var osnova:Box=null;		//на чём стоит
		public var shelf:Boolean=true;	//на этом можно стоять
		public var isPlav:Boolean=false, isPlav2:Boolean=false, fixPlav:Boolean=false;
		public var id:String;
		public var door:int = 0;
		public var begX:Number=-1, begY:Number=-1; 		//исходная точка
		public var stX:Number=0, stY:Number=0;	//положение на начало такта
		public var cdx:Number=0, cdy:Number=0;	//движение того, кто стоит на ящике	
		public var vel2:Number=0; //скорость в квадрате
		
		public var mat:int=0;		//материал	//0 - хз что //1 - металл //2 - камень //3 - дерево
		public var wall:int=0;		//крепится на стену
		public var phis:int=1;
		public var sur:int=0;		//предме на ящике
		public var hp:Number=100;
		public var thre:Number=0;
		public var montdam:int=5;		//насколько будет ломаться монтировка
		public var electroDam:Number=0;	//если больше 0 - является генератором электрозащиты
		public var tiles:Array;			//задействованные блоки
		public var dead:Boolean	= false;
		public var invis:Boolean = false;
		public var light:Boolean = false;	//убрать туман войны в этой точке
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
		
		private static var cachedObjs:Object = {}; // Save all objects that have been used before to avoid parsing XML for lots of objects.
		
		private static var tileX:int = Tile.tileX;
		private static var tileY:int = Tile.tileY;

		public function Box(nloc:Location, nid:String, nx:int=0, ny:int=0, xml:XML=null, loadObj:Object=null)
		{
			loc=nloc;
			id=nid;
			if (loc.land.kolAll)
			{
				if (loc.land.kolAll[id]>0) loc.land.kolAll[id]++;
				else loc.land.kolAll[id]=1;
			}
			prior=1;
			vis=World.w.grafon.getObj('vis'+id, Grafon.numbObj);
			shad=World.w.grafon.getObj('vis'+id, Grafon.numbObj);
			if (vis == null)
			{
				vis  = new visbox0();
				shad = new visbox0();
			}
			vis.stop();
			shad.gotoAndStop(vis.currentFrame);
			shad.filters = [dsf];
			
			var node:XML = getObjInfo(id);
			
			coordinates.X = begX = nx; 
			coordinates.Y = begY = ny;
			objectWidth = vis.width;
			objectHeight = vis.height;
			if (node.@scx.length()) objectWidth = node.@scx;
			if (node.@scy.length()) objectHeight = node.@scy;
			leftBound = coordinates.X - objectWidth / 2;
			rightBound = coordinates.X + objectWidth / 2;
			topBound = coordinates.Y - objectHeight;
			bottomBound = coordinates.Y;
			
			
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
			if (objectWidth<40 || wall>0) shelf=false;
			if (node.@shelf.length()) shelf=true;
			if (node.@massaMult.length()) massaMult=node.@massaMult;
			massa=objectWidth*objectHeight*objectHeight/250000*massaMult;
			if (node.@massa.length()) massa=node.@massa/50;
			
			if (xml && xml.@indestruct.length())
			{
				hp=10000;
				thre=10000;
			}

			//Door
			if (node.@door.length())
			{
				door = node.@door;
				if (node.@opac.length()) door_opac = node.@opac;
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
			vis.x = shad.x = coordinates.X;
			vis.y = coordinates.Y;
			shad.y = coordinates.Y + (wall?2:6);
			prior +=1 / (objectWidth * objectHeight);
			if (node.@actdam.length()) {
				if (xml && xml.@tipdam.length())  bindUnit(xml.@tipdam);
				else bindUnit();
			}
			if (xml && xml.@pokr.length()) {
				sloy=1;
				prior=3;
			}
			
			if (loadObj && loadObj.dead) die(-1);		//если объект был уничтожен
			

			function getObjInfo(id:String):XML
			{
				// Check if the node is already cached
				var node:XML;
				if (cachedObjs[id] != undefined) node = cachedObjs[id];
				else
				{
					node = XMLDataGrabber.getNodeWithAttributeThatMatches("core", "AllData", "objs", "id", id);
					cachedObjs[id] = node;
				}
				return node;
			}
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
		public override function setNull(f:Boolean=false)
		{
			super.setNull(f);
			if (!dead && invis && f)
			{
				invis = false;
				coordinates.X = begX;
				coordinates.Y = begY;
				dx = 0;
				dy = 0;
				topBound = coordinates.Y - objectHeight;
				bottomBound = coordinates.Y;
				leftBound = coordinates.X - objectWidth / 2;
				rightBound = coordinates.X + objectWidth / 2;
			}
		}
		
		public override function remVisual() {
			if (vis && vis.parent) vis.parent.removeChild(vis);
			if (shad && shad.parent) shad.parent.removeChild(shad);
		}
		
		public override function setVisState(s:String) {
			if ((s=='open' || s=='comein') && sndOpen!='' && !World.w.testLoot) Snd.ps(sndOpen, coordinates.X, coordinates.Y);
			if (s=='close' && sndClose!='') Snd.ps(sndClose, coordinates.X, coordinates.Y);
			try
			{
				if (s=='comein') vis.gotoAndPlay(s);
				else vis.gotoAndStop(s);
			}
			catch (err)
			{
				trace('ERROR: (00:2B) - Could not set vis state: "' + s + '"!');
			}
		}
		
		public override function step():void
		{
			if (dead && invis) {
				onCursor=0;
				return;
			}
			stX = coordinates.X;
			stY = coordinates.Y;
			if (inter) inter.step();
			if (radioactiv) {
				getRasst2()
				ggModum();
			}
			if (molnDam>0) {
				moln_t++;
				if (moln_t>=molnPeriod) {
					moln_t=0;
					attMoln();
					vis.gotoAndPlay('moln');
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
					}
					else
					{
						coordinates.X += osnova.cdx;
						coordinates.Y += osnova.cdy;
						leftBound = coordinates.X - objectWidth / 2;
						rightBound = coordinates.X + objectWidth / 2;
						topBound = coordinates.Y - objectHeight;
						bottomBound = coordinates.Y;
						if (vis) runVis()
					}
				}
			}
			if (wall==0 && !(stay && dx==0) && !fixPlav) {
				if (wall==0) forces();		//внешние силы, влияющие на ускорение
				if (Math.abs(dx)<World.maxdelta && Math.abs(dy)<World.maxdelta)	run();
				else {
					var div = int(Math.max(Math.abs(dx),Math.abs(dy))/World.maxdelta)+1;
					for (var i = 0; i < div; i++) run(div);
				}
				checkWater();
				if (!fixPlav && !levit && isPlav&&!isPlav2 && dy<2 && dy>-2 && ddyPlav<0) {
					dy = 0;
					dx = 0;
					fixPlav=true;
				}
				if (!levit && (dy>5 || dy<-5 || dx>5 || dx<-5)) attDrop();
				if (vis) runVis();
				if (inter) {inter.coordinates.X = coordinates.X; inter.coordinates.Y = coordinates.Y;}
			}
			cdx = coordinates.X - stX;
			cdy = coordinates.Y - stY;
			if (t_throw>0) t_throw--;
			onCursor=(leftBound<World.w.celX && rightBound>World.w.celX && topBound<World.w.celY && bottomBound>World.w.celY)?prior:0;
		}
		
		public function initDoor()
		{
			tiles = [];
			for (var i:int = int(leftBound / tileX + 0.5); i <= int(rightBound / tileX - 0.5); i++)
			{
				for (var j:int = int(topBound / tileY + 0.5); j <= int(bottomBound / tileY - 0.5); j++)
				{
					var t:Tile = loc.getTile(i, j);
					t.front = '';
					t.phis = phis;
					t.opac = door_opac;
					t.door = this;
					t.mat = mat;
					t.hp = hp;
					t.thre = thre;
					tiles.push(t);
				}
			}
		}

		// This is for opening and closing doors inside of rooms, NOT for traveling to new rooms.
		public function setDoor(state:Boolean)
		{
			for (var i in tiles)
			{
				(tiles[i] as Tile).phis = (state? 0:phis);
				(tiles[i] as Tile).opac = (state? 0:door_opac);
			}

			setVisState(state? 'open':'close');
			
			if (state && World.w.loc)
			{
				World.w.loc.isRelight = true;
				World.w.loc.isRebuild = true;
			}
		}

		// Check if doorway is clear
		public function attDoor():Boolean
		{
			for each (var cel in loc.units)
			{
				if (cel == null || (cel as Unit).sost == 4) continue;
				if (cel is UnitMWall) continue;
				if (cel is Mine && !(cel.leftBound >= rightBound || cel.rightBound <= leftBound || cel.topBound >= bottomBound || cel.bottomBound <= topBound))
				{
					cel.fixed = true;
					trace('Mine activated by door!');
					(cel as Mine).activate();
					continue;
				}
				if (!(cel.leftBound >= rightBound || cel.rightBound <= leftBound || cel.topBound >= bottomBound || cel.bottomBound <= topBound))
				{
					trace('Door blocked by unit!');
					return true;
				}
			}
			for each (cel in loc.objs)
			{
				if ((cel as Box).wall > 0) continue;
				if (!(cel.coordinates.X - cel.objectWidth / 2 >= rightBound || cel.coordinates.X + cel.objectWidth / 2 <= leftBound || cel.coordinates.Y - cel.objectHeight >= bottomBound || cel.coordinates.Y <= topBound))
				{
					trace('Door blocked by box!');
					return true;
				}
			}
			return false;
		}
		
		public function attMoln()
		{
			for each (var cel in loc.units)
			{
				if (cel == null || (cel as Unit).sost == 4) continue;
				if (!(cel.leftBound >= rightBound || cel.rightBound <= leftBound || cel.topBound >= bottomBound || cel.bottomBound <= topBound))
				{
					cel.udarBox(this);
				}
			}
		}
		
		//проверка на попадание пули, наносится урон, если пуля попала, возвращает -1 если не попала
		public override function udarBullet(bul:Bullet, sposob:int=0):int {
			if (sposob==1)
			{
				if (!bulPlayer) return -1;
				damage(bul.destroy);
				return mat;
			}
			if (sposob == 0 && bulChance > 0)
			{
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
						if (inter.fiascoRemine != null) inter.fiascoRemine();
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
					Emitter.emit(kus, loc, coordinates.X, coordinates.Y-objectHeight/2, {kol:12,rx:objectWidth, ry:objectHeight});
					if (sndDie!='') Snd.ps(sndDie, coordinates.X, coordinates.Y);
				}
				if (noiseDie) loc.budilo(coordinates.X, coordinates.Y - objectHeight / 2, noiseDie);
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
			if (isPlav)
			{
				dy *= 0.65;
				dx *= 0.65;
			}
			else if (levit) {
				dy *= 0.8; 
				dx *= 0.8;
			}
		}
		
		//удар от падения
		public function attDrop() {
			vel2=dx*dx+dy*dy;
			if (vel2<50) return;
			for each(var cel:Unit in loc.units) {
				if (cel==null || fracLevit>0 && cel.fraction==fracLevit) continue;
				if (cel.sost==4 || cel.neujaz>0 || cel.loc!=loc || cel.leftBound>rightBound || cel.rightBound<leftBound || cel.topBound>bottomBound || cel.bottomBound<topBound) continue;
				if (t_throw>0) {
					cel.neujaz=12;
					continue;
				}
				cel.udarBox(this);
				isThrow=false;
			}
		}
		
		public override function checkStay() {
			if (osnova || wall>0) return true;
			fixPlav=false;
			checkWater();
			if (isPlav&&!isPlav2 && dy<2 && dy>-2) {
				fixPlav=true;
			}
			for (var i=int(leftBound/tileX); i<=int(rightBound/tileX); i++)
			{
				var t=loc.space[i][int((bottomBound+1)/tileY)];
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
			
			
			//HORIZONTAL
				coordinates.X += dx / div;
				if (coordinates.X - objectWidth / 2 < 0)
				{
					coordinates.X = objectWidth / 2;
					dx=Math.abs(dx);
				}
				if (coordinates.X + objectWidth / 2 >= loc.spaceX * tileX)
				{
					coordinates.X = loc.spaceX * tileX - 1 - objectWidth / 2;
					dx = -Math.abs(dx);
				}
				leftBound = coordinates.X - objectWidth / 2;
				rightBound = coordinates.X + objectWidth / 2;
				//движение влево
				if (dx<0)
				{
					for (i=int(topBound/tileY); i<=int(bottomBound/tileY); i++)
					{
						t = loc.space[int(leftBound / tileX)][i];
						if (collisionTile(t))
						{
								coordinates.X = t.phX2 + objectWidth / 2;
								if (dx<-10) dx=-dx*0.2;
								else dx=0;
								leftBound = coordinates.X - objectWidth / 2;
								rightBound = coordinates.X + objectWidth / 2;
							isThrow=false;
						}
					}
				}
				//движение вправо
				if (dx>0) {
					for (i=int(topBound/tileY); i<=int(bottomBound/tileY); i++) {
						t=loc.space[int(rightBound/tileX)][i];
						if (collisionTile(t)) {
								coordinates.X = t.phX1 - objectWidth / 2;
								if (dx>10) dx=-dx*0.2;
								else dx=0;
								leftBound = coordinates.X - objectWidth / 2;
								rightBound = coordinates.X + objectWidth / 2;
							isThrow=false;
						}
					}
				}
			
			
			//VERTICAL
			//движение вниз
			var newmy:Number=0;
			if (dy>0)
			{
				stay=false;
				for (i = int(leftBound / tileX); i <= int(rightBound / tileX); i++) {
					t = loc.space[i][int((bottomBound + dy / div) / tileY)];
					if (collisionTile(t,0,dy/div))
					{
						newmy = t.phY1;
						break;
					}
				}
				if (newmy == 0 && !levit && !isThrow) newmy = checkShelf(dy / div);
				if (coordinates.Y >= (loc.spaceY - 1) * tileY && !loc.bezdna) newmy = (loc.spaceY - 1) * tileY;
				if (coordinates.Y >= loc.spaceY * tileY - 1 && loc.bezdna)
				{
					invis = true;
					if (vis) remVisual();
				}
				if (newmy)
				{
					coordinates.Y = newmy;
					topBound = coordinates.Y - objectHeight;
					bottomBound = coordinates.Y;
					if (loc.active && dy>4 && dy*massa>5) World.w.quake(0,dy*Math.sqrt(massa)/2);
					if (dy > 5 && sndFall && sndOn) Snd.ps(sndFall, coordinates.X, coordinates.Y, 0, dy / 15);
					if (dy > 5)
					{
						loc.budilo(coordinates.X, coordinates.Y, dy * dy * massa);
					}

					if (dy<5 || massa>1) dy=0;
					else dy*=-0.2;

					if (dx>-5 && dx<5) dx=0;
					else
					{
						dx*=0.92;
						if (mat==1)	Emitter.emit('iskr_wall', loc, coordinates.X + (Math.random()-0.5)*objectWidth, coordinates.Y);
					}

					if (!levit && (!isPlav || ddyPlav>0)) {
						stay=true;
						isThrow=false;
						fracLevit=0;
					}

					sndOn=true;
				}
				else
				{
					coordinates.Y += dy / div;
					topBound = coordinates.Y - objectHeight;
					bottomBound = coordinates.Y;
				}
			}
			//движение вверх
			if (dy<0)
			{
				stay = false;
				coordinates.Y += dy / div;
				topBound = coordinates.Y-objectHeight;
				bottomBound = coordinates.Y;
				if (coordinates.Y - objectHeight < 0) coordinates.Y = objectHeight;
				for (i = int(leftBound/tileX); i <= int(rightBound/tileX); i++)
				{
					t = loc.space[i][int(topBound/tileY)];
					if (collisionTile(t))
					{
						coordinates.Y = t.phY2 + objectHeight;
						topBound = coordinates.Y - objectHeight;
						bottomBound = coordinates.Y;
						dy = 0;
						isThrow=false;
					}
				}
			}
		}
		//поиск жидкости
		public function checkWater():Boolean
		{
			var pla = isPlav;
			isPlav = false;
			isPlav2 = false;

			if ((loc.space[int(coordinates.X/tileX)][int((coordinates.Y-objectHeight*0.45) / tileY)] as Tile).water > 0)
			{
				isPlav=true;
			}
			if ((loc.space[int(coordinates.X/tileX)][int((coordinates.Y-objectHeight*0.55) / tileY)] as Tile).water > 0)
			{
				isPlav2=true;
			}


			if (pla!=isPlav && (dy>8 || dy<-8)) Emitter.emit('kap', loc, coordinates.X, coordinates.Y-objectHeight*0.25+dy, {dy:-Math.abs(dy)*(Math.random()*0.3+0.3), kol:Math.floor(Math.abs(dy*massa*2)-5)});
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
				if (!b.invis && b.stay && b.shelf && !(coordinates.X<b.leftBound || coordinates.X > b.rightBound) && bottomBound<=b.topBound && bottomBound+dy>b.topBound)
				{
					osnova = b;
					return b.topBound;
				}
			}
			return 0;
		}

		public function collisionAll(gx:Number=0, gy:Number=0):Boolean
		{
			for (var i:int = int((leftBound + gx) / tileX); i <= int((rightBound + gx) / tileX); i++)
			{
				for (var j:int = int((topBound + gy) / tileY); j <= int((bottomBound + gy) / tileY); j++)
				{
					if (collisionTile(loc.space[i][j], gx, gy)) return true;
				}
			}
			return false;
		}
		
		public function bindUnit(n:String='-1')
		{
			un = new VirtualUnit(n);
			copy(un);
			un.owner = this;
			un.loc = loc;
		}
		
		//принудительное движение
		public override function bindMove(nx:Number, ny:Number, ox:Number=-1, oy:Number=-1)
		{
			super.bindMove(nx,ny);
			if (this.un) un.bindMove(nx,ny);
			if (vis) runVis()
		}
		
		public function runVis() {
			vis.x = shad.x = coordinates.X;
			vis.y = coordinates.Y;
			shad.y = coordinates.Y + (wall? 2:6);
		}
		
		public function sound(sid:String, msec:Number=0, vol:Number=1):*
		{
			return Snd.ps(sid, coordinates.X, coordinates.Y, msec, vol);
		}
		
		public function collisionTile(t:Tile, gx:Number=0, gy:Number=0):int
		{
			if (!t || (t.phis==0 || t.phis==3) && !t.shelf) return 0;  //пусто
			if (rightBound + gx <= t.phX1 || leftBound + gx >= t.phX2 || bottomBound + gy <= t.phY1 || topBound + gy>=t.phY2)
			{
				return 0;
			}
			else if ((t.phis==0 || t.phis==3) && t.shelf && (bottomBound>t.phY1 || levit || isThrow)) {  //полка 
				return 0;
			}
			else return 1;
		}
		
		//особые функции
		private function initFun(fun:String):void
		{
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
		
		private function funGenerator():void
		{
			inter.active=false;
			World.w.gui.infoText('unFixLock');
			World.w.game.runScript('fixGenerator',this);
		}
	}
}
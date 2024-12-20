package fe.loc {

	import flash.geom.ColorTransform;
	import flash.display.MovieClip;
	import flash.display.BitmapData;


	import fe.*;
	import fe.util.Vector2;
	import fe.graph.*;
	import fe.entities.Entity;
	import fe.entities.Obj;
	import fe.projectile.Bullet;
	import fe.unit.Unit;
	import fe.unit.UnitPlayer;
	import fe.unit.UnitPhoenix;
	import fe.unit.UnitTransmitter;
	import fe.serv.LootGen;
	import fe.serv.Item;
	import fe.unit.UnitTurret;
	
	public class Location {

		public var land:Land;
		
		public var id:String;
		public var room:Room;		//связанный шаблон
		public var prob:Probation;	//связанное испытание
		
		//рамеры и положение
		public var spaceX:int;	//размер локации в блоках
		public var spaceY:int;
		public var landX:int=0;	//положение локации на местности
		public var landY:int=0;
		public var landZ:int=0;
		public var landProb:String='';
		public var bindLoc:Location;	//привязанная по координате z
		public var base:Boolean = false;	//базовый лагерь
		public var train:Boolean = false;	//полигон
		
		//объекты
		public var grafon:Grafon;
		public var space:Vector.<Tile>;	//пространство блоков | One dimensional array of area tiles. instead of a nested [X][Y], indices are [tileXIndex * spaceY + tileYIndex;]
		public var defaultTile:Tile;			//пустой блок
		public var units:Array;			//юниты
		public var ups:Array;			//спавн случайных юнитов
		public var objs:Array;			//боксы
		public var bonuses:Array;		//бонусы
		public var areas:Array;			//области
		public var acts:Array;			//активные объекты (отображаемые на карте)
		public var saves:Array;			//объекты, подлежащие сохранению
		public var backobjs:Array;		//фоновые объекты
		public var grenades:Array;		//активные гранаты
		public var gg:UnitPlayer;
		public var celObj:Obj, celDist:Number=-1;	//целевой объект и расстояние до него
		public var unitCoord;			//объект для координации юнитов
		
		//входы и посещение
		public var spawnPoints:Array;	//точки спавна
		public var enspawn:Array;		//точки спавна врагов
		public var doors:Array;			//проходы в другие локации
		public var signposts:Array, sign_vis:Boolean=true;		//указатели выхода
		public var nAct:int=0;			//последнее посещение
		public var active:Boolean=false;		//активна в данный момент
		public var visited:Boolean=false;		//посещена
		
		//служебные
		public var cp:CheckPoint;
		public var pass_r:Array, pass_d:Array;		//проходы в другие локации
		public var objsT:Array;				//активные объекты
		public var recalcTiles:Array;		//пересчитать воду

		//цепочка выполнения
		public var firstObj:Entity;
		public var nextObj:Entity;
		public var lastObj:Entity;
		
		public var isRebuild:Boolean=false, isRecalc:Boolean=false, isRelight:Boolean=false, relight_t:int;
		public var warning:int=0;			//имеются опасности типа брошенных гранат
		public var t_gwall:int=0;	//имеются призрачные стены
		public var lDist1:int=300, lDist2:int=1000;	//дистанция открывания тумана войны
		public var quake:int=0;
		public var broom:Boolean=false;		//весь лут поднимется автоматически
		public var isCheck:Boolean=false;	//была создана контрольная точка, точка выхода или дверь испытаний
		
		//опции
		public var noHolesPlace:Boolean=true;	//убирать контейнеры около проходов
		public var ramka:int=0;					//рамка из блоков по периметру 1-весь периметр, 2-только бока, 3-только низ, 4-низ и бока
		public var bezdna:Boolean=false;		//выход вниз при падении
		public var mirror:Boolean=false;		//зеркальная комната
		public var endLand:Boolean=false;		//комната на последнем уровне локации
		public var sky:Boolean=false;
		public var zoom:Number=1;
		
		//настройки
		public var gas:int=0;					//особая текстура
		public var maxdy:Number=20;
		public var rad:Number=0, wrad:Number=1;	//радиоактивность воздуха и воды
		public var wdam:Number=0, wtipdam:int=7;	//урон от воды
		public var tipWater:int=0;				//внешний вид воды
		public var opacWater:Number=0;			//непрозрачность воды
		public var waterLevel:int=100;			//уровень воды
		public var backwall:String='';			//фон задней стены
		public var backform:int=0;				//форма фона задней стены 0-закрашено всё, 1-боковые части, 2-нижняя часть
		public var transpFon:Boolean=false;		//задний фон имеет прозрачность
		public var cTransform:ColorTransform;
		public var cTransformFon:ColorTransform;
		public var color:String;
		public var colorfon:String;
		public var sndMusic:String='music_0';
		public var postMusic:Boolean=false;		//музыка не пеключается на боевую
		public var homeStable:Boolean=false;	
		public var homeAtk:Boolean=false;	
		public var visMult:Number=1;
		public var noMap:Boolean=false;			//карта недоступна
		public var darkness:int = 0;			// Background darkening
		public var lightOn:int = 0;				// More than 0, light is on, 0 or less is off

		// Fog of war
		public var black:Boolean	= true;								//	Fog of war is enabled	(Default: True)
		public var retDark:Boolean	= Settings.settings.fogRegenerates;	//	Fog of war returns		(Default: False)
		
		public var levitOn:Boolean=true;		//самолевитация разрешена
		public var portOn:Boolean=true;			//телепортация разрешена
		public var petOn:Boolean=true;			//спутник разрешен
		public var destroyOn:Boolean=true;		//разрушение стены разрешены
		public var itemsTip:String;				//особый тип лута
		public var electroDam:Number=0;
		public var trus:Number=0;				//постоянная тряска
		
		//враги
		public var tipEnemy:int=-1;				//тип случайных врагов
		public var kolEn:Array=[0,6,4,6,4,6]; //количество случайных мелких врагов: 0, мелкий ползучий, обычный, летучий, потолочный, ловушка
		private var tipEn:Array = ['','enl1','enl2','enf1','enc1','lov'];
		public var tipSpawn:String='enl2';
		public var kolEnSpawn:int=0;		//может заспавнится обычных врагов
		public var tileSpawn:Number=0;		//спавн при разрушении блоков
		public var kolEnHid:int=3;			//скрытых обычных врагов
		public var kol_phoenix:int=0;
		
		public var detecting:Boolean=false;
		public var t_alarm:int=0;			//счётчик сигнализации
		public var t_alarmsp:int=0;			//счётчик спавна врагов
		
		//бонусы и опыт
		public var kolXp:int=0, maxXp:int=0;
		public var unXp:int=100;
		public var summXp:int=0;
		
		//Уровень сложности
		public var locDifLevel:Number=0;
		public var biom:int=0;
		public var locksLevel:Number=0;		//уровень замков 0-25
		public var mechLevel:Number=0;		//уровень мин и механизмов 0-7
		public var weaponLevel:Number=0;	//уровень случайно выпадающего оружия
		public var enemyLevel:int=0;		//левел мобов
		public var earMult:Number=1; 		//множитель слуха мобов
		
		// Cached tile size in pixels
		private static var tileX:int = Tile.tileX;
		private static var tileY:int = Tile.tileY;

		// Precomputed for inverse multiplication instead of division 
		private static const INV_TILEX:Number = 1 / 40; // 0.025
		private static const INV_TILEY:Number = 1 / 40; // 0.025

		public var maxX:int;
    	public var maxY:int;
		private var halfSpaceX = spaceX / 2;
		private var halfSpaceY = spaceY /2;

//**************************************************************************************************************************
//
//				Создание
//
//**************************************************************************************************************************


// ------------------------------------------------------------------------------------------------
// первый этап - создать и построить по карте из xml

		// Constructor
		public function Location(land:Land, room:XML, rnd:Boolean, opt:Object=null) {
			this.land = land;
			
			spaceX = World.cellsX;	// Room width in tiles
			spaceY = World.cellsY;	// Room height in tiles

			// GetAbsTile uses thse values CONSTANTLY, calculating beforehand. 
			maxX = spaceX * tileX;	// Screen width in pixels
			maxY = spaceY * tileY;	// Screen height in pixels

			defaultTile = new Tile(-1, -1);

			initializeArrays();
			maxdy = World.maxdy;

			if (rnd) ramka = 1;
			if (opt) {
				if (opt.prob) ramka=0;
				if (opt.mirror) mirror=true;
				if (opt.water!=null) waterLevel=opt.water;
				if (opt.ramka!=null) ramka=opt.ramka;
				if (ramka==5) backform=1;
				if (ramka==6) backform=2;
				if (opt.backform) backform=opt.backform;
				if (opt.transpFon) transpFon=opt.transpFon;
				if (opt.home) homeStable=true;
				if (opt.atk) homeAtk=true;
			}

			for (var i:int = 0; i < kolEn.length; i++) {
				ups[i] = [];
			}

			noHolesPlace = rnd;
			
			buildLoc(room);
		}

		private function initializeArrays():void {
			units		= [];
			ups			= [];
			objs		= [];
			acts		= [];
			areas		= [];
			saves		= [];
			enspawn		= [];
			backobjs	= [];
			signposts	= [];
			recalcTiles = [];
			spawnPoints	= [];
			grenades	= [];
			bonuses		= [];
		}

		// добавить гг в массив юнитов
		public function addPlayer(un:UnitPlayer):void {
			gg = un;
			units.push(un);
			units.push(un.defpet);
		}
		
		//построить по карте xml
		public function buildLoc(nroom:XML):void {
			//создать массив блоков
			// Initialize space as a single-dimensional Vector
			initializeSpace();
			
			//опции
			backwall=land.act.backwall;
			sndMusic=land.act.sndMusic;
			postMusic=land.act.postMusic;
			rad=land.act.rad;
			wrad=land.act.wrad;
			wdam=land.act.wdam;
			wtipdam=land.act.wtipdam;
			tipWater=land.act.tipWater;
			color=land.act.color;
			visMult=land.act.visMult;
			opacWater=land.act.opacWater;
			darkness=land.act.darkness;
			if (nroom.options.length()) {
				if (nroom.options.@backwall.length()) backwall=nroom.options.@backwall;
				if (nroom.options.@backform.length()) backform=nroom.options.@backform;
				if (nroom.options.@transpfon.length()) transpFon=true;
				if (nroom.options.@music.length()) sndMusic=nroom.options.@music;
				if (nroom.options.@rad.length()) rad=nroom.options.@rad;
				if (nroom.options.@wrad.length()) wrad=nroom.options.@wrad;
				if (nroom.options.@wtip.length()) tipWater=nroom.options.@wtip;
				if (nroom.options.@wopac.length()) opacWater=nroom.options.@wopac;
				if (nroom.options.@wdam.length()) wdam=nroom.options.@wdam;
				if (nroom.options.@wtipdam.length()) wtipdam=nroom.options.@wtipdam;
				if (nroom.options.@bezdna.length()) bezdna=true;
				if (nroom.options.@wlevel.length()) waterLevel=nroom.options.@wlevel;
				if (nroom.options.@base.length()) base=true;
				if (nroom.options.@noblack.length() && !Settings.alwaysFogOfWar) black = false;
				if (nroom.options.@train.length()) train=true;
				if (nroom.options.@color.length()) color=nroom.options.@color;
				if (nroom.options.@colorfon.length()) colorfon=nroom.options.@colorfon;
				if (nroom.options.@vis.length()) visMult=nroom.options.@vis;
				if (nroom.options.@nomap.length()) noMap=true;
				if (nroom.options.@entip.length()) tipEnemy=nroom.options.@entip;
				if (nroom.options.@lon.length()) lightOn=nroom.options.@lon;
				if (nroom.options.@dark.length()) darkness=nroom.options.@dark;
				if (nroom.options.@retdark.length()) retDark=true;
				if (nroom.options.@levitoff.length()) levitOn=false;
				if (nroom.options.@portoff.length()) portOn=false;
				if (nroom.options.@desoff.length()) destroyOn=false;
				if (nroom.options.@petoff.length()) petOn=false;
				if (nroom.options.@spawn.length()) tipSpawn=nroom.options.@spawn;
				if (nroom.options.@kolspawn.length()) kolEnSpawn=nroom.options.@kolspawn;
				if (nroom.options.@tilespawn.length()) tileSpawn=nroom.options.@tilespawn;
				if (nroom.options.@items.length()) itemsTip=nroom.options.@items;
				if (nroom.options.@maxdy.length()) maxdy=nroom.options.@maxdy;
				if (nroom.options.@sky.length()) sky=true;
				if (nroom.options.@zoom.length()) zoom=nroom.options.@zoom;
				if (nroom.options.@trus.length()) trus=nroom.options.@trus;
				if (!black) {
					for (var i:int = 0; i < spaceX; i++) {
						for (var j:int = 0; j<spaceY; j++) {
							getTile(i, j).visi = 1;
						}
					}
				}
			}
			if (homeStable) {
				color = 'yellow';
				lightOn = 1;
				base = true;
			}
			if (homeAtk) {
				color = 'fire';
				lightOn = 1;
			}

			for (j = 0; j < spaceY; j++) {
				var js:String = '';
				js = nroom.a[j];
				var arri:Array = js.split('.');
				for (i = 0; i < spaceX; i++) {
					var jis:String;

					if (mirror) jis = arri[spaceX - i - 1];
					else jis = arri[i];
						
					if (jis == null) jis = '';
					getTile(i, j).dec(jis, mirror);
					if (getTile(i, j).stair != 0) { //полочка наверху лестницы  
						if (j > 0 && getTile(i, j).phis == 0 && !getTile(i, j).shelf && getTile(i, j).stair != getTile(i, j - 1).stair) {
							getTile(i, j).shelf = true;
							getTile(i, j).vid++;
						}
					}
					//линия воды
					if (j >= waterLevel) getTile(i, j).water = 1;
					//рамка
					if (i == 0 || i == spaceX - 1 || j == 0 || j == spaceY - 1)
					{
						if (ramka==1
							|| (ramka==2 || ramka==4) && (i==0 || i==spaceX-1)
							|| (ramka==3 || ramka==4) && (j==spaceY-1)
							|| ramka==5 && (i<=10 || i>=37)
							|| ramka==6 && j>=16
							|| ramka==7 && (i<=10 || i>=37) && j>=16
							|| ramka==8 && (i==spaceX-1)
							) {
								getTile(i, j).phis=1;
						}
						else if (getTile(i, j).phis>=1) {
							getTile(i, j).indestruct = true;
						}
					}
				}
			}
			
			//возможные проходы в другие локации
			if (nroom.doors.length() > 0) {
				var s:String = nroom.doors[0];
				doors = s.split('.');
				if (mirror) {
					var d;
					d = doors[6];
					doors[6] = doors[10];
					doors[10] = d;
					d = doors[7];
					doors[7] = doors[9];
					doors[9] = d;
					d = doors[17];
					doors[17] = doors[21];
					doors[21] = d;
					d = doors[18];
					doors[18] = doors[20];
					doors[20] = d;
					
					for (i = 0; i <= 5; i++) {
						d = doors[i];
						doors[i] = doors[i + 11];
						doors[i + 11] = d;
					}
				}
			} 
			else {
				doors = [];
				for (i = 0; i < 22; i++) doors[i] = 2;
			}
			
			//видимость
			lDist1 *= visMult;
			lDist2 *= visMult;
			if (isNaN(lDist1)) {
				lDist1 =  300;
				lDist2 = 1000;
			}
			//цветофильтр
			cTransform = colorFilter(color);
			if (colorfon) cTransformFon = colorFilter(colorfon);
			
			
			//точки появления активных объектов
			objsT = [];
			for each(var obj:XML in nroom.obj) {
				var xmll:XML = XMLDataGrabber.getNodeWithAttributeThatMatches("core", "AllData", "objs", "id", obj.@id);
				var size:int = xmll.@size;
				if (size <= 0) size = 1;
				var nx:int = obj.@x;
				var ny:int = obj.@y;
				if (mirror) nx = spaceX - nx - size;

				if (xmll.@tip == 'spawnpoint') spawnPoints.push({x:nx, y:ny});
				else if (xmll.@tip == 'enspawn') addEnSpawn(nx, ny, xmll);
				else if (xmll.@tip == 'up')
				{
					var n:int = xmll.@tipn;
					ups[n].push({x:nx, y:ny, xml:obj});
				}
				else objsT.push({id:obj.@id, tip:xmll.@tip, rem:xmll.@rem, x:nx, y:ny, xml:obj})
			}
			
			//фоновые объекты
			for each(obj in nroom.back) {
				backobjs.push(new BackObj(this, obj.@id, obj.@x * tileX,obj.@y * tileY, obj));
			}
			if (zoom > 1) {
				maxX *= zoom;
				maxY *= zoom;
			}
		}
		
		//цветофильтр
		public function colorFilter(filterName:String = ''):ColorTransform {
			var filter:ColorFilter = ColorFilter.getColorFromTable(filterName);
			
			var colorT:ColorTransform = new ColorTransform();
			colorT.redMultiplier 	= filter.red;
			colorT.greenMultiplier 	= filter.green;
			colorT.blueMultiplier 	= filter.blue;

			return colorT;
		}
		
// ------------------------------------------------------------------------------------------------
// второй этап - определить проходы, сделать рамку, создать объекты в зависимости от сложности и проходов

		//добавить переход с номером n
		public function setDoor(n:int, fak:int=2):void {
			var q:int;
			if (fak < 2) return;

			var dyr:Boolean = false;

			if (n > 21) return;
			else if (n >= 17) {
				q = (n - 17) * 9 + 4;
				dyr = getTile(q + 1, 0).hole() || dyr;
				dyr = getTile(q + 2, 0).hole() || dyr;
				getTile(q + 1, 1).hole();
				getTile(q + 2, 2).hole();
				setNoObj(q + 1, 0, 0, 2);
				setNoObj(q + 2, 0, 0, 2);
				if (fak > 2)
				{
					dyr = getTile(q, 0).hole() || dyr;
					dyr = getTile(q + 3, 0).hole() || dyr;
					getTile(q, 1).hole();
					getTile(q + 3, 1).hole();
					setNoObj(q, 0, 0, 2);
					setNoObj(q + 3, 0, 0, 2);
				}
				if (dyr) addSignPost(q + 2, 0, -90);
			}
			else if (n>=11) {
				q=(n-11)*4+3;
				dyr=getTile(0, q).hole() || dyr;
				dyr=getTile(0, q - 1).hole() || dyr;
				getTile(1, q).hole();
				getTile(1, q - 1).hole();
				setNoObj(0,q,5,0);
				setNoObj(0,q-1,5,0);
				if (fak>2) {
					dyr=getTile(0, q - 2).hole() || dyr;
					getTile(1, q - 2).hole();
				} 
				if (dyr) addSignPost(0,q,180);
				addEnSpawn(tileX, (q+1)*tileY-1);
			}
			else if (n>=6) {
				q=(n-6)*9+4;
				dyr=getTile(q + 1, spaceX - 1).hole() || dyr;
				dyr=getTile(q + 2, spaceX - 1).hole() || dyr;
				getTile(q + 1, spaceX - 2).hole();
				getTile(q + 2, spaceX - 2).hole();
				setNoObj(q+1,spaceY-1,0,-2);
				setNoObj(q+2,spaceY-1,0,-2);
				if (fak>2) {
					dyr=getTile(q, spaceX - 1).hole() || dyr;
					dyr=getTile(q + 3, spaceX - 1).hole() || dyr;
					getTile(q, spaceX - 2).hole();
					getTile(q + 3, spaceX - 2).hole();
					setNoObj(q,spaceY-1,0,-2);
					setNoObj(q+3,spaceY-1,0,-2);
				} 
				if (dyr) addSignPost(q+2,spaceY,90);
			}
			else if (n>=0)
			{
				q=(n)*4+3;
				dyr = getTile(spaceX - 1, q).hole() || dyr;
				dyr = getTile(spaceX - 1, q - 1).hole() || dyr;
				getTile(spaceX - 2, q).hole();
				getTile(spaceX - 2, q - 1).hole();
				setNoObj(spaceX - 1, q, -5, 0);
				setNoObj(spaceX - 1, q - 1, -5, 0);
				if (fak>2)
				{
					dyr=getTile(spaceX - 1, q - 2).hole() || dyr;
					getTile(spaceX - 2, q - 2).hole();
				} 
				if (dyr) addSignPost(spaceX,q,0);
				addEnSpawn((spaceX-1)*tileX, (q+1)*tileY-1);
			}
			else return;
		}
		
		//добавить указатели перехода в соседние локации
		private function addSignPost(xCoord:int, yCoord:int, rotation:int)
		{
			var sign:MovieClip;
			sign = new signPost();
			sign.x = xCoord * tileX;
			sign.y = yCoord * tileY;
			sign.rotation = rotation;
			signposts.push(sign);
		}
		
		//добавить точки спавна врагов 
		private function addEnSpawn(xCoord:Number, yCoord:Number, xmll:XML=null) 
		{
			var obj:Object = new Object();
			if (xmll)
			{
				var size:int = xmll.@size;
				if (size <= 0) size = 1;
				obj.x = (xCoord + 0.5 * size) * tileX;
				obj.y = (yCoord + 1.0) * tileY - 1;
			}
			else
			{
				obj.x = xCoord;
				obj.y = yCoord;
			}
			enspawn.push(obj);
		}
		
		//добавить места, в которых не должно быть контейнеров (около переходов)
		private function setNoObj(nx:int, ny:int, dx:int, dy:int)
		{
			var i:int;
			if (dx > 0) for (i = nx; i<=nx+dx; i++) getTile(i, ny).place = false;
			if (dx < 0) for (i = nx+dx; i<=nx; i++) getTile(i, ny).place = false;
			if (dy > 0) for (i = ny; i<=ny+dy; i++) getTile(nx, i).place = false;
			if (dy < 0) for (i = ny+dy; i<=ny; i++) getTile(nx, i).place = false;
		}
		
		
		//главная рамка, вызывать после проделывания проходов
		public function mainFrame()
		{
			var border:String = 'A';
			if (land && land.act) border = land.act.border;
			for (var j:int = 0; j < spaceX; j++)
			{
				if (getTile(j, 0).phis >= 1) getTile(j, 0).mainFrame(border);
				if (getTile(j, spaceY - 1).phis >= 1) getTile(j, spaceY - 1).mainFrame(border);
			}
			for (j = 0; j<spaceY; j++)
			{
				if (getTile(0, j).phis >= 1) getTile(0, j).mainFrame(border);
				if (getTile(spaceX - 1, j).phis >= 1) getTile(spaceX - 1, j).mainFrame(border);
			}
		}
		
		//создать активные объекты в местах их появления, кроме мест около переходов, вызывать после проделывания проходов
		public function setObjects():void
		{
			for each (var obj in objsT)
			{
				if (noHolesPlace && obj.rem>0 && !getTile(obj.x, obj.y).place) continue;	//не ставить ящики около прохода
				
				if (obj.tip=='unit') createUnit(obj.id,obj.x,obj.y, false, obj.xml);
				else createObj(obj.id, obj.tip, obj.x,obj.y, obj.xml);
			}
			objsT = null;
			setRandomUnits();
			if (land.rnd && World.w.pers.modMetal > 0 && Math.random() < World.w.pers.modMetal) putRandomLoot();
		}
		
		//задать количество случайных врагов
		public function setKolEn(en:int, min:int, max:int, spl:int=0):void
		{
			if (en == -1)
			{
				kolEnSpawn = min + int(Math.random()*(max-min+1));
			}
			else
			{
				kolEn[en] = min + int(Math.random() * (max - min + 1));
				if (spl > 0 && Math.random() < 0.2) kolEn[en] += spl;
			}
		}
		
		//создать случайных врагов в точках их появления
		public function setRandomUnits():void {
			for (var i:int = 1; i < kolEn.length; i++) {
				if (kolEn[i] > 0 && ups[i].length) {
					//убрать точки от проходов
					if (noHolesPlace) {
						for (var j=0; j<ups[i].length; j++) {
							if (!getTile( ups[i][j].x, ups[i][j].y ).place) {
								ups[i].splice(j, 1);
								j--;
							}
						}
					}
					if (ups[i].length > 0) {
						for (j = 0; j < kolEn[i]; j++) {
							var n = int(Math.random() * ups[i].length);
							createUnit(tipEn[i], ups[i][n].x, ups[i][n].y, false, ups[i][n].xml);
							
							if (ups[i].length <= 1) {
								ups[i] = [];
								break;
							}
							else {
								ups[i].splice(n, 1);
							}
						}
					}
				}
			}
			//добавить скрытых врагов
			if (kolEnHid > 0 && ups[2].length > 0)
			{
				for (j = 0; j < kolEnHid; j++)
				{
					n = int(Math.random() * ups[2].length);
					createHidden(ups[2][n].x, ups[2][n].y);
					
					if (ups[2].length <= 1) break;
					else ups[2].splice(n, 1);
				}
			}
		}
		
		//создать рандомный лут
		public function putRandomLoot():void
		{
			var nx:int = int(Math.random() * (spaceX - 2) + 1);
			var ny:int = int(Math.random() * (spaceY - 2) + 1);
			if (getTile(nx, ny).phis == 0) 
			{
				LootGen.lootCont(this, (nx + 0.5) * tileX, (ny + 0.8) * tileY, 'metal');
			}
		}
		
		//создать юнит, nx,ny-координаты в блоках если abs=false, и в пикселях, если abs=true
		//emerg>0 - плавное появление в течении Х тактов
		public function createUnit(tip:String,nx:int,ny:int,abs:Boolean=false,xml:XML=null,cid:String=null, emerg:int=0):Unit {
			if (tip=='mines') {
				createUnit('mine',nx,ny);
				createUnit('mine',nx+2,ny);
				createUnit('mine',nx+4,ny);
				return null;
			}
			if (land.rnd && tip=='transm') {
				if ((xml==null || xml.@on.length()==0) && Math.random()<0.5) return null;
			}
			if (xml && xml.@trigger.length() && World.w.game.triggers[xml.@trigger]=='1') return null;
			var loadObj:Object=null;
			if (xml && xml.@code.length() && World.w.game.objs.hasOwnProperty(xml.@code)) loadObj=World.w.game.objs[xml.@code];
			//не генерировать юнита, который сдох
			if (loadObj && loadObj.dead>0 && loadObj.loot!=2) return null;
			var un:Unit;
			var scid:String;
			var hero:int=0;
			var inWater:Boolean=false;
			if ((biom == 1 || biom == 5) && abs == false) inWater = getTile(nx, ny).water > 0;
			var s:String=randomUnit(tip,inWater); //определить, является ли юнит случайным, если да, то сгенерировать его id
			//если тип был случайным и удалось сгенерировать его id
			if (s!='') 
			{
				if (cid) scid=cid;
				else scid=randomCid(s);
				if (s=='slmine') s='slime';
				un=Unit.create(s,locDifLevel,xml,loadObj,scid);
			}
			//если юнит не был случайным, или не получилось сгенерировать по id=s, попробовать сгенерировать по id=tip
			if ((s=='' && !homeStable) || un==null) {
				if (cid) scid=cid;
				else scid=randomCid(tip);
				un=Unit.create(tip,locDifLevel,xml,loadObj,scid);
			}
			if (un!=null) 
			{
				var enl:int = enemyLevel;
				if (land.rnd && landProb=='') //геройский юнит
				{
					if (Math.random()<Math.min(0.05,locDifLevel/100+0.02)) hero=Math.floor(Math.random()*4+1);	
				}
				if (hero==0 && un.boss==false) enl=Math.round(enl*(1.1-Math.random()*0.4));
				un.setLevel(enl);
				un.setHero(hero);
				if (abs) {
					un.putLoc(this,nx,ny);
				} else {
					var size:int = Math.floor((un.objectWidth-1)/40)+1;
					un.putLoc(this,(nx+0.5*size)*tileX,(ny+1)*tileY-1);
				}
				if (active) {
					un.xp=0;
				}
				else {
					summXp+=un.xp;
				}
				addObj(un);
				units.push(un);
				if (homeStable) {
					un.fraction=Unit.F_PLAYER;
					un.warn=0;
				}
				if (homeAtk) {
					if (un is UnitTurret) (un as UnitTurret).hack(2);
					else if (Math.random()<0.5) backobjs.push(new BackObj(this, 'blood1', nx*tileX,(ny-Math.random()*4)*tileY));
					
				}
				if (xml && xml.@code.length()) saves.push(un);
				//Добавление объектов, имеющих uid в массив
				if (xml && xml.@uid.length()) {
					un.uid=xml.@uid;
					land.uidObjs[un.uid]=un;
				}
				if (emerg>0) un.emergence(emerg);
				un.step();
			}
			return un;
		}
		
		//создать феникса, сидящего на ящике
		private function createPhoenix(box:Box):Boolean
		{
			if (box.wall || !box.shelf) return false;
			if (collisionUnit(box.coordinates.X,box.topBound-1,38,38)) return false;
			var un:Unit=new UnitPhoenix();
			un.putLoc(this, box.coordinates.X, box.topBound-1);
			addObj(un);
			units.push(un);
			kol_phoenix++;
			land.kol_phoenix++;
			return true;
		}
		//создать передатчик на ящике
		private function createTransmitter(box:Box):Boolean
		{
			if (box.wall || !box.shelf) return false;
			if (land.rnd && Math.random()<0.5) return false;
			if (collisionUnit(box.coordinates.X, box.topBound-1,30,20)) return false;
			var un:Unit=new UnitTransmitter('box');
			un.setLevel(enemyLevel);
			un.putLoc(this,box.coordinates.X,box.topBound-1);
			addObj(un);
			units.push(un);
			return true;
		}
		
		//создать предмет, стоящий на ящике
		private function createSur(box:Box, nsur:String=null):void
		{
			if (nsur==null) 
			{
				if (Math.random()>0.25) return;
				if (biom==0) nsur='fan';
				if (biom==2) nsur='lamp';
				if (biom==3) nsur='kofe';
				if (nsur==null) return;
			}
			var item:Item=new Item(null, nsur, 1);
			var l:Loot=new Loot(this,item,box.coordinates.X, box.coordinates.Y-box.objectHeight-3,false,false,false);
			if (base) 
			{
				l.inter.active=false;
				l.levitPoss=false;
			}
		}
		
		//создать скрытый юнит или дополнительный объект
		public function createHidden(nx:int,ny:int):void
		{
			if (biom==10 || biom==11) return;
			if (tipEnemy==0) createUnit('zombie',nx,ny, false, <unit dig='2'/>);
			else if (tipEnemy==2) createObj('robocell','box',nx,ny);
			else if (tipEnemy==1 || tipEnemy==3) createObj('alarm','box',nx,ny);
			else if (tipEnemy==6) createUnit('lov',nx,ny);
		}
		
		//облака газа
		public function createClouds(lvl:int, ncloud:String=null):void
		{
			if (ncloud == null)
			{
				if (biom == 1)
				{
					ncloud='tcloud1';
					if (lvl>=2) return;
				}
				if (biom == 5)
				{
					ncloud = 'pcloud1';
				}
			}
			if (ncloud != null)
			{
				var kol:int = 1;
				if (biom == 1) kol = Math.random() * 5;
				if (biom == 5)
				{
					if (lvl == 0) kol = Math.random() * 2;
					else kol = Math.random()*3;
				}
				for (var i:int = 0; i<kol; i++)
				{
					var nx:int = int(Math.random()*(spaceX-4)+2);
					var ny:int = int(Math.random()*(spaceY-4)+2);
					if (cp) {
						var dnx = cp.coordinates.X - (nx * tileX + 20);
						var dny = cp.coordinates.Y - (ny * tileY + 40);
						if (dnx * dnx + dny * dny < 80 * 80) continue;
					}
					if (biom==1 && lvl==1 && ny>15) ny=15;
					if (biom==5 && lvl==0) ny = int(Math.random()*15+9);
					createObj(ncloud,'box',nx,ny);
				}
			}
		}
		
		//определение id случайного юнита
		public function randomUnit(tip:String, inWater:Boolean=false):String
		{
			var s:String='';
			switch (tip) {
				case 'enl2':
					if (biom==10) s='stabpon';
					else if (tipEnemy==0) s='zombie';
					else if (tipEnemy==2) {
						if (biom==2 && locDifLevel>=12 && Math.random()<Math.min(locDifLevel/100,0.15)) s='eqd';
						else if (locDifLevel>=5 && Math.random()<0.1) s='landturret';
						else if (locDifLevel>=6 && Math.random()<Math.min(locDifLevel/40,0.3)) s='gutsy';
						else if (locDifLevel>=2 && Math.random()<Math.min(locDifLevel/10,0.5)) s='protect';
						else s='robot';
					} 
					else if (tipEnemy==3) s='slaver';
					else if (tipEnemy==4) s='merc';
					else if (tipEnemy==5) s='alicorn';
					else if (tipEnemy==6) s='zebra';
					else if (tipEnemy==7) {
						if (Math.random()<0.4) {
							if (Math.random()<0.5) s='gutsy';
							else s='protect';
						} else s='ranger';
					} else if (tipEnemy==8) {
						if (Math.random()<0.75) s='zombie';
						else s='necros'
					} else if (tipEnemy==9) {
						if (Math.random()<0.1) s='hellhound';
						else if (Math.random()<0.07) s='landturret';
						else s='encl';
					} else if (tipEnemy==10) s='hellhound';
					else if (tipEnemy==11) {
						if (Math.random()<0.3) s='hellhound';
						else s='encl';
					} else s='raider';
				break;
				case 'enl1':
					if (biom==10 || biom==11) return '';
					if ((biom==1 || biom==5) && inWater) {
						s='fish';
					} else if (biom==5) {
						if (Math.random()<0.3) s='scorp3';
						else s='slime';
					} else if (biom==6) {
						s='roller';
					} else if (tipEnemy==2 && locDifLevel>=4 || tipEnemy==7 || tipEnemy==9 || tipEnemy==10) {
						if ((landX+landY)%2==0) s='roller';
						else s='msp';
					} else if (tipEnemy==0 || tipEnemy==5 || tipEnemy==6) {
						if (locDifLevel>=2 && Math.random()<Math.min(locDifLevel/30,0.5)) {
							s='scorp';
						} else if ((landX+landY)%2==0) s='slime';
						else s='ant';
						if (biom==1 && Math.random()<0.25) s='rat';
					} else if (locDifLevel>=2 && Math.random()<Math.min(locDifLevel/30,0.5)) s='molerat';
					else if (Math.random()<0.6) s='tarakan';
					else s='rat';
				break;
				case 'enc1':
					if (biom==10) {
						s='turret';
					} else if ((biom==1 || biom==5) && inWater) {
						s='fish';
					} else if (biom==5) {
						if ((landX+landY)%2==0) s='bloodwing';
						else s='slime';
					} else if (biom==6 || biom==4) {
						s='cturret';
					} else if (tipEnemy==0 || tipEnemy==5 || tipEnemy==6) {
						if (biom==1 && Math.random()<0.6) s='slime';
						else s='bloodwing';
					} else s='turret';
				break;
				case 'enf1':
					if (biom==10) return '';
					if ((biom==1 || biom==5) && inWater) {
						s='fish';
					} else if (biom==5) {
						s='bloat';
					} else if (tipEnemy==0 || tipEnemy==5) s='bloat';
					else if ((tipEnemy==1 || tipEnemy==3 || tipEnemy==4 || tipEnemy==6) && locDifLevel>=3) s='vortex';
					else if (tipEnemy==2 && locDifLevel>=3) s='spritebot';
					else if (tipEnemy==11 || tipEnemy==7 || tipEnemy==9 || tipEnemy==10 || tipEnemy==2 && locDifLevel>10 && Math.random()<Math.min(locDifLevel/40,0.5)) s='dron';
				break;
				case 'lov':
					if (biom==10 || biom==11) return '';
					if (biom==5) {
						s='slmine';
					} else if (tipEnemy==0) {
						if ((landX+landY)%2==0) s='slmine';
						else s='trap';
					} else if ((tipEnemy==1 || tipEnemy==3 || tipEnemy==4 || tipEnemy==6)&&(landX+landY)%2==0) {
						if (locDifLevel>=10 && Math.random()<0.5) s='trridge';
						else if (Math.random()<0.5) s='trplate';
						else s='trcans';
					} else if ((biom==2 && tipEnemy==2 || tipEnemy==7 || tipEnemy==9) &&(landX+landY)%2==0) {
						s='trlaser';
					} else s='mine';
				break;
			}
			return s;
		}
		
		//определение сid случайного юнита
		public function randomCid(tip:String):String {
			var tr:int=0;
			switch (tip) {
				case 'raider':
					if (locDifLevel>=5) tr = int(Math.random()*9+1);
					else if (locDifLevel>=2) tr = int(Math.random()*5+1);
					else tr = int(Math.random()*2+1);
					return tr.toString();
				break;
				case 'slaver':
					if (locDifLevel>=18) tr = int(Math.random()*6+1);
					else if (locDifLevel>=15) tr = int(Math.random()*5+1);
					else tr = int(Math.random()*4+1);
					return tr.toString();
				break;
				case 'zebra':
					if (locDifLevel>=15) tr = int(Math.random()*4+1);
					else tr = int(Math.random()*2+1);
					if (locDifLevel>=25 && Math.random()<0.1) tr=5; 
					return tr.toString();
				break;
				case 'ranger':
					if (land.act.conf==7) tr = int(Math.random()*3+1);
					else if (landY==0) tr=1;
					else tr = int(Math.random()*2+1);
					return tr.toString();
				break;
				case 'merc':
					if (locDifLevel>=19) tr = int(Math.random()*5+1);
					else if (locDifLevel>=15 && Math.random()>0.5) tr = int(Math.random()*4+1);
					else tr = int(Math.random()*2+1);
					return tr.toString();
				break;
				case 'encl':
					tr = int(Math.random()*4+1);
					return tr.toString();
				break;
				case 'protect':
					if (tipEnemy==7) tr=1;
					return tr.toString();
				break;
				case 'gutsy':
					if (tipEnemy==7) tr=1;
					return tr.toString();
				break;
				case 'dron':
					if (tipEnemy==9) {
						tr = int(Math.random()*4+1);
						if (tr>3) tr=3;
					}
					else tr = int(Math.random()*2+1);
					return tr.toString();
				break;
				case 'roller':
					if (biom==6) tr=2;
					else tr=1;
					return tr.toString();
				break;
				case 'zombie':
					if (biom==5) {
						if (locDifLevel>=20 && Math.random()<0.1) tr=9;
						else tr = int(Math.random()*4+5);
					} else if (biom>=1 && locDifLevel>=8) tr = int(Math.random()*7);
					else if (locDifLevel>=5) tr = int(Math.random()*5);
					else if (locDifLevel>=2) tr = int(Math.random()*4);
					else tr=0;
					return tr.toString();
				break;
				case 'alicorn':
					tr = int(Math.random()*3+1);
					return tr.toString();
				break;
				case 'hellhound':
					tr=1;
					return tr.toString();
				break;
				case 'bloat':
					if (biom==5) tr = int(Math.random()*3+4);
					else if (locDifLevel>=10) tr = int(Math.random()*5);
					else if (locDifLevel>=4) tr = int(Math.random()*4);
					else if (locDifLevel>=2) tr = int(Math.random()*3);
					else tr=0;
					return tr.toString();
				break;
				case 'ant':
					if (biom>=1 && locDifLevel>=6) tr = int(Math.random()*3+1);
					else if (locDifLevel>=3) tr = int(Math.random()*2+1);
					else tr=1;
					return tr.toString();
				break;
				case 'fish':
					if (biom==5) tr=3;
					else tr = int(Math.random()*2+1);
					return tr.toString();
				break;
				case 'slime':
					if (biom==5) tr=2;
					else tr=0;
					return tr.toString();
				break;
				case 'slmine':
					if (biom==5) tr=12;
					else tr=10;
					return tr.toString();
				break;
				case 'bloodwing':
					if (biom==5) tr=2;
					else tr=1;
					return tr.toString();
				break;
				case 'scorp':
					if (locDifLevel>=5) tr = int(Math.random()*2+1);
					else tr=1;
					return 'scorp'+tr;
				break;
				case 'mine':
					if (biom==4) return 'plamine';
					if (biom==2 && Math.random()<Math.min(locDifLevel/20,0.4)) return 'plamine';
					else if (Math.random()<Math.min(locDifLevel/20,0.75)) return 'mine';
					else return 'hmine';
				break;
			}
			return null;
		}
		
		//создать активный объект, nx,ny-координаты в блоках
		public function createObj(id:String,tip:String,nx:int,ny:int,xml:XML=null):Obj
		{
			var obj:Obj;
			var size:int = XMLDataGrabber.getNodeWithAttributeThatMatches("core", "AllData", "objs", "id", id).@size;
			if (size<=0) size=1;
			var loadObj:Object=null;
			if (xml && xml.@code.length() && World.w.game.objs.hasOwnProperty(xml.@code)) loadObj=World.w.game.objs[xml.@code];
			if (tip=='box' || tip=='door') {
				obj=new Box(this, id, (nx+0.5*size)*tileX, (ny+1)*tileY-1, xml, loadObj);
				objs.push(obj);
				if ((obj is Box) && (obj as Box).un) units.push((obj as Box).un);
				//создать феникса
				if (xml && xml.@ph=='1' && !World.w.game.triggers['pet_phoenix']) createPhoenix((obj as Box));
				if (xml && xml.@transm=='1') createTransmitter((obj as Box));
				if (land.rnd && land.act.biom==0 && !World.w.game.triggers['pet_phoenix'] && kol_phoenix==0 && land.kol_phoenix<3 && Math.random()<0.02) {
					createPhoenix(obj as Box);
				}
				if ((obj is Box) && (obj as Box).sur && land.rnd) createSur(obj as Box);
				if (!land.rnd && xml && xml.@sur.length()) createSur(obj as Box, xml.@sur);
				if ((obj is Box) && (obj as Box).electroDam>electroDam && !obj.inter.open) electroDam=(obj as Box).electroDam;
			} else if (tip=='trap') {
				obj=new Trap(this, id,(nx+0.5*size)*tileX, (ny+1)*tileY-1);
			} else if (tip=='checkpoint') {
				obj=new CheckPoint(this, id,(nx+0.5*size)*tileX, (ny+1)*tileY-1, xml, loadObj);
				//установить на контрольных точках телепорты на базу
				if (World.w.game.globalDif<=1 || land.rnd && World.w.game.globalDif==2 && Math.random()<0.33) (obj as CheckPoint).teleOn=true;
				acts.push(obj);
			} else if (tip=='area') {
				obj=new Area(this, xml, loadObj, mirror);
				areas.push(obj);
			} else if (tip=='bonus') {
				obj=new Bonus(this, id,(nx+0.5)*tileX, (ny+0.5)*tileY, xml, loadObj);
				bonuses.push(obj);
			}
			if (xml && xml.@code.length()) {
				saves.push(obj);
				obj.code=xml.@code;
				if (tip=='checkpoint' && !land.rnd) {	//сохранённая контрольная точка
					if (World.w.pers.currentCPCode!=null && obj.code==World.w.pers.currentCPCode || World.w.pers.prevCPCode!=null && obj.code==World.w.pers.prevCPCode || land.act.lastCpCode==obj.code) {
						land.currentCP=obj as CheckPoint;
					}
				}
			}
			//Добавление объектов, имеющих uid в массив
			if (xml && xml.@uid.length())
			{
				obj.uid=xml.@uid;
				land.uidObjs[obj.uid]=obj;
			}
			if (xml && xml.@nazv.length()) obj.nazv=xml.@nazv;
			//Добавление id испытаний
			if (landProb=='' && xml && xml.@prob.length() && xml.@prob!='') land.probIds.push(xml.@prob);
			addObj(obj);
			return obj;
		}
		
		//создание чекпоинта в случайной точке появления
		public function createCheck(act:Boolean=false):void
		{
			if (spawnPoints.length>0)
			{
				var sp = spawnPoints[int(Math.random()*spawnPoints.length)];
				var id = 'checkpoint';
				if (!act && land.rnd && Math.random()<0.5)
				{
					id += int(Math.random()*5+1);
				}
				cp = createObj(id,'checkpoint',sp.x,sp.y) as CheckPoint;
				if (land.act.landStage==0 && act) cp.teleOn=true;
				if (act) cp.activate(true);
				isCheck=true;
			}
		}

		//создание выхода в случайной точке появления
		public function createExit(s:String = ''):void
		{
			if (spawnPoints.length>0)
			{
				var sp = spawnPoints[int(Math.random() * spawnPoints.length)];
				createObj('exit', 'box', sp.x, sp.y, <obj name = 'exit' prob = {land.act.exitProb + s} time = '20' inter = '8' sign = '1'/>);
				isCheck = true;
			}
		}
		//создание двери испытаний в случайной точке появления
		public function createDoorProb(nid:String, nprob:String):Boolean
		{
			if (spawnPoints.length > 0)
			{
				var sp = spawnPoints[int(Math.random()*spawnPoints.length)];
				createObj(nid,'box',sp.x,sp.y,<obj prob={nprob} nazv = {Res.txt('m', nprob)} time='20' inter='8'/>);
				isCheck=true;
				return true;
			}
			return false;
		}
		
		
		public function createXpBonuses(kol:int=5):void {
			if (homeStable || homeAtk) return;
			var nx:int, ny:int, x1:int, x2:int, y1:int, y2:int;
			var mesto:int=4;
			var n:int=5;
			maxXp = kol;
			for (var i:int = 1; i<=100; i++) {
				x1 = 2;
				y1 = 2;
				x2 = spaceX - 2;
				y2 = spaceY - 2;

				switch (mesto) {
					case 4:
						x2 = halfSpaceX;
						y2 = halfSpaceY;
					break;
					case 3:
						x1 = halfSpaceX;
						y2 = halfSpaceY;
					break;
					case 2:
						x2 = halfSpaceX;
						y1 = halfSpaceY;
					break;
					case 1:
						x1 = halfSpaceX;
						y1 = halfSpaceY;
					break;
					
				}

				nx = int(x1 + Math.random() * (x2 - x1));
				ny = int(y1 + Math.random() * (y2 - y1));
				if (getTile(nx, ny).phis == 0 && (getTile(nx - 1, ny).phis == 0 || getTile(nx + 1, ny).phis == 0)) { // Check that the tile is empty.
					createObj('xp','bonus',nx,ny);
					kolXp++;
					if (mesto>0) mesto--;
					if (kolXp>=kol) return;
				} 
				else {
					n--;
					if (n <= 0) {
						n = 5;
						if (mesto > 0) {
							mesto--;
						}
					}
				}
			}
		}
		
		public function preStep():void
		{
			for (var i:int = 0; i < 30; i++) stepInvis();
		}
		
//**************************************************************************************************************************
//
//				Активация
//
//**************************************************************************************************************************
		
		//активировать при входе гг в локацию
		public function reactivate(n:int = 0):void
		{
			var obj:Entity = firstObj;
			while (obj)
			{
				nextObj=obj.nobj;
				obj.setNull(n-nAct>2 || n==0 || prob &&!prob.closed);
				obj=nextObj;
			}
			resetUnits();
			if (n>0) nAct=n;
			showSign(false);
			active=true;
			visited=true;
			warning=0;
			if (prob) prob.over();
		}
		
		public function resetUnits():void
		{
			units = units.filter(isAct);
		}
		
		private function isAct(element:*, index:int, arr:Array):Boolean
		{
			if (element == null) return false;
			if (element is fe.unit.UnitPet) return true;
            return (element.sost < 4);
        }
		
		//деактивировать локацию
		public function out():void
		{
			active=false;
			for each (var un:Unit in units)
			{
				un.locout();
			}
			if (prob) prob.out();
		}
		
//**************************************************************************************************************************
//
//				Цепочка обработки
//
//**************************************************************************************************************************
		//добавить любой объект в цепочку обработки
		public function addObj(obj:Entity):void
		{
			if (obj.in_chain) return;
			if (firstObj) {
				lastObj.nobj = obj;
				obj.pobj = lastObj;
			}
			else firstObj = obj;
			obj.nobj=null;
			lastObj=obj;
			obj.in_chain=true;
			if (active) obj.addVisual();
		}
		
		//удалить объект из цепочки обработки
		public function remObj(obj:Entity):void
		{
			if (!obj.in_chain) return;

			if (obj.nobj) obj.nobj.pobj = obj.pobj;
			else lastObj = obj.pobj;

			if (obj.pobj) obj.pobj.nobj = obj.nobj;
			else firstObj = obj.nobj;

			obj.in_chain=false;
			obj.nobj=obj.pobj=null;
			obj.remVisual();
		}
		
//**************************************************************************************************************************
//
//				Работа с пространством блоков
//
//**************************************************************************************************************************
		
		public function initializeSpace():void {
			space = new Vector.<Tile>(spaceX * spaceY, true);
			for (var i:int = 0; i < spaceX; i++) {
				for (var j:int = 0; j < spaceY; j++) {
					space[i * spaceY + j] = new Tile(i, j);
				}
			}

			trace("Location.as/initializeSpace() - Room Width (Horizontal Tiles): " + spaceX);
			trace("Location.as/initializeSpace() - Room Height (Vertical Tiles): " + spaceY);
			trace("Location.as/initializeSpace() - Total Tiles Generated: " + space.length);
		}

		//получить блок
		public function getTile(nx:int, ny:int):Tile {
			// Cache for speed
			const sX:int = spaceX;
			const sY:int = spaceY;
			
			if (nx < 0 || nx >= sX || ny < 0 || ny >= sY) {
				return defaultTile;
			}
			
			// The index calculator to get the position of the tile in the vector
			const index:int = nx * sY + ny;
			return space[index];
		}

		// Changed Math.floor calls to int
		public function getAbsTile(nx:int, ny:int):Tile {
			// Cache for speed
			const mX:int = maxX;
			const mY:int = maxY;
			
			// Do inverse multiplication instead of division
			const invTileX:Number = INV_TILEX; // 0.025
			const invTileY:Number = INV_TILEY; // 0.025
			
			if (nx < 0 || nx >= mX || ny < 0 || ny >= mY) {
				return defaultTile;
			}
			
			const tileXIndex:int = int(nx * invTileX);
			const tileYIndex:int = int(ny * invTileY);
			const index:int = tileXIndex * spaceY + tileYIndex;
			
			return space[index];
		}

		public function collisionUnit(X:Number, Y:Number, objectWidth:Number=0, objectHeight:Number=0):Boolean {
			var leftBound = X - objectWidth / 2;
			var rightBound = X + objectWidth / 2;
			var topBound = Y - objectHeight;

			for (var i:int = int(leftBound / tileX); i <= int(rightBound / tileX); i++) {
				for (var j:int = int(topBound / tileY); j <= int(Y / tileY); j++) {
					if (i < 0 || i >= spaceX || j < 0 || j >= spaceY) continue;
					if (getTile(i, j).phis > 0) return true;
				}
			}
			return false;
		}

		//попробовать проложить линию. obj - дверь, которую нужно игнорировать
		// Move as much calculation as possible outside the loop
		public function isLine(nx:Number, ny:Number, cx:Number, cy:Number, obj:Obj=null):Boolean {
			var ndx:Number = cx - nx;
			var ndy:Number = cy - ny;
			var div:int = int(Math.max(Math.abs(ndx), Math.abs(ndy)) / World.maxdelta) + 1;

			var deltaX:Number = ndx / div;
			var deltaY:Number = ndy / div;

			for (var i:int = 1; i < div; i++) {
				var currentX:Number = nx + deltaX * i;
				var currentY:Number = ny + deltaY * i;

				var t:Tile = World.w.loc.getAbsTile(int(currentX), int(currentY));

				if (t.phis == 1 && currentX >= t.phX1 && currentX <= t.phX2 && currentY >= t.phY1 && currentY <= t.phY2)
				{
					if (obj == null || t.door != obj) return false;
				}
			}
			return true;
		}
	
		//контуры блоков
		public function tileKontur(tx:int, ty:int, t:Tile):void {
			var a0:Boolean,a1:Boolean,a2:Boolean,a3:Boolean,a4:Boolean,a5:Boolean,a6:Boolean,a7:Boolean;
			if (t.phis==1) {
				a0=uslKontur(tx-1,ty-1);
				a1=uslKontur(tx,  ty-1);
				a2=uslKontur(tx+1,ty-1);
				a3=uslKontur(tx+1,ty);
				a4=uslKontur(tx+1,ty+1);
				a5=uslKontur(tx,  ty+1);
				a6=uslKontur(tx-1,ty+1);
				a7=uslKontur(tx-1,ty);
				t.kont1=insKontur(a1,a7,a0);
				t.kont2=insKontur(a1,a3,a2);
				t.kont3=insKontur(a5,a7,a6);
				t.kont4=insKontur(a5,a3,a4);
				if (b!='') {
					if (!a1) a1=uslPontur(tx, ty-1);
					if (!a3) a3=uslPontur(tx+1,ty);
					if (!a5) a5=uslPontur(tx, ty+1);
					if (!a7) a7=uslPontur(tx-1,ty);
					t.pont1=insKontur(a1,a7,a0);
					t.pont2=insKontur(a1,a3,a2);
					t.pont3=insKontur(a5,a7,a6);
					t.pont4=insKontur(a5,a3,a4);
				}
			} 
			else {
				var b:String=t.back;
				var vse:Boolean=(backwall=='sky');
				a0=uslBontur(tx-1,ty-1, b, vse);
				a1=uslBontur(tx,  ty-1, b, vse);
				a2=uslBontur(tx+1,ty-1, b, vse);
				a3=uslBontur(tx+1,ty, b, vse);
				a4=uslBontur(tx+1,ty+1, b, vse);
				a5=uslBontur(tx,  ty+1,b, vse);
				a6=uslBontur(tx-1,ty+1,b, vse);
				a7=uslBontur(tx-1,ty,b, vse);
				t.pont1=insKontur(a1,a7,a0);
				t.pont2=insKontur(a1,a3,a2);
				t.pont3=insKontur(a5,a7,a6);
				t.pont4=insKontur(a5,a3,a4);
			}
		}
		
		private function insKontur(a:Boolean, b:Boolean, c:Boolean):int {
			if (a && b) return c?0:1;
			else if (!a && b) return 2;
			else if (a && !b) return 3;
			else return 4;
		}
		
		//контуры переднего плана
		private function uslKontur(nx:int,ny:int):Boolean {
			if (nx<0 || nx>=spaceX || ny<0 || ny>=spaceY) return true;
			return (getTile(nx, ny).phis==1 || getTile(nx, ny).door!=null);
		}

		//контуры заднего плана если есть стенка
		private function uslPontur(nx:int,ny:int):Boolean {
			if (nx<0 || nx>=spaceX || ny<0 || ny>=spaceY) return true;
			return (getTile(nx, ny).back!='' || getTile(nx, ny).shelf>0);
		}
		//контуры заднего плана если нет стенки
		private function uslBontur(nx:int,ny:int,b:String='',vse:Boolean=false):Boolean {
			if (nx<0 || nx>=spaceX || ny<0 || ny>=spaceY) return true;
			return (getTile(nx, ny).back==b || vse && getTile(nx, ny).back!='' || getTile(nx, ny).phis==1 || getTile(nx, ny).shelf>0);
		}
		
		//урон блоку
		public function hitTile(t:Tile, hit:int, nx:int, ny:int, tip:int = 9):void {
			var isPhisGreaterThanOrEqualToOne:Boolean = t.phis >= 1;
			var isHpZeroOrLess:Boolean = t.hp <= 0;

			if (tip == 100 && hit <= 50 && (t.thre > 0 || t.indestruct)) return;
			if (tip == 100) tip = 4;

			var hitDivHp:Number = hit / t.hp;

			if (!destroyOn && t.hp > 500) {
				if (active && isPhisGreaterThanOrEqualToOne) grafon.dyrka(nx, ny, tip, t.mat, true, hitDivHp);
				return;
			}
			if (!t.udar(hit)) {
				if (isPhisGreaterThanOrEqualToOne && active) grafon.dyrka(nx, ny, tip, t.mat, true, hitDivHp);
				return;
			}
			if (isHpZeroOrLess) {
				if (isPhisGreaterThanOrEqualToOne) {
					isRebuild = true;
					if (t.coords.Y < waterLevel) {
						recalcTiles.push(t);
						isRecalc = true;
					}
				}
				if (t.door) t.door.die(tip);
				else if (isPhisGreaterThanOrEqualToOne) {
					t.die();
					if (tileSpawn > 0 && Math.random() < tileSpawn) {
						enemySpawn(true, true);
					}
					if (active) {
						grafon.tileDie(t, tip);
					}
				}
			} 
			else if (isPhisGreaterThanOrEqualToOne && active) grafon.dyrka(nx, ny, tip, t.mat, false, hitDivHp);
		}
		
		//уничтожить блок
		public function dieTile(t:Tile):void {
			if (t.indestruct) return;
			if (t.phis==1) {
				if (t.door) { //если это дверь
					t.door.die(4);
				} 				
				isRebuild=true;			//изменить конфигурацию локации				
				if (t.coords.Y < waterLevel) {	//пересчитать воду
					recalcTiles.push(t);
					isRecalc=true;
				}
			}
			if (t.phis>=1) {
				t.die();
				if (active) grafon.tileDie(t,4);
			}
		}
		
		
		//вызывается при любом изменении конфигурации пространства блоков
		private function rebuild():void {
			recalcWater();
			isRebuild = false;
		}
		
		//физика воды		
		private function recalcWater():void {
			var rec:Array=recalcTiles;
			recalcTiles=[];
			isRecalc=false;
			var t:Tile, tl:Tile, tr:Tile, tt:Tile, tb:Tile;
			for (var i in rec) {
				t=rec[i];
				if (t.coords.Y >= waterLevel) continue;
				if (t.phis!=1) {
					tl = getTile(t.coords.X - 1, t.coords.Y);
					tr = getTile(t.coords.X + 1, t.coords.Y);
					tt = getTile(t.coords.X, t.coords.Y - 1);
					tb = getTile(t.coords.X, t.coords.Y + 1);
					if ((tb.phis==1 || tb.water==1) && (tr.phis==1 || tr.water==1) && (tl.phis==1 || tl.water==1) && (tl.water==1 || tr.water==1 || tt.water==1)) {
						t.water=1;
						if (active) grafon.drawWater(t);
					} 
					else {
						if (tl.water>0 && t.phis!=1) {
							tl.water=0;
							recalcTiles.push(tl);
							if (active) grafon.drawWater(tl);
							isRecalc=true;
						}
						if (tr.water>0 && t.phis!=1) {
							tr.water=0;
							recalcTiles.push(tr);
							if (active) grafon.drawWater(tr);
							isRecalc=true;
						}
						if (tt.water>0 && t.phis!=1) {
							tt.water=0;
							recalcTiles.push(tt);
							if (active) grafon.drawWater(tt);
							isRecalc=true;
						}
					}
					t.recalc=false;
				}
			}
			var obj:Entity = firstObj;
			while (obj) {
				if (obj is Obj) (obj as Obj).checkStay();
				obj=obj.nobj;
			}
		}
		
		//проверка на возможность установки призрачной стены, возвращает true если ничего не мешает
		public function testTile(t:Tile):Boolean {
			if (t.phis>0 || t.stair!=0 || t.water!=0 || t.door) return false;
			for each (var cel in units) {
				if (cel==null || (cel as Unit).sost==4) continue;
				if (cel.transT) continue;
				if (!(cel.leftBound >= (t.coords.X + 1) * tileX 
					|| cel.rightBound <= t.coords.X * tileX
					|| cel.topBound >= (t.coords.Y + 1) * tileY
					|| cel.bottomBound <= t.coords.Y * tileY)
					) {
						return false;
				}
			}
			return true;
		}
		
		//прорисовка карты
		public function drawMap(m:BitmapData) {
			var vid:Number=1;
			for (var i:int = 0; i < spaceX; i++) {
				for (var j:int = 0; j < spaceY; j++) {
					var color:uint = 0x003323;
					var t:Tile = getTile(i, j);
					if (t.water) color = 0x0066FF;
					if (t.shelf || t.diagon != 0) color = 0x7B482F;
					if (t.stair != 0) color = 0x666666;
					if (t.phis == 1) {
						if (t.indestruct) color = 0xFFFFFF;
						else if (t.door) color = 0x639104;
						else if (t.hp<100) color = 0x01995A; 
						else color = 0x00FF99;
					}
					if (t.phis == 2) color = 0x01995A; 
					if (!World.w.drawAllMap) {
						vid = getTile(i, j).visi;
						if (i < spaceX - 1) {
							if (getTile(i + 1, j).visi > vid) vid = getTile(i + 1, j).visi;
							if (j < spaceY - 1) {
								if (getTile(i + 1, j + 1).visi > vid) vid = getTile(i + 1, j + 1).visi;
							}
						}
						if (j<spaceY-1) {
							if (getTile(i, j + 1).visi>vid) vid=getTile(i, j + 1).visi;
						}
					}
					color += int(vid * 255) * 0x1000000;
					m.setPixel32((landX - land.minLocX) * World.cellsX + i, (landY - land.minLocY) * World.cellsY + j, color);
				}
			}
			for each (var obj:Obj in objs) {
				if (obj.inter && obj.inter.cont!='' && obj.inter.active) drawMapObj(m, obj, 0xFFCC00);
				if (obj.inter && obj.inter.prob!='' && obj.inter.prob!=null) drawMapObj(m, obj, 0xFF0077);
			}
			for each (obj in acts) {
				if (obj is CheckPoint) drawMapObj(m, obj, 0xFF00FF)
			}
			for each (obj in units) {
				if ((obj as Unit).npc) drawMapObj(m, obj, 0x5500FF);
			}
		}
		
		private function drawMapObj(map:BitmapData, obj:Obj, color:uint):void {
			var worldCellsX:int = World.cellsX;
			var worldCellsY:int = World.cellsY;
			
			var startXIndex:int = (landX - land.minLocX) * worldCellsX;
			var startYIndex:int = (landY - land.minLocY) * worldCellsY;

			var xStart:int	= startXIndex + int(obj.leftBound / tileX + 0.5);
			var xEnd:int	= startXIndex + int(obj.rightBound / tileX - 0.5);
			var yStart:int	= startYIndex + int(obj.topBound / tileY + 0.4);
			var yEnd:int	= startYIndex + int(obj.bottomBound / tileY - 0.5);

			for (var i:int = xStart; i <= xEnd; i++) {
				for (var j:int = yStart; j <= yEnd; j++) {
					map.setPixel(i, j, color);
				}
			}
		}
		
//**************************************************************************************************************************
//
//				Использование
//
//**************************************************************************************************************************
		//команда всем объектам
		public function allAct(emit:Obj, allact:String, allid:String=''):void {
			var obj:Obj;
			for each (obj in objs) {
				if (obj!=emit && obj.inter && (allid=='' || allid==null || obj.inter.allid==allid)) obj.command(allact,'13');
			}
			for each (obj in areas) {
				if (obj!=emit && allid=='' || allid==null || (obj as Area).allid==allid) obj.command(allact);
			}
			for each (obj in units) {
				if (obj!=emit && obj.inter && (allid=='' || allid==null || obj.inter.allid==allid)) obj.command(allact);
			}
		}
		
		//пробуждение всех вокруг
		public function budilo(nx:Number, ny:Number, rad:Number=1000, owner:Unit=null):void {
			var r2:Number = rad * rad * earMult * earMult;

			for each(var un in units) {
				if (un && un != owner && un.sost == 1 && !un.unres) {
					var dx = un.coordinates.X - nx;
					var dy = un.coordinates.Y - ny;
					var delta = rad / 2;
					if (delta > 400) delta = 400;
					if (dx * dx + dy * dy < r2 * un.ear * un.ear) un.alarma(nx+(Math.random()-0.5)*delta,ny+(Math.random()-0.5)*delta);
				}
			}
		}
		
		public function electroCheck():void {
			electroDam = 0;
			for each (var obj in objs) {
				if ((obj is Box) && (obj as Box).electroDam > electroDam && !obj.inter.open) electroDam = (obj as Box).electroDam;
			}
		}
		
		//активировать все ячейки роботов
		public function robocellActivate():void {
			for each(var un in objs) {
				if (un.inter && un.inter.allact=='robocell') un.inter.genRobot();
			}
		}
		
		//включить сигнализацию
		public function signal(n:int=300):void {
			t_alarm = n;
			t_alarmsp = int(n*Math.random() * 0.25 + 0.25);
			if (prob && prob.alarmScript) prob.alarmScript.start(); 
		}

		//включить всё
		public function allon():void {
			color = 'yellow';
			cTransform = colorFilter(color);
			lightOn = 1;
			darkness = -20;
			gg.inLoc(this);
			for each(var obj in units) {
				obj.cTransform = cTransform;
			}
			for each(var obj in objs) {
				obj.cTransform=cTransform;
				if (obj.inter) {
					if (obj.inter.lockTip == '4') obj.inter.setAct('open', 0);
					obj.inter.active = true;
					obj.inter.update();
				}
			}
			for each(var obj in backobjs) {
				obj.onoff(1);
			}
			World.w.redrawLoc();
		}

		//выключить всё
		public function alloff():void {
			color = 'black';
			cTransform = colorFilter(color);
			lightOn = -1;
			darkness = 20;
			gg.inLoc(this);
			for each(var obj in units) {
				obj.cTransform = cTransform;
			}
			for each(var obj in objs) {
				obj.cTransform = cTransform;
			}
			for each(var obj in backobjs) {
				obj.onoff(-1);
			}
			World.w.redrawLoc();
		}
		
		//спавн врага в точке спавна
		public function enemySpawn(one:Boolean=false, getGG:Boolean=false, tipSp:String=null):void {
			if (kolEnSpawn <= 0 || enspawn == null || enspawn.length == 0) return;
			kolEnSpawn--;
			if (!one) t_alarmsp=Math.floor(Math.random()*30);
			var sp:Object=enspawn[Math.floor(Math.random()*enspawn.length)];
			var un:Unit=createUnit((tipSp==null)?tipSpawn:tipSp,sp.x,sp.y,true,null,null,30);

			if (getGG) un.alarma(gg.coordinates.X, gg.coordinates.Y);
			else un.alarma();
		}
		
		//спавн врага из волны
		public function waveSpawn(w:XML, n:int=0, spart:String=null):Unit {
			if (w == null) return null;
			if (enspawn.length == 0) return null;
			var sp:Object = enspawn[n];
			if (sp == null) sp = enspawn[Math.floor(Math.random() * enspawn.length)];
			var un:Unit=createUnit(w.@id,sp.x,sp.y,true,w,w.@cid,30);
			if (spart!=null) Emitter.emit(spart,this,sp.x,sp.y);
			if (un) {
				un.trup = false;
				un.isRes = false;
				un.fraction = 1;
				un.wave = 1;
				un.alarma();
				return un;
			}
			return null;
		}
		
		//устроить трясучку
		public function earthQuake(n:int):void {
			if (quake < n) {
				quake = n;
				World.w.quake(n, n / 4);
			}
		}
		
		public function createHealBonus(nx:Number, ny:Number):void {
			if (World.w.pers.bonusHeal <= 0) return;
			var obj:Bonus = new Bonus(this, 'heal', nx, ny);
			obj.liv = 300;
			obj.val = World.w.pers.bonusHeal * World.w.pers.bonusHealMult;
			if (active) obj.addVisual();
			addObj(obj);
		}
		
		//обработать призрачные стены
		private function gwalls():void {
			var est = false;
			var t:Tile
			for (var i:int = 0; i < spaceX; i++) {
				for (var j:int = 0; j < spaceY; j++) {
					t = getTile(i, j);
					if (t.phis == 3) {
						if (active) {
							t.t_ghost--;
							est = true;
							if (t.t_ghost <= 0) dieTile(t);
						}
						else {
							t.t_ghost = 0;
							dieTile(t);
						}
					}
				}
			}
			if (est) {
				t_gwall = World.fps + 1;
			}
		}
		
		public function lightAll():void {
			for each (var cell:Object in objs) {
				if (cell.light) {
					var adjustedY:Number = cell.coordinates.Y - cell.objectHeight / 2;

					lighting(cell.coordinates.X - 10, adjustedY);
					lighting(cell.coordinates.X, adjustedY);
					lighting(cell.coordinates.X + 10, adjustedY);
				}
			}
		}
		
		public function lighting(nx:int = -10000, ny:int = -10000, dist1:int = -1, dist2:int = -1):void {
			if (!active) return;
			if (dist1 < 0) dist1 = lDist1;
			if (dist2 < 0) dist2 = lDist2;
			if (nx == -10000) {
				nx = gg.coordinates.X  + gg.storona * 12;
				ny = gg.topBound + gg.stayY * 0.247;
			}

			var n1:Number;
			var n2:Number;

			relight_t = 10;

			// Pre-calculate squared distances to avoid square root calculations, done outside the loop to save cycles.
			var dist1Squared:int = dist1 * dist1;
			var dist2Squared:int = dist2 * dist2;

			for (var i:int = 1; i < spaceX; i++) {
				for (var j:int = 1; j < spaceY; j++) {
					var currentTile:Tile = getTile(i, j);
					n1 = currentTile.visi;
					if (!retDark && n1 >= 1) continue;

					var dx:int = i * tileX - nx;
					var dy:int = j * tileY - ny;
					var rasst:int = (dx * dx) + (dy * dy);

					if (rasst >= dist2Squared) {
						if (retDark && currentTile.t_visi > 0) {
							currentTile.t_visi -= 0.025;
							if (currentTile.t_visi < 0) currentTile.t_visi = 0;
							changePixelOpacity(currentTile);
						}
						continue;
					}

					// Revised visibility calculation using squared distances
					if (rasst <= dist1Squared) n2 = 1;
					else n2 = (dist2Squared - rasst) / (dist2Squared - dist1Squared);
					

					if (rasst <= dist2Squared) { //видимость по линии
						var dex:Number, dey:Number, maxe:int;

						var absDx:int = Math.abs(dx); // Pre-calculate these to save cycles.
						var absDy:int = Math.abs(dy);
						if (absDx == absDy) { // Increment and re-calculate only if we have to.
							dy++; 
							absDy = Math.abs(dy);
						}
						if (absDx >= absDy) {
							if (dx > 0) {
								dex = tileX;
								dey = dy / dx * tileY;
							}
							else {
								dex = -tileX;
								dey = -dy / dx * tileY;
							}
							maxe = dx / dex;
						}
						else {
							if (dy > 0) {
								dey = tileY;
								dex = dx / dy * tileX;
							}
							else {
								dey = -tileY;
								dex = -dx / dy * tileX;
							}
							maxe = dy / dey;
						}
						for (var e:int = 1; e <= maxe; e++) {
							var t:Tile = getAbsTile(nx + e * dex, ny + e * dey);
							var opac:Number = t.opac;
							if (opacWater > 0 && t.water > 0 && opacWater > opac) opac = opacWater;
							if (opac > 0) {
								n2 -= opac;
								if (n2 <= 0) {
									n2 = 0;
									break;
								}
							}
						}
					}
					if (n2 > 1) n2 = 1;
					if (n2 > n1 + 0.01) {
						currentTile.t_visi = n2;
						changePixelOpacity(currentTile);
					}
					else if (retDark && n2 < n1 - 0.01) {
						currentTile.t_visi -= 0.025;
						if (currentTile.t_visi < n2) currentTile.t_visi = n2;
						changePixelOpacity(currentTile);
					}
				}
			}

			function changePixelOpacity(tileToChange:Tile):void {
				grafon.lightBmp.setPixel32(i, j + 1, int((1 - tileToChange.updVisi()) * 255) * 0x1000000);
			}
		}
		
		public function lighting2():void {
			if (!active) return;
			relight_t--;
			for (var i:int = 1; i < spaceX; i++) {
				for (var j:int = 1; j < spaceY; j++) {
					var currentTile:Tile = getTile(i, j);
					if (currentTile.visi != currentTile.t_visi) {
						changePixelOpacity(currentTile);
					}
				}
			}

			function changePixelOpacity(tileToChange:Tile):void {
				grafon.lightBmp.setPixel32(i, j + 1, int((1 - tileToChange.updVisi()) * 255) * 0x1000000);
			}
		}
		
		
		//дать опыт
		public function takeXP(dxp:int, nx:Number=-1, ny:Number=-1, un:Boolean=false):void {
			if (un) {
				if (dxp>summXp) {
					dxp=summXp;
					summXp=0;
				}
				else summXp -= dxp;
				land.summXp += dxp;
			}
			if (dxp > 0) {
				World.w.pers.expa(dxp, nx, ny);
			}
		}
		
		
		//обработка за кадром
		public function stepInvis():void {
			var numb=0;
			var obj:Entity = firstObj;
			if (warning > 0) warning--;
			while (obj) {
				nextObj=obj.nobj;
				try {
					obj.step();
				} 
				catch(err) {
					trace('ERROR: (00:29)');
					World.w.showError(err, obj.err());
				}
				obj=nextObj;
				numb++;
				if (numb>10000) {
					trace('alarma');
					break;
				}
			}
			if (isRebuild) rebuild();
			if (isRecalc) recalcWater();
			if (t_gwall==1) gwalls();
			if (t_gwall>0) t_gwall--;
		}
		
		public function step():void {
			gg.step();
			if (prob) prob.step();
			//пройтись по всей цепочке объектов
			var numb=0;
			var obj:Entity = firstObj;
			if (warning>0) warning--;
			while (obj) {
				nextObj=obj.nobj;
				obj.step();

				//определить объект под курсором
				if ((obj is Obj) && (obj as Obj).onCursor>0 && obj!=gg && (celObj==null || (obj as Obj).onCursor>=celObj.onCursor)) celObj=(obj as Obj);
				obj=nextObj;
				
				//нет ли бесконечного цикла
				numb++;
				if (numb>10000) {
					trace('alarma');
					break;
				}
			}
			if (unitCoord && unitCoord.step) unitCoord.step();
			if (celObj && celObj.onCursor<=0) celObj=null;
			if (black) {
				if (gg.velocity.X + gg.osndx > 0.5 || gg.velocity.Y + gg.osndy > 0.5 || gg.velocity.X + gg.osndx < -0.5 || gg.velocity.Y + gg.osndy < -0.5 || isRelight || isRebuild) lighting();
				else if (relight_t > 0) lighting2();
			}
			isRelight=false;
			getDist();
			//если нужно, пересчитать пространство
			if (isRebuild) rebuild();
			if (isRecalc) recalcWater();
			if (t_gwall == 1) gwalls();
			if (t_gwall > 0) t_gwall--;
			//показать/скрыть указатели перехода
			if (sign_vis && World.w.possiblyOut() ||  !sign_vis && !World.w.possiblyOut()) showSign(!sign_vis);
			//тревога
			if (t_alarm > 0) t_alarm--;
			if (t_alarmsp > 0) {
				t_alarmsp--;
				if (t_alarmsp==0) enemySpawn();
			}
			//трясучка
			if (quake > 0) quake--;
			if (trus > 0) World.w.quake(trus / 2, trus);
		}
		
		//убить всех врагов и открыть все контейнеры
		public function getAll():int {
			World.w.summxp=0;
			World.w.pers.expa(unXp*9);
			for each (var un:Unit in units) {
				if (un.fraction!=Unit.F_PLAYER && un.xp>0) un.damage(100000,Unit.D_INSIDE);
			}
			for each (var box:Box in objs) {
				if (box.inter && box.inter.cont) box.inter.loot();
			}
			return World.w.summxp;
		}
		
		public function openAllPrize():void {
			for each (var box:Box in objs) {
				if (box.inter && box.inter.cont && box.inter.prize) box.inter.loot();
			}
		}
		
		
		//дистанция между гг и активным объектом
		private function getDist():void {
			if (getTile(Math.round(World.w.celX/tileX),Math.round(World.w.celY/tileY)).visi<0.1) celObj=null;
			if (celObj) {
				celDist=(gg.coordinates.X - celObj.coordinates.X) * (gg.coordinates.X - celObj.coordinates.X) + (gg.coordinates.Y - celObj.coordinates.Y) * (gg.coordinates.Y - celObj.coordinates.Y);
			} 
			else celDist=-1;
		}
		
		
		//показать/скрыть указатели перехода
		private function showSign(n:Boolean):void {
			for each (var s in signposts) {
				s.visible = n;
			}
			sign_vis = n;
		}
		
		public function newGrenade(g:Bullet):void {
			if (grenades[0] == null) grenades[0] = g;
			else {
				for (var i:int = 1; i < 10; i++) {
					if (grenades[i] == null) grenades[i] = g;
				}
			}
		}

		public function remGrenade(g:Bullet):void {
			if (grenades[0] == g) grenades[0] = null;
			else {
				for (var i:int = 1; i < 10; i++) {
					if (grenades[i] == g) {
						grenades[i] = null;
					}
				}
			}
		}
		
		//сохранить все объекты
		public function saveObjs(arr:Array) {
			for each (var obj:Obj in saves) {
				if (obj.code) {
					arr[obj.code] = obj.save();
				}
			}
		}	
	}	
}
package fe.game.domain.location {

	import flash.geom.ColorTransform;
	import flash.display.MovieClip;
	import flash.display.BitmapData;

	import fe.engine.Settings;
	import fe.engine.text.XMLDataGrabber;
	import fe.game.World;
	import fe.game.GameContainer;
	import fe.engine.utils.SymbolFactory;
	import fe.engine.utils.Vec2;
	import fe.game.rendering.Grafon;
	import fe.game.rendering.Emitter;
	import fe.game.rendering.BackObj;
	import fe.game.rendering.enums.E_Decal;
	import fe.game.domain.entities.Entity;
	import fe.game.domain.entities.Obj;
	import fe.game.domain.projectile.Bullet;
	import fe.game.domain.units.Unit;
	import fe.game.domain.units.Resistances;
	import fe.game.domain.units.UnitPlayer;
	import fe.game.domain.units.Coord;
	import fe.game.domain.serv.LootGen;
	import fe.game.domain.units.UnitTurret;
	import fe.game.domain.location.tile.Tile;
	import fe.game.domain.location.tile.TilePiece_Definition;
	import fe.game.domain.location.tile.TileRegistry;
	import fe.game.domain.units.enums.E_Resistances;
	import fe.game.enums.E_Direction;
	import fe.engine.Engine;
	import fe.game.domain.objects.Bonus;
	import fe.game.domain.objects.Box;
	import fe.game.domain.objects.CheckPoint;
	import fe.game.rendering.ColorFilter;
	import fe.game.domain.location.factories.ObjFactory;
	import fe.game.domain.location.factories.UnitFactory;
	
	public class Location {

		public var land:Level;
		
		public var id:String;
		public var room:Room_Definition;								//связанный шаблон
		public var challenge:Room_Challenge;							//связанное испытание
		
		//рамеры и положение
		public var landX:int			= 0;				//положение локации на местности
		public var landY:int			= 0;
		public var landZ:int			= 0;
		public var challengeId:String		= "";
		public var bindLoc:Location;						//привязанная по координате z
		public var base:Boolean			= false;			//базовый лагерь
		public var train:Boolean		= false;			//полигон
		
		//объекты
		public var grafon:Grafon;
		public var space:Vector.<Tile>;						// The room's tiles row by row: the tile at (x, y) is at y * spaceX + x
		public var defaultTile:Tile;						//пустой блок
		public var units:Vector.<Unit>;						//юниты
		public var ups:Array;								// [Spawn random units]
		public var objs:Vector.<Box>;						// [Boxes]
		public var areas:Vector.<Area>;						//области
		public var acts:Vector.<CheckPoint>;				//активные объекты (отображаемые на карте)
		public var saves:Array;								//объекты, подлежащие сохранению
		public var backobjs:Array;							//фоновые объекты
		public var grenades:Array;							// [Active grenades]
		public var gg:UnitPlayer;
		public var celObj:Obj;
		public var celDist:Number		= -1.00;			//целевой объект и расстояние до него
		public var unitCoord:Coord;							// [object for unit coordination]
		
		// [Entrances and visiting]
		public var spawnPoints:Vector.<Vec2>;				//точки спавна | in tiles
		public var enspawn:Vector.<Vec2>;					//точки спавна врагов | in pixels
		public var signposts:Vector.<MovieClip>;
		public var sign_vis:Boolean = true;					//указатели выхода
		public var nAct:int=0;								//последнее посещение
		public var active:Boolean=false;					//активна в данный момент
		public var visited:Boolean=false;					//посещена
		
		// [Serivce]
		public var cp:CheckPoint;
		public var objsT:Array;								// [Active objects]
		public var recalcTiles:Vector.<Tile>;				// [Count the water]

		//цепочка выполнения
		public var firstObj:Entity;
		public var nextObj:Entity;
		public var lastObj:Entity;
		
		public var isRebuild:Boolean		= false;
		public var isRecalc:Boolean			= false;
		public var isRelight:Boolean		= false;
		public var relight_t:int;

		public var warning:int				=   0;			//имеются опасности типа брошенных гранат
		public var t_gwall:int				=   0;			//имеются призрачные стены
		public var lDist1:int				=  300;			//дистанция открывания тумана войны
		public var lDist2:int				= 1000;		
		public var quake:int				=   0;	
		public var broom:Boolean			= false;		//весь лут поднимется автоматически
		public var isCheck:Boolean			= false;		//была создана контрольная точка, точка выхода или дверь испытаний

		//опции	
		public var noHolesPlace:Boolean		= true;			//убирать контейнеры около проходов
		public var ramka:int				= 0;			//рамка из блоков по периметру 1-весь периметр, 2-только бока, 3-только низ, 4-низ и бока
		public var bezdna:Boolean			= false;		//выход вниз при падении
		public var mirror:Boolean			= false;		//зеркальная комната
		public var endLevel:Boolean			= false;		//комната на последнем уровне локации
		public var sky:Boolean				= false;	
		public var zoom:Number				= 1;	

		//настройки	
		public var gas:int					=   0;			//особая текстура
		public var maxdy:Number				=  20.00;	
		public var rad:Number				=   0.00;		//радиоактивность воздуха и воды
		public var wrad:Number				=   1.00;		
		public var wdam:Number				=   0.00;	
		public var wtipdam:String			=   E_Resistances.DAM_VENOM;	// [water damage]
		public var tipWater:int				=   0;			//внешний вид воды
		public var opacWater:Number			=   0.00;		//непрозрачность воды
		public var waterLevel:int			= 100;			//уровень воды
		public var backWallShape:int		=   0;			// What the back wall covers: 0 the whole room, 1 the sides, 2 the lower part, 3 a strip along the bottom
		public var backwall:String			= "";			//фон задней стены
		public var transparentBack:Boolean	= false;		// Gaps in the back wall show the sky

		public var cTransform:ColorTransform;
		public var cTransformSky:ColorTransform;			// Tints the sky, set from skyColor
		public var color:String;
		public var skyColor:String;							// The sky's tint, by ColorFilter name
		
		public var sndMusic:String			= 'music_0';
		public var postMusic:Boolean		= false;		//музыка не пеключается на боевую
		public var homeStable:Boolean		= false;	
		public var homeAtk:Boolean			= false;	
		public var visMult:Number			= 1.00;
		public var noMap:Boolean			= false;		//карта недоступна
		public var darkness:int				= 0;			// Background darkening
		public var lightOn:int				= 0;			// More than 0, light is on, 0 or less is off

		// Fog of war
		public var black:Boolean			= true;								//	Fog of war is enabled	(Default: True)
		public var retDark:Boolean			= Settings.settings.fogRegenerates;	//	Fog of war returns		(Default: False)
		
		public var levitOn:Boolean			= true;			//самолевитация разрешена
		public var portOn:Boolean			= true;			//телепортация разрешена
		public var petOn:Boolean			= true;			//спутник разрешен
		public var destroyOn:Boolean		= true;			//разрушение стены разрешены
		public var itemsTip:String;							//особый тип лута
		public var electroDam:Number		= 0.00;
		public var trus:Number				= 0.00;			//постоянная тряска
		
		// [Enemies]
		public var tipEnemy:int				= -1;			//тип случайных врагов
		public var kolEn:Array				= [0,6,4,6,4,6]; //количество случайных мелких врагов: 0, мелкий ползучий, обычный, летучий, потолочный, ловушка
		private var tipEn:Array				= ['', 'enl1', 'enl2', 'enf1', 'enc1', 'lov'];
		public var tipSpawn:String			= 'enl2';
		public var kolEnSpawn:int			=  0;			//может заспавнится обычных врагов
		public var tileSpawn:Number			=  0.00;			//спавн при разрушении блоков
		public var kolEnHid:int				=  3;			//скрытых обычных врагов
		public var kol_phoenix:int			=  0;
		
		public var detecting:Boolean		= false;
		public var t_alarm:int				= 0;			//счётчик сигнализации
		public var t_alarmsp:int			= 0;			//счётчик спавна врагов
		
		// [Bonuses and experience]
		public var xpBonuses:Vector.<Bonus>;				// The room's generated XP pickups; taking the last one pays out for the whole set
		public var unXp:int					= 100;
		public var summXp:int				=   0;
		
		// [Difficulty level]
		public var locDifLevel:Number		= 0.00;
		public var biom:int					= 0;
		public var locksLevel:Number		= 0.00;		//уровень замков 0-25
		public var mechLevel:Number			= 0.00;		//уровень мин и механизмов 0-7
		public var weaponLevel:Number		= 0.00;		//уровень случайно выпадающего оружия
		public var enemyLevel:int			= 0;		//левел мобов
		public var earMult:Number			= 1.00; 	//множитель слуха мобов
		
		// Cached tile size in pixels
		private static var tileX:int = Tile.tileX;
		private static var tileY:int = Tile.tileY;

		private const TOP_Y:int				= 0;
		private const LEFT_X:int			= 0;
		private var BOTTOM_Y:int;
		private var RIGHT_X:int;

		// Precomputed for inverse multiplication instead of division 
		private static var INV_TILEX:Number;
		private static var INV_TILEY:Number;

		public var maxX:int;
    	public var maxY:int;
		private var gridWidth:int;		// The tile grid in pixels; maxX and maxY grow past it in zoomed rooms
		private var gridHeight:int;

		public var spaceX:int;	// [Location size in tiles]
		public var spaceY:int;
		public var halfSpaceX:int;
		public var halfSpaceY:int;
		private var spaceLength:int;

		public function Location(land:Level, room:XML, rnd:Boolean, opt:Object=null) {
			this.land		= land;

			spaceX			= GameContainer.cellsX;		// Room width in tiles
			spaceY			= GameContainer.cellsY;		// Room height in tiles

			// Initialize right and bottom bounds based on spaceX and spaceY
			RIGHT_X			= spaceX - 1;
			BOTTOM_Y		= spaceY - 1;

			INV_TILEX		= 1 / tileX;
			INV_TILEY		= 1 / tileY;

			halfSpaceX		= spaceX * 0.50;
			halfSpaceY		= spaceY * 0.50;

			// GetAbsTile uses thse values CONSTANTLY, calculating beforehand. 
			gridWidth = spaceX * tileX;
			gridHeight = spaceY * tileY;
			maxX = gridWidth;					// Screen width in pixels
			maxY = gridHeight;					// Screen height in pixels

			defaultTile = new Tile(-1, -1);		// Use this as a back-up if a tile can't be found

			initializeArrays();
			maxdy = GameContainer.maxdy;

			if (rnd) {
				ramka = 1;
			}
			
			if (opt) {
				if (opt.challenge) ramka=0;
				if (opt.mirror) mirror=true;
				if (opt.water!=null) waterLevel=opt.water;
				if (opt.ramka!=null) ramka=opt.ramka;
				if (ramka==5) backWallShape=1;
				if (ramka==6) backWallShape=2;
				if (opt.backWallShape) backWallShape=opt.backWallShape;
				if (opt.transparentBack) transparentBack=opt.transparentBack;
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
			units		= new Vector.<Unit>();
			ups			= [];
			objs		= new Vector.<Box>();
			acts		= new Vector.<CheckPoint>();
			areas		= new Vector.<Area>();
			saves		= [];
			enspawn		= new Vector.<Vec2>();
			backobjs	= [];
			signposts	= new Vector.<MovieClip>();
			recalcTiles = new Vector.<Tile>();
			spawnPoints	= new Vector.<Vec2>();
			xpBonuses	= new Vector.<Bonus>();
			grenades	= [];
		}

		// добавить гг в массив юнитов
		public function addPlayer(un:UnitPlayer):void {
			gg = un;
			units.push(un);
			units.push(un.defpet);
		}
		
		// [Build from xml map]
		public function buildLoc(nroom:XML):void {
			var tile:Tile;

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
			wtipdam = land.act.wtipdam;
			tipWater=land.act.tipWater;
			color=land.act.color;
			visMult=land.act.visMult;
			opacWater=land.act.opacWater;
			darkness=land.act.darkness;
			
			if (nroom.options.length()) {
				if (nroom.options.@backwall.length()) backwall=nroom.options.@backwall;
				if (nroom.options.@backform.length()) backWallShape=nroom.options.@backform;
				if (nroom.options.@transpfon.length()) transparentBack=true;
				if (nroom.options.@music.length()) sndMusic=nroom.options.@music;
				if (nroom.options.@rad.length()) rad=nroom.options.@rad;
				if (nroom.options.@wrad.length()) wrad=nroom.options.@wrad;
				if (nroom.options.@wtip.length()) tipWater=nroom.options.@wtip;
				if (nroom.options.@wopac.length()) opacWater=nroom.options.@wopac;
				if (nroom.options.@wdam.length()) wdam=nroom.options.@wdam;
				if (nroom.options.@wtipdam.length()) wtipdam=Resistances.parseDamageType(nroom.options.@wtipdam, E_Resistances.DAM_PIERCE);
				if (nroom.options.@bezdna.length()) bezdna=true;
				if (nroom.options.@wlevel.length()) waterLevel=nroom.options.@wlevel;
				if (nroom.options.@base.length()) base=true;
				if (nroom.options.@noblack.length() && !Settings.alwaysFogOfWar) black = false;
				if (nroom.options.@train.length()) train=true;
				if (nroom.options.@color.length()) color=nroom.options.@color;
				if (nroom.options.@colorfon.length()) skyColor=nroom.options.@colorfon;
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
						for (var j:int = 0; j < spaceY; j++) {
							getTile(i, j).visibility = 1;
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

					if (mirror) {
						jis = arri[RIGHT_X - i];
					}
					else {
						jis = arri[i];
					}
						
					if (jis == null) {
						jis = '';
					}
					
					tile = getTile(i, j);
					tile.applyDefinition(TileRegistry.viewDefinition(jis, mirror));

					if (tile.definition.ladderSide != E_Direction.NEUTRAL) { //полочка наверху лестницы
						if (j > 0 && tile.collision == 0 && !tile.platform && tile.definition.ladderSide != getTile(i, j - 1).definition.ladderSide) {
							tile.platform = true;
							tile.ladderTop = true;
						}
					}

					//линия воды
					if (j >= waterLevel) tile.water = 1;
					
					//рамка
					if (i == LEFT_X || i == RIGHT_X || j == TOP_Y || j == BOTTOM_Y) {
						if (ramka == 1
							|| (ramka == 2 || ramka==4) && (i == 0 || i == RIGHT_X)
							|| (ramka == 3 || ramka==4) && (j == BOTTOM_Y)
							|| ramka == 5 && (i <= 10 || i >= 37)
							|| ramka == 6 && j >= 16
							|| ramka == 7 && (i <= 10 || i>=37) && j >= 16
							|| ramka == 8 && (i == RIGHT_X)
							) {
								tile.collision = 1;
						}
						else if (tile.collision >= 1) {
							tile.indestructible = true;
						}
					}
				}
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
			
			if (skyColor) {
				cTransformSky = colorFilter(skyColor);
			}
			
			
			//точки появления активных объектов
			objsT = [];
			for each(var obj:XML in nroom.obj) {
				var xmll:XML = XMLDataGrabber.getNodeWithAttributeThatMatches("core", "AllData", "objs", "id", obj.@id);
				var size:int = xmll.@size;
				
				if (size <= 0) {
					size = 1;
				}
				
				var nx:int = obj.@x;
				var ny:int = obj.@y;
				
				if (mirror) {
					nx = spaceX - nx - size;
				}

				if (xmll.@tip == 'spawnpoint') {
					spawnPoints.push(new Vec2(nx, ny));
				}
				else if (xmll.@tip == 'enspawn') {
					addEnSpawn(nx, ny, xmll);
				}
				else if (xmll.@tip == 'up') {
					var n:int = xmll.@tipn;
					ups[n].push({x:nx, y:ny, xml:obj});
				}
				else {
					objsT.push({id:obj.@id, tip:xmll.@tip, rem:xmll.@rem, x:nx, y:ny, xml:obj});
				}
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
//  [the second stage is to define the passages, make a frame, create objects depending on the complexity and passages]

		// [Add directional signs to neighboring locations]
		public function addSignPost(xCoord:int, yCoord:int, rotation:int):void {
			var sign:MovieClip;
			sign = SymbolFactory.createInstance("signPost") as MovieClip;
			sign.x = xCoord * tileX;
			sign.y = yCoord * tileY;
			sign.rotation = rotation;
			signposts.push(sign);
		}
		
		//добавить точки спавна врагов 
		public function addEnSpawn(xCoord:Number, yCoord:Number, xmll:XML=null):void {
			var point:Vec2 = new Vec2();
			if (xmll) {
				var size:int = xmll.@size;
				
				if (size <= 0) {
					size = 1;
				}
				
				point.X = (xCoord + 0.5 * size) * tileX;
				point.Y = (yCoord + 1.0) * tileY - 1;
			}
			else {
				point.X = xCoord;
				point.Y = yCoord;
			}
			
			enspawn.push(point);
		}
		
		// [Add places where containers should not be (near transitions)]
		public function setNoObj(nx:int, ny:int, dx:int, dy:int):void {
			var i:int;
			if (dx > 0) {
				for (i = nx; i <= nx + dx; i++) {
					getTile(i, ny).canPlaceObjects = false;
				}
			}
			if (dx < 0) {
				for (i = nx + dx; i <= nx; i++) {
					getTile(i, ny).canPlaceObjects = false;
				}
			}
			if (dy > 0) {
				for (i = ny; i <= ny + dy; i++) {
					getTile(nx, i).canPlaceObjects = false;
				}
			}
			if (dy < 0) {
				for (i = ny + dy; i <= ny; i++) {
					getTile(nx, i).canPlaceObjects = false;
				}
			}
		}
		
		
		// [Main frame, call after making passes]
		public function mainFrame():void {
			var border:String = 'A';
			
			if (land && land.act) {
				border = land.act.border;
			}
			
			for (var j:int = 0; j < spaceX; j++) {
				if (getTile(j, TOP_Y).collision >= 1) {
					getTile(j, TOP_Y).mainFrame(border);
				}
				
				if (getTile(j, BOTTOM_Y).collision >= 1) {
					getTile(j, BOTTOM_Y).mainFrame(border);
				}
			}
		
			for (j = 0; j < spaceY; j++) {
				if (getTile(LEFT_X, j).collision >= 1) {
					getTile(LEFT_X, j).mainFrame(border);
				}
				
				if (getTile(RIGHT_X, j).collision >= 1) {
					getTile(RIGHT_X, j).mainFrame(border);
				}
			}
		}
		
		//создать активные объекты в местах их появления, кроме мест около переходов, вызывать после проделывания проходов
		public function setObjects():void {
			for each (var obj:Object in objsT) {
				if (noHolesPlace && obj.rem>0 && !getTile(obj.x, obj.y).canPlaceObjects) {
					continue;	//не ставить ящики около прохода
				}
				
				if (obj.tip=='unit') {
					createUnit(obj.id,obj.x,obj.y, false, obj.xml);
				}
				else {
					createObj(obj.id, obj.tip, obj.x,obj.y, obj.xml);
				}
			}
			
			objsT = null;
			setRandomUnits();
			
			if (land.rnd && GameContainer.reference.pers.modMetal > 0 && Math.random() < GameContainer.reference.pers.modMetal) {
				putRandomLoot();
			}
		}
		
		// [Set the number of random enemies]
		public function setKolEn(en:int, min:int, max:int, spl:int=0):void {
			if (en == -1) {
				kolEnSpawn = min + int(Math.random()*(max-min+1));
			}
			else {
				kolEn[en] = min + int(Math.random() * (max - min + 1));
				if (spl > 0 && Math.random() < 0.2) {
					kolEn[en] += spl;
				}
			}
		}
		
		// [Create random enemies at their spawn points]
		public function setRandomUnits():void {
			for (var i:int = 1; i < kolEn.length; i++) {
				if (kolEn[i] > 0 && ups[i].length) {
					// [Remove points from passages]
					if (noHolesPlace) {
						for (var j:int = 0; j<ups[i].length; j++) {
							if (!getTile( ups[i][j].x, ups[i][j].y ).canPlaceObjects) {
								ups[i].splice(j, 1);
								j--;
							}
						}
					}
					if (ups[i].length > 0) {
						for (var k:int = 0; k < kolEn[i]; k++) {
							var n:int = int(Math.random() * ups[i].length);
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
			// [Add hidden enemies]
			if (kolEnHid > 0 && ups[2].length > 0) {
				for (j = 0; j < kolEnHid; j++) {
					n = int(Math.random() * ups[2].length);
					createHidden(ups[2][n].x, ups[2][n].y);
					
					if (ups[2].length <= 1) {
						break;
					}
					else {
						ups[2].splice(n, 1);
					}
				}
			}
		}
		
		//создать рандомный лут | Loot spawn from (0, 0) to (RIGHT_X - 1, BOTTOM_Y - 1)
		public function putRandomLoot():void {
			var nx:int = int(Math.random() * (RIGHT_X - 1) + 1);
			var ny:int = int(Math.random() * (BOTTOM_Y - 1) + 1);
			
			if (getTile(nx, ny).collision == 0) {
				LootGen.lootCont(this, (nx + 0.5) * tileX, (ny + 0.8) * tileY, 'metal');
			}
		}
		
		//создать юнит, nx,ny-координаты в блоках если abs=false, и в пикселях, если abs=true
		//emerg>0 - плавное появление в течении Х тактов
		public function createUnit(tip:String,nx:int,ny:int,abs:Boolean=false,xml:XML=null,cid:String=null, emerg:int=0):Unit {
			var un:Unit;

			if (tip=='mines') {
				createUnit('mine', nx, ny);
				createUnit('mine', nx + 2, ny);
				createUnit('mine', nx + 4, ny);
				return null;
			}

			un = UnitFactory.createUnit(this, tip, nx, ny, abs, xml, cid);
			if (un != null) registerUnit(un, nx, ny, xml, emerg);
			return un;
		}

		// Adds a newly built unit to this location. nx, ny are the spot it was asked for, where a raided base splashes blood
		private function registerUnit(un:Unit, nx:int, ny:int, xml:XML=null, emerg:int=0):void {
			if (active) {
				un.xp=0;
			}
			else {
				summXp+=un.xp;
			}

			addObj(un);
			units.push(un);

			if (homeAtk && !(un is UnitTurret) && Math.random()<0.5) backobjs.push(new BackObj(this, 'blood1', nx*tileX,(ny-Math.random()*4)*tileY));

			if (xml && xml.@code.length()) saves.push(un);

			//Добавление объектов, имеющих uid в массив
			if (xml && xml.@uid.length()) {
				un.uid=xml.@uid;
				land.uidObjs[un.uid]=un;
			}

			if (emerg>0) un.emergence(emerg);

			un.step();
		}
		
		
		
		//создать скрытый юнит или дополнительный объект
		public function createHidden(nx:int,ny:int):void {
			var hidden:Obj = ObjFactory.createHidden(this, nx, ny);

			if (hidden is Unit) registerUnit(hidden as Unit, nx, ny);
			else if (hidden != null) registerObj(hidden);
		}
		
		//облака газа
		public function createClouds(lvl:int, ncloud:String=null):void {
			for each (var cloud:Box in ObjFactory.createClouds(this, lvl, ncloud)) {
				registerObj(cloud);
			}
		}
		
		
		
		//создать активный объект, nx,ny-координаты в блоках
		public function createObj(id:String,tip:String,nx:int,ny:int,xml:XML=null):Obj {
			var obj:Obj = ObjFactory.createObj(this, id, tip, nx, ny, xml);

			registerObj(obj, xml);
			return obj;
		}

		// Adds a newly built object to this location: its typed list, the save list, script uids, trial doors and the processing chain.
		// xml is the room card it came from, which can put a phoenix, a transmitter or an item on a box
		private function registerObj(obj:Obj, xml:XML=null):void {
			var box:Box;
			var un:Unit;

			if (obj is Box) {
				box = obj as Box;
				objs.push(box);
				if (box.un) units.push(box.un);
				//создать феникса
				if (xml && xml.@ph=='1' && !GameContainer.reference.game.triggers['pet_phoenix']) addPhoenix(box);
				if (xml && xml.@transm=='1') {
					un = UnitFactory.createTransmitter(this, box);
					if (un) {
						addObj(un);
						units.push(un);
					}
				}
				if (land.rnd && land.act.biom==0 && !GameContainer.reference.game.triggers['pet_phoenix'] && kol_phoenix==0 && land.kol_phoenix<3 && Math.random()<0.02) {
					addPhoenix(box);
				}
				if (box.sur && land.rnd) ObjFactory.createSur(this, box);
				if (!land.rnd && xml && xml.@sur.length()) ObjFactory.createSur(this, box, xml.@sur);
				if (box.electroDam>electroDam && !box.inter.open) electroDam=box.electroDam;
			}
			else if (obj is CheckPoint) {
				acts.push(obj as CheckPoint);
			}
			else if (obj is Area) {
				areas.push(obj as Area);
			}
			if (obj.code != null) {
				saves.push(obj);
				if (obj is CheckPoint && !land.rnd) {	//сохранённая контрольная точка
					if (GameContainer.reference.pers.currentCPCode!=null && obj.code==GameContainer.reference.pers.currentCPCode || GameContainer.reference.pers.prevCPCode!=null && obj.code==GameContainer.reference.pers.prevCPCode || land.act.lastCpCode==obj.code) {
						land.currentCP=obj as CheckPoint;
					}
				}
			}
			//Добавление объектов, имеющих uid в массив
			if (obj.uid != null) land.uidObjs[obj.uid]=obj;
			//Добавление id испытаний
			if (challengeId=='' && obj.inter && obj.inter.challengeId) land.challengeIds.push(obj.inter.challengeId);
			addObj(obj);
		}

		//создать феникса, сидящего на ящике
		private function addPhoenix(box:Box):void {
			var un:Unit = UnitFactory.createPhoenix(this, box);

			if (un == null) return;
			addObj(un);
			units.push(un);
			kol_phoenix++;
			land.kol_phoenix++;
		}
		
		// [Creating a checkpoint at a random spawn point]
		public function createCheck(act:Boolean=false):void {
			var checkPoint:CheckPoint = ObjFactory.createCheck(this, act);

			if (checkPoint == null) return;
			registerObj(checkPoint);
			cp = checkPoint;
			if (act) cp.activate(true);
			isCheck=true;
		}

		// [Creating an exit at a random spawn point]
		public function createExit(s:String = ''):void {
			var exit:Box = ObjFactory.createExit(this, s);

			if (exit == null) return;
			registerObj(exit);
			isCheck = true;
		}

		//создание двери испытаний в случайной точке появления
		public function createDoorChallenge(nid:String, challengeId:String):Boolean {
			var door:Box = ObjFactory.createDoorChallenge(this, nid, challengeId);

			if (door == null) return false;
			registerObj(door);
			isCheck=true;
			return true;
		}
		
		// How many of the room's generated XP pickups are still waiting to be taken
		public function xpBonusesLeft():int {
			var left:int = 0;

			for each (var bonus:Bonus in xpBonuses) {
				if (bonus.sost == 1) left++;
			}
			return left;
		}
		
		public function createXpBonuses(kol:int=5):void {
			if (homeStable || homeAtk) return;
			xpBonuses = ObjFactory.createXpBonuses(this, kol);
			for each (var bonus:Bonus in xpBonuses) {
				registerObj(bonus);
			}
		}
		
		public function preStep():void {
			for (var i:int = 0; i < 30; i++) stepInvis();
		}
		
//**************************************************************************************************************************
//
//				[Activation]
//
//**************************************************************************************************************************
		
		//активировать при входе гг в локацию
		public function reactivate(n:int = 0):void {
			var obj:Entity = firstObj;
			while (obj) {
				nextObj=obj.nobj;
				obj.setNull(n-nAct>2 || n==0 || challenge &&!challenge.closed);
				obj=nextObj;
			}
			resetUnits();
			if (n>0) nAct=n;
			showSign(false);
			active=true;
			visited=true;
			warning=0;
			if (challenge) challenge.over();
		}
		
		// Create a new list of units by removing an units that are no longer active
		public function resetUnits():void {
			var filteredUnits:Vector.<Unit> = new Vector.<Unit>();
			for each (var unit:Unit in units) {
				if (isAct(unit)) {
					filteredUnits.push(unit);
				}
			}
			units = filteredUnits;
		}
		
		// Check if a unit is still active
		private function isAct(unit:Unit):Boolean {
			if (unit == null) return false;
			if (unit is fe.game.domain.units.UnitPet) return true;
			return (unit.sost < 4);
		}
		
		//деактивировать локацию
		public function out():void {
			active=false;
			for each (var un:Unit in units) {
				un.locout();
			}
			if (challenge) challenge.out();
		}
		
//**************************************************************************************************************************
//
//				[Processing chain]
//
//**************************************************************************************************************************
		
		// [Add any object to the processing chain] (Bullets, )
		public function addObj(obj:Entity):void {
			if (obj.in_chain) return;
			if (firstObj) {
				lastObj.nobj = obj;
				obj.pobj = lastObj;
			}
			else firstObj = obj;
			obj.nobj = null;
			lastObj = obj;
			obj.in_chain = true;
			if (active) obj.addVisual();
		}
		
		//удалить объект из цепочки обработки
		public function remObj(obj:Entity):void {
			if (!obj.in_chain) return;

			if (obj.nobj) obj.nobj.pobj = obj.pobj;
			else lastObj = obj.pobj;

			if (obj.pobj) obj.pobj.nobj = obj.nobj;
			else firstObj = obj.nobj;

			obj.in_chain = false;
			obj.nobj = obj.pobj = null;
			obj.remVisual();
		}
		
//**************************************************************************************************************************
//
//				[Working with tile space]
//
//**************************************************************************************************************************
		
		public function initializeSpace():void {
			space = new Vector.<Tile>(spaceX * spaceY, true);
			for (var j:int = 0; j < spaceY; j++) { // Iterate rows (y)
				for (var i:int = 0; i < spaceX; i++) { // Iterate columns (x)
					space[j * spaceX + i] = new Tile(i, j);
				}
			}

			// Precompute space length
			spaceLength = space.length;
		}

		// Returns a Tile from a room using (X, Y) coordinates
		public function getTile(nx:int, ny:int):Tile {
			// Cache for speed
			const sX:int = spaceX;
			const sY:int = spaceY;
			
			if (nx < 0 || nx >= sX || ny < 0 || ny >= sY) {
				return defaultTile;
			}
			
			// Row-Major Indexing: index = y * width + x
			const index:int = ny * sX + nx;
			return space[index];
		}

		public function getAbsTile(nx:int, ny:int):Tile {
			// Cache for speed
			const mX:int = gridWidth;
			const mY:int = gridHeight;
			
			// Do inverse multiplication instead of division
			const invTileX:Number = INV_TILEX; // 0.025
			const invTileY:Number = INV_TILEY; // 0.025
			
			if (nx < 0 || nx >= mX || ny < 0 || ny >= mY) {
				return defaultTile;
			}
			
			const tileXIndex:int = int(nx * invTileX);
			const tileYIndex:int = int(ny * invTileY);
			const index:int = tileYIndex * spaceX + tileXIndex; // Row-Major
			
			return space[index];
		}

		public function collisionUnit(X:Number, Y:Number, objectWidth:Number=0, objectHeight:Number=0):Boolean {
			// Precompute bounds
			var halfWidth:Number = objectWidth / 2;
			var leftBound:int = Math.floor((X - halfWidth) / tileX);
			var rightBound:int = Math.floor((X + halfWidth) / tileX);
			var topBound:int = Math.floor((Y - objectHeight) / tileY);
			var bottomBound:int = Math.floor(Y / tileY);

			// Clamp bounds to valid tile indices
			var startI:int = Math.max(leftBound, LEFT_X);
			var endI:int = Math.min(rightBound, spaceX - 1);
			var startJ:int = Math.max(topBound, TOP_Y);
			var endJ:int = Math.min(bottomBound, spaceY - 1);

			// Iterate over tiles
			for (var i:int = startI; i <= endI; i++) {
				var indexBase:int = i;
				for (var j:int = startJ; j <= endJ; j++) {
					var index:int = j * spaceX + i;

					// Bounds check to prevent out-of-range access
					if (index < 0 || index >= spaceLength) continue;

					var tile:Tile = space[index];

					if (tile.collision > 0) {
						return true; // Collision detected
					}
				}
			}

			return false; // No collision detected
		}

		// [try to lay a line. obj - the door to be ignored]
		// Move as much calculation as possible outside the loop
		public function isLine(nx:Number, ny:Number, cx:Number, cy:Number, obj:Obj=null):Boolean {
			var ndx:Number = cx - nx;
			var ndy:Number = cy - ny;
			var div:int = int(Math.max(Math.abs(ndx), Math.abs(ndy)) / GameContainer.maxdelta) + 1;

			var deltaX:Number = ndx / div;
			var deltaY:Number = ndy / div;

			for (var i:int = 1; i < div; i++) {
				var currentX:Number = nx + deltaX * i;
				var currentY:Number = ny + deltaY * i;

				var t:Tile = World.w.loc.getAbsTile(int(currentX), int(currentY));

				if (t.collision == 1 && t.boundingBox.intersectsPoint(currentX, currentY)) {
					if (obj == null || t.door != obj) {
						return false;
					}
				}
			}
			return true;
		}
	
		// [tile outlines]
		public function tileKontur(tx:int, ty:int, t:Tile):void {
			var a0:Boolean,a1:Boolean,a2:Boolean,a3:Boolean,a4:Boolean,a5:Boolean,a6:Boolean,a7:Boolean;
			if (t.collision==1) {
				a0=uslKontur(tx-1,ty-1);
				a1=uslKontur(tx,  ty-1);
				a2=uslKontur(tx+1,ty-1);
				a3=uslKontur(tx+1,ty);
				a4=uslKontur(tx+1,ty+1);
				a5=uslKontur(tx,  ty+1);
				a6=uslKontur(tx-1,ty+1);
				a7=uslKontur(tx-1,ty);
				t.mainOutline1=insKontur(a1,a7,a0);
				t.mainOutline2=insKontur(a1,a3,a2);
				t.mainOutline3=insKontur(a5,a7,a6);
				t.mainOutline4=insKontur(a5,a3,a4);
				// Differs from vanilla, which read an unassigned local here and so set back outlines on every solid tile
				if (t.definition.wall) {
					if (!a1) a1=uslPontur(tx, ty-1);
					if (!a3) a3=uslPontur(tx+1,ty);
					if (!a5) a5=uslPontur(tx, ty+1);
					if (!a7) a7=uslPontur(tx-1,ty);
					t.backOutline1=insKontur(a1,a7,a0);
					t.backOutline2=insKontur(a1,a3,a2);
					t.backOutline3=insKontur(a5,a7,a6);
					t.backOutline4=insKontur(a5,a3,a4);
				}
			} 
			else {
				var wall:TilePiece_Definition=t.definition.wall;
				var vse:Boolean=(backwall=='sky');
				a0=uslBontur(tx-1,ty-1, wall, vse);
				a1=uslBontur(tx,  ty-1, wall, vse);
				a2=uslBontur(tx+1,ty-1, wall, vse);
				a3=uslBontur(tx+1,ty, wall, vse);
				a4=uslBontur(tx+1,ty+1, wall, vse);
				a5=uslBontur(tx,  ty+1, wall, vse);
				a6=uslBontur(tx-1,ty+1, wall, vse);
				a7=uslBontur(tx-1,ty, wall, vse);
				t.backOutline1=insKontur(a1,a7,a0);
				t.backOutline2=insKontur(a1,a3,a2);
				t.backOutline3=insKontur(a5,a7,a6);
				t.backOutline4=insKontur(a5,a3,a4);
			}
		}
		
		private function insKontur(a:Boolean, b:Boolean, c:Boolean):int {
			if (a && b) return c?0:1;
			else if (!a && b) return 2;
			else if (a && !b) return 3;
			else return 4;
		}
		
		// [Foreground contours]
		private function uslKontur(nx:int,ny:int):Boolean {
			var tile:Tile;
			if (nx < LEFT_X || nx >= spaceX || ny < TOP_Y || ny >= spaceY) return true;
			tile = space[ny * spaceX + nx];
			return (tile.collision == 1 || tile.door != null);
		}

		// [Background contours if there is a wall]
		private function uslPontur(nx:int,ny:int):Boolean {
			var tile:Tile;
			if (nx < LEFT_X || nx >= spaceX || ny < TOP_Y || ny >= spaceY) return true;
			tile = space[ny * spaceX + nx];
			return (tile.definition.wall != null || tile.platform);
		}
		// [Background contours if there is no wall]
		private function uslBontur(nx:int,ny:int,wall:TilePiece_Definition,vse:Boolean=false):Boolean {
			var tile:Tile;
			if (nx < LEFT_X || nx >= spaceX || ny < TOP_Y || ny >= spaceY) return true;
			tile = space[ny * spaceX + nx];
			return (tile.definition.wall == wall || vse && tile.definition.wall != null || tile.collision == 1 || tile.platform);
		}
		
		// [Tile damage]
		public function hitTile(t:Tile, hit:int, nx:int, ny:int, tip:int):void {
			var hasCollision:Boolean = t.collision >= 1;

			if (tip == E_Decal.STOMP && hit <= 50 && (t.damageThreshold > 0 || t.indestructible)) return;
			if (tip == E_Decal.STOMP) tip = E_Decal.BLOW_SMALL;

			var hitDivHp:Number = hit / t.hp;

			if (!destroyOn && t.hp > 500) {
				if (active && hasCollision) grafon.dyrka(nx, ny, tip, t.material, true, hitDivHp);
				return;
			}
			if (!t.udar(hit)) {
				if (hasCollision && active) grafon.dyrka(nx, ny, tip, t.material, true, hitDivHp);
				return;
			}
			var isHpZeroOrLess:Boolean = t.hp <= 0;
			if (isHpZeroOrLess) {
				if (hasCollision) {
					isRebuild = true;
					isRelight = true;
					if (t.coords.Y < waterLevel) {
						recalcTiles.push(t);
						isRecalc = true;
					}
				}
				if (t.door) t.door.die(tip);
				else if (hasCollision) {
					t.die();
					if (tileSpawn > 0 && Math.random() < tileSpawn) {
						enemySpawn(true, true);
					}
					if (active) {
						grafon.tileDie(t, tip);
					}
				}
			} 
			else if (hasCollision && active) grafon.dyrka(nx, ny, tip, t.material, false, hitDivHp);
		}
		
		// [Destroy the tile]
		public function dieTile(t:Tile):void {
			if (t.indestructible) return;
			if (t.collision==1) {
				if (t.door) { //если это дверь
					t.door.die(E_Decal.BLOW_SMALL);
				} 				
				isRebuild=true;			//изменить конфигурацию локации				
				isRelight = true;
				if (t.coords.Y < waterLevel) {	//пересчитать воду
					recalcTiles.push(t);
					isRecalc=true;
				}
			}
			if (t.collision>=1) {
				t.die();
				if (active) grafon.tileDie(t, E_Decal.BLOW_SMALL);
			}
		}
		
		
		//вызывается при любом изменении конфигурации пространства блоков
		private function rebuild():void {
			recalcWater();
			isRebuild = false;
		}
		
		//физика воды		
		private function recalcWater():void {
			// Copy tiles to be processed
			var rec:Vector.<Tile> = recalcTiles;
			// Clear where we were holding them
			recalcTiles = new Vector.<Tile>();
			// Mark as not needing updated
			isRecalc = false;
			
			var t:Tile;		// The tile being processed
			var tl:Tile;	// The tile to the left
			var tr:Tile;	// The tile to the right
			var tt:Tile;	// The tile below
			var tb:Tile;	// The tile above
			
			for each (t in rec) {
				if (t.coords.Y >= waterLevel) continue;
				if (t.collision != 1) {
					tl = getTile(t.coords.X - 1, t.coords.Y);
					tr = getTile(t.coords.X + 1, t.coords.Y);
					tt = getTile(t.coords.X, t.coords.Y - 1);
					tb = getTile(t.coords.X, t.coords.Y + 1);
					
					if ((tb.collision == 1 || tb.water == 1) && 
						(tr.collision == 1 || tr.water == 1) && 
						(tl.collision == 1 || tl.water == 1) && 
						(tl.water == 1 || tr.water == 1 || tt.water == 1)) {
						
						t.water = 1;
						if (active) grafon.drawWater(t);
					}
					else {
						if (tl.water > 0 && t.collision != 1) {
							tl.water = 0;
							recalcTiles.push(tl);
							if (active) grafon.drawWater(tl);
							isRecalc = true;
						}
						if (tr.water > 0 && t.collision != 1) {
							tr.water = 0;
							recalcTiles.push(tr);
							if (active) grafon.drawWater(tr);
							isRecalc = true;
						}
						if (tt.water > 0 && t.collision != 1) {
							tt.water = 0;
							recalcTiles.push(tt);
							if (active) grafon.drawWater(tt);
							isRecalc = true;
						}
					}
				}
			}
			
			var obj:Entity = firstObj;
			while (obj) {
				if (obj is Obj) (obj as Obj).checkStay();
				obj = obj.nobj;
			}
		}
		
		// [check for the possibility of installing a ghost wall, returns true if nothing interferes]
		public function testTile(t:Tile):Boolean {
			if (t.collision > 0 || t.definition.ladderSide != E_Direction.NEUTRAL || t.water != 0 || t.door) {
				return false;
			}

			for each (var cel:Unit in units) {
				if (cel == null || (cel as Unit).sost == 4) {
					continue;
				}
				
				if (cel.transT) {
					continue;
				}
				
				if (!(cel.boundingBox.left >= (t.coords.X + 1) * tileX
					|| cel.boundingBox.right <= t.coords.X * tileX
					|| cel.boundingBox.top >= (t.coords.Y + 1) * tileY
					|| cel.boundingBox.bottom <= t.coords.Y * tileY)
					) {
						return false;
				}
			}
			return true;
		}
		
//**************************************************************************************************************************
//
//				[Usage]
//
//**************************************************************************************************************************
		
		// [Command to all objects]
		public function allAct(emit:Obj, allact:String, allid:String = ""):void {
			var obj:Obj;
			var area:Area;
			for each (obj in objs) {
				if (obj != emit && obj.inter && (allid == "" || allid == null || obj.inter.allid == allid)) {
					obj.command(allact, "13");
				}
			}
			
			for each (area in areas) {
				// Unbracketed as in vanilla: with an allid set, the emitting area also receives its own command; the maps were authored against this
				if (area != emit && allid == "" || allid == null || area.allid == allid) {
					area.command(allact);
				}
			}
			
			for each (obj in units) {
				if (obj!=emit && obj.inter && (allid == "" || allid == null || obj.inter.allid == allid)) {
					obj.command(allact);
				}
			}
		}
		
		// [Awakening everyone around]
		public function budilo(nx:Number, ny:Number, rad:Number = 1000, owner:Unit=null):void {
			var r2:Number = rad * rad * earMult * earMult;

			for each(var un:Unit in units) {
				if (un && un != owner && un.sost == 1 && !un.unres) {
					var dx:Number = un.coordinates.X - nx;
					var dy:Number = un.coordinates.Y - ny;
					var delta:Number = rad * 0.50;
					
					if (delta > 400) {
						delta = 400;
					}
					
					if (dx * dx + dy * dy < r2 * un.ear * un.ear) {
						un.alarma(nx + (Math.random() - 0.50) * delta, ny + (Math.random() - 0.50) * delta);
					}
				}
			}
		}
		
		public function electroCheck():void {
			electroDam = 0;
			
			for each (var obj:Obj in objs) {
				if ((obj is Box) && (obj as Box).electroDam > electroDam && !obj.inter.open) {
					electroDam = (obj as Box).electroDam;
				}
			}
		}
		
		//активировать все ячейки роботов
		public function robocellActivate():void {
			for each(var un:Obj in objs) { // 'un' is being called as a Box
				if (un.inter && un.inter.allact == 'robocell') {
					un.inter.genRobot();
				}
			}
		}
		
		//включить сигнализацию
		public function signal(n:int = 300):void {
			t_alarm = n;
			t_alarmsp = int(n*Math.random() * 0.25 + 0.25);
			
			if (challenge && challenge.alarmScript) {
				challenge.alarmScript.start();
			}
		}

		//включить всё
		public function allon():void {
			color = 'yellow';
			cTransform = colorFilter(color);
			lightOn = 1;
			darkness = -20;
			gg.inLoc(this);
			
			for each(var un:Unit in units) {
				un.cTransform = cTransform;
			}
			
			for each(var obj:Obj in objs) {
				obj.cTransform=cTransform;
				
				if (obj.inter) {
					if (obj.inter.lockTip == 4) obj.inter.setAct('open', 0);
					obj.inter.active = true;
					obj.inter.update();
				}
			}
			
			for each(var backobj:BackObj in backobjs) {
				backobj.onoff(1);
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
			
			for each(var un:Unit in units) {
				un.cTransform = cTransform;
			}
			
			for each(var obj:Obj in objs) {
				obj.cTransform = cTransform;
			}
			
			for each(var backobj:BackObj in backobjs) {
				backobj.onoff(-1);
			}
			
			World.w.redrawLoc();
		}
		
		//спавн врага в точке спавна
		public function enemySpawn(one:Boolean=false, getGG:Boolean=false, tipSp:String=null):void {
			if (kolEnSpawn <= 0 || enspawn == null || enspawn.length == 0) {
				return;
			}
			
			kolEnSpawn--;
			
			if (!one) {
				t_alarmsp = Math.floor(Math.random() * 30);
			}
			
			var sp:Vec2 = enspawn[int(Math.random() * enspawn.length)];
			var un:Unit = createUnit((tipSp == null) ? tipSpawn : tipSp, sp.X, sp.Y, true, null, null, 30);

			if (getGG) {
				un.alarma(gg.coordinates.X, gg.coordinates.Y);
			}
			else {
				un.alarma();
			}
		}
		
		//спавн врага из волны
		public function waveSpawn(w:XML, n:int=0, spart:String=null):Unit {
			if (w == null || enspawn.length == 0) {
				return null;
			}
			
			var sp:Vec2;
			
			// A wave index past the spawn points picks one at random
			if (n >= 0 && n < enspawn.length) {
				sp = enspawn[n];
			}
			else {
				sp = enspawn[int(Math.random() * enspawn.length)];
			}
			
			var un:Unit = createUnit(w.@id, sp.X, sp.Y, true, w, w.@cid, 30);
			
			if (spart != null) {
				Emitter.emit(spart,this,sp.X,sp.Y);
			}
			
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
		
		// [Arrange a shake-up]
		public function earthQuake(n:int):void {
			if (quake < n) {
				quake = n;
				World.w.quake(n, n * 0.25);
			}
		}
		
		public function createHealBonus(nx:Number, ny:Number):void {
			var bonus:Bonus = ObjFactory.createHealBonus(this, nx, ny);

			if (bonus) addObj(bonus);
		}
		
		//обработать призрачные стены
		private function gwalls():void {
			var est:Boolean = false;
			var t:Tile
			
			for (var i:int = 0; i < spaceX; i++) {
				for (var j:int = 0; j < spaceY; j++) {
					t = getTile(i, j);
					if (t.collision == 3) {
						if (active) {
							t.ghostTimer--;
							est = true;
							if (t.ghostTimer <= 0) dieTile(t);
						}
						else {
							t.ghostTimer = 0;
							dieTile(t);
						}
					}
				}
			}
			
			if (est) {
				t_gwall = Engine.TPS + 1;
			}
		}
		
		public function lightAll():void {
			for each (var cell:Object in objs) {
				if (cell.light) {
					var adjustedY:Number = cell.coordinates.Y - cell.boundingBox.halfHeight;

					lighting(cell.coordinates.X - 10, adjustedY);
					lighting(cell.coordinates.X, adjustedY);
					lighting(cell.coordinates.X + 10, adjustedY);
				}
			}
		}

		public function lighting(nx:int = -10000, ny:int = -10000):void {
			var lightX:int = nx;
			var lightY:int = ny;
			var dist1Squared:int = lDist1 * lDist1;
			var dist2Squared:int = lDist2 * lDist2;
			var invDistDiff:Number = 1.0 / (dist2Squared - dist1Squared);

			// Cache frequently accessed properties
			var fogReturns:Boolean = retDark;
			var opacWaterCache:Number = opacWater;
			var spaceRef:Vector.<Tile> = space;
			var spaceXCache:int = spaceX;
			var spaceYCache:int = spaceY;
			var tileXCache:int = tileX;
			var tileYCache:int = tileY;
			var invTileX:Number = INV_TILEX;
			var invTileY:Number = INV_TILEY;
			var mX:int = gridWidth;
			var mY:int = gridHeight;

			var lightBmpRef:BitmapData;
			var i:int;
			var j:int;
			var e:int;
			var row:int;
			var rowDy:int;
			var rowDySquared:int;
			var index:int;
			var stepIndex:int;
			var currentTile:Tile;
			var stepTile:Tile;
			var n1:Number;
			var n2:Number;
			var cutoff:Number;
			var fadedVisibility:Number;
			var dx:int;
			var dy:int;
			var absDx:int;
			var absDy:int;
			var rasst:int;
			var dex:Number;
			var dey:Number;
			var maxe:int;
			var absNx:int;
			var absNy:int;
			var opac:Number;
			var pixelValue:int;

			if (!active) { return; }

			if (nx == -10000) {
				lightX = gg.coordinates.X + gg.storona.X * 12;
				lightY = gg.boundingBox.top + int(gg.height * 0.247);
			}

			relight_t = 10;
			lightBmpRef = grafon.lightBmp;
			lightBmpRef.lock();

			for (j = 1; j < spaceYCache; j++) {
				row = j * spaceXCache;
				rowDy = j * tileYCache - lightY;
				rowDySquared = rowDy * rowDy;

				for (i = 1; i < spaceXCache; i++) {
					index = row + i;
					currentTile = spaceRef[index];
					n1 = currentTile.visibility;

					if (!fogReturns && n1 >= 1.0) { continue; }

					dx = i * tileXCache - lightX;
					dy = rowDy;
					rasst = dx * dx + rowDySquared;

					// Out of reach: returning fog slowly covers the tile again
					if (rasst >= dist2Squared) {
						if (fogReturns && currentTile.targetVisibility > 0.0) {
							fadedVisibility = currentTile.targetVisibility - 0.025;
							currentTile.targetVisibility = (fadedVisibility > 0.0) ? fadedVisibility : 0.0;
							pixelValue = int((1.0 - currentTile.updVisi()) * 255.0) << 24;
							lightBmpRef.setPixel32(i, j + 1, pixelValue);
						}
						continue;
					}

					// Fully visible within dist1, fading out toward dist2
					n2 = (rasst <= dist1Squared) ? 1.0 : (dist2Squared - rasst) * invDistDiff;

					// A ray that drops to the cutoff counts as blocked -- it can't go below zero, and without returning fog only a result brighter than the tile gets drawn
					cutoff = fogReturns ? 0.0 : n1 + 0.01;

					if (n2 > cutoff) {
						absDx = (dx >= 0) ? dx : -dx;
						absDy = (dy >= 0) ? dy : -dy;

						if (absDx == absDy) {
							dy++;
							absDy = (dy >= 0) ? dy : -dy;
						}

						// Walk from the light toward the tile, one tile's width at a time along the longer axis
						if (absDx >= absDy) {
							if (dx > 0) {
								dex = tileXCache;
								dey = (dy / dx) * tileYCache;
							}
							else {
								dex = -tileXCache;
								dey = (-dy / dx) * tileYCache;
							}
							maxe = dx / dex;
						}
						else {
							if (dy > 0) {
								dey = tileYCache;
								dex = (dx / dy) * tileXCache;
							}
							else {
								dey = -tileYCache;
								dex = (-dx / dy) * tileXCache;
							}
							maxe = dy / dey;
						}

						for (e = 1; e <= maxe; e++) {
							absNx = lightX + e * dex;
							absNy = lightY + e * dey;
							if (absNx < 0 || absNx >= mX || absNy < 0 || absNy >= mY) { continue; }

							stepIndex = int(absNy * invTileY) * spaceXCache + int(absNx * invTileX);
							stepTile = spaceRef[stepIndex];
							opac = stepTile.opacity;
							if (opacWaterCache > opac && stepTile.water > 0) {
								opac = opacWaterCache;
							}

							if (opac > 0.0) {
								n2 -= opac;
								if (n2 <= cutoff) {
									n2 = 0.0;
									break;
								}
							}
						}
					}

					if (n2 > n1 + 0.01) {
						currentTile.targetVisibility = n2;
						pixelValue = int((1.0 - currentTile.updVisi()) * 255.0) << 24;
						lightBmpRef.setPixel32(i, j + 1, pixelValue);
					}
					else if (fogReturns && n2 < n1 - 0.01) {
						fadedVisibility = currentTile.targetVisibility - 0.025;
						currentTile.targetVisibility = (fadedVisibility > n2) ? fadedVisibility : n2;
						pixelValue = int((1.0 - currentTile.updVisi()) * 255.0) << 24;
						lightBmpRef.setPixel32(i, j + 1, pixelValue);
					}
				}
			}

			lightBmpRef.unlock();
		}

		public function lighting2():void {
			var spaceRef:Vector.<Tile> = space;
			var spaceXCache:int = spaceX;
			var spaceYCache:int = spaceY;
			var lightBmpRef:BitmapData;
			var i:int;
			var j:int;
			var row:int;
			var index:int;
			var currentTile:Tile;
			var pixelValue:int;

			if (!active) { return; }

			relight_t--;
			lightBmpRef = grafon.lightBmp;
			lightBmpRef.lock();

			for (j = 1; j < spaceYCache; j++) {
				row = j * spaceXCache;
				for (i = 1; i < spaceXCache; i++) {
					index = row + i;
					currentTile = spaceRef[index];
					if (currentTile.visibility != currentTile.targetVisibility) {
						pixelValue = int((1.0 - currentTile.updVisi()) * 255.0) << 24;
						lightBmpRef.setPixel32(i, j + 1, pixelValue);
					}
				}
			}

			lightBmpRef.unlock();
		}
		//дать опыт
		public function takeXP(dxp:int, nx:Number=-1, ny:Number=-1, un:Boolean=false):void {
			if (un) {
				if (dxp>summXp) {
					dxp=summXp;
					summXp=0;
				}
				else {
					summXp -= dxp;
				}

				land.summXp += dxp;
			}
			if (dxp > 0) {
				GameContainer.reference.pers.expa(dxp, nx, ny);
			}
		}
		
		
		// [Behind the scenes processing]
		public function stepInvis():void {
			var numb:int = 0;
			var obj:Entity = firstObj;
		
			if (warning > 0) warning--;
		
			while (obj) {
				nextObj=obj.nobj;
				
				try {
					obj.step();
				} 
				catch(err:Error) {
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
			
			if (isRebuild) {
				rebuild();
			}
			
			if (isRecalc) {
				recalcWater();
			}
			
			if (t_gwall == 1) {
				gwalls();
			}
			
			if (t_gwall > 0) {
				t_gwall--;
			}
		}
		
		public function step():void {
			gg.step();
			
			if (challenge) {
				challenge.step();
			}
			
			//пройтись по всей цепочке объектов
			var numb:int = 0;
			var obj:Entity = firstObj;
			
			if (warning > 0) {
				warning--;
			}
			
			while (obj) {
				nextObj=obj.nobj;
				obj.step();

				//определить объект под курсором
				if ((obj is Obj) && (obj as Obj).onCursor>0 && obj!=gg && (celObj==null || (obj as Obj).onCursor>=celObj.onCursor)) {
					celObj=(obj as Obj);
				}

				obj=nextObj;
				
				//нет ли бесконечного цикла
				numb++;
				if (numb>10000) {
					trace('alarma');
					break;
				}
			}
			
			if (unitCoord && unitCoord.step != null) {
				unitCoord.step();
			}
			
			if (celObj && celObj.onCursor <= 0) celObj = null;
			
			if (black) {
				if (gg.velocity.X + gg.osndx > 0.5 || gg.velocity.Y + gg.osndy > 0.5 || gg.velocity.X + gg.osndx < -0.5 || gg.velocity.Y + gg.osndy < -0.5 || isRelight || isRebuild) {
					lighting(); // Normal lighting update when we move the player / LOS
				}
				else if (relight_t > 0) {
					lighting2();
				}
			}
			
			isRelight = false;
			
			getDist();
			
			//если нужно, пересчитать пространство
			if (isRebuild) {
				rebuild();
			}
		
			if (isRecalc) {
				recalcWater();
			}
			
			if (t_gwall == 1) {
				gwalls();
			}
			
			if (t_gwall > 0) {
				t_gwall--;
			}

			//показать/скрыть указатели перехода
			if (sign_vis && World.w.possiblyOut() ||  !sign_vis && !World.w.possiblyOut()) {
				showSign(!sign_vis);
			}
			
			//тревога
			if (t_alarm > 0) {
				t_alarm--;
			}
			
			if (t_alarmsp > 0) {
				t_alarmsp--;
				if (t_alarmsp==0) {
					enemySpawn();
				}
			}
			
			//трясучка
			if (quake > 0) {
				quake--;
			}
			
			if (trus > 0) {
				World.w.quake(trus * 0.50, trus);
			}

			// Bounding-box debugging (Draws each objects bounding box)
			grafon.drawDebugLayer();
		}
		
		// [Kill all enemies and open all containers]
		public function getAll():int {
			GameContainer.reference.summxp = 0;
			GameContainer.reference.pers.expa(unXp * 9);
			
			for each (var un:Unit in units) {
				if (un.fraction!=Unit.F_PLAYER && un.xp>0) {
					un.damage(100000, E_Resistances.DAM_INTERNAL);
				}
			}
			
			for each (var box:Box in objs) {
				if (box.inter && box.inter.cont) {
					box.inter.loot();
				}
			}
			
			return GameContainer.reference.summxp;
		}
		
		public function openAllPrize():void {
			for each (var box:Box in objs) {
				if (box.inter && box.inter.cont && box.inter.prize) {
					box.inter.loot();
				}
			}
		}
		
		//дистанция между гг и активным объектом
		private function getDist():void {
			if (getTile(Math.round(GameContainer.reference.celX / tileX), Math.round(GameContainer.reference.celY / tileY)).visibility < 0.10) {
				celObj = null;
			}
			
			if (celObj) {
				celDist = (gg.coordinates.X - celObj.coordinates.X) * (gg.coordinates.X - celObj.coordinates.X) + (gg.coordinates.Y - celObj.coordinates.Y) * (gg.coordinates.Y - celObj.coordinates.Y);
			} 
			else {
				celDist = -1;
			}
		}
		
		//показать/скрыть указатели перехода
		private function showSign(n:Boolean):void {
			for each (var s:MovieClip in signposts) {
				s.visible = n;
			}
			
			sign_vis = n;
		}
		
		public function newGrenade(g:Bullet):void {
			if (grenades[0] == null) {
				grenades[0] = g;
			}
			else {
				for (var i:int = 1; i < 10; i++) {
					if (grenades[i] == null) {
						grenades[i] = g;
						break;
					}
				}
			}
		}

		public function remGrenade(g:Bullet):void {
			if (grenades[0] == g) {
				grenades[0] = null;
			}
			else {
				for (var i:int = 1; i < 10; i++) {
					if (grenades[i] == g) {
						grenades[i] = null;
					}
				}
			}
		}
		
		//сохранить все объекты
		public function saveObjs(arr:Array):void {
			for each (var obj:Obj in saves) {
				if (obj.code) {
					arr[obj.code] = obj.save();
				}
			}
		}	
	}	
}

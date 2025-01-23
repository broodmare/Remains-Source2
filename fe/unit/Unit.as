package fe.unit {

	import flash.media.SoundChannel;
	import flash.filters.GlowFilter;
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	
	import fe.*;
	import fe.SymbolFactory;
	import fe.util.Calc;
	import fe.util.Vector2;

	import fe.weapon.*;
	import fe.projectile.Bullet;
	import fe.loc.*;
	import fe.serv.*;
	import fe.graph.Emitter;
	import fe.entities.Obj;
	import fe.entities.BoundingBox;
	import fe.entities.Part;
	
	public class Unit extends Obj {

		public static var txtMiss:String;
		public static var arrIcos:Array;
		
		public var id:String;
		private var mapxml:XML;
		public var uniqName:Boolean = false;

		// Starting coordinates
		public var begX:Number				= -1.00;
		public var begY:Number				= -1.00;
		public var rasst:Number				=  0.00;		// Distance to player
		
		public var level:int				=  0;
		public var hero:int					=  0;			// This unit is a unique (tougher) variant 
		public var boss:Boolean				= false;

		// Health
		public var maxhp:Number				= 100.00;		// Maximum Hitpoints
		public var hp:Number				= 100.00;		// Current Hitpoints
		public var hpmult:Number			=   1.00;		// Hitpoints multiplier
		public var cut:Number				=   0.00;		// Wounds (For bleed status?)
		public var poison:Number			=   0.00;		// Poison (For poison status?)
		public var critHeal:Number			=   0.20;
		public var shithp:Number			=   0.00;

		private var t_hp:int;
		public var mana:Number				= 1000.00;
		public var maxmana:Number			= 1000.00;
		public var dmana:Number				= 1.00;
		
		// Armor and [vulnerabilities]
		public var invulner:Boolean			= false;
		public var allVulnerMult:Number		= 1.00;
		public var skin:Number				= 0.00;			// [Skin, armor, probability that it will work]
		public var armor_hp:Number			= 0.00;
		public var armor_maxhp:Number		= 0.00;
		public var shitArmor:Number			= 20.00;

		// NEW VULNERABILITIES/RESISTANCES
		public var armor:Number				= 0.00;
		public var marmor:Number			= 0.00;
		public var armorQual:Number			= 0.00;
		public var typeResist:Resistances;					// This replaces 'armor', 'marmor', and 'armorQual'
		
		// OLD VULNERABILITIES
		public static var opts:Array		= [];			// Default 'opt' values for every unit ID initialized
		public var opt:Object;								// Paramteters for this unit or variant
		public var vulnerabilities:Resistances;				// Damage multiplers for each type of damage (Eg. 1.20 is 120% damage or 0.00 is 0% damage) (These can change)
		public var begvulner:Resistances;					// The unit's default vulnerabilities without an modifiers (These can not change)
		
		// Evasion, 1 is standard, 0 always hits
		public var dexter:Number			= 1.00;
		public var dexterPlus:Number		= 0.00;
		
		// [The probability of evading in close combat, an increase in the probability of hitting the enemy, 1 - always]
		public var dodge:Number				= 0.00;
		public var undodge:Number			= 0.00;			
		
		public var transp:Boolean			= false;		// [Transparent for non-damaging bullets]
		public var damWall:Number			= 0.00;			// [Wall impact damage]
		public var damWallSpeed:Number		= 12.00;	
		public var dopTestOn:Boolean		= false;		// [Difficult hit check]
		public var friendlyExpl:Number		= 0.25;
		
		// Damage
		public var dam:Number				= 0.00;			//урон самого юнита
		public var tipDamage:String			= Resistances.DAM_BLUNT;		//тип урона
		public var radDamage:Number			= 0.00;			//урон радиацией
		public var retDamage:Boolean		= false;		//возврат урона от юнита к врагу
		public var relat:Number				= 0.00;			//обратный возврат урона, от врага к юниту
		public var destroy:Number			= -1.00;		//урон блокам при столкновении
		public var collisionTip:int			= 1;	
		public var dieWeap:String;							//оружие, из которого юнит был убит
		public var levitAttack:Number		= 1.00;			//насколько успешной будет атака в состоянии левитации
		public var noAgro:Boolean			= false;		//не нападает первый
		
		// Movement
		// Motion parameters
		public var bind:Obj;								//привязка
		public var fixed:Boolean			= false;		//не двигаться вообще
		public var mater:Boolean			= true;			//взаимодействовать со стенами
		public var massaFix:Number			=  1.00;		//масса зафиксированного объекта
		public var massaMove:Number			=  1.00;		//масса перемещаемого объекта
		public var walk:int;								// [Movement on the floor, 1 - right, -1 left, 0 - no movement]
		
		public var maxSpeed:Number			= 10.00;
		public var walkSpeed:Number			=  5.00;
		public var runSpeed:Number			= 10.00;
		public var sitSpeed:Number			=  3.00;
		public var lazSpeed:Number			=  5.00;
		public var plavSpeed:Number			=  5.00;
		
		public var accel:Number				=  5.00;
		public var brake:Number				=  1.00;
		public var levitaccel:Number		=  1.60;
		public var knocked:Number			=  1.00;
		
		public var jumpdy:Number			= 15.00;
		public var plavdy:Number			=  1.00;
		public var levidy:Number			=  1.00;
		public var elast:Number				=  0.00;
		public var jumpBall:Number			=  0.00;

		public var ddyPlav:Number			=  1.00;		//выталкивающая сила
		public var osndx:Number				=  0.00;
		public var osndy:Number				=  0.00;
		public var levit_max:int			=  0.00;		//максимальное время левитации, если 0, то левитация не ограничена
		public var levit_r:int				=  0.00;		//сколько времени объект был левитирован
		public var grav:Number				=  1.00;
		public var slow:int					=  0.00;		//внешнее замедление
		public var tormoz:Number			=  1.00;		//на эту величину умножается dx, если объект стоит на земле
		public var t_throw:int				=  0.00;		//включается после броска
		
		//переменные
		public var stayPhis:int;
		public var stayOsn:Box;
		public var stayMat:int;
		public var tykMat:int;
		
		protected var shX1:Number;							//насколько не помещаешься
		protected var shX2:Number;							//
		protected var diagon:int			= 0;			//
		
		public var porog:Number				= 10.00;
		public var porog_jump:Number		= 4.00;			//автоподъём

		public var isSit:Boolean			= false;
		private var autoSit:Boolean			= false;		// used by run() and it's helper functions to keep track of if the unit automatically crouched
		public var isFly:Boolean			= false;
		public var isRun:Boolean			= false;
		public var isPlav:Boolean			= false;
		public var isLaz:int				= 0;
		public var inWater:Boolean			= false;
		public var isUp:Boolean				= false;
		public var throu:Boolean			= false;
		public var isJump:Boolean			= false;
		public var turnX:int				= 0;
		public var turnY:int				= 0;
		public var kray:Boolean				= false;
		
		public var pumpObj:Interact;						// [object that came across (for opening doors by mobs)]
		private var namok_t:int				= 0;
		public var visDamDY:int				= 0;

		//оружие
		public var currentWeapon:Weapon;
		public var weaponSkill:Number		= 1.00;			//владение оружием
		public var spellPower:Number		= 1.00;			//сила заклинаний, не являющихся оружием
		public var mazil:int				= 0;			//дополнительный случайный разлёт пуль
		public var critCh:Number			= 0.00;			//дополнительный шанс крита
		public var critInvis:Number			= 0.00;			//прибавка к шансу крита для мобов, у которых не установлена цель на владелца пули
		public var critDamMult:Number		= 2.00;			//множитель критического урона
		public var precMult:Number			= 1.00;			//модификатор точности для гг, для всех остальных он равен 1
		public var precMultCont:Number		= 1.00;			//модификатор точности, уменьшающийся от критических эффектов
		public var rapidMultCont:Number		= 1.00;			//модификатор скорости атаки холодным оружием, уменьшающийся от критических эффектов
		public var weaponKrep:Boolean		= true;	
		public var weaponX:Number			= 0.00;
		public var weaponY:Number			= 0.00;
		public var weaponR:Number			= 0.00;
		public var magicX:Number;
		public var magicY:Number;
		public var childObjs:Array;							//подчинённые объекты
		public var isShoot:Boolean			= false;		//устанавливается оружием в true если был выстрел

		//ии
		public var aiNapr:int=1, aiVNapr:int=0; //направление, в котором стремиться двигаться ии
		public var aiTTurn:int=10, aiPlav:int=0; 
		public var aiState:int=0;	//состояние ии 
		protected var aiTCh:int = Calc.intBetween(0, 10);	// [AI state change timer], Changed from range of [0-9] to [0-10]
		protected var aiSpok:int=0, maxSpok:int=30;		// [0 - calm, 1-9 - excited, maxSpok - attacks the target]
		//координаты и вид цели
		public var celX:Number=0, celY:Number=0, celDX:Number=0, celDY:Number=0;

		public var acelX:Number=0, acelY:Number=0;	// [anti-target]
		
		// Vision varaibles
		public var celUnit:Unit;	//кто является целью
		public var priorUnit:Unit;	//кто является врагом
		
		// Point of view
		public var eyeX:Number				= -1000.00;
		public var eyeY:Number				= -1000.00;
		
		//состояния
		public var sost:int					= 1;		//1 - Alive, 2 - Unconscious, 3 - Dead, 4- Destroyed and no longer processed
		public var shok:int					= 0;
		public var maxShok:int				= 30;
		public var stun:int					= 0;
		public var neujaz:int				= 0;
		public var neujazMax:int			= 20;
		public var disabled:Boolean			= false;
		public var noAct:Boolean			= false;	//неактивен, может быть включён командой
		public var detectionDelay:int		= 100;
		public var lootIsDrop:Boolean		= false;	//выпадал ли уже лут
		public var aiTip:String;	
		public var t_emerg:int				= 0;
		public var max_emerg:int			= 0;
		public var wave:int					= 0;		//враг принадлежит к волне
		public var transT:Boolean			= false;	//проходит через магическую стену
		public var postDie:Boolean			= false;	//изначально труп

		//Опции	
		public var blood:int				= 0;		//кровь: 0-нет, 1-обычная, 2-зелёная
		public var mat:int					= 0;		//0-мясо, 1-металл
		public var acidDey:Number			= 0.00;		//разъедание брони кислотой
		public var trup:Boolean				= true;		//оставлять труп или уничтожить
		public var overLook:Boolean			= true;		//может видеть то что сзади
		public var plav:Boolean				= true;		//при true - плавает, иначе ходит по дну
		public var showNumbs:Boolean		= true;		//отображать урон
		public var activateTrap:int			= 2;		//активировать ловушки и мины
		public var isSats:Boolean			= true;		//быть целью для ЗПС
		public var msex:Boolean				= true;		//пол мужской
		public var doop:Boolean				= false;	//true устанавливается для тех, кто не отслеживает цели
		public var plaKap:Boolean			= true;		//брызгается
		public var noBox:Boolean			= false;	//не получчает удары ящиками
		public var areaTestTip:String;	
		public var mHero:Boolean			= false;	//может стать героем
		public var isRes:Boolean			= false;	//восстаёт после смерти
		public var mech:Boolean				= false;	//механизм
		public var noDestr:Boolean			= false;	//не уничтожать после смерти
		
		//фракция
		public var fraction:int				= 0;
		public var player:Boolean			= false;
		public var npc:Boolean				= false;	//Юнит является NPC-ом и отображается на карте

		public static const F_PLAYER:int	= 100;
		public static const F_MONSTER:int	= 1;
		public static const F_RAIDER:int	= 2;
		public static const F_ZOMBIE:int	= 3;
		public static const F_ROBOT:int		= 4;
		
		//видимость юнита для других (маскировка), чем выше показатель, тем с большего расстояния объект виден
		public var visibility:int			= 1000;
		public var stealthMult:Number		= 1.00;		//с какого расстояния становится виден
		public var detecting:int			= 80;		//расстояние безусловного обнаружения
		public var demask:Number			= 0.00;
		public var invis:Boolean			= false;
		public var noise:int				= 0;
		public var noiseRun:int				= 200;
		public var noise_t:int				= 30;		//звук
		public var isVis:Boolean			= true;		//видимый или нет для ГГ
		public var volMinus:Number			= 0.00;		//падение громкости звуковых эффектов
		public var light:Boolean			= false;	//убрать туман войны в этой точке
		
		//видимость других юнитов
		public var observ:Number			= 0.00;		//наблюдательность
		public var vision:Number			= 1.00;		// [Vision multiplier]
		public var ear:Number				= 1.00;		//множитель слуха
		public var unres:Boolean			= false;	//не реагировать на звуки
		public var vAngle:Number			= 0.00;		//конус зрения
		public var vKonus:Number			= 0.00;		//конус зрения
		
		//эффекты
		public var effects:Array;
		
		//случайное имя
		public var id_name:String;
		//реплики
		public var t_replic:int				= Math.random() * 100 - 50;
		public var id_replic:String			= "";

		//визуальная часть
		//блиттинг
		public var blitId:String;						//id битмапа
		public var animState:String			= "";
		public var animState2:String		= "";
		public var blitData:BitmapData;
		private var blitX:int				= 120;
		private var blitY:int				= 120;
		private var blitDX:int				=  -1;
		private var blitDY:int				=  -1;
		private var blitRect:Rectangle;
		private var blitPoint:Point;
		private var visData:BitmapData;
		public var visBmp:Bitmap;
		
		public var anims:Object;						// Animations accessed by string. eg. anims["fly"]
		
		public var ctrans:Boolean			= true;		//применять цветофильтр
		//полоска хп
		public var hpbar:MovieClip;
		public static var heroTransforms:Array = [ 
			new ColorTransform(1.0, 0.8, 0.8, 1, 64,  0, 0,  0), 
			new ColorTransform(0.8, 1.0, 1.0, 1,  0, 32, 64, 0), 
			new ColorTransform(1.0, 0.8, 1.0, 1, 32,  0, 64, 0), 
			new ColorTransform(0.8, 1.0, 0.8, 1,  0, 64, 0,  0)
		];
		
		//смертельные эффекты
		public var timerDie:int				= 0;		//отложенная смерть
		public var burn:Desintegr;
		public var bloodEmit:Emitter;
		public var numbEmit:Emitter;
		public var hitPart:Part;
		public var t_hitPart:int			= 0;
		public var hitSumm:Number			= 0.00;
		public var t_mess:int				= 0;
		
		//звуки
		public var sndMusic:String;
		private var sndMusicPrior:int		= 0;
		public var sndDie:String;
		public var sndRun:String;
		public var sndRunDist:Number		= 800;
		public var sndRunOn:Boolean			= false;
		public var sndVolkoef:Number		= 1.00;

		//пложение
		public var mother:Unit;
		public var kolChild:int				= 0;

		public var scrDie:Script;
		public var scrAlarm:Script;
		public var questId:String;						//id для коллекционного квеста
		
		public var trig:String;							//условие появления
		public var trigDis:Boolean			= false;	//отключён по триггеру
		
		public var xp:int					= 0;		//опыт
		
		private static const robotKZ:int		= 75;
		private static const damWallStun:int	= 45;

		protected var _standingHeight:Number;  // Standing height (Constant)
		protected var _standingWidth:Number;   // Standing width (Constant)
		protected var _crouchingHeight:Number; // Crouching height (Constant)
		protected var _crouchingWidth:Number;  // Crouching width (Constant)

		private static var tileX:int = Tile.tileX;
		private static var tileY:int = Tile.tileY;

		//Параметры для создания юнита
		//cid - идентификатор создания, на основе которого внутри конструктора класса будет определён настоящий идентификатор
		//dif - уровень сложности для этого юнита
		//xml - индивидуальные параметры, взятые из карты
		//loadObj - объект для загрузки состояния юнита

		// Constructor
		public function Unit(cid:String = null, ndif:Number = 100, xml:XML = null, loadObj:Object = null) {
			vulnerabilities = new Resistances();
			vulnerabilities.setResistances(1.00);
			vulnerabilities.setResist(Resistances.DAM_EMP, 0.00)

			inter = new Interact(this, null, xml, loadObj);
			inter.active = false;
			
			effects = [];
			sloy = 2;
			prior = 1;
			warn = 1;
			numbEmit = Emitter.arr['numb'];
			
			if (xml) {
				if (xml.@turn.length()) {
					if (xml.@turn > 0) storona =  1;
					if (xml.@turn < 0) storona = -1;
				}
				else {
					storona=isrnd() ? 1 : -1;
					aiNapr = storona;
				}
				
				if (xml.@name.length()) {
					uniqName = true;
					nazv = Res.txt('u', xml.@name);
				}
				
				if (xml.@ai.length()) aiTip = xml.@ai;
				if (xml.@hpmult.length()) hpmult = xml.@hpmult;
				if (xml.@multhp.length()) hpmult = xml.@multhp;
				if (xml.@unres.length()) unres = true;
				if (xml.@qid.length()) questId = xml.@qid;
				if (xml.@trig.length()) trig = xml.@trig;
				if (xml.@hero.length()) hero = xml.@hero;
				if (xml.@observ.length()) observ = xml.@observ;
				if (xml.@light.length()) light = true;
				if (xml.@noagro.length()) noAgro = true;
				if (xml.@dis.length()) {
					noAct = true;
					disabled = true;
				}
				if (xml.@die.length()) postDie = true;
			}
			
			if (loadObj && loadObj.dead && !postDie) {
				sost = 4;
				disabled = true;
			}
			
			mapxml = xml;
		}
		
		public function get height():Number {
			return _standingHeight;
		}

		public static function create(id:String, dif:int, xml:XML=null, loadObj:Object=null, ncid:String=null):Unit {
			switch (id) {
				case 'mwall':
					return new UnitMWall(null,0,null,null);
				break;
				case 'scythe':
					return new UnitScythe(null,0,null,null);
				break;
				case 'ttur':
					return new UnitThunderTurret(ncid,0,null,null);
				break;
			}

			var node:XML = XMLDataGrabber.getNodeWithAttributeThatMatches("core", "AllData", "objs", "id", id);
			if (!node) {
				trace("ERROR: unit: \"" + id + "\" not found!");
				return null;
			}
			var uc:Class;
			var cn:String = node.@cl;

			switch (cn) {
				case 'Mine':			uc = Mine;break;
				case 'UnitTrap':		uc = UnitTrap;break;
				case 'UnitTrigger':		uc = UnitTrigger;break;
				case 'UnitDamager':		uc = UnitDamager;break;
				case 'UnitRaider':		uc = UnitRaider;break;
				case 'UnitSlaver':		uc = UnitSlaver;break;
				case 'UnitZebra':		uc = UnitZebra;break;
				case 'UnitRanger':		uc = UnitRanger;break;
				case 'UnitEncl':		uc = UnitEncl;break;
				case 'UnitMerc':		uc = UnitMerc;break;
				case 'UnitZombie':		uc = UnitZombie;break;
				case 'UnitAlicorn':		uc = UnitAlicorn;break;
				case 'UnitHellhound':	uc = UnitHellhound;break;
				case 'UnitRobobrain':	uc = UnitRobobrain;break;
				case 'UnitProtect':		uc = UnitProtect;break;
				case 'UnitGutsy':		uc = UnitGutsy;break;
				case 'UnitEqd':			uc = UnitEqd;break;
				case 'UnitSentinel':	uc = UnitSentinel;break;
				case 'UnitTurret':		uc = UnitTurret;break;
				case 'UnitBat':			uc = UnitBat;break;
				case 'UnitFish':		uc = UnitFish;break;
				case 'UnitBloat':		uc = UnitBloat;break;
				case 'UnitSpriteBot':	uc = UnitSpriteBot;break;
				case 'UnitDron':		uc = UnitDron;break;
				case 'UnitVortex':		uc = UnitVortex;break;
				case 'UnitMonstrik':	uc = UnitMonstrik;break;
				case 'UnitAnt':			uc = UnitAnt;break;
				case 'UnitSlime':		uc = UnitSlime;break;
				case 'UnitRoller':		uc = UnitRoller;break;
				case 'UnitNPC':			uc = UnitNPC;break;
				case 'UnitCaptive':		uc = UnitCaptive;break;
				case 'UnitPonPon':		uc = UnitPonPon;break;
				case 'UnitTrain':		uc = UnitTrain;break;
				case 'UnitMsp':			uc = UnitMsp;break;
				case 'UnitTransmitter':	uc = UnitTransmitter;break;
				case 'UnitNecros':		uc = UnitNecros;break;
				case 'UnitSpectre':		uc = UnitSpectre;break;
				case 'UnitBossRaider':	uc = UnitBossRaider;break;
				case 'UnitBossAlicorn':	uc = UnitBossAlicorn;break;
				case 'UnitBossUltra':	uc = UnitBossUltra;break;
				case 'UnitBossNecr':	uc = UnitBossNecr;break;
				case 'UnitBossDron':	uc = UnitBossDron;break;
				case 'UnitBossEncl':	uc = UnitBossEncl;break;
				case 'UnitThunderHead':	uc = UnitThunderHead;break;
				case 'UnitDestr':		uc = UnitDestr;break;
				case 'UnitBloatEmitter': uc = UnitBloatEmitter;break;
			}
			if (!uc) return null;

			var cid:String = null;	// [Creation ID]
			if (node.@cid.length()) cid = node.@cid;
			if (ncid) cid = ncid;
			var un:Unit=new uc(cid, dif, xml, loadObj);
			if (xml && xml.@code.length()) un.code = xml.@code;
			return un;
		}
		
		public override function save():Object {
			var obj:Object = new Object();
			
			if (sost >= 3 && !postDie) {
				obj.dead = true;
			}
			
			if (inter) {
				inter.save(obj);
			}

			return obj;
		}
		
		public function getXmlParam(mid:String = null):void {
			var setOpts:Boolean = false;
			
			// If we've intialized this unit ID before, get it's stored variant options
			if (opts[id]) {
				opt = opts[id];
			}
			// Else load them
			else {
				opt = new Object();
				opts[id] = opt;
				setOpts = true;
			}
			
			var node:XML;
			var isHero:Boolean = false;
			
			if (mid == null) {
				if (hero > 0) {
					isHero = true;
				}
				
				mid = id;
			}
			
			var node0:XML = XMLDataGrabber.getNodeWithAttributeThatMatches("core", "AllData", "units", "id", mid);
			
			if (mid && !uniqName) {
				nazv = Res.txt('u', mid);
			}
			
			if (node0.@fraction.length()) {
				fraction = node0.@fraction;
			}
			
			inter.cont = mid;
			
			if (node0.@cont.length() && inter) {
				inter.cont = node0.@cont;
			}
			
			if (fraction == F_PLAYER) {
				warn = 0;
			}
			
			if (node0.@xp.length()) {
				xp = node0.@xp * World.unitXPMult;
			}
			
			// [Physical parameters]
			if (node0.phis.length()) {
				node = node0.phis[0];
				
				if (node.@sX.length()) {
					_standingWidth = node.@sX;
				}
				
				if (node.@sY.length()) {
					_standingHeight = node.@sY;
				}
				
				if (node.@sitX.length()) {
					_crouchingWidth = node.@sitX;
				}
				else {
					_crouchingWidth = _standingWidth;
				}
				
				if (node.@sitY.length()) {
					_crouchingHeight = node.@sitY; 
				}
				else {
					_crouchingHeight = _standingHeight * 0.50;
				}
				
				if (node.@massa.length()) {
					massaMove = node.@massa / 50;
				}
				
				if (node.@massafix.length()) {
					massaFix = node.@massafix / 50;
				}
				else {
					massaFix = massaMove;
				}
			}

			// Update bounding box with the unit size
			boundingBox.height = _standingHeight;
			boundingBox.width = _standingWidth;
			boundingBox.center(coordinates);
			
			massa = massaFix;
			
			if (massa >= 1) {
				destroy = 0;
			}
			
			//параметры движения
			if (node0.move.length()) {
				node=node0.move[0];
				if (node.@speed.length()) maxSpeed=node.@speed;
				if (node.@run.length()) runSpeed=node.@run;
				if (node.@accel.length()) accel=node.@accel;
				if (node.@jump.length()) jumpdy=node.@jump;
				if (node.@knocked.length()) knocked=node.@knocked;		//множитель отбрасывания оружием
				if (node.@plav.length()) plav=(node.@plav>0);			//если =0, юнит не плавает, а ходит по дну
				if (node.@brake.length()) brake=node.@brake;			//торможение
				if (node.@levit.length()) levitPoss=(node.@levit>0);	//если =0, юнит нельзя поднимать телекинезом
				if (node.@levit_max.length()) levit_max=node.@levit_max;//максимальное время левитации
				if (node.@levitaccel.length()) levitaccel=node.@levitaccel;	//ускорение в поле левитации, определяет возможность врага вырываться из телекинетического захвата
				if (node.@float.length()) ddyPlav=node.@float;			//значение выталкивающей силы
				if (node.@porog.length()) porog=node.@porog;			//автоподъём при движении по горизонтали
				if (node.@fixed.length()) fixed=(node.@fixed>0);		//если =1, юнит является прикреплённым
				if (node.@damwall.length()) damWall=node.@damwall;		//урон от удара ап стену
			}
			
			//боевые параметры
			if (node0.comb.length()) {
				node=node0.comb[0];
				if (node.@hp.length()) hp=maxhp=node.@hp*hpmult;
				if (fraction!=F_PLAYER && World.w.game.globalDif<=1) {
					if (World.w.game.globalDif==0) maxhp*=0.4;
					if (World.w.game.globalDif==1) maxhp*=0.7;
					hp=maxhp;
				}
				if (node.@skin.length()) skin=node.@skin;
				if (node.@armor.length()) armor=node.@armor;
				if (node.@marmor.length()) marmor=node.@marmor;
				if (node.@aqual.length()) armorQual=node.@aqual;		//качество брони
				if (node.@armorhp.length()) armor_hp=armor_maxhp=node.@armorhp*hpmult;
				else armor_hp=armor_maxhp=hp;
				
				if (node.@krep.length()) weaponKrep=node.@krep;			//способ держать оружие, 0 - телекинез // fixedToOwner
				if (node.@dexter.length()) dexter=node.@dexter;			//уклонение
				if (node.@damage.length()) dam=node.@damage;			//собственный урон
				if (node.@tipdam.length()) tipDamage=node.@tipdam;		//тип собственного урона
				if (node.@skill.length()) weaponSkill=node.@skill;		//владение оружием
				if (node.@raddamage.length()) radDamage=node.@raddamage;//собственный урон радиацией
				if (node.@vision.length()) vision=node.@vision;			//зрение
				if (node.@observ.length()) observ+=node.@observ;		//наблюдательность
				if (node.@ear.length()) ear=node.@ear;					//слух
				if (node.@levitatk.length()) levitAttack=node.@levitatk;//атака при левитации
			}
			
			// [vulnerabilities]
			if (node0.vulner.length()) {
				node = node0.vulner[0];
				if (node.@bul.length())		vulnerabilities.setResist(Resistances.DAM_PIERCE, node.@bul);
				if (node.@blade.length())	vulnerabilities.setResist(Resistances.DAM_CUT, node.@blade);
				if (node.@phis.length())	vulnerabilities.setResist(Resistances.DAM_BLUNT, node.@phis);
				if (node.@fire.length())	vulnerabilities.setResist(Resistances.DAM_BURN, node.@fire);
				if (node.@expl.length())	vulnerabilities.setResist(Resistances.DAM_EXPLOSION, node.@expl);
				if (node.@laser.length())	vulnerabilities.setResist(Resistances.DAM_LASER, node.@laser);
				if (node.@plasma.length())	vulnerabilities.setResist(Resistances.DAM_PLASMA, node.@plasma);
				if (node.@venom.length())	vulnerabilities.setResist(Resistances.DAM_VENOM, node.@venom);
				if (node.@emp.length())		vulnerabilities.setResist(Resistances.DAM_EMP, node.@emp);
				if (node.@spark.length())	vulnerabilities.setResist(Resistances.DAM_ELECTRIC, node.@spark);
				if (node.@acid.length())	vulnerabilities.setResist(Resistances.DAM_ACID, node.@acid);
				if (node.@cryo.length())	vulnerabilities.setResist(Resistances.DAM_COLD, node.@cryo);
				if (node.@poison.length())	vulnerabilities.setResist(Resistances.DAM_POISON, node.@poison);
				if (node.@bleed.length())	vulnerabilities.setResist(Resistances.DAM_BLEED, node.@bleed);
				if (node.@fang.length())	vulnerabilities.setResist(Resistances.DAM_BITE, node.@fang);
				if (node.@pink.length())	vulnerabilities.setResist(Resistances.DAM_PINKCLOUD, node.@pink);
			}
			
			//visual parameters
			if (node0.vis.length()) {
				node=node0.vis[0];
				if (node.@sex=='w') msex=false;
				if (node.@blit.length())
				{
					blitId = node.@blit;
					
					if (node.@sprX > 0) blitX = node.@sprX;
					
					// If there's no indication of unit height, use the width as the height to create a square unit.
					if (node.@sprY > 0) blitY = node.@sprY;
					else blitY = blitX;

					if (node.@sprDX.length()) blitDX=node.@sprDX;
					if (node.@sprDY.length()) blitDY=node.@sprDY;
				}
				if (node.@replic.length()) id_replic=node.@replic;
				if (node.@noise.length()) noiseRun=node.@noise;
			}
			
			//звуковые параметры
			if (node0.snd.length()) {
				node=node0.snd[0];
				if (node.@music.length()) {
					sndMusic=node.@music;
					sndMusicPrior=1;
				}
				if (node.@musicp.length()) sndMusicPrior=node.@musicp;
				if (node.@die.length()) sndDie=node.@die;
				if (node.@run.length()) sndRun=node.@run;
			}
			
			//прочие параметры
			if (node0.param.length()) {
				node=node0.param[0];
				if (node.@invulner.length()) invulner=(node.@invulner>0);	//полная неуязвимость
				if (node.@overlook.length()) overLook=(node.@overlook>0);	//может смотреть за спину
				if (node.@sats.length()) isSats=(node.@sats>0);				//отображать как цель в ЗПС
				if (node.@acttrap.length()) activateTrap=node.@acttrap;		//юнит активирует ловушки: 0 - никак, 1 - только установленные игроком
				if (node.@npc.length()) npc=(node.@npc>0);					//отображать на карте как npc
				if (node.@trup.length()) trup=(node.@trup>0);				//оставлять труп после смерти
				if (node.@blood.length()) blood=node.@blood;				//кровь
				if (node.@retdam.length()) retDamage=node.@retdam>0;		//возврат урона
				if (node.@hero.length()) {
					mHero=true;						//может быть героем
					id_name=node.@hero;
				}
				if (setOpts) {
					if (node.@pony.length()) opt.pony=true;			// [is a pony]
					if (node.@zombie.length()) opt.zombie=true;		// [is a zombie]
					if (node.@robot.length()) opt.robot=true;		// [is a robot]
					if (node.@insect.length()) opt.insect=true;		// [is an insect]
					if (node.@monster.length()) opt.monster=true;	// [is a monster]
					if (node.@alicorn.length()) opt.alicorn=true;	// [is an alicorn]
					if (node.@mech.length()) {
						opt.mech=true;					// [is a mechanism]
						mech=true;
					}
					if (node.@hbonus.length()) opt.hbonus=true;					// [is a pony]
					if (node.@izvrat.length()) opt.izvrat=true;					// [is a pony]
				}
			}
			
			if (blood == 0) {
				vulnerabilities.setResist(Resistances.DAM_BLEED, 0);
			}
			
			if (opt) {
				if (opt.robot || opt.mech) {
					vulnerabilities.setResist(Resistances.DAM_DEATH, 0);
					vulnerabilities.setResist(Resistances.DAM_BLEED, 0);
					vulnerabilities.setResist(Resistances.DAM_VENOM, 0);
					vulnerabilities.setResist(Resistances.DAM_POISON, 0);
				}
			}

			// LOAD ANIMATION SETS IF APPLICABLE
			// This unit has a parent unit, load those animations
			if (node0.@parent.length()) {
				var parentID:String = node0.@parent;
				var parentAnims:Object = AnimationSet.loadAnimations(parentID);
				if (parentAnims != null) {
					anims = parentAnims;
				}
				else {
					trace("Unit.as/create() - Failed to load parent animations for: " + parentID);
				}
				
				var subclassAnims:Object = AnimationSet.loadAnimations(id);
				if (subclassAnims != null) {
					for (var animState:String in subclassAnims) {
						anims[animState] = subclassAnims[animState]; // Override or add new animations
					}
				}
				else {
					trace("Unit.as/create() - No subclass animations to load for: " + id);
				}
			}
			// This unit has no parent, load animations normally
			else {
				anims = AnimationSet.loadAnimations(id);
			}

			// Create a duplicate of all the vulnerability values so we can keep track of the default values
			if (setOpts) {
				begvulner = vulnerabilities.clone();
			}
		}
		
		// TODO: Only a few classes use this and they should be cloning the weapon themselves, this is obsolete
		public function getXmlWeapon(dif:int):Weapon {
			trace("Unit.as/getXmlWeapon() - Unit: \"" + id + "\" is getting a weapon from XML");
			// Get the unit info
			var node0:XML = XMLDataGrabber.getNodeWithAttributeThatMatches("core", "AllData", "units", "id", id);

			// Create the internal weapon(s) for this unit
			for each(var n:XML in node0.w) {
				if (n.@f.length()) {
					continue;
				}
				
				if (n.@dif.length() && n.@dif > dif) {
					continue;
				}
				
				if (n.@ch.length() == 0 || isrnd(n.@ch)) {
					trace("Unit.as/getXmlWeapon() - Returning weapon ID: " + n.@id);
					return WeaponManager.reference.cloneWeapon(n.@id);
				}
			}

			
			
			trace("Unit.as/getXmlWeapon() - Failed, returning null");
			return null;
		}
		
		public function getName():String {
			if (World.w.game == null || id_name == null) {
				return "";
			}
			
			var arr:Array = World.w.game.names[id_name];
			
			if (arr == null || arr.length == 0) {
				arr = Res.namesArr(id_name);	//prepare an array of names
			}
			
			if (arr == null || arr.length == 0) {
				return "";
			}

			World.w.game.names[id_name] = arr;
			var n:int = Calc.intBetween(0, arr.length - 1);
			var s:String = arr[n];
			arr.splice(n, 1);
			
			return s;
		}
		
		public function checkTrig():Boolean {
			if (trig) {
				if (trig == 'eco' && (World.w.pers == null || World.w.pers.eco == 0)) {
					return false;
				}
				
				if (World.w.game.triggers[trig] != 1) {
					return false;
				}
			}
			
			return true;
		}
		
		// [Place the created unit in the location]
		public function putLoc(nloc:Location, nx:Number, ny:Number):void {
			if (loc != null) {
				return;
			}
			
			loc = nloc;
			
			if (loc.mirror) {
				storona	= -storona;
				aiNapr	=  storona;
			}
			
			setPos(nx, ny);
			
			if (collisionAll()) {
				if (!collisionAll(-tileX)) {
					setPos(nx - tileX, ny);
				}
			}
			
			if (inter) {
				inter.loc = nloc;
			}
			
			if (inter && inter.saveLoot == 2) {
				inter.loot(true);	// [If the state is 2, generate critical loot]
			}
			
			if (sost >= 3) {
				return;
			}
			
			begX = coordinates.X;
			
			begY = coordinates.Y;
			
			if (hero == 0) {
				cTransform = loc.cTransform;
			}
			else {
				cTransform = heroTransforms[hero - 1];
			}
			
			if (loc.biom == 5) {
				vulnerabilities.setResist(Resistances.DAM_PINKCLOUD, 0);	// [Invulnerable to the pink cloud]
			}
			
			// [Attached scripts]
			if (mapxml) {
				if (mapxml.scr.length()) {
					for each (var xscr in mapxml.scr) {
						var scr:Script = new Script(xscr, loc.land, this);
						
						if (scr.eve == "die" || scr.eve == null) {
							scrDie = scr;
						}
						
						if (scr.eve == "alarm") {
							scrAlarm = scr;
						}
					}
				}
				
				if (mapxml.@scr.length()) {
					scrDie = World.w.game.getScript(mapxml.@scr, this);
				}
				
				if (mapxml.@alarm.length()) {
					scrAlarm = World.w.game.getScript(mapxml.@alarm, this);
				}
			}
			
			if (postDie) {
				sost = 3;
				setCel(null, coordinates.X + storona * 100, coordinates.Y + 50);
				lootIsDrop = true;
				die();
			}
		}

		// [set the mob's level (the value is added to the level specified via the map, default is 0)]
		public function setLevel(nlevel:int=0):void {
			level += nlevel;
			
			if (level < 0) {
				level = 0;
			}
			
			maxhp		= hp * (1 + level * 0.11);
			hp			= maxhp;
			dam			*= (1 + level * 0.07);
			radDamage	*= (1 + level * 0.1);
			critCh		= level * 0.01;
			armor		*= (1 + level * 0.05);
			marmor		*= (1 + level * 0.05);
			skin		*= (1 + level * 0.05);
			armor_hp	= armor_maxhp = armor_hp * (1 + level * 0.1);
			observ		+= Math.min(nlevel * 0.6, 15) * (0.9 + Math.random() * 0.2);
			
			if (currentWeapon && currentWeapon.tip == "internal") {
				currentWeapon.damage *= (1 + level * 0.07);
			}
			else {
				weaponSkill *= (1 + level * 0.035);
			}
			
			damWall *= (1 + level * 0.04);
		}
		
		// [Make a hero]
		public function setHero(nhero:int=1):void {
			if (!mHero) {
				return;
			}

			if (hero == 0) {
				hero = nhero;
			}

			if (hero > 0) {
				if (!uniqName) {
					var s:String = getName();
					
					if (s != null && s != "") {
						nazv = s;
					}
				}
				
				xp *= 5;
			}
			
			if (hero == 1) {
				hp = maxhp = maxhp * 2.50;
				dam *= 1.80;
				
				if (currentWeapon) {
					currentWeapon.damage *= 1.50;
				}
			}
			else if (hero == 2 || hero == 3) {
				maxhp = maxhp * 3;
				hp = maxhp;
				dam *= 1.20;
			}
			else if (hero == 4) {
				hp = maxhp = maxhp * 2;
				dam *= 1.40;
				observ += 8;
				walkSpeed *= 1.40;
				sitSpeed *= 1.40;
				runSpeed *= 1.25;
			}

			setHeroVulners();
		}
		
		public function setHeroVulners():void {
			vulnerabilities.multiplyResist(Resistances.DAM_EMP, 0.80);
			vulnerabilities.multiplyResist(Resistances.DAM_BALEFIRE, 0.70);
			vulnerabilities.multiplyResist(Resistances.DAM_DEATH, 0.70);
			vulnerabilities.multiplyResist(Resistances.DAM_ASTRO, 0.70);

			if (hero == 2) {
				vulnerabilities.multiplyResist(Resistances.DAM_PIERCE, 0.50);
				vulnerabilities.multiplyResist(Resistances.DAM_BLUNT, 0.65);
				vulnerabilities.multiplyResist(Resistances.DAM_CUT, 0.65);
				vulnerabilities.multiplyResist(Resistances.DAM_EXPLOSION, 0.75);
			}
			if (hero == 3) {
				vulnerabilities.multiplyResist(Resistances.DAM_LASER, 0.60);
				vulnerabilities.multiplyResist(Resistances.DAM_PLASMA, 0.50);
				vulnerabilities.multiplyResist(Resistances.DAM_EMP, 0.75);
				vulnerabilities.multiplyResist(Resistances.DAM_ELECTRIC, 0.70);
				vulnerabilities.multiplyResist(Resistances.DAM_BURN, 0.70);
			}
		}
		
		// [Restore to its original state, if f=true, then return to its place]
		public override function setNull(f:Boolean = false):void {
			if (boss && isNoResBoss()) {
				f = false;
			}
			
			if (sost == 1) {
				if (f) {
					// [reset effects]
					if (effects.length > 0) {
						for each (var eff in effects) {
							eff.unsetEff();
						}
						
						effects = [];
					}
					
					stun = 0;
					cut = 0;
					poison = 0;
					detectionDelay = Math.round(World.detectionDelay * (Math.random() * 0.2 + 0.9));
					
					if (!noAct) {
						disabled = false;		// [turn on]
					}
					
					hp = maxhp;			// [restore HP]
					armor_hp = armor_maxhp;
					
					if (hpbar) {
						visDetails();
					}
					
					// [return to starting point]
					if (begX > 0 && begY > 0) {
						setPos(begX, begY);
					}
					
					velocity.set(0, 0);
					setWeaponPos();
				}
				
				if (currentWeapon) {
					currentWeapon.setNull();
				}
			}
			
			levit = 0;
		}
		
		// The condition under which the boss does not restore hp
		public function isNoResBoss():Boolean {
			var res:Boolean = false;
			res = World.w.game.globalDif <= 3 && loc && loc.land.act.tip != 'base';
			
			return res;
		}

		protected function control():void {

		}

		public override function step():void {
			if (disabled || trigDis) {
				return;
			}

			if (t_emerg > 0) {
				t_emerg--;
				setVisPos();
				
				if (vis) {
					if (t_emerg > 0) {
						var tf = t_emerg / (max_emerg + 1);
						vis.filters = [new GlowFilter(0xAADDFF, tf, tf * 20, tf * 20, 1, 3)];
						vis.alpha = 1 - tf;
					}
					else {
						vis.filters = [];
						vis.alpha = 1;
					}
				}
				
				return;
			}
			
			if (sost == 2) {
				timerDie--;
				
				if (timerDie <= 0) {
					die();
				}
			}
			
			if (inter) {
				inter.step();
			}
			
			getRasst2();
			
			if (radioactiv) ggModum();	// [effect on GG (radiation)]
			
			forces();		// [external forces affecting acceleration]
			control();		// [player or AI control]

			// [movement]
			if (fixed) {
				// We're fixed in place, do nothing
			}
			else if (bind || Math.abs(velocity.X + osndx) < World.maxdelta && Math.abs(velocity.Y + osndy) < World.maxdelta) {
				run();
			}
			else {
				var div:int = int(Math.max(Math.abs(velocity.X + osndx),Math.abs(velocity.Y + osndy))/World.maxdelta)+1;
				
				for (var i = 0; i < div; i++) {
					run(div); // What the fuck, this is being used as a string later.
				}
			}
			
			checkWater();
			actions();		// [various actions]
			setVisPos();
			
			if (hpbar) {
				setHpbarPos();
			}

			if (burn) {
				burn.step();

				if (burn.vse) {
					exterminate();
				}
			}
			else {
				animate();
			}

			// TODO: Replace with boundingBox check
			onCursor = (isVis && !disabled && sost < 4 && boundingBox.intersectsPoint(World.w.celX, World.w.celY)) ? prior : 0;

			for (i in childObjs) {
				if (childObjs[i]) { // Here is where it's called as a string.
					childObjs[i].step();
					/*try {
						
					}
					catch(err) {
						trace("Unit.as/step() - Unit: " + nazv + " (" + id + ")" + "'s  Child object: \"" + childObjs[i].id + "\" failed to run step()!");
					}*/
				}
			}

			visDamDY = 0;
			
			if (sndRunOn && sndRun && loc && loc.active) {
				sndRunPlay();
			}
		}
		
		// Move unit to coordinates
		public function setPos(nx:Number, ny:Number):void {
			coordinates.X = nx;
			coordinates.Y = ny;
			boundingBox.center(coordinates);
			setCel();
		}
		
		// [Going beyond the location]
		public function outLoc(napr:int, portX:Number = -1, portY:Number = -1):Boolean {
			// [1-left, 2-right, 3-down, 4-up]
			// [for all except yy, should return false]
			if (isFly || levit) {
				return false;
			}
			
			if (napr == 3) {
				if (loc.bezdna || jumpdy <= 0 || sost == 3) {		// [falling outside the location]
					disabled = true;
					velocity.Y = 0;
					
					if (sost == 3) {
						sost = 4;
						loc.remObj(this);
					}
					
					remVisual();
				}
				else {
					velocity.Y = -jumpdy;
					velocity.X = storona * maxSpeed;
				}
			} 
			
			return false;
		}
		
		// [gradual appearance]
		public function emergence(n:int=30):void {
			t_emerg = n;
			max_emerg = n;
		}

		// [Current forces]
		public function forces():void {
			if (levit) {
				velocity.multiply(0.80);
				isLaz = 0;
			}

			if (isPlav) {
				if (!levit) {
					velocity.Y += World.ddy * ddyPlav;
				}
				
				velocity.multiply(0.80);
			}
			else if (isFly) {
				if (t_throw <= 0) {
					if ((velocity.X * velocity.X + velocity.Y * velocity.Y) > maxSpeed * maxSpeed) {
						velocity.multiply(0.70);
					}
					
					if (velocity.X > -brake && velocity.X < brake) {
						velocity.X = 0;
					}
					
					if (velocity.Y > -brake && velocity.Y < brake) {
						velocity.Y = 0;
					}
				}
			}
			else {
				if (inWater) {
					velocity.X *= 0.5;
				}
				
				if (!levit && !isLaz) {
					var t:Tile = loc.getAbsTile(coordinates.X, coordinates.Y - boundingBox.height * 0.25);
					
					if (t.grav > 0 && velocity.Y < World.maxdy * t.grav || t.grav < 0 && velocity.Y > World.maxdy * t.grav) {
						velocity.Y += World.ddy * t.grav * grav;
					}
				}
				
				if (stay) {
					// Apply friction
					velocity.X *= tormoz;
					
					if (walk < 0) {
						if (velocity.X < -maxSpeed) {
							velocity.X += brake;
						}
					}
					else if (walk > 0) {
						if (velocity.X > maxSpeed) {
							velocity.X -= brake;
						}
					}
					else {
						if (velocity.X > -brake && velocity.X < brake) {
							velocity.X = 0;
						}
						else if (velocity.X > 0) {
							velocity.X -= brake;
						}
						else if (velocity.X < 0) {
							velocity.X += brake;
						}
					}
					
					if (loc.quake && massa <= 2 && sost == 1) {
						var pun:Number = (1 + (2 - massa) / 2) * loc.quake;
						
						if (pun > 10) {
							pun = 10;
						}
						
						velocity.Y = -pun * Math.random();
						velocity.X += pun * (Math.random() * 2 - 1);
					}
				}
			}
			
			if (slow) {
				velocity.multiply(0.75);
			}
			
			osndx = 0;
			osndy = 0;
			
			if (stayOsn) {
				if (stayOsn.cdx>10 || stayOsn.cdx<-10 || stayOsn.cdy>10 || stayOsn.cdy<-10) {
					stay = false;
				}
				else {
					osndx = stayOsn.cdx;
					osndy = stayOsn.cdy;
				}
			}
			
			stayOsn = null;
		}

		public function run(div:int = 1):void {
			if (loc.sky) {
				run2(div);
				return;
			}

			// [Movement] | движение
			var t:Tile;
			var t2:Tile;
			var i:int;
			var newmy:Number = 0;
			var autoSit:Boolean = false;

			// Walking up or down stairs
			if (!throu && stay && diagon && velocity.Y >= 0) {
				
				var dxdiv:Number = velocity.X / div;
				var slopeY:Number = (dxdiv * diagon); 

				if (collisionAll(dxdiv, dxdiv * diagon * -1)) {
					if (slopeY < 0 && !collisionAll(dxdiv, 0)) {
						diagon = 0;
					}
				}
				else {	// Apply sloped movement
					coordinates.X += dxdiv;
					coordinates.Y -= slopeY;
					velocity.Y = 0;
					checkDiagon(0);
				}

				return;
			}

			// Otherwise, indicate we're not on a slope
			diagon = 0;
			
			//HORIZONTAL
			if (!isLaz) {
				coordinates.X += (velocity.X + osndx) / div;
				
				if (coordinates.X - boundingBox.halfWidth < 0) {
					if (!outLoc(1)) {
						coordinates.X = boundingBox.halfWidth;
						velocity.X = Math.abs(velocity.X) * elast;
						turnX = 1;
						kray = true;
					}
				}
				
				if (coordinates.X + boundingBox.halfWidth >= loc.maxX) 	{
					if (!outLoc(2)) {
						coordinates.X = loc.maxX - 1 - boundingBox.halfWidth;
						velocity.X = -Math.abs(velocity.X) * elast;
						turnX = -1;
						kray = true;
					}
				}
				
				boundingBox.center(coordinates);
				
				// [Move left]
				if (velocity.X + osndx < 0) {
					if (!player && stay && shX1 > 0.50) {
						newmy = checkDiagon(-5);
						
						if (newmy > 0) {
							coordinates.Y = newmy;
							boundingBox.flatten(coordinates);
						}
					}
					
					if (player && !isSit && !isFly && !isPlav && !levit && (!stay || isUp || shX1 > 0.5)) {
						newmy=checkDiagon(-2, -1);
						
						if (newmy > 0) {
							coordinates.Y = newmy;
							boundingBox.flatten(coordinates);
						}
					}
					
					if (player && isUp && stay && !isSit) {
						var x:Number = boundingBox.left / tileX;
						var y:Number = boundingBox.top / tileY;
						t = loc.getTile(x, y);
						t2 = loc.getTile(x, y + 1);
						
						if ((t.phis==0 || t.phis==3) && !(t2.phis==0 || t2.phis==3) && t2.zForm==0) {
							coordinates.Y = t2.boundingBox.top;
							boundingBox.bottom = t2.boundingBox.top;
							sit(true);
							autoSit = true;
						}
					}
					
					if (mater) {
						for (i = int(boundingBox.top/tileY); i <= int(boundingBox.bottom/tileY); i++) {
							t = loc.getTile(int(boundingBox.left/tileX), i);
						
							if (collisionTile(t)) {
								if (t.door && t.door.inter) {
									pumpObj=t.door.inter;
								}
							
								if (boundingBox.bottom-t.boundingBox.top<=(stay?porog:porog_jump) && !collisionAll(-20,t.boundingBox.top-boundingBox.bottom)) {
									coordinates.Y = t.boundingBox.top;
								}
								else {
									// Left side collision detection / resolution
									coordinates.X = t.boundingBox.right + boundingBox.halfWidth;
									
									if (t_throw > 0 && velocity.X < -damWallSpeed && damWall) {
										damageWall(2);
									}

									if (destroy > 0 && destroyWall(t, 1)) {
										velocity.X *= 0.75;
									}
									else {
										velocity.X = Math.abs(velocity.X) * elast;
										turnX = 1;

										if (t.mat == 1) {
											tykMat = 1;
										}

										boundingBox.center(coordinates);
									}
								}
							}
						}
					}
				}
				
				// [Move right]
				if (velocity.X + osndx > 0) {
					if (!player && stay && shX2 > 0.5) {
						newmy = checkDiagon(-5);
						
						if (newmy > 0) {
							coordinates.Y = newmy;
							boundingBox.flatten(coordinates);
						}
					}
					
					if (player && !isSit && !isFly && !isPlav && !levit && (!stay || isUp || shX2 > 0.5)) {
						newmy = checkDiagon(-2, 1);
						
						if (newmy > 0) {
							coordinates.Y = newmy;
							boundingBox.flatten(coordinates);
						}
					}
					
					if (player && isUp && stay && !isSit) {
						var x:Number = boundingBox.right / tileX;
						var y:Number = boundingBox.top / tileY;
						t = loc.getTile(x, y);
						t2 = loc.getTile(x, (y + 1));
						
						if ((t.phis==0 || t.phis==3) && !(t2.phis==0 || t2.phis==3) && t2.zForm==0) {
							coordinates.Y  = t2.boundingBox.top;
							boundingBox.bottom = t2.boundingBox.top;
							sit(true);
							autoSit = true;
						}
					} 
					
					if (mater) {
						for (i = int(boundingBox.top / tileY); i <= int(boundingBox.bottom / tileY); i++) {
							t = loc.getTile(int(boundingBox.right / tileX), i);
						
							if (collisionTile(t)) {
								if (t.door && t.door.inter) {
									pumpObj=t.door.inter;
								}
								
								if (boundingBox.bottom - t.boundingBox.top<=(stay ? porog : porog_jump) && !collisionAll(20, t.boundingBox.top - boundingBox.bottom)) {
									coordinates.Y = t.boundingBox.top;
								}
								else {

									// Right side collision detection / resolution
									coordinates.X = t.boundingBox.left - boundingBox.halfWidth;
								
									if (t_throw > 0 && velocity.X > damWallSpeed && damWall) {
										damageWall(1);
									}
								
									if (destroy > 0 && destroyWall(t, 2)) {
										velocity.X *= 0.75;
									}
									else {
										velocity.X = -Math.abs(velocity.X) * elast;
										turnX = -1;

										if (t.mat == 1) {
											tykMat = 1;
										}

										boundingBox.center(coordinates);
									}
								}
							}
						}
					}
				}

				boundingBox.flatten(coordinates);
			}
			//отталкивание | [Repulsion]
			
			
			//VERTICAL
			//downward movement
			newmy = 0;
			
			if (velocity.Y + osndy > 0) {
				if (velocity.Y > 0) {
					stay = false;
					stayPhis = 0;
					stayMat = 0;
				}
				
				shX1 = 1;
				shX2 = 1; //if > 0, then you are not completely standing on the floor

				// Flying, levitating or swimming
				if (levit || plav && isPlav || isFly)  {
					diagon = 0;
					coordinates.Y += (velocity.Y + osndy) / div;
					
					if (coordinates.Y > loc.maxY && !outLoc(3)) {
						coordinates.Y = loc.maxY - 1;
						velocity.Y = 0;
						turnY = -1;
					}
					
					boundingBox.flatten(coordinates);
					
					if (mater) {
						// Collision check below unit
						for (i = int(boundingBox.left / tileX); i <= int(boundingBox.right / tileX); i++) {
							t = loc.getTile(i, int(boundingBox.bottom/tileY));
							
							if (collisionTile(t)) {
								coordinates.Y = t.boundingBox.top;
								boundingBox.flatten(coordinates);
								velocity.Y = 0;
								turnY = -1;
								
								if (t.mat == 1) {
									tykMat = 1;
								}
							}
						}
					}
				}
				// [a fall]
				else  {						
					if (mater) {
						// Collision check below unit
						for (i = int(boundingBox.left/tileX); i<=int(boundingBox.right/tileX); i++) {
							t = loc.getTile(i, int(boundingBox.bottom + velocity.Y / div) / tileY);
							
							if (collisionTile(t, 0, velocity.Y / div)) {
								if (-(boundingBox.left - t.boundingBox.left) / boundingBox.width < shX1) {
									shX1 = -(boundingBox.left - t.boundingBox.left) / boundingBox.width;
								}
								
								if ((boundingBox.right - t.boundingBox.right) / boundingBox.width < shX2) {
									shX2 = (boundingBox.right - t.boundingBox.right) / boundingBox.width;
								}
								
								newmy = t.boundingBox.top;
								
								if (t.mat > 0) {
									stayMat = t.mat;
								}
								
								if (t.phis >= 1 && !(transT && t.phis == 3)) {
									stayPhis = 1;
									
									if (t_throw > 0 && velocity.Y > damWallSpeed && damWall) {
										damageWall(3);
									}
									
									if (destroy > 0 || massa >= 1) {
										destroyWall(t, 3);
									}
								}
								else if (t.shelf && stayPhis == 0) {
									stayPhis = 2;
									stayMat = t.mat;
								}
								
								diagon = 0;
							}
						}
					}

					// Check for stairs
					if (newmy == 0 && !throu) {
						newmy = checkDiagon(velocity.Y / div);
					}

					// Check for a beam
					if (newmy == 0 && !throu) {
						newmy = checkShelf(velocity.Y / div, osndy / div);
					}

					if (newmy)  {
						boundingBox.top = newmy - boundingBox.height;
						
						for (i = int(boundingBox.left / tileX); i <= int(boundingBox.right / tileX); i++) {
							t = loc.getTile(i, int((newmy - boundingBox.height) / tileY));
							
							if (collisionTile(t)) {
								newmy = 0;
							}
						}
					}
					
					if (newmy) {
						coordinates.Y = newmy;
						boundingBox.top = coordinates.Y - boundingBox.height;
						boundingBox.bottom = coordinates.Y;
						
						if (velocity.Y > 16) {
							makeNoise(noiseRun, true);
						}
						else if (velocity.Y > 9) {
							makeNoise(noiseRun * 0.50, true);
						}
						
						if (velocity.Y > 5) {
							sndFall();
						}
						
						if (jumpBall > 0 && velocity.Y > 3) {
							velocity.Y = -velocity.Y * jumpBall;
							turnY=-1;
						}
						else {
							velocity.Y = 0;
						}

						stay = true;
						fracLevit = 0;
		
						isLaz = 0;
					}
					else {
						coordinates.Y += velocity.Y / div;
						boundingBox.flatten(coordinates);
					}
					
					if (coordinates.Y > loc.maxY) {
						if (!outLoc(3)) {
							coordinates.Y = loc.maxY - 1;
							turnY = -1;
							boundingBox.flatten(coordinates);
						}
					}
				}
			}
			// [Upward movement] | движение вверх
			if (velocity.Y + osndy < 0) {
				if (velocity.Y < 0) {
					stay = false;
					diagon = 0;
				}
				
				if (coordinates.Y - boundingBox.height < 0) {
					if (!outLoc(4)) {
						coordinates.Y = boundingBox.height - 0.10;
						velocity.Y = 0;
						turnY = 1;
					}
				}
				
				if (velocity.Y > 0) {
					newmy = checkShelf(velocity.Y / div, osndy / div);
					
					if (newmy) {
						coordinates.Y = newmy;
						boundingBox.flatten(coordinates);
						velocity.Y = 0;
						stay = true;
					}
				}
				else {
					coordinates.Y += (velocity.Y + osndy) / div;
					boundingBox.flatten(coordinates);
				}

				if (mater) {
					for (i = int(boundingBox.left / tileX); i <= int(boundingBox.right / tileX); i++) {
						t = loc.getTile(i, int(boundingBox.top / tileY));
					
						if (collisionTile(t)) {
							if (t_throw > 0 && velocity.Y < -damWallSpeed && damWall) {
								damageWall(4);
							}
							
							if (destroy > 0) {
								destroyWall(t, 4);
							}
							
							coordinates.Y = t.boundingBox.bottom + boundingBox.height;
							boundingBox.flatten(coordinates);
							velocity.Y = 0;
							turnY = 1;
						
							if (t.mat == 1) {
								tykMat = 1;
							}
						
							stay = false;
						}
					}
				}
			} 
			
			if (autoSit) {
				autoSit = false;	
				unsit();
			}
		}
		
		public function run2(div:int = 1):void {
			const MIN_Y_POSITION:Number = 0.10;
			const BOUNDARY_OFFSET:int = 1;

			// Early exit if div is zero to prevent division by zero
			if (div == 0) {
				trace("Error: Division by zero in run2");
				return;
			}

			// Calculate reciprocal once if div is not 1
			var reciprocalDiv:Number = (div !== 1) ? 1 / div : 1;

			// Update coordinates using precomputed reciprocal
			coordinates.X += velocity.X * reciprocalDiv;
			coordinates.Y += velocity.Y * reciprocalDiv;

			// Precompute half width
			var halfWidth:Number = boundingBox.halfWidth;

			// Cache map boundaries
			var maxX:Number = loc.maxX;
			var maxY:Number = loc.maxY;

			// Handle X-axis boundaries
			if (coordinates.X - halfWidth < 0) {
				coordinates.X = halfWidth;
				velocity.X = Math.abs(velocity.X) * elast;
				turnX = 1;
			}
			else if (coordinates.X + halfWidth >= maxX) {
				coordinates.X = maxX - BOUNDARY_OFFSET - halfWidth;
				velocity.X = -Math.abs(velocity.X) * elast;
				turnX = -1;
			}

			// Handle Y-axis boundaries
			if (coordinates.Y - boundingBox.height < 0) {
				coordinates.Y = boundingBox.height - MIN_Y_POSITION;
				velocity.Y = 0;
				turnY = 1;
			}
			else if (coordinates.Y > maxY) {
				coordinates.Y = maxY - BOUNDARY_OFFSET;
				velocity.Y = 0;
				turnY = -1;
			}

			// Center the object after movement and boundary adjustments
			boundingBox.center(coordinates);
		}
		
		// Crouch
		public function sit(turn:Boolean):void {
			
			// Already crouched, exit
			if (isSit == turn) {
				return;
			}
			
			// Update the sitting state
			isSit = turn;
			
			// Adjust dimensions for crouching
			if (isSit) {
				boundingBox.width = _crouchingWidth;
				boundingBox.height = _crouchingHeight;
			}
			// Adjust dimensions for standing
			else {
				boundingBox.width = _standingWidth;
				boundingBox.height = _standingHeight;
			}
			
			// Re-center the bounding box after dimension change
			boundingBox.center(coordinates);
		}
		
		// Stand up
		public function unsit():void {
			sit(false); // Attempt to stand up
			
			// Check for collisions after standing up
			if (collisionAll()) {
				sit(true); // Revert to sitting if collision is detected
			}
		}
		
		// Check if the unit's bounding box collides with any tiles
		public function collisionAll(offsetX:Number = 0, offsetY:Number = 0):Boolean {
			
			// If the location is designated as 'sky', no collision is possible
			if (loc.sky) {
				return false;
			}
			
			// Cache reciprocal of tile sizes for faster multiplication
			var invTileX:Number = 1 / tileX;
			var invTileY:Number = 1 / tileY;

			// Cache map boundaries
			var maxSpaceX:int = loc.spaceX;
			var maxSpaceY:int = loc.spaceY;

			// Precompute tile index ranges and clamp them to map boundaries
			var startI:int = Math.max(int((boundingBox.left + offsetX) * invTileX), 0);
			var endI:int = Math.min(int((boundingBox.right + offsetX) * invTileX), maxSpaceX - 1);

			var startJ:int = Math.max(int((boundingBox.top + offsetY) * invTileY), 0);
			var endJ:int = Math.min(int((boundingBox.bottom + offsetY) * invTileY), maxSpaceY - 1);

			// Iterate over the relevant tiles to check for collisions with the unit's bounding box
			for (var i:int = startI; i <= endI; i++) {
				for (var j:int = startJ; j <= endJ; j++) {
					// Directly access the tile since indices are already clamped
					if (collisionTile(loc.getTile(i, j), offsetX, offsetY)) {
						return true;
					}
				}
			}
			
			// No collisions detected
			return false;
		}
		
		// Checks collision between the character's bounding box and a tile's bounding box.
		public function collisionTile(t:Tile, gx:Number = 0, gy:Number = 0):int {
			if (!t || (t.phis == 0 || (transT && t.phis == 3)) && !t.shelf) {
				return 0; // No collision
			} 
			
			var adjustedBox:BoundingBox = new BoundingBox(new Vector2(0, 0));
			adjustedBox.setBounds(
				boundingBox.left + gx,
				boundingBox.right + gx,
				boundingBox.top + gy,
				boundingBox.bottom + gy
			);

			if (!adjustedBox.intersects(t.boundingBox)) {
				return 0; // No collision
			}

			// Corrected shelf condition
			if (t.shelf && (t.phis == 0 || (transT && t.phis == 3)) &&
				(boundingBox.bottom - (stay ? porog : porog_jump) > t.boundingBox.top || throu || t_throw > 0 || levit || isFly || diagon != 0)) {
				return 0; // No collision with the shelf
			}

			return 1; // Collision detected
		}

		// Search for stairs
		public function checkStairs(ny:int = -1, nx:int = 0):Boolean {
			
			var i:int = int((coordinates.X + nx) / tileX);
			var j:int = int((coordinates.Y + ny) / tileY);

			if (j >= loc.spaceY) {
				j = loc.spaceY - 1;
			}
			
			if (loc.getTile(i, j).phis >= 1 && !(transT&&loc.getTile(i, j).phis == 3)) {
				isLaz = 0;
				return false;
			}
			
			if ((loc.getTile(i, j)).stair) {
				isLaz = (loc.getTile(i, j)).stair;
				storona = (loc.getTile(i, j)).stair;

				if (isLaz == -1) {
					coordinates.X = (loc.getTile(i, j)).boundingBox.left + boundingBox.halfWidth;
				}
				else {
					coordinates.X = (loc.getTile(i, j)).boundingBox.right - boundingBox.halfWidth;
				}
				
				boundingBox.center(coordinates);	// Center the character on the horizontal axis
				stay = false;				// Indicate that the character is no standing on the ground
				sit(false);					// The character is not crouched 
				
				return true;
			}

			// Reset ladder state if no stairs/ladder are found
			isLaz = 0;
			
			return false; // No stairs detected
		}

		// Checks if the character is in water and updates the relevant states. Returs True if the character is swimming (isPlav), otherwise false.
		public function checkWater():Boolean {
			const HEIGHT_MULTIPLIER_TOP:Number = 0.75;
			const HEIGHT_MULTIPLIER_BOTTOM:Number = 0.25;
			
			// Store the previous water state
			var wasInWater:Boolean = inWater;

			// Cache map boundaries to avoid repeated property accesses
			var maxSpaceX:int = loc.spaceX;
			var maxSpaceY:int = loc.spaceY;

			// Precompute adjusted Y coordinates based on object height
			var adjustedYTop:Number = coordinates.Y - boundingBox.height * HEIGHT_MULTIPLIER_TOP;
			var adjustedYBottom:Number = coordinates.Y - boundingBox.height * HEIGHT_MULTIPLIER_BOTTOM;

			// Calculate tile indices for the top position
			var x:int = Math.floor(coordinates.X / tileX);
			var y:int = Math.floor(adjustedYTop / tileY);

			// Clamp x and y to valid ranges
			x = clamp(x, 0, maxSpaceX - 1);
			y = clamp(y, 0, maxSpaceY - 1);

			// Retrieve the tile at (x, y)
			var t:Tile = loc.getTile(x, y);

			// Handle invalid tile access
			if (t == null) {
				trace("Unit.as/checkWater() - Error: Tile 1 tried to retrieve an invalid tile from: (" + x + ", " + y + ")");
				return false;
			}

			// Determine water state based on the tile's water property
			if (t.water > 0) {
				isPlav = true;
				inWater = true;

				if (isPlav) { // Assuming 'plav' should be 'isPlav'
					stay = false;
					sit(false);
				}
			}
			else {
				// Calculate tile indices for the bottom position
				var y2:int = Math.floor(adjustedYBottom / tileY);
				y2 = clamp(y2, 0, maxSpaceY - 1);

				// Retrieve the tile at (x, y2)
				var t2:Tile = loc.getTile(x, y2);

				// Handle invalid tile access
				if (t2 == null) {
					trace("Unit.as/checkWater() - Error: Tile 2 tried to retrieve an invalid tile from: (" + x + ", " + y2 + ")");
					return false;
				}

				// Update water state based on the bottom tile
				isPlav = false;
				if (boundingBox.height <= tileY) {
					inWater = false;
				}
				else if (t2.water > 0) {
					inWater = true;
				}
				else {
					inWater = false;
				}
			}

			// Handle events when water state changes
			if (wasInWater != inWater) {
				if (Math.abs(velocity.Y) > 8 || plaKap) {
					Emitter.emit('kap', loc, coordinates.X, coordinates.Y - boundingBox.height * HEIGHT_MULTIPLIER_BOTTOM + velocity.Y, {
						dy: -Math.abs(velocity.Y) * (Math.random() * 0.3 + 0.3),
						kol: int(Math.abs(velocity.Y * massa * 2) + 1)
					});
				}

				if (wasInWater != inWater && velocity.Y > 5) {
					playFallSound();
				}

				if (wasInWater != inWater && velocity.Y < -5 && massa > 0.4) {
					sound('fall_water2', 0, -velocity.Y / 10);
				}
			}

			// Emit water splash if moving horizontally while in water
			if (inWater && !isPlav && Math.abs(velocity.X) > 3) {
				Emitter.emit('kap', loc, coordinates.X, coordinates.Y - boundingBox.height * HEIGHT_MULTIPLIER_BOTTOM, { rx: boundingBox.width });
			}

			// Handle the 'namok' effect when swimming
			if (isPlav) {
				namok_t++;
				if (namok_t >= 100) {
					namok_t = 0;
					addEffect('namok');
				}
			}
			else if (namok_t > 0) {
				namok_t--;
			}

			return isPlav;
		}

		// Clamps a value between a minimum and maximum range.
		private function clamp(value:int, min:int, max:int):int {
			if (value < min) {
				return min;
			}
			
			if (value > max) {
				return max;
			}
			
			return value;
		}

		// Plays the appropriate falling sound based on the character's mass -- (only for water right now)
		private function playFallSound():void {
			if (massa > 2.00) {
				sound('fall_water0', 0, velocity.Y / 10);
			}
			else if (massa > 0.40) {
				sound('fall_water1', 0, velocity.Y / 10);
			}
			else if (massa > 0.20) {
				sound('fall_water2', 0, velocity.Y / 10);
			}
			else {
				sound('fall_item_water', 0, velocity.Y / 10);
			}
		}

		// This checks for physics objects to stand on and returns the top of their boundingbox
		public function checkShelf(pdy:Number, pdy2:Number = 0):Number {
			for (var i in loc.objs) {
				var b:Box=loc.objs[i] as Box;
				
				if (!b.invis && b.shelf && !b.levit && !(boundingBox.right < b.boundingBox.left || boundingBox.left > b.boundingBox.right) && boundingBox.bottom + pdy2 <= b.boundingBox.top && boundingBox.bottom + pdy + pdy2 > b.boundingBox.top) {
					shX1 = 1;
					shX2 = 1;
					
					if (-(boundingBox.left - b.boundingBox.left) / boundingBox.width < shX1) {
						shX1 = -(boundingBox.left - b.boundingBox.left) / boundingBox.width;
					}
					
					if ((boundingBox.right - b.boundingBox.right) / boundingBox.width < shX2) {
						shX2 = (boundingBox.right - b.boundingBox.right) / boundingBox.width;
					}
					
					stayMat = b.mat;
					stayPhis = 2;
					stayOsn = b;
					
					if (!b.stay) {
						b.velocity.Y += velocity.Y * massa / (massa + b.massa);
						b.fixPlav=false;
					}
					
					return b.boundingBox.top;
				}
			}
			
			return 0;
		}
		
		// [Search for steps]
		public function checkDiagon(velN:Number, napr:int = 0):Number {
			var ddy:Number;
			var newmy:Number = 0;
			var t:Tile = loc.getAbsTile(coordinates.X, coordinates.Y + velocity.Y);
			
			if (diagon == 0) {
				if (t.diagon != 0 && (napr==0 || t.diagon==napr)) {
					ddy = t.getMaxY(coordinates.X);
					
					if (ddy < coordinates.Y + velN) {
						diagon = t.diagon;
						newmy = ddy;
					}
				}
				else {
					t = loc.getAbsTile(coordinates.X, coordinates.Y + 40);
					
					if (t.diagon != 0 && (napr == 0 || t.diagon == napr)) {
						ddy = t.getMaxY(coordinates.X);
						
						if (ddy < coordinates.Y + velN) {
							diagon = t.diagon;
							newmy = ddy;
						}
					}
				}
			}
			else
			{
				if (t.diagon != 0 && (napr == 0 || t.diagon == napr)) {
					ddy = t.getMaxY(coordinates.X);
					diagon = t.diagon;
					newmy = ddy;
				}
				else {
					t = loc.getAbsTile(coordinates.X, coordinates.Y - 40);
					
					if (t.diagon!=0 && (napr==0 || t.diagon==napr)) {
						ddy=t.getMaxY(coordinates.X);
						diagon = t.diagon;
						newmy = ddy;
					}
					else {
						diagon = 0;
					}
				}
			}
			
			if (diagon != 0 && (napr == 0 || t.diagon == napr)) {
				shX1 = 0;
				shX2 = 0;
				stayPhis = 2;
				stayMat = t.mat;
			}
			
			return newmy;
		}
		
		// [teleportation]
		public function teleport(nx:Number,ny:Number,eff:int=0):void {
			if (eff > 0) {
				Emitter.emit('tele', loc, coordinates.X, coordinates.Y - boundingBox.halfHeight, {rx:boundingBox.width, ry:boundingBox.height, kol:30});
			}
			
			setPos(nx, ny);
			
			if (currentWeapon) {
				setWeaponPos(currentWeapon.tip);
				currentWeapon.setNull();
			}
			
			isLaz = 0;
			levit = 0;
			
			if (eff > 0) {
				Emitter.emit('teleport', loc, coordinates.X, coordinates.Y - boundingBox.halfHeight);
			}
		}
		
		// [Tear away from a fixed place] I think this is for grabbing turrets.
		public function otryv():void {
			fixed = false;
		}

		public static function initIcos():void {
			arrIcos = [];
			var unitList:XMLList = XMLDataGrabber.getNodesWithName("core", "AllData", "units", "unit");
			
			for each(var xml in unitList) {
				if (xml.@cat=='3') {
					var bmpd:BitmapData;
					var ok:Boolean=false;
					
					if (xml.vis.length() && xml.vis.@vclass.length()) {
						var dvis:MovieClip=Res.getVis(xml.vis.@vclass);
						var sprX:int=dvis.width+2;
						var sprY:int=dvis.height+2;
						bmpd=new BitmapData(sprX,sprY,true,0x00000000);
						var m:Matrix=new Matrix();
						m.tx=-dvis.getRect(dvis).left;
						m.ty=-dvis.getRect(dvis).top;
						bmpd.draw(dvis,m);
						ok=true;
					}
					
					if (ok) {
						var bmp:Bitmap=new Bitmap(bmpd);
						arrIcos[xml.@id]=bmp;
					}
				}
			}

			unitList = null; // Manual cleanup.
		}
		
		public static function initIco(nid:String):void {
			if (arrIcos==null) {
				arrIcos=[];
			}
			
			if (arrIcos[nid]) {
				return;
			}
			
			var xml:XML = XMLDataGrabber.getNodeWithAttributeThatMatches("core", "AllData", "units", "id", nid);

			if (xml.vis.length() && xml.vis.@blit.length()) {
				var bmpd:BitmapData;
				var data:BitmapData=World.w.grafon.getSpriteList(xml.vis.@blit);
				
				if (data == null) {
					return;
				}
				
				var sprX:int=xml.vis.@sprX;
				var sprY:int=(xml.vis.@sprY>0)?xml.vis.@sprY:sprX;
				var begSprX:int=(xml.vis.@icoX>0)?xml.vis.@icoX:0;
				var begSprY:int=(xml.vis.@icoY>0)?xml.vis.@icoY:0;
				var rect:Rectangle = new Rectangle(begSprX*sprX, begSprY*sprY, (begSprX+1)*sprX, (begSprY+1)*sprY);
				bmpd=new BitmapData(sprX,sprY);
				bmpd.copyPixels(data,rect,new Point(0,0));
				var bmp:Bitmap=new Bitmap(bmpd);
				arrIcos[nid]=bmp;
			}
		}
		
		public function initBlit():void {
			blitData=World.w.grafon.getSpriteList(blitId);
			blitRect = new Rectangle(0, 0, blitX, blitY);
			blitPoint = new Point(0,0);
			vis = new MovieClip();
			var osn:Sprite = new Sprite();
			visData = new BitmapData(blitX, blitY, true, 0);
			visBmp = new Bitmap(visData);
			vis.addChild(osn);
			osn.addChild(visBmp);
			
			if (blitDX >= 0) {
				visBmp.x = -blitDX;
			}
			else {
				visBmp.x = -blitX / 2;
			}
			
			if (blitDY >= 0) {
				visBmp.y = -blitDY;
			}
			else {
				visBmp.y = -blitY + 10;
			}
			
			animState = "stay";
		}
		
		public function blit(blstate:int, blframe:int):void {
			blitRect.x = blframe * blitX;
			blitRect.y = blstate * blitY;
			visData.copyPixels(blitData, blitRect, blitPoint);
		}
		
		public override function addVisual():void {
			if (disabled) {
				return;
			}
			
			trigDis = !checkTrig();
			
			if (trigDis) {
				return;
			}
			
			super.addVisual();
			
			if (!player && !hpbar && vis) {
				hpbar = SymbolFactory.createInstance("hpBar") as MovieClip;
				
				if (hero <= 0) {
					hpbar.goldstar.visible = false;
				}
				
				if (invis) {
					hpbar.visible = false;
				}
				
				visDetails();
			}
			
			if (hpbar && loc && loc.active) {
				World.w.grafon.visObjs[3].addChild(hpbar);
			}
			
			if (cTransform && ctrans) {
				vis.transform.colorTransform=cTransform;
			}
			
			if (childObjs) {
				for (var i in childObjs) {
					if (childObjs[i]!=null && childObjs[i].vis) {
						childObjs[i].addVisual();
					}
				}
			}
		}
		
		public override function remVisual():void {
			super.remVisual();
			
			if (hpbar && hpbar.parent) {
				hpbar.parent.removeChild(hpbar);
			}
			
			if (childObjs) {
				for (var i in childObjs) {
					if (childObjs[i]) childObjs[i].remVisual();
				}
			}
		}
		
		public function animate():void {

		}
		
		protected function sndFall():void {

		}
		
		private function sndRunPlay():void {
				if (rasst2 < sndRunDist * sndRunDist) {
					sndVolkoef = (sndRunDist - Math.sqrt(rasst2)) / sndRunDist;

					if (sndVolkoef < 0.5) {
						sndVolkoef *= 2;
					}
					else {
						sndVolkoef = 1;
					}

					Snd.pshum(sndRun, sndVolkoef);
				}
		}
		
		public function newPart(nid:String,kol:int=1,frame:int=0):void {
			Emitter.emit(nid, loc, coordinates.X, coordinates.Y - boundingBox.halfHeight, {kol:kol, frame:frame});
		}

		public function setVisPos():void {
			if (vis) {
				vis.x = coordinates.X;
				vis.y = coordinates.Y;
				vis.scaleX = storona;
			}
		}

		public function visDetails():void {
			if (hpbar == null) {
				return;
			}

			if ((hp < maxhp || armorQual > 0 && armor_hp < armor_maxhp || hero > 0) && hp > 0 && !invis || boss) {
				if (boss) {
					World.w.gui.hpBarBoss(hp / maxhp);
					hpbar.visible = false;
				}
				else {
					hpbar.visible = true;
					
					if (hp < maxhp) {
						hpbar.bar.visible = true;
						hpbar.bar.gotoAndStop(Math.floor((1 - hp / maxhp) * 20 + 1));
					}
					else {
						hpbar.bar.visible = false;
					}
					
					if (armorQual > 0) {
						hpbar.armor.visible = true;
						hpbar.armor.gotoAndStop(Math.floor((1 - armor_hp / armor_maxhp) * 20 + 1));
					}
					else {
						hpbar.armor.visible = false;
					}
				}
			}
			else {
				hpbar.visible = false;
			}
		}
		
		public function setHpbarPos():void {
			if (boss) {
				hpbar.y = 60;
				hpbar.x = World.w.cam.screenX / 2;
			}
			else {
				hpbar.y = coordinates.Y - _standingHeight - 20;
				
				if (hpbar.y < 20) {
					hpbar.y = 20;
				}
				
				hpbar.x = coordinates.X;
				
				if (loc && loc.zoom != 1) {
					hpbar.scaleX = hpbar.scaleY = loc.zoom;
				}
			}
		}
		
		public function sound(sid:String, msec:Number=0, vol:Number=1):SoundChannel {
			return Snd.ps(sid, coordinates.X, coordinates.Y, msec, vol);
		}

		public function actions():void {
			
			if (isNaN(velocity.X)) {
				velocity.X = 0;
			}
			
			if (isNaN(velocity.Y)) {
				velocity.Y = 0;
			}
			
			if (neujaz > 0) {
				neujaz--;
			}
			
			if (shok > 0) {
				shok--;
			}
			
			if (detectionDelay > 0) {
				if (opt && opt.izvrat && World.w.pers.socks || noAgro) {
					// Do nothing
				}
				else {
					// Start noticing player
					detectionDelay--;
				}
			}
			
			if (noise > 0) {
				noise -= 20;
			}
			
			if (noise_t > 0) {
				noise_t--;
			}
			
			//шум при ходьбе
			if (stay && (velocity.X > 12|| velocity.X < -12))  {
				makeNoise(noiseRun);
			}
			else if (stay && (velocity.X > 7 || velocity.X < -7))  {
				makeNoise(noiseRun / 2);
			}
			else if (stay && (velocity.X > 3 || velocity.X < -3))  {
				makeNoise(noiseRun / 4);
			}
			
			if (isFly && (velocity.X > 3 || velocity.X < -3 || velocity.Y > 3 || velocity.Y < -3))  {
				makeNoise(noiseRun / 2);
			}
			
			//положение глаз
			eyeX = coordinates.X + boundingBox.width * 0.25 * storona;
			eyeY = coordinates.Y - boundingBox.height * 0.75;
			
			// [Levitation]
			if (sost == 1) {
				if (levit) {
					levit_r++;
				}
				else {
					if (levit_r == 1) {
						levitPoss = true;
					}
					
					if (levit_r > 60) {
						levit_r = 60;
					}
					
					if (levit_r > 0) {
						levit_r--;
					}
				}
			}
			
			if (levit) {
				if (!fixed && massa != massaMove) {
					otryv();
				}
				
				if (fixed) {
					if (levit_r > 75) {
						otryv();
					}
				}
				
				massa = massaMove;
			}
			
			if (demask > 0) {
				demask -= 5;
			}
			
			if (effects.length > 0) {
				for (var i:int = 0; i < effects.length; i++) {
					if ((effects[i] as Effect).vse) {
                        effects.splice(i, 1);
                        i--;
                    }
					else {
						(effects[i] as Effect).step();
					}
				}
			}
			
			//урон от воды
			//периодические эффекты
			if (cut > 0 || poison > 0 || inWater && loc.wdam > 0) {
				if (t_hp <= 0) {
					t_hp = 30;
					
					if (cut > 0) {
						damage(Math.sqrt(cut), Resistances.DAM_BLEED, null, true);
						cut -= critHeal;
						
						if (cut < 0) {
							cut = 0;
						}
					}
					
					if (poison > 0) {
						damage(Math.sqrt(poison), Resistances.DAM_POISON, null, true);
						poison -= critHeal;
						
						if (poison < 0) {
							poison = 0;
						}
						
						Emitter.emit('poison', loc, coordinates.X, coordinates.Y - boundingBox.height * 0.5);
					}
					
					if (inWater && loc.wdam > 0) {
						damage(loc.wdam, loc.wtipdam, null, true);
					}
				}
			}
			
			if (stun > 0) {
				stun--;
				if (stun%10 == 0) {
					if (opt && opt.robot) {
						Emitter.emit('discharge', loc, coordinates.X, coordinates.Y - boundingBox.height * 0.5);
						Emitter.emit('iskr', loc, coordinates.X, coordinates.Y - boundingBox.height * 0.5, {kol:5});
					}
					else if (!mech) {
						Emitter.emit('stun', loc, coordinates.X, coordinates.Y - boundingBox.height * 0.75);
					}
				}
			}
			
			if (t_hp > 0) {
				t_hp--;
			}
			
			if (slow > 0) {
				slow--;
				
				if (!fixed && slow%10==0 && vis && vis.visible && (velocity.X > 3 || velocity.X < -3 || velocity.Y > 5 || velocity.Y < -5)) {
					Emitter.emit('slow', loc, coordinates.X, coordinates.Y-boundingBox.height * 0.25);
				}
			}
			
			if (t_throw > 0) {
				t_throw--;
			}
			
			//сборный показ цифр урона
			if (World.w.showHit == 2) {
				if (t_hitPart > 0) {
					t_hitPart--;
				}
				else {
					hitSumm = 0;
					hitPart = null;
				}
			}
			
			if (t_mess > 0) {
				t_mess--;
			}
		}
		
		public function makeNoise(n:int, hlup:Boolean=false):void {
			if (n <= 0) {
				return;
			}
			
			if (noise < n) {
				noise = n;
			}
			
			if (noise_t == 0 || hlup && noise_t <= 20) {
				noise_t = 30;
				
				if (loc && loc.active && !getTileVisi()) {
					if (!player) {
						Emitter.emit('noise', loc, coordinates.X, coordinates.Y, {rx:40, ry:40, alpha:Math.min(1, n / 500)});
					}
				}
			}
		}
		
		
//--------------------------------------------------------------------------------------------------------------------
//				Атака

		// [Attack the target with the body using the unit's own damage]
		public function attKorp(cel:Unit, mult:Number=1):Boolean {
			if (sost > 1 || cel == null || cel.loc != loc || burn != null) {
				return false;
			}

			if (!boundingBox.intersects(cel.boundingBox) || cel.neujaz > 0) {
				return false;
			}

			return cel.udarUnit(this, mult);
		}

		// [the blow reached the target]
		public function crash(b:Bullet):void {
			if (b.weap) {
				makeNoise(b.weap.noise, true);
			}
		}

		public function setWeaponPos(tip:String = "internal"):void {
			weaponX = coordinates.X;
			weaponY = boundingBox.top;
			magicX = coordinates.X;
			magicY = boundingBox.top;
		}

		public function setPunchWeaponPos(w:WPunch):void {
			w.coordinates.X = coordinates.X + boundingBox.width / 3 * storona;
			w.coordinates.Y = coordinates.Y - boundingBox.height * 0.75;
			w.rot = (storona > 0) ? 0 : ONE_PI;
		}
		
		public function destroyWall(t:Tile, napr:int=0):Boolean {
			if (isPlav || levit || sost != 1) {
				return false;
			}
			
			if (napr == 3 && velocity.Y > 15 && destroy < 50 && massa >= 1) {
				loc.hitTile(t, 50, (t.coords.X + 0.5) * tileX,(t.coords.Y + 0.5) * tileY, 100);
				
				if (t.phis == 0) {
					return true;
				}
			}
			
			if (destroy > 0 && (velocity.X > 10 && napr == 2 
				|| velocity.X < -10 && napr == 1
				|| velocity.Y < -10 && napr == 4 
				|| velocity.Y > 10 && napr == 3
				)) {
					loc.hitTile(t, destroy, (t.coords.X + 0.5) * tileX, (t.coords.Y + 0.5) * tileY, (napr == 3? 100 : 9));
			}
			
			if (t.phis == 0) {
				return true;
			}
			
			return false;
		}
		
		public function explosion(tdam:Number, ttipdam:String = Resistances.DAM_EXPLOSION, trad:Number = 200, tkol:int = 0, totbros:Number = 0, tdestroy:Number = 0, tdecal:int = 0):void {
			
			var v:Vector2 = new Vector2(coordinates.X, coordinates.Y - 3);
			var bul:Bullet = new Bullet(this, v, null, tkol > 1);
			
			bul.weapId = id;
			bul.damageExpl = tdam;
			bul.tipDamage = ttipdam;
			bul.explKol = tkol;
			
			if (tkol > 1) {
				bul.explTip = 2;
			}
			else if (ttipdam == Resistances.DAM_ACID) {
				bul.explTip = 3;
			}
			
			bul.explRadius = trad;
			bul.tipDecal = tdecal;
			bul.otbros = totbros;
			bul.destroy = tdestroy;
			bul.explosion();
			bul.babah = true;
		}
		
		
//--------------------------------------------------------------------------------------------------------------------
//				Effects

		public function addEffect(id:String, val:Number = 0, t:int = 0, se:Boolean = true):Effect {
			if (id == null || id == "") {
				return null;
			}

			var eff:Effect = new Effect(id, this, val);

			if (t > 0) {
				eff.t = t * World.fps;
			}

			// [Getting a temporary effect]
			for (var i in effects) {
				if (eff.tip == 3 && effects[i].tip == 3) {
					effects[i] = eff;
					eff.setEff();
					
					return eff;
				}
				
				if (effects[i].id == id || effects[i].id == eff.post) {
					if (effects[i].val > eff.val) {
						eff.val = effects[i].val;
					}
					
					if (eff.add) {
						eff.t += effects[i].t;
						
						if (eff.t > 30000) {
							eff.t = 30000;
						}
						
						eff.checkT();
					}
					
					effects[i] = eff;
					eff.setEff();
					
					return eff;
				}
			}
			
			eff.se = se;
			effects.push(eff);
			
			if (player && se) {
				World.w.gui.infoEffText(id);
			}
			
			eff.setEff();
			
			return eff;
		}
		
		public function remEffect(id:String):void {
			for each(var eff in effects) {
				if (eff != null && eff.id == id) {
					eff.unsetEff();
				}
			}
		}
		
		private function setSkillParam(xml:XML, lvl1:int, lvl2:int = 0):void {
			if (xml == null) {
				return;
			}
			
			for each(var sk in xml.sk) {
				var val:Number, lvl:int;
				
				if (sk.@dop.length()) {
					lvl = lvl2;
				}
				else {
					lvl = lvl1;
				}
				
				if (sk.@vd.length()) {
					val = Number(sk.@v0) + lvl * Number(sk.@vd);
				}
				else if (sk.attribute('v' + lvl).length()) {
					val = Number(sk.attribute('v' + lvl));
				}
				else {
					val = Number(sk.@v0);
				}
				
				if (sk.@tip == 'res') {
					vulnerabilities.changeResist(sk.@id, -val);
				}
				else if (hasOwnProperty(sk.@id)) {
					if (sk.@ref == 'add') {
						this[sk.@id] += val;
					}
					else if (sk.@ref == 'mult') {
						this[sk.@id] *= val;
					}
					else {
						this[sk.@id] = val;
					}
				}
			}
		}

		public function setEffParams():void {
			tormoz = 1;
			precMultCont = 1;			
			rapidMultCont = 1;
			
			if (begvulner == null) {
				return;
			}
			
			// Reset all vulnerabilities to their base values
			vulnerabilities.copyFrom(begvulner);
			
			// Make all NPCs invulnerable to Pink Cloud
			if (!player && loc.biom == 5) {
				vulnerabilities.setResist(Resistances.DAM_PINKCLOUD, 0);
			}
			
			// Process active effects
			for each(var eff:Effect in effects) {
				var effid:String = eff.id;
				var sk = XMLDataGrabber.getNodeWithAttributeThatMatches("core", "AllData", "effs", "id", effid);
				setSkillParam(sk, eff.vse ? 0 : 1);
			}
			
			setHeroVulners();
		}
		
//--------------------------------------------------------------------------------------------------------------------
//				Получение урона
		
		//получить урон
		public function damage(dam:Number, tip:String, bul:Bullet=null, tt:Boolean=false):Number {
			if (invulner) {
				return 0;
			}
			
			if (sost == 1) {
				dieWeap = null;
			}
			
			if (vulnerabilities.getResist(tip) != 1) {
				dam *= vulnerabilities.getResist(tip);	// Vulnerabilities
			}
			
			var isCrit:int = 0;
			var isShow:Boolean = false;
			
			if (bul) {	// Critical damage
				// [Damage to certain types]
				if (bul.owner && bul.owner.player && opt) {
					if (opt.pony) {
						dam *= (bul.owner as UnitPlayer).pers.damPony;
					}
					if (opt.zombie) {
						dam *= (bul.owner as UnitPlayer).pers.damZombie;
					}
					if (opt.robot) {
						dam *= (bul.owner as UnitPlayer).pers.damRobot;
					}
					if (opt.insect) {
						dam *= (bul.owner as UnitPlayer).pers.damInsect;
					}
					if (opt.monster) {
						dam *= (bul.owner as UnitPlayer).pers.damMonster;
					}
					if (opt.alicorn) {
						dam *= (bul.owner as UnitPlayer).pers.damAlicorn;
					}
				}
			}
			
			if (dam == 0) {
				return 0;
			}
			
			//уменьшение электрического урона
			if (tip == Resistances.DAM_ELECTRIC) {
				if (!stay && !inWater && isLaz == 0) {
					dam *= 0.5;
				}
			}
			
			//урон ядом наносится только живым
			if (tip == Resistances.DAM_VENOM && sost != 1) {
				return 0;
			}
			
			var mess:String;
			
			// [Damage to armor]
			if (!player && armor_hp > 0 && (shithp <= 0 || dam > shitArmor) && (armor > 0 || marmor > 0) && (tip <= Resistances.DAM_BALEFIRE && tip != Resistances.DAM_EMP && tip != Resistances.DAM_POISON && tip != Resistances.DAM_BLEED || tip == Resistances.DAM_ASTRO)) {
				var damarm:Number = dam;
				
				if (shithp > 0) {
					damarm -= shitArmor;
				}
				
				if (bul && bul.armorMult > 1) {
					damarm /= bul.armorMult;
				}
				
				if (tip == Resistances.DAM_ACID) {
					damarm *= 4;
				}
				else if (tip == Resistances.DAM_EXPLOSION) {
					damarm *= 2;
				}
				
				armor_hp -= damarm;
				
				// [Destruction of armor]
				if (armor_hp <= 0) {
					armor_hp = 0;
					armorQual = 0;
					mess = Res.txt("g", 'abr');
				}
			}
			
			if (dam < 0) {
				heal(-dam);
				
				return 0;
			}
			
			// [Armor and armor-piercing]
			var armor2:Number = 0;		
			if (!tt) {
				if (tip == Resistances.DAM_PIERCE || tip == Resistances.DAM_CUT || tip == Resistances.DAM_EXPLOSION || tip == Resistances.DAM_BLUNT || tip == Resistances.DAM_BITE || tip == Resistances.DAM_ACID) {
					armor2 = skin;
					
					if (armorQual > 0 && isrnd(armorQual)) {
						armor2 += armor;
					}
				}
				
				if (tip == Resistances.DAM_BURN || tip == Resistances.DAM_LASER || tip == Resistances.DAM_PLASMA || tip == Resistances.DAM_ELECTRIC || tip == Resistances.DAM_COLD || tip == Resistances.DAM_ASTRO) {
					armor2 = skin;
					
					if (armorQual > 0 && isrnd(armorQual)) {
						armor2 += marmor;
					}
				}
				
				if (shithp > 0) {
					shithp -= dam;
					
					if (shithp < 0) {
						shithp = 0;
					}
					
					armor2 += shitArmor;
				}
				
				if (bul) {
					armor2 *= bul.armorMult;
					armor2 -= bul.pier;
				}
				
				if (armor2 > 0) {
					dam -= armor2;
					// [If the bullet is piercing, subtract the amount of armor from the damage]
					if (bul && bul.probiv > 0) {
						bul.damage -= armor2 / bul.probiv;
					}
				}
			}
			
			// [Critical damage]
			if (bul) {
				if (Math.random() < bul.critCh) {
					dam *= bul.critDamMult;
					isCrit = 1;
				}
				
				if (!doop && celUnit != bul.owner && bul.critInvis > 0) {
					if (Math.random() < bul.critInvis) {
						dam *= 2;
						isCrit += 2;
					}
				}
			}
			
			if (dam > 0) {
				var sposob:int = 0; // [way to die]
				
				// [Instant disintegration]
				if (bul && bul.desintegr && (tip == Resistances.DAM_LASER || tip == Resistances.DAM_PLASMA)) {
					if (hp <= dam * 10 && isrnd(bul.desintegr)) {
						sposob = 1;
						dam *= 12;
					}
				}
				
				if (tip != Resistances.DAM_POISON && tip != Resistances.DAM_BLEED && tip != Resistances.DAM_INTERNAL) {
					dam *= allVulnerMult;
				}
				
				isShow = ((sost == 1 || sost == 2) && showNumbs && dam > 0.5);
				
				if (bul && bul.probiv > 0) {
					if (maxhp > dam * 20) {
						bul.damage = 0;
					}
					else if (maxhp > dam) {
						bul.damage *= bul.probiv;
					}
					else {
						bul.damage *= 1 - (1 - bul.probiv) * maxhp / dam;
					}
				}
				
				hp -= dam;
				var nshok:int = Math.round((Math.random() * 0.8 + 0.2) * maxShok * 4 * dam / maxhp);
				
				if (nshok > maxShok) {
					nshok = maxShok;
				}
				
				if (tt || nshok < 5) {
					nshok = 0;
				}
				
				if (shok < nshok) {
					shok = nshok;
				}
				
				if (hp <= 0) {
					if (bul && bul.weap) {
						dieWeap = bul.weap.id;
					}
					
					if (bul && bul.weapId) {
						dieWeap = bul.weapId;
					}
					
					if (tip == Resistances.DAM_BURN && (hp <= -maxhp * 3 || !trup)) {
						sposob = 1;
					}
					
					if (tip == Resistances.DAM_LASER && (hp <= -maxhp * 3 || !trup || isrnd())) {
						sposob = 1;
					}
					
					if (tip == Resistances.DAM_PLASMA || tip == Resistances.DAM_ACID) {
						sposob = 2;
					}
					
					if (tip == Resistances.DAM_ASTRO || tip == Resistances.DAM_HARMONY) {
						sposob = 3;
					}
					
					if (tip == Resistances.DAM_COLD) {
						sposob = 4;
					}
					
					if (timerDie <= 0) {
						die(sposob);
					}
					else {
						sost = 2;
					}
				}
				
				// [Electric and emp damage stuns robots]
				if ((tip == Resistances.DAM_ELECTRIC || tip == Resistances.DAM_EMP) && opt && opt.robot && sost == 1 && Math.random() < dam / maxhp) {
					mess = Res.txt("g", 'kz');
					
					if (stun < robotKZ) {
						stun = robotKZ;
					}
				}
				
				// [Explosions cause concussion]
				if (tip == Resistances.DAM_EXPLOSION && opt && !opt.robot && !mech && !doop && sost == 1 && Math.random() < dam / maxhp) {
					mess = Res.txt('e', 'contusion');
					addEffect('contusion');
				}
				
				if (!tt && demask < 200) {
					demask = 200;	// [When taking damage, an invisible object becomes visible]
				}
				
				// [Additional effects]
				if (bul && bul.weap) {								
					if (bul.weap.dopEffect != null && bul.weap.dopCh > 0 && (bul.weap.dopCh >= 1 || Math.random() < bul.weap.dopCh)) {
						if (bul.weap.dopEffect == 'igni' && vulnerabilities.getResist(Resistances.DAM_BURN) > 0.1) {
							addEffect('burning', bul.weap.dopDamage);
							mess = Res.txt('e', 'burning');
						}
						
						if (bul.weap.dopEffect == 'ice' && vulnerabilities.getResist(Resistances.DAM_COLD) > 0.1 && !mech) {
							mess = Res.txt('e', 'freezing');
							addEffect('freezing');
						}
						
						if (bul.weap.dopEffect == 'blind' && vulnerabilities.getResist(Resistances.DAM_LASER) > 0.1 && !mech && !doop) {
							mess = Res.txt('e', 'blindness');
							addEffect('blindness');
						}
						
						if (bul.weap.dopEffect == 'acid' && vulnerabilities.getResist(Resistances.DAM_ACID) > 0.1) {
							mess = Res.txt('e', 'chemburn');
							addEffect('chemburn', bul.weap.dopDamage);
						}
						
						if (bul.weap.dopEffect == 'pink' && vulnerabilities.getResist(Resistances.DAM_PINKCLOUD) > 0.1) {
							mess = Res.txt('e', 'pinkcloud');
							addEffect('pinkcloud', bul.weap.dopDamage);
						}
						
						if (bul.weap.dopEffect == 'poison' && vulnerabilities.getResist(Resistances.DAM_POISON) > 0.1) {
							if (player && poison <= 0) {
								World.w.gui.infoText('poison');
							}

							poison += bul.weap.dopDamage;
						}
						
						if (bul.weap.dopEffect == 'cut' && vulnerabilities.getResist(Resistances.DAM_BLEED) > 0.1 && !mech) {
							if (player && cut <= 0) {
								World.w.gui.infoText('cut');
							}
							
							cut += bul.weap.dopDamage;
						}
						
						if (bul.weap.dopEffect == 'stun') {
							if (!mech && opt && !opt.robot && Math.random() < dam / maxhp && sost == 1) {
								stun = bul.weap.dopDamage;
								
								if (player && stun <= 0) {
									World.w.gui.infoText('stun');
								}
								
								if (stun > 1) {
									mess = Res.txt("g", 'stun');
								}
							}
						}
					}
					
					if (bul.weap.ammo.incendiaryDamage) {
						addEffect('burning', bul.weap.ammo.incendiaryDamage);
						mess = Res.txt('e', 'burning');
					}
				}
				
				// [Return damage to the owner of the bullet]
				if (bul && bul.owner && bul.owner.relat > 0) {
					bul.owner.damage(dam*bul.owner.relat, Resistances.DAM_INTERNAL);
				}
				
				if (tip == Resistances.DAM_INTERNAL && dam<5) {
					isShow = false;
				}
				
				if (blood > 0 && (tip == Resistances.DAM_PIERCE || tip == Resistances.DAM_CUT || tip == Resistances.DAM_BLUNT || tip == Resistances.DAM_BLEED || tip == Resistances.DAM_BITE)) {	//кровь
					if (bloodEmit == null) {
						if (blood == 1) {
							bloodEmit = Emitter.arr["blood"];
						}
						else if (blood == 2) {
							bloodEmit = Emitter.arr["gblood"];
						}
						else if (blood == 3) {
							bloodEmit = Emitter.arr["pblood"];
						}
					}
					
					if (!(player && World.w.alicorn)) {
						if (bul) {
							bloodEmit.cast(loc, bul.coordinates.X, bul.coordinates.Y, {dx:bul.velocity.X / bul.vel * 5, dy:bul.velocity.Y / bul.vel * 5, kol:int(Math.random()*5+dam/5)});
						}
						else {
							bloodEmit.cast(loc, coordinates.X, coordinates.Y - boundingBox.halfHeight, {kol:int(dam/3)});
						}
						
						if (blood == 1 && tip != Resistances.DAM_BLEED && massa > 0.20) {
							var ver:Number = Math.random();
							
							if (tip == Resistances.DAM_CUT) {
								ver = ver * ver;
							}
							
							if (isCrit > 0) {
								ver *= 0.30;
							}
							
							if (dam / 1000 > ver) {
								var st:int = 1;
								
								if (bul && bul.velocity.X < 0) {
									st = -1;
								}
								
								if (bul == null && Math.random() < 0.50) {
									st=-1;
								}
								
								Emitter.emit('bloodexpl' + int(Math.random() * 3 + 1), loc, coordinates.X + 80 * st + (Math.random() - 0.5) * boundingBox.width * 0.5, coordinates.Y - Math.random() * boundingBox.height * 0.5 - 40, {mirr:(st<0?1:0)});
							}
						}
					}
				}
				
				if (mat == 10 && bul) {
					Emitter.emit('pole2', loc, bul.coordinates.X, bul.coordinates.Y);
				}
				
				if (isShow) {//Показывать урон
					var vnumb:int = 1;
					var castX:Number = coordinates.X;
					var castY:Number = boundingBox.top;
					
					if (bul) {
						castX = bul.coordinates.X; castY = bul.coordinates.Y;
					}
					
					if (player || isCrit >= 2) {
						vnumb = 2;
					}
					
					if (tt) {
						vnumb = 3;
					}
					
					if (player && tt && tip == Resistances.DAM_PINKCLOUD) {
						vnumb = 11;
					}
					
					if (World.w.showHit == 1 || tt) {
						visDamDY -= 15;
						numbEmit.cast(loc, castX,castY + visDamDY, {txt:Math.round(dam).toString(), frame:vnumb, rx:40, scale:((isCrit == 1 || isCrit == 3) ? 1.6 : 1)});
					}
					else if (World.w.showHit == 2) {
						hitSumm += dam;
						
						if (hitPart == null) {
							hitPart = numbEmit.cast(loc, castX, castY + visDamDY, {txt:Math.round(dam).toString(), frame:vnumb, rx:40, scale:((isCrit == 1 || isCrit == 3) ? 1.6 : 1)});
						}
						else {
							if (isCrit == 1 || isCrit == 3) {
								hitPart.vis.scaleX = hitPart.vis.scaleY = 1.6 / World.w.cam.scaleV;
							}
							
							hitPart.vis.numb.text = Math.round(hitSumm);
							hitPart.liv = 60;
						}
						
						t_hitPart = 10;
					}
				}
				
				if (hp > 0 && !player && isrnd()) {
					replic('dam');
				}
			}
			else if (World.w.showHit == 2) {
				t_hitPart = 10;
			}

			visDetails();
			
			if (World.w.showHit>=1 && t_mess <= 0) {
				if (hp > 0 && mess) {
					numbEmit.cast(loc, coordinates.X, coordinates.Y - boundingBox.halfHeight, {txt:mess, frame:5, rx:20, ry:20});
					t_mess = 45;
				}
			}
			
			if (!tt) {
				alarma();
			}
			
			return dam;
		}
		
		// [hit the wall 1-right, 2-left, 3-bottom, 4-top]
		public function damageWall(napr:int = 0):void {
			t_throw = 0;
			
			if (damWall > 0) {
				var dam:Number = Math.sqrt(velocity.X * velocity.X + velocity.Y * velocity.Y) / damWallSpeed * damWall;
				damage(dam, Resistances.DAM_BLUNT);
				
				if (Math.random() < dam / maxhp) {
					stun = damWallStun;
				}
				
				if (napr > 0) {
					var nx:Number = coordinates.X;
					var ny:Number = boundingBox.top;

					if (napr == 1) {
						nx = coordinates.X + boundingBox.halfWidth;
					}
					else if (napr == 2) {
						nx = coordinates.X - boundingBox.halfWidth;
					}
					else if (napr == 3) {
						ny = coordinates.Y;
					}
					else if (napr == 4) {
						ny = coordinates.Y - boundingBox.height;
					}

					Emitter.emit('bum', loc, nx, ny);
					Snd.ps('hit_flesh', coordinates.X, coordinates.Y);
				}
			}
		}
		
		public function heal(hl:Number, tip:int=0, ismess:Boolean=true):void {
			if (hp == maxhp) {
				return;
			}

			if (hl > maxhp - hp) {
				hl = maxhp - hp;
				hp = maxhp;
			}
			else {
				hp += hl;
			}

			visDetails();
			
			if (World.w.showHit >= 1) {
				if ((sost == 1 || sost == 2) && showNumbs && hl > 0.5) {
					numbEmit.cast(loc, coordinates.X, coordinates.Y - boundingBox.halfHeight, {txt:('+' + Math.round(hl)), frame:4, rx:20, ry:20});
				}
			}
		}
		
		public function dopTest(bul:Bullet):Boolean {
			return true;
		}
		
		//проверка на попадание пули, наносится урон, если пуля попала, возвращает -1 если не попала
		public override function udarBullet(bul:Bullet, sposob:int = 0):int {
			var acc:Number = bul.accuracy();
			
			if ((bul.miss <= 0 || Math.random() > bul.miss) && (
				dexter <= 0 ||
				bul.precision <= 0 && bul.tipBullet == 0 || 
				bul.tipBullet == 0 && Math.random() < acc / (dexter + dexterPlus + 0.05) || 
				bul.tipBullet == 1 && dodge < 1 && (dodge <= 0 || Math.random() > dodge)
			)) {
				var dm:Number = 0;
				if ((transp && (vulnerabilities.getResist(bul.tipDamage) <= 0) || invulner)) {
					return -1;
				}
				else if (bul.damage > 0) {
					
					if (retDamage && bul.retDam && bul.owner) {//возврат урона
						bul.owner.udarUnit(this);
					}
					
					dm = bul.damage * (Math.random() * 0.60 + 0.70);
					
					if (World.w.testDam) {
						dm = bul.damage;
					}
					
					dm = damage(dm, bul.tipDamage, bul);
					otbros(bul);
					
					if (bul.owner && bul.owner.fraction != 0) {
						priorUnit = bul.owner;
					}
					
					if (!invulner && dm <= 0 || mat == 1) {
						return 1;
					}
					else if (mat == 12) {
						return 12;
					}
					else {
						return 10;
					}
				}
				else {
					return 0;
				}
			}
			else {
				if (World.w.showHit == 1 || World.w.showHit == 2 && t_hitPart == 0) {
					visDamDY -= 15;
					t_hitPart = 10;
					
					if (sost < 3 && isVis && !invulner && bul.flame == 0) {
						numbEmit.cast(loc, coordinates.X, coordinates.Y - boundingBox.halfHeight + visDamDY, {txt:txtMiss, frame:10, rx:40, alpha:0.50});
					}
				}
				
				return -1;
			}
		}

		//удар юнита юнитом
		public function udarUnit(un:Unit, mult:Number=1):Boolean {
			if (neujaz > 0) {
				return false;
			}
			
			neujaz = neujazMax;
			
			if (dodge - un.undodge > 0 && isrnd(dodge - un.undodge)) {
				if (World.w.showHit >= 1) {
					numbEmit.cast(loc, coordinates.X, coordinates.Y - boundingBox.halfHeight, {txt:txtMiss, frame:10, rx:20, ry:20, alpha:0.50});
					
					return false;
				}
			}
			
			var sila:Number = Math.random() * 0.4 + 0.8;
			
			if (un.collisionTip == 1) {
				var ndx:Number = (un.velocity.X * un.massa + velocity.X * massa) / (un.massa + massa);
				var ndy:Number = (un.velocity.Y * un.massa + velocity.Y * massa) / (un.massa + massa); // Corrected to use velocity.Y instead of velocity.X for ndy calculation
				velocity.X = (-velocity.X + ndx) * knocked + ndx;
				velocity.Y = (-velocity.Y + ndy) * knocked + ndy;
				un.velocity.X = (-un.velocity.X + ndx) * un.knocked + ndx;
				un.velocity.Y = (-un.velocity.Y + ndy) * un.knocked + ndy;
			}
			
			if (un.currentWeapon && un.currentWeapon.tip == "cryo") {
				damage((un.currentWeapon.damage*0.5+un.dam)*sila*mult, un.currentWeapon.tipDamage)
			}
			else {
				damage((un.dam)*sila*mult, un.tipDamage);
			}
			
			var sc:Number = (un.dam * sila * mult) / 20;
			
			if (sc < 0.5) {
				sc = 0.5;
			}
			
			if (sc > 3) {
				sc = 3;
			}
			
			if (un.tipDamage == Resistances.DAM_ELECTRIC) {
				Emitter.emit('moln', loc, coordinates.X, coordinates.Y-boundingBox.halfHeight, {celx:un.coordinates.X, cely:(un.coordinates.Y - un.boundingBox.halfHeight)});
				Snd.ps('electro', coordinates.X, coordinates.Y);
			}
			else if (un.tipDamage == Resistances.DAM_ACID) {
				Emitter.emit('buma', loc, (coordinates.X + un.coordinates.X) * 0.50, (coordinates.Y - boundingBox.halfHeight + un.coordinates.Y - un.boundingBox.halfHeight) * 0.50, {scale:sc});
				Snd.ps('acid',coordinates.X, coordinates.Y);
			}
			else if (un.tipDamage == Resistances.DAM_DEATH) {
				Emitter.emit('bumn',loc,(coordinates.X + un.coordinates.X) * 0.50, (coordinates.Y - boundingBox.halfHeight + un.coordinates.Y - un.boundingBox.halfHeight) * 0.50, {scale:sc});
				Snd.ps('hit_necr', coordinates.X, coordinates.Y);
			}
			else if (un.tipDamage == Resistances.DAM_BITE) {
				Emitter.emit('bum',loc,(coordinates.X + un.coordinates.X) * 0.50, (coordinates.Y - boundingBox.halfHeight + un.coordinates.Y - un.boundingBox.halfHeight) * 0.50, {scale:sc});
				Snd.ps('fang_hit', coordinates.X, coordinates.Y);
			}
			else {
				Emitter.emit('bum', loc, (coordinates.X + un.coordinates.X) * 0.50, (coordinates.Y - boundingBox.halfHeight + un.coordinates.Y - un.boundingBox.halfHeight) * 0.50, {scale:sc});
				Snd.ps('hit_flesh', coordinates.X, coordinates.Y);
			}

			priorUnit = un;
			
			return true;
		}
		
		//удар падающим предметом
		public function udarBox(un:Box):int {
			if (neujaz > 0 || noBox || un.loc != loc) {
				return 0;
			}
			
			if (un.molnDam > 0) {
				damage(un.molnDam, Resistances.DAM_ELECTRIC);
				return 1;
			}
			
			neujaz = neujazMax;
			
			if (fixed) {
				un.velocity.multiply(0.50);
            }
			else {
                var ndx:Number = (un.velocity.X * un.massa + velocity.X * massa) / (un.massa + massa);
                var ndy:Number = (un.velocity.Y * un.massa + velocity.X * massa) / (un.massa + massa);
                velocity.X = (-velocity.X + ndx) * knocked + ndx;
				velocity.Y = (-velocity.Y + ndy) * knocked + ndy;
                un.velocity.X = (-un.velocity.X + ndx) * 0.25 + ndx;
				un.velocity.Y = (-un.velocity.Y + ndy) * 0.25 + ndy;
            }
			
			damage(un.massa * (un.vel2 - 50) * World.boxDamage, Resistances.DAM_BLUNT);
			priorUnit = null;
			
			return 2;
		}

		//эффект отбрасывания пулей
		public function otbros(bul:Bullet):void {
			if (invulner) {
				return;
			}
			
			var sila:Number = Math.random() * 0.40 + 0.80;
			
			sila *= knocked / massa;
			
			if (sila > 3) {
				sila = 3;
			}
			
			velocity.X += bul.knockx * bul.otbros * sila;
			velocity.Y += bul.knocky * bul.otbros * sila;
		}
		
		// [Activation from passive mode]
		public function alarma(nx:Number = -1,ny:Number = -1):void {
			detectionDelay = 0;	// Player is seen, remove the grace period
			if (nx > 0 && ny > 0 && celUnit == null) {
				setCel(null, nx, ny);
			}
		}

		//пробуждение всех вокруг
		public function budilo(rad:Number = 500):void {
			makeNoise(noiseRun * 1.20);
			
			for each(var un:Unit in loc.units) {
				if (un && un != this && un.fraction == fraction && un.sost == 1 && !un.unres) {
					var nx:Number = un.coordinates.X - coordinates.X;
					var ny:Number = un.coordinates.Y - coordinates.Y;
					
					if (opt && opt.robot && un.opt && un.opt.robot) {
						if (nx * nx + ny * ny < rad * rad) {
							un.alarma(celX, celY);
						}
					}
					else {
						if (nx * nx + ny * ny < rad * rad * un.ear * un.ear) {
							un.alarma(coordinates.X + (Math.random() - 0.50) * 250, coordinates.Y + (Math.random() - 0.5) * 250);
						}
					}
				}
			}
		}
		
		//отключение (для систем безопасности)
		public function hack(sposob:int = 0):void {

		}
		
		public override function die(sposob:int = 0):void {
			if (hpbar) {
				hpbar.visible = false;
			}
			
			if (boss) {
				World.w.gui.hpBarBoss();
				
				if (sndMusic) {
					Snd.combatMusic(sndMusic, sndMusicPrior, 90);
				}
			}
			
			if (sposob == 0 && sost == 1 && sndDie) {
				sound(sndDie);
			}
			
			if (noDestr) {			// [Don't clean up after a murder]
				sost = 3;
			}
			else if (sposob > 0) {	// [Killed in an exotic way]
				isFly = false;
				initBurn(sposob);
				dexter = 100;
				fraction = 0;
				throu = false;
				sost = 3;
			}
			else if (trup && hp > -maxhp * 2) {	// [Leave the corpse and it is not destroyed]
				replic('die');
				isFly = false;
				boundingBox.width = _crouchingWidth;
				boundingBox.height = _crouchingHeight;
				
				// Crouch the obj since the body is stretched out on the floor
				boundingBox.center(coordinates);

				fraction = 0;
				throu = false;
				porog = 0;
				sost = 3;
			}
			else if (trup && blood > 0) {		// [There is blood]
				if (burn == null) {
					sound('trup');
				}
				
				initBurn(4 + blood);
				isFly = false;
				fraction = 0;
				throu = false;
				porog = 0;
				sost = 3;
			}
			else if (burn == null) {			// [Destroy]
				if (trup && blood > 0) {
					sound('trup');
				}
				
				expl();
				exterminate();
			}
			
			shithp		= 0;
			walk		= 0;
			elast		= 0;
			isLaz		= 0;
			stun		= 0;
			transT		= true;
			sndRunOn	= false;
			plaKap		= false;
			
			if (!doop && World.w.t_battle > 30) {
				World.w.t_battle = 30;
			}
			
			if (!lootIsDrop && (!isRes || sost == 4 || burn)) {
				lootIsDrop = true;
				
				if (mother) {
					mother.kolChild--;
				}
				
				if (hero > 0) {
					World.w.gui.infoText('killHero', nazv);
				}
				
				runScript();
				dropLoot();
				incStat();
				
				if (xp > 0) {
					loc.takeXP(xp, coordinates.X, coordinates.Y, true);
					xp = 0;
				}
				
				if (loc.prob) {
					loc.prob.check();
				}
				
				if (opt && opt.hbonus) {
					loc.createHealBonus(coordinates.X, boundingBox.top);
				}
			}
		}
		
		//уничтожить, убрать из мира
		public function exterminate():void {
			radioactiv = 0;
			levitPoss = false;
			
			if (sost != 4) {
				loc.remObj(this);
			}
			
			sost = 4;
			disabled = true;
		}
		
		//взрыв, кишки или другой эффект после смерти
		public function expl():void  {
			if (blood) {
				if (bloodEmit == null) {
					if (blood == 1) {
						bloodEmit = Emitter.arr['blood'];
					}
					else if (blood == 2) {
						bloodEmit = Emitter.arr['gblood'];
					}
					else if (blood == 3) {
						bloodEmit = Emitter.arr['pblood'];
					}
				}
				
				bloodEmit.cast(loc, coordinates.X, coordinates.Y, {kol:massa * 50, rx:boundingBox.halfWidth, ry:boundingBox.halfHeight});
			}
		}

		//вызывается в любом случае в момент любого способа смерти, только один раз!
		public function dropLoot():void {
			if (inter) {
				inter.loot();
			}
			
			if (hero > 0 && !(opt.robot == true) && isrnd(0.75)) {
				LootGen.lootId(loc, coordinates.X, boundingBox.top, 'essence');
			}
			
			//выпадение драгоценного камня
			if (World.w.pers && World.w.pers.dropTre > 0 && xp > 0) {
				if (Math.random() < World.w.pers.dropTre * xp / 4000) {
					LootGen.lootId(loc, coordinates.X, boundingBox.top, 'gem' + int(Math.random() * 3 + 1));
				}
			}
		}
		
		public function initBurn(sposob:int):void {
			if (burn != null) {
				return;
			}
			
			remVisual();
			burn = new Desintegr(this,sposob);
			childObjs = [];
			addVisual();
			levitPoss = false;
			setVisPos();
		}

		public function runScript():void {
			if (scrDie) {
				scrDie.start();
			}
			
			if (questId)  {
				if (loc.land.itemScripts[questId]) {
					loc.land.itemScripts[questId].start();
				}

				World.w.game.incQuests(questId);
			}
			
			if (wave && loc.prob) {
				loc.prob.checkWave(true);
			}
			
			//действие типа уничтожить сколько-то врагов из определённого оружия
			if (dieWeap != null && World.w.game.triggers['look_' + dieWeap] > 0 && xp > 0) {
				World.w.game.incQuests('kill_' + dieWeap);
			}
		}

		//изменить статистику
		public function incStat(sposob:int=0):void {
			if (World.w.game) {
				if (World.w.game.triggers['frag_'+id] > 0) {
					World.w.game.triggers['frag_'+id]++;
				}
				else {
					World.w.game.triggers['frag_'+id] = 1;
				}
			}
		}
		
//--------------------------------------------------------------------------------------------------------------------
//				Служебные ф-и для ИИ

		//возможность взаимодействия с юнитом
		public function isMeet(un:Unit):Boolean {
			return un != null && loc == un.loc && !un.disabled && !un.trigDis && un.sost != 4 && un != this;
		}

		// Whether the unit is covered by the fog of war, true if not
		public function getTileVisi(r:Number=0.3):Boolean {
			return (loc.getAbsTile(coordinates.X, boundingBox.top).visi > r);
		}
		
		//слушать другого юнита
		public function listen(ncel:Unit):Number {
			var noi:Number = ncel.noise * ear * loc.earMult; // Hearing radius based on noise
			if (noi <= 0) {
				return 0;
			}

			var r2:Number; // Distance squared
			if (ncel.player) {
				r2 = rasst2;
			}
			else {
				var nx:Number = ncel.coordinates.X - this.coordinates.X;
				var ny:Number = ncel.boundingBox.top - boundingBox.bottom;
				r2 = nx * nx + ny * ny;
			}

			if (noi * noi > r2) {
				return (1 - r2 / (noi * noi)) * 4;
			}
			
			return 0;
		}

		public function look(ncel:Unit, over:Boolean = true, visParam:Number = 0, nDist:Number = 0):Number {
			// Early exit if no target unit or visibility parameters are invalid
			if (ncel == null || (nDist <= 0 && visParam <= 0 && vision <= 0)) {
				return 0;
			}

			// Initialize eye position if not set
			if (eyeX == -1000 || eyeY == -1000) {
				eyeX = coordinates.X;
				eyeY = coordinates.Y - 30;
			}

			// Calculate relative position once
			var cx:Number = ncel.coordinates.X - eyeX;
			var cy:Number = ncel.coordinates.Y - ncel.boundingBox.halfHeight * 0.6 - eyeY;

			// Calculate squared distance once to avoid repeated calculations
			var r2:Number = cx * cx + cy * cy;

			// Determine visibility distance
			var distVis:Number = nDist > 0 ? nDist :
				(ncel.visibility * ncel.stealthMult * loc.visMult + ncel.demask) * (visParam || vision);

			// Adjust visibility distance based on angle if necessary
			if (vKonus == 0 && !over && cy > 0 && cy * cy > cx * cx) {
				var angleFactor:Number = 0.5 + 0.5 * Math.abs(cx / cy);
				distVis *= angleFactor;
			}

			var distVisSquared16:Number = distVis * distVis * 16;
			if (r2 > distVisSquared16) {
				return 0;
			}

			// Early exit if the unit is behind and out of detecting range
			if (vKonus == 0 && !over && cx * storona < 0 && r2 > detecting * detecting) {
				return 0;
			}

			// Check if the unit is within the cone of vision
			if (vKonus > 0) {
				var ug:Number = Math.atan2(cy, cx);
				var dug:Number = normalizeAngle(vAngle - ug);
				
				if (Math.abs(dug) > vKonus / 2) {
					return 0;
				}
			}

			// Line of sight check
			var maxDeltaInv:Number = 1 / World.maxdelta;
			var div:int = int(Math.max(Math.abs(cx), Math.abs(cy)) * maxDeltaInv) + 1;
			var startIdx:int = mater ? 1 : 4;
			var step:Number = 1 / div;
			var baseX:Number = coordinates.X + boundingBox.width * 0.25 * storona;
			var baseY:Number = coordinates.Y - boundingBox.height * 0.75;
			
			for (var i:int = startIdx; i < div; i++) {
				var nx:Number = baseX + cx * i * step;
				var ny:Number = baseY + cy * i * step;
				var tileXIdx:int = int(nx / tileX);
				var tileYIdx:int = int(ny / tileY);
				var t:Tile = World.w.loc.getTile(tileXIdx, tileYIdx);
				
				if (t.phis == 1 && t.boundingBox.intersectsPoint(nx, ny)) {
					return 0;
				}
			}

			// Determine observation value based on distance
			if (r2 < ncel.detecting * ncel.detecting) {
				return 20;
			}

			if (r2 < distVis * distVis) {
				return 4;
			}

			// Return scaled observation value
			return (distVis * distVis) / r2 * 4;
		}

		// Helper function to normalize angle between -PI and PI
		private function normalizeAngle(angle:Number):Number {
			while (angle > ONE_PI) {
				angle -= TWO_PI;
			}
			
			while (angle < -ONE_PI) {
				angle += TWO_PI;
			}
			
			return angle;
		}

		// [Get target for AI]
		public function findCel(over:Boolean = false):Boolean {
			if (detectionDelay > 0) {
				return false;
			}
			
			var ncel:Unit;
			
			if (priorUnit && isMeet(priorUnit) && priorUnit.fraction != fraction && priorUnit.sost < 3 && priorUnit.hp > -priorUnit.maxhp && (!priorUnit.doop || priorUnit.levit)) {
				ncel = priorUnit;
			}
			else if (isMeet(loc.gg) && !loc.gg.invulner && fraction != F_PLAYER) {
				ncel = loc.gg;
			}
			else {
				return false;
			}
			
			if (ncel.player) {
				var res1:Number = listen(ncel);
				if (res1) {
					(ncel as UnitPlayer).observation(res1);
				}
				
				var res2:Number = look(ncel,overLook || over);
				if (res2 > 0) {
					(ncel as UnitPlayer).observation(res2, observ);
					
					if ((ncel as UnitPlayer).obs >= (ncel as UnitPlayer).maxObs) {
						setCel(ncel);
						return true;
					}
				}
				else if (res1 > 0) {
					if ((ncel as UnitPlayer).obs >= (ncel as UnitPlayer).maxObs) {
						setCel(null, ncel.coordinates.X + Calc.intBetween(-100, 100), ncel.coordinates.Y + Calc.intBetween(-100, 100));
					}
					
					if (res1 > 1) {
						return true;
					}
				}
			}
			else {
				if (look(ncel,overLook || over)>0.5) {
					setCel(ncel);
					return true;
				}
			}
			
			celUnit = null;
			priorUnit = null;
			
			return false;
		}

		// [Set a target to a unit or point]
		public function setCel(un:Unit=null, cx:Number=-10000, cy:Number=-10000):void {
			if (un && isMeet(un)) {
				celX = un.coordinates.X + un.boundingBox.width * 0.25 * un.storona;
				celY = un.boundingBox.top;
				celUnit = un;
				
				if (un.player) {
					World.w.t_battle = World.battleNoOut;
					World.w.cur();
					loc.detecting = true;
					if (sndMusic && !loc.postMusic) {
						Snd.combatMusic(sndMusic, sndMusicPrior, boss ? 10000 : 150);
					}
				}
			}
			else if (cx > -10000 && cy > -10000) {
				celX = cx;
				celY = cy;
				celUnit = null;
			}
			else {
				celX = coordinates.X;
				celY = boundingBox.top;
				celUnit = null;
			}
			
			celDX = celX - coordinates.X;
			celDY = celY - coordinates.Y + boundingBox.height;
		}
		
		public function findGrenades():Boolean {
			for (var i:int = 0; i < 10; i++) {
				if (loc.grenades[i] == null) {
					continue;
				}
				
				var gx:Number = loc.grenades[i].coordinates.X - coordinates.X;
				var gy:Number = loc.grenades[i].coordinates.Y - boundingBox.top;
				
				if (gx * gx + gy * gy < 160000) { // [There is a grenade]
					if (loc.isLine(coordinates.X, coordinates.Y - boundingBox.height * 0.75, loc.grenades[i].coordinates.X, loc.grenades[i].coordinates.Y)) {
						acelX = loc.grenades[i].coordinates.X;
						acelY = loc.grenades[i].coordinates.Y;
						return true;
					}
				}
			}
			
			return false;
		}
		
		public function findLevit():Boolean {
			if (isMeet(loc.gg) && loc.gg.teleObj) {
				var gx:Number=loc.gg.teleObj.coordinates.X - coordinates.X;
				
				if (!overLook && gx * storona < 0) {
					return false;
				}
				
				var gy:Number = loc.gg.teleObj.coordinates.Y - loc.gg.teleObj.boundingBox.halfHeight - coordinates.Y + boundingBox.halfHeight;
				
				if (gx * gx + gy * gy < vision * vision * 1000000 && loc.isLine(coordinates.X, coordinates.Y - boundingBox.height * 0.75, loc.gg.teleObj.coordinates.X, loc.gg.teleObj.coordinates.Y - loc.gg.teleObj.boundingBox.halfHeight)) {
					return true;
				}
			}
			
			return false;
		}
		
		public override function command(com:String, val:String = null):void {
			super.command(com, val);
			
			if (com == 'activate') {
				noAct = false;
				disabled = false;
				setNull(true);
				addVisual();
				Emitter.emit('tele', loc, coordinates.X, boundingBox.bottom, {rx:boundingBox.width, ry:boundingBox.height, kol:30});
			}
			
			if (com == 'fraction') {
				fraction = int(val);
				
				if (fraction == F_PLAYER) {
					warn = 0;
				}
				else {
					warn = 1;
				}
			}
		}

		public function replic(s:String):void {
			if (sost != 1 || id_replic == "" || !loc.active) {
				return;
			}
			
			var s_replic:String;
			
			if (s == "dam" && isrnd(0.05)) {
				t_replic = 0;
			}
			
			if (s == "die" && isrnd()) {
				t_replic = 0
			}
			
			if (t_replic <= 0) {
				if (s == "attack") {
					t_replic = 50 +  Calc.intBetween(0, 100);
				}
				else  {
					t_replic = 110 + Calc.intBetween(0, 150);
				}
				
				s_replic = Res.repText(id_replic, s, msex);
				
				if (s_replic != "" && s_replic != null) {
					Emitter.emit("replic", loc, coordinates.X, coordinates.Y - 110, {txt:s_replic, ry:50});
				}
			}
		}

		protected function isrnd(n:Number = 0.5):Boolean {
			return Math.random() < n;
		}
	}
}
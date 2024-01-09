package fe.unit {
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.utils.*;
	
	import fe.*;
	import fe.weapon.*;
	import fe.loc.*;
	import fe.serv.*;
	import fe.graph.Emitter;
	import fe.graph.Grafon;
	import flash.media.SoundChannel;
	import flash.filters.GlowFilter;
	import fe.graph.Part;
	
	public class Unit extends Obj{
		
		public static const
		D_BUL=0,		//пули		+
		D_BLADE=1,		//лезвие	+
		D_PHIS=2,		//дробящий	+
		D_FIRE=3,		//огонь		*
		D_EXPL=4,		//взрыв		+
		D_LASER=5,		//лазер		*
		D_PLASMA=6,		//плазма	*
		D_VENOM=7,		//отравляющие вещества
		D_EMP=8,		//ЭМП
		D_SPARK=9,		//молния	*
		D_ACID=10,		//кислота	*
		D_CRIO=11,		//холод		*
		D_POISON=12,	//отравление
		D_BLEED=13,		//кровотечение
		D_FANG=14,		//звери		+
		D_BALE=15,		//пиздец
		D_NECRO=16,		//некромантия
		D_PSY=17,		//пси
		D_ASTRO=18,		//звиздец
		D_PINK=19,		//розовое облако
		D_INSIDE=100,	//???
		D_FRIEND=101;	//дружба
		
		public static var txtMiss:String;
		
		public static var arrIcos:Array;
		
		public var id:String;
		var mapxml:XML;
		var uniqName:Boolean=false;
		
		//координаты и размеры
		public var sitY:Number=40, stayY:Number=40, sitX:Number=40, stayX:Number=40;	//размеры
		public var begX:Number=-1, begY:Number=-1; 		//исходная точка
		public var rasst:Number=0;	//расстояние до ГГ
		
		public var level:int=0;
		public var hero:int=0;
		public var boss:Boolean=false;
		//хп
		public var maxhp:Number=100;
		public var hpmult:Number=1;
		public var hp:Number=100;
		public var cut:Number=0;	//раны
		public var poison:Number=0;	//яд
		public var critHeal:Number=0.2;
		public var shithp:Number=0;
		var t_hp:int;
		public var mana:Number=1000, maxmana:Number=1000, dmana:Number=1;
		//броня и уязвимости
		public var invulner:Boolean=false;
		public var allVulnerMult:Number=1;
		public var skin:Number=0, armor:Number=0, marmor:Number=0, armor_hp:Number=0, armor_maxhp:Number=0, armor_qual:Number=0;		//шкура, броня, вероятность того, что она сработает
		public var shitArmor:Number=20;
		public var vulner:Array;		
		public var begvulner:Array;
		public static var begvulners:Array=new Array();
		public var dexter:Number=1, dexterPlus:Number=0;			//уклонение, 1 - стандартное, больше 1 - больше, 0 - всегда попадёшь		
		public var dodge:Number=0, undodge:Number=0;			//вероятность уклониться в ближнем бою, прибавка к вероятности попасть по врагу, 1 - всегда
		public var transp:Boolean=false;	//прозрачный для пуль, не наносящих урона
		public var damWall:Number=0;		//урон от удара об стену
		public var damWallSpeed:Number=12;
		public var dopTestOn:Boolean=false;	//сложная проверка попадания
		public var friendlyExpl:Number=0.25;
		// урон
		public var dam:Number=0;			//урон самого юнита
		public static const kolVulners=20;
		public var tipDamage:int=D_PHIS;		//тип урона
		public var radDamage:Number=0;		//урон радиацией
		public var retDamage:Boolean=false; //возврат урона от юнита к врагу
		public var relat:Number=0;			//обратный возврат урона, от врага к юниту
		public var destroy:Number=-1;			//урон блокам при столкновении
		public var collisionTip:int=1;
		public var dieWeap:String;			//оружие, из которого юнит был убит
		public var levitAttack:Number=1;	//насколько успешной будет атака в состоянии левитации
		public var noAgro:Boolean=false;	//не нападает первый
		
		//движение
		//параметры движения
		public var fixed:Boolean=false;		//не двигаться вообще
		public var bind:Obj;				//привязка
		public var mater:Boolean=true;		//взаимодействовать со стенами
		public var massaFix:Number=1;		//масса зафиксированного объекта
		public var massaMove:Number=1;		//масса перемещаемого объекта
		public var walk:int;				//движение по поверхности, 1 - вправо, -1 влево, 0 - нет движения
		public var maxSpeed:Number=10, walkSpeed:Number=5, runSpeed:Number=10, sitSpeed:Number=3, lazSpeed:Number=5, plavSpeed:Number=5;
		public var accel:Number=5, brake:Number=1, levitaccel:Number=1.6, knocked:Number=1;
		public var jumpdy:Number=15, plavdy:Number=1, levidy:Number=1, elast:Number=0, jumpBall:Number=0;
		public var ddyPlav:Number=1; //выталкивающая сила
		public var osndx:Number=0, osndy:Number=0;
		public var levit_max=0; //максимальное время левитации, если 0, то левитация не ограничена
		public var levit_r:int=0;		//сколько времени объект был левитирован
		public var grav:Number=1;
		public var slow:int=0;			//внешнее замедление
		public var tormoz:Number=1;		//на эту величину умножается dx, если объект стоит на земле
		public var t_throw:int=0;		//включается после броска
		//переменные
		public var stayPhis:int;
		public var stayOsn:Box=null;
		public var stayMat:int;
		public var tykMat:int;
		protected var shX1:Number, shX2:Number;	//насколько не помещаешься
		protected var diagon:int=0;
		public var porog:Number=10, porog_jump:Number=4; //автоподъём
		public var isSit:Boolean=false, isFly:Boolean=false, isRun:Boolean=false, isPlav:Boolean=false, isLaz:int=0, inWater:Boolean=false, isUp:Boolean=false;
		public var throu:Boolean=false, isJump:Boolean=false, turnX:int=0, turnY:int=0, kray:Boolean=false;
		public var pumpObj:Interact;	//объект на который наткнулся (для открывание дверей мобами)
		private var namok_t:int=0;
		var visDamDY:int=0;


		//оружие
		public var currentWeapon:Weapon;
		public var weaponSkill:Number=1;		//владение оружием
		public var spellPower:Number=1;		//сила заклинаний, не являющихся оружием
		public var mazil:int=0;			//дополнительный случайный разлёт пуль
		public var critCh:Number=0;		//дополнительный шанс крита
		public var critInvis:Number=0;	//прибавка к шансу крита для мобов, у которых не установлена цель на владелца пули
		public var critDamMult:Number=2;	//множитель критического урона
		public var precMult:Number=1;	//модификатор точности для гг, для всех остальных он равен 1
		public var precMultCont:Number=1;	//модификатор точности, уменьшающийся от критических эффектов
		public var rapidMultCont:Number=1;	//модификатор скорости атаки холодным оружием, уменьшающийся от критических эффектов
		public var weaponKrep:int=1;	
		public var weaponX:Number, weaponY:Number, weaponR:Number=0;
		public var magicX:Number, magicY:Number;
		public var childObjs:Array;			//подчинённые объекты
		public var isShoot:Boolean=false;	//устанавливается оружием в true если был выстрел

		//ии
		var aiNapr:int=1, aiVNapr:int=0; //направление, в котором стремиться двигаться ии
		var aiTTurn:int=10, aiPlav:int=0; 
		var aiState:int=0;	//состояние ии 
		var aiTCh:int=Math.floor(Math.random()*10);	//таймер смены состояния ии 
		var aiSpok:int=0, maxSpok:int=30;	//0 - спокоен, 1-9 - возбуждён, maxSpok - атакует цель
		//координаты и вид цели
		public var celX:Number=0, celY:Number=0, celDX:Number=0, celDY:Number=0;
		public var acelX:Number=0, acelY:Number=0;	//антицель
		public var celUnit:Unit;	//кто является целью
		public var priorUnit:Unit;	//кто является врагом
		public var eyeX:Number=-1000, eyeY:Number=-1000;	//точка зрения
		
		//состояния
		public var sost:int=1;  //1-живой	2-в отключке    3-сдох    4-уничтожен и больше не обрабатывается
		public var shok:int=0, maxShok:int=30;
		public var stun:int=0;
		public var neujaz:int=0, neujazMax:int=20;
		public var disabled:Boolean=false;
		public var noAct:Boolean=false;	//неактивен, может быть включён командой
		public var oduplenie:int=100;
		public var lootIsDrop=false;	//выпадал ли уже лут
		public var aiTip:String;
		public var t_emerg:int=0, max_emerg:int=0;
		public var wave:int=0;	//враг принадлежит к волне
		public var transT:Boolean=false;	//проходит через магическую стену
		public var postDie:Boolean=false;	//изначально труп
		
		//Опции
		public var blood:int=0; //кровь: 0-нет, 1-обычная, 2-зелёная
		public var mat:int=0; //0-мясо, 1-металл
		public var acidDey:Number=0;	//разъедание брони кислотой
		public var trup:Boolean=true; //оставлять труп или уничтожить
		public var overLook:Boolean=true; //может видеть то что сзади
		public var plav:Boolean=true; //при true - плавает, иначе ходит по дну
		public var showNumbs:Boolean=true;	//отображать урон
		public var activateTrap:int=2;	//активировать ловушки и мины
		public var isSats:Boolean=true;	//быть целью для ЗПС
		public var msex:Boolean=true;		//пол мужской
		public var doop:Boolean=false;	//true устанавливается для тех, кто не отслеживает цели
		public var plaKap:Boolean=true;	//брызгается
		public var noBox:Boolean=false;	//не получчает удары ящиками
		public var areaTestTip:String;
		public var mHero:Boolean=false;	//может стать героем
		public var isRes:Boolean=false;	//восстаёт после смерти
		public var mech:Boolean=false;	//механизм
		public var noDestr:Boolean=false; //не уничтожать после смерти
		
		public var opt:Object;
		public static var opts:Array=new Array();
		
		//фракция
		public var fraction:int=0, player:Boolean=false;
		public static const F_PLAYER=100, F_MONSTER=1, F_RAIDER=2, F_ZOMBIE=3, F_ROBOT=4;
		public var npc:Boolean=false;	//Юнит является NPC-ом и отображается на карте
		
		//видимость юнита для других (маскировка), чем выше показатель, тем с большего расстояния объект виден
		public var visibility:int=1000, stealthMult:Number=1;	//с какого расстояния становится виден
		public var detecting:int=80;	//расстояние безусловного обнаружения
		public var demask:Number=0;
		public var invis:Boolean=false;
		public var noise:int=0, noiseRun:int=200, noise_t:int=30;			//звук
		public var isVis:Boolean=true; 		//видимый или нет для ГГ
		public var volMinus:Number=0;	//падение громкости звуковых эффектов
		public var light:Boolean=false;	//убрать туман войны в этой точке
		
		//видимость других юнитов
		public var observ:Number=0;			//наблюдательность
		public var vision:Number=1;			//множитель зрения
		public var ear:Number=1;			//множитель слуха
		public var unres:Boolean=false;		//не реагировать на звуки
		public var vAngle:Number=0;			//конус зрения
		public var vKonus:Number=0;			//конус зрения
		
		//эффекты
		public var effects:Array;
		
		//случайное имя
		public var id_name:String;
		//реплики
		public var t_replic:int=Math.random()*100-50;
		public var id_replic:String='';
		
		//визуальная часть
		//блиттинг
		var blitId:String;		//id битмапа
		public var animState:String='',animState2:String='';
		public var blitData:BitmapData;
		var blitX:int=120, blitY:int=120;
		var blitDX:int=-1, blitDY:int=-1;
		var blitRect:Rectangle;
		var blitPoint:Point;
		var visData:BitmapData;
		var visBmp:Bitmap;
		var anims:Array;
		
		var ctrans:Boolean=true;	//применять цветофильтр
		//полоска хп
		public var hpbar:MovieClip;
		public static var heroTransforms=[new ColorTransform(1,0.8,0.8,1,64,0,0,0),new ColorTransform(0.8,1,1,1,0,32,64,0),new ColorTransform(1,0.8,1,1,32,0,64,0),new ColorTransform(0.8,1,0.8,1,0,64,0,0)];
		//смертельные эффекты
		var timerDie:int=0;	//отложенная смерть
		var burn:Desintegr;
		var bloodEmit:Emitter;
		var numbEmit:Emitter;
		var hitPart:Part, t_hitPart:int=0, hitSumm:Number=0, t_mess:int=0;
		//звуки
		public var sndMusic:String;
		var sndMusicPrior:int=0;
		public var sndDie:String;
		public var sndRun:String;
		public var sndRunDist:Number=800;
		public var sndRunOn:Boolean=false;
		var sndVolkoef:Number=1;

		//пложение
		var mother:Unit;
		var kolChild:int=0;

		public var scrDie:Script, scrAlarm:Script;
		public var questId:String;	//id для коллекционного квеста
		
		public var trig:String;		//условие появления
		public var trigDis:Boolean=false;	//отключён по триггеру
		
		public var xp:int=0;	//опыт
		
		static var ppp:Point=new Point();
		
		static const robotKZ=75;
		static const damWallStun=45;



		//Параметры для создания юнита
		//cid - идентификатор создания, на основе которого внутри конструктора класса будет определён настоящий идентификатор
		//dif - уровень сложности для этого юнита
		//xml - индивидуальные параметры, взятые из карты
		//loadObj - объект для загрузки состояния юнита
		public function Unit(cid:String=null, ndif:Number=100, xml:XML=null, loadObj:Object=null) {
			vulner=new Array();
			inter=new Interact(this,null,xml,loadObj);
			inter.active=false;
			for (var i=0; i<kolVulners; i++) vulner[i]=1;
			vulner[D_EMP]=0;
			effects=new Array();
			sloy=2, prior=1, warn=1;
			numbEmit=Emitter.arr['numb'];
			if (xml) {
				if (xml.@turn.length()) {
					if (xml.@turn>0) storona=1;
					if (xml.@turn<0) storona=-1;
				} else {
					storona=isrnd()?1:-1;
					aiNapr=storona;
				}
				if (xml.@name.length()) {
					uniqName=true;
					nazv=Res.txt('u',xml.@name);
				}
				if (xml.@ai.length()) aiTip=xml.@ai;
				if (xml.@hpmult.length()) hpmult=xml.@hpmult;
				if (xml.@multhp.length()) hpmult=xml.@multhp;
				if (xml.@unres.length()) unres=true;
				if (xml.@qid.length()) questId=xml.@qid;
				if (xml.@trig.length()) trig=xml.@trig;
				if (xml.@hero.length()) hero=xml.@hero;
				if (xml.@observ.length()) observ=xml.@observ;
				if (xml.@light.length()) light=true;
				if (xml.@noagro.length()) noAgro=true;
				if (xml.@dis.length()) {
					noAct=true;
					disabled=true;
				}
				if (xml.@die.length()) postDie=true;
			}
			/*if (xml && xml.@code=='MraR4xuhkXhpQYkj') {
				trace(loadObj.dead)
			}*/
			if (loadObj && loadObj.dead && !postDie) {
				sost=4;
				disabled=true;
				trace(this, nazv)
			}
			mapxml=xml;
		}
		
		public static function create(id:String, dif:int, xml:XML=null, loadObj:Object=null, ncid:String=null):Unit {
			if (id=='mwall') return new UnitMWall(null,0,null,null);
			if (id=='scythe') return new UnitScythe(null,0,null,null);
			if (id=='ttur') return new UnitThunderTurret(ncid,0,null,null);
			var node:XML=AllData.d.obj.(@id==id)[0];
			if (node==null) {
				trace('Не найден юнит',id);
				return null;
			}
			var uc:Class;
			var cn:String=node.@cl;
			switch (cn) {
				case 'Mine': uc=Mine;break;
				case 'UnitTrap': uc=UnitTrap;break;
				case 'UnitTrigger': uc=UnitTrigger;break;
				case 'UnitDamager': uc=UnitDamager;break;
				case 'UnitRaider': uc=UnitRaider;break;
				case 'UnitSlaver': uc=UnitSlaver;break;
				case 'UnitZebra': uc=UnitZebra;break;
				case 'UnitRanger': uc=UnitRanger;break;
				case 'UnitEncl': uc=UnitEncl;break;
				case 'UnitMerc': uc=UnitMerc;break;
				case 'UnitZombie': uc=UnitZombie;break;
				case 'UnitAlicorn': uc=UnitAlicorn;break;
				case 'UnitHellhound': uc=UnitHellhound;break;
				case 'UnitRobobrain': uc=UnitRobobrain;break;
				case 'UnitProtect': uc=UnitProtect;break;
				case 'UnitGutsy': uc=UnitGutsy;break;
				case 'UnitEqd': uc=UnitEqd;break;
				case 'UnitSentinel': uc=UnitSentinel;break;
				case 'UnitTurret':uc=UnitTurret;break;
				case 'UnitBat': uc=UnitBat;break;
				case 'UnitFish': uc=UnitFish;break;
				case 'UnitBloat': uc=UnitBloat;break;
				case 'UnitBloatEmitter': uc=UnitBloatEmitter;break;
				case 'UnitSpriteBot': uc=UnitSpriteBot;break;
				case 'UnitDron': uc=UnitDron;break;
				case 'UnitVortex': uc=UnitVortex;break;
				case 'UnitMonstrik': uc=UnitMonstrik;break;
				case 'UnitAnt': uc=UnitAnt;break;
				case 'UnitSlime': uc=UnitSlime;break;
				case 'UnitRoller': uc=UnitRoller;break;
				case 'UnitNPC': uc=UnitNPC;break;
				case 'UnitCaptive': uc=UnitCaptive;break;
				case 'UnitPonPon': uc=UnitPonPon;break;
				case 'UnitTrain': uc=UnitTrain;break;
				case 'UnitMsp': uc=UnitMsp;break;
				case 'UnitTransmitter': uc=UnitTransmitter;break;
				case 'UnitNecros': uc=UnitNecros;break;
				case 'UnitSpectre': uc=UnitSpectre;break;
				case 'UnitBossRaider': uc=UnitBossRaider;break;
				case 'UnitBossAlicorn': uc=UnitBossAlicorn;break;
				case 'UnitBossUltra': uc=UnitBossUltra;break;
				case 'UnitBossNecr': uc=UnitBossNecr;break;
				case 'UnitBossDron': uc=UnitBossDron;break;
				case 'UnitBossEncl': uc=UnitBossEncl;break;
				case 'UnitThunderHead': uc=UnitThunderHead;break;
				case 'UnitDestr': uc=UnitDestr;break;
			}
			if (uc==null) {
				return null;
			}
			var cid:String=null;						//идентификатор создания
			if (node.@cid.length()) cid=node.@cid;
			if (ncid!=null) cid=ncid;
			var un:Unit=new uc(cid,dif,xml,loadObj);
			if (xml && xml.@code.length()) un.code=xml.@code;
			return un;
		}
		
		public override function save():Object {
			var obj:Object=new Object();
			if (sost>=3 && !postDie) obj.dead=true;
			if (inter) inter.save(obj);
			return obj;
		}
		
		public function getXmlParam(mid:String=null) {
			var setOpts:Boolean=false;
			if (opts[id]) {
				opt=opts[id];
				begvulner=begvulners[id];
			} else {
				opt=new Object();
				opts[id]=opt;
				begvulner=new Array();
				begvulners[id]=begvulner;
				setOpts=true;
			}
			var node:XML;
			var isHero:Boolean=false;
			if (mid==null) {
				if (hero>0) isHero=true;
				mid=id;
			}
			var node0:XML=AllData.d.unit.(@id==mid)[0];
			if (mid && !uniqName) nazv=Res.txt('u',mid);
			if (node0.@fraction.length()) fraction=node0.@fraction;
			inter.cont=mid;
			if (node0.@cont.length() && inter) inter.cont=node0.@cont;
			if (fraction==F_PLAYER) warn=0;
			if (node0.@xp.length()) xp=node0.@xp*World.unitXPMult;
			//физические параметры
			if (node0.phis.length()) {
				node=node0.phis[0];
				if (node.@sX.length()) stayX=scX=node.@sX;
				if (node.@sY.length()) stayY=scY=node.@sY;
				if (node.@sitX.length()) sitX=node.@sitX; else sitX=stayX;
				if (node.@sitY.length()) sitY=node.@sitY; else sitY=stayY/2;
				if (node.@massa.length()) massaMove=node.@massa/50;
				if (node.@massafix.length()) massaFix=node.@massafix/50;
				else massaFix=massaMove;
			}
			massa=massaFix;
			if (massa>=1) destroy=0;
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
				if (node.@aqual.length()) armor_qual=node.@aqual;		//качество брони
				if (node.@armorhp.length()) armor_hp=armor_maxhp=node.@armorhp*hpmult;
				else armor_hp=armor_maxhp=hp;
				
				if (node.@krep.length()) weaponKrep=node.@krep;			//способ держать оружие, 0 - телекинез
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
			//уязвимости
			if (node0.vulner.length()) {
		//public static const D_BUL=0, D_BLADE=1, D_PHIS=2, D_FIRE=3, D_EXPL=4, D_LASER=5, D_PLASMA=6, D_VENOM=7, D_EMP=8, D_SPARK=9, D_ACID=10, D_INSIDE=100;
				node=node0.vulner[0];
				if (node.@bul.length()) vulner[D_BUL]=node.@bul;
				if (node.@blade.length()) vulner[D_BLADE]=node.@blade;
				if (node.@phis.length()) vulner[D_PHIS]=node.@phis;
				if (node.@fire.length()) vulner[D_FIRE]=node.@fire;
				if (node.@expl.length()) vulner[D_EXPL]=node.@expl;
				if (node.@laser.length()) vulner[D_LASER]=node.@laser;
				if (node.@plasma.length()) vulner[D_PLASMA]=node.@plasma;
				if (node.@venom.length()) vulner[D_VENOM]=node.@venom;
				if (node.@emp.length()) vulner[D_EMP]=node.@emp;
				if (node.@spark.length()) vulner[D_SPARK]=node.@spark;
				if (node.@acid.length()) vulner[D_ACID]=node.@acid;
				if (node.@cryo.length()) vulner[D_CRIO]=node.@cryo;
				if (node.@poison.length()) vulner[D_POISON]=node.@poison;
				if (node.@bleed.length()) vulner[D_BLEED]=node.@bleed;
				if (node.@fang.length()) vulner[D_FANG]=node.@fang;
				if (node.@pink.length()) vulner[D_PINK]=node.@pink;
			}
			//визуальные параметры
			if (node0.vis.length()) {
				node=node0.vis[0];
				if (node.@sex=='w') msex=false;
				if (node.@blit.length()) {
					blitId=node.@blit;
					if (node.@sprX>0) blitX=node.@sprX;
					if (node.@sprY>0) blitY=node.@sprY;
					else blitY=node.@sprX;
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
					if (node.@pony.length()) opt.pony=true;					//является пони
					if (node.@zombie.length()) opt.zombie=true;					//является зомби
					if (node.@robot.length()) opt.robot=true;					//является роботом
					if (node.@insect.length()) opt.insect=true;					//является насекомым
					if (node.@monster.length()) opt.monster=true;					//является насекомым
					if (node.@alicorn.length()) opt.alicorn=true;					//является аликорном
					if (node.@mech.length()) {
						opt.mech=true;					//является механизмом
						mech=true;
					}
					if (node.@hbonus.length()) opt.hbonus=true;					//является пони
					if (node.@izvrat.length()) opt.izvrat=true;					//является пони
				}
			}
			if (blood==0) vulner[D_BLEED]=0;
			if (opt) {
				if (opt.robot || opt.mech) {
					vulner[D_NECRO]=vulner[D_BLEED]=vulner[D_VENOM]=vulner[D_POISON]=0;
				}
			}
			if (node0.blit.length()) {
				if (anims==null) anims=new Array();
				for each(var xbl:XML in node0.blit) {
					anims[xbl.@id]=new BlitAnim(xbl);
				}
			}
			if (setOpts) for (var i=0; i<kolVulners; i++) begvulner[i]=vulner[i];
		}
		
		public function getXmlWeapon(dif:int):Weapon {
			var node0:XML=AllData.d.unit.(@id==id)[0];
			var weap:Weapon;
			for each(var n:XML in node0.w) {
				if (n.@f.length()) continue;
				if (n.@dif.length() && n.@dif>dif) continue;
				if (n.@ch.length()==0 || isrnd(n.@ch)) {
					weap=Weapon.create(this,n.@id);
					if (weap) return weap;
				}
			}
			return null;
		}
		
		public function getName():String {
			if (World.w.game==null || id_name==null) return '';
			var arr:Array=World.w.game.names[id_name];
			if (arr==null || arr.length==0) arr=Res.namesArr(id_name); 	//подготовить массив имён
			if (arr==null || arr.length==0) return '';
			World.w.game.names[id_name]=arr;
			var n=Math.floor(Math.random()*arr.length);
			var s=arr[n];
			arr.splice(n,1);
			return s;
		}
		
		public function checkTrig():Boolean {
			if (trig) {
				if (trig=='eco' && (World.w.pers==null || World.w.pers.eco==0)) return false;
				if (World.w.game.triggers[trig]!=1) return false;
			}
			return true;
		}
		
		//поместить созданный юнит в локацию
		public function putLoc(nloc:Location, nx:Number, ny:Number) {
			if (loc!=null) return;
			loc=nloc;
			if (loc.mirror) {
				storona=-storona;
				aiNapr=storona;
			}
			setPos(nx,ny);
			if (collisionAll()) {
				if (!collisionAll(-Tile.tileX)) {
					setPos(nx-Tile.tileX,ny);
				}
			}
			if (inter) inter.loc=nloc;
			if (inter && inter.saveLoot==2) {
				inter.loot(true);	//если состояние 2, сгенерировать критичный лут
			}
			if (sost>=3) return;
			begX=X, begY=Y;
			if (hero==0) cTransform=loc.cTransform;
			else cTransform=heroTransforms[hero-1];
			if (loc.biom==5) {
				vulner[D_PINK]=0;	//неуязв. к розовому облаку
			}
			//прикреплённые скрипты
			if (mapxml) {
				if (mapxml.scr.length()) {
					for each (var xscr in mapxml.scr) {
						var scr:Script=new Script(xscr,loc.land, this);
						if (scr.eve=='die' || scr.eve==null) scrDie=scr;
						if (scr.eve=='alarm') scrAlarm=scr;
					}
				}
				if (mapxml.@scr.length()) scrDie=World.w.game.getScript(mapxml.@scr,this);
				if (mapxml.@alarm.length()) scrAlarm=World.w.game.getScript(mapxml.@alarm,this);
			}
			if (postDie) {
				sost=3;
				setCel(null, X+storona*100,Y+50);
				lootIsDrop=true;
				die();
			};
		}
		//установить левел моба (значение прибавляется к левелу, заданному через карту, по умолчанию 0)
		public function setLevel(nlevel:int=0) {
			level+=nlevel;
			if (level<0) level=0;
			hp=maxhp=hp*(1+level*0.11);
			dam*=(1+level*0.07);
			radDamage*=(1+level*0.1);
			critCh=level*0.01;
			armor*=(1+level*0.05);
			marmor*=(1+level*0.05);
			skin*=(1+level*0.05);
			armor_hp=armor_maxhp=armor_hp*(1+level*0.1);
			observ+=Math.min(nlevel*0.6,15)*(0.9+Math.random()*0.2);
			if (currentWeapon && currentWeapon.tip==0) {
				currentWeapon.damage*=(1+level*0.07);
			} else {
				weaponSkill*=(1+level*0.035);
			}
			damWall*=(1+level*0.04);
			//nazv+=' '+level;
		}
		
		//сделать героем
		public function setHero(nhero:int=1) {
			if (!mHero) return;
			if (hero==0) hero=nhero;
			if (hero>0) {
				if (!uniqName) {
					var s=getName();
					if (s!=null && s!='') nazv=s;
				}
				xp*=5;
			}
			if (hero==1) {
				hp=maxhp=maxhp*2.5;
				dam*=1.8;
				if (currentWeapon) currentWeapon.damage*=1.5;
			} else if (hero==2 || hero==3) {
				hp=maxhp=maxhp*3;
				dam*=1.2;
			} else if (hero==4) {
				hp=maxhp=maxhp*2;
				dam*=1.4;
				observ+=8;
				walkSpeed*=1.4;
				sitSpeed*=1.4;
				runSpeed*=1.25;
			}
			setHeroVulners();
			//trace(id,hero)
		}
		
		public function setHeroVulners() {
			vulner[D_EMP]*=0.8;
			vulner[D_BALE]*=0.7;
			vulner[D_NECRO]*=0.7;
			vulner[D_ASTRO]*=0.7;
			if (hero==2) {
				vulner[D_BUL]*=0.5;
				vulner[D_PHIS]*=0.65;
				vulner[D_BLADE]*=0.65;
				vulner[D_EXPL]*=0.75;
			}
			if (hero==3) {
				vulner[D_LASER]*=0.6;
				vulner[D_PLASMA]*=0.5;
				vulner[D_EMP]*=0.75;
				vulner[D_SPARK]*=0.7;
				vulner[D_FIRE]*=0.7;
			}
		}
		
		//привести в исходное состояние, если f=true, то вернуть на места
		public override function setNull(f:Boolean=false) {
			if (boss && isNoResBoss()) f=false;
			if (sost==1) {
				if (f) {
					//сбросить эффекты
					if (effects.length>0) {
						for each (var eff in effects) eff.unsetEff();
						effects=new Array();
					}
					stun=cut=poison=0;
					oduplenie=Math.round(World.oduplenie*(Math.random()*0.2+0.9));
					if (!noAct) disabled=false;		//включить
					hp=maxhp;			//восстановить хп
					armor_hp=armor_maxhp;
					if (hpbar) visDetails();
					//вернуть в исходную точку
					if (begX>0 && begY>0) setPos(begX, begY);
					dx=dy=0;
					setWeaponPos();
				}
				if (currentWeapon) currentWeapon.setNull();
			}
			levit=0;
		}
		
		//условие, при котором босс не восстанавливает хп
		public function isNoResBoss():Boolean {
			var res=false;
			try {
				res=World.w.game.globalDif<=3 && loc && loc.land.act.tip!='base';
			} catch(err) {}
			return res;
		}
		
		public override function err():String {
			//setNull();
			return 'Error unit '+nazv;
		}
		
		
		
		public override function step() {
			if (disabled || trigDis) return;
			if (t_emerg>0) {
				t_emerg--;
				setVisPos();
				if (vis) {
					if (t_emerg>0) {
						var tf=t_emerg/(max_emerg+1);
						vis.filters=[new GlowFilter(0xAADDFF,tf,tf*20,tf*20,1,3)];
						vis.alpha=1-tf;
					} else {
						vis.filters=[];
						vis.alpha=1;
					}
				}
				return;
			}
			if (sost==2) {
				timerDie--;
				if (timerDie<=0) die();
			}
			if (inter) inter.step();
			getRasst2();
			if (radioactiv) ggModum();	//действие на ГГ (радиация)
			forces();		//внешние силы, влияющие на ускорение
			//try {
				control();		//управление игроком или ИИ
			//} catch (err) {
			//}
			//движение
			if (fixed) {
			} else if (bind || Math.abs(dx+osndx)<World.maxdelta && Math.abs(dy+osndy)<World.maxdelta)	{
				run();
			} else {
				var div=Math.floor(Math.max(Math.abs(dx+osndx),Math.abs(dy+osndy))/World.maxdelta)+1;
				for (var i=0; i<div; i++) run(div);
			}
			checkWater();
			actions();		//различные действия
			setVisPos();
			if (hpbar) setHpbarPos();
			if (burn==null) animate();		//анимация
			else {
				burn.step();
				if (burn.vse) exterminate();
			}
			onCursor=(isVis && !disabled && sost<4 && X1<World.w.celX && X2>World.w.celX && Y1<World.w.celY && Y2>World.w.celY)?prior:0;
			//подчинённые объекты
			for (i in childObjs) if (childObjs[i]) {
				try {
					childObjs[i].step();
				} catch(err) {
					childObjs[i].err();
				}
			}
			visDamDY=0;
			if (sndRunOn && sndRun && loc && loc.active) sndRunPlay();

			//if (id=='slaver1')	trace(dx);

		}
		
		public function control() {
		}
		
//**************************************************************************************************************************
//
//				Движение
//
//**************************************************************************************************************************
		//перемещение в точку
		public function setPos(nx:Number,ny:Number) {
			X=nx, Y=ny;
			Y1=Y-scY, Y2=Y, X1=X-scX/2, X2=X+scX/2;
			setCel();
		}
		
		
		//Выход за пределы локации
		public function outLoc(napr:int, portX:Number=-1, portY:Number=-1):Boolean {
			//1-влево, 2-вправо, 3-вниз, 4-вверх
			//для всех, кроме гг, должно возвращать false
			if (isFly || levit) return false;
			if (napr==3) {
				if (loc.bezdna || jumpdy<=0 || sost==3) {		//падение за пределы локации
					disabled=true;
					dy=0;
					if (sost==3) {
						sost=4;
						loc.remObj(this);
					}
					remVisual();
				} else {
					dy=-jumpdy;
					dx=storona*maxSpeed;
				}
			} 
			return false;
		}
		
		//постепенное появление
		public function emergence(n:int=30) {
			t_emerg=max_emerg=n;
		}

		//Действующие силы
		public function forces() {
			if (levit) {
				dy*=0.8;
				dx*=0.8;
				isLaz=0;
			}
			if (isPlav) {
				if (!levit) dy+=World.ddy*ddyPlav;
				dy*=0.8;
				dx*=0.8;
			} else if (isFly) {
				if (t_throw>0) {
				} else {
					if ((dx*dx+dy*dy)>maxSpeed*maxSpeed) {
						dx*=0.7;
						dy*=0.7;
					}
					if (dx>-brake && dx<brake) dx=0;
					if (dy>-brake && dy<brake) dy=0;
				}
			} else {
				if (inWater) dx*=0.5;
				//if (!levit && dy<World.maxdy) dy+=World.ddy;
				if (!levit && isLaz==0) {
					var t:Tile=loc.getAbsTile(X,Y-scY/4);
					if (t.grav>0 && dy<World.maxdy*t.grav || t.grav<0 && dy>World.maxdy*t.grav) dy+=World.ddy*t.grav*grav;
				}
				if (stay) {
					dx*=tormoz;
					if (walk<0) {
						if (dx<-maxSpeed) dx+=brake;
					} else if (walk>0) {
						if (dx>maxSpeed) dx-=brake;
					} else {
						if (dx>-brake && dx<brake) dx=0;
						else if (dx>0) dx-=brake;
						else if (dx<0) dx+=brake;
					}
					if (loc.quake && massa<=2 && sost==1) {
						var pun:Number=(1+(2-massa)/2)*loc.quake;
						if (pun>10) pun=10;
						dy=-pun*Math.random();
						dx+=pun*(Math.random()*2-1);
					}
				}
			}
			if (slow>0) {
				dx*=0.75;
				dy*=0.75;
			}
			osndx=osndy=0;
			if (stayOsn) {
				if (stayOsn.cdx>10 || stayOsn.cdx<-10 || stayOsn.cdy>10 || stayOsn.cdy<-10) {
					stay=false;
				} else {
					osndx=stayOsn.cdx;
					osndy=stayOsn.cdy;
				}
			}
			stayOsn=null;
		}
		
		
		
		public function run(div:int=1) {
			if (loc.sky) {
				run2(div);
				return;
			}
			//движение
			var t:Tile, t2:Tile;
			var i:int;
			var newmy:Number=0;
			var autoSit:Boolean=false;
			//porog=(diagon==0)?10:40;
			
			if (!throu && stay && diagon!=0 && dy>=0) {
				if (!collisionAll(dx/div,-dx/div*diagon)) {
					X+=dx/div;
					Y-=dx/div*diagon;
					Y1=Y-scY, Y2=Y;
					X1=X-scX/2, X2=X+scX/2;
					dy=0;
					checkDiagon(0);
				} else if (-dx/div*diagon>0 && !collisionAll(dx/div,0)) {
					diagon=0;
				}
				return;
			}			
			diagon=0;
			//ГОРИЗОНТАЛЬ
			if (!isLaz) {
				X+=(dx+osndx)/div;
				//Y-=dx/div*diagon;
				if (X-scX/2<0) {
					if (!outLoc(1)) {
						X=scX/2;
						dx=Math.abs(dx)*elast;
						turnX=1;
						kray=true;
					}
				}
				if (X+scX/2>=loc.limX) {
					if (!outLoc(2)) {
						X=loc.limX-1-scX/2;
						dx=-Math.abs(dx)*elast;
						turnX=-1;
						kray=true;
					}
				}
				X1=X-scX/2, X2=X+scX/2;
				//движение влево
				if (dx+osndx<0) {
					if (!player && stay && shX1>0.5) {
						newmy=checkDiagon(-5);
						if (newmy>0) {
							Y=newmy;
							Y1=Y-scY, Y2=Y;
						}
					}
					if (player && !isSit && !isFly && !isPlav && !levit && (!stay || isUp || shX1>0.5)) {
						newmy=checkDiagon(-2,-1);
						if (newmy>0) {
							Y=newmy;
							Y1=Y-scY, Y2=Y;
						}
					}
					if (player && isUp && stay && !isSit) {
						t=loc.space[Math.floor(X1/Tile.tileX)][Math.floor(Y1/Tile.tileY)];
						t2=loc.space[Math.floor(X1/Tile.tileX)][Math.floor(Y1/Tile.tileY)+1];
						if ((t.phis==0 || t.phis==3) && !(t2.phis==0 || t2.phis==3) && t2.zForm==0) {
							Y=Y2=t2.phY1;
							sit(true);
							autoSit=true;
						}
					}
					if (mater) {
						for (i=Math.floor(Y1/Tile.tileY); i<=Math.floor(Y2/Tile.tileY); i++) {
							t=loc.space[Math.floor(X1/Tile.tileX)][i];
							if (collisionTile(t)) {
								if (t.door && t.door.inter) pumpObj=t.door.inter;
								if (Y2-t.phY1<=(stay?porog:porog_jump) && !collisionAll(-20,t.phY1-Y2)) {
									Y=t.phY1;
								} else {
									X=t.phX2+scX/2;
									if (t_throw>0 && dx<-damWallSpeed && damWall) damageWall(2);//((-dx-damWallSpeed)/4*damWall,D_PHIS);
									if (destroy>0 && destroyWall(t,1)) {
										dx*=0.75;
									} else {
										dx=Math.abs(dx)*elast;
										turnX=1;
										if (t.mat==1) tykMat=1;
										X1=X-scX/2, X2=X+scX/2;
									}
								}
							}
						}
					}
				}
				//движение вправо
				if (dx+osndx>0) {
					if (!player && stay && shX2>0.5) {
						newmy=checkDiagon(-5);
						if (newmy>0) {
							Y=newmy;
							Y1=Y-scY, Y2=Y;
						}
					}
					if (player && !isSit && !isFly && !isPlav && !levit && (!stay || isUp || shX2>0.5)) {
						newmy=checkDiagon(-2,1);
						if (newmy>0) {
							Y=newmy;
							Y1=Y-scY, Y2=Y;
						}
					}
					if (player && isUp && stay && !isSit) {
						t=loc.space[Math.floor(X2/Tile.tileX)][Math.floor(Y1/Tile.tileY)];
						t2=loc.space[Math.floor(X2/Tile.tileX)][Math.floor(Y1/Tile.tileY)+1];
						if ((t.phis==0 || t.phis==3) && !(t2.phis==0 || t2.phis==3) && t2.zForm==0) {
							Y=Y2=t2.phY1;
							sit(true);
							autoSit=true;
						}
					} 
					if (mater) {
						for (i=Math.floor(Y1/Tile.tileY); i<=Math.floor(Y2/Tile.tileY); i++) {
							t=loc.space[Math.floor(X2/Tile.tileX)][i];
							if (collisionTile(t)) {
								if (t.door && t.door.inter) pumpObj=t.door.inter;
								if (Y2-t.phY1<=(stay?porog:porog_jump) && !collisionAll(20,t.phY1-Y2)) {
									Y=t.phY1;
								} else {
									X=t.phX1-scX/2;
									if (t_throw>0 && dx>damWallSpeed && damWall) damageWall(1);
									if (destroy>0 && destroyWall(t,2)) {
										dx*=0.75;
									} else {
										dx=-Math.abs(dx)*elast;
										turnX=-1;
										if (t.mat==1) tykMat=1;
										X1=X-scX/2, X2=X+scX/2;
									}
								}
							}
						}
					}
				}
				Y1=Y-scY, Y2=Y;
			}
			//отталкивание
			
			
			//ВЕРТИКАЛЬ
			//движение вниз
			newmy=0;
			if (dy+osndy>0) {
				if (dy>0) {
					stay=false;
					stayPhis=stayMat=0;
				}
				//diagon=0;
				shX1=shX2=1; //если >0, то не полностью стоишь на полу
				if (levit || plav && isPlav || isFly) {	//полёт, левитация или плавание 
					diagon=0;
					Y+=(dy+osndy)/div;
					if (Y>loc.limY) {
						if (!outLoc(3)) {
							Y=loc.limY-1;
							dy=0;
							turnY=-1;
						}
					}
					Y1=Y-scY, Y2=Y;
					if (mater) {
						for (i=Math.floor(X1/Tile.tileX); i<=Math.floor(X2/Tile.tileX); i++) {
							t=loc.space[i][Math.floor(Y2/Tile.tileY)];
							if (collisionTile(t)) {
								Y=t.phY1;
								Y1=Y-scY, Y2=Y;
								dy=0;
								turnY=-1;
								if (t.mat==1) tykMat=1;
							}
						}
					}
				} else {						//падение
					if (mater) {
						for (i=Math.floor(X1/Tile.tileX); i<=Math.floor(X2/Tile.tileX); i++) {
							t=loc.space[i][Math.floor((Y2+dy/div)/Tile.tileY)];
							if (collisionTile(t,0,dy/div)) {
								if (-(X1-t.phX1)/scX<shX1) shX1=-(X1-t.phX1)/scX;
								if ((X2-t.phX2)/scX<shX2) shX2=(X2-t.phX2)/scX;
								newmy=t.phY1;
								if (t.mat>0) stayMat=t.mat;
								if (t.phis>=1 && !(transT && t.phis==3)) {
									stayPhis=1;
									if (t_throw>0 && dy>damWallSpeed && damWall) damageWall(3);
									if (destroy>0 || massa>=1) destroyWall(t,3);
								} else if (t.shelf && stayPhis==0) {
									stayPhis=2;
									stayMat=t.mat;
								}
								diagon=0;
							}
						}
					}
					if (newmy==0 && !throu) newmy=checkDiagon(dy/div);
					if (newmy==0 && !throu) newmy=checkShelf(dy/div, osndy/div);
					if (newmy) {	//баги!!!!!
						Y1=newmy-scY;
						for (i=Math.floor(X1/Tile.tileX); i<=Math.floor(X2/Tile.tileX); i++) {
							t=loc.space[i][Math.floor((newmy-scY)/Tile.tileY)];
							if (collisionTile(t)) newmy=0;
						}
					}
					if (newmy) {
						Y=newmy;
						Y1=Y-scY, Y2=Y;
						if (dy>16) makeNoise(noiseRun,true);
						else if (dy>9) makeNoise(noiseRun/2,true);
						if (dy>5) sndFall();
						if (jumpBall>0 && dy>3) {
							dy=-dy*jumpBall;
							turnY=-1;
						} else {
							dy=0;
							
						}
						stay=true;
						fracLevit=0;
		
						isLaz=0;
					} else {
						Y+=dy/div;
						Y1=Y-scY, Y2=Y;
					}
					if (Y>loc.limY) {
						if (!outLoc(3)) {
							Y=loc.limY-1;
							turnY=-1;
							Y1=Y-scY, Y2=Y;
						}
					}
				}
			}
			//движение вверх
			if (dy+osndy<0) {
				if (dy<0) {
					stay=false;
					diagon=0;
				}
				if (Y-scY<0) {
					if (!outLoc(4)) {
						Y=scY-0.1;
						dy=0;
						turnY=1;
					}
				}
				if (dy>0) {
					newmy=checkShelf(dy/div, osndy/div);
					if (newmy) {
						Y=newmy;
						Y1=Y-scY, Y2=Y;
						dy=0;
						stay=true;
					}
				} else {
					Y+=(dy+osndy)/div;
					Y1=Y-scY, Y2=Y;
				}
				if (mater) {
					for (i=Math.floor(X1/Tile.tileX); i<=Math.floor(X2/Tile.tileX); i++) {
						t=loc.space[i][Math.floor(Y1/Tile.tileY)];
						if (collisionTile(t)) {
							if (t_throw>0 && dy<-damWallSpeed && damWall) damageWall(4);
							if (destroy>0) destroyWall(t,4);
							Y=t.phY2+scY;
							Y1=Y-scY, Y2=Y;
							dy=0;
							turnY=1;
							if (t.mat==1) tykMat=1;
							stay=false;
						}
					}
				}
			} 
			if (autoSit) {
				autoSit=false;	
				unsit();
			}
		}
		
		public function run2(div:int=1) {
			X+=dx/div;
			Y+=dy/div;
			if (X-scX/2<0) {
				X=scX/2;
				dx=Math.abs(dx)*elast;
				turnX=1;
			}
			if (X+scX/2>=loc.limX) {
				X=loc.limX-1-scX/2;
				dx=-Math.abs(dx)*elast;
				turnX=-1;
			}
			if (Y-scY<0) {
				Y=scY-0.1;
				dy=0;
				turnY=1;
			}
			if (Y>loc.limY) {
				Y=loc.limY-1;
				dy=0;
				turnY=-1;
			}
			X1=X-scX/2, X2=X+scX/2;
			Y1=Y-scY, Y2=Y;
		}
		
		public function sit(turn:Boolean) {
			if (isSit==turn) return;
			isSit=turn;
			if (isSit) {
				scX=sitX, scY=sitY;
			} else {
				scX=stayX, scY=stayY;
			}
			X1=X-scX/2, X2=X+scX/2,	Y1=Y-scY;
		}
		
		public function unsit() {
			sit(false);
			if (collisionAll()) {
				sit(true);
			}
		}
		
		public function collisionAll(gx:Number=0, gy:Number=0):Boolean {
			if (loc.sky) return false;
			for (var i=Math.floor((X1+gx)/Tile.tileX); i<=Math.floor((X2+gx)/Tile.tileX); i++) {
				for (var j=Math.floor((Y1+gy)/Tile.tileY); j<=Math.floor((Y2+gy)/Tile.tileY); j++) {
					if (i<0 || i>=loc.spaceX || j<0 || j>=loc.spaceY) continue;
					if (collisionTile(loc.space[i][j],gx,gy)) return true;
				}
			}
			return false;
		}
		
		public function collisionTile(t:Tile, gx:Number=0, gy:Number=0):int {
			if (!t || (t.phis==0 || transT&&t.phis==3) && !t.shelf) return 0;  //пусто
			if (X2+gx<=t.phX1 || X1+gx>=t.phX2 || Y2+gy<=t.phY1 || Y1+gy>=t.phY2) {
				return 0;
			} else if ((t.phis==0 || transT&&t.phis==3) && t.shelf && (Y2-(stay?porog:porog_jump)>t.phY1 || throu || t_throw>0 || levit || isFly || diagon!=0)) {  //полка 
			//} else if (t.phis==0 && t.shelf && (Y2>t.phY1 || throu || levit || isFly || diagon!=0)) {  //полка 
				return 0;
			}
			else return 1;
		}

		//поиск лестницы
		public function checkStairs(ny:int=-1, nx:int=0):Boolean {
			try {
				var i=Math.floor((X+nx)/Tile.tileX);
				var j=Math.floor((Y+ny)/Tile.tileY);
				if (j>=loc.spaceY) j=loc.spaceY-1;
				if (loc.space[i][j].phis>=1 && !(transT&&loc.space[i][j].phis==3)) {
					isLaz=0;
					return false;
				}
				if ((loc.space[i][j] as Tile).stair) {
					isLaz=storona=(loc.space[i][j] as Tile).stair;
					if (isLaz==-1) X=(loc.space[i][j] as Tile).phX1+scX/2;
					else X=(loc.space[i][j] as Tile).phX2-scX/2;
					X1=X-scX/2, X2=X+scX/2;
					stay=false;
					sit(false);
					return true;
				}
			} catch (err) {
			}
			isLaz=0;
			return false;
		}
		//поиск жидкости
		public function checkWater():Boolean {
			var pla=inWater;
			try {
				if ((loc.space[Math.floor(X/Tile.tileX)][Math.floor((Y-scY*0.75)/Tile.tileY)] as Tile).water>0) {
					isPlav=true;
					inWater=true;
					if (plav) {
						stay=false;
						sit(false);
					}
				} else {
					isPlav=false;
					if (scY<=Tile.tileY) {
						inWater=false;
					} else if ((loc.space[Math.floor(X/Tile.tileX)][Math.floor((Y-scY*0.25)/Tile.tileY)] as Tile).water>0) {
						inWater=true;
					} else inWater=false;
				}
			} catch (err) {
				isPlav=inWater=false;
			}
			if (pla!=inWater && (dy>8 || dy<-8 || plaKap)) {
				Emitter.emit('kap',loc,X,Y-scY*0.25+dy,{dy:-Math.abs(dy)*(Math.random()*0.3+0.3), kol:Math.floor(Math.abs(dy*massa*2)+1)});
				
			}
			if (pla!=inWater && dy>5) {
				if (massa>2) sound('fall_water0', 0, dy/10);
				else if (massa>0.4) sound('fall_water1', 0, dy/10);
				else if (massa>0.2) sound('fall_water2', 0, dy/10);
				else sound('fall_item_water', 0, dy/10);
			}
			if (pla!=inWater && dy<-5 && massa>0.4) sound('fall_water2', 0, -dy/10);
			//newPart('kap',0,X+(Math.random()-0.5)*scX,Y-scY*0.25,0,-Math.abs(dy)*(Math.random()*0.3+0.3),Math.min(30,Math.floor(Math.abs(dy*massa*3)-5)));
			if (inWater && !isPlav && (dx>3 || dx<-3)) Emitter.emit('kap',loc,X,Y-scY*0.25,{rx:scX});
			//newPart('kap',0,X+(Math.random()-0.5)*scX,Y-Tile.tileY,0,-Math.abs(dy)*(Math.random()*0.3+0.3));
			if (isPlav) {
				namok_t++;
				if (namok_t>=100) {
					namok_t=0;
					addEffect('namok');
				}
			} else if (namok_t>0) {
				namok_t--
			}
			return isPlav;
		}

		//поиск предмета, на котором можно стоять
		public function checkShelf(pdy:Number,pdy2:Number=0):Number {
			for (var i in loc.objs) {
				var b:Box=loc.objs[i] as Box;//
				if (!b.invis && b.shelf && !b.levit && !(X2<b.X1 || X1>b.X2) && Y2+pdy2<=b.Y1 && Y2+pdy+pdy2>b.Y1) {
					shX1=shX2=1;
					if (-(X1-b.X1)/scX<shX1) shX1=-(X1-b.X1)/scX;
					if ((X2-b.X2)/scX<shX2) shX2=(X2-b.X2)/scX;
					stayMat=b.mat;
					stayPhis=2;
					stayOsn=b;
					if (!b.stay) {
						b.dy+=dy*massa/(massa+b.massa);
						b.fixPlav=false;
					}
					return b.Y1;
				}
			}
			return 0;
		}
		
		//поиск ступенек
		public function checkDiagon(dy:Number, napr:int=0):Number {
			var ddy:Number, newmy:Number=0;
			var t:Tile=loc.getAbsTile(X,Y+dy);
			if (diagon==0) {
				if (t.diagon!=0 && (napr==0 || t.diagon==napr)) {
					ddy=t.getMaxY(X);
					if (ddy<Y+dy) {
						diagon=t.diagon;
						newmy=ddy;
					}
				} else {
					t=loc.getAbsTile(X,Y+40);
					if (t.diagon!=0 && (napr==0 || t.diagon==napr)) {
						ddy=t.getMaxY(X);
						if (ddy<Y+dy) {
							diagon=t.diagon;
							newmy=ddy;
						}
					}
				}
			} else {
				if (t.diagon!=0 && (napr==0 || t.diagon==napr)) {
					ddy=t.getMaxY(X);
					diagon=t.diagon;
					newmy=ddy;
				} else {
					t=loc.getAbsTile(X,Y-40);
					if (t.diagon!=0 && (napr==0 || t.diagon==napr)) {
						ddy=t.getMaxY(X);
						diagon=t.diagon;
						newmy=ddy;
					} else diagon=0;
				}
			}
			if (diagon!=0 && (napr==0 || t.diagon==napr)) {
				shX1=shX2=0;
				stayPhis=2;
				stayMat=t.mat;
			}
			return newmy;
		}
		
		//телепортация
		public function teleport(nx:Number,ny:Number,eff:int=0) {
			if (eff>0) Emitter.emit('tele',loc,X,Y-scY/2,{rx:scX, ry:scY, kol:30});
			setPos(nx,ny);
			if (currentWeapon) {
				setWeaponPos(currentWeapon.tip);
				currentWeapon.setNull();
			}
			isLaz=0;
			levit=0;
			if (eff>0) Emitter.emit('teleport',loc,X,Y-scY/2);
		}
		
		//оторвать от фиксированного места
		public function otryv() {
			fixed=false;
		}

//**************************************************************************************************************************
//
//				Визуальная часть
//
//**************************************************************************************************************************

		public static function initIcos() {
			arrIcos=new Array();
			for each(var xml in AllData.d.unit) {
				if (xml.@cat=='3') {
					var bmpd:BitmapData;
					var ok:Boolean=false;
					if (xml.vis.length() && xml.vis.@blit.length()) {
						/*var data:BitmapData=World.w.grafon.getSpriteList(xml.vis.@blit);
						if (data==null) continue;
						var sprX:int=xml.vis.@sprX;
						var sprY:int=(xml.vis.@sprY>0)?xml.vis.@sprY:sprX;
						var begSprX:int=(xml.vis.@icoX>0)?xml.vis.@icoX:0;
						var begSprY:int=(xml.vis.@icoY>0)?xml.vis.@icoY:0;
						var rect:Rectangle = new Rectangle(begSprX*sprX, begSprY*sprY, (begSprX+1)*sprX, (begSprY+1)*sprY);
						bmpd=new BitmapData(sprX,sprY);
						bmpd.copyPixels(data,rect,new Point(0,0));
						ok=true;*/
					} else if (xml.vis.length() && xml.vis.@vclass.length()) {
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
		}
		
		public static function initIco(nid:String) {
			if (arrIcos==null) arrIcos=new Array();
			if (arrIcos[nid]) return;
			var xml=AllData.d.unit.(@id==nid);
			if (xml.vis.length() && xml.vis.@blit.length()) {
				var bmpd:BitmapData;
				var data:BitmapData=World.w.grafon.getSpriteList(xml.vis.@blit);
				if (data==null) return;
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
		
		public function initBlit() {
			blitData=World.w.grafon.getSpriteList(blitId);
			blitRect = new Rectangle(0, 0, blitX, blitY);
			blitPoint = new Point(0,0);
			vis=new MovieClip();
			var osn=new Sprite();
			visData=new BitmapData(blitX,blitY,true,0);
			visBmp=new Bitmap(visData);
			vis.addChild(osn);
			osn.addChild(visBmp);
			if (blitDX>=0) visBmp.x=-blitDX;
			else visBmp.x=-blitX/2;
			if (blitDY>=0) visBmp.y=-blitDY;
			else visBmp.y=-blitY+10;
			animState='stay';
		}
		
		public function blit(blstate:int, blframe:int) {
			blitRect.x=blframe*blitX, blitRect.y=blstate*blitY;
			visData.copyPixels(blitData,blitRect,blitPoint);
		}
		
		public override function addVisual() {
			if (disabled) return;
			trigDis=!checkTrig();
			if (trigDis) return;
			super.addVisual();
			if (!player && !hpbar && vis) {
				hpbar=new hpBar();
				if (hero<=0) hpbar.goldstar.visible=false;
				if (invis) hpbar.visible=false;
				visDetails();
			}
			if (hpbar && loc && loc.active) World.w.grafon.visObjs[3].addChild(hpbar);
			if (cTransform && ctrans) vis.transform.colorTransform=cTransform;
			if (childObjs) {
				for (var i in childObjs) {
					if (childObjs[i]!=null && childObjs[i].vis) {
						childObjs[i].addVisual();
						//World.w.grafon.visObjs[.sloy].addChild(childObjs[i].vis);
					}
				}
			}
		}
		
		public override function remVisual() {
			super.remVisual();
			if (hpbar && hpbar.parent) hpbar.parent.removeChild(hpbar);
			if (childObjs) {
				for (var i in childObjs) {
					if (childObjs[i]) childObjs[i].remVisual();
					//if (childObjs[i].vis && childObjs[i].vis.parent) World.w.grafon.visObjs[childObjs[i].sloy].removeChild(childObjs[i].vis);
				}
			}
		}
		
		public function animate() {
		}
		
		protected function sndFall() {
		}
		
		function sndRunPlay() {
				if (rasst2<sndRunDist*sndRunDist) {
					sndVolkoef=(sndRunDist-Math.sqrt(rasst2))/sndRunDist;
					if (sndVolkoef<0.5) sndVolkoef*=2;
					else sndVolkoef=1;
					Snd.pshum(sndRun,sndVolkoef);
				}
		}
		
		function newPart(nid:String,kol:int=1,frame:int=0) {
			Emitter.emit(nid,loc,X,Y-scY/2,{kol:kol, frame:frame});
		}

		public function setVisPos() {
			if (vis) {
				vis.x=X,vis.y=Y;
				vis.scaleX=storona;
			}
		}

		public function visDetails() {
			if (hpbar==null) return;
			if ((hp<maxhp || armor_qual>0 && armor_hp<armor_maxhp || hero>0) && hp>0 && !invis || boss) {
				if (boss) {
					World.w.gui.hpBarBoss(hp/maxhp);
					hpbar.visible=false;
				} else {
					hpbar.visible=true;
					if (hp<maxhp) {
						hpbar.bar.visible=true;
						hpbar.bar.gotoAndStop(Math.floor((1-hp/maxhp)*20+1));
					} else hpbar.bar.visible=false;
					if (armor_qual>0) {
						hpbar.armor.visible=true;
						hpbar.armor.gotoAndStop(Math.floor((1-armor_hp/armor_maxhp)*20+1));
					} else hpbar.armor.visible=false;
				}
				//hpbar.hpNum.text=Math.round(hp)+'/'+maxhp;
			} else hpbar.visible=false;
		}
		
		public function setHpbarPos() {
			if (boss) {
				hpbar.y=60;
				hpbar.x=World.w.cam.screenX/2;
			} else {
				hpbar.y=Y-stayY-20;
				if (hpbar.y<20) hpbar.y=20;
				hpbar.x=X;
				if (loc && loc.zoom!=1) hpbar.scaleX=hpbar.scaleY=loc.zoom;
			}
		}
		
		
		public function sound(sid:String, msec:Number=0, vol:Number=1):SoundChannel {
			return Snd.ps(sid,X,Y,msec,vol);
		}

//**************************************************************************************************************************
//
//				Действия
//
//**************************************************************************************************************************

		public function actions() {
			if (isNaN(dx)) {
				trace(nazv, 'dx!!!');
				dx=0;
			}
			if (isNaN(dy)) {
				trace(nazv, 'dy!!!');
				dy=0;
			}
			if (neujaz>0) neujaz--;
			if (shok>0) shok--;
			if (oduplenie>0) {
				if (opt && opt.izvrat && World.w.pers.socks || noAgro) {}
				else oduplenie--;
			}
			if (noise>0) noise-=20;
			if (noise_t>0) noise_t--;
			//шум при ходьбе
			if (stay && (dx>12|| dx<-12))  makeNoise(noiseRun);
			else if (stay && (dx>7 || dx<-7))  makeNoise(noiseRun/2);
			else if (stay && (dx>3 || dx<-3))  makeNoise(noiseRun/4);
			if (isFly && (dx>3 || dx<-3 || dy>3 || dy<-3))  makeNoise(noiseRun/2);
			
			//положение глаз
			eyeX=X+scX*0.25*storona;
			eyeY=Y-scY*0.75;
			
			//левитация
			if (sost==1) {
				if (levit) {
					levit_r++;
				} else {
					if (levit_r==1) levitPoss=true;
					if (levit_r>60) levit_r=60;
					if (levit_r>0) levit_r--;
				}
			}
			if (levit) {
				if (!fixed && massa!=massaMove) otryv();
				if (fixed) {
					if (levit_r>75) otryv();
				}
				massa=massaMove;
			}
			
			if (demask>0) demask-=5;
			if (effects.length>0) {
				for (var i=0; i<effects.length; i++) {
					if (!(effects[i] as Effect).vse) (effects[i] as Effect).step();
					else {
						effects.splice(i,1);
						i--;
					}
				}
			}
						//урон от воды
			//периодические эффекты
			if (cut>0 || poison>0 || inWater && loc.wdam>0) {
				if (t_hp<=0) {
					t_hp=30;
					if (cut>0) {
						damage(Math.sqrt(cut),D_BLEED,null,true);
						cut-=critHeal;
						if (cut<0) cut=0;
					}
					if (poison>0) {
						damage(Math.sqrt(poison),D_POISON,null,true);
						poison-=critHeal;
						if (poison<0) poison=0;
						Emitter.emit('poison',loc,X,Y-scY*0.5);
					}
					if (inWater && loc.wdam>0) {
						//trace('wdam',loc.wdam,loc.wtipdam,vulner[loc.wtipdam]);
						damage(loc.wdam,loc.wtipdam,null,true);
					}
				}
			}
			if (stun>0) {
				stun--;
				if (stun%10==0) {
					//trace(stun)
					if (opt && opt.robot) {
						Emitter.emit('discharge',loc,X,Y-scY*0.5);
						Emitter.emit('iskr',loc,X,Y-scY*0.5,{kol:5});
					} else if (!mech) Emitter.emit('stun',loc,X,Y-scY*0.75);
				}
			}
			if (t_hp>0) t_hp--;
			if (slow>0) {
				slow--;
				if (!fixed && slow%10==0 && vis && vis.visible && (dx>3 || dx<-3 || dy>5 || dy<-5)) Emitter.emit('slow',loc,X,Y-scY*0.25);
			}
			if (t_throw>0) t_throw--;
			//сборный показ цифр урона
			if (World.w.showHit==2) {
				if (t_hitPart>0) {
					t_hitPart--;
				} else {
					hitSumm=0;
					hitPart=null;
				}
			}
			if (t_mess>0) t_mess--;
		}
		
		public function makeNoise(n:int, hlup:Boolean=false) {
			if (n<=0) return;
			if (noise<n) noise=n;
			if (noise_t==0 || hlup && noise_t<=20) {
				noise_t=30;
				if (loc && loc.active && !getTileVisi()) {
					if (!player) Emitter.emit('noise',loc,X,Y,{rx:40, ry:40, alpha:Math.min(1,n/500)});
				}
			}
		}
		
		
//--------------------------------------------------------------------------------------------------------------------
//				Атака

		//Атка цели корпусом с использованием собственного урона юнита
		public function attKorp(cel:Unit, mult:Number=1):Boolean {
			if (sost>1 || cel==null || cel.loc!=loc || burn!=null) return false;
			if (cel.X1>X2 || cel.X2<X1 || cel.Y1>Y2 || cel.Y2<Y1 || cel.neujaz>0) return false;
			return cel.udarUnit(this, mult);
		}
		//удар достиг цели
		public function crash(b:Bullet) {
			if (b.weap) makeNoise(b.weap.noise, true);
		}
		//задать положение оружия
		public function setWeaponPos(tip:int=0) {
			weaponX=X;
			weaponY=Y-scY*0.5;
			magicX=X;
			magicY=Y-scY*0.5;
		}
		public function setPunchWeaponPos(w:WPunch) {
			w.X=X+scX/3*storona;
			w.Y=Y-scY*0.75;
			w.rot=(storona>0)?0:Math.PI;
		}
		
		public function destroyWall(t:Tile, napr:int=0):Boolean {
			if (isPlav || levit || sost!=1) return false;
			if (napr==3 && dy>15 && destroy<50 && massa>=1) {
				loc.hitTile(t,50,(t.X+0.5)*Tile.tileX,(t.Y+0.5)*Tile.tileY,100);
				if (t.phis==0) return true;
			}
			if (destroy>0 && (dx>10 && napr==2 || dx<-10 && napr==1 || dy<-10 && napr==4  || dy>10 && napr==3)) loc.hitTile(t,destroy,(t.X+0.5)*Tile.tileX,(t.Y+0.5)*Tile.tileY,(napr==3?100:9));
			if (t.phis==0) return true;
			return false;
		}
		
		public function explosion(tdam:Number, ttipdam:int=4, trad:Number=200, tkol:int=0, totbros:Number=0, tdestroy:Number=0, tdecal:int=0) {
			var bul:Bullet=new Bullet(this,X,Y-3,null,tkol>1);
			bul.weapId=id;
			bul.damageExpl=tdam;
			bul.tipDamage=ttipdam;
			bul.explKol=tkol;
			if (tkol>1) bul.explTip=2;
			else if (ttipdam==10) bul.explTip=3;
			bul.explRadius=trad;
			bul.tipDecal=tdecal;
			bul.otbros=totbros;
			bul.destroy=tdestroy;
			bul.explosion();
			bul.babah=true;
		}
		
		
//--------------------------------------------------------------------------------------------------------------------
//				Эффекты

		//Добавить эффект
		public function addEffect(id:String, val:Number=0, t:int=0, se:Boolean=true):Effect {
			if (id==null || id=='') return null;
			var eff:Effect = new Effect(id, this, val);
			if (t>0) eff.t=t*World.fps;
			//получение временного эффекта
			for (var i in effects) {
				if (eff.tip==3 && effects[i].tip==3) {
					effects[i]=eff;
					eff.setEff();
					return eff;
				}
				if (effects[i].id==id || effects[i].id==eff.post) {
					if (effects[i].val>eff.val) eff.val=effects[i].val;
					if (eff.add) {
						eff.t+=effects[i].t;
						if (eff.t>30000) eff.t=30000;
						eff.checkT();
					}
					effects[i]=eff;
					eff.setEff();
					return eff;
				}
			}
			eff.se=se;
			effects.push(eff);
			if (player && se) World.w.gui.infoEffText(id);
			eff.setEff();
			return eff;
		}
		
		public function remEffect(id:String) {
			for each(var eff in effects) {
				if (eff!=null && eff.id==id) eff.unsetEff();
			}
		}
		
		function setSkillParam(xml:XML, lvl1:int, lvl2:int=0) {
			if (xml==null) return;
			for each(var sk in xml.sk) {
				var val:Number, lvl:int;
				if (sk.@dop.length()) lvl=lvl2;
				else lvl=lvl1;
				if (sk.@vd.length()) val=Number(sk.@v0)+lvl*Number(sk.@vd);
				else if (sk.attribute('v'+lvl).length()) val=Number(sk.attribute('v'+lvl));
				else val=Number(sk.@v0);
				if (sk.@tip=='res') vulner[sk.@id]-=val;
				else if (hasOwnProperty(sk.@id)) {
					if (sk.@ref=='add') this[sk.@id]+=val;
					else if (sk.@ref=='mult') this[sk.@id]*=val;
					else this[sk.@id]=val;
				}
			}
			
		}
		public function setEffParams() {
				try {
			tormoz=1;
			precMultCont=1;			
			rapidMultCont=1;
			if (begvulner==null) return;
			for (var i=0; i<kolVulners; i++) vulner[i]=begvulner[i];
			if (!player && loc.biom==5) {
				vulner[D_PINK]=0;	//неуязв. к розовому облаку
			}
			for each(var eff:Effect in effects) {
				var effid=eff.id;
				var sk=AllData.d.eff.(@id==effid)[0];
				setSkillParam(sk, eff.vse?0:1);
			}
			setHeroVulners();
				} catch (err) {trace('ошибка эффектов',nazv)}
		}
		
//--------------------------------------------------------------------------------------------------------------------
//				Получение урона
		
		/*D_BUL=0,		//пули		+
		D_BLADE=1,		//лезвие	+
		D_PHIS=2,		//дробящий	+
		D_FIRE=3,		//огонь		*
		D_EXPL=4,		//взрыв		+
		D_LASER=5,		//лазер		*
		D_PLASMA=6,		//плазма	*
		D_VENOM=7,		//отравляющие вещества
		D_EMP=8,		//ЭМП
		D_SPARK=9,		//молния	*
		D_ACID=10,		//кислота	*
		D_CRIO=11,		//холод		*
		D_POISON=12,	//отравление
		D_BLEED=13,		//кровотечение
		D_FANG=14,		//звери		+
		D_BALE=15,		//пиздец
		D_NECRO=16,		//некромантия
		D_PSY=17,		//пси
		D_ASTRO=18,		//звиздец
		D_INSIDE=100;	//???*/


		//получить урон
		public function damage(dam:Number, tip:int, bul:Bullet=null, tt:Boolean=false):Number {
			if (invulner) return 0;
			if (sost==1) dieWeap=null;
			if (tip<kolVulners) dam*=vulner[tip];			//уязвимости
			//var damageNumb:Part;
			var isCrit:int=0;
			var isShow:Boolean=false;
			if (bul) {					//критический урон
				/*if (Math.random()<bul.critCh) {
					dam*=bul.critDamMult;
					isCrit=1;
				}
				if (!doop && celUnit!=bul.owner && bul.critInvis>0) {
					if (Math.random()<bul.critInvis) {
						dam*=2;
						isCrit+=2;
					}
				}*/
				//урон определённым типам
				if (bul.owner && bul.owner.player && opt) {
					if (opt.pony) dam*=(bul.owner as UnitPlayer).pers.damPony;
					if (opt.zombie) dam*=(bul.owner as UnitPlayer).pers.damZombie;
					if (opt.robot) dam*=(bul.owner as UnitPlayer).pers.damRobot;
					if (opt.insect) dam*=(bul.owner as UnitPlayer).pers.damInsect;
					if (opt.monster) dam*=(bul.owner as UnitPlayer).pers.damMonster;
					if (opt.alicorn) dam*=(bul.owner as UnitPlayer).pers.damAlicorn;
				}
				
			}
			if (dam==0) return 0;
			//уменьшение электрического урона
			if (tip==D_SPARK) {
				if (!stay && !inWater && isLaz==0) dam*=0.5;
			}
			//урон ядом наносится только живым
			if (tip==D_VENOM && sost!=1) {
				return 0;
			}
			var mess:String;
			//урон броне
			if (!player && armor_hp>0 && (shithp<=0 || dam>shitArmor) && (armor>0 || marmor>0) && (tip<=D_BALE && tip!=D_EMP && tip!=D_POISON && tip!=D_BLEED || tip==D_ASTRO)) {
				var damarm=dam;
				if (shithp>0) damarm-=shitArmor;
				//if (bul && bul.pier>0) damarm+=bul.pier;
				if (bul && bul.armorMult>1) damarm/=bul.armorMult;
				if (tip==D_ACID) damarm*=4;
				else if (tip==D_EXPL) damarm*=2;
				armor_hp-=damarm;
				if (armor_hp<=0) {	//разрушение брони
					armor_hp=0;
					armor_qual=0;
					mess=Res.guiText('abr');
				}
			}
			/*if (!player && tip==D_ACID && acidDey>0 && armor>0 && armor_qual>0.25) {
				armor_qual-=dam/maxhp*acidDey;
				if (armor_qual<0.25) armor_qual=0.25;
				if (dam/maxhp>0.01) numbEmit.cast(loc,X,Y-scY/2,{txt:('-'+Math.round(dam/maxhp*100).toString()+'%'), frame:5, rx:20, ry:20});
			}*/
			if (dam<0) {
				heal(-dam);
				return 0;
			}
			var armor2=0;		//броня и бронебойность
			if (!tt) {
				if (tip==D_BUL || tip==D_BLADE || tip==D_EXPL || tip==D_PHIS || tip==D_FANG || tip==D_ACID) {
					armor2=skin;
					if (armor_qual>0 && isrnd(armor_qual)) armor2+=armor;
				}
				if (tip==D_FIRE || tip==D_LASER || tip==D_PLASMA || tip==D_SPARK || tip==D_CRIO || tip==D_ASTRO) {
					armor2=skin;
					if (armor_qual>0 && isrnd(armor_qual)) armor2+=marmor;
				}
				if (shithp>0) {
					shithp-=dam;
					if (shithp<0) shithp=0;
					armor2+=shitArmor;
				}
				if (bul) {
					armor2*=bul.armorMult;
					armor2-=bul.pier;
				}
				if (armor2>0) {
					dam-=armor2;
					if (bul && bul.probiv>0) {	//если пуля пробивная, вычесть из урона величину брони
						bul.damage-=armor2/bul.probiv;
					}
				}
			}
			if (bul) {					//критический урон
				if (Math.random()<bul.critCh) {
					dam*=bul.critDamMult;
					isCrit=1;
				}
				if (!doop && celUnit!=bul.owner && bul.critInvis>0) {
					if (Math.random()<bul.critInvis) {
						dam*=2;
						isCrit+=2;
					}
				}
			}
			if (dam>0) {
				var sposob:int=0;		//способ сдохнуть
				if (bul && bul.desintegr && (tip==D_LASER || tip==D_PLASMA)) {	//мгновенная дезинтеграция
					if (hp<=dam*10 && isrnd(bul.desintegr)) {
						sposob=1;
						dam*=12;
					}
				}
				if (tip!=D_POISON && tip!=D_BLEED && tip!=D_INSIDE) dam*=allVulnerMult;
				isShow=((sost==1 || sost==2) && showNumbs && dam>0.5);
				if (bul && bul.probiv>0) {
					if (maxhp>dam*20) bul.damage=0;
					else if (maxhp>dam) bul.damage*=bul.probiv;
					else bul.damage*=1-(1-bul.probiv)*maxhp/dam;
				}
				hp-=dam;
				var nshok=Math.round((Math.random()*0.8+0.2)*maxShok*4*dam/maxhp);
				if (nshok>maxShok) nshok=maxShok;
				if (tt || nshok<5) nshok=0;
				if (shok<nshok) shok=nshok;
				if (hp<=0) {
					if (bul && bul.weap) dieWeap=bul.weap.id;
					if (bul && bul.weapId) dieWeap=bul.weapId;
					if (tip==D_FIRE && (hp<=-maxhp*3 || !trup)) sposob=1;
					if (tip==D_LASER && (hp<=-maxhp*3 || !trup || isrnd())) sposob=1;
					if (tip==D_PLASMA || tip==D_ACID) sposob=2;
					if (tip==D_ASTRO || tip==D_FRIEND) sposob=3;
					if (tip==D_CRIO) sposob=4;
					if (timerDie<=0) die(sposob);
					else sost=2;
				}
				//электрический и эми урон оглушает роботов
				if ((tip==D_SPARK || tip==D_EMP) && opt && opt.robot && sost==1 && Math.random()<dam/maxhp) {
					mess=Res.guiText('kz');
					if (stun<robotKZ) stun=robotKZ;
				}
				//взрывы вызывают контузию
				if (tip==D_EXPL && opt && !opt.robot && !mech && !doop && sost==1 && Math.random()<dam/maxhp) {
					mess=Res.txt('e','contusion');
					addEffect('contusion');
				}
				if (!tt && demask<200) demask=200;	//При получении урона невидимый объект становится видимым
				//дополнительные эффекты
				if (bul && bul.weap) {								
					if (bul.weap.dopEffect!=null && bul.weap.dopCh>0 && (bul.weap.dopCh>=1 || Math.random()<bul.weap.dopCh)) {
						if (bul.weap.dopEffect=='igni' && vulner[D_FIRE]>0.1) {
							addEffect('burning',bul.weap.dopDamage);
							mess=Res.txt('e','burning');
						}
						if (bul.weap.dopEffect=='ice' && vulner[D_CRIO]>0.1 && !mech) {
							mess=Res.txt('e','freezing');
							addEffect('freezing');
						}
						if (bul.weap.dopEffect=='blind' && vulner[D_LASER]>0.1 && !mech && !doop) {
							mess=Res.txt('e','blindness');
							addEffect('blindness');
						}
						if (bul.weap.dopEffect=='acid' && vulner[D_ACID]>0.1) {
							mess=Res.txt('e','chemburn');
							addEffect('chemburn',bul.weap.dopDamage);
						}
						if (bul.weap.dopEffect=='pink' && vulner[D_PINK]>0.1) {
							mess=Res.txt('e','pinkcloud');
							addEffect('pinkcloud',bul.weap.dopDamage);
						}
						if (bul.weap.dopEffect=='poison' && vulner[D_POISON]>0.1) {
							if (player && poison<=0) World.w.gui.infoText('poison');
							poison+=bul.weap.dopDamage;
						}
						if (bul.weap.dopEffect=='cut' && vulner[D_BLEED]>0.1 && !mech) {
							if (player && cut<=0) World.w.gui.infoText('cut');
							cut+=bul.weap.dopDamage;
						}
						if (bul.weap.dopEffect=='stun') {
							if (!mech && opt && !opt.robot && Math.random()<dam/maxhp && sost==1) {
								stun=bul.weap.dopDamage;
								//trace(stun);
								if (player && stun<=0) World.w.gui.infoText('stun');
								if (stun>1) mess=Res.guiText('stun');
							}
						}
					}
					if (bul.weap.ammoFire) {
						addEffect('burning',bul.weap.ammoFire);
						mess=Res.txt('e','burning');
					}
				}
				//возврат урона хозяину пули
				if (bul && bul.owner && bul.owner.relat>0) {
					bul.owner.damage(dam*bul.owner.relat, D_INSIDE);
				}
				if (tip==D_INSIDE && dam<5) isShow=false;
				if (blood>0 && (tip==D_BUL || tip==D_BLADE || tip==D_PHIS || tip==D_BLEED || tip==D_FANG)) {	//кровь
					if (bloodEmit==null) {
						if (blood==1) bloodEmit=Emitter.arr['blood'];
						if (blood==2) bloodEmit=Emitter.arr['gblood'];
						if (blood==3) bloodEmit=Emitter.arr['pblood'];
					}
					if (!(player && World.w.alicorn)) {
						if (bul) {
							bloodEmit.cast(loc,bul.X,bul.Y,{dx:bul.dx/bul.vel*5, dy:bul.dy/bul.vel*5,kol:Math.floor(Math.random()*5+dam/5)});
						} else {
							bloodEmit.cast(loc,X,Y-scY/2,{kol:Math.floor(dam/3)});
						}
						if (blood==1 && tip!=D_BLEED && massa>0.2) {
							var ver=Math.random();
							if (tip==D_BLADE) ver=ver*ver;
							if (isCrit>0) ver*=0.3;
							if (dam/1000>ver) {
								var st:int=1;
								if (bul && bul.dx<0) st=-1;
								if (bul==null && Math.random()<0.5) st=-1;
								Emitter.emit('bloodexpl'+Math.floor(Math.random()*3+1),loc,X+80*st+(Math.random()-0.5)*scX*0.5,Y-Math.random()*scY*0.5-40,{mirr:(st<0?1:0)});
							}
						}
					}
				}
				if (mat==10 && bul) {
					Emitter.emit('pole2',loc,bul.X,bul.Y);
				}
				if (isShow) {//Показывать урон
					var vnumb:int=1;
					var castX:Number=X;
					var castY:Number=Y-scY/2;
					if (bul) {castX=bul.X; castY=bul.Y;}
					if (player || isCrit>=2) vnumb=2;
					if (tt) vnumb=3;
					if (player && tt && tip==D_PINK) vnumb=11;
					if (World.w.showHit==1 || tt) {
						visDamDY-=15;
						numbEmit.cast(loc,castX,castY+visDamDY,{txt:Math.round(dam).toString(), frame:vnumb, rx:40, scale:((isCrit==1 || isCrit==3)?1.6:1)});
					} else if (World.w.showHit==2) {
						hitSumm+=dam;
						if (hitPart==null) {
							hitPart=numbEmit.cast(loc,castX,castY+visDamDY,{txt:Math.round(dam).toString(), frame:vnumb, rx:40, scale:((isCrit==1 || isCrit==3)?1.6:1)});
						} else {
							if (isCrit==1 || isCrit==3) {
								hitPart.vis.scaleX=hitPart.vis.scaleY=1.6/World.w.cam.scaleV;;
							}
							hitPart.vis.numb.text=Math.round(hitSumm);
							hitPart.liv=60;
						}
						t_hitPart=10;
					}
				}
				if (hp>0 && !player && isrnd()) replic('dam');
			} else if (World.w.showHit==2) t_hitPart=10
			visDetails();
			if (World.w.showHit>=1 && t_mess<=0) {
				if (hp>0 && mess) {
					numbEmit.cast(loc,X,Y-scY/2,{txt:mess, frame:5, rx:20, ry:20});
					t_mess=45;
				}
			}
			if (!tt) alarma();
			return dam;
		}
		
		//удар ап стену 1-справа, 2-слева, 3-снизу, 4-сверху
		public function damageWall(napr:int=0) {
			t_throw=0;
			if (damWall>0) {
				var dam=Math.sqrt(dx*dx+dy*dy)/damWallSpeed*damWall;
				damage(dam,D_PHIS);
				if (Math.random()<dam/maxhp) stun=damWallStun;
				if (napr>0) {
					var nx:Number=X, ny:Number=Y-scY/2;
					if (napr==1) nx=X+scX/2;
					if (napr==2) nx=X-scX/2;
					if (napr==3) ny=Y;
					if (napr==4) ny=Y-scY;
					Emitter.emit('bum',loc,nx,ny);//,{scale:dam/damWall}
					Snd.ps('hit_flesh',X,Y);
				}
			}
		}
		
		public function heal(hl:Number, tip:int=0, ismess:Boolean=true) {
			if (hp==maxhp) return;
			if (hl>maxhp-hp) {
				hl=maxhp-hp;
				hp=maxhp;
			} else {
				hp+=hl;
			}
			visDetails();
			if (World.w.showHit>=1) {
				if ((sost==1 || sost==2) && showNumbs && hl>0.5) numbEmit.cast(loc,X,Y-scY/2,{txt:('+'+Math.round(hl)), frame:4, rx:20, ry:20});
			}
			//newPart('numb',4,X+Math.random()*20-10,Y-scY/2+Math.random()*20-10,0,0,1,'+'+Math.round(hl));
		}
		
		public function dopTest(bul:Bullet):Boolean {
			return true;
			/*ppp.x=nx-vis.x;
			ppp.y=ny-vis.y;
			ppp=vis.localToGlobal(ppp);
			if (!vis.hitTestPoint(ppp.x,ppp.y,true)) return false;
			Emitter.emit('marker',loc,nx,ny);
			return true;*/
		}
		
		//проверка на попадание пули, наносится урон, если пуля попала, возвращает -1 если не попала
		public override function udarBullet(bul:Bullet, sposob:int=0):int {
			var acc:Number=bul.accuracy();
			if ((bul.miss<=0 || Math.random()>bul.miss) && (
				dexter<=0 ||
				bul.precision<=0 && bul.tipBullet==0 || 
				bul.tipBullet==0 && Math.random()<acc/(dexter+dexterPlus+0.05) || 
				bul.tipBullet==1 && dodge<1 && (dodge<=0 || Math.random()>dodge)
			)) {
				//trace('попал',bul.precision/bul.dist);
				var dm=0;
				if (transp && (vulner[bul.tipDamage]<=0 || invulner)) {
					return -1;
				} else if (bul.damage>0) {
					if (retDamage && bul.retDam && bul.owner) {//возврат урона
						bul.owner.udarUnit(this);
					}
					dm=bul.damage*(Math.random()*0.6+0.7);
					if (World.w.testDam) dm=bul.damage;
					/*if (acc>1 && bul.critM>0) {		//если меткость>1 и у оружия есть дополнительный модификатор крита, то увеличить урон
						dm+=dm*bul.critM*(1-1/acc);
					}*/
					dm=damage(dm, bul.tipDamage, bul);
					otbros(bul);
					if (bul.owner && bul.owner.fraction!=0) priorUnit=bul.owner;
					if (!invulner && dm<=0 || mat==1) return 1;
					else if (mat==12) return 12;
					else return 10;
				} else return 0;
			} else {
				if (World.w.showHit==1 || World.w.showHit==2 && t_hitPart==0) {
					visDamDY-=15;
					t_hitPart=10;
					if (sost<3 && isVis && !invulner && bul.flame==0) numbEmit.cast(loc,X,Y-scY/2+visDamDY,{txt:txtMiss, frame:10, rx:40, alpha:0.5});
				}
				return -1;
			}
		}
		//удар юнита юнитом
		public function udarUnit(un:Unit, mult:Number=1):Boolean {
			if (neujaz>0) return false;
			neujaz=neujazMax;
			if (dodge-un.undodge>0 && isrnd(dodge-un.undodge)) {
				if (World.w.showHit>=1)	numbEmit.cast(loc,X,Y-scY/2,{txt:txtMiss, frame:10, rx:20, ry:20, alpha:0.5});
				return false;
			}
			var sila=Math.random()*0.4+0.8;
			if (un.collisionTip==1) {
				var ndx=(un.dx*un.massa+dx*massa)/(un.massa+massa);
				var ndy=(un.dy*un.massa+dy*massa)/(un.massa+massa);
				dx=(-dx+ndx)*knocked+ndx, dy=(-dy+ndy)*knocked+ndy;
				un.dx=(-un.dx+ndx)*un.knocked+ndx, un.dy=(-un.dy+ndy)*un.knocked+ndy;
			}
			if (un.currentWeapon && un.currentWeapon.tip==1) {
				damage((un.currentWeapon.damage*0.5+un.dam)*sila*mult, un.currentWeapon.tipDamage)
			} else {
				damage((un.dam)*sila*mult, un.tipDamage);
			}
			var sc:Number=(un.dam*sila*mult)/20;
			if (sc<0.5) sc=0.5;
			if (sc>3) sc=3;
			if (un.tipDamage == Unit.D_SPARK) {
				Emitter.emit('moln',loc,X,Y-scY/2,{celx:un.X, cely:(un.Y-un.scY/2)});
				Snd.ps('electro',X,Y);
			} else if (un.tipDamage == Unit.D_ACID) {
				Emitter.emit('buma',loc,(X+un.X)/2,(Y-scY/2+un.Y-un.scY/2)/2,{scale:sc});
				Snd.ps('acid',X,Y);
			} else if (un.tipDamage == Unit.D_NECRO) {
				Emitter.emit('bumn',loc,(X+un.X)/2,(Y-scY/2+un.Y-un.scY/2)/2,{scale:sc});
				Snd.ps('hit_necr',X,Y);
			} else if (un.tipDamage == Unit.D_FANG) {
				Emitter.emit('bum',loc,(X+un.X)/2,(Y-scY/2+un.Y-un.scY/2)/2,{scale:sc});
				Snd.ps('fang_hit',X,Y);
			} else {
				Emitter.emit('bum',loc,(X+un.X)/2,(Y-scY/2+un.Y-un.scY/2)/2,{scale:sc});
				Snd.ps('hit_flesh',X,Y);
			}
			priorUnit=un;
			return true;
		}
		//удар падающим предметом
		public function udarBox(un:Box):int {
			if (neujaz>0 || noBox || un.loc!=loc) return 0;
			if (un.molnDam>0) {
				damage(un.molnDam, D_SPARK);
				return 1;
			}
			neujaz=neujazMax;
			if (!fixed) {
				var ndx=(un.dx*un.massa+dx*massa)/(un.massa+massa);
				var ndy=(un.dy*un.massa+dy*massa)/(un.massa+massa);
				dx=(-dx+ndx)*knocked+ndx, dy=(-dy+ndy)*knocked+ndy;
				un.dx=(-un.dx+ndx)*0.25+ndx, un.dy=(-un.dy+ndy)*0.25+ndy;
			} else {
				un.dx*=0.5;
				un.dy*=0.5;
			}
			damage(un.massa*(un.vel2-50)*World.boxDamage, D_PHIS);
			priorUnit=null;
			return 2;
		}
		//эффект отбрасывания пулей
		public function otbros(bul:Bullet) {
			if (invulner) return;
			var sila=Math.random()*0.4+0.8;
			sila*=knocked/massa;
			if (sila>3) sila=3;
			dx+=bul.knockx*bul.otbros*sila;
			dy+=bul.knocky*bul.otbros*sila;
			if (bul.explRadius>0) {
				//trace(bul.dx/bul.vel*bul.otbros/massa*sila,bul.dy/bul.vel*bul.otbros/massa*sila)
			}
		}
		
		//активация из пассивного режима
		public function alarma(nx:Number=-1,ny:Number=-1) {
			oduplenie=0;
			if (nx>0 && ny>0 && celUnit==null) {
				setCel(null,nx,ny);
			}
		}
		//пробуждение всех вокруг
		public function budilo(rad:Number=500) {
			makeNoise(noiseRun*1.2);
			//trace('budilo');
			for each(var un:Unit in loc.units) {
				if (un && un!=this && un.fraction==fraction && un.sost==1 && !un.unres) {
					var nx=un.X-X;
					var ny=un.Y-Y;
					if (opt && opt.robot && un.opt && un.opt.robot) {
						if (nx*nx+ny*ny<rad*rad) un.alarma(celX,celY);
					} else {
						//trace(un.ear);
						if (nx*nx+ny*ny<rad*rad*un.ear*un.ear) un.alarma(X+(Math.random()-0.5)*250,Y+(Math.random()-0.5)*250);
					}
				}
			}
		}
		//отключение (для систем безопасности)
		public function hack(sposob:int=0) {
		}
		
		
//--------------------------------------------------------------------------------------------------------------------
//				Смерть
		
		public override function die(sposob:int=0) {
			if (hpbar) hpbar.visible=false;
			if (boss) {
				World.w.gui.hpBarBoss();
				if (sndMusic) Snd.combatMusic(sndMusic, sndMusicPrior, 90);
			}
			if (sposob==0 && sost==1 && sndDie) sound(sndDie);
			if (noDestr) {			//не убирать после убийства
				sost=3;
			} else if (sposob>0) {	//убит экзотическим способом
				isFly=false;
				initBurn(sposob);
				dexter=100;
				fraction=0;
				throu=false;
				sost=3;
			} else if (trup && hp>-maxhp*2) {	//оставлять труп и он не уничтожен
				replic('die');
				isFly=false;
				scX=sitX, scY=sitY;
				X1=X-scX/2, X2=X+scX/2,	Y1=Y-scY;
				fraction=0;
				throu=false;
				porog=0;
				sost=3;
			} else if (trup && blood>0) {		//есть кровь
				if (burn==null) sound('trup');
				initBurn(4+blood);
				isFly=false;
				fraction=0;
				throu=false;
				porog=0;
				sost=3;
			} else if (burn==null) {			//уничтожить
				if (trup && blood>0) sound('trup');
				expl();
				exterminate();
			}
			shithp=0;
			walk=0;
			elast=0;
			isLaz=0;
			stun=0;
			transT=true;
			sndRunOn=false;
			plaKap=false;
			if (!doop && World.w.t_battle>30) World.w.t_battle=30;
			if (!lootIsDrop && (!isRes || sost==4 || burn)) {
				lootIsDrop=true;
				if (mother) mother.kolChild--;
				if (hero>0) World.w.gui.infoText('killHero',nazv);
				runScript();
				dropLoot();
				incStat();
				if (xp>0) {
					loc.takeXP(xp,X,Y,true);
					xp=0;
				}
				if (loc.prob) loc.prob.check();
				if (opt && opt.hbonus) {
					loc.createHealBonus(X, Y-scY/2);
				}
			}
		}
		
		//уничтожить, убрать из мира
		public function exterminate() {
			radioactiv=0;
			levitPoss=false;
			if (sost!=4) loc.remObj(this);
			sost=4;
			disabled=true;
		}
		
		//взрыв, кишки или другой эффект после смерти
		public function expl()	{
			if (blood) {
				if (bloodEmit==null) {
					if (blood==1) bloodEmit=Emitter.arr['blood'];
					if (blood==2) bloodEmit=Emitter.arr['gblood'];
					if (blood==3) bloodEmit=Emitter.arr['pblood'];
				}
				bloodEmit.cast(loc,X,Y,{kol:massa*50, rx:scX/2, ry:scY/2});
			}
		}
		//вызывается в любом случае в момент любого способа смерти, только один раз!
		public function dropLoot() {
			if (inter) inter.loot();
			if (hero>0 && !(opt.robot==true) && isrnd(0.75)) LootGen.lootId(loc,X,Y-scY/2,'essence');
			//выпадение драгоценного камня
			if (World.w.pers && World.w.pers.dropTre>0 && xp>0) {
				if (Math.random()<World.w.pers.dropTre*xp/4000) LootGen.lootId(loc,X,Y-scY/2,'gem'+Math.floor(Math.random()*3+1));
			}
		}
		
		public function initBurn(sposob:int) {
			if (burn!=null) return;
			remVisual();
			burn=new Desintegr(this,sposob);
			childObjs=[];
			addVisual();
			
			levitPoss=false;
			
			setVisPos();
		}

		public function runScript() {
			if (scrDie) scrDie.start();
			if (questId)  {
				if (loc.land.itemScripts[questId]) loc.land.itemScripts[questId].start();
				World.w.game.incQuests(questId);
			}
			if (wave && loc.prob) loc.prob.checkWave(true);
			//действие типа уничтожить сколько-то врагов из определённого оружия
			if (dieWeap!=null && World.w.game.triggers['look_'+dieWeap]>0 && xp>0) {
				World.w.game.incQuests('kill_'+dieWeap);
			}
		}

		//изменить статистику
		public function incStat(sposob:int=0) {
			if (World.w.game) {
				if (World.w.game.triggers['frag_'+id]>0) World.w.game.triggers['frag_'+id]++;
				else World.w.game.triggers['frag_'+id]=1;
			}
		}
		
//--------------------------------------------------------------------------------------------------------------------
//				Служебные ф-и для ИИ

		//возможность взаимодействия с юнитом
		public function isMeet(un:Unit):Boolean {
			return un!=null && loc==un.loc && !un.disabled && !un.trigDis && un.sost!=4 && un!=this;
		}
		//не закрывает ли юнит туман войны, true если нет
		public function getTileVisi(r:Number=0.3):Boolean {
			return (loc.getAbsTile(X,Y-scY/2).visi>r);
		}
		
		//слушать другого юнита
		public function listen(ncel:Unit):Number {
			var noi=ncel.noise*ear*loc.earMult;	//радиус слышимости издаваемого звука
			if (noi<=0) return 0;
			var r2:Number;		//расстояние до объекта в квадрате
			if (ncel.player) r2=rasst2;
			else {
				var nx=ncel.X-X;
				var ny=ncel.Y-ncel.scY/2-Y+scY/2;
				r2=nx*nx+ny*ny;
			}
			if (noi*noi>r2) return (1-r2/(noi*noi))*4;
			return 0;
		}

		//взгляд на другого юнита
		//параметры: ncel - целевой юнит
		//over - смотреть вокруг себя на все стороны
		//visParam - параметр для определения дальности зрения, по умолчанию берётся vision
		//nDist - дистанция видимости объекта, по умолчанию вычисляется
		//возвращает значение, на которое увеличивается obs героя
		public function look(ncel:Unit, over:Boolean=true, visParam:Number=0, nDist:Number=0):Number {
			if (ncel==null || nDist<=0 && visParam<=0 && vision<=0) return 0;
			var cx=(ncel.X-eyeX);
			var cy=(ncel.Y-ncel.scY*0.6-eyeY);
			if (eyeX==-1000 || eyeY==-1000) {
				eyeX=X,eyeY=Y-30;
				//trace('Не задана точка зрения', nazv);
			}
			//дистанция видимости
			var distVis=nDist;		//взять из параметра
			if (nDist<=0) distVis=(ncel.visibility*ncel.stealthMult*loc.visMult+ncel.demask)*(visParam?visParam:vision);	//или вычислить
			//если нет зрения за спиной, и объект выше или ниже 45 градусов, уменьшить дистанцию
			if (vKonus==0 && !over && cy*cy>cx*cx && cy>0) {
				distVis*=(0.5+0.5*Math.abs(cx/cy));
			}
			//если расстояние больше дистанции видимости, вернуть 0
			var r2:Number=cx*cx+cy*cy;
			if (r2>distVis*distVis*16) return 0;
			//если нет зрения за спиной, и объект сзади, вернуть 0
			if (vKonus==0 && !over && cx*storona<0 && r2>detecting*detecting) return 0;
			//конус зрения
			if (vKonus>0) {
				var ug:Number=Math.atan2(cy,cx);
				var dug:Number=vAngle-ug;
				if (dug>Math.PI) dug-=Math.PI*2;
				if (dug<-Math.PI) dug+=Math.PI*2;
				if (Math.abs(dug)>vKonus/2) return 0;
			}
			
			//проверить линию взгляда
			var div=Math.floor(Math.max(Math.abs(cx),Math.abs(cy))/World.maxdelta)+1;
			for (var i=(mater?1:4); i<div; i++) {
				var nx=X+scX*0.25*storona+cx*i/div;
				var ny=Y-scY*0.75+cy*i/div;
				var t:Tile=World.w.loc.getTile(Math.floor(nx/Tile.tileX),Math.floor(ny/Tile.tileY));
				if (t.phis==1 && nx>=t.phX1 && nx<=t.phX2 && ny>=t.phY1 && ny<=t.phY2) {
					return 0;
				}
			}
			if (r2<ncel.detecting*ncel.detecting) return 20;
			if (r2<distVis*distVis) return 4;
			return (distVis*distVis)/r2*4;
		}
		//получить цель для ИИ
		public function findCel(over:Boolean=false):Boolean {
			if (oduplenie>0) return false;
			var ncel:Unit;
			if (priorUnit && isMeet(priorUnit) && priorUnit.fraction!=fraction && priorUnit.sost<3 && priorUnit.hp>-priorUnit.maxhp && (!priorUnit.doop || priorUnit.levit)) ncel=priorUnit;
			else if (isMeet(loc.gg) && !loc.gg.invulner && fraction!=F_PLAYER) ncel=loc.gg;
			else return false;
			if (ncel.player) {
				var res1:Number=listen(ncel);
				if (res1) {
					(ncel as UnitPlayer).observation(res1);
				}
				var res2:Number=look(ncel,overLook || over);
				if (res2>0) {
					(ncel as UnitPlayer).observation(res2,observ);
					if ((ncel as UnitPlayer).obs>=(ncel as UnitPlayer).maxObs) {
						setCel(ncel);
						return true;
					}
				} else if (res1>0){
					if ((ncel as UnitPlayer).obs>=(ncel as UnitPlayer).maxObs) {
						setCel(null,ncel.X+(Math.random()-0.5)*200, ncel.Y+(Math.random()-0.5)*200);
					}
					if (res1>1) return true;
				}
			} else {
				if (look(ncel,overLook || over)>0.5) {
					setCel(ncel);
					return true;
				}
			}
			celUnit=null;
			priorUnit=null;
			return false;
		}
		//установить цель на юнит или на точку
		public function setCel(un:Unit=null, cx:Number=-10000, cy:Number=-10000) {
			if (un && isMeet(un)) {
				celX=un.X+un.scX/4*un.storona, celY=un.Y-un.scY/2;
				celUnit=un;
				if (un.player) {
					World.w.t_battle=World.battleNoOut;
					World.w.cur();
					loc.detecting=true;
					if (sndMusic && !loc.postMusic) Snd.combatMusic(sndMusic, sndMusicPrior, boss?10000:150);
				}
			} else if (cx>-10000 && cy>-10000) {
				celX=cx, celY=cy;
				celUnit=null;
			} else {
				celX=X, celY=Y-scY/2;
				celUnit=null;
			}
			celDX=celX-X;
			celDY=celY-Y+scY;
		}
		
		public function findGrenades():Boolean {
			for (var i=0; i<10; i++) {
				if (loc.grenades[i]==null) continue;
				var gx:Number=loc.grenades[i].X-X;
				var gy:Number=loc.grenades[i].Y-Y+scY/2;
				if (gx*gx+gy*gy<400*400) {	//граната есть
					if (loc.isLine(X,Y-scY*0.75,loc.grenades[i].X, loc.grenades[i].Y)) {
						acelX=loc.grenades[i].X;
						acelY=loc.grenades[i].Y;
						return true;
					}
				}
			}
			return false;
		}
		
		public function findLevit() {
			if (isMeet(loc.gg) && loc.gg.teleObj) {
				var gx:Number=loc.gg.teleObj.X-X;
				if (!overLook && gx*storona<0) return false;
				var gy:Number=loc.gg.teleObj.Y-loc.gg.teleObj.scY/2-Y+scY/2;
				if (gx*gx+gy*gy<vision*vision*1000*1000 && loc.isLine(X,Y-scY*0.75,loc.gg.teleObj.X, loc.gg.teleObj.Y-loc.gg.teleObj.scY/2)) return true;
			}
			return false;
		}
		
		public override function command(com:String, val:String=null) {
			super.command(com,val);
			if (com=='activate') {
				noAct=false;
				disabled=false;
				setNull(true);
				addVisual();
				Emitter.emit('tele',loc,X,Y-scY/2,{rx:scX, ry:scY, kol:30});
			}
			if (com=='fraction') {
				fraction=int(val);
				if (fraction==F_PLAYER) warn=0;
				else warn=1;
			}
			//trace(com,val);
		}
		
//--------------------------------------------------------------------------------------------------------------------
//				Разговоры

		public function replic(s:String) {
			//trace(id,s);
			if (sost!=1 || id_replic=='' || !loc.active) return;
			var s_replic:String;
			if (s=='dam') {
				if (isrnd(0.05)) t_replic=0;
			} 
			if (s=='die') {
				if (isrnd()) t_replic=0;
			} 
			if (t_replic<=0) {
				if (s=='attack') {
					t_replic=50+Math.random()*100;
				} else {
					t_replic=110+Math.random()*150;
				}
				s_replic=Res.repText(id_replic, s, msex);
				if (s_replic!='' && s_replic!=null) {
					Emitter.emit('replic',loc,X,Y-110,{txt:s_replic, ry:50});
					//var p:Part=newPart('replic',0,X,Y-80-Math.random()*50,0,0,1,s_replic);
				}
			}
		}
		
		
//--------------------------------------------------------------------------------------------------------------------
//				Рандом
		protected function isrnd(n:Number=0.5):Boolean {
			return Math.random()<n;
		}
		
		
	}
	
}

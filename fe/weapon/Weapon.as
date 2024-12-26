package fe.weapon {

	import flash.geom.Point;
	import flash.utils.*;
	import flash.media.SoundChannel;
	import flash.display.Graphics;
	
	import fe.*;
	import fe.util.Vector2;
	import fe.entities.Obj;
	import fe.unit.Unit;
	import fe.unit.UnitPlayer;
	import fe.graph.Emitter;
	import fe.unit.Pers;
	import fe.projectile.Bullet;
	import fe.projectile.Trasser;
	import fe.projectile.SmartBullet;

	public class Weapon extends Obj {
		
		public static var weaponPerks:Array=['pistol','shot','commando','rifle','perf','laser','plasma','pyro','acute','stunning']
		public static var variant2:String = ' - II';
		
		public var b:Bullet;
		public var trasser:Trasser;
		public var owner:Unit;
		public var rot:Number;
		public var bulCoords:Vector2 = new Vector2(0, 0);
		
		//[visual]
		public var svis:String, svisv:String;	// [the weapon itself]
		public var vWeapon:Class;			
		public var visbul:String;				// [shells]
		public var vBullet:Class;
		public var flare:String;				//[flash]
		public var visexpl:String;				//[explosion]
		
		public var is_attack:Boolean = false;			//	[is the attack key pressed?]
		public var is_pattack:Boolean = false;	
		
		public var t_attack:int=0;
		public var t_prep:int=0;
		public var t_reload:int=0;
		public var t_rech:int=0;
		public var t_rel:int=0;			//время перезарядки для оружия, не имеющего магазина
		public var t_shoot:int=0;		//время после выстрела
		public var t_auto:int=0;
		public var pow:int=0;			//усиление атаки
		public var skillConf:Number=1;			//модификатор, зависит от соответствия уровня скилла, 1 - норм, 0.8 - скилл на 1 уровень ниже, 0.6 - скилл на 2 уровня ниже
		public var skillPlusDam:Number=1;		//усиление оружия низких уровней;
		public var weaponSkill:Number=1;	//умение для гг
		private var t_ret:int=0;
		private var rotUp:Number=0;
		public var jammed:Boolean=false;	//заклинило
		public var kol_shoot:int=0;	//	количество сделанных выстрелов
		public var ready:Boolean=false; //оружие наведено на цель
		public var is_shoot:Boolean=false; // [shot fired]
		protected var animated:Boolean=false;
		
		public var krep:int = 0;		// [fastening type]
		public var hold:int = 0;		// [left in the clip]

		public var findCel:Boolean = true;	//[turn to target]
		public var forceRot:Number = 0;
		public var fixRot:int = 0;	
		public var checkLine:Boolean = false;	

		public var id:String;
		public var uniq:Number=-1;			//вероятность появления уникального варианта
		public var variant:int=0;			//уникальное оружие
		
		//характеристики
		//тип оружия
		//0 - внутреннее
		//1 - холодное
		//2 - лёгкое огнестрельное
		//3 - тяжёлое
		//4 - взрывчатка
		public var tip:int=0;
		//категория 
		public var cat:int=0;
		//инвентарь
		public var respect:int=0;		//отношение 0-новое, 1-скрытое, 2-используемое, 3-схема
		//необходимый скилл
		public var skill:int=0;
		//уровень скилла
		public var lvl:int=0;
		public var lvlNoUse:Boolean=false;	//запретить использовать если навык не достаточен
		public var perslvl:int=0;
		public var spell:Boolean=false;		//является защитным заклинанием
		public var alicorn:Boolean=false;	//доступно в режиме аликорна
		public var rep_eff:Number=1;	//эффективность ремонта набором оружейника
		
		public var auto:Boolean = false;	// [automatic attack]
		public var rapid:int = 5;			// [cycles per shot, 30 = 1s]
		public var speed:Number = 100;		// [bullet speed]
		public var volna:Boolean = false;	// [if true, then the bullet speed will not be random]
		public var deviation:Number = 0; 	// Weapon dispersion
		public var precision:Number = 0;	// [accuracy, shows the distance at which the hit will be 100%]
		public var antiprec:Number = 0;		// [for sniper rifles, shows the distance at which accuracy will begin to decrease]

		public var dlina:int=50;			// [bladed weapon length]
		public var mindlina:int=50;			
		
		public var mass:int=1;			//занимает место
		public var drot:Number=0;		//скорость поворота оружия, 0 -мгновенно
		public var drot2:Number=0;		//скорость поворота оружия при атаке
		public var prep:int=0;			//тактов на раскрутку
		
		public var explRadius:Number=0;	//радиус взрыва, если 0, то взрыва нет
		public var explTip:int=1;		//тип взрыва, 1-обычный, 2-облако газа
		public var explKol:int=0;		//количество взрывов, интервал 1с, 0 - мгновенный взрыв
		public var destroy:Number=10;	//урон блокам
		public var damage:Number=0;		//урон юнитам
		public var damageExpl:Number=0;	//урон по площади
		public var tipDamage:int=0;		//тип урона
		public var pier:Number=0;		//бронебойность
		public var critCh:Number=0.1;	//вероятность крита
		public var critM:Number=0;		//дополнительный крит
		public var critDamPlus:Number=0;//прибавка к модификатору критического урона
		public var distExpl:Boolean=false;	//пули взрываются по прошествии времени
		public var navod:Number = 0;		// [homing]

		public var otbros:Number=0;		//отброс
		public var kol:Number=1;		//количество пуль за 1 выстрел
		public var dkol:Number=0;		//стрельба очередями
		public var rashod:Number=1;		//зарядов за 1 выстрел
		public var opt:Object;		//опции
		public var recoil:int=0;		//отдача назад
		public var recoilUp:int=0;		//отдача вверх
		public var recoilMult:int=1;	//множитель отдачи
		public var desintegr:Number=0;	//вероятность дезинтеграции
		
		public var holder:int=0;		//обойма
		public var ammoBase:String='';	//базовый тип боеприпасов
		public var ammo:String='';		//текущий тип боеприпасов
		public var ammoTarg:String='';	//тип боеприпасов на замену
		public var reload:int=0;		//тактов на перезарядку, 30=1с
		public var recharg:int=0;		//тактов на подзарядку, если она имеется, 0 если нет
		public var magic:Number=100, dmagic:Number=100;	//расход магии
		public var mana:Number=100, dmana:Number=100;	//расход маны

		public var noise:int=0;			//звук выстрела
		public var shine:int=500;			//вспышка от выстрела
		public var tipDecal:int=0;		//тип оставляемых следов		
		public var bulAnim:Boolean=false;	//анимировать снаряд
		public var spring:int=1;		//растягивание
		public var flame:int=0;	//снаряд ведёт себя как огонь
		public var grav:Number=0;	//снаряд движется по параболе
		public var accel:Number=0;	//снаряд движется с ускорением
		public var shell:Boolean=false;	//выбрасывает гильзу
		public var fromWall:Boolean=false;	//стрелять из стены
		public var bulBlend:String='screen';
		private var emitShell:Emitter=Emitter.arr['gilza'];
		
		//дополнительные эффекты
		public var dopEffect:String;		//эффект
		public var dopDamage:Number=0;		//урон
		public var dopCh:Number=1;			//шанс
		public var probiv:Number=0;
		public var visionMult:Number=1;		//множитель видимости для пользователя
		
		//модификаторы
		public var drotMult:Number=1;
		public var reloadMult:Number=1;
		
		public var precMult:Number=1;
		public var consMult:Number=1;
		public var damMult:Number=1;
		public var damAdd:Number=0;
		public var pierAdd:Number=0;
		public var critchAdd:Number=0;
		public var speedMult:Number=1;
		public var otbrosMult:Number=1;
		public var explRadMult:Number=1;
		public var devMult:Number=1;
		
		public var absPierRnd:Number=0;
		
		//модификаторы патрона
		public var ammoPier:Number=0;	//бронебойность
		public var ammoArmor:Number=1;	//модификатор брони цели
		public var ammoDamage:Number=1;	//урон
		public var ammoProbiv:Number=0;	//пробивание цели насквозь
		public var ammoOtbros:Number=1;	//отбрасывание
		public var ammoPrec:Number=1;	//точность
		public var ammoHP:int=0;		//прибавка к износу
		public var ammoFire:Number=0;	//зажигательный
		public var ammoMod:int=-1;		//изменение типа урона
		
		
		// SATS
		public var satsQue:int = 1;
		public var satsCons:Number = 10;
		public var noSats:Boolean = false;	// [Do not support]
		public var noPerc:Boolean = false;	// [Do not calculate accuracy]
		public var noTrass:Boolean = false;	// [Do not trace]
		public var satsMelee:Boolean = false;
		
		// Sounds
		public var sndShoot:String='';
		public var sndShoot_n:int=1;
		public var sndReload:String='';
		public var sndPrep:String='';
		public var sndHit:String='';
		public var snd_t_prep1:int=0;
		public var snd_t_prep2:int=0;
		public var sndCh:SoundChannel;
		
		public var hp:int, maxhp:int=100;
		public var price:int=0;
		public var breaking:Number=0;

		public static var cachedWeaponList:XMLList = XMLDataGrabber.getNodesWithName("core", "AllData", "weapons", "weapon");

		private static var cachedWeapons:Object	= {}; // Save object nodes that have been used before to avoid parsing XML for lots of objects.
		private static var cachedAmmo:Object	= {};

		public function Weapon(own:Unit, nid:String, nvar:int=0) {
			sloy=2;
			owner=own;
			id=nid;
			variant=nvar;
			opt = new Object();
			
			trasser = new Trasser();
			
			getXmlParam();
			setNull();
			if (!own.player) auto = true;
		}
		
		public static function create(owner:Unit, id:String, nvar:int=0):Weapon {
			if (id.charAt(id.length-2)=='^') {
				id=id.substr(0,id.length-2);
				nvar=1;
			}

			var node:XML = getWeaponInfo(id);
			var w:Weapon;

			if (node.@tip==1) w = new WClub(owner,id,nvar);
			else if (node.@tip==12) w = new WPaint(owner,id,nvar);
			else if (node.@tip==4) w = new WThrow(owner,id,nvar);
			else if (node.@tip==5) w = new WMagic(owner,id,nvar);
			else if (node.@punch>0) w = new WPunch(owner,id,nvar);	
			else w=new Weapon(owner,id,nvar);
			
			return w;
		}

		public static function getWeaponInfo(id:String):XML {
			if (cachedWeapons[id] != undefined) return cachedWeapons[id];

			var node:XML = XMLDataGrabber.getNodeWithAttributeThatMatches("core", "AllData", "weapons", "id", id);
			if (node) cachedWeapons[id] = node;

			return node;
		}

		public static function getAmmoInfo(id:String):XML {
			var node:XML;
			if (cachedAmmo[id] != undefined) return cachedAmmo[id];

			node = XMLDataGrabber.getNodeWithAttributeThatMatches("core", "AllData", "items", "id", id);
			if (node) cachedAmmo[id] = node;

			return node;
		}
		
		public override function err():String {
			return 'Error weapon '+nazv+':'+(owner?owner.nazv:'????');
		}
		
		public function getXmlParam():void {
			//общие характеристики
			var node:XML = getWeaponInfo(id);
			
			if (node.@tip.length()) tip=node.@tip;
			if (variant==0)	nazv=Res.txt('w',id);
			else {
				if (Res.istxt('w',id+'^'+variant)) nazv=Res.txt('w',id+'^'+variant);
				else nazv=Res.txt('w',id)+variant2;
			}
			cat=node.@cat;
			skill=node.@skill;
			if (node.@perk.length()) {
				opt.perk=node.@perk;
				opt[node.@perk]=true;
			}
			lvl=node.@lvl;
			perslvl=node.@perslvl;
			if (node.@alicorn>0) alicorn=true;
			
			//SATS
			if (node.sats.length()) {
				if (node.sats[0].@que.length()) satsQue=node.sats[0].@que;
				if (node.sats[0].@cons.length()) satsCons=node.sats[0].@cons;
				if (node.sats[0].@no.length()) noSats=true;
				if (node.sats[0].@noperc.length()) noPerc=true;
			}
			//цена и ремонт
			if (node.com.length()) {
				if (node.com[0].@rep.length()) rep_eff=node.com[0].@rep;
				if (node.com[0].@price.length()) price=node.com[0].@price;
				if (node.com[0].@uniq.length()) uniq=node.com[0].@uniq;
				if (variant>0 && node.com[variant] && node.com[variant].@price.length()) price=node.com[variant].@price;
			}
			//визуал
			svis='vis'+id;
			if (tip==0) svisv=null; 
			else if (variant>0) svisv=svis+'_'+variant;
			else svisv=svis;
			if (node.vis.length()) {
				getVisParam(node.vis[0])
				if (variant>0) getVisParam(node.vis[variant]);
			}
			if (tip>0 || svisv) {
				vWeapon=Res.getClass(svisv, svis, visp10mm);
				vis=new vWeapon();
			}
			if (owner && owner.weaponKrep>0) krep=owner.weaponKrep;
			if (vis && vis.totalFrames>1) animated=true;
			if (flare==null) flare=visbul;
			if (visbul)
			{ 
				try
				{
					vBullet = getDefinitionByName('visbul' + visbul) as Class;
				}
				catch (err:ReferenceError)
				{
					trace("ERROR: (00:11)");
					vBullet = visualBullet;
				}
			}
			else
			{
				vBullet = visualBullet;
			}
			
			//звуки
			if (node.snd.length()) {
				getSndParam(node.snd[0])
				if (variant>0) getSndParam(node.snd[variant]);
			}
			//Физические параметры
			if (node.phis.length()) {
				getPhisParam(node.phis[0])
				if (variant>0) getPhisParam(node.phis[variant]);
			}
			//боеприпасы
			if (node.ammo.length()) {
				getAmmoParam(node.ammo[0])
				if (variant>0) getAmmoParam(node.ammo[variant]);
			}
			//Дополнительные эффекты
			if (node.dop.length()) {
				getDopParam(node.dop[0])
				if (variant>0) getDopParam(node.dop[variant]);
			}
			//боеприпасы
			if (node.a.length())
			{
				ammo = ammoBase = node.a[0];
				var ammoNode = getAmmoInfo(ammo);
				setAmmo(ammo,ammoNode);
			}
			
			//боевые характеристики
			getCharParam(node.char[0]);
			if (variant>0) getCharParam(node.char[variant]);
			
			recoilUp=recoil/2;
			if (owner && !owner.player) recoilUp*=0.2;
			t_rech=recharg;
			if (recharg) hold=holder;
			hp=maxhp;
			if (owner && owner.player) {
				if (tipDamage==Unit.D_BUL) critDamPlus+=0.2;
				if (tipDamage==Unit.D_PLASMA) critDamPlus-=0.2;
			}
		}
		
		protected function getVisParam(node:XML):void {
			if (node==null) return;
			if (node.@vweap.length()>0) svisv=node.@vweap;
			if (node.@tipdec.length()) tipDecal=node.@tipdec;
			if (node.@shell.length()) shell=true;
			if (node.@spring.length()) spring=node.@spring;
			if (node.@bulanim.length()) bulAnim=true;
			if (node.@phisbul.length()) bulBlend='normal';
			if (node.@visexpl.length()) visexpl=node.@visexpl;
			if (node.@shine.length()) shine=node.@shine;
			if (node.@vbul.length()) visbul=node.@vbul;
			if (node.@flare.length()) flare=node.@flare;
		}
		
		protected function getSndParam(node:XML):void {
			if (node==null) return;
			if (node.@shoot.length()) sndShoot=node.@shoot;
			if (node.@shoot_n.length()) sndShoot_n=node.@shoot_n;
			if (node.@reload.length()) sndReload=node.@reload;
			if (node.@hit.length()) sndHit=node.@hit;
			if (node.@prep.length()) sndPrep=node.@prep;
			if (node.@t1.length()) snd_t_prep1=node.@t1;
			if (node.@t2.length()) snd_t_prep2=node.@t2;
			if (node.@noise.length()) noise=node.@noise;
		}
		
		protected function getDopParam(node:XML):void {
			if (node==null) return;
			if (node.@vision.length()) visionMult=node.@vision;
			if (node.@effect.length()) dopEffect=node.@effect;
			if (node.@damage.length()) dopDamage=node.@damage;
			if (node.@ch.length()) dopCh=node.@ch;
			if (node.@probiv.length()) probiv=node.@probiv;
		}
		
		protected function getPhisParam(node:XML):void {
			if (node==null) return;
			if (node.@massa>0) massa=node.@massa/50;
			else massa=0;
			if (node.@m.length()) mass=node.@m;
			if (node.@drot.length()) drot=(node.@drot*Math.PI/180);
			if (node.@drot2.length()) drot2=(node.@drot2*Math.PI/180);
			if (node.@recoil.length()) recoil=node.@recoil;
			if (node.@speed.length()) speed=node.@speed;
			if (node.@deviation.length()) deviation=node.@deviation;
			if (node.@flame.length()) flame=node.@flame;
			if (node.@grav.length()) grav=node.@grav;
			if (owner && owner.fraction!=Unit.F_PLAYER && node.@grav2.length()) grav=node.@grav2;
			if (node.@accel.length()) accel=node.@accel;
			if (node.@navod.length()) navod=node.@navod;
			if (node.@distexpl.length()) distExpl=true;
			if (node.@volna.length()) volna=true;
		}
		
		protected function getCharParam(node:XML):void {
			if (node==null) return;
			if (node.@maxhp.length()) maxhp=node.@maxhp;
			if (node.@damage.length()) damage=node.@damage;
			if (node.@damexpl.length()) damageExpl=node.@damexpl;
			if (node.@rapid.length()) rapid=node.@rapid;
			if (node.@pier.length()) pier=node.@pier;
			if (node.@crit.length()) {
				critM=node.@crit-1;
				critCh=0.1*node.@crit;
			}
			if (node.@critdam.length()) critDamPlus=node.@critdam;
			if (node.@knock.length()) otbros=node.@knock;
			if (node.@tipdam.length()) tipDamage=node.@tipdam;
			if (node.@prec.length()) precision=node.@prec*40;
			if (node.@antiprec.length()) antiprec=node.@antiprec*40;
			if (node.@destroy.length()) destroy=node.@destroy;
			if (node.@kol.length()) kol=node.@kol;
			if (node.@dkol.length()) dkol=node.@dkol;
			if (node.@expl.length()) explRadius=node.@expl;
			if (node.@expltip.length()) explTip=node.@expltip;
			if (node.@explkol.length()) explKol=node.@explkol;
			if (node.@prep.length()) prep=node.@prep;
			auto=(rapid<=6);
			if (node.@auto.length()) auto=(node.@auto!='0');
		}
		
		protected function getAmmoParam(node:XML):void {
			if (node==null) return;
			if (node.@holder.length()) holder=node.@holder;
			if (node.@rashod.length()) rashod=node.@rashod;
			if (node.@reload.length()) reload=node.@reload;
			if (node.@recharg.length()) recharg=node.@recharg;
			if (node.@mana.length()) mana=dmana=node.@mana;
			if (node.@magic.length()) magic=dmagic=node.@magic;
		}
		
		public function updVariant(nvar:int):void {
			if (uniq<0) return;
			variant=nvar;
			if (owner.player && World.w.gg.currentWeapon==this) {
				remVisual();
			}
			getXmlParam();			
			if (owner.player && World.w.gg.currentWeapon==this) {
				addVisual();
				World.w.gg.weaponLevit();
			}
		}
		
		public override function step():void {
			actions();		// [Various actions]
			if (owner) owner.setWeaponPos(tip);
			if (vis) animate();		//анимация
		}

		public override function addVisual():void {
			if (owner) {
				loc=owner.loc;
			}
			else {
				loc=World.w.loc;
			}
			super.addVisual();
			if (owner && tip!=5 && owner.cTransform) {
				vis.transform.colorTransform=owner.cTransform;
			}
		}
		
		public function addVisual2():void {
			if (tip==5 && vis) World.w.grafon.visObjs[sloy].addChild(vis);
		}
		
		public override function setNull(f:Boolean=false):void {
			t_attack=t_reload=0;
			if (owner) {
				coordinates.X = owner.weaponX;
				coordinates.Y = owner.weaponY;
				animate();
			}
		}
		
		public function setPers(gg:UnitPlayer, pers:Pers):void {
  			weaponSkill = pers.weaponSkills[skill];
			if (pers.desintegr > 0) desintegr = pers.desintegr;
			if (tip != 5) drotMult = pers.drotMult;
			reloadMult=pers.reloadMult;
			precMult=pers.allPrecMult;
			recoilMult=pers.recoilMult;
			consMult=1;
			damMult=pers.allDamMult;
			if (skill==2 || skill==3 || skill==4) damMult*=pers.gunsDamMult;
			var razn=lvl-pers.getWeapLevel(skill);
			if (razn<0) skillPlusDam=1-razn*0.1;
			else skillPlusDam=1;
			speedMult=1;
			damAdd=0;
			pierAdd=0;
			critchAdd=0;
			otbrosMult=1;
			devMult=1;
			for each(var wp in weaponPerks) {
				if (opt[wp]) {
					if (pers.hasOwnProperty(wp + 'Prec')) precMult *= pers[wp + 'Prec'];
					if (pers.hasOwnProperty(wp + 'Cons')) consMult *= pers[wp + 'Cons'];
					if (pers.hasOwnProperty(wp + 'Dam')) damMult *= pers[wp + 'Dam'];
					if (pers.hasOwnProperty(wp + 'Speed')) speedMult *= pers[wp + 'Speed'];
					if (pers.hasOwnProperty(wp + 'Det')) damAdd += pers[wp + 'Det'];
					if (pers.hasOwnProperty(wp + 'Pier')) pierAdd += pers[wp + 'Pier'];
					if (pers.hasOwnProperty(wp + 'Critch')) critchAdd += pers[wp + 'Critch'];
					if (pers.hasOwnProperty(wp + 'Knock')) otbrosMult *= pers[wp + 'Knock'];
					if (pers.hasOwnProperty(wp + 'Dev')) devMult *= pers[wp + 'Dev'];
					if (pers.hasOwnProperty(wp + 'Stun')) {
						dopEffect='stun';
						dopDamage=pers[wp+'Stun'];
						dopCh=1;
					}
				}
			}
			absPierRnd = pers.modTarget;
			explRadMult = pers.explRadMult;
		}
		
		public function actions():void {
			var rot2:Number;
			if (owner == null) return;

			if (coordinates.X < owner.celX) storona = 1;
			else storona = -1;

			// This turns the weapon to face the curosr and is executed every tick.
			if (findCel) {
				if (tip == 5) {
					coordinates.X = owner.magicX;
					coordinates.Y = owner.magicY;
					rot2=Math.atan2(owner.celY - coordinates.Y, owner.celX - coordinates.X);
				}
				else if (krep > 0 || !coordinates.X) {
					coordinates.X = owner.weaponX;
					coordinates.Y = owner.weaponY;
					rot2=Math.atan2(owner.celY - coordinates.Y, Math.abs(owner.celX - coordinates.X)*owner.storona);
				}
				else {
					coordinates.X += (owner.weaponX - coordinates.X) / 5;
					coordinates.Y += (owner.weaponY - coordinates.Y) / 5;
					rot2=Math.atan2(owner.celY - coordinates.Y, owner.celX - coordinates.X);
				}
			}
			else {
				coordinates.X = owner.weaponX;
				coordinates.Y = owner.weaponY;
				rot2 = forceRot;
			}

			ready = false;
			
			var rdrot:Number = drot;
			
			if (drot2 > 0 && (t_prep > 0 || t_attack > 0)) rdrot = drot2;
			
			if (rdrot == 0) {
				rot = rot2;
				ready = true;
			}
			else {
				if (Math.abs(rot-rot2)>Math.PI) {
					if (Math.abs(rot-rot2)>Math.PI*2-rdrot*drotMult) {
						rot=rot2;
						ready=true;
					}
					else if (rot>rot2) rot+=rdrot*drotMult;
					else rot-=rdrot*drotMult;
				}
				else {
					if (rot2-rot>rdrot*drotMult) rot+=rdrot*drotMult;
					else if (rot2-rot<-rdrot*drotMult) rot-=rdrot*drotMult;
					else {
						rot=rot2;
						ready=true;
					}
				}
				if (rot>Math.PI) rot-=Math.PI*2;
				if (rot<-Math.PI) rot+=Math.PI*2;
			}
			
			if (fixRot == 1) {
				if (rot<-Math.PI/6 && rot>-Math.PI/2) rot=-Math.PI/6;
				if (rot>-Math.PI*5/6 && rot<=-Math.PI/2) rot=-Math.PI*5/6;
			}
			
			if (fixRot == 2) {
				if (rot<-Math.PI/6) rot=-Math.PI/6;
				if (rot>Math.PI/6) rot=Math.PI/6;
			}
			
			if (fixRot == 3) {
				if (rot>0 && rot<Math.PI*5/6) rot=Math.PI*5/6;
				if (rot<=0 && rot>-Math.PI*5/6) rot=-Math.PI*5/6;
			}

			try {
				if (dkol <= 0 && t_attack == rapid) shoot();
				if (dkol > 0 && t_attack > rapid && t_attack % rapid == 0) shoot();
			}
			catch (err) {
				trace("ERROR: (00:12)");
			}

			if (t_attack>0) {
				t_attack--;
			}
			
			if (t_rel>0) t_rel--;
			
			if (t_ret>0) {
				t_ret--;
			}
			
			if (rotUp>5) {
				rotUp*=0.9;
			}
			else if (rotUp>0.5) {
				rotUp-=0.5;
			}
			else rotUp=0;
			
			if (t_prep>0) {
				t_prep--;
			}
			else {
				kol_shoot=0;
			}
			if (t_auto>0) {
				t_auto--;
			}
			else pow = 0;
			
			if (t_shoot > 0) t_shoot--;
			
			if (sndPrep!='')
			{
				if (!is_pattack && is_attack) {
					sndCh = Snd.ps(sndPrep, coordinates.X, coordinates.Y, t_prep * 30);
				}	// [spin sound]
				if (snd_t_prep1>0 && is_attack && sndCh!=null && sndCh.position>snd_t_prep2-300)
				{
					sndCh.stop();
					sndCh=Snd.ps(sndPrep, coordinates.X, coordinates.Y, snd_t_prep1 + 200);
				}	// [continuation sound]
				if (snd_t_prep2>0 && is_pattack && !is_attack && t_prep>0 && sndCh!=null && sndCh.position<snd_t_prep2-400)
				{
					sndCh.stop();
					sndCh=Snd.ps(sndPrep, coordinates.X, coordinates.Y, snd_t_prep2 + 100);
				}	// [stop sound]
			}
			
			if (recharg && hold < holder && t_attack == 0) {
				t_rech--;
				if (t_rech <= 0) {
					hold++;
					t_rech = recharg;
					if (owner.player) World.w.gui.setWeapon();
				}
			}
			
			if (t_attack == 0 && t_reload > 0) t_reload--;
			
			if (t_reload == Math.round(10 * reloadMult)) reloadWeapon();
			
			is_pattack = is_attack;
			is_attack = false;
		}

		public function attack(waitReady:Boolean = false):Boolean {
			if (waitReady && !ready) return false;
			
			// Weapon is broke, abort
			if (hp <= 0 && owner == World.w.gg) {
				World.w.gui.infoText('brokenWeapon', nazv, null, false);
				World.w.gui.bulb(coordinates.X, coordinates.Y);
				return false;
			}
			
			if (owner.player && (respect == 1 || alicorn && !World.w.alicorn)) {
				World.w.gui.infoText('disWeapon', null, null, false);
				return false;
			}
			
			if (!waitReady && !World.w.alicorn && !auto && t_auto > 0) {
				t_auto = 3;
				pow++;
				return true;
			}
			
			skillConf = 1;
			
			if (owner.player) {
				if (!checkAvail()) return false;
			}
			
			if (holder > 0 && hold<rashod) { // [requires recharging]
				initReload();
				return false;
			}
			
			weaponAttack();
			
			is_attack = true;
			
			if (t_prep < prep + 10) t_prep += 2;
			
			if (t_prep >= prep && t_attack <= 0 && t_reload <= 0) {
				if (dkol <= 0) t_attack = rapid;
				else t_attack = rapid * (dkol + 1);
				if (holder == 1) initReload();
			
			}
			return true;
		}
		
		protected function weaponAttack():void {
			if (jammed) {
				if (tipDamage==Unit.D_LASER || tipDamage==Unit.D_PLASMA || tipDamage==Unit.D_EMP || tipDamage==Unit.D_SPARK) World.w.gui.infoText('weaponCircuit',null,null,false);
				else World.w.gui.infoText('weaponJammed',null,null,false);
				Snd.ps('no_ammo', coordinates.X, coordinates.Y);
				initReload();
				return;
			}
			if (hp < maxhp / 2) breaking = (maxhp - hp) / maxhp * 2 - 1;
			else breaking = 0;
		}
		
		protected function checkAvail():Boolean {
			var razn=lvl-(owner as UnitPlayer).pers.getWeapLevel(skill);
			if (razn==1) skillConf=0.8;
			else if (razn==2) skillConf=0.6;
			else if (razn>2) {
				World.w.gui.infoText('weaponSkillLevel',null,null,false);
				return false;
			}
			if (perslvl && (owner as UnitPlayer).pers.level<perslvl) {
				World.w.gui.infoText('persLevel',null,null,false);
				return false;
			}
			return true;
		}
		
		// [Possibility of attack]
		public function attackPos():Boolean {
			return t_attack <= 0 && t_reload <= 0;
		}
		
		public function getBulXY():void {
			try {
				if (vis && vis.emit && vis.parent) {
					var p:Point=new Point(vis.emit.x,vis.emit.y);
					var p1:Point=vis.localToGlobal(p);
					p1=vis.parent.globalToLocal(p1);
					bulCoords.X = p1.x;
					bulCoords.Y = p1.y;
				}
				else {
					bulCoords.setVector(coordinates);
				}
			}
			catch (err) {
				trace("ERROR: (00:13)");
				bulCoords.setVector(coordinates);
			}
		}
		
		protected function shoot():Bullet {
			// [Misfire]
			if (breaking > 0 && owner && owner.player) {
				var rnd:Number = Math.random();
				var jm = (owner as UnitPlayer).pers.jammedMult;
				if (rnd < breaking / Math.max(20, holder) * jm) {
					t_ret = 2;
					jammed = true;
					return null;
				}
				else if (rnd < breaking / 5 * jm) {
					t_ret = 2;
					if (rapid > 5) World.w.gui.infoText('misfire', null, null, false);
					Snd.ps('no_ammo', coordinates.X, coordinates.Y);
					return null;
				}
			}

			if (holder > 0 && hold < rashod) return null;
			
			var sk:int = 1;
			
			if (owner) {
				sk = owner.weaponSkill;
				if (owner.player) sk = weaponSkill;
			}
			
			var r:Number = (Math.random() - 0.5) * (deviation * (1 + breaking * 2) / skillConf / (sk + 0.01) + owner.mazil) * 3.1415 / 180 * devMult;
			
			getBulXY();
			
			for (var i:int = 0; i < kol; i++) {
				if (navod) {
					b = new SmartBullet(owner, bulCoords, vBullet);
					(b as SmartBullet).setCel(World.w.gg, navod);
				}
				else {
					b = new Bullet(owner, bulCoords, vBullet);
				}

				b.weap = this;
				
				if (b.vis) b.vis.blendMode = bulBlend;
				if (fromWall) {
					try {
						if (loc.getAbsTile(bulCoords.X, bulCoords.Y).phis) b.inWall = true;
					}
					catch(err) { 
						trace("ERROR: (00:14)");
					}
				}
				
				if (b.vis && spring == 3) b.vis.gotoAndStop(i + 1);
				
				b.rot = rot - rotUp * storona / 50 + r + (i - (kol - 1) / 2) * deviation * 3.1415 / 360;
			
				if (grav > 0 || volna) b.vel = speed * speedMult; 
				else b.vel = speed * speedMult * (Math.random() * 0.4 + 0.8);
				
				b.velocity.X = Math.cos(b.rot) * b.vel;
				b.velocity.Y = Math.sin(b.rot) * b.vel;
				b.knockx = b.velocity.X / b.vel;
				b.knocky = b.velocity.Y / b.vel;
				if (owner && distExpl) {
					b.celX = owner.celX;
					b.celY = owner.celY;
				}
				if (damage > 0) b.damage = resultDamage(damage, sk) * ammoDamage;
				if (damageExpl > 0) b.damageExpl = resultDamage(damageExpl, sk);

				setBullet(b);
				
				b.miss = 1 - skillConf;
				b.ddy = b.ddx = 0;
				if (desintegr) b.desintegr = desintegr;
				if (owner) {
					b.precision = resultPrec(owner.precMult, sk);
					b.antiprec = antiprec;
				}
				if (accel) {
					b.ddx += Math.cos(b.rot) * accel;
					b.ddy += Math.sin(b.rot) * accel;
					b.accel=accel;
				}
				if (flame > 0) {
					b.flame = flame;
					if (flame == 1) {
						b.ddy += -0.8 - Math.random() * 0.2;
						b.brakeR = 180 + Math.random() * 40;
						b.liv = b.brakeR / 7;
					}
					else if (flame == 2) {
						b.ddy += -0.2-Math.random() * 0.2;
						b.brakeR = 100 + Math.random() * 40;
						b.liv = b.brakeR / 7;
					}
				}
				if (grav) {
					b.ddy += World.ddy * grav;
					b.vRot = true;
				}
				if (bulAnim) b.vis.play();
			}
			if (shell) {
				emitShell.cast(loc, coordinates.X, coordinates.Y, {dx:-10*vis.scaleX, dy:-10, dr:-15*vis.scaleX});
			}
			if (owner.demask<shine) owner.demask=shine;	// [shot visibility]
			if (noise > 0) owner.makeNoise(noise, true);
			owner.isShoot = true;
			if (holder > 0 && hold > 0) {
				if (owner.player && (owner as UnitPlayer).pers.recyc > 0 && (ammo == 'batt' || ammo == 'energ' || ammo == 'crystal') && Math.random() < (owner as UnitPlayer).pers.recyc) {
					// [don't waste ammunition]
				}
				else {
					hold -= rashod;
					// [replenishment at the landfill]
					if (owner.player && (loc.train) && ammo!='recharg' && ammo!='not') {
						World.w.invent.items[ammo].kol+=rashod;
						World.w.invent.mass[2]+=World.w.invent.items[ammo].mass*rashod;
					}
				}
			}
			if (owner.player && tip<4 && tip!=0 && !(loc.train || World.w.alicorn)) hp-=(1+ammoHP);
			if (animated && t_shoot<=1) {
				try {
					vis.gotoAndPlay('shoot');
				}
				catch (err) {
					trace("ERROR: (00:15) - weapon: " + id + "\" held by: \"" + owner.id + "\" Could not play movieclip \"shoot\"!");
				}
				t_shoot=3;
			}
			kol_shoot++;
			t_ret = Math.round(recoil * recoilMult);
			if (recoil > 3 && t_ret < 3) t_ret = 3;
			rotUp += recoilUp * recoilMult;
			is_shoot = true;
			if (sndShoot != '' && kol_shoot%sndShoot_n == 0) Snd.ps(sndShoot, coordinates.X, coordinates.Y);
			t_auto = 3;
			return b;
		}
		
		// [Resulting damage]
		public function resultDamage(dam0:Number, sk:Number=1):Number {
			return (dam0+damAdd)*damMult*sk*skillPlusDam*(1-breaking*0.3);
		}

		// [Resulting range]
		public function resultPrec(pm:Number=1, sk:Number=1):Number {
			return precision * precMult * (1 + (sk - 1) * 0.5) * pm * owner.precMultCont;
		}

		// Resulting attack time
		public function resultRapid(rap0:Number, sk:Number=1):Number {
			return rap0;
		}
		
		public function setTrass(gr:Graphics):void {
			var rot3=Math.atan2(World.w.celY - coordinates.Y, World.w.celX - coordinates.X);
			trasser.loc = owner.loc;
			trasser.X = trasser.begx = coordinates.X;
			trasser.Y = trasser.begy = coordinates.Y;
			trasser.dx = trasser.begdx = Math.cos(rot3) * speed * speedMult;
			trasser.dy = trasser.begdy = Math.sin(rot3) * speed * speedMult;
			trasser.ddy = 0;
			trasser.ddx = 0;
			if (grav) {
				trasser.ddy += World.ddy;
			}
			trasser.trass(gr);
		}
		
		public function isLine(cx:Number, cy:Number):Boolean {
			if (checkLine) return owner.loc.isLine(coordinates.X, coordinates.Y, cx, cy);
			return true;
		}
		
		
		protected function setBullet(bul:Bullet):void {
			bul.tipDamage=tipDamage;
			bul.tipDecal=tipDecal;
			bul.otbros=otbros*otbrosMult*ammoOtbros;
			bul.pier=pier+pierAdd+ammoPier;
			bul.armorMult=ammoArmor;
			bul.destroy=destroy;
			bul.precision=precision*ammoPrec;
			bul.explTip=explTip;
			bul.explRadius=explRadius*explRadMult;
			bul.explKol=explKol;
			bul.spring=spring;
			bul.flare=flare;
			bul.probiv=probiv+ammoProbiv;
			if (bul.probiv>1) bul.probiv=1;
			if (ammoMod>=0) {
				bul.tipDamage=ammoMod;
				if (ammoMod==8) {
					bul.destroy=bul.otbros=0;
				}
			}
			if (owner) {
				bul.critCh=critCh+owner.critCh+critchAdd;
				bul.critInvis=owner.critInvis;
				bul.critDamMult=owner.critDamMult+critDamPlus;
				bul.critM=critM;
			}
			if (absPierRnd>0 && Math.random()<absPierRnd*critCh) bul.pier=1000;
		}
		
		public function reloadWeapon():void {
			jammed=false;
			if (ammo=='recharg') return;
			if (owner && owner.player && ammo!='not') {
				if (ammoTarg!=ammo) {
					if (hold>0) {
						World.w.invent.items[ammo].kol+=hold;
						World.w.invent.mass[2]+=World.w.invent.items[ammo].mass*hold;
						hold=0;
					}
					setAmmo(ammoTarg);
				}
				var kol:int=World.w.invent.items[ammo].kol;
				if (kol>holder-hold) kol=holder-hold;
				hold+=kol;
				World.w.invent.items[ammo].kol-=kol;
				World.w.invent.mass[2]-=World.w.invent.items[ammo].mass*kol;
			}
			else {
				if (ammoTarg!=ammo) setAmmo(ammoTarg);
				hold=holder;
			}
		}
		
		// [Set the type of ammunition used]
		public function setAmmo(nammo:String=null, node:XML=null):void {
			if (nammo != null) ammo = nammo;
			if (node == null) {
				node = World.w.invent.items[ammo].xml;
				if (owner && owner.player && World.w.gui) World.w.gui.setWeapon();
			}
			if (node == null) {
				trace("ERROR: (00:50) - Invalid ammo: ", ammo);
				return;
			}
			ammoPier=0;		//бронебойность
			ammoArmor=1;	//модификатор брони цели
			ammoDamage=1;	//урон
			ammoProbiv=0;
			ammoOtbros=1;	//отбрасывание
			ammoPrec=1;		//точность
			ammoHP=0;		//прибавка к износу
			ammoFire=0;		//зажигательный
			ammoMod=-1;		//изменение типа урона
			if (node.@pier.length()) ammoPier=node.@pier;
			if (node.@armor.length()) ammoArmor=node.@armor;
			if (node.@damage.length()) ammoDamage=node.@damage;
			if (node.@probiv.length()) ammoProbiv=node.@probiv;
			if (node.@knock.length()) ammoOtbros=node.@knock;
			if (node.@prec.length()) ammoPrec=node.@prec;
			if (node.@det.length()) ammoHP=node.@det;
			if (node.@fire.length()) ammoFire=node.@fire;
			if (node.@tipdam.length()) ammoMod=node.@tipdam;
		}
		
		//разрядить
		public function unloadWeapon():void {
			if (owner && owner.player && holder && hold && ammo!='' && ammo!='recharg' && ammo!='not') {
				World.w.gui.infoText('unloadWeapon',nazv,null,false);
				(owner as UnitPlayer).invent.items[ammo].kol+=hold;
				World.w.invent.mass[2]+=World.w.invent.items[ammo].mass*hold;
				hold=0;
				if (sndReload!='') Snd.ps(sndReload, coordinates.X, coordinates.Y);
			}
		}
		
		//[0-ready to fire, 1-shooting, 2-empty, 3-reloading, 4-out of ammo, 5-broken, 6-out of mana]
		public function status():int {
			if (hp<=0) return 5;
			if (jammed) return 2;
			if (ammo!='recharg' && ammo!='not' && holder>0 && hold<rashod) {
				if (World.w.invent.items[ammo].kol<rashod) return 4;
				else return 2;
			}
			if (dmagic>owner.mana && owner.mana<owner.maxmana*0.99) return 6;
			if (t_attack>0) return 1;
			if (t_reload>0) return 3;
			return 0;
		}
		
		//[Availability for use]
		public function avail():int {
			if (hp<=0) return -2;
			if (perslvl && (owner as UnitPlayer).pers.level<perslvl) return -1; 
			var razn=lvl-(owner as UnitPlayer).pers.getWeapLevel(skill);
			if (World.w.weaponsLevelsOff && (razn>2 || lvlNoUse && razn>0)) return -1;
			if (ammo!='recharg' && ammo!='not' && holder>0 && World.w.invent.items[ammo].kol<rashod) return 0;
			return 1;
		}
		
		public function repair(nhp:int):void {
			hp+=nhp;
			if (hp>maxhp) hp=maxhp;
		}
		
		public function crash(dam:int=1):void {
			
		}

		public function initReload(nammo:String=''):void {
			if (!jammed && (holder<=0 || (hold==holder && nammo=='') || recharg>0)) return;
			if (nammo=='') ammoTarg=ammo;
			if (owner.player) {
				// unsuitable ammunition
				if (nammo!='' && nammo!=ammo)
				{
					var am = getAmmoInfo(nammo);
					if (am.length()==0) return;
					if (am.@base!=ammoBase) {
						World.w.gui.infoText('imprAmmo',World.w.invent.items[nammo].nazv,null,false);
						World.w.gui.bulb(coordinates.X, coordinates.Y);
						return;
					}
					ammoTarg=nammo;
				}
				if (nammo!='' && nammo==ammo) {
					ammoTarg=nammo;
				}
				if (!jammed && ammo!='not' && World.w.invent.items[ammoTarg].kol<rashod) {
					World.w.gui.infoText('noAmmo',World.w.invent.items[ammoTarg].nazv,null,false);
					World.w.gui.bulb(coordinates.X, coordinates.Y);
					return;
				}
			}
			if (t_reload<=0 || reload==0) {
				if (reload>0) {
					t_reload=Math.round(reload*reloadMult);
					if (animated) {
						try
						{
							vis.gotoAndPlay('reload');
						}
						catch (err)
						{
							trace("ERROR: (00:16) - weapon: " + id + "\" held by: \"" + owner.id + "\" Could not play movieclip \"reload\"!");
						}
					}
					if (sndReload!='') Snd.ps(sndReload, coordinates.X, coordinates.Y);
				} else reloadWeapon();
			}
		}

		public function detonator():Boolean {
			return false;
		}

		public function animate():void {
			if (!vis) return;
			vis.x = coordinates.X - t_ret * vis.scaleX * 2;
			vis.y = coordinates.Y;
			if (prep && t_shoot<=0) {
				if (t_prep<prep && t_prep>1) {
					vis.gotoAndStop(t_prep);
				}
				if (t_prep >= prep) {
					try {
						if (tip != 0) vis.gotoAndStop('ready'); // Don't try to animate internal weapons
					}
					catch(err) {
						trace("ERROR: (00:17) - weapon: " + id + "\" held by: \"" + owner.id + "\" Could not play movieclip \"ready\"!");
					}
				}
				if (t_prep<=1 && t_reload==0) vis.gotoAndStop(1);
			}
			if (krep == 0) {
				if (coordinates.X > owner.celX) {
					vis.scaleX = -1;
					vis.rotation = rot * 180 / Math.PI + 180 + rotUp;
				}
				if (coordinates.X < owner.celX) {
					vis.scaleX = 1;
					vis.rotation = rot * 180 / Math.PI - rotUp;
				}
			}
			else {
				vis.scaleX = owner.storona;
				vis.rotation = rot * 180 / Math.PI + 90 * (1 - owner.storona) - rotUp * storona;
			}
		}
		
		public function write():String {
			var s:String='';
			s+=id;
			if (variant>0) s+='^'+variant;
			s+='\t';
			s+=nazv+'\t';
			s+=skill+'\t';
			if (lvl>0) s+=lvl+'\t';
			else if (tip==5 && variant>0) s+=(perslvl+7)+'\t';
			else s+=perslvl+'\t';
			if (damage>0) s+=damage;
			if (kol>1) s+=' [x'+kol+']';
			if (this.damageExpl>0) s+='('+damageExpl+' взр) ';
			s += '\t';
			s += Number(30/rapid).toFixed(1)+'\t';
			s += Number((damage+damageExpl)*kol*30/rapid).toFixed(1)+'\t';
			s += Res.pipText('tipdam'+tipDamage)+'\t';
			s += Math.round(critCh*100)+'%\t';
			s += Math.round(precision/40)+'\t';
			s += pier+'\t';
			if (tip==5) s+='магия\t'+mana+'\t';
			else {
				if (ammo == '') {
                    s += '\t';
                } else s += Res.txt('i', ammo) + '\t';
				if (holder > 0) {
					s += holder;
					if (rashod > 1) s += ' (-' + rashod + ')';
				}
				s += '\t';
			}
			s += satsCons;
			if (satsQue > 1) s += ' [x' + satsQue + ']';
			s += '\t';
			if (opt && opt.perk) s += Res.txt('e', opt.perk);
			s += '\t';
			if (tip < 4) s += maxhp + '\t';
			else s += '\t';
			if (tip == 4) s += getWeaponInfo(id).@price + '\t';
			else if (tip != 5 && variant > 0) s += price * 3 + '\t';
			else s += price + '\t';
			return s;
		}
	}	
}
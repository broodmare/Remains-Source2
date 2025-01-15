package fe.weapon {

	import flash.geom.Point;
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
		
		public static var weaponPerks:Array		= ['pistol', 'shot', 'commando', 'rifle', 'perf', 'laser', 'plasma', 'pyro', 'acute', 'stunning']
		public static var variant2:String		= ' - II';
		
		public var b:Bullet;
		public var trasser:Trasser;
		public var owner:Unit;	// TODO: REMOVE
		public var rot:Number;
		public var bulCoords:Vector2 = new Vector2(0, 0);
		
		//[visual]
		public var svis:String;
		public var svisv:String;					// [The weapon itself]
		
		public var vWeapon:Class;
		public var visbul:String;					// [Shells]
		public var vBullet:Class;
		public var flare:String;					// [Flash]
		public var visexpl:String;					// [Explosion]
		
		public var is_attack:Boolean	= false;	// [If the attack key pressed]
		public var is_pattack:Boolean	= false;	
		
		// Timers
		public var t_attack:int			= 0;
		public var t_prep:int			= 0;
		public var t_reload:int			= 0;
		public var t_rech:int			= 0;
		public var t_rel:int			= 0;		// [Reload time for weapons without a magazine]
		public var t_shoot:int			= 0;		// [Time after shot]
		public var t_auto:int			= 0;
		
		public var pow:int				= 0;		//усиление атаки
		public var skillConf:Number		= 1.00;		//модификатор, зависит от соответствия уровня скилла, 1 - норм, 0.8 - скилл на 1 уровень ниже, 0.6 - скилл на 2 уровня ниже
		public var skillPlusDam:Number	= 1.00;		//усиление оружия низких уровней;
		public var weaponSkill:Number	= 1.00;		//умение для гг
		private var t_ret:int			= 0;
		private var rotUp:Number		= 0.00;
		public var jammed:Boolean		= false;	//заклинило
		public var kol_shoot:int		= 0;		//количество сделанных выстрелов
		public var ready:Boolean		= false;	//оружие наведено на цель
		public var is_shoot:Boolean		= false;	// [shot fired]
		public var animated:Boolean	= false;
		
		public var krep:int	= 0;					// [fastening type]
		public var hold:int	= 0;					// [left in the clip]

		public var findCel:Boolean		= true;		// [turn to target]
		public var forceRot:Number		= 0.00;
		public var fixRot:int			= 0;	
		public var checkLine:Boolean	= false;	

		public var id:String;
		public var uniq:Number			= -1.00;	// [Probability of a unique variant appearing]
		public var variant:Boolean		= false;	// This weapon is a unique version of a base weapon
		
		// [Characteristics]
		// [Weapon type]
		// 0 - [Internal]					-> "internal"
		// 1 - [Cryo(?)]					-> "cryo"
		// 2 - [Light guns]					-> "lightGun"
		// 3 - [Heavy gun]					-> "heavyGun"
		// 4 - [Explosives]					-> "explosives"
		// 5 - magic						-> "magic"
		public var tip:String = "";			// Changed from int to String

		// [category]
		public var cat:int				= 0;
		
		// [Inventory]
		public var respect:int			= 0;		// [Relation 0 - new, 1 - hidden, 2 - used, 3 - scheme]
		
		// [Required skill]
		public var skill:int			= 0;
		
		// [Skill level]
		public var lvl:int				= 0;
		public var lvlNoUse:Boolean		= false;	// [Prohibit use if skill is not sufficient]
		public var perslvl:int			= 0;
		public var spell:Boolean		= false;	// [Is a protective spell]
		public var alicorn:Boolean		= false;	// [Available in alicorn mode]
		public var rep_eff:Number		= 1.00;		// [Repair efficiency with a gunsmith's kit]
		
		public var auto:Boolean			= false;	// [automatic attack]
		public var rapid:int			= 5;		// [cycles per shot, 30 = 1s]
		public var speed:Number			= 100.00;	// [bullet speed]
		public var volna:Boolean		= false;	// [if true, then the bullet speed will not be random]
		public var deviation:Number		= 0;		// Weapon dispersion
		public var precision:Number		= 0;		// [accuracy, shows the distance at which the hit will be 100%]
		public var antiprec:Number		= 0;		// [for sniper rifles, shows the distance at which accuracy will begin to decrease]

		public var dlina:int			= 50;		// [Bladed weapon length]
		public var mindlina:int			= 50;			
		
		public var mass:int				= 1;		// [Takes place (uses inventory space?)]
		public var drot:Number			= 0.00;		// [weapon rotation speed, 0 - instant]
		public var drot2:Number			= 0.00;		// [weapon rotation speed when attacking]
		public var prep:int				= 0;		// [cycles for promotion]
		
		public var explRadius:Number	= 0.00;		// [Explosion radius, if 0, then there is no explosion]
		public var explTip:int			= 1;		// [Explosion type, 1-normal, 2-gas cloud]
		public var explKol:int			= 0;		// [Number of explosions, interval 1s, 0 - instant explosion]
		public var destroy:Number		= 10.00;	// [Block damage]
		public var damage:Number		= 0.00;		// [Damage to units]
		public var damageExpl:Number	= 0.00;		// [Area damage]
		public var tipDamage:String		= "";		// [Damage type]
		public var pier:Number			= 0.00;		// [armor-piercing]
		public var critCh:Number		= 0.10;		// [crit chance]
		public var critM:Number			= 0.00;		// [extra crit]
		public var critDamPlus:Number	= 0.00;		// [Increase to critical damage modifier]
		public var distExpl:Boolean		= false;	// [bullets explode as time passes]
		public var navod:Number			= 0.00;		// [homing]

		public var otbros:Number		= 0.00;		// [garbage]
		public var kol:int				= 1;		// [number of bullets per shot]
		public var dkol:int				= 0;		// [burst shooting]
		public var rashod:int			= 1;		// [charges per shot]
		public var opt:Object			= {};		// [options]
		public var recoil:int			= 0;		// [recoil back]
		public var recoilUp:int			= 0;		// [recoil up]
		public var recoilMult:int		= 1;		// [recoil multiplier]
		public var desintegr:Number		= 0.00;		// [probability of disintegration]
		
		public var holder:int			= 0;		// Rounds in the magazine
		public var ammoBase:String		= "";		// ID of the weapon's default ammo
		public var ammo:String			= "";		// ID o fthe weapon's current ammo
		public var ammoTarg:String		= "";		// [Type of ammunition to replace]
		public var reload:int			= 0;		// [reload cycles, 30 = 1s]
		public var recharg:int			= 0;		// [cycles for recharging if applicable, 0 if not]
		public var magic:Number			= 100.00;
		public var dmagic:Number		= 100.00;	// [magic consumption]
		public var mana:Number			= 100.00;
		public var dmana:Number			= 100.00;	// [mana consumption]

		public var noise:int			= 0;		// [sound of a gunshot]
		public var shine:int			= 500;		// [flash from a shot]
		public var tipDecal:int			= 0;		// [type of traces left (Bullet hole/scorch marks)]
		public var bulAnim:Boolean		= false;	// [animate the projectile]
		public var spring:int			= 1;		// [stretching]
		public var flame:int			= 0;		// [the projectile behaves like fire]
		public var grav:Number			= 0.00;		// [the projectile moves in a parabola]
		public var accel:Number			= 0.00;		// [the projectile moves with acceleration]
		public var shell:Boolean		= false;	// [throws out the cartridge case]
		public var fromWall:Boolean		= false;	// [shoot from the wall]
		public var bulBlend:String		= "screen";
		private var emitShell:Emitter	= Emitter.arr["gilza"];
		
		// [additional effects] (usually called 'DOP')
		public var dopEffect:String;				// [Effect]
		public var dopDamage:Number		= 0.00;		// [Damage]
		public var dopCh:Number			= 1.00;		// [Chance]
		public var probiv:Number		= 0.00;
		public var visionMult:Number	= 1.00;		// [user visibility multiplier]
		
		// [Modifiers]
		public var drotMult:Number		= 1.00;
		public var reloadMult:Number	= 1.00;
		
		public var precMult:Number		= 1.00;
		public var consMult:Number		= 1.00;
		public var damMult:Number		= 1.00;
		public var damAdd:Number		= 0.00;
		public var pierAdd:Number		= 0.00;
		public var critchAdd:Number		= 0.00;
		public var speedMult:Number		= 1.00;
		public var otbrosMult:Number	= 1.00;
		public var explRadMult:Number	= 1.00;
		public var devMult:Number		= 1.00;
		
		public var absPierRnd:Number	= 0.00;
		
		// [Cartridge modifiers]
		public var ammoPier:Number		= 0.00;	// [armor-piercing]
		public var ammoArmor:Number		= 1.00;	// [target's armor modifier]
		public var ammoDamage:Number	= 1.00;	// [damage]
		public var ammoProbiv:Number	= 0.00;	// [punching through the target]
		public var ammoOtbros:Number	= 1.00;	// [discarding]
		public var ammoPrec:Number		= 1.00;	// [precision]
		public var ammoHP:int			= 0;	// [increase in wear]
		public var ammoFire:Number		= 0.00;	// [incendiary]
		public var ammoMod:int			= -1;	// [change damage type]
		
		
		// SATS
		public var satsQue:int			= 1;
		public var satsCons:Number		= 10.00;
		public var noSats:Boolean		= false;	// [Do not support]
		public var noPerc:Boolean		= false;	// [Do not calculate accuracy]
		public var noTrass:Boolean		= false;	// [Do not trace]
		public var satsMelee:Boolean	= false;
		
		// Sounds
		public var sndShoot:String		= "";
		public var sndReload:String		= "";
		public var sndPrep:String		= "";
		public var sndHit:String		= "";
		public var snd_t_prep1:int		= 0;
		public var snd_t_prep2:int		= 0;
		public var sndCh:SoundChannel;
		
		public var hp:int;
		public var maxhp:int			= 100;
		public var price:int			= 0;
		public var breaking:Number		= 0.00;

		// Constructor
		public function Weapon() {
			
		}
		
		public override function step():void {
			actions();
			
			if (owner) {
				owner.setWeaponPos(tip);
			}
			
			if (vis) {
				animate();
			}
		}

		public override function addVisual():void {
			if (owner) {
				loc = owner.loc;
			}
			else {
				loc = World.w.loc;
			}
			
			super.addVisual();	// Obj.addVisual()
			
			if (owner && tip != "magic" && owner.cTransform) {
				vis.transform.colorTransform = owner.cTransform;
			}
		}
		
		public function addVisual2():void {
			if (tip == "magic" && vis) {
				World.w.grafon.visObjs[sloy].addChild(vis);
			}
		}
		

		/*public override function setNull(f:Boolean = false):void {
			if (owner) {
				coordinates.X = owner.weaponX;
				coordinates.Y = owner.weaponY;
				animate();
			}
		}*/
		
		public function setPers(gg:UnitPlayer, pers:Pers):void {
  			weaponSkill = pers.weaponSkills[skill];
			
			if (pers.desintegr > 0) {
				desintegr = pers.desintegr;
			}
			
			if (tip != "magic") {
				drotMult = pers.drotMult;
			}
			
			reloadMult = pers.reloadMult;
			precMult = pers.allPrecMult;
			recoilMult = pers.recoilMult;
			consMult = 1;
			damMult = pers.allDamMult;
			
			if (skill == 2 || skill == 3 || skill == 4) {
				damMult *= pers.gunsDamMult;
			}
			
			var razn:int = lvl - pers.getWeapLevel(skill);
			if (razn < 0) {
				skillPlusDam = 1.00 - razn * 0.10;
			}
			else {
				skillPlusDam = 1.00;
			}
			
			speedMult	= 1.00;
			damAdd		= 0.00;
			pierAdd		= 0.00;
			critchAdd	= 0.00;
			otbrosMult	= 1.00;
			devMult		= 1.00;
			
			for each(var wp:String in weaponPerks) {
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
						dopEffect = 'stun';
						dopDamage = pers[wp + 'Stun'];
						dopCh = 1.00;
					}
				}
			}
			
			absPierRnd = pers.modTarget;
			explRadMult = pers.explRadMult;
		}
		
		public function actions():void {
			var rot2:Number;
			if (owner == null) {
				return;
			}

			if (coordinates.X < owner.celX) {
				storona = 1;
			}
			else {
				storona = -1;
			}

			// This turns the weapon to face the curosr and is executed every tick.
			if (findCel) {
				if (tip == "magic") {
					coordinates.X = owner.magicX;
					coordinates.Y = owner.magicY;
					rot2 = Math.atan2(owner.celY - coordinates.Y, owner.celX - coordinates.X);
				}
				else if (krep > 0 || !coordinates.X) {
					coordinates.X = owner.weaponX;
					coordinates.Y = owner.weaponY;
					rot2 = Math.atan2(owner.celY - coordinates.Y, Math.abs(owner.celX - coordinates.X)*owner.storona);
				}
				else {
					coordinates.X += (owner.weaponX - coordinates.X) * 0.20;
					coordinates.Y += (owner.weaponY - coordinates.Y) * 0.20;
					rot2 = Math.atan2(owner.celY - coordinates.Y, owner.celX - coordinates.X);
				}
			}
			else {
				coordinates.X = owner.weaponX;
				coordinates.Y = owner.weaponY;
				rot2 = forceRot;
			}

			ready = false;
			
			var rdrot:Number = drot;
			
			if (drot2 > 0 && (t_prep > 0 || t_attack > 0)) {
				rdrot = drot2;
			}
			
			if (rdrot == 0) {
				rot = rot2;
				ready = true;
			}
			else {
				if (Math.abs(rot - rot2) > Math.PI) {
					if (Math.abs(rot - rot2) > Math.PI * 2 - rdrot * drotMult) {
						rot = rot2;
						ready = true;
					}
					else if (rot > rot2) {
						rot += rdrot * drotMult;
					}
					else {
						rot -= rdrot * drotMult;
					}
				}
				else {
					if (rot2 - rot > rdrot * drotMult) {
						rot += rdrot * drotMult;
					}
					else if (rot2 - rot < -rdrot * drotMult) {
						rot -= rdrot * drotMult;
					}
					else {
						rot = rot2;
						ready = true;
					}
				}
				
				if (rot > Math.PI) {
					rot -= Math.PI * 2;
				}
				
				if (rot <- Math.PI) {
					rot += Math.PI * 2;
				}
			}
			
			if (fixRot == 1) {
				if (rot < -Math.PI / 6 && rot > -Math.PI / 2) {
					rot = -Math.PI / 6;
				}
				if (rot > -Math.PI * 5 / 6 && rot <= -Math.PI/2) {
					rot = -Math.PI * 5 / 6;
				}
			}
			
			if (fixRot == 2) {
				if (rot < -Math.PI / 6) rot = -Math.PI / 6;
				if (rot >  Math.PI / 6) rot =  Math.PI / 6;
			}
			
			if (fixRot == 3) {
				if (rot > 0 && rot <   Math.PI * 5 / 6) {
					rot =  Math.PI * 5 / 6;
				}
				if (rot <= 0 && rot > -Math.PI * 5 / 6) {
					rot = -Math.PI * 5 / 6;
				}
			}

			try {
				if (dkol <= 0 && t_attack == rapid) {
					shoot();
				}
				if (dkol > 0 && t_attack > rapid && t_attack % rapid == 0) {
					shoot();
				}
			}
			catch (err) {
				trace("ERROR: (00:12)");
			}

			if (t_attack > 0) {
				t_attack--;
			}
			
			if (t_rel > 0) {
				t_rel--;
			}
			
			if (t_ret > 0) {
				t_ret--;
			}
			
			if (rotUp > 5) {
				rotUp *= 0.9;
			}
			else if (rotUp > 0.5) {
				rotUp -= 0.5;
			}
			else {
				rotUp = 0;
			}
			
			if (t_prep > 0) {
				t_prep--;
			}
			else {
				kol_shoot = 0;
			}
			
			if (t_auto > 0) {
				t_auto--;
			}
			else {
				pow = 0;
			}
			
			if (t_shoot > 0) {
				t_shoot--;
			}
			
			if (sndPrep != '') {
				if (!is_pattack && is_attack) {
					sndCh = Snd.ps(sndPrep, coordinates.X, coordinates.Y, t_prep * 30);
				}	// [spin sound]
				
				if (snd_t_prep1 > 0 && is_attack && sndCh != null && sndCh.position > snd_t_prep2 - 300) {
					sndCh.stop();
					sndCh = Snd.ps(sndPrep, coordinates.X, coordinates.Y, snd_t_prep1 + 200);
				}	// [continuation sound]
				
				if (snd_t_prep2 > 0 && is_pattack && !is_attack && t_prep > 0 && sndCh != null && sndCh.position < snd_t_prep2 - 400) {
					sndCh.stop();
					sndCh = Snd.ps(sndPrep, coordinates.X, coordinates.Y, snd_t_prep2 + 100);
				}	// [stop sound]
			}
			
			if (recharg && hold < holder && t_attack == 0) {
				t_rech--;
				if (t_rech <= 0) {
					hold++;
					t_rech = recharg;
					if (owner.player) {
						World.w.gui.setWeapon();
					}
				}
			}
			
			if (t_attack == 0 && t_reload > 0) {
				t_reload--;
			}
			
			if (t_reload == Math.round(10 * reloadMult)) {
				reloadWeapon();
			}
			
			is_pattack = is_attack;
			is_attack = false;
		}

		public function attack(waitReady:Boolean = false):Boolean {
			if (waitReady && !ready) {
				return false;
			}
			
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
			
			skillConf = 1.00;
			
			if (owner.player && !checkAvail()) {
				return false;
			}
			
			if (holder > 0 && hold < rashod) { // [requires recharging]
				initReload();
				return false;
			}
			
			weaponAttack();
			
			is_attack = true;
			
			if (t_prep < prep + 10) {
				t_prep += 2;
			}
			
			if (t_prep >= prep && t_attack <= 0 && t_reload <= 0) {
				if (dkol <= 0) {
					t_attack = rapid;
				}
				else {
					t_attack = rapid * (dkol + 1);
				}

				if (holder == 1) {
					initReload();
				}
			
			}
			
			return true;
		}
		
		protected function weaponAttack():void {
			if (jammed) {
				if (tipDamage == "laser" || tipDamage == "plasma" || tipDamage == "emp" || tipDamage == "electric") {
					World.w.gui.infoText('weaponCircuit', null, null, false);
				}
				else {
					World.w.gui.infoText('weaponJammed', null, null, false);
				}
				
				Snd.ps('no_ammo', coordinates.X, coordinates.Y);
				initReload();
				
				return;
			}
			
			if (hp < maxhp * 0.50) {
				breaking = (maxhp - hp) / maxhp * 2 - 1;
			}
			else {
				breaking = 0.00;
			}
		}
		
		protected function checkAvail():Boolean {
			var razn:int = lvl-(owner as UnitPlayer).pers.getWeapLevel(skill);
			
			if (razn == 1) {
				skillConf = 0.8;
			}
			else if (razn == 2) {
				skillConf = 0.6;
			}
			else if (razn > 2) {
				World.w.gui.infoText('weaponSkillLevel', null, null, false);
				return false;
			}
			
			if (perslvl && (owner as UnitPlayer).pers.level < perslvl) {
				World.w.gui.infoText('persLevel', null, null, false);
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
					var p:Point = new Point(vis.emit.x, vis.emit.y);
					var p1:Point = vis.localToGlobal(p);
					p1 = vis.parent.globalToLocal(p1);
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
				var jm:Number = (owner as UnitPlayer).pers.jammedMult;
				
				if (rnd < breaking / Math.max(20, holder) * jm) {
					t_ret = 2;
					jammed = true;
					return null;
				}
				else if (rnd < breaking / 5 * jm) {
					t_ret = 2;
					
					if (rapid > 5) {
						World.w.gui.infoText('misfire', null, null, false);
					}
					
					Snd.ps('no_ammo', coordinates.X, coordinates.Y);
					return null;
				}
			}

			if (holder > 0 && hold < rashod) {
				return null;
			}
			
			var sk:int = 1;
			
			if (owner) {
				sk = owner.weaponSkill;
				
				if (owner.player) {
					sk = weaponSkill;
				}
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
				
				if (b.vis) {
					b.vis.blendMode = bulBlend;
				}

				if (fromWall) {
					try {
						if (loc.getAbsTile(bulCoords.X, bulCoords.Y).phis) b.inWall = true;
					}
					catch(err) { 
						trace("ERROR: (00:14)");
					}
				}
				
				if (b.vis && spring == 3) {
					b.vis.gotoAndStop(i + 1);
				}
				
				b.rot = rot - rotUp * storona / 50 + r + (i - (kol - 1) / 2) * deviation * 3.1415 / 360;
			
				if (grav > 0 || volna) {
					b.vel = speed * speedMult;
				}
				else {
					b.vel = speed * speedMult * (Math.random() * 0.4 + 0.8);
				}
				
				b.velocity.X = Math.cos(b.rot) * b.vel;
				b.velocity.Y = Math.sin(b.rot) * b.vel;
				b.knockx = b.velocity.X / b.vel;
				b.knocky = b.velocity.Y / b.vel;
				
				if (owner && distExpl) {
					b.celX = owner.celX;
					b.celY = owner.celY;
				}
				
				if (damage > 0) {
					b.damage = resultDamage(damage, sk) * ammoDamage;
				}
				
				if (damageExpl > 0) {
					b.damageExpl = resultDamage(damageExpl, sk);
				}

				setBullet(b);
				
				b.miss = 1 - skillConf;
				b.ddy = b.ddx = 0;
				
				if (desintegr) {
					b.desintegr = desintegr;
				}
				
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
					}
					else if (flame == 2) {
						b.ddy += -0.2 - Math.random() * 0.2;
						b.brakeR = 100 + Math.random() * 40;
					}
					
					b.liv = b.brakeR / 7;
				}
				
				if (grav) {
					b.ddy += World.ddy * grav;
					b.vRot = true;
				}
				
				if (bulAnim) {
					b.vis.play();
				}
			}
			
			if (shell) {
				emitShell.cast(loc, coordinates.X, coordinates.Y, {dx:-10*vis.scaleX, dy:-10, dr:-15*vis.scaleX});
			}
			
			// [shot visibility]
			if (owner.demask < shine) {
				owner.demask = shine;
			}
			
			if (noise > 0) {
				owner.makeNoise(noise, true);
			}
			
			owner.isShoot = true;
			
			if (holder > 0 && hold > 0) {
				if (owner.player && (owner as UnitPlayer).pers.recyc > 0 && (ammo == "batt" || ammo == "energ" || ammo == "crystal") && Math.random() < (owner as UnitPlayer).pers.recyc) {
					// [don't waste ammunition]
				}
				else {
					hold -= rashod;
					// [replenishment at the landfill]
					if (owner.player && (loc.train) && ammo != "recharg" && ammo != "not") {
						World.w.invent.increaseQuantity(ammo, rashod);
						//World.w.invent.mass[2] += World.w.invent.items[ammo].mass * rashod;
					}
				}
			}
			
			if (owner.player && tip != "internal" && tip != "explosives" && tip != "magic" && !(loc.train || World.w.alicorn)) {
				hp -= (1 + ammoHP);
			}
			
			if (animated && t_shoot <= 1) {
				try {
					vis.gotoAndPlay('shoot');
				}
				catch (err) {
					trace("ERROR: (00:15) - weapon: " + id + "\" held by: \"" + owner.id + "\" Could not play movieclip \"shoot\"!");
				}
				
				t_shoot = 3;
			}
			
			kol_shoot++;
			t_ret = Math.round(recoil * recoilMult);
			
			if (recoil > 3 && t_ret < 3) {
				t_ret = 3;
			}
			
			rotUp += recoilUp * recoilMult;
			is_shoot = true;
			
			t_auto = 3;
			
			return b;
		}
		
		// [Resulting damage]
		public function resultDamage(dam0:Number, sk:Number = 1):Number {
			return (dam0 + damAdd) * damMult * sk * skillPlusDam * (1 - breaking * 0.3);
		}

		// [Resulting range]
		public function resultPrec(pm:Number = 1, sk:Number = 1):Number {
			return precision * precMult * (1 + (sk - 1) * 0.5) * pm * owner.precMultCont;
		}

		// Resulting attack time
		public function resultRapid(rap0:Number, sk:Number = 1):Number {
			return rap0;
		}
		
		public function setTrass(gr:Graphics):void {
			var rot3:Number = Math.atan2(World.w.celY - coordinates.Y, World.w.celX - coordinates.X);
			
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
			if (checkLine) {
				return owner.loc.isLine(coordinates.X, coordinates.Y, cx, cy);
			}
			
			return true;
		}
		
		protected function setBullet(bul:Bullet):void {
			bul.tipDamage = tipDamage;
			bul.tipDecal = tipDecal;
			bul.otbros = otbros * otbrosMult * ammoOtbros;
			bul.pier = pier + pierAdd + ammoPier;
			bul.armorMult = ammoArmor;
			bul.destroy = destroy;
			bul.precision = precision * ammoPrec;
			bul.explTip = explTip;
			bul.explRadius = explRadius * explRadMult;
			bul.explKol = explKol;
			bul.spring = spring;
			bul.flare = flare;
			bul.probiv = probiv + ammoProbiv;
			
			if (bul.probiv > 1) {
				bul.probiv = 1;
			}
			
			/*
			if (ammoMod >= 0) {
				bul.tipDamage = ammoMod;
				
				if (ammoMod == 8) {
					bul.destroy = 0;
					bul.otbros = 0;
				}
			}
			*/ // BROKEN FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME 

			if (owner) {
				bul.critCh=critCh+owner.critCh+critchAdd;
				bul.critInvis=owner.critInvis;
				bul.critDamMult=owner.critDamMult+critDamPlus;
				bul.critM=critM;
			}
			
			if (absPierRnd > 0 && Math.random() < absPierRnd * critCh) {
				bul.pier = 1000;
			}
		}
		
		public function reloadWeapon():void {
			jammed = false;
			
			if (ammo == 'recharg') {
				return;
			}
			
			if (owner && owner.player && ammo != 'not') {
				if (ammoTarg != ammo) {
					if (hold > 0) {
						World.w.invent.increaseQuantity(ammo, hold);
						//World.w.invent.mass[2] += World.w.invent.items[ammo].mass * hold;
						hold = 0;
					}
					
					setAmmo(ammoTarg);
				}
				
				var kol:int = World.w.invent.getQuantity(ammo);
				
				if (kol > holder - hold) {
					kol = holder-hold;
				}
				
				hold += kol;
				World.w.invent.decreaseQuantity(ammo, kol);
				//World.w.invent.mass[2] -= World.w.invent.items[ammo].mass * kol;
			}
			else {
				if (ammoTarg != ammo) {
					setAmmo(ammoTarg);
				}
				
				hold = holder;
			}
		}
		
		// [Set the type of ammunition used]
		public function setAmmo(nammo:String = null):void {
			ammo = nammo;

			if (owner && owner.player && World.w.gui) {
				World.w.gui.setWeapon();
			}
			
			ammoPier	=  0.00;		// [Armor-piercing]
			ammoArmor	=  1.00;		// [Target's armor modifier]
			ammoDamage	=  1.00;		// [Damage]
			ammoProbiv	=  0.00;
			ammoOtbros	=  1.00;		// [Discarding]
			ammoPrec	=  1.00;		// [Accuracy]
			ammoHP		=  0.00;		// [Increase in wear]
			ammoFire	=  0.00;		// [Incendiary]
			ammoMod		= -1.00;		// [Change damage type]
			
			var ammoData:Object = ItemManager.reference.getItem(nammo);
			
			if ("pier" in ammoData) {
				ammoPier = ammoData.pier;
			}
			if ("armor" in ammoData) {
				ammoArmor = ammoData.armor;
			}
			if ("damage" in ammoData) {
				ammoDamage = ammoData.damage;
			}
			if ("probiv" in ammoData) {
				ammoProbiv = ammoData.probiv;
			}
			if ("knock" in ammoData) {
				ammoOtbros = ammoData.knock;
			}
			if ("prec" in ammoData) {
				ammoPrec = ammoData.prec;
			}
			if ("det" in ammoData) {
				ammoHP = ammoData.det;
			}
			if ("fire" in ammoData) {
				ammoFire = ammoData.fire;
			}
			if ("tipdam" in ammoData) {
				ammoMod = ammoData.tipdam;
			}
		}
		
		public function unloadWeapon():void {
			if (owner && owner.player && holder && hold && ammo!='' && ammo != "recharg" && ammo != "not") {
				World.w.gui.infoText('unloadWeapon', nazv, null, false);
				(owner as UnitPlayer).invent.increaseQuantity(ammo, hold);
				//World.w.invent.mass[2] += World.w.invent.items[ammo].mass * hold;
				hold = 0;
				
				if (sndReload != "") {
					Snd.ps(sndReload, coordinates.X, coordinates.Y);
				}
			}
		}
		
		//[0-ready to fire, 1-shooting, 2-empty, 3-reloading, 4-out of ammo, 5-broken, 6-out of mana]
		public function status():int {
			if (hp <= 0) {
				return 5;
			}
			
			if (jammed) {
				return 2;
			}
			
			if (ammo != 'recharg' && ammo != 'not' && holder > 0 && hold < rashod) {
				if (World.w.invent.getQuantity(ammo) < rashod) {
					return 4;
				}
				
				return 2;
			}
			
			if (dmagic > owner.mana && owner.mana < owner.maxmana * 0.99) {
				return 6;
			}
			
			if (t_attack > 0) {
				return 1;
			}
			
			if (t_reload > 0) {
				return 3;
			}
			
			return 0;
		}
		
		//[Availability for use]
		public function avail():int {
			if (hp <= 0) {
				return -2;
			}
			
			if (perslvl && (owner as UnitPlayer).pers.level < perslvl) {
				return -1;
			}
			
			var razn:int = lvl-(owner as UnitPlayer).pers.getWeapLevel(skill);
			
			if (World.w.weaponsLevelsOff && (razn>2 || lvlNoUse && razn>0)) {
				return -1;
			}
			
			if (ammo != 'recharg' && ammo != 'not' && holder > 0 && World.w.invent.getQuantity(ammo) < rashod) {
				return 0;
			}
			
			return 1;
		}
		
		public function repair(nhp:int):void {
			hp += nhp;
			
			if (hp > maxhp) {
				hp = maxhp;
			}
		}
		
		public function crash(dam:int=1):void {
			
		}

		public function initReload(nammo:String = ""):void {
			if (!jammed && (holder <= 0 || (hold == holder && nammo == "") || recharg > 0)) {
				return;
			}
			
			if (nammo == "") {
				ammoTarg = ammo;
			}
			
			if (owner.player) {
				// unsuitable ammunition
				
				/*
				if (nammo != "" && nammo != ammo) {
					var am:XML = getAmmoInfo(nammo);
					
					if (am.length() == 0) {
						return;
					}
					
					if (am.@base != ammoBase) {
						World.w.gui.infoText('imprAmmo', ItemManager.reference.getItem(nammo).nazv, null, false);
						World.w.gui.bulb(coordinates.X, coordinates.Y);
						return;
					}
					
					ammoTarg = nammo;
				}
				*/ // BROKEN FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME 
				
				if (nammo != "" && nammo == ammo) {
					ammoTarg = nammo;
				}
				
				if (!jammed && ammo != 'not' && World.w.invent.getQuantity(ammoTarg) < rashod) {
					World.w.gui.infoText('noAmmo', ItemManager.reference.getItem(ammoTarg).nazv, null, false);
					World.w.gui.bulb(coordinates.X, coordinates.Y);
					return;
				}
			}
			
			if (t_reload <= 0 || reload == 0) {
				if (reload > 0) {
					t_reload = Math.round(reload * reloadMult);
					
					if (animated) {
						try {
							vis.gotoAndPlay('reload');
						}
						catch (err) {
							trace("ERROR: (00:16) - weapon: " + id + "\" held by: \"" + owner.id + "\" Could not play movieclip \"reload\"!");
						}
					}
					if (sndReload != "") {
						Snd.ps(sndReload, coordinates.X, coordinates.Y);
					}
				}
				else {
					reloadWeapon();
				}
			}
		}

		public function detonator():Boolean {
			return false;
		}

		public function animate():void {
			if (!vis) {
				return;
			}
			
			vis.x = coordinates.X - t_ret * vis.scaleX * 2;
			vis.y = coordinates.Y;
			
			if (prep && t_shoot <= 0) {
				if (t_prep < prep && t_prep > 1) {
					vis.gotoAndStop(t_prep);
				}
				
				if (t_prep >= prep) {
					try {
						if (tip != "internal") vis.gotoAndStop('ready'); // Don't try to animate internal weapons
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
			var s:String = "";
			s += id;
			
			if (variant>0) {
				s += '^' + variant;
			}
			
			s += '\t';
			s += nazv + '\t';
			s += skill + '\t';
			
			if (lvl > 0) {
				s += lvl + '\t';
			}
			else if (tip == "magic" && variant > 0) {
				s += (perslvl + 7) + '\t';
			}
			else {
				s += perslvl + '\t';
			}
			
			if (damage > 0) {
				s += damage;
			}
			
			if (kol > 1) {
				s += ' [x' + kol + ']';
			}
			
			if (this.damageExpl > 0) {
				s += '(' + damageExpl + ' взр) ';
			}
			
			s += '\t';
			s += Number(30 / rapid).toFixed(1) + '\t';
			s += Number((damage + damageExpl) * kol * 30 / rapid).toFixed(1) + '\t';
			s += LanguageManager.reference.localText("pip", 'tipdam' + tipDamage) + '\t';
			s += Math.round(critCh * 100) + '%\t';
			s += Math.round(precision / 40) + '\t';
			s += pier + '\t';
			
			if (tip == "magic") {
				s += 'магия\t'+mana+'\t';
			}
			else {
				if (ammo == '') {
                    s += '\t';
                }
				else {
					s += Res.txt('i', ammo) + '\t';
				}
				
				if (holder > 0) {
					s += holder;
					
					if (rashod > 1) {
						s += ' (-' + rashod + ')';
					}
				}
				
				s += '\t';
			}
			
			s += satsCons;
			
			if (satsQue > 1) {
				s += ' [x' + satsQue + ']';
			}
			
			s += '\t';
			
			if (opt && opt.perk) {
				s += Res.txt('e', opt.perk);
			}
			
			s += '\t';
			
			if (tip != "explosives" && tip != "magic") {
				s += maxhp + '\t';
			}
			else {
				s += '\t';
			}
			
			if (tip == "explosives") {
				s += WeaponManager.reference.weaponData(id).price + '\t';
			}
			else if (tip != "magic" && variant > 0) {
				s += price * 3 + '\t';
			}
			else {
				s += price + '\t';
			}
			
			return s;
		}
	}	
}
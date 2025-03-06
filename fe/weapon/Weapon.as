package fe.weapon {

	import flash.geom.Point;
	import flash.media.SoundChannel;
	import flash.display.Graphics;
	
	import fe.*;
	import fe.util.Vector2;
	import fe.entities.Obj;
	import fe.unit.Unit;
	import fe.unit.Resistances;
	import fe.unit.UnitPlayer;
	import fe.graph.Emitter;
	import fe.unit.Pers;
	import fe.projectile.Bullet;
	import fe.projectile.Trasser;
	import fe.projectile.SmartBullet;

	public class Weapon extends Obj {

		public static const WEP_INACTIVE:int = 0, WEP_LOCKED:int = 1, WEP_ACTIVE:int = 2, WEP_BLUEPRINT:int = 3;
		public static const TYPE_INTERNAL:String = "internal", TYPE_MELEE:String = "melee", TYPE_LIGHTGUN:String = "lightGun", TYPE_HEAVYGUN:String = "heavyGun", TYPE_EXPLOSIVES:String = "explosives", TYPE_MAGIC:String = "magic";

		public static var weaponPerks:Array		= ["pistol", "shot", "commando", "rifle", "perf", "laser", "plasma", "pyro", "acute", "stunning"]
		public static var variant2:String		= " - II";
		
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
		public var t_ret:int			= 0;
		public var rotUp:Number			= 0.00;
		public var jammed:Boolean		= false;	//заклинило
		public var kol_shoot:int		= 0;		//количество сделанных выстрелов
		public var ready:Boolean		= false;	//оружие наведено на цель
		public var is_shoot:Boolean		= false;	// [shot fired]
		public var animated:Boolean		= false;

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
		// 1 - [Cryo(?)]					-> "cryo"   (Cold steel??????)
		// 2 - [Light guns]					-> "lightGun"
		// 3 - [Heavy gun]					-> "heavyGun"
		// 4 - [Explosives]					-> "explosives"
		// 5 - magic						-> "magic"
		public var tip:String = "";			// Changed from int to String

		// [category]
		public var cat:int				= 0;
		
		// [Inventory]
		public var respect:int			= 0;		// [ 0 - INACTIVE, 1 - LOCKED, 2 - EQUIPED, 3 - BLUEPRINT (Not crafted yet)
		
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
		public var deviation:Number		= 0.00;		// Weapon dispersion
		public var precision:Number		= 0.00;		// [accuracy, shows the distance at which the hit will be 100%]
		public var antiprec:Number		= 0.00;		// [for sniper rifles, shows the distance at which accuracy will begin to decrease]

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
		
		public var fixedToOwner:Boolean	= false;	// True means the weapon is attached to the unit's position and follows its rotation. False means the weapon moves dynamically, chasing the cursor or target.
		public var magazineRounds:int	= 0;		// [left in the clip]
		public var magazineCapacity:int	= 0;		// Rounds in the magazine

		public var ammoBase:Ammo;					// ID of the weapon's default ammo
		public var ammo:Ammo;						// ID o fthe weapon's current ammo
		public var ammoTarg:Ammo;					// [Type of ammunition to replace]
		
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
		public var emitShell:Emitter	= Emitter.arr["gilza"];
		
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
			
			if (owner && tip != TYPE_MAGIC && owner.cTransform) {
				vis.transform.colorTransform = owner.cTransform;
			}
		}
		
		public function addVisual2():void {
			if (tip == TYPE_MAGIC && vis) {
				World.w.grafon.visObjs[sloy].addChild(vis);
			}
		}

		public override function setNull(f:Boolean = false):void {
			if (owner) {
				coordinates.X = owner.weaponX;
				coordinates.Y = owner.weaponY;
				animate();
			}
		}
		
		public function setPers(gg:UnitPlayer, pers:Pers):void {
  			weaponSkill = pers.weaponSkills[skill];
			
			if (pers.desintegr > 0) {
				desintegr = pers.desintegr;
			}
			
			if (tip != TYPE_MAGIC) {
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
					if (pers.hasOwnProperty(wp + "Prec")) precMult *= pers[wp + "Prec"];
					if (pers.hasOwnProperty(wp + "Cons")) consMult *= pers[wp + "Cons"];
					if (pers.hasOwnProperty(wp + "Dam")) damMult *= pers[wp + "Dam"];
					if (pers.hasOwnProperty(wp + "Speed")) speedMult *= pers[wp + "Speed"];
					if (pers.hasOwnProperty(wp + "Det")) damAdd += pers[wp + "Det"];
					if (pers.hasOwnProperty(wp + "Pier")) pierAdd += pers[wp + "Pier"];
					if (pers.hasOwnProperty(wp + "Critch")) critchAdd += pers[wp + "Critch"];
					if (pers.hasOwnProperty(wp + "Knock")) otbrosMult *= pers[wp + "Knock"];
					if (pers.hasOwnProperty(wp + "Dev")) devMult *= pers[wp + "Dev"];
					if (pers.hasOwnProperty(wp + "Stun")) {
						dopEffect = "stun";
						dopDamage = pers[wp + "Stun"];
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

			// Determine if facing right or left
			storona = (coordinates.X < owner.celX) ? 1 : -1;

			// Update weapon coordinates and calculate rotation
			if (findCel) {
				if (tip == TYPE_MAGIC) {
					coordinates.X = owner.magicX;
					coordinates.Y = owner.magicY;
					rot2 = Math.atan2(owner.celY - coordinates.Y, owner.celX - coordinates.X);
				}
				else if (fixedToOwner || coordinates.X == 0) {
					coordinates.X = owner.weaponX;
					coordinates.Y = owner.weaponY;
					rot2 = Math.atan2(owner.celY - coordinates.Y, Math.abs(owner.celX - coordinates.X) * storona);
				}
				else {
					// Smoothly interpolate weapon position towards the owner's weapon position
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
			
			var rdrot:Number = (drot2 > 0 && (t_prep > 0 || t_attack > 0)) ? drot2 : drot;

			if (rdrot == 0) {
				rot = rot2;
				ready = true;
			}
			else {
				var rotDifference:Number = Math.abs(rot - rot2);
				
				if (rotDifference > ONE_PI) {
					if (rotDifference > TWO_PI - rdrot * drotMult) {
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

				// Normalize rotation to be within [-PI, PI]
				if (rot > ONE_PI) {
					rot -= TWO_PI;
				}
				if (rot < -ONE_PI) {
					rot += TWO_PI;
				}
			}
			
			// Apply rotation fixes using precomputed constants
			switch(fixRot) {
				case 1:
					if (rot < NEGATIVE_SIXTH_PI && rot > NEGATIVE_HALF_PI) {
						rot = NEGATIVE_SIXTH_PI;
					}
					if (rot > NEGATIVE_FIVE_SIXTH_PI && rot <= NEGATIVE_HALF_PI) {
						rot = NEGATIVE_FIVE_SIXTH_PI;
					}
					break;
				
				case 2:
					if (rot < NEGATIVE_SIXTH_PI) {
						rot = NEGATIVE_SIXTH_PI;
					}
					if (rot > SIXTH_PI) {
						rot = SIXTH_PI;
					}
					break;
				
				case 3:
					if (rot > 0 && rot < POSITIVE_FIVE_SIXTH_PI) {
						rot = POSITIVE_FIVE_SIXTH_PI;
					}
					if (rot <= 0 && rot > NEGATIVE_FIVE_SIXTH_PI) {
						rot = NEGATIVE_FIVE_SIXTH_PI;
					}
					break;
			}

			try {
				if ((dkol <= 0 && t_attack == rapid) ||
					(dkol > 0 && t_attack > rapid && t_attack % rapid == 0)) {
					shoot();
				}
			}
			catch (err:Error) {
				trace("ERROR: (00:12)");
			}

			// Decrement timers
			if (t_attack > 0) t_attack--;
			if (t_rel > 0) t_rel--;
			if (t_ret > 0) t_ret--;

			// Smooth rotation adjustments
			if (rotUp > 5) {
				rotUp *= 0.9;
			}
			else if (rotUp > 0.5) {
				rotUp -= 0.5;
			}
			else {
				rotUp = 0;
			}

			// Handle preparation and shooting
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

			// Handle sounds with precomputed positions and delays
			if (sndPrep != "") {
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
			
			// Handle recharging logic
			if (recharg && magazineRounds < magazineCapacity && t_attack == 0) {
				t_rech--;
				if (t_rech <= 0) {
					magazineCapacity++;
					t_rech = recharg;
					if (owner.player) {
						World.w.gui.setWeapon();
					}
				}
			}
			
			// Handle reloading logic
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
				World.w.gui.infoText("brokenWeapon", nazv, null, false);
				World.w.gui.bulb(coordinates.X, coordinates.Y);
				return false;
			}
			
			if (owner.player && (respect == WEP_LOCKED || alicorn && !World.w.alicorn)) {
				World.w.gui.infoText("disWeapon", null, null, false);
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
			
			if (magazineCapacity > 0 && magazineCapacity < rashod) { // [requires recharging]
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

				if (magazineCapacity == 1) {
					initReload();
				}
			
			}
			
			return true;
		}
		
		protected function weaponAttack():void {
			if (jammed) {
				if (tipDamage == Resistances.DAM_LASER || tipDamage == Resistances.DAM_PLASMA || tipDamage == Resistances.DAM_EMP || tipDamage == Resistances.DAM_ELECTRIC) {
					World.w.gui.infoText("weaponCircuit", null, null, false);
				}
				else {
					World.w.gui.infoText("weaponJammed", null, null, false);
				}
				
				Snd.ps("no_ammo", coordinates.X, coordinates.Y);
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
				World.w.gui.infoText("weaponSkillLevel", null, null, false);
				return false;
			}
			
			if (perslvl && (owner as UnitPlayer).pers.level < perslvl) {
				World.w.gui.infoText("persLevel", null, null, false);
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
				
				if (rnd < breaking / Math.max(20, magazineCapacity) * jm) {
					t_ret = 2;
					jammed = true;
					return null;
				}
				else if (rnd < breaking / 5 * jm) {
					t_ret = 2;
					
					if (rapid > 5) {
						World.w.gui.infoText("misfire", null, null, false);
					}
					
					Snd.ps("no_ammo", coordinates.X, coordinates.Y);
					return null;
				}
			}

			if (magazineCapacity > 0 && magazineCapacity < rashod) {
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
					b.damage = resultDamage(damage, sk) * ammo.damageMultiplier;
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
			
			if (magazineCapacity > 0 && magazineCapacity > 0) {
				if (owner.player && (owner as UnitPlayer).pers.recyc > 0 && (ammo.id == "batt" || ammo.id == "energ" || ammo.id == "crystal") && Math.random() < (owner as UnitPlayer).pers.recyc) {
					// [don't waste ammunition]
				}
				else {
					magazineRounds -= rashod;
					// [replenishment at the landfill]
					if (owner.player && (loc.train) && ammo.id != "recharg" && ammo.id != "not") {
						World.w.invent.increaseQuantity(ammo.id, rashod);
						//World.w.invent.mass[2] += World.w.invent.items[ammo].mass * rashod;
					}
				}
			}
			
			if (owner.player && tip != "internal" && tip != TYPE_EXPLOSIVES && tip != TYPE_MAGIC && !(loc.train || World.w.alicorn)) {
				hp -= (1 + ammo.increasedWear);
			}
			
			if (animated && t_shoot <= 1) {
				try {
					vis.gotoAndPlay("shoot");
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
			bul.otbros = otbros * otbrosMult * ammo.knockback;
			bul.pier = pier + pierAdd + ammo.piercing;
			bul.armorMult = ammo.armorMultiplier;
			bul.destroy = destroy;
			bul.precision = precision * ammo.accuracyModifier;
			bul.explTip = explTip;
			bul.explRadius = explRadius * explRadMult;
			bul.explKol = explKol;
			bul.spring = spring;
			bul.flare = flare;
			bul.probiv = probiv + ammo.penetrationModifier;
			
			if (bul.probiv > 1) {
				bul.probiv = 1;
			}
			if (ammo.damageType != "") {
				bul.tipDamage = ammo.damageType;
				
				if (ammo.damageType == Resistances.DAM_EMP) {
					bul.destroy = 0;
					bul.otbros = 0;
				}
			}

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
			// Unjam the waepon if applicable
			jammed = false;
			
			// Rechargeable weapons can't reload, abort
			if (ammo.id == "recharg") {
				return;
			}
			
			if (owner && owner.player && ammo.id != "not") {
				if (ammoTarg.id != ammo.id) {
					if (magazineCapacity > 0) {
						World.w.invent.increaseQuantity(ammo.id, magazineCapacity);
						//World.w.invent.mass[2] += World.w.invent.items[ammo].mass * magazineCapacity;
						magazineRounds = 0;
					}
					
					setAmmo(ammoTarg.id);
				}
				
				var kol:int = World.w.invent.getQuantity(ammo.id);
				
				if (kol > magazineCapacity - magazineRounds) {
					kol = magazineCapacity-magazineRounds;
				}
				
				magazineCapacity += kol;
				World.w.invent.decreaseQuantity(ammo.id, kol);
				//World.w.invent.mass[2] -= World.w.invent.items[ammo].mass * kol;
			}
			else {
				if (ammoTarg != ammo) {
					setAmmo(ammoTarg.id);
				}
				
				magazineCapacity = magazineCapacity;
			}
		}
		
		// [Set the type of ammunition used]
		public function setAmmo(id:String):void {
			ammo = WeaponManager.reference.getAmmo(id);

			if (owner && owner.player && World.w.gui) {
				World.w.gui.setWeapon();
			}
		}
		
		public function unloadWeapon():void {
			if (owner && owner.player && magazineCapacity && magazineCapacity && ammo.id != "" && ammo.id != "recharg" && ammo.id != "not") {
				World.w.gui.infoText("unloadWeapon", nazv, null, false);
				(owner as UnitPlayer).invent.increaseQuantity(ammo.id, magazineCapacity);
				//World.w.invent.mass[2] += World.w.invent.items[ammo].mass * magazineCapacity;
				magazineRounds = 0;
				
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
			
			if (ammo.id != "recharg" && ammo.id != "not" && magazineCapacity > 0 && magazineCapacity < rashod) {
				if (World.w.invent.getQuantity(ammo.id) < rashod) {
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
			
			if (ammo.id != "recharg" && ammo.id != "not" && magazineCapacity > 0 && World.w.invent.getQuantity(ammo.id) < rashod) {
				return 0;
			}
			
			return 1;
		}
		
		// ??? 
		public function crash(dam:int=1):void {
			// Maybe used by sub-classes??? 
		}

		public function initReload(s:String = ""):void {
			if (!jammed && (magazineCapacity <= 0 || (magazineCapacity == magazineCapacity && s == "") || recharg > 0)) {
				return;
			}
			
			// Reload using the same ammo
			if (s == "") {
				ammoTarg = ammo;
			}
			
			if (owner.player) {
				// Reloading using ammunition different than our current ammunition
				if (s != "" && s != ammo.id) {
					var am:Ammo = WeaponManager.reference.getAmmo(s);
					
					// The base ammo type does not match, abort
					if (am.base != ammo.base) {
						World.w.gui.infoText("imprAmmo", am.name, null, false);
						World.w.gui.bulb(coordinates.X, coordinates.Y);
						return;
					}
					
					ammoTarg = am;
				}

				// We're reloading using the same ammo
				if (s != "" && s == ammo.id) {
					ammoTarg = ammo;
				}
				
				// The required ammo is missing from inventory
				if (!jammed && ammo.id != "not" && World.w.invent.getQuantity(ammoTarg.id) < rashod) {
					World.w.gui.infoText("noAmmo", ammoTarg.name, null, false);
					World.w.gui.bulb(coordinates.X, coordinates.Y);
					return;
				}
			}
			
			if (t_reload <= 0 || reload == 0) {
				if (reload > 0) {
					// Set the time to reload in frames
					t_reload = Math.round(reload * reloadMult);
					
					// Play the reload animation
					if (animated) {
						try {
							vis.gotoAndPlay("reload");
						}
						catch (err) {
							trace("ERROR: (00:16) - weapon: " + id + "\" held by: \"" + owner.id + "\" Could not play movieclip \"reload\"!");
						}
					}
					
					// Play the reload sound (if applicable)
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
						if (tip != "internal") {
							vis.gotoAndStop("ready"); // Don't try to animate internal weapons
						}
					}
					catch(err) {
						trace("ERROR: (00:17) - weapon: " + id + "\" held by: \"" + owner.id + "\" Could not play movieclip \"ready\"!");
					}
				}
				
				if (t_prep<=1 && t_reload == 0) {
					vis.gotoAndStop(1);
				}
			}
			
			if (!fixedToOwner) {
				if (coordinates.X > owner.celX) {
					vis.scaleX = -1;
					vis.rotation = rot * RAD_TO_DEG + 180 + rotUp;
				}
				
				if (coordinates.X < owner.celX) {
					vis.scaleX = 1;
					vis.rotation = rot * RAD_TO_DEG - rotUp;
				}
			}
			else {
				vis.scaleX = owner.storona;
				vis.rotation = rot * RAD_TO_DEG + 90 * (1 - owner.storona) - rotUp * storona;
			}
		}
		
		public function write():String {
			var s:String = "";
			s += id;
			
			s += "\t";
			s += nazv + "\t";
			s += skill + "\t";
			
			if (lvl > 0) {
				s += lvl + "\t";
			}
			else if (tip == TYPE_MAGIC && variant) {
				s += (perslvl + 7) + "\t";
			}
			else {
				s += perslvl + "\t";
			}
			
			if (damage > 0) {
				s += damage;
			}
			
			if (kol > 1) {
				s += " [x" + kol + "]";
			}
			
			if (damageExpl > 0) {
				s += "(" + damageExpl + " взр) ";
			}
			
			s += "\t";
			s += Number(30 / rapid).toFixed(1) + "\t";
			s += Number((damage + damageExpl) * kol * 30 / rapid).toFixed(1) + "\t";
			s += LanguageManager.reference.localText("pip", "tipdam" + tipDamage) + "\t";
			s += Math.round(critCh * 100) + "%\t";
			s += Math.round(precision / 40) + "\t";
			s += pier + "\t";
			
			if (tip == TYPE_MAGIC) {
				s += "магия\t" + mana + "\t";
			}
			else {
				if (!ammo) {
                    s += "\t";
                }
				else {
					s += ammo.name + "\t";
				}
				
				if (magazineCapacity > 0) {
					s += magazineCapacity;
					
					if (rashod > 1) {
						s += " (-" + rashod + ")";
					}
				}
				
				s += "\t";
			}
			
			s += satsCons;
			
			if (satsQue > 1) {
				s += " [x" + satsQue + "]";
			}
			
			s += "\t";
			
			if (opt && opt.perk) {
				s += Res.txt("e", opt.perk);
			}
			
			s += "\t";
			
			if (tip != TYPE_EXPLOSIVES && tip != TYPE_MAGIC) {
				s += maxhp + "\t";
			}
			else {
				s += "\t";
			}
			
			if (tip == TYPE_EXPLOSIVES) {
				s += WeaponManager.reference.weaponData(id).price + "\t";
			}
			else if (tip != TYPE_MAGIC && variant > 0) {
				s += price * 3 + "\t";
			}
			else {
				s += price + "\t";
			}
			
			return s;
		}
	}	
}
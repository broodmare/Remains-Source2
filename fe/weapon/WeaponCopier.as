package fe.weapon {

	public class WeaponCopier {

		/*
		**	Temporary awful workaround. Currently this subclass needs information from it's ammo, but ammo is now a real item and assigned when a weapon is constructed,
		**	This lets us use all the default values from the weapon we constructed and then continue to build the subclass.
		*/
		public static function copyFrom(weaponFrom:Weapon, weaponTo:Weapon):void {
			weaponTo.b = weaponFrom.b;
			weaponTo.trasser = weaponFrom.trasser;
			weaponTo.owner = weaponFrom.owner;
			weaponTo.rot = weaponFrom.rot;
			weaponTo.bulCoords = weaponFrom.bulCoords;
			
			// Visual properties
			weaponTo.vis = weaponFrom.vis;			// Weapon sprite
			weaponTo.svis = weaponFrom.svis;
			weaponTo.svisv = weaponFrom.svisv;
			weaponTo.vWeapon = weaponFrom.vWeapon;
			weaponTo.visbul = weaponFrom.visbul;
			weaponTo.vBullet = weaponFrom.vBullet;
			weaponTo.flare = weaponFrom.flare;
			weaponTo.visexpl = weaponFrom.visexpl;
			
			// State flags
			weaponTo.is_attack = weaponFrom.is_attack;
			weaponTo.is_pattack = weaponFrom.is_pattack;
			
			// Timers
			weaponTo.t_attack = weaponFrom.t_attack;
			weaponTo.t_prep = weaponFrom.t_prep;
			weaponTo.t_reload = weaponFrom.t_reload;
			weaponTo.t_rech = weaponFrom.t_rech;
			weaponTo.t_rel = weaponFrom.t_rel;
			weaponTo.t_shoot = weaponFrom.t_shoot;
			weaponTo.t_auto = weaponFrom.t_auto;
			weaponTo.t_ret = weaponFrom.t_ret;
			
			// Attributes
			weaponTo.pow = weaponFrom.pow;
			weaponTo.skillConf = weaponFrom.skillConf;
			weaponTo.skillPlusDam = weaponFrom.skillPlusDam;
			weaponTo.weaponSkill = weaponFrom.weaponSkill;
			weaponTo.rotUp = weaponFrom.rotUp;
			weaponTo.jammed = weaponFrom.jammed;
			weaponTo.kol_shoot = weaponFrom.kol_shoot;
			weaponTo.ready = weaponFrom.ready;
			weaponTo.is_shoot = weaponFrom.is_shoot;
			weaponTo.animated = weaponFrom.animated;
			
			// Targeting
			weaponTo.findCel = weaponFrom.findCel;
			weaponTo.forceRot = weaponFrom.forceRot;
			weaponTo.fixRot = weaponFrom.fixRot;
			weaponTo.checkLine = weaponFrom.checkLine;
			
			// Identification
			weaponTo.id = weaponFrom.id;
			weaponTo.uniq = weaponFrom.uniq;
			weaponTo.variant = weaponFrom.variant;
			
			// Characteristics
			weaponTo.tip = weaponFrom.tip;
			weaponTo.cat = weaponFrom.cat;
			weaponTo.respect = weaponFrom.respect;
			weaponTo.skill = weaponFrom.skill;
			weaponTo.lvl = weaponFrom.lvl;
			weaponTo.lvlNoUse = weaponFrom.lvlNoUse;
			weaponTo.perslvl = weaponFrom.perslvl;
			weaponTo.spell = weaponFrom.spell;
			weaponTo.alicorn = weaponFrom.alicorn;
			weaponTo.rep_eff = weaponFrom.rep_eff;
			
			// Combat properties
			weaponTo.auto = weaponFrom.auto;
			weaponTo.rapid = weaponFrom.rapid;
			weaponTo.speed = weaponFrom.speed;
			weaponTo.volna = weaponFrom.volna;
			weaponTo.deviation = weaponFrom.deviation;
			weaponTo.precision = weaponFrom.precision;
			weaponTo.antiprec = weaponFrom.antiprec;
			
			// Physical properties
			weaponTo.dlina = weaponFrom.dlina;
			weaponTo.mindlina = weaponFrom.mindlina;
			weaponTo.mass = weaponFrom.mass;
			weaponTo.drot = weaponFrom.drot;
			weaponTo.drot2 = weaponFrom.drot2;
			weaponTo.prep = weaponFrom.prep;
			
			// Damage and effects
			weaponTo.explRadius = weaponFrom.explRadius;
			weaponTo.explTip = weaponFrom.explTip;
			weaponTo.explKol = weaponFrom.explKol;
			weaponTo.destroy = weaponFrom.destroy;
			weaponTo.damage = weaponFrom.damage;
			weaponTo.damageExpl = weaponFrom.damageExpl;
			weaponTo.tipDamage = weaponFrom.tipDamage;
			weaponTo.pier = weaponFrom.pier;
			weaponTo.critCh = weaponFrom.critCh;
			weaponTo.critM = weaponFrom.critM;
			weaponTo.critDamPlus = weaponFrom.critDamPlus;
			weaponTo.distExpl = weaponFrom.distExpl;
			weaponTo.navod = weaponFrom.navod;
			
			// Additional properties
			weaponTo.otbros = weaponFrom.otbros;
			weaponTo.kol = weaponFrom.kol;
			weaponTo.dkol = weaponFrom.dkol;
			weaponTo.rashod = weaponFrom.rashod;
			weaponTo.opt = weaponFrom.opt;
			weaponTo.recoil = weaponFrom.recoil;
			weaponTo.recoilUp = weaponFrom.recoilUp;
			weaponTo.recoilMult = weaponFrom.recoilMult;
			weaponTo.desintegr = weaponFrom.desintegr;
			
			// Attachment and ammo
			weaponTo.fixedToOwner = weaponFrom.fixedToOwner;
			weaponTo.magazineRounds = weaponFrom.magazineRounds;
			weaponTo.magazineCapacity = weaponFrom.magazineCapacity;
			weaponTo.ammoBase = weaponFrom.ammoBase;
			weaponTo.ammo = weaponFrom.ammo;
			weaponTo.ammoTarg = weaponFrom.ammoTarg;
			
			// Reload and magic
			weaponTo.reload = weaponFrom.reload;
			weaponTo.recharg = weaponFrom.recharg;
			weaponTo.magic = weaponFrom.magic;
			weaponTo.dmagic = weaponFrom.dmagic;
			weaponTo.mana = weaponFrom.mana;
			weaponTo.dmana = weaponFrom.dmana;
			
			// Audio and visuals
			weaponTo.noise = weaponFrom.noise;
			weaponTo.shine = weaponFrom.shine;
			weaponTo.tipDecal = weaponFrom.tipDecal;
			weaponTo.bulAnim = weaponFrom.bulAnim;
			weaponTo.spring = weaponFrom.spring;
			weaponTo.flame = weaponFrom.flame;
			weaponTo.grav = weaponFrom.grav;
			weaponTo.accel = weaponFrom.accel;
			weaponTo.shell = weaponFrom.shell;
			weaponTo.fromWall = weaponFrom.fromWall;
			weaponTo.bulBlend = weaponFrom.bulBlend;
			weaponTo.emitShell = weaponFrom.emitShell;
			
			// Additional effects
			weaponTo.dopEffect = weaponFrom.dopEffect;
			weaponTo.dopDamage = weaponFrom.dopDamage;
			weaponTo.dopCh = weaponFrom.dopCh;
			weaponTo.probiv = weaponFrom.probiv;
			weaponTo.visionMult = weaponFrom.visionMult;
			
			// Modifiers
			weaponTo.drotMult = weaponFrom.drotMult;
			weaponTo.reloadMult = weaponFrom.reloadMult;
			weaponTo.precMult = weaponFrom.precMult;
			weaponTo.consMult = weaponFrom.consMult;
			weaponTo.damMult = weaponFrom.damMult;
			weaponTo.damAdd = weaponFrom.damAdd;
			weaponTo.pierAdd = weaponFrom.pierAdd;
			weaponTo.critchAdd = weaponFrom.critchAdd;
			weaponTo.speedMult = weaponFrom.speedMult;
			weaponTo.otbrosMult = weaponFrom.otbrosMult;
			weaponTo.explRadMult = weaponFrom.explRadMult;
			weaponTo.devMult = weaponFrom.devMult;
			weaponTo.absPierRnd = weaponFrom.absPierRnd;
			
			// SATS properties
			weaponTo.satsQue = weaponFrom.satsQue;
			weaponTo.satsCons = weaponFrom.satsCons;
			weaponTo.noSats = weaponFrom.noSats;
			weaponTo.noPerc = weaponFrom.noPerc;
			weaponTo.noTrass = weaponFrom.noTrass;
			weaponTo.satsMelee = weaponFrom.satsMelee;
			
			// Sounds
			weaponTo.sndShoot = weaponFrom.sndShoot;
			weaponTo.sndReload = weaponFrom.sndReload;
			weaponTo.sndPrep = weaponFrom.sndPrep;
			weaponTo.sndHit = weaponFrom.sndHit;
			weaponTo.snd_t_prep1 = weaponFrom.snd_t_prep1;
			weaponTo.snd_t_prep2 = weaponFrom.snd_t_prep2;
			weaponTo.sndCh = weaponFrom.sndCh;
			
			// Health and pricing
			weaponTo.hp = weaponFrom.hp;
			weaponTo.maxhp = weaponFrom.maxhp;
			weaponTo.price = weaponFrom.price;
			weaponTo.breaking = weaponFrom.breaking;
		}
	}
}
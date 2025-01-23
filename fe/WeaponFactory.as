package fe {

	import flash.utils.getDefinitionByName;
	import flash.display.MovieClip;

	import fe.SymbolFactory;
	import fe.weapon.Weapon;
	import fe.projectile.Trasser;
	import fe.unit.Resistances;

	public class WeaponFactory {
		
		private static const DEG_TO_RAD:Number = Math.PI / 180;

		// Initialize a weapon using the data passed to this function (until it reaches the step that requires an Ammo item)
		public static function createWeaponPart1(data:Object):Weapon {
			var weapon:Weapon = new Weapon();

			weapon.sloy = 2;	// ???
			weapon.id = data.id;

			weapon.tip = data.tip;
			weapon.variant = data.variant;
			weapon.trasser = new Trasser();

			weapon.nazv = LanguageManager.reference.data.weapon.id;
			weapon.cat = data.cat;
			weapon.skill = data.skill;
			
			if ("perk" in data) {
				weapon.opt.perk = data.perk;
				weapon.opt[data.perk] = true;
			}
			
			weapon.lvl = data.lvl;
			weapon.perslvl = data.perslvl;

			if ("alicorn" in data) {
				weapon.alicorn = data.alicorn;
			}

			//SATS
			if ("sats_que" in data) {
				weapon.satsQue = data.sats_que;
			}
			if ("sats_cons" in data) {
				weapon.satsCons = data.sats_cons;
			}
			if ("sats_noSats" in data) {
				weapon.noSats = data.sats_noSats;
			}
			if ("sats_noperc" in data) {
				weapon.noPerc = data.sats_noperc;
			}
			
			// [Price and repair]
			if ("com_rep" in data) {
				weapon.rep_eff = data.com_rep;
			}
			if ("com_price" in data) {
				weapon.price = data.com_price;
			}
			if ("com_uniq" in data) {
				weapon.uniq = data.com_uniq;
			}
			
			// [Visual]
			weapon.svis = 'vis' + weapon.id;
			
			// Punch weapons don't have a visual sprite
			if (weapon.tip == "punch") {
				weapon.svisv = null;
			}
			else {
				weapon.svisv = weapon.svis;
			}
			
			// "vis" properties
			if ("vis_vweap" in data ) {
				weapon.svisv = data.vis_vweap;		// String
			}
			if ("vis_tipdec" in data ) {
				weapon.tipDecal = data.vis_tipdec;	// Int
			}
			if ("vis_shell" in data ) {
				weapon.shell = data.vis_shell;		// Boolean
			}
			if ("vis_spring" in data ) {
				weapon.spring = data.vis_spring;	// Int
			}
			if ("vis_bulanim" in data ) {
				weapon.bulAnim = data.vis_bulanim;	// Boolean
			}
			if ("vis_phisbul" in data ) {
				weapon.bulBlend = "normal";		// String | Custom string here! Don't change this
			}
			if ("vis_visexpl" in data ) {
				weapon.visexpl = data.vis_visexpl;	// String
			}
			if ("vis_shine" in data ) {
				weapon.shine = data.vis_shine;		// Int
			}
			if ("vis_vbul" in data ) {
				weapon.visbul = data.vis_vbul;		// String
			}
			if ("vis_flare" in data ) {
				weapon.flare = data.vis_flare;		// String
			}

			var create:Function = SymbolFactory.createInstance;
			var fetch:Function  = SymbolFactory.fetchSymbolClass;

			if (weapon.tip != "punch" || weapon.svisv) {
				// Tries to set the weapon visual movieclip as weapon.svisv, if that fails, weapon.svis, and finally visp10mm as a failsafe
				weapon.vWeapon = fetch("weapon.svisv") || fetch("weapon.svis") || fetch("visp10mm");
				
				// Create a new instance of the class we fetched
				weapon.vis = new (weapon.vWeapon)();
				(weapon.vis != null) ? trace("WeaponFactory.as/createWeaponPart1() - Retrieved vis for weapon: " + data.id + " svis: " + weapon.svis + " svisv: " + weapon.svisv)
									 : trace("WeaponFactory.as/createWeaponPart1() - Failed to retrieve vis for weapon: " + data.id + " svis: " + weapon.svis + " svisv: " + weapon.svisv);
			}
			
			if (weapon.vis && weapon.vis.totalFrames > 1) {
				weapon.animated = true;
			}
			
			if (weapon.flare == null) {
				weapon.flare = weapon.visbul;
			}
			
			if (weapon.visbul) { 
				try {
					weapon.vBullet = create("visbul" + String(weapon.visbul)) as Class;
				}
				catch (err:ReferenceError) {
					trace("ERROR: (00:11)");
					weapon.vBullet = create("visualBullet") as Class;
				}
			}
			else {
				weapon.vBullet = create("visualBullet") as Class;
			}
			
			// Sounds
			if ("snd_shoot" in data ) {
				weapon.sndShoot = data.snd_shoot;		// String
			}
			if ("snd_reload" in data ) {
				weapon.sndReload = data.snd_reload;		// String
			}
			if ("snd_hit" in data ) {
				weapon.sndHit = data.snd_hit;			// String
			}
			if ("snd_prep" in data ) {
				weapon.sndPrep = data.snd_prep;			// String
			}
			if ("snd_t1" in data ) {
				weapon.snd_t_prep1 = data.snd_t1;		// Int
			}
			if ("snd_t2" in data ) {
				weapon.snd_t_prep2 = data.snd_t2;		// Int
			}
			if ("snd_noise" in data ) {
				weapon.noise = data.snd_noise;			// Int
			}
			
			// [Physical parameters]
			if ("phis_massa" in data) {
				weapon.massa = data.phis_massa / 50
			}
			else {
				weapon.massa = 0;
			}
			if ("phis_m" in data ) {
				weapon.mass = data.phis_m;				// Int
			}
			if ("phis_drot" in data ) {
				weapon.drot = data.phis_drot * DEG_TO_RAD;
			}
			if ("phis_drot2" in data ) {
				weapon.drot2 = data.phis_drot2 * DEG_TO_RAD;
			}
			if ("phis_recoil" in data ) {
				weapon.recoil = data.phis_recoil;
			}
			if ("phis_speed" in data ) {
				weapon.speed = data.phis_speed;
			}
			if ("phis_deviation" in data ) {
				weapon.deviation = data.phis_deviation;
			}
			if ("phis_flame" in data ) {
				weapon.flame = data.phis_flame;
			}
			if ("phis_grav" in data ) {
				weapon.grav = data.phis_grav;
			}
			if ("phis_grav2" in data && weapon.owner && weapon.owner.fraction != 100) {	// ( != 100 means != player )
				weapon.grav = data.phis_grav2;
			}
			if ("phis_accel" in data ) {
				weapon.accel = data.phis_accel;
			}
			if ("phis_navod" in data ) {
				weapon.navod = data.phis_navod;
			}
			if ("phis_distexpl" in data ) {
				weapon.distExpl = data.phis_distexpl;
			}
			if ("phis_volna" in data ) {
				weapon.volna = data.phis_volna;
			}

			// Ammunition
			if ("ammo_holder" in data ) {
				weapon.magazineCapacity = data.ammo_holder;
			}
			if ("ammo_rashod" in data ) {
				weapon.rashod = data.ammo_rashod;
			}
			if ("ammo_reload" in data ) {
				weapon.reload = data.ammo_reload;
			}
			if ("ammo_recharg" in data ) {
				weapon.recharg = data.ammo_recharg;
			}
			if ("ammo_mana" in data ) {
				weapon.mana = data.ammo_mana;
				weapon.dmana = data.ammo_mana;
			}
			if ("ammo_magic" in data ) {
				weapon.magic = data.ammo_magic;
				weapon.dmagic = data.ammo_magic;
			}

			
			// [Additional effects (was called 'dop')]
			if ("dop_vision" in data ) {
				weapon.visionMult = data.dop_vision;
			}
			if ("dop_effect" in data ) {
				weapon.dopEffect = data.dop_effect;
			}
			if ("dop_damage" in data ) {
				weapon.dopDamage = data.dop_damage;
			}
			if ("dop_ch" in data ) {
				weapon.dopCh = data.dop_ch;
			}
			if ("dop_probiv" in data ) {
				weapon.probiv = data.dop_probiv;
			}

			return weapon;
		}

		// Continue creating the weapon after ammo has been added
		public static function createWeaponPart2(weapon:Weapon, data:Object):void {
			// [Combat characteristics]
			if ("char_maxhp" in data ) {
				weapon.maxhp = data.char_maxhp;
			}
			if ("char_damage" in data ) {
				weapon.damage = data.char_damage;
			}
			if ("char_damexpl" in data ) {
				weapon.damageExpl = data.char_damexpl;
			}
			if ("char_rapid" in data ) {
				weapon.rapid = data.char_rapid;
			}
			if ("char_pier" in data ) {
				weapon.pier = data.char_pier;
			}
			if ("char_crit" in data ) {
				weapon.critM = data.char_crit - 1;
				weapon.critCh = 0.1 * data.char_crit;
			}
			if ("char_critdam" in data ) {
				weapon.critDamPlus = data.char_critdam;
			}
			if ("char_knock" in data ) {
				weapon.otbros = data.char_knock;
			}
			if ("char_tipdam" in data ) {
				weapon.tipDamage = data.char_tipdam;
			}
			if ("char_prec" in data ) {
				weapon.precision = data.char_prec * 40;
			}
			if ("char_antiprec" in data ) {
				weapon.antiprec = data.char_antiprec * 40;
			}
			if ("char_destroy" in data ) {
				weapon.destroy = data.char_destroy;
			}
			if ("char_kol" in data ) {
				weapon.kol = data.char_kol;
			}
			if ("char_dkol" in data ) {
				weapon.dkol = data.char_dkol;
			}
			if ("char_expl" in data ) {
				weapon.explRadius = data.char_expl;
			}
			if ("char_expltip" in data ) {
				weapon.explTip = data.char_expltip;
			}
			if ("char_explkol" in data ) {
				weapon.explKol = data.char_explkol;
			}
			if ("char_prep" in data ) {
				weapon.prep = data.char_prep;
			}

			weapon.auto = (weapon.rapid <= 6);
			
			if ("char_auto" in data ) {
				weapon.auto = data.char_auto;	// Boolean
			}
			
			// End of accessing data

			weapon.recoilUp = weapon.recoil * 0.50;
			
			if (weapon.owner && !weapon.owner.player) {
				weapon.recoilUp *= 0.20;
			}
			
			weapon.t_rech = weapon.recharg;
			
			if (weapon.recharg) {
				weapon.magazineRounds = weapon.magazineCapacity;
			}
			
			weapon.hp = weapon.maxhp;
			
			if (weapon.owner && weapon.owner.player) {
				if (weapon.tipDamage == Resistances.DAM_PIERCE) {
					weapon.critDamPlus += 0.20;
				}
				
				if (weapon.tipDamage == Resistances.DAM_PLASMA) {
					weapon.critDamPlus -= 0.20;
				}
			}

			weapon.t_attack = 0;
			weapon.t_reload = 0;
		}
	}
}
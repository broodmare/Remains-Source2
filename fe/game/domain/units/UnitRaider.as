package fe.game.domain.units {

	import flash.filters.GlowFilter;

	import fe.game.WeaponManager;
	import fe.game.World;
	import fe.engine.text.XMLDataGrabber;
	import fe.game.domain.projectile.Bullet;
	import fe.game.domain.serv.AnimationSet;
	import fe.game.domain.serv.LootGen;
	import fe.game.domain.units.ai.Brain;
	import fe.game.domain.units.ai.Brain_Definition;
	import fe.game.domain.units.anim.Animator;
	import fe.game.domain.units.anim.Animator_Definition;
	import fe.game.domain.units.attack.BodyAttack;
	import fe.game.domain.units.attack.BodyAttack_Definition;
	import fe.game.domain.units.attack.GunAttack;
	import fe.game.domain.units.attack.GunAttack_Definition;
	import fe.game.domain.units.attack.WeaponAttack;
	import fe.game.domain.units.attack.WeaponAttack_Definition;
	import fe.game.domain.units.motor.FlyMotor;
	import fe.game.domain.units.motor.FlyMotor_Definition;
	import fe.game.domain.units.motor.WalkMotor;
	import fe.game.domain.units.motor.WalkMotor_Definition;
	import fe.engine.utils.Calc;
	import fe.game.domain.weapon.WThrow;
	import fe.game.domain.weapon.Weapon;
	import fe.game.domain.units.enums.E_AIState;
	import fe.game.enums.E_Direction;

	// Raiders, and the families built on them: slavers, zebras, rangers, Enclave soldiers and griffon mercenaries
	public class UnitRaider extends UnitPon {

		// How the unit fights (attackerType), picked from its weapon
		private static const UNARMED:int				= 0;		// Rams with its body
		private static const MELEE:int					= 1;		// Swings a levitated melee weapon
		private static const GUNNER:int					= 2;
		private static const GRENADIER:int				= 3;

		private static const WALKER_SPEED:Number		= 2.5;		// walkSpeed of raiders with a walking animation
		private static const SIT_SPEED:Number			= 0.5;		// Speeds as multiples of the speed in the unit's data
		private static const CLIMB_SPEED:Number			= 1.1;
		private static const RUN_SPEED:Number			= 2.0;
		private static const PATROL_ACCEL:Number		= 1.0 / 3.0;
		private static const TURN_DELAY_GROUND:int		= 5;		// Ticks between turns on the ground
		private static const TURN_DELAY_AIR:int			= 30;		// Ticks between turns off the ground
		private static const JUMP_BOOST:Number			= 2.0;
		private static const WALL_GIVE_UP:Number		= 0.1;
		private static const FLY_DODGE:Number			= 1.5;
		private static const CHATTER_CHANCE:Number		= 0.001;
		private static const ALERT_VISION:Number		= 1.5;		// Vision while alert, as a multiple of the calm vision
		private static const TARGET_MEMORY:int			= 6;
		private static const DRIFT_INTERVAL:int			= 5;
		private static const LEVIT_WAKE_SHOCK:int		= 45;
		private static const WAKE_RADIUS:Number			= 500.0;	// Allies woken when the unit turns on its target or is hurt
		private static const ALLIED_WAKE_RADIUS:Number	= 2000.0;	// The same for units with allLink
		private static const SMART_REAIM:Number			= 0.9;		// Chance to turn toward a target off to the side, durak or not
		private static const DURAK_REAIM:Number			= 0.5;
		private static const SURPRISE_SPREAD:int		= 19;		// The surprise lasts tupizna to tupizna + this, a quarter of tupizna up close
		private static const CHARGE_SPEED:Number		= 1.5;		// Chasing speed of body attackers, as a fraction of runSpeed
		private static const DASH_CHANCE:Number			= 0.3;

		// Gunners stand and shoot at a target seen within the last couple of looks inside aiDist, and leap back from one too close
		private static const HOLD_CHANCE:Number			= 0.7;
		private static const HOLD_ALERT_MARGIN:int		= 8;
		private static const BACK_OFF_RANGE:Number		= 200.0;
		private static const BACK_OFF_CHANCE:Number		= 0.6;

		// Melee fighters stand and swing while the target is inside their reach band
		private static const SWING_RANGE_MIN:Number		= 50.0;
		private static const SWING_RANGE_MAX:Number		= 100.0;
		private static const SWING_HEIGHT:Number		= 80.0;
		private static const SWING_HOLD_MIN:int			= 10;		// Ticks a melee fighter that doesn't move holds before deciding again
		private static const SWING_HOLD_MAX:int			= 19;
		private static const SWING_REACH:Number			= 120.0;	// The weapon reaches this far side to side
		private static const SWING_REACH_UP:Number		= 8.0;		// And this many times its rapid up and down
		private static const SWING_CHANCE:Number		= 0.3;

		private static const RAM_SLOW_SPEED:Number		= 8.0;		// A ram at or below this speed hits at RAM_SLOW_FACTOR
		private static const RAM_SLOW_FACTOR:Number		= 0.5;
		private static const BUMP_CHANCE:Number			= 0.1;		// Armed raiders now and then shove a target they touch
		private static const BUMP_RANGE:Number			= 100.0;
		private static const BUMP_STRENGTH:Number		= 0.5;
		private static const THROW_CHANCE:Number		= 0.02;

		// Dangers: grenades in sight, and mines the player is levitating
		private static const GRENADE_CHECK:int			= 10;		// Ticks between looks for grenades
		private static const GRENADE_CHECK_CHANCE:Number	= 0.2;
		private static const GRENADE_REPLIC_HASTE:int	= 20;		// How much sooner the unit may speak again after shouting about a grenade
		private static const MINE_CHECK:int				= 30;		// Ticks between looks for levitated mines
		private static const MINE_FLEE_RANGE:Number		= 400.0;
		private static const MINE_SUSPICION:int			= 8;		// aiSpok after seeing the player levitate something other than a mine
		private static const FLEE_TIME_MIN:int			= 20;
		private static const FLEE_TIME_MAX:int			= 84;
		private static const FLEE_SLACK:Number			= 30.0;		// A danger closer than this side to side doesn't decide the way to run

		private static const EMIT_COOLDOWN:int			= 300;		// Ticks between released vortices
		private static const BURST_MAGAZINE:int			= 10;		// Weapons with bigger magazines fire in bursts of half a magazine
		private static const ANTIPREC_DAMAGE:Number		= 0.8;		// Damage of weapons with antiprec in raider hands
		private static const DEATH_THROWS:int			= 3;		// Explosives a dying grenadier lets go of
		private static const DROP_SCATTER:Number		= 15.0;
		private static const VOLUME_FALLOFF:Number		= 8000.0;	// Distance over which the unit's sounds fade out
		private static const ACID_WEAR:Number			= 0.5;

		private var weap:String;					// ID of the weapon the unit was given, saved with it
		private var aiDist:int			= 1000;		// Gunners stand and shoot at targets inside this range
		private var stalkDist:int		= 500;		// Fliers hover once within this distance of the player
		private var aiAttackOch:int		= 0;		// Shots per burst, 0 for single shots
		private var emit_t:int			= 0;		// Ticks until the next vortex may be released
		private var plusObservOk:Boolean	= false;
		private var brainDefinition:Brain_Definition		= new Brain_Definition();
		private var walkDefinition:WalkMotor_Definition		= new WalkMotor_Definition();
		private var flyDefinition:FlyMotor_Definition		= new FlyMotor_Definition();
		private var ramDefinition:BodyAttack_Definition		= new BodyAttack_Definition();
		private var bumpDefinition:BodyAttack_Definition	= new BodyAttack_Definition();

		// Settings a subclass may change before calling this constructor
		protected var parentId:String;				// The family, such as "raider"; the unit's id is this plus its variant number
		protected var kolTrs:int		= 0;		// Variants in the family
		protected var flyer:Boolean		= false;	// Can fly
		protected var tupizna:int		= 40;		// Ticks a gunner stands surprised on seeing its target, a quarter of that for close fighters
		protected var durak:Boolean		= true;		// Runs about while alert instead of walking and taking aim
		protected var dash:Boolean		= false;	// Sometimes dashes at its target
		protected var allLink:Boolean	= false;	// Wakes allies further away
		protected var visionMult:Number	= 1.0;		// Vision while calm, raised by ALERT_VISION while alert

		// Settings from the unit's data, which a subclass may change after calling this constructor
		protected var walker:Boolean	= false;	// Has a walking animation, used while calm or holding
		protected var sniper:Boolean	= false;	// Fires bursts only at a target in sight
		protected var fearGrenade:Boolean	= true;	// Runs from grenades
		protected var stroll:Boolean	= true;		// Wanders while calm
		protected var moving:Boolean	= true;		// Leaves its post to chase
		protected var quiet:Boolean		= false;	// Doesn't talk to itself while calm
		protected var kol_emit:int		= 0;		// Vortices left to release on seeing the target
		protected var grenader:int		= 0;		// Grenades carried as a second weapon
		protected var isDropArm:Boolean	= true;		// Drops its weapon on death
		protected var enclWeap:Boolean	= false;	// Holds an Enclave weapon
		protected var dropW:String;					// Explosive dropped on death
		protected var dropWeapon:Weapon;
		protected var scrAlarmOn:Boolean	= true;	// The map's alarm script still starts on first sight
		protected var plusObserv:int	= 0;		// Observation gained once alarmed
		protected var wPos:Array;					// Weapon offsets per animation frame
		protected var attackerType:int	= 0;
		protected var gunDefinition:GunAttack_Definition		= new GunAttack_Definition();
		protected var animatorDefinition:Animator_Definition	= new Animator_Definition();

		// Whether the unit is in a state it attacks in
		protected function isAttacking():Boolean {
			return aiState == E_AIState.CHASE || aiState == E_AIState.HOLD || aiState == E_AIState.FLEE || aiState == E_AIState.DASH;
		}

		private function isCalm():Boolean {
			return aiState == E_AIState.IDLE || aiState == E_AIState.PATROL;
		}

		// Tune the brain, motor and attacks for how the unit fights
		private function arm():void {
			var isUnarmed:Boolean = attackerType == UNARMED;

			if (attackerType >= GUNNER) {
				brainDefinition.surpriseTimeMin = tupizna;
			}
			else {
				brainDefinition.surpriseTimeMin = int(tupizna * 0.25);
			}

			brainDefinition.surpriseTimeMax = brainDefinition.surpriseTimeMin + SURPRISE_SPREAD;
			brainDefinition.runsWhenAlert = !flyer && durak;
			brainDefinition.runsOnceSeen = !flyer && isUnarmed;
			brainDefinition.chaseSpeed = isUnarmed ? CHARGE_SPEED : 1.0;
			flyDefinition.stalkDistance = isUnarmed ? 0.0 : stalkDist;

			if (attackerType == GUNNER) {
				brainDefinition.holdChance = HOLD_CHANCE;
				brainDefinition.holdRange = aiDist;
				brainDefinition.holdAlertMargin = HOLD_ALERT_MARGIN;
				brainDefinition.backOffRange = BACK_OFF_RANGE;
				brainDefinition.backOffChance = BACK_OFF_CHANCE;
				walkDefinition.backpedals = weaponKrep;
			}

			if (attackerType == MELEE) {
				brainDefinition.holdTimeMin = SWING_HOLD_MIN;
				brainDefinition.holdTimeMax = SWING_HOLD_MAX;
				brainDefinition.closeHoldChance = 1.0;
				brainDefinition.closeRangeXMin = SWING_RANGE_MIN;
				brainDefinition.closeRangeX = SWING_RANGE_MAX;
				brainDefinition.closeRangeAbove = SWING_HEIGHT;
				brainDefinition.closeRangeBelow = SWING_HEIGHT;
				brainDefinition.closeHoldTimeMin = brainDefinition.alertTimeMin;
				brainDefinition.closeHoldTimeMax = brainDefinition.alertTimeMax;
				brainDefinition.closeHoldSearching = false;
				brainDefinition.closeHoldReleases = true;
			}

			// Body attackers ram in every fight; everyone else rams only when dashing, and shoves now and then
			ramDefinition.whileChasing = isUnarmed;
			ramDefinition.whileHolding = isUnarmed;
			ramDefinition.whileFleeing = isUnarmed;
			bumpDefinition.whileChasing = !isUnarmed;
			bumpDefinition.whileHolding = !isUnarmed;
			bumpDefinition.whileFleeing = !isUnarmed;
		}

		private function addAttacks():void {
			var swingDefinition:WeaponAttack_Definition = new WeaponAttack_Definition();
			var throwDefinition:WeaponAttack_Definition = new WeaponAttack_Definition();

			ramDefinition.rangeX = 0.0;
			ramDefinition.rangeY = 0.0;
			ramDefinition.slowSpeed = RAM_SLOW_SPEED;
			ramDefinition.slowFactor = RAM_SLOW_FACTOR;
			ramDefinition.whileDashing = true;
			attacks.push(new BodyAttack(this, ramDefinition));

			bumpDefinition.chance = BUMP_CHANCE;
			bumpDefinition.rangeX = (attackerType == MELEE) ? 0.0 : BUMP_RANGE;
			bumpDefinition.rangeY = bumpDefinition.rangeX;
			bumpDefinition.strength = (attackerType == GRENADIER) ? 1.0 : BUMP_STRENGTH;
			bumpDefinition.shockedStrength = bumpDefinition.strength;
			bumpDefinition.slowSpeed = (attackerType == GRENADIER) ? RAM_SLOW_SPEED : 0.0;
			bumpDefinition.slowFactor = RAM_SLOW_FACTOR;
			attacks.push(new BodyAttack(this, bumpDefinition));

			if (attackerType == MELEE) {
				swingDefinition.chance = SWING_CHANCE;
				swingDefinition.rangeX = SWING_REACH;
				swingDefinition.rangeY = currentWeapon.rapid * SWING_REACH_UP;
				swingDefinition.stopsWhenShocked = true;
				swingDefinition.whileChasing = true;
				swingDefinition.whileFleeing = true;
				attacks.push(new WeaponAttack(this, swingDefinition));
			}

			if (attackerType == GUNNER) {
				gunDefinition.burst = aiAttackOch;
				gunDefinition.isSniper = sniper;
				attacks.push(new GunAttack(this, gunDefinition));
			}

			if (attackerType == GRENADIER) {
				throwDefinition.chance = THROW_CHANCE;
				throwDefinition.needsTarget = true;
				throwDefinition.whileChasing = true;
				throwDefinition.whileFleeing = true;
				attacks.push(new WeaponAttack(this, throwDefinition));
			}
		}

		private function isOutOfGrenades():Boolean {
			var thrown:WThrow = currentWeapon as WThrow;

			return thrown != null && thrown.kolAmmo <= 0;
		}

		// Run from a danger dx away to one side
		private function flee(dx:Number):void {
			aiState = E_AIState.FLEE;
			aiSpok = maxSpok + brainDefinition.sightBonus;
			aiTCh = Calc.intBetween(FLEE_TIME_MIN, FLEE_TIME_MAX);

			if (dx > FLEE_SLACK) {
				aiNapr = E_Direction.LEFT;
			}

			if (dx < -FLEE_SLACK) {
				aiNapr = E_Direction.RIGHT;
			}
		}

		// The player is levitating something: run from a mine close by, shoot one further off, or just grow wary
		private function watchLevitation():void {
			var mine:Mine = loc.gg.teleObj as Mine;
			var dx:Number;
			var dy:Number;

			if (mine) {
				dx = mine.coordinates.X - coordinates.X;
				dy = mine.coordinates.Y - coordinates.Y + boundingBox.halfHeight;
				alarma();

				if (dx * dx + dy * dy < MINE_FLEE_RANGE * MINE_FLEE_RANGE) {
					flee(dx);
				}
				else {
					if (attackerType == GUNNER) {
						setCel(mine);
						aiState = E_AIState.HOLD;
					}

					aiSpok = maxSpok + brainDefinition.sightBonus;
					aiTCh = Calc.intBetween(FLEE_TIME_MIN, FLEE_TIME_MAX);
				}
			}
			else {
				aiSpok = MINE_SUSPICION;
			}

			replic("tele");
		}

		private function watchForDanger():void {
			var isGrenadeCheck:Boolean = fearGrenade && loc.warning > 0 && aiTCh % GRENADE_CHECK == 1;

			if (isGrenadeCheck && Math.random() < GRENADE_CHECK_CHANCE && findGrenades()) {
				t_replic -= GRENADE_REPLIC_HASTE;
				replic("grenade");
				flee(acelX - coordinates.X);
			}

			if (aiTCh % MINE_CHECK == 1 && levit == 0 && celUnit != loc.gg && findLevit()) {
				watchLevitation();
			}
		}

		// Aim just around its own feet, for dropping explosives on death
		private function aimAtFeet():void {
			var x:Number = coordinates.X + Calc.floatBetween(-DROP_SCATTER, DROP_SCATTER);
			var y:Number = coordinates.Y - Calc.floatBetween(0.0, DROP_SCATTER);

			setCel(null, x, y);
		}

		private function emit():void {
			var vortex:Unit = loc.createUnit("vortex", coordinates.X, coordinates.Y - boundingBox.halfHeight, true);

			vortex.fraction = fraction;
			vortex.detectionDelay = 0;
			emit_t = EMIT_COOLDOWN;
			kol_emit--;
		}

		protected override function control():void {
			if (emit_t > 0) {
				emit_t--;
			}

			if (sost != 3 && brain.isOn && World.w.enemyAct > 0) {
				watchForDanger();
			}

			super.control();

			// A grenadier out of grenades fights with its body
			if (attackerType == GRENADIER && isOutOfGrenades()) {
				attackerType = UNARMED;
				arm();
			}
		}

		public var tr:int = 1;		// Variant number within the family

		public function UnitRaider(cid:String = null, ndif:Number = 100.0, xml:XML = null, loadObj:Object = null) {
			var wm:WeaponManager = WeaponManager.reference;
			var tip:String;
			var walkMotor:WalkMotor;

			super(cid, ndif, xml, loadObj);

			if (parentId == null) {
				parentId = "raider";
			}

			if (kolTrs == 0) {
				kolTrs = 9;
			}

			tr = resolveVariant(cid, xml, loadObj, Calc.intBetween(1, kolTrs));
			if (tr <= 0) {
				tr = 1;
			}

			id = parentId + tr;
			getXmlParam();
			walkSpeed = walker ? WALKER_SPEED : maxSpeed;
			plavSpeed = maxSpeed;
			sitSpeed = maxSpeed * SIT_SPEED;
			lazSpeed = maxSpeed * CLIMB_SPEED;
			runSpeed = maxSpeed * RUN_SPEED;
			plavdy = accel;

			// The weapon comes from the save, then the map, then the unit's data
			if (loadObj && loadObj.weap) {
				if (loadObj.weap != "") {
					currentWeapon = wm.cloneWeapon(loadObj.weap);
				}
			}
			else if (xml && xml.@weap.length() > 0) {
				if (xml.@weap != "") {
					currentWeapon = wm.cloneWeapon(String(xml.@weap));
				}
			}
			else {
				currentWeapon = getXmlWeapon(ndif);
			}

			weap = "";
			if (currentWeapon) {
				wm.setOwner(currentWeapon, this);
				weap = currentWeapon.id;
				childObjs = [currentWeapon];
				currentWeapon.magazineRounds = currentWeapon.magazineCapacity;

				if (currentWeapon.antiprec > 0) {
					currentWeapon.damage *= ANTIPREC_DAMAGE;
				}
			}

			if (xml && xml.@emit.length() > 0) {
				kol_emit = int(xml.@emit);
			}

			if (xml && xml.@nodrop.length() > 0) {
				isDropArm = false;
			}

			if (dropW != null) {
				dropWeapon = wm.cloneWeapon(dropW);
				wm.setOwner(dropWeapon, this);
				dropWeapon.vis.visible = false;
				dropWeapon.vis.alpha = 0.0;
				childObjs.push(dropWeapon);
			}

			if (currentWeapon && currentWeapon.magazineCapacity > BURST_MAGAZINE && aiAttackOch == 0) {
				aiAttackOch = int(Math.round(currentWeapon.magazineCapacity * 0.5));
			}

			initBlit();
			animState = "stay";

			if (teleColor != 0) {
				teleFilter = new GlowFilter(teleColor, 1.0, 6.0, 6.0, 1.0, 3);
			}

			if (aiTip == "stay") {
				stroll = false;
			}

			if (aiTip == "quiet") {
				stroll = false;
				quiet = true;
			}

			if (aiTip == "sniper") {
				stroll = false;
				moving = false;
				weaponSkill = 2.0;
			}

			if (xml && xml.@fraction.length() > 0) {
				fraction = int(xml.@fraction);
				if (fraction == F_PLAYER) {
					warn = 0;
				}
			}

			weaponLevit();

			// Units with nothing, or a melee weapon held in their teeth, ram with their body
			tip = currentWeapon ? currentWeapon.tip : Weapon.TYPE_INTERNAL;
			if ((tip == Weapon.TYPE_INTERNAL || tip == Weapon.TYPE_MELEE) && (weaponKrep || !currentWeapon)) {
				attackerType = UNARMED;
			}
			else if (tip == Weapon.TYPE_MELEE) {
				attackerType = MELEE;
			}
			else if (tip == Weapon.TYPE_EXPLOSIVES) {
				attackerType = GRENADIER;
			}
			else {
				attackerType = GUNNER;
			}

			acidDey = ACID_WEAR;
			wPos = AnimationSet.getWeaponOffset(msex ? "wPosRaider1" : "wPosRaider2");

			if (!msex) {
				id_name += "_f";
			}

			if (sndDie == "rm" && !msex) {
				sndDie = "rw";
			}

			brainDefinition.stroll = stroll;
			brainDefinition.chatterChance = quiet ? 0.0 : CHATTER_CHANCE;
			brainDefinition.turnsWhenSurprised = false;
			brainDefinition.chasesOnSight = false;
			brainDefinition.wakeRadius = allLink ? ALLIED_WAKE_RADIUS : WAKE_RADIUS;
			brainDefinition.moves = moving;
			brainDefinition.dropsInAnyState = true;
			brainDefinition.freezesAimInAir = true;
			brainDefinition.calmVision = visionMult;
			brainDefinition.alertVision = visionMult * ALERT_VISION;
			brainDefinition.looksBehindWhenAlert = true;
			brainDefinition.targetMemory = TARGET_MEMORY;
			brainDefinition.driftInterval = DRIFT_INTERVAL;
			brainDefinition.driftsVertically = true;
			brainDefinition.doubtsNoises = true;
			brainDefinition.reaimChance = durak ? DURAK_REAIM : SMART_REAIM;
			brainDefinition.levitWakeShock = LEVIT_WAKE_SHOCK;
			brainDefinition.levitHoldShock = 0;
			brainDefinition.dashChance = dash ? DASH_CHANCE : 0.0;

			walkDefinition.patrolAccel = PATROL_ACCEL;
			walkDefinition.staysPut = !moving;
			walkDefinition.turnDelayGround = TURN_DELAY_GROUND;
			walkDefinition.turnDelayAir = TURN_DELAY_AIR;
			walkDefinition.idleFacesMotion = true;
			walkDefinition.wallGiveUpChance = WALL_GIVE_UP;
			walkDefinition.opensDoors = true;
			walkDefinition.jumpBoost = JUMP_BOOST;
			walkDefinition.climbsLadders = !flyer;
			flyDefinition.dodge = FLY_DODGE;

			arm();
			addAttacks();

			brain = new Brain(this, brainDefinition);
			walkMotor = new WalkMotor(this, walkDefinition);
			motor = flyer ? new FlyMotor(this, flyDefinition, walkMotor) : walkMotor;

			animatorDefinition.trot = "trot";
			animatorDefinition.walkStep = 1;
			animatorDefinition.trotStep = 1;
			animatorDefinition.runStep = 2;
			animatorDefinition.climb = "laz";
			animatorDefinition.climbStill = "laz";
			animatorDefinition.climbStep = 3;
			animatorDefinition.levitate = "derg";
			animatorDefinition.swim = "plav";
			animator = new Animator(this, animatorDefinition);
		}

		public override function getXmlParam(mid:String = null):void {
			var node0:XML;
			var un:XMLList;

			super.getXmlParam(parentId);
			super.getXmlParam();
			node0 = XMLDataGrabber.getNodeWithAttributeThatMatches("core", "AllData", "units", "id", id);

			if (node0.vis.length() > 0 && node0.vis.@telecolor.length() > 0) {
				teleColor = uint(node0.vis.@telecolor);
			}

			un = node0.un;
			if (un.length() == 0) { return; }

			if (un.@flyer.length() > 0) {
				flyer = true;
			}

			if (un.@och.length() > 0) {
				aiAttackOch = int(un.@och);
			}

			if (un.@dist.length() > 0) {
				aiDist = int(un.@dist);
			}

			if (un.@stalk.length() > 0) {
				stalkDist = int(un.@stalk);
			}

			if (un.@walker.length() > 0) {
				walker = true;
			}

			if (un.@sniper.length() > 0) {
				sniper = true;
			}

			if (un.@gren.length() > 0) {
				fearGrenade = false;
			}

			if (un.@grenader.length() > 0) {
				grenader = int(un.@grenader);
			}

			if (un.@drop.length() > 0) {
				dropW = String(un.@drop);
			}

			if (un.@stay.length() > 0) {
				stroll = false;
			}

			if (un.@enclweap.length() > 0) {
				enclWeap = true;
			}
		}

		public override function save():Object {
			var obj:Object = super.save();

			if (obj == null) {
				obj = {};
			}

			obj.tr = tr;
			obj.weap = weap;

			return obj;
		}

		public override function setWeaponPos(tip:String = "internal"):void {
			var obj:Object;

			super.setWeaponPos(tip);

			if (!enclWeap && (tip == Weapon.TYPE_MELEE || tip == Weapon.TYPE_LIGHTGUN || tip == Weapon.TYPE_EXPLOSIVES)) {
				obj = wPos[anims[animState].id][int(anims[animState].f)];
				weaponX = coordinates.X + (obj.x + visBmp.x) * storona.X;
				weaponY = coordinates.Y + obj.y + visBmp.y;
				weaponR = obj.r;
			}
		}

		// Ground animations go by what the unit is doing rather than how fast it moves
		public override function animOverride():String {
			if (sost == 2 || sost == 3 || !stay) { return ""; }
			if (velocity.X == 0 || aiState == E_AIState.DASH_PREP) { return animatorDefinition.stand; }
			if (attackerType == UNARMED && isAttacking() || aiState == E_AIState.DASH) { return animatorDefinition.run; }
			if (walker && (isCalm() || aiState == E_AIState.HOLD)) { return animatorDefinition.walk; }

			return animatorDefinition.trot;
		}

		public override function alarma(nx:Number = -1, ny:Number = -1):void {
			if (sost != 1 || !isCalm()) { return; }

			super.alarma(nx, ny);
			areaTestTip = "raider";

			if (!plusObservOk) {
				observ += plusObserv;
				plusObservOk = true;
			}
		}

		public override function onSighting():void {
			if (scrAlarmOn && scrAlarm) {
				scrAlarm.start();
				scrAlarmOn = false;
			}
		}

		public override function onSpotted():void {
			areaTestTip = "raider";

			if (kol_emit > 0 && emit_t <= 0) {
				emit();
			}
		}

		public override function onCalm():void {
			areaTestTip = "";
		}

		public override function dropLoot():void {
			var i:int;

			super.dropLoot();

			if (currentWeapon) {
				if (currentWeapon.vis) {
					currentWeapon.vis.visible = false;
				}

				if (isDropArm) {
					LootGen.lootId(loc, currentWeapon.coordinates.X, currentWeapon.coordinates.Y, currentWeapon.id, 0);
				}
			}

			if (attackerType == GRENADIER) {
				for (i = 0; i < DEATH_THROWS; i++) {
					aimAtFeet();
					currentWeapon.attack();
				}
			}

			if (dropWeapon) {
				aimAtFeet();
				dropWeapon.attack();
			}
		}

		public override function actions():void {
			super.actions();
			rasst = Math.sqrt(rasst2);
			volMinus = rasst / VOLUME_FALLOFF;
		}

		public override function damage(dam:Number, tip:String, bul:Bullet = null, tt:Boolean = false):Number {
			scrAlarmOn = false;

			if (sost == 1 && isCalm()) {
				budilo(WAKE_RADIUS);
			}

			return super.damage(dam, tip, bul, tt);
		}

		// Firebugs and bombers sometimes shout about their trade when they attack
		public override function replic(s:String):void {
			var line:String = s;

			if (t_replic <= 0 && s == "attack") {
				if (tr == 8 && isrnd(0.3)) {
					line = "fire";
				}

				if (tr == 9 && isrnd(0.3)) {
					line = "expl";
				}
			}

			super.replic(line);
		}

		public override function command(com:String, val:String = null):void {
			super.command(com, val);

			if (com == "turn") {
				if (val == "0") {
					storona = E_Direction.opposite(storona);
				}
				else if (val == "-1") {
					storona = E_Direction.LEFT;
				}
				else {
					storona = E_Direction.RIGHT;
				}

				motor.turnTo(storona);
				setVisPos();
			}

			if (com == "off") {
				walk = E_Direction.NEUTRAL;
				brain.isOn = false;
			}
			else if (com == "on") {
				brain.isOn = true;
			}
		}
	}
}

package fe.unit {

	import fe.serv.BlitAnim;
	import fe.unit.ai.model.Brain_Definition;
	import fe.unit.ai.system.Brain;
	import fe.unit.anim.model.Animator_Definition;
	import fe.unit.anim.system.Animator;
	import fe.unit.attack.model.BodyAttack_Definition;
	import fe.unit.attack.model.WeaponAttack_Definition;
	import fe.unit.attack.system.BodyAttack;
	import fe.unit.attack.system.WeaponAttack;
	import fe.unit.motor.model.WalkMotor_Definition;
	import fe.unit.motor.system.WalkMotor;
	import fe.util.Calc;

	// Small critters: radroaches, rats, molerats and radscorpions
	public class UnitMonstrik extends Unit {

		private static const PUNCH_TIME:int			= 15;		// Ticks between a scorpion's claw strikes, and the length of the strike animation
		private static const SPEED_SPREAD:Number	= 0.1;		// Each critter's speed varies by up to this fraction

		private var punch:WeaponAttack;			// A scorpion's claw strike, null for other critters

		public function UnitMonstrik(cid:String = null, ndif:Number = 100.0, xml:XML = null, loadObj:Object = null) {
			var brainDefinition:Brain_Definition = new Brain_Definition();
			var motorDefinition:WalkMotor_Definition = new WalkMotor_Definition();
			var biteDefinition:BodyAttack_Definition = new BodyAttack_Definition();
			var punchDefinition:WeaponAttack_Definition = new WeaponAttack_Definition();
			var animatorDefinition:Animator_Definition = new Animator_Definition();
			var isJumper:Boolean;
			var isScorpion:Boolean;

			super(cid, ndif, xml, loadObj);
			id = cid;
			if (id == "scorp") {
				id += Calc.intBetween(1, 2);
			}

			getXmlParam();
			initBlit();
			animState = "stay";
			maxSpeed *= Calc.floatBetween(1.0 - SPEED_SPREAD, 1.0 + SPEED_SPREAD);
			sitSpeed = maxSpeed;
			walkSpeed = maxSpeed;
			plavdy = accel;
			isJumper = id == "rat" || id == "molerat";
			isScorpion = id.indexOf("scorp") == 0;

			brainDefinition.calmVision = 0.25;
			brainDefinition.alertVision = 0.5;
			brainDefinition.hearsNoise = false;
			brainDefinition.sightBonus = 0;
			brainDefinition.wakeRadius = 0.0;
			brainDefinition.alertTimeMin = 40;
			brainDefinition.alertTimeMax = 90;
			brainDefinition.reaimInterval = 10;
			brainDefinition.reaimChance = 0.7;
			brainDefinition.reaimDistance = 80.0;
			brainDefinition.alarmShockMin = 3;
			brainDefinition.alarmShockMax = 8;
			brainDefinition.alarmWakeRadius = 250.0;

			motorDefinition.ledgeThreshold = 0.5;
			motorDefinition.ledgeHopChance = isJumper ? 0.1 : 0.0;
			motorDefinition.stopChance = 0.0;
			motorDefinition.hopsGaps = isJumper;
			motorDefinition.jumpToReach = isJumper;
			motorDefinition.jumpBoost = 5.0;
			motor = new WalkMotor(this, motorDefinition);

			biteDefinition.hop = isScorpion ? 0.0 : 0.5;
			attacks.push(new BodyAttack(this, biteDefinition));

			// Scorpions stop next to their target to strike with their claws
			if (isScorpion) {
				brainDefinition.closeHoldChance = 0.7;
				brainDefinition.closeRangeX = 80.0;
				brainDefinition.closeRangeAbove = 80.0;
				brainDefinition.closeRangeBelow = 40.0;
				brainDefinition.closeHoldTimeMin = PUNCH_TIME;
				brainDefinition.closeHoldTimeMax = PUNCH_TIME;

				currentWeapon = giveWeapon((id == "scorp1") ? "scorppunch" : id + "punch");
				punchDefinition.cooldown = PUNCH_TIME;
				punchDefinition.leapAbove = 40.0;
				punch = new WeaponAttack(this, punchDefinition);
				attacks.push(punch);
			}

			brain = new Brain(this, brainDefinition);

			animatorDefinition.runFrom = 5.0;
			animatorDefinition.swim = "plav";
			animatorDefinition.levitate = "plav";
			animatorDefinition.fall = "";
			animator = new Animator(this, animatorDefinition);
		}

		public override function setHero(nhero:int = 1):void {
			super.setHero(nhero);

			if (hero == 1) {
				maxhp *= 2.0;
				hp = maxhp;
			}
		}

		public override function expl():void {
			super.expl();

			if (id == "tarakan") {
				newPart("shmatok", 2, 1);
			}
		}

		public override function animOverride():String {
			if (!punch || punch.cooldownLeft <= 0) {
				return "";
			}

			if (punch.cooldownLeft == PUNCH_TIME) {
				BlitAnim(anims["attack"]).restart();
			}

			return "attack";
		}
	}
}

package fe.unit {

	import fe.loc.Location;
	import fe.unit.ai.model.AIState;
	import fe.unit.ai.model.Brain_Definition;
	import fe.unit.ai.system.Brain;
	import fe.unit.anim.model.Animator_Definition;
	import fe.unit.anim.system.Animator;
	import fe.unit.attack.model.BodyAttack_Definition;
	import fe.unit.attack.system.BodyAttack;
	import fe.unit.motor.model.WalkMotor_Definition;
	import fe.unit.motor.system.WalkMotor;

	// Hellhounds climbs walls, squeezes under low ceilings and smashes through blocks while chasing
	public class UnitHellhound extends UnitPon {

		private static const CLIMB_SPEED:Number			= 0.6;		// Climbing speed as a fraction of runSpeed
		private static const WALL_DAMAGE:Number			= 1000.0;	// Damage to blocks it runs into while chasing a target at its height
		private static const ENRAGED_WALL_DAMAGE:Number	= 5000.0;	// The same, at or below ENRAGED_HEALTH
		private static const ENRAGED_HEALTH:Number		= 0.3;		// Fraction of max hp
		private static const SMASH_RANGE_Y:Number		= 80.0;		// How close in height the target must be for blocks to be smashed
		private static const HEARING_RANGE:Number		= 400.0;	// The player is always noticed inside this range
		private static const CERTAIN_SIGHTING:Number	= 20.0;		// What look() returns for a target it can't miss

		protected override function control():void {
			var chasing:Boolean;

			super.control();

			chasing = sost == 1 && (aiState == AIState.SEARCH || aiState == AIState.CHASE) && Math.abs(celDY) < SMASH_RANGE_Y;
			if (!chasing) {
				destroy = 0;
			}
			else if (hp <= maxhp * ENRAGED_HEALTH) {
				destroy = ENRAGED_WALL_DAMAGE;
			}
			else {
				destroy = WALL_DAMAGE;
			}
		}

		public function UnitHellhound(cid:String = null, ndif:Number = 100.0, xml:XML = null, loadObj:Object = null) {
			var brainDefinition:Brain_Definition = new Brain_Definition();
			var motorDefinition:WalkMotor_Definition = new WalkMotor_Definition();
			var biteDefinition:BodyAttack_Definition = new BodyAttack_Definition();
			var animatorDefinition:Animator_Definition = new Animator_Definition();

			super(cid, ndif, xml, loadObj);
			id = "hellhound" + resolveVariant(cid, xml, loadObj, 1);
			getXmlParam();
			walkSpeed = maxSpeed;
			lazSpeed = runSpeed * CLIMB_SPEED;
			initBlit();
			animState = "stay";

			brainDefinition.calmVision = 0.7;
			brainDefinition.wakesOnAlarm = false;
			brain = new Brain(this, brainDefinition);

			motorDefinition.airControl = 1.0;
			motorDefinition.walkFriction = true;
			motorDefinition.brakesAtLedges = true;
			motorDefinition.turnsToTargetAtWall = false;
			motorDefinition.wallGiveUpChance = 0.5;
			motorDefinition.climbsLadders = true;
			motorDefinition.climbsWalls = true;
			motorDefinition.crouchClimb = true;
			motorDefinition.crawls = true;
			motorDefinition.crawlSpeed = 2.0;
			motor = new WalkMotor(this, motorDefinition);

			biteDefinition.shockedStrength = 0.5;
			attacks.push(new BodyAttack(this, biteDefinition));

			animatorDefinition.walkFrom = 1.0;
			animatorDefinition.sit = "sit";
			animatorDefinition.crawl = "polz";
			animatorDefinition.climb = "laz";
			animatorDefinition.climbStill = "laz";
			animatorDefinition.climbStep = 3;
			animator = new Animator(this, animatorDefinition);

			sit(true);
		}

		public override function getXmlParam(mid:String = null):void {
			super.getXmlParam("hellhound");		// Stats shared by every hellhound
			super.getXmlParam();				// Then the variant's own, such as hellhound1
		}

		public override function putLoc(nloc:Location, nx:Number, ny:Number):void {
			super.putLoc(nloc, nx, ny);
			unsit();
		}

		public override function look(ncel:Unit, over:Boolean = true, visParam:Number = 0, nDist:Number = 0):Number {
			if (ncel.player && rasst2 < HEARING_RANGE * HEARING_RANGE) {
				return CERTAIN_SIGHTING;
			}

			return super.look(ncel, over, visParam, nDist);
		}
	}
}

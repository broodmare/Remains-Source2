package fe.game.domain.units {

	import fe.game.domain.units.ai.Brain;
	import fe.game.domain.units.ai.Brain_Definition;
	import fe.game.domain.units.anim.Animator;
	import fe.game.domain.units.anim.Animator_Definition;
	import fe.game.domain.units.attack.BodyAttack;
	import fe.game.domain.units.attack.BodyAttack_Definition;
	import fe.game.domain.units.attack.WeaponAttack;
	import fe.game.domain.units.attack.WeaponAttack_Definition;
	import fe.game.domain.units.motor.WalkMotor;
	import fe.game.domain.units.motor.WalkMotor_Definition;
	import fe.engine.utils.Calc;
	import fe.engine.utils.Numbers;
	import fe.engine.utils.Vec2;
	import fe.game.enums.E_Direction;

	// Giant ants that wander up and down walls; fire ants (variant 3) breathe flame
	public class UnitAnt extends Unit {

		private static const SPEED_SPREAD:Number	= 0.1;		// Each ant's speed varies by up to this fraction
		private static const SWIM_STROKE:Number		= 0.25;		// Swimming stroke strength as a fraction of accel
		private static const HERO_SKIN:Number		= 4.0;		// Extra armor for a hero ant

		private var walker:WalkMotor;
		private var climbFacing:Vec2 = E_Direction.UP;		// Sprite direction along the wall, kept from the last climb

		protected override function control():void {
			overLook = isLaz != E_Direction.NEUTRAL;
			super.control();
		}

		public var tr:int;

		public function UnitAnt(cid:String = null, ndif:Number = 100.0, xml:XML = null, loadObj:Object = null) {
			var brainDefinition:Brain_Definition = new Brain_Definition();
			var motorDefinition:WalkMotor_Definition = new WalkMotor_Definition();
			var biteDefinition:BodyAttack_Definition = new BodyAttack_Definition();
			var animatorDefinition:Animator_Definition = new Animator_Definition();

			super(cid, ndif, xml, loadObj);
			tr = resolveVariant(cid, xml, loadObj, 1);
			id = "ant" + tr;
			getXmlParam();
			initBlit();
			animState = "stay";
			maxSpeed *= Calc.floatBetween(1.0 - SPEED_SPREAD, 1.0 + SPEED_SPREAD);
			sitSpeed = maxSpeed;
			walkSpeed = maxSpeed;
			lazSpeed = maxSpeed;
			plavdy = accel * SWIM_STROKE;

			brainDefinition.calmVision = 0.25;
			brainDefinition.alertVision = 0.5;
			brainDefinition.hearsNoise = false;
			brainDefinition.sightBonus = 0;
			brainDefinition.wakeRadius = 0.0;
			brainDefinition.chasesInWater = false;
			brainDefinition.idleTimeMin = 10;
			brainDefinition.idleTimeMax = 30;
			brainDefinition.alertTimeMin = 40;
			brainDefinition.alertTimeMax = 90;
			brainDefinition.reaimInterval = 10;
			brainDefinition.reaimChance = 0.7;
			brainDefinition.reaimDistance = 80.0;
			brainDefinition.alarmShockMin = 3;
			brainDefinition.alarmShockMax = 8;
			brainDefinition.alarmWakeRadius = 250.0;

			motorDefinition.ledgeThreshold = 0.5;
			motorDefinition.ledgeTurnChance = 0.5;
			motorDefinition.ledgeHopChance = 0.0;
			motorDefinition.stopChance = 0.0;
			motorDefinition.hopsGaps = false;
			motorDefinition.jumpToReach = false;
			motorDefinition.jumpBoost = 5.0;
			motorDefinition.climbsLadders = true;
			motorDefinition.climbsWalls = true;
			motorDefinition.climbAccel = 0.5;
			motorDefinition.climbRest = 0;
			motorDefinition.climbRangeX = 200.0;
			motorDefinition.wanderClimb = true;
			walker = new WalkMotor(this, motorDefinition);
			motor = walker;

			biteDefinition.rangeY = 120.0;
			biteDefinition.hop = 0.5;
			attacks.push(new BodyAttack(this, biteDefinition));

			// Fire ants stop near their target to breathe flame at it
			if (tr == 3) {
				brainDefinition.closeHoldChance = 0.07;
				brainDefinition.closeRangeX = 120.0;
				brainDefinition.closeRangeAbove = 80.0;
				brainDefinition.closeRangeBelow = 80.0;
				brainDefinition.closeHoldTimeMin = 40;
				brainDefinition.closeHoldTimeMax = 90;

				currentWeapon = giveWeapon("antfire");
				attacks.push(new WeaponAttack(this, new WeaponAttack_Definition()));
			}

			brain = new Brain(this, brainDefinition);

			animatorDefinition.runFrom = 5.0;
			animatorDefinition.climb = "walk";
			animatorDefinition.climbStill = "stay";
			animatorDefinition.swim = "plav";
			animatorDefinition.levitate = "plav";
			animatorDefinition.fall = "";
			animator = new Animator(this, animatorDefinition);
		}

		public override function setHero(nhero:int = 1):void {
			super.setHero(nhero);

			if (hero == 1) {
				skin += HERO_SKIN;
			}
		}

		public override function getXmlParam(mid:String = null):void {
			super.getXmlParam("ant");		// Stats shared by every ant
			super.getXmlParam();			// Then the variant's own, such as ant3
		}

		// On a wall the sprite turns sideways and faces the way the ant last climbed. The burn's clip in vis follows it.
		public override function setVisPos():void {
			var x:Number = coordinates.X;
			var y:Number = coordinates.Y;
			var facing:Number = storona.X;
			var turn:Number = 0.0;

			if (walker && walker.climbDirection != E_Direction.NEUTRAL) {
				climbFacing = walker.climbDirection;
			}

			if (isLaz == E_Direction.RIGHT) {
				x = boundingBox.right;
				y = coordinates.Y - boundingBox.halfHeight;
				turn = -Numbers.HALF_PI;
				facing = -climbFacing.Y;
			}
			else if (isLaz != E_Direction.NEUTRAL) {
				x = boundingBox.left;
				y = coordinates.Y - boundingBox.halfHeight;
				turn = Numbers.HALF_PI;
				facing = climbFacing.Y;
			}

			if (art) {
				art.x = x;
				art.y = y;
				art.scaleX = facing;
				art.rotation = turn;
			}
			if (vis) {
				vis.x = x;
				vis.y = y;
				vis.scaleX = facing;
				vis.scaleY = 1;
				vis.rotation = turn * Numbers.RAD_TO_DEG;
			}
		}
	}
}

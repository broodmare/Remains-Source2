package fe.unit {

	import flash.display.MovieClip;

	import fe.SymbolFactory;
	import fe.World;
	import fe.unit.ai.model.AIState;
	import fe.unit.ai.model.Brain_Definition;
	import fe.unit.ai.system.Brain;
	import fe.unit.attack.model.BodyAttack_Definition;
	import fe.unit.attack.system.BodyAttack;
	import fe.unit.motor.model.WalkMotor_Definition;
	import fe.unit.motor.system.WalkMotor;
	import fe.util.Calc;

	// A rolling robot ball that bounces at its target; the plasma variant (2) explodes when destroyed
	public class UnitRoller extends Unit {

		private static const SPEED_SPREAD:Number	= 1.0;		// Each roller's speed varies by up to this much
		private static const SPIN:Number			= 1.5;		// Degrees of spin per unit of horizontal speed
		private static const ALERT_RANGE:Number		= 200.0;	// The sprite shows its alert frame while the player is closer than this
		private static const CALM_RANGE:Number		= 600.0;	// The sprite returns to its calm frame once the player is further than this

		private var tr:int;
		private var rollSpin:Number = 0.0;		// Degrees the sprite turns per tick

		// Water shorts it out
		protected override function control():void {
			if (sost < 3 && isPlav && World.w.enemyAct > 0) {
				die();
				return;
			}

			super.control();
		}

		public function UnitRoller(cid:String = null, ndif:Number = 100.0, xml:XML = null, loadObj:Object = null) {
			var brainDefinition:Brain_Definition = new Brain_Definition();
			var motorDefinition:WalkMotor_Definition = new WalkMotor_Definition();
			var slamDefinition:BodyAttack_Definition = new BodyAttack_Definition();

			super(cid, ndif, xml, loadObj);
			tr = Math.max(resolveVariant(cid, xml, loadObj, 1), 1);
			id = (tr >= 2) ? "roller" + tr : "roller";
			getXmlParam();

			vis = SymbolFactory.createInstance((tr == 2) ? "visualRoller2" : "visualRoller") as MovieClip;
			vis.osn.rotation = Math.random() * 360.0;
			vis.osn.stop();
			maxSpeed += Calc.floatBetween(-SPEED_SPREAD, SPEED_SPREAD);
			walkSpeed = maxSpeed;
			sitSpeed = maxSpeed;
			runSpeed = maxSpeed;
			mat = 1;
			acidDey = 1.0;
			jumpBall = 0.5;
			elast = 0.8;
			storona = 1;

			brainDefinition.stroll = false;
			brainDefinition.alertTimeMin = 40;
			brainDefinition.alertTimeMax = 90;
			brainDefinition.reaimChance = 1.0;
			brainDefinition.hearsNoise = false;
			brainDefinition.sightBonus = 0;
			brainDefinition.wakeRadius = 0.0;
			brainDefinition.wakesOnAlarm = false;
			brainDefinition.wakesWhenLifted = false;
			brainDefinition.levitHoldShock = 0;
			brainDefinition.obeysStun = false;
			brain = new Brain(this, brainDefinition);

			motorDefinition.airControl = 1.0;
			motorDefinition.walkFriction = true;
			motorDefinition.turnsToTargetAtWall = false;
			motorDefinition.looksBeforeJumping = false;
			motorDefinition.reachJumpMin = 0.5;
			motorDefinition.reachJumpMax = 1.0;
			motor = new WalkMotor(this, motorDefinition);

			slamDefinition.hop = 0.3;
			attacks.push(new BodyAttack(this, slamDefinition));
		}

		public override function expl():void {
			newPart("metal", 4);
			newPart("miniexpl");
		}

		public override function setVisPos():void {
			vis.x = coordinates.X;
			vis.y = boundingBox.getCenter(coordinates);
		}

		public override function dropLoot():void {
			if (tr == 2) {
				explosion(dam * 4.0, Resistances.DAM_PLASMA, 150.0, 0, 20.0, 30.0, 9);
			}

			super.dropLoot();
		}

		// Spin with the roll, and show the alert frame while the player is close
		public override function animate():void {
			if (aiState == AIState.IDLE) {
				if (vis.osn.currentFrame != 1) {
					vis.osn.gotoAndStop(1);
				}
			}
			else if (rasst2 < ALERT_RANGE * ALERT_RANGE && vis.osn.currentFrame == 1) {
				vis.osn.gotoAndStop(2);
			}
			else if (rasst2 > CALM_RANGE * CALM_RANGE && vis.osn.currentFrame == 2) {
				vis.osn.gotoAndStop(1);
			}

			if (stay || turnY == -1) {
				rollSpin = velocity.X * SPIN;
			}

			turnY = 0;
			vis.osn.rotation += rollSpin;
		}
	}
}

package fe.unit {

	import flash.display.MovieClip;

	import fe.SymbolFactory;
	import fe.World;
	import fe.unit.ai.Brain;
	import fe.unit.ai.Brain_Definition;
	import fe.unit.attack.BodyAttack;
	import fe.unit.attack.BodyAttack_Definition;
	import fe.unit.motor.WalkMotor;
	import fe.unit.motor.WalkMotor_Definition;
	import fe.util.Calc;
	import fe.enums.E_Material;
	import fe.unit.enums.E_AIState;
	import fe.unit.enums.E_Resistances;
	import fe.graph.enums.E_Decal;
	import fe.enums.E_Direction;

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
			mat = E_Material.METAL;
			acidDey = 1.0;
			jumpBall = 0.5;
			elast = 0.8;
			storona = E_Direction.RIGHT;

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
				explosion(dam * 4.0, E_Resistances.DAM_PLASMA, 150.0, 0, 20.0, 30.0, E_Decal.EXPLOSION);
			}

			super.dropLoot();
		}

		// Spin with the roll, and show the alert frame while the player is close
		public override function animate():void {
			if (aiState == E_AIState.IDLE) {
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

			if (stay || turnY == E_Direction.UP) {
				rollSpin = velocity.X * SPIN;
			}

			turnY = E_Direction.NEUTRAL;
			vis.osn.rotation += rollSpin;
		}
	}
}

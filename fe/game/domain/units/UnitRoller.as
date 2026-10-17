package fe.game.domain.units {

	import fe.game.domain.units.ai.Brain;
	import fe.game.domain.units.ai.Brain_Definition;
	import fe.game.domain.units.attack.BodyAttack;
	import fe.game.domain.units.attack.BodyAttack_Definition;
	import fe.game.domain.units.motor.WalkMotor;
	import fe.game.domain.units.motor.WalkMotor_Definition;
	import fe.engine.utils.Calc;
	import fe.engine.utils.Numbers;
	import fe.game.rendering.Flipbook;
	import fe.game.enums.E_Material;
	import fe.game.domain.units.enums.E_AIState;
	import fe.game.domain.units.enums.E_Resistances;
	import fe.game.rendering.enums.E_Decal;
	import fe.game.enums.E_Direction;
	import fe.game.GameContainer;

	// A rolling robot ball that bounces at its target; the plasma variant (2) explodes when destroyed
	public class UnitRoller extends Unit {

		private static const SPEED_SPREAD:Number	= 1.0;		// Each roller's speed varies by up to this much
		private static const SPIN:Number			= 1.5;		// Degrees of spin per unit of horizontal speed
		private static const ALERT_RANGE:Number		= 200.0;	// The sprite shows its alert frame while the player is closer than this
		private static const CALM_RANGE:Number		= 600.0;	// The sprite returns to its calm frame once the player is further than this
		private static const FULL_TURN:Number		= 360.0;

		private var tr:int;
		private var rollSpin:Number = 0.0;		// Degrees the sprite turns per tick
		private var rollTurn:Number = 0.0;		// Degrees the sprite has turned
		private var isAlert:Boolean = false;	// Whether the sprite shows its alert frame
		private var sparks:Flipbook;			// Shown while alert, turning with the body

		// Water shorts it out
		protected override function control():void {
			if (sost < 3 && isPlav && GameContainer.reference.enemyAct > 0) {
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

			initArt((tr == 2) ? "roller2" : "roller");
			art.play("stay");
			rollTurn = Math.random() * FULL_TURN;
			art.setBodyRotation(rollTurn);
			sparks = GameContainer.reference.renderer.effects.createEffect((tr == 2) ? "roller2_sparks" : "roller_sparks");
			sparks.visible = false;
			sparks.x = art.definition.hubX;
			sparks.y = art.definition.hubY;
			art.carry(sparks);
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
			art.x = coordinates.X;
			art.y = boundingBox.getCenter(coordinates);
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
				isAlert = false;
			}
			else if (rasst2 < ALERT_RANGE * ALERT_RANGE) {
				isAlert = true;
			}
			else if (rasst2 > CALM_RANGE * CALM_RANGE) {
				isAlert = false;
			}
			art.play(isAlert ? "active" : "stay");
			// Alert anew, the sparks start over, as Flash restarted the alert body's loop
			if (isAlert && !sparks.visible) {
				sparks.goTo(0, true);
			}
			sparks.visible = isAlert;

			if (stay || turnY == E_Direction.UP) {
				rollSpin = velocity.X * SPIN;
			}

			turnY = E_Direction.NEUTRAL;
			rollTurn = (rollTurn + rollSpin) % FULL_TURN;
			art.setBodyRotation(rollTurn);
			sparks.rotation = rollTurn * Numbers.DEG_TO_RAD;
		}
	}
}

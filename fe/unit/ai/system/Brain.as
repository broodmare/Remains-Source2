package fe.unit.ai.system {

	import fe.World;
	import fe.loc.Tile;
	import fe.unit.Unit;
	import fe.unit.ai.model.AIState;
	import fe.unit.ai.model.Brain_Definition;
	import fe.unit.attack.system.IAttack;
	import fe.unit.motor.system.IMotor;
	import fe.util.Calc;

	// Decides what an AI unit does each tick: stays calm, notices targets, searches for them, chases them, stops to attack
	public class Brain {

		private static const SENSE_INTERVAL:int		= 10;		// Ticks between looking and listening for targets
		private static const SEARCH_DRIFT:Number	= 40.0;		// How far a searching unit's guess of the target's position wanders per look
		private static const LEVEL_SLACK:Number		= 40.0;		// A target point closer than this vertically counts as level with the unit
		private static const STEP_UP:Number			= 10.0;		// Height a walking unit steps up onto without jumping (porog)
		private static const STEP_UP_OFF:Number		= 70.0;		// No stepping up while the target is further below than this
		private static const DROP_THROUGH:Number	= 80.0;		// A chasing unit drops through platforms to a target further below than this
		private static const FLOOR_MARGIN:Number	= 80.0;		// No dropping through platforms this close to the bottom of the level
		private static const STUN_RECHECK:int		= 3;		// Ticks until a stunned unit decides again

		private var owner:Unit;
		private var definition:Brain_Definition;
		private var baseVision:Number;			// The unit's vision before calm and alert multipliers

		private function isCalm():Boolean {
			return owner.aiState == AIState.IDLE || owner.aiState == AIState.PATROL;
		}

		private function setState(state:int, timeMin:int, timeMax:int):void {
			owner.aiState = state;
			owner.aiTCh = Calc.intBetween(timeMin, timeMax);
		}

		// Look a little ahead, where a calm unit's eyes rest
		private function lookAhead():void {
			owner.celX = owner.coordinates.X + owner.boundingBox.width * owner.storona * 2;
			owner.celY = owner.coordinates.Y - owner.boundingBox.height;
		}

		// The state timer ran out: settle on a state from how alert the unit is
		private function decide():void {
			var state:int = owner.aiState;

			if (state == AIState.SURPRISED) {
				if (owner.celUnit) {
					owner.aiSpok = owner.maxSpok + definition.sightBonus;
					owner.replic("attack");
					setState(AIState.CHASE, definition.alertTimeMin, definition.alertTimeMax);
				}
				else {
					setState(AIState.PATROL, definition.patrolTimeMin, definition.patrolTimeMax);
				}

				return;
			}

			if (owner.aiSpok == 0) {
				if (!isCalm()) {
					owner.replic("vse");
				}

				state = (definition.stroll && Math.random() < 0.5) ? AIState.PATROL : AIState.IDLE;
				owner.storona = owner.aiNapr;
			}

			if (owner.aiSpok > 0) {
				state = AIState.SEARCH;
			}

			if (owner.aiSpok >= owner.maxSpok) {
				if (owner.aiState != AIState.CHASE && owner.aiState != AIState.HOLD) {
					wakeAllies();
				}

				state = AIState.CHASE;
			}

			if (state == AIState.IDLE) {
				setState(state, definition.idleTimeMin, definition.idleTimeMax);
			}
			else if (state == AIState.PATROL) {
				setState(state, definition.patrolTimeMin, definition.patrolTimeMax);
			}
			else {
				setState(state, definition.alertTimeMin, definition.alertTimeMax);
			}
		}

		private function wakeAllies():void {
			if (definition.wakeRadius > 0) {
				owner.budilo(definition.wakeRadius);
			}
		}

		// Look and listen for a target
		private function sense():void {
			var found:Boolean = owner.findCel();

			// A unit deaf to noise treats a sound like nothing at all
			if (found && !owner.celUnit && !definition.hearsNoise) {
				found = false;
			}

			if (!found) {
				owner.setCel(null, owner.celX + Calc.floatBetween(-SEARCH_DRIFT, SEARCH_DRIFT), owner.celY);

				if (owner.aiSpok > 0) {
					owner.aiSpok--;
				}

				if (owner.aiSpok > 0 && owner.aiSpok < owner.maxSpok) {
					owner.replic("find");
				}

				return;
			}

			if (!owner.celUnit) {
				owner.replic("ear");
				owner.aiSpok = owner.maxSpok - 1;
				return;
			}

			if (isCalm()) {
				setState(AIState.SURPRISED, definition.surpriseTimeMin, definition.surpriseTimeMax);
				return;
			}

			owner.replic("attack");
			owner.aiSpok = owner.maxSpok + definition.sightBonus;

			if (owner.aiState == AIState.SEARCH) {
				setState(AIState.CHASE, definition.alertTimeMin, definition.alertTimeMax);
			}
		}

		// Work out where the target point is relative to the unit, and how to move vertically toward it
		private function aim():void {
			var chasing:Boolean = owner.aiState == AIState.SEARCH || owner.aiState == AIState.CHASE;

			owner.celDX = owner.celX - owner.coordinates.X;
			owner.celDY = owner.celY - owner.coordinates.Y + owner.boundingBox.height;

			if (owner.celDY > LEVEL_SLACK) {
				owner.aiVNapr = 1;
			}
			else if (owner.celDY < -LEVEL_SLACK) {
				owner.aiVNapr = -1;
			}
			else {
				owner.aiVNapr = 0;
			}

			owner.porog = (owner.celDY > STEP_UP_OFF) ? 0 : STEP_UP;
			owner.throu = chasing && owner.celDY > DROP_THROUGH && owner.coordinates.Y <= owner.loc.spaceY * Tile.tileY - FLOOR_MARGIN;
		}

		// Now and then, turn toward a target that has moved off to one side
		private function reaim():void {
			if (owner.aiTCh % definition.reaimInterval != 1 || Math.random() >= definition.reaimChance) { return; }

			if (owner.celDX > definition.reaimDistance) {
				owner.aiNapr = 1;
			}

			if (owner.celDX < -definition.reaimDistance) {
				owner.aiNapr = -1;
			}
		}

		private function holdIfClose():void {
			if (definition.closeHoldChance <= 0 || !owner.celUnit) { return; }
			if (Math.abs(owner.celDX) > definition.closeRangeX) { return; }
			if (owner.celDY < -definition.closeRangeAbove || owner.celDY > definition.closeRangeBelow) { return; }

			if (Math.random() < definition.closeHoldChance) {
				setState(AIState.HOLD, definition.closeHoldTimeMin, definition.closeHoldTimeMax);
			}
		}

		private function speedFor(state:int):Number {
			switch (state) {
				case AIState.SEARCH: {
					return owner.runSpeed * definition.searchSpeed;
				}
				case AIState.CHASE: {
					return owner.runSpeed * definition.chaseSpeed;
				}
				default: {
					return owner.walkSpeed * definition.patrolSpeed;
				}
			}
		}

		private function act():void {
			var motor:IMotor = owner.motor;

			switch (owner.aiState) {
				case AIState.IDLE: {
					motor.idle();
					break;
				}
				case AIState.PATROL: {
					motor.patrol();
					break;
				}
				case AIState.SEARCH:
				case AIState.CHASE: {
					reaim();
					holdIfClose();
					motor.chase();
					break;
				}
				default: {
					motor.hold();
					break;
				}
			}
		}

		// Being lifted wakes a calm unit, and keeps it shocked while it hangs in the air
		private function reactToLevitation():void {
			if (definition.wakesWhenLifted) {
				owner.replic("levit");

				if (isCalm()) {
					owner.aiState = AIState.CHASE;
					owner.shok = Math.max(owner.shok, definition.levitWakeShock);
					wakeAllies();
				}
			}

			if (owner.shok < definition.levitHoldShock) {
				owner.shok = definition.levitHoldShock;
			}
		}

		public function Brain(owner_:Unit, definition_:Brain_Definition) {
			owner = owner_;
			definition = definition_;
			baseVision = owner.vision;
			owner.aiNapr = owner.storona;
		}

		public function tick():void {
			var attack:IAttack;

			if (owner.sost == 3) { return; }

			if (owner.levit != 0) {
				reactToLevitation();
			}

			if (owner.stun > 0 && definition.obeysStun) {
				owner.aiState = AIState.IDLE;
				owner.aiTCh = STUN_RECHECK;
				owner.walk = 0;
			}

			owner.t_replic--;

			if (World.w.enemyAct <= 0) {
				lookAhead();
				return;
			}

			owner.motor.tick();

			if (owner.aiTCh > 0) {
				owner.aiTCh--;
			}
			else {
				decide();
				owner.motor.rethink();
			}

			if (World.w.enemyAct > 1 && owner.aiTCh % SENSE_INTERVAL == 1) {
				sense();
			}

			aim();

			if (owner.aiSpok == 0) {
				owner.vision = baseVision * definition.calmVision;
				lookAhead();
			}
			else {
				owner.vision = baseVision * definition.alertVision;
			}

			if (owner.isPlav && (owner.aiState == AIState.IDLE || !definition.chasesInWater)) {
				owner.aiState = AIState.PATROL;
			}

			owner.maxSpeed = speedFor(owner.aiState);
			act();
			owner.pumpObj = null;

			if (World.w.enemyAct >= 3) {
				for each (attack in owner.attacks) {
					attack.tick();
				}
			}
		}

		// An alarm or an ally has woken the unit
		public function alarm():void {
			if (!definition.wakesOnAlarm || owner.sost != 1 || !isCalm()) { return; }

			owner.aiSpok = owner.maxSpok + definition.sightBonus;
			owner.aiState = AIState.CHASE;
			owner.shok = Calc.intBetween(definition.alarmShockMin, definition.alarmShockMax);

			if (definition.alarmWakeRadius > 0) {
				owner.budilo(definition.alarmWakeRadius);
			}
		}

		// Calm down completely, as when a level resets
		public function reset():void {
			owner.aiState = AIState.IDLE;
			owner.aiSpok = 0;
		}
	}
}
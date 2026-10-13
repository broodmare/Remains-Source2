package fe.unit.ai {

	import fe.World;
	import fe.loc.tile.Tile;
	import fe.unit.Unit;
	import fe.unit.attack.IAttack;
	import fe.unit.motor.IMotor;
	import fe.util.Calc;
	import fe.unit.enums.E_AIState;
	import fe.enums.E_Direction;

	// Decides what an AI unit does each tick: stays calm, notices targets, searches for them, chases them, stops to attack
	public class Brain {

		private static const SENSE_INTERVAL:int		= 10;		// Ticks between looking and listening for targets
		private static const SEARCH_DRIFT:Number	= 40.0;		// How far a searching unit's guess of the target's position wanders per drift
		private static const LEVEL_SLACK:Number		= 40.0;		// A target point closer than this vertically counts as level with the unit
		private static const STEP_UP:Number			= 10.0;		// Height a walking unit steps up onto without jumping (porog)
		private static const STEP_UP_OFF:Number		= 70.0;		// No stepping up while the target is further below than this
		private static const DROP_THROUGH:Number	= 80.0;		// A chasing unit drops through platforms to a target further below than this
		private static const FLOOR_MARGIN:Number	= 80.0;		// No dropping through platforms this close to the bottom of the level
		private static const STUN_RECHECK:int		= 3;		// Ticks until a stunned unit decides again
		private static const DASH_PREP_TIME:int		= 20;		// Ticks spent standing still before a dash
		private static const DASH_TIME:int			= 35;		// Ticks a dash lasts
		private static const GIVE_UP_SPOK:int		= 15;		// aiSpok below which a unit that doubts what it heard gives up searching
		private static const GIVE_UP_REMARK:Number	= 0.5;		// Chance it says so when it gives up

		private var owner:Unit;
		private var definition:Brain_Definition;
		private var baseVision:Number;				// The unit's vision before calm and alert multipliers
		private var isAware:Boolean		= false;	// Has seen the player at least once
		private var memoryTarget:Unit;				// The target last seen, still followed for memoryLeft looks after losing sight of it
		private var memoryLeft:int		= 0;
		private var unseenLooks:int		= 0;		// Looks that found nothing, for pacing the drift of the searched-for point

		private function isCalm():Boolean {
			return owner.aiState == E_AIState.IDLE || owner.aiState == E_AIState.PATROL;
		}

		private function setState(state:int, timeMin:int, timeMax:int):void {
			owner.aiState = state;
			owner.aiTCh = Calc.intBetween(timeMin, timeMax);
		}

		// Look a little ahead, where a calm unit's eyes rest
		private function lookAhead():void {
			owner.celX = owner.coordinates.X + owner.boundingBox.width * owner.storona.X * 2;
			owner.celY = owner.coordinates.Y - owner.boundingBox.height;
		}

		// The state timer ran out: settle on a state from how alert the unit is
		private function decide():void {
			var state:int;

			if (owner.aiState == E_AIState.DASH_PREP) {
				setState(E_AIState.DASH, DASH_TIME, DASH_TIME);
				return;
			}

			// The surprise wears off: a target still in sight is attacked, then the unit decides like any other time
			if (owner.aiState == E_AIState.SURPRISED) {
				if (owner.celUnit) {
					owner.aiSpok = owner.maxSpok + definition.sightBonus;
					owner.replic("attack");
					owner.onSpotted();
					owner.aiState = E_AIState.CHASE;
				}
				else {
					owner.aiState = E_AIState.PATROL;
				}
			}

			state = owner.aiState;

			if (owner.aiSpok == 0) {
				if (!isCalm() && (isAware || !definition.doubtsNoises)) {
					owner.replic("vse");
				}

				state = (definition.stroll && Math.random() < 0.5) ? E_AIState.PATROL : E_AIState.IDLE;
				owner.motor.turnTo(owner.aiNapr);
				owner.onCalm();
			}

			if (owner.aiSpok > 0) {
				state = E_AIState.SEARCH;
			}

			if (owner.aiSpok >= owner.maxSpok) {
				if (owner.aiState != E_AIState.CHASE && owner.aiState != E_AIState.HOLD) {
					wakeAllies();
				}

				state = pickAttack();
			}

			switch (state) {
				case E_AIState.IDLE: {
					setState(state, definition.idleTimeMin, definition.idleTimeMax);
					break;
				}
				case E_AIState.PATROL: {
					setState(state, definition.patrolTimeMin, definition.patrolTimeMax);
					break;
				}
				case E_AIState.HOLD: {
					setState(state, definition.holdTimeMin, definition.holdTimeMax);
					break;
				}
				case E_AIState.DASH_PREP: {
					setState(state, DASH_PREP_TIME, DASH_PREP_TIME);
					break;
				}
				default: {
					setState(state, definition.alertTimeMin, definition.alertTimeMax);
					break;
				}
			}
		}

		// How a fully alert unit goes after its target: chase it, stand and shoot, or get ready to dash
		private function pickAttack():int {
			var state:int = E_AIState.CHASE;
			var range:Number = definition.holdRange;
			var distance2:Number = owner.celDX * owner.celDX + owner.celDY * owner.celDY;
			var isFreshSighting:Boolean = owner.aiSpok >= owner.maxSpok + definition.holdAlertMargin;

			if (isFreshSighting && distance2 < range * range && Math.random() < definition.holdChance) {
				state = E_AIState.HOLD;
			}

			if (owner.celUnit && Math.random() < definition.dashChance) {
				state = E_AIState.DASH_PREP;
			}

			if (!definition.moves) {
				state = E_AIState.HOLD;
			}

			return state;
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
				lose();
				return;
			}

			if (!owner.celUnit) {
				owner.replic("ear");
				owner.aiSpok = owner.maxSpok - 1;
				return;
			}

			memoryTarget = owner.celUnit;
			memoryLeft = definition.targetMemory;
			if (owner.celUnit.player) {
				isAware = true;
			}

			owner.onSighting();

			if (isCalm()) {
				setState(E_AIState.SURPRISED, definition.surpriseTimeMin, definition.surpriseTimeMax);
				return;
			}

			owner.replic("attack");
			owner.aiSpok = owner.maxSpok + definition.sightBonus;
			owner.onSpotted();

			if (definition.chasesOnSight && owner.aiState == E_AIState.SEARCH) {
				setState(E_AIState.CHASE, definition.alertTimeMin, definition.alertTimeMax);
			}
		}

		// Nothing seen or heard: follow a remembered target for a while, then let the guess drift and cool down
		private function lose():void {
			var driftY:Number = 0.0;

			if (memoryLeft > 0) {
				memoryLeft--;
				owner.setCel(memoryTarget);
				return;
			}

			unseenLooks++;
			if (unseenLooks % definition.driftInterval == 0) {
				if (definition.driftsVertically) {
					driftY = Calc.floatBetween(-SEARCH_DRIFT, SEARCH_DRIFT);
				}

				owner.setCel(null, owner.celX + Calc.floatBetween(-SEARCH_DRIFT, SEARCH_DRIFT), owner.celY + driftY);
			}

			if (owner.aiSpok > 0) {
				owner.aiSpok--;
			}

			if (owner.aiSpok == 0) { return; }

			if (definition.doubtsNoises && !isAware) {
				if (owner.aiSpok < GIVE_UP_SPOK) {
					owner.aiSpok = 0;
					if (Math.random() < GIVE_UP_REMARK) {
						owner.replic((owner.hp >= owner.maxhp) ? "nope" : "dont");
					}
				}
			}
			else if (owner.aiSpok < owner.maxSpok) {
				owner.replic("find");
			}
		}

		// Work out where the target point is relative to the unit, and how to move vertically toward it
		private function aim():void {
			var state:int = owner.aiState;
			var isChasing:Boolean = state == E_AIState.SEARCH || state == E_AIState.CHASE;
			var mayDrop:Boolean = definition.moves && (isChasing || definition.dropsInAnyState);

			owner.celDX = owner.celX - owner.coordinates.X;
			if (owner.stay || !definition.freezesAimInAir) {
				owner.celDY = owner.celY - owner.coordinates.Y + owner.boundingBox.height;
			}

			if (owner.celDY > LEVEL_SLACK) {
				owner.aiVNapr = E_Direction.DOWN;
			}
			else if (owner.celDY < -LEVEL_SLACK) {
				owner.aiVNapr = E_Direction.UP;
			}
			else {
				owner.aiVNapr = E_Direction.NEUTRAL;
			}

			owner.porog = (owner.celDY > STEP_UP_OFF) ? 0 : STEP_UP;
			owner.throu = mayDrop && owner.celDY > DROP_THROUGH && owner.coordinates.Y <= owner.loc.spaceY * Tile.tileY - FLOOR_MARGIN;
		}

		// Now and then, turn toward a target that has moved off to one side
		private function reaim():void {
			if (owner.aiTCh % definition.reaimInterval != 1 || Math.random() >= definition.reaimChance) { return; }

			if (owner.celDX > definition.reaimDistance) {
				owner.aiNapr = E_Direction.RIGHT;
			}

			if (owner.celDX < -definition.reaimDistance) {
				owner.aiNapr = E_Direction.LEFT;
			}
		}

		// Stop to attack a target that is close enough; with closeHoldReleases, chase again once it moves off
		private function holdIfClose():void {
			var state:int = owner.aiState;
			var distanceX:Number = Math.abs(owner.celDX);
			var inReach:Boolean = distanceX >= definition.closeRangeXMin && distanceX <= definition.closeRangeX;

			if (definition.closeHoldChance <= 0) { return; }

			if (state == E_AIState.HOLD && definition.closeHoldReleases && !inReach) {
				owner.aiState = E_AIState.CHASE;
				return;
			}

			if (!(state == E_AIState.CHASE || state == E_AIState.SEARCH && definition.closeHoldSearching)) { return; }
			if (!owner.celUnit || !inReach) { return; }
			if (owner.celDY < -definition.closeRangeAbove || owner.celDY > definition.closeRangeBelow) { return; }

			if (Math.random() < definition.closeHoldChance) {
				setState(E_AIState.HOLD, definition.closeHoldTimeMin, definition.closeHoldTimeMax);
			}
		}

		// Leap back from a target that comes too close while holding, then chase it
		private function backOffIfCrowded():void {
			var range:Number = definition.backOffRange;

			if (range <= 0 || owner.celDX * owner.celDX + owner.celDY * owner.celDY >= range * range) { return; }

			if (Math.random() < definition.backOffChance) {
				owner.motor.leapBack();
			}

			owner.aiState = E_AIState.CHASE;
		}

		private function isRunning():Boolean {
			return definition.runsWhenAlert || definition.runsOnceSeen && owner.aiSpok >= owner.maxSpok;
		}

		private function speedFor(state:int):Number {
			switch (state) {
				case E_AIState.SEARCH: {
					return isRunning() ? owner.runSpeed * definition.searchSpeed : owner.walkSpeed;
				}
				case E_AIState.CHASE: {
					return isRunning() ? owner.runSpeed * definition.chaseSpeed : owner.walkSpeed;
				}
				case E_AIState.FLEE: {
					return owner.runSpeed * definition.fleeSpeed;
				}
				case E_AIState.DASH: {
					return owner.runSpeed * definition.dashSpeed;
				}
				case E_AIState.DASH_PREP: {
					return 0.0;
				}
				default: {
					return owner.walkSpeed * definition.patrolSpeed;
				}
			}
		}

		private function lookBehind(isAlert:Boolean):void {
			if (definition.looksBehindWhenAlert) {
				owner.overLook = isAlert;
			}
		}

		// Calm: eyes forward, and now and then a word to itself
		private function relax():void {
			lookBehind(false);

			if (Math.random() < definition.chatterChance) {
				owner.replic("neutral");
			}
		}

		private function act():void {
			var motor:IMotor = owner.motor;

			holdIfClose();

			switch (owner.aiState) {
				case E_AIState.IDLE: {
					relax();
					motor.idle();
					break;
				}
				case E_AIState.PATROL: {
					relax();
					motor.patrol();
					break;
				}
				case E_AIState.SEARCH:
				case E_AIState.CHASE: {
					lookBehind(true);
					reaim();
					motor.chase();
					break;
				}
				case E_AIState.FLEE: {
					lookBehind(true);
					motor.rush();
					break;
				}
				case E_AIState.DASH: {
					lookBehind(true);
					reaim();
					motor.rush();
					break;
				}
				case E_AIState.HOLD: {
					motor.hold();
					backOffIfCrowded();
					break;
				}
				case E_AIState.SURPRISED: {
					if (definition.turnsWhenSurprised) {
						motor.hold();
					}
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
					owner.aiState = E_AIState.CHASE;
					owner.shok = Math.max(owner.shok, definition.levitWakeShock);
					wakeAllies();
				}
			}

			if (owner.shok < definition.levitHoldShock) {
				owner.shok = definition.levitHoldShock;
			}
		}

		public var isOn:Boolean = true;		// False while a script has switched the unit's AI off

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
				owner.aiState = E_AIState.IDLE;
				owner.aiTCh = STUN_RECHECK;
				owner.walk = E_Direction.NEUTRAL;
			}

			owner.t_replic--;

			if (!isOn) { return; }

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

			if (World.w.enemyAct > 1 && owner.aiTCh % SENSE_INTERVAL == 1 && owner.aiState != E_AIState.FLEE) {
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

			if (owner.isPlav && (owner.aiState == E_AIState.IDLE || !definition.chasesInWater)) {
				owner.aiState = E_AIState.PATROL;
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
			owner.aiState = E_AIState.CHASE;
			owner.shok = Calc.intBetween(definition.alarmShockMin, definition.alarmShockMax);

			if (definition.alarmWakeRadius > 0) {
				owner.budilo(definition.alarmWakeRadius);
			}
		}

		// Calm down completely, as when a level resets
		public function reset():void {
			owner.aiState = E_AIState.IDLE;
			owner.aiSpok = 0;
		}
	}
}
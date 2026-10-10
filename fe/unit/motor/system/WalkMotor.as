package fe.unit.motor.system {

	import fe.loc.Tile;
	import fe.unit.Unit;
	import fe.unit.ai.model.AIState;
	import fe.unit.motor.model.WalkMotor_Definition;
	import fe.util.Calc;

	// Walking, jumping, swimming and climbing for units that live on the ground
	public class WalkMotor implements IMotor {

		private static const IDLE_LEDGE:Number			= 0.5;		// How far over a ledge a standing unit turns back from
		private static const CHASE_LEDGE:Number			= 0.5;		// How far over a ledge a chasing unit hops or brakes
		private static const LEDGE_LOOKAHEAD:Number		= 80.0;		// How far ahead a wandering unit looks for ground to hop to
		private static const LEDGE_BRAKE:Number			= 0.6;		// Speed kept when braking at a ledge
		private static const LEDGE_BRAKE_SPEED:Number	= 5.0;		// Only brake at a ledge when faster than this
		private static const HOP:Number					= 0.5;		// Jump strength for hopping ledges and gaps
		private static const LADDER_HOP:Number			= 0.8;		// Jump strength for leaping off a ladder
		private static const LADDER_HOP_CHANCE:Number	= 0.7;
		private static const LADDER_HOP_TIME:int		= 20;		// Ticks of climbing after which letting go can turn into a leap
		private static const HEADROOM_NEAR:Number		= 85.0;		// Heights above the feet that must be clear to jump
		private static const HEADROOM_FAR:Number		= 125.0;
		private static const HEADROOM_AHEAD:Number		= 40.0;		// How far ahead the headroom is checked as well
		private static const TARGET_FAR_BELOW:Number	= 100.0;	// A wall isn't worth jumping when the target is this far below
		private static const SWIM_MEMORY:int			= 10;		// Ticks a unit still counts as swimming after leaving water
		private static const WATER_EXIT:Number			= 0.6;		// Jump strength for leaping out of water
		private static const SWIM_UP_CHANCE:Number		= 0.7;		// Chance per tick a chasing swimmer strokes up toward a target above
		private static const STAIRS_SPEED:Number		= 0.5;		// Fraction of top speed when walking up stairs
		private static const CRAWL_CHECK:int			= 10;		// Ticks between attempts to stand up from a crawl
		private static const CRAWL_GAP:Number			= 40.0;		// Height of the opening a crawler squeezes into
		private static const WANDER_CLIMB_CHANCE:Number	= 0.2;		// Chance a wandering climber picks a new climbing direction when it rethinks
		private static const WALL_CLIMB_CHANCE:Number	= 0.5;		// Chance a wandering climber climbs a wall instead of turning away from it
		private static const TURN_TIME_MIN:int			= 5;		// Bumps against a wall before a chasing unit turns back
		private static const TURN_TIME_MAX:int			= 24;
		private static const JUMP_COOLDOWN_MIN:int		= 30;		// Ticks after a jump before jumping toward a target above again
		private static const JUMP_COOLDOWN_MAX:int		= 79;

		private var owner:Unit;
		private var definition:WalkMotor_Definition;
		private var jumpPower:Number	= 0.0;		// Jump queued during this tick's chase
		private var jumpCooldown:int	= 0;
		private var ladderCooldown:int	= 0;
		private var climbTime:int		= 0;		// Ticks spent climbing, or while negative, ticks since the last climb
		private var climbIntent:int		= 0;		// Where a wandering climber wants to go: -1 up, 1 down, 0 neither

		// Accelerate in a direction, up to maxSpeed
		private function push(direction:int, amount:Number):void {
			if (direction < 0 && owner.velocity.X > -owner.maxSpeed) {
				owner.velocity.X -= amount;
			}
			else if (direction > 0 && owner.velocity.X < owner.maxSpeed) {
				owner.velocity.X += amount;
			}
		}

		// Tell the physics which way the unit is walking; with walkFriction it is left to drag as if standing
		private function walkToward(direction:int):void {
			if (!definition.walkFriction) {
				owner.walk = direction;
			}
		}

		private function face():void {
			if (owner.isLaz == 0) {
				owner.storona = owner.aiNapr;
			}
		}

		private function turnAround():void {
			owner.aiNapr = owner.turnX;
			owner.storona = owner.turnX;
			owner.turnX = 0;
		}

		private function limitSpeed():void {
			if (owner.velocity.X * owner.diagon > 0) {
				owner.maxSpeed *= STAIRS_SPEED;
			}
		}

		// Whether the unit stands over a ledge in the direction it is heading
		private function isOverLedge(threshold:Number):Boolean {
			return owner.stay && (owner.aiNapr < 0 && owner.shX1 > threshold || owner.aiNapr > 0 && owner.shX2 > threshold);
		}

		private function isGroundAhead():Boolean {
			var tile:Tile = owner.loc.getAbsTile(owner.coordinates.X + owner.storona * LEDGE_LOOKAHEAD, owner.coordinates.Y + 10);

			return tile.phis == 1 || tile.shelf;
		}

		private function isClear(x:Number, y:Number):Boolean {
			return owner.loc.getAbsTile(x, y).phis == 0;
		}

		// Run into a wall while chasing: turn back toward a target behind, otherwise try to jump it and eventually give up
		private function bumpWall():void {
			if (definition.turnsToTargetAtWall && owner.celDX * owner.aiNapr < 0) {
				owner.aiNapr = owner.turnX;
				owner.aiTTurn = Calc.intBetween(TURN_TIME_MIN, TURN_TIME_MAX);
			}
			else {
				owner.aiTTurn--;

				if (Math.random() < definition.wallGiveUpChance || owner.turnY > 0 || definition.looksBeforeJumping && (owner.kray || owner.celDY > TARGET_FAR_BELOW || !canJumpUp())) {
					owner.aiTTurn -= 10;
				}
				else {
					jumpPower = 1.0;
				}

				if (owner.aiTTurn < 0 && owner.stay) {
					owner.aiNapr = owner.turnX;
					owner.aiTTurn = Calc.intBetween(TURN_TIME_MIN, TURN_TIME_MAX);
				}
			}

			owner.kray = false;
			owner.turnX = 0;
			owner.turnY = 0;
		}

		// Duck under a low ceiling the unit has just walked into
		private function crawlUnder():void {
			var edgeX:Number;
			var top:Number = owner.boundingBox.top;

			if (!owner.stay || owner.turnX == 0) { return; }

			edgeX = (owner.turnX < 0) ? owner.boundingBox.right + 2 : owner.boundingBox.left - 2;
			if (!isClear(edgeX, top) && isClear(edgeX, top + CRAWL_GAP) && isClear(edgeX, top + CRAWL_GAP * 2)) {
				owner.sit(true);
				owner.turnX = 0;
			}
		}

		// Grab a ladder, or with climbsWalls a wall, level with the point dy below the feet
		private function findClimbable(dy:int):void {
			var column:int;
			var row:int;
			var tile:Tile;

			if (!definition.climbsWalls) {
				owner.checkStairs(dy);
				return;
			}

			column = int(owner.coordinates.X / Tile.tileX);
			row = Math.min(int((owner.coordinates.Y + dy) / Tile.tileY), owner.loc.spaceY - 1);
			tile = owner.loc.getTile(column, row);

			if (tile.phis >= 1) {
				owner.isLaz = 0;
			}
			else if (tile.stair != 0) {
				owner.isLaz = tile.stair;
			}
			else if (owner.loc.getTile(column + owner.storona, row).phis != 0) {
				owner.isLaz = owner.storona;
			}
			else {
				owner.isLaz = 0;
			}

			if (owner.isLaz == 0) { return; }

			owner.storona = owner.isLaz;
			if (owner.isLaz < 0) {
				owner.coordinates.X = tile.boundingBox.left + owner.boundingBox.halfWidth;
			}
			else {
				owner.coordinates.X = tile.boundingBox.right - owner.boundingBox.halfWidth;
			}
			owner.boundingBox.center(owner.coordinates);
			owner.stay = false;
		}

		private function climb(direction:int):void {
			var step:Number = owner.lazSpeed * definition.climbAccel;

			climbDirection = direction;
			if (direction < 0) {
				owner.velocity.Y = Math.max(owner.velocity.Y - step, -owner.lazSpeed);
			}
			else {
				owner.velocity.Y = Math.min(owner.velocity.Y + step, owner.lazSpeed);
			}

			findClimbable(-1);
		}

		// Stay where the unit is: wall climbers keep clinging, everyone else lets go
		private function holdOnto():void {
			if (definition.climbsWalls) {
				owner.velocity.Y = 0;
				findClimbable(-1);
			}
			else {
				owner.isLaz = 0;
			}
		}

		// Climb toward a target above or below, then let go once level with it
		private function climbTowardTarget():void {
			var inRange:Boolean = definition.climbRangeX <= 0 || Math.abs(owner.celDX) < definition.climbRangeX;

			if (owner.isLaz == 0 && owner.aiVNapr != 0 && inRange && ladderCooldown <= 0 && climbTime < -definition.climbRest) {
				findClimbable((owner.aiVNapr < 0) ? -1 : 2);

				if (owner.isLaz != 0) {
					ladderCooldown = definition.climbRest;
				}
			}

			if (owner.isLaz == 0) {
				if (climbTime > 0) {
					climbTime = 0;
				}

				climbTime--;
				climbDirection = 0;
				return;
			}

			if (climbTime < 0) {
				climbTime = 0;
			}

			climbTime++;

			if (definition.crouchClimb) {
				owner.sit(true);
			}

			if (owner.celY < owner.coordinates.Y && climbDirection <= 0) {
				climb(-1);
			}
			else if (owner.aiVNapr > 0 && climbDirection >= 0) {
				climb(1);
			}
			else {
				owner.isLaz = 0;

				if (climbTime > LADDER_HOP_TIME && Math.random() < LADDER_HOP_CHANCE) {
					jumpPower = LADDER_HOP;
				}
			}

			if (owner.turnY != 0) {
				owner.isLaz = 0;
				owner.turnY = 0;
			}
		}

		// Climb up and down at random while wandering, sometimes climbing a wall instead of turning away from it
		private function wanderClimb():void {
			if (owner.stay && owner.turnX != 0 && Math.random() < WALL_CLIMB_CHANCE) {
				climbIntent = -1;
				owner.turnX = 0;
			}

			if (owner.isLaz == 0 && climbIntent != 0) {
				findClimbable((climbIntent < 0) ? -1 : 2);
			}

			if (owner.isLaz != 0) {
				if (climbIntent != 0) {
					climb(climbIntent);
				}
				else {
					owner.isLaz = 0;
				}

				if (owner.turnY != 0) {
					climbIntent = (owner.turnY < 0 && Math.random() < 0.5) ? 0 : owner.turnY;
					owner.turnY = 0;
				}
			}

			if (owner.isLaz == 0) {
				climbIntent = 0;
				climbDirection = 0;
			}
		}

		public var climbDirection:int	= 0;		// Direction of the current climb: -1 up, 1 down, 0 not climbing

		public function WalkMotor(owner_:Unit, definition_:WalkMotor_Definition) {
			owner = owner_;
			definition = definition_;
		}

		public function tick():void {
			if (jumpCooldown > 0) {
				jumpCooldown--;
			}

			if (ladderCooldown > 0) {
				ladderCooldown--;
			}

			if (owner.aiPlav > 0) {
				owner.aiPlav--;
			}

			if (owner.isPlav) {
				owner.aiPlav = SWIM_MEMORY;
			}

			if (definition.crawls && owner.isSit && owner.aiTCh % CRAWL_CHECK == 1) {
				owner.unsit();
			}
		}

		public function rethink():void {
			if (definition.wanderClimb && Math.random() < WANDER_CLIMB_CHANCE) {
				climbIntent = Calc.intBetween(-1, 1);
			}
		}

		public function idle():void {
			limitSpeed();
			owner.walk = 0;

			if (owner.isLaz != 0) {
				holdOnto();
			}

			if (owner.stay && owner.shX1 > IDLE_LEDGE && owner.aiNapr < 0) {
				owner.turnX = 1;
			}

			if (owner.stay && owner.shX2 > IDLE_LEDGE && owner.aiNapr > 0) {
				owner.turnX = -1;
			}

			if (owner.isPlav) {
				jump(1.0);
			}
		}

		public function patrol():void {
			limitSpeed();

			if (owner.isLaz != 0 && !definition.wanderClimb) {
				owner.isLaz = 0;
			}

			push(owner.aiNapr, owner.accel * definition.patrolAccel);
			walkToward(owner.aiNapr);

			if (isOverLedge(definition.ledgeThreshold) && Math.random() < definition.ledgeTurnChance) {
				if (Math.random() < definition.ledgeHopChance && isGroundAhead()) {
					jump(HOP);
				}
				else {
					owner.turnX = -owner.aiNapr;
				}
			}

			if (definition.crawls) {
				crawlUnder();
			}

			if (definition.wanderClimb) {
				wanderClimb();
			}

			// A wanderer sometimes stops after turning around
			if (owner.stay && owner.turnX != 0) {
				if (Math.random() < definition.stopChance) {
					owner.aiState = AIState.IDLE;
				}

				turnAround();
			}

			if (owner.isPlav) {
				jump(1.0);

				if (owner.turnX != 0) {
					turnAround();
				}
			}

			face();
		}

		public function chase():void {
			jumpPower = 0.0;

			if (definition.crawls && owner.isSit) {
				owner.maxSpeed = owner.walkSpeed * definition.crawlSpeed;
			}

			limitSpeed();

			if (definition.jumpToReach && owner.aiVNapr < 0 && jumpCooldown <= 0 && owner.aiTCh % 2 == 1 && (!definition.looksBeforeJumping || canJumpUp())) {
				jumpPower = Calc.floatBetween(definition.reachJumpMin, definition.reachJumpMax);
			}

			// Units that walk along the bottom (plav off) don't swim up after a target
			if (owner.isPlav && owner.plav && owner.celDY < 0 && Math.random() < SWIM_UP_CHANCE) {
				jumpPower = 1.0;
			}

			if (definition.climbsLadders || definition.climbsWalls) {
				climbTowardTarget();
			}

			if (owner.levit != 0) {
				push(owner.aiNapr, owner.levitaccel);
			}
			else if (owner.stay || owner.isPlav) {
				push(owner.aiNapr, owner.accel);
				walkToward(owner.aiNapr);
			}
			else {
				push(owner.aiNapr, owner.accel * definition.airControl);
			}

			if (isOverLedge(CHASE_LEDGE)) {
				if (definition.hopsGaps && owner.aiVNapr <= 0 && Math.random() < 0.5) {
					jumpPower = HOP;
				}
				else if (definition.brakesAtLedges && Math.abs(owner.velocity.X) > LEDGE_BRAKE_SPEED) {
					owner.velocity.X *= LEDGE_BRAKE;
				}
			}

			if (definition.crawls) {
				crawlUnder();
			}

			if (owner.turnX != 0) {
				bumpWall();
			}

			if (jumpPower > 0) {
				owner.storona = owner.aiNapr;
				jump(jumpPower);
			}

			face();
		}

		public function hold():void {
			limitSpeed();
			owner.walk = 0;

			if (owner.isLaz != 0) {
				holdOnto();
				return;
			}

			owner.aiNapr = (owner.celX > owner.coordinates.X) ? 1 : -1;
			owner.storona = owner.aiNapr;
		}

		public function jump(power:Number):void {
			jumpCooldown = Calc.intBetween(JUMP_COOLDOWN_MIN, JUMP_COOLDOWN_MAX);

			if (owner.stay || owner.isLaz != 0) {
				owner.velocity.Y = -owner.jumpdy * power;
				owner.isLaz = 0;
			}

			if (owner.stay) {
				owner.velocity.X += owner.storona * owner.accel * definition.jumpBoost;
			}

			if (!owner.isPlav && owner.aiPlav > 0) {
				owner.velocity.Y = -owner.jumpdy * WATER_EXIT;
			}

			if (owner.isPlav) {
				owner.velocity.Y -= owner.plavdy;
			}
		}

		// Whether there's room above, and above just ahead, to jump
		public function canJumpUp():Boolean {
			var x:Number = owner.coordinates.X;
			var y:Number = owner.coordinates.Y;
			var aheadX:Number = x + HEADROOM_AHEAD * owner.storona;

			return isClear(x, y - HEADROOM_NEAR) && isClear(x, y - HEADROOM_FAR) && isClear(aheadX, y - HEADROOM_NEAR) && isClear(aheadX, y - HEADROOM_FAR);
		}
	}
}
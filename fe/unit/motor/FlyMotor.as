package fe.unit.motor {

	import fe.unit.Unit;
	import fe.util.Calc;
	import fe.unit.enums.E_AIState;
	import fe.enums.E_Direction;

	// Flying for units that also walk: takes off when falling, swimming or reaching for a target high above, lands while wandering
	public class FlyMotor implements IMotor {

		private static const FALL_TAKEOFF:int		= 6;		// Ticks of falling before the unit takes to the air
		private static const TAKEOFF_ABOVE:Number	= 80.0;		// Takes off toward a target point further above than this
		private static const FLOAT_STEP:Number		= 0.0512;	// Phase step per tick of the bobbing while flying
		private static const FLOAT_HEIGHT:Number	= 2.0;		// Vertical sway of the bobbing, against 1 side to side
		private static const HOVER_DRAG:Number		= 0.85;		// Speed kept per tick while hovering near the target
		private static const LANDING_DRAG:Number	= 0.85;		// Horizontal speed kept per tick while coming down to land
		private static const LANDING_SINK:Number	= 10.0;		// Fastest sink while coming down to land
		private static const LANDING_TIME:int		= 20;		// Ticks touching the ground before a chasing flier lands
		private static const EASE_RADIUS:Number		= 100.0;	// Closer than this to the target point, the flier eases off
		private static const BOUNCE_MIN:Number		= 50.0;		// How far off a flier with no target picks a new point after hitting a wall
		private static const BOUNCE_MAX:Number		= 150.0;
		private static const ALERT_BOUNCE:Number	= 0.5;		// Elasticity against walls while flying alert

		private var owner:Unit;
		private var definition:FlyMotor_Definition;
		private var ground:WalkMotor;					// Moves the unit while it isn't flying
		private var baseDexter:Number;					// The unit's dexterity on the ground
		private var floatPhase:Number	= Math.random();
		private var floatX:Number		= 1.0;
		private var floatY:Number		= 0.0;
		private var fallTime:int		= 0;
		private var landingTime:int		= 0;

		private function isAlert():Boolean {
			return owner.aiState != E_AIState.IDLE && owner.aiState != E_AIState.PATROL;
		}

		// Fly toward the target point, or bob about once within stalking distance of the player
		private function fly():void {
			var stalk:Number = definition.stalkDistance;
			var heading:int = owner.aiNapr;
			var stepX:Number;
			var stepY:Number;
			var length:Number;
			var limit:Number;
			var distance2:Number;
			var bounceX:Number;

			if (owner.celUnit && owner.rasst2 < stalk * stalk) {
				owner.velocity.multiply(HOVER_DRAG);
				owner.velocity.X += floatX;
				owner.velocity.Y += floatY;
			}
			else {
				stepX = owner.celX - owner.coordinates.X;
				stepY = owner.celY - (owner.coordinates.Y - owner.boundingBox.halfHeight);

				// Hit a wall: stop pushing into it, and with no target pick a point the other way
				if (owner.turnX != E_Direction.NEUTRAL) {
					stepX = 0.0;
					heading = owner.turnX;
					if (!owner.celUnit) {
						bounceX = owner.coordinates.X + Calc.floatBetween(BOUNCE_MIN, BOUNCE_MAX) * owner.turnX;
						owner.setCel(null, bounceX, owner.celY);
					}
				}

				if (owner.turnY != E_Direction.NEUTRAL) {
					stepY = 0.0;
				}

				distance2 = owner.celDX * owner.celDX + owner.celDY * owner.celDY;
				limit = Math.min(owner.accel, owner.accel * distance2 / (EASE_RADIUS * EASE_RADIUS));
				length = Math.sqrt(stepX * stepX + stepY * stepY);
				if (length > limit) {
					stepX *= limit / length;
					stepY *= limit / length;
				}

				owner.velocity.X += stepX + floatX;
				owner.velocity.Y += stepY + floatY;
			}

			ground.turnTo(heading);

			if (owner.turnY == E_Direction.UP) {
				if (landingTime > LANDING_TIME) {
					landingTime = 0;
					owner.isFly = false;
				}
				else {
					landingTime++;
				}
			}

			owner.turnX = E_Direction.NEUTRAL;
			owner.turnY = E_Direction.NEUTRAL;
			fallTime = 0;
		}

		public function FlyMotor(owner_:Unit, definition_:FlyMotor_Definition, ground_:WalkMotor) {
			owner = owner_;
			definition = definition_;
			ground = ground_;
			baseDexter = owner.dexter;
		}

		public function tick():void {
			ground.tick();

			if (owner.stay) {
				fallTime = 0;
			}
			else {
				fallTime++;
				if (fallTime > FALL_TAKEOFF) {
					owner.isFly = true;
				}
			}

			if (owner.isPlav || owner.celDY < -TAKEOFF_ABOVE) {
				owner.isFly = true;
			}

			if (owner.isFly) {
				floatPhase += FLOAT_STEP;
				floatX = Math.sin(floatPhase);
				floatY = Math.cos(floatPhase) * FLOAT_HEIGHT;
			}

			owner.elast = (owner.isFly && isAlert()) ? ALERT_BOUNCE : 0.0;
			owner.dexter = owner.isFly ? baseDexter * definition.dodge : baseDexter;
		}

		public function rethink():void {
			ground.rethink();
		}

		public function idle():void {
			ground.idle();
		}

		// A wandering flier comes down to land
		public function patrol():void {
			if (!owner.isFly) {
				ground.patrol();
				return;
			}

			if (owner.velocity.Y < LANDING_SINK) {
				owner.velocity.Y += 1.0;
			}

			owner.velocity.X *= LANDING_DRAG;

			if (owner.turnY == E_Direction.UP) {
				owner.isFly = false;
				owner.turnY = E_Direction.NEUTRAL;
			}

			ground.turnTo(owner.aiNapr);
		}

		public function chase():void {
			if (!owner.isFly || owner.levit != 0) {
				ground.chase();
				return;
			}

			fly();
		}

		public function rush():void {
			if (!owner.isFly || owner.levit != 0) {
				ground.rush();
				return;
			}

			fly();
		}

		public function hold():void {
			ground.hold();
		}

		public function leapBack():void {
			ground.leapBack();
		}

		public function turnTo(direction:int):void {
			ground.turnTo(direction);
		}

		public function jump(power:Number):void {
			ground.jump(power);
		}
	}
}
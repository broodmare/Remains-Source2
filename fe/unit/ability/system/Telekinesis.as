package fe.unit.ability.system {

	import flash.filters.GlowFilter;
	import flash.geom.ColorTransform;

	import fe.entities.Obj;
	import fe.loc.Box;
	import fe.unit.Unit;
	import fe.unit.UnitPlayer;

	// Magically grabbing an object, steering it to a point, throwing it and letting it go
	public class Telekinesis {
		public static const VANILLA_THROW:Boolean	= true;		// Let-go objects are slowed to vanilla's carry speed, so throws deal vanilla damage; false keeps the full carry speed

		private static const RELEASE:Number			= 4.0;		// Vanilla's carry speed as a multiple of accel -- its 0.8 levitation drag capped held objects there
		private static const EASE:Number			= 0.35;		// Fraction of the remaining distance covered per tick on the final approach
		private static const BESIDE_UNIT:Number		= 150.0;	// How far beside the owner a lifted unit is held
		private static const BESIDE_OBJECT:Number	= 80.0;		// How far beside the owner a lifted object is held
		private static const HOLD_HEIGHT:Number		= 40.0;		// How far above the owner's feet things are held beside it
		private static const HEAVY_MASS:Number		= 1.0;		// Boxes this heavy are worth lifting, and heavier ones are thrown slower
		private static const BOX_CHANCE:Number		= 0.3;		// Chance each suitable box is considered when looking for one to lift
		private static const FLING_X:Number			= 100.0;	// A lifted unit is thrown sideways by this much for every FLING_Y upward
		private static const FLING_Y:Number			= -30.0;
		private static const ARC_LIFT:Number		= 4.0;		// Thrown objects aim above the target by its horizontal distance divided by this

		private var owner:Unit;
		private var filter:GlowFilter;			// Glow on the held object
		private var tint:ColorTransform;		// Optional colour tint on the held object
		private var grabLevit:int;				// The levit value the object was grabbed with

		// With VANILLA_THROW, slow the held object to vanilla's carry speed, so faster carrying doesn't make throws hit harder
		private function trimRelease():void {
			var trimmed:Object;

			if (!VANILLA_THROW) { return; }

			trimmed = {x:held.velocity.X, y:held.velocity.Y};
			owner.norma(trimmed, accel * RELEASE);
			held.velocity.X = trimmed.x;
			held.velocity.Y = trimmed.y;
		}

		public var held:Obj;					// The object being held, null if none
		public var speed:Number;				// Top speed of the held object
		public var accel:Number;				// How much the held object's velocity can change per tick

		public function Telekinesis(owner_:Unit, speed_:Number, accel_:Number, filter_:GlowFilter = null, tint_:ColorTransform = null) {
			owner = owner_;
			speed = speed_;
			accel = accel_;
			filter = filter_;
			tint = tint_;
		}

		// Lift an object. Its levit value is kept while held (the player uses it as a struggle counter when lifted)
		public function grab(target:Obj, levit:int = 2):void {
			if (held) {
				release();
			}

			held = target;
			grabLevit = levit;
			target.levit = levit;
			target.teleHolder = owner;
			target.fracLevit = owner.fraction;
			target.stay = false;

			if (target is UnitPlayer) {
				UnitPlayer(target).levitFilter2 = filter;
			}
			else if (target.vis) {
				target.vis.filters = (filter != null) ? [filter] : [];

				if (tint) {
					target.vis.transform.colorTransform = tint;
				}

				if (target.vis.parent) {
					target.vis.parent.setChildIndex(target.vis, target.vis.parent.numChildren - 1);
				}
			}
		}

		// Steer the held object's centre toward a point; lets go if another caster took it, it broke free, or the game reset it
		public function hold(targetX:Number, targetY:Number):void {
			var dx:Number;
			var dy:Number;
			var distance:Number;
			var approachSpeed:Number;
			var steer:Object;

			if (!held) { return; }

			if (held.teleHolder != owner) {
				held = null;
				return;
			}

			if (held.levit == 0 || held.levit == 1 && grabLevit != 1) {
				release(false);
				return;
			}

			if (held is Unit) {
				Unit(held).isLaz = 0;		// Held units can't cling to ladders
			}

			dx = targetX - held.coordinates.X;
			dy = targetY - (held.coordinates.Y - held.boundingBox.halfHeight);
			distance = Math.sqrt(dx * dx + dy * dy);
			approachSpeed = Math.min(speed, Math.sqrt(2.0 * accel * distance + accel * accel / 4.0) - accel / 2.0, distance * EASE);
			steer = {x:-held.velocity.X, y:-held.velocity.Y};

			if (distance > 0.0) {
				steer.x += dx / distance * approachSpeed;
				steer.y += dy / distance * approachSpeed;
			}

			owner.norma(steer, accel);
			held.velocity.X += steer.x;
			held.velocity.Y += steer.y;
		}

		// Hold the object beside the owner, further out for lifted units (alicorns)
		public function holdBeside():void {
			var besideX:Number;

			if (!held) { return; }

			besideX = owner.coordinates.X + owner.storona * ((held is Unit) ? BESIDE_UNIT : BESIDE_OBJECT);
			hold(besideX, owner.coordinates.Y - HOLD_HEIGHT - held.boundingBox.halfHeight);
		}

		// A box worth lifting within maxDistance that the owner can see, or null (alicorns)
		public function findBox(maxDistance:Number):Box {
			var box:Box;

			for each (box in owner.loc.objs) {
				if (!box.levitPoss || box.wall != 0 || box.levit != 0 || box.massa < HEAVY_MASS || Math.random() >= BOX_CHANCE) {
					continue;
				}

				if (owner.getRasst2(box) > maxDistance * maxDistance) {
					continue;
				}

				if (owner.loc.isLine(owner.coordinates.X, owner.boundingBox.top, box.coordinates.X, box.boundingBox.top)) {
					return box;
				}
			}

			return null;
		}

		// Add (dx, dy), capped at force, to the held object's velocity and let it go; the thrower sets how long it stays dangerous (t_throw)
		public function throwToward(dx:Number, dy:Number, force:Number):void {
			var impulse:Object;

			if (!held) { return; }

			trimRelease();
			impulse = {x:dx, y:dy};
			owner.norma(impulse, force);

			if (held is Box) {
				Box(held).isThrow = true;
			}

			held.velocity.X += impulse.x;
			held.velocity.Y += impulse.y;
			release(false);
		}

		// Throw at a point in an arc (alicorns): lifted units are flung sideways and up, heavy objects fly slower
		public function throwAt(targetX:Number, targetY:Number, force:Number):void {
			var throwForce:Number = force;
			var dx:Number;

			if (!held) { return; }

			if (held.massa > HEAVY_MASS) {
				throwForce /= Math.sqrt(held.massa);
			}

			if (held is Unit) {
				throwToward(FLING_X * owner.storona, FLING_Y, throwForce);
			}
			else {
				dx = targetX - held.coordinates.X;
				throwToward(dx, targetY - (held.coordinates.Y - held.boundingBox.halfHeight) - Math.abs(dx) / ARC_LIFT, throwForce);
			}
		}

		// Let go of the held object. With trim, it is first slowed to vanilla's carry speed (see VANILLA_THROW)
		public function release(trim:Boolean = true):void {
			var released:Obj = held;

			if (!released) { return; }

			if (released.teleHolder != owner) {
				held = null;
				return;
			}

			if (trim) {
				trimRelease();
			}

			if (!(released is UnitPlayer) && released.vis) {
				released.vis.filters = [];

				if (tint && released.cTransform) {
					released.vis.transform.colorTransform = released.cTransform;
				}
			}

			released.levit = 0;
			released.teleHolder = null;
			held = null;
		}
	}
}
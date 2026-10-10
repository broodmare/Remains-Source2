package fe.unit.ability {
	
	import flash.filters.GlowFilter;
	import flash.geom.ColorTransform;
	
	import fe.entities.Obj;
	import fe.loc.Box;
	import fe.unit.Unit;
	import fe.unit.UnitPlayer;
	
	// Magically grabbing an object, steering it to a point, throwing it and letting it go
	public class Telekinesis {
		
		public static const VANILLA_THROW:Boolean	= true;		// true: let-go objects are trimmed to vanilla's carry speed, so throws deal vanilla damage. false: they keep the full carry speed
		private static const RELEASE:Number			= 4.00;		// Vanilla's carry speed as a multiple of accel (its 0.8 levitation drag capped held objects there)
		private static const EASE:Number			= 0.35;		// Fraction of the remaining distance covered per tick on the final approach
		
		public var held:Obj;					// The object being held, null if none
		public var speed:Number;				// Top speed of the held object
		public var accel:Number;				// How much the held object's velocity can change per tick
		
		private var owner:Unit;
		private var filter:GlowFilter;			// Glow on the held object
		private var tint:ColorTransform;		// Optional colour tint on the held object
		private var grabLevit:int;				// The levit value the object was grabbed with
		
		public function Telekinesis(owner:Unit, speed:Number, accel:Number, filter:GlowFilter = null, tint:ColorTransform = null) {
			this.owner	= owner;
			this.speed	= speed;
			this.accel	= accel;
			this.filter	= filter;
			this.tint	= tint;
		}
		
		// Lift an object. Its levit value is kept while held (the player uses it as a struggle counter when lifted)
		public function grab(obj:Obj, levit:int = 2):void {
			if (held) {
				release();
			}
			
			held			= obj;
			grabLevit		= levit;
			obj.levit		= levit;
			obj.teleHolder	= owner;
			obj.fracLevit	= owner.fraction;
			obj.stay		= false;
			
			if (obj is UnitPlayer) {
				(obj as UnitPlayer).levitFilter2 = filter;
			}
			else if (obj.vis) {
				obj.vis.filters = filter ? [filter] : [];
				
				if (tint) {
					obj.vis.transform.colorTransform = tint;
				}
				
				if (obj.vis.parent) {
					obj.vis.parent.setChildIndex(obj.vis, obj.vis.parent.numChildren - 1);
				}
			}
		}
		
		// Steer the held object's centre toward a point: accelerate by up to accel per tick toward the fastest speed
		// Returns false if there is nothing held any more (taken by another caster, broke free, or reset by the game)
		public function hold(tx:Number, ty:Number):Boolean {
			var dx:Number;
			var dy:Number;
			var dist:Number;
			var spd:Number;
			var steer:Object;
			
			if (!held) {
				return false;
			}
			
			if (held.teleHolder != owner) {
				held = null;
				return false;
			}
			
			if (held.levit == 0 || held.levit == 1 && grabLevit != 1) {
				release(false);
				return false;
			}
			
			if (held is Unit) {
				(held as Unit).isLaz = 0;	// Held units can't cling to ladders
			}
			
			dx = tx - held.coordinates.X;
			dy = ty - (held.coordinates.Y - held.boundingBox.halfHeight);
			dist = Math.sqrt(dx * dx + dy * dy);
			spd = Math.min(speed, Math.sqrt(2 * accel * dist + accel * accel / 4) - accel / 2, dist * EASE);
			steer = {x:-held.velocity.X, y:-held.velocity.Y};
			
			if (dist > 0) {
				steer.x += dx / dist * spd;
				steer.y += dy / dist * spd;
			}
			
			owner.norma(steer, accel);
			held.velocity.X += steer.x;
			held.velocity.Y += steer.y;
			
			return true;
		}
		
		// Hold the object beside the owner, further out for lifted units (alicorns)
		public function holdBeside():Boolean {
			if (!held) {
				return false;
			}
			
			return hold(owner.coordinates.X + owner.storona * ((held is Unit) ? 150 : 80), owner.coordinates.Y - 40 - held.boundingBox.halfHeight);
		}
		
		// Find a box worth lifting within maxDist that the owner can see (alicorns)
		public function findBox(maxDist:Number):Box {
			for each (var b:Box in owner.loc.objs) {
				if (b.levitPoss && b.wall == 0 && b.levit == 0 && b.massa >= 1 && Math.random() < 0.3) {
					if (owner.getRasst2(b) > maxDist * maxDist) {
						continue;
					}
					
					if (owner.loc.isLine(owner.coordinates.X, owner.boundingBox.top, b.coordinates.X, b.boundingBox.top)) {
						return b;
					}
				}
			}
			
			return null;
		}
		
		// Throw the held object by adding (dx, dy), capped at force, to its velocity, then let it go.
		// How long the thrown object stays dangerous (t_throw) is up to the thrower
		public function throwToward(dx:Number, dy:Number, force:Number):void {
			var p:Object;
			
			if (!held) {
				return;
			}
			
			trimRelease();
			p = {x:dx, y:dy};
			owner.norma(p, force);
			
			if (held is Box) {
				(held as Box).isThrow = true;
			}
			
			held.velocity.X += p.x;
			held.velocity.Y += p.y;
			release(false);
		}
		
		// Throw at a point in an arc (alicorns): lifted units are flung sideways and up, heavy objects fly slower
		public function throwAt(tx:Number, ty:Number, force:Number):void {
			var dx:Number;
			
			if (!held) {
				return;
			}
			
			if (held.massa > 1) {
				force /= Math.sqrt(held.massa);
			}
			
			if (held is Unit) {
				throwToward(100 * owner.storona, -30, force);
			}
			else {
				dx = tx - held.coordinates.X;
				throwToward(dx, ty - (held.coordinates.Y - held.boundingBox.halfHeight) - Math.abs(dx) / 4, force);
			}
		}
		
		// Let go of the held object. With trim, it is first slowed to vanilla's carry speed (see VANILLA_THROW)
		public function release(trim:Boolean = true):void {
			var obj:Obj = held;
			
			if (!obj) {
				return;
			}
			
			if (obj.teleHolder != owner) {
				held = null;
				return;
			}
			
			if (trim) {
				trimRelease();
			}
			
			if (!(obj is UnitPlayer) && obj.vis) {
				obj.vis.filters = [];
				
				if (tint && obj.cTransform) {
					obj.vis.transform.colorTransform = obj.cTransform;
				}
			}
			
			obj.levit		= 0;
			obj.teleHolder	= null;
			held			= null;
		}
		
		// With VANILLA_THROW, slow the held object to vanilla's carry speed, so faster carrying doesn't make throws hit harder
		private function trimRelease():void {
			var v:Object;
			
			if (!VANILLA_THROW) {
				return;
			}
			
			v = {x:held.velocity.X, y:held.velocity.Y};
			owner.norma(v, accel * RELEASE);
			held.velocity.X = v.x;
			held.velocity.Y = v.y;
		}
	}
}

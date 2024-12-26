package fe.projectile {

	import fe.util.Vector2;
	import fe.entities.BoundingBox;
	import fe.unit.Unit;
	
	public class SmartBullet  extends Bullet {
		
		public var manevr:Number = 3;
		public var maxVel:int = 150;
		public var cel:Unit;
		static var p:Object = {x:0, y:0};

		public function SmartBullet(own:Unit, coords:Vector2, visClass:Class=null, addobj:Boolean=true) {
			super(own, coords, visClass);
			vRot = true;
		}
		
		public function setCel(ncel:Unit, man:Number=3) {
			cel = ncel;
			manevr = man;
		}
		
		public override function step():void {
			if (!babah && cel && manevr>0) {
				p.x = cel.coordinates.X - coordinates.X;
				p.y = (cel.boundingBox.top + cel.boundingBox.bottom) / 2 - coordinates.Y;
				norma(p,manevr);
				p.x += velocity.X;
				p.y += velocity.Y;
				if (vel < maxVel) {
					vel += accel;
				}
				norma(p, vel);
				velocity.X = p.x;
				velocity.Y = p.y;
			}
			super.step();
			rot = Math.atan2(velocity.Y, velocity.X);
			if (vis) vis.rotation = rot * 180 / Math.PI;
		}
	}
}
package fe.game.domain.projectile {

	import fe.engine.utils.Numbers;
	import fe.engine.utils.Vec2;
	import fe.game.domain.entities.BoundingBox;
	import fe.game.domain.units.Unit;
	
	public class SmartBullet  extends Bullet {
		
		public var manevr:Number = 3;
		public var maxVel:int = 150;
		public var cel:Unit;
		private static var p:Object = {x:0, y:0};

		public function SmartBullet(own:Unit, coords:Vec2, visClass:Class=null) {
			super(own, coords, visClass);
			vRot = true;
		}
		
		public function setCel(ncel:Unit, man:Number=3):void {
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
			
			if (vis) {
				vis.rotation = rot * Numbers.RAD_TO_DEG;
			}
		}
	}
}
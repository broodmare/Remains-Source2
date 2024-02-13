package fe.projectile
{
	import fe.unit.Unit;
	
	public class SmartBullet  extends Bullet
	{
		public var manevr:Number=3;
		public var maxVel=150;
		public var cel:Unit;
		static var p:Object={x:0, y:0};

		public function SmartBullet(own:Unit, nx:Number, ny:Number, visClass:Class=null, addobj:Boolean=true)
		{
			super(own,nx,ny,visClass);
			vRot=true;
		}
		
		public function setCel(ncel:Unit, man:Number=3)
		{
			cel=ncel;
			manevr=man;
		}
		
		public override function step():void
		{
			if (!babah && cel && manevr>0)
			{
				p.x = cel.coordinates.X - coordinates.X;
				p.y = (cel.topBound + cel.bottomBound) / 2 - coordinates.Y;
				norma(p,manevr);
				p.x += dx;
				p.y += dy;
				if (vel<maxVel)	vel+=accel;
				norma(p,vel);
				dx=p.x, dy=p.y;
			}
			super.step();
			rot=Math.atan2(dy,dx);
			if (vis) vis.rotation=rot*180/Math.PI;
		}
	}
}
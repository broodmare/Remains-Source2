package fe.weapon 
{
	import fe.World;
	import fe.Snd;
	import fe.unit.Unit;
	import fe.loc.Tile
	import fe.projectile.Bullet;
	
	public class WKick extends Weapon
	{
		public var kick:Boolean=true;
		
		public function WKick(own:Unit, id:String, nvar:int=0)
		{
			super(own, id,nvar);
			vBullet=visualPunch;
			b=new Bullet(own, coordinates.X - (dlina / 2) * storona, coordinates.Y - dlina, null, false);
			b.weap=this;
			dopCh=0;
			dopEffect='stun';
			setBullet(b);
		}
		
		public override function actions():void
		{
			coordinates.X = owner.coordinates.X;
			coordinates.Y = owner.coordinates.Y;
			storona=owner.storona;
			if (t_attack>0) t_attack--;
			if (t_attack==rapid-8) {
				b.retDam=true;
				b.off=false;
				b.tilehit=false;
				b.loc=owner.loc;
				b.knocky=-0.1;
				b.knockx=storona;
				b.parrDict=null;
				b.dist=0;
				b.damage=damage*World.w.pers.punchDamMult;
				b.otbros=otbros*World.w.pers.punchDamMult;
				b.destroy=destroy;
				b.probiv=1;
				var vverh:Boolean=false;
				if (World.w.pers.punchDamMult>1) {
					dopCh=(World.w.pers.punchDamMult-1);
					dopDamage=30;
				}
				if (kick) {
					//b.probiv=true;
					storona=-owner.storona;
					var t1:Tile=owner.loc.getAbsTile(coordinates.X + storona * 60, coordinates.Y - 30);
					var t2:Tile=owner.loc.getAbsTile(coordinates.X + storona * 60, coordinates.Y - 50);
					if (t1 && t2 && t2.thre<t1.thre) vverh=true;
					b.knockx=storona;
					b.damage*=2;
					b.otbros*=1.5;
					b.destroy=World.w.pers.kickDestroy;
					dopDamage=60;
					if (vverh) {
						b.bindMove(coordinates.X + storona * 70, coordinates.Y - 50, coordinates.X + storona * 20, coordinates.Y - 50);
						b.bindMove(coordinates.X + storona * 70, coordinates.Y - 30, coordinates.X + storona * 20, coordinates.Y - 30);
					} else {
						b.bindMove(coordinates.X + storona * 70, coordinates.Y - 30, coordinates.X + storona * 20, coordinates.Y - 30);
						b.bindMove(coordinates.X + storona * 70, coordinates.Y - 50, coordinates.X + storona * 20, coordinates.Y - 50);
					}
					Snd.ps('m_big', coordinates.X, coordinates.Y, 0, Math.random()*0.2+0.1);
				} else {
					var t1:Tile=owner.loc.getAbsTile(coordinates.X + storona * 60, coordinates.Y - 30);
					var t2:Tile=owner.loc.getAbsTile(coordinates.X + storona * 60, coordinates.Y - 50);
					if (t1 && t2 && t2.thre<t1.thre) vverh=true;
					if (vverh) b.bindMove(coordinates.X + storona * 60, coordinates.Y - 50, coordinates.X + storona * 20, coordinates.Y - 50);
					b.bindMove(coordinates.X + storona * 60, coordinates.Y - 30, coordinates.X + storona * 20, coordinates.Y - 30);
					for (var i=1; i<=5; i++) {
						if (i!=3 && !(vverh && i==5)) b.bindMove(coordinates.X + storona * 60, coordinates.Y - i * 10, coordinates.X + storona * 20, coordinates.Y - i * 10);
					}
					Snd.ps('m_med', coordinates.X, coordinates.Y, 0, Math.random()*0.2+0.1);
				}
			}
		}

		public override function attack(waitReady:Boolean=false):Boolean {
			if (t_attack<=0) {
				t_attack=rapid;
			}
			return true;
		}
		
		public override function animate():void {

		}
	}	
}
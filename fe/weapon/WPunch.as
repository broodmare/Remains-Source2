package fe.weapon  {
	
	import fe.World;
	import fe.Snd;
	import fe.unit.Unit;
	public class WPunch extends Weapon {
		
		public var zadok:Boolean=false;	//может действовать назад

		public function WPunch(own:Unit, id:String, nvar:int=0){
			super(own, id,nvar);
			vBullet=visualPunch;
		}
		
		public override function actions() {
			owner.setPunchWeaponPos(this);
			if (t_attack>0) t_attack--;
			if (t_attack==rapid-5) {
				if (owner.player) {
					var deltaX:Number=owner.celX-X;
					var deltaY:Number=owner.celY-Y;
					var signY:int=(deltaY>0)?1:-1;
					if (Math.abs(deltaY)>Math.abs(deltaX)) deltaY=Math.abs(deltaX)*signY;
					rot=Math.atan2(deltaY, deltaX);
				}
				shoot();
				if (owner.player) {
					b.damage*=World.w.pers.punchDamMult;
				}
				b.liv=5;
				if (zadok && (rot<Math.PI/2 && rot>-Math.PI/2 && owner.storona<0 || (rot>Math.PI/2 || rot<-Math.PI/2) && owner.storona>0)) {	//kick
					b.otbros=otbros*1.5;
					b.damage=damage*2*damMult;
					if (owner.player) {
						b.damage*=World.w.pers.punchDamMult;
						b.destroy=World.w.pers.kickDestroy;
					}
					Snd.ps('m_big',X,Y,0,Math.random()*0.2+0.1);
				} else {
					Snd.ps('m_med',X,Y,0,Math.random()*0.2+0.1);
				}
				b.probiv=1;
				b.retDam=true;
			}
		}

		public override function attack(waitReady:Boolean=false):Boolean {
			if (t_attack<=0) {
				t_attack=rapid;
			}
			return true;
		}
		
		public override function animate() {
		}
	}
	
}

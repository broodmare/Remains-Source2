package fe.weapon {

	import fe.World;
	import fe.Snd;
	import fe.unit.Unit;

	public class WPunch extends Weapon {
		
		public var zadok:Boolean = false;	// [Can act backwards]

		// Constructor
		public function WPunch(w:Weapon) {
			super();
			// Get all the properties from an already made default weapon and use them
			WeaponCopier.copyFrom(w, this);

			vBullet = visualPunch;
		}
		
		public override function actions():void {

			owner.setPunchWeaponPos(this);
			if (t_attack > 0) {
				t_attack--;
			}

			if (t_attack == rapid - 5) {
				if (owner.player) {
					var deltaX:Number = owner.celX - coordinates.X;
					var deltaY:Number = owner.celY - coordinates.Y;
					var signY:int=(deltaY > 0) ? 1 : -1;
					
					if (Math.abs(deltaY) > Math.abs(deltaX)) {
						deltaY = Math.abs(deltaX) * signY;
					}
					
					rot = Math.atan2(deltaY, deltaX);
				}
				
				shoot();
				
				if (owner.player) {
					b.damage *= World.w.pers.punchDamMult;
				}
				
				b.liv = 5;
				
				if (zadok && (rot < HALF_PI && rot > -HALF_PI && owner.storona < 0 || (rot > HALF_PI || rot < -HALF_PI) && owner.storona > 0)) {	//kick
					b.otbros = otbros * 1.5;
					b.damage = damage * 2 * damMult;
					
					if (owner.player) {
						b.damage *= World.w.pers.punchDamMult;
						b.destroy = World.w.pers.kickDestroy;
					}
					
					Snd.ps('m_big', coordinates.X, coordinates.Y, 0, Math.random() * 0.20 + 0.10);
				}
				else {
					Snd.ps('m_med', coordinates.X, coordinates.Y, 0, Math.random() * 0.20 + 0.10);
				}
				
				b.probiv = 1;
				b.retDam = true;
			}
		}

		public override function attack(waitReady:Boolean = false):Boolean {
			if (t_attack <= 0) {
				t_attack = rapid;
			}

			return true;
		}
	}
}
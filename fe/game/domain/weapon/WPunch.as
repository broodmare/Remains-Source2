package fe.game.domain.weapon {

	import fe.engine.utils.Numbers;
	import fe.engine.utils.SymbolFactory;
	import fe.game.GameContainer;
	import fe.engine.audio.Sound;
	import fe.game.domain.units.Unit;
	import fe.engine.utils.Vec2;
	import fe.game.enums.E_Direction;

	public class WPunch extends Weapon {
		
		public var zadok:Boolean = false;	// [Can act backwards]

		// Use WeaponManager.cloneWeapon() to create weapons
		public function WPunch() {
			super();
		}

		public override function init(data:Object):void {
			// The movieclip with the bullet effect
			vBullet = SymbolFactory.fetchSymbolClass("visualPunch");
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
					var signY:Vec2=(deltaY > 0) ? E_Direction.DOWN : E_Direction.UP;
					
					if (Math.abs(deltaY) > Math.abs(deltaX)) {
						deltaY = Math.abs(deltaX) * signY.Y;
					}
					
					rot = Math.atan2(deltaY, deltaX);
				}
				
				shoot();
				
				if (owner.player) {
					b.damage *= GameContainer.reference.pers.punchDamMult;
				}
				
				b.liv = 5;
				
				if (zadok && (rot < Numbers.HALF_PI && rot > -Numbers.HALF_PI && owner.storona == E_Direction.LEFT || (rot > Numbers.HALF_PI || rot < -Numbers.HALF_PI) && owner.storona == E_Direction.RIGHT)) {	//kick
					b.otbros = otbros * 1.5;
					b.damage = damage * 2 * damMult;
					
					if (owner.player) {
						b.damage *= GameContainer.reference.pers.punchDamMult;
						b.destroy = GameContainer.reference.pers.kickDestroy;
					}
					
					Sound.ps('m_big', coordinates.X, coordinates.Y, 0, Math.random() * 0.20 + 0.10);
				}
				else {
					Sound.ps('m_med', coordinates.X, coordinates.Y, 0, Math.random() * 0.20 + 0.10);
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
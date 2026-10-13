package fe.unit.attack {

	import fe.unit.Unit;
	import fe.util.Calc;
	import fe.weapon.Weapon;
	import fe.unit.enums.E_AIState;

	// Fires a second weapon every so often while the unit fights, and with no target in sight a blind weapon if it has one
	public class SideWeaponAttack implements IAttack {

		private var owner:Unit;
		private var definition:SideWeaponAttack_Definition;
		private var weapon:Weapon;
		private var blindWeapon:Weapon;			// Fired instead when no target is in sight, null for none
		private var timeLeft:int;

		private function isActive():Boolean {
			var state:int = owner.aiState;

			return state == E_AIState.CHASE || state == E_AIState.HOLD || state == E_AIState.FLEE || state == E_AIState.DASH;
		}

		public function SideWeaponAttack(owner_:Unit, definition_:SideWeaponAttack_Definition, weapon_:Weapon, blindWeapon_:Weapon) {
			owner = owner_;
			definition = definition_;
			weapon = weapon_;
			blindWeapon = blindWeapon_;
			timeLeft = Calc.intBetween(definition.intervalMin, definition.intervalMax);
		}

		public function tick():void {
			if (!isActive()) { return; }

			timeLeft--;
			if (timeLeft > 0) { return; }

			if (owner.celUnit) {
				if (Math.random() < definition.chance) {
					weapon.attack();
				}
			}
			else if (blindWeapon) {
				blindWeapon.attack();
			}

			timeLeft = Calc.intBetween(definition.intervalMin, definition.intervalMax);
		}
	}
}
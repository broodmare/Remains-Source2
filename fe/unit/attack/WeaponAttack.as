package fe.unit.attack {

	import fe.unit.Unit;
	import fe.unit.enums.E_AIState;

	// Uses the unit's current weapon on its target
	public class WeaponAttack implements IAttack {

		private var owner:Unit;
		private var definition:WeaponAttack_Definition;

		private function isActive():Boolean {
			switch (owner.aiState) {
				case E_AIState.CHASE: {
					return definition.whileChasing;
				}
				case E_AIState.HOLD: {
					return definition.whileHolding;
				}
				case E_AIState.FLEE: {
					return definition.whileFleeing;
				}
				default: {
					return false;
				}
			}
		}

		private function isInRange():Boolean {
			if (definition.rangeX > 0 && Math.abs(owner.celDX) > definition.rangeX) { return false; }
			if (definition.rangeY > 0 && Math.abs(owner.celDY) > definition.rangeY) { return false; }

			return true;
		}

		public var cooldownLeft:int = 0;		// Ticks until the weapon may be used again

		public function WeaponAttack(owner_:Unit, definition_:WeaponAttack_Definition) {
			owner = owner_;
			definition = definition_;
		}

		public function tick():void {
			if (cooldownLeft > 0) {
				cooldownLeft--;
			}

			if (!isActive() || !owner.currentWeapon || cooldownLeft > 0) { return; }
			if (definition.needsTarget && !owner.celUnit) { return; }
			if (definition.stopsWhenShocked && owner.shok > 0) { return; }
			if (!isInRange() || Math.random() >= definition.chance) { return; }

			if (definition.leapAbove > 0 && owner.celDY < -definition.leapAbove) {
				owner.motor.jump(1.0);
				owner.velocity.X = 0.0;
			}

			owner.currentWeapon.attack();
			cooldownLeft = definition.cooldown;
		}
	}
}
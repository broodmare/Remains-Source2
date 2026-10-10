package fe.unit.attack.system {

	import fe.unit.Unit;
	import fe.unit.ai.model.AIState;
	import fe.unit.attack.model.WeaponAttack_Definition;

	// Uses the unit's current weapon on its target
	public class WeaponAttack implements IAttack {

		private var owner:Unit;
		private var definition:WeaponAttack_Definition;

		public var cooldownLeft:int = 0;		// Ticks until the weapon may be used again

		public function WeaponAttack(owner_:Unit, definition_:WeaponAttack_Definition) {
			owner = owner_;
			definition = definition_;
		}

		public function tick():void {
			if (cooldownLeft > 0) {
				cooldownLeft--;
			}

			if (!(owner.aiState == AIState.CHASE && definition.whileChasing || owner.aiState == AIState.HOLD && definition.whileHolding)) { return; }
			if (!owner.currentWeapon || cooldownLeft > 0) { return; }

			if (definition.leapAbove > 0 && owner.celDY < -definition.leapAbove) {
				owner.motor.jump(1.0);
				owner.velocity.X = 0.0;
			}

			owner.currentWeapon.attack();
			cooldownLeft = definition.cooldown;
		}
	}
}
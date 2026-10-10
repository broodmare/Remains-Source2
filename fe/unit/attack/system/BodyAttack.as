package fe.unit.attack.system {

	import fe.unit.Unit;
	import fe.unit.ai.model.AIState;
	import fe.unit.attack.model.BodyAttack_Definition;

	// Rams the target with the unit's own body whenever the target is close
	public class BodyAttack implements IAttack {

		private var owner:Unit;
		private var definition:BodyAttack_Definition;

		public function BodyAttack(owner_:Unit, definition_:BodyAttack_Definition) {
			owner = owner_;
			definition = definition_;
		}

		public function tick():void {
			var target:Unit = owner.celUnit;
			var strength:Number = (owner.shok <= 0) ? definition.strength : definition.shockedStrength;

			if (!(owner.aiState == AIState.CHASE && definition.whileChasing || owner.aiState == AIState.HOLD && definition.whileHolding)) { return; }
			if (!target) { return; }
			if (Math.abs(owner.celDX) > definition.rangeX || Math.abs(owner.celDY) > definition.rangeY) { return; }

			if (strength > 0) {
				owner.attKorp(target, strength);
			}

			if (definition.hop > 0 && owner.isLaz == 0) {
				owner.motor.jump(definition.hop);
			}
		}
	}
}
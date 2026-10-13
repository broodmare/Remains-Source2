package fe.game.domain.units.attack {

	import fe.game.domain.units.Unit;
	import fe.game.domain.units.enums.E_AIState;
	import fe.game.enums.E_Direction;

	// Rams the target with the unit's own body whenever the target is close
	public class BodyAttack implements IAttack {

		private static const DASH_HIT_END:int = 5;		// Ticks a dash goes on after it hits

		private var owner:Unit;
		private var definition:BodyAttack_Definition;

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
				case E_AIState.DASH: {
					return definition.whileDashing;
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

		public function BodyAttack(owner_:Unit, definition_:BodyAttack_Definition) {
			owner = owner_;
			definition = definition_;
		}

		public function tick():void {
			var target:Unit = owner.celUnit;
			var strength:Number = (owner.shok <= 0) ? definition.strength : definition.shockedStrength;

			if (!isActive() || !target || !isInRange()) { return; }
			if (Math.random() >= definition.chance) { return; }

			if (Math.abs(owner.velocity.X) <= definition.slowSpeed) {
				strength *= definition.slowFactor;
			}

			if (strength > 0 && owner.attKorp(target, strength) && owner.aiState == E_AIState.DASH) {
				owner.aiTCh = DASH_HIT_END;
			}

			if (definition.hop > 0 && owner.isLaz == E_Direction.NEUTRAL) {
				owner.motor.jump(definition.hop);
			}
		}
	}
}
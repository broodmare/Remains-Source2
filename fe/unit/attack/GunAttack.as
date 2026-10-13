package fe.unit.attack {

	import fe.unit.Unit;
	import fe.util.Calc;
	import fe.weapon.Weapon;
	import fe.unit.enums.E_AIState;
	import fe.enums.E_Direction;

	// Shoots the unit's current weapon while it chases, holds or flees: single shots now and then, or bursts with pauses
	public class GunAttack implements IAttack {

		private static const BURST_SPREAD:Number	= 0.2;		// Bursts vary in length by up to this fraction
		private static const BURST_PAUSE:Number		= 0.25;		// Fraction of a burst's length spent not firing at its end

		private var owner:Unit;
		private var definition:GunAttack_Definition;
		private var burstLeft:int = 0;							// Ticks left in the current burst, pause included

		private function isActive():Boolean {
			var state:int = owner.aiState;

			return state == E_AIState.CHASE || state == E_AIState.HOLD || state == E_AIState.FLEE;
		}

		public function GunAttack(owner_:Unit, definition_:GunAttack_Definition) {
			owner = owner_;
			definition = definition_;
		}

		public function tick():void {
			var weapon:Weapon = owner.currentWeapon;
			var liftedAim:Number = owner.levitAttack;
			var burst:int = definition.burst;
			var singleChance:Number;

			if (!isActive() || !weapon) { return; }
			if (owner.isLaz != E_Direction.NEUTRAL && !definition.whileClimbing) { return; }

			if (definition.isSniper) {
				owner.mazil = 0;
			}
			else {
				owner.mazil = (owner.aiState == E_AIState.HOLD) ? definition.holdSpread : definition.moveSpread;
			}

			if (definition.isShakenWhenLifted && owner.levit != 0) {
				owner.mazil = definition.levitSpread;
				if (liftedAim < 1.0 && (liftedAim == 0.0 || Math.random() > liftedAim)) { return; }
			}

			if (burst == 0) {
				singleChance = owner.celUnit ? definition.singleChance : definition.blindChance;
				if (owner.shok <= 0 && Math.random() < singleChance) {
					weapon.attack();
				}

				return;
			}

			if (definition.isSniper && !owner.celUnit) { return; }

			if (burstLeft <= 0) {
				burstLeft = Math.round(Calc.floatBetween(1.0 - BURST_SPREAD, 1.0 + BURST_SPREAD) * burst);
			}

			if (burstLeft > burst * BURST_PAUSE) {
				weapon.attack();
			}

			burstLeft--;
		}
	}
}
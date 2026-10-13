package fe.util {

	// Currency values can be fractional while a trade is being assembled, but caps are whole units.
	public final class TradeValue {

		private static const INTEGER_EPSILON:Number = 0.0000001;

		// Collapse floating-point noise when a value is effectively a whole number.
		public static function normalize(value:Number):Number {
			if (isNaN(value)) {
				return 0;
			}

			var nearestInteger:Number = Math.round(value);
			if (Math.abs(value - nearestInteger) < INTEGER_EPSILON) {
				return nearestInteger;
			}

			return value;
		}

		// Amount charged when a fractional price is settled in whole caps.
		public static function charge(value:Number):int {
			value = normalize(value);
			return value > 0 ? Math.ceil(value) : 0;
		}

		// Amount paid out when a fractional sale is settled in whole caps.
		public static function payout(value:Number):int {
			value = normalize(value);
			return value > 0 ? Math.floor(value) : 0;
		}
	}
}

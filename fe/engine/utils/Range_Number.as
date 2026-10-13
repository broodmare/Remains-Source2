package fe.engine.utils {

	// Two Numbers constituting a sanity-checked Range
	public final class Range_Number {

		private var low:Number;
		private var high:Number;

		public function Range_Number(min_:Number, max_:Number) {
			if (isNaN(min_) || isNaN(max_) || min_ > max_) {
				throw new ArgumentError("Range_Number.as/Range_Number() - Error: invalid range [" + min_ + " , " + max_ + "]");
			}

			low = min_;
			high = max_;
		}

		public function get min():Number { return low; }
		public function get max():Number { return high; }

		// A random value between min (inclusive) and max (exclusive)
		public function pick():Number { return Calc.floatBetween(low, high); }

		public function contains(value:Number):Boolean { return value >= min && value <= max; }
	}
}
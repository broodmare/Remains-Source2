package fe.util {

	// Two ints constituting a sanity-checked Range
	public final class Range_int {

		private var low:int;
		private var high:int;

		public function Range_int(min_:int, max_:int) {
			if (min_ > max_) {
				throw new ArgumentError("Range_int.as/Range_int() - Error: invalid range [" + min_ + " , " + max_ + "]");
			}

			low = min_;
			high = max_;
		}

		public function get min():int { return low; }
		public function get max():int { return high; }

		// A random value between min and max, both inclusive
		public function pick():int { return Calc.intBetween(low, high); }

		public function contains(value:int):Boolean { return value >= min && value <= max; }
	}
}
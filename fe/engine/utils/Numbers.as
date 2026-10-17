package fe.engine.utils {

	public class Numbers {

		public static const EPSILON:Number = 0.0000001;

		// Fractions
		public static const ONE_SIXTH:Number = 1 / 6;
		public static const FIVE_SIXTH:Number = 5 / 6;

		// π Pie
		public static const ONE_PI:Number = Math.PI;
		public static const HALF_PI:Number = ONE_PI / 2;
		public static const QUARTER_PI:Number = ONE_PI / 4;
		public static const SIXTH_PI:Number = ONE_PI / 6;
		public static const TWO_PI:Number = 2 * ONE_PI;
		public static const NEGATIVE_SIXTH_PI:Number = -SIXTH_PI;
		public static const NEGATIVE_HALF_PI:Number = -HALF_PI;
		public static const NEGATIVE_FIVE_SIXTH_PI:Number = -ONE_PI * FIVE_SIXTH;
		public static const POSITIVE_FIVE_SIXTH_PI:Number = ONE_PI * FIVE_SIXTH;

		// Conversions
		public static const RAD_TO_DEG:Number = 180 / ONE_PI;
		public static const DEG_TO_RAD:Number = ONE_PI / 180;
	}
}
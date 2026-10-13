package fe.enums {

	// Which way along one axis, as the sign of a step that way, so it can scale a speed or offset
	// UP shares LEFT's value and DOWN shares RIGHT's; tile piece data stores these numbers, so they never change
	public class E_Direction {
		public static const UP:int		= -1;	// Screen y grows downward
		public static const DOWN:int	= 1;
		public static const LEFT:int	= -1;
		public static const RIGHT:int	= 1;
		public static const NEUTRAL:int	= 0;	// Neither way, such as standing still or off a ladder
	}
}
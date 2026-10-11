package fe.loc.tile {

	// What a tile piece does to the units that touch it
	public class TileBehaviour {
		public static const NONE:int			= 0;	// Nothing, units pass through
		public static const SOLID:int			= 1;	// Blocks units, bullets and light
		public static const PLATFORM:int		= 2;	// Stood on from above, dropped through from on top
		public static const LADDER:int			= 3;	// Climbed
		public static const SLOPE:int			= 4;	// Walked up and down like a ramp
		public static const HIDING_SPOT:int		= 5;	// The player can hide in front of it
	}
}

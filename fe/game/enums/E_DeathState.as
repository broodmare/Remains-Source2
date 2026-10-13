package fe.game.enums {

	// The stages after the player dies, in the order they run
	public class E_DeathState {
		public static const NONE:int		= 0;	// The player is alive
		public static const DYING:int		= 1;	// The death animation plays
		public static const FADE_OUT:int	= 2;	// The screen fades to black
		public static const RESPAWN:int		= 3;	// The player is back at the checkpoint and the screen fades in
		public static const RESURRECT:int	= 4;	// The player gets up, still without control
		public static const CONTROL:int		= 5;	// The player has control again
	}
}
package fe.game.enums {

	// The stages of leaving a land, in the order they run
	public class E_ExitState {
		public static const NONE:int		= 0;	// Not leaving a land
		public static const LEAVING:int		= 1;	// The player has lost control, the fade starts next frame
		public static const FADE_OUT:int	= 2;	// The screen fades to black
		public static const LOAD_SCREEN:int	= 3;	// The loading screen is up, so it draws before the next land loads
		public static const ENTER_LAND:int	= 4;	// The next land loads
		public static const PROMPT:int		= 5;	// The story screen asks for a click, when there is one
		public static const WAIT:int		= 6;	// Holds until the player clicks; the land doesn't update
		public static const FADE_IN:int		= 7;	// The new land fades in from black
		public static const SHOW_GUI:int	= 8;	// The HUD comes back on
	}
}
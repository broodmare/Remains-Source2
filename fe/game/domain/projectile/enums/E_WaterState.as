package fe.game.domain.projectile.enums {

	// Whether a bullet was in water on its last step, so it splashes only when it crosses the surface
	public class E_WaterState {
		public static const UNCHECKED:int	= -1;	// Not looked at yet, so the first step never splashes
		public static const OUT:int			= 0;	// Out of water
		public static const IN:int			= 1;	// In water
	}
}
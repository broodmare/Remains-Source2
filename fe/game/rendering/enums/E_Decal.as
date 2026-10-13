package fe.game.rendering.enums {

	// The mark a hit leaves on walls and tiles. Weapon data stores these numbers, so they never change, and code
	// groups them by range: bullets and blows up to BLOW_LARGE, physical marks up to EXPLOSION, burns from FIRE, melts from PLASMA
	public class E_Decal {
		public static const NONE:int				= 0;
		public static const BULLET_SMALL:int		= 1;	// Pistols and submachine guns
		public static const BULLET_MEDIUM:int		= 2;	// Revolvers and rifles
		public static const BULLET_LARGE:int		= 3;	// Anti-materiel rifles and railguns
		public static const BLOW_SMALL:int			= 4;	// Light melee weapons
		public static const BLOW_MEDIUM:int			= 5;	// Heavy melee weapons
		public static const BLOW_LARGE:int			= 6;
		public static const EXPLOSION:int			= 9;
		public static const FIRE:int				= 11;
		public static const LASER:int				= 12;
		public static const LASER_SMALL:int			= 13;
		public static const PLASMA:int				= 15;
		public static const PLASMA_BLUE:int			= 16;
		public static const PLASMA_PINK:int			= 17;
		public static const CRYO:int				= 18;
		public static const ENERGY_EXPLOSION:int	= 19;	// Plasma, spark and balefire blasts
		public static const STOMP:int				= 100;	// A unit landing hard on a tile: marks like BLOW_SMALL, but too weak for tough tiles
	}
}
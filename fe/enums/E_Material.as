package fe.enums {

	// What a tile, box or unit is made of, which picks the sparks, debris, marks and sound when it's hit
	// Box data stores these numbers, so they never change
	public class E_Material {
		public static const NONE:int		= 0;	// Nothing to hit, or a hit that makes no sound or marks
		public static const METAL:int		= 1;	// Conducts electricity in electrified rooms
		public static const STONE:int		= 2;
		public static const WOOD:int		= 3;
		public static const BRICK:int		= 4;
		public static const GLASS:int		= 5;
		public static const EARTH:int		= 6;
		public static const FORCE_FIELD:int	= 7;
		public static const MEAT:int		= 10;
		public static const SLIME:int		= 12;
		public static const SHIELD:int		= 13;	// A unit's energy shield, which flares when shot
	}
}
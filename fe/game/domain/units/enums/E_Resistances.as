package fe.game.domain.units.enums {

	public class E_Resistances {
		// All damage types
		public static const DAM_PIERCE:String		= "DAM_PIERCE";
		public static const DAM_CUT:String			= "DAM_CUT";
		public static const DAM_BLUNT:String		= "DAM_BLUNT";
		public static const DAM_BURN:String			= "DAM_BURN";
		public static const DAM_EXPLOSION:String	= "DAM_EXPLOSION";
		public static const DAM_LASER:String		= "DAM_LASER";
		public static const DAM_PLASMA:String		= "DAM_PLASMA";
		public static const DAM_VENOM:String		= "DAM_VENOM";
		public static const DAM_EMP:String			= "DAM_EMP";
		public static const DAM_ELECTRIC:String		= "DAM_ELECTRIC";
		public static const DAM_ACID:String			= "DAM_ACID";
		public static const DAM_COLD:String			= "DAM_COLD";
		public static const DAM_POISON:String		= "DAM_POISON";
		public static const DAM_BLEED:String		= "DAM_BLEED";
		public static const DAM_BITE:String			= "DAM_BITE";
		public static const DAM_BALEFIRE:String		= "DAM_BALEFIRE";
		public static const DAM_DEATH:String		= "DAM_DEATH";
		public static const DAM_PSYCHIC:String		= "DAM_PSYCHIC";
		public static const DAM_ASTRO:String		= "DAM_ASTRO";
		public static const DAM_PINKCLOUD:String	= "DAM_PINKCLOUD";
		public static const DAM_INTERNAL:String		= "DAM_INTERNAL";
		public static const DAM_HARMONY:String		= "DAM_HARMONY";

		// Legacy integer damage type IDs (still used by units.xml, weapons.json, etc.) mapped to their new string IDs
		public static const LEGACY_DAMAGE_TYPES:Object = {
			0: DAM_PIERCE,		1: DAM_CUT,			2: DAM_BLUNT,		3: DAM_BURN,		4: DAM_EXPLOSION,
			5: DAM_LASER,		6: DAM_PLASMA,		7: DAM_VENOM,		8: DAM_EMP,			9: DAM_ELECTRIC,
			10: DAM_ACID,		11: DAM_COLD,		12: DAM_POISON,		13: DAM_BLEED,		14: DAM_BITE,
			15: DAM_BALEFIRE,	16: DAM_DEATH,		17: DAM_PSYCHIC,	18: DAM_ASTRO,		19: DAM_PINKCLOUD,
			100: DAM_INTERNAL,	101: DAM_HARMONY
		};

		// Damage types that wear down a unit's armor (formerly 'tip <= D_BALE' except EMP, poison and bleeding, plus astro)
		public static const ARMOR_DAMAGE_TYPES:Object = {
			DAM_PIERCE: true,	DAM_CUT: true,		DAM_BLUNT: true,	DAM_BURN: true,		DAM_EXPLOSION: true,
			DAM_LASER: true,	DAM_PLASMA: true,	DAM_VENOM: true,	DAM_ELECTRIC: true,	DAM_ACID: true,
			DAM_COLD: true,		DAM_BITE: true,		DAM_BALEFIRE: true,	DAM_ASTRO: true
		};
	}
}
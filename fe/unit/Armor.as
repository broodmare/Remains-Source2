package fe.unit {
	
	public class Armor {

		// Armor info
		public var id:String	= "";
		public var lvl:int		= 0;
		public var maxlvl:int	= 0;
		public var nazv:String	= "";
		public var owner:Unit	= null; // TODO: REMOVE
		public var tip:int		= 1;			// [1 - Armor, 3 - Amulet]
		
		// Usage flags
		public var clo:int			= 0;		// [Armor can be changed at any time in the limited inventory]
		public var active:Boolean	= false;
		
		// Damage resistance
		public var armor:Number		= 0.00;		// [Armor, the likelihood that it will work]
		public var marmor:Number	= 0.00;
		public var armorQual:Number	= 0.00;		
		public var resistances:Resistances = new Resistances();		// The stats of the armor based on it's current upgrade level

		// Stat modifiers
		public var dexter:Number	= 0.00;		// [Dodge bonus]
		public var sneak:Number		= 0.00;		// [Stealth bonus]
		public var radVul:Number	= 1.00;		// Radiation resistance(?)
		public var h2oMult:Number	= 1.00;		// [Breath]
		public var meleeMult:Number	= 1.00;		// [Cold (Melee cooldown buff?)]
		public var gunsMult:Number	= 1.00;		// [Firearm]
		public var magicMult:Number	= 1.00;		// [Magic]
		public var crit:Number		= 0.00;		// [Crit chance]
		public var tre:Number		= 0.00;		// [Additional treasures]
		
		// Armor ability
		public var abil:String		= "";		// [Special function]
		public var mana:Number		= 0.00;
		public var maxmana:Number	= 0.00;
		public var dmana_act:Number	= 0.00;		// [Mana consumption when activating the function]
		public var dmana_use:Number	= 0.00;		// [Mana cost to maintain]
		public var dmana_res:Number	= 0.00;		// [Mana recovery]
		
		// Armor state
		public var ableFly:Boolean		= false;
		public var abilActive:Boolean	= false;	// [Function active]
		public var showObsInd:Boolean	= false;	// [Show stealth indicator]
		public var und:Boolean			= false;	// [Doesn't break]
		public var norep:Boolean		= false;	// [Cannot be repaired on a workbench]
		public var hp:int				= 100;		// Current HP of the armor
		public var maxhp:int			= 100;		// HP cap of the armor
		public var idComp:String		= "";		// Component needed to upgrade the armor set
		public var kolComp:int			= 1;		// How many components are needed to upgrade
		public var price:int			= 0;		// How much the armor is worth
		public var sort:int				= 0;		// Inventory category
		public var hideMane:int			= 0;		// This armor hides the player's mane
		
		// Constructor
		public function Armor() {

		}
	}	
}
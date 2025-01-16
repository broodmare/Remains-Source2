package fe.weapon {

	public class Ammo {
		
		public var id:String							= "";			// The properties formerly known as...
		public var name:String							= "";			// Localized name
		public var base:String							= "";			// The default type of ammo (used for ammo variants)
		public var piercing:Number						=  0.00;		// Formerly 'ammoPier'		| [Armor-piercing]
		public var armorMultiplier:Number				=  1.00;		// Formerly 'ammoArmor'		| [Target's armor modifier]
		public var damageMultiplier:Number				=  1.00;		// Formerly 'ammoDamage'	| [Damage]
		public var penetrationModifier:Number			=  0.00;		// Formerly 'ammoProbiv'	| 
		public var knockback:Number						=  1.00;		// Formerly 'ammoOtbros'	| [Discarding]
		public var accuracyModifier:Number				=  1.00;		// Formerly 'ammoPrec'		| [Accuracy]
		public var increasedWear:Number					=  0.00;		// Formerly 'ammoHP'		| [Increase in wear]
		public var incendiaryDamage:Number				=  0.00;		// Formerly 'ammoFire'		| [Incendiary]
		public var damageType:String					= "";			// Formerly 'ammoMod'		| [Change damage type]

		// LEGACY ITEM PROPERTIES -- TODO: REMOVE
		public var tip:String							= "";			// Inventory type
		public var kol:int								= 0;			// How many of these are dropped by default as loot
        public var stage:int							= 0;			// What stage of the main quest is required for these to be available
        public var lvl:int								= 0;			// Player level required for these to be available
		public var chance:Number						= 0.00;			// Drop chance multipler(?)
        public var price:Number							= 0.00;			// Buy price multiplier(?)
        public var sell:Number							= 0.00;			// Sell price multiplier(?)
        public var weight:Number						= 0.00;			// Inventory weight
		public var fc:int								= -1;			// Message pop-up color (only ever '3')
		public var invis:Boolean						= false;		// Hidden in inventory(?)

		public function Ammo() {

		}

	}
}
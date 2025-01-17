package fe.weapon {

	public class Ammo {
		
		public var id:String;						// The properties formerly known as...
		public var name:String;						// Localized name
		public var base:String;						// The default type of ammo (used for ammo variants)
		public var piercing:Number;					// Formerly 'ammoPier'		| [Armor-piercing]
		public var armorMultiplier:Number;			// Formerly 'ammoArmor'		| [Target's armor modifier]
		public var damageMultiplier:Number;			// Formerly 'ammoDamage'	| [Damage]
		public var penetrationModifier:Number;		// Formerly 'ammoProbiv'	| 
		public var knockback:Number;				// Formerly 'ammoOtbros'	| [Discarding]
		public var accuracyModifier:Number;			// Formerly 'ammoPrec'		| [Accuracy]
		public var increasedWear:Number;			// Formerly 'ammoHP'		| [Increase in wear]
		public var incendiaryDamage:Number;			// Formerly 'ammoFire'		| [Incendiary]
		public var damageType:String;				// Formerly 'ammoMod'		| [Change damage type]

		// LEGACY ITEM PROPERTIES -- TODO: REMOVE		
		public var tip:String;						// Inventory type
		public var kol:int;							// How many of these are dropped by default as loot
        public var stage:int;						// What stage of the main quest is required for these to be available
        public var lvl:int;							// Player level required for these to be available
		public var chance:Number;					// Drop chance multipler(?)
        public var price:Number;					// Buy price multiplier(?)
        public var sell:Number;						// Sell price multiplier(?)
        public var weight:Number;					// Inventory weight
		public var fc:int;							// Message pop-up color (only ever '3')
		public var invis:Boolean;					// Hidden in inventory(?)

		public function Ammo() {

		}

	}
}
package fe.weapon {

	public class Ammo {

		public var id:String				= "";
		public var name:String				= "";		// Localized name
		public var base:String				= "";		// The default type of ammo (used for ammo variants)
		public var mod:String				= "";		// Ammo variant type, eg. "AP" (formerly an int, see WeaponManager.AMMO_MODS)
		public var piercing:Number			= 0.00;		// Formerly 'ammoPier'		| [Armor-piercing]
		public var armorMultiplier:Number	= 1.00;		// Formerly 'ammoArmor'		| [Target's armor modifier]
		public var damageMultiplier:Number	= 1.00;		// Formerly 'ammoDamage'	| [Damage]
		public var penetrationModifier:Number = 0.00;	// Formerly 'ammoProbiv'	|
		public var knockback:Number			= 1.00;		// Formerly 'ammoOtbros'	| [Discarding]
		public var accuracyModifier:Number	= 1.00;		// Formerly 'ammoPrec'		| [Accuracy]
		public var increasedWear:Number		= 0.00;		// Formerly 'ammoHP'		| [Increase in wear]
		public var incendiaryDamage:Number	= 0.00;		// Formerly 'ammoFire'		| [Incendiary]
		public var damageType:String		= "";		// Formerly 'ammoMod'		| [Change damage type] Empty means the weapon's damage type is used

		public function Ammo(id:String = "") {
			this.id = id;
		}

	}
}

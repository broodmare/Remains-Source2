package fe.game {

	// Which kinds of loot the player picks up by walking over it, as switched in the Pip-Buck options
	public class AutoPickupManager {

		public static var reference:AutoPickupManager;	// Publically accessable reference to this instance

		public var checkLoot:Boolean	= false;		// [Recalculate auto loot pickup]

		public var vsWeaponNew:Boolean	= true;			// [Automatically pick up a new weapon if there is room]
		public var vsWeaponRep:Boolean	= true;			// [automatically pick up weapons for repairs]
		public var vsAmmoAll:Boolean	= true;			// All ammunition
		public var vsAmmoTek:Boolean	= true;			// Ammunition for weapons the player carries
		public var vsExplAll:Boolean	= true;			// Grenades, mines and bombs
		public var vsMedAll:Boolean		= true;			// Medicine and potions
		public var vsHimAll:Boolean		= true;			// Chems
		public var vsEqipAll:Boolean	= true;			// Other equipment, such as repair kits and runes
		public var vsStuffAll:Boolean	= true;			// Everything in the stuff section
		public var vsVal:Boolean		= true;			// Valuables, sold to merchants
		public var vsBook:Boolean		= true;			// Skill books and memory orbs
		public var vsFood:Boolean		= true;			// Food and drink
		public var vsComp:Boolean		= true;			// Workbench components
		public var vsIngr:Boolean		= true;			// Potion ingredients

		public function AutoPickupManager() {
			reference = this;
		}

		// Reads the switches from the user's stored settings; a switch with nothing stored keeps its default
		public function load(configObj:Object):void {
			if (configObj.data.vsWeaponNew != null)	{ vsWeaponNew	= configObj.data.vsWeaponNew; }
			if (configObj.data.vsWeaponRep != null)	{ vsWeaponRep	= configObj.data.vsWeaponRep; }
			if (configObj.data.vsAmmoAll != null)	{ vsAmmoAll		= configObj.data.vsAmmoAll; }
			if (configObj.data.vsAmmoTek != null)	{ vsAmmoTek		= configObj.data.vsAmmoTek; }
			if (configObj.data.vsExplAll != null)	{ vsExplAll		= configObj.data.vsExplAll; }
			if (configObj.data.vsMedAll != null)	{ vsMedAll		= configObj.data.vsMedAll; }
			if (configObj.data.vsHimAll != null)	{ vsHimAll		= configObj.data.vsHimAll; }
			if (configObj.data.vsEqipAll != null)	{ vsEqipAll		= configObj.data.vsEqipAll; }
			if (configObj.data.vsStuffAll != null)	{ vsStuffAll	= configObj.data.vsStuffAll; }
			if (configObj.data.vsVal != null)		{ vsVal			= configObj.data.vsVal; }
			if (configObj.data.vsBook != null)		{ vsBook		= configObj.data.vsBook; }
			if (configObj.data.vsFood != null)		{ vsFood		= configObj.data.vsFood; }
			if (configObj.data.vsComp != null)		{ vsComp		= configObj.data.vsComp; }
			if (configObj.data.vsIngr != null)		{ vsIngr		= configObj.data.vsIngr; }
		}

		// Writes the switches into the user's stored settings
		public function save(configObj:Object):void {
			configObj.data.vsWeaponNew	= vsWeaponNew;
			configObj.data.vsWeaponRep	= vsWeaponRep;
			configObj.data.vsAmmoAll	= vsAmmoAll;
			configObj.data.vsAmmoTek	= vsAmmoTek;
			configObj.data.vsExplAll	= vsExplAll;
			configObj.data.vsMedAll		= vsMedAll;
			configObj.data.vsHimAll		= vsHimAll;
			configObj.data.vsEqipAll	= vsEqipAll;
			configObj.data.vsStuffAll	= vsStuffAll;
			configObj.data.vsVal		= vsVal;
			configObj.data.vsBook		= vsBook;
			configObj.data.vsFood		= vsFood;
			configObj.data.vsComp		= vsComp;
			configObj.data.vsIngr		= vsIngr;
		}
	}
}
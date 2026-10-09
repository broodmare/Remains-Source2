package fe {

	import fe.weapon.Weapon;
	import fe.unit.Unit;
	import fe.unit.UnitPlayer;
	import fe.unit.UnitPet;
	import fe.unit.Armor;
	import fe.unit.Spell;
	import fe.unit.Effect;
	import fe.unit.Pers;
	import fe.unit.Inventory;
	import fe.unit.InventoryItem;
	import fe.unit.Favorites;
	import fe.serv.Item;
	import fe.serv.LootGen;
	import fe.serv.Script;
	import fe.loc.Loot;

	// Everything the player can do with their inventory (formerly most of Invent.as), the Inventory class only holds the data
	public class ItemInteraction {

		private var _owner:UnitPlayer;
		private var _inventory:Inventory;
		
		private var _itemsId:Array	= [];	// [Items that can be used with the 'use item' key]
		private var _eqip:Array		= [];	// [Equipment that can be lost when the player is carrying too much]
		public var cItem:int		= -1;	// [Index of the item selected for the 'use item' key]
		public var cItemMax:int		= 0;
		
		// Constructor
		public function ItemInteraction(owner:UnitPlayer, inventory:Inventory) {
			_owner = owner;
			_inventory = inventory;
			
			var itemManager:ItemManager = ItemManager.reference;
			for each (var data:Object in itemManager.itemList) {
				if ("us" in data && data.us >= 2) {
					_itemsId.push(data.id);
				}
				
				if (itemManager.getInvCat(data.id) == 1 && itemManager.getWeight(data.id) > 0 && !("perk" in data)) {
					_eqip.push(data.id);
				}
			}
			
			cItemMax = _itemsId.length;
		}
		
		public function get inventory():Inventory {
			return _inventory;
		}
		
		// The ID of the item selected for the 'use item' key
		public function get currentItemId():String {
			return (cItem >= 0 && cItem < cItemMax) ? _itemsId[cItem] : null;
		}
		
		private static function itemName(id:String):String {
			return LanguageManager.reference.localText("items", id);
		}

//=============================================================================================================
//			Using items
//=============================================================================================================
		
		// [Select the next item the player has for the 'use item' key]
		public function nextItem(n:int = 1):void {
			if (cItemMax <= 0) {
				return;
			}
			
			var ci:int = cItem + n;
			if (ci >= cItemMax) {
				ci = 0;
			}
			if (ci < 0) {
				ci = cItemMax - 1;
			}
			
			for (var i:int = 0; i < cItemMax; i++) {
				if (_inventory.getQuantity(_itemsId[ci]) > 0) {
					cItem = ci;
					break;
				}
				
				ci += n;
				if (ci >= cItemMax) {
					ci = 0;
				}
				if (ci < 0) {
					ci = cItemMax - 1;
				}
			}
			
			World.w.gui.setItems();
		}
		
		// [choose the right medical device for healing an organ, n - 1: head, 2: torso, 3: legs]
		public function getMed(n:int):String {
			var pers:Pers = _owner.pers;
			var nhp:Number = 0;
			
			if (n == 1) {
				nhp = pers.inMaxHP - pers.headHP;
			}
			else if (n == 2) {
				nhp = pers.inMaxHP - pers.torsHP;
			}
			else if (n == 3) {
				nhp = pers.inMaxHP - pers.legsHP;
			}
			else {
				return "";
			}
			
			var minRazn:Number = 10000;
			var nci:String = "";
			
			for each (var pot:Object in ItemManager.reference.itemList) {
				if (pot.heal == "organ" && _inventory.getQuantity(pot.id) > 0 && (!("minmed" in pot) || pot.minmed <= pers.medic)) {
					var hhp:Number = ("horgan" in pot) ? pot.horgan : 0;
					var razn:Number = Math.abs(hhp - nhp + 25);
					
					if (razn < minRazn) {
						minRazn = razn;
						nci = pot.id;
					}
				}
			}
			
			return nci;
		}
		
		// [Use a potion, medicine or food] ci - the item ID, null picks the most suitable healing potion and "mana" picks the most suitable mana potion
		public function usePotion(ci:String = null, norgan:int = 0):Boolean {
			var gg:UnitPlayer = _owner;
			var pers:Pers = gg.pers;
			var itemManager:ItemManager = ItemManager.reference;
			var hhp:Number = 0;
			var hhplong:Number = 0;
			var pot:Object;
			var pet:UnitPet;
			var need1:Number = gg.maxhp - gg.hp - gg.rad;	// [Need taking into account actual health]
			var need2:Number = need1 - gg.healhp;			// [Need taking into account potions taken]
			var minRazn:Number = 10000;
			var razn:Number;
			var nci:String = "";
			
			if (ci != null && ci != "mana" && _inventory.getQuantity(ci) <= 0) {
				return false;
			}
			
			if (ci == null && need2 < 1) {
				World.w.gui.infoText("noHeal");
				if (gg.rad > 1) {
					World.w.gui.infoText("useAntirad");
				}
				return false;
			}
			
			// [Apply the most suitable potion]
			if (ci == null) {
				for each (pot in itemManager.itemList) {
					if (pot.heal == "hp" && _inventory.getQuantity(pot.id) > 0) {
						hhp = 0;
						
						if ("hhp" in pot) {
							hhp += pot.hhp * pers.healMult;
						}
						
						if ("hhplong" in pot) {
							hhp += pot.hhplong * pers.healMult;
						}
						
						razn = Math.abs(hhp - need2);
						
						if (razn < minRazn) {
							minRazn = razn;
							nci = pot.id;
						}
					}
				}
				
				// No suitable potion was found
				if (nci == "") {
					World.w.gui.infoText("noSuitablePot");
					return false;
				}
				
				ci = nci;
			}

			// [Apply the most suitable mana potion]
			if (ci == "mana") {
				need1 = pers.inMaxMana - pers.manaHP;
				
				if (need1 < 1) {
					return false;
				}

				for each (pot in itemManager.itemList) {
					if (pot.heal == "mana" && _inventory.getQuantity(pot.id) > 0) {
						hhp = ("hmana" in pot) ? pot.hmana : 0;
						razn = Math.abs(hhp - need1);
						
						if (razn < minRazn) {
							minRazn = razn;
							nci = pot.id;
						}
					}
				}
				
				// No suitable potion was found
				if (nci == "") {
					World.w.gui.infoText("noSuitablePot");
					return false;
				}
				
				ci = nci;
			}
			
			if (ci == "potion_swim") {
				gg.h2o = 1000;
			}
			
			if (!itemManager.hasItem(ci)) {
				return false;
			}
			pot = itemManager.getItem(ci);
			
			if (World.w.alicorn) {
				if (pot.tip == Item.L_POT || pot.tip == Item.L_HIM || pot.tip == Item.L_FOOD) {
					World.w.gui.infoText("alicornNot", null, null, false);
					return false;
				}
			}
			
			if (pot.heal == "rad" && gg.rad < 1) {
				World.w.gui.infoText("noMedic", itemName(ci));
				return false;
			}
			else if (pot.heal == "poison" && gg.poison < 0.1) {
				World.w.gui.infoText("noMedic", itemName(ci));
				return false;
			}
			else if (pot.heal == "blood" && (pers.inMaxHP - pers.bloodHP < 1)) {
				World.w.gui.infoText("noMedic", itemName(ci));
				return false;
			}
			else if (pot.heal == "organ" && (pers.inMaxHP - pers.headHP < 1) && (pers.inMaxHP - pers.torsHP < 1) && (pers.inMaxHP - pers.legsHP < 1)) {
				World.w.gui.infoText("noHeal");
				return false;
			}
			else if (pot.heal == "mana" && (pers.inMaxMana - pers.manaHP < 1)) {
				World.w.gui.infoText("noMedic", itemName(ci));
				return false;
			}
			// [Phoenix treatment]
			else if (pot.heal == "pet") {
				pet = gg.pets[pot.pet];

				if (pet == null || pet.maxhp - pet.hp < 1) {
					World.w.gui.infoText("noMedic", itemName(ci));
					return false;
				}
			}
			
			// [Check skill level compliance]
			if ("minmed" in pot && pot.minmed > pers.medic) {
				World.w.gui.infoText("needSkill", LanguageManager.reference.localText("effect", "medic"), pot.minmed);
				return false;
			}
			
			if (pot.heal == "detoxin") {
				var limAddict:int = pot.detox;
				
				for (var j:int = 0; j < 5; j++) {
					for (var ad:String in pers.addictions) {
						if (pers.addictions[ad] > 0) {
							var redAddict:int = Math.round(Math.random() * 50 + 25);
							
							if (redAddict > pers.addictions[ad]) {
								limAddict -= pers.addictions[ad];
								pers.addictions[ad] = 0;
							}
							else {
								limAddict -= redAddict;
								pers.addictions[ad] -= redAddict;
							}
						}
						
						if (limAddict <= 0) {
							break;
						}
					}
					
					if (limAddict <= 0) {
						break;
					}
				}
				
				for each (var eff:Effect in gg.effects) {
					if (eff.him == 1 || eff.him == 2) {
						eff.unsetEff(false, true, false);
					}
				}
				
				gg.setAddictions();
				pers.setParameters();
			}
			
			hhp = ("hhp" in pot) ? pot.hhp * pers.healMult : 0;
			hhplong = ("hhplong" in pot) ? pot.hhplong * pers.healMult : 0;
			
			gg.heal(hhp, 0, false);
			gg.heal(hhplong, 1, false);
			
			if (hhp + hhplong > 0) {
				gg.numbEmit.cast(gg.loc, gg.coordinates.X, gg.coordinates.Y - gg.boundingBox.halfHeight, {txt:Math.round(hhp + hhplong), frame:4, rx:20, ry:20});
			}
			
			if ("hrad" in pot) {
				gg.heal(pot.hrad * pers.healMult, 2);
			}
			
			if ("hpoison" in pot) {
				gg.heal(pot.hpoison, 4, false);
			}
			
			if ("hcut" in pot) {
				gg.heal(pot.hcut, 3, false);
			}
			
			if ("horgan" in pot) {
				pers.heal(pot.horgan, norgan);
			}
			
			if ("horgans" in pot) {
				pers.heal(pot.horgans, 4);
			}
			
			if ("hblood" in pot) {
				pers.heal(pot.hblood, 5);
			}
			
			if ("hmana" in pot) {
				pers.heal(pot.hmana, 6);
			}
			
			if ("hpurif" in pot) {
				for each (var eff2:Effect in gg.effects) {
					if (eff2.tip == 4) {
						eff2.unsetEff(false, true, false);
					}
				}
				
				gg.remEffect("curse");
				World.w.game.triggers["curse"] = 0;
				pers.setParameters();
			}
			
			if ("hpet" in pot) {
				pet = gg.pets[pot.pet];
				pet.heal(pot.hpet, 0);
			}
			
			if ("perk" in pot) {
				pers.addPerk(pot.perk);
			}
			
			if ("effect" in pot) {
				var eff3:Effect = gg.addEffect(pot.effect);
				
				if (pot.tip == Item.L_HIM) {
					if (pers.himLevel > 0) {
						eff3.lvl = pers.himLevel;
						pers.setParameters();
					}
					
					eff3.t *= pers.himTimeMult;
				}
			}
			
			if ("alc" in pot) {
				gg.addEffect("drunk", 0, pot.alc * 10);
			}
			
			if ("rad" in pot) {
				gg.drad2 += Number(pot.rad);
			}
			
			if ("ad" in pot) {
				var n1:int = pot.admin;
				var n2:int = pot.admax;
				var n:int = Math.round(Math.random() * (n2 - n1) + n1) * pers.himBadMult * pers.himBadDif;
				
				if (pers.addictions[pot.ad] == null) {
					pers.addictions[pot.ad] = 0;
				}
				
				var prev:int = pers.addictions[pot.ad];
				pers.addictions[pot.ad] += n;
				
				if (pers.addictions[pot.ad] > pers.admax) {
					pers.addictions[pot.ad] = pers.admax;
				}
				
				if (prev < pers.ad3 && prev + n >= pers.ad3) {
					World.w.gui.infoText("addiction3", itemName(ci));
				}
				else if (prev < pers.ad2 && prev + n >= pers.ad2) {
					World.w.gui.infoText("addiction2", itemName(ci));
				}
				else if (prev < pers.ad1 && prev + n >= pers.ad1) {
					World.w.gui.infoText("addiction1", itemName(ci));
				}
			}
			
			if (pot.tip == Item.L_FOOD) {
				if (pot.ftip == 1) {
					World.w.gui.infoText("usedfood2", itemName(ci));
				}
				else {
					World.w.gui.infoText("usedfood", itemName(ci));
				}
			}
			else if (pot.heal == "organ") {
				World.w.gui.infoText("usedheal", itemName(ci));
			}
			else {
				World.w.gui.infoText("heal", itemName(ci));
			}
			
			// [Items that are never used up]
			if (pot.inf > 0) {
				return true;
			}
			
			minusItem(ci);
			
			return true;
		}
		
		// [Use an item, null uses the item selected for the 'use item' key]
		public function useItem(ci:String = null):Boolean {
			var gg:UnitPlayer = _owner;
			
			if (ci == null) {
				if (cItem < 0) {
					return false;
				}
				
				if (World.w.gui.t_item <= 0) {
					World.w.gui.setItems();
					return false;
				}
				
				ci = currentItemId;
			}
			
			// [Portable workbenches]
			if (ci == "mworkbench" || ci == "mworkexpl" || ci == "mworklab") {
				if (World.w.t_battle > 0) {
					World.w.gui.infoText("noUseCombat", null, null, false);
					return false;
				}
				
				World.w.pip.workTip = ci;
				World.w.pip.onoff(7);
				return false;
			}
			
			if (_inventory.getQuantity(ci) <= 0 || !ItemManager.reference.hasItem(ci)) {
				return false;
			}
			
			var item:Object = ItemManager.reference.getItem(ci);
			var tip:String = item.tip;
			
			// [Paint]
			if ("paint" in item) {
				gg.changePaintWeapon(item.id, uint(item.paint), item.blend);
				World.w.gui.infoText("inUse", itemName(ci));
				return true;
			}
			
			// [Document]
			if ("text" in item) {
				if (World.w.t_battle > 0) {
					World.w.gui.infoText("noUseCombat", null, null, false);
					return false;
				}
				
				World.w.pip.onoff(-1);
				World.w.gui.dialog(item.text);
				
				if ("perk" in item) {
					gg.pers.addPerk(item.perk);
				}
				
				return true;
			}
			
			if (ci == "rollup") {
				if (!useRollup()) {
					return false;
				}
			}
			else if (tip == Item.L_MED || tip == Item.L_HIM || tip == Item.L_POT) {
				return usePotion(ci);
			}
			else if (tip == Item.L_FOOD) {
				if (World.w.alicorn) {
					World.w.gui.infoText("alicornNot", null, null, false);
					return false;
				}
				
				if (World.w.t_battle > 0) {
					World.w.gui.infoText("noUseCombat", null, null, false);
					return false;
				}
				
				return usePotion(ci);
			}
			else if (tip == Item.L_SPELL) {
				if (World.w.alicorn) {
					World.w.gui.infoText("alicornNot", null, null, false);
					return false;
				}
				
				gg.changeSpell(ci);
				return false;
			}
			else if (tip == Item.L_BOOK) {
				if (World.w.t_battle > 0) {
					World.w.gui.infoText("noUseCombat", null, null, false);
					return false;
				}
				
				if (World.w.hardInv && !World.w.loc.base) {
					World.w.gui.infoText("noBase");
					return false;
				}
				
				if ("perk" in item) {
					gg.pers.addPerk(item.perk);
				}
				else {
					gg.pers.upSkill(ci);
				}
				
				// [Read books]
				_inventory.increaseQuantity("lbook");
			}
			else if (ci == "sphera") {
				if (World.w.t_battle > 0) {
					World.w.gui.infoText("noUseCombat", null, null, false);
					return false;
				}
				
				if (World.w.hardInv && !World.w.loc.base) {
					World.w.gui.infoText("noBase");
					return false;
				}
				
				gg.pers.addSkillPoint(1, true);
			}
			else if (ci == "runa" || ci == "reboot") {
				return false;
			}
			else if (ci == "rep") {
				if (!repWeapon(gg.currentWeapon)) {
					return false;
				}
			}
			else if (ci == "stealth") {
				if (World.w.alicorn) {
					World.w.gui.infoText("alicornNot", null, null, false);
					return false;
				}
				
				gg.addEffect("stealth");
			}
			else if ("pet" in item) {
				if (World.w.alicorn) {
					World.w.gui.infoText("alicornNot", null, null, false);
					return false;
				}
				
				gg.callPet(item.pet);
				return true;
			}
			// [Card of fate]
			else if ("chdif" in item) {
				if (!World.w.game.changeDif(item.chdif)) {
					return false;
				}
				
				World.w.gui.infoText("changeDif", LanguageManager.reference.localText("gui", "dif" + item.chdif));
			}
			else {
				return false;
			}
			
			minusItem(ci);
			
			if (ci == currentItemId && World.w.gui.t_item > 0) {
				World.w.gui.setItems();
			}
			
			World.w.calcMass = true;
			
			return true;
		}
		
		// [smoke a joint]
		private function useRollup():Boolean {
			if (World.w.loc.base) {
				World.w.pip.onoff(-1);
				var xml1:XML = XMLDataGrabber.getNodeWithAttributeThatMatches("core", "GameData", "Scripts", "id", "smokeRollup");
				var smokeScr:Script = new Script(xml1, World.w.loc.land, _owner);
				smokeScr.start();
				World.w.game.triggers["rollup"] = 1;
				return true;
			}
			
			World.w.gui.infoText("noBase");
			return false;
		}

//=============================================================================================================
//			Favorites
//=============================================================================================================
		
		// [Use the item in a favorites cell]
		public function useFav(n:int):void {
			var ci:String = _inventory.favorites.fav[n];
			
			if (ci == null) {
				return;
			}
			
			// Explosives are both weapons and items, they're selected as weapons
			if (ci in WeaponManager.reference.allWeaponData()) {
				_owner.changeWeapon(ci);
			}
			else if (ArmorManager.reference.hasArmor(ci)) {
				_owner.changeArmor(ci);
			}
			else if (ItemManager.reference.hasItem(ci)) {
				useItem(ci);
			}
		}
		
		// [Put an item in a favorites cell, cells 25-28 only take spells, 29 explosives and 30 a spell or explosive]
		public function favItem(id:String, cell:int):void {
			var gg:UnitPlayer = _owner;
			
			if (cell == Favorites.CELL_THROW || cell == Favorites.CELL_MAGIC) {
				var w:Weapon = _inventory.equipment.getWeapon(id);
				
				if (w == null || (w.tip != Weapon.TYPE_EXPLOSIVES && w.tip != Weapon.TYPE_MAGIC) || w.spell) {
					World.w.gui.infoText("onlyExpl");
					return;
				}
				
				if (cell == Favorites.CELL_THROW) {
					if (gg.throwWeapon && id == gg.throwWeapon.id) {
						gg.throwWeapon = null;
					}
					else {
						gg.throwWeapon = w;
						gg.throwWeapon.setNull();
						gg.throwWeapon.setPers(gg, gg.pers);
						gg.throwWeapon.addVisual();
						
						if (gg.throwWeapon.tip == Weapon.TYPE_EXPLOSIVES) {
							gg.throwWeapon.remVisual();
						}
					}
				}
				
				if (cell == Favorites.CELL_MAGIC) {
					if (gg.magicWeapon && id == gg.magicWeapon.id) {
						gg.magicWeapon = null;
					}
					else {
						gg.magicWeapon = w;
						gg.magicWeapon.setNull();
						gg.magicWeapon.setPers(gg, gg.pers);
						gg.magicWeapon.addVisual();
						
						if (gg.magicWeapon.tip == Weapon.TYPE_EXPLOSIVES) {
							gg.magicWeapon.remVisual();
						}
					}
				}
			}
			
			if (cell < Favorites.CELL_THROW && cell >= 25) {
				if (ItemManager.reference.getItemType(id) != Item.L_SPELL) {
					World.w.gui.infoText("onlySpell");
					return;
				}
			}
			
			_inventory.favorites.setFavorite(id, cell);
		}

//=============================================================================================================
//			Weapons, armor and spells
//=============================================================================================================
		
		// Add a weapon to the player's equipment, if they already have it, it's repaired instead
		public function addWeapon(id:String, hp:int = 0xFFFFFF, hold:int = 0, respect:int = 0):Weapon {
			if (id == null) {
				return null;
			}

			var w:Weapon = _inventory.equipment.getWeapon(id);

			// We already have this weapon, repair it instead (a blueprint is replaced by the weapon)
			if (w && w.respect != Weapon.WEP_BLUEPRINT) {
				w.repair(hp);
				return w;
			}
			
			w = WeaponManager.reference.cloneWeapon(id, _owner);
			if (w == null) {
				return null;
			}
			
			if (w.tip == Weapon.TYPE_MAGIC || hp == 0xFFFFFF) {
				w.hp = w.maxhp;
			}
			else {
				w.hp = hp;
			}

			if (hold > 0) {
				w.magazineRounds = hold;
			}
			
			// [Explosives don't need to be crafted] They're items, so they can't be hidden or stored either (older saves could hide them)
			if (w.tip == Weapon.TYPE_EXPLOSIVES && (respect == Weapon.WEP_BLUEPRINT || respect == Weapon.WEP_LOCKED)) {
				respect = Weapon.WEP_INACTIVE;
			}
			
			w.respect = respect;
			_inventory.equipment.addWeapon(w);
			
			return w;
		}
		
		// [Remove a weapon, eg. it was sold] it stays as a blueprint if the player has its schematic
		public function remWeapon(id:String):void {
			var w:Weapon = _inventory.equipment.getWeapon(id);
			
			if (w == null) {
				return;
			}
			
			if (w == _owner.currentWeapon) {
				_owner.changeWeapon(id, true);
			}
			
			// Put the ammo in its magazine back in the inventory
			if (w.magazineRounds > 0 && w.usesInventoryAmmo()) {
				_inventory.increaseQuantity(w.ammo.id, w.magazineRounds);
				w.magazineRounds = 0;
			}
			
			if (_owner.throwWeapon == w) {
				_owner.throwWeapon = null;
			}
			
			if (_owner.magicWeapon == w) {
				_owner.magicWeapon = null;
			}
			
			if (_inventory.getQuantity("s_" + id) > 0) {
				w.respect = Weapon.WEP_BLUEPRINT;
			}
			else {
				_inventory.equipment.deleteWeapon(id);
				_inventory.favorites.removeFavorite(id);
			}
			
			World.w.calcMassW = true;
		}
		
		// The ID of a weapon's unique variant, or null if it doesn't have one
		public static function uniqueVariant(id:String):String {
			var uid:String = id + "^1";
			return (id.indexOf("^") < 0 && uid in WeaponManager.reference.allWeaponData()) ? uid : null;
		}
		
		// [Upgrade a weapon to its unique variant] (homemade weapons can be upgraded at a workbench), it replaces the original weapon
		public function upgradeWeapon(id:String):Weapon {
			var old:Weapon = _inventory.equipment.getWeapon(id);
			var uid:String = uniqueVariant(id);
			
			if (old == null || uid == null) {
				return null;
			}
			
			var wasCurrent:Boolean = (_owner.currentWeapon == old);
			if (wasCurrent) {
				_owner.changeWeapon(id, true);
			}
			
			// Put the ammo in its magazine back in the inventory
			if (old.magazineRounds > 0 && old.usesInventoryAmmo()) {
				_inventory.increaseQuantity(old.ammo.id, old.magazineRounds);
			}
			
			_inventory.equipment.deleteWeapon(id);
			_inventory.favorites.renameFavorite(id, uid);
			
			var w:Weapon = addWeapon(uid, 0xFFFFFF, 0, old.respect);
			
			if (wasCurrent) {
				_owner.changeWeapon(uid);
			}
			
			World.w.calcMassW = true;
			
			return w;
		}
		
		// [Show/hide a weapon] Hidden weapons are stored on the weapon stand, the inventory only hides spells this way
		public function respectWeapon(id:String):int {
			var w:Weapon = _inventory.equipment.getWeapon(id);
			
			if (w == null) {
				return Weapon.WEP_ACTIVE;
			}
			
			return storeWeapon(id, w.respect == Weapon.WEP_INACTIVE || w.respect == Weapon.WEP_ACTIVE);
		}
		
		// Store a weapon on the weapon stand (hidden from the player's inventory) or take it back
		public function storeWeapon(id:String, stored:Boolean):int {
			var w:Weapon = _inventory.equipment.getWeapon(id);
			
			if (w == null || w.respect == Weapon.WEP_BLUEPRINT) {
				return Weapon.WEP_ACTIVE;
			}
			
			// Explosives are items, they can't be stored
			if (w.tip == Weapon.TYPE_EXPLOSIVES) {
				return w.respect;
			}
			
			if (stored) {
				w.respect = Weapon.WEP_LOCKED;
			}
			else if (w.respect == Weapon.WEP_LOCKED) {
				w.respect = Weapon.WEP_ACTIVE;
			}
			
			if (_owner.currentWeapon && _owner.currentWeapon.respect == Weapon.WEP_LOCKED) {
				_owner.changeWeapon(_owner.currentWeapon.id);
			}
			
			if (w.respect == Weapon.WEP_LOCKED && _owner.currentSpell && _owner.currentSpell.id == w.id) {
				_owner.changeSpell("");
			}
			
			calcWeaponMass(_inventory);
			
			return w.respect;
		}
		
		// [Repair a weapon using a gunsmith's kit or parts]
		public function repWeapon(w:Weapon, koef:Number = 1):Boolean {
			if (w && w.hasDurability() && w.rep_eff > 0) {
				if (w.hp < w.maxhp) {
					var hhp:Number = w.maxhp * _owner.pers.repairMult * w.rep_eff * koef;
					w.repair(hhp);
					World.w.gui.infoText("repairWeapon", w.nazv, Math.round(w.hp / w.maxhp * 100));
					World.w.gui.setWeapon();
				}
				else {
					World.w.gui.infoText("noRepair");
					return false;
				}
			}
			else {
				World.w.gui.infoText("noRepair2");
				return false;
			}
			
			return true;
		}
		
		// [Repair a weapon by picking up another one, kol is the HP of the weapon that was picked up]
		public function repairWeapon(id:String, kol:int):void {
			var w:Weapon = _inventory.equipment.getWeapon(id);
			
			if (w == null || isNaN(kol)) {
				return;
			}
			
			var hpw:int = w.hp;
			var rep:int = Math.round(kol * _owner.pers.repairMult);
			
			if (hpw < kol) {
				rep = Math.round(kol - hpw + hpw * _owner.pers.repairMult);
			}
			
			w.repair(rep);
			
			// [Taking a weapon apart for scrap]
			if (_owner.pers.barahlo) {
				if (w.rep_eff <= 0) {
					return;
				}
				
				var n:Number = kol / w.maxhp / w.rep_eff;
				
				if (n < 0.3) {
					n = 0.3;
				}
				
				if (n < 1 && n < Math.random()) {
					return;
				}
				
				n = Math.round(n);
				
				if (n > 0) {
					_inventory.increaseQuantity("frag", n);
					
					if (!World.w.testLoot) {
						World.w.gui.infoText("take", itemName("frag") + ((n > 1) ? (" (" + n + ")") : ""));
					}
				}
			}
		}

		// [Add armor, a level of -1 means it's a blueprint that hasn't been crafted] A blueprint is replaced by the armor
		public function addArmor(id:String, hp:int = 0xFFFFFF, nlvl:int = 0):Armor {
			var old:Armor = _inventory.equipment.getArmor(id);
			
			if (old && (old.lvl >= 0 || nlvl < 0)) {
				return null;
			}
			
			var a:Armor = ArmorManager.reference.cloneArmor(id, nlvl);
			if (a == null) {
				return null;
			}
			
			a.hp = Math.min(hp, a.maxhp);
			_inventory.equipment.addArmor(a);
			
			return a;
		}
		
		// [Learn a spell] Spells are also weapons so they can be selected
		public function addSpell(id:String):Spell {
			if (id == null) {
				return null;
			}
			
			if (_inventory.equipment.getSpell(id)) {
				return _inventory.equipment.getSpell(id);
			}

			var sp:Spell = new Spell(_owner, id);
			_inventory.equipment.addSpell(sp);
			
			var w:Weapon = addWeapon(id);
			if (w) {
				w.spell = true;
				w.nazv = sp.nazv;
			}
			
			return sp;
		}
		
		public function addAllSpells():void {
			for each (var data:Object in ItemManager.reference.itemList) {
				if (data.tip == Item.L_SPELL) {
					addSpell(data.id);
				}
			}
		}

//=============================================================================================================
//			Taking, dropping and losing items
//=============================================================================================================
		
		// [add to inventory, tr = 1 if the item was purchased, 2 if it was received as a reward]
		public function take(l:Item, tr:int = 0):void {
			var gg:UnitPlayer = _owner;
			var kol:int = 0;
			var color:int = -1;
			var hp:int;

			if (l.tip == Item.L_WEAPON) {
				// [Weapons that were found come with some ammo]
				var patron:String = l.data.ammo_base;
				if (tr == 0 && !l.dropped && patron && patron != "recharg" && patron != "not") {
					var ammoKol:int = ItemManager.reference.hasItem(patron) ? int(ItemManager.reference.getItem(patron).kol) : 0;
					kol = Math.floor(Math.random() * ammoKol) + 1;
					_inventory.increaseQuantity(patron, kol);
				}

				hp = Math.round(int(l.data.char_maxhp) * l.sost * l.multHP);
				
				var w:Weapon = _inventory.equipment.getWeapon(l.id);
				if (w && w.respect != Weapon.WEP_BLUEPRINT) {
					// [We already have this weapon, use it for repairs]
					if (w.tip != Weapon.TYPE_MAGIC) {
						repairWeapon(l.id, hp);
						if (!World.w.testLoot) {
							World.w.gui.infoText("repairWeapon", w.nazv, Math.round(w.hp / w.maxhp * 100));
						}
					}
				}
				else {
					if (tr == 0 && !World.w.testLoot) {
						World.w.gui.infoText("takeWeapon", l.nazv, Math.round(l.sost * l.multHP * 100));
					}
					
					addWeapon(l.id, hp, 0, 0);
					takeScript(l.id);
					
					if (gg.currentWeapon == null) {
						gg.changeWeapon(l.id);
					}
				}
				
				// [The player picked it up on purpose, make it usable]
				if (l.shpun == 2 && _inventory.equipment.getWeapon(l.id)) {
					_inventory.equipment.getWeapon(l.id).respect = Weapon.WEP_INACTIVE;
				}
				
				World.w.gui.setWeapon();
				World.w.calcMassW = true;
				color = 5;
			}
			else if (l.tip == Item.L_ARMOR) {
				hp = Math.round(int(l.data.hp || 100) * l.sost * l.multHP);
				
				if (addArmor(l.id, hp, l.armorLvl) && tr == 0 && !World.w.testLoot) {
					World.w.gui.infoText("take", l.nazv);
				}
				
				color = 3;
			}
			else if (l.tip == Item.L_SPELL) {
				plus(l, tr);
				World.w.calcMassW = true;
				color = 5;
			}
			else if (l.tip == Item.L_SCHEME) {
				if (_inventory.getQuantity(l.id) == 0) {
					takeScript(l.id);
				}
				
				plus(l, tr);
				
				if (tr <= 1 && !World.w.testLoot) {
					World.w.gui.infoText("take", l.nazv);
				}
				
				// [The weapon or armor can now be crafted]
				var wid:String = l.id.substr(2);
				if (l.data.cat == "weapon" && !_inventory.equipment.getWeapon(wid)) {
					addWeapon(wid, 0xFFFFFF, 0, Weapon.WEP_BLUEPRINT);
				}
				
				if (l.data.cat == "armor" && !_inventory.equipment.getArmor(wid)) {
					addArmor(wid, 0xFFFFFF, -1);
				}
				
				color = 7;
			}
			else if (l.tip == Item.L_EXPL) {
				plus(l, tr);
				
				if (!_inventory.equipment.getWeapon(l.id)) {
					addWeapon(l.id);
				}
				
				if (tr == 0 && !World.w.testLoot) {
					World.w.gui.infoText("take", l.nazv + ((l.kol > 1) ? (" (" + l.kol + ")") : ""));
				}
				
				color = 3;
			}
			else if (l.tip == Item.L_AMMO) {
				plus(l, tr);
				
				if (tr == 0 && !World.w.testLoot) {
					World.w.gui.infoText("takeAmmo", l.nazv, l.kol);
				}
				
				color = 3;
			}
			else if (l.tip == Item.L_MED) {
				plus(l, tr);
				
				if (tr == 0 && !World.w.testLoot) {
					World.w.gui.infoText("takeMed", l.nazv);
				}
				
				selectNewItem();
				color = 1;
			}
			else if (l.tip == Item.L_BOOK) {
				if (_inventory.getQuantity(l.id) == 0) {
					takeScript(l.id);
				}
				
				plus(l, tr);
				
				if (tr <= 1 && !World.w.testLoot) {
					World.w.gui.infoText("takeBook", l.nazv);
				}
				
				selectNewItem();
				color = 4;
			}
			else if (l.tip == Item.L_INSTR || l.tip == Item.L_ART || l.tip == Item.L_IMPL || "sk" in l.data) {
				if (_inventory.getQuantity(l.id) == 0) {
					takeScript(l.id);
				}
				
				plus(l, tr);
				
				if (tr == 0 && !World.w.testLoot) {
					World.w.gui.infoText("take", l.nazv);
				}
				
				gg.pers.setParameters();
				color = 6;
			}
			else {
				if (_inventory.getQuantity(l.id) == 0) {
					takeScript(l.id);
				}
				
				// Increment items in inventory
				plus(l, tr);
				
				if (tr == 0 && !World.w.testLoot) {
					if (l.id == "money") {
						World.w.gui.infoText("takeMoney", l.kol);
					}
					else {
						World.w.gui.infoText("take", l.nazv + ((l.kol > 1) ? (" (" + l.kol + ")") : ""));
					}
				}

				selectNewItem();
				
				if (l.tip == "valuables") {
					color = 2;
				}
				else if (l.tip == Item.L_HIM || l.tip == Item.L_POT) {
					color = 1;
				}
				else if (l.tip == Item.L_KEY || l.tip == Item.L_SPEC) {
					color = 6;
				}
				else if (l.tip == "equip") {
					color = 8;
				}
				else {
					color = 0;
				}
			}
			
			if (tr == 2) {
				if (l.kol > 1) {
					World.w.gui.infoText("reward", l.nazv, l.kol);
				}
				else {
					World.w.gui.infoText("reward2", l.nazv);
				}
			}

			// [if the object was generated randomly, update the limits]
			if (tr == 0 && l.imp == 0 && "limit" in l.data) {
				World.w.game.addLimit(l.data.limit, 2);
			}

			// [pop-up message]
			if (!World.w.testLoot && (tr == 0 || tr == 2)) {
				if (l.fc >= 0) {
					color = l.fc;
				}
				
				World.w.gui.floatText(l.nazv + (l.kol > 1 ? (" (" + l.kol + ")") : ""), gg.coordinates.X, gg.coordinates.Y, color);
			}

			// [information window for important items]
			if (World.w.helpMess || l.tip == Item.L_ART) {
				if (l.mess != null && !(World.w.game.triggers["mess_" + l.mess] > 0)) {
					World.w.game.triggers["mess_" + l.mess] = 1;
					World.w.gui.impMess(Res.txt("i", l.mess), Res.txt("i", l.mess, 2), l.mess);
				}
			}

			// [if the object is critical, confirm receipt]
			if (l.imp == 2 && l.cont) {
				l.cont.receipt();
			}

			var res:String = World.w.game.checkQuests(l.id);
			if (res != null) {
				World.w.gui.infoText("collect", res);
			}

			if (World.w.hardInv) {
				_inventory.mass[l.invCat] += l.mass * l.kol;
			}
			
			World.w.calcMass = true;
		}

		// [Give the player an item as a reward (eg. from a quest)] kol - the amount, -1 uses the item's default amount
		public function giveReward(id:String, kol:int = -1):void {
			if (ItemManager.reference.getItemType(id) == null) {
				trace("ItemInteraction.as/giveReward() - Error: Unknown item: \"" + id + "\"");
				return;
			}
			
			take(new Item(id, kol), 2);
		}
		
		// [Take items from the player (eg. for a quest)] and tell them about it
		public function withdraw(id:String, n:int = 1):void {
			if (n <= 0) {
				return;
			}
			
			if (_inventory.equipment.hasWeapon(id) && !ItemManager.reference.hasItem(id)) {
				World.w.gui.infoText("withdraw", _inventory.equipment.getWeapon(id).nazv, 1);
				remWeapon(id);
				return;
			}
			
			minusItem(id, n);
			World.w.gui.infoText("withdraw", Item.nameOf(id), n);
		}
		
		// [Select an item for the 'use item' key if none is selected]
		private function selectNewItem():void {
			if (cItem < 0) {
				nextItem(1);
			}
			else {
				World.w.gui.setItems();
			}
		}
		
		private function plus(l:Item, tr:int = 0):void {
			if (tr == 1) {
				_inventory.addNew(l.id, l.bou);
				l.trade();
			}
			else {
				_inventory.addNew(l.id, l.kol);
			}
			
			// Don't have more than one of each blueprint or spell.
			if ((l.tip == Item.L_SCHEME || l.tip == Item.L_SPELL) && _inventory.getQuantity(l.id) > 1) {
				_inventory.setQuantity(l.id, 1);
			}
		}
		
		// [Increase the number of items]
		public function plusItem(ci:String, n:int = 1):void {
			if (n > 0) {
				_inventory.addNew(ci, n);
			}
		}
		
		// [Reduce the number of items] Items stored in the vault are used if there aren't enough in the inventory
		public function minusItem(ci:String, n:int = 1, snd:Boolean = true):void {
			if (n <= 0) {
				return;
			}
			
			var have:int = _inventory.getQuantity(ci);
			
			if (have >= n) {
				_inventory.decreaseQuantity(ci, n);
			}
			else {
				// [Use the items stored in the vault for the rest]
				var vault:Inventory = World.w.vault;
				if (vault) {
					vault.setQuantity(ci, vault.getQuantity(ci) - (n - have));
				}
				
				_inventory.setQuantity(ci, 0);
			}
			
			if (_inventory.getQuantity(ci) == 0) {
				nextItem(1);
			}
			
			if (currentItemId && _inventory.getQuantity(currentItemId) == 0) {
				cItem = -1;
			}
			
			if (snd && ItemManager.reference.hasItem(ci)) {
				var uses:String = ItemManager.reference.getItem(ci).uses;
				if (uses) {
					Snd.ps(uses, _owner.coordinates.X, _owner.coordinates.Y);
				}
			}
		}
		
		// [Check if the player has enough of an item] At the base, items stored in the vault are also counted
		public function checkKol(ci:String, n:int = 1):Boolean {
			if (World.w.loc && World.w.loc.base && World.w.vault) {
				return _inventory.getQuantity(ci) + World.w.vault.getQuantity(ci) >= n;
			}
			
			return _inventory.getQuantity(ci) >= n;
		}
		
		// [Equipment is lost or destroyed when the player is carrying too much]
		public function damageItems(dam:Number, destr:Boolean = true):void {
			var pers:Pers = _owner.pers;
			
			if (!destr && !World.w.loc.base && !World.w.alicorn) {
				dam = 5;
			}
			
			if (_inventory.mass[1] <= pers.maxm1 || dam <= 0 || _eqip.length == 0) {
				return;
			}
			
			var kol:Number = dam * (_inventory.mass[1] - pers.maxm1) / 800;
			
			if (kol >= 1 || Math.random() < kol) {
				kol = Math.ceil(kol * Math.random());
				
				for (var i:int = 1; i < 20; i++) {
					var nid:String = _eqip[Math.floor(Math.random() * _eqip.length)];
					
					if (_inventory.getQuantity(nid) > 0) {
						if (destr) {
							minusItem(nid, kol, false);
							World.w.gui.infoText("itemDestr", itemName(nid), kol);
						}
						else {
							drop(nid, kol);
							World.w.gui.infoText("itemLose", itemName(nid), kol);
						}
						
						World.w.calcMass = true;
						return;
					}
				}
			}
		}

		// [Drop items on the ground]
		public function drop(nid:String, kol:int = 1):void {
			if (World.w.loc.base || World.w.alicorn) {
				return;
			}

			if (kol > _inventory.getQuantity(nid)) {
				kol = _inventory.getQuantity(nid);
			}
			
			if (kol <= 0) {
				return;
			}
			
			dropLoot(new Item(nid, kol));
			minusItem(nid, kol, false);
		}
		
		// Weapons that can be dropped, spells, magic and explosives (which are dropped from the ammo page) can't be
		public static function canDropWeapon(w:Weapon):Boolean {
			return w != null && (w.respect == Weapon.WEP_INACTIVE || w.respect == Weapon.WEP_ACTIVE) && !w.spell && !w.alicorn && w.hasDurability();
		}
		
		// [Drop a weapon on the ground] It keeps its condition, the ammo in its magazine goes back to the inventory
		public function dropWeapon(id:String):void {
			var w:Weapon = _inventory.equipment.getWeapon(id);
			
			if (World.w.loc.base || World.w.alicorn || !canDropWeapon(w)) {
				return;
			}
			
			var item:Item = new Item(id, -1, Item.L_WEAPON);
			item.sost = (w.maxhp > 0) ? w.hp / w.maxhp : 1;
			item.dropped = true;
			
			remWeapon(id);
			dropLoot(item);
		}
		
		// [Drop armor on the ground] It keeps its condition and upgrades, worn armor is taken off first
		public function dropArmor(id:String):void {
			var a:Armor = _inventory.equipment.getArmor(id);
			
			if (World.w.loc.base || World.w.alicorn || !canDropArmor(a)) {
				return;
			}
			
			// [Armor can't be changed in battle]
			if ((a == _owner.currentArmor || a == _owner.currentAmul) && !_owner.changeArmor(id, true)) {
				return;
			}
			
			var item:Item = new Item(id, -1, Item.L_ARMOR);
			item.sost = (a.maxhp > 0) ? a.hp / a.maxhp : 1;
			item.armorLvl = a.lvl;
			item.dropped = true;
			
			remArmor(id);
			dropLoot(item);
		}
		
		// Amulets can't be dropped, and neither can armor that's stored on the weapon stand
		public static function canDropArmor(a:Armor):Boolean {
			return a != null && a.lvl >= 0 && !a.stored && a.tip != Armor.TYPE_AMULET;
		}
		
		// Store armor or an amulet on the weapon stand (it can't be worn) or take it back, worn armor is taken off first
		public function storeArmor(id:String, stored:Boolean):Boolean {
			var a:Armor = _inventory.equipment.getArmor(id);
			
			if (a == null || a.lvl < 0) {
				return false;
			}
			
			// [Armor can't be changed in battle]
			if (stored && (a == _owner.currentArmor || a == _owner.currentAmul) && !_owner.changeArmor(id, true)) {
				return false;
			}
			
			a.stored = stored;
			return true;
		}
		
		// [Remove armor] it stays as a blueprint if the player has its schematic
		public function remArmor(id:String):void {
			if (!_inventory.equipment.hasArmor(id)) {
				return;
			}
			
			_inventory.equipment.deleteArmor(id);
			
			if (_inventory.getQuantity("s_" + id) > 0) {
				addArmor(id, 0xFFFFFF, -1);
			}
			else {
				_inventory.favorites.removeFavorite(id);
			}
		}
		
		// Put an item on the ground at the player's feet
		private function dropLoot(item:Item):void {
			new Loot(World.w.loc, item, _owner.coordinates.X, _owner.coordinates.Y - _owner.boundingBox.halfHeight, true, false, false);
		}
		
		// Call the script attached to an item when it's found
		public function takeScript(id:String):void {
			if (World.w.land && World.w.land.itemScripts[id]) {
				World.w.land.itemScripts[id].start();
			}
		}

//=============================================================================================================
//			Debug and new game helpers
//=============================================================================================================
		
		// Add only the default armor to the player (used in the beginning of the game)
		public function addBegin():void { // TODO: Stupid, turn into a script.
			addArmor("pip");
			_inventory.cArmorId = "pip";
		}

		public function addAllWeapon():void { // TODO: Stupid, turn into a script.
			var w:Object;
			for each (w in LootGen.arr["weapon"]) {
				addWeapon(w.id);
			}
			for each (w in LootGen.arr["e"]) {
				addWeapon(w.id);
			}
			for each (w in LootGen.arr["magic"]) {
				addWeapon(w.id);
			}
		}

		public function addAllAmmo():void { // TODO: Stupid, turn into a script.
			var w:Object;
			for each (w in LootGen.arr["a"]) {
				_inventory.setQuantity(w.id, 10000);
			}
			for each (w in LootGen.arr["e"]) {
				_inventory.setQuantity(w.id, 10000);
			}
		}

		public function addAllItem():void { // TODO: Stupid, turn into a script.
			var amounts:Object = {med:1000, compa:1000, him:1000, book:10, compw:100, compe:100, compm:100, compp:1000, stuff:1000, paint:1, pot:100, food:100};
			var w:Object;
			
			for (var tip:String in amounts) {
				for each (w in LootGen.arr[tip]) {
					_inventory.setQuantity(w.id, amounts[tip]);
				}
			}
			
			for each (w in LootGen.arr["scheme"]) {
				take(new Item(w.id, -1, Item.L_SCHEME));
			}
			
			for each (w in LootGen.arr["spell"]) {
				take(new Item(w.id, -1, Item.L_SPELL));
			}
			
			_inventory.setQuantity("stealth", 1000);
			_inventory.setQuantity("potHP", 1000);
			_inventory.setQuantity("rep", 1000);
			_inventory.setQuantity("sphera", 100);
			_inventory.setQuantity("screwdriver", 1);
		}

		// TODO: Stupid, turn into a script.
		public function addAllArmor():void {
			for each (var arm:Armor in ArmorManager.reference.armors) {
				addArmor(arm.id);
			}
		}
		
		// TODO: Stupid, turn into a script.
		public function addAll():void {
			addAllWeapon();
			addAllAmmo();
			addAllItem();
			addAllArmor();
		}

//=============================================================================================================
//			Saving and loading
//=============================================================================================================
		
		// Load the player's inventory, weapons, armor and favorites
		// Works with the original game's saves, their unique weapons were saved as {id:"mont", variant:1} instead of {id:"mont^1"}
		public function load(saveData:Object):void {
			_inventory.load(saveData);
			
			if (saveData == null || saveData is Array) {
				return;
			}
			
			// [Items stored in the base's vault]
			if (World.w.vault) {
				for (var vaultId:String in saveData.vault) {
					World.w.vault.setQuantity(vaultId, int(saveData.vault[vaultId]));
				}
			}
			
			var renamed:Object = {};
			var data:Object;
			
			for each (data in saveData.weapons) {
				if (data == null || !data.id) {
					continue;
				}
				
				var id:String = data.id;
				if (data.variant > 0 && id.indexOf("^") < 0) {
					renamed[id] = id + "^" + data.variant;
					id = renamed[id];
				}
				
				var weap:Weapon = addWeapon(id, data.hp, data.hold, data.respect);
				
				if (weap && data.ammo && weap.ammo && data.ammo != weap.ammo.id) {
					weap.ammo = WeaponManager.reference.getAmmo(data.ammo);
					weap.ammoTarg = weap.ammo;
				}
			}
			
			// Point the current weapon and favorites at the renamed weapons
			for (var oldId:String in renamed) {
				if (_inventory.cWeaponId == oldId) {
					_inventory.cWeaponId = renamed[oldId];
				}
				
				_inventory.favorites.renameFavorite(oldId, renamed[oldId]);
			}
			
			for each (data in saveData.armors) {
				if (data && data.id) {
					var arm:Armor = addArmor(data.id, data.hp, data.lvl);
					
					if (arm && data.stored) {
						arm.stored = true;
					}
				}
			}
		}
		
		public function save():Object {
			var gg:UnitPlayer = _owner;
			var vaultSave:Object = {};
			
			if (World.w.vault) {
				for each (var item:InventoryItem in World.w.vault.getAllItems()) {
					vaultSave[item.id] = item.quantity;
				}
			}
			
			return _inventory.save({
				vault:		vaultSave,
				cWeaponId:	gg.currentWeapon ? gg.currentWeapon.id : "",
				cArmorId:	gg.currentArmor ? gg.currentArmor.id : "",
				cAmulId:	gg.currentAmul ? gg.currentAmul.id : "",
				cSpellId:	gg.currentSpell ? gg.currentSpell.id : "",
				prevArmor:	gg.prevArmor
			});
		}

//=============================================================================================================
//			Weight
//=============================================================================================================
		
		public static function calcMass(inv:Inventory):void {
			inv.calcMass();
			World.w.checkLoot = true;
			World.w.pers.invMassParam();
		}

		public static function calcWeaponMass(inv:Inventory):void {
			inv.calcWeaponMass();
			World.w.checkLoot = true;
			World.w.pers.invMassParam();
		}
		
		// [Return a string representation of the occupied space] n - 1-3: inventory sections, 4: weapons, 5: spells
		public static function retMass(inv:Inventory, n:int):String {
			var pers:Pers = World.w.pers;
			var txt:String;
			var cl:String = "mass";
			var m:Number = 0;
			var maxm:Number = 0;
			
			if (n >= 1 && n <= 3) {
				txt = "allmass" + n;
				m = inv.mass[n];
				maxm = pers["maxm" + n];
			}
			else if (n == 4) {
				txt = "allweap";
				m = inv.massW;
				maxm = pers.maxmW;
			}
			else if (n == 5) {
				txt = "allmagic";
				m = inv.massM;
				maxm = pers.maxmM;
			}
			
			if (m > maxm) {
				cl = "red";
			}
			
			return LanguageManager.reference.localText("pip", txt) + ": <span class = \'" + cl + "\'>" + Res.numb(m) + "/" + Math.round(maxm) + "</span>";
		}
	}
}

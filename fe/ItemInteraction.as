package fe { 

	import fe.weapon.Weapon;
	import fe.unit.Unit;
	import fe.unit.Armor;
	import fe.unit.Spell;
	import fe.unit.Inventory;
	import fe.serv.Item;

	public class ItemInteraction {

		// [choose the right honey. device (potion?)]
		public function getMed(n:int):String {
			/*
			var nhp:Number = 0;
			if (n == 1) {
				nhp = gg.pers.inMaxHP - gg.pers.headHP;
			}
			else if (n == 2) {
				nhp = gg.pers.inMaxHP - gg.pers.torsHP;
			}
			else if (n == 3) {
				nhp = gg.pers.inMaxHP - gg.pers.legsHP;
			}
			else {
				return "";
			}
			
			var minRazn:Number = 10000;
			var nci:String = "";
			
			for each (var pot in _inventory) {
				
				// Skill anything not in the medical category
				if (!("tip" in pot) || pot.tip != "med"){
					continue;
				}
				
				if (pot.heal == 'organ' && _inventory[pot.id].kol > 0 && (!("minmed" in pot) || pot.minmed <= gg.pers.medic)) {
					var hhp:int = 0;
					if (pot.horgan.length()) {
						hhp = pot.horgan;
					}
					
					var razn:int = Math.abs(hhp - nhp + 25);
					if (razn < minRazn) {
						minRazn = razn;
						nci = pot.id;
					}
				}
			}
			
			return nci;
			*/
			return "";
		}
		
		public function usePotion(ci:String=null, norgan:int=0):Boolean {
			/*
			var hhp:Number = 0; 
			var hhplong:Number = 0;
			var pot;
			var pet:UnitPet;
			var need1:Number = gg.maxhp - gg.hp - gg.rad;	// [Need taking into account actual health]
			var need2:Number = need1 - gg.healhp;			// [Need taking into account potions taken]
			
			var minRazn:Number = 10000;
			var nci:String = "";
			
			if (ci != null && ci != "mana" && _inventory[ci].kol <= 0) {
				return false;
			}
			
			if (ci == null && need2 < 1) {
				World.w.gui.infoText('noHeal');
				if (gg.rad>1) World.w.gui.infoText('useAntirad');
				return false;
			}
			
			if (ci == null) {	
				// [Apply the most suitable potion]
				for each (pot in _inventory) {
					if ("heal" in pot && pot.heal == 'hp' && _inventory[pot.id].kol > 0) {
						hhp = 0;
						
						if ("hhp" in pot) {
							hhp += pot.hhp * gg.pers.healMult;
						}
						
						if ("hhplong" in pot) {
							hhp += pot.hhplong * gg.pers.healMult;
						}
						
						var razn:Number = Math.abs(hhp - need2);
						
						if (razn < minRazn) {
							minRazn = razn;
							nci = pot.id;
						}
					}
				}
				
				// No suitable potion was found
				if (nci == "") {
					World.w.gui.infoText('noSuitablePot');
					return false;
				}
				else {
					ci = nci;
				}
			}

			// [Apply the most suitable mana potion]
			if (ci == "mana") {
				need1 = gg.pers.inMaxMana - gg.pers.manaHP;
				
				if (need1 < 1) {
					return false;
				}

				for each (pot in _inventory) {
					if ("heal" in pot && pot.heal == 'mana' && _inventory[pot.id].kol > 0) {
						
						hhp = 0;
						
						if ("hmana" in pot) {
							hhp = pot.hmana;
						}
						
						var razn1:Number = Math.abs(hhp - need1);
						
						if (razn1 < minRazn) {
							minRazn = razn1;
							nci = pot.id;
						}
					}
				}
				
				// No suitable potion was found
				if (nci == "") {
					World.w.gui.infoText('noSuitablePot');
					return false;
				}
				else {
					ci = nci;
				}
			}
			
			if (ci == 'potion_swim') {
				gg.h2o = 1000;
			}
			

			if (_inventory.hasOwnProperty(ci)) {
				pot = _inventory[ci];
			}
			else {
				return false;
			}
			
			if (World.w.alicorn) {
				if (pot.tip == 'pot' || pot.tip == 'him' || pot.tip == 'food') {
					World.w.gui.infoText('alicornNot', null, null, false);
					
					return false;
				}
			}
			
			if (pot.heal == 'rad' && gg.rad < 1) {
				World.w.gui.infoText('noMedic', LanguageManager.reference.localText("item", ci));
				
				return false;
			}
			else if (pot.heal == 'poison' && gg.poison < 0.1) {
				World.w.gui.infoText('noMedic', LanguageManager.reference.localText("item", ci));
				
				return false;
			}
			else if (pot.heal == 'blood' && (gg.pers.inMaxHP - gg.pers.bloodHP < 1)) {
				World.w.gui.infoText('noMedic', LanguageManager.reference.localText("item", ci));
				
				return false;
			}
			else if (pot.heal == 'organ' && (gg.pers.inMaxHP - gg.pers.headHP < 1) && (gg.pers.inMaxHP - gg.pers.torsHP < 1) && (gg.pers.inMaxHP - gg.pers.legsHP < 1)) {
				World.w.gui.infoText('noHeal');
				
				return false;
			}
			else if (pot.heal == 'mana' && (gg.pers.inMaxMana - gg.pers.manaHP < 1)) {
				World.w.gui.infoText('noMedic', LanguageManager.reference.localText("item", ci));
				
				return false;
			}
			// [Phoenix treatment]
			else if (pot.heal == 'pet') {		
				pet = gg.pets[pot.pet];
				
				if (pet == null || pet.maxhp - pet.hp < 1) {
					World.w.gui.infoText('noMedic', LanguageManager.reference.localText("item", ci));
					
					return false;
				}
			}
			
			// [Check skill level compliance]
			if ("minmed" in pot && pot.minmed > gg.pers.medic) {
				World.w.gui.infoText('needSkill', Res.txt('e','medic'), pot.minmed);
				
				return false;
			}
			
			if (pot.heal == 'detoxin') {
				var limAddict:int = pot.detox;
				
				for (var j:int = 0; j < 5; j++) {
					for (var ad:String in World.w.pers.addictions) {
						if (World.w.pers.addictions[ad] > 0) {
							var redAddict:int = Math.round(Math.random() * 50 + 25);
							
							if (redAddict > World.w.pers.addictions[ad]) {
								limAddict -= World.w.pers.addictions[ad];
								World.w.pers.addictions[ad] = 0;
							}
							else {
								limAddict -= redAddict;
								World.w.pers.addictions[ad] -= redAddict;
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
				
				for each(var eff:Effect in _owner.effects) {
					if (eff.him == 1 || eff.him == 2) {
						eff.unsetEff(false, true, false);
					}
				}
				
				gg.setAddictions();
				gg.pers.setParameters();
			}
			
			hhp = 0;
			hhplong = 0;
			
			if ("hhp" in pot) {
				hhp = pot.hhp * gg.pers.healMult;
			}
			
			if ("hhplong" in pot) {
				hhplong = pot.hhplong * gg.pers.healMult;
			}
			
			gg.heal(hhp, 0, false);
			gg.heal(hhplong, 1, false);
			
			if (hhp + hhplong > 0) {
				gg.numbEmit.cast(gg.loc, gg.coordinates.X, gg.coordinates.Y - gg.boundingBox.halfHeight, {txt:Math.round(hhp+hhplong), frame:4, rx:20, ry:20});
			}
			
			if ("hrad" in pot) {
				gg.heal(pot.hrad * gg.pers.healMult, 2);
			}
			
			if ("hpoison" in pot) {
				gg.heal(pot.hpoison, 4, false);
			}
			
			if ("hcut" in pot) {
				gg.heal(pot.hcut, 3, false);
			}
			
			if ("horgan" in pot) {
				gg.pers.heal(pot.horgan, norgan);
			}
			
			if ("horgans" in pot) {
				gg.pers.heal(pot.horgans, 4);
			}
			
			if ("hblood" in pot) {
				gg.pers.heal(pot.hblood, 5);
			}
			
			if ("hmana" in pot) {
				gg.pers.heal(pot.hmana, 6);
			}
			
			if ("hpurif" in pot) {
				for each(var eff2:Effect in _owner.effects) {
					if (eff2.tip == 4) {
						eff2.unsetEff(false, true, false);
					}
				}
				
				gg.remEffect('curse');
				World.w.game.triggers['curse'] = 0;
				gg.pers.setParameters();
			}
			
			if ("hpet" in pot) {
				pet = gg.pets[pot.pet];
				pet.heal(pot.hpet, 0);
			}
			
			if ("perk" in pot) {
				gg.pers.addPerk(pot.perk);
			}
			
			if ("effect" in pot) {
				var eff3:Effect = gg.addEffect(pot.effect);
				
				if (pot.tip == 'him') {
					if (gg.pers.himLevel > 0) {
						eff3.lvl = gg.pers.himLevel;
						gg.pers.setParameters();
					}
					
					eff3.t *= gg.pers.himTimeMult;
				}
			}
			
			if ("alc" in pot) {
				gg.addEffect('drunk', 0, pot.alc * 10);
			}
			
			if ("rad" in pot) {
				gg.drad2 += pot.rad;
			}
			
			if ("ad" in pot) {
				var n1:int = pot.admin;
				var n2:int = pot.admax;
				var n:int = Math.round(Math.random() * (n2 - n1) + n1) * gg.pers.himBadMult * gg.pers.himBadDif;
				
				if (gg.pers.addictions[pot.ad] == null) {
					gg.pers.addictions[pot.ad] = 0;
				}
				
				var prev:int = gg.pers.addictions[pot.ad];
				gg.pers.addictions[pot.ad] += n;
				
				if (gg.pers.addictions[pot.ad] > gg.pers.admax) {
					gg.pers.addictions[pot.ad] = gg.pers.admax;
				}
				
				if (prev < gg.pers.ad3 && prev + n >= gg.pers.ad3) {
					World.w.gui.infoText('addiction3', LanguageManager.reference.localText("item", ci));
				}
				else if (prev < gg.pers.ad2 && prev + n >= gg.pers.ad2) {
					World.w.gui.infoText('addiction2', LanguageManager.reference.localText("item", ci));
				}
				else if (prev < gg.pers.ad1 && prev + n >= gg.pers.ad1) {
					World.w.gui.infoText('addiction1', LanguageManager.reference.localText("item", ci));
				}
			}
			
			if (pot.tip == "food") {
				if (pot.ftip=='1') {
					World.w.gui.infoText('usedfood2', LanguageManager.reference.localText("item", ci));
				}
				else {
					World.w.gui.infoText('usedfood',  LanguageManager.reference.localText("item", ci));
				}
			}
			else if (pot.heal == 'organ') {
				World.w.gui.infoText('usedheal', LanguageManager.reference.localText("item", ci));
			}
			else {
				World.w.gui.infoText('heal', LanguageManager.reference.localText("item", ci));
			}
			
			if (pot.inf > 0) {
				return true;
			}
			
			minusItem(ci);
			
			return true;
			*/
			return false;
		}
		
		public function useItem(ci:String=null):Boolean {
			/*
			if (ci == null) {
				if (cItem < 0) {
					return false;
				}
				
				if (World.w.gui.t_item <= 0) {
					World.w.gui.setItems();
					return false;
				}
				else {
					ci = itemsId[cItem];
				}
			}
			
			if (ci=='mworkbench' || ci=='mworkexpl' || ci=='mworklab') {
				if (World.w.t_battle>0) {
					World.w.gui.infoText('noUseCombat',null,null,false);
					
					return false;
				}
				
				World.w.pip.workTip=ci;
				World.w.pip.onoff(7);
				
				return false;
			}
			
			if (_inventory[ci].kol<=0) {
				return false;
			}
			
			var item:XML = _inventory[ci].xml;
			
			if (item == null) {
				return false;
			}
			
			var tip:String=item.@tip;
			
			if (item.@paint.length()) { // [Paint]
				gg.changePaintWeapon(item.@id,item.@paint,item.@blend);
				World.w.gui.infoText('inUse', _inventory[ci].nazv);
				
				return true;
			}
			
			if (item.@text.length()) { // [Document]
				if (World.w.t_battle>0) {
					World.w.gui.infoText('noUseCombat',null,null,false);
					return false;
				}
				
				World.w.pip.onoff(-1);
				World.w.gui.dialog(item.@text);
				
				if (item.@perk.length()) {
					gg.pers.addPerk(item.@perk);
				}
				
				return true;
			}
			
			if (ci=='rollup') {
				if (!useRollup()) return false;
			}
			else if (tip=='med' || tip=='him' || tip=='pot') {
				return (usePotion(ci));
			}
			else if (tip=='food') {
				if (World.w.alicorn) {
					World.w.gui.infoText('alicornNot',null,null,false);
					return false;
				}
				
				if (World.w.t_battle>0) {
					World.w.gui.infoText('noUseCombat',null,null,false);
					return false;
				}
				
				return (usePotion(ci));
			}
			else if (tip=='spell') {
				if (World.w.alicorn) {
					World.w.gui.infoText('alicornNot',null,null,false);
					return false;
				}
				
				gg.changeSpell(ci);
				
				return false;
			}
			else if (tip=='book') {
				if (World.w.t_battle>0) {
					World.w.gui.infoText('noUseCombat',null,null,false);
					return false;
				}
				
				if (World.w.hardInv && !World.w.loc.base) {
					World.w.gui.infoText('noBase');
					return false;
				}
				
				if (item.@perk.length()) {
					gg.pers.addPerk(item.@perk);
				}
				else {
					gg.pers.upSkill(ci);
				}
				
				_inventory['lbook'].kol++;
			}
			else if (ci=='sphera') {
				if (World.w.t_battle>0) {
					World.w.gui.infoText('noUseCombat',null,null,false);
					return false;
				}
				if (World.w.hardInv && !World.w.loc.base) {
					World.w.gui.infoText('noBase');
					return false;
				}
				gg.pers.addSkillPoint(1, true);
			}
			else if (ci=='runa' || ci=='reboot') {
				return false;
			}
			else if (ci=='rep') {
				if (!repWeapon(gg.currentWeapon)) return false;
			}
			else if (ci=='stealth') {
				if (World.w.alicorn) {
					World.w.gui.infoText('alicornNot',null,null,false);
					return false;
				}
				gg.addEffect('stealth');
			}
			else if (item.@pet.length()) {
				if (World.w.alicorn) {
					World.w.gui.infoText('alicornNot',null,null,false);
					return false;
				}
				gg.callPet(item.@pet);
				return true;
			}
			else if (item.@chdif.length()) {	// [Fate card]
				if (!World.w.game.changeDif(item.@chdif)) return false;
				World.w.gui.infoText('changeDif',Res.txt("g", 'dif'+item.@chdif));
			}
			else {
				return false;
			}
			
			minusItem(ci);
			
			if (ci == itemsId[cItem] && World.w.gui.t_item > 0) {
				World.w.gui.setItems();
			}
			
			World.w.calcMass = true;
			
			return true;
			*/
			return false;
		}
		
		
		
		public function addWeapon(id:String, hp:int = 0xFFFFFF, magazineRounds:int = 0, respect:int = 0):Weapon {
			/*
			// We already have this weapon in inventory, use this to repair our current weapon instead
			if (_inventory[id]) {
				_inventory[id].repair(hp);
				return _inventory[id];
			}

			var wData:Object = ItemManager.reference.weapons[id];
			var w:Weapon = Weapon.create(_owner, wData);

			if (w == null) {
				return null;
			}
			
			if (w.tip == 5 || hp == 0xFFFFFF) {
				w.hp = w.maxhp;
			}
			else {
				w.hp=hp;
			}
			
			if (magazineRounds > 0) {
				w.magazineRounds = magazineRounds;
			}

			if (w.tip == 4 && respect == Weapon.WEP_BLUEPRINT) {
				respect = Weapon.WEP_INACTIVE;
			}
			
			w.respect = respect;
			_inventory[id] = w;
			
			return w;
			*/
			return new Weapon();
		}
		
		public function remWeapon(id:String):void {
			/*
			if (_inventory[id]) {
				if (_inventory[id] == gg.currentWeapon) {
					gg.changeWeapon(id, true);
				}
				
				if (_inventory[id].magazineRounds > 0) {
					_inventory[id].kol += _inventory[id].magazineRounds;
					_inventory[id].magazineRounds = 0;
				}
				
				if (_inventory['s_' + id] && _inventory['s_' + id].kol > 0) {
					_inventory[id].respect = Weapon.WEP_BLUEPRINT;
				}
				else {
					_inventory[id] = null;
				}
			}
			*/
		}
		
		// Replace the base weapon in the player's inventory with a unique variant(?)
		public function updWeapon(id:String, nvar:Boolean):void {
			/*
			// If the weapon doesn't already exist in inventory, add the base variant to the player's inventory
			if (_inventory[id] == null) {
				addWeapon(id);
			}
			
			// Run the updVariant function to update the base weapon to a variant using XML data
			_inventory[id].updVariant(nvar);
			*/
		}
		
		// [Show/hide weapons]
		public function respectWeapon(id:String):int {
			/*
			var w:Weapon = _inventory[id];
			
			if (w == null) {
				return 2;
			}
			
			if (w.respect == Weapon.WEP_INACTIVE || w.respect == Weapon.WEP_ACTIVE) {
				w.respect = Weapon.WEP_LOCKED;
			}
			else {
				w.respect = Weapon.WEP_ACTIVE;
			}
			
			if (gg.currentWeapon && gg.currentWeapon.respect == Weapon.WEP_LOCKED) {
				gg.changeWeapon(gg.currentWeapon.id);
			}
			
			if (w.respect == Weapon.WEP_LOCKED && gg.currentSpell && gg.currentSpell.id == w.id) {
				gg.changeSpell("");
			}
			
			calcWeaponMass();
			
			return w.respect;
			*/
			return 0;
		}
		
		// [Repair weapons using a gunsmith's kit or parts]
		public function repWeapon(w:Weapon, koef:Number=1):Boolean {
			/*
			if (w && w.tip>0 && w.tip<4 && w.rep_eff>0) {
				if (w.hp<w.maxhp) {
					var hhp:Number = w.maxhp * gg.pers.repairMult * w.rep_eff * koef;
					w.repair(hhp);
					World.w.gui.infoText('repairWeapon',w.nazv,Math.round(w.hp/w.maxhp*100));
					World.w.gui.setWeapon();
				}
				else {
					World.w.gui.infoText('noRepair');
					return false;
				}
			}
			else {
				World.w.gui.infoText('noRepair2');
				return false;
			}
			return true;
			*/
			
			return false;
		}
		
		public function repairWeapon(id:String, kol:int):void {
			/*
			var hpw:Number = (_inventory[id] as Weapon).hp;
			var rep:int = Math.round(kol*gg.pers.repairMult);
			
			if (hpw<kol) {
				rep = Math.round(kol - hpw + hpw * gg.pers.repairMult);
			}
			
			(_inventory[id] as Weapon).repair(rep);
			
			if (gg.pers.barahlo) {
				var n:Number = kol/(_inventory[id] as Weapon).maxhp / (_inventory[id] as Weapon).rep_eff;
				
				if ((_inventory[id] as Weapon).rep_eff<=0) {
					return;
				}
				
				if (n < 0.30) {
					n = 0.30;
				}
				
				if (n < 1 && n < Math.random()) {
					return;
				}
				
				n = Math.round(n);
				_inventory['frag'].kol += n;
				
				if(!World.w.testLoot) {
					World.w.gui.infoText('take', Res.txt('i', 'frag') + ((n > 1)? (' (' + n + ')') : ''));
				}
			}
			*/
		}

		public function addArmor(id:String, hp:int=0xFFFFFF, nlvl:int=0):Armor {
			/*
			if (!_inventory.hasOwnProperty(id)) {
				return null;
			}
			
			var w:Armor = new Armor(id, nlvl);
			
			w.hp = hp;
			
			if (w.hp > w.maxhp) {
				w.hp = w.maxhp;
			}
			
			_inventory[id] = w;
			
			return w;
			*/
			return new Armor();
		}
		
		public function addSpell(id:String):Spell {
			/*
			if (_inventory.hasOwnProperty(id)) {
				return _inventory[id];
			}

			var sp:Spell = new Spell(_owner, id);
			
			if (sp == null) {
				return null;
			}
			
			_inventory[id] = sp;
			var w:Weapon = addWeapon(id);
			w.spell = true;
			w.nazv = sp.nazv;
			
			return sp;
			*/
			var unit:Unit = null;
			return new Spell(unit, "id");
		}
		
		// Initializes the list of spells
		public function addAllSpells():void {
			/*
			for each(var sp in ItemManager.reference.items) {
				if ("tip" in sp && sp.tip == "spell") {
					trace("Invent.addAllSpells() - Adding spell: " + sp.id);
					addSpell(sp.id);
				}
			}
			*/
		}
		
		// [add to inventory, tr = 1 if the item was purchased, 2 if it was received as a reward]
		public function take(l:Item, tr:int = 0):void {
			/*
			if (l == null) {
				trace("Invent.as/take() - Item is null!");
				return;
			}
			
			var kol:int = 0;
			var color:int = -1;
			var s:String = l.id;
			var itemData:Object = ItemManager.reference.getItem(s);

			// Item is a weapon
			if (l.tip == Item.L_WEAPON) {
				
				// Get the ammo this weapon uses
				var ammoType:String = itemData.base;
				
				// If the item isn't new, uses ammo, and isn't rechargable
				if (tr == 0 && ammoType && ammoType != 'recharg') {
					kol = Math.floor(Math.random() * ItemManager.reference.getItem(ammoType).kol) + 1;
					_inventory[ammoType].kol += kol;
				}

				// Assign the weapon a maximum health value
				var hp:int = Math.round(itemData.maxhp * l.sost * l.multHP);
				
				if (_inventory[l.id]) {
					if (_inventory[l.id].variant < l.variant) {
						if (tr == 0 && !World.w.testLoot) World.w.gui.infoText('takeWeapon', l.nazv, Math.round(l.sost * l.multHP * 100));
						updWeapon(l.id, l.variant);
					}
					if (_inventory[l.id].tip != 5) {
						repairWeapon(l.id, hp);
						if (!World.w.testLoot) {
							World.w.gui.infoText('repairWeapon', _inventory[l.id].nazv, Math.round(_inventory[l.id].hp / _inventory[l.id].maxhp * 100));
						}
					}
				}
				else {
					if (tr == 0 && !World.w.testLoot) {
						World.w.gui.infoText('takeWeapon', l.nazv, Math.round(l.sost * l.multHP * 100));
					}
					
					addWeapon(l.id, hp, 0, 0);
					takeScript(l.id);
					
					if (_owner.player && gg.currentWeapon == null) {
						gg.changeWeapon(l.id);
					}
				}
				
				if (l.shpun == 2) {
					_inventory[l.id].respect = Weapon.WEP_INACTIVE;
				}
				
				World.w.gui.setWeapon();
				World.w.calcMassW = true;
				color = 5;
			}
			else if (itemData.tip == Item.L_ARMOR) {
				var hp2:int = Math.round(itemData.hp * l.sost * l.multHP);
				addArmor(l.id, hp2);
				color = 3;
			}
			else if (itemData.tip == Item.L_SPELL) {
				plus(l, tr);
				World.w.calcMassW = true;
				color = 5;
			}
			else if (l.tip == Item.L_SCHEME) {
				if (_inventory[l.id].kol == 0) {
					takeScript(l.id);
				}
				
				plus(l, tr);
				
				if (tr <= 1 && !World.w.testLoot) {
					World.w.gui.infoText('take', l.nazv);
				}
				
				// Add a new weapon under the base weapon's ID, eg. "Shotgun^1" -> "Shotgun"
				if (itemData.cat == 'weapon' && _inventory[l.id.substr(2)] == null) {
					addWeapon(l.id.substr(2), 0xFFFFFF, 0,3);
				}
				
				// Add a new weapon under the base armor's ID, eg. "Armor^1" -> "Armor"
				if (itemData.cat=='armor' && _inventory[l.id.substr(2)] == null) {
					addArmor(l.id.substr(2), 0xFFFFFF, -1);
				}
				
				color=7;
			}
			else if (itemData.tip == Item.L_EXPL) {
				plus(l,tr);
				
				if (!_inventory[l.id]) {
					addWeapon(l.id);
				}
				
				if (tr == 0 && !World.w.testLoot) {
					World.w.gui.infoText('take', l.nazv+((l.kol > 1)? (' (' + l.kol + ')') : ''));
				}
				
				color = 3;
			}
			else if (itemData.tip == Item.L_AMMO) {
				plus(l, tr);
				
				if (tr == 0 && !World.w.testLoot) {
					World.w.gui.infoText('takeAmmo', l.nazv, l.kol);
				}
				
				color = 3;
			}
			else if (itemData.tip == Item.L_MED) {
				plus(l, tr);
				
				if (tr == 0 && !World.w.testLoot) {
					World.w.gui.infoText('takeMed', l.nazv);
				}
				
				if (cItem < 0) {
					nextItem(1);
				}
				else {
					World.w.gui.setItems();
				}
				
				color = 1;
			}
			else if (itemData.tip == Item.L_BOOK) {
				if (_inventory[l.id].kol == 0) {
					takeScript(l.id);
				}
				
				plus(l, tr);
				
				if (tr <= 1 && !World.w.testLoot) {
					World.w.gui.infoText('takeBook', l.nazv);
				}
				
				if (cItem < 0) {
					nextItem(1);
				}
				else {
					World.w.gui.setItems();
				}
				
				color = 4;
			}
			else if (itemData.tip == Item.L_INSTR || itemData.tip==Item.L_ART || itemData.tip==Item.L_IMPL || "sk" in itemData) {
				trace("Invent.as/take() - TYPE: INSTR, ART, IMPL, other????");
				
				if (_inventory[l.id].kol == 0)	{
					takeScript(l.id);
				}
				
				plus(l, tr);
				
				if (tr == 0 && !World.w.testLoot) {
					World.w.gui.infoText('take', l.nazv);
				}
				
				gg.pers.setParameters();
				color = 6;
			}
			else {
				if (!_inventory[l.id] || _inventory[l.id].kol == 0) {
					takeScript(l.id);
				}
				
				// Increment items in inventory
				plus(l, tr);
				
				if (tr == 0 && !World.w.testLoot) {
					if (itemData.id == 'money') { 
						World.w.gui.infoText('takeMoney', l.kol);
					}
					else {
						World.w.gui.infoText('take', l.nazv + ((l.kol > 1) ? (' (' + l.kol + ')') : ''));
					}
				}

				if (cItem < 0) {
					nextItem(1);
				}
				else {
					World.w.gui.setItems();
				}
				
				if (itemData.tip == 'valuables') {
					color = 2;
				}
				else if (itemData.tip == Item.L_HIM || itemData.tip==Item.L_POT) {
					color = 1;
				}
				else if (itemData.tip == Item.L_KEY || itemData.tip==Item.L_SPEC) {
					color = 6;
				}
				else if (itemData.tip == 'equip') {
					color = 8;
				}
				else {
					color = 0;}
			}
			
			if (tr == 2) {
				if (l.kol > 1) {
					World.w.gui.infoText('reward', l.nazv, l.kol);
				}
				else {
					World.w.gui.infoText('reward2', l.nazv);
				}
			}

			// [if the object was generated randomly, update the limits]
			if (tr == 0 && itemData.imp == 0 && "limit" in itemData) {
				World.w.game.addLimit(itemData.limit, 2);
			}

			// [pop-up message]
			if (!World.w.testLoot && (tr == 0 || tr == 2)) {
				if (itemData.fc >= 0) {
					color = itemData.fc;
				}
				
				World.w.gui.floatText(l.nazv + (l.kol > 1? (" (" + l.kol + ")") : ""), gg.coordinates.X, gg.coordinates.Y, color);
			}

			// [information window for important items]
			if (World.w.helpMess || l.tip == "art") {
				if (itemData.mess != null && !(World.w.game.triggers["mess_" + l.mess] > 0)) {
					World.w.game.triggers["mess_" + itemData.mess] = 1;
					World.w.gui.impMess(Res.txt("i", itemData.mess), Res.txt("i", itemData.mess, 2), itemData.mess);
				}
			}

			// [if the object is critical, confirm receipt]
			if (itemData.imp == 2 && "cont" in itemData) {
				itemData.cont.receipt();
			}

			var res:String = World.w.game.checkQuests(l.id);
			if (res != null) {
				World.w.gui.infoText("collect", res);
			}

			if (World.w.hardInv) {
				mass[itemData.invCat] += itemData.mass * l.kol;
			}
			
			World.w.calcMass = true;
			*/
		}

		// [Destruction of equipment]
		public function damageItems(dam:Number, destr:Boolean=true):void {
			/*
			if (!destr && !World.w.loc.base && !World.w.alicorn) {
				dam = 5;
			}
			
			if (mass[1] <= World.w.pers.maxm1 || dam <= 0) {
				return;
			}
			
			var kol:Number = dam * (mass[1] - World.w.pers.maxm1) / 800;
			if (kol >= 1 || Math.random() < kol) {
				kol = Math.ceil(kol*Math.random());
				for (var i:int = 1; i < 20; i++) {
					var nid:String = _inventory[Math.floor(Math.random() * _inventory.length)];
					if (_inventory[nid].kol > 0) {
						if (destr) {
							minusItem(nid, kol, false);
							World.w.gui.infoText("itemDestr", _inventory[nid].nazv, kol);
						}
						else {
							drop(nid, kol);
							World.w.gui.infoText("itemLose", _inventory[nid].nazv, kol);
						}
						
						World.w.calcMass = true;
						return;
					}
				}
			}
			*/
		}

		// Drop items from inventory
		public function drop(nid:String, kol:int=1):void {
			/*
			if (World.w.loc.base || World.w.alicorn) {
				return;
			}

			if (kol > _inventory[nid].kol) {
				kol = _inventory[nid].kol;
			}
			
			if (kol <= 0) {
				return;
			}
			
			var item:Item = new Item(nid, kol);
			var loot:Loot = new Loot(World.w.loc, item, _owner.coordinates.X, _owner.coordinates.Y - _owner.boundingBox.halfHeight, true, false, false);
			
			minusItem(nid, kol, false);
			*/
		}
		
		// Call attached script
		public function takeScript(id:String):void {
			/*
			if (World.w.land.itemScripts[id]) {
				trace("Invent.as/takeScript() - Running script ID: \"" + id + "\" attached to item");
				World.w.land.itemScripts[id].start();
			}
			else {
				trace("Invent.as/takeScript() - ERROR: (00:54) - script ID: \"" + id + "\" not found!");
			}
			*/
		}
		
		// [Smoke a joint]
		private function useRollup():Boolean {
			/*
			if (World.w.loc.base) {
                World.w.pip.onoff(-1);
                var xml1:XML = XMLDataGrabber.getNodeWithAttributeThatMatches("core", "AllData", "Scripts", "id", 'smokeRollup');
                var smokeScr:Script = new Script(xml1, World.w.loc.land, gg);
                smokeScr.start();
                World.w.game.triggers['rollup'] = 1;
                return true;
            }
			else {
                World.w.gui.infoText('noBase');
                return false;
            }
			*/
			return false;
		}
		
		// Add only the default armor to the player (used in the beginning of the game)
		public function addBegin():void { // TODO: Stupid, turn into a script.
			/*
			trace("Invent.as/addBegin() - Adding starting armor set to player.");
			addArmor('pip');
			cArmorId = 'pip';
			*/
		}

		public function addAllWeapon():void { // TODO: Stupid, turn into a script.
			/*
			var w;
			for each (w in LootGen.arr['weapon']) addWeapon(w.id);
			for each (w in LootGen.arr['e']) addWeapon(w.id);
			for each (w in LootGen.arr['magic']) addWeapon(w.id);
			*/
		}

		public function addAllAmmo():void { // TODO: Stupid, turn into a script.
			/*
			var w;
			for each (w in LootGen.arr['a']) _inventory[w.id].kol=10000;
			for each (w in LootGen.arr['e']) _inventory[w.id].kol=10000;
			*/
		}

		public function addAllItem():void { // TODO: Stupid, turn into a script.
			/*
			var w;
			
			for each (w in LootGen.arr['med']) {
				_inventory[w.id].kol=1000;
			}
			for each (w in LootGen.arr['compa']) {
				_inventory[w.id].kol=1000;
			}
			for each (w in LootGen.arr['him']) {
				_inventory[w.id].kol=1000;
			}
			for each (w in LootGen.arr['book']) {
				_inventory[w.id].kol=10;
			}
			for each (w in LootGen.arr['scheme']) {
				take(new Item(Item.L_SCHEME,w.id));
			}
			for each (w in LootGen.arr['spell']) {
				take(new Item(Item.L_SPELL,w.id));
			}
			for each (w in LootGen.arr['compw']) {
				_inventory[w.id].kol=100;
			}
			for each (w in LootGen.arr['compe']) {
				_inventory[w.id].kol=100;
			}
			for each (w in LootGen.arr['compm']) {
				_inventory[w.id].kol=100;
			}
			for each (w in LootGen.arr['compp']) {
				_inventory[w.id].kol=1000;
			}
			for each (w in LootGen.arr['stuff']) {
				_inventory[w.id].kol=1000;
			}
			for each (w in LootGen.arr['paint']) {
				_inventory[w.id].kol=1;
			}
			for each (w in LootGen.arr['pot']) {
				_inventory[w.id].kol=100;
			}
			for each (w in LootGen.arr['food']) {
				_inventory[w.id].kol=100;
			}
			
			_inventory['stealth'].kol = 1000;
			_inventory['potHP'].kol = 1000;
			_inventory['rep'].kol = 1000;
			_inventory['sphera'].kol = 100;
			_inventory['screwdriver'].kol = 1;
			*/
		}

		// TODO: Stupid, turn into a script.
		public function addAllArmor():void {
			/*
			for each(var arm in ItemManager.reference.armors) {
				addArmor(arm.id);
			}
			*/
		}
		
		// TODO: Stupid, turn into a script.
		public function addAll():void {
			/*
			addAllWeapon();
			addAllAmmo();
			addAllItem();
			addAllArmor();
			*/
		}

		public static function calcMass(inv:Inventory):void {
			/*
			inv.mass[1] = 0;
			inv.mass[2] = 0;
			inv.mass[3] = 0;
			
			itemList = inv.getAllItems();
			itemManager = ItemManager.reference;
			for each (var item:InventoryItem in itemList) {
				inv.mass[item.invCat] += itemManager.getItem(item.id).mass * item.quantity;
			}
			
			World.w.checkLoot = true;
			World.w.pers.invMassParam();
			*/
		}
		
		public static function calcWeaponMass(inv:Inventory):void {
			/*
			inv.massW = 0;
			inv.massM = 0;
			
			for each (var w:Weapon in _inventory) {
				if (w == null) {
					continue;
				}
				
				if (w.tip > 0 && w.tip<4 && (w.respect == Weapon.WEP_INACTIVE || w.respect == Weapon.WEP_ACTIVE)) {
					inv.massW += w.mass;
				}
				
				if (w.tip == 5 && (w.respect == Weapon.WEP_INACTIVE || w.respect == Weapon.WEP_ACTIVE) && (!w.spell || _inventory[w.id] && _inventory[w.id].kol > 0)) {
					inv.massM += w.mass;
				}
			}
			
			World.w.checkLoot = true;
			World.w.pers.invMassParam();
			*/
		}

		// [Return a string representation of the occupied space]
		public static function retMass(n:int):String {
			/*
			var txt:String;
			var cl:String = "mass";
			var m:Number;
			var maxm:Number;
			
			if (n >= 1 && n <= 3) {
				txt = "allmass"+n;
				m = mass[n];
				maxm = gg.pers["maxm" + n];
			}
			else if (n == 4) {
				txt = "allweap";
				m = massW;
				maxm = gg.pers.maxmW;
			}
			else if (n == 5) {
				txt = "allmagic";
				m = massM;
				maxm = gg.pers.maxmM;
			}
			
			if (m > maxm) {
				cl = "red";
			}
			
			return LanguageManager.reference.localText("pip", txt) + ": <span class = \'" + cl + "\'>" + Res.numb(m) + "/" + Math.round(maxm) + "</span>";
			*/
			return "AAAAAAAAAAaa, MASS COUNTING IS COMMENTED OUT AAAAAAAAAaaaaaa";
		}
	}
}
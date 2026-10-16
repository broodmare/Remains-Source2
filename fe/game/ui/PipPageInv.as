package fe.game.ui {

	import flash.display.MovieClip;
	import flash.events.MouseEvent;

	import fe.engine.text.LanguageManager;
	import fe.engine.text.TextParser;
	import fe.game.ItemInteraction;
	import fe.game.ItemManager;
	import fe.game.WeaponManager;
	import fe.game.World;
	import fe.game.GameContainer;
	import fe.game.domain.units.Armor;
	import fe.game.domain.weapon.Weapon;
	import fe.game.domain.serv.Item;
	import fe.game.domain.units.InventoryItem;
	import fe.game.domain.units.Favorites;
	import fe.engine.utils.SymbolFactory;
	
	/* 
	*	One of the main pip-buck categories
	*	sub-categories:
	*		1 - Weapons
	*		2 - Armor
	*		3 - Equipment
	*		4 - Other
	*		5 - Ammunition
	*/
	public class PipPageInv extends PipPage {

		private static const PAGE_WEAPON:int = 1;
		private static const PAGE_ARMOR:int = 2;
		private static const PAGE_EQUIPMENT:int = 3;
		private static const PAGE_OTHER:int = 4;
		private static const PAGE_AMMO:int = 5;
		
		private var assId:String = null;
		private var assArr:Array;
		private var actCurrent:String = "";
		private var canShowHidden:Boolean = false;	// The weapon page's 'show hidden' button can be used
		
		private var overId:String;
		private var overItem:Object;
		private var over_t:int;
		private var dat:Number = 0;
		
		public function PipPageInv(npip:PipBuck, npp:String) {
			isLC = true;
			isRC = true;
			itemClass = SymbolFactory.fetchSymbolClass("visPipInvItem");
			
			super(npip, npp);
			
			vis.butOk.addEventListener(MouseEvent.CLICK,showH);
			// FILTERS - each array is a subcategory in the inventory, each index in the array is the filter.
			// Entry 0 is empty for alignment, then weapons, armor, equipment, other and ammo.
			tips = [
				[],
				["", "w1", "w2", "w4", "w5", "w6", "w3"],
				["", "armor1", "armor3"],
				["", "med", ["him", "pot"], "food", ["equip", "spell"], ["book", "sphera", "note"], "paint"],
				["", ["valuables", "money"], ["spec", "key"], ["impl", "art", "instr", "equip"], ["stuff", "compa", "compw", "compe", "compm"], ["compp", "food"], "scheme"],
				["", "a", "e"]
			];
			
			initCats();
		}
		
		// [Preparing pages]
		override protected function setSubPages():void {
			var localize:Function = LanguageManager.reference.localText;
			gg = GameContainer.reference.gg;
			inv = GameContainer.reference.invent;
			
			vis.butOk.visible = false;
			statHead.cat.visible = false;
			statHead.rid.visible = false;
			pip.vis.butHelp.visible = true;
			pip.vis.butMass.visible = GameContainer.reference.hardInv;
			
			setIco();
			setCats();
			
			assId = null;
			canShowHidden = false;
			dat = new Date().getTime();
			
			if (page2 != PAGE_OTHER) {
				setTopText("invupr" + page2);
			}
			
			ItemInteraction.calcMass(inv);
			ItemInteraction.calcWeaponMass(inv);
			
			// Weapons page
			if (page2 == PAGE_WEAPON) {
				assArr = [];
				
				statHead.fav.text = localize("pip", "ii1");
				statHead.nazv.text = localize("pip", "ii2");
				statHead.hp.text = localize("pip", "ii3");
				statHead.ammo.text = "";
				statHead.mass.text = "";
				statHead.ammotip.text = localize("pip", "ii4");
				
				for each(var weapon:Weapon in inv.equipment.weapons) {
					
					if (weapon.respect == Weapon.WEP_BLUEPRINT) {
						continue;
					}
					
					if (weapon.spell && GameContainer.reference.alicorn) {
						continue;
					}
					
					// [Spells the player hasn't learned]
					if (weapon.spell && inv.getQuantity(weapon.id) <= 0) {
						continue;
					}
					
					weapon.setPers(gg, gg.pers);
					
					// [Hidden] Spells can be hidden and taken back at any time, weapons stored on the weapon stand only where the stand can be used
					if (weapon.respect == Weapon.WEP_LOCKED) {	
						if (weapon.tip == Weapon.TYPE_MAGIC || !GameContainer.reference.hardInv || World.w.loc.base || World.w.loc.train) {
							vis.butOk.visible = true;
							canShowHidden = true;
						}
						
						if (!pip.showHidden) {
							continue;
						}
					}
					
					if (weapon.alicorn && !GameContainer.reference.alicorn) {
						continue;
					}
					
					var trol:String = "w" + weapon.skill;
					
					if (trol == "w7") {
						trol = "w6";
					}
					
					// [Category]
					if (curTip != "" && curTip != null && curTip != trol) {
						continue;
					}
					
					var avail:Boolean = true;
					
					if (weapon.avail() <= -1) {
						avail = false;
					}
					
					var n:Object = {tip:"w", id:weapon.id, nazv:weapon.nazv, respect:weapon.respect, avail:avail, variant:weapon.variant, trol:trol, drop:0};
					n.expl = (weapon.tip == Weapon.TYPE_EXPLOSIVES);	// Explosives are items, any amount of them can be dropped
					
					n.sort1 = 1;
					
					if (!avail) {
						n.sort1 = 2;
					}
					
					if (n.respect == Weapon.WEP_LOCKED) {
						n.sort1 = 3;
					}
					
					n.sort3 = weapon.lvl;
					n.sort2 = weapon.skill;
					
					if (weapon.tip == Weapon.TYPE_MAGIC) {
						n.sort3 = weapon.perslvl;
					}
					
					if (weapon.spell) {
						n.sort3 = 900 + weapon.perslvl;
					}
					
					n.sort3 = int(n.sort3);
					
					if (weapon.tip != Weapon.TYPE_EXPLOSIVES && weapon.tip != Weapon.TYPE_MAGIC) {
						n.hp = Math.round(weapon.hp / weapon.maxhp * 100) + "%";
					}
					
					if (weapon.ammo != null) {
						n.ammo = WeaponManager.reference.getAmmoTotal(inv, weapon) + weapon.magazineRounds;
						n.ammotip = (weapon.tip == Weapon.TYPE_EXPLOSIVES || weapon.ammoBase == null) ? "" : weapon.ammoBase.name;
					}
					
					if (weapon.alicorn) {
						n.nazv = TextParser.rainbow(n.nazv);
					}
					
					arr.push(n);
					assArr[n.id] = n;
				}
				
				pip.reqKey = true;
				vis.butOk.text.text = localize("pip", "showhidden");
				actCurrent = "showhidden";
				
				if (arr.length) {
					arr.sortOn(["sort1", "sort2", "sort3", "nazv"], [0, 0, Array.NUMERIC, 0]);
				}
				
				pip.massText = TextParser.txt("p", "massInv0", 0, true) + "<br><br>" + TextParser.txt("p", "massInv1", 0, true);
			}
			// Armor page
			else if (page2 == PAGE_ARMOR) {
				assArr = [];
				statHead.fav.text		= localize("pip", "ii1");
				statHead.nazv.text		= localize("pip", "ii2");
				statHead.hp.text		= localize("pip", "ii3");
				statHead.ammo.text		= "";
				statHead.mass.text		= "";
				statHead.ammotip.text	= "";
				
				for each (var arm:Armor in inv.equipment.armors) {
					
					// [Blueprints and armor left on the weapon stand]
					if (arm.lvl < 0 || arm.stored) {
						continue;
					}
					
					// [category]
					if (curTip != "" && curTip != null && curTip != "armor" + arm.tip) {
						continue;
					}	
					
					n = {id:arm.id, nazv:arm.nazv, clo:arm.clo, hp:Math.round(arm.hp / arm.maxhp * 100)+"%", sort:arm.sort, trol:"armor" + arm.tip, drop:0};
					arr.push(n);
					assArr[n.id] = n;
				}
				
				pip.reqKey = true;
				
				if (arr.length) {
					arr.sortOn(["trol", "sort"], [0, Array.NUMERIC]);
				}
				
				pip.massText = TextParser.txt("p", "massInv0", 0, true) + "<br><br>" + TextParser.txt("p", "massInv2", 0, true);
			}
			else if (page2 == PAGE_EQUIPMENT || page2 == PAGE_OTHER || page2 == PAGE_AMMO) {	// [equipment]
				assArr = [];
				statHead.fav.text		= localize("pip", "ii1");
				statHead.nazv.text		= localize("pip", "ii2");
				statHead.hp.text		= localize("pip", "ii5");
				statHead.ammotip.text	= localize("pip", "ii6");
				statHead.ammo.text		= "";
				
				if (GameContainer.reference.hardInv) {
					statHead.mass.text	= localize("pip", "ii8");
				}

				var data:Object; 
				var itemManager:ItemManager = ItemManager.reference;
				for each (var item:InventoryItem in inv.getAllItems()) {
					if (item.quantity <= 0 || item.hidden || !itemManager.hasItem(item.id)) {
						continue;
					}
					
					data = itemManager.getItem(item.id);
					
					if (data.invis) {
						continue;
					}

					// [Items stop being marked as new after a while]
					if (item.nov == 1 && (dat - item.dat) > 1000 * 60 * 15) {
						item.nov = 0;
					}
					
					if (item.nov == 2 && (dat - item.dat) > 1000 * 60 * 5) {
						item.nov = 0;
					}
					
					if (!checkCat(data.tip)) {
						continue;
					}
					
					var itemTip:int = 0;
					if (data.tip == "a" || data.tip == "e") {
						itemTip = 2;
					}
					else if (data.us > 0) {
						itemTip = 1;
					}
					
					if ((itemTip == 1 && page2 == PAGE_EQUIPMENT) || (itemTip == 0 && page2 == PAGE_OTHER) || (itemTip == 2 && page2 == PAGE_AMMO)) {
						var tcat:String;
						
						if (TextParser.istxt("p", data.tip)) {
							tcat = localize("pip", data.tip);
						}
						else {
							tcat = localize("pip", "stuff");
						}
						
						n = {
							tip:		data.tip,
							id:			item.id,
							nazv:		Item.nameOf(item.id, data.tip),
							kol:		item.quantity,
							drop:		0,
							mass:		itemManager.getWeight(item.id),
							cat:		tcat,
							trol:		data.tip
						};
						
						if (data.tip == "valuables") {
							n.price = data.price;
						}
						
						if (data.tip == "food" && data.ftip == "1") {
							n.trol = "drink";
						}
						
						// [Hidden spell]
						if (data.tip == Item.L_SPELL && inv.equipment.getWeapon(item.id) && inv.equipment.getWeapon(item.id).respect == Weapon.WEP_LOCKED) {
							continue;
						}
						
						n.sort = n.cat;
						n.sort2 = "sort" in data ? data.sort : 0;
						
						// [Cartridges for current weapon forward]
						if (page2 == PAGE_AMMO && gg.currentWeapon && gg.currentWeapon.tip != Weapon.TYPE_EXPLOSIVES && gg.currentWeapon.tip != Weapon.TYPE_MAGIC && gg.currentWeapon.ammoBase && (gg.currentWeapon.ammoBase.id == data.base || gg.currentWeapon.ammoBase.id == data.id)) {
							n.sort = "0" + n.sort;
						}
						
						arr.push(n);
						assArr[n.id] = n;
					}
				}
				
				if (page2 == PAGE_EQUIPMENT) {
					pip.reqKey = true;
				}
				
				if (arr.length) {
					arr.sortOn(["sort", "sort2", "nazv"], [0, Array.NUMERIC, 0]);
				}
				
				pip.massText = TextParser.txt("p", "massInv0", 0, true) + "<br><br>" + TextParser.txt("p", "massInv3", 0, true);
			}
			
			pip.helpText = TextParser.txt("p","helpInv" + page2, 0, true);
			
			if (arr.length == 0) {
				vis.emptytext.text = localize("pip", "emptyinv");
				statHead.visible = false;
			}
			else {
				vis.emptytext.text = "";
				statHead.visible = true;
			}
			
			showBottext();
		}
		
		private function showBottext():void {
			vis.bottext.htmlText = LanguageManager.reference.localText("pip", "caps") + ": " + numberAsColor("yellow", GameContainer.reference.invent.getQuantity("money"));
			
			if (GameContainer.reference.hardInv) {
				if (page2 == PAGE_WEAPON) {
					vis.bottext.htmlText  = "    " + ItemInteraction.retMass(inv, 4) + "    " + ItemInteraction.retMass(inv, 5);
				}
				else if (page2 == PAGE_EQUIPMENT) {
					vis.bottext.htmlText += "    " + ItemInteraction.retMass(inv, 1);
				}
				else if (page2 == PAGE_OTHER) {
					vis.bottext.htmlText += "    " + ItemInteraction.retMass(inv, 3);
				}
				else if (page2 == PAGE_AMMO) {
					vis.bottext.htmlText += "    " + ItemInteraction.retMass(inv, 2);
				}
			}
		}
		
		// [Show one element] (in inventory)
		override protected function setStatItem(item:MovieClip, obj:Object):void {
			item.id.text		= obj.id;
			item.id.visible		= false;
			item.rid.visible	= false;
			item.cat.visible	= false;
			item.alpha			= 1;
			item.nazv.alpha		= 1;
			item.mass.text		= "";
			
			// [Favorites cell]
			var cell:int = inv.favorites.getCell(obj.id);
			
			if (cell > 0) {
				if (cell == Favorites.CELL_THROW) {
					item.fav.text = GameContainer.reference.ctr.retKey("keyGrenad");
				}
				else if (cell == Favorites.CELL_MAGIC) {
					item.fav.text = GameContainer.reference.ctr.retKey("keyMagic");
				}
				else if (cell > GameContainer.kolHK * 2) {
					item.fav.text = GameContainer.reference.ctr.retKey("keySpell" + (cell - GameContainer.kolHK * 2));
				}
				else if (cell > GameContainer.kolHK) {
					item.fav.text = "^" + GameContainer.reference.ctr.retKey("keyWeapon" + (cell - GameContainer.kolHK));
				}
				else {
					item.fav.text = GameContainer.reference.ctr.retKey("keyWeapon" + cell);
				}
			}
			else {
				item.fav.text = "";
			}

			try {
				item.trol.gotoAndStop(obj.trol);
			}
			catch (err:Error) {
				trace("ERROR: (00:3C)");
				item.trol.gotoAndStop(1);
			}
			
			if (page2 == PAGE_WEAPON) {
				item.ramka.visible = (GameContainer.reference.gg.newWeapon && GameContainer.reference.gg.newWeapon.id == obj.id) || (GameContainer.reference.gg.currentSpell && GameContainer.reference.gg.currentSpell.id == obj.id);
				
				if (item.ramka.visible) {
					selItem = item;
				}
				
				item.nazv.htmlText = obj.nazv;
				
				if (obj.respect == Weapon.WEP_INACTIVE && item.fav.text == "") {
					item.fav.text = "☩";
				}
				
				item.hp.text=(obj.hp == null) ? "" : obj.hp;
				
				if (obj.ammo == null) {
                    item.ammo.text = item.ammotip.text = "";
                }
				else {
                    item.ammo.text = obj.ammo;
                    item.ammotip.text = obj.ammotip;
                }
				
				if (obj.respect == Weapon.WEP_LOCKED) {
					item.alpha = 0.40;
				}
				
				if (obj.avail == false) {
					item.nazv.alpha = 0.60;
				}
				
				// [Marked to be dropped]
				if (obj.drop > 0) {
					item.ammotip.text = LanguageManager.reference.localText("pip", "drop") + (obj.expl ? ": " + obj.drop : "");
				}

				item.rid.text = obj.id;
			}
			else if (page2 == PAGE_ARMOR) {
				item.ramka.visible = false;
				
				if (GameContainer.reference.hardInv && !World.w.loc.base && obj.trol=="armor1" && GameContainer.reference.gg.prevArmor!=obj.id && obj.clo==0) {
					item.alpha = 0.40;
				}
				
				if (GameContainer.reference.gg.currentArmor && GameContainer.reference.gg.currentArmor.id == obj.id) {
					item.ramka.visible = true;
					item.alpha = 1;
					selItem = item;
				}
				
				if (GameContainer.reference.gg.currentAmul && GameContainer.reference.gg.currentAmul.id == obj.id) {
					item.ramka.visible = true;
				}
				
				item.nazv.text = obj.nazv;
				
				if (obj.trol == "armor3") {
					item.hp.text = "";
				}
				else {
					item.hp.text = obj.hp;
				}
				
				item.ammo.text = "";
				item.ammotip.text = (obj.drop > 0) ? LanguageManager.reference.localText("pip", "drop") : "";
			}
			else  {
				item.ramka.visible = (GameContainer.reference.gg.currentSpell && GameContainer.reference.gg.currentSpell.id == obj.id);
				item.nazv.text = obj.nazv;
				item.hp.text = obj.kol;
				
				if (GameContainer.reference.hardInv && obj.mass > 0) {
					item.mass.text = TextParser.numb(obj.kol * obj.mass);
				}
				
				if (obj.price && obj.tip == "valuables") {
					item.ammo.text = obj.price;
				}
				else {
					item.ammo.text = "";
				}
				
				// [New items]
				if (item.fav.text == "" && inv.getItem(obj.id)) {
					if (inv.getItem(obj.id).nov == 1) {
						item.fav.text = "☩";
					}
				
					if (inv.getItem(obj.id).nov == 2) {
						item.fav.text = "+";
					}
				}

				
				if (obj.drop > 0) {
					item.ammotip.text = LanguageManager.reference.localText("pip", "drop") + ": " + obj.drop;
				}
				else {
					item.ammotip.text = obj.cat.substring(2);
				}
			}
		}
		
		// [item information]
		override protected function statInfo(event:MouseEvent):void {
			assId = null;
			
			if (page2 == PAGE_WEAPON) {
				assId=event.currentTarget.id.text;
				infoItem(Item.L_WEAPON,event.currentTarget.rid.text,event.currentTarget.nazv.text);
			}
			
			if (page2 == PAGE_ARMOR) {
				assId=event.currentTarget.id.text;
				infoItem(Item.L_ARMOR,event.currentTarget.id.text,event.currentTarget.nazv.text);
			}
			
			if (page2 == PAGE_EQUIPMENT || page2 == PAGE_OTHER) {
				if (page2 == PAGE_EQUIPMENT) assId=event.currentTarget.id.text;
				infoItem(Item.L_ITEM,event.currentTarget.id.text,event.currentTarget.nazv.text);
			}
			
			if (page2 == PAGE_AMMO) {
				infoItem(Item.L_AMMO,event.currentTarget.id.text,event.currentTarget.nazv.text);
			}
			
			if (page2 == 0 || page2 == PAGE_WEAPON || page2 == PAGE_ARMOR || page2 == PAGE_EQUIPMENT) {
				if (event.currentTarget.id.text != overId) {
					overId = event.currentTarget.id.text;
					overItem = event.currentTarget;
					over_t = 30;
				}
			}
		}
		
		override protected function itemClick(event:MouseEvent):void {
			if (pip.noAct) {
				GUIManager.reference.gui.infoText("noAct");
				return;
			}
			
			if (event.ctrlKey) {
				itemRightClick(event);
				return;
			}
			
			var ci:String = event.currentTarget.id.text;
			
			if (page2 == PAGE_WEAPON) {
				GameContainer.reference.gg.changeWeapon(ci);
				selItem = event.currentTarget as MovieClip;
				setStatus(false);
				statInfo(event);	// setStatus() clears the item's information, show it again
				pip.snd(1);
			} 
			else if (page2 == PAGE_ARMOR) {
				if (GameContainer.reference.gg.changeArmor(ci)) {
					setStatus(false);
					statInfo(event);
				}
				
				pip.snd(1);
			} 
			else if (page2 == PAGE_EQUIPMENT) {
				if (ci=="retr") {
					if (GameContainer.reference.alicorn) {
						GUIManager.reference.gui.infoText("alicornNot",null,null,false);
						return; // Set as return instead of return false.
					}
					
					if (GameContainer.reference.game.curLandId==GameContainer.reference.game.baseId) {
						return;
					}
					else if (World.w.possiblyOut()>=2) {
						GUIManager.reference.gui.infoText("noUseCombat");
					}
					else {
						buttonOk("retr");
					}
				} 
				else if (ci=="mworkbench" || ci=="mworkexpl" || ci=="mworklab") {
					if (GameContainer.reference.t_battle>0) {
						GUIManager.reference.gui.infoText("noUseCombat",null,null,false);
					} 
					else {
						pip.workTip=ci;
						pip.onoff(7);
					}
				} 
				else {
					gg.itemInteraction.useItem(ci);
					setStatus(false);
					GUIManager.reference.gui.setHp();
				}
				
				pip.snd(1);
				over_t=2;
			}
			else if (page2 == PAGE_AMMO) {
				if (gg.invent.equipment.hasWeapon(ci)) {
					gg.invent.equipment.getWeapon(ci).respect = Weapon.WEP_ACTIVE;
					GameContainer.reference.gg.changeWeapon(ci);
				} 
				else if (gg.currentWeapon && gg.currentWeapon.tip != Weapon.TYPE_EXPLOSIVES && gg.currentWeapon.tip != Weapon.TYPE_MAGIC && gg.currentWeapon.magazineCapacity > 0) {
					gg.currentWeapon.initReload(ci);
				}
			}
			
			pip.setRPanel();
			showBottext();
		}
		
		override protected function itemRightClick(event:MouseEvent):void {
			if (pip.noAct) {
				GUIManager.reference.gui.infoText("noAct");
				return;
			}
			
			var obj:Object = assArr[event.currentTarget.id.text];
			
			if (obj == null) {
				return;
			}
			
			// [Mark weapons and armor to be dropped] Spells can't be dropped, they're hidden or taken back instead
			if (page2 == PAGE_WEAPON || page2 == PAGE_ARMOR) {
				var weapon:Weapon = (page2 == PAGE_WEAPON) ? inv.equipment.getWeapon(obj.id) : null;
				
				if (weapon && weapon.tip == Weapon.TYPE_MAGIC) {
					obj.respect = gg.itemInteraction.respectWeapon(obj.id);
					setStatItem(event.currentTarget as MovieClip, obj);
					pip.setRPanel();
					showBottext();
					pip.snd(1);
					return;
				}
				
				if (World.w.loc.base) {
					GUIManager.reference.gui.infoText("noDrop1", null, null, false);
					return;
				}
				
				// [Explosives are dropped like other items] one at a time, or all of them with [shift]
				if (obj.expl) {
					var have:int = inv.getQuantity(obj.id);
					
					if (have <= 0) {
						GUIManager.reference.gui.infoText("noDrop2", null, null, false);
						return;
					}
					
					obj.drop = event.shiftKey ? have : Math.min(obj.drop + 1, have);
				}
				// Weapons stored on the weapon stand are taken back from the stand
				else if (page2 == PAGE_WEAPON && !ItemInteraction.canDropWeapon(weapon)) {
					GUIManager.reference.gui.infoText((weapon && weapon.respect == Weapon.WEP_LOCKED) ? "disWeapon" : "noDrop2", null, null, false);
					return;
				}
				// [Amulets can't be dropped]
				else if (page2 == PAGE_ARMOR && !ItemInteraction.canDropArmor(inv.equipment.getArmor(obj.id))) {
					GUIManager.reference.gui.infoText("noDrop2", null, null, false);
					return;
				}
				else {
					obj.drop = (obj.drop > 0) ? 0 : 1;
				}
				
				setStatItem(event.currentTarget as MovieClip, obj);
				updateDropButton();
				pip.snd(1);
			}
			
			// [Drop items]
			if (page2 >= PAGE_EQUIPMENT) {
				if (World.w.loc.base) {
					GUIManager.reference.gui.infoText("noDrop1",null,null,false);
					return;
				}
				
				if (obj.mass > 0 && obj.tip != "book" && obj.tip != "sphera") {
					if (event.shiftKey) {
						obj.drop = obj.kol;
					}
					else {
						obj.drop++;
					}
					
					setStatItem(event.currentTarget as MovieClip, obj);
					buttonOk("drop");
				}
				else {
					GUIManager.reference.gui.infoText("noDrop2", null, null, false);
				}
			}
		}
		
		public function assignKey(num:int):void {
			pip.snd(1);
			var temp:String = assId;
			
			if ((page2 == 0 || page2 == PAGE_WEAPON || page2 == PAGE_ARMOR || page2 == PAGE_EQUIPMENT) && assId != null) {
				gg.itemInteraction.favItem(assId, num);
				setStatus(false);
			}
			
			assId = temp;
		}
		
		private function showH(event:MouseEvent):void {
			// [show hidden weapon]
			if (actCurrent == "showhidden") {
				pip.showHidden=!pip.showHidden;
				setStatus();
				pip.snd(2);
			}
			// [Return to base]
			else if (actCurrent == "retr") {
				if (inv.hasItem("retr") && GameContainer.reference.game.triggers["noreturn"] != 1) {
					inv.decreaseQuantity("retr");
					GameContainer.reference.game.gotoLand(GameContainer.reference.game.baseId);
				}
				
				vis.butOk.visible = false;
				pip.onoff(-1);
			}
			//выбросить вещи
			else if (actCurrent == "drop") {		
				for each (var obj:Object in arr) {
					if (obj.drop <= 0) {
						continue;
					}
					
					if (page2 == PAGE_WEAPON && !obj.expl) {
						gg.itemInteraction.dropWeapon(obj.id);
					}
					else if (page2 == PAGE_ARMOR) {
						gg.itemInteraction.dropArmor(obj.id);
					}
					else {
						gg.itemInteraction.drop(obj.id, obj.drop);
					}
				}
				
				vis.butOk.visible = false;
				pip.onoff(-1);
			}
		}
		
		// Show the drop button while something is marked to be dropped, otherwise put back the weapon page's 'show hidden' button
		private function updateDropButton():void {
			for each (var obj:Object in arr) {
				if (obj.drop > 0) {
					buttonOk("drop");
					return;
				}
			}
			
			buttonOk("showhidden");
			vis.butOk.visible = (page2 == PAGE_WEAPON && canShowHidden);
		}
		
		private function buttonOk(act:String):void {
			vis.butOk.visible = true;
			vis.butOk.text.text = LanguageManager.reference.localText("pip", act);
			actCurrent = act;
		}
		
		
		public override function step():void {
			if (over_t > 0) {
				over_t--;
			}
			
			if (over_t == 1 && overItem) {
				try {
					if (overItem.fav.text == "☩" || overItem.fav.text == "+") {
						overItem.fav.text = "";
					}
					if (inv.getItem(overId)) {
						inv.getItem(overId).nov = 0;
					}
				}
				catch (err:Error) {
					trace("ERROR: (00:3C)");
				}				
			}
		}	
	}	
}
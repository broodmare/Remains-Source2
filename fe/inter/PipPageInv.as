package fe.inter {

	import flash.display.MovieClip;
	import flash.events.MouseEvent;

	import fe.*;
	import fe.unit.Armor;
	import fe.weapon.Weapon;
	import fe.serv.Item;
	import fe.unit.InventoryItem;

	import fe.stubs.visPipInvItem;
	
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

		private static const PAGE_WEAPON:int = 1, PAGE_ARMOR:int = 2, PAGE_EQUIPMENT:int = 3, PAGE_OTHER:int = 4, PAGE_AMMO:int = 5;
		
		private var assId:String = null;
		private var assArr:Array;
		private var actCurrent:String = "";
		
		private var overId:String;
		private var overItem:Object;
		private var over_t:int;
		private var dat:Number = 0;
		
		// Constructor
		public function PipPageInv(npip:PipBuck, npp:String) {
			isLC = true;
			isRC = true;
			itemClass = visPipInvItem;
			
			super(npip, npp);
			
			vis.butOk.addEventListener(MouseEvent.CLICK,showH);
			// FILTERS - each array is a subcategory in the inventory, each index in the array is the filter.
			tips = [
				[],									// Empty entry for correct alignment
				["","w1","w2","w4","w5","w6","w3"],	// Weapon filter buttons
				["","armor1","armor3"],				// Armor filter buttons
				["","med",["him","pot"],"food",["equip","spell"],["book","sphera","note"],"paint"],
				["",["valuables","money"],["spec","key"],["impl","art","instr","equip"],["stuff","compa","compw","compe","compm"],["compp","food"],"scheme"],
				["","a","e"]
			];
			
			initCats();
		}
		
		// [Preparing pages]
		override protected function setSubPages():void {
			var localize:Function = LanguageManager.reference.localText;

			vis.butOk.visible = false;
			statHead.cat.visible = false;
			statHead.rid.visible = false;
			pip.vis.butHelp.visible = true;
			pip.vis.butMass.visible = World.w.hardInv;
			
			setIco();
			setCats();
			
			assId = null;
			dat = new Date().getTime();
			
			if (page2 != PAGE_OTHER) {
				setTopText("invupr" + page2);
			}
			
			//inv.calcMass();
			//inv.calcWeaponMass();
			
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
					
					if (weapon.spell && World.w.alicorn) {
						continue;
					}
					
					if (weapon.spell && !inv.equipment.hasEquipment(weapon.id)) {
						continue;
					}
					
					weapon.setPers(gg, gg.pers);
					
					// [Hidden]
					if (weapon.respect == Weapon.WEP_LOCKED) {	
						if (!World.w.hardInv || World.w.loc.base || World.w.loc.train) {
							vis.butOk.visible = true;
						}
						
						if (!pip.showHidden) {
							continue;
						}
					}
					
					if (weapon.alicorn && !World.w.alicorn) {
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
					
					var n:Object = {tip:"w", id:weapon.id, nazv:weapon.nazv, respect:weapon.respect, avail:avail, variant:weapon.variant, trol:trol};
					
					n.sort1 = 1;
					
					if (!avail) {
						n.sort1 = 2;
					}
					
					if (n.respect == Weapon.WEP_LOCKED) {
						n.sort1 = 3;
					}
					
					n.sort3 = weapon.lvl;
					n.sort2 = weapon.skill;
					
					if (weapon.tip == "magic") {
						n.sort3 = weapon.perslvl;
					}
					
					if (weapon.spell) {
						n.sort3 = 900 + weapon.perslvl;
					}
					
					n.sort3 = int(n.sort3);
					
					if (weapon.tip == "internal" || weapon.tip == "cryo" || weapon.tip == "lightGun" || weapon.tip == "heavyGun") {
						n.hp = Math.round(weapon.hp / weapon.maxhp * 100) + "%";
					}
					
					if (weapon.ammo != null) {
						if (inv.hasItem(weapon.ammo.base)) {
							n.ammo = inv.getQuantity(weapon.ammo.id) + weapon.magazineRounds;
						}
						else {
							n.ammo = inv.getQuantity(weapon.ammo.base) + weapon.magazineRounds;
						}
						
						n.ammotip = (weapon.tip == "explosives") ? "" : ItemManager.reference.getItem(weapon.ammo.base).nazv;
					}
					
					if (weapon.alicorn) {
						n.nazv = Res.rainbow(n.nazv);
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
				
				pip.massText = Res.txt("p", "massInv0", 0, true) + "<br><br>" + Res.txt("p", "massInv1", 0, true);
			}
			// Armor page
			else if (page2 == PAGE_ARMOR) {
				statHead.fav.text		= localize("pip", "ii1");
				statHead.nazv.text		= localize("pip", "ii2");
				statHead.hp.text		= localize("pip", "ii3");
				statHead.ammo.text		= "";
				statHead.mass.text		= "";
				statHead.ammotip.text	= "";
				
				for each (var arm:Armor in inv.equipment.armors) {
					
					if (arm.lvl < 0) {
						continue;
					}
					
					// [category]
					if (curTip != "" && curTip != null && curTip != "armor" + arm.tip) {
						continue;
					}	
					
					n = {id:arm.id, nazv:arm.nazv, clo:arm.clo, hp:Math.round(arm.hp / arm.maxhp * 100)+"%", sort:arm.sort, trol:"armor" + arm.tip};
					arr.push(n);
				}
				
				pip.reqKey = true;
				
				if (arr.length) {
					arr.sortOn(["trol", "sort"], [0, Array.NUMERIC]);
				}
				
				pip.massText = Res.txt("p", "massInv0", 0, true) + "<br><br>" + Res.txt("p", "massInv2", 0, true);
			}
			else if (page2 == PAGE_EQUIPMENT || page2 == PAGE_OTHER || page2 == PAGE_AMMO) {	// [equipment]
				assArr = [];
				statHead.fav.text		= localize("pip", "ii1");
				statHead.nazv.text		= localize("pip", "ii2");
				statHead.hp.text		= localize("pip", "ii5");
				statHead.ammotip.text	= localize("pip", "ii6");
				statHead.ammo.text		= "";
				
				if (World.w.hardInv) {
					statHead.mass.text	= localize("pip", "ii8");
				}

				var data:Object; 
				var itemManager:ItemManager;
				for each (var item:InventoryItem in inv.getAllItems()) {
					if (item.hidden) {
						continue;
					}
					
					data = itemManager.getItem(item.id);

					if (data.nov == 1 && (data.dat) > 1000 * 60 * 15) {
						//data.nov = 0; Can't set this anymore right now FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME 
					}
					
					if (data.nov == 2 && (data.dat) > 1000 * 60 * 5) {
						//data.nov = 0; ; Can't set this anymore right now FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME 
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
						
						if (Res.istxt("p", data.tip)) {
							tcat = localize("pip", data.tip);
						}
						else {
							tcat = localize("pip", "stuff");
						}
						
						n = {
							tip:		data.tip,
							id:			item.id,
							nazv:		((data.tip == "e") ? localize("weapon", item.id) : ItemManager.reference.getItem(item.id).nazv),
							kol:		inv.getQuantity(item.id),
							drop:		0,
							mass:		0, //inv.items[s].mass, FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME 
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
						if (data.tip == "spell" && inv.equipment.hasEquipment(item.id) && inv.equipment.getWeapon(item.id).respect == Weapon.WEP_LOCKED) {
							continue;
						}
						
						n.sort = n.cat;
						n.sort2 = "sort" in data ? data.sort : 0;
						
						// [Cartridges for current weapon forward]
						if (page2 == PAGE_AMMO && gg.currentWeapon && gg.currentWeapon.tip != "explosives" && gg.currentWeapon.tip != "magic" && (gg.currentWeapon.ammoBase.id == data.base || gg.currentWeapon.ammoBase.id == data.id)) {
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
				
				pip.massText = Res.txt("p", "massInv0", 0, true) + "<br><br>" + Res.txt("p", "massInv3", 0, true);
			}
			
			pip.helpText = Res.txt("p","helpInv" + page2, 0, true);
			
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
			vis.bottext.htmlText = LanguageManager.reference.localText("pip", "caps") + ": " + numberAsColor("yellow", World.w.invent.getQuantity("money"));
			/* FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME 
			if (World.w.hardInv) {
				if (page2 == PAGE_WEAPON) {
					vis.bottext.htmlText  = "    " + inv.retMass(4) + "    " + inv.retMass(5);
				}
				else if (page2 == PAGE_EQUIPMENT) {
					vis.bottext.htmlText += "    " + inv.retMass(1);
				}
				else if (page2 == PAGE_OTHER) {
					vis.bottext.htmlText += "    " + inv.retMass(3);
				}
				else if (page2 == PAGE_AMMO) {
					vis.bottext.htmlText += "    " + inv.retMass(2);
				}
			} */
		}
		
		//показ одного элемента
		override protected function setStatItem(item:MovieClip, obj:Object):void {
			item.id.text		= obj.id;
			item.id.visible		= false;
			item.rid.visible	= false;
			item.cat.visible	= false;
			item.alpha			= 1;
			item.nazv.alpha		= 1;
			item.mass.text		= "";
			
			/*
			if (inv.favIds[obj.id]) {
				if (inv.favIds[obj.id]==29) item.fav.text=World.w.ctr.retKey("keyGrenad");
				else if (inv.favIds[obj.id]==30) item.fav.text=World.w.ctr.retKey("keyMagic");
				else if (inv.favIds[obj.id]>World.kolHK*2) item.fav.text=World.w.ctr.retKey("keySpell"+(inv.favIds[obj.id]-World.kolHK*2));
				else if (inv.favIds[obj.id]>World.kolHK) item.fav.text="^"+World.w.ctr.retKey("keyWeapon"+(inv.favIds[obj.id]-World.kolHK));
				else item.fav.text=World.w.ctr.retKey("keyWeapon"+inv.favIds[obj.id]);
			}
			else {
				item.fav.text = "";
			}
			*/ // DISBALED FOR ITEM REWORK FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME 

			try {
				item.trol.gotoAndStop(obj.trol);
			}
			catch (err) {
				trace("ERROR: (00:3C)");
				item.trol.gotoAndStop(1);
			}
			
			if (page2 == PAGE_WEAPON) {
				item.ramka.visible = (World.w.gg.newWeapon && World.w.gg.newWeapon.id == obj.id) || (World.w.gg.currentSpell && World.w.gg.currentSpell.id == obj.id);
				
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

				item.rid.text = obj.id;
			}
			else if (page2 == PAGE_ARMOR) {
				item.ramka.visible = false;
				
				if (World.w.hardInv && !World.w.loc.base && obj.trol=="armor1" && World.w.gg.prevArmor!=obj.id && obj.clo==0) {
					item.alpha = 0.40;
				}
				
				if (World.w.gg.currentArmor && World.w.gg.currentArmor.id == obj.id) {
					item.ramka.visible = true;
					item.alpha = 1;
					selItem = item;
				}
				
				if (World.w.gg.currentAmul && World.w.gg.currentAmul.id == obj.id) {
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
				item.ammotip.text = "";
			}
			else  {
				item.ramka.visible = (World.w.gg.currentSpell && World.w.gg.currentSpell.id == obj.id);
				item.nazv.text = obj.nazv;
				item.hp.text = obj.kol;
				
				if (World.w.hardInv && obj.mass > 0) {
					item.mass.text = Res.numb(obj.kol * obj.mass);
				}
				
				if (obj.price && obj.tip == "valuables") {
					item.ammo.text = obj.price;
				}
				else {
					item.ammo.text = "";
				}
				
				/*
				if (item.fav.text == "") {
					if (inv.getItem(obj.id).nov == 1) {
						item.fav.text = "☩";
					}
				
					if (inv.getItem(obj.id).nov == 2) {
						item.fav.text = "+";
					}
				} */ // FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME 

				
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
				World.w.gui.infoText("noAct");
				return;
			}
			
			if (event.ctrlKey) {
				itemRightClick(event);
				return;
			}
			
			var ci:String = event.currentTarget.id.text;
			
			if (page2 == PAGE_WEAPON) {
				World.w.gg.changeWeapon(ci);
				selItem = event.currentTarget as MovieClip;
				setStatus(false);
				pip.snd(1);
			} 
			else if (page2 == PAGE_ARMOR) {
				if (World.w.gg.changeArmor(ci)) {
					setStatus(false);
				}
				
				pip.snd(1);
			} 
			else if (page2 == PAGE_EQUIPMENT) {
				if (ci=="retr") {
					if (World.w.alicorn) {
						World.w.gui.infoText("alicornNot",null,null,false);
						return; // Set as return instead of return false.
					}
					
					if (World.w.game.curLandId==World.w.game.baseId) {
						return;
					}
					else if (World.w.possiblyOut()>=2) {
						World.w.gui.infoText("noUseCombat");
					}
					else {
						buttonOk("retr");
					}
				} 
				else if (ci=="mworkbench" || ci=="mworkexpl" || ci=="mworklab") {
					if (World.w.t_battle>0) {
						World.w.gui.infoText("noUseCombat",null,null,false);
					} 
					else {
						pip.workTip=ci;
						pip.onoff(7);
					}
				} 
				else {
					//World.w.invent.useItem(ci);	// FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME 
					setStatus(false);
					World.w.gui.setHp();
				}
				
				pip.snd(1);
				over_t=2;
			}
			else if (page2 == PAGE_AMMO) {
				if (gg.invent.equipment.hasEquipment(ci)) {
					gg.invent.equipment.getWeapon(ci).respect = Weapon.WEP_ACTIVE;
					World.w.gg.changeWeapon(ci);
				} 
				else if (gg.currentWeapon && gg.currentWeapon.tip <= "heavyGun" && gg.currentWeapon.magazineCapacity > 0) {
					gg.currentWeapon.initReload(ci);
				}
			}
			
			pip.setRPanel();
			showBottext();
		}
		
		override protected function itemRightClick(event:MouseEvent):void {
			if (pip.noAct) {
				World.w.gui.infoText("noAct");
				return;
			}
			
			if (page2 == PAGE_WEAPON) {
				var obj = assArr[event.currentTarget.id.text];
				// obj.respect = World.w.invent.respectWeapon(event.currentTarget.id.text); FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME 
				setStatItem(event.currentTarget as MovieClip, obj);
				pip.setRPanel();
				showBottext();
				pip.snd(1);
			}
			
			if (page2 == 0 || page2 == PAGE_WEAPON || page2 == PAGE_ARMOR || page2 == PAGE_EQUIPMENT) {
				if (World.w.loc.base) {
					World.w.gui.infoText("noDrop1",null,null,false);
					return;
				}
				
				var obj = assArr[event.currentTarget.id.text];
				
				if (obj.mass>0 && obj.tip!="book" && obj.tip!="sphera") {
					if (event.shiftKey) {
						obj.drop=obj.kol;
					}
					else {
						obj.drop++;
					}
					
					setStatItem(event.currentTarget as MovieClip, obj);
					buttonOk("drop");
				}
				else {
					World.w.gui.infoText("noDrop2",null,null,false);
				}
			}
		}
		
		public function assignKey(num:int):void {
			pip.snd(1);
			var temp = assId;
			
			if ((page2 == 0 || page2 == PAGE_WEAPON || page2 == PAGE_ARMOR || page2 == PAGE_EQUIPMENT) && assId != null) {
				// World.w.invent.favItem(assId, num); FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME 
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
				if (inv.hasItem("retr") && World.w.game.triggers["noreturn"] != 1) {
					inv.decreaseQuantity("retr");
					World.w.game.gotoLand(World.w.game.baseId);
				}
				
				vis.butOk.visible = false;
				pip.onoff(-1);
			}
			//выбросить вещи
			else if (actCurrent == "drop") {		
				for each (var obj in arr) {
					if (obj.drop > 0) {
						//inv.drop(obj.id, obj.drop);	FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME 
					}
				}
				
				vis.butOk.visible = false;
				pip.onoff(-1);
			}
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
					if (overItem.fav.text == "☩" || overItem.fav.text == "+") overItem.fav.text = "";
					//inv.getItem(overId).nov = 0;	FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME 
				}
				catch (err) {
					trace("ERROR: (00:3C)");
				}				
			}
		}	
	}	
}
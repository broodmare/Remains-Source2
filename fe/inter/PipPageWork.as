package fe.inter {

	import flash.display.MovieClip;
	import flash.events.MouseEvent;

	import fe.*;
	import fe.unit.Armor;
	import fe.weapon.Weapon;
	import fe.serv.Item;
	import fe.unit.InventoryItem;
	import fe.unit.UnitPet;

	import fe.stubs.visPipInvItem;
	
	/* 
	*	The page displayed when interacting with a crafting table
	*	sub-categories:
	*		1 - Create
	*		2 - Enhance
	*		3 - Repair
	*		4 - *disabled*
	*		5 - *disabled*
	*/
	public class PipPageWork extends PipPage {
		
		private static const PAGE_CRAFT:int = 1, PAGE_UPGRADE:int = 2, PAGE_REPAIR:int = 3;
		private var assArr:Array;

		// Constructor
		public function PipPageWork(npip:PipBuck, npp:String) {
			isLC = true;
			itemClass = visPipInvItem;
			super(npip, npp);

			// Set which sub-categories are disabled at the top of the pip-buck
			vis.but4.visible = false;
			vis.but5.visible = false;
		}

		// [Preparing pages]
		override protected function setSubPages():void {
			
			trace("PipPageWork.as/setSubPages() - Initializing the workbench interface. Station type: " + pip.workTip);

			// Indicate if we're using a specialized crafting bench, otherwise this value is just "work"
			if (pip.workTip == "mworklab") {
				pip.workTip = "lab";
			}
			
			if (pip.workTip == "mworkexpl") {
				pip.workTip = "expl";
			}
			
			 // Enable the sub-category buttons at the top of the pip-buck
			vis.but1.visible = true;
			vis.but2.visible = true;
			vis.but3.visible = true;

			// This workbench can only repair
			if (pip.workTip=="mworkbench") {
				vis.but1.visible = false;
				vis.but2.visible = false;
				// Set the current page to the "Repair" page
				page2 = PAGE_REPAIR;
			}
			// These workbenches can only create
			else if (pip.workTip == "stove" || pip.workTip == "lab" || pip.workTip == "expl") {
				vis.but2.visible = false;
				vis.but3.visible = false;
				// Set the current page to the "Create" page
				page2 = PAGE_CRAFT;
			}

			vis.bottext.text = LanguageManager.reference.localText("pip", "caps") + ": " + World.w.invent.getQuantity("money");
			vis.butOk.visible = false;
			statHead.cat.visible = false;
			setIco();
			
			var assId:String = null;
			var n:Object;
			
			statHead.rid.visible = false;
			statHead.mass.text = "";
			vis.bottext.text = "";

			// The "Create" page
			if (page2 == PAGE_CRAFT) {

				assArr					= [];
				statHead.fav.text		= "";
				statHead.nazv.text		= LanguageManager.reference.localText("pip", "work1");
				statHead.hp.text		= LanguageManager.reference.localText("pip", "iv6");
				statHead.ammo.text		= "";
				statHead.ammotip.text	= "";
				
				for each (var item:InventoryItem in inv.getAllItems()) {
					
					var data:Object = ItemManager.reference.getItem(item.id);
					
					if (data.tip == "scheme" && "work" in data && (data.work == 0 || data.work == pip.workTip || data.work == "expl" && pip.workTip == "work")) {
						var ok:int = 1;
						
						if ("skill" in data && "lvl" in data && gg.pers.getSkillLevel(data.skill) < data.lvl) {
							ok = 2;
						}
						
						// Get the real item ID by removing the first two letters from the id, eg. "s_pizza" turns into "pizza"
						var wid:String = data.id.substr(2);
						
						if (inv.equipment.hasEquipment(wid)) {
							if (inv.equipment.getWeapon(wid).respect == Weapon.WEP_BLUEPRINT || inv.equipment.getWeapon(wid).tip == Weapon.TYPE_EXPLOSIVES) {
								n = {
									tip:	Item.L_WEAPON,
									id:		wid,
									nazv:	Res.txt("w", wid),
									ok:		ok,
									sort:	data.skill + data.lvl
								};
								
								if (inv.hasItem(wid)) {
									n.kol = inv.getQuantity(wid);
								}
								
								arr.push(n);
								assArr[n.id] = n;
							}
						}
						else if (inv.equipment.getArmor(wid)) {
							if (inv.equipment.getArmor(wid).lvl < 0) {
								n = {
									tip:	Item.L_ARMOR,
									id:		wid,
									nazv:	Res.txt("a", wid),
									ok:		ok,
									sort:	data.skill + data.lvl
								};
								
								arr.push(n);
							}
						}
						else {
							
							if ((data.tip == Item.L_IMPL || data.one > 0) && inv.hasItem(wid)) {
								trace("PipPageWork.as/setSubPages() - We've already made this item");
								continue; // [Only one piece]
							}	
							
							n = {
								tip:(data.tip == Item.L_IMPL ? Item.L_IMPL : Item.L_ITEM),
								kol:inv.getQuantity(wid),
								id:wid, nazv:Res.txt("i", wid),
								ok:ok,
								sort:data.skill + data.lvl
							};

							arr.push(n);
							assArr[n.id] = n;
						}
					}
				}
				
				if (arr.length) {
					arr.sortOn(["ok", "sort"]);
					vis.emptytext.text = "";
					statHead.visible = true;
				}
				else {
					vis.emptytext.text = LanguageManager.reference.localText("pip", "emptycreate");
					statHead.visible = false;
				}
			}
			// The "Enhance" page
			else if (page2 == PAGE_UPGRADE) {
				statHead.fav.text="";
				statHead.nazv.text="";
				statHead.hp.text="";
				statHead.ammo.text="";
				statHead.ammotip.text="";
				
				if (gg.pers.maxArmorLvl > 0) {
					for each(var arm:Armor in inv.equipment.armors) {
						if (arm.lvl >= 0 && arm.lvl < arm.maxlvl && arm.lvl < gg.pers.maxArmorLvl) {
							n = {tip:Item.L_ARMOR, id:arm.id, nazv:arm.nazv, lvl:arm.lvl, sort:("a" + arm.sort)};
							arr.push(n);
						}
					}
				}
				
				for each(var weap:Weapon in inv.equipment.weapons) {
					if (weap.skill==3 && weap.variant == 0 && weap.respect != Weapon.WEP_BLUEPRINT) {
						n = {tip:Item.L_WEAPON, id:weap.id, nazv:weap.nazv, sort:("w" + weap.nazv)};
						arr.push(n);
					}
				}
				
				if (arr.length) {
					arr.sortOn("sort");
					vis.emptytext.text = "";
					statHead.visible = true;
				}
				else {
					vis.emptytext.text = LanguageManager.reference.localText("pip", "emptyupgrade");
					statHead.visible = false;
				}
			}
			// The "Repair" page
			else if (page2 == PAGE_REPAIR) {
				assArr = [];
				
				statHead.fav.text		= "";
				statHead.nazv.text		= LanguageManager.reference.localText("pip", "ii2");
				statHead.hp.text		= LanguageManager.reference.localText("pip", "ii3");
				statHead.ammo.text		= "";
				statHead.ammotip.text	= LanguageManager.reference.localText("pip", "repairto");
				
				setTopText("inforepair");
				
				if (inv.hasItem("owl")) {
					World.w.pers.setRoboowl();
					
					if (World.w.pers.owlhpProc < 1) {
						var owlRep:int = 100;
						
						n = {
							tip:	Item.L_INSTR,
							id:		"owl",
							nazv:	ItemManager.reference.getItem("owl").nazv,
							hp:		World.w.pers.owlhp * World.w.pers.owlhpProc,
							maxhp:	World.w.pers.owlhp,
							rep:	owlRep / World.w.pers.owlhp
						};
						
						arr.push(n);
						assArr[n.id]=n;
					}

				}
				
				for each (var w:Weapon in inv.equipment.weapons) {
					if (w.tip != "internal" && w.tip != "explosives" && w.respect != Weapon.WEP_LOCKED && w.hp < w.maxhp) {
						n = {
							tip:	Item.L_WEAPON,
							id:		w.id,
							nazv:	w.nazv,
							hp:		w.hp,
							maxhp:	w.maxhp,
							rep:	w.rep_eff * 0.25
						};
						
						arr.push(n);
						assArr[n.id] = n;
					}
				}
				
				for each (var a:Armor in inv.equipment.armors) {
					if (!a.norep && !a.und && a.hp < a.maxhp) {
						n = {
							tip:	Item.L_ARMOR,
							id:		a.id,
							nazv:	a.nazv,
							hp:		a.hp,
							maxhp:	a.maxhp,
							rep:	1 / a.kolComp
						};
						
						arr.push(n);
						assArr[n.id] = n;
					}
				}
				
				if (arr.length) {
					vis.emptytext.text = "";
					statHead.visible = true;
				}
				else {
					vis.emptytext.text = LanguageManager.reference.localText("pip", "emptyrep");
					statHead.visible = false;
				}
			}

		}
		
		//показ одного элемента
		override protected function setStatItem(item:MovieClip, obj:Object):void {
			item.rid.visible		= false;
			item.id.text			= obj.id;
			item.cat.text			= obj.tip;
			item.nazv.text			= obj.nazv;
			item.id.visible			= false;
			item.cat.visible		= false;
			item.ramka.visible		= false;
			item.mass.text			= "";
			item.fav.text			= "";
			item.hp.text			= "";
			item.ammotip.text		= "";
			item.alpha				= 1;
			
			if (page2 == PAGE_CRAFT) {
				if (obj.ok > 1) {
					item.alpha = 0.50;
				}
				
				if (obj.kol > 0) {
					item.hp.text = obj.kol;
				}
			}
			else if (page2 == PAGE_UPGRADE) {
				// Do nothing
			}
			else if (page2 == PAGE_REPAIR) {
				item.hp.text = Math.round(obj.hp / obj.maxhp * 1000) / 10 + "%";
				item.ammotip.text = Math.round(obj.rep * gg.pers.repairMult * 1000) / 10 + "%";
			}
			
			item.ammo.text = "";
		}
		
		
		//информация об элементе
		override protected function statInfo(event:MouseEvent):void {
			var assId:String = null;
			
			if (page2 == PAGE_CRAFT) {
				infoItem(event.currentTarget.cat.text,event.currentTarget.id.text,event.currentTarget.nazv.text, 1);
			}
			
			if (page2 == PAGE_UPGRADE) {
				if (event.currentTarget.cat.text == Item.L_ARMOR) {
					infoItem(event.currentTarget.cat.text, event.currentTarget.id.text, event.currentTarget.nazv.text, 2);
				}
				else {
					infoItem(event.currentTarget.cat.text, event.currentTarget.id.text + "^1", event.currentTarget.nazv.text + " - II", 2);
				}
			}
			
			if (page2 == PAGE_REPAIR) {
				infoItem(event.currentTarget.cat.text, event.currentTarget.id.text, event.currentTarget.nazv.text);
				
				if (event.currentTarget.cat.text == Item.L_ARMOR) {
					showBottext(inv.equipment.getArmor(event.currentTarget.id.text).idComp);
				}
				
				if (event.currentTarget.cat.text == Item.L_WEAPON) {
					showBottext("frag");
				}
				
				if (event.currentTarget.cat.text == Item.L_INSTR) {
					showBottext("scrap");
				}
			}
		}

		private function showBottext(cid:String):void {
			if (inv.hasItem(cid)) {
				vis.bottext.htmlText=Res.txt("i",cid)+ ": "+textAsColor("yellow", String(inv.getQuantity(cid)));
				
				if (World.w.loc.base && World.w.vault.hasItem(cid)) {
					vis.bottext.htmlText += " (+" + textAsColor("yellow", String(World.w.vault.getQuantity(cid))) + " "+LanguageManager.reference.localText("pip", "invault") + ")";
				}
			}
			else {
				vis.bottext.htmlText = "";
			}
		}
		
		// Check if the player meets all the requirements to craft an item
		private function checkScheme(data:Object):Boolean {
			// Skill and level requirements
			if ("skill" in data && "lvl" in data && gg.pers.getSkillLevel(data.skill) < data.lvl) {
				World.w.gui.infoText("needSkill", Res.txt("e", data.skill), data.lvl);	// [skill required]
				
				return false;
			}
			
			// Crafting ingredients
			for (var ingredientID:String in data.ingredients) {
				if ((inv.getQuantity(ingredientID) + World.w.vault.getQuantity(ingredientID)) < data.ingredients[ingredientID]) {
					World.w.gui.infoText("noMaterials");
					return false;
				}
			}
			
			return true;
		}
		
		// [subtract the number of components required for crafting]
		private function minusCraftComp(data:Object):void {
			for (var ingredientID:String in data.ingredients) {
				inv.decreaseQuantity(data.id, data.ingredients[ingredientID]);
			}
		}
		
		override protected function itemClick(event:MouseEvent):void {
			if (pip.noAct) {
				World.w.gui.infoText("noAct");
				return;
			}
			
			var w:Weapon;
			var arm:Armor;
			var cid:String		= event.currentTarget.id.text;
			var ccat:String		= event.currentTarget.cat.text;
			var cnazv:String	= event.currentTarget.nazv.text
			
			if (page2 == PAGE_CRAFT) {
				var string2:String = "s_" + cid;
				var data:Object = ItemManager.reference.getItem(string2);
				var kol:int = 1;
				
				if ("kol" in data) {
					kol = int(data.kol);
				}
				
				if ("perk" in data && data.perk == "potmaster" && gg.pers.potmaster) {
					kol *= 2;
				}
				
				if (!checkScheme(data)) {
					return;
				}
				
				if (ccat == Item.L_WEAPON) {
					w = inv.equipment.getWeapon(cid);
					var obj = assArr[cid];
					
					if (w.tip != "explosives" && w.respect != Weapon.WEP_BLUEPRINT) {
						return;
					}
					
					minusCraftComp(data);
					
					if (w.tip == "explosives") {
                        inv.increaseQuantity(w.id, kol);
                        obj.kol = inv.getQuantity(w.id);
                        World.w.gui.infoText("created2", cnazv, inv.getQuantity(cid));
                        infoItem(ccat, cid, cnazv, 1);
                        setStatItem(event.currentTarget as MovieClip, obj);
                    }
					else {
                        w.respect = Weapon.WEP_INACTIVE;
                        w.magazineRounds = w.magazineCapacity;
                        World.w.gui.infoText("created", cnazv);
                        setStatus();
                    }
					
					//inv.calcWeaponMass();	FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME 
				}
				else if (ccat == Item.L_ARMOR) {
					arm = inv.equipment.getArmor(cid);
					
					if (arm.lvl >= 0) {
						return;
					}
					
					minusCraftComp(data);
					arm.lvl = 0;
					World.w.gui.infoText("created3", cnazv);
					setStatus();
				}
				else if (ccat == Item.L_IMPL) {
					minusCraftComp(data);
					inv.increaseQuantity(cid, 1);
					//inv.takeScript(cid); FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME 
					World.w.gui.infoText("created4", cnazv);
					gg.pers.setParameters();
					setStatus();
				}
				else if (ccat == Item.L_ITEM) {
					var obj = assArr[cid];
					minusCraftComp(data);
					inv.increaseQuantity(cid, kol);
					obj.kol = inv.getQuantity(cid);
					World.w.gui.infoText("created2", cnazv, inv.getQuantity(cid));
					infoItem(ccat,cid,cnazv, 1);
					
					if ("one" in ItemManager.reference.getItem(cid).data && ItemManager.reference.getItem(cid).data.one == "1") {
						setStatus();
					}
					
					setStatItem(event.currentTarget as MovieClip, obj);
				}
				
				World.w.game.checkQuests(cid);
				
				if (World.w.helpMess && inv.hasItem(cid)) {
					var lmess:String = ItemManager.reference.getItem(cid).mess;
					
					if (lmess != null && !(World.w.game.triggers["mess_"+lmess] > 0)) {
						World.w.game.triggers["mess_" + lmess] = 1;
						World.w.gui.impMess(Res.txt("i", lmess), Res.txt("i", lmess,2), lmess);
						pip.onoff(-1);
					}
				}
			}
			else if (page2 == PAGE_UPGRADE) {
				if (ccat == Item.L_ARMOR) {
					arm = inv.equipment.getArmor(cid);
					
					if (arm == null) {
						return;
					}
				
					var kol:int = arm.kolComp;
					if (inv.getQuantity(arm.idComp) >= kol) {
						inv.decreaseQuantity(arm.idComp, kol);
						ArmorManager.upgradeArmor(arm);
						gg.pers.setParameters();
						World.w.gui.infoText("upArmor");
						setStatus();
					}
					else {
						World.w.gui.infoText("noMaterials");
					}
				}
				else if (ccat == Item.L_WEAPON) {
					// Create the name of the schematic, eg. "s_dartgun" and retrieve the data for the schematic
					var data:Object = ItemManager.reference.getItem("s_" + cid);
					
					if (!checkScheme(data)) {
						return;
					}

					minusCraftComp(data);
					//inv.updWeapon(cid, 1); FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME NOT SURE IF STILL NEEDED
					World.w.gui.infoText("created", cnazv + Weapon.variant2);
					setStatus();
				}
			}
			else if (page2 == PAGE_REPAIR) {
				var obj = assArr[cid];
				
				if (ccat == Item.L_ARMOR) {
					arm = inv.equipment.getArmor(cid);
					
					if (arm.hp >= arm.maxhp) {
						World.w.gui.infoText("noRepair");
						return;
					}
					
					var cid2:String = inv.equipment.getArmor(cid).idComp;
					
					if (inv.hasItem(cid2)) {
						var repairAmount:Number = arm.maxhp*gg.pers.repairMult/arm.kolComp;
						ArmorManager.reference.repair(arm, repairAmount);
						inv.decreaseQuantity(cid2);
						obj.hp = arm.hp;
						showBottext(cid2);
					}
					else {
						World.w.gui.infoText("noMaterials");
					}
				}
				else if (ccat == Item.L_WEAPON) {
					if (inv.hasItem("frag")) {
						w = inv.equipment.getWeapon(cid);
						
						if (WeaponManager.reference.repairWeapon(w, 0.25)) {
							inv.decreaseQuantity("frag");
							obj.hp = w.hp;
							showBottext("frag");
						}
					}
					else {
						World.w.gui.infoText("noMaterials");
					}
				}
				else if (ccat == Item.L_INSTR) {
					if (inv.hasItem("scrap")) {
						var owl:UnitPet = gg.pets[cid];
						var owlRep:int = 100;
					
						if (owl.repair(owlRep * gg.pers.repairMult)) {
							inv.decreaseQuantity("scrap");
							obj.hp = owl.hp;
							showBottext("scrap");
						}
					}
					else {
						World.w.gui.infoText("noMaterials");
					}
				}
				
				setStatItem(event.currentTarget as MovieClip, obj);
			}
			
			pip.snd(1);
			//inv.calcMass();	// FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME 
			pip.setRPanel();
		}	
	}	
}
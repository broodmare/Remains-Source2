package fe.game.ui {

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;

	import fl.controls.NumericStepper;	// Adobe Animate dependency

	import fe.engine.text.LanguageManager;
	import fe.engine.text.TextParser;
	import fe.game.ArmorManager;
	import fe.game.ItemInteraction;
	import fe.game.ItemManager;
	import fe.game.WeaponManager;
	import fe.game.World;
	import fe.game.GameContainer;
	import fe.game.domain.units.Armor;
	import fe.game.domain.units.UnitPet;
	import fe.game.domain.units.InventoryItem;
	import fe.game.domain.serv.Item;
	import fe.game.domain.serv.Vendor;
	import fe.game.domain.weapon.Weapon;
	import fe.game.domain.location.Quest;
	import fe.game.domain.units.enums.E_ArmorTypes;
	import fe.engine.utils.TradeValue;
	import fe.engine.utils.SymbolFactory;


	/* 
	*	The page displayed when interacting with vendor NPCs
	*	sub-categories:
	*		1 - Buy
	*		2 - Sell
	*		3 - Repair
	*		4 - Quests
	*		5 - *disabled*
	*/
	public class PipPageVend extends PipPage {

		private static const PAGE_BUY:int = 1, PAGE_SELL:int = 2, PAGE_REPAIR:int = 3, PAGE_QUEST:int = 4;
		
		private var npcId:String		= "";
		private var vendor:Vendor;
		private var assArr:Array;
		private var npcInter:String		= "";	//цена ремонта совы
		private var inbase:Boolean		= false;
		private var selall:Boolean		= true;

		public function PipPageVend(npip:PipBuck, npp:String) {
			isLC = true;
			isRC = true;
			
			itemClass = SymbolFactory.fetchSymbolClass("visPipBuyItem");
			
			super(npip,npp);
			
			// Set which sub-categories are disabled at the top of the pip-buck
			vis.but5.visible = false;
			
			vis.butOk.text.text=LanguageManager.reference.localText("pip", "transaction");	// "Accept"
			vis.butOk.addEventListener(MouseEvent.CLICK,transOk);
			var tf:TextFormat = new TextFormat();
			tf.color = 0x00FF99; 
			tf.size = 16; 
			
			for (var i:int = 0; i < maxrows; i++) {
				var item:MovieClip = statArr[i]; 
				var ns:NumericStepper = item.ns;	// Adobe Animate dependency
				ns.addEventListener(MouseEvent.CLICK,nsClick);
				ns.addEventListener(Event.CHANGE,nsCh);
				ns.tabEnabled = false;
				ns.focusRect = false;
				ns.setStyle("textFormat", tf);
			}
			
			tips = [
				[],
				[
					"",
					[Item.L_WEAPON, Item.L_ARMOR,"spell"],
					["a","e"],
					["med","him","pot","food"],
					["equip","art","book","sphera","spec","key","impl","instr"],
					["stuff","compa","compw","compe","compm","compp"],
					"scheme"
				],
				[
					"",
					"valuables",
					["a","e"],
					["med","him","pot","equip","food"],
					"food",
					["stuff","compa","compw","compe","compm","spec"],
					"compp"
				]
			];
			
			initCats();
		}

		// [Preparing pages]
		override protected function setSubPages():void {
			var localize:Function = LanguageManager.reference.localText;
			gg = GameContainer.reference.gg;
			inv = GameContainer.reference.invent;
			
			// Get the npc ID and vendor inventory
			npcId = pip.npcId;
			vendor = pip.vendor;
			
			if (vendor) {
				vendor.buyTotal = 0;
			}
			
			inbase = World.w.loc.base;	// If we're currently at home base
			npcInter = pip.npcInter;	// 
			
			vis.but3.visible = true;	// Enable the repair page
			vis.but4.visible = true;	// Enable the Vendor quests page
			
			// Set the size
			statHead.price.x		= 504;
			statHead.price.width	= 150;
			
			// If there's no valid NPC and we're on the Vendor quests page, move to the buying screen instead 
			if (npcId == "") {
				if (page2 == PAGE_QUEST) {
					page2 = PAGE_BUY;
				}
				
				vis.but4.visible = false;	// Disable the Vendor quests page
			}
			
			if (npcInter == "vr") {
				vis.but3.text.text = localize("pip", "vend3");	// Button text = "Repair"
			}
			
			if (npcInter == "doc") {
				vis.but3.text.text = localize("pip", "med1");	// Button text = "Healing"
			}
			
			if (npcInter == "v") {
				vis.but3.visible = false;
				if (page2 == PAGE_REPAIR) {
					page2 = PAGE_BUY;
				}
			}
			
			statHead.rid.visible = false;
			var ns:NumericStepper = statHead.ns;	// Adobe Animate dependency
			ns.visible = false;
			
			setCats();
			
			// If the Vendor is missing, hide the page and abort
			if (vendor == null) {
				vis.visible = false;
				return;
			}
			
			// Buy items page
			if (page2 == PAGE_BUY) {
				trace("PipPageVend.as/setSubPages() - Initializing Buy menu");
				assArr = [];
				setTopText("infotrade");														// "[click] - select 1 unit of product@[right click] - cancel selection@hold [shift] - select all"
				statHead.nazv.text = localize("pip", "iv1");									// "Goods"
				statHead.hp.text = localize("pip", "iv2") + " / " + localize("pip", "iv6");		// "Condition / You have"
				statHead.price.text = localize("pip", "iv3");									// "Price"
				statHead.kol.text = localize("pip", "iv4");										// "Available"
				statHead.cat.visible = false;
				
				for each (var b:Item in vendor.stock) {
					if (b.kol <= 0) {
						continue;
					}
					
					try {
						// [Schematics for weapons the player already has or schematics they already own]
						if (b.tip == Item.L_SCHEME && (inv.equipment.hasWeapon(b.id.substr(2)) || inv.hasItem(b.id))) {
							continue;
						}
						
						// Weapons and armor the player already has
						if (b.tip == Item.L_WEAPON && inv.equipment.hasWeapon(b.id)) {
							continue;
						}
						
						if (b.tip == Item.L_ARMOR && inv.equipment.hasArmor(b.id)) {
							continue;
						}
						
						// Items without a price can't be sold
						if (b.tip != Item.L_WEAPON && !("price" in b.data))  {
							continue;
						}
						
						// If it's an "Art" item or an implant we already have, don't list it
						if ((b.tip == Item.L_ART || b.tip == Item.L_IMPL) && inv.hasItem(b.id)) {
							continue;
						}
						
						// Character level or barter level too low
						if (b.lvl > gg.pers.level || b.barter > gg.pers.barterLvl) {
							continue;
						}
						
						// Haven't hit the required trigger
						if (b.trig && GameContainer.reference.game.triggers[b.trig] != 1) {
							continue;
						}
						
						// [Only sold in limited inventory mode]
						if (b.hardinv && !GameContainer.reference.hardInv) {
							continue;
						}
						
						if (!checkCat(b.tip)) {
							continue;
						}
						
						b.getPrice();
						var mp:Number = b.getMultPrice();
						
						if (vendor.multPrice > mp) {
							mp = vendor.multPrice;
						}

						var n:Object = {
							tip:		b.tip,
							id:			b.id,
							rid:		b.id,
							nazv:		b.nazv,
							sost:		b.sost * b.multHP,
							price:		b.price,
							mp:			mp,
							kol:		b.kol,
							bou:		0,
							sort:		LanguageManager.reference.hasText("pip", b.tip) ? localize("pip", b.tip) : b.tip,
							barter: 	b.barter,
							variant:	b.variant
						};
						
						if (b.nocheap) {
							n.mp = 1;
						}
						
						// [How many the player already has]
						if (b.tip != Item.L_WEAPON && b.tip != Item.L_ARMOR) {
							n.sost = inv.getQuantity(b.id);
						}
						
						assArr[n.rid] = n;
						n.wtip = b.wtip;
						
						if (b.data.tip == Item.L_FOOD && b.data.ftip == 1) {
							n.wtip = "drink";
						}
						
						arr.push(n);
					}
					catch (err:Error) {
						trace("ERROR: (00:41) " + err.message);
					}
				}
				
				if (arr.length) {
					arr.sortOn(["sort", "barter", "price"], [0, 0, Array.NUMERIC]);
					vis.emptytext.text = "";
					statHead.visible = true;
				}
				else {
					vis.emptytext.text = localize("pip", "emptybuy");	// "This merchant has nothing to sell"
					statHead.visible = false;
				}

				vis.butOk.text.text = localize("pip", "transaction");	// "Accept"
				vis.butOk.visible = false;
			}
			// Sell items page
			if (page2 == PAGE_SELL) {
				trace("PipPageVend.as/setSubPages() - Initializing Sell menu");
				assArr = [];
				setTopText("infotrade");
				vendor.sellTotal = 0;
				statHead.nazv.text = localize("pip", "iv1");			// "Goods"
				statHead.hp.text = "";
				statHead.price.text = localize("pip", "iv3");			// "Price"
				statHead.kol.text = localize("pip", "iv6");				// "You have"
				statHead.cat.visible = false;
				
				for each (var item:InventoryItem in inv.getAllItems()) {
					if (item.quantity <= 0 || !ItemManager.reference.hasItem(item.id)) {
						continue;
					}
					
					var data:Object = ItemManager.reference.getItem(item.id);
					
					if (data.sell > 0) {
						if (!checkCat(data.tip)) {
							continue;
						}

						var n:Object = {
							tip:	data.tip,
							id:		item.id,
							rid:	item.id,
							nazv:	Item.nameOf(item.id, data.tip),
							kol:	item.quantity,
							bou:	0,
							sort:	"b"
						};
						
						n.price = data.sell;
						n.wtip = data.tip;
						
						if (data.tip == Item.L_FOOD && data.ftip == 1) {
							n.wtip = "drink";
						}
						
						if (n.wtip == "valuables") {
							n.sort = "a";
						}
						
						assArr[n.id] = n;
						arr.push(n);
					}
				}
				
				if (arr.length) {
					arr.sortOn(["sort", "wtip", "price"], [0, 0, Array.NUMERIC]);
					vis.emptytext.text = "";
					statHead.visible = true;
				}
				else {
					vis.emptytext.text = localize("pip", "emptysell");
					statHead.visible = false;
				}
				
				if (inbase) {
					selall = true;
					vis.butOk.text.text = localize("pip", "sellall");
					vis.butOk.visible = true;
				}
				else {
					vis.butOk.visible = false;
				}
				
				setIco();
			}
			// Repair items page
			if (page2 == PAGE_REPAIR) {
				trace("PipPageVend.as/setSubPages() - Initializing Repair menu");
				assArr = [];
				setTopText("inforepair");
				statHead.nazv.text = "";
				statHead.hp.text = localize("pip", "iv2");
				statHead.price.text = localize("pip", "iv5");
				statHead.kol.text = "";
				statHead.price.x = 450;
				statHead.cat.visible = false;
				
				if (inv.hasItem("owl")) {
					GameContainer.reference.pers.setRoboowl();
					var repOwl:int = 2;
					
					n = {
						tip:		Item.L_INSTR,
						id:			"owl",
						nazv:		Item.nameOf("owl"),
						hp:			GameContainer.reference.pers.owlhp * GameContainer.reference.pers.owlhpProc,
						maxhp:		GameContainer.reference.pers.owlhp,
						price:		GameContainer.reference.pers.owlhp * repOwl};
					
					arr.push(n);
					assArr[n.id] = n;

				}
				
				for each (var w:Weapon in inv.equipment.weapons) {
					if (w.tip != Weapon.TYPE_INTERNAL && w.tip != Weapon.TYPE_EXPLOSIVES && w.respect != Weapon.WEP_LOCKED && w.hp < w.maxhp) {
						n = {
							tip:		Item.L_WEAPON,
							id:			w.id,
							nazv:		w.nazv,
							hp:			w.hp,
							maxhp:		w.maxhp,
							price:		w.price,
							variant:	w.variant
						};

						n.wtip = "w" + w.skill;
						arr.push(n);
						assArr[n.id] = n;
					}
				}
				
				for each (var a:Armor in inv.equipment.armors) {
					if (a.hp < a.maxhp && a.tip != E_ArmorTypes.AMULET) {
						n = {
							tip:		Item.L_ARMOR,
							id:			a.id,
							nazv:		a.nazv,
							hp:			a.hp,
							maxhp:		a.maxhp,
							price:		a.price
						};

						arr.push(n);
						assArr[n.id] = n;
						n.wtip = "armor1";
					}
				}
				
				if (arr.length) {
					arr.sortOn(["price"], [Array.NUMERIC]);
					vis.emptytext.text = "";
					statHead.visible = true;
				}
				else {
					vis.emptytext.text = localize("pip", "emptyrep");
					statHead.visible = false;
				}
				
				vis.butOk.visible = false;
			}
			// Vendor quests
			if (page2 == PAGE_QUEST) {
				trace("PipPageVend.as/setSubPages() - Initializing Tasks menu");
				statHead.visible = false;
				
				if (npcId == "" || vendor == null) {
					return;
				}

				if (isEmpty(vendor.vendorData) || vendor.vendorData.tasks == undefined) {
					vis.emptytext.text = localize("pip", "emptytasks");
					return;
				}
				
				for each(var task in vendor.vendorData.tasks) {
					if (!checkQuest(task)) {
						continue;
					}

					n = {id:task.id, state:0, sort:0};
					
					if (task.skill) {
						n.skill  = task.skill;
						n.skilln = task.skilln;
					}
					
					n.nazv = TextParser.messText(task.id);
					
					if (GameContainer.reference.game.quests[task.id]) {
						var quest:Quest = GameContainer.reference.game.quests[task.id];
						n.state = GameContainer.reference.game.quests[task.id].state;
						
						if (n.state == 1 && quest.chReport(npcId, false)) {
							n.state = 3;
						}
						
						if (n.state == 1 && quest.chGive(npcId, false)) {
							n.state = 4;
						}
					}
					
					if (n.state == 3 || n.state == 4) {
						n.sort = 1;
					}
					
					if (n.state == 1) {
						n.sort = 2;
					}
					
					if (n.state == 2) {
						n.sort = 3;
					}
					
					arr.push(n);
				}
				
				if (arr.length == 0) {
					vis.emptytext.text = localize("pip", "emptytasks");
				}
				else {
					vis.emptytext.text = "";
					arr.sortOn("sort");
				}
			}
			
			setIco();
			showBottext();
		}
		
		override protected function setSigns():void {
			if (vendor == null) {
				return;
			}

			super.setSigns();
			
			if (vis.but4.visible && !isEmpty(vendor.vendorData)) {
				for each(var task in vendor.vendorData.tasks) {
					if (!checkQuest(task)) {
						continue;
					}
					if (GameContainer.reference.game.quests[task.id]) {
						var quest:Quest = GameContainer.reference.game.quests[task.id];
						var nstate = GameContainer.reference.game.quests[task.id].state;
						
						if (nstate == 0 || nstate == 1 && quest.chReport(npcId, false) || nstate == 1 && quest.chGive(npcId, false)) {
							signs[4] = 1;
							break;
						}
					}
					else {
						signs[4] = 1;
						break;
					}
				}
			}
		}
		
		// Clicking on one of the sub-categories at the top of the page
		override protected function page2Click(event:MouseEvent):void {
			if (GameContainer.reference.ctr.setkeyOn) {
				return;
			}

			var clickedPage:int = int(event.currentTarget.id.text);

			// Don't try to change the sub-cateogry if we're already there
			if (clickedPage == page2) {
				trace("PipPageVend.as/page2Click() - Selected the same sub-category, aborting");
				pip.snd(2);    // Play the button press sound anyway
				return;
			}

			// Update the current subcategory
			page2 = clickedPage;
			trace("PipPageVend.as/page2Click() - Changing page2 to: " + page2);
			
			if (page2 == PAGE_REPAIR && npcInter == "doc") {
				page2 = PAGE_BUY;
				pip.onoff(6);
			}
			else {
				setStatus();
			}
		}
	
		private function showBottext():void {
			if (page2 == PAGE_BUY && vendor) {
				vis.bottext.htmlText=LanguageManager.reference.localText("pip", "caps")+": "+numberAsColor("yellow", inv.getQuantity("money"))+" (";
				
				if (vendor.buyTotal > 0) {
					vis.bottext.htmlText+="-"+numberAsColor("yellow", TradeValue.charge(vendor.buyTotal))+"; ";
				}
				
				vis.bottext.htmlText+=numberAsColor("yellow", inv.getQuantity("money") - TradeValue.charge(vendor.buyTotal))+" "+LanguageManager.reference.localText("pip", "ost")+")";
			}
			
			if (page2 == PAGE_SELL && vendor) {
				vis.bottext.htmlText=LanguageManager.reference.localText("pip", "caps")+": "+numberAsColor("yellow", inv.getQuantity("money"))+" (+"+numberAsColor("yellow", TradeValue.payout(vendor.sellTotal))+")";
				if (!inbase) {
					vis.bottext.htmlText+="   "+LanguageManager.reference.localText("pip", "vcaps")+": "+numberAsColor("yellow", vendor.money);
				}
			}
			
			if (page2 == PAGE_REPAIR) {
				vis.bottext.htmlText=LanguageManager.reference.localText("pip", "caps")+": "+numberAsColor("yellow", inv.getQuantity("money"));
			}
		}
		
		// [Show one element (in the list?)]
		override protected function setStatItem(item:MovieClip, obj:Object):void {
			item.id.text = obj.id;
			item.id.visible = false;
			item.cat.visible = false;
			item.rid.visible = false;
			item.lvl.visible = false;
			item.ns.visible = false;
			item.nazv.alpha = 1;
			item.price.x = 504;
			item.price.width = 58;
			
			if (obj.wtip) {
				item.trol.gotoAndStop(obj.wtip);
			}
			else {
				item.trol.gotoAndStop(1);
			}
			
			if (page2 == PAGE_BUY) {
				item.lvl.visible = true;
				item.lvl.gotoAndStop(obj.barter + 1);
				item.rid.text = obj.id;
				item.cat.text = obj.tip;
				item.nazv.text = obj.nazv;
				
				if (obj.tip == Item.L_WEAPON || obj.tip == Item.L_ARMOR) {
					item.hp.text = Math.round(obj.sost * 100) + "%";
					
					if (obj.bou == 0) {
						item.kol.text = LanguageManager.reference.localText("pip", "est");
					}
					else {
						item.kol.text = LanguageManager.reference.localText("pip", "sel");
					}
					
					item.price.text = TradeValue.charge(obj.price * obj.mp);
				}
				else {
					var ns:NumericStepper = item.ns;	// Adobe Animate dependency
					ns.visible = true;
					ns.maximum = obj.kol;
					ns.value = obj.bou;
					item.kol.text = obj.kol-obj.bou;
					item.hp.text = (obj.sost == 0)? "-" : obj.sost;
					item.price.text = Math.round(TradeValue.normalize(obj.price * obj.mp) * 10) / 10;
				}
			} 
			
			if (page2 == PAGE_SELL) {
				item.cat.text=obj.tip;
				item.rid.text=obj.id;
				item.nazv.text=obj.nazv;
				item.hp.text="";
				item.price.text = Math.round(TradeValue.normalize(obj.price) * 10) / 10;
				item.kol.text=obj.kol;
				var ns:NumericStepper = item.ns;	// Adobe Animate dependency
				ns.visible=true;
				ns.maximum=obj.kol;
				ns.value=obj.bou;
				item.kol.text=obj.kol-obj.bou;
			} 
			
			if (page2 == PAGE_REPAIR) {
				item.cat.text = obj.tip;
				item.nazv.text = obj.nazv;
				item.hp.text = Math.round(obj.hp / obj.maxhp * 100) + "%";
				
				item.price.text = repairPrice(obj);
				item.kol.text = "";
				
				item.rid.text = obj.id;
			} 
		
			if (page2 == 4) {
				item.cat.text = obj.state;
				item.nazv.text = obj.nazv;
				item.hp.text = "";
				item.price.text = "";
				item.price.x = 400;
				item.price.width = 158;
				
				if (obj.state == 1) {
					item.price.text=LanguageManager.reference.localText("pip", "perform");
				}
				
				if (obj.state == 2) {
					item.price.text=LanguageManager.reference.localText("pip", "done");
					item.nazv.alpha=0.5;
				}
				
				if (obj.state == 3) {
					item.price.text=LanguageManager.reference.localText("pip", "surr");
				}
				
				if (obj.state == 4) {
					item.price.text=LanguageManager.reference.localText("pip", "progress");
				}
				
				item.kol.text = "";
			}
		}
		
		// [Item information]
		override protected function statInfo(event:MouseEvent):void {
			if (page2 == PAGE_BUY || page2 == PAGE_SELL || page2 == PAGE_REPAIR) {
				infoItem(event.currentTarget.cat.text, event.currentTarget.rid.text, event.currentTarget.nazv.text);
			}
			
			if (page2 == PAGE_QUEST) {
				vis.nazv.text = event.currentTarget.nazv.text;
				
				var s:String = infoQuest(event.currentTarget.id.text);
				
				if (s == "") vis.info.htmlText=TextParser.messText(event.currentTarget.id.text, 1);
				else vis.info.htmlText = s;
				
				if (event.currentTarget.cat.text == "0") {
					vis.info.htmlText += "\n\n<span class = 'orange'>" + LanguageManager.reference.localText("pip", "actTake") + "</span>";
				}
				
				if (event.currentTarget.cat.text == "3") {
					vis.info.htmlText += "\n\n<span class = 'orange'>" + LanguageManager.reference.localText("pip", "actSurr") + "</span>";
				}
				
				if (event.currentTarget.cat.text == "4") {
					vis.info.htmlText += "\n\n<span class = 'orange'>" + LanguageManager.reference.localText("pip", "actGive") + "</span>";
				}
				
				setIco();
			}
			
			event.stopPropagation();
		}
		
		private function selBuy(buy:Object, n:int=1):void {
			if (selall) {
				vis.butOk.text.text = LanguageManager.reference.localText("pip", "transaction");	// "Accept"
			}
			
			selall = false;
			
			if (buy == null || buy.kol - buy.bou <= 0) {
				return;
			}
			
			if (buy.tip == Item.L_WEAPON && inv.equipment.hasWeapon(buy.id)) {
				return;
			}
			
			if (buy.tip == Item.L_ARMOR && inv.equipment.hasArmor(buy.id)) {
				return;
			}
			
			// [Warn the player if they can't carry it in limited inventory mode]
			if ((buy.tip == Item.L_WEAPON || buy.tip == Item.L_SPELL) && vendor.getItem(buy.id)) {
				vendor.getItem(buy.id).checkAuto(true);
			}
			
			vis.butOk.visible = true;
			
			if (buy.kol - buy.bou < n) {
				n = buy.kol - buy.bou;
			}
			
			if (page2 == PAGE_BUY) {
				refreshTradeTotal();
				var unitPrice:Number = buy.price * buy.mp;
				var proposedTotal:Number = vendor.buyTotal + unitPrice * n;
				if (unitPrice > 0 && TradeValue.charge(proposedTotal) > inv.getQuantity("money")) {
					n = Math.floor((inv.getQuantity("money") - vendor.buyTotal) / unitPrice);
					while (n > 0 && TradeValue.charge(vendor.buyTotal + unitPrice * n) > inv.getQuantity("money")) {
						n--;
					}

					if (n <= 0) {
						GUIManager.reference.gui.infoText("noMoney", Math.max(1, TradeValue.charge(vendor.buyTotal + unitPrice) - inv.getQuantity("money")));
						return;
					}
				}
			}
			
			buy.bou += n;
			refreshTradeTotal();
		}
		
		private function unselBuy(buy:Object, n:int=1):void {
			if (buy == null || buy.bou <= 0) {
				return;
			}
			
			if (buy.bou < n) {
				n = buy.bou;
			}
			
			buy.bou -= n;
			refreshTradeTotal();
		}

		// Rebuild the pending total from the selected rows so adding and removing an item is reversible.
		private function refreshTradeTotal():void {
			var total:Number = 0;
			
			for (var selectionKey:String in assArr) {
				var selection:Object = assArr[selectionKey];
				if (selection == null || selection.bou <= 0) {
					continue;
				}

				if (page2 == PAGE_BUY) {
					total += selection.price * selection.mp * selection.bou;
				}
				else if (page2 == PAGE_SELL) {
					total += selection.price * selection.bou;
				}
			}
			
			total = TradeValue.normalize(total);
			if (page2 == PAGE_BUY) {
				vendor.buyTotal = total;
			}
			else if (page2 == PAGE_SELL) {
				vendor.sellTotal = total;
			}
		}

		private function repairPrice(obj:Object):int {
			var mp:Number = (obj.tip == Item.L_ARMOR) ? gg.pers.priceRepArmor : 1;
			return TradeValue.charge(obj.price * (obj.maxhp - obj.hp) / obj.maxhp * vendor.multPrice * mp);
		}
		
		private function nsClick(event:MouseEvent):void {
			event.stopPropagation();
		}

		private function nsCh(event:Event):void {
			if (page2 == PAGE_BUY || page2 == PAGE_SELL) {
				var buy:Object = assArr[event.currentTarget.parent.rid.text];
				var n = event.currentTarget.value - buy.bou;
				
				if (n > 0) {
					selBuy(buy, n);
				}
				else if (n < 0) {
					unselBuy(buy, -n);
				}
				
				if (n != 0) {
					setStatItem(event.currentTarget.parent as MovieClip, buy);
					showBottext();
				}
			}
		}
		
		override protected function itemClick(event:MouseEvent):void {
			if (page2 == PAGE_BUY || page2 == PAGE_SELL) {
				var buy:Object = assArr[event.currentTarget.rid.text];
				var n:int = 1;
				
				if (event.shiftKey) {
					n = buy.kol - buy.bou;
				}
				
				if (event.shiftKey && event.ctrlKey) {
					n = buy.bou;
				}
				
				if (event.ctrlKey) {
					unselBuy(buy, n);
				}
				else {
					selBuy(buy, n);
				}
				
				setStatItem(event.currentTarget as MovieClip, buy);
			}
			
			if (page2 == PAGE_REPAIR) {
				if (inv.getQuantity("money") <= 0) {
					return;
				}

				var obj:Object = assArr[event.currentTarget.id.text];
				var price:int = repairPrice(obj);
				
				if (price <= 0) {
					return;
				}
				
				if (price > inv.getQuantity("money")) {
					price = inv.getQuantity("money");
				}
				
				if (event.currentTarget.cat.text==Item.L_INSTR) {
					var owl:UnitPet=gg.pets[event.currentTarget.id.text];
					var repOwl:int = 2;
					var hl:Number=price/repOwl/vendor.multPrice;
					hl = Math.min(hl, owl.maxhp - owl.hp);
					
					owl.repair(hl);
					obj = assArr[event.currentTarget.id.text];
					obj.hp = owl.hp;
				}
				
				if (event.currentTarget.cat.text==Item.L_WEAPON) {
					var w:Weapon = inv.equipment.getWeapon(event.currentTarget.id.text);
					var hp1:int = Math.ceil(price/w.price*w.maxhp/vendor.multPrice);
					WeaponManager.reference.repairWeapon(w, hp1);
					
					obj = assArr[event.currentTarget.id.text];
					obj.hp = w.hp;
				}
				
				if (event.currentTarget.cat.text==Item.L_ARMOR) {
					var a:Armor = inv.equipment.getArmor(event.currentTarget.id.text);
					var hp2:int = Math.ceil(price / a.price * a.maxhp / vendor.multPrice / gg.pers.priceRepArmor);
					ArmorManager.reference.repair(a, hp2);
					
					obj = assArr[event.currentTarget.id.text];
					obj.hp = a.hp;
				}
				
				inv.decreaseQuantity("money", price);
				pip.vendor.increaseMoney(price);
				setStatItem(event.currentTarget as MovieClip, obj);
				GUIManager.reference.gui.setWeapon();
				pip.setRPanel();
			}
			
			if (page2 == PAGE_QUEST) {
				try {
					if (GameContainer.reference.game.quests[event.currentTarget.id.text]) {
						var quest:Quest=GameContainer.reference.game.quests[event.currentTarget.id.text];
						quest.chGive(npcId, true);
						quest.chReport(npcId, true);
					}
					else {
						GameContainer.reference.game.addQuest(event.currentTarget.id.text);
					}
				}
				catch(err) {
					trace("ERROR: (00:43)");
				}
				
				setStatus(false);
			}
			
			pip.snd(1);
			showBottext();
			event.stopPropagation();
		}

		override protected function itemRightClick(event:MouseEvent):void {
			if (page2 == PAGE_BUY || page2 == PAGE_SELL) {
				var buy:Object=assArr[event.currentTarget.rid.text];
				var n:int = 1;
				if (event.shiftKey) n=10;
				unselBuy(buy, n);
				setStatItem(event.currentTarget as MovieClip, buy);
			}
			
			pip.snd(1);
			showBottext();
			event.stopPropagation();
		}
		
		private function transOk(event:MouseEvent):void {
			if (page2 == PAGE_BUY) {
				trade(assArr);
			}
			
			if (page2 == PAGE_SELL) {
				if (selall) {
					sellAll();
				}
				else {
					sell(assArr);
				}
			}
			
			pip.setRPanel();
			pip.snd(3);
		}
		
		public function trade(arr:Array):void {
			// We don't have enough money to buy the items selected
			if (TradeValue.charge(vendor.buyTotal) > inv.getQuantity("money")) {
				return;
			}
			
			for each (var item:Item in vendor.stock) {
				if (arr[item.id] && arr[item.id].bou > 0) {
					item.bou = arr[item.id].bou;
					gg.itemInteraction.take(item, 1);
				}
			}
			
			var price:int = TradeValue.charge(vendor.buyTotal);
			if (price > 0) {
				inv.decreaseQuantity("money", price);
				vendor.increaseMoney(price);
			}
			
			vendor.buyTotal = 0;
			ItemInteraction.calcMass(inv);
			ItemInteraction.calcWeaponMass(inv);

			// Refresh the PipBuck(?)
			setStatus();
		}
		
		public function sell(arr:Array):void {
			// We're not at the base and the vendor doesn't have enough money to buy our goods
			if (!inbase && TradeValue.payout(vendor.sellTotal) > vendor.money) {
				GUIManager.reference.gui.infoText("noSell");
				return;
			}
			
			for each (var item:InventoryItem in inv.getAllItems()) {
				var obj:Object = arr[item.id];
				
				if (obj && obj.bou > 0) {
					var n:int = Math.min(obj.bou, item.quantity);
					
					if (n > 0) {
						vendor.addStock(item.id, n);
						inv.decreaseQuantity(item.id, n);
					}
				}
			}
			
			var price:int = TradeValue.payout(vendor.sellTotal);
			if (price > 0) {
				inv.increaseQuantity("money", price);
			}
			
			vendor.decreaseMoney(price);
			vendor.sellTotal = 0;
			ItemInteraction.calcMass(inv);

			// Refresh the PipBuck(?)
			setStatus();
		}
		
		public function sellAll():void {
			for (var s in arr) {
				if (arr[s].tip == "valuables") {
					selBuy(arr[s], arr[s].kol - arr[s].bou);
				}
			}
			
			vis.butOk.text.text = LanguageManager.reference.localText("pip", "transaction");	// "Accept"
			selall = false;
			showBottext();
			setStatItems();
		}

		// Check if an object is empty, Eg. '{}'
		private function isEmpty(obj:Object):Boolean {
			for (var key:String in obj) {
				return false; // Found a property, so it's not empty
			}
			
			return true; // No properties found, it's empty
		}
	}	
}

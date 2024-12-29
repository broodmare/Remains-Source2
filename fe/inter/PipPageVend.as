package fe.inter {

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;

	import fl.controls.NumericStepper;	// Adobe Animate dependency

	import fe.*;
	import fe.unit.Armor;
	import fe.unit.UnitPet;
	import fe.serv.Item;
	import fe.serv.Vendor;
	import fe.weapon.Weapon;
	import fe.loc.Quest;

	import fe.stubs.visPipBuyItem;

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
		
		private var npcId:String = '';
		private var vendor:Vendor;
		private var assArr:Array;
		private var npcInter:String = '';	//цена ремонта совы
		private var inbase:Boolean = false;
		private var selall:Boolean = true;

		// Constructor
		public function PipPageVend(npip:PipBuck, npp:String) {
			isLC = true;
			isRC = true;
			
			itemClass = visPipBuyItem;
			
			super(npip,npp);
			
			// Set which sub-categories are disabled at the top of the pip-buck
			vis.but5.visible = false;
			
			vis.butOk.text.text=Res.pipText('transaction');
			vis.butOk.addEventListener(MouseEvent.CLICK,transOk);
			var tf:TextFormat=new TextFormat();
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
					'',
					[Item.L_WEAPON, Item.L_ARMOR,'spell'],
					['a','e'],
					['med','him','pot','food'],
					['equip','art','book','sphera','spec','key','impl','instr'],
					['stuff','compa','compw','compe','compm','compp'],
					'scheme'
				],
				[
					'',
					'valuables',
					['a','e'],
					['med','him','pot','equip','food'],
					'food',
					['stuff','compa','compw','compe','compm','spec'],
					'compp'
				]
			];
			
			initCats();
		}

		// [Preparing pages]
		override protected function setSubPages():void {
			// Get the npc ID and vendor inventory
			npcId = pip.npcId;
			vendor = pip.vendor;
			
			if (vendor) {
				vendor.kolBou = 0;
			}
			
			inbase = World.w.loc.base;	// If we're currently at home base
			npcInter = pip.npcInter;	// 
			
			vis.but3.visible = true;	// Enable the repair page
			vis.but4.visible = true;	// Enable the Vendor quests page
			
			// Set the size
			statHead.price.x = 504;
			statHead.price.width = 150;
			
			// If there's no valid NPC and we're on the Vendor quests page, move to the buying screen instead 
			if (npcId == '') {
				if (page2 == 4) {
					page2 = 1;
				}
				
				vis.but4.visible = false;	// Disable the Vendor quests page
			}
			
			if (npcInter == 'vr') {
				vis.but3.text.text = Res.pipText('vend3');	// Button text = "Repair"
			}
			
			if (npcInter == 'doc') {
				vis.but3.text.text = Res.pipText('med1');	// Button text = "Healing"
			}
			
			if (npcInter == 'v') {
				vis.but3.visible = false;
				if (page2 == 3) {
					page2 = 1;
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
			if (page2 == 1) {
				trace("PipPageVend.as/setSubPages() - Initializing Buy menu");
				assArr = [];
				pip.money = inv.money.kol;
				setTopText('infotrade');
				statHead.nazv.text = Res.pipText('iv1');
				statHead.hp.text = Res.pipText('iv2') + ' / ' + Res.pipText('iv6');
				statHead.price.text = Res.pipText('iv3');
				statHead.kol.text = Res.pipText('iv4');
				statHead.cat.visible = false;
				
				for each(var b:Item in vendor.buys) {
					if (b.kol <= 0) continue;
					try {
						if (b.tip==Item.L_SCHEME && (inv.weapons[b.id.substr(2)] != null || inv.items[b.id].kol > 0)) {
							continue;
						}
						
						if (b.tip==Item.L_WEAPON && (inv.weapons[b.id]!=null && inv.weapons[b.id].variant>=b.variant)) {
							continue;
						}
						
						if (b.tip==Item.L_ARMOR && inv.armors[b.id]!=null) {
							continue;
						}
						
						if (b.tip!=Item.L_WEAPON && b.xml && b.xml.@price.length()==0)  {
							continue;
						}
						
						if ((b.tip==Item.L_ART || b.tip==Item.L_IMPL) && inv.items[b.id].kol>0) {
							continue;
						}
						
						if (b.lvl>gg.pers.level || b.barter>gg.pers.barterLvl) {
							continue;
						}
						
						if (b.trig && World.w.game.triggers[b.trig]!=1) {
							continue;
						}
						
						if (b.hardinv && !World.w.hardInv) {
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
							tip: b.tip,
							id: b.id,
							nazv: b.nazv,
							sost: b.sost * b.multHP,
							price: b.price,
							mp: mp,
							kol: b.kol,
							bou: 0,
							sort: Res.pipText(b.tip),
							barter: b.barter,
							variant: b.variant
						};
						
						if (b.variant > 0) {
							n.rid = b.id + '^' + b.variant;
						}
						else {
							n.rid = b.id;
						}
						
						if (b.nocheap) {
							n.mp = 1;
						}
						
						if (gg.invent.items[b.id]) {
							n.sost = gg.invent.items[b.id].kol;
						}
						
						assArr[n.rid] = n;
						n.wtip = b.wtip;
						
						if (b.xml && b.xml.@tip == 'food' && b.xml.@ftip == '1') {
							n.wtip = 'drink';
						}
						
						arr.push(n);
					}
					catch (err) {
						trace('ERROR: (00:41)');
					}
				}
				
				if (arr.length) {
					arr.sortOn(['sort', 'barter', 'price'], [0, 0, Array.NUMERIC]);
					vis.emptytext.text = '';
					statHead.visible = true;
				}
				else {
					vis.emptytext.text = Res.pipText('emptybuy');
					statHead.visible = false;
				}

				vis.butOk.text.text = Res.pipText('transaction');
				vis.butOk.visible = false;
			}
			// Sell items page
			if (page2 == 2) {
				trace("PipPageVend.as/setSubPages() - Initializing Sell menu");
				assArr=[];
				pip.money=inv.money.kol;
				setTopText('infotrade');
				vendor.kolSell=0;
				statHead.nazv.text=Res.pipText('iv1');
				statHead.hp.text='';
				statHead.price.text=Res.pipText('iv3');
				statHead.kol.text=Res.pipText('iv6');
				statHead.cat.visible=false;
				for (var s in inv.items) {
					
					if (s == "" || inv.items[s].kol<=0) {
						continue;
					}
					
					var node = inv.items[s].xml;
					
					if (node == null) {
						continue;
					}
					if (node.@sell > 0) {
						if (!checkCat(node.@tip)) {
							continue;
						}
						var n={tip:inv.items[s].tip, id:s, nazv:inv.items[s].nazv, kol:inv.items[s].kol, bou:0, sort:'b'};
						
						if (inv.weapons[s]!=null) {
							n.nazv=Res.txt('w',s);
						}
						
						n.price=node.@sell;
						n.wtip=node.@tip;
						
						if (node.@tip=='food' && node.@ftip=='1') {
							n.wtip='drink';
						}
						
						if (n.wtip=='valuables') {
							n.sort='a';
						}
						
						assArr[n.id]=n;
						arr.push(n);
					}
				}
				
				if (arr.length) {
					arr.sortOn(['sort','wtip','price'],[0,0,Array.NUMERIC]);
					vis.emptytext.text='';
					statHead.visible=true;
				}
				else {
					vis.emptytext.text=Res.pipText('emptysell');
					statHead.visible=false;
				}
				
				if (inbase) {
					selall=true;
					vis.butOk.text.text=Res.pipText('sellall');
					vis.butOk.visible=true;
				}
				else {
					vis.butOk.visible=false;
				}
				
				setIco();
			}
			// Repair items page
			if (page2 == 3) {
				trace("PipPageVend.as/setSubPages() - Initializing Repair menu");
				assArr = [];
				setTopText('inforepair');
				statHead.nazv.text = "";
				statHead.hp.text = Res.pipText('iv2');
				statHead.price.text = Res.pipText('iv5');
				statHead.kol.text = '';
				statHead.price.x = 450;
				statHead.cat.visible = false;
				
				if (inv.items['owl'] && inv.items['owl'].kol) {
					World.w.pers.setRoboowl();
					var repOwl:int = 2;
					n = {tip:Item.L_INSTR, id:'owl', nazv:inv.items['owl'].nazv, hp:World.w.pers.owlhp*World.w.pers.owlhpProc, maxhp:World.w.pers.owlhp, price:World.w.pers.owlhp*repOwl};
					arr.push(n);
					assArr[n.id] = n;

				}
				
				for each (var w:Weapon in inv.weapons) {
					if (w == null) {
						continue;
					}
					
					if (w.tip != 0 && w.tip != 4 && w.respect != 1 && w.hp < w.maxhp) {
						n = {tip:Item.L_WEAPON, id:w.id, nazv:w.nazv, hp:w.hp, maxhp:w.maxhp, price:w.price, variant:w.variant};
						n.wtip = 'w' + w.skill;
						arr.push(n);
						assArr[n.id] = n;
					}
				}
				
				for each (var a:Armor in inv.armors) {
					if (a.hp < a.maxhp && a.tip < 3) {
						n = {tip:Item.L_ARMOR, id:a.id, nazv:a.nazv, hp:a.hp, maxhp:a.maxhp, price:a.price};
						arr.push(n);
						assArr[n.id] = n;
						n.wtip = 'armor1';
					}
				}
				
				if (arr.length) {
					arr.sortOn(['price'], [Array.NUMERIC]);
					vis.emptytext.text = "";
					statHead.visible = true;
				}
				else {
					vis.emptytext.text = Res.pipText('emptyrep');
					statHead.visible = false;
				}
				
				vis.butOk.visible = false;
			}
			// Vendor quests
			if (page2 == 4) {
				trace("PipPageVend.as/setSubPages() - Initializing Tasks menu");
				statHead.visible = false;
				
				if (npcId == "" || vendor == null) {
					return;
				}

				if (isEmpty(vendor.vendorData) || vendor.vendorData.tasks == undefined) {
					vis.emptytext.text = Res.pipText("emptytasks");
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
					
					n.nazv = Res.messText(task.id);
					
					if (World.w.game.quests[task.id]) {
						var quest:Quest = World.w.game.quests[task.id];
						n.state = World.w.game.quests[task.id].state;
						
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
					vis.emptytext.text = Res.pipText("emptytasks");
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
					if (World.w.game.quests[task.id]) {
						var quest:Quest = World.w.game.quests[task.id];
						var nstate = World.w.game.quests[task.id].state;
						
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
			if (World.w.ctr.setkeyOn) {
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
			
			if (page2 == 3 && npcInter == 'doc') {
				page2 = 1;
				pip.onoff(6);
			}
			else {
				setStatus();
			}
		}
	
		private function showBottext():void {
			if (page2==1 && vendor) {
				vis.bottext.htmlText=Res.pipText('caps')+': '+numberAsColor('yellow', pip.money)+' (';
				if (vendor.kolBou>0) vis.bottext.htmlText+='-'+numberAsColor('yellow', Math.ceil(vendor.kolBou))+'; ';
				vis.bottext.htmlText+=numberAsColor('yellow', Math.floor(pip.money-vendor.kolBou))+' '+Res.pipText('ost')+')';
			}
			
			if (page2==2 && vendor) {
				vis.bottext.htmlText=Res.pipText('caps')+': '+numberAsColor('yellow', pip.money)+' (+'+numberAsColor('yellow', Math.floor(vendor.kolSell))+')';
				if (!inbase) vis.bottext.htmlText+='   '+Res.pipText('vcaps')+': '+numberAsColor('yellow', vendor.money);
			}
			
			if (page2==3) {
				vis.bottext.htmlText=Res.pipText('caps')+': '+numberAsColor('yellow', inv.money.kol);
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
			
			try {
				item.trol.gotoAndStop(obj.wtip);
			}
			catch (err) {
				trace('ERROR: (00:42)');
				item.trol.gotoAndStop(1);
			}
			
			if (page2 == 1) {
				item.lvl.visible = true;
				item.lvl.gotoAndStop(obj.barter + 1);
				item.rid.text = obj.rid;
				item.cat.text = obj.tip;
				item.nazv.text = obj.nazv;
				
				if (obj.tip == Item.L_WEAPON || obj.tip == Item.L_ARMOR) {
					item.hp.text = Math.round(obj.sost * 100) + '%';
					
					if (obj.bou == 0) {
						item.kol.text = Res.pipText('est');
					}
					else {
						item.kol.text = Res.pipText('sel');
					}
					
					item.price.text = Math.round(obj.price * obj.mp);
				}
				else {
					var ns:NumericStepper = item.ns;	// Adobe Animate dependency
					ns.visible = true;
					ns.maximum = obj.kol;
					ns.value = obj.bou;
					item.kol.text = obj.kol-obj.bou;
					item.hp.text = (obj.sost == 0)? "-" : obj.sost;
					item.price.text = Math.round(obj.price * obj.mp * 10) / 10;
				}
			} 
			
			if (page2==2) {
				item.cat.text=obj.tip;
				item.rid.text=obj.id;
				item.nazv.text=obj.nazv;
				item.hp.text='';
				item.price.text = Math.round(obj.price*10)/10;
				item.kol.text=obj.kol;
				var ns:NumericStepper = item.ns;	// Adobe Animate dependency
				ns.visible=true;
				ns.maximum=obj.kol;
				ns.value=obj.bou;
				item.kol.text=obj.kol-obj.bou;
			} 
			
			if (page2 == 3) {
				item.cat.text = obj.tip;
				item.nazv.text = obj.nazv;
				item.hp.text = Math.round(obj.hp / obj.maxhp * 100) + '%';
				
				var mp:Number = 1;
				if (obj.tip == Item.L_ARMOR) {
					mp = gg.pers.priceRepArmor;
				}
				
				item.price.text = Math.ceil(obj.price * (obj.maxhp - obj.hp) / obj.maxhp * vendor.multPrice * mp);
				item.kol.text = "";
				
				if (obj.variant > 0) {
					item.rid.text = obj.id + '^' + obj.variant;
				}
				else {
					item.rid.text = obj.id;
				}
			} 
		
			if (page2==4) {
				item.cat.text=obj.state;
				item.nazv.text=obj.nazv;
				item.hp.text='';
				item.price.text='';
				item.price.x=400;
				item.price.width=158;
				if (obj.state==1) item.price.text=Res.pipText('perform');
				if (obj.state==2) {
					item.price.text=Res.pipText('done');
					item.nazv.alpha=0.5;
				}
				if (obj.state==3) item.price.text=Res.pipText('surr');
				if (obj.state==4) item.price.text=Res.pipText('progress');
				item.kol.text='';
			}
		}
		
		// [Item information]
		override protected function statInfo(event:MouseEvent):void {
			if (page2 == 1 || page2 == 2 || page2 == 3) {
				infoItem(event.currentTarget.cat.text, event.currentTarget.rid.text, event.currentTarget.nazv.text);
			}
			
			if (page2 == 4) {
				vis.nazv.text = event.currentTarget.nazv.text;
				
				var s:String = infoQuest(event.currentTarget.id.text);
				if (s=='') vis.info.htmlText=Res.messText(event.currentTarget.id.text,1);
				else vis.info.htmlText=s;
				
				if (event.currentTarget.cat.text == '0') {
					vis.info.htmlText += "\n\n<span class = 'orange'>" + Res.pipText('actTake') + "</span>";
				}
				
				if (event.currentTarget.cat.text == '3') {
					vis.info.htmlText += "\n\n<span class = 'orange'>" + Res.pipText('actSurr') + "</span>";
				}
				
				if (event.currentTarget.cat.text == '4') {
					vis.info.htmlText += "\n\n<span class = 'orange'>" + Res.pipText('actGive') + "</span>";
				}
				
				setIco();
			}
			
			event.stopPropagation();
		}
		
		private function selBuy(buy:Object, n:int=1):void {
			if (selall) {
				vis.butOk.text.text = Res.pipText('transaction');
			}
			
			selall = false;
			
			if (buy == null || buy.kol - buy.bou <= 0) {
				return;
			}
			
			if (buy.tip == Item.L_WEAPON && inv.weapons[buy.id] != null && inv.weapons[buy.id].variant >= buy.variant) {
				return;
			}
			
			if (buy.tip == Item.L_ARMOR && inv.armors[buy.id] != null) {
				return;
			}
			
			if (buy.tip == Item.L_WEAPON && inv.weapons[buy.id] == null) {
				if (vendor.buys2[buy.id]) {
					vendor.buys2[buy.id].checkAuto(true);
				}
			}
			
			if (buy.tip == Item.L_SPELL && vendor.buys2[buy.id]) {
				vendor.buys2[buy.id].checkAuto(true);
			}
			
			vis.butOk.visible = true;
			
			if (buy.kol - buy.bou < n) {
				n = buy.kol - buy.bou;
			}
			
			if (page2 == 1 && Math.round(buy.price * buy.mp * n)>pip.money - vendor.kolBou) {//!!!
				n = Math.floor((pip.money - vendor.kolBou) / (buy.price * buy.mp));
				if (n <= 0) {
					World.w.gui.infoText('noMoney', Math.round(buy.price * buy.mp - (pip.money - vendor.kolBou)));
					return;
				}
			}
			
			buy.bou += n;
			
			if (page2 == 1) {
				vendor.kolBou += buy.price * buy.mp * n;
			}
			
			if (page2 == 2) {
				vendor.kolSell += buy.price * n;
			}
		}
		
		private function unselBuy(buy:Object, n:int=1):void {
			if (buy == null || buy.bou <= 0) {
				return;
			}
			
			if (buy.bou < n) {
				n = buy.bou;
			}
			
			buy.bou -= n;
			
			if (page2 == 1) {
				vendor.kolBou -= buy.price * buy.mp * n;
			}
			
			if (page2 == 2) {
				vendor.kolSell -= buy.price * n;
			}
		}
		
		private function nsClick(event:MouseEvent):void {
			event.stopPropagation();
		}

		private function nsCh(event:Event):void {
			if (page2 == 1 || page2 == 2) {
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
			if (page2 == 1 || page2 == 2) {
				var buy:Object = assArr[event.currentTarget.rid.text];
				var n = 1;
				
				if (event.shiftKey) {
					n=buy.kol-buy.bou;
				}
				
				if (event.shiftKey && event.ctrlKey) {
					n=buy.bou;
				}
				
				if (event.ctrlKey) {
					unselBuy(buy, n);
				}
				else {
					selBuy(buy, n);
				}
				
				setStatItem(event.currentTarget as MovieClip, buy);
			}
			
			if (page2==3) {
				if (inv.money.kol<=0) return;
				var price:int=event.currentTarget.price.text;
				if (price<=0) return;
				if (price>inv.money.kol) price=inv.money.kol;
				var obj;
				
				if (event.currentTarget.cat.text==Item.L_INSTR) {
					var owl:UnitPet=gg.pets[event.currentTarget.id.text];
					var repOwl:int = 2;
					var hl:Number=price/repOwl/vendor.multPrice;
					if (hl>owl.maxhp-owl.hp) {
						hl=(owl.maxhp-owl.hp);
						price=hl*repOwl*vendor.multPrice;
					}
					owl.repair(hl);
					obj=assArr[event.currentTarget.id.text];
					obj.hp=owl.hp;
				}
				
				if (event.currentTarget.cat.text==Item.L_WEAPON)
				{
					var w:Weapon=inv.weapons[event.currentTarget.id.text];
					var hp:int=Math.ceil(price/w.price*w.maxhp/vendor.multPrice);
					w.repair(hp);
					obj=assArr[event.currentTarget.id.text];
					obj.hp=w.hp;
				}
				
				if (event.currentTarget.cat.text==Item.L_ARMOR) {
					var a:Armor=inv.armors[event.currentTarget.id.text];
					var hp:int=Math.ceil(price/a.price*a.maxhp/vendor.multPrice/gg.pers.priceRepArmor);
					a.repair(hp);
					obj=assArr[event.currentTarget.id.text];
					obj.hp=a.hp;
				}
				
				inv.money.kol-=price;
				pip.vendor.money+=price;
				setStatItem(event.currentTarget as MovieClip, obj);
				World.w.gui.setWeapon();
				pip.setRPanel();
			}
			
			if (page2==4) {
				try {
					if (World.w.game.quests[event.currentTarget.id.text]) {
						var quest:Quest=World.w.game.quests[event.currentTarget.id.text];
						quest.chGive(npcId, true);
						quest.chReport(npcId, true);
					}
					else {
						World.w.game.addQuest(event.currentTarget.id.text);
					}
				}
				catch(err) {
					trace('ERROR: (00:43)');
				}
				
				setStatus(false);
			}
			
			pip.snd(1);
			showBottext();
			event.stopPropagation();
		}

		override protected function itemRightClick(event:MouseEvent):void {
			if (page2==1 || page2==2) {
				var buy:Object=assArr[event.currentTarget.rid.text];
				var n=1;
				if (event.shiftKey) n=10;
				unselBuy(buy, n);
				setStatItem(event.currentTarget as MovieClip, buy);
			}
			
			pip.snd(1);
			showBottext();
			event.stopPropagation();
		}
		
		private function transOk(event:MouseEvent):void {
			if (page2==1) {
				trade(assArr);
			}
			
			if (page2==2) {
				if (selall) sellAll();
				else sell(assArr);
			}
			
			pip.setRPanel();
			pip.snd(3);
		}
		
		public function trade(arr:Array):void {
			if (vendor.kolBou>inv.money.kol) {
				return;
			}
			
			for each(var buy:Item in vendor.buys) {
				var rid:String=buy.id;
				if (buy.variant>0) rid+='^'+buy.variant;
				if (arr[rid] && arr[rid].bou>0) {
					buy.bou=arr[rid].bou;
					inv.take(buy,1);
				}
			}
			
			inv.money.kol-=Math.ceil(vendor.kolBou);
			vendor.money+=Math.ceil(vendor.kolBou);
			pip.money=inv.money.kol;
			vendor.kolBou=0;
			inv.calcMass();
			inv.calcWeaponMass();
			setStatus();
		}
		
		public function sell(arr:Array):void {
			if (!inbase && Math.ceil(vendor.kolSell)>vendor.money) {
				World.w.gui.infoText('noSell');
				return;
			}
			
			for (var s in inv.items) {
				if (s=='' || inv.items[s].kol<=0) continue;
				var node=inv.items[s].xml;
				if (node==null) continue;
				if (arr[s] && arr[s].bou>0) {
					var buy:Item=vendor.buys2[s];
					if (buy==null) {
						buy=new Item(null,s,0);
						buy.kol=0;
						vendor.buys.push(buy);
						vendor.buys2[s]=buy;
					}
					buy.kol+=arr[s].bou;
					inv.items[s].kol-=arr[s].bou;
				}
			}
			
			inv.money.kol+=Math.floor(vendor.kolSell);
			vendor.money-=Math.ceil(vendor.kolSell);
			pip.money=inv.money.kol;
			vendor.kolSell=0;
			setStatus();
		}
		
		public function sellAll():void {
			for (var s in arr) {
				if (arr[s].tip=='valuables') {
					selBuy(arr[s],arr[s].kol-arr[s].bou);
				}
			}
			vis.butOk.text.text=Res.pipText('transaction');
			selall=false;
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
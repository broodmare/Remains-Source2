package fe.inter {

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;

	import fl.controls.NumericStepper;	// Adobe Animate dependency

	import fe.*;
	import fe.serv.Item;
	import fe.weapon.Weapon;
	import fe.unit.Inventory;
	import fe.unit.InventoryItem;

	import fe.stubs.visPipVaultItem;
	
	/* 
	*	A menu for storing or retrieving items. (Currently accessed in-game through the orange chest)
	*	sub-categories:
	*		1 - Equipment
	*		2 - Ammunition
	*		3 - Stuff
	*		4 - *disabled*
	*		5 - *disabled*
	*/
	public class PipPageVault extends PipPage {
		
		private static const PAGE_EQUIPMENT:int = 1, PAGE_AMMO:int = 2, PAGE_STUFF:int = 3;
		private var assArr:Array;

		// Constructor
		public function PipPageVault(npip:PipBuck, npp:String) {
			isLC = true;
			isRC = true;

			itemClass = visPipVaultItem;
			
			super(npip,npp);
			
			// Set which sub-categories are disabled at the top of the pip-buck
			vis.but4.visible = false;
			vis.but5.visible = false;
			
			var tf:TextFormat=new TextFormat();
			tf.color = 0x00FF99; 
			tf.size = 16; 
			vis.butOk.addEventListener(MouseEvent.CLICK,transOk);
			for (var i:int = 0; i < maxrows; i++) {
				var item:MovieClip = statArr[i]; 
				var ns:NumericStepper = item.ns;
				ns.addEventListener(MouseEvent.CLICK, nsClick);
				ns.addEventListener(Event.CHANGE, nsCh);
				ns.tabEnabled = false;
				ns.focusRect = false;
				ns.setStyle("textFormat", tf);
			}
		}

		// [Preparing pages]
		override protected function setSubPages():void {
			inv = World.w.invent;
			gg = World.w.gg;
			var vault:Inventory = World.w.vault;
			
			assArr = [];
			statHead.ns.visible = false;
			statHead.id.visible = false;
			statHead.cat.visible = false;
			statHead.nazv.text = LanguageManager.reference.localText("pip", "ii2");
			statHead.kol.text = LanguageManager.reference.localText("pip", "ii7");
			statHead.kol.width = 170;
			statHead.mass.text  = World.w.hardInv ? LanguageManager.reference.localText("pip", "ii8") : "";
			statHead.mass2.text = World.w.hardInv ? LanguageManager.reference.localText("pip", "ii9") : "";
			setTopText("vaultupr");
			vis.butOk.visible = false;
			
			// inv.calcMass(); FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME 
			

			for each (var item:InventoryItem in inv.getAllItems()) {
				if (item.hidden) {
					continue;
				}

				var iData:Object = ItemManager.reference.getItem(item.id);
				var type:String = iData.tip;

				if (type == "money" || type == "paint" || type == "spell" || type == "spec" || type == "key" || type == "instr" 
									|| type == "impl" || type == "art" || type == "scheme") {
					continue;
				}
				
				if (iData.invCat == page2) {
					
					// Get the localized name of the category this item belondgs to
					var tcat:String;
					tcat = LanguageManager.reference.localText("pip", type);
					
					var n:Object = {
						tip:	type, 
						id:		iData.id, 
						nazv:((type == "e") ? Res.txt("w", iData.id) : iData.nazv), 
						kol:	inv.getQuantity(item.id), 
						vault:	vault.getQuantity(item.id), 
						mass:	iData.mass, 
						cat:	tcat,
						trol:	type
					};
					
					if (type == "valuables") {
						n.price = iData.price;
					}
					
					if (type == "food" && iData.ftip == "1") {
						n.trol = "drink";
					}
					
					if (iData.keep > 0) {
						n.keep = true;
					}
					
					n.sort = n.cat;
					n.sort2 = "sort" in iData ? iData.sort : 0;
					arr.push(n);
					assArr[n.id] = n;
				}
			}
			
			if (arr.length) {
				arr.sortOn(["sort", "sort2", "nazv"], [0, Array.NUMERIC, 0]);
			}
			
			if (page2 == PAGE_AMMO || page2 == PAGE_STUFF) {
				vis.butOk.text.text = LanguageManager.reference.localText("pip", "tovault");
				vis.butOk.visible = true;
			}
				
			setIco();
			showBottext();
		}
		
		private function showBottext():void {
			if (World.w.hardInv) {
				//vis.bottext.text=inv.retMass(page2); FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME 
			}
			else {
				vis.bottext.text = "";
			}
		}
		
		// [Show one element]
		override protected function setStatItem(item:MovieClip, obj:Object):void {
			item.id.text = obj.id;
			item.id.visible = false;
			item.cat.visible = false;
			item.nazv.alpha = 1;
			
			try {
				item.trol.gotoAndStop(obj.tip);
			}
			catch (err) {
				trace("ERROR: (00:40)");
				item.trol.gotoAndStop(1);
			}
			
			item.id.text = obj.id;
			item.nazv.text = obj.nazv;
			item.nazv.alpha = 1;
			
			if (obj.kol == 0) {
				item.nazv.alpha = 0.5;
			}
			
			item.cat.text=obj.tip;
			item.mass.text=World.w.hardInv?obj.mass:"";
			item.mass2.text=World.w.hardInv?Res.numb(obj.mass*obj.kol):"";
			item.kol.text=obj.kol;
			item.ns.maximum=obj.kol+obj.vault;
			item.ns.value=obj.vault;
		}
		
		// [Item information]
		override protected function statInfo(event:MouseEvent):void {
			infoItem(event.currentTarget.cat.text,event.currentTarget.id.text,event.currentTarget.nazv.text);
		}
		
		private function chKol(mc, n:int = 0):void {
			var obj = assArr[mc.id.text];
			var id:String = mc.id.text;
			var data:Object = ItemManager.reference.getItem(id);
			
			if (id == "" || obj == null) {
				return;
			}
			
			var inv:Inventory = World.w.invent;
			var vault:Inventory = World.w.vault;

			var invQty:int = inv.getQuantity(id);
			var vaultQty:int = vault.getQuantity(id);
			
			n = n - vaultQty;
			
			if (n > invQty) {
				n = invQty;
			}
			
			if (n < -vaultQty) {
				n = -vaultQty;
			}
			
			vault.increaseQuantity(id, n);
			inv.decreaseQuantity(id, n);

			obj.kol = inv.getQuantity(id);
			obj.vault = vault.getQuantity(id);
			
			var dmass:Number = n * data.mass;
			inv.mass[data.invCat] -= dmass;
			
			showBottext();
			pip.setRPanel();
			
			if (mc) {
				if (obj.kol == 0) {
					mc.nazv.alpha = 0.5;
				}
				else {
					mc.nazv.alpha = 1;
				}
				
				mc.kol.text = obj.kol;
				mc.ns.value = obj.vault;
				mc.mass2.text = World.w.hardInv ? Res.numb(obj.mass * obj.kol) : "";
			}
		}
		
		private function nsClick(event:MouseEvent):void {
			event.stopPropagation();
		}

		private function nsCh(event:Event):void {
			chKol(event.currentTarget.parent, event.currentTarget.value);
		}
		
		override protected function itemClick(event:MouseEvent):void {
			if (event.ctrlKey) {
				chKol(event.currentTarget, 0);
			}
			else {
				chKol(event.currentTarget, int.MAX_VALUE);
			}
			
			pip.snd(1);
			showBottext();
			pip.setRPanel();
			event.stopPropagation();
		}
		
		override protected function itemRightClick(event:MouseEvent):void {
			chKol(event.currentTarget, 0);
			pip.snd(1);
			showBottext();
			pip.setRPanel();
			event.stopPropagation();
		}
		
		private function checkAmmo(item:Item):Boolean {
			var ab:String = item.id;
			
			if (item.tip == "a" && "base" in item.data) {
				ab = item.base;
			}
			
			for each(var weap:Weapon in inv.equipment.weapons) {
				if (weap == null) {
					continue;
				}
				
				if (weap.respect == Weapon.WEP_INACTIVE || weap.respect == Weapon.WEP_ACTIVE) {
					if (weap.tip == "explosives" && ab == weap.id) {
						return true;
					}
					
					if (ab == weap.ammo.base) {
						return true;
					}
				}
			}
			
			return false;
		}

		private function sbrosHlam():void {
			
			var dmass:Number = 0;	// Total mass of items?
			
			for (var s:String in arr) {
				if (arr[s].tip != "food" && arr[s].tip != "book" && arr[s].tip != "sphera" && arr[s].tip != "valuables" && !arr[s].keep) {
					var item:InventoryItem = inv.getItem(arr[s].id);
					var data:Object = ItemManager.reference.getItem(item.id)
					
					/*
					if (arr[s].tip == "a" || arr[s].tip == "e" || arr[s].tip == "compw") {
						if (checkAmmo(item)) {
							continue
						}
					}
					*/ // FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME

					var inv:Inventory = World.w.invent;
					var vault:Inventory = World.w.vault;

					dmass = inv.getQuantity(item.id) * data.mass;
					vault.increaseQuantity(item.id, item.quantity);
					inv.setQuantity(item.id, 0);
					inv.mass[data.invCat] -= dmass;
					dmass = 0;
				}
			}
			
			showBottext();
			setStatus();
			pip.setRPanel();
		}
		
		private function transOk(event:MouseEvent):void {
			if (page2 == PAGE_AMMO || page2 == PAGE_STUFF) {
				sbrosHlam();
			}
		}
	}	
}
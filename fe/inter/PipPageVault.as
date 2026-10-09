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
	*		3 - Explosives
	*		4 - Stuff
	*		5 - *disabled*
	*/
	public class PipPageVault extends PipPage {
		
		private static const PAGE_EQUIPMENT:int = 1, PAGE_AMMO:int = 2, PAGE_EXPLOSIVES:int = 3, PAGE_STUFF:int = 4;
		private var assArr:Array;

		// Constructor
		public function PipPageVault(npip:PipBuck, npp:String) {
			isLC = true;
			isRC = true;

			itemClass = visPipVaultItem;
			
			super(npip,npp);
			
			// Set which sub-categories are disabled at the top of the pip-buck
			vis.but5.visible = false;
			updateLang();
			
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

		// The tabs don't match the 'vault1'-'vault3' texts anymore (those are also used for the weight categories)
		override public function updateLang():void {
			super.updateLang();
			
			var localize:Function = LanguageManager.reference.localText;
			vis.but3.text.text = localize("pip", "vaultexpl");
			vis.but4.text.text = localize("pip", "vault3");
		}
		
		// [The tab an item is listed on] Explosives have their own tab, but they still count towards the ammunition's weight
		private static function vaultPage(id:String, type:String):int {
			if (type == Item.L_EXPL) {
				return PAGE_EXPLOSIVES;
			}
			
			var invCat:int = ItemManager.reference.getInvCat(id);
			return (invCat == 3) ? PAGE_STUFF : invCat;
		}
		
		// The weight category shown on the current tab (see ItemManager.getInvCat)
		private function massCat():int {
			if (page2 == PAGE_EXPLOSIVES) {
				return 2;
			}
			
			if (page2 == PAGE_STUFF) {
				return 3;
			}
			
			return page2;
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
			
			ItemInteraction.calcMass(inv);
			
			var itemManager:ItemManager = ItemManager.reference;
			
			// [Everything the player is carrying or has stored]
			var ids:Array = [];
			var listed:Object = {};
			var item:InventoryItem;
			
			for each (item in inv.getAllItems()) {
				listed[item.id] = true;
				ids.push(item.id);
			}
			
			for each (item in vault.getAllItems()) {
				if (!listed[item.id]) {
					listed[item.id] = true;
					ids.push(item.id);
				}
			}

			for each (var id:String in ids) {
				if (!itemManager.hasItem(id)) {
					continue;
				}

				var iData:Object = itemManager.getItem(id);
				var type:String = iData.tip;
				
				if (iData.invis) {
					continue;
				}

				if (type == "money" || type == "paint" || type == "spell" || type == "spec" || type == "key" || type == "instr" 
									|| type == "impl" || type == "art" || type == "scheme") {
					continue;
				}
				
				if (vaultPage(id, type) == page2) {
					
					// Get the localized name of the category this item belondgs to
					var tcat:String;
					if (LanguageManager.reference.hasText("pip", type)) {
						tcat = LanguageManager.reference.localText("pip", type);
					}
					else {
						tcat = LanguageManager.reference.localText("pip", "stuff");
					}
					
					var n:Object = {
						tip:	type, 
						id:		id, 
						nazv:	Item.nameOf(id, type), 
						kol:	inv.getQuantity(id), 
						vault:	vault.getQuantity(id), 
						mass:	itemManager.getWeight(id), 
						cat:	tcat,
						trol:	type
					};
					
					if (type == "valuables") {
						n.price = iData.price;
					}
					
					if (type == "food" && iData.ftip == 1) {
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
				vis.bottext.htmlText = ItemInteraction.retMass(inv, massCat());
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
		
		// [Change how many of an item are stored in the vault] n - the amount that should be in the vault
		private function chKol(mc, n:int = 0):void {
			var obj = assArr[mc.id.text];
			var id:String = mc.id.text;
			
			if (id == "" || obj == null) {
				return;
			}
			
			var inv:Inventory = World.w.invent;
			var vault:Inventory = World.w.vault;
			var invQty:int = inv.getQuantity(id);
			var vaultQty:int = vault.getQuantity(id);
			
			// The amount to move into the vault (negative to take items out)
			n = n - vaultQty;
			
			if (n > invQty) {
				n = invQty;
			}
			
			if (n < -vaultQty) {
				n = -vaultQty;
			}
			
			if (n > 0) {
				inv.decreaseQuantity(id, n);
				vault.increaseQuantity(id, n);
			}
			else if (n < 0) {
				vault.decreaseQuantity(id, -n);
				inv.increaseQuantity(id, -n);
			}

			obj.kol = inv.getQuantity(id);
			obj.vault = vault.getQuantity(id);
			
			inv.mass[ItemManager.reference.getInvCat(id)] -= n * obj.mass;
			
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
		
		// [Check if the item is ammo for a weapon the player is using]
		private function checkAmmo(id:String, tip:String):Boolean {
			var ab:String = id;
			
			if (tip == Item.L_AMMO && WeaponManager.reference.getAmmo(id).base != "") {
				ab = WeaponManager.reference.getAmmo(id).base;
			}
			
			for each(var weap:Weapon in inv.equipment.weapons) {
				if (weap.respect == Weapon.WEP_INACTIVE || weap.respect == Weapon.WEP_ACTIVE) {
					if (weap.tip == Weapon.TYPE_EXPLOSIVES && ab == weap.id) {
						return true;
					}
					
					if (weap.ammoBase && ab == weap.ammoBase.id) {
						return true;
					}
				}
			}
			
			return false;
		}

		// [Put everything that isn't needed in the vault]
		private function sbrosHlam():void {
			var inv:Inventory = World.w.invent;
			var vault:Inventory = World.w.vault;
			
			for each (var obj:Object in arr) {
				if (obj.tip != "food" && obj.tip != "book" && obj.tip != "sphera" && obj.tip != "valuables" && !obj.keep) {
					var kol:int = inv.getQuantity(obj.id);
					
					if (kol <= 0) {
						continue;
					}
					
					if (obj.tip == Item.L_AMMO || obj.tip == Item.L_EXPL || obj.tip == Item.L_COMPW) {
						if (checkAmmo(obj.id, obj.tip)) {
							continue;
						}
					}

					inv.setQuantity(obj.id, 0);
					vault.increaseQuantity(obj.id, kol);
					inv.mass[ItemManager.reference.getInvCat(obj.id)] -= kol * obj.mass;
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
package fe.inter {

	// [Stand for weapons, collectibles and achievements]
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	import flash.geom.Matrix;
	
	import fe.*;
	import fe.unit.Inventory;
	import fe.unit.Armor;
	import fe.weapon.Weapon;
	import fe.serv.Item;
	
	public class Stand {
		
		public var active:Boolean = false;
		
		private var vis:MovieClip;
		private var visX:int = 1200;
		private var visY:int = 800;

		private var pages:Vector.<MovieClip>;
		private var buttons:Vector.<MovieClip>;

		private var weapons:Array;
		private var arts:Array;
		private var armors:Array;
		
		public var inv:Inventory;
		
		private var kolPages:int		= 9;
		private var kolLevels:int		= 6;
		private var page:int			= 0;
		
		private var ls:Array = ["stat_aj","stat_tw","stat_fl","stat_rr","stat_rd","stat_pp"];
		
		private var itemFilter:GlowFilter	= new GlowFilter(0x00FF99, 1, 3, 3, 4, 1, false, false);
		private var clearFilter:GlowFilter	= new GlowFilter(0x00FF99, 1, 3, 3, 1, 1, false, true);
		private var glowFilter:GlowFilter	= new GlowFilter(0x00FF99, 1, 10, 6, 2, 3);
		
		private var info:MovieClip;
		
		// Constructor
		public function Stand(vstand:MovieClip, ninv:Inventory) {
			vis = vstand;
			inv = ninv;
			pages	= new Vector.<MovieClip>(kolPages, true);
			buttons	= new Vector.<MovieClip>(kolPages, true);
			weapons	= [];
			armors	= [];
			arts	= [];

			for (var i:int = 0; i < kolPages; i++) {
				var page:MovieClip = new MovieClip();
				page.x = 200;
				page.visible = false;
				vis.addChild(page);
				pages[i] = page;
				var but:MovieClip = new butStand(); // .SWF Dependency
				but.id.text = i;
				but.id.visible = false;
				but.ico.gotoAndStop(i + 2);
				but.text.text = Res.txt("g", "stand" + i);
				but.y = 25 + 75 * i;
				but.x = 20;
				but.stop();
				vis.addChild(but);
				buttons[i] = but;
				but.addEventListener(MouseEvent.CLICK, standBut);
			}
			
			vis.butclose.addEventListener(MouseEvent.CLICK,standClose);
			vis.butclose.id.visible=false;
			vis.butclose.text.text=Res.txt("g", "close");
			
			resizeScreen(1200, 800);
			
			createWeaponLists(0);
			createWeaponLists(1);
			createWeaponLists(2);
			createWeaponLists(3);
			createWeaponLists(4);
			createWeaponLists(5);
			createArmorList(6);
			createArmorList(7);
			createArtList(8);
			showWeaponList(0);
			
			info = new visualStandInfo(); // SWF Dependency
			vis.addChild(info);
			info.visible=false;
			PipPage.setStyle(info.info);
			info.info.autoSize="left";
			vis.toptext.visible=false;
			PipPage.setStyle(vis.bottext);
			PipPage.setStyle(vis.toptext.txt);
			vis.bottext.htmlText="";
		}
		
		public function standClose(event:MouseEvent):void {
			onoff(-1);
		}
		
		public function standBut(event:MouseEvent):void {
			page = event.currentTarget.id.text;
			setButtons();
			showWeaponList(page);
		}
		
		// [Create the weapon slots of a page] Each slot holds a base weapon and its unique variant (eg. "mont" and "mont^1")
		private function createWeaponLists(n:int):void {
			var levels:Array = [0, 0, 0, 0, 0, 0, 0];
			var stolb:int = -1;
			var weaponData:Object = WeaponManager.reference.allWeaponData();

			for each (var weap:Object in weaponData) {

				// Explosives like grenades and mines are items, they're kept in the vault instead (launchers stay on the stand)
				if (weap.variant || weap.tip == Weapon.TYPE_INTERNAL || weap.tip == Weapon.TYPE_EXPLOSIVES || weap.nostand) {
					continue;
				}
				
				if ((n==0 && weap.skill==1) || (n==1 && weap.skill==2) || (n==2 && weap.skill==4) || (n==3 && weap.skill==5) || (n==4 && weap.skill==3) || (n==5 && weap.skill>=6)) {
					var item:MovieClip = new itemStand();  // SWF Dependency
					var uniqueId:String = ItemInteraction.uniqueVariant(weap.id);
					
					if (weap.tip == Weapon.TYPE_MAGIC) {
						stolb++;
						if (stolb >= kolLevels) {
							stolb = 0;
						}
					}
					else {
						stolb = weap.lvl;
					}
					
					levels[stolb]++;
					
					item.x = 80 + stolb * 160;
					item.y = 40 + levels[stolb] * 100;
					item.id.text = weap.id;
					item.id.visible = false;
					item.dop.visible = false;
					item.dop.text = "";
					item.goldstar.stop();
					item.nazv.text = WeaponManager.weaponName(weap.id);
					
					// [Image]
					var infIco:MovieClip;
					var r:Number = 1;
					
					// [Spell]
					if (weap.tip == Weapon.TYPE_MAGIC) {
						infIco = new itemIco();  // SWF Dependency
						
						try {
							infIco.gotoAndStop(weap.id);
						}
						catch(err:Error) {
							trace("ERROR: (00:47)");
							infIco.stop();
						}
						
						item.goldstar.y = -85;
						item.zad.scaleY = 1.35;
						item.y = 40 + levels[stolb] * 140;
						
						if (weap.spell) {
							item.nazv.text = Item.nameOf(weap.id);
						}
					}
					else {
						var vWeapon:Class = null;
						
						if ("vis_vico" in weap) {
							vWeapon = Res.getClass(weap.vis_vico, null);
						}
						
						if (vWeapon == null) {
							vWeapon = Res.getClass("vis" + weap.id, null);
						}
						
						if (vWeapon != null) {
							infIco = new vWeapon();
						}
					}
					
					if (infIco) {
						if ("vis_icomult" in weap) {
							r = infIco.scaleX = infIco.scaleY = weap.vis_icomult;
						}
						
						infIco.x = -infIco.getRect(infIco).left * r - infIco.width * 0.50;
						infIco.y = -infIco.height - infIco.getRect(infIco).top;
						infIco.stop();
						
						if (infIco.lez) {
							infIco.lez.stop();
						}
						
						item.weapon.addChild(infIco);
					}
					
					// The unique variant shares the slot
					if (uniqueId) {
						item.nazv2.text = WeaponManager.weaponName(uniqueId);
						item.dop.text = "1";	// [There is a unique option]
						item.goldstar.gotoAndStop(2);	// Add a gold star to indicate it has a unique variant
						vWeapon = Res.getClass("vis" + weap.id + "_1", null);	// Get the variant image
						
						if (vWeapon != null) {
							infIco = new vWeapon();
							infIco.x = -infIco.getRect(infIco).left * r - infIco.width * 0.50;
							infIco.y = -infIco.height - infIco.getRect(infIco).top;
							infIco.stop();
							
							if (infIco.lez) {
								infIco.lez.stop();
							}
							
							item.weapon2.addChild(infIco);
							item.dop.text = "2"; // [There is a unique option with your own picture]
						}
					}
					
					pages[n].addChild(item);
					weapons[weap.id] = item;
				}
			}
		}
		
		private function createArtList(n:int):void {
			for (var stolb:int = 0; stolb < 6; stolb++) {
				var item:MovieClip = new itemArt();  // SWF Dependency
				item.x = 80 + stolb * 160;
				item.y = 40;
				item.art.gotoAndStop(ls[stolb]);
				item.nazv.text=Res.txt("i", ls[stolb]);
				item.id.text = ls[stolb];
				item.id.visible = false;
				pages[n].addChild(item);
				arts[stolb] = item;
			}
		}
		
		private function createArmorList(n:int):void {
			var stolb:int = 0;
			var str:int = 0;
			var dvis:MovieClip = new visBodyStay();  // SWF Dependency
			var sc:Number = 1.5;
			var aid:String = Appear.ggArmorId;
			Appear.transp = true;
			
			for each(var arm in ArmorManager.reference.armors) {

				// Armor goes on the armor page and amulets on the amulet page
				if (n == 6 && arm.tip != Armor.TYPE_ARMOR || n == 7 && arm.tip != Armor.TYPE_AMULET) {
					continue;
				}

				var item:MovieClip = new itemArt();  // SWF Dependency
				item.x = 80 + stolb * 160;
				item.y = str * 180;
				stolb++;
				
				if (stolb >= 6) {
					stolb = 0;
					str++;
				}
				
				item.id.text = arm.id;
				item.id.visible = false;
				item.nazv.text = LanguageManager.reference.localText("armor", arm.id);
				
				pages[n].addChild(item);
				armors[arm.id] = item;
				
				if (n == 6) {
					World.w.armorWork = arm.id;
					dvis.gotoAndStop(2);
					dvis.gotoAndStop(1);
					var sprX:int = dvis.width * sc + 2;
					var sprY:int = dvis.height * sc + 2;
					var m:Matrix = new Matrix();
					m.tx = -dvis.getRect(dvis).left + 1;
					m.ty = -dvis.getRect(dvis).top + 1;
					m.scale(sc, sc);
					
					try {
						dvis.pip1.visible = false;
						dvis.sleg1.mark.visible = false;
						dvis.sleg2.mark.visible = false;
						dvis.head.morda.magic.visible = false; 
						dvis.head.morda.eye.visible = false;
					}
					catch (err) {

					}
					
					var bmpd:BitmapData = new BitmapData(sprX, sprY, true, 0x00000000);
					bmpd.draw(dvis, m);
					var bmp:Bitmap = new Bitmap(bmpd);
					item.art.addChild(bmp);
					bmp.x = -bmp.width / 2 - 10;
					bmp.y = 100;
				}
				else if (n == 7) {
					item.art.gotoAndStop(arm.id);
					item.art.y = 100;
				}
			}
			
			Appear.transp = false;
			World.w.armorWork = "";
		}
		
		private function showMass():void {
			vis.bottext.htmlText = "";
			
			if (page <= 4) {
				vis.bottext.htmlText = ItemInteraction.retMass(inv, 4);
			}

			if (page == 5) {
				vis.bottext.htmlText = ItemInteraction.retMass(inv, 5);
			}
		}
		
		// A weapon the player has, excluding blueprints and spells they haven't learned
		private function ownedWeapon(id:String):Weapon {
			var w:Weapon = inv.equipment.getWeapon(id);
			
			if (w == null || w.respect == Weapon.WEP_BLUEPRINT || (w.spell && inv.getQuantity(id) <= 0)) {
				return null;
			}
			
			return w;
		}
		
		// [The weapon shown in a slot] The weapon the player is carrying (the unique variant if they carry both), otherwise the one that's stored
		private function shownWeapon(baseId:String):Weapon {
			var base:Weapon = ownedWeapon(baseId);
			var unique:Weapon = ownedWeapon(baseId + "^1");
			
			if (unique && unique.respect != Weapon.WEP_LOCKED) {
				return unique;
			}
			
			if (base && base.respect != Weapon.WEP_LOCKED) {
				return base;
			}
			
			return unique || base;
		}
		
		// Update a slot to show the weapons the player has
		private function showFamily(item:MovieClip, baseId:String):void {
			var w:Weapon = shownWeapon(baseId);
			
			if (w == null) {
				showWeapon(item, 0, 0);
				return;
			}
			
			showWeapon(item, w.variant ? 2 : 1, w.respect);
			
			// [A brighter star if the player has the unique variant]
			if (item.dop.text != "") {
				item.goldstar.gotoAndStop(ownedWeapon(baseId + "^1") ? 3 : 2);
			}
		}
		
		private function showWeaponList(n:int):void {
			// Hide all pages
			for (var i:int = 0; i < kolPages; i++) {
				pages[i].visible = false;
			}


			// Limited inventory, show weight
			if (World.w.hardInv) {
				showMass();
			}
			
			pages[n].visible = true;
			
			if (n <= 5) {
				vis.toptext.txt.htmlText = Res.txt("p", "infostand", 0, true);
				vis.toptext.visible = true;
			}
			else if (n <= 7) {
				vis.toptext.txt.htmlText = Res.txt("p", "infostand3", 0, true);
				vis.toptext.visible = true;
			}
			else {
				vis.toptext.visible = false;
			}

			for (var baseId:String in weapons) {
				showFamily(weapons[baseId], baseId);
			}

			for (var armorId:String in armors) {
				showArmor(armors[armorId], armorId);
			}
			
			// Ministry mare statuettes 
			for (var s:String in ls) {
				if (inv.hasItem(ls[s])) {
					arts[s].nazv.visible = true;
					arts[s].art.filters = [itemFilter, glowFilter];
				}
				else {
					arts[s].nazv.visible = false;
					arts[s].art.filters = [clearFilter];
				}
			}
		}
		
		// [n - 0 - no, 1 - normal, 2 - unique]
		// [respect - 0 - new, 1 - hidden, 2 - used, 3 - scheme]
		private function showWeapon(item:MovieClip, n:int, respect:int):void {
			if (n == 0) {
				item.weapon.filters = [clearFilter, glowFilter];
				item.weapon2.filters = [clearFilter, glowFilter];
				item.weapon.alpha = 1;
				item.weapon2.alpha = 1;
				item.nazv.visible = false;
				item.nazv2.visible = false;
				item.weapon.visible = true;
				item.weapon2.visible = false;
				item.goldstar.visible = false;
			}
			else if (n==1) {
				item.nazv.visible = true;
				item.nazv2.visible = false;
				item.weapon.visible = true;
				item.weapon2.visible = false;
				item.goldstar.visible = true;
			}
			else if (n==2) {
				item.nazv.visible = false;
				item.nazv2.visible = true;
				if (item.dop.text == "2") {
					item.weapon.visible = false;
					item.weapon2.visible = true;
				}
				else {
					item.weapon.visible = true;
					item.weapon2.visible = false;
				}
				item.goldstar.gotoAndStop(3);
				item.goldstar.visible = true;
			}
			
			if (item.nazv.visible || item.nazv2.visible) {
				// [Stored weapons are dimmed] Both sprites are dimmed, the unique variant uses weapon2
				if (respect == Weapon.WEP_LOCKED) {
					item.weapon.alpha = 0.5;
					item.weapon2.alpha = 0.5;
					item.weapon.filters = [itemFilter];
					item.weapon2.filters = [itemFilter];
					item.nazv.alpha = 0.35;
					item.nazv2.alpha = 0.35;
				}
				else {
					item.weapon.filters = [itemFilter, glowFilter];
					item.weapon2.filters = [itemFilter, glowFilter];
					item.nazv.alpha = 1;
					item.nazv2.alpha = 1;
					item.weapon.alpha = 1;
					item.weapon2.alpha = 1;
				}
			}
		}
		
		// [Show armor or an amulet] Highlighted if the player is carrying it, dimmed if it's left on the stand
		private function showArmor(item:MovieClip, id:String):void {
			var a:Armor = inv.equipment.getArmor(id);
			
			if (a == null || a.lvl < 0) {
				item.nazv.visible = false;
				item.art.alpha = 1;
				item.art.filters = [clearFilter];
			}
			else if (a.stored) {
				item.nazv.visible = true;
				item.nazv.alpha = 0.35;
				item.art.alpha = 0.5;
				item.art.filters = [itemFilter];
			}
			else {
				item.nazv.visible = true;
				item.nazv.alpha = 1;
				item.art.alpha = 1;
				item.art.filters = [itemFilter, glowFilter];
			}
		}
		
		private function setButtons():void {
			for (var i:int = 0; i < kolPages; i++) {
				var item:MovieClip = buttons[i];
				
				if (page == i) {
					item.gotoAndStop(2);
				}
				else {
					item.gotoAndStop(1);
				}
			}
		}
		
		// [Store or take weapons] With both variants the clicks go: carry both -> store the base -> swap them -> store both -> carry both
		public function itemClick(event:MouseEvent):void {
			var baseId:String = event.currentTarget.id.text;
			var base:Weapon = ownedWeapon(baseId);
			var unique:Weapon = ownedWeapon(baseId + "^1");
			var itemInteraction:ItemInteraction = World.w.gg.itemInteraction;
			
			if (base == null && unique == null) {
				return;
			}
			
			if (base == null || unique == null) {
				var w:Weapon = base || unique;
				itemInteraction.storeWeapon(w.id, w.respect != Weapon.WEP_LOCKED);
			}
			else {
				var baseStored:Boolean = (base.respect == Weapon.WEP_LOCKED);
				var uniqueStored:Boolean = (unique.respect == Weapon.WEP_LOCKED);
				
				if (!baseStored && !uniqueStored) {
					itemInteraction.storeWeapon(base.id, true);
				}
				else if (baseStored && !uniqueStored) {
					itemInteraction.storeWeapon(unique.id, true);
					itemInteraction.storeWeapon(base.id, false);
				}
				else if (!baseStored && uniqueStored) {
					itemInteraction.storeWeapon(base.id, true);
				}
				else {
					itemInteraction.storeWeapon(base.id, false);
					itemInteraction.storeWeapon(unique.id, false);
				}
			}
			
			showFamily(event.currentTarget as MovieClip, baseId);

			if (World.w.hardInv) {
				showMass();
			}
		}

		// [Leave armor or an amulet on the stand or take it back]
		public function armorClick(event:MouseEvent):void {
			var id:String = event.currentTarget.id.text;
			var a:Armor = inv.equipment.getArmor(id);
			
			if (a == null || a.lvl < 0) {
				return;
			}
			
			if (World.w.gg.itemInteraction.storeArmor(id, !a.stored)) {
				showArmor(event.currentTarget as MovieClip, id);
			}
		}

		public function itemOver(event:MouseEvent):void {
			var w:Weapon = shownWeapon(event.currentTarget.id.text);
			
			if (w == null) {
				return;
			}
			
			info.nazv.text = w.nazv;
			info.info.htmlText = PipPage.infoStr(Item.L_WEAPON, w.id);
			
			info.visible = true;
			info.fon.height = info.info.height + info.info.y + 8;
			var nx:int = event.currentTarget.x + event.currentTarget.parent.x + 80;
			var ny:int = event.currentTarget.y + event.currentTarget.parent.y - 50;
			
			if (ny + vis.y + info.height > World.w.cam.screenY - 10) {
				ny = World.w.cam.screenY - vis.y-info.height - 10;
			}
			
			if (nx + vis.x + info.width > World.w.cam.screenX - 10) {
				nx = event.currentTarget.x + event.currentTarget.parent.x - 80 - info.width;
			}
			
			info.x = nx;
			info.y = ny;
		}

		public function itemOver2(event:MouseEvent):void {
			if (!event.currentTarget.nazv.visible) {
				return;
			}
			
			info.nazv.text = event.currentTarget.nazv.text;
			info.info.htmlText = PipPage.infoStr(Item.L_ARMOR,event.currentTarget.id.text);
			info.visible = true;
			info.fon.height=info.info.height+info.info.y+8;
			var nx:int = event.currentTarget.x + event.currentTarget.parent.x + 80;
			var ny:int = event.currentTarget.y + event.currentTarget.parent.y + 20;
			
			if (ny + vis.y + info.height > World.w.cam.screenY - 10) {
				ny = World.w.cam.screenY - vis.y - info.height - 10;
			}
			
			if (nx + vis.x + info.width > World.w.cam.screenX - 10) {
				nx = event.currentTarget.x + event.currentTarget.parent.x - 80 - info.width;
			}
			
			info.x = nx;
			info.y = ny;
		}

		public function itemOut(event:MouseEvent):void {
			info.visible = false;
		}
		
		public function onoff(turn:int=0):void {
			if (turn == 0) {
				active =! active;
			}
			else if (turn > 0) {
				active = true;
				World.w.pip.onoff(-1);
				World.w.ctr.clearAll();
			}
			else {
				active = false;
			}
			
			vis.visible = active;

			if (active) {
				World.w.cur();
				setButtons();
				showWeaponList(page);
				
				for each (var item:MovieClip in weapons) {
					if (!item.hasEventListener(MouseEvent.CLICK)) {
						item.addEventListener(MouseEvent.CLICK,itemClick);
						item.addEventListener(MouseEvent.MOUSE_OVER,itemOver);
						item.addEventListener(MouseEvent.MOUSE_OUT,itemOut);
					}
				}
				
				for each (var item1:MovieClip in armors) {
					item1.addEventListener(MouseEvent.CLICK,armorClick);
					item1.addEventListener(MouseEvent.MOUSE_OVER,itemOver2);
					item1.addEventListener(MouseEvent.MOUSE_OUT,itemOut);
				}
				
				for each (var item2:MovieClip in arts) {
					item2.addEventListener(MouseEvent.MOUSE_OVER,itemOver2);
					item2.addEventListener(MouseEvent.MOUSE_OUT,itemOut);
				}
			}
			else {
				for each (var item3:MovieClip in weapons) {
					if (item3.hasEventListener(MouseEvent.CLICK)) {
						item3.removeEventListener(MouseEvent.CLICK,itemClick);
						item3.removeEventListener(MouseEvent.MOUSE_OVER,itemOver);
						item3.removeEventListener(MouseEvent.MOUSE_OUT,itemOut);
					}
				}
			
				for each (var item4:MovieClip in armors) {
					item4.removeEventListener(MouseEvent.CLICK,armorClick);
					item4.removeEventListener(MouseEvent.MOUSE_OVER,itemOver2);
					item4.removeEventListener(MouseEvent.MOUSE_OUT,itemOut);
				}
				
				for each (var item5:MovieClip in arts) {
					item5.removeEventListener(MouseEvent.MOUSE_OVER,itemOver2);
					item5.removeEventListener(MouseEvent.MOUSE_OUT,itemOut);
				}
			}
		}

		// [Size correction]
		public function resizeScreen(nx:int, ny:int):void {
			if (nx >= 1200 && ny >= 800) {
				vis.x = (nx - visX) / 2;
				vis.y = (ny - visY) / 2;
				vis.scaleX = 1;
				vis.scaleY = 1;
			}
			else {
				vis.x = 0;
				vis.y = 0;
			
				if (nx / 1200 < ny / 800) {
					vis.scaleX = vis.scaleY = nx / 1200;
				}
				else {
					vis.scaleX = vis.scaleY = ny / 800;
				}
			}
		}
	}
}
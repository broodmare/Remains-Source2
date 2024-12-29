package fe.unit {

	import fe.*;
	import fe.util.Vector2;
	import fe.weapon.*;
	import fe.serv.Item;
	import fe.serv.LootGen;
	import fe.serv.Script;
	import fe.loc.Loot;
	
	public class Invent {

		private var itemManager:ItemManager; // Reference to the ItemManager
		public var gg:UnitPlayer;
		public var owner:Unit;
		
		// The player's inventory
		public var items:Object		= {};	// Dictionary of ???
		public var eqip:Object		= {};	// Dictionary of all eqip items (Consumables, Eg. Potion, stimpak, etc.) stored by ID
		public var armors:Object	= {};	// Dictionary of all Armor objects stored by id
		public var weapons:Object	= {};	// Dictionary of all Weapon objects stored by id
		public var ammos:Object		= {};	// Dictionary of all Ammunition objects stored by id
		public var spells:Object	= {};	// Dictionary of all Spell objects stored by id

		public var fav:Array		= [];	// [Array of favorites by cell number]
		public var favIds:Array		= [];	// [Array of favorites by item id]
		
		public var cWeaponId:String;	// Current weapon equipped (ID)
		public var cSpellId:String;		// Current spell equipped (ID)
		public var cArmorId:String;		// Current armor equipped (ID)
		public var prevArmor:String;	// Previous armor equipped (ID)
		public var cAmulId:String;		// Current amulet equipped (ID)
		
		public var money:Item;	// Cached item (Not sure why)
		public var pin:Item;	// Cached item (Not sure why)
		public var gel:Item;	// Cached item (Not sure why)
		public var good:Item;	// Cached item (Not sure why)
		
		public var itemsId:Array = [];
		public var cItem:int=-1;
		public var cItemMax:int;
		
		public var mass:Array = [0, 0, 0, 0];
		public var massW:int = 0;
		public var massM:int = 0;

		private static var itemList:XMLList;
		private static var armorList:XMLList;

		public function Invent(manager:ItemManager, own:Unit, loadObj:Object = null, opt:Object = null) {
			itemManager = manager;
			owner = own;

			// Cache all items, armors, and weapons
			itemList = XMLDataGrabber.getNodesWithName("core", "AllData", "items", "item");
			armorList = XMLDataGrabber.getNodesWithName("core", "AllData", "armors", "armor");
			
			for each (var node in itemList) {
				var item:Item = new Item(node.@tip, node.@id, 0, 0, node);
				items[node.@id] = item;
				
				if (node.@us >= 2) {
					itemsId.push(node.@id);
				}
				
				if (item.invCat == 1 && item.mass > 0 && node.@perk.length() == 0) {
					eqip[node.@id];
				}
				
				if (node.@base.length()) {
					ammos[node.@base] = 0;
				}
			}

			// Cache references for these items
			money = items['money'];
			pin = items['pin'];
			gel = items['gel'];
			good = items['good'];
			
			// Create a blank item and store it as ""
			items[""] = new Item("", "", 0, 0, <item/>);	
			
			// If we were passed an object with the player's saved inventory, load it
			if (loadObj != null) {
				addLoad(loadObj);
			}
			
			cItemMax = itemsId.length;
		}
		
		public function nextItem(n:int = 1) {
			var ci = cItem + n;
			
			if (ci >= cItemMax) ci = 0;
			
			if (ci < 0) ci = cItemMax - 1;
			
			for (var i:int = 0; i < cItemMax; i++) {
				if (items[itemsId[ci]].kol > 0) {
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
		
		// [choose the right honey. device (potion?)]
		public function getMed(n:int):String {
			var nhp:Number=0;
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
			
			for each (var pot:XML in itemList) {
				if (pot.@heal == 'organ' && items[pot.@id].kol > 0 && (pot.@minmed.length() == 0 || pot.@minmed <= gg.pers.medic)) {
					var hhp:int = 0;
					if (pot.@horgan.length()) hhp = pot.@horgan;
					var razn:int = Math.abs(hhp - nhp + 25);
					if (razn < minRazn) {
						minRazn = razn;
						nci = pot.@id;
					}
				}
			}
			
			return nci;
		}
		
		public function usePotion(ci:String=null, norgan:int=0):Boolean {
			var hhp:Number = 0; 
			var hhplong:Number = 0;
			var pot;
			var pet:UnitPet;
			var need1=gg.maxhp-gg.hp-gg.rad;	//нужда с учётом фактического здоровья
			var need2=need1-gg.healhp;			//нужда с учётом принятых зелий
			
			if (ci!=null && ci!='mana' && items[ci].kol<=0) {
				return false;
			}
			
			if (ci==null && need2<1) {
				World.w.gui.infoText('noHeal');
				if (gg.rad>1) World.w.gui.infoText('useAntirad');
				return false;
			}
			
			if (ci == null) {	//применить наиболее подходящее зелье
				var minRazn:Number = 10000;
				var nci:String = '';
				for each (pot in itemList) {
					if (pot.@heal=='hp' && items[pot.@id].kol>0) {
						hhp=0;
						if (pot.@hhp.length()) hhp+=pot.@hhp*gg.pers.healMult;
						if (pot.@hhplong.length()) hhp+=pot.@hhplong*gg.pers.healMult;
						
						var razn = Math.abs(hhp-need2);
						
						if (razn < minRazn) {
							minRazn = razn;
							nci=pot.@id;
						}
					}
				}
				if (nci=='') {	//нет подходящего
					World.w.gui.infoText('noSuitablePot');
					return false;
				}
				else {
					ci = nci;
				}
			}
			if (ci == 'mana') {	//применить наиболее подходящее зелье маны
				var minRazn:Number=10000;
				need1=gg.pers.inMaxMana-gg.pers.manaHP;
				
				if (need1 < 1) {
					return false;
				}
				
				var nci:String='';
				
				for each (pot in itemList) {
					if (pot.@heal=='mana' && items[pot.@id].kol>0) {
						hhp=0;
						if (pot.@hmana.length()) hhp=pot.@hmana;
						var razn=Math.abs(hhp-need1);
						if (razn<minRazn) {
							minRazn=razn;
							nci=pot.@id;
						}
					}
				}
				
				if (nci == "") {	//нет подходящего
					World.w.gui.infoText('noSuitablePot');
					return false;
				}
				else {
					ci = nci;
				}
			}
			if (ci=='potion_swim') {
				gg.h2o=1000;
			}
			
			pot = itemList.(@id==ci);
			
			if (pot.length()==0) {
				return false;
			}
			
			if (World.w.alicorn) {
				if (pot.@tip=='pot' || pot.@tip=='him' || pot.@tip=='food') {
					World.w.gui.infoText('alicornNot',null,null,false);
					return false;
				}
			}
			
			if (pot.@heal=='rad' && gg.rad < 1) {
				World.w.gui.infoText('noMedic',Res.txt('i',ci));
				return false;
			}
			else if (pot.@heal=='poison' && gg.poison < 0.1) {
				World.w.gui.infoText('noMedic',Res.txt('i',ci));
				return false;
			}
			else if (pot.@heal=='blood' && (gg.pers.inMaxHP-gg.pers.bloodHP < 1)) {
				World.w.gui.infoText('noMedic',Res.txt('i',ci));
				return false;
			}
			else if (pot.@heal=='organ' && (gg.pers.inMaxHP-gg.pers.headHP<1) && (gg.pers.inMaxHP-gg.pers.torsHP<1) && (gg.pers.inMaxHP-gg.pers.legsHP<1)) {
				World.w.gui.infoText('noHeal');
				return false;
			}
			else if (pot.@heal=='mana' && (gg.pers.inMaxMana-gg.pers.manaHP < 1)) {
				World.w.gui.infoText('noMedic',Res.txt('i',ci));
				return false;
			}
			else if (pot.@heal=='pet') {		//лечение феникса
				pet=gg.pets[pot.@pet];
				if (pet==null || pet.maxhp-pet.hp<1) {
					World.w.gui.infoText('noMedic',Res.txt('i',ci));
					return false;
				}
			}
			
			//проверить соответствие уровню навыка
			if (pot.@minmed.length() && pot.@minmed>gg.pers.medic) {
				 World.w.gui.infoText('needSkill',Res.txt('e','medic'),pot.@minmed);
				  return false;
			}
			
			if (pot.@heal=='detoxin') {
				var limAddict:int=pot.@detox;
				for (var j=0; j<5; j++) {
					for (var ad in World.w.pers.addictions) {
						if (World.w.pers.addictions[ad]>0) {
							var redAddict=Math.round(Math.random()*50+25);
							if (redAddict>World.w.pers.addictions[ad]) {
								limAddict-=World.w.pers.addictions[ad];
								World.w.pers.addictions[ad]=0;
							}
							else {
								limAddict-=redAddict;
								World.w.pers.addictions[ad]-=redAddict;
							}
						}
						if (limAddict<=0) break;
					}
					if (limAddict<=0) break;
				}
				for each(var eff:Effect in owner.effects) {
					if (eff.him==1 || eff.him==2) {
						eff.unsetEff(false,true,false);
					}
				}
				gg.setAddictions();
				gg.pers.setParameters();
			}
			
			hhp=hhplong=0;
			
			if (pot.@hhp.length()) hhp=pot.@hhp*gg.pers.healMult;
			
			if (pot.@hhplong.length()) hhplong=pot.@hhplong*gg.pers.healMult;
			
			gg.heal(hhp,0,false);
			gg.heal(hhplong,1,false);
			
			if (hhp+hhplong>0) gg.numbEmit.cast(gg.loc, gg.coordinates.X, gg.coordinates.Y - gg.boundingBox.halfHeight, {txt:Math.round(hhp+hhplong), frame:4, rx:20, ry:20});
			
			if (pot.@hrad.length()) gg.heal(pot.@hrad*gg.pers.healMult,2);
			
			if (pot.@hpoison.length()) gg.heal(pot.@hpoison, 4, false);
			
			if (pot.@hcut.length()) gg.heal(pot.@hcut, 3, false);
			
			if (pot.@horgan.length()) gg.pers.heal(pot.@horgan,norgan);
			
			if (pot.@horgans.length()) gg.pers.heal(pot.@horgans,4);
			
			if (pot.@hblood.length()) gg.pers.heal(pot.@hblood,5);
			
			if (pot.@hmana.length()) gg.pers.heal(pot.@hmana, 6);
			
			if (pot.@hpurif.length()) {
				for each(var eff:Effect in owner.effects) {
					if (eff.tip==4) {
						eff.unsetEff(false,true,false);
					}
				}
				gg.remEffect('curse');
				World.w.game.triggers['curse']=0;
				gg.pers.setParameters();
			}
			
			if (pot.@hpet.length()) {
				pet=gg.pets[pot.@pet];
				pet.heal(pot.@hpet, 0);
			}
			
			if (pot.@perk.length()) {
				gg.pers.addPerk(pot.@perk);
			}
			
			if (pot.@effect.length()) {
				var eff:Effect=gg.addEffect(pot.@effect);
				if (pot.@tip=='him') {
					if (gg.pers.himLevel>0) {
						eff.lvl=gg.pers.himLevel;
						gg.pers.setParameters();
					}
					eff.t*=gg.pers.himTimeMult;
				}
			}
			
			if (pot.@alc.length()) {
				gg.addEffect('drunk',0,pot.@alc*10);
			}
			
			if (pot.@rad.length()) {
				gg.drad2+=pot.@rad*1;
			}
			
			if (pot.@ad.length()) {
				var n1:int=pot.@admin;
				var n2:int=pot.@admax;
				var n:int=Math.round(Math.random()*(n2-n1)+n1)*gg.pers.himBadMult*gg.pers.himBadDif;
				if (gg.pers.addictions[pot.@ad]==null) gg.pers.addictions[pot.@ad]=0;
				var prev:int=gg.pers.addictions[pot.@ad];
				gg.pers.addictions[pot.@ad]+=n;
				if (gg.pers.addictions[pot.@ad]>gg.pers.admax) gg.pers.addictions[pot.@ad]=gg.pers.admax;
				if (prev<gg.pers.ad3 && prev+n>=gg.pers.ad3) World.w.gui.infoText('addiction3',Res.txt('i',ci));
				else if (prev<gg.pers.ad2 && prev+n>=gg.pers.ad2) World.w.gui.infoText('addiction2',Res.txt('i',ci));
				else if (prev<gg.pers.ad1 && prev+n>=gg.pers.ad1) World.w.gui.infoText('addiction1',Res.txt('i',ci));
			}
			
			if (pot.@tip=='food') {
				if (pot.@ftip=='1') World.w.gui.infoText('usedfood2',Res.txt('i',ci));
				else World.w.gui.infoText('usedfood',Res.txt('i',ci));
			}
			else if (pot.@heal=='organ') {
				World.w.gui.infoText('usedheal',Res.txt('i',ci));
			}
			else {
				World.w.gui.infoText('heal',Res.txt('i',ci));
			}
			
			if (pot.@inf>0) return true;
			
			minusItem(ci);
			
			return true;
		}
		
		public function useItem(ci:String=null):Boolean {
			if (ci==null) {
				if (cItem < 0) {
					return false;
				}
				if (World.w.gui.t_item <= 0) {
					World.w.gui.setItems();
					return false;
				}
				else {
					ci=itemsId[cItem];
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
			if (items[ci].kol<=0) return false;
			var item=items[ci].xml;
			if (item==null) return false;
			var tip:String=item.@tip;
			if (item.@paint.length()) { // [Paint]
				gg.changePaintWeapon(item.@id,item.@paint,item.@blend);
				World.w.gui.infoText('inUse',items[ci].nazv);
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
				} else {
					gg.pers.upSkill(ci);
				}
				items['lbook'].kol++;
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
				World.w.gui.infoText('changeDif',Res.guiText('dif'+item.@chdif));
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
		}
		
		public function useFav(n:int):void {
			// This function is called with an integer (assumed 1-9) and that's used as an index to get the ID of the item for that number
			var ci:String = fav[n];
			
			// Index returned nothing, abort
			if (ci == null) {
				return;
			}
			
			var ID:String;

			// Check the weaponlist for the ID we retrieved
			ID = itemManager.getWeapon(ci).id;
			if (ID) {
				gg.changeWeapon(ci);
				return;
			}
			
			// We didn't find it, check the armorList for the ID
			ID = armorList.(@id == ci);
			if (ID) {
				gg.changeArmor(ci);
				return;
			}
			
			// We still didn't find it, check the itemList for the ID
			ID = itemList.(@id == ci);
			if (ID) {
				useItem(ci);
			}
			else {
				trace("Invent.as/useFav() - Tried to use favorite item: " + ci);
			}
		}
		
		public function addWeapon(id:String, hp:int = 0xFFFFFF, hold:int = 0, respect:int = 0, nvar:int = 0):Weapon {
			if (id == null) {
				return null;
			}
			
			if (weapons[id]) {
				weapons[id].repair(hp);
				return weapons[id];
			}

			var w:Weapon = Weapon.create(owner, id, nvar);

			if (w == null) {
				return null;
			}
			
			if (w.tip == 5 || hp == 0xFFFFFF) {
				w.hp = w.maxhp;
			}
			else {
				w.hp=hp;
			}
			
			if (hold > 0) {
				w.hold = hold;
			}

			if (w.tip == 4 && respect == 3) {
				respect=0;
			}
			
			w.respect = respect;
			weapons[id] = w;
			
			return w;
		}
		
		public function remWeapon(id:String) {
			if (weapons[id]) {
				if (weapons[id] == gg.currentWeapon) {
					gg.changeWeapon(id, true);
				}
				
				if (weapons[id].hold > 0) {
					items[weapons[id].ammo].kol += weapons[id].hold;
					weapons[id].hold = 0;
				}
				
				if (items['s_' + id] && items['s_' + id].kol > 0) {
					weapons[id].respect = 3;
				}
				else {
					weapons[id] = null;
				}
			}
		}
		
		public function updWeapon(id:String, nvar:int){
			if (weapons[id]==null) addWeapon(id);
			weapons[id].updVariant(nvar);
		}
		
		//показать/скрыть оружие
		public function respectWeapon(id:String):int {
			var w:Weapon=weapons[id];
			if (w==null) return 2;
			if (w.respect==0 || w.respect==2) w.respect=1;
			else w.respect=2;
			if (gg.currentWeapon && gg.currentWeapon.respect==1) {
				gg.changeWeapon(gg.currentWeapon.id);
			}
			if (w.respect==1 && gg.currentSpell && gg.currentSpell.id==w.id) {
				gg.changeSpell('');
			}
			calcWeaponMass();
			return w.respect;
		}
		
		//ремонтировать оружие с помощью набора оружейника или деталей
		public function repWeapon(w:Weapon, koef:Number=1):Boolean {
			if (w && w.tip>0 && w.tip<4 && w.rep_eff>0) {
				if (w.hp<w.maxhp) {
					var hhp=w.maxhp*gg.pers.repairMult*w.rep_eff*koef;
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
		}
		
		public function repairWeapon(id:String, kol:int) {
			if (kol==undefined || isNaN(kol)) return;
			var hpw=(weapons[id] as Weapon).hp;
			var rep=Math.round(kol*gg.pers.repairMult);
			if (hpw<kol) rep=Math.round(kol-hpw+hpw*gg.pers.repairMult);
			(weapons[id] as Weapon).repair(rep);
			if (gg.pers.barahlo) {
				var n:Number=kol/(weapons[id] as Weapon).maxhp/(weapons[id] as Weapon).rep_eff;
				if ((weapons[id] as Weapon).rep_eff<=0) return;
				if (n<0.3) n=0.3;
				if (n<1 && n<Math.random()) return;
				n=Math.round(n);
				items['frag'].kol+=n;
				if(!World.w.testLoot) World.w.gui.infoText('take',Res.txt('i','frag')+((n>1)?(' ('+n+')'):''));
			}
		}

		public function favItem(id:String, cell:int) {
			if (gg && (cell==29 || cell==30)) {
				if (weapons[id]==null || (weapons[id].tip!=4 && weapons[id].tip!=5) || weapons[id].spell) {
					World.w.gui.infoText('onlyExpl');
					return;
				}
				if (cell==29) {
					if (gg.throwWeapon && id==gg.throwWeapon.id) gg.throwWeapon=null;
					else {
						gg.throwWeapon=weapons[id];
						gg.throwWeapon.setNull();
						gg.throwWeapon.setPers(gg,gg.pers);
						gg.throwWeapon.addVisual();
						if (gg.throwWeapon.tip==4) gg.throwWeapon.remVisual();
					}
				}
				if (cell==30) {
					if (gg.magicWeapon && id==gg.magicWeapon.id) gg.magicWeapon=null;
					else {
						gg.magicWeapon=weapons[id];
						gg.magicWeapon.setNull();
						gg.magicWeapon.setPers(gg,gg.pers);
						gg.magicWeapon.addVisual();
						if (gg.magicWeapon.tip==4) gg.magicWeapon.remVisual();
					}
				}
			}
			if (cell<29 && cell>=25) {
				var xml = itemList.(@id==id);
				if (xml.length()==0 || xml.@tip!='spell') {
					World.w.gui.infoText('onlySpell');
					return;
				}
			}
			var prevCell=favIds[id];
			var prevId=fav[cell];
			if (fav[prevCell]) fav[prevCell]=null;
			if (favIds[prevId]) favIds[prevId]=null;
			if (prevCell!=cell) {
				fav[cell]=id;
				favIds[id]=cell;
			}
		}
		
		public function addArmor(id:String, hp:int=0xFFFFFF, nlvl:int=0):Armor {
			if (armors[id]) {
				return null;
			}
			
			var node = armorList.(@id == id);
			
			if (!node) {
				return null;
			}
			
			var w:Armor = new Armor(id, nlvl);
			
			w.hp = hp;
			
			if (w.hp > w.maxhp) {
				w.hp = w.maxhp;
			}
			
			armors[id] = w;
			
			return w;
		}
		
		public function addSpell(id:String):Spell {
			if (id == null) {
				return null;
			}

			if (spells[id]) {
				return spells[id];
			}

			var sp:Spell = new Spell(owner, id);
			if (sp == null) return null;
			spells[id] = sp;
			var w:Weapon = addWeapon(id);
			w.spell = true;
			w.nazv = sp.nazv;
			return sp;
		}
		
		// Initializes the list of spells
		public function addAllSpells() {
			for each(var sp in itemList.(@tip == 'spell')) {
				addSpell(sp.@id);
			}
		}
		
		// [add to inventory, tr = 1 if the item was purchased, 2 if it was received as a reward]
		public function take(l:Item, tr:int = 0) {
			var kol:int = 0;
			var color:int = -1;
			
			if (l.tip == Item.L_WEAPON) {
				var patron = l.xml.a[0];
				if (tr == 0 && patron && patron != 'recharg') {
					kol = Math.floor(Math.random() * itemList.(@id == patron).@kol) + 1;
					items[patron].kol += kol;
				}

				var hp:int;
				if (l.variant > 0 && l.xml.char[l.variant].@maxhp.length()) {
					hp = Math.round(l.xml.char[l.variant].@maxhp * l.sost * l.multHP);
				}
				else {
					hp = Math.round(l.xml.char[0].@maxhp * l.sost * l.multHP);
				}
				
				if (weapons[l.id]) {
					if (weapons[l.id].variant < l.variant) {
						if (tr == 0 && !World.w.testLoot) World.w.gui.infoText('takeWeapon', l.nazv, Math.round(l.sost * l.multHP * 100));
						updWeapon(l.id, l.variant);
					}
					if (weapons[l.id].tip != 5) {
						repairWeapon(l.id, hp);
						if (!World.w.testLoot) World.w.gui.infoText('repairWeapon', weapons[l.id].nazv, Math.round(weapons[l.id].hp / weapons[l.id].maxhp * 100));
					}
				}
				else {
					if (tr==0 && !World.w.testLoot) World.w.gui.infoText('takeWeapon',l.nazv,Math.round(l.sost*l.multHP*100));
					addWeapon(l.id, hp, 0,0, l.variant);
					takeScript(l.id);
					if (owner.player && gg.currentWeapon==null) gg.changeWeapon(l.id);
				}
				if (l.shpun==2) weapons[l.id].respect=0;
				World.w.gui.setWeapon();
				World.w.calcMassW=true;
				color=5;
			}
			else if (l.tip==Item.L_ARMOR) {
				var hp:int=Math.round(l.xml.@hp*l.sost*l.multHP);
				addArmor(l.id, hp);
				color=3;
			}
			else if (l.tip==Item.L_SPELL) {
				plus(l,tr);
				World.w.calcMassW=true;
				color=5;
			}
			else if (l.tip==Item.L_SCHEME) {
				if (items[l.id].kol==0)	takeScript(l.id);
				plus(l,tr);
				if (tr<=1 && !World.w.testLoot) World.w.gui.infoText('take',l.nazv);
				if (l.xml && l.xml.@cat=='weapon' && weapons[l.id.substr(2)]==null) {
					addWeapon(l.id.substr(2), 0xFFFFFF, 0,3);
				}
				if (l.xml && l.xml.@cat=='armor' && armors[l.id.substr(2)]==null) {
					addArmor(l.id.substr(2), 0xFFFFFF, -1);
				}
				color=7;
			}
			else if (l.tip==Item.L_EXPL) {
				plus(l,tr);
				if (!weapons[l.id]) addWeapon(l.id);
				if (tr==0 && !World.w.testLoot) World.w.gui.infoText('take',l.nazv+((l.kol>1)?(' ('+l.kol+')'):''));
				color=3;
			}
			else if (l.tip==Item.L_AMMO)
			{
				plus(l, tr);
				if (tr == 0 && !World.w.testLoot) World.w.gui.infoText('takeAmmo', l.nazv, l.kol);
				color=3;
			}
			else if (l.tip==Item.L_MED) {
				plus(l, tr);
				
				if (tr==0 && !World.w.testLoot) World.w.gui.infoText('takeMed',l.nazv);
				
				if (cItem < 0) {
					nextItem(1);
				}
				else {
					World.w.gui.setItems();
				}
				
				color = 1;
			}
			else if (l.tip==Item.L_BOOK) {
				if (items[l.id].kol == 0) {
					takeScript(l.id);
				}
				
				plus(l, tr);
				
				if (tr <= 1 && !World.w.testLoot) World.w.gui.infoText('takeBook', l.nazv);
				
				if (cItem < 0) {
					nextItem(1);
				}
				else {
					World.w.gui.setItems();
				}
				
				color = 4;
			}
			else if (l.tip==Item.L_INSTR || l.tip==Item.L_ART || l.tip==Item.L_IMPL || l.xml && l.xml.sk.length()) {
				trace("Invent.as/take() - TYPE: INSTR, ART, IMPL, other????");
				if (items[l.id].kol==0)	takeScript(l.id);
				plus(l,tr);
				if (tr==0 && !World.w.testLoot) World.w.gui.infoText('take', l.nazv);
				gg.pers.setParameters();
				color=6;
			}
			else {
				if (!items[l.id] || items[l.id].kol == 0) {
					takeScript(l.id);
				}
				// Increment items in inventory
				plus(l, tr);
				if (tr == 0 && !World.w.testLoot) {
					if (l.id == 'money') { 
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
				
				if (l.tip=='valuables') color=2;
				else if (l.tip==Item.L_HIM || l.tip==Item.L_POT) color=1;
				else if (l.tip==Item.L_KEY || l.tip==Item.L_SPEC) color=6;
				else if (l.tip=='equip') color=8;
				else color=0;
			}
			if (tr == 2) {
				if (l.kol>1) World.w.gui.infoText('reward', l.nazv, l.kol);
				else World.w.gui.infoText('reward2', l.nazv);
			}

			// [if the object was generated randomly, update the limits]
			if (tr == 0 && l.imp == 0 && l.xml.@limit.length()) {
				World.w.game.addLimit(l.xml.@limit, 2);
			}

			// [pop-up message]
			if (!World.w.testLoot && (tr == 0 || tr == 2)) {
				if (l.fc >= 0) {
					color = l.fc;
				}
				
				World.w.gui.floatText(l.nazv + (l.kol > 1? (" (" + l.kol + ")") : ""), gg.coordinates.X, gg.coordinates.Y, color);
			}

			// [information window for important items]
			if (World.w.helpMess || l.tip == "art") {
				if (l.mess!=null && !(World.w.game.triggers["mess_"+l.mess]>0)) {
					World.w.game.triggers["mess_"+l.mess]=1;
					World.w.gui.impMess(Res.txt("i",l.mess),Res.txt("i",l.mess,2),l.mess);
				}
			}

			// [if the object is critical, confirm receipt]
			if (l.imp == 2 && l.cont) l.cont.receipt();

			var res:String=World.w.game.checkQuests(l.id);
			if (res != null) {
				World.w.gui.infoText("collect",res);
			}

			if (World.w.hardInv) mass[l.invCat] += l.mass * l.kol;
			World.w.calcMass = true;
		}
		
		private function plus(l:Item, tr:int = 0) {
			trace("Invent.as/plus() - Item ID: " + l.id + ", kol: " + l.kol + ", tr: " + tr);
			
			if (l.id != "money") {
				if (items[l.id].kol == 0) {
					items[l.id].nov = 1;
				}
				else if (items[l.id].nov == 0) {
					items[l.id].nov = 2;
				}
				items[l.id].dat = new Date().getTime();
			}
			
			if (tr == 1) {
				items[l.id].kol += l.bou;
				l.trade();
			}

			else items[l.id].kol += l.kol;
			
			// Don't have more than one of each blueprint or spell.
			if (l.tip==Item.L_SCHEME || l.tip==Item.L_SPELL) {
				items[l.id].kol = 1;
			}
		}
		
		// [Increase the number of items] | увеличить количество предметов
		public function plusItem(ci:String, n:int = 1) {
			if (items[ci] == null) {
				trace("Invent.as/plusItem() - ERROR: could not increase quantity of item: \"" + ci + "\"!");
				return;
			}
			
			if (ci != "money") {
				if (items[ci].kol == 0) {
					items[ci].nov = 1;
				}
				else if (items[ci].nov == 0) {
					items[ci].nov = 2;
				}
				
				items[ci].dat = new Date().getTime();
			}

			items[ci].kol += n;
		}
		
		// [Reduce the number of items]
		public function minusItem(ci:String, n:int=1, snd:Boolean=true) {
			if (items[ci]==null) {
				trace("Invent.as/minusItem() - Error while decrementing item count", ci);
				return;
			}

			if (items[ci].kol>=n) {
				items[ci].kol-=n;
			}
			else {
				items[ci].vault-=(n-items[ci].kol);
				items[ci].kol=0;
				if (items[ci].vault<0) items[ci].vault=0;
			}

			if (items[ci].kol == 0) {
				nextItem(1);
			}

			try {
				if (items[itemsId[cItem]] && items[itemsId[cItem]].kol==0) {
					cItem=-1;
				}
			}
			catch(err) {
				trace("ERROR: (00:5)");
			}
			if (snd && items[ci].xml && items[ci].xml.@uses.length()) {
				Snd.ps(items[ci].xml.@uses, owner.coordinates.X, owner.coordinates.Y);
			}
		}
		
		public function checkKol(ci:String, n:int=1):Boolean {
			if (World.w.loc && World.w.loc.base) {
				if (items[ci].kol+items[ci].vault>=n) return true;
				else return false;
			}
			else {
				if (items[ci].kol >= n) return true;
				else return false;
			}
			return false;
		}
		
		public function calcMass() {
			mass[1]=mass[2]=mass[3]=0;
			for each (var item:Item in items) {
				mass[item.invCat]+=item.mass*item.kol;
			}
			World.w.checkLoot=true;
			World.w.pers.invMassParam();
		}
		
		public function calcWeaponMass() {
			massW=0;
			massM=0;
			for each (var w:Weapon in weapons) {
				if (w == null) continue;
				if (w.tip > 0 && w.tip<4 && (w.respect==0 || w.respect==2)) massW+=w.mass;
				if (w.tip == 5 && (w.respect==0 || w.respect==2) && (!w.spell || items[w.id] && items[w.id].kol>0)) massM+=w.mass;
			}
			World.w.checkLoot=true;
			World.w.pers.invMassParam();
		}
		
		// [Destruction of equipment]
		public function damageItems(dam:Number, destr:Boolean=true) {
			if (!destr && !World.w.loc.base && !World.w.alicorn) dam=5;
			if (mass[1]<=World.w.pers.maxm1 || dam<=0) return;
			var kol=dam*(mass[1]-World.w.pers.maxm1)/800;
			if (kol>=1 || Math.random()<kol) {
				kol=Math.ceil(kol*Math.random());
				for (var i=1; i<20; i++) {
					var nid=eqip[Math.floor(Math.random()*eqip.length)];
					if (items[nid].kol>0) {
						if (destr) {
							minusItem(nid,kol,false);
							World.w.gui.infoText("itemDestr",items[nid].nazv, kol);
						}
						else {
							drop(nid,kol);
							World.w.gui.infoText("itemLose",items[nid].nazv, kol);
						}
						World.w.calcMass=true;
						return;
					}
				}
			}
		}
		
		
		// [Return a string representation of the occupied space]
		public function retMass(n:int):String {
			var txt:String;
			var cl:String="mass";
			var m:Number, maxm:Number;
			if (n>=1 && n<=3) {
				txt="allmass"+n;
				m=mass[n];
				maxm=gg.pers["maxm"+n];
			}
			else if (n==4) {
				txt="allweap";
				m=massW;
				maxm=gg.pers.maxmW;
			}
			else if (n==5) {
				txt="allmagic";
				m=massM;
				maxm=gg.pers.maxmM;
			}
			
			if (m>maxm) cl="red";
			
			return Res.pipText(txt) + ": <span class = \'" + cl + "\'>" + Res.numb(m) + "/" + Math.round(maxm) + "</span>";
		}
		
		// Drop items from inventory
		public function drop(nid:String, kol:int=1) {
			if (World.w.loc.base || World.w.alicorn) {
				return;
			}

			if (kol > items[nid].kol) {
				kol = items[nid].kol;
			}
			
			if (kol <= 0) {
				return;
			}
			
			var item:Item = new Item(null, nid, kol);
			var loot:Loot = new Loot(World.w.loc, item, owner.coordinates.X, owner.coordinates.Y - owner.boundingBox.halfHeight, true, false, false);
			
			minusItem(nid, kol, false);
		}
		
		// Call attached script
		public function takeScript(id:String) {
			trace("Invent.as/takeScript() - Running script ID: \"" + id + "\" attached to item");
			if (World.w.land.itemScripts[id]) {
				World.w.land.itemScripts[id].start();
			}
			else {
				trace("ERROR: (00:54) - script ID: \"" + id + "\" not found!");
			}
		}
		
		// [Calculate the number of cartridges based on their base]
		public function getKolAmmos() {
			for (var s in ammos) ammos[s]=0;
			for each (var ammo:Item in items) {
				if (ammo.base!='') ammos[ammo.base]+=ammo.kol;
			}
		}
		
		// [Smoke a joint]
		private function useRollup():Boolean {
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
		}
		
		// Add only the default armor to the player (used in the beginning of the game)
		public function addBegin() { // TODO: Stupid, turn into a script.
			trace("Invent.as/addBegin() - Adding starting armor set to player.");
			addArmor('pip');
			cArmorId = 'pip';
		}

		public function addAllWeapon() { // TODO: Stupid, turn into a script.
			var w;
			for each (w in LootGen.arr['weapon']) addWeapon(w.id);
			for each (w in LootGen.arr['e']) addWeapon(w.id);
			for each (w in LootGen.arr['magic']) addWeapon(w.id);
		}

		public function addAllAmmo() { // TODO: Stupid, turn into a script.
			var w;
			for each (w in LootGen.arr['a']) items[w.id].kol=10000;
			for each (w in LootGen.arr['e']) items[w.id].kol=10000;
		}

		public function addAllItem() { // TODO: Stupid, turn into a script.
			var w;
			for each (w in LootGen.arr['med']) items[w.id].kol=1000;
			for each (w in LootGen.arr['compa']) items[w.id].kol=1000;
			for each (w in LootGen.arr['him']) items[w.id].kol=1000;
			for each (w in LootGen.arr['book']) items[w.id].kol=10;
			for each (w in LootGen.arr['scheme']) take(new Item(Item.L_SCHEME,w.id));
			for each (w in LootGen.arr['spell']) take(new Item(Item.L_SPELL,w.id));
			for each (w in LootGen.arr['compw']) items[w.id].kol=100;
			for each (w in LootGen.arr['compe']) items[w.id].kol=100;
			for each (w in LootGen.arr['compm']) items[w.id].kol=100;
			for each (w in LootGen.arr['compp']) items[w.id].kol=1000;
			for each (w in LootGen.arr['stuff']) items[w.id].kol=1000;
			for each (w in LootGen.arr['paint']) items[w.id].kol=1;
			for each (w in LootGen.arr['pot']) items[w.id].kol=100;
			for each (w in LootGen.arr['food']) items[w.id].kol=100;
			items['stealth'].kol = 1000;
			items['potHP'].kol = 1000;
			items['rep'].kol = 1000;
			items['sphera'].kol = 100;
			items['screwdriver'].kol = 1;
		}

		// TODO: Stupid, turn into a script.
		public function addAllArmor() {
			for each(var arm in armorList) {
				addArmor(arm.@id);
			}
		}
		
		// TODO: Stupid, turn into a script.
		public function addAll() {
			addAllWeapon();
			addAllAmmo();
			addAllItem();
			addAllArmor();
		}

		// TODO: Stupid, turn into a script.
		public function addLoad(obj:Object) {
			if (obj == null) return;

			var w;

			for each(w in obj.weapons) {
				var weap:Weapon=addWeapon(w.id,w.hp,w.hold,w.respect,w.variant);
				if (w.ammo) weap.setAmmo(w.ammo, items[w.ammo].xml);
			}

			for each(w in obj.armors) {
				addArmor(w.id,w.hp,w.lvl);
			}

			for (w in obj.items) {
				if (items[w]) items[w].kol=obj.items[w];
				if (isNaN(items[w].kol)) items[w].kol=0;
				if (obj.vault && obj.vault[w]>0) items[w].vault=obj.vault[w];
			}

			for (w in obj.fav) {
				favItem(obj.fav[w],w);
			}

			cWeaponId=obj.cWeaponId;
			cArmorId=obj.cArmorId;
			cAmulId=obj.cAmulId;
			cSpellId=obj.cSpellId;
			prevArmor=obj.prevArmor;
			if (prevArmor == null) prevArmor = '';
		}

		public function save():Object {
			var obj:Object = new Object;
			obj.weapons = [];
			obj.armors = [];
			obj.fav = [];
			obj.items = [];
			obj.vault = [];
			
			var w;

			for (w in weapons) {
				if (weapons[w] is Weapon) obj.weapons[w]={id:weapons[w].id, hp:weapons[w].hp, hold:weapons[w].hold, ammo:weapons[w].ammo, respect:weapons[w].respect, variant:weapons[w].variant};
			}
			for (w in armors) {
				if (armors[w] is Armor) obj.armors[w]={id:armors[w].id, hp:armors[w].hp, lvl:armors[w].lvl};
			}
			for (w in fav) {
				obj.fav[w] = fav[w];
			}
			for (w in items) {
				if (w != '') {
					obj.items[w] = items[w].kol;
					if (items[w].vault > 0) obj.vault[w] = items[w].vault;
				}
			}

			if (gg.currentWeapon) {
				obj.cWeaponId = gg.currentWeapon.id;
			}
			else {
				obj.cWeaponId = '';
			}
			if (gg.currentArmor) {
				obj.cArmorId = gg.currentArmor.id;
			}
			else {
				obj.cArmorId = '';
			}
			if (gg.currentAmul) {
				obj.cAmulId = gg.currentAmul.id;
			}
			else {
				obj.cAmulId = '';
			}
			if (gg.currentSpell) {
				obj.cSpellId = gg.currentSpell.id;
			}
			else {
				obj.cSpellId = '';
			}
			
			obj.prevArmor = gg.prevArmor;
			
			return obj;
		}
	}
}
package fe.serv {
	
	import fe.*;
	import fe.loc.Loot;
	import fe.loc.Location;
	
	public class LootGen {

		// [Random objects]
		public static var arr:Array;
				
		private static var is_loot:int = 0;	// [Loot was generated]
		private static var loc:Location;	// [Target location]
		private static var nx:Number;
		private static var ny:Number;
		private static var lootBroken:Boolean = false;
		
		public static function init():void
		{
			arr = [];
			var n:Array = [];

			n['weapon'] = 0;
			arr['weapon'] = [];
			arr['magic'] = [];
			arr['uniq'] = [];
			arr['pers'] = [];

			var weaponList:XMLList = XMLDataGrabber.getNodesWithName("core", "AllData", "weapons", "weapon");
			for each (var weap in weaponList.(@tip > 0 && @tip < 4)) {
				if (weap.com.length()==0) continue;
				arr['weapon'].push({id:weap.@id, st:weap.com.@stage, chance:weap.com.@chance, worth:weap.com.@worth, lvl:weap.@lvl, r:(n['weapon']+=Number(weap.com.@chance))});
				if (weap.com.@uniq.length()) arr['uniq'].push({id:weap.@id+'^1', st:weap.com.@stage, chance:weap.com.@uniq, worth:weap.com.@worth, lvl:weap.@lvl, r:(n['uniq']+=Number(weap.com.@uniq))});
			}
			for each (weap in weaponList.(@tip==5)) {
				arr['magic'].push({id:weap.@id, st:0, chance:0, worth:0, lvl:0, r:0});
			}
			weaponList = null; // Manual cleanup.

			var itemList:XMLList = XMLDataGrabber.getNodesWithName("core", "AllData", "items", "item");
			for each (var item in itemList) {
				if (item.@tip.length()) {
					if (arr[item.@tip] == null) {
						arr[item.@tip] = [];
						n[item.@tip] = 0;
					}
					arr[item.@tip].push({id:item.@id, st:item.@stage, chance:(item.@chance.length()?item.@chance:1), lvl:item.@lvl,  r:(n[item.@tip]+=Number(item.@chance.length()?item.@chance:1))});
					if (item.@tip=='art' || item.@tip=='impl' || item.sk.length()) arr['pers'].push(item.@id);	//признак предметов, изменяющих характеристики перса
				}
				if (item.@tip2.length()) {
					if (arr[item.@tip2] == null) {
						arr[item.@tip2] = [];
						n[item.@tip2] = 0;
					}
					arr[item.@tip2].push({id:item.@id, st:item.@stage, chance:(item.@chance2.length()?item.@chance2:item.@chance), lvl:item.@lvl,  r:(n[item.@tip2]+=Number(item.@chance2.length()?item.@chance2:item.@chance))});
				}
			}
			itemList = null; // Manual cleanup
		}
		
		public static function getRandom(lootType:String, maxlvl:Number=-100, worth:int=-100):String {
			
			var a:Array = arr[lootType];
			if (a == null) {
				return null;
				trace("LootGen.as/getRandom() - Something went wrong while generating random loot drops, aborting");
			}

			var res:Array = [];
			var n:Number = 0;

			var gameStage:int = 0
			if (World.w.land) {
				gameStage = World.w.land.gameStage;
			}

			if (lootType != Item.L_BOOK && (maxlvl > 0 || worth > 0 || gameStage > 0)) {
				for each(var i in a) {
					if (
						(gameStage <= 0 || i.st == null || i.st <= gameStage) &&	//зависит от этапа сюжета
						(maxlvl == -100 || i.lvl == null || i.lvl <= maxlvl) &&		//максимальный уровень, зависит от сложности
						(worth == -100 || i.worth == null || worth == i.worth)		//тип предмета, зависит от типа контейнера
					) {
						res.push({id:i.id, r:(n += Number(i.chance))});
					}
				}
			}
			else {
				res = a;
			}

			// Couldn't find it, return null
			if (res.length == 0) {
				return null;
			}

			// Found exactly one match, return it
			if (res.length == 1) {
				return res[0].id;
			}

			n = Math.random() * res[res.length - 1].r;
			for each(i in res) {
				if (i.r > n) return i.id;
			}

			// Failsafe, return nothing
			return null;
		}
		
		//create random, if id == null, or specified loot
		//if the request exceeds the limit, do not create loot, return false
		private static function newLoot(rnd:Number, lootType:String, id:String = null, itemCount:int = -1, imp:int = 0, cont:Interact = null):Boolean {
			
			//trace("LootGen.as/newLoot() - Generating a new loot item. Item id: " + id + ", lootType: " + lootType +", (" + itemCount + ")");
			if (rnd < 1 && Math.random() > rnd) {
				return false;
			}

			var mn:Number = 1;

			if (lootBroken) {
				mn = 0.4;
			}

			if (lootType == Item.L_WEAPON) {
				// [Random weapons]
				if (int(id) > 0) {
					id = getRandom(lootType, Math.max(1,loc.weaponLevel+(Math.random()*2-1)),int(id));
					if (id == null) mn *= 0.5;
				}
				if (id == null) {
					id = getRandom(lootType, Math.max(1, loc.weaponLevel + (Math.random() * 2 - 1)));
					if (id == null) mn *= 0.5;
				}
				if (id == null) {
					id = getRandom(lootType);
				}
			}

			// [Random loot, determine the desired id]
			if (id == null || id == '') {
				if (lootType == Item.L_EXPL || lootType == Item.L_UNIQ) {
					id = getRandom(lootType, Math.max(1, loc.weaponLevel + (Math.random() * 2 - 1)));
				}
				else {
					id = getRandom(lootType, Math.max(1, loc.locDifLevel / 2 + (Math.random() * 2 - 1)));
				}
				if (id == null) {
					id = getRandom(lootType);
				}
			}

			if (id == null) {
				trace('LootGen.as/newLoot() - Error when generating loot type:', lootType);
				return false;
			}

			var iCount:int = -1; // Temp variable since itemCount could be modified
			if (itemCount != -1) {
				iCount = itemCount;
			}	
			// If no amount of items was specified or it's a unique item, spawn 1 of the item
			if (itemCount == -1 && lootType == Item.L_UNIQ) {
				iCount = 1;
			}
			trace("iCount: " + iCount);
			// Spawn the item
			var item:Item = new Item(lootType, id, iCount);
			if (item.xml != null) {
				//trace("LootGen.as/newLoot() - Created new item, XML Data: " + item.xml.toXMLString());
				//trace("LoostGen.as/newLoot() - Item info -- ID: " + item.id + ", name: " + item.nazv  + ", kol: " + item.kol);
			}
			else {
				trace("LootGen.as/newLoot() - ERROR: Created new item with no XML data");
			}

			if (lootType == 'eda') {
				item.tip = 'food';
			}
			if (lootType == 'co') {
				item.tip = 'scheme';
				var wid:String = id.substr(2);
				item.nazv = Res.pipText('recipe') + ' «' + Res.txt('i', wid) + '»';
			}

			item.multHP = mn;
			item.imp = imp;
			item.cont = cont;

			// Reduce rewards for containers that were broken into instead of unlocked
			if (item.id == 'money') {	//множитель крышек
				item.kol *= (World.w.pers.capsMult * World.w.pers.difCapsMult);
			}	
			if (item.id == 'bit') {		//множитель крышек
				item.kol *= (World.w.pers.bitsMult * World.w.pers.difCapsMult);
			}	
			if (lootBroken && (item.id == 'money' || item.id == 'bit')) {
				item.kol *= 0.5;
			}
			if (lootBroken && (item.tip == Item.L_AMMO || item.tip == Item.L_EXPL) && Math.random() < 0.5) {
				return false;
			
			}
			// [Check limits]
			if (imp == 0 && item.xml.@limit.length()) {
				var lim:int = World.w.game.getLimit(item.xml.@limit);
				var itemLimit:Number = World.w.land.lootLimit;
				if (item.xml.@mlim.length()) itemLimit *= item.xml.@mlim;
				if (item.xml.@maxlim.length() && lim >= item.xml.@maxlim) {
					if (!World.w.testLoot) trace("Maximum loot amount reached for item: " + id + ", amount: " + lim);
					return false;
				}
				if (lim >= itemLimit) {
					if (!World.w.testLoot) trace("Maximum loot amount reached for item: " + id + ", amount: " + itemLimit);
					return false;
				}
				World.w.game.addLimit(item.xml.@limit,1);
			}
			if (World.w.testLoot) {
				trace("LootGen.as/newLoot() - is calling the Invent.as()/take function because World.testLoot is true");
				World.w.invent.take(item);
			}
			else {
				new Loot(loc, item, nx, ny, true);
			}
			is_loot++;
			return true;
		}
		
		// [Generate loot based on a given ID]
		public static function lootId(nloc:Location, nnx:Number, nny:Number, id:String, itemCount:int = -1, imp:int = 0, cont:Interact = null, broken:Boolean = false):void {
			if (nloc == null) {
				return;
			}

			lootBroken = broken;
			loc = nloc;
			nx = nnx;
			ny = nny;
			newLoot(1, '', id, itemCount, imp, cont);
		}
		
		// [Generate loot from a given container type, returns true if something was generated]
		// [lockDifficulty - difficulty of locks, takes a value from 0 to 49]
		public static function lootCont(nloc:Location, nnx:Number, nny:Number, cont:String, broken:Boolean=false, lockDifficulty:Number=0):Boolean {
			if (nloc == null) {
				return false;
			}

			lootBroken = broken;
			loc = nloc;
			nx = nnx;
			ny = nny;
			is_loot = 0;
			
			var locdif:Number = Math.min(loc.locDifLevel, 20);
			var itemCount:int = 1;

			// TODO: Turn this into a loot table
			if (cont=='ammo') {
				newLoot(0.70, Item.L_AMMO);
				newLoot(0.25, Item.L_AMMO);
				newLoot(0.15, Item.L_AMMO);
				if (World.w.pers.freel) {
					newLoot(0.70,Item.L_AMMO);
				}
			}
			else if (cont=='metal') {		// Metal detector
				if (!newLoot(0.5, Item.L_ITEM, 'money', Math.random()*30*(locdif*0.15+1)+5)) newLoot(1,Item.L_AMMO);
			}
			else if (cont=='bomb') {
				itemCount=3;
				for (var i = 0; i < itemCount; i++) newLoot(1, Item.L_EXPL, 'dinamit');
			}
			else if (cont=='expl') {
				itemCount=Math.floor(Math.random()*4-1);
				for (var i=0; i<=itemCount; i++) newLoot(1, Item.L_EXPL);
				newLoot(0.5, Item.L_COMPE);
				if (World.w.pers.freel) newLoot(0.5,Item.L_EXPL);
			}
			else if (cont=='bigexpl') {
				itemCount=Math.floor(Math.random()*4+2);
				for (var i=0; i<=itemCount; i++) newLoot(1, Item.L_EXPL);
				if (World.w.pers.freel) newLoot(0.5,Item.L_EXPL);
				newLoot(0.5, Item.L_COMPE);
			}
			else if (cont=='wbattle') {
				if (!newLoot(0.04, Item.L_UNIQ)) {
					if (Math.random()<Math.min(locdif/5,0.7)) newLoot(1, Item.L_WEAPON,'4',1);
					else newLoot(1, Item.L_WEAPON,'3',1);
				}
				newLoot(0.8, Item.L_AMMO);
				if (World.w.pers.freel) newLoot(0.5,Item.L_AMMO);
				newLoot(0.1,Item.L_ITEM,'stealth');
				if (World.w.pers.barahlo) newLoot(0.1, Item.L_COMPA, 'intel_comp');
			}
			else if (cont=='case') {
				newLoot(0.9, Item.L_ITEM,'money',Math.random()*20*(locdif*0.11+1)+5);
			}
			else if (cont=='wbig') {
				if (!newLoot(0.08, Item.L_UNIQ)) {
					if (Math.random()<0.5) newLoot(1, Item.L_WEAPON,'5',1);
					else newLoot(1, Item.L_WEAPON,'4',1);
				}
				newLoot(0.5,Item.L_EXPL,'',Math.floor(Math.random()*4));
				newLoot(0.5,Item.L_AMMO,'',Math.floor(Math.random()*4));
				if (World.w.pers.freel) newLoot(0.5,Item.L_AMMO);
				if (World.w.pers.barahlo) newLoot(0.5, Item.L_COMPA, 'intel_comp');
			}
			else if (cont=='robocell') {
				newLoot(1, Item.L_COMPM);
			}
			else if (cont=='instr') {
				newLoot(0.1, Item.L_ITEM,'pin',Math.floor(Math.random()*5+1)); 
				if (!newLoot(0.35, Item.L_WEAPON,'2',1)) newLoot(0.5, Item.L_ITEM,'rep');
				newLoot(0.85, Item.L_COMPA);
				newLoot(0.7, Item.L_COMPW);
				newLoot(0.1, Item.L_COMPE);
				newLoot(0.5, Item.L_COMPM);
				newLoot(0.5, Item.L_PAINT);
				if (World.w.pers.barahlo) {
					newLoot(0.85, Item.L_COMPA);
					newLoot(0.7, Item.L_COMPW);
					newLoot(0.1, Item.L_COMPE);
					newLoot(0.1, Item.L_COMPE);
					newLoot(0.5, Item.L_COMPA);
				}
			}
			else if (cont=='instr2') {
				newLoot(0.1, Item.L_ITEM,'pin',Math.floor(Math.random()*5+1)); 
				if (!newLoot(0.35, Item.L_WEAPON,'2',1)) newLoot(0.5, Item.L_ITEM,'rep');
				newLoot(0.75, Item.L_COMPA);
				newLoot(0.4, Item.L_COMPW);
				newLoot(0.5, Item.L_COMPM);
				newLoot(0.2, Item.L_PAINT);
				if (World.w.pers.barahlo) {
					newLoot(0.75, Item.L_COMPA);
					newLoot(0.4, Item.L_COMPW);
					newLoot(0.1, Item.L_COMPE);
					newLoot(0.5, Item.L_COMPA);
				}
			}
			else if (cont=='trash') {
				if (loc.land.act.biom==0) newLoot(0.25, Item.L_FOOD, 'radcookie');
				if (Math.random()<0.25) {
					if (Math.random()<0.6) loc.createUnit('tarakan',nx,ny,true);
					else loc.createUnit('rat',nx,ny,true);
				} else {
					itemCount=Math.floor(Math.random()*2);
					if (World.w.pers.barahlo) itemCount+=2;
					for (i=0; i<=itemCount; i++) newLoot(1, Item.L_STUFF);
					newLoot(0.4, Item.L_ITEM,'money',Math.random()*10*(locdif*0.1+1)+5);
				}
			}
			else if (cont=='fridge') {
				newLoot(0.5, Item.L_FOOD, 'sparklecola');
				newLoot(0.5, Item.L_FOOD, 'sars');
				newLoot(0.1, Item.L_FOOD, 'radcola');
				if (Math.random()<0.2) {
					if (Math.random()<0.4) loc.createUnit('tarakan',nx,ny,true);
					else if (Math.random()<0.5) loc.createUnit('rat',nx,ny,true);
					else loc.createUnit('bloat',nx,ny,true);
				} else {
					itemCount=Math.floor(Math.random()*2);
					for (i=0; i<=itemCount; i++) newLoot(1, Item.L_FOOD);
					newLoot(0.3, Item.L_COMPP, 'herbs',Math.floor(Math.random()*6+1));
				}
			}
			else if (cont=='food') {
				if (loc.land.act.biom==0) newLoot(0.25, Item.L_FOOD, 'radcookie');
				if (Math.random()<0.25) {
					if (Math.random()<0.6) loc.createUnit('tarakan',nx,ny,true);
					else loc.createUnit('rat',nx,ny,true);
				} else {
					newLoot(0.8, Item.L_FOOD);
					newLoot(0.5, Item.L_STUFF);
					newLoot(0.2, Item.L_COMPP, 'herbs',Math.floor(Math.random()*6+1));
					newLoot(0.05, 'co');
				}
			}
			else if (cont=='med') {
				newLoot(0.05, Item.L_ITEM,'pin',Math.floor(Math.random()*2+1)); 
				itemCount=Math.floor(Math.random()*3-1);
				for (i=0; i<=itemCount; i++) newLoot(1, Item.L_MED);
				newLoot(0.25, Item.L_HIM);
				newLoot(0.03, Item.L_MED, 'firstaid');
				newLoot(0.05, Item.L_POT, 'potHP');
				newLoot(0.25, Item.L_ITEM, 'gel');
			}
			else if (cont=='med2') {
				newLoot(0.75, Item.L_POT, 'potHP');
				itemCount=Math.floor(Math.random()*3);
				for (i=0; i<=itemCount; i++) newLoot(1, Item.L_MED);
				newLoot(1, Item.L_HIM);
				newLoot(0.5, Item.L_MED, 'firstaid');
				newLoot(0.5, Item.L_MED, 'doctor');
				newLoot(0.5, Item.L_MED, 'surgeon');
				newLoot(0.8, Item.L_ITEM, 'gel');
			}
			else if (cont=='table') {
				newLoot(0.1, Item.L_ITEM,'pin',Math.floor(Math.random()*3+1)); 
				if (!newLoot(0.08, Item.L_BOOK)) newLoot(0.5, Item.L_ITEM,'money',Math.random()*50+5+3*locdif);
				newLoot(0.1, Item.L_FOOD);
				newLoot(0.13,Item.L_WEAPON,'3');
				newLoot(0.3,Item.L_AMMO);
				newLoot(0.1, Item.L_ITEM,'dart');
				newLoot(0.1, Item.L_ITEM,'app');
				newLoot(0.04, Item.L_SCHEME);
				newLoot(0.25, Item.L_FOOD);
				newLoot(0.08, 'co');
				newLoot(0.1, Item.L_MED, 'potm1')
			}
			else if (cont=='filecab') {
				newLoot(0.1, Item.L_ITEM,'pin',Math.floor(Math.random()*3+1)); 
				newLoot(0.5, Item.L_ITEM,'money',Math.random()*20);
				newLoot(0.1, Item.L_ITEM,'app');
				newLoot(0.02, Item.L_SCHEME);
				newLoot(0.08, 'co');
			}
			else if (cont=='cup') {
				newLoot(0.06, Item.L_ITEM,'pin',Math.floor(Math.random()*3+1)); 
				newLoot(0.3, Item.L_ITEM,'money',Math.random()*20);
				newLoot(0.25, Item.L_COMPA);
				newLoot(0.75, Item.L_STUFF);
				newLoot(0.2, Item.L_COMPA, 'kombu_comp');
				newLoot(0.2, Item.L_COMPA, 'antirad_comp');
				newLoot(0.2, Item.L_COMPA, 'antihim_comp');
			}
			else if (cont=='bloat') {
				loc.createUnit('bloat',nx,ny,true);
			}
			else if (cont=='book') {
				if (!newLoot(0.3, Item.L_BOOK)) newLoot(1, Item.L_ITEM,'lbook');
				newLoot(0.1, Item.L_ITEM,'gem'+Math.floor(Math.random()*3+1));
				newLoot(0.25, Item.L_SCHEME);
				newLoot(0.3, 'co');
				if (nloc.itemsTip=='bibl') newLoot(0.5, Item.L_ITEM, 'book_cm');
			}
			else if (cont=='term' || cont=='info') {
				if (nloc.land.act.id=='minst') newLoot(1,Item.L_ITEM,'datast');
				else if (!newLoot(0.25, Item.L_ITEM,'disc')) newLoot(1,Item.L_ITEM,'data');
				newLoot(0.5, Item.L_COMPM);
			}
			else if (cont=='cryo') {
				itemCount=Math.floor(Math.random()*3);
				for (var i=0; i<=itemCount; i++) newLoot(1, Item.L_ITEM,'pcryo');
				newLoot(0.5, Item.L_ITEM, 'gel');
			}
			else if (cont=='chest') {
				newLoot(0.1, Item.L_ITEM,'pin',Math.floor(Math.random()*5+1)); 
				newLoot(0.2, Item.L_WEAPON,'3',2);
				newLoot(0.2, Item.L_ITEM,'bit',Math.random()*50+7*locdif+2);
				newLoot(0.3, Item.L_ITEM,'gem'+Math.floor(Math.random()*3+1));
				newLoot(0.25, Item.L_COMPA);
				newLoot(0.03, Item.L_BOOK);
				newLoot(0.5, Item.L_AMMO);
				newLoot(0.03, Item.L_SCHEME);
				if (is_loot>5) replic('full');
				if (is_loot<2) replic('empty');
			}
			else if (cont=='safe') {
				if (World.w.land.rnd && nloc.prob==null && Math.random()<0.05) {
					for (i=0; i<4; i++) loc.createUnit('bloat',nx,ny,true);
				}
				else {
					newLoot(lockDifficulty/100, Item.L_UNIQ);
					newLoot(0.1+lockDifficulty/100, Item.L_ITEM,'sphera');
					newLoot(0.2+lockDifficulty/200, Item.L_ITEM,'stealth');
					newLoot(0.25+lockDifficulty/100, Item.L_ITEM,'gem'+Math.floor(Math.random()*3+1));
					newLoot(0.2, Item.L_MED);
					newLoot(0.25, Item.L_ITEM, 'retr');
					newLoot(0.1, Item.L_ITEM, 'runa');
					newLoot(0.1, Item.L_ITEM, 'reboot');
					newLoot(0.2+lockDifficulty/100, Item.L_BOOK);
					newLoot(0.1+lockDifficulty/100, Item.L_COMPP);
					newLoot(1, Item.L_ITEM,'bit',Math.random()*(lockDifficulty+10)*8+2+4*locdif);
					newLoot(0.1+lockDifficulty/300, Item.L_SCHEME);
					newLoot(0.25, Item.L_POT, 'potMP');
					newLoot(0.1, Item.L_POT, 'potHP');
					if (!newLoot(0.4, Item.L_MED, 'potm2')) newLoot(0.3, Item.L_MED, 'potm3')
					if (is_loot==0) newLoot(1, Item.L_ITEM,'gem'+Math.floor(Math.random()*3+1));
					if (is_loot>6) replic('full');
					if (is_loot<2) replic('empty');
				}
			}
			else if (cont=='specweap') {
				itemCount=Math.floor(Math.random()*4);
				var vars:Array = [];
				if (World.w.invent.weapons['lsword']==null || World.w.invent.weapons['lsword'].variant==0) vars.push('lsword^1');
				if (World.w.invent.weapons['antidrak']==null || World.w.invent.weapons['antidrak'].variant==0) vars.push('antidrak^1');
				if (World.w.invent.weapons['quick']==null || World.w.invent.weapons['quick'].variant==0) vars.push('quick^1');
				if (World.w.invent.weapons['mlau']==null || World.w.invent.weapons['mlau'].variant==0) vars.push('mlau^1');
				if (vars.length) newLoot(1, Item.L_WEAPON, vars[Math.floor(Math.random()*vars.length)]);
				else newLoot(1, Item.L_UNIQ);
			}
			else if (cont=='specalc') {
				newLoot(1, Item.L_SPEC,'alc7');
				newLoot(1, Item.L_ITEM,'gem'+Math.floor(Math.random()*3+1));
			}
			else if (cont=='speclp') {
				newLoot(1, Item.L_SPEC,'lp_item');
				newLoot(1, Item.L_ITEM,'gem'+Math.floor(Math.random()*3+1));
			}
			return is_loot > 0;
		}
		
		// [generation of loot dropped from enemies, return true if something was generated]
		public static function lootDrop(nloc:Location, nnx:Number, nny:Number, lootTable:String, hero:int=0):Boolean {
			if (nloc == null) {
				return false;
			}

			lootBroken = false;
			loc = nloc;
			nx = nnx;
			ny = nny;
			is_loot = 0;
			
			// TODO: Turn this into a loot table
			// Monsters
			if (lootTable=='scorp') {
				newLoot(1, Item.L_COMPA, 'chitin_comp');
				newLoot(0.25, Item.L_COMPP, 'gland');
				newLoot(0.1, Item.L_FOOD, 'meat');
			}
			else if (lootTable=='slime') {
				newLoot(0.75, Item.L_ITEM, 'acidslime');
			}
			else if (lootTable=='pinkslime') {
				newLoot(0.75, Item.L_ITEM, 'pinkslime');
			}
			else if (lootTable=='raider') {
				newLoot(0.25, 'eda');
				newLoot(0.25, Item.L_AMMO);
				newLoot(0.12, Item.L_EXPL);
			}
			else if (lootTable=='alicorn1' || lootTable=='alicorn2' || lootTable=='alicorn3') {
				newLoot(1, Item.L_COMPP, 'mdust');
				newLoot(0.1, Item.L_POT, 'potMP');
				if (!newLoot(0.3, Item.L_MED, 'potm1')) newLoot(0.2, Item.L_MED, 'potm2');
			}
			else if (lootTable=='ranger1' || lootTable=='ranger2' || lootTable=='ranger3') {
				newLoot(1, Item.L_ITEM, 'frag',Math.floor(Math.random()*3+1));
				newLoot(0.5, Item.L_ITEM, 'scrap',Math.floor(Math.random()*3+1));
				newLoot(1, Item.L_COMPA, 'power_comp');
				newLoot(0.25, Item.L_AMMO);
			}
			else if (lootTable=='encl2' || lootTable=='encl3' || lootTable=='encl4') {
				newLoot(0.5, Item.L_ITEM, 'frag',Math.floor(Math.random()*3+1));
				if (!newLoot(0.3, Item.L_AMMO, 'batt')) newLoot(0.5, Item.L_AMMO,'crystal');
				newLoot(0.3, Item.L_COMPA, 'power_comp');
			}
			else if (lootTable=='hellhound1') {
				if (hero>0) newLoot(1, Item.L_COMPW, 'kogt');
			}
			else if (lootTable=='zombie') {
				newLoot(0.35, Item.L_COMPP, 'ghoulblood');
				newLoot(0.15, Item.L_COMPP, 'radslime');
				newLoot(0.5, Item.L_COMPA, 'skin_comp');
			}
			else if (lootTable=='zombie4') {
				newLoot(0.8, Item.L_COMPP, 'ghoulblood');
				newLoot(1, Item.L_COMPP, 'radslime');
			}
			else if (lootTable=='zombie5') {
				newLoot(1, Item.L_COMPP, 'ghoulblood');
				newLoot(0.3, Item.L_COMPP, 'metal_comp');
			}
			else if (lootTable=='zombie6') {
				newLoot(1, Item.L_COMPP, 'ghoulblood');
				newLoot(0.3, Item.L_COMPA, 'battle_comp');
				newLoot(0.8, Item.L_COMPP, 'acidslime');
			}
			else if (lootTable=='zombie7') {
				newLoot(0.6, Item.L_COMPP, 'ghoulblood');
				newLoot(0.2, Item.L_COMPP, 'pinkslime');
				if (hero>0) newLoot(0.6, Item.L_COMPM, 'darkfrag');
			}
			else if (lootTable=='zombie8') {
				newLoot(0.6, Item.L_COMPP, 'ghoulblood');
				newLoot(1, Item.L_COMPP, 'pinkslime');
				if (hero>0) newLoot(0.8, Item.L_COMPM, 'darkfrag');
			}
			else if (lootTable=='zombie9') {
				newLoot(0.6, Item.L_COMPP, 'ghoulblood');
				newLoot(1, Item.L_COMPP, 'whorn');
				if (hero>0) newLoot(1, Item.L_COMPM, 'darkfrag');
			}
			else if (lootTable=='bloodwing') {
				newLoot(0.2, Item.L_COMPP, 'wingmembrane');
				newLoot(0.16, Item.L_COMPP, 'vampfang');
				newLoot(0.25, Item.L_FOOD, 'meat');
			}
			else if (lootTable=='bloodwing2') {
				newLoot(0.3, Item.L_COMPP, 'wingmembrane');
				newLoot(0.2, Item.L_COMPP, 'vampfang');
				newLoot(0.4, Item.L_COMPP, 'pinkslime');
			}
			else if (lootTable=='bloat0') {
				newLoot(0.2, Item.L_COMPP, 'bloatwing');
				newLoot(0.1, Item.L_COMPP, 'bloateye');
			}
			else if (lootTable=='bloat1') {
				newLoot(0.2, Item.L_COMPP, 'bloatwing');
				newLoot(0.1, Item.L_COMPP, 'bloateye');
				newLoot(0.2, Item.L_COMPP, 'acidslime');
			}
			else if (lootTable=='bloat2') {
				newLoot(0.2, Item.L_COMPP, 'bloatwing');
				newLoot(0.1, Item.L_COMPP, 'bloateye');
				newLoot(0.1, Item.L_COMPP, 'gland');
			}
			else if (lootTable=='bloat3') {
				newLoot(0.3, Item.L_COMPP, 'bloatwing');
				newLoot(0.2, Item.L_COMPP, 'bloateye');
				newLoot(0.1, Item.L_COMPP, 'molefat');
			}
			else if (lootTable=='bloat4') {
				newLoot(0.4, Item.L_COMPP, 'bloatwing');
				newLoot(0.3, Item.L_COMPP, 'bloateye');
			}
			else if (lootTable=='rat') {
				newLoot(0.35, Item.L_COMPP, 'ratliver');
				newLoot(0.25, Item.L_COMPP, 'rattail');
				newLoot(0.1, Item.L_FOOD, 'meat');
			}
			else if (lootTable=='molerat') {
				newLoot(0.5, Item.L_COMPP, 'ratliver');
				newLoot(1, Item.L_COMPP, 'molefat');
				newLoot(0.25, Item.L_FOOD, 'meat');
			}
			else if (lootTable=='fish1') {
				newLoot(0.5, Item.L_COMPP, 'fishfat');
			}
			else if (lootTable=='fish2') {
				newLoot(1, Item.L_COMPP, 'fishfat');
			}
			else if (lootTable=='ant1') {
				newLoot(0.15, Item.L_COMPA, 'chitin_comp');
				newLoot(0.1, Item.L_FOOD, 'meat');
			}
			else if (lootTable=='ant2') {
				newLoot(0.3, Item.L_COMPA, 'chitin_comp');
				newLoot(0.1, Item.L_FOOD, 'meat');
			}
			else if (lootTable=='ant3') {
				newLoot(0.2, Item.L_COMPA, 'chitin_comp');
				newLoot(1, Item.L_COMPP, 'firegland');
				newLoot(0.1, Item.L_FOOD, 'meat');
			}
			else if (lootTable=='necros') {
				newLoot(0.5, Item.L_ITEM, 'dsoul');
			}
			else if (lootTable=='ebloat') {
				newLoot(1, Item.L_COMPP, 'essence');
			}
			// Robots
			else if (lootTable=='turret') {
				newLoot(0.5, Item.L_ITEM, 'scrap');
				newLoot(0.35, Item.L_COMPW, 'frag');
				if (!newLoot(0.2, Item.L_AMMO, 'batt')) newLoot(0.2, Item.L_AMMO,'energ');
			}
			else if (lootTable=='turret1') {
				newLoot(0.5, Item.L_ITEM, 'scrap');
				newLoot(0.5, Item.L_ITEM, 'scrap');
				newLoot(0.85, Item.L_COMPW, 'frag');
				newLoot(0.52, Item.L_COMPA, 'magus_comp');
				if (!newLoot(0.4, Item.L_AMMO, 'batt')) newLoot(0.8, Item.L_AMMO,'energ');
			}
			else if (lootTable=='robobrain') {
				newLoot(0.25, Item.L_ITEM, 'scrap');
				newLoot(0.15, Item.L_COMPW, 'frag');
				newLoot(0.5, Item.L_COMPM);
				newLoot(0.5, Item.L_AMMO, 'batt');
				newLoot(0.4, Item.L_COMPA, 'metal_comp');
				if (hero>0) newLoot(1, Item.L_COMPM, 'impgen');
			}
			else if (lootTable=='protect') {
				newLoot(0.3, Item.L_ITEM, 'scrap');
				newLoot(0.25, Item.L_COMPW, 'frag');
				newLoot(0.6, Item.L_COMPM);
				newLoot(0.9, Item.L_AMMO, 'batt');
				newLoot(0.4, Item.L_COMPA, 'metal_comp');
				if (hero>0) newLoot(1, Item.L_COMPM, 'uscan');
			}
			else if (lootTable=='gutsy') {
				newLoot(0.45, Item.L_ITEM, 'scrap');
				newLoot(0.5, Item.L_COMPW, 'frag');
				newLoot(0.7, Item.L_COMPM);
				newLoot(0.85, Item.L_COMPA, 'battle_comp');
				if (!newLoot(0.4, Item.L_AMMO, 'fuel')) newLoot(0.75, Item.L_AMMO, 'energ');
				if (hero>0) newLoot(1, Item.L_COMPM, 'tlaser');
			}
			else if (lootTable=='eqd') {
				newLoot(0.45, Item.L_ITEM, 'scrap');
				newLoot(0.5, Item.L_COMPW, 'frag');
				newLoot(0.8, Item.L_COMPM);
				newLoot(0.85, Item.L_COMPA, 'magus_comp');
				newLoot(1, Item.L_AMMO, 'energ');
				newLoot(0.5, Item.L_ITEM, 'data');
				if (hero>0) newLoot(1, Item.L_COMPM, 'pcrystal');
			}
			else if (lootTable=='sentinel') {
				newLoot(0.85, Item.L_ITEM, 'scrap');
				newLoot(0.5, Item.L_COMPW, 'frag');
				newLoot(1, Item.L_COMPM);
				if (!newLoot(0.4, Item.L_AMMO, 'p5')) newLoot(1, Item.L_AMMO, 'crystal');
				newLoot(0.85, Item.L_AMMO, 'rocket');
				newLoot(0.5, Item.L_COMPW);
				newLoot(1, Item.L_COMPM, 'motiv');
			}
			else if (lootTable=='vortex' || lootTable=='spritebot' || lootTable=='roller') {
				newLoot(0.2, Item.L_ITEM, 'scrap');
			}
			return is_loot>0;
		}
		
		public static function replic(s:String) {
			if (isrnd()) World.w.gg.replic(s);
		}	
		
		private static function isrnd(n:Number = 0.5):Boolean {
			return Math.random() < n;
		}
	}
}
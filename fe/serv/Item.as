package fe.serv {	
	
	import fe.*;
	import fe.unit.Invent;
	
	
	public class Item {	// [Inventory item]
		
		// Ghetto AS3 enumeration
		public static const L_ITEM:String = 'item';
		public static const L_ARMOR:String = 'armor';
		public static const L_WEAPON:String = 'weapon';
		public static const L_UNIQ:String = 'uniq';
		public static const L_SPELL:String = 'spell';
		public static const L_AMMO:String = 'a';
		public static const L_EXPL:String = 'e';
		public static const L_MED:String = 'med';
		public static const L_BOOK:String = 'book';
		public static const L_HIM:String = 'him';
		public static const L_POT:String = 'pot';
		public static const L_FOOD:String = 'food';
		public static const L_SCHEME:String = 'scheme';
		public static const L_PAINT:String = 'paint';
		public static const L_COMPA:String = 'compa';
		public static const L_COMPW:String = 'compw';
		public static const L_COMPE:String = 'compe';
		public static const L_COMPM:String = 'compm';
		public static const L_COMPP:String = 'compp';
		public static const L_SPEC:String = 'spec';
		public static const L_INSTR:String = 'instr';
		public static const L_STUFF:String = 'stuff';
		public static const L_ART:String = 'art';
		public static const L_IMPL:String = 'impl';
		public static const L_KEY:String = 'key';

		public static var itemTip:Array=['weapon','spell','a','e','med','book','him','scheme','compa','compw','compe','compm','compp','paint','art','impl','key'];
		
		public var tip:String;
		public var wtip:String='';
		public var base:String='';
		public var id:String;
		public var nazv:String;
		public var mess:String;	//информационное окно, ставящее игру на паузу
		public var fc:int=-1;	//цвет всплывающего сообщения
		public var invis:Boolean=false;
		
		public var xml;
		public var kol:int=0;		//количество в инвентаре
		public var vault:int=0;		//количество в хранилище
		public var invCat:int=3;	//отдел инвентаря
		public var sost:Number=1;	//состояние лута
		public var multHP:Number=1;	//множитель ХП
		public var variant:int=0;
		public var mass:Number=0;
		
		public var imp:int=0; //0 - случайно сгенерированный, 1 - заданный, 2 - критичный
		public var cont:Interact;	// [parent container]
		
		public var nov:int=0;	//новая вещь
		public var dat:Number=0;	//время получения
		public var bou:int=0;	//куплено
		public var shpun:int=0;		//признак, указывающий на то, что скрытое оружие нужно раскрыть
		public var lvl:int=0;		//уровень персонажа, с которого предмет становится доступен
		public var barter:int=0;	//уровень навыка, с которого предмет становится доступен
		public var trig:String;		//триггер, который должен быть установлен, чтобы предмет стал доступен
		public var price:Number=0;
		public var pmult:Number=1;
		public var noref:Boolean=false;	//не восполнять
		public var nocheap:Boolean=false;	//не уменьшать цену
		public var hardinv:Boolean=false;	//только при ограниченном инвентаре

		private static var cachedItems:Object = {}; // Save all objects that have been used before to avoid parsing XML for lots of objects.
		
		// [nkol -- number of items or weapon/armor condition 0-1-2]
		// [If nkol=-1, the quantity is taken from xml]
		// Constructor
		public function Item(ntip:String, nid:String, nkol:int=-1, unique:int = 0, nxml:XML = null) {
			variant = unique;

			//	ID
			if (nid.charAt(nid.length - 2) == '^') {
				variant = int(nid.charAt(nid.length - 1));
				id = nid.substr(0, nid.length - 2);
			}
			else id = nid;

			//	TYPE
			tip = ntip;
			xml = nxml;

			// If we're missing either the tip or XML, try to load the info
			if (tip == null || tip == '' || nxml == null) {
				getItemInfo();
			}
			
			if (tip == L_UNIQ) tip = L_WEAPON; // All uniques are weapon, change to L_WEAPON

			wtip = xml.@tip;

			if (tip == L_ARMOR || tip == L_WEAPON) {
				kol = 1;

				if (tip == L_ARMOR && xml && xml.@tip == '3') {
					sost = 1;
				}
				else {
					if (nkol == 0) sost = 0.05 + Math.random() * 0.15;
					if (nkol == 1) sost = 0.60 + Math.random() * 0.25;
				}
			}
			
			// If there's a manual item count being passed, use it
			if (nkol >= 0) {
				kol = nkol;
			}
			// Otherwise, if this is being called with -1, use data from the XML
			else if (nkol < 0 && xml) {
				if (xml.@kol.length()) {
					kol = xml.@kol;
				}
				else {
					kol = 1;
				}
			}
			
			if (tip == L_WEAPON || tip == L_EXPL) {
				if (variant == 0)	{
					nazv = Res.txt('w', id);
				}
				else
				{
					if (Res.istxt('w', id + '^' + variant)) {
						nazv = Res.txt('w', id + '^' + variant);
					}
					else {
						nazv = Res.txt('w', id) + ' - II';
					}
				}
				if (tip == L_EXPL) {
					wtip = 'w5';
				}
				else {
					wtip = 'w' + xml.@skill;
				}
			}
			else if (tip == L_ARMOR) {
				nazv=Res.txt('a', id);
				if (xml && xml.@tip.length()) {
					wtip = 'armor' + xml.@tip;
				}
				else {
					wtip = 'armor1';
				}
			}
			else if (xml && xml.@base.length()) {
				base=xml.@base;
				nazv=Res.txt('i',base);
				if (xml.@mod.length()) nazv+=' ('+Res.pipText('am_'+xml.@mod)+')';
			}
			else {
				nazv = Res.txt('i', id);
			}

			if (tip==L_ITEM && xml && xml.@tip.length()) tip=xml.@tip;
			if (tip==L_SCHEME && !Res.istxt('i',id))
			{
				var wid:String=id.substr(2);
				if (xml.@work == 'work') {
					nazv = Res.pipText('scheme1') + ' «' + Res.txt('i', wid) + '»';
				}
				else {
					nazv = Res.pipText('recipe') + ' «' + Res.txt('i', wid) + '»';
				}
			}
			if (tip == L_AMMO || tip == L_EXPL) {
				invCat = 2;
			}
			if (xml && xml.@us > 0 && tip != L_FOOD && tip != 'eda' && tip != L_BOOK) {
				invCat = 1;
			}
			if (tip == L_WEAPON && xml) { 
				if (xml.@tip != 4) mass = 1;
				if (xml.phis.length() && xml.phis.@m.length()) mass = xml.phis.@m;
			}
			if (xml) {
				if (xml.@invcat.length())	invCat = xml.@invcat;
				if (xml.@invis.length())	invis = true;
				if (xml.@fc.length())		fc = xml.@fc;
				if (xml.@mess.length())		mess = xml.@mess;
				if (xml.@m.length())		mass = xml.@m;
			}

		}

		// Set the item's XML and Tip properties
		private function getItemInfo():void {
			// Check if the node is already cached
			if (cachedItems[id] != null) {
				if (xml == null) {
					trace(cachedItems[id]);
					xml = cachedItems[id].xml;
				}
				if (tip == null) {
					tip = cachedItems[id].tip;
				}
				return;
			}
			
			var node;

			// We don't have the XML
			if (tip != null) {
				node = XMLDataGrabber.getNodeWithAttributeThatMatches("core", "AllData", tip, "id", id);
				if (node != null ) {
					xml = node;
					tip = node.@tip;

					cachedItems[id] = node;	// Cache the item
					return;
				}
			}

			// We still don't have the XML OR the Item Type
			var categories:Array = ["items", "weapons", "armors"];
			var tips:Array = [L_ITEM, L_WEAPON, L_ARMOR];
			
			for (var i:int = 0; i < categories.length; i++) {
				node = XMLDataGrabber.getNodeWithAttributeThatMatches("core", "AllData", categories[i], "id", id);
				if (node != null) {	// We found the item 
					xml = node;
					tip = (categories[i] == "items" && xml.@tip.length()) ? xml.@tip : tips[i];
					break;
				}
			}
			
			cachedItems[id] = node;	// Cache the item
			return;
		}
		
		public function getPrice():void {
			if (xml) {
				if (xml.com.length() && xml.com.@price.length()) {
					price=xml.com[0].@price*sost*multHP*pmult;
					if (variant>0) {
						if (xml.com[1]) price=xml.com[1].@price*sost*multHP*pmult;
						else price*=3;
					}
				}
				else {
					price = xml.@price * sost * multHP * pmult;
				}
			}
		}
		
		public function getMultPrice():Number {
			if (xml && xml.@price>0 && xml.@sell>0) {
				return Number(xml.@sell)/Number(xml.@price);
			}
			else {
				return 0.1;
			}
		}
		
		public function checkAuto(m:Boolean=false):Boolean {
			var inv:Invent=World.w.invent;
			if (tip==L_WEAPON) {
				var w = inv.weapons[id];
				if (w != null && (World.w.vsWeaponRep || m)) {		//если включен автоподбор для ремонта или принудительный вызов
					if (w.hp <= w.maxhp && (w.respect==0 || w.respect==2 || !World.w.hardInv)) {	//подбирать автоматом если оружие есть, оно неисправно и (оно выбрано или инвентарь бесконечный)
						return true;
					}
					else if (m && World.w.hardInv) {	//если было принудительное взятие при конечном инвентаре, то активировать взятое оружие
						shpun=2;
					}
					return false; 
				}
				if (w==null && World.w.vsWeaponNew) {	//если включен автоподбор нового и оружия ещё нет
					if (World.w.hardInv) {		//если инвентарь ограниченный, то проверять вес
						if (mass==0) return true;
						if (xml.@tip<=3) {
							if (inv.massW<=World.w.pers.maxmW-mass) {
								return true;
							} else {
								if (m) World.w.gui.infoText('fullWeap');
								return false;
							}
						}
						if (xml.@tip==5) {
							if (inv.massM<=World.w.pers.maxmM-mass) {
								return true;
							}
							else {
								if (m) World.w.gui.infoText('fullMagic');
								return false;
							}
						}
						return false;
					}
					return true;
				}
				return false;
			}
			if (tip==L_SPELL) {
				if (inv.massM>=World.w.pers.maxmM) World.w.gui.infoText('fullMagic');
				return true;
			}
			if (tip==L_ARMOR) return true;
			if (mass==0) return true;
			if (World.w.hardInv) {
				if (inv.mass[invCat]+mass*kol>World.w.pers['maxm'+invCat]) return false;
			}
			if (World.w.vsAmmoAll && tip==L_AMMO) return true;
			if (World.w.vsAmmoTek && xml && tip==L_AMMO) {
				for each (w in inv.weapons) {
					if (w.tip<=3 && (w.respect==0 || w.respect==2) && w.ammoBase!='' && (w.ammoBase==xml.@id || w.ammoBase==xml.@base)) return true;
				}
			}
			if (World.w.vsExplAll && tip==L_EXPL) return true;
			if (World.w.vsMedAll && (tip==L_MED || tip==L_POT)) return true;
			if (World.w.vsHimAll && tip==L_HIM) return true;
			if (World.w.vsEqipAll && tip=='equip') return true;
			if (World.w.vsStuffAll && invCat==3) return true;
			if (World.w.vsVal && tip=='valuables') return true;
			if (World.w.vsBook && (tip=='book' || tip=='sphera')) return true;
			if (World.w.vsFood && (tip=='food' || tip=='eda')) return true;
			if (World.w.vsComp && (tip=='stuff' || tip=='compa' || tip=='compw' || tip=='compe' || tip=='compm')) return true;
			if (World.w.vsIngr && tip=='compp') return true;
			return false;
		}
		
		public function save():Object {
			return {tip:tip, id:id, kol:kol, sost:sost, barter:barter, lvl:lvl, trig:trig,variant:variant};
		}
		
		public function trade():void {
			kol -= bou;
			bou = 0;
		}
	}
}
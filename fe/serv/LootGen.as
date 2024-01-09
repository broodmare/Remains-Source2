package fe.serv {
	
	import fe.*;
	import fe.loc.Loot;
	import fe.loc.Location;
	
	public class LootGen {

		public function LootGen() {
			// constructor code
		}

		//случайные объекты 
		
		private static var rndArr:Array;
		public static var arr:Array;
				
		private static var is_loot:int=0;		//был сгенерирован лут
		private static var loc:Location;				//целевая локация
		private static var nx:Number, ny:Number;
		private static var lootBroken:Boolean=false;
		//public static const L_ARMOR=1, L_WEAPON=2, L_AMMO=3, L_ITEM=4, L_MED=5, L_BOOK=6, L_EXPL=7, L_HIM=8, L_SCHEME=9, L_SPECIAL=10, L_COMP1=11, L_COMP2=12, L_COMP3=13;
		
		public static function init() {
			//var n:Number;
			arr=new Array();
			var n:Array = new Array();
			//arrWeapon=new Array();
			n['weapon']=0;
			arr['weapon']=new Array();
			arr['magic']=new Array();
			arr['uniq']=new Array();
			arr['pers']=new Array();
			for each (var weap in AllData.d.weapon.(@tip>0 && @tip<4)) {
				if (weap.com.length()==0) continue;
				arr['weapon'].push({id:weap.@id, st:weap.com.@stage, chance:weap.com.@chance, worth:weap.com.@worth, lvl:weap.@lvl, r:(n['weapon']+=Number(weap.com.@chance))});
				if (weap.com.@uniq.length()) arr['uniq'].push({id:weap.@id+'^1', st:weap.com.@stage, chance:weap.com.@uniq, worth:weap.com.@worth, lvl:weap.@lvl, r:(n['uniq']+=Number(weap.com.@uniq))});
			}
			for each (weap in AllData.d.weapon.(@tip==5)) {
				arr['magic'].push({id:weap.@id, st:0, chance:0, worth:0, lvl:0, r:0});
			}
			for each (var item in AllData.d.item) {
				if (item.@tip.length()) {
					if (arr[item.@tip]==null) {
						arr[item.@tip]=new Array();
						n[item.@tip]=0;
					}
					arr[item.@tip].push({id:item.@id, st:item.@stage, chance:(item.@chance.length()?item.@chance:1), lvl:item.@lvl,  r:(n[item.@tip]+=Number(item.@chance.length()?item.@chance:1))});
					if (item.@tip=='art' || item.@tip=='impl' || item.sk.length()) arr['pers'].push(item.@id);	//признак предметов, изменяющих характеристики перса
				}
				if (item.@tip2.length()) {
					if (arr[item.@tip2]==null) {
						arr[item.@tip2]=new Array();
						n[item.@tip2]=0;
					}
					arr[item.@tip2].push({id:item.@id, st:item.@stage, chance:(item.@chance2.length()?item.@chance2:item.@chance), lvl:item.@lvl,  r:(n[item.@tip2]+=Number(item.@chance2.length()?item.@chance2:item.@chance))});
				}
			}
			
			// проверка рандома
			var a:Array=new Array();
			/*for (var i=0; i<10000; i++) {
				var str:String =getRandom('food',3);
				if (a[str]) a[str]++;
				else a[str]=1;
			}
			for (i in a) trace (i,a[i]);*/
			/*for (i=0; i<100; i++) {
				trace(getRandom('weapon',2,2))
			}*/
		}
		
		public static function getRandom(tip:String, maxlvl:Number=-100, worth:int=-100):String {
			var a:Array, res:Array, n:Number=0;
			a=arr[tip];
			if (a==null) return null;
			var gameStage:int=0
			if (World.w.land) gameStage=World.w.land.gameStage;
			if (tip!=Item.L_BOOK && (maxlvl>0 || worth>0 || gameStage>0)) {
				res=new Array();
				for each(var i in a) {
					if (
						(gameStage<=0 || i.st==null || i.st<=gameStage) &&		//зависит от этапа сюжета
						(maxlvl==-100 || i.lvl==null || i.lvl<=maxlvl) &&			//максимальный уровень, зависит от сложности
						(worth==-100 || i.worth==null || worth==i.worth)			//тип предмета, зависит от типа контейнера
					) {
						res.push({id:i.id, r:(n+=Number(i.chance))});
					}
				}
			} else {
				res=a;
			}
			if (res.length==0) return null;
			if (res.length==1) return res[0].id;
			n=Math.random()*res[res.length-1].r;
			for each(i in res) {
				if (i.r>n) return i.id;
			}
			return null;
		}
		
		//создать рандомный, если id==null, или заданный лут
		//если запрос превышает лимит, не создавать лут, вернуть false
		private static function newLoot(rnd:Number, tip:String, id:String=null, kol:int=-1, imp:int=0, cont:Interact=null):Boolean {
			if (rnd<1 && Math.random()>rnd) return false;
			var mn:Number=1;
			if (lootBroken) {
				mn=0.4;
			}
			if (tip==Item.L_WEAPON) {
				//Рандомное оружие
				if (int(id)>0) {
					id=getRandom(tip,Math.max(1,loc.weaponLevel+(Math.random()*2-1)),int(id));
					if (id==null) mn*=0.5;
				}
				if (id==null) {
					id=getRandom(tip,Math.max(1,loc.weaponLevel+(Math.random()*2-1)));
					if (id==null) mn*=0.5;
				}
				if (id==null) {
					id=getRandom(tip);
				}
			}
			//Рандомный лут, определить нужный id
			if (id==null || id=='') {
				if (tip==Item.L_EXPL || tip==Item.L_UNIQ) {
					id=getRandom(tip,Math.max(1,loc.weaponLevel+(Math.random()*2-1)));
				} else {
					id=getRandom(tip,Math.max(1,loc.locDifLevel/2+(Math.random()*2-1)));
				}
				if (id==null) {
					id=getRandom(tip);
				}
			}
			if (id==null) {
				trace('Ошибка при генерации лута тип:', tip);
				return false;
			}
			if (kol==-1 && tip==Item.L_UNIQ) kol=1;
			var item:Item=new Item(tip, id, kol);
			if (tip=='eda') item.tip='food';
			if (tip=='co') {
				item.tip='scheme';
				var wid:String=id.substr(2);
				item.nazv=Res.pipText('recipe')+' «'+Res.txt('i',wid)+'»';
			}
			item.multHP=mn;
			item.imp=imp;
			item.cont=cont;
			if (item.id=='money') item.kol*=World.w.pers.capsMult*World.w.pers.difCapsMult;	//множитель крышек
			if (item.id=='bit') item.kol*=World.w.pers.bitsMult*World.w.pers.difCapsMult;	//множитель крышек
			if (lootBroken && (item.id=='money' || item.id=='bit')) item.kol*=0.5;
			if (lootBroken && (item.tip==Item.L_AMMO || item.tip==Item.L_EXPL) && Math.random()<0.5) return false;
			//проверить лимиты
			if (imp==0 && item.xml.@limit.length()) {
				var lim:int=World.w.game.getLimit(item.xml.@limit);
				var itemLimit:Number=World.w.land.lootLimit;
				if (item.xml.@mlim.length()) itemLimit*=item.xml.@mlim;
				if (item.xml.@maxlim.length() && lim>=item.xml.@maxlim) {
					if (!World.w.testLoot) trace('Достигнут максимум:', id, lim);
					return false;
				}
				if (lim>=itemLimit) {
					if (!World.w.testLoot) trace('Превышен лимит:', id, lim, itemLimit);
					return false;
				}
				World.w.game.addLimit(item.xml.@limit,1);
			}
			if (World.w.testLoot) World.w.invent.take(item);
			else new Loot(loc,item,nx,ny,true);
			is_loot++;
			return true;
		}
		
		//Генерация лута по заданному ID
		public static function lootId(nloc:Location, nnx:Number, nny:Number, id:String, kol:int=-1, imp:int=0, cont:Interact=null, broken:Boolean=false) {
			if (nloc==null) return false;
			lootBroken=broken;
			loc=nloc;
			nx=nnx, ny=nny;
			newLoot(1, '', id, kol, imp, cont);
		}
		
		//генерация лута из заданного типа контейнера, вернуть true если было что-то сгенерировано
		//dif - сложность замков, принимает значение от 0 до 49
		public static function lootCont(nloc:Location, nnx:Number, nny:Number, cont:String, broken:Boolean=false, dif:Number=0):Boolean {
			if (nloc==null) return false;
			lootBroken=broken;
			loc=nloc;
			nx=nnx, ny=nny;
			is_loot=0;
			var locdif:Number=Math.min(loc.locDifLevel,20);
			var kol:int=1;
			if (cont=='ammo') {
				newLoot(0.7,Item.L_AMMO);
				newLoot(0.25, Item.L_AMMO);
				newLoot(0.15, Item.L_AMMO);
				if (World.w.pers.freel) newLoot(0.7,Item.L_AMMO);
			} else if (cont=='metal') {		//металлоискатель
				if (!newLoot(0.5, Item.L_ITEM,'money',Math.random()*30*(locdif*0.15+1)+5)) newLoot(1,Item.L_AMMO);
			} else if (cont=='bomb') {
				kol=3;
				for (var i=0; i<kol; i++) newLoot(1, Item.L_EXPL,'dinamit');
			} else if (cont=='expl') {
				kol=Math.floor(Math.random()*4-1);
				for (var i=0; i<=kol; i++) newLoot(1, Item.L_EXPL);
				newLoot(0.5, Item.L_COMPE);
				if (World.w.pers.freel) newLoot(0.5,Item.L_EXPL);
			} else if (cont=='bigexpl') {
				kol=Math.floor(Math.random()*4+2);
				for (var i=0; i<=kol; i++) newLoot(1, Item.L_EXPL);
				if (World.w.pers.freel) newLoot(0.5,Item.L_EXPL);
				newLoot(0.5, Item.L_COMPE);
			} else if (cont=='wbattle') {
				if (!newLoot(0.04, Item.L_UNIQ)) {
					if (Math.random()<Math.min(locdif/5,0.7)) newLoot(1, Item.L_WEAPON,'4',1);
					else newLoot(1, Item.L_WEAPON,'3',1);
				}
				newLoot(0.8, Item.L_AMMO);
				if (World.w.pers.freel) newLoot(0.5,Item.L_AMMO);
				newLoot(0.1,Item.L_ITEM,'stealth');
				if (World.w.pers.barahlo) newLoot(0.1, Item.L_COMPA, 'intel_comp');
			} else if (cont=='case') {
				//newLoot(1, Item.L_UNIQ);	//!!!!!!!!!!!!!!!!!!!!
				newLoot(0.9, Item.L_ITEM,'money',Math.random()*20*(locdif*0.11+1)+5);
			} else if (cont=='wbig') {
				if (!newLoot(0.08, Item.L_UNIQ)) {
					if (Math.random()<0.5) newLoot(1, Item.L_WEAPON,'5',1);
					else newLoot(1, Item.L_WEAPON,'4',1);
				}
				newLoot(0.5,Item.L_EXPL,'',Math.floor(Math.random()*4));
				newLoot(0.5,Item.L_AMMO,'',Math.floor(Math.random()*4));
				if (World.w.pers.freel) newLoot(0.5,Item.L_AMMO);
				if (World.w.pers.barahlo) newLoot(0.5, Item.L_COMPA, 'intel_comp');
			} else if (cont=='robocell') {
				newLoot(1, Item.L_COMPM);
			} else if (cont=='instr') {
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
			} else if (cont=='instr2') {
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
			} else if (cont=='trash') {
				if (loc.land.act.biom==0) newLoot(0.25, Item.L_FOOD, 'radcookie');
				if (Math.random()<0.25) {
					if (Math.random()<0.6) loc.createUnit('tarakan',nx,ny,true);
					else loc.createUnit('rat',nx,ny,true);
				} else {
					kol=Math.floor(Math.random()*2);
					if (World.w.pers.barahlo) kol+=2;
					for (i=0; i<=kol; i++) newLoot(1, Item.L_STUFF);
					newLoot(0.4, Item.L_ITEM,'money',Math.random()*10*(locdif*0.1+1)+5);
				}
			} else if (cont=='fridge') {
				newLoot(0.5, Item.L_FOOD, 'sparklecola');
				newLoot(0.5, Item.L_FOOD, 'sars');
				newLoot(0.1, Item.L_FOOD, 'radcola');
				if (Math.random()<0.2) {
					if (Math.random()<0.4) loc.createUnit('tarakan',nx,ny,true);
					else if (Math.random()<0.5) loc.createUnit('rat',nx,ny,true);
					else loc.createUnit('bloat',nx,ny,true);
				} else {
					kol=Math.floor(Math.random()*2);
					for (i=0; i<=kol; i++) newLoot(1, Item.L_FOOD);
					newLoot(0.3, Item.L_COMPP, 'herbs',Math.floor(Math.random()*6+1));
				}
			} else if (cont=='food') {
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
			} else if (cont=='med') {
				newLoot(0.05, Item.L_ITEM,'pin',Math.floor(Math.random()*2+1)); 
				kol=Math.floor(Math.random()*3-1);
				for (i=0; i<=kol; i++) newLoot(1, Item.L_MED);
				newLoot(0.25, Item.L_HIM);
				newLoot(0.03, Item.L_MED, 'firstaid');
				newLoot(0.05, Item.L_POT, 'potHP');
				newLoot(0.25, Item.L_ITEM, 'gel');
			} else if (cont=='med2') {
				newLoot(0.75, Item.L_POT, 'potHP');
				kol=Math.floor(Math.random()*3);
				for (i=0; i<=kol; i++) newLoot(1, Item.L_MED);
				newLoot(1, Item.L_HIM);
				newLoot(0.5, Item.L_MED, 'firstaid');
				newLoot(0.5, Item.L_MED, 'doctor');
				newLoot(0.5, Item.L_MED, 'surgeon');
				newLoot(0.8, Item.L_ITEM, 'gel');
			} else if (cont=='table') {
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
			} else if (cont=='filecab') {
				newLoot(0.1, Item.L_ITEM,'pin',Math.floor(Math.random()*3+1)); 
				newLoot(0.5, Item.L_ITEM,'money',Math.random()*20);
				newLoot(0.1, Item.L_ITEM,'app');
				newLoot(0.02, Item.L_SCHEME);
				newLoot(0.08, 'co');
			} else if (cont=='cup') {
				newLoot(0.06, Item.L_ITEM,'pin',Math.floor(Math.random()*3+1)); 
				newLoot(0.3, Item.L_ITEM,'money',Math.random()*20);
				newLoot(0.25, Item.L_COMPA);
				newLoot(0.75, Item.L_STUFF);
				newLoot(0.2, Item.L_COMPA, 'kombu_comp');
				newLoot(0.2, Item.L_COMPA, 'antirad_comp');
				newLoot(0.2, Item.L_COMPA, 'antihim_comp');
			} else if (cont=='bloat') {
				loc.createUnit('bloat',nx,ny,true);
			} else if (cont=='book') {
				if (!newLoot(0.3, Item.L_BOOK)) newLoot(1, Item.L_ITEM,'lbook');
				newLoot(0.1, Item.L_ITEM,'gem'+Math.floor(Math.random()*3+1));
				newLoot(0.25, Item.L_SCHEME);
				newLoot(0.3, 'co');
				if (nloc.itemsTip=='bibl') newLoot(0.5, Item.L_ITEM, 'book_cm');
			} else if (cont=='term' || cont=='info') {
				if (nloc.land.act.id=='minst') newLoot(1,Item.L_ITEM,'datast');
				else if (!newLoot(0.25, Item.L_ITEM,'disc')) newLoot(1,Item.L_ITEM,'data');
				newLoot(0.5, Item.L_COMPM);
			} else if (cont=='cryo') {
				kol=Math.floor(Math.random()*3);
				for (var i=0; i<=kol; i++) newLoot(1, Item.L_ITEM,'pcryo');
				newLoot(0.5, Item.L_ITEM, 'gel');
			} else if (cont=='chest') {
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
			} else if (cont=='safe') {
				if (World.w.land.rnd && nloc.prob==null && Math.random()<0.05) {
					for (i=0; i<4; i++) loc.createUnit('bloat',nx,ny,true);
				} else {
					//dif - 0..50
					newLoot(dif/100, Item.L_UNIQ);
					newLoot(0.1+dif/100, Item.L_ITEM,'sphera');
					newLoot(0.2+dif/200, Item.L_ITEM,'stealth');
					newLoot(0.25+dif/100, Item.L_ITEM,'gem'+Math.floor(Math.random()*3+1));
					newLoot(0.2, Item.L_MED);
					newLoot(0.25, Item.L_ITEM, 'retr');
					newLoot(0.1, Item.L_ITEM, 'runa');
					newLoot(0.1, Item.L_ITEM, 'reboot');
					newLoot(0.2+dif/100, Item.L_BOOK);
					newLoot(0.1+dif/100, Item.L_COMPP);
					newLoot(1, Item.L_ITEM,'bit',Math.random()*(dif+10)*8+2+4*locdif);
					newLoot(0.1+dif/300, Item.L_SCHEME);
					newLoot(0.25, Item.L_POT, 'potMP');
					newLoot(0.1, Item.L_POT, 'potHP');
					if (!newLoot(0.4, Item.L_MED, 'potm2')) newLoot(0.3, Item.L_MED, 'potm3')
					if (is_loot==0) newLoot(1, Item.L_ITEM,'gem'+Math.floor(Math.random()*3+1));
					if (is_loot>6) replic('full');
					if (is_loot<2) replic('empty');
				}
			} else if (cont=='specweap') {
				kol=Math.floor(Math.random()*4);
				var vars:Array=new Array();
				if (World.w.invent.weapons['lsword']==null || World.w.invent.weapons['lsword'].variant==0) vars.push('lsword^1');
				if (World.w.invent.weapons['antidrak']==null || World.w.invent.weapons['antidrak'].variant==0) vars.push('antidrak^1');
				if (World.w.invent.weapons['quick']==null || World.w.invent.weapons['quick'].variant==0) vars.push('quick^1');
				if (World.w.invent.weapons['mlau']==null || World.w.invent.weapons['mlau'].variant==0) vars.push('mlau^1');
				if (vars.length) newLoot(1, Item.L_WEAPON, vars[Math.floor(Math.random()*vars.length)]);
				else newLoot(1, Item.L_UNIQ);
			} else if (cont=='specalc') {
				newLoot(1, Item.L_SPEC,'alc7');
				newLoot(1, Item.L_ITEM,'gem'+Math.floor(Math.random()*3+1));
			} else if (cont=='speclp') {
				newLoot(1, Item.L_SPEC,'lp_item');
				newLoot(1, Item.L_ITEM,'gem'+Math.floor(Math.random()*3+1));
			}
			return is_loot>0;
		}
		
		//генерация лута, выпадающего из врагов, вернуть true если было что-то сгенерировано
		public static function lootDrop(nloc:Location, nnx:Number, nny:Number, cont:String, hero:int=0):Boolean {
			if (nloc==null) return false;
			lootBroken=false;
			loc=nloc;
			nx=nnx, ny=nny;
			is_loot=0;
			//монстры
			if (cont=='scorp') {
				newLoot(1, Item.L_COMPA, 'chitin_comp');
				newLoot(0.25, Item.L_COMPP, 'gland');
				newLoot(0.1, Item.L_FOOD, 'meat');
			} else if (cont=='slime') {
				newLoot(0.75, Item.L_ITEM, 'acidslime');
			} else if (cont=='pinkslime') {
				newLoot(0.75, Item.L_ITEM, 'pinkslime');
			} else if (cont=='raider') {
				newLoot(0.25, 'eda');
				newLoot(0.25, Item.L_AMMO);
				newLoot(0.12, Item.L_EXPL);
			} else if (cont=='alicorn1' || cont=='alicorn2' || cont=='alicorn3') {
				newLoot(1, Item.L_COMPP, 'mdust');
				newLoot(0.1, Item.L_POT, 'potMP');
				if (!newLoot(0.3, Item.L_MED, 'potm1')) newLoot(0.2, Item.L_MED, 'potm2');
			} else if (cont=='ranger1' || cont=='ranger2' || cont=='ranger3') {
				newLoot(1, Item.L_ITEM, 'frag',Math.floor(Math.random()*3+1));
				newLoot(0.5, Item.L_ITEM, 'scrap',Math.floor(Math.random()*3+1));
				newLoot(1, Item.L_COMPA, 'power_comp');
				newLoot(0.25, Item.L_AMMO);
			} else if (cont=='encl2' || cont=='encl3' || cont=='encl4') {
				newLoot(0.5, Item.L_ITEM, 'frag',Math.floor(Math.random()*3+1));
				if (!newLoot(0.3, Item.L_AMMO, 'batt')) newLoot(0.5, Item.L_AMMO,'crystal');
				newLoot(0.3, Item.L_COMPA, 'power_comp');
			} else if (cont=='hellhound1') {
				if (hero>0) newLoot(1, Item.L_COMPW, 'kogt');
			} else if (cont=='zombie') {
				newLoot(0.35, Item.L_COMPP, 'ghoulblood');
				newLoot(0.15, Item.L_COMPP, 'radslime');
				newLoot(0.5, Item.L_COMPA, 'skin_comp');
			} else if (cont=='zombie4') {
				newLoot(0.8, Item.L_COMPP, 'ghoulblood');
				newLoot(1, Item.L_COMPP, 'radslime');
			} else if (cont=='zombie5') {
				newLoot(1, Item.L_COMPP, 'ghoulblood');
				newLoot(0.3, Item.L_COMPP, 'metal_comp');
			} else if (cont=='zombie6') {
				newLoot(1, Item.L_COMPP, 'ghoulblood');
				newLoot(0.3, Item.L_COMPA, 'battle_comp');
				newLoot(0.8, Item.L_COMPP, 'acidslime');
			} else if (cont=='zombie7') {
				newLoot(0.6, Item.L_COMPP, 'ghoulblood');
				newLoot(0.2, Item.L_COMPP, 'pinkslime');
				if (hero>0) newLoot(0.6, Item.L_COMPM, 'darkfrag');
			} else if (cont=='zombie8') {
				newLoot(0.6, Item.L_COMPP, 'ghoulblood');
				newLoot(1, Item.L_COMPP, 'pinkslime');
				if (hero>0) newLoot(0.8, Item.L_COMPM, 'darkfrag');
			} else if (cont=='zombie9') {
				newLoot(0.6, Item.L_COMPP, 'ghoulblood');
				newLoot(1, Item.L_COMPP, 'whorn');
				if (hero>0) newLoot(1, Item.L_COMPM, 'darkfrag');
			} else if (cont=='bloodwing') {
				newLoot(0.2, Item.L_COMPP, 'wingmembrane');
				newLoot(0.16, Item.L_COMPP, 'vampfang');
				newLoot(0.25, Item.L_FOOD, 'meat');
			} else if (cont=='bloodwing2') {
				newLoot(0.3, Item.L_COMPP, 'wingmembrane');
				newLoot(0.2, Item.L_COMPP, 'vampfang');
				newLoot(0.4, Item.L_COMPP, 'pinkslime');
			} else if (cont=='bloat0') {
				newLoot(0.2, Item.L_COMPP, 'bloatwing');
				newLoot(0.1, Item.L_COMPP, 'bloateye');
			} else if (cont=='bloat1') {
				newLoot(0.2, Item.L_COMPP, 'bloatwing');
				newLoot(0.1, Item.L_COMPP, 'bloateye');
				newLoot(0.2, Item.L_COMPP, 'acidslime');
			} else if (cont=='bloat2') {
				newLoot(0.2, Item.L_COMPP, 'bloatwing');
				newLoot(0.1, Item.L_COMPP, 'bloateye');
				newLoot(0.1, Item.L_COMPP, 'gland');
			} else if (cont=='bloat3') {
				newLoot(0.3, Item.L_COMPP, 'bloatwing');
				newLoot(0.2, Item.L_COMPP, 'bloateye');
				newLoot(0.1, Item.L_COMPP, 'molefat');
			} else if (cont=='bloat4') {
				newLoot(0.4, Item.L_COMPP, 'bloatwing');
				newLoot(0.3, Item.L_COMPP, 'bloateye');
			} else if (cont=='rat') {
				newLoot(0.35, Item.L_COMPP, 'ratliver');
				newLoot(0.25, Item.L_COMPP, 'rattail');
				newLoot(0.1, Item.L_FOOD, 'meat');
			} else if (cont=='molerat') {
				newLoot(0.5, Item.L_COMPP, 'ratliver');
				newLoot(1, Item.L_COMPP, 'molefat');
				newLoot(0.25, Item.L_FOOD, 'meat');
			} else if (cont=='fish1') {
				newLoot(0.5, Item.L_COMPP, 'fishfat');
			} else if (cont=='fish2') {
				newLoot(1, Item.L_COMPP, 'fishfat');
			} else if (cont=='ant1') {
				newLoot(0.15, Item.L_COMPA, 'chitin_comp');
				newLoot(0.1, Item.L_FOOD, 'meat');
			} else if (cont=='ant2') {
				newLoot(0.3, Item.L_COMPA, 'chitin_comp');
				newLoot(0.1, Item.L_FOOD, 'meat');
			} else if (cont=='ant3') {
				newLoot(0.2, Item.L_COMPA, 'chitin_comp');
				newLoot(1, Item.L_COMPP, 'firegland');
				newLoot(0.1, Item.L_FOOD, 'meat');
			} else if (cont=='necros') {
				newLoot(0.5, Item.L_ITEM, 'dsoul');
			} else if (cont=='ebloat') {
				newLoot(1, Item.L_COMPP, 'essence');
			}
			//роботы
			else if (cont=='turret') {
				newLoot(0.5, Item.L_ITEM, 'scrap');
				newLoot(0.35, Item.L_COMPW, 'frag');
				if (!newLoot(0.2, Item.L_AMMO, 'batt')) newLoot(0.2, Item.L_AMMO,'energ');
			} else if (cont=='turret1') {
				newLoot(0.5, Item.L_ITEM, 'scrap');
				newLoot(0.5, Item.L_ITEM, 'scrap');
				newLoot(0.85, Item.L_COMPW, 'frag');
				newLoot(0.52, Item.L_COMPA, 'magus_comp');
				if (!newLoot(0.4, Item.L_AMMO, 'batt')) newLoot(0.8, Item.L_AMMO,'energ');
			} else if (cont=='robobrain') {
				newLoot(0.25, Item.L_ITEM, 'scrap');
				newLoot(0.15, Item.L_COMPW, 'frag');
				newLoot(0.5, Item.L_COMPM);
				newLoot(0.5, Item.L_AMMO, 'batt');
				newLoot(0.4, Item.L_COMPA, 'metal_comp');
				if (hero>0) newLoot(1, Item.L_COMPM, 'impgen');
			} else if (cont=='protect') {
				newLoot(0.3, Item.L_ITEM, 'scrap');
				newLoot(0.25, Item.L_COMPW, 'frag');
				newLoot(0.6, Item.L_COMPM);
				newLoot(0.9, Item.L_AMMO, 'batt');
				newLoot(0.4, Item.L_COMPA, 'metal_comp');
				if (hero>0) newLoot(1, Item.L_COMPM, 'uscan');
			} else if (cont=='gutsy') {
				newLoot(0.45, Item.L_ITEM, 'scrap');
				newLoot(0.5, Item.L_COMPW, 'frag');
				newLoot(0.7, Item.L_COMPM);
				newLoot(0.85, Item.L_COMPA, 'battle_comp');
				if (!newLoot(0.4, Item.L_AMMO, 'fuel')) newLoot(0.75, Item.L_AMMO, 'energ');
				if (hero>0) newLoot(1, Item.L_COMPM, 'tlaser');
			} else if (cont=='eqd') {
				newLoot(0.45, Item.L_ITEM, 'scrap');
				newLoot(0.5, Item.L_COMPW, 'frag');
				newLoot(0.8, Item.L_COMPM);
				newLoot(0.85, Item.L_COMPA, 'magus_comp');
				newLoot(1, Item.L_AMMO, 'energ');
				newLoot(0.5, Item.L_ITEM, 'data');
				if (hero>0) newLoot(1, Item.L_COMPM, 'pcrystal');
			} else if (cont=='sentinel') {
				newLoot(0.85, Item.L_ITEM, 'scrap');
				newLoot(0.5, Item.L_COMPW, 'frag');
				newLoot(1, Item.L_COMPM);
				if (!newLoot(0.4, Item.L_AMMO, 'p5')) newLoot(1, Item.L_AMMO, 'crystal');
				newLoot(0.85, Item.L_AMMO, 'rocket');
				newLoot(0.5, Item.L_COMPW);
				newLoot(1, Item.L_COMPM, 'motiv');
			} else if (cont=='vortex' || cont=='spritebot' || cont=='roller') {
				newLoot(0.2, Item.L_ITEM, 'scrap');
			}
			return is_loot>0;
		}
		
		public static function replic(s:String) {
			if (isrnd()) World.w.gg.replic(s);
		}	
		
		protected static function isrnd(n:Number=0.5):Boolean {
			return Math.random()<n;
		}
		
	}
	
}

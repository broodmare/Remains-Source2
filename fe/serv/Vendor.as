package fe.serv {
	
	import fe.*;
	import fe.unit.Invent;
	import fe.unit.Unit;

	public class Vendor {
		
		public var id:String;
		
		public var buys:Array;
		public var buys2:Array;
		public var kolBou:Number=0;
		public var kolSell:Number=0;
		public var money:int=0;
		public var xml:XML;
		
		public var multPrice:Number=1;

		public function Vendor(lvl:int=0, nxml:XML=null, loadObj:Array=null, tip:String='vendor') {
			buys=new Array();
			buys2=new Array();
			xml=nxml;
			var item:Item;
			if (nxml) {
				if (nxml.@id=='random') {
					if (loadObj) {
						for each(var obj:Object in loadObj) {
							item=new Item(null,obj.id,obj.kol,obj.variant);
							buys.push(item);
						}
					} else setRndBuys(100,'random');
				} else {
					for each(var b:XML in xml.buy) {
						item=new Item(null,b.@id,b.@n);
						if (b.@barter.length()) item.barter=b.@barter;
						if (b.@lvl.length()) item.lvl=b.@lvl;
						if (b.@trigger.length()) item.trig=b.@trigger;
						if (b.@noref.length()) item.noref=true;
						if (b.@nocheap.length()) item.nocheap=true;
						if (b.@hardinv.length()) item.hardinv=true;
						if (b.@pmult.length()) item.pmult=b.@pmult;
						if (loadObj) {
							//item.kol=0;
							for each(var obj:Object in loadObj) {
								if (obj.variant==item.variant && obj.id==item.id) {
									item.kol=obj.kol;
									item.sost=obj.sost;
									break;
								}
							}
						}
						buys.push(item);
					}
				}
			} else {
				setRndBuys(lvl, tip);
			}
			if (xml) id=xml.@id;
			for (var i in buys) {
				var uid:String=buys[i].id;
				if (buys[i].variant>0) uid+='^'+buys[i].variant;
				buys2[uid]=buys[i];
			}
			money=Math.round(Math.random()*450+50);
			if (Math.random()<0.2) money*=2;
		}
		
		public function setRndBuys(lvl:int=0, rndtip:String='vendor') {
			if (Math.random()<0.7) {
				multPrice=Math.floor(Math.random()*6+8)/10;
			}
			var num:int;
			if (rndtip=='random') num=30;
			else if (rndtip=='doctor') num=5+3*World.w.pers.barterLvl;
			else num=10+6*World.w.pers.barterLvl;
			num=Math.round(num*(0.5+Math.random()*0.7));
			var num2:int=num*(0.1+Math.random()*0.3);
			var item:Item;
			var cid:String;
			for (var i=0; i<num; i++) {
				if (i<num2 && rndtip!='doctor') {
					cid=LootGen.getRandom(Item.L_WEAPON,1+lvl/4);
					item=new Item(Item.L_WEAPON, cid, 1)
					if (buys2[cid]==null) {
						if (Math.random()<0.2) {
							item.barter=Math.floor(Math.random()*lvl/4+1);
							if (item.barter>5) item.barter=5;
						}
						buys.push(item);
						buys2[cid]=item;
					}
				} else {
					var tip:String;
					var t:int=Math.floor(Math.random()*110);
					if (rndtip=='doctor') {
						if (t<70) tip=Item.L_MED;
						else tip=Item.L_HIM;
					} else {
						if (t<5) tip=Item.L_UNIQ;
						else if (t<10) tip=Item.L_SCHEME;
						else if (t<25) tip=Item.L_MED;
						else if (t<35) tip=Item.L_HIM;
						else if (t<55) tip=Item.L_EXPL;
						else if (t<60) tip=Item.L_COMPA;
						else if (t<65) tip=Item.L_COMPW;
						else if (t<70) tip=Item.L_COMPE;
						else if (t<75) tip=Item.L_COMPM;
						else tip=Item.L_AMMO;
					}
					cid=LootGen.getRandom(tip,lvl);
					if (cid==null) continue;
					item=new Item(tip, cid);
					if (buys2[cid]==null) {
						if (Math.random()<0.3) {
							item.lvl=Math.floor(Math.random()*lvl+1);
							if (item.lvl>5) item.lvl=5;
						}
						if (tip==Item.L_AMMO) {
							item.kol=Math.round(item.kol*(3+Math.random()*12));
						} else if (tip!=Item.L_UNIQ && tip!=Item.L_SCHEME) {
							item.kol=Math.round(item.kol*(1+Math.random()*4));
						}
						buys.push(item);
						buys2[cid]=item;
					} else if (tip!=Item.L_UNIQ && tip!=Item.L_SCHEME) {
						buys2[cid].kol+=item.kol;
					}
				}
			}
		}
		
		public function reset() {
			kolBou=0;
			for (var i in buys) buys[i].bou=0;
		}
		
		public function refill() {
			//trace(id,xml);
			if (xml==null) return;
			if (id=='random') {
				buys=new Array();
				buys2=new Array();
				setRndBuys(100,'random');
				for (var i in buys) {
					var uid:String=buys[i].id;
					if (buys[i].variant>0) uid+='^'+buys[i].variant;
					buys2[uid]=buys[i];
				}
				return;
			} 
			for each(var item:Item in buys) {
				if (item.noref || item.tip==Item.L_ARMOR || item.tip==Item.L_WEAPON || item.tip==Item.L_SCHEME || item.tip==Item.L_UNIQ || item.tip==Item.L_IMPL) continue;
				var buy=xml.buy.(@id==item.id);
				if (buy.length()==0 || buy.@n.length()==0) continue;
				var lim=Math.ceil(buy.@n*World.w.pers.limitBuys);
				if (item.kol<lim) {
					item.kol=Math.min(lim,item.kol+Math.ceil(0.25*lim));
					//trace(item.nazv, item.kol);
				}
			}
		}
		
		public function save():* {
			if (id==null) return null;
			var arr:Array=new Array();
			for each (var b:Item in buys) arr.push(b.save());
			return arr;
		}
		

	}
	
}

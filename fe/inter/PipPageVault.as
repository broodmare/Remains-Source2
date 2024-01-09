package fe.inter {
	
	import fe.*;
	import fe.unit.Unit;
	import fe.unit.Armor;
	import fe.unit.UnitPlayer;
	import fe.unit.UnitPet;
	import fe.serv.Item;
	import fe.weapon.Weapon;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import fl.controls.NumericStepper;
	import flash.text.TextFormat;
	import fe.loc.Quest;
	import fe.loc.LandAct;
	
	public class PipPageVault extends PipPage{
		
		var assArr:Array;

		public function PipPageVault(npip:PipBuck, npp:String) {
			isLC=isRC=true;
			itemClass=visPipVaultItem;
			super(npip,npp);
			vis.but4.visible=vis.but5.visible=false;
			var tf:TextFormat=new TextFormat();
			tf.color = 0x00FF99; 
			tf.size = 16; 
			vis.butOk.addEventListener(MouseEvent.CLICK,transOk);
			for (var i=0; i<maxrows; i++) {
				var item:MovieClip=statArr[i]; 
				var ns:NumericStepper=item.ns;
				ns.addEventListener(MouseEvent.CLICK,nsClick);
				ns.addEventListener(Event.CHANGE,nsCh);
				ns.tabEnabled=false;
				ns.focusRect=false;
				ns.setStyle("textFormat", tf);
			}
		}

		//подготовка страниц
		override function setSubPages() {
			assArr=new Array();
			statHead.ns.visible=statHead.id.visible=statHead.cat.visible=false;
			statHead.nazv.text=Res.pipText('ii2');
			statHead.kol.text=Res.pipText('ii7');
			statHead.kol.width=170;
			statHead.mass.text=World.w.hardInv?Res.pipText('ii8'):'';
			statHead.mass2.text=World.w.hardInv?Res.pipText('ii9'):'';
			setTopText('vaultupr');
			vis.butOk.visible=false;
			inv.calcMass();
				for (var s in inv.items) {
					if (s=='' || (inv.items[s].kol<=0 && inv.items[s].vault<=0) || inv.items[s].invis) continue;
					var node:XML=inv.items[s].xml;
					if (node==null) continue;
					if (node.@tip=='money' || node.@tip=='paint' || node.@tip=='spell' || node.@tip=='spec' || node.@tip=='key' || node.@tip=='instr' || node.@tip=='impl' || node.@tip=='art' || node.@tip=='scheme') continue;
					/*var itemTip=3;
					if (node.@tip=='a' || node.@tip=='e') itemTip=2;
					else if (node.@us>0) itemTip=1;
					if (node.@tip=='food') itemTip=3;*/
					
					//if (node.@v.length() && node.@v!=page2) return;
					if (inv.items[s].invCat==page2) {
						var tcat:String;
						if (Res.istxt('p',node.@tip)) tcat=Res.pipText(node.@tip);
						else tcat=Res.pipText('stuff');
						var n={tip:node.@tip, id:s, nazv:((node.@tip=='e')?Res.txt('w',s):inv.items[s].nazv), kol:inv.items[s].kol, vault:inv.items[s].vault, mass:inv.items[s].mass, cat:tcat, trol:node.@tip};
						if (node.@tip=='valuables') n.price=node.@price;
						if (node.@tip=='food' && node.@ftip=='1') {
							n.trol='drink';
						}
						if (node.@keep>0) {
							n.keep=true;
						}
						n.sort=n.cat;
						n.sort2=node.@sort.length()?node.@sort:0;
						arr.push(n);
						assArr[n.id]=n;
					}
				}
				if (arr.length) arr.sortOn(['sort','sort2','nazv'],[0,Array.NUMERIC,0]);
			if (page2==2 || page2==3) {
				vis.butOk.text.text=Res.pipText('tovault');
				vis.butOk.visible=true;
			}
				
			setIco();
			showBottext();
		}
		
		function showBottext() {
			if (World.w.hardInv) vis.bottext.text=inv.retMass(page2);
			else vis.bottext.text='';
		}
		
		//показ одного элемента
		override function setStatItem(item:MovieClip, obj:Object) {
			item.id.text=obj.id;
			item.id.visible=false;
			item.cat.visible=false;
			item.nazv.alpha=1;
			try {
				item.trol.gotoAndStop(obj.tip);
			} catch (err) {
				item.trol.gotoAndStop(1);
			}
			item.id.text=obj.id;
			item.nazv.text=obj.nazv;
			item.nazv.alpha=1;
			if (obj.kol==0) item.nazv.alpha=0.5;
			item.cat.text=obj.tip;
			item.mass.text=World.w.hardInv?obj.mass:'';
			item.mass2.text=World.w.hardInv?Res.numb(obj.mass*obj.kol):'';
			item.kol.text=obj.kol;
			item.ns.maximum=obj.kol+obj.vault;
			item.ns.value=obj.vault;
		}
		
		//информация об элементе
		override function statInfo(event:MouseEvent) {
			infoItem(event.currentTarget.cat.text,event.currentTarget.id.text,event.currentTarget.nazv.text);
		}
		
		function chKol(mc, n:int=0) {
			var obj=assArr[mc.id.text]
			var item:Item=inv.items[mc.id.text];
			if (item==null || obj==null) return;
			n=n-item.vault;
			if (n>item.kol) n=item.kol;
			if (n<-item.vault) n=-item.vault;
			item.vault+=n;
			item.kol-=n;
			obj.kol=item.kol;
			obj.vault=item.vault;
			var dmass=n*item.mass;
			inv.mass[item.invCat]-=dmass;
			showBottext();
			pip.setRPanel();
			if (mc) {
				if (obj.kol==0) mc.nazv.alpha=0.5;
				else mc.nazv.alpha=1;
				mc.kol.text=obj.kol;
				mc.ns.value=obj.vault;
				mc.mass2.text=World.w.hardInv?Res.numb(obj.mass*obj.kol):'';
			}
		}
		
		
		function nsClick(event:MouseEvent) {
			event.stopPropagation();
		}
		function nsCh(event:Event) {
			chKol(event.currentTarget.parent, event.currentTarget.value);
		}
		
		override function itemClick(event:MouseEvent) {
			if (event.ctrlKey) chKol(event.currentTarget, 0);
			else chKol(event.currentTarget, int.MAX_VALUE);
			pip.snd(1);
			showBottext();
			pip.setRPanel();
			event.stopPropagation();
		}
		override function itemRightClick(event:MouseEvent) {
			chKol(event.currentTarget, 0);
			pip.snd(1);
			showBottext();
			pip.setRPanel();
			event.stopPropagation();
		}
		
		function checkAmmo(item:Item):Boolean {
			var ab:String=item.id;
			if (item.tip=='a' && item.xml && item.xml.@base.length()) ab=item.xml.@base;
			for each(var weap:Weapon in inv.weapons) {
				if (weap==null) continue;
				if (weap.respect==0 || weap.respect==2) {
					if (weap.tip==4 && ab==weap.id) return true;
					if (ab==weap.ammoBase) return true;
				}
			}
			return false;
		}
		function sbrosHlam() {
			for (var s in arr) {
				if (arr[s].tip!='food' && arr[s].tip!='book' && arr[s].tip!='sphera' && arr[s].tip!='valuables' && !arr[s].keep) {
					var item:Item=inv.items[arr[s].id];
					if (item==null) continue;
					if (arr[s].tip=='a' || arr[s].tip=='e' || arr[s].tip=='compw') {
						if (checkAmmo(item)) continue;
					}
					var dmass=item.kol*item.mass;
					item.vault+=item.kol;
					item.kol=0;
					inv.mass[item.invCat]-=dmass;
				}
			}
			showBottext();
			setStatus();
			pip.setRPanel();
		}
		
		function transOk(event:MouseEvent) {
			if (page2==2 || page2==3) {
				sbrosHlam();
			}
		}
	}
	
}

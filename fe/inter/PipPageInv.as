package fe.inter {
	
	import fe.*;
	import fe.unit.Unit;
	import fe.unit.Armor;
	import fe.unit.UnitPlayer;
	import fe.weapon.Weapon;
	import fe.serv.Item;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	public class PipPageInv extends PipPage{
		
		var assId:String=null;
		var assArr:Array;
		var actCurrent:String='';
		
		var overId:String;
		var overItem:Object;
		var over_t:int;
		var dat:Number=0;
		

		public function PipPageInv(npip:PipBuck, npp:String) {
			isLC=isRC=true;
			itemClass=visPipInvItem;
			super(npip,npp);
			vis.butOk.addEventListener(MouseEvent.CLICK,showH);
			tips=[[],
			['','w1','w2','w4','w5','w6','w3'],
			['','armor1','armor3'],
			['','med',['him','pot'],'food',['equip','spell'],['book','sphera','note'],'paint'],
			['',['valuables','money'],['spec','key'],['impl','art','instr','equip'],['stuff','compa','compw','compe','compm'],['compp','food'],'scheme'],
			['','a','e']];
			initCats();
		}
		
		//подготовка страниц
		override function setSubPages() {
			vis.butOk.visible=false;
			statHead.cat.visible=false;
			statHead.rid.visible=false;
			pip.vis.butHelp.visible=true;
			pip.vis.butMass.visible=World.w.hardInv;
			setIco();
			setCats();
			assId=null;
			dat=new Date().getTime();
			if (page2!=4) {
				setTopText('invupr'+page2);
			}
			inv.calcMass();
			inv.calcWeaponMass();
			if (page2==1) {		//оружие
				inv.getKolAmmos();
				assArr=new Array();
				statHead.fav.text=Res.pipText('ii1');
				statHead.nazv.text=Res.pipText('ii2');
				statHead.hp.text=Res.pipText('ii3');
				statHead.ammo.text='';
				statHead.mass.text='';
				statHead.ammotip.text=Res.pipText('ii4');
				for each(var obj in inv.weapons) {
					if (obj is Weapon) {
						var w:Weapon=obj as Weapon;
						if (w.respect==3) continue;
						if (w.spell && World.w.alicorn) continue;
						if (w.spell && (inv.items[w.id]==null || inv.items[w.id].kol<=0)) continue;
						w.setPers(gg, gg.pers);
						if (w.respect==1) {	//скрытый
							if (!World.w.hardInv || World.w.loc.base || World.w.loc.train) vis.butOk.visible=true;
							if (!pip.showHidden) continue;
						}
						if (w.alicorn && !World.w.alicorn) continue;
						var trol:String='w'+w.skill;
						if (trol=='w7') trol='w6';
						if (curTip!='' && curTip!=null && curTip!=trol) continue;	//категория
						var avail:Boolean=true;
						if (w.avail()<=-1) avail=false;
						var n:Object={tip:'w', id:w.id, nazv:w.nazv, respect:w.respect, avail:avail, variant:w.variant, trol:trol};
						n.sort1=1;
						if (!avail) n.sort1=2;
						if (n.respect==1) n.sort1=3;
						n.sort3=w.lvl;
						n.sort2=w.skill;
						if (w.tip==5) n.sort3=w.perslvl;
						if (w.spell) n.sort3=900+w.perslvl;
						n.sort3=int(n.sort3);
						if (w.tip<4) {
							n.hp=Math.round(w.hp/w.maxhp*100)+'%';
						}
						if (w.ammo!='' && w.ammo!=null) {
							if (inv.ammos[w.ammoBase]!=null) n.ammo=inv.ammos[w.ammoBase]+w.hold;
							else n.ammo=inv.items[w.ammo].kol+w.hold;
							n.ammotip=(w.tip!=4)?inv.items[w.ammoBase].nazv:'';
						}
						if (w.alicorn) n.nazv=Res.rainbow(n.nazv);
						arr.push(n);
						assArr[n.id]=n;
					}
				}
				pip.reqKey=true;
				vis.butOk.text.text=Res.pipText('showhidden');
				actCurrent='showhidden';
				if (arr.length) arr.sortOn(['sort1','sort2','sort3','nazv'],[0,0,Array.NUMERIC,0]);
				//if (arr.length) arr.sortOn('fav');
				pip.massText=Res.txt('p','massInv0',0,true)+'<br><br>'+Res.txt('p','massInv1',0,true);
			} else if (page2==2) {	//броня
				//if (World.w.alicorn) return;
				statHead.fav.text=Res.pipText('ii1');
				statHead.nazv.text=Res.pipText('ii2');
				statHead.hp.text=Res.pipText('ii3');
				statHead.ammo.text='';
				statHead.mass.text='';
				statHead.ammotip.text='';
				for (var s in inv.armors) {
					if (s=='') continue;
					var arm:Armor=inv.armors[s];
					if (arm.lvl<0) continue;
					if (curTip!='' && curTip!=null && curTip!='armor'+arm.tip) continue;	//категория
					n={id:s, nazv:arm.nazv, clo:arm.clo, hp:Math.round(arm.hp/arm.maxhp*100)+'%', sort:arm.sort, trol:'armor'+arm.tip};
					arr.push(n);
				}
				pip.reqKey=true;
				if (arr.length) arr.sortOn(['trol','sort'],[0,Array.NUMERIC]);
				pip.massText=Res.txt('p','massInv0',0,true)+'<br><br>'+Res.txt('p','massInv2',0,true);
			} else if (page2==3 || page2==4 || page2==5) {	//снаряжение
				//if (page2!=5 && World.w.alicorn) return;
				assArr=new Array();
				statHead.fav.text=Res.pipText('ii1');
				statHead.nazv.text=Res.pipText('ii2');
				statHead.hp.text=Res.pipText('ii5');
				statHead.ammotip.text=Res.pipText('ii6');
				statHead.ammo.text='';
				if (World.w.hardInv) statHead.mass.text=Res.pipText('ii8');
				for (s in inv.items) {
					if (s=='' || inv.items[s].kol<=0 || inv.items[s].invis) continue;
					var node:XML=inv.items[s].xml;
					if (node==null) continue;
					
					if (inv.items[s].nov==1 && (dat-inv.items[s].dat)>1000*60*15) inv.items[s].nov=0;
					if (inv.items[s].nov==2 && (dat-inv.items[s].dat)>1000*60*5) inv.items[s].nov=0;
						
					/*if (curTip is Array) {
						if (node.@tip!=curTip[0] && node.@tip!=curTip[1] && node.@tip!=curTip[2] && node.@tip!=curTip[3] && node.@tip!=curTip[4]) continue;
					} else if (curTip!='' && curTip!=null && curTip!=node.@tip) continue;*/	//категория
					if (!checkCat(node.@tip)) continue;
					var itemTip=0;
					if (node.@tip=='a' || node.@tip=='e') itemTip=2;
					else if (node.@us>0) itemTip=1;
					if ((itemTip==1 && page2==3) || (itemTip==0 && page2==4) || (itemTip==2 && page2==5)) {
						var tcat:String;
						if (Res.istxt('p',node.@tip)) tcat=Res.pipText(node.@tip);
						else tcat=Res.pipText('stuff');
						n={tip:node.@tip, id:s, nazv:((node.@tip=='e')?Res.txt('w',s):inv.items[s].nazv), kol:inv.items[s].kol, drop:0, mass:inv.items[s].mass, cat:tcat, trol:node.@tip};
						if (node.@tip=='valuables') n.price=node.@price;
						if (node.@tip=='food' && node.@ftip=='1') {
							n.trol='drink';
						}
						if (node.@tip=='spell' && inv.weapons[s] && inv.weapons[s].respect==1) continue;	//скрытое заклинание
						n.sort=n.cat;
						n.sort2=node.@sort.length()?node.@sort:0;
						//патроны к текущему оружию вперёд
						if (page2==5 && gg.currentWeapon && gg.currentWeapon.tip<4 && (gg.currentWeapon.ammoBase==node.@base || gg.currentWeapon.ammoBase==node.@id)) n.sort='0'+n.sort;
						arr.push(n);
						assArr[n.id]=n;
					}
				}
				if (page2==3) pip.reqKey=true;
				if (arr.length) arr.sortOn(['sort','sort2','nazv'],[0,Array.NUMERIC,0]);
				pip.massText=Res.txt('p','massInv0',0,true)+'<br><br>'+Res.txt('p','massInv3',0,true);
			}
			pip.helpText=Res.txt('p','helpInv'+page2,0,true);
			if (arr.length==0) {
				vis.emptytext.text=Res.pipText('emptyinv');
				statHead.visible=false;
			} else {
				vis.emptytext.text='';
				statHead.visible=true;
			}
			showBottext();
		}
		
		function showBottext() {
			vis.bottext.htmlText=Res.pipText('caps')+': '+yel(pip.money);
			if (World.w.hardInv) {
				if (page2==1) vis.bottext.htmlText='    '+inv.retMass(4)+'    '+inv.retMass(5);
				else if (page2==3) vis.bottext.htmlText+='    '+inv.retMass(1);
				else if (page2==4) vis.bottext.htmlText+='    '+inv.retMass(3);
				else if (page2==5) vis.bottext.htmlText+='    '+inv.retMass(2);
			}
		}
		
		
		//показ одного элемента
		override function setStatItem(item:MovieClip, obj:Object) {
			item.id.text=obj.id;
			item.id.visible=item.rid.visible=item.cat.visible=false;
			item.alpha=1;
			item.nazv.alpha=1;
			item.mass.text='';
			if (inv.favIds[obj.id]) {
				if (inv.favIds[obj.id]==29) item.fav.text=World.w.ctr.retKey('keyGrenad');
				else if (inv.favIds[obj.id]==30) item.fav.text=World.w.ctr.retKey('keyMagic');
				else if (inv.favIds[obj.id]>World.kolHK*2) item.fav.text=World.w.ctr.retKey('keySpell'+(inv.favIds[obj.id]-World.kolHK*2));
				else if (inv.favIds[obj.id]>World.kolHK) item.fav.text='^'+World.w.ctr.retKey('keyWeapon'+(inv.favIds[obj.id]-World.kolHK));
				else item.fav.text=World.w.ctr.retKey('keyWeapon'+inv.favIds[obj.id]);
			}
			else item.fav.text='';

			try {
				item.trol.gotoAndStop(obj.trol);
			} catch (err) {
				item.trol.gotoAndStop(1);
			}
			if (page2==1) {
				item.ramka.visible=(World.w.gg.newWeapon && World.w.gg.newWeapon.id==obj.id) || (World.w.gg.currentSpell && World.w.gg.currentSpell.id==obj.id);
				if (item.ramka.visible) selItem=item;
				item.nazv.htmlText=obj.nazv;
				//if (obj.respect==0) item.nazv.text='('+Res.pipText('new')+') '+item.nazv.text;
				if (obj.respect==0 && item.fav.text=='') item.fav.text='☩';
				item.hp.text=(obj.hp==null)?'':obj.hp;
				if (obj.ammo!=null) {
					item.ammo.text=obj.ammo;
					item.ammotip.text=obj.ammotip;
				} else {
					item.ammo.text=item.ammotip.text='';
				}
				if (obj.respect==1) item.alpha=0.4;
				if (obj.avail==false) item.nazv.alpha=0.6;
				if (obj.variant>0) item.rid.text=obj.id+'^'+obj.variant;
				else item.rid.text=obj.id;
			} else if (page2==2) {
				item.ramka.visible=false;
				if (World.w.hardInv && !World.w.loc.base && obj.trol=='armor1' && World.w.gg.prevArmor!=obj.id && obj.clo==0) item.alpha=0.4;
				if (World.w.gg.currentArmor && World.w.gg.currentArmor.id==obj.id) {
					item.ramka.visible=true;
					item.alpha=1;
					selItem=item;
				}
				if (World.w.gg.currentAmul && World.w.gg.currentAmul.id==obj.id) {
					item.ramka.visible=true;
				}
				item.nazv.text=obj.nazv;
				if (obj.trol=='armor3') item.hp.text='';
				else item.hp.text=obj.hp;
				item.ammo.text='';
				item.ammotip.text='';
			} else  {
				item.ramka.visible=(World.w.gg.currentSpell && World.w.gg.currentSpell.id==obj.id);;
				item.nazv.text=obj.nazv;
				item.hp.text=obj.kol;
				if (World.w.hardInv && obj.mass>0) item.mass.text=Res.numb(obj.kol*obj.mass);
				if (obj.price && obj.tip=='valuables') item.ammo.text=obj.price;
				else item.ammo.text='';
				if (item.fav.text=='') {
					if (inv.items[obj.id].nov==1) item.fav.text='☩';
					if (inv.items[obj.id].nov==2) item.fav.text='+';
				}
				if (obj.drop>0) item.ammotip.text=Res.pipText('drop')+': '+obj.drop;
				else item.ammotip.text=obj.cat.substring(2);
			}
		}
		
		
		//информация об элементе
		override function statInfo(event:MouseEvent) {
			assId=null;
			if (page2==1) {
				assId=event.currentTarget.id.text;
				infoItem(Item.L_WEAPON,event.currentTarget.rid.text,event.currentTarget.nazv.text);
			}
			if (page2==2) {
				assId=event.currentTarget.id.text;
				infoItem(Item.L_ARMOR,event.currentTarget.id.text,event.currentTarget.nazv.text);
			}
			if (page2==3 || page2==4) {
				if (page2==3) assId=event.currentTarget.id.text;
				infoItem(Item.L_ITEM,event.currentTarget.id.text,event.currentTarget.nazv.text);
			}
			if (page2==5) {
				infoItem(Item.L_AMMO,event.currentTarget.id.text,event.currentTarget.nazv.text);
			}
			if (page2>=3) {
				if (event.currentTarget.id.text!=overId) {
					overId=event.currentTarget.id.text;
					overItem=event.currentTarget;
					over_t=30;
				}
			}
		}
		
		override function itemClick(event:MouseEvent) {
			if (pip.noAct) {
				World.w.gui.infoText('noAct');
				return;
			}
			if (event.ctrlKey) {
				itemRightClick(event);
				return;
			}
			var ci:String=event.currentTarget.id.text;
			if (page2==1) {
				World.w.gg.changeWeapon(ci);
				selItem=event.currentTarget as MovieClip;
				setStatus(false);
				pip.snd(1);
			} else if (page2==2) {
				if (World.w.gg.changeArmor(ci)) {
					setStatus(false);
					/*if (selItem) selItem.ramka.visible=false;
					if (World.w.gg.currentArmor) {
						selItem=event.currentTarget as MovieClip;
						selItem.ramka.visible=true;
					}*/
				}
				pip.snd(1);
			} else if (page2==3) {
				if (ci=='retr') {
					if (World.w.alicorn) {
						World.w.gui.infoText('alicornNot',null,null,false);
						return false;
					}
					if (World.w.game.curLandId==World.w.game.baseId) return;
					else if (World.w.possiblyOut()>=2) World.w.gui.infoText('noUseCombat'); 
					else buttonOk('retr');
				} else if (ci=='mworkbench' || ci=='mworkexpl' || ci=='mworklab') {
					if (World.w.t_battle>0) {
						World.w.gui.infoText('noUseCombat',null,null,false);
					} else {
						pip.workTip=ci;
						pip.onoff(7);
					}
				} else {
					World.w.invent.useItem(ci);
					setStatus(false);
					World.w.gui.setHp();
				}
				pip.snd(1);
				over_t=2;
			} else if (page2==5) {
				if (gg.invent.weapons[ci]) {
					gg.invent.weapons[ci].respect=2;
					World.w.gg.changeWeapon(ci);
				} else if (gg.currentWeapon && gg.currentWeapon.tip<=3 && gg.currentWeapon.holder>0) gg.currentWeapon.initReload(ci);
			}
			pip.setRPanel();
			showBottext();
		}
		
		override function itemRightClick(event:MouseEvent) {
			if (pip.noAct) {
				World.w.gui.infoText('noAct');
				return;
			}
			if (page2==1) {
				var obj=assArr[event.currentTarget.id.text];
				obj.respect=World.w.invent.respectWeapon(event.currentTarget.id.text);
				setStatItem(event.currentTarget as MovieClip, obj);
				pip.setRPanel();
				showBottext();
				pip.snd(1);
			}
			if (page2>=3) {
				if (World.w.loc.base) {
					World.w.gui.infoText('noDrop1',null,null,false);
					return;
				}
				var obj=assArr[event.currentTarget.id.text];
				if (obj.mass>0 && obj.tip!='book' && obj.tip!='sphera') {
					if (event.shiftKey) obj.drop=obj.kol;
					else obj.drop++;
					setStatItem(event.currentTarget as MovieClip, obj);
					buttonOk('drop');
				} else {
					World.w.gui.infoText('noDrop2',null,null,false);
				}
			}
		}
		
		public function assignKey(num:int) {
			trace('назначение клавиши',num,assId);
			pip.snd(1);
			var temp=assId;
			if (page2<=3 && assId!=null) {
				World.w.invent.favItem(assId, num);
				setStatus(false);
			}
			assId=temp;
		}
		
		function showH(event:MouseEvent) {
			if (actCurrent=='showhidden') {			//показать скрытое оружие
				pip.showHidden=!pip.showHidden;
				setStatus();
				pip.snd(2);
			} else if (actCurrent=='retr') {		//Возврат на базу
				if (inv.items['retr'].kol>0 && World.w.game.triggers['noreturn']!=1) {
					inv.minusItem('retr');
					World.w.game.gotoLand(World.w.game.baseId);
				}
				vis.butOk.visible=false;
				pip.onoff(-1);
			} else if (actCurrent=='drop') {		//выбросить вещи
				for each (var obj in arr) {
					if (obj.drop>0) inv.drop(obj.id, obj.drop);
				}
				vis.butOk.visible=false;
				pip.onoff(-1);
			}
		}
		
		function buttonOk(act:String) {
			vis.butOk.visible=true;
			vis.butOk.text.text=Res.pipText(act);
			actCurrent=act;
		}
		
		
		public override function step() {
			if (over_t>0) over_t--;
			if (over_t==1 && overItem) {
				try {
					if (overItem.fav.text=='☩' || overItem.fav.text=='+') overItem.fav.text='';
					inv.items[overId].nov=0;
				} catch (err) {}
				
			}
		}
		
	}
	
}

package fe.inter {
	
	import fe.*;
	import fe.unit.Unit;
	import fe.unit.Armor;
	import fe.unit.UnitPlayer;
	import fe.weapon.Weapon;
	import fe.serv.Item;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import fe.unit.UnitPet;
	
	public class PipPageWork extends PipPage{
		
		var assId:String=null;
		var assArr:Array;
		
		var owlRep:int=100;

		public function PipPageWork(npip:PipBuck, npp:String) {
			isLC=true;
			itemClass=visPipInvItem;
			super(npip,npp);
			vis.but4.visible=vis.but5.visible=false;
			//vis.butOk.addEventListener(MouseEvent.CLICK,showH);
		}

		//подготовка страниц
		override function setSubPages() {
			if (pip.workTip=='mworklab') pip.workTip='lab';
			if (pip.workTip=='mworkexpl') pip.workTip='expl';
			vis.but1.visible=vis.but2.visible=vis.but3.visible=true;
			if (pip.workTip=='mworkbench') {
				vis.but1.visible=vis.but2.visible=false;
				page2=3;
			} else if (pip.workTip=='stove' || pip.workTip=='lab' || pip.workTip=='expl') {
				vis.but2.visible=vis.but3.visible=false;
				page2=1;
			}
			
			vis.bottext.text=Res.pipText('caps')+': '+pip.money;
			vis.butOk.visible=false;
			statHead.cat.visible=false;
			setIco();
			assId=null;
			var n;
			statHead.rid.visible=false;
			statHead.mass.text='';
			vis.bottext.text='';
			if (page2==1) {		//крафт
				assArr=new Array();
				statHead.fav.text='';
				statHead.nazv.text=Res.pipText('work1');;
				statHead.hp.text=Res.pipText('iv6');
				statHead.ammo.text='';
				statHead.ammotip.text='';
				for (var s:String in inv.items) {
					if (s=='' || inv.items[s]==null || inv.items[s].kol<=0) continue;
					var node=inv.items[s].xml;
					if (node==null) continue;
					if (node.@tip=='scheme' && (node.@work.length()==0 || node.@work==pip.workTip || node.@work=='expl' && pip.workTip=='work')) {//node.@work=='stove' && pip.workTip=='lab' ||
						var ok:int=1;
						if (node.@skill.length() && node.@lvl.length() && gg.pers.getSkillLevel(node.@skill)<node.@lvl) ok=2;
						var wid:String=s.substr(2);
						if (inv.weapons[wid]) {
							if (inv.weapons[wid].respect==3 || inv.weapons[wid].tip==4) {
								n={tip:Item.L_WEAPON, id:wid, nazv:Res.txt('w',wid), ok:ok ,sort:node.@skill+node.@lvl};
								if (inv.items[wid] && inv.items[wid].kol>0) n.kol=inv.items[wid].kol;
								arr.push(n);
								assArr[n.id]=n;
							}
						} else if (inv.armors[wid]) {
							if (inv.armors[wid].lvl<0) {
								n={tip:Item.L_ARMOR, id:wid, nazv:Res.txt('a',wid), ok:ok ,sort:node.@skill+node.@lvl};
								arr.push(n);
							}
						} else {
							var node1=AllData.d.item.(@id==wid);
							if (node1.length()==0) continue;
							if ((node1.@tip==Item.L_IMPL || node1.@one>0) && inv.items[wid].kol>0) continue;	//только одна штука
							n={tip:(node1.@tip==Item.L_IMPL?Item.L_IMPL:Item.L_ITEM), kol:inv.items[wid].kol, id:wid, nazv:Res.txt('i',wid), ok:ok , sort:node.@skill+node.@lvl};
							//if (node1.@one>0) n.tip=Item.L_IMPL;
							arr.push(n);
							assArr[n.id]=n;
						}
					}
				}
				if (arr.length) {
					arr.sortOn(['ok','sort']);
					vis.emptytext.text='';
					statHead.visible=true;
				} else {
					vis.emptytext.text=Res.pipText('emptycreate');
					statHead.visible=false;
				}
					
			} else if (page2==2) {	//улучшение
				statHead.fav.text='';
				statHead.nazv.text='';//Res.pipText('ii2');
				statHead.hp.text='';
				statHead.ammo.text='';
				statHead.ammotip.text='';
				if (gg.pers.maxArmorLvl>0) {
					for each(var arm:Armor in inv.armors) {
						if (arm.lvl>=0 && arm.lvl<arm.maxlvl && arm.lvl<gg.pers.maxArmorLvl) {
							n={tip:Item.L_ARMOR, id:arm.id, nazv:arm.nazv, lvl:arm.lvl, sort:('a'+arm.sort)};
							arr.push(n);
						}
					}
				}
				for each(var weap:Weapon in inv.weapons) {
					if (weap==null) continue;
					if (weap.skill==3 && weap.variant==0 && weap.respect!=3) {
						n={tip:Item.L_WEAPON, id:weap.id, nazv:weap.nazv, sort:('w'+weap.nazv)};
						arr.push(n);
					}
				}
				if (arr.length) {
					arr.sortOn('sort');
					vis.emptytext.text='';
					statHead.visible=true;
				} else {
					vis.emptytext.text=Res.pipText('emptyupgrade');
					statHead.visible=false;
				}
			} else if (page2==3) {	//ремонт
				assArr=new Array();
				statHead.fav.text='';
				statHead.nazv.text=Res.pipText('ii2');
				statHead.hp.text=Res.pipText('ii3');
				statHead.ammo.text='';
				statHead.ammotip.text=Res.pipText('repairto');
				setTopText('inforepair');
				if (inv.items['owl'] && inv.items['owl'].kol) {
					World.w.pers.setRoboowl();
					if (World.w.pers.owlhpProc<1) {
						n={tip:Item.L_INSTR, id:'owl', nazv:inv.items['owl'].nazv, hp:World.w.pers.owlhp*World.w.pers.owlhpProc, maxhp:World.w.pers.owlhp, rep:owlRep/World.w.pers.owlhp};
						arr.push(n);
						assArr[n.id]=n;
					}
					
				}
				for each (var w:Weapon in inv.weapons) {
					if (w==null) continue;
					if (w.tip!=0 && w.tip!=4 && w.respect!=1 && w.hp<w.maxhp) {
						n={tip:Item.L_WEAPON, id:w.id, nazv:w.nazv, hp:w.hp, maxhp:w.maxhp, rep:w.rep_eff*0.25};
						arr.push(n);
						assArr[n.id]=n;
					}
				}
				for each (var a:Armor in inv.armors) {
					if (!a.norep && !a.und && a.hp<a.maxhp) {
						n={tip:Item.L_ARMOR, id:a.id, nazv:a.nazv, hp:a.hp, maxhp:a.maxhp, rep:1/a.kolComp};
						arr.push(n);
						assArr[n.id]=n;
					}
				}
				if (arr.length) {
					vis.emptytext.text='';
					statHead.visible=true;
				} else {
					vis.emptytext.text=Res.pipText('emptyrep');
					statHead.visible=false;
				}
			}
			
		}
		
		//показ одного элемента
		override function setStatItem(item:MovieClip, obj:Object) {
			item.rid.visible=false;
			item.id.text=obj.id;
			item.cat.text=obj.tip;
			item.nazv.text=obj.nazv;
			item.id.visible=item.cat.visible=false;
			item.ramka.visible=false;
			item.mass.text='';
			item.fav.text='';
			item.hp.text=item.ammotip.text='';
			item.alpha=1;
			if (page2==1) {
				if (obj.ok>1) item.alpha=0.5;
				if (obj.kol>0) item.hp.text=obj.kol;
			} else if (page2==2) {
			} else if (page2==3) {
				item.hp.text=Math.round(obj.hp/obj.maxhp*1000)/10+'%';
				item.ammotip.text=Math.round(obj.rep*gg.pers.repairMult*1000)/10+'%';
			}
			item.ammo.text='';
		}
		
		
		//информация об элементе
		override function statInfo(event:MouseEvent) {
			assId=null;
			if (page2==1) {
				infoItem(event.currentTarget.cat.text,event.currentTarget.id.text,event.currentTarget.nazv.text, 1);
			}
			if (page2==2) {
				if (event.currentTarget.cat.text==Item.L_ARMOR) {
					infoItem(event.currentTarget.cat.text,event.currentTarget.id.text,event.currentTarget.nazv.text, 2);
				} else {
					infoItem(event.currentTarget.cat.text,event.currentTarget.id.text+'^1',event.currentTarget.nazv.text+' - II', 2);
				}
			}
			if (page2==3) {
				infoItem(event.currentTarget.cat.text,event.currentTarget.id.text,event.currentTarget.nazv.text);
				if (event.currentTarget.cat.text==Item.L_ARMOR) {
					showBottext(inv.armors[event.currentTarget.id.text].idComp);
				}
				if (event.currentTarget.cat.text==Item.L_WEAPON) {
					showBottext('frag');
				}
				if (event.currentTarget.cat.text==Item.L_INSTR) {
					showBottext('scrap');
				}
			}
		}
		
		function showBottext(cid) {
			if (inv.items[cid]) {
				vis.bottext.htmlText=Res.txt('i',cid)+ ': '+yel(inv.items[cid].kol);
				if (World.w.loc.base && inv.items[cid].vault>0) vis.bottext.htmlText+=' (+'+yel(inv.items[cid].vault)+' '+Res.pipText('invault')+')';
			} else {
				vis.bottext.htmlText='';
			}
		}
		
		function checkScheme(sch:XML):Boolean {
			if (sch.@skill.length() && sch.@lvl.length() && gg.pers.getSkillLevel(sch.@skill)<sch.@lvl) {
				World.w.gui.infoText('needSkill', Res.txt('e',sch.@skill), sch.@lvl);	//требуется навык
				return false;
			}
			for each(var c in sch.craft) {
				if (inv.items[c.@id]==null || (inv.items[c.@id].kol+inv.items[c.@id].vault)<c.@kol) {
					World.w.gui.infoText('noMaterials');
					return false;
				}
			}
			return true;
		}
		
		//вычесть нужное для крафта количество компонентов
		function minusCraftComp(sch) {
			for each(var c in sch.craft) {
				inv.minusItem(c.@id,c.@kol,false);
			}
		}
		
		override function itemClick(event:MouseEvent) {
			if (pip.noAct) {
				World.w.gui.infoText('noAct');
				return;
			}
			var w:Weapon;
			var arm:Armor;
			var cid:String=event.currentTarget.id.text;
			var ccat:String=event.currentTarget.cat.text;
			var cnazv:String=event.currentTarget.nazv.text
			if (page2==1) {
				var sch=AllData.d.item.(@id=='s_'+cid);
				if (sch.length()) sch=sch[0];
				var kol:int=1;
				if (sch.@kol.length()) kol=int(sch.@kol);
				if (sch.@perk=='potmaster' && gg.pers.potmaster) kol*=2;
				if (!checkScheme(sch)) return;
				if (ccat==Item.L_WEAPON) {
					w=inv.weapons[cid];
					var obj=assArr[cid];
					if (w.tip!=4 && w.respect!=3) return;
					minusCraftComp(sch);
					if (w.tip!=4) {
						w.respect=0;
						w.hold=w.holder;
						World.w.gui.infoText('created',cnazv);
						setStatus();
					} else {
						inv.plusItem(w.id,kol);
						obj.kol=inv.items[w.id].kol;
						World.w.gui.infoText('created2',cnazv,inv.items[cid].kol);
						infoItem(ccat,cid,cnazv, 1);
						setStatItem(event.currentTarget as MovieClip, obj);
					}
					inv.calcWeaponMass();
				} else if (ccat==Item.L_ARMOR) {
					arm=inv.armors[cid];
					if (arm.lvl>=0) return;
					minusCraftComp(sch);
					arm.lvl=0;
					World.w.gui.infoText('created3',cnazv);
					setStatus();
				} else if (ccat==Item.L_IMPL) {
					minusCraftComp(sch);
					inv.plusItem(cid,1);
					inv.takeScript(cid);
					World.w.gui.infoText('created4',cnazv);
					gg.pers.setParameters();
					setStatus();
				} else if (ccat==Item.L_ITEM) {
					var obj=assArr[cid];
					minusCraftComp(sch);
					inv.plusItem(cid,kol);
					obj.kol=inv.items[cid].kol;
					World.w.gui.infoText('created2',cnazv,inv.items[cid].kol);
					infoItem(ccat,cid,cnazv, 1);
					if (inv.items[cid].xml && inv.items[cid].xml.@one=='1') setStatus();
					//setStatus(false);
					setStatItem(event.currentTarget as MovieClip, obj);
				}
				World.w.game.checkQuests(cid);
				if (World.w.helpMess && inv.items[cid]) {
					var lmess:String=inv.items[cid].mess;
					if (lmess!=null && !(World.w.game.triggers['mess_'+lmess]>0)) {
						World.w.game.triggers['mess_'+lmess]=1;
						World.w.gui.impMess(Res.txt('i',lmess),Res.txt('i',lmess,2),lmess);
						pip.onoff(-1);
					}
				}
			} else if (page2==2) {
				if (ccat==Item.L_ARMOR) {
					arm=inv.armors[cid];
					if (arm==null) return;
					var kol=arm.needComp();
					if (inv.checkKol(arm.idComp,kol)) {
						inv.minusItem(arm.idComp,kol,false);
						arm.upgrade();
						gg.pers.setParameters();
						World.w.gui.infoText('upArmor');
						setStatus();
					} else {
						World.w.gui.infoText('noMaterials');
					}
				} else if (ccat==Item.L_WEAPON) {
					var sch=AllData.d.item.(@id=='s_'+cid);
					if (sch.length()) sch=sch[0];
					if (!checkScheme(sch)) return;
					minusCraftComp(sch);
					inv.updWeapon(cid,1);
					World.w.gui.infoText('created',cnazv+Weapon.variant2);
					setStatus();
				}
			} else if (page2==3) {
				var obj=assArr[cid];
				if (ccat==Item.L_ARMOR) {
					arm=inv.armors[cid];
					if (arm.hp>=arm.maxhp) {
						World.w.gui.infoText('noRepair');
						return;
					}
					var cid2:String=inv.armors[cid].idComp;
					if (inv.checkKol(cid2)) {
						arm.repair(arm.maxhp*gg.pers.repairMult/arm.kolComp);
						inv.minusItem(cid2);
						obj.hp=arm.hp;
						showBottext(cid2);
					} else {
						World.w.gui.infoText('noMaterials');
					}
				} else if (ccat==Item.L_WEAPON) {
					if (inv.checkKol('frag')) {
						w=inv.weapons[cid];
						if (inv.repWeapon(w,0.25)) {
							inv.minusItem('frag');
							obj.hp=w.hp;
							showBottext('frag');
						}
					} else {
						World.w.gui.infoText('noMaterials');
					}
				} else if (ccat==Item.L_INSTR) {
					if (inv.checkKol('scrap')) {
						var owl:UnitPet=gg.pets[cid];
						if (owl.repair(owlRep*gg.pers.repairMult)) {
							inv.minusItem('scrap');
							obj.hp=owl.hp;
							showBottext('scrap');
						}
					} else {
						World.w.gui.infoText('noMaterials');
					}
				}
				setStatItem(event.currentTarget as MovieClip, obj);
			}
			pip.snd(1);
			inv.calcMass();
			pip.setRPanel();
		}
		
		
		
	}
	
}

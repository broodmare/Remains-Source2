package fe.inter {
	
	import fe.*;
	import fe.unit.Unit;
	import fe.unit.Armor;
	import fe.unit.UnitPlayer;
	import fe.unit.UnitPet;
	import fe.serv.Item;
	import fe.serv.Vendor;
	import fe.weapon.Weapon;
	import fe.loc.Quest;
	import fe.loc.LandAct;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import fl.controls.NumericStepper;
	import flash.text.TextFormat;
	
	public class PipPageVend extends PipPage{
		
		var vend:Vendor;
		var npcId:String='';
		var assArr:Array;
		var npcInter:String='';
		var repOwl:int=2;	//цена ремонта совы
		var inbase:Boolean=false;
		var selall:Boolean=true;

		public function PipPageVend(npip:PipBuck, npp:String) {
			isLC=isRC=true;
			itemClass=visPipBuyItem;
			super(npip,npp);
			vis.but5.visible=false;
			vis.butOk.text.text=Res.pipText('transaction');
			vis.butOk.addEventListener(MouseEvent.CLICK,transOk);
			var tf:TextFormat=new TextFormat();
			tf.color = 0x00FF99; 
			tf.size = 16; 
			for (var i=0; i<maxrows; i++) {
				var item:MovieClip=statArr[i]; 
				var ns:NumericStepper=item.ns;
				ns.addEventListener(MouseEvent.CLICK,nsClick);
				ns.addEventListener(Event.CHANGE,nsCh);
				ns.tabEnabled=false;
				ns.focusRect=false;
				//ns.textField.textField.textColor=0x00FF99;
				ns.setStyle("textFormat", tf);
			}
			tips=[[],
				['',
					[Item.L_WEAPON, Item.L_ARMOR,'spell'],
					['a','e'],
					['med','him','pot','food'],
					['equip','art','book','sphera','spec','key','impl','instr'],
					['stuff','compa','compw','compe','compm','compp'],
				'scheme'],
				['',
					'valuables',
					['a','e'],
					['med','him','pot','equip','food'],
					'food',
					['stuff','compa','compw','compe','compm','spec'],
				'compp']
			];
			initCats();
		}

		//подготовка страниц
		override function setSubPages() {
			vend=pip.vendor;
			npcId=pip.npcId;
			if (vend) {
				vend.kolBou=0;
			}
			inbase=World.w.loc.base;
			npcInter=pip.npcInter;
			vis.but3.visible=true;
			vis.but4.visible=true;
			statHead.price.x=504;
			statHead.price.width=150;
			if (npcId=='') {
				if (page2==4) page2=1;
				vis.but4.visible=false;
			}
			//trace(npcId, npcInter)
			if (npcInter=='vr') vis.but3.text.text=Res.pipText('vend3');
			if (npcInter=='doc') vis.but3.text.text=Res.pipText('med1');
			if (npcInter=='v') {
				vis.but3.visible=false;
				if (page2==3) page2=1;
			}
			statHead.rid.visible=false;
			var ns:NumericStepper=statHead.ns;
			ns.visible=false;
			setCats();
			if (vend==null) {
				vis.visible=false;
				return;
			}
			if (page2==1) {
				assArr=new Array();
				pip.money=inv.money.kol;
				setTopText('infotrade');
				statHead.nazv.text=Res.pipText('iv1');
				statHead.hp.text=Res.pipText('iv2')+' / '+Res.pipText('iv6');
				statHead.price.text=Res.pipText('iv3');
				statHead.kol.text=Res.pipText('iv4');
				//statHead.bou.text='';
				statHead.cat.visible=false;
				for each(var b:Item in vend.buys) {
					if (b.kol<=0) continue;
					try {
					if (b.tip==Item.L_SCHEME && (inv.weapons[b.id.substr(2)]!=null || inv.items[b.id].kol>0)) continue;
					if (b.tip==Item.L_WEAPON && (inv.weapons[b.id]!=null && inv.weapons[b.id].variant>=b.variant)) continue;
					if (b.tip==Item.L_ARMOR && inv.armors[b.id]!=null) continue;
					if (b.tip!=Item.L_WEAPON && b.xml && b.xml.@price.length()==0)  continue;
					if ((b.tip==Item.L_ART || b.tip==Item.L_IMPL) && inv.items[b.id].kol>0) continue;
					if (b.lvl>gg.pers.level || b.barter>gg.pers.barterLvl) continue;
					if (b.trig && World.w.game.triggers[b.trig]!=1) continue;
					if (b.hardinv && !World.w.hardInv) continue;
					if (!checkCat(b.tip)) continue;
					b.getPrice();
					var mp=b.getMultPrice();
					if (vend.multPrice>mp) mp=vend.multPrice;
					var n:Object={tip:b.tip, id:b.id, nazv:b.nazv, sost:b.sost*b.multHP, price:b.price, mp:mp, kol:b.kol, bou:0, sort:Res.pipText(b.tip), barter:b.barter, variant:b.variant};
					if (b.variant>0) n.rid=b.id+'^'+b.variant;
					else n.rid=b.id;
					if (b.nocheap) n.mp=1;
					if (gg.invent.items[b.id]) n.sost=gg.invent.items[b.id].kol;
					assArr[n.rid]=n;
					n.wtip=b.wtip;
					if (b.xml && b.xml.@tip=='food' && b.xml.@ftip=='1') {
						n.wtip='drink';
					}
					arr.push(n);
					} catch (err) {
						trace('ошибка торговца, товар', b.id);
					}
				}
				if (arr.length) {
					arr.sortOn(['sort','barter','price'],[0,0,Array.NUMERIC]);
					vis.emptytext.text='';
					statHead.visible=true;
				} else {
					vis.emptytext.text=Res.pipText('emptybuy');
					statHead.visible=false;
				}

				vis.butOk.text.text=Res.pipText('transaction');
				vis.butOk.visible=false;
			} 
			if (page2==2) {
				assArr=new Array();
				pip.money=inv.money.kol;
				setTopText('infotrade');
				vend.kolSell=0;
				statHead.nazv.text=Res.pipText('iv1');
				statHead.hp.text='';
				statHead.price.text=Res.pipText('iv3');
				statHead.kol.text=Res.pipText('iv6');
				//statHead.bou.text='';
				statHead.cat.visible=false;
				for (var s in inv.items) {
					if (s=='' || inv.items[s].kol<=0) continue;
					var node=inv.items[s].xml;
					if (node==null) continue;
					if (node.@sell>0) {
						if (!checkCat(node.@tip)) continue;
						var n={tip:inv.items[s].tip, id:s, nazv:inv.items[s].nazv, kol:inv.items[s].kol, bou:0, sort:'b'};
						if (inv.weapons[s]!=null) n.nazv=Res.txt('w',s); 
						n.price=node.@sell;
						n.wtip=node.@tip;
						if (node.@tip=='food' && node.@ftip=='1') {
							n.wtip='drink';
						}
						if (n.wtip=='valuables') n.sort='a';
						//vend.kolSell+=n.price*n.kol;
						assArr[n.id]=n;
						arr.push(n);
					}
				}
				if (arr.length) {
					arr.sortOn(['sort','wtip','price'],[0,0,Array.NUMERIC]);
					vis.emptytext.text='';
					statHead.visible=true;
				} else {
					vis.emptytext.text=Res.pipText('emptysell');
					statHead.visible=false;
				}
				if (inbase) {
					selall=true;
					vis.butOk.text.text=Res.pipText('sellall');
					vis.butOk.visible=true;
				} else {
					vis.butOk.visible=false;
				}
				setIco();
			}
			if (page2==3) {
				assArr=new Array();
				setTopText('inforepair');
				statHead.nazv.text='';
				statHead.hp.text=Res.pipText('iv2');
				statHead.price.text=Res.pipText('iv5');
				statHead.kol.text='';
				statHead.price.x=450;
				//statHead.bou.text='';
				statHead.cat.visible=false;
				if (inv.items['owl'] && inv.items['owl'].kol) {
					World.w.pers.setRoboowl();
					n={tip:Item.L_INSTR, id:'owl', nazv:inv.items['owl'].nazv, hp:World.w.pers.owlhp*World.w.pers.owlhpProc, maxhp:World.w.pers.owlhp, price:World.w.pers.owlhp*repOwl};
					arr.push(n);
					assArr[n.id]=n;
					
				}
				for each (var w:Weapon in inv.weapons) {
					if (w==null) continue;
					if (w.tip!=0 && w.tip!=4 && w.respect!=1 && w.hp<w.maxhp) {
						n={tip:Item.L_WEAPON, id:w.id, nazv:w.nazv, hp:w.hp, maxhp:w.maxhp, price:w.price, variant:w.variant};
						n.wtip='w'+w.skill;
						arr.push(n);
						assArr[n.id]=n;
					}
				}
				for each (var a:Armor in inv.armors) {
					if (a.hp<a.maxhp && a.tip<3) {
						n={tip:Item.L_ARMOR, id:a.id, nazv:a.nazv, hp:a.hp, maxhp:a.maxhp, price:a.price};
						arr.push(n);
						assArr[n.id]=n;
						n.wtip='armor1';
					}
				}
				if (arr.length) {
					arr.sortOn(['price'],[Array.NUMERIC]);
					vis.emptytext.text='';
					statHead.visible=true;
				} else {
					vis.emptytext.text=Res.pipText('emptyrep');
					statHead.visible=false;
				}
				vis.butOk.visible=false;
			}
			if (page2==4) {
				//setTopText('infotasks');
				statHead.visible=false;
				if (npcId=='' || vend==null || vend.xml==null || vend.xml.task.length()==0) {
					vis.emptytext.text=Res.pipText('emptytasks');
					return;
				}
				for each(var task in vend.xml.task) {
					if (!checkQuest(task)) continue;
					n={id:task.@id, state:0, sort:0};
					if (task.@skill.length()) {
						n.skill=task.@skill;
						n.skilln=task.@skilln;
					}
					n.nazv=Res.messText(task.@id);
					if (World.w.game.quests[task.@id]) {
						var quest:Quest=World.w.game.quests[task.@id];
						n.state=World.w.game.quests[task.@id].state;
						if (n.state==1 && quest.chReport(npcId, false)) n.state=3;
						if (n.state==1 && quest.chGive(npcId, false)) n.state=4;
					}
					if (n.state==3 || n.state==4) n.sort=1;
					if (n.state==1) n.sort=2;
					if (n.state==2) n.sort=3;
					arr.push(n);
				}
				if (arr.length==0) {
					vis.emptytext.text=Res.pipText('emptytasks');
				} else {
					vis.emptytext.text='';
					arr.sortOn('sort');
				}
			}
			setIco();
			showBottext();
		}
		//
		
		override function setSigns() {
			if (vend==null) return;
			super.setSigns();
			if (vis.but4.visible && vend.xml) {
				for each(var task in vend.xml.task) {
					if (!checkQuest(task)) continue;
					if (World.w.game.quests[task.@id]) {
						var quest:Quest=World.w.game.quests[task.@id];
						var nstate=World.w.game.quests[task.@id].state;
						if (nstate==0 || nstate==1 && quest.chReport(npcId, false) || nstate==1 && quest.chGive(npcId, false)) {
							signs[4]=1;
							break;
						}
					} else {
						signs[4]=1;
						break;
					}
				}
			}
		}
		
		public override function page2Click(event:MouseEvent) {
			if (World.w.ctr.setkeyOn) return;
			page2=int(event.currentTarget.id.text);
			pip.snd(2);
			if (page2==3 && npcInter=='doc') {
				page2=1;
				pip.onoff(6);
			} else {
				setStatus();
			}
		}
		
	
		function showBottext() {
			if (page2==1 && vend) {
				vis.bottext.htmlText=Res.pipText('caps')+': '+yel(pip.money)+' (';
				if (vend.kolBou>0) vis.bottext.htmlText+='-'+yel(Math.ceil(vend.kolBou))+'; ';
				vis.bottext.htmlText+=yel(Math.floor(pip.money-vend.kolBou))+' '+Res.pipText('ost')+')';
			}
			if (page2==2 && vend) {
				vis.bottext.htmlText=Res.pipText('caps')+': '+yel(pip.money)+' (+'+yel(Math.floor(vend.kolSell))+')';
				if (!inbase) vis.bottext.htmlText+='   '+Res.pipText('vcaps')+': '+yel(vend.money);
			}
			if (page2==3) vis.bottext.htmlText=Res.pipText('caps')+': '+yel(inv.money.kol);
		}
		
		//показ одного элемента
		override function setStatItem(item:MovieClip, obj:Object) {
				//trace(obj.id,obj.rid,obj.tip,obj.nazv)
			item.id.text=obj.id;
			item.id.visible=false;
			item.cat.visible=false;
			item.rid.visible=false;
			item.lvl.visible=false;
			item.ns.visible=false;
			item.nazv.alpha=1;
			item.price.x=504;
			item.price.width=58;
			try {
				item.trol.gotoAndStop(obj.wtip);
			} catch (err) {
				item.trol.gotoAndStop(1);
			}
			if (page2==1) {
				item.lvl.visible=true;
				item.lvl.gotoAndStop(obj.barter+1);
				item.rid.text=obj.rid;
				item.cat.text=obj.tip;
				item.nazv.text=obj.nazv;
				if (obj.tip==Item.L_WEAPON || obj.tip==Item.L_ARMOR) {
					item.hp.text=Math.round(obj.sost*100)+'%';
					if (obj.bou==0) item.kol.text=Res.pipText('est');
					else item.kol.text=Res.pipText('sel');
					item.price.text=Math.round(obj.price*obj.mp);
				} else {
					var ns:NumericStepper=item.ns;
					ns.visible=true;
					ns.maximum=obj.kol;
					ns.value=obj.bou;
					item.kol.text=obj.kol-obj.bou;
					item.hp.text=(obj.sost==0)?'-':obj.sost;
					item.price.text=Math.round(obj.price*obj.mp*10)/10;
				}
				//item.bou.text=(obj.bou==0)?'':obj.bou;
			} 
			if (page2==2) {
				item.cat.text=obj.tip;
				item.rid.text=obj.id;
				item.nazv.text=obj.nazv;
				item.hp.text='';
				item.price.text=Math.round(obj.price*10)/10;
				item.kol.text=obj.kol;
				var ns:NumericStepper=item.ns;
				ns.visible=true;
				ns.maximum=obj.kol;
				ns.value=obj.bou;
				item.kol.text=obj.kol-obj.bou;
			} 
			if (page2==3) {
				item.cat.text=obj.tip;
				item.nazv.text=obj.nazv;
				item.hp.text=Math.round(obj.hp/obj.maxhp*100)+'%';
				//item.price.text=Math.ceil(obj.price*(obj.maxhp-obj.hp)/obj.maxhp*0.5*vend.multPrice);
				var mp:Number=1;
				if (obj.tip==Item.L_ARMOR) mp=gg.pers.priceRepArmor;
				item.price.text=Math.ceil(obj.price*(obj.maxhp-obj.hp)/obj.maxhp*vend.multPrice*mp);
				item.kol.text='';
				if (obj.variant>0) item.rid.text=obj.id+'^'+obj.variant;
				else item.rid.text=obj.id;
				//item.bou.text='';
			} 
			if (page2==4) {
				item.cat.text=obj.state;
				item.nazv.text=obj.nazv;
				item.hp.text='';
				item.price.text='';
				item.price.x=400;
				item.price.width=158;
				if (obj.state==1) item.price.text=Res.pipText('perform');
				if (obj.state==2) {
					item.price.text=Res.pipText('done');
					item.nazv.alpha=0.5;
				}
				if (obj.state==3) item.price.text=Res.pipText('surr');
				if (obj.state==4) item.price.text=Res.pipText('progress');
				item.kol.text='';
			}
		}
		
		//информация об элементе
		override function statInfo(event:MouseEvent) {
			if (page2==1 || page2==2 || page2==3) {
				infoItem(event.currentTarget.cat.text,event.currentTarget.rid.text,event.currentTarget.nazv.text);
			}
			if (page2==4) {
				vis.nazv.text=event.currentTarget.nazv.text;
				var s:String=infoQuest(event.currentTarget.id.text);
				if (s=='') vis.info.htmlText=Res.messText(event.currentTarget.id.text,1);
				else vis.info.htmlText=s;
				if (event.currentTarget.cat.text=='0') vis.info.htmlText+="\n\n<span class = 'or'>"+Res.pipText('actTake')+"</span>";
				if (event.currentTarget.cat.text=='3') vis.info.htmlText+="\n\n<span class = 'or'>"+Res.pipText('actSurr')+"</span>";
				if (event.currentTarget.cat.text=='4') vis.info.htmlText+="\n\n<span class = 'or'>"+Res.pipText('actGive')+"</span>";
				setIco();
			}
			event.stopPropagation();
		}
		
		function selBuy(buy:Object, n:int=1) {
			if (selall) vis.butOk.text.text=Res.pipText('transaction');
			selall=false;
			if (buy==null || buy.kol-buy.bou<=0) return;
			if (buy.tip==Item.L_WEAPON && inv.weapons[buy.id]!=null && inv.weapons[buy.id].variant>=buy.variant) return;
			if (buy.tip==Item.L_ARMOR && inv.armors[buy.id]!=null) return;
			if (buy.tip==Item.L_WEAPON && inv.weapons[buy.id]==null) {
				if (vend.buys2[buy.id]) vend.buys2[buy.id].checkAuto(true);
			}
			if (buy.tip==Item.L_SPELL && vend.buys2[buy.id]) vend.buys2[buy.id].checkAuto(true);
			vis.butOk.visible=true;
			if (buy.kol-buy.bou<n) n=buy.kol-buy.bou;
			if (page2==1 && Math.round(buy.price*buy.mp*n)>pip.money-vend.kolBou) {//!!!
				trace(buy.price,buy.mp,n,pip.money,vend.kolBou)
				n=Math.floor((pip.money-vend.kolBou)/(buy.price*buy.mp));
				trace(n);
				if (n<=0) {
					World.w.gui.infoText('noMoney',Math.round(buy.price*buy.mp-(pip.money-vend.kolBou)));
					return;
				}
			}
			buy.bou+=n;
			if (page2==1) vend.kolBou+=buy.price*buy.mp*n;
			if (page2==2) vend.kolSell+=buy.price*n;
		}
		
		function unselBuy(buy:Object, n:int=1) {
			if (buy==null || buy.bou<=0) return;
			if (buy.bou<n) n=buy.bou;
			buy.bou-=n;
			if (page2==1) vend.kolBou-=buy.price*buy.mp*n;
			if (page2==2) vend.kolSell-=buy.price*n;
		}
		
		/*function chBuy(buy:Object, kol:int=0) {
			if (buy==null) return;
			vis.butOk.visible=true;
			if (Math.round(buy.price*vend.multPrice*n)>pip.money-vend.kolBou) {
				n=Math.floor((pip.money-vend.kolBou)/buy.price*vend.multPrice);
				if (n<=0) {
					World.w.gui.infoText('noMoney',Math.round(buy.price*vend.multPrice-(pip.money-vend.kolBou)));
					return;
				}
			}
		}*/
		
		function nsClick(event:MouseEvent) {
			event.stopPropagation();
		}
		function nsCh(event:Event) {
			if (page2==1 || page2==2) {
				var buy:Object=assArr[event.currentTarget.parent.rid.text];
				var n=event.currentTarget.value-buy.bou;
				if (n>0) selBuy(buy, n);
				else if (n<0) unselBuy(buy, -n);
				if (n!=0) {
					setStatItem(event.currentTarget.parent as MovieClip, buy);
					showBottext();
				}
			}
		}
		
		override function itemClick(event:MouseEvent) {
			if (page2==1 || page2==2) {
				var buy:Object=assArr[event.currentTarget.rid.text];
				var n=1;
				if (event.shiftKey) n=buy.kol-buy.bou;
				if (event.shiftKey && event.ctrlKey) n=buy.bou;
				if (event.ctrlKey) unselBuy(buy, n);
				else selBuy(buy, n);
				setStatItem(event.currentTarget as MovieClip, buy);
			}
			if (page2==3) {
				if (inv.money.kol<=0) return;
				var price:int=event.currentTarget.price.text;
				if (price<=0) return;
				if (price>inv.money.kol) price=inv.money.kol;
				var obj;
				if (event.currentTarget.cat.text==Item.L_INSTR) {
					var owl:UnitPet=gg.pets[event.currentTarget.id.text];
					var hl:Number=price/repOwl/vend.multPrice;
					if (hl>owl.maxhp-owl.hp) {
						hl=(owl.maxhp-owl.hp);
						price=hl*repOwl*vend.multPrice;
					}
					owl.repair(hl);
					obj=assArr[event.currentTarget.id.text];
					obj.hp=owl.hp;
					//trace(owl.maxhp, hl, price, vend.multPrice);
				}
				if (event.currentTarget.cat.text==Item.L_WEAPON) {
					var w:Weapon=inv.weapons[event.currentTarget.id.text];
					var hp:int=Math.ceil(price/w.price*w.maxhp/vend.multPrice);
					w.repair(hp);
					obj=assArr[event.currentTarget.id.text];
					obj.hp=w.hp;
				}
				if (event.currentTarget.cat.text==Item.L_ARMOR) {
					var a:Armor=inv.armors[event.currentTarget.id.text];
					var hp:int=Math.ceil(price/a.price*a.maxhp/vend.multPrice/gg.pers.priceRepArmor);
					a.repair(hp);
					obj=assArr[event.currentTarget.id.text];
					obj.hp=a.hp;
				}
				inv.money.kol-=price;
				pip.vendor.money+=price;
				setStatItem(event.currentTarget as MovieClip, obj);
				World.w.gui.setWeapon();
				pip.setRPanel();
			}
			if (page2==4) {
				try {
					if (World.w.game.quests[event.currentTarget.id.text]) {
						var quest:Quest=World.w.game.quests[event.currentTarget.id.text];
						quest.chGive(npcId, true);
						quest.chReport(npcId, true);
					} else World.w.game.addQuest(event.currentTarget.id.text);
				} catch(err) {}
				setStatus(false);
			}
			pip.snd(1);
			showBottext();
			event.stopPropagation();
		}
		override function itemRightClick(event:MouseEvent) {
			if (page2==1 || page2==2) {
				var buy:Object=assArr[event.currentTarget.rid.text];
				var n=1;
				if (event.shiftKey) n=10;
				unselBuy(buy, n);
				setStatItem(event.currentTarget as MovieClip, buy);
			}
			pip.snd(1);
			showBottext();
			event.stopPropagation();
		}
		
		function transOk(event:MouseEvent) {
			if (page2==1) {
				trade(assArr);
			}
			if (page2==2) {
				if (selall) sellAll();
				else sell(assArr);
			}
			pip.setRPanel();
			pip.snd(3);
				//pip.sellAll();
		}
		
		public function trade(arr:Array) {
			if (vend.kolBou>inv.money.kol) return;
			for each(var buy:Item in vend.buys) {
				var rid:String=buy.id;
				if (buy.variant>0) rid+='^'+buy.variant;
				if (arr[rid] && arr[rid].bou>0) {
					buy.bou=arr[rid].bou;
					inv.take(buy,1);
				}
			}
			inv.money.kol-=Math.ceil(vend.kolBou);
			vend.money+=Math.ceil(vend.kolBou);
			pip.money=inv.money.kol;
			vend.kolBou=0;
			inv.calcMass();
			inv.calcWeaponMass();
			setStatus();
		}
		
		public function sell(arr:Array) {
			if (!inbase && Math.ceil(vend.kolSell)>vend.money) {
				World.w.gui.infoText('noSell');
				return;
			}
			for (var s in inv.items) {
				if (s=='' || inv.items[s].kol<=0) continue;
				var node=inv.items[s].xml;
				if (node==null) continue;
				if (arr[s] && arr[s].bou>0) {
					//if (inv.items[s]<arr[s].bou) arr[s].bou=inv.items[s];
					var buy:Item=vend.buys2[s];
					if (buy==null) {
						buy=new Item(null,s,0);
						buy.kol=0;
						vend.buys.push(buy);
						vend.buys2[s]=buy;
					}
					buy.kol+=arr[s].bou;
					inv.items[s].kol-=arr[s].bou;
					//inv.items['money']+=arr[s].bou*arr[s].price;
				}
			}
			inv.money.kol+=Math.floor(vend.kolSell);
			vend.money-=Math.ceil(vend.kolSell);
			pip.money=inv.money.kol;
			vend.kolSell=0;
			setStatus();
		}
		
		public function sellAll() {
			for (var s in arr) {
				if (arr[s].tip=='valuables') {
					selBuy(arr[s],arr[s].kol-arr[s].bou);
				}
			}
			vis.butOk.text.text=Res.pipText('transaction');
			selall=false;
			showBottext();
			setStatItems();
		}
	}
	
}

package fe.inter {

	import flash.display.MovieClip;
	import flash.events.MouseEvent;

	import fe.*;
	import fe.unit.Pers;
	import fe.serv.Item;

	import fe.stubs.visPipMedItem;
	
	/* 
	*	The healing menu when interacting with doctors
	*	sub-categories:
	*		1 - Healing
	*		2 - Trading
	*		3 - *disabled*
	*		4 - *disabled*
	*		5 - *disabled*
	*/
	public class PipPageMed extends PipPage {

		var pers:Pers;
		var infoItemId:String='';
		var priceHP:Number=0.5;
		var priceBlood:Number=0.5;
		var priceRad:Number=1;
		var priceOrgan:Number=0.5;
		var priceCut:Number=4;
		var pricePoison:Number=4;
		var priceMana:Number=1;
		var raz:int=200;
		var razMana:int=100;
		
		var plata:Item;

		// Constructor
		public function PipPageMed(npip:PipBuck, npp:String) {
			isLC = true;
			itemClass = visPipMedItem;
			super(npip, npp);

			// Set which sub-categories are disabled at the top of the pip-buck
			vis.but3.visible = false;
			vis.but4.visible = false;
			vis.but5.visible = false;
		}

		//подготовка страниц
		override protected function setSubPages():void {
			setIco();
			
			if (pip.npcInter=='adoc') {
				vis.but2.visible=false;
				plata=inv.gel;
			}
			else if (pip.npcInter=='vdoc') {
				vis.but2.visible=false;
				plata=inv.good;
			}
			else {
				vis.but2.visible=true;
				plata=inv.money;
			}
			
			pers=World.w.pers;
			priceHP=pers.priceHP;
			priceBlood=pers.priceBlood;
			priceRad=pers.priceRad;
			priceOrgan=pers.priceOrgan;
			priceCut=pers.priceCut;
			pricePoison=pers.pricePoison;
			priceMana=pers.priceMana;
			
			statHead.hpbar.visible=false;
			statHead.nazv.text='';
			statHead.numb.text='';
			statHead.price.text=Res.pipText('medprice');
			vis.butOk.visible=vis.butDef.visible=false;
			if (page2==1) {
				gg.pers.checkHP();
				setTopText('usemed2');
				var cena:Number;
				cena=(gg.maxhp-gg.hp-gg.rad)*priceHP;
				if (cena<0) cena=0;
				
				arr.push({id:'hp', nazv:Res.pipText('hp'), lvl:Math.round(gg.hp)+'/'+Math.round(gg.maxhp), bar:(gg.hp/gg.maxhp), price:cena});
				arr.push({id:'organism', nazv:Res.pipText('organism')+':', lvl:''});
				
				if (gg.pers.inMaxHP-gg.pers.headHP>raz) cena=raz*priceOrgan; else cena=(gg.pers.inMaxHP-gg.pers.headHP)*priceOrgan;
				arr.push({id:'statHead'+gg.pers.headSt,nazv:'   '+Res.pipText('head'), lvl:Math.round(gg.pers.headHP)+'/'+Math.round(gg.pers.inMaxHP), bar:(gg.pers.headHP/gg.pers.inMaxHP), price:cena});
				
				if (gg.pers.inMaxHP-gg.pers.torsHP>raz) cena=raz*priceOrgan; else cena=(gg.pers.inMaxHP-gg.pers.torsHP)*priceOrgan;
				arr.push({id:'statTors'+gg.pers.torsSt,nazv:'   '+Res.pipText('tors'), lvl:Math.round(gg.pers.torsHP)+'/'+Math.round(gg.pers.inMaxHP), bar:(gg.pers.torsHP/gg.pers.inMaxHP), price:cena});
				
				if (gg.pers.inMaxHP-gg.pers.legsHP>raz) cena=raz*priceOrgan; else cena=(gg.pers.inMaxHP-gg.pers.legsHP)*priceOrgan;
				arr.push({id:'statLegs'+gg.pers.legsSt,nazv:'   '+Res.pipText('legs'), lvl:Math.round(gg.pers.legsHP)+'/'+Math.round(gg.pers.inMaxHP), bar:(gg.pers.legsHP/gg.pers.inMaxHP), price:cena});
				
				if (gg.pers.inMaxHP-gg.pers.bloodHP>raz) cena=raz*priceBlood; else cena=(gg.pers.inMaxHP-gg.pers.bloodHP)*priceBlood;
				arr.push({id:'statBlood'+gg.pers.bloodSt,nazv:'   '+Res.pipText('blood'), lvl:Math.round(gg.pers.bloodHP)+'/'+Math.round(gg.pers.inMaxHP), bar:(gg.pers.bloodHP/gg.pers.inMaxHP), price:cena});
				
				if (gg.pers.inMaxMana-gg.pers.manaHP>razMana) cena=razMana*priceMana; else cena=(gg.pers.inMaxMana-gg.pers.manaHP)*priceMana;
				arr.push({id:'statMana'+gg.pers.manaSt,nazv:'   '+Res.pipText('mana'), lvl:Math.round(gg.pers.manaHP)+'/'+Math.round(gg.pers.inMaxMana), bar:(gg.pers.manaHP/gg.pers.inMaxMana), price:cena});
				
				cena=(gg.rad)*priceRad;
				arr.push({id:'rad', nazv:Res.pipText('rad'), lvl:Math.round(gg.rad), price:cena});
				cena=(gg.cut)*priceCut;
				arr.push({id:'cut', nazv:Res.pipText('cut'), lvl:Math.round(gg.cut*10)/10, price:cena});
				cena=(gg.poison)*pricePoison;
				arr.push({id:'poison', nazv:Res.pipText('poison'), lvl:Math.round(gg.poison*10)/10, price:cena});
			}
			showBottext();
		}
		
		//показ одного элемента
		override protected function setStatItem(item:MovieClip, obj:Object):void {
			if (obj.id == null) {
                item.id.text = '';
            }
			else item.id.text = obj.id;
			
			item.id.visible=false;
			item.hpbar.visible=false;
			item.nazv.text=obj.nazv;
			item.numb.text=obj.lvl;
			
			if (obj.price == null) {
                item.price.text = '';
            }
			else {
				item.price.text = Math.round(obj.price);
			}
			
			if (obj.bar!=null) {
				item.hpbar.visible=true;
				item.hpbar.bar.scaleX=obj.bar;
			}
		}
		
		//информация об элементе
		override protected function statInfo(event:MouseEvent):void
		{
				if (event.currentTarget.id.text == '') {
                    vis.nazv.text = vis.info.htmlText = '';
                }
				else {
                    vis.nazv.text = Res.pipText(event.currentTarget.id.text);
                    var s:String = Res.txt('p', event.currentTarget.id.text, 1);
                    vis.info.htmlText = s;
                }
		}
		
		override protected function page2Click(event:MouseEvent):void {
			if (World.w.ctr.setkeyOn) return;
			page2=int(event.currentTarget.id.text);
			pip.snd(2);
			if (page2==2) {
				page2=1;
				pip.onoff(4);
				pip.currentPage.page2=1;
				pip.currentPage.setStatus();
			}
			else {
				setStatus();
			}
		}

		private function showBottext():void {
			if (pip.npcInter=='adoc') vis.bottext.htmlText=Res.txt('i','gel')+': '+numberAsColor('yellow', plata.kol);
			else if (pip.npcInter=='vdoc') vis.bottext.htmlText=Res.txt('i','good')+': '+numberAsColor('yellow', plata.kol);
			else vis.bottext.htmlText=Res.pipText('caps')+': '+numberAsColor('yellow', plata.kol);
		}
		
		override protected function itemClick(event:MouseEvent):void {
			if (pip.noAct) {
				World.w.gui.infoText('noAct');
				return;
			}
			
			var cena:Number;
			var need:String;
			var mon = plata.kol;

			infoItemId = getSimplifiedItemId(event.currentTarget.id.text);
			switch (infoItemId) {
				case 'hp':
					cena = (gg.maxhp - gg.hp - gg.rad) * priceHP;
					if (cena > plata.kol) cena = plata.kol;
					gg.heal(cena / priceHP, 0, false);
					break;

				case 'rad':
					cena = (gg.rad) * priceRad;
					if (cena > plata.kol) cena = plata.kol;
					gg.heal(cena / priceRad, 2, false);
					break;

				case 'cut':
					cena = (gg.cut) * priceCut;
					if (cena > plata.kol) cena = plata.kol;
					gg.heal(cena / priceCut, 3, false);
					break;

				case 'poison':
					cena = (gg.poison) * pricePoison;
					if (cena > plata.kol) cena = plata.kol;
					gg.heal(cena / pricePoison, 4, false);
					break;

				case 'statBlood':
					if (gg.pers.inMaxHP - gg.pers.bloodHP > raz) cena = raz * priceBlood; 
					else cena = (gg.pers.inMaxHP - gg.pers.bloodHP) * priceBlood;

					if (cena > plata.kol) cena = plata.kol;

					if (healCheckPassed(gg.pers.bloodHP)) gg.pers.heal(49, 5);
					else gg.pers.heal(cena / priceBlood, 5);
					break;
				
				case 'statMana':
					if (gg.pers.inMaxMana - gg.pers.manaHP > razMana) cena = razMana * priceMana; 
					else cena = (gg.pers.inMaxMana - gg.pers.manaHP) * priceMana;

					if (cena > plata.kol) cena = plata.kol;

					gg.pers.heal(cena / priceMana, 6);
					break;

				case 'statHead':
					if (gg.pers.inMaxHP-gg.pers.headHP>raz) cena = raz * priceOrgan; 
					else cena = (gg.pers.inMaxHP - gg.pers.headHP) * priceOrgan;

					if (cena > plata.kol) cena = plata.kol;

					if (healCheckPassed(gg.pers.headHP)) gg.pers.heal(49, 1);
					else gg.pers.heal(cena / priceOrgan, 1);
					break;
				
				case 'statTors':
					if (gg.pers.inMaxHP - gg.pers.torsHP > raz) cena = raz * priceOrgan; 
					else cena = (gg.pers.inMaxHP - gg.pers.torsHP) * priceOrgan;

					if (cena > plata.kol) cena = plata.kol;

					if (healCheckPassed(gg.pers.torsHP)) gg.pers.heal(49, 2);
					else gg.pers.heal(cena / priceOrgan, 2);
					break;

				case 'statLegs':
					if (gg.pers.inMaxHP - gg.pers.legsHP > raz) cena = raz * priceOrgan; 
					else cena = (gg.pers.inMaxHP - gg.pers.legsHP) * priceOrgan;

					if (cena > plata.kol) cena = plata.kol;

					if (healCheckPassed(gg.pers.legsHP)) gg.pers.heal(49, 3);
					else gg.pers.heal(cena / priceOrgan, 3);
					break;
			}
			
			plata.kol -= Math.round(cena);

			if (plata.id == 'money' && plata.kol < mon && pip.vendor) {
				pip.vendor.money += (mon - plata.kol);
			}

			pip.snd(1);
			setStatus();
			showBottext();
			pip.setRPanel();

			// Helper functions
			function getSimplifiedItemId(infoItemId:String):String {
				if (infoItemId.indexOf('statBlood') == 0) return 'statBlood';
				if (infoItemId.indexOf('statMana')  == 0) return 'statMana';
				if (infoItemId.indexOf('statHead')  == 0) return 'statHead';
				if (infoItemId.indexOf('statTors')  == 0) return 'statTors';
				if (infoItemId.indexOf('statLegs')  == 0) return 'statLegs';

				return infoItemId;
			}

			function healCheckPassed(input:Number):Boolean {
				if (input <= 2 && plata.kol <= 0 && gg.pers.level < 6) return true
				else return false;
			}
		}
	}	
}
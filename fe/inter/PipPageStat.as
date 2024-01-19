package fe.inter
{
	import fe.*;
	import fe.unit.Unit;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import fe.unit.Pers;

	import fe.stubs.visPipStatItem;
	
	public class PipPageStat extends PipPage
	{
		private var pers:Pers;
		private var skills:Array;
		private var maxSkLvl:int=20;
		private var skillPoint:int=0;
		private var perkPoint:int=0;
		private var selectedPerk:String = '';
		private var infoItemId:String = '';
		private var n_food:String;
		private var drunk:int = 0;

		private static var cachedPerkList:XMLList = XMLDataGrabber.getNodesWithName("core", "AllData", "perks", "perk");
		private static var cachedParamList:XMLList = XMLDataGrabber.getNodesWithName("core", "AllData", "params", "param");

		private static var cachedPerks:Object = {};
		private static var cachedParams:Object = {};

		public function PipPageStat(npip:PipBuck, npp:String)
		{
			isLC=isRC=true;
			itemClass=visPipStatItem;
			skills=new Array();
			super(npip, npp);
			vis.butOk.addEventListener(MouseEvent.CLICK,transOk);
			vis.butDef.addEventListener(MouseEvent.CLICK,gotoDef);
			n_food=Res.txt('e','food');
		}

		public static function getPerkInfo(id:String):XML
		{
			var node:XML;
			if (cachedPerks[id] != undefined) node = cachedPerks[id];
			else
			{
				node = XMLDataGrabber.getNodeWithAttributeThatMatches("core", "AllData", "perks", "id", id);
				cachedPerks[id] = node;
			}
			return node;
		}

		public static function getParamInfo(id:String):XML
		{
			var node:XML;
			if (cachedParams[id] != undefined) node = cachedParams[id];
			else
			{
				node = XMLDataGrabber.getNodeWithAttributeThatMatches("core", "AllData", "params", "id", id);
				cachedParams[id] = node;
			}
			return node;
		}
		
		//подготовка страниц
		override protected function setSubPages():void
		{
			setIco();
			pers=World.w.pers;
			maxSkLvl=Pers.maxSkLvl;
			statHead.progress.visible=false;
			statHead.hpbar.visible=statHead.cat.visible=false;
			statHead.numb.x=335;
			vis.butOk.visible=vis.butDef.visible=false;
			drunk=0;
			if (page2==1) {
				statHead.nazv.text=statHead.numb.text='';
				arr.push({nazv:Res.pipText('name'), lvl:gg.pers.persName});
				arr.push({nazv:Res.pipText('level'), lvl:gg.pers.level});
				arr.push({nazv:Res.pipText('expa'), lvl:gg.pers.xpCur+' ('+(gg.pers.xpNext-gg.pers.xpCur)+')'});
				arr.push({id:'diff', nazv:Res.pipText('diff'), lvl:Res.guiText('dif'+World.w.game.globalDif)});
				arr.push({id:'reput', nazv:Res.pipText('reput'), lvl:(gg.pers.rep+' ('+gg.pers.repTex()+')')});
				var arm:String='';

				for (var i = 0; i < cachedParamList.length(); i++)
				{
					var xml:XML = cachedParamList[i];
					if (xml.@show > 0)
					{
						if (xml.@show=='2' && gg.armor==0 && gg.marmor==0) continue;
						if (xml.@show=='3' && (!World.w.game.triggers['story_canter']>0)) continue;
						var nazv:String = Res.pipText(xml.@id);
						if (xml.@v!='') nazv='-  '+nazv;
						else {
							arr.push({id:xml.@id, nazv:nazv, lvl:''});
							continue;
						}
						var param;
						if (xml.@tip=='4') param=gg.vulner[xml.@v];
						else if (gg.hasOwnProperty(xml.@v)) param=gg[xml.@v];
						else if (gg.pers.hasOwnProperty(xml.@v)) param=gg.pers[xml.@v];
						else {
							trace('нет переменной',xml.@v);
							continue;
						}
						if (xml.@tip=='0') {
							if (param>0) arr.push({id:xml.@id, nazv:nazv, lvl:Res.numb(param)});
						}
						if (xml.@tip=='1') {
							if (param!=1 || World.w.pers.factor[xml.@v] && World.w.pers.factor[xml.@v].length>1) arr.push({id:xml.@id, nazv:nazv, lvl:((param>=1?'+':'')+Res.numb((param-1)*100)+'%')});
						}
						if (xml.@tip=='2') {
							arr.push({id:xml.@id, nazv:nazv, lvl:(Res.numb(param*100)+'%')});
						}
						if (xml.@tip=='3' || xml.@tip=='4') {
							if (param!=1) arr.push({id:xml.@id, nazv:nazv, lvl:((param<1?'+':'')+Res.numb((1-param)*100)+'%')});
						}
					}
				}
			} else if (page2==5) {
				if (World.w.game.triggers['nomed']>0) {
					vis.emptytext.text=Res.pipText('emptymed');
					statHead.visible=false;
					return;
				} else {
					vis.emptytext.text='';
					statHead.visible=true;
				}
				gg.pers.checkHP();
				setTopText('usemed1');
				statHead.nazv.text=statHead.numb.text='';
				arr.push({id:'hp', nazv:Res.pipText('hp'), lvl:Math.round(gg.hp)+'/'+Math.round(gg.maxhp), bar:(gg.hp/gg.maxhp)});
				arr.push({id:'organism', nazv:Res.pipText('organism')+':', lvl:''});
				arr.push({id:'statHead'+gg.pers.headSt,nazv:'   '+Res.pipText('head'), lvl:Math.round(gg.pers.headHP)+'/'+Math.round(gg.pers.inMaxHP), bar:(gg.pers.headHP/gg.pers.inMaxHP)});
				arr.push({id:'statTors'+gg.pers.torsSt,nazv:'   '+Res.pipText('tors'), lvl:Math.round(gg.pers.torsHP)+'/'+Math.round(gg.pers.inMaxHP), bar:(gg.pers.torsHP/gg.pers.inMaxHP)});
				arr.push({id:'statLegs'+gg.pers.legsSt,nazv:'   '+Res.pipText('legs'), lvl:Math.round(gg.pers.legsHP)+'/'+Math.round(gg.pers.inMaxHP), bar:(gg.pers.legsHP/gg.pers.inMaxHP)});
				arr.push({id:'statBlood'+gg.pers.bloodSt,nazv:'   '+Res.pipText('blood'), lvl:Math.round(gg.pers.bloodHP)+'/'+Math.round(gg.pers.inMaxHP), bar:(gg.pers.bloodHP/gg.pers.inMaxHP)});
				arr.push({id:'statMana'+gg.pers.manaSt,nazv:'   '+Res.pipText('mana'), lvl:Math.round(gg.pers.manaHP)+'/'+Math.round(gg.pers.inMaxMana), bar:(gg.pers.manaHP/gg.pers.inMaxMana)});
				arr.push({id:'rad', nazv:Res.pipText('rad'), lvl:Math.round(gg.rad)});
				arr.push({id:'radx', nazv:Res.pipText('radx'), lvl:Math.round((1-gg.radX)*100)+'%'});
				arr.push({id:'cut', nazv:Res.pipText('cut'), lvl:Math.round(gg.cut*10)/10});
				arr.push({id:'resbleeding', nazv:Res.pipText('resbleeding'), lvl:Math.round((1-gg.vulner[Unit.D_BLEED])*100)+'%'});
				arr.push({id:'poison', nazv:Res.pipText('poison'), lvl:Math.round(gg.poison*10)/10});
				arr.push({id:'respoison', nazv:Res.pipText('respoison'), lvl:Math.round((1-gg.vulner[Unit.D_POISON])*100)+'%'});
				if (gg.pets['phoenix'] && World.w.game.triggers['pet_phoenix']) {
					arr.push({id:'phoenix', nazv:gg.pets['phoenix'].nazv, lvl:Math.round(gg.pets['phoenix'].hp)+'/'+Math.round(gg.pets['phoenix'].maxhp)});
				}
				for (var i in pers.addictions) {
					if (pers.addictions[i]>0) {
						var str:String='';
						if (pers.addictions[i]>=pers.ad3) str=Res.pipText('ad3');
						else if (pers.addictions[i]>=pers.ad2) str=Res.pipText('ad2');
						else if (pers.addictions[i]>=pers.ad1) str=Res.pipText('ad1');
						else str=Res.pipText('ad0');
						arr.push({id:i, nazv:Res.txt('e',i+'_ad'), lvl:Math.round(pers.addictions[i])+'% ('+str+')', cat:'ad'});
					}
				}
			} else if (page2==2) {	
				setTopText('infoskills');
				skillPoint=pers.skillPoint;
				statHead.nazv.text=Res.pipText('is1');
				statHead.numb.text=Res.pipText('is2');
				for each(var sk in pers.skill_ids) {
					if (pers.level<Pers.postPersLevel && sk.post>0) continue;
					var numb=pers.skills[sk.id];
					var n:Object={id:sk.id, nazv:Res.txt('e',sk.id), lvl:numb, minlvl:numb, post:sk.post};
					arr.push(n);
					skills[sk.id]=n;
				}
				vis.butOk.text.text=Res.pipText('accept');
			} else if (page2==3) {
				perkPoint=pers.perkPoint;
				statHead.nazv.text=Res.pipText('is5');
				statHead.numb.text=Res.pipText('is2');
				for (var pid in pers.perks) {
					var maxlvl=1;
					var xperk:XML = getPerkInfo(pid);
					if (xperk.length() && xperk.@lvl.length()) maxlvl=xperk.@lvl;
					var numb=pers.perks[pid];
					var n:Object={id:pid, nazv:Res.txt('e',pid), lvl:numb, maxlvl:maxlvl, sort:(xperk.@tip=='0'?2:1)};
					arr.push(n);
				}
				if (perkPoint) {
					vis.butOk.text.text=Res.pipText('choose');
					vis.butOk.visible=true;
				}
				if (arr.length==0) {
					vis.emptytext.text=Res.pipText('emptyperk');
					statHead.visible=false;
				} else {
					vis.emptytext.text='';
					statHead.visible=true;
					arr.sortOn(['sort','nazv']);
				}
			} else if (page2==4) {
				statHead.nazv.text=Res.pipText('is3');
				statHead.numb.text=Res.pipText('is4');
				statHead.numb.x=500;
				for (var sk in gg.effects) {
					var ef=gg.effects[sk];
					var n={id:ef.id, nazv:Res.txt('e',ef.id), lvl:'∞'};
					if (ef.ad) {
						var str=Res.txt('e',ef.id+'_ad');
						if (str!='') {
							n.nazv=str+' ('+Res.pipText('ad'+ef.lvl)+')';
							n.id+='_ad';
						}
					}
					if (ef.id=='drunk') {
						n.nazv=Res.pipText('drunk'+ef.lvl);
						drunk=ef.lvl;
					}
					if (!ef.forever) n.lvl=Math.round(ef.t/30);
					if (ef.tip==3) {
						n.nazv=n_food;
					}
					arr.push(n);
				}
				if (arr.length==0) {
					vis.emptytext.text=Res.pipText('emptyeff');
					statHead.visible=false;
				} else {
					vis.emptytext.text='';
					statHead.visible=true;
				}
			} else if (page2==6) {
				perkPoint=pers.perkPoint;
				statHead.nazv.text=Res.pipText('is5');
				statHead.numb.text=Res.pipText('is2');

				for each(var dp:XML in cachedPerkList)
				{
					if (dp.@tip==1) {
						var res:int=pers.perkPoss(dp.@id, dp);
						if (res<0) continue;
						var numb=pers.perks[dp.@id];
						if (numb==null) numb=0;
						var maxlvl=1;
						if (dp.@lvl.length()) maxlvl=dp.@lvl;
						var n:Object={id:dp.@id, nazv:Res.txt('e',dp.@id), lvl:(numb+1), maxlvl:maxlvl, ok:(res>0), sort:(1-res)};
						arr.push(n);
					}
				}

				arr.sortOn(['sort','nazv']);
				vis.butOk.text.text=Res.pipText('accept');
				vis.butDef.text.text=Res.guiText('cancel');
				vis.butDef.visible=true;
			}
			showBottext();
		}
		
		override protected function setSigns():void
		{
			super.setSigns();
			if (pers.skillPoint>0) signs[2]=1;
			if (pers.perkPoint>0) signs[3]=1;
			if (gg.pers.headHP/gg.pers.inMaxHP<0.25 || gg.pers.torsHP/gg.pers.inMaxHP<0.25 || gg.pers.legsHP/gg.pers.inMaxHP<0.25 || gg.pers.bloodHP/gg.pers.inMaxHP<0.25) signs[5]=3;
			else if (gg.pers.headHP/gg.pers.inMaxHP<0.5 || gg.pers.torsHP/gg.pers.inMaxHP<0.5 || gg.pers.legsHP/gg.pers.inMaxHP<0.5 || gg.pers.bloodHP/gg.pers.inMaxHP<0.5) signs[5]=2;
		}
		
		//показ одного элемента
		override protected function setStatItem(item:MovieClip, obj:Object):void
		{
			if (obj.id!=null) item.id.text=obj.id; else item.id.text='';
			if (obj.cat!=null) item.cat.text=obj.cat; else item.cat.text='';
			item.id.visible=false;
			item.cat.visible=false;
			item.progress.visible=false;
			item.hpbar.visible=false;
			item.numb.x=335;
			item.nazv.text=obj.nazv;
			item.numb.text=obj.lvl;
			if (obj.maxlvl && obj.maxlvl>1 && obj.maxlvl<1000) item.numb.text+='/'+obj.maxlvl;
			item.alpha=1;
			if (page2==4) item.numb.x=500;
			if (page2==2) {
				if (obj.post>0) {
					var sklvl=pers.getPostSkLevel(obj.lvl);
					var nextN=100;
					if (sklvl<pers.postSkTab.length) nextN=pers.postSkTab[sklvl];
					item.numb.text=obj.lvl+ '  (+'+(nextN-obj.lvl)+')\t         '+Res.pipText('level')+': '+sklvl;
					item.numb.x=215;
				} else {
					item.numb.text=pers.getSkLevel(obj.lvl);
					for (var i=1; i<=maxSkLvl; i++) {
						if (i<=obj.minlvl) item.progress['p'+i].gotoAndStop(2);
						else if (i<=obj.lvl) item.progress['p'+i].gotoAndStop(3);
						else item.progress['p'+i].gotoAndStop(1);
					}
					item.progress.visible=true;
					item.numb.x=525;
				}
			}
			if (page2==6) {
				if (!obj.ok) item.alpha=0.4;
			}
			if (obj.bar!=null) {
				item.hpbar.visible=true;
				item.hpbar.bar.scaleX=Math.max(0,obj.bar);
			}
		}
		
		//информация об элементе
		override protected function statInfo(event:MouseEvent):void
		{
			var id:String=event.currentTarget.id.text;
			var nazv:String=event.currentTarget.nazv.text;
			if (page2==2 || page2==3 || page2==6) setIco(5,id);
			else setIco();
			if (id!='') {
				if (page2==1) {
					infoItemId=id;
					if (id=='diff') {
						vis.nazv.text=Res.txt('p',id);
						vis.info.htmlText=Res.txt('g','dif'+World.w.game.globalDif,1);
					} else {
						vis.nazv.text=Res.pipText(id);
						vis.info.htmlText=Res.txt('p',id,1);
					}
					vis.info.htmlText+='<br><br>';
					var xml:XML = getParamInfo(id);
					if (xml != null && xml.@f>0) vis.info.htmlText+=factor(xml.@v);
				} else if (page2==5) {
					infoItemId=id;
					showBottext();
					var lvl;
					if (event.currentTarget.cat.text=='ad') {
						vis.nazv.text=Res.txt('e',id+'_ad');
						lvl=0;
						lvl=int(event.currentTarget.numb.text);
						if (lvl>0) lvl--;
						vis.info.htmlText=effStr('eff',id+'_ad',lvl);
					} else if (id=='phoenix') {
						vis.nazv.text=nazv;
						vis.info.htmlText=Res.txt('u','phoenix',1);
					} else {
						vis.nazv.text=Res.pipText(id);
						vis.info.htmlText=Res.txt('p',id,1);
					}
					vis.info.htmlText+='<br><br>';
					if (id.substr(0,8)=='statHead') {
						lvl=id.substr(8,1);
						if (lvl>3) lvl=3;
						if (lvl>0) vis.info.htmlText+=effStr('perk','trauma_head',lvl);
					}
					if (id.substr(0,8)=='statTors') {
						lvl=id.substr(8,1);
						if (lvl>3) lvl=3;
						if (lvl>0) vis.info.htmlText+=effStr('perk','trauma_tors',lvl);
					}
					if (id.substr(0,8)=='statLegs') {
						lvl=id.substr(8,1);
						if (lvl>3) lvl=3;
						if (lvl>0) vis.info.htmlText+=effStr('perk','trauma_legs',lvl);
					}
					if (id.substr(0,9)=='statBlood') {
						lvl=id.substr(9,1);
						if (lvl>3) lvl=3;
						if (lvl>0) vis.info.htmlText+=effStr('perk','trauma_blood',lvl);
					}
					if (id.substr(0,8)=='statMana') {
						lvl=id.substr(8,1);
						if (lvl>2) vis.info.htmlText+=effStr('perk','trauma_mana',lvl);
					}
					if (id=='hp') vis.info.htmlText+=factor('maxhp');
					if (id=='radx') vis.info.htmlText+=factor('radX');
					if (id=='resbleeding') vis.info.htmlText+=factor('13');
					if (id=='respoison') vis.info.htmlText+=factor('12');
				} else {
					vis.nazv.text=nazv;
					if (page2==4) {
						if (id=='drunk') {
							vis.info.htmlText=effStr('eff',id,drunk-1);
						} else if (nazv==n_food) vis.info.htmlText=Res.txt('e','food',1)+'<br><br>'+effStr('eff',id);
						else vis.info.htmlText=effStr('eff',id);
					} else if (page2==2) {
						if (World.w.alicorn && Res.istxt('e',id+'_al')) {
							vis.info.htmlText=Res.rainbow(Res.txt('e',id+'_al'));
							vis.info.htmlText+='<br><br>'+effStr('skill',id+'_al');
						} else {
							vis.info.htmlText=effStr('skill',id);
						}
					} else if (page2==6) {
						vis.info.htmlText=effStr('perk',id, 1);
					} else if (page2==3) {
						vis.info.htmlText=effStr('perk',id);
					}
				}
			} else {
				vis.nazv.text=vis.info.htmlText='';
			}
		}
		
		private function selSkill(id:String):void
		{
			if (pers.skillIsPost(id) && skills[id].lvl<Pers.maxPostSkLvl || skills[id].lvl<maxSkLvl){
				if (skillPoint>0) {
					skills[id].lvl++;
					skillPoint--;
					vis.butOk.visible=true;
				} else {
					World.w.gui.infoText('noSkillPoint');
				}
			}
		}

		private function unselSkill(id:String):void
		{
			if (skills[id].lvl>skills[id].minlvl)
			{
				skills[id].lvl--;
				skillPoint++;
			}
		}
		
		private function showBottext():void
		{
			vis.bottext.text='';
			if (page2==1) vis.bottext.htmlText=Res.pipText('tgame')+': '+World.w.game.gameTime();
			if (page2==2) vis.bottext.htmlText=Res.pipText('skillpoint')+': '+numberAsColor('pink', skillPoint);
			if (page2==3) vis.bottext.htmlText=Res.pipText('perkpoint')+': '+numberAsColor('pink', perkPoint);
			if (page2==6) {
				if (selectedPerk=='') vis.bottext.htmlText=Res.pipText('chooseperk');
				else vis.bottext.htmlText=textAsColor('pink', Res.txt('e',selectedPerk));
			}
			if (page2==5 && infoItemId!='') 
			{
				var ci:String = '';
				var simplifiedID:String = getSimplifiedItemId(infoItemId)

				switch (simplifiedID)
				{
					case 'hp':
						vis.bottext.htmlText = Res.txt('pip', 'healpotions') + ': ' + textAsColor('yellow', inv.items['pot1'].kol + inv.items['pot2'].kol + inv.items['pot3'].kol);
					break;
					case 'rad':
						ci = 'antiradin';
					break;
					case 'cut':
						ci = 'pot0';
					break;
					case 'poison':
						ci = 'antidote';
					break;
					case 'statBlood':
						ci = 'bloodpak';
					break;
					case 'statMana':
						vis.bottext.htmlText = Res.txt('i','potm1') + ': ' + textAsColor('yellow', inv.items['potm1'].kol + inv.items['potm2'].kol + inv.items['potm3'].kol);
					break;
					case 'phoenix':
						ci = 'radcookie';
					break;
					case 'post_':
						ci = 'detoxin';
					break;
					case 'statHead':
						ci = gg.invent.getMed(1);
						if (ci == '') vis.bottext.text = '';
					break;
					case 'statTors':
						ci = gg.invent.getMed(2);
						if (ci == '') vis.bottext.text = '';
					break;
					case 'statLegs':
						ci = gg.invent.getMed(3);
						if (ci == '') vis.bottext.text = '';
					break;
				}

				if (ci != '') vis.bottext.htmlText = Res.txt('i', ci) + ': ' + textAsColor('yellow', inv.items[ci].kol);
			}
		}
		
		override protected function itemClick(event:MouseEvent):void
		{
			if (pip.noAct)
			{
				World.w.gui.infoText('noAct');
				return;
			}
			if (page2==2)
			{
				var id=event.currentTarget.id.text;
				if (event.ctrlKey) unselSkill(id);
				else selSkill(id);
				setStatItem(event.currentTarget as MovieClip, skills[id]);
				pip.snd(1);
			}
			if (page2==6)
			{
				if (event.currentTarget.alpha>=1)
				{
					vis.butOk.visible=true;
					selectedPerk=event.currentTarget.id.text;
				}
				pip.snd(1);
			}
			if (page2==5 && infoItemId!='')
			{
				infoItemId=event.currentTarget.id.text;
				var need:String;
				var simplifiedID:String = getSimplifiedItemId(infoItemId)

				switch (simplifiedID)
				{
					case 'hp':
						inv.usePotion();
					break;
					case 'rad':
						inv.usePotion('antiradin');
					break;
					case 'cut':
						inv.usePotion('pot0');
					break;
					case 'poison':
						inv.usePotion('antidote');
					break;
					case 'statBlood':
						inv.usePotion('bloodpak');
					break;
					case 'statMana':
						inv.usePotion('mana');
					break;
					case 'phoenix':
						inv.usePotion('radcookie');
					break;
					case 'post_':
						inv.usePotion('detoxin');
					break;
					case 'statHead':
						need = gg.invent.getMed(1);
						if (need != '') inv.usePotion(need, 1);
					break;
					case 'statTors':
						need = gg.invent.getMed(2);
						if (need != '') inv.usePotion(need, 2);
					break;
					case 'statLegs':
						need = gg.invent.getMed(3);
						if (need != '') inv.usePotion(need, 3);
					break;
				}
				setStatus();
				pip.snd(1);
				pip.setRPanel();
			}
			showBottext();
		}

		// Helper function for switch-cases. These strings have nubmers at the end, eg. 'statBlood2' to represent intensity levels.
		// This removes the trailing number if applicable so the switch-case can do an instant comparison to check for matches.
		private function getSimplifiedItemId(infoItemId:String):String  
		{
			if (infoItemId.indexOf('statBlood') == 0) return 'statBlood';
			if (infoItemId.indexOf('statMana')  == 0) return 'statMana';
			if (infoItemId.indexOf('statHead')  == 0) return 'statHead';
			if (infoItemId.indexOf('statTors')  == 0) return 'statTors';
			if (infoItemId.indexOf('statLegs')  == 0) return 'statLegs';
			if (infoItemId.indexOf('detoxin')   == 0) return 'detoxin';

			return infoItemId;
		}

		override protected function itemRightClick(event:MouseEvent):void
		{
			if (pip.noAct) {
				World.w.gui.infoText('noAct');
				return;
			}
			if (page2==2) {
				var id=event.currentTarget.id.text;
				unselSkill(id);
				setStatItem(event.currentTarget as MovieClip, skills[id]);
				pip.snd(1);
			}
			showBottext();
		}

		private function transOk(event:MouseEvent):void
		{
			if (pip.noAct) {
				World.w.gui.infoText('noAct');
				return;
			}
			if (page2==2) {
				var n=0;
				for (var i in skills) {
					n+=skills[i].lvl-skills[i].minlvl;
				}
				if (n<=pers.skillPoint) {
					for (i in skills) {
						pers.addSkill(skills[i].id, skills[i].lvl-skills[i].minlvl, true);
					}
					pers.setParameters();
					World.w.gui.setAll();
				}
				pip.snd(3);
				World.w.saveGame();
			} else if (page2==3) {
				page2=6;
				pip.snd(2);
				selectedPerk='';
			} else if (page2==6) {
				if (selectedPerk!='' && pers.perkPoint>0) pers.addPerk(selectedPerk,true);
				page2=3;
				pip.snd(3);
				pip.setRPanel();
				World.w.saveGame();
			}
			setStatus();
		}

		private function gotoDef(event:MouseEvent):void
		{
			if (page2==6)
			{
				page2=3;
				setStatus();
				pip.snd(2);
			}
		}
	}	
}
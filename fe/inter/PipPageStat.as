package fe.inter {

	import flash.display.MovieClip;
	import flash.events.MouseEvent;

	import fe.*;
	import fe.unit.Unit;
	import fe.unit.Resistances;
	import fe.unit.Pers;

	import fe.stubs.visPipStatItem;
	
	/* 
	*	One of the main pip-buck categories
	*	sub-categories:
	*		1 - Main (Character overview)
	*		2 - Skills
	*		3 - Perks
	*		4 - Effects
	*		5 - Health
	*		6 - ???
	*/
	public class PipPageStat extends PipPage {

		private static const PAGE_MAIN:int = 1, PAGE_SKILLS:int = 2, PAGE_PERKS:int = 3, PAGE_EFFECTS:int = 4, PAGE_HEALTH:int = 5, PAGE_CHOOSEPERK:int = 6;

		private static var cachedPerkList = XMLDataGrabber.getNodesWithName("core", "AllData", "perks", "perk");
		private static var cachedParamList = XMLDataGrabber.getNodesWithName("core", "AllData", "params", "param");

		private var pers:Pers;
		private var skills:Array;
		private var maxSkLvl:int				= 20;
		private var skillPoint:int				= 0;
		private var perkPoint:int				= 0;
		private var selectedPerk:String			= "";
		private var infoItemId:String			= "";
		private var n_food:String				= "";
		private var drunk:int					= 0;

		private static var cachedPerks:Object	= {};
		private static var cachedParams:Object	= {};

		// Constructor
		public function PipPageStat(npip:PipBuck, npp:String) {
			isLC = true;
			isRC = true;
			
			itemClass = visPipStatItem;
			skills = [];
			
			super(npip, npp);
			
			vis.butOk.addEventListener(MouseEvent.CLICK,transOk);
			vis.butDef.addEventListener(MouseEvent.CLICK,gotoDef);
			n_food = Res.txt('e','food');
		}

		public static function getPerkInfo(id:String):XML {
			var node;
			
			if (cachedPerks[id] == undefined) {
				node = XMLDataGrabber.getNodeWithAttributeThatMatches("core", "AllData", "perks", "id", id);
				cachedPerks[id] = node;
			}
			else {
				node = cachedPerks[id];
			}
			
			return node;
		}

		public static function getParamInfo(id:String):XML {
			var node;
		
			if (cachedParams[id] == undefined) {
				node = XMLDataGrabber.getNodeWithAttributeThatMatches("core", "AllData", "params", "id", id);
				cachedParams[id] = node;
			}
			else {
				node = cachedParams[id];
			}
		
			return node;
		}
		
		//подготовка страниц
		override protected function setSubPages():void {
			inv			= World.w.invent;
			gg			= World.w.gg;
			pers		= World.w.pers;
			maxSkLvl	= Pers.maxSkLvl;
			var localize:Function = LanguageManager.reference.localText;

			setIco();
			
			statHead.progress.visible	= false;
			statHead.hpbar.visible		= false;
			statHead.cat.visible		= false;
			statHead.numb.x				= 335;
			vis.butOk.visible			= false;
			vis.butDef.visible			= false;
			
			drunk = 0;
			
			if (page2 == PAGE_MAIN) {
				statHead.nazv.text = "";
				statHead.numb.text = "";
				
				arr.push({
					nazv:localize("pip", 'name'),
					lvl:gg.pers.persName
				});
				
				arr.push({
					nazv:localize("pip", 'level'),
					lvl:gg.pers.level});
				
				arr.push({
					nazv:localize("pip", 'expa'),
					lvl:gg.pers.xpCur + ' (' + (gg.pers.xpNext - gg.pers.xpCur) + ')'
				});
				
				arr.push({
					id:'diff',
					nazv:localize("pip", 'diff'),
					lvl:Res.txt("g", 'dif' + World.w.game.globalDif)
				});
				
				arr.push({
					id:'reput',
					nazv:localize("pip", 'reput'),
					lvl:(gg.pers.rep + ' (' + gg.pers.repTex() + ')')
				});
				
				var arm:String = "";

				for (var i:int = 0; i < cachedParamList.length(); i++) {
					var xml = cachedParamList[i];
					
					if (xml.@show > 0) {
						if (xml.@show == '2' && gg.armor == 0 && gg.marmor == 0) {
							continue;
						}
						
						if (xml.@show == '3' && (!World.w.game.triggers['story_canter'] > 0)) {
							continue;
						}
						
						var nazv:String = localize("pip", xml.@id);
						
						if (xml.@v == "") {
							var n:Object = {
								id: xml.@id, 
								nazv: nazv, 
								lvl: ""
							}
							arr.push(n);
							continue;
						}
						else {
							nazv = "-  " + nazv;
						}
						
						var param;
						
						// This might be incorrect? It used to be '== 4'
						if (xml.@tip == Resistances.DAM_EXPLOSION) {
							param = gg.vulnerabilities.getResist(xml.@v);
						}
						else if (gg.hasOwnProperty(xml.@v)) {
							param = gg[xml.@v];
						}
						else if (gg.pers.hasOwnProperty(xml.@v)) {
							param = gg.pers[xml.@v];
						}
						else {
							trace('PipPageStat.as/setSubPages() - Error: No variable ' + xml.@v);
							continue;
						}

						// This might be incorrect? It used to be '== 0'
						if (xml.@tip == Resistances.DAM_PIERCE) {
							if (param > 0) {
								arr.push({
									id:xml.@id,
									nazv:nazv,
									lvl:Res.numb(param)
								});
							}
						}

						// This might be incorrect? It used to be '== 4'
						if (xml.@tip == Resistances.DAM_CUT) {
							if (param != 1 || World.w.pers.factor[xml.@v] && World.w.pers.factor[xml.@v].length > 1) {
								arr.push({
									id:xml.@id,
									nazv:nazv,
									lvl:((param >= 1 ? '+' : '') + Res.numb((param - 1) * 100) + '%')
								});
							}
						}
						
						// This might be incorrect? It used to be '== 2'
						if (xml.@tip == Resistances.DAM_BLUNT) {
							arr.push(
								{id:xml.@id, nazv:nazv,
								lvl:(Res.numb(param*100)+'%')
							});
						}

						// This might be incorrect? It used to be '== 3 || == 4'
						if (xml.@tip == Resistances.DAM_BURN || xml.@tip == Resistances.DAM_EXPLOSION) {
							if (param != 1) {
								arr.push({
									id:xml.@id,
									nazv:nazv,
									lvl:((param < 1 ? '+' : '') + Res.numb((1 - param) * 100) + '%')
								});
							}
						}
					}
				}
			}
			else if (page2 == PAGE_HEALTH) {
				if (World.w.game.triggers['nomed'] > 0) {
					vis.emptytext.text = localize("pip", 'emptymed');
					statHead.visible = false;
					return;
				}
				else {
					vis.emptytext.text = "";
					statHead.visible = true;
				}
				
				gg.pers.checkHP();
				setTopText('usemed1');

				statHead.nazv.text = "";
				statHead.numb.text = "";
				
				arr.push({
					id:'hp', nazv:localize("pip", 'hp'),
					lvl:Math.round(gg.hp) + '/' + Math.round(gg.maxhp),
					bar:(gg.hp / gg.maxhp)
				});
				
				arr.push({
					id:'organism', 
					nazv:localize("pip", 'organism') + ':', 
					lvl:''});
				
				arr.push({
					id:'statHead' + gg.pers.headSt,
					nazv:'   ' + localize("pip", 'head'),
					lvl:Math.round(gg.pers.headHP) + '/' + Math.round(gg.pers.inMaxHP),
					bar:(gg.pers.headHP / gg.pers.inMaxHP)
				});
				
				arr.push({
					id:'statTors' + gg.pers.torsSt,
					nazv:'   ' + localize("pip", 'tors'),
					lvl:Math.round(gg.pers.torsHP) + '/' + Math.round(gg.pers.inMaxHP),
					bar:(gg.pers.torsHP / gg.pers.inMaxHP)
				});
				
				arr.push({
					id:'statLegs' + gg.pers.legsSt,
					nazv:'   ' + localize("pip", 'legs'),
					lvl:Math.round(gg.pers.legsHP) + '/' + Math.round(gg.pers.inMaxHP),
					bar:(gg.pers.legsHP / gg.pers.inMaxHP)
				});
			
				arr.push({
					id:'statBlood' + gg.pers.bloodSt,
					nazv:'   ' + localize("pip", 'blood'),
					lvl:Math.round(gg.pers.bloodHP) + '/' + Math.round(gg.pers.inMaxHP),
					bar:(gg.pers.bloodHP / gg.pers.inMaxHP)
				});
				
				arr.push({
					id:'statMana' + gg.pers.manaSt,
					nazv:'   ' + localize("pip", 'mana'),
					lvl:Math.round(gg.pers.manaHP) + '/' + Math.round(gg.pers.inMaxMana),
					bar:(gg.pers.manaHP / gg.pers.inMaxMana)
				});
			
				arr.push({
					id:'rad',
					nazv:localize("pip", 'rad'),
					lvl:Math.round(gg.rad)
				});
			
				arr.push({
					id:'radx',
					nazv:localize("pip", 'radx'),
					lvl:Math.round((1 - gg.radX) * 100) + '%'
				});
			
				arr.push({
					id:'cut',
					nazv:localize("pip", 'cut'),
					lvl:Math.round(gg.cut * 10) / 10
				});
			
				arr.push({
					id:'resbleeding',
					nazv:localize("pip", 'resbleeding'),
					lvl:Math.round((1 - gg.vulnerabilities.getResist(Resistances.DAM_BLEED)) * 100) + '%'
				});
				
				arr.push({
					id:'poison',
					nazv:localize("pip", 'poison'),
					lvl:Math.round(gg.poison * 10) / 10
				});
			
				arr.push({
					id:'respoison',
					nazv:localize("pip", 'respoison'),
					lvl:Math.round((1 - gg.vulnerabilities.getResist(Resistances.DAM_POISON)) * 100) + '%'
				});
				
				if (gg.pets['phoenix'] && World.w.game.triggers['pet_phoenix']) {
					arr.push({
						id:'phoenix',
						nazv:gg.pets['phoenix'].nazv,
						lvl:Math.round(gg.pets['phoenix'].hp) + '/' + Math.round(gg.pets['phoenix'].maxhp)
					});
				}
				
				for (var j:int = 0; j < pers.addictions.length; j++) {
					if (pers.addictions[j] > 0) {
						var str:String = "";
						
						if (pers.addictions[j] >= pers.ad3) {
							str = localize("pip", 'ad3');
						}
						else if (pers.addictions[j] >= pers.ad2) {
							str = localize("pip", 'ad2');
						}
						else if (pers.addictions[j] >= pers.ad1) {
							str = localize("pip", 'ad1');
						}
						else {
							str = localize("pip", 'ad0');
						}
						
						var n:Object = {
							id:j,
							nazv:Res.txt('e', j + '_ad'),
							lvl:Math.round(pers.addictions[j]) + '% (' + str + ')',
							cat:'ad'
						}
						
						arr.push(n);
					}
				}
			}
			else if (page2 == PAGE_SKILLS) {	
				setTopText('infoskills');
				skillPoint = pers.skillPoint;
				statHead.nazv.text = localize("pip", 'is1');
				statHead.numb.text = localize("pip", 'is2');
				
				for each(var sk in pers.skill_ids) {
					if (pers.level < Pers.postPersLevel && sk.post > 0) {
						continue;
					}

					var numb = pers.skills[sk.id];
					

					var n:Object = {
						id:sk.id,
						nazv:Res.txt('e', sk.id),
						lvl:numb,
						minlvl:numb,
						post:sk.post
					};

					arr.push(n);

					skills[sk.id] = n;
				}
				
				vis.butOk.text.text=localize("pip", 'accept');
			}
			else if (page2 == PAGE_PERKS) {
				perkPoint=pers.perkPoint;
				statHead.nazv.text=localize("pip", 'is5');
				statHead.numb.text=localize("pip", 'is2');
				
				for (var pid in pers.perks) {
					var maxlvl:int = 1;
					var xperk = getPerkInfo(pid);
				
					if (xperk.length() && xperk.@lvl.length()) {
						maxlvl = int(xperk.@lvl);
					}
				
					var numb = pers.perks[pid];
					
					var n:Object = {
						id:pid, 
						nazv:Res.txt('e', pid),
						lvl:numb,
						maxlvl:maxlvl,
						sort:(xperk.@tip == '0' ? 2 : 1)
					}
					
					arr.push(n);
				}
				
				if (perkPoint) {
					vis.butOk.text.text = localize("pip", 'choose');
					vis.butOk.visible = true;
				}
				
				if (arr.length == 0) {
					vis.emptytext.text = localize("pip", 'emptyperk');
					statHead.visible = false;
				}
				else {
					vis.emptytext.text = "";
					statHead.visible = true;
					arr.sortOn(['sort', 'nazv']);
				}
			}
			else if (page2 == PAGE_EFFECTS) {
				statHead.nazv.text=localize("pip", 'is3');
				statHead.numb.text=localize("pip", 'is4');
				statHead.numb.x = 500;
			
				for (var sk in gg.effects) {
					var ef = gg.effects[sk];
					var n:Object = {
						id:ef.id,
						nazv:Res.txt('e', ef.id),
						lvl:'∞'
					};
			
					if (ef.ad) {
						var str:String = Res.txt('e',ef.id+'_ad');
			
						if (str != "") {
							n.nazv = str + ' (' + localize("pip", 'ad' + ef.lvl) + ')';
							n.id += '_ad';
						}
					}
				
					if (ef.id == 'drunk') {
						n.nazv = localize("pip", 'drunk' + ef.lvl);
						drunk = ef.lvl;
					}
			
					if (!ef.forever) {
						n.lvl = Math.round(ef.t / 30);
					}
			
					if (ef.tip == 3) {
						n.nazv = n_food;
					}
			
					arr.push(n);
				}
			
				if (arr.length == 0) {
					vis.emptytext.text = localize("pip", 'emptyeff');
					statHead.visible = false;
				}
				else {
					vis.emptytext.text = "";
					statHead.visible = true;
				}
			}
			else if (page2 == PAGE_CHOOSEPERK) {
				perkPoint = pers.perkPoint;
				statHead.nazv.text = localize("pip", 'is5');
				statHead.numb.text = localize("pip", 'is2');

				for each(var dp in cachedPerkList) {
					if (dp.@tip == 1) {
						var res:int = pers.perkPoss(dp.@id, dp);
					
						if (res < 0) {
							continue;
						}
					
						var numb = pers.perks[dp.@id];
					
						if (numb == null) {
							numb = 0;
						}
					
						var maxlvl:int = 1;
					
						if (dp.@lvl.length()) {
							maxlvl = int(dp.@lvl);
						}
						
						var n:Object = {
							id:dp.@id,
							nazv:Res.txt('e', dp.@id),
							lvl:(numb + 1),
							maxlvl:maxlvl,
							ok:(res > 0),
							sort:(1 - res)
						}
						
						arr.push(n);
					}
				}

				arr.sortOn(['sort','nazv']);
				vis.butOk.text.text = localize("pip", 'accept');
				vis.butDef.text.text = Res.txt("g", 'cancel');
				vis.butDef.visible = true;
			}
		
			showBottext();
		}
		
		override protected function setSigns():void {
			super.setSigns();
			
			if (pers.skillPoint > 0) {
				signs[2] = 1;
			}
			
			if (pers.perkPoint > 0) {
				signs[3] = 1;
			}
			
			if (gg.pers.headHP / gg.pers.inMaxHP < 0.25 || gg.pers.torsHP / gg.pers.inMaxHP < 0.25 || gg.pers.legsHP / gg.pers.inMaxHP < 0.25 || gg.pers.bloodHP / gg.pers.inMaxHP < 0.25) {
				signs[5] = 3;
			}
			else if (gg.pers.headHP / gg.pers.inMaxHP < 0.5 || gg.pers.torsHP / gg.pers.inMaxHP < 0.5 || gg.pers.legsHP / gg.pers.inMaxHP < 0.5 || gg.pers.bloodHP / gg.pers.inMaxHP < 0.5) {
				signs[5] = 2;
			}
		}
		
		//показ одного элемента
		override protected function setStatItem(item:MovieClip, obj:Object):void {
			if (obj.id == null) {
				item.id.text = "";
			}
			else {
				item.id.text = obj.id;
			}
			
			if (obj.cat == null) {
				item.cat.text = "";
			}
			else {
				item.cat.text = obj.cat;
			}
			
			item.id.visible = false;
			item.cat.visible = false;
			item.progress.visible = false;
			item.hpbar.visible = false;
			item.numb.x = 335;
			item.nazv.text = obj.nazv;
			item.numb.text = obj.lvl;
			
			if (obj.maxlvl && obj.maxlvl>1 && obj.maxlvl<1000) {
				item.numb.text += '/' + obj.maxlvl;
			}
			
			item.alpha = 1;
			
			if (page2 == PAGE_EFFECTS) {
				item.numb.x = 500;
			}
			
			if (page2 == PAGE_SKILLS) {
				if (obj.post > 0) {
					var sklvl:int = pers.getPostSkLevel(obj.lvl);
					var nextN:int = 100;
					
					if (sklvl < pers.postSkTab.length) {
						nextN = pers.postSkTab[sklvl];
					}
					
					item.numb.text = obj.lvl + '  (+' + (nextN - obj.lvl) + ')\t         ' + LanguageManager.reference.localText("pip", 'level') + ': ' + sklvl;
					item.numb.x = 215;
				}
				else {
					item.numb.text = pers.getSkLevel(obj.lvl);
					for (var i:int = 1; i <= maxSkLvl; i++) {
						if (i <= obj.minlvl) {
							item.progress['p' + String(i)].gotoAndStop(2);
						}
						else if (i<=obj.lvl) {
							item.progress['p' + String(i)].gotoAndStop(3);
						}
						else {
							item.progress['p' + String(i)].gotoAndStop(1);
						}
					}
					
					item.progress.visible = true;
					item.numb.x = 525;
				}
			}

			if (page2 == PAGE_CHOOSEPERK) {
				if (!obj.ok) {
					item.alpha = 0.40;
				}
			}

			if (obj.bar != null) {
				item.hpbar.visible = true;
				item.hpbar.bar.scaleX = Math.max(0, obj.bar);
			}
		}
		
		//информация об элементе
		override protected function statInfo(event:MouseEvent):void {
			var id:String = event.currentTarget.id.text;
			var nazv:String = event.currentTarget.nazv.text;

			if (page2 == PAGE_SKILLS || page2 == PAGE_PERKS || page2 == PAGE_CHOOSEPERK) {
				setIco(5, id);
			}
			else {
				setIco();
			}
			
			if (id == "") {
				vis.nazv.text = vis.info.htmlText = "";
			}
			else {
				if (page2 == PAGE_MAIN) {
					infoItemId = id;
					
					if (id == 'diff') {
						vis.nazv.text = Res.txt('p', id);
						vis.info.htmlText = Res.txt('g', 'dif' + World.w.game.globalDif, 1);
					}
					else {
						vis.nazv.text = LanguageManager.reference.localText("pip", id);
						vis.info.htmlText = Res.txt('p', id, 1);
					}
					
					vis.info.htmlText += '<br><br>';
					var xml = getParamInfo(id);
					
					if (xml != null && xml.@f > 0) {
						vis.info.htmlText += factor(xml.@v);
					}
				}
				else if (page2 == PAGE_HEALTH) {
					infoItemId = id;
					showBottext();
					var lvl;
				
					if (event.currentTarget.cat.text == 'ad') {
						vis.nazv.text = Res.txt('e', id + '_ad');
						lvl = 0;
						lvl = int(event.currentTarget.numb.text);
						
						if (lvl > 0) {
							lvl--;
						}
						
						vis.info.htmlText = effStr('eff', id + '_ad', lvl);
					}
					else if (id == 'phoenix') {
						vis.nazv.text = nazv;
						vis.info.htmlText = Res.txt('u', 'phoenix', 1);
					}
					else {
						vis.nazv.text = LanguageManager.reference.localText("pip", id);
						vis.info.htmlText = Res.txt('p', id, 1);
					}
					
					vis.info.htmlText += '<br><br>';
					
					if (id.substr(0, 8) == 'statHead') {
						lvl = id.substr(8, 1);
						
						if (lvl > 3) {
							lvl = 3;
						}
						
						if (lvl > 0) {
							vis.info.htmlText += effStr('perk', 'trauma_head', lvl);
						}
					}
					
					if (id.substr(0, 8) == 'statTors') {
						lvl = id.substr(8, 1);
						
						if (lvl > 3) {
							lvl = 3;
						}
						
						if (lvl > 0) {
							vis.info.htmlText += effStr('perk', 'trauma_tors', lvl);
						}
					}
					
					if (id.substr(0, 8) == 'statLegs') {
						lvl = id.substr(8, 1);
						
						if (lvl > 3) {
							lvl = 3;
						}
						
						if (lvl > 0) {
							vis.info.htmlText += effStr('perk', 'trauma_legs', lvl);
						}
					}
					
					if (id.substr(0, 9) == 'statBlood') {
						lvl = id.substr(9, 1);
					
						if (lvl > 3) {
							lvl = 3;
						}
					
						if (lvl > 0) {
							vis.info.htmlText += effStr('perk', 'trauma_blood', lvl);
						}
					}
					
					if (id.substr(0, 8) == 'statMana') {
						lvl = id.substr(8, 1);
					
						if (lvl > 2) {
							vis.info.htmlText += effStr('perk', 'trauma_mana', lvl);
						}
					}
					
					if (id == 'hp') {
						vis.info.htmlText += factor('maxhp');
					}
					
					if (id == 'radx') {
						vis.info.htmlText += factor('radX');
					}
					
					if (id == 'resbleeding') {
						vis.info.htmlText += factor('13');
					}
					
					if (id == 'respoison') {
						vis.info.htmlText += factor('12');
					}
				}
				else {
					vis.nazv.text = nazv;

					if (page2 == PAGE_EFFECTS) {
						if (id == 'drunk') {
							vis.info.htmlText = effStr('eff', id, drunk - 1);
						}
						else if (nazv == n_food) {
							vis.info.htmlText = Res.txt('e', 'food', 1) + '<br><br>' + effStr('eff', id);
						}
						else {
							vis.info.htmlText = effStr('eff', id);
						}
					}
					else if (page2 == PAGE_SKILLS) {
						if (World.w.alicorn && Res.istxt('e', id + '_al')) {
							vis.info.htmlText = Res.rainbow(Res.txt('e', id + '_al'));
							vis.info.htmlText += '<br><br>' + effStr('skill', id + '_al');
						}
						else {
							vis.info.htmlText = effStr('skill', id);
						}
					}
					else if (page2 == PAGE_CHOOSEPERK) {
						vis.info.htmlText = effStr('perk', id, 1);
					}
					else if (page2 == PAGE_PERKS) {
						vis.info.htmlText = effStr('perk', id);
					}
				}
			}
		}
		
		private function selSkill(id:String):void {
			if (pers.skillIsPost(id) && skills[id].lvl < Pers.maxPostSkLvl || skills[id].lvl < maxSkLvl){
				if (skillPoint > 0) {
					skills[id].lvl++;
					skillPoint--;
					vis.butOk.visible = true;
				}
				else {
					World.w.gui.infoText('noSkillPoint');
				}
			}
		}

		private function unselSkill(id:String):void {
			if (skills[id].lvl > skills[id].minlvl) {
				skills[id].lvl--;
				skillPoint++;
			}
		}
		
		private function showBottext():void {
			vis.bottext.text='';
			
			if (page2 == PAGE_MAIN) {
				vis.bottext.htmlText=LanguageManager.reference.localText("pip", 'tgame')+': '+World.w.game.gameTime();
			}
			
			if (page2 == PAGE_SKILLS) {
				vis.bottext.htmlText=LanguageManager.reference.localText("pip", 'skillpoint')+': '+numberAsColor('pink', skillPoint);
			}
			
			if (page2 == PAGE_PERKS) {
				vis.bottext.htmlText=LanguageManager.reference.localText("pip", 'perkpoint')+': '+numberAsColor('pink', perkPoint);
			}
			
			if (page2 == PAGE_CHOOSEPERK) {
				if (selectedPerk == "") {
					vis.bottext.htmlText=LanguageManager.reference.localText("pip", 'chooseperk');
				}
				else {
					vis.bottext.htmlText=textAsColor('pink', Res.txt('e',selectedPerk));
				}
			}
			
			if (page2 == PAGE_HEALTH && infoItemId != "") {
				var ci:String = "";
				var simplifiedID:String = getSimplifiedItemId(infoItemId)

				switch (simplifiedID) {
					case 'hp':
						vis.bottext.htmlText = Res.txt('pip', 'healpotions') + ': ' + textAsColor('yellow', String(inv.getQuantity('pot1') + inv.getQuantity('pot2') + inv.getQuantity('pot3')));
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
						vis.bottext.htmlText = Res.txt('i','potm1') + ': ' + textAsColor('yellow', String(inv.getQuantity('potm1') + inv.getQuantity('potm2') + inv.getQuantity('potm3')));
					break;
					case 'phoenix':
						ci = 'radcookie';
					break;
					case 'post_':
						ci = 'detoxin';
					break;
					case 'statHead':
						/*							FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME 
						ci = gg.invent.getMed(1);
						if (ci == "") {
							vis.bottext.text = "";
						}
						*/
					break;
					case "statTors":
						/*							FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME 
						ci = gg.invent.getMed(2);
						if (ci == "") {
							vis.bottext.text = "";
						}
						*/
					break;
					case "statLegs":
						/*							FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME 
						ci = gg.invent.getMed(3);
						if (ci == "") {
							vis.bottext.text = "";
						}
						*/
					break;
				}

				if (ci != "") {
					vis.bottext.htmlText = Res.txt("i", ci) + ": " + textAsColor("yellow", String(inv.getQuantity(ci)));
				}
			}
		}
		
		override protected function itemClick(event:MouseEvent):void {
			if (pip.noAct) {
				World.w.gui.infoText('noAct');
				return;
			}
			
			if (page2 == PAGE_SKILLS) {
				var id:String = event.currentTarget.id.text;
			
				if (event.ctrlKey) {
					unselSkill(id);
				}
				else {
					selSkill(id);
				}
			
				setStatItem(event.currentTarget as MovieClip, skills[id]);
				pip.snd(1);
			}
		
			if (page2 == PAGE_CHOOSEPERK) {
				if (event.currentTarget.alpha >= 1) {
					vis.butOk.visible=true;
					selectedPerk=event.currentTarget.id.text;
				}
				
				pip.snd(1);
			}
		
			if (page2 == PAGE_HEALTH && infoItemId != "") {
				infoItemId=event.currentTarget.id.text;
				var need:String;
				var simplifiedID:String = getSimplifiedItemId(infoItemId)

				switch (simplifiedID) {
					case 'hp':
						//inv.usePotion();
					break;
					case 'rad':
						//inv.usePotion('antiradin');
					break;
					case 'cut':
						//inv.usePotion('pot0');
					break;
					case 'poison':
						//inv.usePotion('antidote');
					break;
					case 'statBlood':
						//inv.usePotion('bloodpak');
					break;
					case 'statMana':
						//inv.usePotion('mana');
					break;
					case 'phoenix':
						//inv.usePotion('radcookie');
					break;
					case 'post_':
						//inv.usePotion('detoxin');
					break;
					case 'statHead':
						/*									FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME 
						need = gg.invent.getMed(1);
						if (need != "") {
							inv.usePotion(need, 1);
						}
						*/
					break;
					case 'statTors':
						/*									FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME
						need = gg.invent.getMed(2);
						if (need != "") {
							inv.usePotion(need, 2);
						}
						*/
					break;
					case 'statLegs':
						/*									FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME 
						need = gg.invent.getMed(3);
						if (need != "") {
							inv.usePotion(need, 3);
						}
						*/
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
		private function getSimplifiedItemId(infoItemId:String):String {
			if (infoItemId.indexOf('statBlood') == 0) return 'statBlood';
			if (infoItemId.indexOf('statMana')  == 0) return 'statMana';
			if (infoItemId.indexOf('statHead')  == 0) return 'statHead';
			if (infoItemId.indexOf('statTors')  == 0) return 'statTors';
			if (infoItemId.indexOf('statLegs')  == 0) return 'statLegs';
			if (infoItemId.indexOf('detoxin')   == 0) return 'detoxin';

			return infoItemId;
		}

		override protected function itemRightClick(event:MouseEvent):void {
			if (pip.noAct) {
				World.w.gui.infoText('noAct');
				return;
			}
			
			if (page2 == PAGE_SKILLS) {
				var id = event.currentTarget.id.text;
				unselSkill(id);
				setStatItem(event.currentTarget as MovieClip, skills[id]);
				pip.snd(1);
			}
			
			showBottext();
		}

		private function transOk(event:MouseEvent):void {
			if (pip.noAct) {
				World.w.gui.infoText('noAct');
				return;
			}
			
			if (page2 == PAGE_SKILLS) {
				var n:int = 0;
				for (var i in skills) {
					n += skills[i].lvl-skills[i].minlvl;
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
			}
			else if (page2 == PAGE_PERKS) {
				page2 = PAGE_CHOOSEPERK;
				pip.snd(2);
				selectedPerk = "";
			}
			else if (page2 == PAGE_CHOOSEPERK) {
				if (selectedPerk != "" && pers.perkPoint > 0) {
					pers.addPerk(selectedPerk, true);
				}
				
				page2 = PAGE_PERKS;
				pip.snd(3);
				pip.setRPanel();
				World.w.saveGame();
			}

			setStatus();
		}

		private function gotoDef(event:MouseEvent):void {
			if (page2 == PAGE_CHOOSEPERK) {
				page2 = PAGE_PERKS;
				setStatus();
				pip.snd(2);
			}
		}
	}	
}
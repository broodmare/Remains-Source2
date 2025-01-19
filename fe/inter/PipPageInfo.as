package fe.inter {

	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.display.Bitmap;
	import flash.display.BitmapData;

	import fe.*;
	import fe.loc.Tile;
	import fe.loc.Game;
	import fe.loc.Quest;
	import fe.loc.LandAct;
	import fe.unit.Unit;
	import fe.weapon.Weapon;

	import fe.stubs.visPipQuestItem;
	import fe.stubs.visPipInfo;
	import fe.stubs.visPipMap;
	import fe.stubs.visPipWMap;
	
	/* 
	*	One of the main pip-buck categories
	*	sub-categories:
	*		1 - Local Map
	*		2 - Quests
	*		3 - World Map
	*		4 - Notes
	*		5 - Enemies
	*/
	public class PipPageInfo extends PipPage {
		
		private static const PAGE_LOCAL_MAP:int = 1, PAGE_QUEST:int = 2, PAGE_WORLD_MAP:int = 3, PAGE_NOTES:int = 4, PAGE_ENEMIES:int = 5;

		private var visMap:MovieClip;
		private var visWMap:MovieClip;
		public var map:Bitmap;
		public var mbmp:BitmapData;
		private var visPageX=850, visPageY=540;
		private var mapScale:Number=2, ms:Number=2;
		private var plTag:MovieClip;
		private var targetLand:String='';
		private var game:Game;

		private static var lastLandTooltipDisplayed:String;

		private static var cachedUnits:Object = {};
		private static var cachedTaskList = XMLDataGrabber.getNodesWithName("core", "GameData", "Vendors", "task");
		private static var cachedUnitList = XMLDataGrabber.getNodesWithName("core", "AllData", "units", "unit");
		
		private static var tileX:int = Tile.tileX;
		private static var tileY:int = Tile.tileY;

		// Constructor
		public function PipPageInfo(npip:PipBuck, npp:String) {

			itemClass = visPipQuestItem;
			pageClass = visPipInfo;
			isLC = true;
			
			super(npip, npp);
			
			// [Map object]
			visMap	= new visPipMap();
			visWMap	= new visPipWMap();
			vis.addChild(visMap);
			vis.addChild(visWMap);

			visMap.x=12;
			visMap.y=75;
			visWMap.x=17;
			visWMap.y=80;
			
			// [Bitmap]
			map = new Bitmap();
			visMap.vmap.addChild(map);
			visMap.vmap.mask=visMap.maska;
			plTag=visMap.vmap.plTag;
			visMap.vmap.swapChildren(map,plTag);
			
			vis.butOk.addEventListener(MouseEvent.CLICK,transOk);
			visMap.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
			visMap.addEventListener(MouseEvent.MOUSE_UP,onMouseUp);
			visMap.butZoomP.addEventListener(MouseEvent.CLICK,funZoomP);
			visMap.butZoomM.addEventListener(MouseEvent.CLICK,funZoomM);
			visMap.butCenter.addEventListener(MouseEvent.CLICK,funCenter);
		}

		public static function getUnitInfo(id:String):XML {
			
			var node;
			if (cachedUnits[id] == undefined) {
				node = XMLDataGrabber.getNodeWithAttributeThatMatches("core", "AllData", "units", "id", id);
				cachedUnits[id] = node;
			}
			else {
				node = cachedUnits[id];
			}
			
			return node;
		}

		override protected function setSubPages():void {
			gg = World.w.gg;
			inv = World.w.invent;
			
			vis.bottext.visible=false;
			vis.butOk.visible=false;
			statHead.visible=false;
			visMap.visible=false;
			visWMap.visible=false;
			vis.ico.visible=false;
			vis.nazv.x=458;
			vis.info.x=458;
			vis.nazv.width=413;
			vis.info.width=458;
			pip.vis.butHelp.visible=false;
			targetLand='';
			setTopText();
			game=World.w.game;
			
			if (page2 == PAGE_LOCAL_MAP) {		//карта
				if (World.w.loc.noMap) {
					vis.emptytext.text=LanguageManager.reference.localText("pip", 'emptymap');
				}
				else {
					vis.emptytext.text = "";
					map.bitmapData = World.w.land.drawMap();
					setMapSize();
					visMap.visible = true;
				}
			}
			else if (page2 == PAGE_QUEST) {	//задания
				for each(var q:Quest in game.quests) {
					if (q.state>0) {
						var n:Object={id:q.id, nazv:q.nazv, main:q.main, sort:(q.main?0:1), state:q.state};
						arr.push(n);
					}
				}
				
				if (arr.length) {
					arr.sortOn(['state','sort','nazv']);
				}
				
				if (World.w.loc && World.w.loc.base) {
					for each (var task in cachedTaskList) {
						if (checkQuest(task)) {
							var q:Quest = game.quests[task.@id];
							
							if (q == null || q.state == 0) {
								vis.butOk.visible = true;
								vis.butOk.text.text = LanguageManager.reference.localText("pip", 'alltask');
								break;
							}
						}
					}
				}
			}
			else if (page2 == PAGE_WORLD_MAP) {	// [General map]
				
				vis.nazv.x = 584
				vis.info.x = 584;
				vis.nazv.width = 287;
				vis.info.width = 332;
				
				if (pip.travel) setTopText('infotravel');
				for each (var land:LandAct in game.lands) {
					if (land.prob) {
						continue;
					}
					
					land.calcProbs();
					
					// Populate the map with clickable locations
					var sim:MovieClip = visWMap[land.id];
					if (sim) {
						sim.alpha = 1;
						sim.zad.gotoAndStop(1);
						sim.sign.stop();
						sim.sign.visible = false;
						sim.visible = false;
						
						if (!sim.hasEventListener(MouseEvent.CLICK)) {
							sim.addEventListener(MouseEvent.CLICK,itemClick);
							sim.addEventListener(MouseEvent.MOUSE_OVER,statInfo);
						}
						
						try {
							sim.sim.gotoAndStop(land.id);
						}
						catch (err) {
							trace('ERROR: (00:3A)');
							sim.sim.gotoAndStop(1);
						}
						
						if (land.test && !World.w.testMode) {
							continue;
						}
						
						if (!game.checkTravel(land.id)) {
							sim.alpha = 0.5;
						}
						
						if (World.w.testMode && !land.visited && !land.access) {
							sim.alpha = 0.3;
						}
						
						if (World.w.helpMess && !land.visited && land.access) {
							sim.sign.play();
							sim.sign.visible = true;
						}
						
						if (World.w.testMode || land.visited || land.access) sim.visible = true;
					}
				}
				vis.butOk.text.text = LanguageManager.reference.localText("pip", 'trans');
				visWMap.visible = true;
				pip.vis.butHelp.visible = true;
				pip.helpText = Res.txt('p', 'helpWorld', 0, true);
			}
			else if (page2 == PAGE_NOTES) {	// [Notes]
				var doparr:Array = [];
				for each (var note:String in game.notes) {
					//TODO: Stop searching Res on your own.
					var xml = Res.currentLanguageData.txt.(@id == note);
					
					var nico:int = 0;
					
					if (xml && xml.@imp > 0) {
						nico = int(xml.@imp);
					}
					else {
						continue;
					}

					var title:String;
					
					if (xml.n.t.length()) {
						title = xml.n.t[0];
					}
					else {
						title = xml.n.r[0];
					}
					
					title = title.replace(/&lp/g,World.w.pers.persName);
					var n:Object = {id:note, nazv:title, ico:nico};
					
					if (nico==3) {
						doparr.push(n);
					}
					else {
						arr.push(n);
					}
				}
				
				arr.reverse();
				arr = doparr.concat(arr);
			}
			else if (page2 == PAGE_ENEMIES) {	// [Enemies]
				if (Unit.arrIcos == null) {
					Unit.initIcos();
				}
				
				var prevObj:Object = null;
				statHead.visible = true;
				statHead.nazv.text = "";
				statHead.mq.visible = false;
				statHead.kol.text = LanguageManager.reference.localText("pip", 'frag');
				vis.ico.visible = true;

				for each(var xml in cachedUnitList) {
					if (xml && xml.@cat.length()) {
						var n:Object = {id:xml.@id, nazv:Res.txt('u', xml.@id), cat:xml.@cat, kol:-1};
						
						if (xml.@cat == '3' && World.w.game.triggers['frag_' + xml.@id] >= 0) {
							n.kol = int(World.w.game.triggers['frag_' + xml.@id]);
						}
						
						if (xml.@cat == '2') {
							prevObj = n;
						}
						else if (xml.@cat == '3') {
							if (prevObj && n.kol >= 0) {
								if (prevObj.kol < 0) {
									prevObj.kol = 0;
								}
								
								prevObj.kol += n.kol;
							}
							
							if (prevObj) {
								n.prev = prevObj.id;
							}
						}
						
						arr.push(n);
					}
				}

				arr = arr.filter(isKol);		// [Filter]
			}
		}
		
		private function isKol(element:*, index:int, arr:Array):Boolean {
            return (element.kol >= 0 || element.cat == '1');
        }

		// [One list element]
		override protected function setStatItem(item:MovieClip, obj:Object):void {
			item.id.text=obj.id;
			item.id.visible=false;
			item.nazv.text=obj.nazv;
			item.mq.visible=false;
			item.ramka.visible=false;
			item.nazv.alpha=1;
			item.kol.text='';
			item.kol.visible=false;
			if (page2 == PAGE_QUEST) {
				item.nazv.x=32;
				item.mq.visible=obj.main;
				item.mq.gotoAndStop(1);
				
				if (obj.state==2) {
					item.nazv.alpha=item.mq.alpha=0.4;
					item.nazv.text+=' ('+LanguageManager.reference.localText("pip", 'done')+')';
				}
				else {
					item.nazv.alpha=item.mq.alpha=1;
				}
			}
			else if (page2 == PAGE_NOTES) {
				item.nazv.x=32;
				item.nazv.htmlText=obj.nazv.substr((obj.nazv.charAt(0)==' ')?3:0, 60);
				item.kol.text=obj.nazv;
				item.mq.visible=true;
				item.mq.alpha=1;
				item.mq.gotoAndStop(obj.ico+1);
			}
			else if (page2 == PAGE_ENEMIES) {
				
				item.nazv.x = 5;
				
				if (obj.cat == '1') {
					item.nazv.htmlText = '<b>' + item.nazv.text + '</b>';
				}
				
				if (obj.cat == '2') {
					item.nazv.htmlText = '      <b>'+item.nazv.text + '</b>';
				}
				
				if (obj.cat == '3') {
					item.nazv.htmlText = '            ' + item.nazv.text;
				}
				
				if (obj.kol > 0) {
					item.kol.text = obj.kol;
				}
				
				item.kol.visible = true;
			}
		}

		//информация об элементе
		override protected function statInfo(event:MouseEvent):void {
			vis.info.y=vis.ico.y;
			if (page2 == PAGE_QUEST) {
				vis.info.htmlText=infoQuest(event.currentTarget.id.text);
			}
			else if (page2 == PAGE_WORLD_MAP) {
				var l:LandAct = game.lands[event.currentTarget.name];

				if (l == null || l.id == lastLandTooltipDisplayed) {
					return;
				}
				
				lastLandTooltipDisplayed = l.id;

				vis.nazv.text = Res.txt('m',l.id);
				var s:String = Res.txt('m',l.id,1);
				
				if (l.visited) {
					if (l.passed) s += "\n\n<span class ='orange'>" + LanguageManager.reference.localText("pip", 'ls2') + "</span>";							// "Cleared" message
					else if (l.tip == 'base') s += "\n\n<span class ='orange'>" + LanguageManager.reference.localText("pip", 'ls4') + "</span>";						// "Base camp" message
					else if (l.tip == 'rnd') s += "\n\n<span class ='yellow'>" + LanguageManager.reference.localText("pip", 'ls3') + ": " + (l.landStage + 1) + "</span>";
				}
				else {
					s += "\n\n<span class ='blue'>" + LanguageManager.reference.localText("pip", 'ls1') + "</span>";	// "Location level reached" message
				}
				
				if (l.tip == 'rnd' && l.kolAllProb > 0) {
					if (l.kolClosedProb >= l.kolAllProb) { // If all trials complete, print in green
						s += "\n" + LanguageManager.reference.localText("pip", 'kolProb') + ': ' + l.kolClosedProb + '/' + l.kolAllProb;
					}
					else { // Otherwise, print in yellow
						s += "\n<span class ='yellow'>" + LanguageManager.reference.localText("pip", 'kolProb') + ': ' + l.kolClosedProb + '/' + l.kolAllProb + "</span>";
					}
				}
				
				if (l.dif > 0) { // "Reccomended level" message
					if (World.w.pers.level < l.dif) { // Player below reccomended level, highlight red
						//trace('Highlighting level requirement. Requirement not met. 	Player level: "' + World.w.pers.level + '", requirement: "' + l.dif + '".');
						s += '\n\n' + "<span class = 'red'>"+ LanguageManager.reference.localText("pip", 'recLevel') + ' ' + Math.round(l.dif) + "</span>";
					}
					else {
						//trace('Highlighting level requirement. Requirement met. Player level: "' + World.w.pers.level + '", requirement: "' + l.dif + '".');
						s += '\n\n' + LanguageManager.reference.localText("pip", 'recLevel') + ' ' + Math.round(l.dif);
					}

					
				}
				
				if (l.dif>World.w.pers.level) {
					s += '\n\n' + LanguageManager.reference.localText("pip", 'wrLevel');
				}
				
				if (World.w.pers.speedShtr>=3) {
					s += '\n\n' + textAsColor('red', LanguageManager.reference.localText("pip", 'speedshtr3'));
				}
				else if (World.w.pers.speedShtr==2) {
					s += '\n\n' + textAsColor('red', LanguageManager.reference.localText("pip", 'speedshtr2'));
				}
				else if (World.w.pers.speedShtr==1) {
					s += '\n\n' + textAsColor('red', LanguageManager.reference.localText("pip", 'speedshtr1'));
				}
				
				if (World.w.pers.speedShtr >= 1) {
					s += '\n' + LanguageManager.reference.localText("pip", 'speedshtr0');
				}
				
				vis.info.htmlText=s;
			}
			else if (page2 == PAGE_NOTES) {
				vis.info.y=vis.nazv.y;
				var s:String=Res.messText(event.currentTarget.id.text,0,false);
				s=s.replace(/&lp/g,World.w.pers.persName);
				s=s.replace(/\[/g,"<span class='yellow'>");
				s=s.replace(/]/g,"</span>");
				vis.info.htmlText=s;
			}
			else if (page2 == PAGE_ENEMIES) {
				if (vis.ico.numChildren>0) {
					vis.ico.removeChildAt(0);
				}
				
				Unit.initIco(event.currentTarget.id.text)
				
				if (Unit.arrIcos[event.currentTarget.id.text]) {
					vis.ico.addChild(Unit.arrIcos[event.currentTarget.id.text]);
				}
				
				vis.nazv.text=event.currentTarget.nazv.text;
				vis.info.htmlText=Res.txt('u',event.currentTarget.id.text,1)+'\n'+infoUnit(event.currentTarget.id.text, event.currentTarget.kol.text);
				vis.info.y=vis.ico.y+vis.ico.height+20;
				vis.ico.x=685-vis.ico.width/2;
			}
			
			if (vis.scText) {
				vis.scText.visible = false;
			}
			
			if (vis.info.height<vis.info.textHeight && vis.scText) {
				vis.scText.scrollPosition=0;
				vis.scText.maxScrollPosition=vis.info.maxScrollV;
				vis.scText.visible=true;
			}
		}
		
		private function getParam(un, pun, cat:String, param:String):* {
			if (un.length()==0) return null;
			if (un[cat].length() && un[cat].attribute(param).length()) return un[cat].attribute(param);
			if (pun==null || pun.length()==0) return null;
			if (pun[cat].length() && pun[cat].attribute(param).length()) return pun[cat].attribute(param);
			return null;
		}
		
		private function infoUnit(id:String, kol:int):String {
			var n:int = 0;

			//юнит
			var un = getUnitInfo(id);

			if (un.length()==0 || un.@cat!='3') {
				return '';
			}
			
			//родитель
			var pun;
			
			if (un.@parent.length()) pun = getUnitInfo(un.@parent);
			//дельта
			
			var delta=getParam(un,pun,'vis','dkill');
			if (delta==null) delta=5;
			
			if (delta<=0) n=10;
			else n = Math.floor(int(kol)/delta);

			
			var v_hp		= getParam(un, pun, 'comb', 'hp');
			var v_skin		= getParam(un, pun, 'comb', 'skin');
			var v_aqual		= getParam(un, pun, 'comb', 'aqual');
			var v_armor		= getParam(un, pun, 'comb', 'armor');
			var v_marmor	= getParam(un, pun, 'comb', 'marmor');
			var v_dexter	= getParam(un, pun, 'comb', 'dexter');
			var v_skill		= getParam(un, pun, 'comb', 'skill');
			var v_observ	= getParam(un, pun, 'comb', 'observ');
			var v_visdam	= getParam(un, pun, 'vis',  'visdam');
			var v_damage	= getParam(un, pun, 'comb', 'damage');
			var v_tipdam	= getParam(un, pun, 'comb', 'tipdam');
			var v_sdamage	= getParam(un, pun, 'vis',  'sdamage');
			var v_stipdam	= getParam(un, pun, 'vis',  'stipdam');
			
			var s:String = "\n";
			
			if (un.comb.length()) {
				var node=un.comb[0];
				
				if (n>=1) {
					//ХП
					s+=LanguageManager.reference.localText("pip", 'hp')+': '+textAsColor('yellow', v_hp)+'\n';
					//порог урона и броня
					if (v_skin) 	s+=LanguageManager.reference.localText("pip", 'skin')+': '+textAsColor('yellow', v_skin)+'\n';
					if (v_aqual) {
						if (v_armor) 	s+=LanguageManager.reference.localText("pip", 'armor')+': '+textAsColor('yellow', v_armor)+' ('+(v_aqual*100)+'%)  ';
						if (v_marmor) 	s+=LanguageManager.reference.localText("pip", 'marmor')+': '+textAsColor('yellow', v_marmor)+' ('+(v_aqual*100)+'%)';
						if (v_armor || v_marmor)s+='\n';
					}
				}
				
				if (n>=2) {
					if ((v_visdam==1 || v_visdam==3) && v_damage) {
						s+=LanguageManager.reference.localText("pip", 'dam_melee')+': ';
						
						if (v_tipdam) {
							s+=textAsColor('blue', LanguageManager.reference.localText("pip", 'tipdam'+v_tipdam));
						}
						else {
							s+=textAsColor('blue', LanguageManager.reference.localText("pip", 'tipdam2'));
						}
						
						s+=' ('+textAsColor('yellow', v_damage)+')\n'
					}
					
					if ((v_visdam==2 || v_visdam==3) && v_sdamage) {
						s+=LanguageManager.reference.localText("pip", 'dam_shoot')+': ';
						
						if (v_stipdam) {
							s+=textAsColor('blue', LanguageManager.reference.localText("pip", 'tipdam'+v_stipdam));
						}
						else {
							s+=textAsColor('blue', LanguageManager.reference.localText("pip", 'tipdam0'));
						}
						
						s+=' ('+textAsColor('yellow', v_sdamage)+')\n'
					}
					
					// Get what weapons the enemy uses
					if (un.w.length()) {
						var wk:Boolean = false;
						for each (var weap in un.w) {
							if (!(weap.@no > 0)) {
								if (wk) {
									s += ', ';
								}
								else {
									s += LanguageManager.reference.localText("pip", 'enemy_weap') + ': ';
								}
								
								s += textAsColor('blue', Res.txt('w', weap.@id));
								
								try {
									var data:Object = WeaponManager.reference.weaponData(weap.@id);
									var dam:Number = 0;
									
									if (data.damage > 0) {
										dam += Number(data.damage);
									}
									
									if (data.damageExpl > 0) {
										dam += Number(data.damageExpl);
									}
									
									s += ' (' + textAsColor('yellow', Res.numb(dam)) + ')';
								}
								catch (err) {
									trace('ERROR: (00:3B)');
								}
								
								wk = true;
							}
						}
						
						s += "\n";
					}
				}
				
				//уклонение
				if (n>=3) {
					if (v_dexter!=null) 	s+=LanguageManager.reference.localText("pip", 'dexter')+': '+textAsColor('yellow', (v_dexter>1?'+':'')+Math.round((v_dexter-1)*100)+'%')+'\n';
					if (v_observ) 	s+=LanguageManager.reference.localText("pip", 'observ')+': '+textAsColor('yellow', (v_observ>0?'+':'')+v_observ)+'\n';
					if (v_skill!=null) 	s+=LanguageManager.reference.localText("pip", 'weapskill')+': '+textAsColor('yellow', Math.round(v_skill*100)+'%')+'\n';
				}
			}
			
			//сопротивления
			if (n>=3 && un.vulner.length()) {
				s += LanguageManager.reference.localText("pip", 'resists')+': ';
				node = un.vulner[0];
				
				if (node.@bul.length()) 	s += vulner(0,  node.@bul);
				if (node.@blade.length()) 	s += vulner(1,  node.@blade);
				if (node.@phis.length()) 	s += vulner(2,  node.@phis);
				if (node.@fire.length()) 	s += vulner(3,  node.@fire);
				if (node.@expl.length()) 	s += vulner(4,  node.@expl);
				if (node.@laser.length()) 	s += vulner(5,  node.@laser);
				if (node.@plasma.length()) 	s += vulner(6,  node.@plasma);
				if (node.@venom.length()) 	s += vulner(7,  node.@venom);
				if (node.@emp.length()) 	s += vulner(8,  node.@emp);
				if (node.@spark.length()) 	s += vulner(9,  node.@spark);
				if (node.@acid.length()) 	s += vulner(10, node.@acid);
				if (node.@cryo.length()) 	s += vulner(11, node.@cryo);
			}
			return s;
		}
		
		private function vulner(n:int, val:Number):String {
			return textAsColor('blue', LanguageManager.reference.localText("pip", 'tipdam' + n))+': ' + textAsColor('yellow', Math.round((1 - val) * 100) + '%   ');
		}
		
		override protected function itemClick(event:MouseEvent):void {
			if (pip.noAct) {
				World.w.gui.infoText('noAct');
				return;
			}
			
			if (page2 == PAGE_WORLD_MAP && (pip.travel || World.w.testMode)) {
				if (targetLand != "" && visWMap[targetLand]) {
					visWMap[targetLand].zad.gotoAndStop(1);
				}
				
				var id = event.currentTarget.name;
				
				if (game.checkTravel(id)) {
					targetLand=id;
					setStatItems();
					vis.butOk.visible=true;
					if (targetLand!='' && visWMap[targetLand]) {
						visWMap[targetLand].zad.gotoAndStop(2);
					}
				}
				else {
					vis.butOk.visible=false;
					World.w.gui.infoText('noTravel');
				}
				
				pip.snd(1);
			}
		}
		
		private function transOk(event:MouseEvent):void {
			if (pip.noAct) {
				World.w.gui.infoText('noAct');
				return;
			}
			
			if (page2 == PAGE_WORLD_MAP && (pip.travel || World.w.testMode)) {
				if (game.lands[targetLand] && game.lands[targetLand].loaded) {
					game.beginMission(targetLand);
					pip.onoff(-1);
				}
			}
			
			if (page2 == PAGE_QUEST) {
				addAllQuestsToGameClass();
				setStatus();
			}
		}

		private function addAllQuestsToGameClass():void {
			for each (var task in cachedTaskList) {
				if (task.@man=='1') continue;
				if (checkQuest(task)) {
					var q:Quest = game.quests[task.@id];
					if (q == null || q.state==0) game.addQuest(task.@id, null, false, false, false);
				}
			}
		}
		
		public function onMouseDown(event:MouseEvent):void {
			visMap.vmap.startDrag();
		}

		public function onMouseUp(event:MouseEvent):void {
			visMap.vmap.stopDrag();
			setMapSize();
		}

		public function funZoomP(event:MouseEvent):void {
			mapScale++;
			setMapSize(visMap.fon.width/2, visMap.fon.height/2);
		}

		public function funZoomM(event:MouseEvent):void {
			mapScale--;
			setMapSize(visMap.fon.width/2, visMap.fon.height/2);
		}

		public function funCenter(event:MouseEvent):void {
			visMap.vmap.x=visMap.fon.width/2-plTag.x;
			visMap.vmap.y=visMap.fon.height/2-plTag.y;
		}
		
		private function setMapSize(cx:Number=350, cy:Number=285):void {
			if (mapScale > 6) mapScale = 6;
			if (mapScale < 1) mapScale = 1;

			map.scaleX = mapScale;
			map.scaleY = mapScale;

			var tx = (visMap.vmap.x - cx) * mapScale / ms;
			var ty = (visMap.vmap.y - cy) * mapScale / ms;

			visMap.vmap.x = tx + cx;
			visMap.vmap.y = ty + cy;

			plTag.x = World.w.land.ggX / tileX * mapScale;
			plTag.y = World.w.land.ggY / tileY * mapScale;

			ms = mapScale;
		}
		
		public override function scroll(dn:int=0):void {
			if (page2==1) {
				if (dn>0) mapScale++;
				if (dn<0) mapScale--;
				setMapSize(visMap.mouseX, visMap.mouseY);
			}
		}

		private function funWMapClick(event:MouseEvent):void {
			trace(event.currentTarget.name);
		}

		private function funWMapOver(event:MouseEvent):void {
			//trace(event.currentTarget.name);
		}
	}
}
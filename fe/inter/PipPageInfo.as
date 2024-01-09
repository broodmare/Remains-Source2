package fe.inter {
	
	import fe.*;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import fe.loc.Game;
	import fe.loc.Quest;
	import fe.loc.LandAct;
	import fe.unit.Unit;
	import flash.text.TextField;
	
	public class PipPageInfo extends PipPage{
		
		var visMap:MovieClip;
		var visWMap:MovieClip;
		public var map:Bitmap;
		public var mbmp:BitmapData;
		var visPageX=850, visPageY=540;
		var mapScale:Number=2, ms:Number=2;
		var plTag:MovieClip;
		var targetLand:String='';
		var game:Game;

		public function PipPageInfo(npip:PipBuck, npp:String) {
			itemClass=visPipQuestItem;
			pageClass=visPipInfo;
			isLC=true;
			super(npip,npp);
			//объект карты
			visMap=new visPipMap();
			visWMap=new visPipWMap();
			vis.addChild(visMap);
			vis.addChild(visWMap);
			visMap.x=12;
			visMap.y=75;
			visWMap.x=17;
			visWMap.y=80;
			//битмап
			map=new Bitmap();
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
		

		override function setSubPages() {
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
			if (page2==1) {		//карта
				if (World.w.loc.noMap) {
					vis.emptytext.text=Res.pipText('emptymap');
				} else {
					vis.emptytext.text='';
					map.bitmapData=World.w.land.drawMap();
					setMapSize();
					visMap.visible=true;
				}
			} else if (page2==2) {	//задания
				for each(var q:Quest in game.quests) {
					if (q.state>0) {
						var n:Object={id:q.id, nazv:q.nazv, main:q.main, sort:(q.main?0:1), state:q.state};
						arr.push(n);
					}
				}
				if (arr.length) arr.sortOn(['state','sort','nazv']);
				if (World.w.loc && World.w.loc.base) {
					for each (var task in GameData.d.vendor.task) {
						if (checkQuest(task)) {
							var q:Quest=game.quests[task.@id];
							if (q==null || q.state==0) {
								vis.butOk.visible=true;
								vis.butOk.text.text=Res.pipText('alltask');
								break;
							}
						}
					}
				}
			} else if (page2==3) {	//общая карта
				vis.nazv.x=vis.info.x=584;
				vis.nazv.width=287;
				vis.info.width=332;
				if (pip.travel) setTopText('infotravel');
				for each (var land:LandAct in game.lands) {
					if (land.prob) continue;
					land.calcProbs();
					var sim:MovieClip=visWMap[land.id];
					if (sim) {
						sim.alpha=1;
						sim.zad.gotoAndStop(1);
						sim.sign.stop();
						sim.sign.visible=false;
						sim.visible=false;
						if (!sim.hasEventListener(MouseEvent.CLICK)) {
							sim.addEventListener(MouseEvent.CLICK,itemClick);
							sim.addEventListener(MouseEvent.MOUSE_OVER,statInfo);
						}
						try {
							sim.sim.gotoAndStop(land.id);
						} catch (err) {
							sim.sim.gotoAndStop(1);
						}
						//trace(land.id, World.w.testMode);
						if (land.test && !World.w.testMode) continue;
						if (!game.checkTravel(land.id)) sim.alpha=0.5;
						if (World.w.testMode && !land.visited && !land.access) sim.alpha=0.3;
						if (World.w.helpMess && !land.visited && land.access) {
							sim.sign.play();
							sim.sign.visible=true;
						}
						if (World.w.testMode || land.visited || land.access) sim.visible=true;
					}
				}
				vis.butOk.text.text=Res.pipText('trans');
				visWMap.visible=true;
				pip.vis.butHelp.visible=true;
				pip.helpText=Res.txt('p','helpWorld',0,true);
			} else if (page2==4) {	//записи
				var doparr:Array=new Array();
				for each (var note:String in game.notes) {
					/*var s:String=Res.messText(note,0,false);
					if (s=='') continue;
					s=s.replace(/&lp/g,World.w.pers.persName);
					s=s.replace(/\[/g,"<span class='yel'>");
					s=s.replace(/\]/g,"</span>");*/
					var xml=Res.d.txt.(@id==note);
					var nico:int=0;
					if (xml && xml.@imp>0) {
						nico=int(xml.@imp);
					} else continue;
					var title:String;
					if (xml.n.t.length()) title=xml.n.t[0];
					else title=xml.n.r[0];
					title=title.replace(/&lp/g,World.w.pers.persName);
					var n:Object={id:note, nazv:title, ico:nico};
					if (nico==3) doparr.push(n);
					else arr.push(n);
				}
				arr.reverse();
				arr=doparr.concat(arr);
			} else if (page2==5) {	//противники
				if (Unit.arrIcos==null) Unit.initIcos();
				var prevObj:Object=null;
				statHead.visible=true;
				statHead.nazv.text='';
				statHead.mq.visible=false;
				statHead.kol.text=Res.pipText('frag');
				vis.ico.visible=true;
				for each(var xml in AllData.d.unit) {
					if (xml && xml.@cat.length()) {
						var n:Object={id:xml.@id, nazv:Res.txt('u',xml.@id), cat:xml.@cat, kol:-1};
						if (xml.@cat=='3' && World.w.game.triggers['frag_'+xml.@id]>=0) n.kol=int(World.w.game.triggers['frag_'+xml.@id]);
						if (xml.@cat=='2') {
							prevObj=n;
						} else if (xml.@cat=='3') {
							if (prevObj && n.kol>=0) {
								if (prevObj.kol<0) prevObj.kol=0;
								prevObj.kol+=n.kol;
							}
							if (prevObj) n.prev=prevObj.id;
						}
						arr.push(n);
					}
				}
				arr=arr.filter(isKol);		//отфильтровать
				//if (arr.length) arr.sortOn('sort');
			}
		}
		
		/*override function setSigns() {
			super.setSigns();
			signs[5]=2;
		}*/
		
		private function isKol(element:*, index:int, arr:Array):Boolean {
            return (element.kol>=0 || element.cat=='1');
        }		
		//один эемент списка
		override function setStatItem(item:MovieClip, obj:Object) {
			item.id.text=obj.id;
			item.id.visible=false;
			item.nazv.text=obj.nazv;
			item.mq.visible=false;
			item.ramka.visible=false;
			item.nazv.alpha=1;
			item.kol.text='';
			item.kol.visible=false;
			if (page2==2) {
				item.nazv.x=32;
				item.mq.visible=obj.main;
				item.mq.gotoAndStop(1);
				if (obj.state==2) {
					item.nazv.alpha=item.mq.alpha=0.4;
					item.nazv.text+=' ('+Res.pipText('done')+')';
				} else {
					item.nazv.alpha=item.mq.alpha=1;
				}
			} else if (page2==3) {
				/*item.nazv.x=5;
				if (obj.id==targetLand) item.ramka.visible=true;
				if (obj.kol>0) item.kol.text=obj.kol;
				item.kol.visible=true;*/
			} else if (page2==4) {
				item.nazv.x=32;
				item.nazv.htmlText=obj.nazv.substr((obj.nazv.charAt(0)==' ')?3:0, 60);
				item.kol.text=obj.nazv;
				item.mq.visible=true;
				item.mq.alpha=1;
				item.mq.gotoAndStop(obj.ico+1);
			} else if (page2==5) {
				item.nazv.x=5;
				if (obj.cat=='1') item.nazv.htmlText='<b>'+item.nazv.text+'</b>';
				if (obj.cat=='2') item.nazv.htmlText='      <b>'+item.nazv.text+'</b>';
				if (obj.cat=='3') item.nazv.htmlText='            '+item.nazv.text;
				if (obj.kol>0) item.kol.text=obj.kol;
				item.kol.visible=true;
			}
		}
		//информация об элементе
		override function statInfo(event:MouseEvent) {
			vis.info.y=vis.ico.y;
			//vis.info.condenseWhite=false;
			if (page2==2) {
				vis.info.htmlText=infoQuest(event.currentTarget.id.text);
			} else if (page2==3) {
				var l:LandAct=game.lands[event.currentTarget.name];
				if (l==null) return;
				vis.nazv.text=Res.txt('m',l.id);
				var s:String=Res.txt('m',l.id,1);
				if (!l.visited) s+="\n\n<span class ='blu'>"+Res.pipText('ls1')+"</span>";
				else if (l.passed) s+="\n\n<span class ='or'>"+Res.pipText('ls2')+"</span>";
				else if (l.tip=='base') s+="\n\n<span class ='or'>"+Res.pipText('ls4')+"</span>";
				else if (l.tip=='rnd') s+="\n\n<span class ='yel'>"+Res.pipText('ls3')+": "+(l.landStage+1)+"</span>";
				if (l.tip=='rnd' && l.kolAllProb>0) {
					s+="\n<span class ='yel'>"+Res.pipText('kolProb')+': '+l.kolClosedProb+'/'+l.kolAllProb+"</span>";
				}
				if (l.dif>0) s+='\n\n'+Res.pipText('recLevel')+' '+Math.round(l.dif);
				if (l.dif>World.w.pers.level) s+='\n\n'+Res.pipText('wrLevel');
				if (World.w.pers.speedShtr>=3) {
					s+='\n\n'+red(Res.pipText('speedshtr3'));
				} else if (World.w.pers.speedShtr==2) {
					s+='\n\n'+red(Res.pipText('speedshtr2'));
				} else if (World.w.pers.speedShtr==1) {
					s+='\n\n'+red(Res.pipText('speedshtr1'));
				}
				if (World.w.pers.speedShtr>=1) s+='\n'+Res.pipText('speedshtr0');
				vis.info.htmlText=s;
			} else if (page2==4) {
				vis.info.y=vis.nazv.y;
				//vis.info.condenseWhite=true;
				//vis.info.htmlText=event.currentTarget.kol.text;
				var s:String=Res.messText(event.currentTarget.id.text,0,false);
				s=s.replace(/&lp/g,World.w.pers.persName);
				s=s.replace(/\[/g,"<span class='yel'>");
				s=s.replace(/\]/g,"</span>");
				vis.info.htmlText=s;
			} else if (page2==5) {
				if (vis.ico.numChildren>0) vis.ico.removeChildAt(0);
				Unit.initIco(event.currentTarget.id.text)
				if (Unit.arrIcos[event.currentTarget.id.text]) vis.ico.addChild(Unit.arrIcos[event.currentTarget.id.text]);
				vis.nazv.text=event.currentTarget.nazv.text;
				vis.info.htmlText=Res.txt('u',event.currentTarget.id.text,1)+'\n'+infoUnit(event.currentTarget.id.text, event.currentTarget.kol.text);
				vis.info.y=vis.ico.y+vis.ico.height+20;
				vis.ico.x=685-vis.ico.width/2; //460 910
			}
			if (vis.scText) vis.scText.visible=false;
			if (vis.info.height<vis.info.textHeight && vis.scText) {
				vis.scText.scrollPosition=0;
				vis.scText.maxScrollPosition=vis.info.maxScrollV;
				vis.scText.visible=true;
				//vis.info.scaleX=vis.info.scaleY=0.8;
				//vis.info.height=vis.info.textHeight+5;
			}
		}
		
		function getParam(un, pun, cat:String, param:String):* {
			if (un.length()==0) return null;
			if (un[cat].length() && un[cat].attribute(param).length()) return un[cat].attribute(param);
			if (pun==null || pun.length()==0) return null;
			if (pun[cat].length() && pun[cat].attribute(param).length()) return pun[cat].attribute(param);
			return null;
		}
		
		function infoUnit(id:String, kol):String {
			var n:int=0, delta;
			//юнит
			var un=AllData.d.unit.(@id==id);
			if (un.length()==0 || un.@cat!='3') return '';
			//родитель
			var pun;
			if (un.@parent.length()) pun=AllData.d.unit.(@id==un.@parent);
			//дельта
			delta=getParam(un,pun,'vis','dkill');
			if (delta==null) delta=5;
			if (delta<=0) n=10;
			else n=Math.floor(int(kol)/delta);
			//n=10;
			
			var v_hp=getParam(un,pun,'comb','hp');
			var v_skin=getParam(un,pun,'comb','skin');
			var v_aqual=getParam(un,pun,'comb','aqual');
			var v_armor=getParam(un,pun,'comb','armor');
			var v_marmor=getParam(un,pun,'comb','marmor');
			var v_dexter=getParam(un,pun,'comb','dexter');
			var v_skill=getParam(un,pun,'comb','skill');
			var v_observ=getParam(un,pun,'comb','observ');
			var v_visdam=getParam(un,pun,'vis','visdam');
			var v_damage=getParam(un,pun,'comb','damage');
			var v_tipdam=getParam(un,pun,'comb','tipdam');
			var v_sdamage=getParam(un,pun,'vis','sdamage');
			var v_stipdam=getParam(un,pun,'vis','stipdam');
			
			var s:String='\n';
			if (un.comb.length()) {
				var node=un.comb[0];
				if (n>=1) {
					//ХП
					s+=Res.pipText('hp')+': '+yel(v_hp)+'\n';
					//порог урона и броня
					if (v_skin) 	s+=Res.pipText('skin')+': '+yel(v_skin)+'\n';
					if (v_aqual) {
						if (v_armor) 	s+=Res.pipText('armor')+': '+yel(v_armor)+' ('+(v_aqual*100)+'%)  ';
						if (v_marmor) 	s+=Res.pipText('marmor')+': '+yel(v_marmor)+' ('+(v_aqual*100)+'%)';
						if (v_armor || v_marmor)s+='\n';
					}
				}
				if (n>=2) {
					if ((v_visdam==1 || v_visdam==3) && v_damage) {
						s+=Res.pipText('dam_melee')+': ';
						if (v_tipdam) s+=blue(Res.pipText('tipdam'+v_tipdam)); else s+=blue(Res.pipText('tipdam2'));
						s+=' ('+yel(v_damage)+')\n'
					}
					if ((v_visdam==2 || v_visdam==3) && v_sdamage) {
						s+=Res.pipText('dam_shoot')+': ';
						if (v_stipdam) s+=blue(Res.pipText('tipdam'+v_stipdam)); else s+=blue(Res.pipText('tipdam0'));
						s+=' ('+yel(v_sdamage)+')\n'
					}
					if (un.w.length()) {
						var wk:Boolean=false;
						for each (var weap in un.w) {
							if (!(weap.@no>0)) {// && Res.istxt('w', weap.@id)) {
								if (wk) s+=', ';
								else s+=Res.pipText('enemy_weap')+': ';
								s+=blue(Res.txt('w', weap.@id));
								try {
									var w=AllData.d.weapon.(@id==weap.@id);
									var dam=0;
									if (w.char[0].@damage>0) dam+=Number(w.char[0].@damage);
									if (w.char[0].@damexpl>0) dam+=Number(w.char[0].@damexpl);
									s+=' ('+yel(Res.numb(dam))+')';
								} catch (err) {};
								wk=true;
							}
						}
						s+='\n';
					}
				}
				//уклонение
				if (n>=3) {
					if (v_dexter!=null) 	s+=Res.pipText('dexter')+': '+yel((v_dexter>1?'+':'')+Math.round((v_dexter-1)*100)+'%')+'\n';
					if (v_observ) 	s+=Res.pipText('observ')+': '+yel((v_observ>0?'+':'')+v_observ)+'\n';
					if (v_skill!=null) 	s+=Res.pipText('weapskill')+': '+yel(Math.round(v_skill*100)+'%')+'\n';
				}
			}
			//сопротивления
			if (n>=3 && un.vulner.length()) {
				s+=Res.pipText('resists')+': ';
				node=un.vulner[0];
				if (node.@emp.length()) 	s+=vulner(Unit.D_EMP,node.@emp);
				if (node.@bul.length()) 	s+=vulner(Unit.D_BUL,node.@bul);
				if (node.@blade.length()) 	s+=vulner(Unit.D_BLADE,node.@blade);
				if (node.@phis.length()) 	s+=vulner(Unit.D_PHIS,node.@phis);
				if (node.@expl.length()) 	s+=vulner(Unit.D_EXPL,node.@expl);
				if (node.@laser.length()) 	s+=vulner(Unit.D_LASER,node.@laser);
				if (node.@plasma.length()) 	s+=vulner(Unit.D_PLASMA,node.@plasma);
				if (node.@fire.length()) 	s+=vulner(Unit.D_FIRE,node.@fire);
				if (node.@cryo.length()) 	s+=vulner(Unit.D_CRIO,node.@cryo);
				if (node.@spark.length()) 	s+=vulner(Unit.D_SPARK,node.@spark);
				if (node.@venom.length()) 	s+=vulner(Unit.D_VENOM,node.@venom);
				if (node.@acid.length()) 	s+=vulner(Unit.D_ACID,node.@acid);
			}
			return s;
		}
		
		function vulner(n:int, val:Number):String {
			return blue(Res.pipText('tipdam'+n))+': '+yel(Math.round((1-val)*100)+'%   ');
		}
		
		
		override function itemClick(event:MouseEvent) {
			if (pip.noAct) {
				World.w.gui.infoText('noAct');
				return;
			}
			if (page2==3 && (pip.travel || World.w.testMode)) {
				if (targetLand!='' && visWMap[targetLand]) {
					visWMap[targetLand].zad.gotoAndStop(1);
				}
				var id=event.currentTarget.name;
				if (game.checkTravel(id)) {
					targetLand=id;
					setStatItems();
					vis.butOk.visible=true;
					if (targetLand!='' && visWMap[targetLand]) {
						visWMap[targetLand].zad.gotoAndStop(2);
					}
				} else {
					vis.butOk.visible=false;
					World.w.gui.infoText('noTravel');
				}
				pip.snd(1);
			}
		}
		
		function transOk(event:MouseEvent) {
			if (pip.noAct) {
				World.w.gui.infoText('noAct');
				return;
			}
			if (page2==3 && (pip.travel || World.w.testMode)) {
				if (game.lands[targetLand] && game.lands[targetLand].loaded) {
					game.beginMission(targetLand);
					pip.onoff(-1);
				} else {
					
				}
			}
			if (page2==2) {
				for each (var task in GameData.d.vendor.task) {
					if (task.@man=='1') continue;
					if (checkQuest(task)) {
						var q:Quest=game.quests[task.@id];
						if (q==null || q.state==0) game.addQuest(task.@id,null,false,false,false);
					}
				}
				setStatus();
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
		
		function setMapSize(cx:Number=350, cy:Number=285) {
			/*if (isset) {
				var s=Math.min(visPageX/map.bitmapData.width,visPageY/map.bitmapData.height);
				if (s>=1) {
					mapScale=Math.floor(s)
				} else {
					mapScale=1;
				}
			}*/
			if (mapScale>6) mapScale=6;
			if (mapScale<1) mapScale=1;
			map.scaleX=map.scaleY=mapScale;
			var tx=(visMap.vmap.x-cx)*mapScale/ms;
			var ty=(visMap.vmap.y-cy)*mapScale/ms;
			visMap.vmap.x=tx+cx;
			visMap.vmap.y=ty+cy;
			plTag.x=World.w.land.ggX/World.tileX*mapScale;
			plTag.y=World.w.land.ggY/World.tileY*mapScale;
			ms=mapScale;
		}
		
		public override function scroll(dn:int=0) {
			if (page2==1) {
				if (dn>0) mapScale++;
				if (dn<0) mapScale--;
				setMapSize(visMap.mouseX, visMap.mouseY);
			}
		}

		function funWMapClick(event:MouseEvent) {
			trace(event.currentTarget.name);
		}
		function funWMapOver(event:MouseEvent) {
			//trace(event.currentTarget.name);
		}
		
	}
	
}

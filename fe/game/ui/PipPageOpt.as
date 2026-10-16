package fe.game.ui {

	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.StageDisplayState;
	import flash.net.FileReference;
	import flash.net.FileFilter;
	import flash.utils.ByteArray;

	import fl.controls.CheckBox;
	import fl.controls.ScrollBar;
	import fl.events.ScrollEvent;

	import fe.engine.audio.Sound;
	import fe.engine.text.LanguageManager;
	import fe.engine.text.TextParser;
	import fe.game.World;
	import fe.engine.Engine;
	import fe.game.GameContainer;
	
	import fe.game.AutoPickupManager;
	import fe.engine.SaveManager;
	import fe.engine.utils.SymbolFactory;
	
	/* 
	*	One of the main pip-buck categories
	*	sub-categories:
	*		1 - Load
	*		2 - Save
	*		3 - Options
	*		4 - Controls
	*		5 - Log
	*		6 - Item Pickup Options
	*/
	public class PipPageOpt extends PipPage {
		
		private static const PAGE_LOAD:int = 1, PAGE_SAVE:int = 2, PAGE_OPTIONS:int = 3, PAGE_CONTROLS:int = 4, PAGE_LOG:int = 5, PAGE_AUTOPICKUP_OPT:int = 6;

		private var setkeyAction:String;
		private var setkeyCell:int=1;
		private var nSave:int=-1;
		private var info:TextField;

		private var file:FileReference = new FileReference();
		private var ffil:Array;
		
		public function PipPageOpt(npip:PipBuck, npp:String) {
			isLC=true;
			itemClass=SymbolFactory.fetchSymbolClass("visPipOptItem");
			super(npip,npp);
			vis.butOk.addEventListener(MouseEvent.CLICK,transOk);
			vis.butDef.addEventListener(MouseEvent.CLICK,gotoDef);
			file.addEventListener(Event.SELECT, selectHandler);
			file.addEventListener(Event.COMPLETE, completeHandler);
			pip.vis.butHelp.visible=false;
			var log:MovieClip = SymbolFactory.createInstance("logText");
			info=log.text;
			log.x = 20;
			log.y = 85;
			vis.addChild(log);
		}

		//подготовка страниц
		override protected  function setSubPages():void {
			var localize:Function = LanguageManager.reference.localText;
			gg = GameContainer.reference.gg;
			inv = GameContainer.reference.invent;
			
			info.visible = false;
			statHead.visible = false;
			
			vis.butOk.visible = false;
			vis.butDef.visible = false;
			vis.pers.visible = false;
			vis.info.y = 160;
			
			nSave = -1;
			
			if (page2 == PAGE_OPTIONS) {
				statHead.nazv.text=statHead.numb.text="";
				arr.push({id:"fullscreen"});
				arr.push({id:"zoom100", check:GameContainer.reference.zoom100});
				arr.push({id:"quake", check:GameContainer.reference.quakeCam});
				arr.push({id:"opt1_1", numb:Math.round(Sound.globalVol*100)});
				arr.push({id:"opt1_2", numb:Math.round(Sound.musicVol*100)});
				arr.push({id:"opt1_3", numb:Math.round(Sound.stepVol*100)});
				arr.push({id:"help_mess", check:GameContainer.reference.helpMess});
				arr.push({id:"dial_on", check:GameContainer.reference.dialOn});
				arr.push({id:"show_hit1", check:GameContainer.reference.showHit>0});
				arr.push({id:"show_hit2", check:GameContainer.reference.showHit==2});
				arr.push({id:"hint_tele", check:GameContainer.reference.hintTele});
				arr.push({id:"sys_cur", check:GameContainer.reference.sysCur});
				arr.push({id:"show_favs", check:GameContainer.reference.showFavs});
				arr.push({id:"mat_filter", check:GameContainer.reference.matFilter});
				arr.push({id:"err_show", check:GameContainer.reference.errorShowOpt});
				arr.push({id:"autotake"});
			}

			if (page2 == PAGE_AUTOPICKUP_OPT) {
				arr.push({id:"vsWeaponNew", check:AutoPickupManager.reference.vsWeaponNew});
				arr.push({id:"vsWeaponRep", check:AutoPickupManager.reference.vsWeaponRep});
				arr.push({id:"vsAmmoAll", check:AutoPickupManager.reference.vsAmmoAll});
				arr.push({id:"vsAmmoTek", check:AutoPickupManager.reference.vsAmmoTek});
				arr.push({id:"vsExplAll", check:AutoPickupManager.reference.vsExplAll});
				arr.push({id:"vsMedAll", check:AutoPickupManager.reference.vsMedAll});
				arr.push({id:"vsHimAll", check:AutoPickupManager.reference.vsHimAll});
				arr.push({id:"vsEqipAll", check:AutoPickupManager.reference.vsEqipAll});
				arr.push({id:"vsStuffAll", check:AutoPickupManager.reference.vsStuffAll});
				arr.push({id:"vsVal", check:AutoPickupManager.reference.vsVal});
				arr.push({id:"vsBook", check:AutoPickupManager.reference.vsBook});
				arr.push({id:"vsFood", check:AutoPickupManager.reference.vsFood});
				arr.push({id:"vsComp", check:AutoPickupManager.reference.vsComp});
				arr.push({id:"vsIngr", check:AutoPickupManager.reference.vsIngr});
			}

			if (page2 == PAGE_CONTROLS) {
				setTopText("infokeys");
				
				for (i in GameContainer.reference.ctr.keyObj) {
					var key:Object=GameContainer.reference.ctr.keyObj[i];
					obj={id:key.id, nazv:TextParser.txt("k",key.id), a1:key.a1, a2:key.a2};
					arr.push(obj);
				}
				
				vis.butOk.text.text = localize("pip", "accept");
				vis.butDef.visible=true;
				vis.butDef.text.text = localize("pip", "default");
			}

			if (page2 == PAGE_LOG) {
				if (pip.light) {
					return;
				}

				info.visible=true;
				info.styleSheet=GUIManager.reference.gui.style;
				info.htmlText=World.w.log;
				info.scrollV=info.maxScrollV;
			}

			if (page2 == PAGE_LOAD || page2 == PAGE_SAVE) {
				if (pip.light) {
					return;
				}

				vis.butDef.visible=true;
				GUIManager.reference.app.saveOst();

				if (page2 == PAGE_LOAD) {
					setTopText("infoload");
					vis.butOk.text.text  = localize("pip", "opt1");
					vis.butDef.text.text = localize("pip", "loadfile");
				}
				else {
					setTopText("infosave");
					
					if (GameContainer.reference.pers.hardcore) {
						nSave=World.w.autoSaveN;
						vis.butOk.visible=true;
					}
					
					vis.butOk.text.text = localize("pip", "opt2");
					
					if (gg.pers.hardcore) {
						vis.butDef.visible = false;
					}
					
					vis.butDef.text.text = localize("pip", "savefile");
				}
				
				for (var i = 0; i <= SaveManager.reference.saveKol; i++) {
					var save:Object = SaveManager.reference.getSave(i);
					var obj:Object = saveObj(save,i);
					arr.push(obj);
				}
				
				if (page2 == PAGE_SAVE && GameContainer.reference.pers.hardcore) {
					showSaveInfo(arr[nSave],vis);
				}
				
				pip.vis.butHelp.visible = true;
				pip.helpText = TextParser.txt("p", "helpSave", 0, true);
			}
		}
		
		public static function saveObj(save:Object, n):Object {
			var obj:Object={id:n};
			
			if (save==null || save.est==null) {
				obj.nazv=LanguageManager.reference.localText("pip", "freeslot");
				obj.gg="";
				obj.date="";
			} 
			else {
				obj.nazv=(n==0)?LanguageManager.reference.localText("pip", "autoslot"):(LanguageManager.reference.localText("pip", "saveslot")+" "+n);
				obj.gg=(save.pers.persName==null)?"-------":save.pers.persName;
				obj.land=TextParser.txt("m",save.game.land);
				obj.level=(save.pers.level==null)?"":save.pers.level;
				obj.date=(save.date==null)?"-------":TextParser.getDate(save.date);
				obj.dif=TextParser.txt("g", "dif"+save.game.dif);
				obj.app=save.app;
				obj.armor=save.invent.cArmorId;
				
				if (save.pers.dead) {
					obj.hard=2;
				}
				else if (save.pers.hardcore) {
					obj.hard=1;
				}
				
				if (save.hardInv) {
					obj.hardInv=1;
				}
				
				if (save.pers.rndpump) {
					obj.rndpump=1;
				}
				
				obj.time=TextParser.gameTime(save.game.t_save);
				obj.ver=save.ver;
			}
			return obj;
		}		
		
		// [Show one element]
		override protected function setStatItem(item:MovieClip, obj:Object):void {
			if (obj.id == null) {
                item.id.text = "";
            }
			else {
				item.id.text = obj.id;
			}
			
			item.id.visible=false;
			item.scr.visible=false;
			item.check.visible=false;
			item.key1.visible=item.key2.visible=false;
			item.ramka.visible=false;
			item.land.text = "";
			
			if (page2 == PAGE_OPTIONS || page2 == PAGE_AUTOPICKUP_OPT) {
				item.nazv.text = LanguageManager.reference.localText("pip", obj.id);
				item.ggName.text = "";
				if (obj.numb == null) {
                    item.numb.text = "";
                }
				else {
                    item.numb.text = obj.numb;
                    var scr:ScrollBar = item.scr;
                    scr.visible = true;
                    scr.minScrollPosition = 0;
                    scr.maxScrollPosition = 100;
                    scr.scrollPosition = obj.numb;
                    if (!scr.hasEventListener(ScrollEvent.SCROLL)) scr.addEventListener(ScrollEvent.SCROLL, optScroll);
                }
				if (obj.check!=null) {
					item.check.visible=true;
					var ch:CheckBox=item.check;
					ch.selected=obj.check;
					if (!ch.hasEventListener(Event.CHANGE)) ch.addEventListener(Event.CHANGE,optCheck);
				}
			}
			
			if (page2 == PAGE_CONTROLS) {
				item.key1.visible=item.key2.visible=true;
				item.numb.text=item.ggName.text="";
				item.nazv.text=obj.nazv;
				setVisKey(obj.a1,item.key1);
				setVisKey(obj.a2,item.key2);
			}
			
			if (page2 == PAGE_LOAD || page2 == PAGE_SAVE) {
				item.nazv.text=obj.nazv;
				item.numb.text=obj.date;
				item.ggName.text=obj.gg;
				
				if (obj.level) {
					item.ggName.text+=((obj.level == "") ? "" : (" (" + obj.level + ")"));
				}
				
				if (obj.land) {
					item.land.text=obj.land.substr(0,18);
				}
				
				if (obj.hard==1) {
					item.nazv.text+=" {!}";
				}
				
				if (obj.hard==2) {
					item.nazv.text+=" [†]";
				}
				
				if (nSave==obj.id) {
					item.ramka.visible=true;
				}
			}
		}
		
		// [Set visual display of key]
		private function setVisKey(n, vis):void {
			vis.txt.text = "";
			vis.gotoAndStop(1);
			
			if (n == null) {
				return;
			}
			
			try {
				vis.txt.text = GameContainer.reference.ctr.keyNames[n];
			} 
			catch(err) {
				trace("ERROR: (00:3C)");
				vis.gotoAndStop(n);
			}
		}
		
		//показать окно назначения клавиши
		private function showSetKey():void {
			pip.vissetkey.visible=true;
			pip.vissetkey.txt.htmlText=TextParser.txt("g", "setkeyinfo")+"\n\n<b>"+TextParser.txt("k",setkeyAction)+"</b>\n"+setkeyCell;
			GameContainer.reference.ctr.requestKey(unshowSetKey);
		}
		
		private function unshowSetKey():void {
			var newkey = GameContainer.reference.ctr.setkeyRequest;
			pip.vissetkey.visible=false;
			
			if (newkey!=-1) {
				for (var i in arr) {
					if (newkey!=null) {
						if (arr[i].a1 == newkey) {
							arr[i].a1 = null;
						}
						
						if (arr[i].a2 == newkey) {
							arr[i].a2 = null;
						}
					}
					
					if (arr[i].id == setkeyAction) {
						if (setkeyCell == 1) {
							arr[i].a1 = newkey;
						}
						
						if (setkeyCell == 2) {
							arr[i].a2 = newkey;
						}
					}
				}
				
				setStatItems();
				vis.butOk.visible=true;
			}
		}
		
		override public function setStatus(flop:Boolean=true):void {
			if (pip.light) {
				vis.but5.visible = false;
				vis.but1.visible = false;
				vis.but2.visible = false;

				if (page2 == PAGE_LOAD || page2 == PAGE_SAVE) {
					page2 = PAGE_OPTIONS;
				}
			}
			else {
				vis.but5.visible = true;
				vis.but1.visible = true;
				vis.but2.visible = true;
			}
			
			super.setStatus(flop);
		}

		override public function updateLang():void {
			vis.butOk.text.text=LanguageManager.reference.localText("pip", "accept");
			vis.butDef.text.text=LanguageManager.reference.localText("pip", "default");
			super.updateLang();
		}
		
		// The volume sliders in sound settings
		public function optScroll(event:ScrollEvent):void {
			event.currentTarget.parent.numb.text = Math.round(event.position);
			var id:String = event.currentTarget.parent.id.text;
			var volume:Number = Math.round((event.position / 100) * 100) / 100; // Rounds to two decimal places
			
			if (id == "opt1_1") {
				Sound.globalVol = volume;
				Sound.setGameMuted(Sound.globalVol <= 0);
				Sound.ps("mine_bip", 1000, 0);
			}
			
			if (id == "opt1_2") {
				Sound.musicVol = volume;
				Sound.updateMusicVol();
			}
			
			if (id == "opt1_3") {
				Sound.stepVol = volume;
			}
			
			pip.isSaveConf = true;
		}

		public function optCheck(event:Event):void {
			var id:String = event.currentTarget.parent.id.text;
			var sel:Boolean = (event.target as CheckBox).selected;
			
			if (id == "dial_on") {
				GameContainer.reference.dialOn=sel;
			}
			
			if (id == "mat_filter") {
				GameContainer.reference.matFilter=sel;
			}
			
			if (id == "help_mess") {
				GameContainer.reference.helpMess=sel;
			}
			
			var hit1:Boolean = GameContainer.reference.showHit > 0;
			var hit2:Boolean = GameContainer.reference.showHit == 2;
			
			if (id == "show_hit1") {
				hit1 = sel;
			}
			
			if (id == "show_hit2") {
				hit2 = sel;
			}
			
			GameContainer.reference.showHit = hit1 ? (hit2 ? 2 : 1) : 0;
			
			if (id == "sys_cur") {
				GameContainer.reference.sysCur = sel;
			}
			
			if (id == "hint_tele") {
				GameContainer.reference.hintTele = sel;
			}
			
			if (id == "show_favs") {
				GameContainer.reference.showFavs = sel;
			}
			
			if (id == "quake") {
				GameContainer.reference.quakeCam=sel;
			}
			
			if (id == "err_show") {
				GameContainer.reference.errorShowOpt = sel;
			}
			
			if (id == "zoom100") {
				GameContainer.reference.zoom100 = sel;
				
				if (pip.light) {
					if (sel) {
						GameContainer.reference.cam.isZoom = 0;
					}
					else {
						GameContainer.reference.cam.isZoom = 2;
					}
				}
				else {
					if (sel) {
						GameContainer.reference.cam.setZoom(0);
					}
					else {
						GameContainer.reference.cam.setZoom(2);
					}
				}
			}
		
			if (page2 == PAGE_AUTOPICKUP_OPT) {
				AutoPickupManager.reference[id] = sel;
				AutoPickupManager.reference.checkLoot = true;
			}
			
			pip.isSaveConf = true;
		}

		override protected function itemClick(event:MouseEvent):void {
			if (GameContainer.reference.ctr.setkeyOn) {
				return;
			}
			
			if (page2 == PAGE_OPTIONS) {
				if (event.currentTarget.id.text=="fullscreen") {
					Engine.reference.stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
				}
				
				if (event.currentTarget.id.text=="autotake") {
					page2 = PAGE_AUTOPICKUP_OPT;
					setStatus();
				}
			}
			else if (page2 == PAGE_CONTROLS) {
				if (event.target.parent.name=="key1" || event.target.name=="key1") {
					setkeyCell=1;
				}
				else if (event.target.parent.name=="key2" || event.target.name=="key2") {
					setkeyCell=2;
				}
				else {
					return;
				}
				
				if (setkeyCell==1 && event.currentTarget.key1.txt.text=="TAB") {
					return;
				}
				
				setkeyAction=event.currentTarget.id.text;
				showSetKey();
			}
			else if (page2 == PAGE_LOAD || page2 == PAGE_SAVE) {
				if (pip.noAct && page2 == PAGE_SAVE) {
					GUIManager.reference.gui.infoText("noAct");
					return;
				}

				if (page2 == PAGE_SAVE && gg.pers.hardcore) {
					return;
				}
			
				var numb:int = event.currentTarget.id.text;
			
				if (page2 == PAGE_LOAD && event.currentTarget.numb.text == "") {
					return;
				}
			
				nSave = numb;
				setStatItems();
				showSaveInfo(arr[numb], vis);
				vis.butOk.visible = true;
			}
		}
		
		// [Apply settings]
		private function transOk(event:MouseEvent):void {
			if (page2 == PAGE_CONTROLS) {
				for (var i in arr) {
					var obj = GameContainer.reference.ctr.keyIds[arr[i].id];
					obj.a1 = arr[i].a1;
					obj.a2 = arr[i].a2;
				}
				
				vis.butOk.visible = false;
				GameContainer.reference.ctr.updateKeys();
				GameContainer.reference.saveConfig();
			}
			else if (page2 == PAGE_LOAD) {
				World.w.comLoad=nSave;
			}
			else if (page2 == PAGE_SAVE) {
				if (pip.noAct) {
					GUIManager.reference.gui.infoText("noAct");
					return;
				}
					try {
						SaveManager.reference.saveGame(nSave);
						GUIManager.reference.gui.infoText("SaveGame");
						nSave=-1;
						vis.butOk.visible=false;
						setStatus();
					}
					catch (err) {
						trace("ERROR: (00:3D)");
						GUIManager.reference.gui.infoText("noSaveGame");
					}
			}
		}
		
		private function selectHandler(event:Event):void {
            file.load();
        }

		private function completeHandler(event:Event):void {
			try {
				var obj:Object=file.data.readObject();
				if (obj && obj.est == 1) {
					World.w.comLoad = 99;
					SaveManager.reference.loaddata = obj;
					return;
				}
			}
			catch(err) {
				trace("ERROR: (00:3E)");
			}

			GUIManager.reference.gui.infoText("noLoadGame");
			trace("Error load");
       }		
		
		private function gotoDef(event:MouseEvent):void {
			var localize:Function = LanguageManager.reference.localText;
			
			if (page2 == PAGE_CONTROLS) {
				GameContainer.reference.ctr.gotoDef();
				GameContainer.reference.ctr.updateKeys();
				GameContainer.reference.saveConfig();
				setStatus();
			}
			else if (page2 == PAGE_LOAD) {
				ffil = [new FileFilter(localize("pip", "gamesaves")+" (*.sav)", "*.sav")];
				file.browse(ffil);
			}
			else if (page2 == PAGE_SAVE) {
				if (pip.noAct) {
					GUIManager.reference.gui.infoText("noAct");
					return;
				}
				
				// [Save to file]
				var obj:Object = new Object();
				SaveManager.reference.saveToObj(obj);
				var ba:ByteArray = new ByteArray();
				ba.writeObject(obj);
				var sfile:FileReference = new FileReference();
				
				try {
					sfile.save(ba,gg.pers.persName+"("+gg.pers.level+").sav");
				}
				catch(err) {
					trace("ERROR: (00:3F)");
					sfile.save(ba, "Name(" + gg.pers.level + ").sav");
				}
			}
		}
		
		public static function showSaveInfo(obj:Object, vis:MovieClip):void {
			var localize:Function = LanguageManager.reference.localText;
			vis.info.htmlText = "";
		
			if (obj && obj.gg != "") {
				vis.nazv.text=obj.gg;
				GUIManager.reference.app.load(obj.app);
				GUIManager.reference.pip.setArmor(obj.armor);
				vis.pers.gotoAndStop(2);
				vis.pers.gotoAndStop(1);
				vis.pers.head.morda.magic.visible=false;
				vis.pers.visible=true;
				vis.info.y=vis.pers.y+25;
				vis.info.htmlText+=localize("pip", "level")+": "+textAsColor("yellow", obj.level)+"\n";
				vis.info.htmlText+=obj.land+"\n";
				vis.info.htmlText+="\n";
				vis.info.htmlText+=localize("pip", "diff")+": "+textAsColor("yellow", obj.dif)+"\n";
				
				if (obj.hard == 1) {
					vis.info.htmlText+=TextParser.txt("g", "opt2")+"\n";
				}
				
				if (obj.hard == 2) {
					vis.info.htmlText+=textAsColor("red", localize("pip", "dead"))+"\n";
				}
				
				if (obj.hardInv == 1) {
					vis.info.htmlText += TextParser.txt("g", "opt6")+"\n";
				}
				
				if (obj.rndpump == 1) {
					vis.info.htmlText += TextParser.txt("g", "opt4")+"\n";
				}
				
				if (obj.ver) {
					vis.info.htmlText += TextParser.txt("g", "version") + ": " + textAsColor("yellow", obj.ver)+"\n";
				}
				
				vis.info.htmlText += localize("pip", "tgame") + ": " + textAsColor("yellow", obj.time) + "\n";
				vis.info.htmlText += localize("pip", "saved") + ": " + textAsColor("yellow", obj.date) + "\n";
			} 
			else {
				vis.nazv.text = "";
				vis.pers.visible = false;
			}
		}
		
		// [item information]
		override protected function statInfo(event:MouseEvent):void {
			if (page2 == PAGE_OPTIONS || page2 == PAGE_AUTOPICKUP_OPT) {
				vis.info.htmlText = TextParser.txt("p", event.currentTarget.id.text, 1);
			}
			else if (page2 == PAGE_LOAD || page2 == PAGE_SAVE) {
				if (nSave < 0) {
					showSaveInfo(arr[event.currentTarget.id.text], vis);
				}
			}
			else {
				vis.info.text = "";
			}
		}
	}
}

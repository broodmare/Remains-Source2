package fe {
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageScaleMode;
	import flash.display.StageDisplayState;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import fe.inter.PipBuck;
	import fe.inter.Appear;
	import fe.graph.Displ;
	import flash.display.SimpleButton;
	import flash.text.TextFormat;
	import flash.text.StyleSheet;
	import flash.net.FileReference;
	import flash.net.FileFilter;
	//import flash.net.URLLoader; 
	//import flash.net.URLRequest; 
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import fe.inter.PipPageOpt;
	
	public class MainMenu {

		var version:String='1.0.2';
		var mm:MovieClip;
		public var main:Sprite;
		var world:World;
		public var active:Boolean=true;
		public var loaded:Boolean=false;
		var newGameMode:int=2;
		var newGameDif:int=2;
		var loadCell:int=-1;
		var loadReg:int=0;	//режим окна загрузки, 0 - загрузка, 1 - выбор слота для автосейва
		var command:int=0;
		var com:String='';
		var mmp:MovieClip;//для пипбака
		var pip:PipBuck;
		var displ:Displ;
		var animOn:Boolean=true;
		var langReload:Boolean=false;
		
		var kolDifs:int=5;
		var kolOpts:int=6;
		
		var butsLang:Array;
		
		var stn:int=0;
		
		public var style:StyleSheet = new StyleSheet(); 
		var styleObj:Object = new Object(); 
		
		var format:TextFormat = new TextFormat();
		
		var file:FileReference = new FileReference();
		var ffil:Array;
		var arr:Array=new Array();
		
		var mainTimer:Timer;
			
		public function MainMenu(nmain:Sprite) {
			main=nmain;
			mm=new visMainMenu();
			mm.dialLoad.visible=false;
			mm.dialNew.visible=false;
			mm.dialAbout.visible=false;
			main.stage.addEventListener(Event.RESIZE, resizeDisplay); 
			main.stage.addEventListener(Event.ENTER_FRAME, mainStep);
			
			//mainTimer = new Timer(30);
			//mainTimer.addEventListener(TimerEvent.TIMER, mainStep);
			//mainTimer.start();
			
			showButtons(false);
			mainMenuOn();
			
			var paramObj:Object = LoaderInfo(main.root.loaderInfo).parameters;
			world=new World(main, paramObj);
			world.mm=this;
			
			mm.testtest.visible=world.testMode;
			mm.info.visible=false;
			//mm.testtest.htmlText='555 <a href="https://tabun.everypony.ru/">gre</a> 777';
			Snd.initSnd();
			setMenuSize();
			displ=new Displ(mm.pipka, mm.groza);
			mm.groza.visible=false;
			format.font = "_sans";
            format.color = 0xFFFFFF;
            format.size = 28;
			
			styleObj.fontWeight = "bold"; 
			styleObj.color = "#FFFF00"; 
			style.setStyle(".yel", styleObj); 	//выделение важного
			
			styleObj.fontWeight = "normal"; 
			styleObj.color = "#00FF99";
			styleObj.fontSize= "12";
			style.setStyle(".music", styleObj); 	//мелкий шрифт
			
			styleObj.fontWeight = "normal"; 
			styleObj.color = "#66FF66";
			styleObj.fontSize=undefined;
			style.setStyle("a", styleObj); 	//ссыль
			styleObj.textDecoration= "underline";
			style.setStyle("a:hover", styleObj);
			
			//mm.testtest.styleSheet=style;
			mm.info.txt.styleSheet=style;
			mm.link.l1.styleSheet=style;
			mm.link.l2.styleSheet=style;
			//mm.link.l1.htmlText="<a href='http://foe.ucoz.org/main.html'>foe.ucoz.org</a>";
			//mm.link.l1.useHandCursor=true;
		}

		public function mainMenuOn() {
			active=true;
			//mm.butRus.addEventListener(MouseEvent.CLICK, funRus);
			//mm.butEng.addEventListener(MouseEvent.CLICK, funEng);
			mm.butNewGame.addEventListener(MouseEvent.MOUSE_OVER, funOver);
			mm.butNewGame.addEventListener(MouseEvent.MOUSE_OUT, funOut);
			mm.butLoadGame.addEventListener(MouseEvent.MOUSE_OVER, funOver);
			mm.butLoadGame.addEventListener(MouseEvent.MOUSE_OUT, funOut);
			mm.butContGame.addEventListener(MouseEvent.MOUSE_OVER, funOver);
			mm.butContGame.addEventListener(MouseEvent.MOUSE_OUT, funOut);
			mm.butOpt.addEventListener(MouseEvent.MOUSE_OVER, funOver);
			mm.butOpt.addEventListener(MouseEvent.MOUSE_OUT, funOut);
			mm.butAbout.addEventListener(MouseEvent.MOUSE_OVER, funOver);
			mm.butAbout.addEventListener(MouseEvent.MOUSE_OUT, funOut);
			mm.butOpt.addEventListener(MouseEvent.CLICK, funOpt);
			mm.butNewGame.addEventListener(MouseEvent.CLICK, funNewGame);
			mm.butLoadGame.addEventListener(MouseEvent.CLICK, funLoadGame);
			mm.butContGame.addEventListener(MouseEvent.CLICK, funContGame);
			mm.butAbout.addEventListener(MouseEvent.CLICK, funAbout);
			mm.adv.addEventListener(MouseEvent.CLICK, funAdv);
			mm.adv.addEventListener(MouseEvent.RIGHT_CLICK, funAdvR);
			if (!main.contains(mm)) main.addChild(mm);
			file.addEventListener(Event.SELECT, selectHandler);
			file.addEventListener(Event.COMPLETE, completeHandler);
		}
		public function mainMenuOff() {
			active=false;
			//mm.butRus.removeEventListener(MouseEvent.CLICK, funRus);
			//mm.butEng.removeEventListener(MouseEvent.CLICK, funEng);
			mm.butNewGame.removeEventListener(MouseEvent.MOUSE_OVER, funOver);
			mm.butNewGame.removeEventListener(MouseEvent.MOUSE_OUT, funOut);
			mm.butLoadGame.removeEventListener(MouseEvent.MOUSE_OVER, funOver);
			mm.butLoadGame.removeEventListener(MouseEvent.MOUSE_OUT, funOut);
			mm.butContGame.removeEventListener(MouseEvent.MOUSE_OVER, funOver);
			mm.butContGame.removeEventListener(MouseEvent.MOUSE_OUT, funOut);
			mm.butOpt.removeEventListener(MouseEvent.MOUSE_OVER, funOver);
			mm.butOpt.removeEventListener(MouseEvent.MOUSE_OUT, funOut);
			mm.butAbout.removeEventListener(MouseEvent.MOUSE_OVER, funOver);
			mm.butAbout.removeEventListener(MouseEvent.MOUSE_OUT, funOut);
			mm.butOpt.removeEventListener(MouseEvent.CLICK, funOpt);
			mm.butNewGame.removeEventListener(MouseEvent.CLICK, funNewGame);
			mm.butLoadGame.removeEventListener(MouseEvent.CLICK, funLoadGame);
			mm.butContGame.removeEventListener(MouseEvent.CLICK, funContGame);
			mm.butAbout.removeEventListener(MouseEvent.CLICK, funAbout);
			mm.adv.removeEventListener(MouseEvent.CLICK, funAdv);
			mm.adv.removeEventListener(MouseEvent.RIGHT_CLICK, funAdvR);
			file.removeEventListener(Event.SELECT, selectHandler);
			file.removeEventListener(Event.COMPLETE, completeHandler);
			for each(var m in butsLang) {
				if (m) m.removeEventListener(MouseEvent.CLICK, funLang);
			}
			if (main.contains(mm)) main.removeChild(mm);
			world.vwait.visible=true;
			world.vwait.progres.text=Res.guiText('loading');
		}
		public function funNewGame(event:MouseEvent) {
			world.mmArmor=false;
			mainLoadOff();
			mainNewOn();
		}
		public function funLoadGame(event:MouseEvent) {
			world.mmArmor=true;
			mainNewOff();
			loadReg=0;
			mainLoadOn();
		}
		//продолжить игру
		public function funContGame(event:MouseEvent) {
			var n:int=0;
			var maxDate:Number=0;
			for (var i=0; i<=world.saveKol; i++) {
				var save:Object=World.w.getSave(i);
				if (save && save.est && save.date>maxDate) {
					n=i;
					maxDate=save.date;
				}
			}
			save=World.w.getSave(n);
			if (save && save.est) {
				mainMenuOff();
				loadCell=n;
				command=3;
			} else {
				mainNewOn();
				mainLoadOff();
			}
		}
		public function funOver(event:MouseEvent) {
			(event.currentTarget as MovieClip).fon.scaleX=1;
			(event.currentTarget as MovieClip).fon.alpha=1.5;
		}
		public function funOut(event:MouseEvent) {
			(event.currentTarget as MovieClip).fon.scaleX=0.7;
			(event.currentTarget as MovieClip).fon.alpha=1;
		}
		
		public function setLangButtons() {
			butsLang=new Array();
			if (world.kolLangs>1) {
				var i=world.kolLangs;
				for each(var l in world.langsXML.lang) {
					i--;
					var m:MovieClip=new butLang();
					butsLang[i]=m;
					m.lang.text=l[0];
					m.y=-i*40;
					m.n.text=l.@id;
					m.n.visible=false;
					m.addEventListener(MouseEvent.CLICK, funLang);
					mm.lang.addChild(m);
				}
			}
			//mm.butRus.lang.text= 'ѠҨҼ✶☆☢☣';
			
		}
		
		//надписи
		public function setMainLang() {
			//mm.butContGame.txt.defaultTextFormat=format;
			setMainButton(mm.butContGame,Res.guiText('contgame'));
			setMainButton(mm.butNewGame,Res.guiText('newgame'));
			setMainButton(mm.butLoadGame,Res.guiText('loadgame'));
			setMainButton(mm.butOpt,Res.guiText('options'));
			setMainButton(mm.butAbout,Res.guiText('about'));
			mm.dialNew.title.text=Res.guiText('newgame');
			mm.dialLoad.title.text=Res.guiText('loadgame');
			mm.dialLoad.title2.text=Res.guiText('select_slot');
			mm.version.htmlText='<b>'+Res.guiText('version')+' '+version+'</b>';
			mm.dialLoad.butCancel.text.text=mm.dialNew.butCancel.text.text=Res.guiText('cancel');
			mm.dialLoad.butFile.text.text=Res.pipText('loadfile');
			mm.dialLoad.warn.text=mm.dialNew.warn.text=Res.guiText('loadwarn');
			mm.dialNew.infoName.text=Res.guiText('inputname');
			mm.dialNew.hardOpt.text=Res.guiText('hardopt');
			mm.dialNew.butOk.text.text='OK';
			mm.dialNew.inputName.text=Res.txt('u','littlepip');
			mm.dialNew.maxChars=32;
			for (var i=0; i<kolDifs; i++) {
				mm.dialNew['dif'+i].mode.text=Res.guiText('dif'+i);
				mm.dialNew['dif'+i].modeinfo.text=Res.formatText(Res.txt('g','dif'+i,1));
			}
			for (var i=1; i<=kolOpts; i++) {
				mm.dialNew['infoOpt'+i].text=Res.guiText('opt'+i);
			}
			mm.dialNew.butVid.mode.text=Res.guiText('butvid');
			if (world.app) world.app.setLang();
			mm.adv.text=Res.advText(world.nadv);
			mm.adv.y=main.stage.stageHeight-mm.adv.textHeight-40;
			//mm.butRus.visible=(Res.lang==1);
			//mm.butEng.visible=(Res.lang==0);
			mm.info.txt.htmlText=Res.txt('g','inform')+'<br>'+Res.txt('g','inform',1);
			mm.info.visible=(mm.info.txt.text.length>0);
			setScrollInfo();
		}
		
		function setMainButton(but:MovieClip, txt:String) {
			but.txt.text=txt;
			but.glow.text=txt;
			but.txt.visible=(but.glow.textWidth<1)
		}
		
		public function setMenuSize() {
			mm.adv.y=main.stage.stageHeight-mm.adv.textHeight-40;
			mm.version.y=main.stage.stageHeight-58;
			mm.link.y=main.stage.stageHeight-125;
			var ny=main.stage.stageHeight-400;
			if (ny<280) ny=280;
			mm.dialLoad.x=mm.dialNew.x=world.app.vis.x=main.stage.stageWidth/2;
			mm.dialLoad.y=mm.dialNew.y=world.app.vis.y=ny;
			mm.lang.x=main.stage.stageWidth-30;
			mm.lang.y=main.stage.stageHeight-50;
			mm.info.txt.height=mm.info.scroll.height=mm.link.y-mm.info.y-20;
			setScrollInfo();
		}
		
		function setScrollInfo() {
			if (mm.info.txt.height<mm.info.txt.textHeight) {
				mm.info.scroll.maxScrollPosition=mm.info.txt.maxScrollV;
				mm.info.scroll.visible=true;
			} else mm.info.scroll.visible=false;
		}
		
		public function resizeDisplay(event:Event) {
			world.resizeScreen();
			if (active) setMenuSize();
		}

		//загрузка игры
		public function mainLoadOn() {
			mm.dialLoad.visible=true;
			mm.dialLoad.title2.visible=(loadReg==1);
			mm.dialLoad.title.visible=(loadReg==0);
			mm.dialLoad.slot0.visible=(loadReg==0);
			mm.dialLoad.info.text='';
			mm.dialLoad.nazv.text='';
			mm.dialLoad.pers.visible=false;
			arr=new Array();
			for (var i=0; i<=world.saveKol; i++) {
				var slot:MovieClip=mm.dialLoad['slot'+i];
				var save:Object=World.w.getSave(i);
				var obj:Object=fe.inter.PipPageOpt.saveObj(save,i);
				arr.push(obj);
				slot.id.text=i;
				slot.id.visible=false;
				if (save!=null && save.est!=null) {
					slot.nazv.text=(i==0)?Res.pipText('autoslot'):(Res.pipText('saveslot')+' '+i);
					slot.ggName.text=(save.pers.persName==null)?'-------':save.pers.persName;
					if (save.pers.level!=null) slot.ggName.text+=' ('+save.pers.level+')';
					if (save.pers.dead) slot.nazv.text+=' [†]';
					else if (save.pers.hardcore) slot.nazv.text+=' {!}';
					slot.date.text=(save.date==null)?'-------':Res.getDate(save.date);
					slot.land.text=(save.date==null)?'':Res.txt('m',save.game.land).substr(0,18);
				} else {
					slot.nazv.text=Res.pipText('freeslot');
					slot.ggName.text=slot.land.text=slot.date.text='';
				}
				slot.addEventListener(MouseEvent.CLICK, funLoadSlot);
				slot.addEventListener(MouseEvent.MOUSE_OVER, funOverSlot);
			}
			mm.dialLoad.butCancel.addEventListener(MouseEvent.CLICK, funLoadCancel);
			mm.dialLoad.butFile.addEventListener(MouseEvent.CLICK, funLoadFile);
			animOn=false;
		}
		
		public function mainLoadOff() {
			mm.dialLoad.visible=false;
			if (mm.dialLoad.butCancel.hasEventListener(MouseEvent.CLICK)) {
				mm.dialLoad.butCancel.removeEventListener(MouseEvent.CLICK, funLoadCancel);
				mm.dialLoad.butFile.removeEventListener(MouseEvent.CLICK, funLoadFile);
			}
			for (var i=0; i<=world.saveKol; i++) {
				var slot:MovieClip=mm.dialLoad['slot'+i];
				if (slot.hasEventListener(MouseEvent.CLICK)) {
					slot.removeEventListener(MouseEvent.CLICK, funLoadSlot);
					slot.removeEventListener(MouseEvent.MOUSE_OVER, funOverSlot);
				}
			}
			animOn=true;
		}
		
		public function funLoadCancel(event:MouseEvent) {
			mainLoadOff();
		}
		//выбрать слот
		public function funLoadSlot(event:MouseEvent) {
			loadCell=event.currentTarget.id.text;
			if (loadReg==1 && loadCell==0) return;
			if (loadReg==0 && event.currentTarget.ggName.text=='') return;
			mainLoadOff();
			mainMenuOff();
			command=3;
			if (loadReg==1) com='new';
			else com='load';
		}
		public function funOverSlot(event:MouseEvent) {
			fe.inter.PipPageOpt.showSaveInfo(arr[event.currentTarget.id.text],mm.dialLoad);
		}
		
		public function funLoadFile(event:MouseEvent) {
			ffil=[new FileFilter(Res.pipText('gamesaves')+" (*.sav)", "*.sav")];
			file.browse(ffil);
		}
		
		private function selectHandler(event:Event):void {
            file.load();
        }		
		private function completeHandler(event:Event):void {
			try {
				var obj:Object=file.data.readObject();
				if (obj && obj.est==1) {
					loadCell=99;
					world.loaddata=obj;
					mainLoadOff();
					mainMenuOff();
					command=3;
					com='load';
					return;
				}
			} catch(err) {}
			trace('Error load');
       }		
		
		//новая игры
		public function mainNewOn() {
			mm.dialNew.visible=true;
			mm.dialNew.butCancel.addEventListener(MouseEvent.CLICK, funNewCancel);
			mm.dialNew.butOk.addEventListener(MouseEvent.CLICK, funNewOk);
			mm.dialNew.butVid.addEventListener(MouseEvent.CLICK, funNewVid);
			for (var i=0; i<kolDifs; i++) {
				mm.dialNew['dif'+i].addEventListener(MouseEvent.CLICK, funNewDif);
				mm.dialNew['dif'+i].addEventListener(MouseEvent.MOUSE_OVER, infoMode);
			}
			for (var i=1; i<=kolOpts; i++) {
				mm.dialNew['infoOpt'+i].addEventListener(MouseEvent.MOUSE_OVER, infoOpt);
				mm.dialNew['checkOpt'+i].addEventListener(MouseEvent.MOUSE_OVER, infoOpt);
			}
			updNewMode();
			mm.dialNew.pers.gotoAndStop(2);
			mm.dialNew.pers.gotoAndStop(1);
			animOn=false;
		}
		public function mainNewOff() {
			mm.dialNew.visible=false;
			if (mm.dialNew.butCancel.hasEventListener(MouseEvent.CLICK)) mm.dialNew.butCancel.removeEventListener(MouseEvent.CLICK, funNewCancel);
			if (mm.dialNew.butOk.hasEventListener(MouseEvent.CLICK)) mm.dialNew.butOk.removeEventListener(MouseEvent.CLICK, funNewOk);
			if (mm.dialNew.butOk.hasEventListener(MouseEvent.CLICK)) {
				mm.dialNew.butVid.removeEventListener(MouseEvent.CLICK, funNewVid);
				for (var i=0; i<kolDifs; i++) {
					mm.dialNew['dif'+i].removeEventListener(MouseEvent.CLICK, funNewDif);
					mm.dialNew['dif'+i].removeEventListener(MouseEvent.MOUSE_OVER, infoMode);
				}
			}
			animOn=true;
		}
		public function funAdv(event:MouseEvent) {
			world.nadv++;
			if (world.nadv>=world.koladv) world.nadv=0;
			mm.adv.text=Res.advText(world.nadv);
			mm.adv.y=main.stage.stageHeight-mm.adv.textHeight-40;
		}
		public function funAdvR(event:MouseEvent) {
			world.nadv--;
			if (world.nadv<0) world.nadv=world.koladv-1;
			mm.adv.text=Res.advText(world.nadv);
			mm.adv.y=main.stage.stageHeight-mm.adv.textHeight-40;
		}
		public function funNewCancel(event:MouseEvent) {
			mainNewOff();
		}
		//нажать ОК в окне новой игры
		public function funNewOk(event:MouseEvent) {
			mainNewOff();
			if (mm.dialNew.checkOpt2.selected) {	//показать окно выбора слота
				loadReg=1;
				mainLoadOn();
			} else {
				mainMenuOff();
				loadCell=-1;
				command=3;
				com='new';
			}
		}
		//включить настройки внешности
		public function funNewVid(event:MouseEvent) {
			setMenuSize();
			mm.dialNew.visible=false;
			world.app.attach(mm,funVidOk,funVidOk);
		}
		//принять настройки внешности
		public function funVidOk() {
			mm.dialNew.visible=true;
			world.app.detach();
			mm.dialNew.pers.gotoAndStop(2);
			mm.dialNew.pers.gotoAndStop(1);
		}
		public function funNewDif(event:MouseEvent) {
			if (event.currentTarget==mm.dialNew.dif0) newGameDif=0;
			if (event.currentTarget==mm.dialNew.dif1) newGameDif=1;
			if (event.currentTarget==mm.dialNew.dif2) newGameDif=2;
			if (event.currentTarget==mm.dialNew.dif3) newGameDif=3;
			if (event.currentTarget==mm.dialNew.dif4) newGameDif=4;
			updNewMode();
		}
		function updNewMode() {
			mm.dialNew.dif0.fon.gotoAndStop(1);
			mm.dialNew.dif1.fon.gotoAndStop(1);
			mm.dialNew.dif2.fon.gotoAndStop(1);
			mm.dialNew.dif3.fon.gotoAndStop(1);
			mm.dialNew.dif4.fon.gotoAndStop(1);
			if (newGameDif==0) mm.dialNew.dif0.fon.gotoAndStop(2);
			if (newGameDif==1) mm.dialNew.dif1.fon.gotoAndStop(2);
			if (newGameDif==2) mm.dialNew.dif2.fon.gotoAndStop(2);
			if (newGameDif==3) mm.dialNew.dif3.fon.gotoAndStop(2);
			if (newGameDif==4) mm.dialNew.dif4.fon.gotoAndStop(2);
		}
		function infoMode(event:MouseEvent) {
			mm.dialNew.modeinfo.htmlText=event.currentTarget.modeinfo.text;
		}
		function infoOpt(event:MouseEvent) {
			var n=int(event.currentTarget.name.substr(event.currentTarget.name.length-1));
			mm.dialNew.modeinfo.htmlText=Res.formatText(Res.txt('g','opt'+n,1));
		}
		
		public function funOpt(event:MouseEvent) {
			mainNewOff();
			mainLoadOff();
			world.pip.onoff();
		}
		public function funLang(event:MouseEvent) {
			mm.loading.text='';
			var nid=event.currentTarget.n.text;
			if (nid==world.lang) return;
			world.defuxLang(nid);
			if (nid==world.langDef) {
				setMainLang();
			} else {
				langReload=true;
				showButtons(false);
				mm.loading.text='Loading';
			}
		}
		
		function showButtons(n:Boolean) {
			mm.lang.visible=mm.butNewGame.visible=mm.butLoadGame.visible=mm.butContGame.visible=mm.butOpt.visible=mm.butAbout.visible=n;
		}
		
		//создатели
		public function funAbout(event:MouseEvent) {
			mm.dialAbout.title.text=Res.guiText('about');
			var s:String=Res.formatText(Res.txt('g','about',1));
			s+='<br><br>'+Res.guiText('usedmusic')+'<br>';
			s+="<br><span class='music'>"+Res.formatText(Res.d.gui.(@id=='usedmusic').info[0])+"</span>"
			s+="<br><br><a href='https://creativecommons.org/licenses/by-nc/4.0/legalcode'>Music CC-BY License</a>";
			//s=s.replace(/\[/g,"<span class='imp'>");
			//s=s.replace(/\]/g,"</span>");
			mm.dialAbout.txt.styleSheet=style;
			mm.dialAbout.txt.htmlText=s;
			mm.dialAbout.visible=true;
			mm.dialAbout.butCancel.addEventListener(MouseEvent.CLICK, funAboutOk);
			mm.dialAbout.scroll.maxScrollPosition=mm.dialAbout.txt.maxScrollV;
		}
		public function funAboutOk(event:MouseEvent) {
			mm.dialAbout.visible=false;
			mm.dialAbout.butCancel.removeEventListener(MouseEvent.CLICK, funAboutOk);
		}
		
		function step() {
			if (langReload) {
				if (world.textLoaded) {
					langReload=false;
					showButtons(true);
					if (world.textLoadErr) mm.loading.text='Language loading error';
					else mm.loading.text='';
					world.pip.updateLang();
					setMainLang();
				}
				return;
			}
			if (loaded) {
				if (animOn && !world.pip.active) displ.anim();
				if (world.allLandsLoaded && world.textLoaded) {
					if (world.musicKol>world.musicLoaded) mm.loading.text='Music loading '+world.musicLoaded+'/'+world.musicKol;
					else mm.loading.text='';
				}
				return;
			}
			if (world.grafon.resIsLoad) {
				stn++;
				mm.loading.text='Loading '+(Math.floor(stn/30))+'\n';
				//+Math.round(world.textProgressLoad*100)+'%\n';
				if (world.textLoaded) world.init2();
				if (world.allLandsLoaded && world.textLoaded) {
					setLangButtons();
					setMainLang();
					loaded=true;
					showButtons(true);
					return;
				}
				mm.loading.text+=world.load_log;
			} else {
				mm.loading.text='Loading '+Math.round(world.grafon.progressLoad*100)+'%';
			}
		}
		
		public function log(s:String) {
			mm.loading.text+=s+'; ';
		}

		public function mainStep(event:Event):void {
			if (active) step();
			else if (command>0) {
				command--;
				if (command==1 && !mm.dialNew.checkOpt1.selected && com=='new') {
					world.setLoadScreen(0);
				}
				//начать игру !!!!
				if (command==0) {
					var opt:Object;
					if (com=='new') {
						//propusk - опция 1 - пропуск обучения
						//hardcore - опция 2
						//fastxp - опция 3, опыта нужно на 40% меньше
						//rndpump - опция 4, случайная прокачка
						//hardskills - давать по 3 sp за уровень
						//autoSaveN - ячейка автосейва
						opt={dif:newGameDif,
							propusk:mm.dialNew.checkOpt1.selected,
							hardcore:mm.dialNew.checkOpt2.selected,
							fastxp:mm.dialNew.checkOpt3.selected,
							rndpump:mm.dialNew.checkOpt4.selected,
							hardskills:mm.dialNew.checkOpt5.selected,
							hardinv:mm.dialNew.checkOpt6.selected};
						if (opt.hardcore) opt.autoSaveN=loadCell;
						loadCell=-1;
					}
					world.newGame(loadCell,mm.dialNew.inputName.text,opt);
				}
			} else world.step();
		}
		
				
	}
	
}

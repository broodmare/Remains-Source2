package fe {

	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	import flash.text.StyleSheet;
	import flash.net.FileReference;
	import flash.net.FileFilter;
	import flash.utils.Timer;

	import fe.inter.PipBuck;
	import fe.inter.PipPageOpt;
	import fe.graph.Displ;

	import fe.stubs.visMainMenu;
	import fe.stubs.butLang;

	public class MainMenu {

		public var version:String = '1.1a';
		private var mainMenuMovieClip:MovieClip;
		public var main:Sprite;	// The stage everything is contained in
		private var world:World;
		public var active:Boolean = true;	// The main menu is visible and needs to update
		public var loaded:Boolean = false;
		private var newGameMode:int = 2;
		private var newGameDif:int = 2;
		private var loadCell:int = -1;
		private var loadReg:int = 0;	// [Loading window mode, 0 - loading, 1 - selecting slot for autosave]
		private var command:int = 0;
		private var com:String = '';
		private var mmp:MovieClip; // [For pipbuck]
		private var pip:PipBuck;
		private var displ:Displ;
		private var animOn:Boolean = true;
		private var langReload:Boolean = false;

		// Buttons for each language option
		private var butsLang:Array;
		
		private var stn:int=0;
		
		public var style:StyleSheet = new StyleSheet(); 
		private var styleObj:Object = new Object();
		
		private var format:TextFormat = new TextFormat();
		
		private var file:FileReference = new FileReference();
		private var saveFiles:Array=[];
		
		private var mainTimer:Timer;

		// Loading state flags
		private var part1Loaded:Boolean = false;
		private var part2Loaded:Boolean = false;

		// Constructor
		public function MainMenu(nmain:Sprite) 
		{
			// Load the settings file and store it in memory
			Settings.initializeSettings();

			// Load the game's data files into memory
			XMLData.initializeModules();

			// Load all music and sounds
			Snd.initSnd();

			// Save a reference to the stage container
			main = nmain;

			// Load the main menu moveclip object and hide some of it's children
			mainMenuMovieClip = new visMainMenu();
			mainMenuMovieClip.dialLoad.visible = false;
			mainMenuMovieClip.dialNew.visible = false;
			mainMenuMovieClip.dialAbout.visible = false;
			showButtons(false);

			// Add a listener for what to do when the window resizes
			main.stage.addEventListener(Event.RESIZE, resizeDisplay);
			// Add a listener for what to do every new frame (our main loop)
			main.stage.addEventListener(Event.ENTER_FRAME, mainStep);
			
			// Setup complete, show the main menu
			mainMenuOn();
		}

		private function mainMenu2():void {
			trace('ALL XML LOADED, STARTING LOADING PART 2!');

			var paramObj:Object = LoaderInfo(main.root.loaderInfo).parameters;
			world = new World(main, paramObj);
			world.mainMenuClass = this;
			
			mainMenuMovieClip.testtest.visible=world.testMode;
			mainMenuMovieClip.info.visible=false;
			setMenuSize();
			displ = new Displ(mainMenuMovieClip.pipka, mainMenuMovieClip.groza);
			mainMenuMovieClip.groza.visible=false;
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
			
			mainMenuMovieClip.info.txt.styleSheet=style;
			mainMenuMovieClip.link.l1.styleSheet=style;
			mainMenuMovieClip.link.l2.styleSheet=style;
		}

		private function mainMenuOn():void {
			active = true;
			menuButtonListeners(true);

			mainMenuMovieClip.adv.addEventListener(MouseEvent.CLICK, funAdv);
			mainMenuMovieClip.adv.addEventListener(MouseEvent.RIGHT_CLICK, funAdvR);
			
			if (!main.contains(mainMenuMovieClip)) {
				main.addChild(mainMenuMovieClip);
			}

			file.addEventListener(Event.SELECT, selectHandler);
			file.addEventListener(Event.COMPLETE, completeHandler);
		}

		private function mainMenuOff():void {
			active = false;
			menuButtonListeners(false);

			mainMenuMovieClip.adv.removeEventListener(MouseEvent.CLICK, funAdv);
			mainMenuMovieClip.adv.removeEventListener(MouseEvent.RIGHT_CLICK, funAdvR);

			file.removeEventListener(Event.SELECT, selectHandler);
			file.removeEventListener(Event.COMPLETE, completeHandler);

			for each(var m:MovieClip in butsLang)  {
				if (m) m.removeEventListener(MouseEvent.CLICK, funLang);
			}
			
			if (main.contains(mainMenuMovieClip)) {
				main.removeChild(mainMenuMovieClip);
			}
			
			world.vwait.visible = true;
			world.vwait.progres.text = Res.guiText('loading');
		}

		private function menuButtonListeners(setState:Boolean):void {
			var mainFivebuttons:Array = [mainMenuMovieClip.butContGame, mainMenuMovieClip.butLoadGame, mainMenuMovieClip.butNewGame, mainMenuMovieClip.butOpt, mainMenuMovieClip.butAbout];	
			var handleListeners:Function;

			for each (var mainFiveButton:Object in mainFivebuttons) {
				handleListeners = setState ? mainFiveButton.addEventListener : mainFiveButton.removeEventListener;
				handleListeners(MouseEvent.MOUSE_OVER, funOver);
				handleListeners(MouseEvent.MOUSE_OUT, funOut);
				handleListeners(MouseEvent.CLICK, funButtonPress);
			}

			function funButtonPress(event:MouseEvent):void {
				trace('MainMenu.as/funButtonPress() - "' + event.currentTarget.name + '" pressed.');
				switch(event.currentTarget.name)
				{
					case "butContGame":
						funContGame();
					break;

					case "butLoadGame":
						funLoadGame();
					break;

					case "butNewGame":
						funNewGame();
					break;

					case "butOpt":
						funOpt();
					break;

					case "butAbout":
						funAbout();
					break;
				}
			}
		}

		private function funNewGame():void {
			world.mmArmor = false;
			mainLoadOff();
			mainNewOn();
		}

		private function funLoadGame():void {
			world.mmArmor = true;
			mainNewOff();
			loadReg = 0;
			mainLoadOn();
		}

		//продолжить игру
		private function funContGame():void {
			var n:int=0;
			var maxDate:Number=0;
			for (var i:int = 0; i<=world.saveKol; i++)  {
				var save:Object=World.w.getSave(i);
				if (save && save.est && save.date>maxDate) {
					n = i;
					maxDate = save.date;
				}
			}

			save = World.w.getSave(n);

			if (save && save.est) {
				mainMenuOff();
				loadCell=n;
				command=3;
			} 
			else {
				mainNewOn();
				mainLoadOff();
			}
		}

		private function funOver(event:MouseEvent):void {
			(event.currentTarget as MovieClip).fon.scaleX=1;
			(event.currentTarget as MovieClip).fon.alpha=1.5;
		}

		private function funOut(event:MouseEvent):void {
			(event.currentTarget as MovieClip).fon.scaleX=0.7;
			(event.currentTarget as MovieClip).fon.alpha=1;
		}
		
		private function setLangButtons():void {
			butsLang = [];
			var languageManager:LanguageManager = world.languageManager; // Access the LanguageManager instance

			if (languageManager.languages.length > 1) {
				// Loop through the languages array
				for (var i:int = 0; i < languageManager.languages.length; i++) {
					var lang:Object = languageManager.languages[i];
					var m:MovieClip = new butLang(); // .SWF Dependency
					butsLang[i] = m;
					m.lang.text = lang.name; // Use the language name from JSON
					m.y = -i * 40;
					m.n.text = lang.id; // Use the language ID
					m.n.visible = false;
					m.addEventListener(MouseEvent.CLICK, funLang);
					mainMenuMovieClip.lang.addChild(m);
				}
			}
		}
		
		//надписи
		private function setMainLang():void {
			setMainButton(mainMenuMovieClip.butContGame,Res.guiText('contgame'));
			setMainButton(mainMenuMovieClip.butNewGame,Res.guiText('newgame'));
			setMainButton(mainMenuMovieClip.butLoadGame,Res.guiText('loadgame'));
			setMainButton(mainMenuMovieClip.butOpt,Res.guiText('options'));
			setMainButton(mainMenuMovieClip.butAbout,Res.guiText('about'));
			mainMenuMovieClip.dialNew.title.text=Res.guiText('newgame');
			mainMenuMovieClip.dialLoad.title.text=Res.guiText('loadgame');
			mainMenuMovieClip.dialLoad.title2.text=Res.guiText('select_slot');
			mainMenuMovieClip.version.htmlText='<b>'+Res.guiText('version')+' '+version+'</b>';
			mainMenuMovieClip.dialLoad.butCancel.text.text=mainMenuMovieClip.dialNew.butCancel.text.text=Res.guiText('cancel');
			mainMenuMovieClip.dialLoad.butFile.text.text=Res.pipText('loadfile');
			mainMenuMovieClip.dialLoad.warn.text=mainMenuMovieClip.dialNew.warn.text=Res.guiText('loadwarn');
			mainMenuMovieClip.dialNew.infoName.text=Res.guiText('inputname');
			mainMenuMovieClip.dialNew.hardOpt.text=Res.guiText('hardopt');
			mainMenuMovieClip.dialNew.butOk.text.text='OK';
			mainMenuMovieClip.dialNew.inputName.text=Res.txt('u','littlepip');
			mainMenuMovieClip.dialNew.maxChars=32;
			var kolDifs:int = 5;
			for (var i:int = 0; i<kolDifs; i++) {
				mainMenuMovieClip.dialNew['dif'+i].mode.text=Res.guiText('dif'+i);
				mainMenuMovieClip.dialNew['dif'+i].modeinfo.text=Res.formatText(Res.txt('g','dif'+i,1));
			}
			var kolOpts:int = 6;
			for (i = 1; i<=kolOpts; i++) {
				mainMenuMovieClip.dialNew['infoOpt'+i].text=Res.guiText('opt'+i);
			}
			mainMenuMovieClip.dialNew.butVid.mode.text=Res.guiText('butvid');
			if (world.app) world.app.setLang();
			mainMenuMovieClip.adv.text=Res.advText(world.nadv);
			mainMenuMovieClip.adv.y=main.stage.stageHeight-mainMenuMovieClip.adv.textHeight-40;
			mainMenuMovieClip.info.txt.htmlText=Res.txt('g','inform')+'<br>'+Res.txt('g','inform',1);
			mainMenuMovieClip.info.visible=(mainMenuMovieClip.info.txt.text.length>0);
			setScrollInfo();
		}

		private function setMainButton(but:MovieClip, txt:String):void {
			but.txt.text=txt;
			but.glow.text=txt;
			but.txt.visible=(but.glow.textWidth<1)
		}
		
		private function setMenuSize():void {
			mainMenuMovieClip.adv.y=main.stage.stageHeight-mainMenuMovieClip.adv.textHeight-40;
			mainMenuMovieClip.version.y=main.stage.stageHeight-58;
			mainMenuMovieClip.link.y=main.stage.stageHeight-125;
			var ny:int = main.stage.stageHeight-400;
			if (ny<280) ny=280;
			mainMenuMovieClip.dialLoad.x=mainMenuMovieClip.dialNew.x=world.app.vis.x=main.stage.stageWidth/2;
			mainMenuMovieClip.dialLoad.y=mainMenuMovieClip.dialNew.y=world.app.vis.y=ny;
			mainMenuMovieClip.lang.x=main.stage.stageWidth-30;
			mainMenuMovieClip.lang.y=main.stage.stageHeight-50;
			mainMenuMovieClip.info.txt.height=mainMenuMovieClip.info.scroll.height=mainMenuMovieClip.link.y-mainMenuMovieClip.info.y-20;
			setScrollInfo();
		}
		
		private function setScrollInfo():void {
			if (mainMenuMovieClip.info.txt.height<mainMenuMovieClip.info.txt.textHeight) {
				mainMenuMovieClip.info.scroll.maxScrollPosition = mainMenuMovieClip.info.txt.maxScrollV;
				mainMenuMovieClip.info.scroll.visible = true;
			} 
			else {
				mainMenuMovieClip.info.scroll.visible = false;
			}
		}
		
		private function resizeDisplay(event:Event):void {
			world.resizeScreen();
			if (active) setMenuSize();
		}

		//загрузка игры
		private function mainLoadOn():void {
			mainMenuMovieClip.dialLoad.visible=true;
			mainMenuMovieClip.dialLoad.title2.visible=(loadReg==1);
			mainMenuMovieClip.dialLoad.title.visible=(loadReg==0);
			mainMenuMovieClip.dialLoad.slot0.visible=(loadReg==0);
			mainMenuMovieClip.dialLoad.info.text='';
			mainMenuMovieClip.dialLoad.nazv.text='';
			mainMenuMovieClip.dialLoad.pers.visible=false;
			saveFiles = [];
			for (var i:int = 0; i <= world.saveKol; i++) {
				var slot:MovieClip = mainMenuMovieClip.dialLoad['slot' + i];
				var save:Object = World.w.getSave(i);
				var obj:Object = fe.inter.PipPageOpt.saveObj(save, i);
				saveFiles.push(obj);
				slot.id.text = i;
				slot.id.visible = false;
				if (save != null && save.est != null) {
					slot.nazv.text=(i==0)?Res.pipText('autoslot'):(Res.pipText('saveslot')+' '+i);
					slot.ggName.text=(save.pers.persName==null)?'-------':save.pers.persName;
					if (save.pers.level!=null) slot.ggName.text+=' ('+save.pers.level+')';
					if (save.pers.dead) slot.nazv.text+=' [†]';
					else if (save.pers.hardcore) slot.nazv.text+=' {!}';
					slot.date.text=(save.date==null)?'-------':Res.getDate(save.date);
					slot.land.text=(save.date==null)?'':Res.txt('m',save.game.land).substr(0,18);
				} 
				else {
					slot.nazv.text=Res.pipText('freeslot');
					slot.ggName.text=slot.land.text=slot.date.text='';
				}
				slot.addEventListener(MouseEvent.CLICK, funLoadSlot);
				slot.addEventListener(MouseEvent.MOUSE_OVER, funOverSlot);
			}
			mainMenuMovieClip.dialLoad.butCancel.addEventListener(MouseEvent.CLICK, funLoadCancel);
			mainMenuMovieClip.dialLoad.butFile.addEventListener(MouseEvent.CLICK, funLoadFile);
			animOn = false;
		}
		
		private function mainLoadOff():void {
			mainMenuMovieClip.dialLoad.visible=false;
			if (mainMenuMovieClip.dialLoad.butCancel.hasEventListener(MouseEvent.CLICK)) {
				mainMenuMovieClip.dialLoad.butCancel.removeEventListener(MouseEvent.CLICK, funLoadCancel);
				mainMenuMovieClip.dialLoad.butFile.removeEventListener(MouseEvent.CLICK, funLoadFile);
			}
			for (var i:int = 0; i<=world.saveKol; i++) {
				var slot:MovieClip=mainMenuMovieClip.dialLoad['slot'+i];
				if (slot.hasEventListener(MouseEvent.CLICK)) {
					slot.removeEventListener(MouseEvent.CLICK, funLoadSlot);
					slot.removeEventListener(MouseEvent.MOUSE_OVER, funOverSlot);
				}
			}
			animOn = true;
		}
		
		private function funLoadCancel(event:MouseEvent):void {
			mainLoadOff();
		}

		//выбрать слот
		private function funLoadSlot(event:MouseEvent):void {
			loadCell=event.currentTarget.id.text;
			if (loadReg==1 && loadCell==0) return;
			if (loadReg==0 && event.currentTarget.ggName.text=='') return;
			mainLoadOff();
			mainMenuOff();
			command=3;
			if (loadReg==1) com='new';
			else com='load';
		}

		private function funOverSlot(event:MouseEvent):void {
			fe.inter.PipPageOpt.showSaveInfo(saveFiles[event.currentTarget.id.text], mainMenuMovieClip.dialLoad);
		}
		
		private function funLoadFile(event:MouseEvent):void {
			var ffil:Array = [new FileFilter(Res.pipText('gamesaves') + " (*.sav)", "*.sav")];
			file.browse(ffil);
		}

		private function selectHandler(event:Event):void {
            file.load();
        }

		private function completeHandler(event:Event):void {
			var obj:Object = file.data.readObject();
			if (obj && obj.est == 1){
				loadCell = 99;
				world.loaddata = obj;
				mainLoadOff();
				mainMenuOff();
				command = 3;
				com = 'load';
				return;
			}
       }		
		
		//новая игры
		private function mainNewOn():void {
			mainMenuMovieClip.dialNew.visible=true;
			mainMenuMovieClip.dialNew.butCancel.addEventListener(MouseEvent.CLICK, funNewCancel);
			mainMenuMovieClip.dialNew.butOk.addEventListener(MouseEvent.CLICK, funNewOk);
			mainMenuMovieClip.dialNew.butVid.addEventListener(MouseEvent.CLICK, funNewVid);
			var kolDifs:int = 5;
			for (var i:int = 0; i<kolDifs; i++) {
				mainMenuMovieClip.dialNew['dif'+i].addEventListener(MouseEvent.CLICK, funNewDif);
				mainMenuMovieClip.dialNew['dif'+i].addEventListener(MouseEvent.MOUSE_OVER, infoMode);
			}
			var kolOpts:int = 6;
			for (i = 1; i<=kolOpts; i++) {
				mainMenuMovieClip.dialNew['infoOpt'+i].addEventListener(MouseEvent.MOUSE_OVER, infoOpt);
				mainMenuMovieClip.dialNew['checkOpt'+i].addEventListener(MouseEvent.MOUSE_OVER, infoOpt);
			}
			updNewMode();
			mainMenuMovieClip.dialNew.pers.gotoAndStop(2);
			mainMenuMovieClip.dialNew.pers.gotoAndStop(1);
			animOn = false;
		}

		private function mainNewOff():void {
			mainMenuMovieClip.dialNew.visible=false;
			if (mainMenuMovieClip.dialNew.butCancel.hasEventListener(MouseEvent.CLICK)) mainMenuMovieClip.dialNew.butCancel.removeEventListener(MouseEvent.CLICK, funNewCancel);
			if (mainMenuMovieClip.dialNew.butOk.hasEventListener(MouseEvent.CLICK)) mainMenuMovieClip.dialNew.butOk.removeEventListener(MouseEvent.CLICK, funNewOk);
			if (mainMenuMovieClip.dialNew.butOk.hasEventListener(MouseEvent.CLICK)) {
				mainMenuMovieClip.dialNew.butVid.removeEventListener(MouseEvent.CLICK, funNewVid);
				var kolDifs:int = 5;
				for (var i:int = 0; i<kolDifs; i++) {
					mainMenuMovieClip.dialNew['dif'+i].removeEventListener(MouseEvent.CLICK, funNewDif);
					mainMenuMovieClip.dialNew['dif'+i].removeEventListener(MouseEvent.MOUSE_OVER, infoMode);
				}
			}
			animOn = true;
		}

		private function funAdv(event:MouseEvent):void {
			world.nadv++;
			if (world.nadv>=world.koladv) world.nadv=0;
			mainMenuMovieClip.adv.text=Res.advText(world.nadv);
			mainMenuMovieClip.adv.y=main.stage.stageHeight-mainMenuMovieClip.adv.textHeight-40;
		}

		private function funAdvR(event:MouseEvent):void {
			world.nadv--;
			if (world.nadv<0) world.nadv=world.koladv-1;
			mainMenuMovieClip.adv.text=Res.advText(world.nadv);
			mainMenuMovieClip.adv.y=main.stage.stageHeight-mainMenuMovieClip.adv.textHeight-40;
		}

		private function funNewCancel(event:MouseEvent):void {
			mainNewOff();
		}

		//нажать ОК в окне новой игры
		private function funNewOk(event:MouseEvent):void {
			mainNewOff();
			if (mainMenuMovieClip.dialNew.checkOpt2.selected) { //показать окно выбора слота
				loadReg=1;
				mainLoadOn();
			} 
			else {
				mainMenuOff();
				loadCell=-1;
				command=3;
				com='new';
			}
		}

		//включить настройки внешности
		private function funNewVid(event:MouseEvent):void {
			setMenuSize();
			mainMenuMovieClip.dialNew.visible=false;
			world.app.attach(mainMenuMovieClip,funVidOk,funVidOk);
		}

		//принять настройки внешности
		private function funVidOk():void {
			mainMenuMovieClip.dialNew.visible=true;
			world.app.detach();
			mainMenuMovieClip.dialNew.pers.gotoAndStop(2);
			mainMenuMovieClip.dialNew.pers.gotoAndStop(1);
		}

		private function funNewDif(event:MouseEvent):void {
			if (event.currentTarget==mainMenuMovieClip.dialNew.dif0) newGameDif=0;
			if (event.currentTarget==mainMenuMovieClip.dialNew.dif1) newGameDif=1;
			if (event.currentTarget==mainMenuMovieClip.dialNew.dif2) newGameDif=2;
			if (event.currentTarget==mainMenuMovieClip.dialNew.dif3) newGameDif=3;
			if (event.currentTarget==mainMenuMovieClip.dialNew.dif4) newGameDif=4;
			updNewMode();
		}

		private function updNewMode():void {
			mainMenuMovieClip.dialNew.dif0.fon.gotoAndStop(1);
			mainMenuMovieClip.dialNew.dif1.fon.gotoAndStop(1);
			mainMenuMovieClip.dialNew.dif2.fon.gotoAndStop(1);
			mainMenuMovieClip.dialNew.dif3.fon.gotoAndStop(1);
			mainMenuMovieClip.dialNew.dif4.fon.gotoAndStop(1);
			if (newGameDif==0) mainMenuMovieClip.dialNew.dif0.fon.gotoAndStop(2);
			if (newGameDif==1) mainMenuMovieClip.dialNew.dif1.fon.gotoAndStop(2);
			if (newGameDif==2) mainMenuMovieClip.dialNew.dif2.fon.gotoAndStop(2);
			if (newGameDif==3) mainMenuMovieClip.dialNew.dif3.fon.gotoAndStop(2);
			if (newGameDif==4) mainMenuMovieClip.dialNew.dif4.fon.gotoAndStop(2);
		}

		private function infoMode(event:MouseEvent):void {
			mainMenuMovieClip.dialNew.modeinfo.htmlText=event.currentTarget.modeinfo.text;
		}

		private function infoOpt(event:MouseEvent):void {
			var n:int = int(event.currentTarget.name.substr(event.currentTarget.name.length-1));
			mainMenuMovieClip.dialNew.modeinfo.htmlText=Res.formatText(Res.txt('g','opt'+n,1));
		}
		
		private function funOpt():void {
			mainNewOff();
			mainLoadOff();
			world.pip.onoff();
		}

		// Function to change the language of the game after clicking a language button
		private function funLang(event:MouseEvent):void {
			mainMenuMovieClip.loading.text = '';
			var nid:String = event.currentTarget.n.text;
			if (nid == world.languageManager.currentLanguage) {
				return;
			}
			world.languageManager.changeLanguage(nid);
			langReload = true;
			showButtons(false);
			mainMenuMovieClip.loading.text = 'Loading';
		}
		
		private function showButtons(n:Boolean):void {
			mainMenuMovieClip.lang.visible = n;
			mainMenuMovieClip.butNewGame.visible = n;
			mainMenuMovieClip.butLoadGame.visible = n;
			mainMenuMovieClip.butContGame.visible = n;
			mainMenuMovieClip.butOpt.visible = n;
			mainMenuMovieClip.butAbout.visible = n;
		}
		
		//создатели
		private function funAbout():void {
			mainMenuMovieClip.dialAbout.title.text = Res.guiText('about');
			var s:String = Res.formatText(Res.txt('g', 'about', 1));
			s += '<br><br>' + Res.guiText('usedmusic') + '<br>';
			s += "<br><span class='music'>" + Res.formatText(Res.currentLanguageData.gui.(@id == 'usedmusic').info[0]) + "</span>"
			s += "<br><br><a href='https://creativecommons.org/licenses/by-nc/4.0/legalcode'>Music CC-BY License</a>";
			mainMenuMovieClip.dialAbout.txt.styleSheet = style;
			mainMenuMovieClip.dialAbout.txt.htmlText = s;
			mainMenuMovieClip.dialAbout.visible = true;
			mainMenuMovieClip.dialAbout.butCancel.addEventListener(MouseEvent.CLICK, funAboutOk);
			mainMenuMovieClip.dialAbout.scroll.maxScrollPosition = mainMenuMovieClip.dialAbout.txt.maxScrollV;
		}

		private function funAboutOk(event:MouseEvent):void {
			mainMenuMovieClip.dialAbout.visible=false;
			mainMenuMovieClip.dialAbout.butCancel.removeEventListener(MouseEvent.CLICK, funAboutOk);
		}
		
		private function step():void {
			if (langReload) {
				langReload = false;
				showButtons(true);
				mainMenuMovieClip.loading.text = '';
				world.pip.updateLang();
				setMainLang();
				return;
			}
			if (loaded) {
				// If the MainMenu background is set to animate and the pipbuck isn't active, animate the background
				if (animOn && !world.pip.active) {
					displ.anim();
				}
				// Green loading text on the top left of the MainMenu
				if (world.allLandsLoaded) {
					// If we're still loading songs, show the progress
					if (Snd.totalSongsToLoad > Snd.totalSongsLoaded) {
						mainMenuMovieClip.loading.text = 'Music loading ' + Snd.totalSongsLoaded + '/' + Snd.totalSongsToLoad;
					}
					// Otherwise clear the text to hide this
					else {
						mainMenuMovieClip.loading.text = '';
					}
				}
				return;
			}
			// If all resource packs (.swfs / or loose files) have finished loading
			if (world.grafon.resIsLoad) {
				stn++;
				mainMenuMovieClip.loading.text = 'Loading ' + (Math.floor(stn / 30)) + '\n';
				world.init2();
				
				if (world.allLandsLoaded) {
					setLangButtons();
					setMainLang();
					loaded=true;
					showButtons(true);
					return;
				}
				
				mainMenuMovieClip.loading.text+=world.load_log;
			} 
			else {
				mainMenuMovieClip.loading.text='Loading '+Math.round(world.grafon.progressLoad*100)+'%';
				
			}
		}
		
		public function log(s:String):void {
			mainMenuMovieClip.loading.text+=s+'; ';
		}

		// This is the main loop of the game and runs every frame
		private function mainStep(event:Event):void {
			if (!part1Loaded) {
				if (XMLData.fileCount < 1) return;
				else if (XMLData.filesLoaded >= XMLData.fileCount) {
					trace('Finished loading: ' + XMLData.filesLoaded + ' of ' + XMLData.fileCount + ' files.');
					part1Loaded = true;
				}
				else {
					trace('Loaded: ' + XMLData.filesLoaded + ' of ' + XMLData.fileCount + ' files.');
					return;
				}

			}
			if (part1Loaded && !part2Loaded) {
				part2Loaded = true;
				mainMenu2();
			}

			if (active) step();
			else if (command>0) {
				command--;
				if (command==1 && !mainMenuMovieClip.dialNew.checkOpt1.selected && com=='new') {
					world.setLoadScreen(0);
				}
				
				if (command==0) { //начать игру !!!!
					var opt:Object;
					if (com=='new') {
						//propusk - опция 1 - пропуск обучения
						//hardcore - опция 2
						//fastxp - опция 3, опыта нужно на 40% меньше
						//rndpump - опция 4, случайная прокачка
						//hardskills - давать по 3 sp за уровень
						//autoSaveN - ячейка автосейва
						opt = {
								dif:newGameDif,
								propusk:mainMenuMovieClip.dialNew.checkOpt1.selected,
								hardcore:mainMenuMovieClip.dialNew.checkOpt2.selected,
								fastxp:mainMenuMovieClip.dialNew.checkOpt3.selected,
								rndpump:mainMenuMovieClip.dialNew.checkOpt4.selected,
								hardskills:mainMenuMovieClip.dialNew.checkOpt5.selected,
								hardinv:mainMenuMovieClip.dialNew.checkOpt6.selected
							};
						
						if (opt.hardcore) {
							opt.autoSaveN = loadCell;
						}
						
						loadCell = -1;
					}
					world.newGame(loadCell, mainMenuMovieClip.dialNew.inputName.text, opt);
				}
			} 
			else world.step();
		}			
	}	
}
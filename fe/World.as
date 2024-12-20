package  fe {

	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.system.Capabilities;
	import flash.net.SharedObject;
    import flash.ui.Mouse;
	import flash.desktop.Clipboard;
	import flash.utils.getTimer;
	import flash.system.System;
	
	import fe.loc.*;
	import fe.graph.Grafon;
	import fe.graph.Emitter;
	import fe.inter.*;
	import fe.serv.LootGen;
	import fe.unit.Unit;
	import fe.unit.UnitPlayer;
	import fe.unit.Invent;
	import fe.unit.Pers;
	
	public class World {

		public static var w:World;
		
		public var playerMode:String;	//Режим флеш-плеера

		//Визуальные составляющие
		public var main:Sprite;			//Главный спрайт игры
		public var swfStage:Stage;	
		
		public var vwait:MovieClip;		//Картинка с надписью ЗАГРУЗКА
		public var vfon:MovieClip;		//Неподвижный задник
		public var visual:Sprite;		//активная область
		public var vscene:MovieClip;	//Сцена
		public var vblack:MovieClip;	//Затемнение
		public var vpip:MovieClip;		//Пипбак
		public var vsats:MovieClip;		//Интерфейс ЗПС
		public var vgui:MovieClip;		//GUI (HUD)
		public var vstand:MovieClip;	//Стенд
		public var verror:MovieClip;	//окно ошибки
		public var vconsol:MovieClip;	//Консоль
	
		//Все главные компоненты
		public var mainMenuClass:MainMenu;
		public var cam:Camera;			//камера
		public var ctr:Ctr;				//управление
		public var consol:Consol;		//консоль
		public var game:Game;			//Игра
		public var gg:UnitPlayer;		//Юнит ГГ
		public var pers:Pers;			//Персонаж
		public var invent:Invent;		//Инвентарь
		public var gui:GUI;				//GUI
		public var grafon:Grafon;		//Графика
		public var pip:PipBuck;			//Пипбак
		public var stand:Stand;			//Стенд
		public var sats:Sats;			//ЗПС
		public var app:Appear;			//настройки внешности персонажа
		
		//Компоненты локаций
		public var land:Land;		//текущая местность
		public var loc:Location;	//текущая локация
		public var rooms:Array;
		
		//Рабочие переменные
		public var consoleActive:Boolean = false;	// Console active
		public var onPause:Boolean=false;	//игра на тестовой паузе
		public var allStat:int=0; 			//общий статус 0 - игра не началась
		public var celX:Number;				//координаты курсора в системе отсчёта локации
		public var celY:Number;
		public var t_battle:int=0;			//идёт бой или нет
		public var t_die:int=0;				//гг сдох
		public var t_exit:int=0;			//выход из местности
		public var gr_stage:int=0;			//стадия прорисовки локации
		public var checkLoot:Boolean=false;	//пересчитать автозабирание лута
		public var calcMass:Boolean=false;	//пересчитать массу
		public var calcMassW:Boolean=false;	//пересчитать массу оружия
		public var lastCom:String=null;
		public var armorWork:String='';		//временное отображение брони
		public var mmArmor:Boolean=false;	//броня в главном меню
		public var catPause:Boolean=false;	//пауза для показа сцены
		
		public var testLoot:Boolean=false;	// [Testing loot and experience]
		public var summxp:int=0;
		var ccur:String;
		
		public var currentMusic:String='';
		
		
		//Настроечные переменные
		public var enemyAct:int=3;	//активность врагов, должно быть 3. Если 0, враги будут не активны
		public var roomsLoad:int = 1;  			//1-загружать из файла карты локаций
		private var langLoad=1;  			//1-загружать из файла
		public var addCheckSP:Boolean=false;			//добавлять скилл-поинты при посещении контрольной точки
		public var weaponsLevelsOff:Boolean=true;	//запрещать ли использование оружия не соотв. уровня
		public var drawAllMap:Boolean=false;		//отображать ли всю карту без тумана войны
		public var black:Boolean=true;				//отображать туман войны
		public var testMode:Boolean=false;			//Тестовый режим
		public var chitOn:Boolean=false;
		public var chit:String='', chitX:String=null;	//текущий чит
		public var showArea:Boolean=false;	//показывать активные области
		public var godMode:Boolean=false;				//неуязвимость
		public var showAddInfo:Boolean=false;		//показывать доп. информацию
		public var testBattle:Boolean=false;		//выносливость будет расходоваться вне боя
		public var testEff:Boolean=false;		//эффекты будут в 10 раз короче
		public var testDam:Boolean=false;		//отменяет разброс урона
		public var hardInv:Boolean=false;		//ограниченный инвентарь
		public var alicorn:Boolean=false;
		public var maxParts:int=100;			//максимум частиц
		
		public var zoom100:Boolean=false;		//масштаб 100%
		public var dialOn:Boolean=true;		//показывать диалоги с нпс
		public var showHit:int=2;			//показывать урон
		public var matFilter:Boolean=true;	//мат фильтр
		public var helpMess:Boolean=true;	//обучающие сообщения
		
		public var shineObjs:Boolean=false;	//свечение объектов
		public var sysCur:Boolean=false;	//системный курсор
		public var hintKeys:Boolean=true;	//подсказка про клавиши
		public var hintTele:Boolean=true;	//подсказка про клавиши
		public var showFavs:Boolean=true;	//показывать доп инфу когда курсор наверху экрана
		public var errorShow:Boolean=true;
		public var errorShowOpt:Boolean=true;
		public var quakeCam:Boolean=true;	//тряска камеры
		
		public var vsWeaponNew:Boolean=true;	// [Automatically pick up a new weapon if there is room]
		public var vsWeaponRep:Boolean=true;	//автоматически брать оружие для ремонта
		public var vsAmmoAll:Boolean=true;		
		public var vsAmmoTek:Boolean=true;		
		public var vsExplAll:Boolean=true;		
		public var vsMedAll:Boolean=true;		
		public var vsHimAll:Boolean=true;		
		public var vsEqipAll:Boolean=true;		
		public var vsStuffAll:Boolean=true;		
		public var vsVal:Boolean=true;		
		public var vsBook:Boolean=true;		
		public var vsFood:Boolean=true;		
		public var vsComp:Boolean=true;		
		public var vsIngr:Boolean=true;		
		
		//Глобальные константы
		public var actionDist=200*200;

		public static const cellsX:int = 48;
		public static const cellsY:int = 25;
		public static const fps:int = 30;
		public static const ddy:int = 1;
		public static const maxdy:int = 20;
		public static const maxwaterdy:int = 20;
		public static const maxdelta:int = 9;
		public static const oduplenie:int = 100;
		public static const battleNoOut:int = 120;
		public static const unitXPMult:Number = 2;
		public static const kolHK:int = 12;			//количество горячих клавиш
		public static const kolQS:int = 4;			//количество быстрых заклинаний
			
		
		public static const boxDamage:int = 0.2;		//мультипликатор силы удара ящиками
		
		//Загрузка текстов
		public var currentLanguage:String = 'en';		// Two letter language id, eg. 'en'
		public var userDefaultLanguage:String = 'ru';	// Two letter language id, eg. 'ru'
		public var langs:Array;							// An array of objects representing langauges. Each obj has two properties, 'file' - the filename, and 'nazv' - the full name of each language, eg. 'english'
		public var kolLangs:int = 0;					// How many language objects are in lang.

		public var tld:TextLoader;	// Default language
		public var tl:TextLoader;	// Selected language

		public var textLoaded:Boolean=false;
		public var textLoadErr:Boolean=false;

		private var loader_lang:URLLoader;

		public var langsXML:XML;
		public var textProgressLoad:Number=0;
		
		//Файлы
		public var spriteURL:String;
		public var sprite1URL:String;
		
		//public var ressoundURL:String;
		public var langURL:String;
		public var langFolder:String;
		
		//загрузка, сейвы, конфиг
		public var configObj:SharedObject;
		private var saveObj:SharedObject;
		private var saveArr:Array;
		public var saveKol:int = 10;
		private var t_save:int = 0;
		public var loaddata:Object;	//данные, загружаемые из файла
		public var nadv:int=0;
		public var koladv:int = 10;	//номер совета
		public var load_log:String='';
		
		//карты местностей
		public var landPath:String;
		public var fileVersion:int=2;		//изменить это число для сброса кэша
		public var landData:Array;
		public var kolLands:int=0;
		public var kolLandsLoaded:int=0;
		public var allLandsLoaded:Boolean=false;
		
		public var comLoad:int=-1;		//команда на загрузку
		public var clickReq:int=0;		//запрос нажатия кнопки, если установить в 1, то 2 установится только после нажатия
		public var ng_wait:int=0;		//начало новой игры, ожидание
		public var loadScreen:int=-1;	//загрузочный экран
		public var autoSaveN:int=0;		//номер ячейки автосейва
		public var log:String='';

		//var date:Date,
		private var d1:int;
		private var d2:int;
		
		public var landError:Boolean = false;

		// Constructor
		public function World(nmain:Sprite, paramObj:Object) {

			World.w = this;
			//техническая часть
			//Узнать тип плеера и адрес, с которого он запущен
			playerMode = Capabilities.playerType;

			//файлы
			spriteURL = 'sprite.swf';
			sprite1URL = 'sprite1.swf';
			langURL = 'Modules/core/Language/lang.xml';
			langFolder = 'Modules/core/Language/'
			landPath = 'Rooms/';

			// Grab a reference to the stage container
			main = nmain;
			swfStage = main.stage;
			swfStage.tabChildren = false;
			swfStage.addEventListener(Event.DEACTIVATE, onDeactivate);

			// STEP 1 LOAD THE LIST OF LANGAUGES FROM 'lang.xml'
			loader_lang = new URLLoader();
			var request_lang:URLRequest = new URLRequest(langURL);

			loader_lang.load(request_lang);
			loader_lang.addEventListener(Event.COMPLETE, onCompleteLoadLang);
			loader_lang.addEventListener(IOErrorEvent.IO_ERROR, onErrorLoadLang);

			LootGen.init();
			Form.setForms();
			Emitter.init();

			//создание элементов графики
			vwait = new visualWait();
			vwait.cacheAsBitmap=true;

			//настройщик внешности
			app=new Appear();

			visual=new Sprite();
			vgui = new visualGUI();
			vfon = new MovieClip();
			vpip = new visPipBuck();
			vstand = new visualStand();
			vsats = new MovieClip();
			vscene = new visualScene();
			vblack = new visBlack();
			vblack.cacheAsBitmap=true;
			vconsol=new visConsol();
			verror=new visError();
			setLoadScreen();
			vgui.visible=vpip.visible=vconsol.visible=vfon.visible=visual.visible=vsats.visible=vwait.visible=vblack.visible=verror.visible=vscene.visible=false;
			vscene.stop();
			main.addChild(vwait);
			main.addChild(vfon);
			main.addChild(visual);
			main.addChild(vscene);
			main.addChild(vblack);
			main.addChild(vpip);
			main.addChild(vsats);
			main.addChild(vgui);
			main.addChild(vstand);
			main.addChild(verror);
			main.addChild(vconsol);
			verror.butCopy.addEventListener(flash.events.MouseEvent.CLICK, function():void {Clipboard.generalClipboard.clear();Clipboard.generalClipboard.setData(flash.desktop.ClipboardFormats.TEXT_FORMAT, verror.txt.text);});
			verror.butClose.addEventListener(flash.events.MouseEvent.CLICK, function():void {verror.visible=false;});
			verror.butForever.addEventListener(flash.events.MouseEvent.CLICK, function():void {errorShow=false; verror.visible=false;});
			vstand.visible=false;
			grafon=new Grafon(visual);
			cam=new Camera(this);
			load_log+='Stage 1 Ok\n';

			// FPS Counter (This seems to also be used for other things like measuring load times.)
			d1 = getTimer();
			d2 = getTimer();

			//конфиг, сразу загружает настройки звука
			var savePath:String = null;
			configObj = SharedObject.getLocal('config', savePath);
			if (configObj.data.snd) Snd.load(configObj.data.snd);
		}

//=============================================================================================================
//			Техническая часть
//=============================================================================================================
		
		// The list of languages 'lang.xml' loaded successfully.
		private function onCompleteLoadLang(event:Event):void {
			loader_lang.removeEventListener(Event.COMPLETE, onCompleteLoadLang);
			loader_lang.removeEventListener(IOErrorEvent.IO_ERROR, onErrorLoadLang);

			langsXML = new XML(loader_lang.data);
			initLangs(false);
			
			load_log += 'Language file loading: ' + langURL + ' Ok\n';
		}
		
		// The list of languages 'lang.xml' did not load successfully.
		private function onErrorLoadLang(event:IOErrorEvent):void {
			loader_lang.removeEventListener(Event.COMPLETE, onCompleteLoadLang);
			loader_lang.removeEventListener(IOErrorEvent.IO_ERROR, onErrorLoadLang);
			
			initLangs(true);
			
			load_log += 'ERROR: Could not load language: ' + langURL + '.\n';
        }
		
		//создать список языков, инициировать загрузку языков
		private function initLangs(err:Boolean = false):void {
			// Failsafe default langauges if lang.xml couldn't be loaded correctly. 
			if (err) { 
				trace("World.as/initLangs() - Error: Couldn't initialize langauges, using defaults");
				load_log += 'ERROR: Initializing languages failed, using defaults\n';
				langsXML =
				<all>
					<lang id='ru' file='text_ru.xml'>Русский</lang>
					<lang id='en' file='text_en.xml'>English</lang>
				</all>;
			}

			currentLanguage = Capabilities.language; // Try to detect default langauge for the user.
			if (configObj.data.language != null) currentLanguage = configObj.data.language; // If user settings exist, overwrite the default language.
			if (langsXML && langsXML.@defaultLanguage.length()) userDefaultLanguage = langsXML.@defaultLanguage;

			langs = [];
			for each (var xl:XML in langsXML.lang) {
				var obj:Object = {file:xl.@file, nazv:xl[0]};	//Creates an obj with two properties, The file path, eg. 'text_en.xml', and the language name eg. 'English' 
				langs[xl.@id] = obj;							//Adds each object into the langs array under it's id, eg. 'en'
				kolLangs++;										//Increase the number of languages.
				
			}
			
			if (langs[currentLanguage] == null) {
				currentLanguage = userDefaultLanguage;
			}

			tld = new TextLoader(langs[userDefaultLanguage].file, true);	// Create a new textloader and pass it the file path of the default langauge.
			
			if (currentLanguage == userDefaultLanguage) {
                tl = tld;													// Otherwise, write the default user language into tl.
            }
			else {
                var languageURL:String = langFolder + currentLanguage;
                tl = new TextLoader(langs[currentLanguage].file);
            }
		}
		
		// [Language loading complete]
		public function textsLoadOk():void {
			if (tl.loaded) {
				textLoaded = true;
				Res.currentLanguageData = tl.xmlData;
			}
			if (tl.errLoad) {
				currentLanguage = userDefaultLanguage;
				if (tld.loaded) {
					textLoaded = true;
					Res.currentLanguageData = tld.xmlData;
				}
				textLoadErr = true;
			}
		}
		
		// [Choose a new language]
		public function defuxLang(nid:String):void {
			currentLanguage = nid;
			textLoadErr = false;
			if (nid == userDefaultLanguage) {
                Res.currentLanguageData = Res.fallbackLanguageData;
                pip.updateLang();
            }
			else {
                textLoaded = false;
                tl = new TextLoader(langs[nid].file);
            }
			saveConfig();
		}
		
		public function init2():void {

			if (consol) return;
			if (configObj) lastCom=configObj.data.lastCom;
			consol = new Consol(vconsol, lastCom);
			// [Saves and config]
			saveArr = [];

			var i:int;
			for (i = 0; i<=saveKol; i++) {
				var savePath:String = null;
				saveArr[i]=SharedObject.getLocal('PFEgame'+i,savePath);
			}
			saveObj = saveArr[0];

			if (configObj.data.dialon!=null) dialOn=configObj.data.dialon;
			if (configObj.data.zoom100!=null) zoom100=configObj.data.zoom100;
			if (zoom100) cam.isZoom=0; else cam.isZoom=2;
			if (configObj.data.mat!=null) matFilter=configObj.data.mat;
			if (configObj.data.help!=null) helpMess=configObj.data.help;
			if (configObj.data.hit!=null) showHit=configObj.data.hit;
			if (configObj.data.sysCur!=null) sysCur=configObj.data.sysCur;
			if (configObj.data.hintTele!=null) hintTele=configObj.data.hintTele;
			if (configObj.data.showFavs!=null) showFavs=configObj.data.showFavs;
			if (configObj.data.quakeCam!=null) quakeCam=configObj.data.quakeCam;
			if (configObj.data.errorShowOpt!=null) errorShowOpt=configObj.data.errorShowOpt;
			if (configObj.data.app) {
				app.load(configObj.data.app);
				app.setTransforms();
			}

			koladv = Res.currentLanguageData.advice[0].a.length();

			if (configObj.data.nadv) {
				nadv=configObj.data.nadv;
				configObj.data.nadv++;
				if (configObj.data.nadv>=koladv) configObj.data.nadv=0;
			}
			else configObj.data.nadv=1;

			if (configObj.data.chit>0) chitOn=true;
			
			if (configObj.data.vsWeaponNew>0) vsWeaponNew=false;
			if (configObj.data.vsWeaponRep>0) vsWeaponRep=false;
			if (configObj.data.vsAmmoAll>0) vsAmmoAll=false;	
			if (configObj.data.vsAmmoTek>0) vsAmmoTek=false;	
			if (configObj.data.vsExplAll>0) vsExplAll=false;	
			if (configObj.data.vsMedAll>0) vsMedAll=false;
			if (configObj.data.vsHimAll>0) vsHimAll=false;
			if (configObj.data.vsEqipAll>0) vsEqipAll=false;
			if (configObj.data.vsStuffAll>0) vsStuffAll=false;
			if (configObj.data.vsVal>0) vsVal=false;
			if (configObj.data.vsBook>0) vsBook=false;
			if (configObj.data.vsFood>0) vsFood=false;
			if (configObj.data.vsComp>0) vsComp=false;
			if (configObj.data.vsIngr>0) vsIngr=false;
			
			ctr=new Ctr(configObj.data.ctr);
			pip=new PipBuck(vpip);
			if (!sysCur) Mouse.cursor='arrow';
			
			// [Loading location maps]
			landData = [];
			
			var xmlList:XMLList = XMLDataGrabber.getNodesWithName("core", "GameData", "Lands", "land");
			for each(var xl in xmlList) {
				if (!testMode && xl.@test>0) continue;
				var ll:LandLoader=new LandLoader(xl.@id);
				if (!(xl.@test>0)) kolLands++;
				landData[xl.@id]=ll;
			}
			xmlList = null; // Manual cleanup

			load_log+='Stage 2 Ok\n';
		}

		public function roomsLoadOk():void {
			if (!roomsLoad) {
				allLandsLoaded = true;
				return;
			}
			kolLandsLoaded++;
			if (kolLands == kolLandsLoaded) allLandsLoaded = true;
		}

		//Пауза и вызов пипбака если потерян фокус
		public function onDeactivate(event:Event):void {
			if (allStat==1) pip.onoff(11);
			if (allStat>0 && !alicorn) saveGame();
		}
		
		//Пауза и вызов пипбака если изменён размер окна
		public function resizeScreen():void {
			if (allStat>0) cam.setLoc(loc);
			if (gui) gui.resizeScreen(swfStage.stageWidth,swfStage.stageHeight);
			pip.resizeScreen(swfStage.stageWidth,swfStage.stageHeight);
			grafon.setFonSize(swfStage.stageWidth,swfStage.stageHeight);
			if (stand) stand.resizeScreen(swfStage.stageWidth,swfStage.stageHeight);
			vblack.width=swfStage.stageWidth;
			vblack.height=swfStage.stageHeight;
			if (loadScreen<0) {
				vwait.x=swfStage.stageWidth/2;
				vwait.y=swfStage.stageHeight/2;
			}
			if (allStat==1 && !testMode) pip.onoff(11);
		}
		
//=============================================================================================================
//			Game
//=============================================================================================================
		
		var ng:Boolean;
		var data:Object;
		var opt:Object;
		var newName:String;

		// [Start a new game or load a save. The slot number is transmitted or -1 for a new game]
		// [Stage 0 - create HUD, ZPS and pipbuck]
		// [Initialize game]
		public function newGame(nload:int=-1, nnewName:String='LP', nopt:Object=null):void {
			if (testMode && !chitOn) {
				vwait.progres.text = 'error';
				return;
			}

			time___metr();
			allStat=-1;
			opt=nopt;
			newName=nnewName;
			game=new Game();
			
			if (!roomsLoad) {
				allLandsLoaded=true;
			}
			
			ng = nload < 0;
			
			if (ng) {
				if (opt && opt.autoSaveN) {
					autoSaveN=opt.autoSaveN;
					saveObj=saveArr[autoSaveN];
					nload=autoSaveN;
				}
				else nload=0;
				saveObj.clear();
			}
			
			//создать GUI
			gui=new GUI(vgui);
			gui.resizeScreen(swfStage.stageWidth,swfStage.stageHeight);
			//перевести пипбак в игровой режим
			pip.toNormalMode();
			pip.resizeScreen(swfStage.stageWidth,swfStage.stageHeight);
			//создать интерфейс ЗПС
			sats=new Sats(vsats);
			time___metr('Interface');
			
			//создать игру
			if (nload==99) {
				data=loaddata;	//была загрузка из файла
			}
			else {
				data = saveArr[nload].data; //была загрузка из слота
			}
			
			if (ng)	game.init(null, opt);
			else game.init(data.game);
			
			ng_wait=1;
			time___metr('Game init');
		}
		
		//этап 1 - создать персонажа и инвентарь
		public function newGame1():void {
			if (!ng) app.load(data.app);
			if (data.hardInv==true) hardInv=true; else hardInv=false;
			if (opt && opt.hardinv) hardInv=true;
			//создать персонажа
			pers=new Pers(data.pers, opt);
			if (ng) pers.persName=newName;
			//создать юнит ГГ
			gg=new UnitPlayer();
			gg.ctr=ctr;
			gg.sats=sats;
			sats.gg=gg;
			gui.gg=gg;
			//создат инвентарь
			invent=new Invent(gg, data.invent, opt);
			stand=new Stand(vstand,invent);
			gg.attach();
			time___metr('Character');
			//номер ячейки автосейва
			if (!ng) if (data.n!=null) autoSaveN=data.n;
			Unit.txtMiss=Res.guiText('miss');
			
			waitLoadClick();
			ng_wait=2;
			time___metr('Terrain');
		}
		
		//этап 2 - создать местность и войти в неё
		public function newGame2():void {
			//визуальная часть
			resizeScreen();
			offLoadScreen();
			vgui.visible=vfon.visible=visual.visible=true;
			vblack.alpha=1;
			cam.dblack=-10;
			pip.onoff(-1);
			//войти в текущую местность
			game.enterToCurLand();//!!!!
			Snd.setTempMute(false);
			gui.setAll();
			allStat = 1;
			if (game.triggers["Quickstart"] == 1){
				trace("World.as/newGame2() - Adding quickstart equipment");
				game.runScript("giveQuickstartItems");
				game.setTrigger("Quickstart", 0);
			}
			ng_wait=0;
		}
		
		public function loadGame(nload:int=0):void {
			time___metr();
			comLoad=-1;
			if (loc) loc.out();
			land=null;
			loc=null;

			cur('arrow');

			//объект загрузки
			var data:Object;
			if (nload==99) data=loaddata;
			else data=saveArr[nload].data;

			//создать игру
			Snd.setTempMute(true);
			cam.showOn=false;
			if (data.hardInv==true) hardInv=true; else hardInv=false;
			game=new Game();
			game.init(data.game);
			app.load(data.app);
			//создать персонажа
			pers=new Pers(data.pers);
			//создать юнит ГГ
			gg=new UnitPlayer();
			gg.ctr=ctr;
			gg.sats=sats;
			sats.gg=gg;
			gui.gg=gg;
			//создат инвентарь
			invent=new Invent(gg, data.invent);
			if (stand) stand.inv=invent;
			else stand=new Stand(vstand,invent);
			gg.attach();
			//номер ячейки автосейва
			if (data.n!=null) autoSaveN=data.n;
			
			offLoadScreen();
			vgui.visible=vfon.visible=visual.visible=true;
			vblack.alpha=1;
			cam.dblack=-10;
			pip.onoff(-1);
			gui.allOn();
			t_die=0;
			t_battle=0;
			time___metr('Character');
			//войти в текущую местность
			game.enterToCurLand();//!!!!
			log='';
			Snd.setTempMute(false);
			gui.setAll();
			allStat=1;
		}
		
		//вызов при входе в конкретную местность
		public function ativateLand(nland:Land):void {
			land = nland;
			grafon.drawFon(vfon, land.act.fon);
		}
		
		//вызов при входе в конкретную локацию
		//тут графический баг
		public function ativateLoc(nloc:Location):void {
			if (loc) loc.out();
			loc=nloc;
			grafon.drawLoc(loc);
			cam.setLoc(loc);
			grafon.setFonSize(swfStage.stageWidth,swfStage.stageHeight);
			gui.setAll();
			currentMusic=loc.sndMusic;
			Snd.playMusic(currentMusic);
			gui.hpBarBoss();
			if (t_die<=0) World.w.gg.controlOn();
			gui.dialText();
			pers.invMassParam();
			gc();
		}
		
		public function redrawLoc():void {
			grafon.drawLoc(loc);
			cam.setLoc(loc);
			gui.setAll();
		}
		
		public function exitLand(fast:Boolean=false):void {
			if (t_exit > 0) return;
			gg.controlOff();
			pip.noAct=true;

			if (fast) {
				t_exit =  21;
			}
			else {
				t_exit = 100;
			}
		}
		
		
		private function exitStep():void {
			t_exit--;
			if (t_exit==99) cam.dblack=1.5;
			if (t_exit==20) {
				vblack.alpha=0;
				cam.dblack=0;
				setLoadScreen(getLoadScreen());
				Snd.setTempMute(true);
			}
			if (t_exit==19) {
				cur('arrow');
				game.enterToCurLand();
			}
			if (t_exit==18 && clickReq>0) waitLoadClick();
			if (t_exit==16) {
				Mouse.show();
				Snd.setTempMute(false);
				offLoadScreen();
				vgui.visible=vfon.visible=visual.visible=true;
				vblack.alpha=1;
				cam.dblack=-10;
				gg.controlOn();
				pip.noAct=false;
			}
			if (t_exit==1) {
				gui.allOn();
			}
		}
		
		private function ggDieStep():void {
			t_die--;
			if (t_die==200) cam.dblack=2.2;
			if (t_die==150) {
				if (alicorn) {
					game.runScript('gameover');
					t_die=0;
				} else {
					if (gg.sost==3) {
						game.curLandId=game.baseId;
						game.enterToCurLand();
					} else {
						land.gotoCheckPoint();
					}
					cam.dblack=-4;
					gg.vis.visible=true;
				}
			}
			if (t_die==100) gg.resurect();
			if (t_die==1) {
				gg.controlOn();
			}
		}

		//Main Loop
		public function step():void {
			if (verror.visible) return;
			
			ctr.step();	// Player input			
			Snd.step();	// Sound
			if (ng_wait > 0) {
				if (ng_wait == 1) {
					newGame1();
				}
				else if (ng_wait == 2) {
					if (clickReq!=1) newGame2();
				}
				return;
			}
			if (!consoleActive && !pip.active) swfStage.focus = swfStage;
			
			// [Only if the game has started and is not paused, game loops]
			if (allStat==1 && !onPause) {
				// [exit cycle]
				if (t_exit > 0) {
					if (!(t_exit == 17 && clickReq == 1)) exitStep();
				}
				
				// [Particle counting]
				Emitter.kol2 = Emitter.kol1;
				Emitter.kol1 = 0;
				
				// [Main loop] !!!!
				if (t_exit != 17) land.step();
				
				// [Cycle of death]
				if (t_die>0) ggDieStep();
				
				// [Battle timer]
				if (t_battle>0) t_battle--;
				
				sats.step2();

				// [if you need to recalculate the mass]
				if (calcMass) {
					invent.calcMass();
					calcMass = false;
				}
				if (calcMassW) {
					invent.calcWeaponMass();
					calcMassW = false;
				}

				// [Saving]
				t_save++;
				if (t_save > 5000 && !testMode && !alicorn) {
					saveGame();
				}

				checkLoot = false;
			}
			
			if (comLoad >= 0) {
				if (comLoad >= 100) {
					if (autoSaveN > 0) saveGame();
					loadGame(comLoad - 100);
				}
				else {
					pip.onoff(-1);
					comLoad += 100;
					setLoadScreen();
				}
			}
			
			//If the game has started, but paused
			if (allStat>=1) {
				cam.calc(gg);
				gui.step();
				pip.step();
				sats.step();
				if (ctr.keyPip) {
					if (!sats.active) pip.onoff();
					ctr.keyPip=false;
				}
				if (ctr.keyInvent) {
					if (!sats.active) pip.onoff(2);
					ctr.keyInvent=false;
				}
				if (ctr.keyStatus) {
					if (!sats.active) pip.onoff(1,1);
					ctr.keyStatus=false;
				}
				if (ctr.keySkills) {
					if (!sats.active) pip.onoff(1,2);
					ctr.keySkills=false;
				}
				if (ctr.keyMed) {
					if (!sats.active) pip.onoff(1,5);
					ctr.keyMed=false;
				}
				if (ctr.keyMap) {
					if (!sats.active) pip.onoff(3,1);
					ctr.keyMap=false;
				}
				if (ctr.keyQuest) {
					if (!sats.active) pip.onoff(3,2);
					ctr.keyQuest=false;
				}
				if (ctr.keySats) {
					if (gg.ggControl && !pip.active && gg && gg.pipOff<=0 && !catPause) sats.onoff();
					ctr.keySats=false;
				}
				allStat=(pip.active || sats.active || stand.active || gui.guiPause)?2:1;
				
				if (consol && consol.consoleIsVisible && !consoleActive) {
					trace('World.as/step() - Console is visible but not active, hiding!');
					consol.setConsoleVisiblility(false);
				}
			}
		}

//=============================================================================================================
//			Функции глобального взаимодействия
//=============================================================================================================
		
		public function cur(ncur:String='arrow'):void {
			if (sysCur) return;
			if (pip.active || stand.active || comLoad>=0) ncur='arrow';
			else if (t_battle>0) ncur='combat';
			if (ncur!=ccur) {
				Mouse.cursor = ncur;
				Mouse.show();
				ccur=ncur;
			}
		}
		
		public function quake(x:Number, y:Number):void {
			if (loc.sky) return;
			if (quakeCam) {
				cam.quakeX += x;
				cam.quakeY += y;
				if (cam.quakeX>20) cam.quakeX=20;
				if (cam.quakeX<-20) cam.quakeX=-20;
				if (cam.quakeY>20) cam.quakeY=20;
				if (cam.quakeY<-20) cam.quakeY=-20;
			}
		}
		
		// Check whether the player is allowed to leave the current room
		public function possiblyOut():int {
			// Can't leave during combat
			if (t_battle > 0) {
				return 2;
			}
			// Can't leave while alarm is going off
			if (loc && loc.t_alarm > 0) {
				return 2;
			}
			// Too soon to change rooms again
			if (land.loc_t > 120) {
				return 1;
			}
			// Can leave
			return 0;
		}
		
		public function showError(err:Error, dop:String=null):void {
			if (!errorShow || !errorShowOpt) return;

			verror.info.text=Res.pipText('error');
			verror.butClose.text.text=Res.pipText('err_close');
			verror.butForever.text.text=Res.pipText('err_dont_show');
			verror.butCopy.text.text=Res.pipText('err_copy_to_clipboard');

			verror.txt.text=err.message+'\n'+err.getStackTrace();
			verror.txt.text+='\n'+'gr_stage: '+gr_stage;
			if (dop!=null) verror.txt.text+='\n'+dop;
			verror.visible=true;
		}
		
		// [Action measurement time]
		public function time___metr(message:String = null):void {
			d2 = getTimer();
			var timeDif:int = d2 - d1;
			if (message != null) trace("time__metr -- " + message + ': ' + timeDif.toString());
			d1 = d2;
		}
		
		public function gc():void {
			System.pauseForGCIfCollectionImminent(0.25)	
		}
		
//=============================================================================================================
//			Экран загрузки
//=============================================================================================================
		
		//установить экран загрузки
		public function setLoadScreen(n:int=-1):void {
			loadScreen=n;
			vwait.story.lmb.stop();
			vwait.story.lmb.visible=false;
			vgui.visible=vfon.visible=visual.visible=vscene.visible=false;
			vwait.visible=true;
			catPause=false;
			vwait.progres.text=Res.guiText('loading');
			if (n < 0) {
				vwait.x = swfStage.stageWidth / 2;
				vwait.y = swfStage.stageHeight / 2;
				vwait.skill.gotoAndStop(Math.floor(Math.random() * vwait.skill.totalFrames + 1));
				vwait.skill.visible = true;
				vwait.progres.visible = true;
				vwait.story.visible = false;
				clickReq = 0;
			} 
			else
			{
				vwait.x = 0;
				vwait.y = 0;
				vwait.story.visible = true;
				vwait.skill.visible = false;
				vwait.progres.visible = false;
				if (n == 0) {
					vwait.story.txt.htmlText = '<i>' + Res.guiText('story') + '</i>';
					}
				else {
					vwait.story.txt.htmlText = '<i>' + 'История' + n + '</i>';
				}
				clickReq=1;
			}
			vwait.cacheAsBitmap = false;
			vwait.cacheAsBitmap = true;
		}
		
		// [Define which loading screen to show]
		private function getLoadScreen():int { 
			return -1; // ONLY SHOWED -1 by default, removed impossible to reach code.
		}
		
		//включить ожидание клика
		private function waitLoadClick():void {
			vwait.story.lmb.play();
			vwait.story.lmb.visible=true;
		}
		
		//убрать экран загрузки
		private function offLoadScreen():void {
			vwait.visible=false;
			vwait.story.visible=false;
			vwait.skill.visible=vwait.progres.visible=true;
			vwait.story.lmb.stop();
			vwait.story.lmb.visible=false;
			clickReq=0;
		}

		//показать сцену
		public function showScene(sc:String, n:int=0):void {
			catPause=true;
			visual.visible=false;
			gui.allOff();
			gui.offCelObj();
			try {
				vscene.gotoAndStop(sc);
			} 
			catch(err) {
				trace('ERROR: (00:20)');
				vscene.gotoAndStop(1);
			}

			if (n>0) {
				vscene.sc.gotoAndPlay(n);
			}
			else {
				vscene.sc.gotoAndPlay(1);
			}

			vscene.visible = true;
		}
		
		//убрать сцену
		public function unshowScene():void {
			catPause=false;
			visual.visible=true;
			gui.allOn();
			vscene.gotoAndStop(1);
			vscene.visible=false;
		}
		
		//финальная заставка или gameover
		public function endgame(n:int=0):void {
			vwait.visible=vfon.visible = false;
			var s:String;
			if (n==1) {
				showScene('gameover');
				s=Res.lpName(Res.guiText('end_bad'));
			} 
			else if (pers.rep>=pers.repGood) {
				showScene('endgame');
				s=Res.lpName(Res.guiText('end_good'));
				Snd.playMusic('music_fall_2');
			} 
			else {
				showScene('endgame');
				s=Res.lpName(Res.guiText('end_norm'));
			}

			vscene.sc.txt.htmlText = s;
		}

//=============================================================================================================
//			Сейвы и конфиг
//=============================================================================================================
		
		public function saveToObj(data:Object):void {
			var now:Date = new Date();
			data.game=game.save();
			data.pers=pers.save();
			data.invent=invent.save();
			data.app=app.save();
			data.date=now.time;
			data.n=autoSaveN;
			data.hardInv=hardInv;
			data.ver = mainMenuClass.version;
			data.est=1;
		}
		
		public function saveGame(n:int=-1):void {
			if (n==-2) {
				n=autoSaveN;
				var save=saveArr[n];
				saveToObj(save.data);
				save.flush();
				trace('World.as/saveGame() - End');
				return;
			}
			if (t_save<100 && n==-1 && !pers.hardcore) return;
			if (pip.noAct) return;
			if (n==-1) n=autoSaveN;
			var save=saveArr[n];
			if (save is SharedObject) {
				saveToObj(save.data);
				var r=save.flush();
				trace(r);
				if (n==0) t_save=0;
			}
		}
		
		public function getSave(n:int):Object {
			if (saveArr[n] is SharedObject) return saveArr[n].data;
			else return null;
		}
		
		public function saveConfig() {
			try {
				configObj.data.ctr=ctr.save();
				configObj.data.snd=Snd.save();
				configObj.data.language = currentLanguage;
				configObj.data.chit=(chitOn?1:0);
				configObj.data.dialon=dialOn;
				configObj.data.zoom100=zoom100;
				configObj.data.help=helpMess;
				configObj.data.mat=matFilter;
				configObj.data.hit=showHit;
				configObj.data.sysCur=sysCur;
				configObj.data.hintTele=hintTele;
				configObj.data.showFavs=showFavs;
				configObj.data.quakeCam=quakeCam;
				configObj.data.errorShowOpt=errorShowOpt;
				configObj.data.app=app.save();
				if (lastCom!=null) configObj.data.lastCom=lastCom;
					
				configObj.data.vsWeaponNew=vsWeaponNew?0:1;
				configObj.data.vsWeaponRep=vsWeaponRep?0:1;
				configObj.data.vsAmmoAll=vsAmmoAll?0:1;	
				configObj.data.vsAmmoTek=vsAmmoTek?0:1;	
				configObj.data.vsExplAll=vsExplAll?0:1;	
				configObj.data.vsMedAll=vsMedAll?0:1;
				configObj.data.vsHimAll=vsHimAll?0:1;
				configObj.data.vsEqipAll=vsEqipAll?0:1;
				configObj.data.vsStuffAll=vsStuffAll?0:1;
				configObj.data.vsVal=vsVal?0:1;
				configObj.data.vsBook=vsBook?0:1;
				configObj.data.vsFood=vsFood?0:1;
				configObj.data.vsComp=vsComp?0:1;
				configObj.data.vsIngr=vsIngr?0:1;
				configObj.flush();
			} 
			catch (err) {
				trace('ERROR: (00:21)');
				showError(err);
			}
		}
	}	
}
package fe.game {

	import flash.net.SharedObject;
    import flash.ui.Mouse;
	import flash.utils.getTimer;
	import flash.system.System;

	import fe.GameContainer;
	import fe.game.enums.E_DeathState;
	import fe.game.enums.E_ExitState;
	import fe.game.rendering.Emitter;
	import fe.game.domain.serv.LootGen;
	import fe.game.domain.units.Unit;
	import fe.game.domain.units.UnitPlayer;
	import fe.game.domain.units.Inventory;
	import fe.game.domain.units.Pers;
	import fe.game.domain.location.tile.TileRegistry;
	import fe.game.domain.location.Land;
	import fe.game.domain.location.Location;
	import fe.game.domain.location.LandLoader;
	import fe.game.domain.location.Game;
	import fe.game.ui.GUI;
	import fe.game.ui.GUIManager;
	import fe.game.ui.Sats;
	import fe.game.ui.Stand;
	import fe.engine.audio.Sound;
	import fe.engine.text.LanguageManager;
	import fe.engine.text.TextParser;
	import fe.engine.text.XMLDataGrabber;
	
	public class World {

		public static var w:World;								// Publically Accessible reference to this instance of World

		private static const EXIT_FADE_OUT_FRAMES:int	= 79;	// How long the screen fades to black when leaving a land
		private static const EXIT_FADE_IN_FRAMES:int	= 15;	// From the new land fading in to the HUD coming back
		private static const DEATH_FADE_OUT_FRAMES:int	= 50;	// How long the screen fades to black after a death
		private static const DEATH_RESPAWN_FRAMES:int	= 50;	// From the respawn to the player getting up
		private static const DEATH_RESURRECT_FRAMES:int	= 99;	// From the player getting up to having control again

		// Location components
		public var land:Land;									// [Current land]
		public var loc:Location;								// [Current location]
		public var rooms:Array;
		
		// Operating Variables
		public var allStat:int					= 0;					// [General status 0 - game has not started]
		public var celX:Number;											// [Cursor coordinates in the location reference system]
		public var celY:Number;
		public var t_battle:int					= 0;					// Battle timer
		public var deathState:int				= E_DeathState.NONE;	// How far the player's death has got
		public var t_die:int					= 0;					// Frames left in the current death stage
		public var exitState:int				= E_ExitState.NONE;		// How far leaving the land has got
		public var t_exit:int					= 0;					// Frames left in the current exit stage
		public var gr_stage:int					= 0;					// Current stage of Grafon while rendering 
		public var checkLoot:Boolean			= false;				// [Recalculate auto loot pickup]
		
		// Update player inventory weight
		public var calcMass:Boolean				= false;		// [Recalculate mass]
		public var calcMassW:Boolean			= false;		// [Recalculate the mass of weapons]
		
		public var lastCom:String				= "";
		public var armorWork:String				= "";			// [Temporary display of armor]
		public var mmArmor:Boolean				= false;		// [Armor in the main menu]
		public var catPause:Boolean				= false;		// [Pause for scene]
		
		public var testLoot:Boolean				= false;		// [Testing loot and experience]
		public var summxp:int					= 0;
		private var ccur:String;
		
		// [Settings Variables]
		public var enemyAct:int					= 3;			//активность врагов, должно быть 3. Если 0, враги будут не активны
		public var roomsLoad:int				= 1;			//1-загружать из файла карты локаций
		private var langLoad:int				= 1;			//1-загружать из файла
		public var addCheckSP:Boolean			= false;		//добавлять скилл-поинты при посещении контрольной точки
		public var weaponsLevelsOff:Boolean		= true;			//запрещать ли использование оружия не соотв. уровня
		public var drawAllMap:Boolean			= false;		//отображать ли всю карту без тумана войны
		public var black:Boolean				= true;			//отображать туман войны
		
		// Debug variables
		public var testMode:Boolean				= false;		// [Test mode]
		public var chitOn:Boolean				= false;		//
		public var chit:String					= "";			// [Current cheat]
		public var chitX:String					= null;			//
		public var showArea:Boolean				= false;		// [Show active areas]
		public var godMode:Boolean				= false;		// Invulnerability
		public var showAddInfo:Boolean			= false;		// [Show additional information]
		public var testBattle:Boolean			= false;		// [Stamina will be consumed outside of combat]
		public var testEff:Boolean				= false;		// [Effects will be 10 times shorter]
		public var testDam:Boolean				= false;		// [Cancels damage spread]
		
		// Game settings
		public var hardInv:Boolean				= false;		// [Limited inventory]
		public var alicorn:Boolean				= false;		//
		public var maxParts:int					= 100;			// [Maximum particles]
		
		public var zoom100:Boolean				= false;		// [Scale 100%]
		public var dialOn:Boolean				= true;			// [Show dialogues with NPCs]
		public var showHit:int					= 2;			// Show damage number pop-ups
		public var matFilter:Boolean			= true;			// [Mat filter]
		public var helpMess:Boolean				= true;			// [Educational messages]
		
		public var shineObjs:Boolean			= false;		// [Glow of objects]
		public var sysCur:Boolean				= false;		// [System cursor]
		public var hintKeys:Boolean				= true;			// Pop-up hints for interactables, eg. (Press "e" to open)
		public var hintTele:Boolean				= true;			// Pop-up hints for things you can levitate, eg. (Press "q" to levitate)
		public var showFavs:Boolean				= true;			// [Show additional information when the cursor is at the top of the screen]
		public var errorShow:Boolean			= true;			//
		public var errorShowOpt:Boolean			= true;			//
		public var quakeCam:Boolean				= true;			// [Camera shaking]
		
		public var vsWeaponNew:Boolean			= true;			// [Automatically pick up a new weapon if there is room]
		public var vsWeaponRep:Boolean			= true;			// [automatically pick up weapons for repairs]
		public var vsAmmoAll:Boolean			= true;			//
		public var vsAmmoTek:Boolean			= true;			//
		public var vsExplAll:Boolean			= true;			//
		public var vsMedAll:Boolean				= true;			//
		public var vsHimAll:Boolean				= true;			//
		public var vsEqipAll:Boolean			= true;			//
		public var vsStuffAll:Boolean			= true;			//
		public var vsVal:Boolean				= true;			//
		public var vsBook:Boolean				= true;			//
		public var vsFood:Boolean				= true;			//
		public var vsComp:Boolean				= true;			//
		public var vsIngr:Boolean				= true;			//
		
		// Global Constants
		public var actionDist:int				= 40000;

		public static const cellsX:int			= 48;			// How many tiles there are in a room (horizontally)
		public static const cellsY:int			= 25;			// How many tiles there are in a room (vertically)
		public static const fps:int				= 30;
		public static const ddy:int				= 1;
		public static const maxdy:int			= 20;
		public static const maxwaterdy:int		= 20;
		public static const maxdelta:int		= 9;
		public static const detectionDelay:int	= 100;			// Default grace period before an enemy spots the player
		public static const battleNoOut:int		= 120;
		public static const unitXPMult:Number	= 2.00;
		public static const kolHK:int			= 12;			//количество горячих клавиш
		public static const kolQS:int			= 4;			//количество быстрых заклинаний
		
		public static const boxDamage:Number	= 0.20;			// [Box impact force multiplier]
		
		// [Loading, saves, config]
		public var configObj:Object;							// The user's stored settings
		private var saveObj:SharedObject;
		private var saveArr:Array;
		public var saveKol:int					= 10;
		private var t_save:int					= 0;
		public var loaddata:Object;								// [Data loaded from file]
		public var nadv:int						= 0;
		public var koladv:int;									// How many advice snippets are loaded
		public var load_log:String				= "";
		
		// [Location maps]
		public var fileVersion:int				= 2;			// [Change this number to reset the cache]
		public var landData:Array;
		public var kolLands:int					= 0;
		public var kolLandsLoaded:int			= 0;
		public var allLandsLoaded:Boolean		= false;
		
		public var comLoad:int					= -1;			//команда на загрузку
		public var clickReq:int					=  0;			//запрос нажатия кнопки, если установить в 1, то 2 установится только после нажатия
		public var ng_wait:int					=  0;			//начало новой игры, ожидание
		public var loadScreen:int				= -1;			//загрузочный экран
		public var autoSaveN:int				=  0;			//номер ячейки автосейва
		public var log:String					= "";

		// Used for the timer to measure in-game processes
		private var d1:int;
		private var d2:int;
		
		public var landError:Boolean			= false;

		public function World(cfgObj:Object) {

			World.w = this;			// Store a publically accessable reference to itself
			configObj = cfgObj;		// The user's stored settings

			LootGen.init();

			TileRegistry.load();

			Emitter.init();

			load_log+='Stage 1 Ok\n';

			// FPS Counter (This seems to also be used for other things like measuring load times.)
			d1 = getTimer();
			d2 = getTimer();
		}

//=============================================================================================================
//			[Technical part]
//=============================================================================================================
		
		public function init2():void {

			if (configObj) {
				lastCom = configObj.data.lastCom;
			}

			// [Saves and config]
			saveArr = [];

			var i:int;
			for (i = 0; i<=saveKol; i++) {
				var savePath:String = null;
				saveArr[i] = SharedObject.getLocal('PFEgame' + i,savePath);
			}
			saveObj = saveArr[0];

			if (configObj.data.dialon!=null) dialOn=configObj.data.dialon;
			if (configObj.data.zoom100!=null) zoom100=configObj.data.zoom100;
			if (zoom100) {
				GameContainer.reference.cam.isZoom = 0;
			}
			else {
				GameContainer.reference.cam.isZoom = 2;
			}
			if (configObj.data.mat!=null) matFilter=configObj.data.mat;
			if (configObj.data.help!=null) helpMess=configObj.data.help;
			if (configObj.data.hit!=null) showHit=configObj.data.hit;
			if (configObj.data.sysCur!=null) sysCur=configObj.data.sysCur;
			if (configObj.data.hintTele!=null) hintTele=configObj.data.hintTele;
			if (configObj.data.showFavs!=null) showFavs=configObj.data.showFavs;
			if (configObj.data.quakeCam!=null) quakeCam=configObj.data.quakeCam;
			if (configObj.data.errorShowOpt!=null) errorShowOpt=configObj.data.errorShowOpt;
			if (configObj.data.app) {
				GUIManager.reference.app.load(configObj.data.app);
				GUIManager.reference.app.setTransforms();
			}

			koladv = LanguageManager.reference.data.advice.length;
			
			if (configObj.data.nadv) {
				nadv = configObj.data.nadv;
				configObj.data.nadv++;
				if (configObj.data.nadv >= koladv) {
					configObj.data.nadv = 0;
				}
			}
			else {
				configObj.data.nadv = 1;
			}

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

			if (!sysCur) {
				Mouse.cursor='arrow';
			}
			
			// [Loading location maps]
			landData = [];
			
			var xmlList:XMLList = XMLDataGrabber.getNodesWithName("core", "GameData", "Lands", "land");
			for each(var xl:XML in xmlList) {
				if (!testMode && xl.@test>0) continue;
				var ll:LandLoader=new LandLoader(xl.@id);
				if (!(xl.@test>0)) kolLands++;
				landData[xl.@id]=ll;
			}
			xmlList = null; // Manual cleanup

			load_log += 'Stage 2 Ok\n';
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
		public function onDeactivate():void {
			if (allStat==1) GUIManager.reference.pip.onoff(11);
			if (allStat>0 && !alicorn) saveGame();
		}
		
		//Пауза и вызов пипбака если изменён размер окна
		public function resizeScreen():void {
			if (allStat>0) GameContainer.reference.cam.setLoc(loc);
			if (GUIManager.reference.gui) GUIManager.reference.gui.resizeScreen(GameContainer.reference.screenWidth,GameContainer.reference.screenHeight);
			GUIManager.reference.pip.resizeScreen(GameContainer.reference.screenWidth,GameContainer.reference.screenHeight);
			GameContainer.reference.grafon.setFonSize(GameContainer.reference.screenWidth,GameContainer.reference.screenHeight);
			if (GUIManager.reference.stand) GUIManager.reference.stand.resizeScreen(GameContainer.reference.screenWidth,GameContainer.reference.screenHeight);
			GUIManager.reference.vblack.width=GameContainer.reference.screenWidth;
			GUIManager.reference.vblack.height=GameContainer.reference.screenHeight;
			if (loadScreen<0) {
				GUIManager.reference.vwait.x=GameContainer.reference.screenWidth/2;
				GUIManager.reference.vwait.y=GameContainer.reference.screenHeight/2;
			}
			if (allStat==1 && !testMode) GUIManager.reference.pip.onoff(11);
		}
		
//=============================================================================================================
//			Game
//=============================================================================================================
		
		private var ng:Boolean;
		private var data:Object;
		private var opt:Object;
		private var newName:String;

		// [Start a new game or load a save. The slot number is transmitted or -1 for a new game]
		// [Stage 0 - create HUD, ZPS and pipbuck]
		// [Initialize game]
		public function newGame(nload:int=-1, nnewName:String='LP', nopt:Object=null):void {
			if (testMode && !chitOn) {
				GUIManager.reference.vwait.progres.text = 'error';
				return;
			}

			time___metr();
			allStat=-1;
			opt=nopt;
			newName=nnewName;
			GameContainer.reference.game=new Game();
			
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
			GUIManager.reference.gui=new GUI(GUIManager.reference.vgui);
			GUIManager.reference.gui.resizeScreen(GameContainer.reference.screenWidth,GameContainer.reference.screenHeight);
			//перевести пипбак в игровой режим
			GUIManager.reference.pip.toNormalMode();
			GUIManager.reference.pip.resizeScreen(GameContainer.reference.screenWidth,GameContainer.reference.screenHeight);
			//создать интерфейс ЗПС
			GUIManager.reference.sats=new Sats(GUIManager.reference.vsats);
			time___metr('Interface');
			
			// [Create a game]
			if (nload == 99) {
				data=loaddata;	// [was loading from a file]
			}
			else {
				data = saveArr[nload].data; // [there was loading from the slot]
			}
			
			if (ng)	{
				GameContainer.reference.game.init(null, opt);
			}
			else {
				GameContainer.reference.game.init(data.game);
			}
			
			ng_wait = 1;
			time___metr('Game init');
		}
		
		// [Stage 1 - Create a character and inventory]
		public function newGame1():void {
			if (!ng) {
				GUIManager.reference.app.load(data.app);
			}
			
			if (data.hardInv == true) {
				hardInv = true;
			}
			else {
				hardInv = false;
			}
			
			if (opt && opt.hardinv) {
				hardInv = true;
			}
			
			// [Create a character]
			GameContainer.reference.pers = new Pers(data.pers, opt);
			
			if (ng) {
				GameContainer.reference.pers.persName = newName;
			}
			
			// [Create a Player Unit]
			GameContainer.reference.gg = new UnitPlayer();
			GameContainer.reference.gg.ctr = GameContainer.reference.ctr;
			GameContainer.reference.gg.sats = GUIManager.reference.sats;
			GUIManager.reference.sats.gg = GameContainer.reference.gg;
			GUIManager.reference.gui.gg = GameContainer.reference.gg;

			// [Create inventory]
			GameContainer.reference.invent = new Inventory();
			GameContainer.reference.vault = new Inventory();
			GUIManager.reference.stand = new Stand(GUIManager.reference.vstand, GameContainer.reference.invent);
			GameContainer.reference.gg.attach(ng ? null : data.invent);
			
			time___metr('Character');
			
			// [Autosave cell number]
			if (!ng && data.n != null) {
				autoSaveN = data.n;
			}
			
			Unit.txtMiss = TextParser.txt("g", 'miss');
			
			waitLoadClick();
			ng_wait = 2;
			time___metr('Terrain');
		}
		
		// [Stage 2 - Create a terrain and enter it]
		public function newGame2():void {
			//визуальная часть
			resizeScreen();
			offLoadScreen();
			GUIManager.reference.vgui.visible = true;
			GUIManager.reference.vfon.visible = true;
			GUIManager.reference.visual.visible = true;
			GUIManager.reference.vblack.alpha=1;
			GameContainer.reference.cam.dblack=-10;
			GUIManager.reference.pip.onoff(-1);
			// [Enter the current area]
			GameContainer.reference.game.enterToCurLand();//!!!!
			Sound.setTempMute(false);
			GUIManager.reference.gui.setAll();
			allStat = 1;
			
			if (GameContainer.reference.game.triggers["Quickstart"] == 1){
				trace("World.as/newGame2() - Adding quickstart equipment");
				GameContainer.reference.game.runScript("giveQuickstartItems");
				GameContainer.reference.game.setTrigger("Quickstart", 0);
			}
			
			ng_wait = 0;
		}
		
		public function loadGame(nload:int = 0):void {
			time___metr();
			comLoad = -1;
			
			if (loc) {
				loc.out();
			}
			
			land = null;
			loc = null;

			cur('arrow');

			// Attempt to load saved data
			var data:Object;
			if (nload == 99) {
				data = loaddata;
			}
			else {
				data = saveArr[nload].data;
			}

			// [Create a game]
			Sound.setTempMute(true);
			
			GameContainer.reference.cam.showOn = false;
			
			if (data.hardInv == true) {
				hardInv = true;
			}
			else {
				hardInv = false;
			}
			
			GameContainer.reference.game = new Game();
			
			GameContainer.reference.game.init(data.game);
			GUIManager.reference.app.load(data.app);
			
			// [Create a character]
			GameContainer.reference.pers = new Pers(data.pers);
			
			// Create a new player unit
			GameContainer.reference.gg = new UnitPlayer();
			GameContainer.reference.gg.ctr = GameContainer.reference.ctr;
			GameContainer.reference.gg.sats = GUIManager.reference.sats;
			GUIManager.reference.sats.gg = GameContainer.reference.gg;
			GUIManager.reference.gui.gg = GameContainer.reference.gg;
			
			// Create inventory and load saved inventory
			GameContainer.reference.invent = new Inventory();
			GameContainer.reference.vault = new Inventory();
			
			if (GUIManager.reference.stand) {
				GUIManager.reference.stand.inv = GameContainer.reference.invent;
			}
			else {
				GUIManager.reference.stand = new Stand(GUIManager.reference.vstand, GameContainer.reference.invent);
			}
			
			GameContainer.reference.gg.attach(data.invent);
			
			// [Autosave cell number]
			if (data.n != null) {
				autoSaveN = data.n;
			}
			
			offLoadScreen();
			GUIManager.reference.vgui.visible = true;
			GUIManager.reference.vfon.visible = true;
			GUIManager.reference.visual.visible = true;
			GUIManager.reference.vblack.alpha = 1;
			GameContainer.reference.cam.dblack = -10;
			
			GUIManager.reference.pip.onoff(-1);
			GUIManager.reference.gui.allOn();
			
			deathState = E_DeathState.NONE;
			t_battle=0;
			time___metr('Character');
			
			// [Enter the current area]
			GameContainer.reference.game.enterToCurLand();		//!!!!
			
			log = "";
			
			Sound.setTempMute(false);
			GUIManager.reference.gui.setAll();
			
			allStat = 1;
		}
		
		// [Call upon entering a specific area]
		public function ativateLand(nland:Land):void {
			land = nland;
			GameContainer.reference.grafon.drawFon(GUIManager.reference.vfon, land.act.fon);
		}
		
		// [Call when entering a specific location]
		// [There's a graphical bug here]
		public function ativateLoc(nloc:Location):void {
			if (loc) loc.out();
			loc = nloc;
			GameContainer.reference.grafon.drawLoc(loc);
			GameContainer.reference.cam.setLoc(loc);
			GameContainer.reference.grafon.setFonSize(GameContainer.reference.screenWidth,GameContainer.reference.screenHeight);
			GUIManager.reference.gui.setAll();
			Sound.playMusic(loc.sndMusic);
			GUIManager.reference.gui.hpBarBoss();
			
			if (deathState == E_DeathState.NONE) {
				GameContainer.reference.gg.controlOn();
			}
			
			GUIManager.reference.gui.dialText();
			GameContainer.reference.pers.invMassParam();
			gc();	// Run garbage collection if required
		}
		
		public function redrawLoc():void {
			GameContainer.reference.grafon.drawLoc(loc);
			GameContainer.reference.cam.setLoc(loc);
			GUIManager.reference.gui.setAll();
		}
		
		public function exitLand(fast:Boolean=false):void {
			if (exitState != E_ExitState.NONE) return;
			GameContainer.reference.gg.controlOff();
			GUIManager.reference.pip.noAct=true;

			// A fast exit skips the fade by starting on its last frame
			exitState = fast ? E_ExitState.FADE_OUT : E_ExitState.LEAVING;
			t_exit = 1;
		}

		// Counts down the current exit stage; when it runs out, the next stage starts and does its work
		private function exitStep():void {
			t_exit--;
			if (t_exit > 0) { return; }

			switch (exitState) {
				case E_ExitState.LEAVING: {
					exitState = E_ExitState.FADE_OUT;
					t_exit = EXIT_FADE_OUT_FRAMES;
					GameContainer.reference.cam.dblack = 1.5;
					break;
				}
				case E_ExitState.FADE_OUT: {
					exitState = E_ExitState.LOAD_SCREEN;
					t_exit = 1;
					GUIManager.reference.vblack.alpha = 0;
					GameContainer.reference.cam.dblack = 0;
					setLoadScreen(getLoadScreen());
					Sound.setTempMute(true);
					break;
				}
				case E_ExitState.LOAD_SCREEN: {
					exitState = E_ExitState.ENTER_LAND;
					t_exit = 1;
					cur('arrow');
					GameContainer.reference.game.enterToCurLand();
					break;
				}
				case E_ExitState.ENTER_LAND: {
					exitState = E_ExitState.PROMPT;
					t_exit = 1;
					if (clickReq > 0) {
						waitLoadClick();
					}
					break;
				}
				case E_ExitState.PROMPT: {
					exitState = E_ExitState.WAIT;
					t_exit = 1;
					break;
				}
				case E_ExitState.WAIT: {
					exitState = E_ExitState.FADE_IN;
					t_exit = EXIT_FADE_IN_FRAMES;
					Mouse.show();
					Sound.setTempMute(false);
					offLoadScreen();
					GUIManager.reference.vgui.visible = true;
					GUIManager.reference.vfon.visible = true;
					GUIManager.reference.visual.visible = true;
					GUIManager.reference.vblack.alpha = 1;
					GameContainer.reference.cam.dblack = -10;
					GameContainer.reference.gg.controlOn();
					GUIManager.reference.pip.noAct = false;
					break;
				}
				case E_ExitState.FADE_IN: {
					exitState = E_ExitState.SHOW_GUI;
					t_exit = 1;
					GUIManager.reference.gui.allOn();
					break;
				}
				case E_ExitState.SHOW_GUI: {
					exitState = E_ExitState.NONE;
					break;
				}
			}
		}

		// Counts down the current death stage; when it runs out, the next stage starts and does its work
		private function ggDieStep():void {
			t_die--;
			if (t_die > 0) { return; }

			switch (deathState) {
				case E_DeathState.DYING: {
					deathState = E_DeathState.FADE_OUT;
					t_die = DEATH_FADE_OUT_FRAMES;
					GameContainer.reference.cam.dblack = 2.2;
					break;
				}
				case E_DeathState.FADE_OUT: {
					if (alicorn) {
						deathState = E_DeathState.NONE;
						GameContainer.reference.game.runScript('gameover');
					}
					else {
						deathState = E_DeathState.RESPAWN;
						t_die = DEATH_RESPAWN_FRAMES;

						if (GameContainer.reference.gg.sost == 3) {
							GameContainer.reference.game.curLandId = GameContainer.reference.game.baseId;
							GameContainer.reference.game.enterToCurLand();
						}
						else {
							land.gotoCheckPoint();
						}

						GameContainer.reference.cam.dblack = -4;
						GameContainer.reference.gg.vis.visible = true;
					}
					break;
				}
				case E_DeathState.RESPAWN: {
					deathState = E_DeathState.RESURRECT;
					t_die = DEATH_RESURRECT_FRAMES;
					GameContainer.reference.gg.resurect();
					break;
				}
				case E_DeathState.RESURRECT: {
					deathState = E_DeathState.CONTROL;
					t_die = 1;
					GameContainer.reference.gg.controlOn();
					break;
				}
				case E_DeathState.CONTROL: {
					deathState = E_DeathState.NONE;
					break;
				}
			}
		}

		// Starts the death sequence; the screen fades once the death animation has played for dyingFrames
		public function startDeath(dyingFrames:int):void {
			deathState = E_DeathState.DYING;
			t_die = dyingFrames;
		}

		//Main Loop
		public function step():void {
			
			if (GUIManager.reference.verror.visible) {
				return;
			}
			
			GameContainer.reference.ctr.step();	// Player input			
			Sound.step();	// Sound
			
			if (ng_wait > 0) {
				if (ng_wait == 1) {
					newGame1();
				}
				else if (ng_wait == 2) {
					if (clickReq != 1) {
						newGame2();
					}
				}
				return;
			}
			
			// [Only if the game has started and is not paused, game loops]
			if (allStat==1 && !GameContainer.reference.onPause) {
				// [exit cycle]
				if (exitState != E_ExitState.NONE) {
					if (!(exitState == E_ExitState.WAIT && clickReq == 1)) exitStep();
				}
				
				// [Particle counting]
				Emitter.kol2 = Emitter.kol1;
				Emitter.kol1 = 0;
				
				// [Main loop] !!!!
				if (exitState != E_ExitState.WAIT) land.step();
				
				// [Cycle of death]
				if (deathState != E_DeathState.NONE) ggDieStep();
				
				// [Battle timer]
				if (t_battle>0) t_battle--;
				
				GUIManager.reference.sats.step2();

				// [if you need to recalculate the mass]
				if (calcMass) {
					ItemInteraction.calcMass(GameContainer.reference.invent);
					calcMass = false;
				}
				if (calcMassW) {
					ItemInteraction.calcWeaponMass(GameContainer.reference.invent);
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
					GUIManager.reference.pip.onoff(-1);
					comLoad += 100;
					setLoadScreen();
				}
			}
			
			//If the game has started, but paused
			if (allStat>=1) {
				GameContainer.reference.cam.calc(GameContainer.reference.gg);
				GUIManager.reference.gui.step();
				GUIManager.reference.pip.step();
				GUIManager.reference.sats.step();
				
				if (GameContainer.reference.ctr.keyPip) {
					if (!GUIManager.reference.sats.active) GUIManager.reference.pip.onoff();
					GameContainer.reference.ctr.keyPip=false;
				}
				
				if (GameContainer.reference.ctr.keyInvent) {
					if (!GUIManager.reference.sats.active) GUIManager.reference.pip.onoff(2);
					GameContainer.reference.ctr.keyInvent=false;
				}
				
				if (GameContainer.reference.ctr.keyStatus) {
					if (!GUIManager.reference.sats.active) GUIManager.reference.pip.onoff(1,1);
					GameContainer.reference.ctr.keyStatus=false;
				}
				
				if (GameContainer.reference.ctr.keySkills) {
					if (!GUIManager.reference.sats.active) GUIManager.reference.pip.onoff(1,2);
					GameContainer.reference.ctr.keySkills=false;
				}
				
				if (GameContainer.reference.ctr.keyMed) {
					if (!GUIManager.reference.sats.active) GUIManager.reference.pip.onoff(1,5);
					GameContainer.reference.ctr.keyMed=false;
				}
				
				if (GameContainer.reference.ctr.keyMap) {
					if (!GUIManager.reference.sats.active) GUIManager.reference.pip.onoff(3,1);
					GameContainer.reference.ctr.keyMap=false;
				}
				
				if (GameContainer.reference.ctr.keyQuest) {
					if (!GUIManager.reference.sats.active) GUIManager.reference.pip.onoff(3,2);
					GameContainer.reference.ctr.keyQuest=false;
				}
				
				if (GameContainer.reference.ctr.keySats) {
					if (GameContainer.reference.gg.ggControl && !GUIManager.reference.pip.active && GameContainer.reference.gg && GameContainer.reference.gg.pipOff<=0 && !catPause) {
						GUIManager.reference.sats.onoff();
					}
					GameContainer.reference.ctr.keySats = false;
				}
				
				allStat = (GUIManager.reference.pip.active || GUIManager.reference.sats.active || GUIManager.reference.stand.active || GUIManager.reference.gui.guiPause) ? 2 : 1;
			}
		}

//=============================================================================================================
//			[Global Interaction Features]
//=============================================================================================================
		
		public function cur(ncur:String = 'arrow'):void {
			if (sysCur) {
				return;
			}
			
			if (GUIManager.reference.pip.active || GUIManager.reference.stand.active || comLoad >= 0) {
				ncur = 'arrow';
			}
			else if (t_battle > 0) {
				ncur = 'combat';
			}
			
			if (ncur != ccur) {
				Mouse.cursor = ncur;
				Mouse.show();
				ccur = ncur;
			}
		}
		
		public function quake(x:Number, y:Number):void {
			if (loc.sky) {
				return;
			}

			if (quakeCam) {
				GameContainer.reference.cam.quakeX += x;
				GameContainer.reference.cam.quakeY += y;
				// Clamp camera shaking
				if (GameContainer.reference.cam.quakeX >  20) GameContainer.reference.cam.quakeX =  20;
				if (GameContainer.reference.cam.quakeX < -20) GameContainer.reference.cam.quakeX = -20;
				if (GameContainer.reference.cam.quakeY >  20) GameContainer.reference.cam.quakeY =  20;
				if (GameContainer.reference.cam.quakeY < -20) GameContainer.reference.cam.quakeY = -20;
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
		
		// Error message that displays during gameplay
		public function showError(err:Error, dop:String = null):void {
			if (!errorShow || !errorShowOpt) {
				return;
			}

			GUIManager.reference.verror.info.text=LanguageManager.reference.localText("pip", 'error');
			GUIManager.reference.verror.butClose.text.text=LanguageManager.reference.localText("pip", 'err_close');
			GUIManager.reference.verror.butForever.text.text=LanguageManager.reference.localText("pip", 'err_dont_show');
			GUIManager.reference.verror.butCopy.text.text=LanguageManager.reference.localText("pip", 'err_copy_to_clipboard');

			GUIManager.reference.verror.txt.text=err.message+'\n'+err.getStackTrace();
			GUIManager.reference.verror.txt.text+='\n'+'gr_stage: '+gr_stage;
			
			if (dop != null) {
				GUIManager.reference.verror.txt.text += '\n' + dop;
			}
			
			GUIManager.reference.verror.visible = true;
		}
		
		// [Action measurement time]
		public function time___metr(message:String = null):void {
			d2 = getTimer();
			var timeDif:int = d2 - d1;
			
			if (message != null) {
				trace("time__metr -- " + message + ': ' + timeDif.toString());
			}
			
			d1 = d2;
		}
		
		public function gc():void {
			System.pauseForGCIfCollectionImminent(0.25);
		}
		
//=============================================================================================================
//			Loading screen
//=============================================================================================================
		
		// [Set loading screen]
		public function setLoadScreen(n:int=-1):void {
			loadScreen=n;
			GUIManager.reference.vwait.story.lmb.stop();
			GUIManager.reference.vwait.story.lmb.visible=false;
			GUIManager.reference.vgui.visible=GUIManager.reference.vfon.visible=GUIManager.reference.visual.visible=GUIManager.reference.vscene.visible=false;
			GUIManager.reference.vwait.visible=true;
			catPause=false;
			GUIManager.reference.vwait.progres.text=TextParser.txt("g", 'loading');
			
			if (n < 0) {
				GUIManager.reference.vwait.x = GameContainer.reference.screenWidth / 2;
				GUIManager.reference.vwait.y = GameContainer.reference.screenHeight / 2;
				GUIManager.reference.vwait.skill.gotoAndStop(Math.floor(Math.random() * GUIManager.reference.vwait.skill.totalFrames + 1));
				GUIManager.reference.vwait.skill.visible = true;
				GUIManager.reference.vwait.progres.visible = true;
				GUIManager.reference.vwait.story.visible = false;
				clickReq = 0;
			} 
			else {
				GUIManager.reference.vwait.x = 0;
				GUIManager.reference.vwait.y = 0;
				GUIManager.reference.vwait.story.visible = true;
				GUIManager.reference.vwait.skill.visible = false;
				GUIManager.reference.vwait.progres.visible = false;
				
				if (n == 0) {
					GUIManager.reference.vwait.story.txt.htmlText = '<i>' + TextParser.txt("g", 'story') + '</i>';
				}
				else {
					GUIManager.reference.vwait.story.txt.htmlText = '<i>' + 'История' + n + '</i>';
				}
				
				clickReq = 1;
			}
			
			GUIManager.reference.vwait.cacheAsBitmap = false;
			GUIManager.reference.vwait.cacheAsBitmap = true;
		}
		
		// [Define which loading screen to show]
		private function getLoadScreen():int { 
			return -1; // ONLY SHOWED -1 by default, removed impossible to reach code.
		}
		
		//включить ожидание клика
		private function waitLoadClick():void {
			GUIManager.reference.vwait.story.lmb.play();
			GUIManager.reference.vwait.story.lmb.visible=true;
		}
		
		//убрать экран загрузки
		private function offLoadScreen():void {
			GUIManager.reference.vwait.visible=false;
			GUIManager.reference.vwait.story.visible=false;
			GUIManager.reference.vwait.skill.visible=GUIManager.reference.vwait.progres.visible=true;
			GUIManager.reference.vwait.story.lmb.stop();
			GUIManager.reference.vwait.story.lmb.visible=false;
			clickReq = 0;
		}

		//показать сцену
		public function showScene(sc:String, n:int=0):void {
			catPause=true;
			GUIManager.reference.visual.visible=false;
			GUIManager.reference.gui.allOff();
			GUIManager.reference.gui.offCelObj();
			try {
				GUIManager.reference.vscene.gotoAndStop(sc);
			} 
			catch(err) {
				trace('ERROR: (00:20)');
				GUIManager.reference.vscene.gotoAndStop(1);
			}

			if (n>0) {
				GUIManager.reference.vscene.sc.gotoAndPlay(n);
			}
			else {
				GUIManager.reference.vscene.sc.gotoAndPlay(1);
			}

			GUIManager.reference.vscene.visible = true;
		}
		
		//убрать сцену
		public function unshowScene():void {
			catPause=false;
			GUIManager.reference.visual.visible=true;
			GUIManager.reference.gui.allOn();
			GUIManager.reference.vscene.gotoAndStop(1);
			GUIManager.reference.vscene.visible=false;
		}
		
		//финальная заставка или gameover
		public function endgame(n:int=0):void {
			GUIManager.reference.vwait.visible=GUIManager.reference.vfon.visible = false;
			var s:String;
			if (n==1) {
				showScene('gameover');
				s=TextParser.lpName(TextParser.txt("g", 'end_bad'));
			} 
			else if (GameContainer.reference.pers.rep>=GameContainer.reference.pers.repGood) {
				showScene('endgame');
				s=TextParser.lpName(TextParser.txt("g", 'end_good'));
				Sound.playMusic('music_fall_2');
			} 
			else {
				showScene('endgame');
				s=TextParser.lpName(TextParser.txt("g", 'end_norm'));
			}

			GUIManager.reference.vscene.sc.txt.htmlText = s;
		}

//=============================================================================================================
//			Saves and config
//=============================================================================================================
		
		public function saveToObj(data:Object):void {
			var now:Date = new Date();
			data.game = GameContainer.reference.game.save();
			data.pers = GameContainer.reference.pers.save();
			data.invent = GameContainer.reference.gg.itemInteraction.save();
			data.app = GUIManager.reference.app.save();
			data.date = now.time;
			data.n = autoSaveN;
			data.hardInv = hardInv;
			data.ver = GameContainer.reference.version;
			data.est = 1;
		}
		
		public function saveGame(n:int=-1):void {
			if (n == -2) {
				n = autoSaveN;
				var save = saveArr[n];
				saveToObj(save.data);
				save.flush();	// Save SharedObject to disk
				trace('World.as/saveGame() - End');
				return;
			}
			
			if (t_save<100 && n==-1 && !GameContainer.reference.pers.hardcore) {
				return;
			}
			
			if (GUIManager.reference.pip.noAct) {
				return;
			}
			
			if (n == -1) {
				n = autoSaveN;
			}
			
			var save = saveArr[n];
			
			if (save is SharedObject) {
				saveToObj(save.data);
				var r = save.flush();	// Save SharedObject to disk
				trace("World.as/saveGame() - Saving: " + r);
				if (n == 0) {
					t_save = 0;
				}
			}
		}
		
		public function getSave(n:int):Object {
			if (saveArr[n] is SharedObject) {
				return saveArr[n].data;
			}
			else {
				return null;
			}
		}
		
		public function saveConfig():void {
			try {
				configObj.data.ctr=GameContainer.reference.ctr.save();
				configObj.data.snd=Sound.save();
				configObj.data.language = LanguageManager.reference.currentLanguage;
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
				configObj.data.app=GUIManager.reference.app.save();
				
				if (lastCom != null) {
					configObj.data.lastCom = lastCom;
				}
					
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
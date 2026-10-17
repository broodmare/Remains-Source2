package fe.game {

    import flash.ui.Mouse;
	import flash.system.System;

	import fe.game.enums.E_DeathState;
	import fe.game.enums.E_ExitState;
	import fe.game.rendering.Emitter;
	import fe.game.domain.serv.LootGen;
	import fe.game.domain.units.Unit;
	import fe.game.domain.units.UnitPlayer;
	import fe.game.domain.units.Inventory;
	import fe.game.domain.units.Pers;
	import fe.game.domain.location.tile.TileRegistry;
	import fe.game.domain.location.Level;
	import fe.game.domain.location.Location;
	import fe.game.domain.location.factories.LevelLoader;
	import fe.game.domain.location.Game;
	import fe.game.ui.GUI;
	import fe.game.ui.GUIManager;
	import fe.game.ui.Sats;
	import fe.game.ui.Stand;
	import fe.engine.Engine;
	import fe.engine.SaveManager;
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
		public var land:Level;									// [Current land]
		public var loc:Location;								// [Current location]
		public var rooms:Array;
		
		// [Location maps]
		public var fileVersion:int				= 2;			// [Change this number to reset the cache]
		public var landData:Array;
		public var kolLevels:int					= 0;
		public var kolLevelsLoaded:int			= 0;
		public var allLevelsLoaded:Boolean		= false;
		
		public var comLoad:int					= -1;			//команда на загрузку
		public var clickReq:int					=  0;			//запрос нажатия кнопки, если установить в 1, то 2 установится только после нажатия
		public var ng_wait:int					=  0;			//начало новой игры, ожидание
		public var loadScreen:int				= -1;			//загрузочный экран
		public var autoSaveN:int				=  0;			//номер ячейки автосейва
		public var log:String					= "";
		
		public var landError:Boolean			= false;

		public function World() {

			World.w = this;			// Store a publically accessable reference to itself

			LootGen.init();

			TileRegistry.load();

			Emitter.init();

			GameContainer.reference.load_log+='Stage 1 Ok\n';
		}

//=============================================================================================================
//			[Technical part]
//=============================================================================================================
		
		public function init2():void {
			// [Loading location maps]
			landData = [];
			
			var xmlList:XMLList = XMLDataGrabber.getNodesWithName("core", "GameData", "Levels", "land");
			for each(var xl:XML in xmlList) {
				if (!GameContainer.reference.testMode && xl.@test>0) continue;
				var ll:LevelLoader=new LevelLoader(xl.@id);
				if (!(xl.@test>0)) kolLevels++;
				landData[xl.@id]=ll;
			}
			xmlList = null; // Manual cleanup

			GameContainer.reference.load_log += 'Stage 2 Ok\n';
		}

		public function roomsLoadOk():void {
			if (!GameContainer.reference.roomsLoad) {
				allLevelsLoaded = true;
				return;
			}
			kolLevelsLoaded++;
			if (kolLevels == kolLevelsLoaded) allLevelsLoaded = true;
		}

		//Пауза и вызов пипбака если потерян фокус
		public function onDeactivate():void {
			if (GameContainer.reference.allStat==1) GUIManager.reference.pip.onoff(11);
			if (GameContainer.reference.allStat>0 && !GameContainer.reference.alicorn) SaveManager.reference.saveGame();
		}
		
		//Пауза и вызов пипбака если изменён размер окна
		public function resizeScreen():void {
			if (GameContainer.reference.allStat>0) GameContainer.reference.cam.setLoc(loc);
			if (GUIManager.reference.gui) GUIManager.reference.gui.resizeScreen(GameContainer.reference.screenWidth,GameContainer.reference.screenHeight);
			GUIManager.reference.pip.resizeScreen(GameContainer.reference.screenWidth,GameContainer.reference.screenHeight);
			GameContainer.reference.renderer.setSkySize(GameContainer.reference.screenWidth,GameContainer.reference.screenHeight);
			if (GUIManager.reference.stand) GUIManager.reference.stand.resizeScreen(GameContainer.reference.screenWidth,GameContainer.reference.screenHeight);
			GUIManager.reference.vblack.width=GameContainer.reference.screenWidth;
			GUIManager.reference.vblack.height=GameContainer.reference.screenHeight;
			if (loadScreen<0) {
				GUIManager.reference.vwait.x=GameContainer.reference.screenWidth/2;
				GUIManager.reference.vwait.y=GameContainer.reference.screenHeight/2;
			}
			if (GameContainer.reference.allStat==1 && !GameContainer.reference.testMode) GUIManager.reference.pip.onoff(11);
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
			if (GameContainer.reference.testMode && !GameContainer.reference.chitOn) {
				GUIManager.reference.vwait.progres.text = 'error';
				return;
			}

			Engine.reference.time___metr();
			GameContainer.reference.allStat=-1;
			opt=nopt;
			newName=nnewName;
			GameContainer.reference.game=new Game();
			
			if (!GameContainer.reference.roomsLoad) {
				allLevelsLoaded=true;
			}
			
			ng = nload < 0;
			
			if (ng) {
				if (opt && opt.autoSaveN) {
					autoSaveN=opt.autoSaveN;
					nload=autoSaveN;
				}
				else nload=0;
				SaveManager.reference.clearSave(nload);
			}
			
			//создать GUI
			GUIManager.reference.gui=new GUI(GUIManager.reference.vgui);
			GUIManager.reference.gui.resizeScreen(GameContainer.reference.screenWidth,GameContainer.reference.screenHeight);
			//перевести пипбак в игровой режим
			GUIManager.reference.pip.toNormalMode();
			GUIManager.reference.pip.resizeScreen(GameContainer.reference.screenWidth,GameContainer.reference.screenHeight);
			//создать интерфейс ЗПС
			GUIManager.reference.sats=new Sats(GUIManager.reference.vsats);
			Engine.reference.time___metr('Interface');
			
			// [Create a game]
			if (nload == 99) {
				data=SaveManager.reference.loaddata;	// [was loading from a file]
			}
			else {
				data = SaveManager.reference.getSave(nload); // [there was loading from the slot]
			}
			
			if (ng)	{
				GameContainer.reference.game.init(null, opt);
			}
			else {
				GameContainer.reference.game.init(data.game);
			}
			
			ng_wait = 1;
			Engine.reference.time___metr('Game init');
		}
		
		// [Stage 1 - Create a character and inventory]
		public function newGame1():void {
			if (!ng) {
				GUIManager.reference.app.load(data.app);
			}
			
			if (data.hardInv == true) {
				GameContainer.reference.hardInv = true;
			}
			else {
				GameContainer.reference.hardInv = false;
			}
			
			if (opt && opt.hardinv) {
				GameContainer.reference.hardInv = true;
			}
			
			// [Create a character]
			GameContainer.reference.pers = new Pers(data.pers, opt);
			
			if (ng) {
				GameContainer.reference.pers.persName = newName;
			}
			
			// The last game's player hands back its GPU art
			if (GameContainer.reference.gg) {
				GameContainer.reference.gg.pony.removeFromParent(true);
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
			
			Engine.reference.time___metr('Character');
			
			// [Autosave cell number]
			if (!ng && data.n != null) {
				autoSaveN = data.n;
			}
			
			Unit.txtMiss = TextParser.txt("g", 'miss');
			
			waitLoadClick();
			ng_wait = 2;
			Engine.reference.time___metr('Terrain');
		}
		
		// [Stage 2 - Create a terrain and enter it]
		public function newGame2():void {
			//визуальная часть
			resizeScreen();
			offLoadScreen();
			GUIManager.reference.vgui.visible = true;
			GUIManager.reference.sky.visible = true;
			GUIManager.reference.visual.visible = true;
			GUIManager.reference.vblack.alpha=1;
			GameContainer.reference.cam.dblack=-10;
			GUIManager.reference.pip.onoff(-1);
			// [Enter the current area]
			GameContainer.reference.game.enterToCurLevel();//!!!!
			Sound.setTempMute(false);
			GUIManager.reference.gui.setAll();
			GameContainer.reference.allStat = 1;
			
			if (GameContainer.reference.game.triggers["Quickstart"] == 1){
				trace("World.as/newGame2() - Adding quickstart equipment");
				GameContainer.reference.game.runScript("giveQuickstartItems");
				GameContainer.reference.game.setTrigger("Quickstart", 0);
			}
			
			ng_wait = 0;
		}
		
		public function loadGame(nload:int = 0):void {
			Engine.reference.time___metr();
			comLoad = -1;
			
			if (loc) {
				loc.out();
			}
			
			land = null;
			loc = null;

			GameContainer.reference.cur('arrow');

			// Attempt to load saved data
			var data:Object;
			if (nload == 99) {
				data = SaveManager.reference.loaddata;
			}
			else {
				data = SaveManager.reference.getSave(nload);
			}

			// [Create a game]
			Sound.setTempMute(true);
			
			GameContainer.reference.cam.showOn = false;
			
			if (data.hardInv == true) {
				GameContainer.reference.hardInv = true;
			}
			else {
				GameContainer.reference.hardInv = false;
			}
			
			GameContainer.reference.game = new Game();
			
			GameContainer.reference.game.init(data.game);
			GUIManager.reference.app.load(data.app);
			
			// [Create a character]
			GameContainer.reference.pers = new Pers(data.pers);
			
			// The last game's player hands back its GPU art
			if (GameContainer.reference.gg) {
				GameContainer.reference.gg.pony.removeFromParent(true);
			}
			
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
			GUIManager.reference.sky.visible = true;
			GUIManager.reference.visual.visible = true;
			GUIManager.reference.vblack.alpha = 1;
			GameContainer.reference.cam.dblack = -10;
			
			GUIManager.reference.pip.onoff(-1);
			GUIManager.reference.gui.allOn();
			
			GameContainer.reference.deathState = E_DeathState.NONE;
			GameContainer.reference.t_battle=0;
			Engine.reference.time___metr('Character');
			
			// [Enter the current area]
			GameContainer.reference.game.enterToCurLevel();		//!!!!
			
			log = "";
			
			Sound.setTempMute(false);
			GUIManager.reference.gui.setAll();
			
			GameContainer.reference.allStat = 1;
		}
		
		// [Call upon entering a specific area]
		public function ativateLevel(nland:Level):void {
			land = nland;
			GameContainer.reference.renderer.drawSky(GUIManager.reference.sky, land.act.fon);
			GameContainer.reference.renderer.keepLevelSheets(land);
		}
		
		// [Call when entering a specific location]
		// [There's a graphical bug here]
		public function ativateLoc(nloc:Location):void {
			if (loc) loc.out();
			loc = nloc;
			GameContainer.reference.renderer.drawLoc(loc);
			GameContainer.reference.cam.setLoc(loc);
			GameContainer.reference.renderer.setSkySize(GameContainer.reference.screenWidth,GameContainer.reference.screenHeight);
			GUIManager.reference.gui.setAll();
			Sound.playMusic(loc.sndMusic);
			GUIManager.reference.gui.hpBarBoss();
			
			if (GameContainer.reference.deathState == E_DeathState.NONE) {
				GameContainer.reference.gg.controlOn();
			}
			
			GUIManager.reference.gui.dialText();
			GameContainer.reference.pers.invMassParam();
			gc();	// Run garbage collection if required
		}
		
		public function redrawLoc():void {
			GameContainer.reference.renderer.drawLoc(loc);
			GameContainer.reference.cam.setLoc(loc);
			GUIManager.reference.gui.setAll();
		}
		
		public function exitLevel(fast:Boolean=false):void {
			if (GameContainer.reference.exitState != E_ExitState.NONE) return;
			GameContainer.reference.gg.controlOff();
			GUIManager.reference.pip.noAct=true;

			// A fast exit skips the fade by starting on its last frame
			GameContainer.reference.exitState = fast ? E_ExitState.FADE_OUT : E_ExitState.LEAVING;
			GameContainer.reference.t_exit = 1;
		}

		// Counts down the current exit stage; when it runs out, the next stage starts and does its work
		private function exitStep():void {
			GameContainer.reference.t_exit--;
			if (GameContainer.reference.t_exit > 0) { return; }

			switch (GameContainer.reference.exitState) {
				case E_ExitState.LEAVING: {
					GameContainer.reference.exitState = E_ExitState.FADE_OUT;
					GameContainer.reference.t_exit = EXIT_FADE_OUT_FRAMES;
					GameContainer.reference.cam.dblack = 1.5;
					break;
				}
				case E_ExitState.FADE_OUT: {
					GameContainer.reference.exitState = E_ExitState.LOAD_SCREEN;
					GameContainer.reference.t_exit = 1;
					GUIManager.reference.vblack.alpha = 0;
					GameContainer.reference.cam.dblack = 0;
					setLoadScreen(getLoadScreen());
					Sound.setTempMute(true);
					break;
				}
				case E_ExitState.LOAD_SCREEN: {
					GameContainer.reference.exitState = E_ExitState.ENTER_LAND;
					GameContainer.reference.t_exit = 1;
					GameContainer.reference.cur('arrow');
					GameContainer.reference.game.enterToCurLevel();
					break;
				}
				case E_ExitState.ENTER_LAND: {
					GameContainer.reference.exitState = E_ExitState.PROMPT;
					GameContainer.reference.t_exit = 1;
					if (clickReq > 0) {
						waitLoadClick();
					}
					break;
				}
				case E_ExitState.PROMPT: {
					GameContainer.reference.exitState = E_ExitState.WAIT;
					GameContainer.reference.t_exit = 1;
					break;
				}
				case E_ExitState.WAIT: {
					GameContainer.reference.exitState = E_ExitState.FADE_IN;
					GameContainer.reference.t_exit = EXIT_FADE_IN_FRAMES;
					Mouse.show();
					Sound.setTempMute(false);
					offLoadScreen();
					GUIManager.reference.vgui.visible = true;
					GUIManager.reference.sky.visible = true;
					GUIManager.reference.visual.visible = true;
					GUIManager.reference.vblack.alpha = 1;
					GameContainer.reference.cam.dblack = -10;
					GameContainer.reference.gg.controlOn();
					GUIManager.reference.pip.noAct = false;
					break;
				}
				case E_ExitState.FADE_IN: {
					GameContainer.reference.exitState = E_ExitState.SHOW_GUI;
					GameContainer.reference.t_exit = 1;
					GUIManager.reference.gui.allOn();
					break;
				}
				case E_ExitState.SHOW_GUI: {
					GameContainer.reference.exitState = E_ExitState.NONE;
					break;
				}
			}
		}

		// Counts down the current death stage; when it runs out, the next stage starts and does its work
		private function ggDieStep():void {
			GameContainer.reference.t_die--;
			if (GameContainer.reference.t_die > 0) { return; }

			switch (GameContainer.reference.deathState) {
				case E_DeathState.DYING: {
					GameContainer.reference.deathState = E_DeathState.FADE_OUT;
					GameContainer.reference.t_die = DEATH_FADE_OUT_FRAMES;
					GameContainer.reference.cam.dblack = 2.2;
					break;
				}
				case E_DeathState.FADE_OUT: {
					if (GameContainer.reference.alicorn) {
						GameContainer.reference.deathState = E_DeathState.NONE;
						GameContainer.reference.game.runScript('gameover');
					}
					else {
						GameContainer.reference.deathState = E_DeathState.RESPAWN;
						GameContainer.reference.t_die = DEATH_RESPAWN_FRAMES;

						if (GameContainer.reference.gg.sost == 3) {
							GameContainer.reference.game.curLevelId = GameContainer.reference.game.baseId;
							GameContainer.reference.game.enterToCurLevel();
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
					GameContainer.reference.deathState = E_DeathState.RESURRECT;
					GameContainer.reference.t_die = DEATH_RESURRECT_FRAMES;
					GameContainer.reference.gg.resurect();
					break;
				}
				case E_DeathState.RESURRECT: {
					GameContainer.reference.deathState = E_DeathState.CONTROL;
					GameContainer.reference.t_die = 1;
					GameContainer.reference.gg.controlOn();
					break;
				}
				case E_DeathState.CONTROL: {
					GameContainer.reference.deathState = E_DeathState.NONE;
					break;
				}
			}
		}

		// Starts the death sequence; the screen fades once the death animation has played for dyingFrames
		public function startDeath(dyingFrames:int):void {
			GameContainer.reference.deathState = E_DeathState.DYING;
			GameContainer.reference.t_die = dyingFrames;
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
			if (GameContainer.reference.allStat==1 && !GameContainer.reference.onPause) {
				// [exit cycle]
				if (GameContainer.reference.exitState != E_ExitState.NONE) {
					if (!(GameContainer.reference.exitState == E_ExitState.WAIT && clickReq == 1)) exitStep();
				}
				
				// [Particle counting]
				Emitter.kol2 = Emitter.kol1;
				Emitter.kol1 = 0;
				
				// [Main loop] !!!!
				if (GameContainer.reference.exitState != E_ExitState.WAIT) land.step();
				
				// [Cycle of death]
				if (GameContainer.reference.deathState != E_DeathState.NONE) ggDieStep();
				
				// [Battle timer]
				if (GameContainer.reference.t_battle>0) GameContainer.reference.t_battle--;
				
				GUIManager.reference.sats.step2();

				// [if you need to recalculate the mass]
				if (GameContainer.reference.calcMass) {
					ItemInteraction.calcMass(GameContainer.reference.invent);
					GameContainer.reference.calcMass = false;
				}
				if (GameContainer.reference.calcMassW) {
					ItemInteraction.calcWeaponMass(GameContainer.reference.invent);
					GameContainer.reference.calcMassW = false;
				}

				// [Saving]
				SaveManager.reference.t_save++;
				if (SaveManager.reference.t_save > 5000 && !GameContainer.reference.testMode && !GameContainer.reference.alicorn) {
					SaveManager.reference.saveGame();
				}

				AutoPickupManager.reference.checkLoot = false;
			}
			
			if (comLoad >= 0) {
				if (comLoad >= 100) {
					if (autoSaveN > 0) SaveManager.reference.saveGame();
					loadGame(comLoad - 100);
				}
				else {
					GUIManager.reference.pip.onoff(-1);
					comLoad += 100;
					setLoadScreen();
				}
			}
			
			//If the game has started, but paused
			if (GameContainer.reference.allStat>=1) {
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
					if (GameContainer.reference.gg.ggControl && !GUIManager.reference.pip.active && GameContainer.reference.gg && GameContainer.reference.gg.pipOff<=0 && !GameContainer.reference.catPause) {
						GUIManager.reference.sats.onoff();
					}
					GameContainer.reference.ctr.keySats = false;
				}
				
				GameContainer.reference.allStat = (GUIManager.reference.pip.active || GUIManager.reference.sats.active || GUIManager.reference.stand.active || GUIManager.reference.gui.guiPause) ? 2 : 1;
			}
		}

//=============================================================================================================
//			[Global Interaction Features]
//=============================================================================================================
		
		public function quake(x:Number, y:Number):void {
			if (loc.sky) {
				return;
			}

			if (GameContainer.reference.quakeCam) {
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
			if (GameContainer.reference.t_battle > 0) {
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
			if (!GameContainer.reference.errorShow || !GameContainer.reference.errorShowOpt) {
				return;
			}

			GUIManager.reference.verror.info.text=LanguageManager.reference.localText("pip", 'error');
			GUIManager.reference.verror.butClose.text.text=LanguageManager.reference.localText("pip", 'err_close');
			GUIManager.reference.verror.butForever.text.text=LanguageManager.reference.localText("pip", 'err_dont_show');
			GUIManager.reference.verror.butCopy.text.text=LanguageManager.reference.localText("pip", 'err_copy_to_clipboard');

			GUIManager.reference.verror.txt.text=err.message+'\n'+err.getStackTrace();
			GUIManager.reference.verror.txt.text+='\n'+'renderer_stage: '+GameContainer.reference.renderer_stage;
			
			if (dop != null) {
				GUIManager.reference.verror.txt.text += '\n' + dop;
			}
			
			GUIManager.reference.verror.visible = true;
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
			GUIManager.reference.vgui.visible=GUIManager.reference.sky.visible=GUIManager.reference.visual.visible=GUIManager.reference.vscene.visible=false;
			GUIManager.reference.vwait.visible=true;
			GameContainer.reference.catPause=false;
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
			GameContainer.reference.catPause=true;
			GUIManager.reference.visual.visible=false;
			GUIManager.reference.gui.allOff();
			GUIManager.reference.gui.offCelObj();
			try {
				GUIManager.reference.vscene.gotoAndStop(sc);
			} 
			catch(err:Error) {
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
			GameContainer.reference.catPause=false;
			GUIManager.reference.visual.visible=true;
			GUIManager.reference.gui.allOn();
			GUIManager.reference.vscene.gotoAndStop(1);
			GUIManager.reference.vscene.visible=false;
		}
		
		//финальная заставка или gameover
		public function endgame(n:int=0):void {
			GUIManager.reference.vwait.visible=GUIManager.reference.sky.visible = false;
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
	}
}
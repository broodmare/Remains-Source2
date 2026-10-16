package fe.game {

	import flash.display.Sprite;
	import flash.ui.Mouse;

	import fe.engine.audio.Sound;
	import fe.engine.text.LanguageManager;
	import fe.game.domain.location.Game;
	import fe.game.domain.units.Inventory;
	import fe.game.domain.units.Pers;
	import fe.game.domain.units.UnitPlayer;
	import fe.game.enums.E_DeathState;
	import fe.game.enums.E_ExitState;
	import fe.game.rendering.Grafon;
	import fe.game.ui.Camera;
	import fe.game.ui.Ctr;
	import fe.game.ui.GUIManager;

	// Top level container for the game
	public class GameContainer {

		public static var reference:GameContainer;		// Publically accessable reference to this instance

		// Data managers (This could probably be a registry in the future)
		private var armorManager:ArmorManager;				// Stores all armor set data and Armors
		private var weaponManager:WeaponManager;			// Stores all weapon data and Weapons

		// All main components
		private var world:World;							//
		private var guiManager:GUIManager;					// Menus, HUD and the clips they draw in
		private var autoPickupManager:AutoPickupManager;	// Which loot the player picks up by walking over it

		public var version:String = "1.2a";					// Game version
		public var onPause:Boolean = false;					// Game is paused

		public var screenWidth:int;							// The stage's size, as the engine last gave it
		public var screenHeight:int;

		public var itemManager:ItemManager;					// Stores all simple item data
		public var vendorManager:VendorManager;				// Stores the vendors of the current game

		public var cam:Camera;								// Camera
		public var ctr:Ctr;									// Input controller
		public var game:Game;
		public var gg:UnitPlayer;							// Player unit
		public var pers:Pers;								// Player stats
		public var invent:Inventory;						// Player inventory
		public var vault:Inventory;							// Global storage for the player
		public var grafon:Grafon;							// Renderer

		// [Loading, config]
		public var configObj:Object;							// The user's stored settings
		public var nadv:int						= 0;
		public var koladv:int;									// How many advice snippets are loaded
		public var load_log:String				= "";

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
		public var matFilter:Boolean			= true;			// Maturity filter
		public var helpMess:Boolean				= true;			// [Educational messages]
		
		public var shineObjs:Boolean			= false;		// [Glow of objects]
		public var sysCur:Boolean				= false;		// [System cursor]
		public var hintKeys:Boolean				= true;			// Pop-up hints for interactables, eg. (Press "e" to open)
		public var hintTele:Boolean				= true;			// Pop-up hints for things you can levitate, eg. (Press "q" to levitate)
		public var showFavs:Boolean				= true;			// [Show additional information when the cursor is at the top of the screen]
		public var errorShow:Boolean			= true;			//
		public var errorShowOpt:Boolean			= true;			//
		public var quakeCam:Boolean				= true;			// [Camera shaking]
		
		// Global Constants
		public var actionDist:int				= 40000;
		public static const cellsX:int			= 48;			// How many tiles there are in a room (horizontally)
		public static const cellsY:int			= 25;			// How many tiles there are in a room (vertically)
		public static const ddy:int				= 1;
		public static const maxdy:int			= 20;
		public static const maxwaterdy:int		= 20;
		public static const maxdelta:int		= 9;			// Max movement distance in pixels between collision checks
		public static const detectionDelay:int	= 100;			// Default grace period before an enemy spots the player
		public static const battleNoOut:int		= 120;
		public static const unitXPMult:Number	= 2.00;
		public static const kolHK:int			= 12;			//количество горячих клавиш
		public static const kolQS:int			= 4;			//количество быстрых заклинаний
		
		public static const boxDamage:Number	= 0.20;			// [Box impact force multiplier]

		// Reads the user's stored settings into the game
		private function loadConfig():void {
			if (configObj) { lastCom = configObj.data.lastCom; }

			if (configObj.data.dialon != null)			{ dialOn = configObj.data.dialon; }
			if (configObj.data.zoom100 != null)			{ zoom100 = configObj.data.zoom100; }
			cam.isZoom = (zoom100) ? 0 : 2;
			if (configObj.data.mat != null)				{ matFilter = configObj.data.mat; }
			if (configObj.data.help != null)			{ helpMess = configObj.data.help; }
			if (configObj.data.hit != null)				{ showHit = configObj.data.hit; }
			if (configObj.data.sysCur != null)			{ sysCur = configObj.data.sysCur; }
			if (configObj.data.hintTele != null)		{ hintTele = configObj.data.hintTele; }
			if (configObj.data.showFavs != null)		{ showFavs = configObj.data.showFavs; }
			if (configObj.data.quakeCam != null)		{ quakeCam = configObj.data.quakeCam; }
			if (configObj.data.errorShowOpt != null)	{ errorShowOpt = configObj.data.errorShowOpt; }
			if (configObj.data.app) {
				guiManager.app.load(configObj.data.app);
				guiManager.app.setTransforms();
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

			if (configObj.data.chit > 0) { chitOn = true; }

			autoPickupManager.load(configObj);

			if (!sysCur) {
				Mouse.cursor = 'arrow';
			}
		}

		public function GameContainer(main:Sprite, configObj_:Object, screenWidth_:int, screenHeight_:int) {
			reference = this;
			configObj = configObj_;
			screenWidth = screenWidth_;
			screenHeight = screenHeight_;

			itemManager			= new ItemManager();
			armorManager		= new ArmorManager();
			weaponManager		= new WeaponManager();
			autoPickupManager	= new AutoPickupManager();

			world		= new World();
			guiManager	= new GUIManager(main);
			grafon		= new Grafon(guiManager.visual);
			cam			= new Camera();
		}

		// Finishes setting up once the graphics have loaded; called every frame until it has run
		public function init2():void {
			if (guiManager.consol) { return; }

			loadConfig();
			world.init2();
			ctr = new Ctr(configObj.data.ctr);
			guiManager.init2(lastCom);
		}

		// The main loop: the main menu until it starts a game, then the world
		public function step():void {
			// Flash moves its clips on at the start of each frame, so the GPU's flipbooks move on here, before the game does
			grafon.objectLayers.advance();
			if (guiManager.mainMenuClass.isRunning) {
				guiManager.mainMenuClass.mainStep();
			}
			else {
				world.step();
			}
		}

		public function resize(screenWidth_:int, screenHeight_:int):void {
			screenWidth = screenWidth_;
			screenHeight = screenHeight_;

			world.resizeScreen();
			guiManager.mainMenuClass.resizeDisplay();
		}

		// The window lost focus
		public function deactivate():void {
			world.onDeactivate();
		}

		// Shows the named mouse cursor, but the arrow while a menu or a load is up and the combat cursor in battle
		public function cur(ncur:String = 'arrow'):void {
			var cursor:String = ncur;

			if (sysCur) {
				return;
			}

			if (guiManager.pip.active || guiManager.stand.active || world.comLoad >= 0) {
				cursor = 'arrow';
			}
			else if (t_battle > 0) {
				cursor = 'combat';
			}

			if (cursor != ccur) {
				Mouse.cursor = cursor;
				Mouse.show();
				ccur = cursor;
			}
		}

		// Writes the game's settings into the user's stored settings and saves them to disk
		public function saveConfig():void {
			try {
				configObj.data.ctr = ctr.save();
				configObj.data.snd = Sound.save();
				configObj.data.language = LanguageManager.reference.currentLanguage;
				configObj.data.chit = (chitOn ? 1 : 0);
				configObj.data.dialon = dialOn;
				configObj.data.zoom100 = zoom100;
				configObj.data.help = helpMess;
				configObj.data.mat = matFilter;
				configObj.data.hit = showHit;
				configObj.data.sysCur = sysCur;
				configObj.data.hintTele = hintTele;
				configObj.data.showFavs = showFavs;
				configObj.data.quakeCam = quakeCam;
				configObj.data.errorShowOpt = errorShowOpt;
				configObj.data.app = guiManager.app.save();

				if (lastCom != null) {
					configObj.data.lastCom = lastCom;
				}

				autoPickupManager.save(configObj);
				configObj.flush();
			}
			catch (err:Error) {
				trace('ERROR: (00:21)');
				world.showError(err);
			}
		}
	}
}
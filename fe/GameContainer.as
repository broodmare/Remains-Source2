package fe {

	import flash.display.Sprite;

	import fe.game.ArmorManager;
	import fe.game.ItemManager;
	import fe.game.VendorManager;
	import fe.game.WeaponManager;
	import fe.game.World;
	import fe.game.domain.location.Game;
	import fe.game.domain.units.Inventory;
	import fe.game.domain.units.Pers;
	import fe.game.domain.units.UnitPlayer;
	import fe.game.rendering.Grafon;
	import fe.game.ui.Camera;
	import fe.game.ui.Ctr;
	import fe.game.ui.GUIManager;

	// Top level container for the game
	public class GameContainer {

		public static var reference:GameContainer;		// Publically accessable reference to this instance

		// Data managers (This could probably be a registry in the future)
		private var armorManager:ArmorManager;			// Stores all armor set data and Armors
		private var weaponManager:WeaponManager;		// Stores all weapon data and Weapons

		// All main components
		private var world:World;						//
		private var guiManager:GUIManager;				// Menus, HUD and the clips they draw in

		public var version:String = "1.2a";				// Game version
		public var onPause:Boolean = false;				// Game is paused

		public var screenWidth:int;						// The stage's size, as the engine last gave it
		public var screenHeight:int;

		public var itemManager:ItemManager;				// Stores all simple item data
		public var vendorManager:VendorManager;			// Stores the vendors of the current game

		public var cam:Camera;							// Camera
		public var ctr:Ctr;								// Input controller
		public var game:Game;
		public var gg:UnitPlayer;						// Player unit
		public var pers:Pers;							// Player stats
		public var invent:Inventory;					// Player inventory
		public var vault:Inventory;						// Global storage for the player
		public var grafon:Grafon;						// Renderer

		public function GameContainer(main:Sprite, userSettings:Object, screenWidth_:int, screenHeight_:int) {
			reference = this;
			screenWidth = screenWidth_;
			screenHeight = screenHeight_;

			itemManager		= new ItemManager();
			armorManager	= new ArmorManager();
			weaponManager	= new WeaponManager();

			world		= new World(userSettings);
			guiManager	= new GUIManager(main);
			grafon		= new Grafon(guiManager.visual);
			cam			= new Camera(world);
		}

		// Finishes setting up once the graphics have loaded; called every frame until it has run
		public function init2():void {
			if (guiManager.consol) { return; }

			world.init2();
			ctr = new Ctr(world.configObj.data.ctr);
			guiManager.init2(world.lastCom);
		}

		// The main loop: the main menu until it starts a game, then the world
		public function step():void {
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
	}
}
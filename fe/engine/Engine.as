package fe.engine {

	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;

	import starling.core.Starling;

	import fe.engine.audio.Sound;
	import fe.engine.text.LanguageManager;
	import fe.engine.text.XMLData;
	import fe.game.GameContainer;

	// Top level container for the entire process
	public class Engine {

		public static var reference:Engine;		// Publically accessable reference to this instance
		private var main:MovieClip;				// The document class, which holds everything Flash draws
		public var stage:Stage;					// CPU Based flash rendering
		private var starling:Starling;			// GPU renderer (drawn under the whole display list)
		private var language:LanguageManager;	// Handles loading and storing languages
		private var saveManager:SaveManager;	// The user's settings and the save slots on disk
		private var game:GameContainer;			// Created once the data modules have loaded
		
		public static const FPS:uint = 30;		// Visual updates per second
		public static const TPS:uint = 30;		// Physics updates per second

		// Used for the timer to measure in-game processes
		private var d1:int;
		private var d2:int;

		// Waits for the data modules, then starts the game and updates it every frame
		private function onEnterFrame(event:Event):void {
			if (game == null) {
				if (XMLData.fileCount < 1) { return; }

				if (XMLData.filesLoaded < XMLData.fileCount) {
					trace("Loaded: " + XMLData.filesLoaded + " of " + XMLData.fileCount + " files.");
					return;
				}

				trace("Finished loading: " + XMLData.filesLoaded + " of " + XMLData.fileCount + " files.");
				game = new GameContainer(main, saveManager.configObj, stage.stageWidth, stage.stageHeight);

				// FPS Counter (This seems to also be used for other things like measuring load times.)
				d1 = getTimer();
				d2 = getTimer();
			}

			game.step();
		}

		private function onResize(event:Event):void {
			starling.viewPort = new Rectangle(0, 0, stage.stageWidth, stage.stageHeight);
			starling.stage.stageWidth = stage.stageWidth;
			starling.stage.stageHeight = stage.stageHeight;

			if (game != null) {
				game.resize(stage.stageWidth, stage.stageHeight);
			}
		}

		private function onDeactivate(event:Event):void {
			if (game != null) {
				game.deactivate();
			}
		}

		public function Engine(stageRef:MovieClip) {
			reference = this;
			main = stageRef;
			stage = stageRef.stage;
			stage.tabChildren = false;

			// Open the user's in-game settings and the save slots
			saveManager = new SaveManager();
			// Load the settings file and store it in memory
			Settings.initializeSettings();

			// Load the game's data files into memory
			XMLData.initializeModules();

			// Load all music and sounds
			Sound.initSnd(saveManager.configObj);

			// Initialize the languageManager and load the current localization into memory
			language = new LanguageManager(saveManager.configObj);

			stage.addEventListener(Event.RESIZE, onResize);
			stage.addEventListener(Event.DEACTIVATE, onDeactivate);
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);

			// Created after the frame listener, so Starling draws each frame after the game has updated
			starling = new Starling(null, stage);
			starling.stop();	// Renders every frame but skips Starling's input and animation, which nothing uses
		}

		// Traces the milliseconds since the last call under message; without a message it only restarts the count
		public function time___metr(message:String = null):void {
			var timeDif:int;

			d2 = getTimer();
			timeDif = d2 - d1;

			if (message != null) {
				trace("time__metr -- " + message + ': ' + timeDif.toString());
			}

			d1 = d2;
		}
	}
}
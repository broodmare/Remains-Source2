package fe.engine {

	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.net.SharedObject;

	import starling.core.Starling;

	import fe.GameContainer;
	import fe.engine.audio.Sound;
	import fe.engine.text.LanguageManager;
	import fe.engine.text.XMLData;

	// Top level container for the entire process
	public class Engine {

		public static var reference:Engine;		// Publically accessable reference to this instance

		private var main:MovieClip;				// The document class, which holds everything Flash draws
		private var starling:Starling;			// GPU renderer (drawn under the whole display list)

		private var userSettings:Object;		// An object containing the user's imported settings
		private var language:LanguageManager;	// Handles loading and storing languages

		private var game:GameContainer;			// Created once the data modules have loaded

		public var stage:Stage;					// CPU Based flash rendering

		// Waits for the data modules, then starts the game and updates it every frame
		private function onEnterFrame(event:Event):void {
			if (game == null) {
				if (XMLData.fileCount < 1) { return; }

				if (XMLData.filesLoaded < XMLData.fileCount) {
					trace("Loaded: " + XMLData.filesLoaded + " of " + XMLData.fileCount + " files.");
					return;
				}

				trace("Finished loading: " + XMLData.filesLoaded + " of " + XMLData.fileCount + " files.");
				game = new GameContainer(main, userSettings, stage.stageWidth, stage.stageHeight);
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

			// Load the user's in-game settings
			userSettings = SharedObject.getLocal("config", null);
			// Load the settings file and store it in memory
			Settings.initializeSettings();

			// Load the game's data files into memory
			XMLData.initializeModules();

			// Load all music and sounds
			Sound.initSnd(userSettings);

			// Initialize the languageManager and load the current localization into memory
			language = new LanguageManager(userSettings);

			stage.addEventListener(Event.RESIZE, onResize);
			stage.addEventListener(Event.DEACTIVATE, onDeactivate);
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);

			// Created after the frame listener, so Starling draws each frame after the game has updated
			starling = new Starling(null, stage);
			starling.stop();	// Renders every frame but skips Starling's input and animation, which nothing uses
		}
	}
}
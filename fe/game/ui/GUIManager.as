package fe.game.ui {

	import flash.desktop.Clipboard;
	import flash.desktop.ClipboardFormats;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	import fe.engine.utils.SymbolFactory;
	import fe.game.World;
	import fe.game.GameContainer;

	public class GUIManager {
		public static var reference:GUIManager;				// Publically accessable reference to this instance

		public var mainMenuClass:MainMenu;
		public var consol:Consol;								// Command console
		public var consoleActive:Boolean = false;				// The console is open, so it keeps the keyboard and the game ignores keys
		public var gui:GUI;										// GUI

		public var pip:PipBuck;									// Pipbuck (Menus)
		public var stand:Stand;									// Item stand
		public var sats:Sats;									// SATS
		public var app:Appear;									// Appearance customizer

		public var vwait:MovieClip;								//Картинка с надписью ЗАГРУЗКА
		public var vfon:MovieClip;								// The stationary backdrop, kept off the display list and drawn into Grafon's Backdrop
		public var visual:Sprite;								//активная область
		public var vscene:MovieClip;							//Сцена
		public var vblack:MovieClip;							//Затемнение
		public var vpip:MovieClip;								//Пипбак
		public var vsats:MovieClip;								//Интерфейс ЗПС
		public var vgui:MovieClip;								//GUI (HUD)
		public var vstand:MovieClip;							//Стенд
		public var verror:MovieClip;							//окно ошибки
		public var vconsol:MovieClip;							//Консоль

		public function GUIManager(main:Sprite) {
			var create:Function = SymbolFactory.createInstance;

			reference = this;

			app = new Appear();
			// Created before the other clips, so the menu sits under them on the display list
			mainMenuClass = new MainMenu(main);

			// [Creation of graphic elements]
			vwait = create("visualWait") as MovieClip;
			vwait.cacheAsBitmap = true;

			visual		= new Sprite();
			vgui 		= create("visualGUI") as MovieClip;
			vfon 		= new MovieClip();
			vpip 		= create("visPipBuck") as MovieClip;
			vstand 		= create("visualStand") as MovieClip;
			vsats		= new MovieClip();
			vscene 		= create("visualScene") as MovieClip;
			vconsol		= create("visConsol") as MovieClip;
			verror		= create("visError") as MovieClip;
			vblack 		= create("visBlack") as MovieClip;
			vblack.cacheAsBitmap = true;

			World.w.setLoadScreen();

			vgui.visible		= false;
			vpip.visible		= false;
			vconsol.visible		= false;
			vfon.visible		= false;
			visual.visible		= false;
			vsats.visible		= false;
			vwait.visible		= false;
			vblack.visible		= false;
			verror.visible		= false;
			vscene.visible		= false;

			vscene.stop();

			main.addChild(vwait);
			main.addChild(visual);
			main.addChild(vscene);
			main.addChild(vblack);
			main.addChild(vpip);
			main.addChild(vsats);
			main.addChild(vgui);
			main.addChild(vstand);
			main.addChild(verror);
			main.addChild(vconsol);

			verror.butCopy.addEventListener(MouseEvent.CLICK, function():void {Clipboard.generalClipboard.clear();Clipboard.generalClipboard.setData(ClipboardFormats.TEXT_FORMAT, verror.txt.text);});
			verror.butClose.addEventListener(MouseEvent.CLICK, function():void {verror.visible=false;});
			verror.butForever.addEventListener(MouseEvent.CLICK, function():void {GameContainer.reference.errorShow=false; verror.visible=false;});

			vstand.visible		= false;
		}

		// Creates the console and the Pipbuck once the graphics have loaded
		public function init2(lastCom:String):void {
			consol = new Consol(vconsol, lastCom);
			pip = new PipBuck(vpip);
		}
	}
}
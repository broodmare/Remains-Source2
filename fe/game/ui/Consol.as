package fe.game.ui {	

	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;

	import fe.engine.audio.Sound;
	import fe.engine.text.LanguageManager;
	import fe.engine.text.TextParser;
	import fe.game.ItemManager;
	import fe.game.World;
	import fe.game.enums.E_DeathState;
	import fe.game.enums.E_ExitState;
	import fe.engine.Engine;
	import fe.game.GameContainer;
	import fe.game.domain.serv.Item;
	import fe.game.domain.units.Unit;
	import fe.game.domain.units.Resistances;
	import fe.game.domain.units.enums.E_Resistances;

	
	// Debug console class. 
	// The debug console contains three textboxes. "help", "list1", and "list2" in order from left to right.
	public class Consol {

		private static const HARDRESET_DYING_FRAMES:int = 10;	// The hardreset command's death plays briefly before the screen fades

		private var world = World.w;

		public var vis:MovieClip;
		public var ist:Array;
		public var istN:int = 0;

		private var textboxesVisible:Boolean = false;

		public function Consol(vcons:MovieClip, prev:String = null) {
			vis = vcons;
			ist = [];

			if (prev != null) {
				ist.push(prev);
			}

			vis.input.addEventListener(KeyboardEvent.KEY_DOWN, onKeyboardDownEvent);
			vis.butEnter.addEventListener(MouseEvent.CLICK, onButEnter);
			vis.butClose.addEventListener(MouseEvent.CLICK, onButClose);

			// Build the help command using each node in help.xml
			// REMOVED BUILDING THE HELP STRING HERE

			// Quick Hack
			vis.help.text = "Debug Console\n";
			vis.help.text += "Up/Down - Command history\n";
			vis.help.text += "Enter - Apply the command\n";
			vis.help.text += "End or Esc - Close the console\n";

			vis.visible = GUIManager.reference.consoleActive;
			setTextBoxVisibility(textboxesVisible);
		}

		// Allow other classes to hide the console.
		public function setConsoleVisiblility(setState:Boolean):void {
			vis.visible = setState;
			GUIManager.reference.consoleActive = setState;

			trace("Consol.as/setConsoleVisiblility() - Set console visiblity to " + setState.toString());

			if (setState) {
				Engine.reference.stage.focus = vis.input;
			}
		}

		public function printLine(text:String):void {
			vis.list2.text += text;
		}

		public function clearBox(box:int):void {
			switch (box) {
				case 0:
					vis.help.text = "";
					break;
				case 1:
					vis.list1.text = "";
					break;
				case 2:
					vis.lsit2.text = "";
					break;
				default:
					trace("Consol.as/clearBox() - ERROR: Tried to clear unknown box!");
			}
		}

		private function onKeyboardDownEvent(event:KeyboardEvent):void {
			if (event.keyCode == Keyboard.ENTER) {
				analis();
			}

			if (event.keyCode == Keyboard.END || event.keyCode == Keyboard.ESCAPE) {
				setConsoleVisiblility(false);
			}

			if (event.keyCode == Keyboard.UP) {
				if (istN > 0) istN--;
				if (istN < ist.length) vis.input.text = ist[istN];
			}

			if (event.keyCode == Keyboard.DOWN) {
				if (istN < ist.length) istN++;
				if (istN < ist.length) vis.input.text = ist[istN];
			}

			event.stopPropagation();
		}

		private function onButEnter(event:MouseEvent):void {
			analis();
			event.stopPropagation();
		}

		private function onButClose(event:MouseEvent):void {
			setConsoleVisiblility(false);
			event.stopPropagation();
		}

		// Lists the ids and names of a localization category, sorted by id. Eg. "mont 	Crowbar"
		private function listNames(entries:Object):String {
			var ids:Array = [];
			for (var id:String in entries) {
				ids.push(id);
			}
			ids.sort();

			var s:String = "";
			for each (id in ids) {
				s += id + " \t" + entries[id].string + "\n";
			}
			return s;
		}

		private function setTextBoxVisibility(setState:Boolean):void {
			textboxesVisible = setState;
			vis.help.visible	= setState;
			vis.list1.visible	= setState;
			vis.list2.visible	= setState;

			trace("Consol.as/setTextBoxVisibility() - Set console textbox visiblity to " + setState.toString());
		}

		private function analis():void {
			var str:String = vis.input.text;
			
			ist.push(str);
			GameContainer.reference.lastCom = str;
			GameContainer.reference.saveConfig();
			istN = ist.length;
			vis.input.text = "";
			
			var s:Array = str.split(" ");

			vis.help.text = "";
			vis.help.text += "Command: \"" + s[0] + "\"\n"

			switch (s[0])  {
				case "clear":
					GameContainer.reference.cam.dblack=0;
					GameContainer.reference.gg.controlOn();
					GameContainer.reference.gg.vis.visible=true;
					GUIManager.reference.vblack.alpha=0;
					GUIManager.reference.vblack.visible=false;
					GameContainer.reference.exitState=E_ExitState.NONE;
					GameContainer.reference.deathState=E_DeathState.NONE;
					GUIManager.reference.vgui.visible=true;
					GUIManager.reference.vfon.visible=true;
					GUIManager.reference.visual.visible=true;
					Sound.setTempMute(false);
					GUIManager.reference.pip.noAct=false;
					break;
				case "redraw":
					world.redrawLoc();
					break;
				case "hud":
					GUIManager.reference.gui.vis.visible=!GUIManager.reference.gui.vis.visible;
					break;
				case "die":
					GameContainer.reference.gg.damage(10000, E_Resistances.DAM_INTERNAL);
					break;
				case "hardreset":
					if (GameContainer.reference.pers.dead) {
						GameContainer.reference.pers.dead=false;
						world.startDeath(HARDRESET_DYING_FRAMES);
						GameContainer.reference.gg.anim("die",true);
						setConsoleVisiblility(false);
					}
					break;
				case "hardinv":
					GameContainer.reference.hardInv=!GameContainer.reference.hardInv;
					break;
				case "res_watcher":
					GameContainer.reference.game.triggers["observer"] = 1;
					break;
				case "mqt":
					GameContainer.reference.chitOn=!GameContainer.reference.chitOn;
					GameContainer.reference.saveConfig();
					break;
				//TODO: Re-implement check that chitOn == true for commands below this point.
				case "hardcore":
					GameContainer.reference.pers.hardcore=!GameContainer.reference.pers.hardcore;
					break;
				case "testmode":
					GameContainer.reference.testMode=!GameContainer.reference.testMode;
					break;
				case "dif":
					GameContainer.reference.game.globalDif=s[1];
					if (GameContainer.reference.game.globalDif<0) GameContainer.reference.game.globalDif=0;
					if (GameContainer.reference.game.globalDif>4) GameContainer.reference.game.globalDif=4;
					GameContainer.reference.pers.setGlobalDif(GameContainer.reference.game.globalDif);
					GameContainer.reference.pers.setParameters();
					break;
				case "all":
					if (s.length==1) {
						GameContainer.reference.gg.itemInteraction.addAll();
						GameContainer.reference.pers.addSkillPoint(10);
					}
					else if (s[1]=="weapon") GameContainer.reference.gg.itemInteraction.addAllWeapon();
					else if (s[1]=="ammo") GameContainer.reference.gg.itemInteraction.addAllAmmo();
					else if (s[1]=="item") GameContainer.reference.gg.itemInteraction.addAllItem();
					else if (s[1]=="armor") GameContainer.reference.gg.itemInteraction.addAllArmor();
					setConsoleVisiblility(false);
					break;
				case "god":
					GameContainer.reference.godMode=!GameContainer.reference.godMode;
					break;
				case "lvl":
				case "level":
					GameContainer.reference.pers.setForcLevel(s[1]);
					break;
				case "xp":
					GameContainer.reference.pers.expa(s[1]);
					break;
				case "sp":
					if (s.length==1) GameContainer.reference.pers.addSkillPoint();
					else GameContainer.reference.pers.addSkillPoint(int(s[1]));
					break;
				case "pp":
					if (s.length==1) GameContainer.reference.pers.perkPoint++;
					else  GameContainer.reference.pers.perkPoint+=int(s[1]);
					break;
				case "weapon":
					// "weapon id" adds a weapon, "weapon id 1" adds its unique variant
					if (s.length==2) GameContainer.reference.gg.itemInteraction.addWeapon(s[1]);
					else if (s.length>2) GameContainer.reference.gg.itemInteraction.addWeapon(s[1] + "^1");
					break;
				case "remw":
					if (s.length==2) GameContainer.reference.gg.itemInteraction.remWeapon(s[1]);
					break;
				case "armor":
					if (s.length==2) GameContainer.reference.gg.itemInteraction.addArmor(s[1]);
					break;
				case "money":
					if (s.length==2) GameContainer.reference.invent.setQuantity("money", int(s[1]));
					break;
				case "item":
					if (!ItemManager.reference.hasItem(s[1])) return;
					if (s.length==3) GameContainer.reference.invent.setQuantity(s[1], int(s[2]));
					else if (s.length==2) GameContainer.reference.invent.increaseQuantity(s[1]);
					GameContainer.reference.game.checkQuests(s[1]);
					GameContainer.reference.pers.setParameters();
					break;
				case "ammo":
					if (s.length==3 && ItemManager.reference.hasItem(s[1])) GameContainer.reference.invent.setQuantity(s[1], int(s[2]));
					break;
				case "perk":
					if (s.length==2) GameContainer.reference.pers.addPerk(s[1]);
					break;
				case "skill":
					if (s.length==3) GameContainer.reference.pers.setSkill(s[1], s[2]);
					break;
				case "eff":
					if (s.length==2) GameContainer.reference.gg.addEffect(s[1]);
					break;
				case "res":
					if (GameContainer.reference.gg.effects.length>0) {
						for each (var eff in GameContainer.reference.gg.effects) eff.unsetEff();
					}
					break;
				case "repair":
					GameContainer.reference.gg.currentWeapon.repair(1000000);
					break;
				case "refill":
					GameContainer.reference.game.refillAllVendors();
					break;
				case "rep":
					if (s.length==2) GameContainer.reference.pers.rep=int(s[1]);
					break;
				case "crack":
					if (s.length==2 && GameContainer.reference.gg.currentWeapon) GameContainer.reference.gg.currentWeapon.hp=Math.round(GameContainer.reference.gg.currentWeapon.maxhp*Number(s[1])/100);
					break;
				case "break":
					if (s.length==2 && GameContainer.reference.gg.currentArmor) GameContainer.reference.gg.currentArmor.hp=Math.round(GameContainer.reference.gg.currentArmor.maxhp*Number(s[1])/100);
					break;
				case "heal":
					GameContainer.reference.gg.heal(10000);
					break;
				case "rad":
					GameContainer.reference.gg.rad=s[1];
					GUIManager.reference.gui.setAll();
					break;
				case "mana":
					GameContainer.reference.pers.manaHP=int(s[1]);
					GameContainer.reference.pers.setParameters();
					break;
				case "check":
					world.land.gotoCheckPoint();
					break;
				case "goto":
					if (s.length==3) world.land.gotoXY(s[1],s[2]);
					break;
				case "map":
					GameContainer.reference.drawAllMap=!GameContainer.reference.drawAllMap;
					break;
				case "black":
					GameContainer.reference.black=!GameContainer.reference.black;
					GameContainer.reference.grafon.visLight.visible=GameContainer.reference.black && world.loc.black;
					break;
				case "battle":
					GameContainer.reference.testBattle=!GameContainer.reference.testBattle;
					break;
				case "testeff":
					GameContainer.reference.testEff=!GameContainer.reference.testEff;
					break;
				case "testdam":
					GameContainer.reference.testDam=!GameContainer.reference.testDam;
					break;
				case "enemy":
					if (GameContainer.reference.enemyAct==3) GameContainer.reference.enemyAct=0;
					else GameContainer.reference.enemyAct=3;
					break;
				case "lim":
					if (s.length==2) world.land.lootLimit=Number(s[1]);
					break;
				case "fly":
				case "port":
				case "emit":
					GameContainer.reference.chit=s[0];
					GameContainer.reference.chitX=s[1];
					break;
				case "getroom":
					GameContainer.reference.testLoot=true;
					trace('получено опыта', world.loc.getAll());
					GameContainer.reference.testLoot=false;
					break;
				case "err":
					world.landError=!world.landError;
					break;
				case "getloc":
					GameContainer.reference.testLoot=true;
					trace('получено опыта', world.land.getAll());
					GameContainer.reference.testLoot=false;	
					break;
				case "alicorn":
					if (GameContainer.reference.alicorn) GameContainer.reference.gg.alicornOff();
					else GameContainer.reference.gg.alicornOn();
					break;
				case "st":
					if (s.length==3) GameContainer.reference.game.triggers[s[1]]=s[2];
					break;
				case "trigger":
					if (s.length==2) GUIManager.reference.gui.infoText("trigger", s[1], GameContainer.reference.game.triggers[s[1]]);
					break;
				case "triggers":
					if (s.length>1) GUIManager.reference.gui.infoText("trigger", s[1], GameContainer.reference.game.triggers[s[1]]);
					else {
						for (var i in GameContainer.reference.game.triggers)  GUIManager.reference.gui.infoText("trigger", i, GameContainer.reference.game.triggers[i]);
					}
					break;
				case "textboxes":
					var b:Boolean = !textboxesVisible;
					setTextBoxVisibility(b);
					break;
				case "listWeapons":
					vis.list1.text = listNames(LanguageManager.reference.data.weapon);
					if (!textboxesVisible) setTextBoxVisibility(true);
					break;
				case "listAmmo":
					var ammoList:String = "";
					for each (var itemData:Object in ItemManager.reference.itemList) {
						if (itemData.tip == Item.L_AMMO) ammoList += itemData.id + " \t" + TextParser.txt('i', itemData.id) + "\n";
					}
					vis.list1.text = ammoList;
					if (!textboxesVisible) setTextBoxVisibility(true);
					break;
				case "listItems":
					vis.list1.text = listNames(LanguageManager.reference.data.items);
					if (!textboxesVisible) setTextBoxVisibility(true);
					break;
				case "spam":
					vis.help.text	+= "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA";
					vis.list1.text	+= "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA";
					vis.list2.text	+= "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA";
					if (!textboxesVisible) setTextBoxVisibility(true);
					break;
				case "textboxClear":
					vis.help.text	= "";
					vis.list1.text	= "";
					vis.list2.text	= "";
					break;
				default:
					//setConsoleVisiblility(false);
					vis.help.text += "Command: \"" + s[0] + "\ not recognized!\n";
					trace("Consol.as/analis() - ERROR: Command: \"" + s[0] + "\" not recognized!");
					break;
			}
			
			// TODO: What is this for???
			if (GUIManager.reference.gui) {
				GUIManager.reference.gui.setAll();
			}
			else {
				trace("Consol.as/analis() - ERROR! world.gui is null!");
			}
			
		}
	}
}
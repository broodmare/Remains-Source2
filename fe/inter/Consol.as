package fe.inter
{	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;

	import fe.*;
	import fe.unit.Unit;
	
	// Debug console class. 
	// The debug console contains three textboxes. "help", "list1", and "list2" in order from left to right.
	public class Consol
	{
		private var world = World.w;

		public var vis:MovieClip;
		public var ist:Array;
		public var istN:int = 0;

		public var consoleIsVisible:Boolean = false;
		private var textboxesVisible:Boolean = false;

		public function Consol(vcons:MovieClip, prev:String = null)
		{
			vis = vcons;
			ist = [];

			if (prev != null) ist.push(prev);

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

			vis.visible = consoleIsVisible;
			setTextBoxVisibility(textboxesVisible);
		}

		// Allow other classes to hide the console.
		public function setConsoleVisiblility(setState:Boolean):void
		{
			vis.visible = setState;
			consoleIsVisible	= setState;

			trace("Consol.as/setConsoleVisiblility() - Set console visiblity to " + setState.toString());

			if (consoleIsVisible) world.swfStage.focus = vis.input;
		}

		public function printLine(text:String):void
		{
			vis.list2.text += text;
		}

		public function clearBox(box:int):void
		{
			switch (box)
			{
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
		private function onKeyboardDownEvent(event:KeyboardEvent):void
		{
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

		private function onButEnter(event:MouseEvent):void
		{
			analis();
			event.stopPropagation();
		}

		private function onButClose(event:MouseEvent):void
		{
			setConsoleVisiblility(false);
			event.stopPropagation();
		}

		private function setTextBoxVisibility(setState:Boolean):void
		{
			textboxesVisible = setState;
			vis.help.visible	= setState;
			vis.list1.visible	= setState;
			vis.list2.visible	= setState;

			trace("Consol.as/setTextBoxVisibility() - Set console textbox visiblity to " + setState.toString());
		}

		private function analis():void
		{
			var str:String = vis.input.text;
			
			ist.push(str);
			world.lastCom = str;
			world.saveConfig();
			istN = ist.length;
			vis.input.text = "";
			
			var s:Array = str.split(" ");

			vis.help.text = "";
			vis.help.text += "Command: \"" + s[0] + "\"\n"

			switch (s[0]) 
			{
				case "clear":
					world.cam.dblack=0;
					world.gg.controlOn();
					world.gg.vis.visible=true;
					world.vblack.alpha=0;
					world.vblack.visible=false;
					world.t_exit=world.t_die=0;
					world.vgui.visible=world.vfon.visible=world.visual.visible=true;
					Snd.tempMuted=false;
					world.pip.noAct=false;
					break;
				case "redraw":
					world.redrawLoc();
					break;
				case "hud":
					world.gui.vis.visible=!world.gui.vis.visible;
					break;
				case "die":
					world.gg.damage(10000,Unit.D_INSIDE);
					break;
				case "hardreset":
					if (world.pers.dead)
					{
						world.pers.dead=false;
						world.t_die=210;
						world.gg.anim("die",true);
						setConsoleVisiblility(false);
					}
					break;
				case "hardinv":
					world.hardInv=!world.hardInv;
					break;
				case "res_watcher":
					world.game.triggers["observer"] = 1;
					break;
				case "mqt":
					world.chitOn=!world.chitOn;
					world.saveConfig();
					break;
				//TODO: Re-implement check that chitOn == true for commands below this point.
				case "hardcore":
					world.pers.hardcore=!world.pers.hardcore;
					break;
				case "testmode":
					world.testMode=!world.testMode;
					break;
				case "dif":
					world.game.globalDif=s[1];
					if (world.game.globalDif<0) world.game.globalDif=0;
					if (world.game.globalDif>4) world.game.globalDif=4;
					world.pers.setGlobalDif(world.game.globalDif);
					world.pers.setParameters();
					break;
				case "all":
					if (s.length==1)
					{
						world.invent.addAll();
						world.pers.addSkillPoint(10);
					}
					else if (s[1]=="weapon") world.invent.addAllWeapon();
					else if (s[1]=="ammo") world.invent.addAllAmmo();
					else if (s[1]=="item") world.invent.addAllItem();
					else if (s[1]=="armor") world.invent.addAllArmor();
					setConsoleVisiblility(false);
					break;
				case "min":
					world.invent.addMin();
					setConsoleVisiblility(false);
					break;
				case "god":
					world.godMode=!world.godMode;
					break;
				case "lvl":
				case "level":
					world.pers.setForcLevel(s[1]);
					break;
				case "xp":
					world.pers.expa(s[1]);
					break;
				case "sp":
					if (s.length==1) world.pers.addSkillPoint();
					else world.pers.addSkillPoint(int(s[1]));
					break;
				case "pp":
					if (s.length==1) world.pers.perkPoint++;
					else  world.pers.perkPoint+=int(s[1]);
					break;
				case "weapon":
					if (s.length==2) world.invent.addWeapon(s[1]);
					else if (s.length>2) world.invent.updWeapon(s[1],1)
					break;
				case "remw":
					if (s.length==2) world.invent.remWeapon(s[1]);
					break;
				case "armor":
					if (s.length==2) world.invent.addArmor(s[1]);
					break;
				case "money":
					if (s.length==2) world.invent.items["money"].kol=int(s[1]);
					break;
				case "item":
					if (world.invent.items[s[1]]==null) return;
					if (s.length==3) world.invent.items[s[1]].kol=int(s[2]);
					else if (s.length==2) world.invent.items[s[1]].kol++;
					world.game.checkQuests(s[1]);
					world.pers.setParameters();
					break;
				case "ammo":
					if (s.length==3) world.invent.items[s[1]].kol=int(s[2]);
					break;
				case "perk":
					if (s.length==2) world.pers.addPerk(s[1]);
					break;
				case "skill":
					if (s.length==3) world.pers.setSkill(s[1], s[2]);
					break;
				case "eff":
					if (s.length==2) world.gg.addEffect(s[1]);
					break;
				case "res":
					if (world.gg.effects.length>0) {
						for each (var eff in world.gg.effects) eff.unsetEff();
					}
					break;
				case "repair":
					world.gg.currentWeapon.repair(1000000);
					break;
				case "refill":
					world.game.refillVendors();
					break;
				case "rep":
					if (s.length==2) world.pers.rep=int(s[1]);
					break;
				case "crack":
					if (s.length==2 && world.gg.currentWeapon) world.gg.currentWeapon.hp=Math.round(world.gg.currentWeapon.maxhp*Number(s[1])/100);
					break;
				case "break":
					if (s.length==2 && world.gg.currentArmor) world.gg.currentArmor.hp=Math.round(world.gg.currentArmor.maxhp*Number(s[1])/100);
					break;
				case "heal":
					world.gg.heal(10000);
					break;
				case "rad":
					world.gg.rad=s[1];
					world.gui.setAll();
					break;
				case "mana":
					world.pers.manaHP=int(s[1]);
					world.pers.setParameters();
					break;
				case "check":
					world.land.gotoCheckPoint();
					break;
				case "goto":
					if (s.length==3) world.land.gotoXY(s[1],s[2]);
					break;
				case "map":
					world.drawAllMap=!world.drawAllMap;
					break;
				case "black":
					world.black=!world.black;
					world.grafon.visLight.visible=world.black && world.loc.black;
					break;
				case "battle":
					world.testBattle=!world.testBattle;
					break;
				case "testeff":
					world.testEff=!world.testEff;
					break;
				case "testdam":
					world.testDam=!world.testDam;
					break;
				case "enemy":
					if (world.enemyAct==3) world.enemyAct=0;
					else world.enemyAct=3;
					break;
				case "lim":
					if (s.length==2) world.land.lootLimit=Number(s[1]);
					break;
				case "fly":
				case "port":
				case "emit":
					world.chit=s[0];
					world.chitX=s[1];
					break;
				case "getroom":
					world.testLoot=true;
					trace('получено опыта', world.loc.getAll());
					world.testLoot=false;
					break;
				case "err":
					world.landError=!world.landError;
					break;
				case "getloc":
					world.testLoot=true;
					trace('получено опыта', world.land.getAll());
					world.testLoot=false;	
					break;
				case "alicorn":
					if (world.alicorn) world.gg.alicornOff();
					else world.gg.alicornOn();
					break;
				case "st":
					if (s.length==3) world.game.triggers[s[1]]=s[2];
					break;
				case "trigger":
					if (s.length==2) world.gui.infoText("trigger", s[1], world.game.triggers[s[1]]);
					break;
				case "triggers":
					if (s.length>1) world.gui.infoText("trigger", s[1], world.game.triggers[s[1]]);
					else {
						for (var i in world.game.triggers)  world.gui.infoText("trigger", i, world.game.triggers[i]);
					}
					break;
				case "textboxes":
					var b:Boolean = !textboxesVisible;
					setTextBoxVisibility(b);
					break;
				case "listWeapons":
					vis.list1.text = "";
					for each(i in Res.currentLanguageData.weapon) vis.list1.text += i.@id + " \t" + i.n[0] + "\n";
					if (!textboxesVisible) setTextBoxVisibility(true);
					break;
				case "listAmmo":
					vis.list1.text = "";
					for each(i in Res.currentLanguageData.ammo) vis.list1.text += i.@id + " \t" + i.n[0] + "\n";
					if (!textboxesVisible) setTextBoxVisibility(true);
					break;
				case "listItems":
					vis.list1.text = "";
					for each(i in Res.currentLanguageData.item) vis.list1.text += i.@id + " \t" + i.n[0] + "\n";
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
			if (world.gui) {
				world.gui.setAll();
			}
			else {
				trace("Consol.as/analis() - ERROR! world.gui is null!");
			}
			
		}
	}
}
package fe.game.domain.serv {
	
	import fe.engine.audio.Sound;
	import fe.engine.text.LanguageManager;
	import fe.engine.text.TextParser;
	import fe.game.ItemManager;
	import fe.game.World;
	import fe.game.ui.GUIManager;
	import fe.game.GameContainer;
	import fe.engine.utils.Vec2;
	import fe.game.domain.entities.Obj;
	import fe.game.domain.location.Level;
	import fe.game.domain.units.Unit;
	import fe.game.domain.units.Armor;
	import fe.game.enums.E_Direction;
	import fe.engine.Engine;
	
	public class Script {

		private var id:String;						// Name of the script
		private var land:Level;						// Level this script is on
		public var owner:Obj;						// Object this script belongs to
		
		public var eve:String;						// [event that causes the script to run]
		public var acts:Array			= [];
		private var actObj:Object;
		
		public var onTimer:Boolean		= false;	// The script has a delay before starting
		public var running:Boolean		= false;	// The script is currently active
		private var wait:Boolean		= false;	// The script is waiting to be activated
		
		private var ncom:int;
		private var tcom:int			=  0;
		private var dial_n:int			= -1;

		private static var debugLog:Boolean = true;			// Output script information as it's executed

		public function Script(xml:XML, nland:Level = null, nowner:Obj = null, tt:Boolean = false) {
			land = nland;
			owner = nowner;
			
			if (xml.@id.length()) {
				id = xml.@id;
			}

			if (xml.@eve.length()) {
				eve = xml.@eve;
			}
			
			if (xml.@act.length()) {
				analiz(xml);
			}
			
			if (xml.s.length()) {
				for each(var s:XML in xml.s) {
					analiz(s);
				}
			}
			
			if (tt) {
				onTimer = true;
			}
			
			if (land && onTimer) {
				land.scripts.push(this);
			}
		}
		
		// Analyze each step in a script and create an object containing all it's actions
		private function analiz(xml:XML):void {
			var act:String;
			var targ:String;
			var val:String;
			var t:int = 0;
			var n:String = "-1";
			var opt1:int = 0;
			var opt2:int = 0;
			
			if (xml.@act.length()) {		// [Command]
				act = xml.@act;
				
				if (act == "dial" || act == "dialog" || act == "inform" || act == "landlevel") {
					onTimer = true;
				}
			}
			
			if (xml.@targ.length()) {
				targ = xml.@targ;		// [Target]
			}
			
			if (xml.@val.length()) {
				val = xml.@val;		// [Value]
			}
			
			if (xml.@t.length()) {						// [Delay in seconds]
				t = Math.round(xml.@t * Engine.TPS);
				if (t > 0) {
					onTimer = true;
				}
			}
			
			if (xml.@n.length()) {
				n = xml.@n;		// [option]
			}
			
			if (xml.@opt1.length()) {
				opt1 = xml.@opt1;		// [option]
			}
			
			if (xml.@opt2.length()) {
				opt2 = xml.@opt2;		// [option]
			}
			
			if (act) {
				acts.push(
					{
						act:act,
						targ:targ,
						val:val,
						t:t,
						n:n,
						opt1:opt1,
						opt2:opt2
					});
			}
		}
		
		// [Running the script]
		public function start():void {
			if (debugLog) {
				trace("Script.as/start() - Running script: \"" + id + "\"");
			}
			
			if (acts.length <= 0) {
				return;
			}
			
			if (onTimer) {
                ncom = 0;
                com(acts[ncom]);
                tcom = acts[ncom].t;
                running = true;
            }
			else {	// [Do everything at once]
                for each(var obj:Object in acts) {
					com(obj);
					
					if (debugLog) {
						trace("Script.as/start() - Script: \"" + id + "\" completed");
					}
				}
            }
		}
		
		public function step():void {
			if (tcom > 0) {
				tcom--;
			}
			
			if (tcom <= 0) {
				if (wait) {
					if (GameContainer.reference.ctr.keyPressed2) {
						dial_n = 10000;
					}
					else if (!GameContainer.reference.ctr.keyPressed) {
						return;
					}
					
					if (dial_n < 0) {
						GUIManager.reference.gui.dialText();
						wait = false;
					}
					else {
						dial_n++;
						
						if (GUIManager.reference.gui.dialText(actObj.val, dial_n, actObj.opt1 > 0, true)) {
							GameContainer.reference.ctr.active = false;
							GameContainer.reference.ctr.keyPressed = false;
							GameContainer.reference.gg.levit = 0;
							
							return;
						}
						else {
							GUIManager.reference.gui.dialText();
							GameContainer.reference.gg.controlOn();
							wait = false;
						}
					}
					
					GameContainer.reference.ctr.keyPressed	= false;
					GameContainer.reference.ctr.keyPressed2	= false;
				}
				
				ncom++;
				
				if (ncom >= acts.length) {
					running = false;
					GUIManager.reference.gui.dialText();
				}
				else {
					com(acts[ncom]);
					tcom = acts[ncom].t;
				}
			}
		}
		
		// [Command execution]
		private function com(obj:Object):void {
			if (obj == null) {
				return;
			}

			actObj = obj;
			
			if (GUIManager.reference.gui.vis.dial.visible) {
				GUIManager.reference.gui.dialText();
			}
			
			GameContainer.reference.ctr.keyPressed = false;
			GameContainer.reference.ctr.keyPressed2 = false;
			wait = false;
			dial_n = -1;

			if (obj.targ) {
				var target:Obj;
				
				if (obj.targ == "this") {
					target = owner;
				}
				else if (land) {
					target = land.uidObjs[obj.targ];
				}
				else {
					target = World.w.land.uidObjs[obj.targ];
				}
				
				if (target) {
					target.command(obj.act, obj.val);
				}
			}
			else {
				if (debugLog) {
					trace("Script.as/com() - Performing action: \"" + String(obj.act) + "\" of script \"" + id + "\"");
				}

				switch (obj.act) {

					case "control off":
						GameContainer.reference.gg.controlOff();
					break;
					
					case "control on":
						GameContainer.reference.gg.controlOn();
					break;

					case "mess":
						GUIManager.reference.gui.messText(obj.val, "", obj.opt1 > 0, obj.opt2 > 0);
					break;

					case "dial":
						if (!(obj.t > 0)) {
							wait = true;
						}
						GameContainer.reference.ctr.active = false;
						GUIManager.reference.gui.dialText(obj.val, obj.n, obj.opt1 > 0, wait);
					break;

					case "dialog":
						if (GameContainer.reference.dialOn) {
							GameContainer.reference.gg.controlOff();
							wait=true;
							dial_n=0;
							GameContainer.reference.ctr.active=false;
							GUIManager.reference.gui.dialText(actObj.val,dial_n,actObj.opt1>0,true);
							GameContainer.reference.ctr.keyJump=false;
							GameContainer.reference.gg.levit=0;
						}
					break;

					case "inform":
						GameContainer.reference.gg.controlOff();
						wait = true;
						dial_n = 0;
						GameContainer.reference.ctr.active = false;
						GUIManager.reference.gui.dialText({mod:actObj.opt2, pushed:(actObj.opt1>0)?1:0, text:String(actObj.val)},0,false,true);
					break;

					case "landlevel":
						if (GameContainer.reference.dialOn && GameContainer.reference.game.lands[actObj.val]) {
							GameContainer.reference.gg.controlOff();
							wait=true;
							GameContainer.reference.ctr.active=false;
							var str:String = TextParser.txt("m",actObj.val) + "\n" + LanguageManager.reference.localText("pip", "recLevel") + ": [" + GameContainer.reference.game.lands[actObj.val].dif + "]\n" + LanguageManager.reference.localText("pip", "isperslvl") + ": [" + GameContainer.reference.pers.level + "]";
							
							if (GameContainer.reference.game.lands[actObj.val].dif>GameContainer.reference.pers.level) {
								str += "\n\n" + LanguageManager.reference.localText("pip", "wrLevel");
							}
							
							GUIManager.reference.gui.dialText({mod:1, text:str},0,false,true);
						}
					break;

					case "allact":
						World.w.loc.allAct(null, obj.val, obj.n);
					break;

					case "take":
						if (obj.n < 0) {
							if (ItemManager.reference.hasItem(obj.val)) {
								GameContainer.reference.gg.itemInteraction.withdraw(obj.val, -obj.n);
								GameContainer.reference.pers.setParameters();
							}
						}
						else {
							GameContainer.reference.gg.itemInteraction.take(new Item(obj.val, obj.n));
						}
					break;

					case "takeArmor":
						GameContainer.reference.gg.itemInteraction.addArmor(obj.val);
					break;

					case "fav":
						GameContainer.reference.gg.itemInteraction.favItem(obj.val, obj.n);
					break;

					case "armor":
						GameContainer.reference.gg.changeArmor(obj.val, true);
					break;

					case "xp":
						GameContainer.reference.pers.expa(obj.val, GameContainer.reference.gg.coordinates.X, GameContainer.reference.gg.coordinates.Y);
					break;

					case "perk":
						GameContainer.reference.pers.addPerk(obj.val);
					break;

					case "eff":
						GameContainer.reference.gg.addEffect(obj.val,obj.opt1,obj.opt2);
					break;

					case "remeff": 
						GameContainer.reference.gg.remEffect(obj.val);
					break;

					case "music":
						if (obj.n>0) Sound.playMusic(obj.val, obj.n);
						else Sound.playMusic(obj.val);
					break;

					case "music_rep":
						if (GameContainer.reference.pers.rep>=GameContainer.reference.pers.repGood) Sound.playMusic(obj.val);
					break;

					case "anim":
						GameContainer.reference.gg.anim(obj.val,actObj.opt1>0);
					break;

					case "turn":
						if (obj.val > 0) {
							GameContainer.reference.gg.storona  = E_Direction.RIGHT;
						}
						else {
							GameContainer.reference.gg.storona = E_Direction.LEFT;
						}
						
						GameContainer.reference.gg.velocity.X += GameContainer.reference.gg.storona.X * 3;
					break;

					case "black":
						GameContainer.reference.cam.dblack = 0;
						
						if (obj.val > 0) {
							GUIManager.reference.vblack.visible = true;
						}
						
						GUIManager.reference.vblack.alpha = obj.val;
					break;

					case "dblack":
						GameContainer.reference.cam.dblack = obj.val;
					break;

					case "gui off":
						GUIManager.reference.gui.hpBarOnOff(false);
					break;

					case "gui on":
						GUIManager.reference.gui.hpBarOnOff(true);
					break;

					case "refill":
						World.w.land.refill();
					break;

					case "upland":
						GameContainer.reference.game.upLevelLevel();
					break;

					case "locon":
						World.w.loc.allon();
					break;

					case "locoff":
						World.w.loc.alloff();
					break;

					case "quest":
						GameContainer.reference.game.addQuest(obj.val);
					break;

					case "showstage":
						GameContainer.reference.game.showQuest(obj.val, obj.n);
					break;

					case "show":
						GameContainer.reference.cam.showOn=false;
					break;

					case "stage":
						GameContainer.reference.game.closeQuest(obj.val, obj.n);
					break;

					case "trigger":
						if (obj.n == null) {
                            GameContainer.reference.game.setTrigger(obj.val);
                        }
						else GameContainer.reference.game.setTrigger(obj.val, obj.n);
					break;

					case "goto":		//перейти в комнату
						var distr:Array=obj.val.split(" ");
						if (distr.length==2) land.gotoXY(distr[0],distr[1]);
					break;

					case "gotoland":	//перейти в местность
						if (obj.n==2) GameContainer.reference.game.gotoLevel(obj.val,null,true);
						else if (obj.n==1) GameContainer.reference.game.gotoLevel(obj.val, obj.opt1+":"+obj.opt2);
						else GameContainer.reference.game.gotoLevel(obj.val);
					break;

					case "openland":	//открыть местность на карте
						GameContainer.reference.game.lands[obj.val].access = true;
					break;

					case "passed":		//местность пройдена
						World.w.land.act.passed = true;
					break;

					case "actchallenge":
						if (World.w.loc.challenge) World.w.loc.challenge.activateChallenge();
					break;

					case "alarm":
						World.w.loc.signal();
					break;

					case "trus":
						if (owner && owner.loc) owner.loc.trus=Number(obj.val);
						else World.w.loc.trus=Number(obj.val);
					break;

					case "checkall":
						for each (var un:Unit in World.w.loc.units) {
							un.command("check");
						}
					break;

					case "robots":
						World.w.loc.robocellActivate();
					break;

					case "weapch":
						GameContainer.reference.gg.changeWeapon(obj.val);
					break;

					case "alicorn":
						if (obj.val <= 0) GameContainer.reference.gg.alicornOff();
						else GameContainer.reference.gg.alicornOn();
					break;

					case "wave":
						if (World.w.loc.challenge) World.w.loc.challenge.beginWave();
					break;

					case "pip":
						GUIManager.reference.pip.onoff(obj.val, obj.n);
					break;

					case "speceffect":
						GameContainer.reference.grafon.specEffect(obj.n);
					break;

					case "scene":
						if (obj.val) World.w.showScene(obj.val, obj.n);
						else World.w.unshowScene();
					break;

					case "endgame":
						World.w.endgame();
					break;

					case "gameover":
						World.w.endgame(1);
					break;

					case "wait":
						wait=true;
						dial_n=0;
						GameContainer.reference.ctr.active=false;
					break;

					default:
						trace("Script.as/com() - ERROR: Script action: \"" + obj.act + "\" not found for script: \"" + id + "\"");
					break;
				}
			}
		}
	}
}
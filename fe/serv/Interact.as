package fe.serv {

	import flash.media.SoundChannel;

	import fe.*;
	import fe.loc.*;
	import fe.util.Vector2;
	import fe.entities.Obj;
	import fe.unit.Unit;
	import fe.projectile.Bullet;
	import fe.unit.UnitPlayer;
	import fe.graph.Emitter;

	public class Interact {

		private var inited:Boolean = false;
		public var owner:Obj;
		public var loc:Location;
		public var coordinates:Vector2 = new Vector2();
		
		public var active:Boolean = true;	// [Object is active]
		// [action displayed in GUI]
		public var action:int = 0;		// [Actions that may be performed -- 1 : open, 2 : use, 3 : clear mines]
		public var userAction:String;	// [Specified action (id)]
		
		public var xml:XML;				// [Individual parameter taken from the map]
			
		public var cont:String;			// This item is a loot container
		public var door:int=0;			// This item is a door
		public var knop:int=0;			// This item is a button
		public var expl:int=0;			// This item is a bomb
		
		public var lock:int=0;			// This item is locked (int = lock difficulty)
		public var lockTip:int=1;		// Lock type (0 : Cannot be lockpicked, 1 : Lockpicking, 2 : Hacking, 3 : Mined, 4 : Disable (repair skill), 5 : repair (repair skill))
		
		public var lockLevel:int=0;			// Lock level (Skill requirement to unlock)
		public var lockAtt:int=-100;		// Lockpick attempt count
		public var lockHP:Number=10;		// Lock HP
		public var noRuna:Boolean=false;	// Whether Runes or Master Keys unlock this lock
		public var low:Number=0;			// [Probability of reducing the difficulty of the lock by 2 times]
		public var mine:int=0;				// This lock is mined
		public var mineTip:int=3;			// Mine type -- 3 : explosive, 6 : alarm
		public var damage:Number=0;			// Explosion damage (to creatures?)
		public var destroy:Number=0;		// Explosion damage (to tiles?)
		public var explRadius:Number=260;	// Explosion radius (in pixels?)
		public var damdis:Number=50;		// [Electric shock]
		public var at_once:int=0;			// [1 : apply the main action immediately after hacking or clearing mines, 2 : after that make it inactive]
		public var lockKey:String;			// Name of the key to this lock (UID or in-game name?)
		public var cons:String;				// [reduce the number of keys after successful use: 0 - do not reduce, 1 - use the key immediately, 2 - use only if the lock cannot be opened in any other way]
		public var allDif:Number=-1;		// [total difficulty of lock and bomb]
		public var xp:int=0;				// [experience for disarming]
		
		public var allact:String;			// [specified action for the entire room]
		public var allid:String;			// [id for a given action]
		public var needSkill:String;
		public var needSkillLvl:int=0;
		public var is_hack:Boolean=false;	// [controlled by access terminal]
		public var open:Boolean=false;		// [open]
		public var prob:String=null;		// [transition to trial]
		public var noBase:Boolean=false;	// [base rules don't work here]
		public var prize:Boolean=false;		// [challenge prize container]
		
		public var is_act:Boolean=false;
		public var is_ready:Boolean=true
		public var t_action:int=0;
		public var unlock:int=0;			// [burglary ability]
		public var master:int=0;			// [hacking skill]
		
		public var stateText:String = "";
		public var actionText:String = "";
		public var sndAct:String = "";
		
		public var successUnlock:Function;
		public var fiascoUnlock:Function;
		public var successRemine:Function;
		public var fiascoRemine:Function;
		public var actFun:Function;
		
		public var area:Area;		// [pinned area]
		
		public var sign:int=0;		// [pointer]
		private var t_sign:int = 0;
		
		public var isMove:Boolean=false;		// [there is movement]
		private var begX:Number=0, begY:Number=0, endX:Number=0, endY:Number=0, endX2:Number=0;	// [coordinates of the starting and ending point]
		private var t_move:Number=0, dt_move:Number=1;		// [timer]
		public var tStay:int=10, tMove:int=100;		// [time to stand and time to move]
		public var moveSt:int=0;					// [movement mode 0-stand, 1-from beginning to end, 2-from end to beginning, 3-from one end to another, 4-continuously]
		private var moveP:Boolean=false;			// [if true, then there is movement at this moment, if false, then there is a stop]
		public var moveCh:SoundChannel;
		
		private var lootBroken:Boolean=false;
		
		public var autoClose:int=0;
		private var t_autoClose:int=0;
		private var t_budilo:int=0;
		
		public var scrAct:Script, scrOpen:Script, scrClose:Script, scrTouch:Script;
		
		// [state changes that persist]
		private var saveMine:int = 0;		// [101 - the mine is neutralized or goes off]
		private var saveLock:int = 0;		// [101 - open, 102 - jammed]
		public var saveLoot:int = 0;		// [1 - loot received, 2 - loot received, there is critical loot]
		private var saveOpen:int = 0;		// [1 - open]
		private var saveExpl:int = 0;
		
		public const maxLockLvl:int = 24;
		public const maxMechLvl:int = 7;
		
		public static var chanceUnlock:Array  = [0.90, 0.75, 0.50, 0.30, 0.15, 0.05, 0.01];
		public static var chanceUnlock2:Array = [0.95, 0.80, 0.55, 0.35, 0.20, 0.08, 0.03];

		private static var tileX:int = Tile.tileX;
		private static var tileY:int = Tile.tileY;
		
		// [node - template, xml - individual parameter taken from the map]
		public function Interact(own:Obj, node:XML=null, nxml:XML=null, loadObj:Object=null) {
			owner=own;
			loc=owner.loc;
			coordinates.X = own.coordinates.X;
			coordinates.Y = own.coordinates.Y;
			xml = nxml;
			var rnd:Boolean = true;
			
			// [if the property is set='1', there will be no random parameters]
			if (xml && xml.@set.length()) {
				rnd = false;
			}
			
			// [lock type]
			if (node && node.@locktip.length()) {
				lockTip=node.@locktip;
			}
			
			if (xml && xml.@locktip.length()) {
				lockTip=xml.@locktip;
			}
			
			if (node) {
				// [contents]
				if (node.@cont.length()) {
					cont=node.@cont;
				}
				
				// [lock]
				if (node.@lock.length()) {
					var lk:Number=Number(node.@lock);
					
					if (rnd) {		// [random lock]
						if (node.@lockch.length()==0 || Math.random()<Number(node.@lockch)) {
							if (lockTip==1 || lockTip==2) {
								lock=Math.floor(lk+(0.3+Math.random())*loc.locksLevel);
							}
							else {
								lock=Math.floor(lk+Math.random()*loc.mechLevel);
							}
						}
						
						if (Math.random()<lk-Math.floor(lk)) {
							lock+=1;
						}
					}
					else {		// [given lock]
						lock=Math.floor(lk);
					}
				}
				
				if (node.@low.length()) {
					low=node.@low;
				}
				
				saveLock=lock;
				
				// [lock hp]
				if (node.@lockhp.length()) lockHP=node.@lockhp;
				
				// [mined]
				if (node.@mine.length()) {
					if (rnd) {
						if (node.@minech.length()) {
							if (Math.random() < Number(node.@minech))	{
								mine = Math.floor(Math.random() * (Number(node.@mine) + Math.random() * loc.mechLevel + 1));
							}
						}
						else {
							mine = Math.floor(Number(node.@mine) + Math.random() * loc.mechLevel);
						}
						
						if (mine >= 2 && Math.random() < 0.25) {
							mine--;
						}
					}
					else {
						mine = node.@mine;
					}
					
					if (node.@minetip.length()) {
						mineTip = node.@minetip;
					}
					else if (node.@inter != "3" && Math.random() < 0.4) {
						mineTip = 6;
					}
				}
				
				saveMine=mine;
				
				// [can be hacked]
				if (node.@hack > 0) {
					is_hack = true;
				}
				
				// [general action]
				if (node.@allact.length()) {
					allact = node.@allact;
				}

				// Actions 
				action = node.@inter;
				if (node.@xp.length()) xp=node.@xp;
				if (node.@once.length()) at_once=node.@once;
				if (node.@door.length()) door=node.@door;
				if (node.@knop.length()) knop=node.@knop;
				if (node.@time.length()) t_action=node.@time;
				if (node.@expl.length()) expl=node.@expl;
				if (node.@autoclose.length()) autoClose=node.@autoclose;
			}
			if (xml) {
				if (xml.@off.length()) active=false;
				if (xml.@open.length()) {
					setAct("open",1);
					update();
				}
				if (xml.@cont.length()) cont=xml.@cont;
				if (xml.@lock.length()) {
					lock=xml.@lock;
					saveLock=lock;
					low=0;
					if (xml.@lock=="0") mine=saveMine=0;
				}
				if (xml.@locklevel.length()) lockLevel=xml.@locklevel;
				if (xml.@key.length()) lockKey=xml.@key;
				if (xml.@cons.length()) cons=xml.@cons;
				if (xml.@lockhp.length()) lockHP=xml.@lockhp;
				if (xml.@lockatt.length()) lockAtt=xml.@lockatt;
				if (xml.@mine.length()) {
					mine=xml.@mine;
					saveMine=mine;
				}
				if (xml.@minetip.length()) mineTip=xml.@minetip;
				if (xml.@autoclose.length()) autoClose=xml.@autoclose;
				if (xml.@hack.length()) is_hack=xml.@hack>0;
				if (xml.@allact.length()) allact=xml.@allact;
				if (xml.@allid.length()) allid=xml.@allid;
				if (xml.@prob.length()) prob=xml.@prob;
				if (xml.@inter.length()) action=xml.@inter;
				if (xml.@time.length()) t_action=xml.@time;
				if (xml.@knop.length()) knop=xml.@knop;
				if (xml.@damage.length()) damage=xml.@damage;
				if (xml.@prize.length()) prize=true;
				if (xml.@nobase.length()) noBase=true;
				if (xml.@noruna.length()) noRuna=true;
				if (xml.@sign.length()) sign=xml.@sign;
				
				if (xml.move.length()) {
					isMove=true;
					begX = coordinates.X;
					begY = coordinates.Y;
					if (xml.move.@dx.length()) {
						if (loc && loc.mirror) endX = coordinates.X - xml.move.@dx * tileX;
						else endX = coordinates.X + xml.move.@dx * tileX;
					}
					else {
						endX	= coordinates.X;
						endX2	= coordinates.X;
					}
					if (xml.move.@dy.length()) endY = coordinates.Y + xml.move.@dy * tileY;
					else endY = coordinates.Y;
					if (xml.move.@tstay.length()) tStay = xml.move.@tstay;
					if (xml.move.@tmove.length()) tMove = xml.move.@tmove;
					if (xml.move.@on.length()) moveSt = 4;
				}
			}
			if (loc && loc.base && cont!=null && !noBase) {
				cont=null;
				lock=mine=saveMine=saveLock=0;
				action=0;
				active=false;
			}
			if (loc && (loc.homeStable) && !noBase) {
				lock=mine=saveMine=saveLock=0;
			}
			if (loc && (loc.homeAtk) && !noBase) {
				lock=mine=saveMine=saveLock=0;
				if (cont && own is Box) {
					setAct("loot",1);
				}
			}
			if (loadObj) load(loadObj);
			var difSet:Boolean=(allDif>=0);
			if (lock<100) {
				if (lockTip==1 || lockTip==2) {
					if (low>0 && Math.random()<low) lock=Math.ceil(lock*0.5);
					if (lock>maxLockLvl) lock=maxLockLvl;
					if (lock>0 && low<=0 && own && own.loc && own.loc.land.rnd && own.loc.prob==null && Math.random()<0.2) lock += int(Math.random()*2)+2;
					// [determine the lock level]
					if (lock>2 && lockLevel==0) {
						lockLevel = Math.round(Math.random()*(lock-2)/3.2);
						if (lockLevel>5) lockLevel=5;
					}
					if (!difSet) allDif=lock+lockLevel*2;
				}
				else {
					if (lock>maxMechLvl) lock=maxMechLvl;
					if (!difSet) allDif=lock*3;
				}
			}
			if (mine>maxMechLvl) mine=maxMechLvl;
			if (mine>0) {
				if (mineTip==6) {
					fiascoRemine=alarm;
				} else {
					damage=mine*50*(0.8+Math.random()*0.4)*(1+loc.locDifLevel*0.1);
					fiascoRemine=explosion;
				}
				if (!difSet) allDif+=mine*2;
			}
			if (loc) {
				damdis=30+loc.mechLevel*20;
			}
			if (expl>0) {
				if (node.@damage.length()) damage=node.@damage;
				if (node.@destroy.length()) destroy=node.@destroy;
				if (node.@radius.length()) explRadius=node.@radius;
			}
			if (allact == "robocell") {
				fiascoUnlock = robocellFail;
			}
			if (allact=="alarm") {
				fiascoRemine = alarm2;
				if (owner)
				{
					area = new Area(loc);
					owner.copy(area);
					area.tip = "raider";
					area.over = alarm2;
				}
			}
			if (prize) {
				mine=0;
				lockTip=0;
				lock=1;
			}
			
			update();
			owner.prior+=1;
			inited=true;
		}
		
		public function save(obj:Object):void {
			obj.lock=saveLock;
			obj.lockLevel=lockLevel;
			obj.mine=saveMine;
			obj.loot=saveLoot;
			obj.open=saveOpen;
			obj.expl=saveExpl;
			obj.dif=allDif;
			obj.sign=sign;
		}
		
		public function step():void {
			if (is_act) act();
			else is_ready=true;
			is_act=false;
			if (isMove) move();
			if (area) area.step();
			if (t_autoClose>0) {
				t_autoClose--;
				if (t_autoClose==1) command("close");
			}
			if (t_budilo>0) {
				if (t_budilo%30==0) {
					loc.budilo(owner.coordinates.X, owner.coordinates.Y,1500);
					Emitter.emit("laser2",loc, owner.coordinates.X, owner.coordinates.Y - owner.boundingBox.height + 20);
					Snd.ps("alarm", coordinates.X, coordinates.Y);
				}
				t_budilo--;
			}
			if (sign>0) {
				if (t_sign<=0) {
					t_sign=30;
					if (World.w.helpMess) Emitter.emit("sign" + sign, loc, owner.coordinates.X, owner.coordinates.Y - owner.boundingBox.halfHeight);
				}
				t_sign--;
			}
		}
		
		public function update():void {
			if (userAction && userAction != "") {
				 actionText = LanguageManager.reference.localText("gui", userAction);
			}
			else {
				if (active && action) {
					switch (action) {
						case 1:
							actionText = LanguageManager.reference.localText("gui", open ? "close" : "open");
						break;

						case 2:
							actionText = LanguageManager.reference.localText("gui", "use"); 
						break;

						case 3:
							actionText = LanguageManager.reference.localText("gui", "remine"); 
						break;

						case 4:
							actionText = LanguageManager.reference.localText("gui", "press"); 
						break;

						case 5:
							actionText = LanguageManager.reference.localText("gui", "shutoff"); 
						break;

						case 8:
							actionText = LanguageManager.reference.localText("gui", "comein"); 
						break;

						case 9:
							actionText = LanguageManager.reference.localText("gui", "exit"); 
						break;

						case 10:
							actionText = LanguageManager.reference.localText("gui", "beginm"); 
						break;

						case 11:
							actionText = LanguageManager.reference.localText("gui", "return"); 
						break;

						case 12:
							actionText = LanguageManager.reference.localText("gui", "see"); 
						break;

						default:
							actionText = "";
						break;
					}
				}
			}
			
			if (mine) {
				if (mineTip == 6) {
					stateText="<span class = 'r2'>"+LanguageManager.reference.localText("gui", "signal")+"</span>";
					actionText=LanguageManager.reference.localText("gui", "shutoff");
				}
				else {
					if (owner is Box) stateText="<span class = 'warn'>"+LanguageManager.reference.localText("gui", "mined")+"</span>";
					actionText=LanguageManager.reference.localText("gui", "remine");
				}
				sndAct = "rem_act";
			}
			else if (lock) {
				switch (lockTip) {
					case 0:
						stateText = "<span class = 'r2'>" + LanguageManager.reference.localText("gui", "lock") + "</span>";
						actionText = "";
						sndAct = "lock_act";
					break;

					case 1:
						if (lock >= 100) stateText = "<span class = 'r3'>" + LanguageManager.reference.localText("gui", "zhopa") + "</span>";
						else stateText = "<span class = 'r2'>" + LanguageManager.reference.localText("gui", "lock") + "</span>";
						actionText = LanguageManager.reference.localText("gui", "unlock");
						sndAct = "lock_act";
					break;

					case 2:
						if (lock >= 100) stateText = "<span class = 'r3'>" + LanguageManager.reference.localText("gui", "block") + "</span>";
						else stateText = "<span class = 'r2'>" + LanguageManager.reference.localText("gui", "termlock") + "</span>";
						actionText = LanguageManager.reference.localText("gui", "termunlock"); 
						sndAct = "term_act";
					break;

					case 4:
						actionText = LanguageManager.reference.localText("gui", "shutoff");
						sndAct = "rem_act";
					break;

					case 5:
						actionText = LanguageManager.reference.localText("gui", "fixup");
						sndAct = "rem_act";
					break;
				}
			}
			else if (cont == "empty") {
				stateText = "<span class = 'r0'>" + LanguageManager.reference.localText("gui", "empty") + "</span>";
			}
			else {
				stateText = "";
			}
		}
		
		// [set state]
		public function setAct(a:String, n:int = 0):void {
			if (a == "mine") {
				if (n < 100) {
					mine = n;
					saveMine = mine;
				}
				if (n == 101) {
					mine = 0;
					saveMine = 101;
					owner.warn = 0;
				}
			}
			if (a == "lock") {
				if (n < 100) {
					lock = n;
					saveLock = lock;
				}
				if (n == 101) {
					saveLock = 101;
					lock = 0;
					stateText = "";
				}
				if (n == 102) {
					saveLock = 102;
					lock = 100;
					if (lockTip == 1) stateText="<span class = 'r3'>" + LanguageManager.reference.localText("gui", "zhopa") + "</span>";
					if (lockTip == 2) stateText="<span class = 'r3'>" + LanguageManager.reference.localText("gui", "block") + "</span>";
					if (lockTip == 5) stateText="<span class = 'r3'>" + LanguageManager.reference.localText("gui", "broken") + "</span>";
				}
			}
			if (a=="loot") {
				if (n>0) {
					saveLoot=n;
					active=false;
					cont="empty";
					actionText="";
					owner.setVisState("open");
				}
			}
			if (a=="open") {
				if (autoClose==0) saveOpen=n;
				open=(n==1);
				if (door) setDoor();
				if (knop) {
					if (open) owner.setVisState("open");
					else owner.setVisState("close");
				}
				if (open) {
					lock=mine=0;
					update();
				}
				if (open && (allact=="robocell" || allact=="alarm")) {
					allact="";
					active=false;
					owner.setVisState("open");
				}
				if (loc && loc.prob && loc.active) loc.prob.check();
			}
			if (a == "expl") saveExpl = n;
		}
		
		// [perform an action]
		public function act():void {
			var verZhopa:int = 0;
			var verFail:int = 0;
			if (action==0) return;
			
			if (scrTouch) {
				scrTouch.start();
				scrTouch=null;
				return;
			}
			
			if (needSkill && needSkillLvl>unlock) {
				World.w.gui.infoText("needSkill", Res.txt("e",needSkill), needSkillLvl,false);	// [skill required]
			}
			else if (mine>0) {
				verZhopa=0;
				verFail=0;
                if (mine>unlock) verZhopa=(mine-unlock+1)*0.15;
                verFail=(mine-unlock+2)*0.2;
                if (Math.random()<verZhopa) {	// [critical failure]
                    setAct("mine",101);
                    if (mineTip==6) World.w.gui.infoText("signalZhopa");	// [the alarm went off]
                    else World.w.gui.infoText("remineZhopa");	// [the bomb went off]
                    if (fiascoRemine!=null) fiascoRemine();
                    if (at_once>0) {
                        actOsn();
                    }
                    replic("zhopa");
                    update();
                }
				else if (Math.random()<verFail) { // [failure]
                    if (mineTip==6) World.w.gui.infoText("signalFail",null,null,false);	// [the alarm is not disarmed]
                    else World.w.gui.infoText("remineFail",null,null,false);	// [the bomb is not defused]
                    replic("fail");
                }
				else {						// [success]
                    setAct("mine",101);
                    if (mineTip==6) World.w.gui.infoText("signalOff");	// [alarm disabled]
                    else  World.w.gui.infoText("remine");	// [the bomb is defused]
                    if (successRemine!=null) successRemine();
                    if (at_once>0) {
                        actOsn();
                    }
                    replic("success");
                    update();
                }
				
				World.w.gui.bulb(coordinates.X, coordinates.Y);
				unlock=0;
				is_ready=false;
			}
			else if (lock>0 && lockKey && World.w.gg.invent.getQuantity(lockKey) > 0) {
				setAct("lock",101);
				if (lockTip==1) World.w.gui.infoText("unLockKey");
				if (lockTip==2) World.w.gui.infoText("unTermLock");
				if (lockTip==4) World.w.gui.infoText("unRepLock");
				if (lockTip==5) World.w.gui.infoText("unFixPart");
				
				update();
				
				if (successUnlock!=null) successUnlock();
			}
			else if (lock > 0) {
				if (unlock > -99) {
					var lockDam1:Number = 0;
					var lockDam2:Number = 2;
					verFail = 0;
					
					if (lockTip==1 || lockTip==5) {
						verFail = 1 - this.getChance(lock - unlock);
						
						if (master<lockLevel) {
							verFail=1;
						}
						
						if (lock-unlock==1) {
							lockDam1=1;
							lockDam2=3;
						}
						else if (lock-unlock>1){
							lockDam1=2;
							lockDam2=4;
						}
					}
					else if (lockTip == 2) {
						verFail = 1 - this.getChance(lock-unlock);
						
						if (master < lockLevel) {
							verFail = 1;
						}
					}
					else if (lockTip == 4) {
						if (lock-unlock<0) verFail=0.1;
						else if (lock-unlock==0) verFail=0.25;
						else if (lock-unlock==1) verFail=0.6;
						else if (lock-unlock==2) verFail=0.85;
						else verFail=1;
						
						lockDam1=2;
						lockDam2=4;
					}
					
					var lockDam:Number = lockDam1;
					
					if (Math.random() < verFail) { // [failure]	
						if (lockTip==1) {
							var pinCrack:Boolean=false;
							
							if (World.w.gg.invent.getQuantity("pin") > 0) {
								
								if (World.w.pers.pinBreak>=1 || Math.random()<World.w.pers.pinBreak) {
									World.w.gg.invent.decreaseQuantity("pin");
									pinCrack = true;
								}
							}
							else {
								lockDam1+=2;
							}
							
							lockDam=(lockDam1+Math.random()*lockDam2)*World.w.pers.lockAtt;
							lockHP-=lockDam;
							
							if (lockHP<=0) {		// [The lock is jammed]
								setAct("lock",102);
								World.w.gui.infoText("unLockZhopa");
								if (fiascoUnlock!=null) fiascoUnlock();
								replic("zhopa");
							}
							else if (pinCrack) {
								World.w.gui.infoText("unLockFailP", null,null,false);	// [the lock is not open, the hairpin is broken]
								replic("fail");
							}
							else if (lockHP>100) {
								World.w.gui.infoText("unLockFailA", null,null,false);	// [the lock is not open, try again]
							}
							else {
								World.w.gui.infoText("unLockFail",null,null,false);		// [the lock is not open]
								replic("fail");
							}
						}
						else if (lockTip==2) {
							if (lockAtt==-100) lockAtt=World.w.pers.hackAtt;
							lockAtt--;
							if (lockAtt>10) World.w.gui.infoText("unTermLockFail2",null,null,false);	// [the terminal is not hacked]
							else if (lockAtt>1) {
								World.w.gui.infoText("unTermLockFail",lockAtt,null,false);	// [the terminal is not hacked]
								replic("fail");
							}
							else if (lockAtt==1) {
								World.w.gui.infoText("unTermLockFail1",null,null,false);	// [the terminal is not hacked]
								replic("fail");
							}
							else {					// [terminal is blocked]
								setAct("lock",102);
								replic("zhopa");
								World.w.gui.infoText("unLockBlock");
								if (fiascoUnlock!=null) fiascoUnlock();
							}
						}
						else if (lockTip==4) {		// [disabling using the repair skill]
							var lockDam3:Number = (lockDam1+Math.random()*lockDam2);
							lockHP-=lockDam3;
							if (lockHP<=0) {		// [Electric shock]
								discharge();
								World.w.gui.infoText("unRepZhopa",null,null,false);
								replic("zhopa");
								if (fiascoUnlock!=null) fiascoUnlock();
							}
							else {
								World.w.gui.infoText("unRepFail",null,null,false);	// [the lock is not open]
								replic("fail");
							}
						}
						else if (lockTip==5) {		// [mechanism repair]
							lockDam=(lockDam1+Math.random()*lockDam2);
							lockHP-=lockDam;
							if (lockHP<=0) {		// [The lock is jammed]
								setAct("lock",102);
								World.w.gui.infoText("unFixZhopa");
								replic("zhopa");
								if (fiascoUnlock!=null) fiascoUnlock();
							}
							else {
								World.w.gui.infoText("unFixFail",null,null,false);	// [the lock is not open]
								replic("fail");
							}
						}
					}
					else {						// [success] // [lock is open]
						setAct("lock", 101);
						
						if (lockTip == 1) {
							World.w.gui.infoText("unLock");
							
							if (Math.random() < 0.8) {
								replic("success");
							}
							else {
								replic("unlock");
							}
						}
						
						if (lockTip==2) {
							World.w.gui.infoText("unTermLock");
							
							if (Math.random() < 0.8) {
								replic("success");
							}
							else {
								replic("hack");
							}
						}
						
						if (lockTip==4) {
							World.w.gui.infoText("unRepLock");
							replic("success");
						}
						
						if (lockTip==5) {
							World.w.gui.infoText("unFixLock");
							replic("success");
						}
						
						if (successUnlock!=null) {
							successUnlock();
						}
						
						if (at_once>0) {
							actOsn();
						}
						
						update();
					}
					World.w.gui.bulb(owner.coordinates.X, owner.coordinates.Y);
				}
				else {
					World.w.gui.infoText("noPoss",null,null,false);
					World.w.gui.bulb(owner.coordinates.X, owner.coordinates.Y);
				}
				
				unlock = 0;
				is_ready = false;
			}
			else if (is_ready) {
				actOsn();
			}
			
			is_ready = false;
		}
		
		public function getChance(dif:int):Number {
			if (dif < -2) {
				return 1;
			}
			
			if (dif > 4) {
				return 0;
			}
			
			if (World.w.pers.upChance > 0) {
				return chanceUnlock2[dif + 2];
			}

			return chanceUnlock[dif + 2]
		}
		
		// [Perform the main action]
		public function actOsn():void {
			if (cons) {
				if (World.w.gg.invent.getQuantity(cons) > 0) {
					World.w.gg.invent.decreaseQuantity(cons);
					World.w.gui.infoText("usedCons", LanguageManager.reference.localText("item", cons));
					if (cons == "empbomb") {
						Emitter.emit("impexpl", loc, owner.coordinates.X, owner.coordinates.Y - owner.boundingBox.halfHeight);
					}
				}
				else {
					World.w.gui.infoText("needCons", LanguageManager.reference.localText("item", cons), null, false);
					return;
				}
			}
			
			if (actFun) {
				actFun();
			}
			
			if (cont != null) {
				loot();
			}
			
			sign = 0;
			
			if (expl) {
				owner.die();
			}
			
			if ((door > 0 || knop > 0) && action > 0) {
				open =! open;
				setAct("open", (open ? 1 : 0));
				
				if (open && scrOpen) {
					scrOpen.start();
				}
				
				if (!open && scrClose) {
					scrClose.start();
				}
				
				if (open) {
					t_autoClose = autoClose;
				}
				
				if (door > 0 && World.w.pers.noiseDoorOpen) {
					World.w.gg.makeNoise(World.w.pers.noiseDoorOpen, true);
				}
			}
			
			if (allact || prob != null) {
				allAct();
			}
			
			if (loc && loc.prob) {
				loc.prob.check();
			}
			
			if (scrAct) {
				scrAct.start();
			}
			
			update();
		}
		
		// [Break the container]
		public function dieCont():void {
			lootBroken = true;
			
			if (cont!=null) {
				loot();
			}
			
			if (mine) {
				setAct("mine", 101);
				World.w.gui.infoText("remineZhopa");	// [The bomb went off]
				
				if (fiascoRemine != null) {
					fiascoRemine();
				}
			}
			
			open = true;
			setAct("open", 1);
			
			if (scrOpen) {
				scrOpen.start();
			}
			
			update();
		}
		
		public function load(obj:Object):void {
			if (obj==null) {
				return;
			}
			
			if (obj.lock!=null) {
				setAct("lock",obj.lock);
			}
			
			if (obj.lockLevel!=null) {
				lockLevel=obj.lockLevel;
			}
			
			if (obj.dif!=null) {
				allDif=obj.dif;
			}
			
			if (obj.mine!=null) {
				setAct("mine",obj.mine);
			}
			
			if (obj.loot!=null) {
				if (obj.loot==2) {
					loot(true);	// [If the state is 2, generate critical loot]
				}
				setAct("loot",obj.loot);
			}
			
			if (obj.open!=null) {
				setAct("open",obj.open);
			}
			
			if (obj.expl!=null) {
				setAct("expl",obj.expl);
			}
			
			if (obj.sign!=null) {
				sign=obj.sign;
			}
		}

		public function setDoor():void {
			if (inited && !open && (owner as Box).attDoor()) {
				open = true;
				
				if (t_autoClose <= 0) {
					World.w.gui.infoText("noClose", null, null, false);
				}
				
				return;
			}
			
			(owner as Box).setDoor(open);
		}
		
		// [Unsuccessful attempt to clear mines - explosion]
		public function explosion():void {
			if (saveExpl) {
				return;
			}
			
			var un:Unit = new Unit();
			un.loc = loc;
			var bul:Bullet = new Bullet(un, owner.coordinates, null, false);
			bul.iExpl(damage, destroy, explRadius);
			setAct("expl", 1);
			if (expl) {
				owner.die();
			}
		}
		
		// [Unsuccessful attempt to hack the force field - electric shock]
		public function discharge():void {
			World.w.gg.electroDamage(damdis * (Math.random() * 0.4 + 0.8), owner.coordinates.X, owner.coordinates.Y - owner.boundingBox.halfHeight);
			damdis += 50;
			if (damdis > 500) {
				damdis = 500;
			}
		}
		
		// [Unsuccessful turn off alarm - alarm]
		public function alarm():void {
			if (saveExpl) {
				return;
			}
			
			t_budilo = 240;
			setAct("expl", 1);
			loc.signal();
			loc.robocellActivate();
		}
		
		// [Failed attempt to disable panic button]
		public function alarm2():void {
			if (allact!="alarm") {
				return;
			}
			
			t_budilo=240;
			loc.signal();
			area=null;
			active=false;
			allact="";
			update();
			owner.setVisState("active");
		}
		
		// [Unsuccessful attempt to break into a robot cell - alarm]
		public function robocellFail():void {
			loc.robocellActivate();
		}
		
		// [Create a robot]
		public function genRobot():void {
			if (allact!="robocell") {
				return;
			}

			loc.createUnit("robot", coordinates.X, coordinates.Y, true, null, null, 30);
			allact = "";
			update();
			owner.setVisState("active");
		}
		
		public function needRuna(gg:UnitPlayer):int {
			if (mineTip == 6 && mine > 0) {
				return 1;
			}
			
			if (noRuna || lock == 0) {
				return 0;
			}
			
			if (gg.invent == null || mine > 0) {
				return 0;
			}
			
			var pick:int = gg.pers.getLockTip(lockTip);
			var master:int = gg.pers.getLockMaster(lockTip)
			
			if (lockTip == 1 && World.w.gg.invent.getQuantity("runa") > 0 && (lock - pick > 1 || lockLevel > master)) {
				return 1;
			}
			
			if (lockTip == 2 && World.w.gg.invent.getQuantity("reboot") > 0 && (lock - pick > 1 || lockLevel > master)) {
				return 1;
			}
			
			return 0;
		}

		public function useRuna(gg:UnitPlayer):void {
			if (mineTip == 6 && mine > 0) {
				if (fiascoRemine != null) {
					fiascoRemine();
				}
				
				setAct("mine", 101);
				
				if (at_once>0) {
					actOsn();
				}
				
				update();
				
				return;
			}
			
			if (gg.invent==null) {
				return;
			}
			
			if (lockTip == 1 && lock > 0 && World.w.gg.invent.getQuantity("runa") > 0) {
				command("unlock");
				World.w.gg.invent.decreaseQuantity("runa");
				World.w.gui.infoText("useRuna");
				World.w.gui.bulb(owner.coordinates.X, owner.coordinates.Y);
			}
			
			if (lockTip == 2 && lock > 0 && World.w.gg.invent.getQuantity("reboot") > 0) {
				command("unlock");
				World.w.gg.invent.decreaseQuantity("reboot");
				World.w.gui.infoText("useReboot");
				World.w.gui.bulb(owner.coordinates.X, owner.coordinates.Y);
			}
		}
		
		public function off():void {
				stateText = "";
				active = false;
				lock = 0;
		}
		
		public function allAct():void {
			if (prob != null) {
				if (World.w.possiblyOut() == 2) {
					World.w.gui.infoText("noOutLoc", null, null, false);
					return;
				}
				
				loc.land.gotoProb(prob, owner.coordinates.X, owner.coordinates.Y);
			}
			else if (allact=="probreturn") {
				if (loc.landProb!="") {
					if (World.w.possiblyOut()==2) {
						World.w.gui.infoText("noOutLoc",null,null,false);
						return;
					}
					
					loc.land.gotoProb("", owner.coordinates.X, owner.coordinates.Y);
				}
			}
			else if (allact=="hack_robot") {
				World.w.gui.infoText("term1Act");
				World.w.gui.bulb(coordinates.X, coordinates.Y);
				for each (var un:Unit in owner.loc.units) un.hack(World.w.pers.security);				
			}
			else if (allact=="hack_lock") {
				World.w.gui.infoText("term2Act");
				World.w.gui.bulb(coordinates.X, coordinates.Y);
				for each (var obj:Obj in owner.loc.objs) {
					if (obj.inter) obj.inter.command("hack");
				}
			}
			else if (allact=="prob_help") {
				if (loc.prob) loc.prob.showHelp();
			}
			else if (allact=="electro_check") {
				loc.electroCheck();
				if (loc.electroDam<=0) World.w.gui.infoText("electroOff",null,null,true);
				else World.w.gui.infoText("electroOn",null,null,true);
			} 
			else if (allact == "comein") {
				trace("Interacting with door at coordinates: (" + coordinates.X + ", " + coordinates.Y + ")");
		 		World.w.gg.outLoc(5, coordinates.X, coordinates.Y);
			}
			else if (allact=="bind") {
				World.w.gg.bindChain(coordinates.X, coordinates.Y - 20);
			}
			else if (allact=="work" || allact=="lab" || allact=="stove") {
				World.w.pip.workTip=allact;
				World.w.pip.onoff(7);
			}
			else if (allact=="app") {
				World.w.pip.onoff(8);
			}
			else if (allact=="map") {
				World.w.pip.travel=true;
				World.w.pip.onoff(3,3);
				World.w.pip.travel=true;
			}
			else if (allact=="stand") {
				World.w.stand.onoff(1);
			}
			else if (allact=="exit") {
				World.w.game.gotoNextLevel();
			}
			else if (allact=="robocell") {
				World.w.gui.infoText("robocellOff");
				setAct("open",1);
			}
			else if (allact=="alarm") {
				World.w.gui.infoText("alarmOff");
				setAct("open",1);
			}
			else if (allact=="vault") {
				World.w.pip.onoff(9);
			}
			else {
				owner.loc.allAct(owner,allact,allid);
			}
		}
		
		// [The beginning of a continuous action on an object]
		public function beginAct():void {
			if (allact == "comein") {
				owner.setVisState("comein");
			}
		}
		
		public function shine():void {
			Emitter.emit("unlock", loc, owner.coordinates.X, owner.coordinates.Y - owner.boundingBox.halfHeight, {kol:10, rx:owner.boundingBox.width, ry:owner.boundingBox.height, dframe:6});
		}
		
		public function signal(n:String):void {
			Emitter.emit(n, loc, owner.coordinates.X, owner.coordinates.Y - owner.boundingBox.halfHeight, {kol:6, rx:owner.boundingBox.halfWidth, ry:owner.boundingBox.height*0.8});
		}
		
		
		public function command(com:String, val:String = null):void {
			switch(com) {
				case "hack":
					if (is_hack) {
						active = true;
						setAct("mine", 101);
						setAct("lock", 101);
						if (at_once > 0) {
							actOsn();
						}
						update();
						shine();
					}
					break;
				
				case "unlock":
					active = true;
					setAct("mine", 101);
					setAct("lock", 101);
					update();
					shine();
					break;
				
				case "open":
					open = true;
					setAct("open", 1);
					t_autoClose = autoClose;
					if (allact && val != "13") {
						allAct();
					}
					break;
				
				case "close":
					open = false;
					setAct("open", 0);
					if (open) {
						t_autoClose = 150;
					}
					if (allact && val != "13") {
						allAct();
					}
					break;
				
				case "dam":
					if (expl) {
						explosion();
					} else if (knop && action == 0) {
						setAct("open", 1);
						if (loc.prob) {
							loc.prob.check();
						}
					} else {
						actOsn();
					}
					break;
				
				case "swap":
					open = !open;
					setAct("open", open ? 1 : 0);
					break;
				
				case "sign":
					sign = int(val);
					break;
				
				case "off":
					active = false;
					break;
				
				case "red":
					signal("red");
					break;
				
				case "green":
					signal("green");
					break;
				
				case "stop":
					if (isMove) {
						moveSt = 0;
					}
					break;
				
				case "move":
					if (isMove) {
						moveSt = 4;
					}
					break;
				
				case "pop":
					if (isMove) {
						moveSt = (moveSt == 0) ? 4 : 0;
					}
					break;
				
				case "move1":
					if (isMove) {
						moveTo(1);
					}
					break;
				
				case "move2":
					if (isMove) {
						moveTo(2);
					}
					break;
				
				case "move3":
					if (isMove) {
						moveTo(3);
					}
					break;
				
				default:
					trace("Interact.as/command() - Uknown command:" + com);
					break;
			}
		}
		
		public function move():void {
			if (isMove && moveSt > 0) {
				var f:Number;
				var pp:Boolean = moveP;
				
				if (dt_move < 1) {
					dt_move += 0.1;
				}
				
				if (t_move >= 0 && t_move < tStay) {	// [we stand at the beginning]
					moveP = false;
					
					if (moveSt == 2 || moveSt == 3) {
						moveSt = 0;
					}
				}
				
				if (t_move>=tStay && t_move<tStay+tMove) { // [moving from beginning to end]
					moveP=true;
					f=(t_move-tStay)/tMove;
				}
				else if (t_move>=tStay+tMove && t_move<tStay+tMove+tStay) { // [standing at the end]
					moveP=false;
					f=1;
					
					if (moveSt==1 || moveSt==3) {
						moveSt=0;
					}
				}
				else if (t_move>=tStay+tMove+tStay && t_move<(tStay+tMove)*2) { // [moving from end to beginning]
					moveP=true;
					f=((tStay+tMove)*2-t_move)/tMove;
				}
				else {
					moveP=false;
					f=0;
				}
				
				if (pp!=moveP) {
					if (moveP) sound("move");
					else sound("stop");
				}
				
				var v:Vector2 = new Vector2( (begX + (endX - begX) * f), (begY + (endY - begY) * f) );
				owner.bindMove(v);
				coordinates.setVector(v);
				
				t_move += dt_move;
				
				if (t_move>=(tStay+tMove)*2) {
					t_move = 0;
				}
			}
		}
		
		public function moveTo(n:int):void {
			moveSt=n;
			if (n==1) {
				if (t_move>=0 && t_move<tStay) { // [we stand at the beginning]
					t_move=tStay;
				}
				
				if (t_move>=tStay+tMove && t_move<tStay+tMove+tStay) { // [standing at the end]
					moveSt=0;
				}
			}
			if (n==2) {
				if (t_move>=0 && t_move<tStay) { // [we stand at the beginning]
					moveSt=0;
				}
				
				if (t_move>=tStay+tMove && t_move<tStay+tMove+tStay) { // [standing at the end]
					t_move=tStay+tMove+tStay;
				}
			}
			if (n==3) {
				if (t_move>=0 && t_move<tStay) { // [we stand at the beginning]
					t_move=tStay;
				}
				if (t_move>=tStay+tMove && t_move<tStay+tMove+tStay) { // [standing at the end]
					t_move=tStay+tMove+tStay;
				}
			}
		}
		
		public function sound(s:String=null):void {
			if (s == "move") {
				moveCh = Snd.ps("move", coordinates.X, coordinates.Y, 0);
			}
			else if (s == "stop") {
				if (moveCh) {
					moveCh.stop();
				}
				
				moveCh = Snd.ps("move", coordinates.X, coordinates.Y, 5500);
			}
			else if (sndAct!="") Snd.actionCh = Snd.ps(sndAct, coordinates.X, coordinates.Y);
			
		}
		
		private function replic(s:String):void {
			if (Math.random() < 0.25) {
				World.w.gg.replic(s);
			}
		}	
		
		// [confirm receipt of critical item]
		public function receipt():void {
			trace("Interact.as/receipt() - Important item, setting saveLoot to \"1\".");
			saveLoot = 1;
		}
		
		public function loot(impOnly:Boolean=false):void {
			if (loc == null || cont == "empty") {
				return;
			}

			coordinates.X = owner.coordinates.X;
			coordinates.Y = owner.boundingBox.bottom;

			var kol:int;
			var imp:int;
			var is_loot:Boolean = false;
			var imp_loot:int = 1;
			
			if (xml && xml.item.length()) {
				for each(var item:XML in xml.item) {
					
					if (impOnly && item.@imp.length() == 0) {
						continue;
					}
					
					if (item.@kol.length()) {
						kol = item.@kol;
					}
					else {
						kol = 1;
					}

					if (item.@imp.length()) {
						imp = 2;
						imp_loot = 2;
					}
					else {
						imp = 1;
					}

					trace("Interact.as/loot() - Calling LootGen.lootId with ID: " + item.@id + ", kol: " + kol);
					LootGen.lootId(loc, coordinates.X, coordinates.Y, item.@id, kol, imp, this, lootBroken);
					is_loot = true;
				}
			}

			if (impOnly) {
				return;
			}

			if (cont != "" && cont != "empty") {
				if (owner is Unit) {
					is_loot = LootGen.lootDrop(loc, coordinates.X, coordinates.Y, cont, (owner as Unit).hero) || is_loot;
				}
				else {
					is_loot=LootGen.lootCont(loc, coordinates.X, coordinates.Y, cont, lootBroken, prize? allDif:50) || is_loot;
					//дать опыт
					if (!lootBroken && allDif > 0 && xp > 0) {
						loc.takeXP(Math.round(xp * (allDif + 1)), coordinates.X, coordinates.Y);
					}
				}
			}
			if (!is_loot && (owner is Box) && !World.w.testLoot) World.w.gui.infoText("itsEmpty");
			setAct("loot",imp_loot);
		}
	}
}
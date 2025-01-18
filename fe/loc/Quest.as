package fe.loc {
	
	import fe.*;
	import fe.serv.Item;
	import fe.serv.Script;
	import fe.weapon.Weapon;

	public class Quest {
		
		public var id:String;
		public var xml:XML;
		public var nazv:String;
		public var info:String;
		public var empl:String;
		
		public var main:Boolean = false;		// [Main quest]
		public var sub:Boolean = false;			// [Quest stage]
		public var nsub:int = 0;				// [Stage number]
		public var subs:Array;					// [Array of stages]
		public var subsId:Array;				// [Array of stages by id]
		public var par:Quest;					// [Main quest in relation to subquest]
		public var auto:Boolean = true;			// [The quest is automatically taken if one of the stages is closed, set to false so that the quest is added as hidden]
		
		public var isCheck:Boolean = false;		// 
		public var nn:Boolean = false;			// Optional (quest?/stage?)
		public var collect:String;				// [Collect items]
		public var colTip:int = 0;				// [Type of collectible. 0-regular, 1-weapon]
		public var isDel:Boolean = false;		// [Retrieve the item after completing the quest]
		public var give:String;					// [Who to give it to]
		public var est:int = 0;
		public var kol:int = 1;
		public var canBeUse:Boolean = false;	// [The subquest will close if the quantity is reached and will not open again]
		public var gived:int = 0;				// [How much was given]
		public var pay:int = 0;					// [Fee for each item brought]
		public var prevRes:String = "";			// [Previous test result]
		
		public var hidden:Boolean = false;		// [Description hidden]
		public var invis:Boolean = false;		// [Quest item is not displayed]
		public var result:Boolean = false;		// [Opens if all previous steps have been completed]
		
		public var report:String;
		
		public var begDial:String;
		public var endDial:String;
		public var endScript:String;
		
		public var state:int=0;			// [State 0 - not active, 1 - active, 2 - completed]
		
		// TODO: Ideally this should be done through scripts
		public var sp:int = 0;			// [Reward in skill points]
		public var xp:int = 0;			// [Reward in experience]
		public var rep:int = 0;			// [Reward in reputation]
		
		public var trigger:String;		// [Set a trigger when the quest is completed]
		public var triggerSet:String;	// [Value of the trigger being set]
		
		public var sort:int = 0;

		public function Quest(nxml:XML, loadObj:Object = null, npar:Quest = null, nnsub:int = 0) {
			
			xml = nxml;
			id = xml.@id;
			
			var pid:String;

			if (npar == null)	{
				pid = id;
			}
			else {
				par = npar;
				sub = true;
				pid = par.id + id;
			}
			
			state = 1;
			nsub = nnsub;
			
			if (loadObj) {
				state = loadObj.state;
				est = loadObj.est;
				if (loadObj.gived) {
					gived = loadObj.gived;
				}
			}
			
			if (xml.@empl.length()) empl=xml.@empl;
			if (xml.@begdial.length()) begDial=xml.@begdial;
			if (xml.@enddial.length()) endDial=xml.@enddial;
			if (xml.@endscr.length()) endScript=xml.@endscr;
			if (xml.@nn.length()) nn=true;
			
			if (xml.@collect.length()) {
				collect=xml.@collect;
				isCheck=true;
				if (par) par.isCheck=true;
				if (xml.@del.length()) isDel=true;
				if (xml.@coltip.length()) colTip=xml.@coltip;
			}
			if (xml.@give.length()) {
				give=xml.@give;
			}
			if (xml.@pay.length()) {
				pay=xml.@pay;
			}
			if (xml.@kol.length()) kol=xml.@kol;
			if (xml.@report.length()) report=xml.@report;
			if (xml.@us.length()) canBeUse=true;
			if (xml.@hidden.length()) hidden=true;
			if (xml.@invis.length()) invis=true;
			if (xml.@result.length()) {
				result=true;
				
				if (par) par.result=true;
			}
			
			if (xml.@sp.length()) sp=xml.@sp;
			if (xml.@xp.length()) xp=xml.@xp;
			if (xml.@rep.length()) rep=xml.@rep;
			if (xml.@trigger.length()) {
				trigger=xml.@trigger;
				if (xml.@triggerset.length()) triggerSet=xml.@triggerset;
				else triggerSet='1';
				
				if (state==2 && World.w.game.triggers[trigger]==null) World.w.game.triggers[trigger]=triggerSet;
			}
			if (loadObj && loadObj.invis != undefined) {
				invis = loadObj.invis;
			}
			
			// Get the localized name of the quest
			nazv = LanguageManager.reference.localText("quest", pid)
			// Failsafe
			if (nazv == "") {
				nazv = '[' + id + ']';
			}

			// Get the description of the quest			
			if (!sub) {
				info = LanguageManager.reference.localDesc("quest", pid)
				// Failsafe
				if (info == "")	{
					info = '---';
				}

				main = xml.@main.length() > 0;
				subs = [];
				subsId = [];
				nnsub = 1;
				
				var sl:Object;
				for each(var sxml:XML in xml.q) {
					sl = {};
					
					if (loadObj) {
						sl = loadObj.subs[sxml.@id];
					}
					
					var q:Quest = new Quest(sxml, sl, this, nnsub);
					subsId[q.id] = q;
					subs.push(q);
					nnsub++;
				}
			}
		}
		
		public function save():Object {
			var obj:Object = {id:id, state:state, est:est, gived:gived, invis:invis};
			if (!sub) {
				obj.subs = [];
				
				for each(var q:Quest in subs) {
					obj.subs[q.id] = q.save();
				}
			}
			
			return obj;
		}
		
		// [Check if cid matches collect, increase est]
		public function inc(cid:String, kol:int=1):void {
			if (cid == collect) {
				est += kol;
			}
			
			if (!sub) {
				for each (var q:Quest in subs) {
					q.inc(cid, kol);
				}
			}
		}
		
		// [Give out starting items]
		public function deposit():void {
			if (xml.deposit.length()) {
				for each(var rew in xml.deposit) {
					if (rew.@id.length()) {
						World.w.invent.increaseQuantity(rew.@id, rew.@kol);
					}
					
					if (rew.@trigger.length()) {
						if (rew.@set.length()) {
							World.w.game.triggers[rew.@trigger] = rew.@set.toString();
						}
						else {
							World.w.game.triggers[rew.@trigger] = 1;
						}
					}
				}
			}
		}
		
		// [Check for compliance with the condition, if everything meets the requirements, then close]
		// [Return output result]
		public function check(cid:String = null):String {
			var res:String;
			if (sub) {
				if (collect && colTip == 0 && gived < kol) {
					
					if (World.w.invent.hasItem(collect)) {
						est = World.w.invent.getQuantity(collect) + gived;
					}
					
					if (est > kol) {
						est = kol;
					}
					
					if (give == null) {
						if (est >= kol) {
							state = 2;
							
							if (par.result) {
								par.isResult();
							}
						}
						else if (canBeUse) {
							if (state < 2) {
								state = 1;
							}
							else {
								est = kol;
							}
						}
						else {
							state = 1;
						}
					}
					else {
						// Do nothing	
					}
					
					if (cid != null && collect == cid) {
						res = nazv + ' ' + est + '/' + kol;
					}
					
					if (World.w.invent.hasItem(collect)) {
						est = World.w.invent.getQuantity(collect);
					}
				}
				
				if (collect && colTip == 1) {
					if (World.w.invent.equipment.hasEquipment(collect) && World.w.invent.equipment.getWeapon(collect).respect != Weapon.WEP_BLUEPRINT) {
						state = 2;
						
						if (par.result) {
							par.isResult();
						}
					}
					
					if (cid != null && collect == cid) {
						res = nazv;
					}
				}
			}
			else {
				if (state == 2) {
					return null;
				}
				
				var cl:Boolean = true;
				var res2:String;
				
				for each (var q:Quest in subs) {
					res2 = q.check(cid);
					
					if (res2 != null) {
						res = res2;
					}
					
					if (q.state < 2 && !q.nn) {
						cl = false;
					}
				}
				
				if (cl) {
					close();
				}
			}

			if (res == prevRes || res == null) {
				return null;
			}
			
			prevRes = res;
			
			return res;
		}
		
		// [Check for the possibility of giving away items]
		public function chGive(npc:String, us:Boolean=false):Boolean {
			if (sub) {
				if (give == null) {
					return false;
				}
				
				if (collect) {
					if (World.w.invent.hasItem(collect)) {
						est = World.w.invent.getQuantity(collect);
					}
					
					if (est > 0 && (kol - gived) > 0) {
						if (est > kol - gived) {
							est = kol - gived;
						}
						
						if (us) {
							World.w.invent.decreaseQuantity(collect, est);
							gived += est;
							
							if (pay > 0) {
								World.w.invent.increaseQuantity("money", (est * pay));
								World.w.gui.infoText('reward', Res.txt('i','money'), est * pay);
							}
							
							World.w.gui.infoText('withdraw', ItemManager.reference.getItem(collect).nazv, est);
							est = 0;
							
							if (gived >= kol) {
								close();
							}
						}
						
						return true;
					}
				}
				
				return false;
			}
			else {
				var ok:Boolean = false;
				
				for each (var q:Quest in subs) {
					if (q.chGive(npc, us)) {
						ok = true;
					}
				}
				
				check(null);
				
				return ok;
			}
		}
		
		public function chReport(npc:String, us:Boolean=false):Boolean {
			if (!sub) {
				var cl:Boolean = true;
				var rep:Quest;
				
				for each (var q:Quest in subs) {
					if (q.report && q.report == npc) {
						rep = q;
					}
					else if (q.state < 2 && !q.nn) {
						cl = false;
					}
				}
				
				if (cl && rep) {
					if (!us) {
						return true;
					}
					
					rep.close();
					check(null);
					
					return true;
				}
			}
			
			return false;
		}
		
		// [Check all stages, if all are closed, then close the main one]
		public function isClosed():void {
			var cl:Boolean = true;
			
			for each (var q:Quest in subs) {
				if (q.state < 2) {
					cl = false;
				}
			}
			
			if (cl) {
				close();
			}
		}
		
		public function isResult():void {
			var cl:Boolean = true;

			for (var i:int = 0; i < subs.length; i++) {
				if (subs[i].result) {
					for (var j:int = i - 1; j >= 0; j--) {
						if (subs[j].state < 2) {
							cl = false;
						}
					}
					
					if (cl) {
						subs[i].invis = false;
					}

					// Reset cl for the next loop
					cl = true;
				}
			}
		}
		
		// [Close the stage]
		public function closeSub(sid:String):void {
			if (state == 2 || sid == null || sid == "" || subsId[sid] == null) {
				return;
			}
			
			subsId[sid].close();
			
			if (result) {
				isResult();
			}
			
			if (state == 1) {
				isClosed();
			}
		}
		
		// [Show hidden stage]
		public function showSub(sid:String):void {
			if (sid == null || sid == "" || subsId[sid] == null) {
				return;
			}
			
			subsId[sid].invis = false;
		}
		
		// [Close the quest]
		public function close():void {
			
			// Already closed
			if (state == 2) {
				return;
			}
			
			state = 2;
			
			// [Remove quest items]
			if (!sub) {
				for each (var q:Quest in subs) {
					if (q.isDel) {
						if (q.colTip == 0) {
							World.w.invent.decreaseQuantity(q.collect, q.kol);
							
							try {
								World.w.gui.infoText('withdraw', ItemManager.reference.getItem(q.collect).nazv, q.kol);
							}
							catch (err) {
								trace('ERROR: (00:23)');
							}
						}
						else if (q.colTip == 1) {
							try {
								World.w.gui.infoText('withdraw', ItemManager.reference.getItem(q.collect).nazv, 1);
							}
							catch (err) {
								trace('ERROR: (00:24)');
							}
							
							World.w.invent.equipment.deleteWeapon(q.collect);
						}
					}
				}
			}
			
			// [Issue awards]
			if (sp) {
				World.w.pers.addSkillPoint(sp);
			}
			
			if (xp) {
				World.w.pers.expa(xp);
			}
			
			if (rep) {
				World.w.pers.rep += rep;
			}
			
			if (trigger) {
				World.w.game.triggers[trigger] = triggerSet;
			}
			
			if (xml.reward.length()) {
				for each(var rew in xml.reward) {
					if (rew.@id.length()) {
						World.w.invent.increaseQuantity(rew.@id, rew.@kol);
					}
					
					if (rew.@trigger.length()) {
						if (rew.@set.length()) {
							World.w.game.triggers[rew.@trigger] = rew.@set.toString();
						}
						else {
							World.w.game.triggers[rew.@trigger] = 1;
						}
					}
				}
			}
			
			// [Message and sound]
			if (sub) {
                World.w.gui.infoText('doneStage', nazv);
            }
			else {
                World.w.gui.infoText('doneTask', nazv);
                Snd.ps('quest_ok');
            }
			
			// [Final dialogue]
			if (endDial && World.w.dialOn) {
				World.w.pip.onoff(-1);
				World.w.gui.dialog(endDial);
			}
			
			// [Finishing script]
			if (endScript != null) {
				World.w.game.runScript(endScript);
			}
		}
	}	
}
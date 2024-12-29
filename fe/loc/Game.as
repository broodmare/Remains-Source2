package fe.loc {

	import fe.*;
	import fe.serv.Vendor;
	import fe.serv.Script;
	import fe.serv.Npc;
	import fe.entities.Obj;
	
	public class Game {       
		
		// Managers
		public var vendorManager:VendorManager;

		// Level information
		public var globalDif:int = 2			// [Global difficulty level]
		public var curLandId:String = 'test';	// Current level ID
		public var curCoord:String = null;		// 
		public var curLand:LandAct;				// 
		
		// Game data storage
		public var lands:Object		= {};	// Dictionary of level data stored by level.id       
		public var probs:Object		= {};	// Dictionary of challenge room data stored by prob.id
		public var notes:Array		= [];	// 
		public var npcs:Object		= {};	// 
		public var triggers:Array	= [];	// 
		public var limits:Array		= [];	// 
		public var quests:Array		= [];	// 
		public var names:Array		= [];	// 
		
		// Game Time
		public var dBeg:Date;				// Game start time
		public var playTime:Number;			// Current play time
		public var t_save:Number=0;			// [Save time]
		
		// ???
		public var baseId:String = '';		// Where to send the player when returning from a level
		public var missionId:String = '';	// 
		public var crea:Boolean = false;	// 
		public var mReturn:Boolean=true;	// [You can return to base camp]
		
		// All in-game data
		public var objs:Array;
		

		public function Game() {
			var landList:XMLList = XMLDataGrabber.getNodesWithName("core", "GameData", "Lands", "land");
			for each(var xl:XML in landList) {
				var land:LandAct = new LandAct(xl);
				if (World.w.landData[xl.@id] && World.w.landData[xl.@id].allroom) {
					land.allroom=World.w.landData[xl.@id].allroom;
					land.loaded=true;
				}
				if (land.prob==0) lands[land.id]=land;
				else probs[land.id]=land;
			}
			landList = null; // Manual cleanup.
		}

		public function save():Object {
			var saveData:Object = {};
			saveData.dif = globalDif;
			saveData.land = curLandId;
			
			// Save objects
			World.w.land.saveObjs(objs);
			saveData.objs = cloneObjects(objs);
			
			// Game data storage cloning
			saveData.lands = saveCollection(lands, "save");
		  //saveData.probs -- Not needed, challenge areas aren't persistant
			saveData.notes = cloneCollection(notes);
			saveData.vendors = saveCollection(vendorManager.vendors, "save");
			saveData.npcs = saveCollection(npcs, "save");
			saveData.triggers = cloneCollection(triggers);
		  //saveData.limits -- ????
			saveData.quests = saveCollection(quests, "save");
		  //saveData.names -- Not needed, names are always re-initialized to the same thing
			
			// Calculate and save time
			var currentTime:Date = new Date();
			var elapsedTime:Number = currentTime.getTime() - dBeg.getTime();
			saveData.t_save = t_save + elapsedTime;
			
			return saveData;
		}

		// Clones an object by copying its properties.
		private function cloneObjects(source:Object):Object {
			var cloned:Object = {};
			for (var uid:String in source) {
				var original:Object = source[uid];
				cloned[uid] = cloneObject(original);
			}
			return cloned;
		}

		 // Clones a single object.
		private function cloneObject(original:Object):Object {
			var clone:Object = {};
			for (var key:String in original) {
				clone[key] = original[key];
			}
			return clone;
		}

		// Saves a collection by invoking a specified method on each item.
		private function saveCollection(collection:Object, methodName:String):Object {
			var saved:Object = {};
			for each (var item:Object in collection) {
				if(item && item.hasOwnProperty(methodName) && item[methodName] is Function) {
					var savedItem:Object = item[methodName]();
					if (savedItem != null) {
						saved[item.id] = savedItem; // Assuming each item has a unique 'id'
					}
				}
			}
			return saved;
		}

		// Clones a simple collection without invoking any methods on its items.
		private function cloneCollection(collection:Object):Object {
			var cloned:Object = {};
			for (var key:String in collection) {
				cloned[key] = collection[key];
			}
			return cloned;
		}
		
		public function init(loadObj:Object = null, opt:Object = null):void {
			if (loadObj) {
				if (loadObj.dif != null) {
					globalDif = loadObj.dif;
				}
				
				if (loadObj.t_save) {
					t_save = loadObj.t_save;
				}
			}
			else {
				if (opt && opt.dif != null) {
					globalDif = opt.dif;
				}
				
				triggers['noreturn'] = 1;
			}
			objs = [];
			if (loadObj && loadObj.objs) {
				for (var uid in loadObj.objs) {
					var obj = loadObj.objs[uid];
					var nobj = {};
					for (var n in obj) {
						nobj[n] = obj[n];
					}
					objs[uid] = nobj;
				}
			}

			// Initialize the vendor manager with the save data
			vendorManager = new VendorManager(loadObj.vendors);

			var npcList:XMLList = XMLDataGrabber.getNodesWithName("core", "GameData", "Npcs", "npc");
			var npc:Npc;
			var loadNPC;
			for each(var xl in npcList) {
				loadNPC = null;
				if (loadObj && loadObj.npcs && loadObj.npcs[xl.@id]) {
					loadNPC = loadObj.npcs[xl.@id];
				}
				npc = new Npc(xl, loadNPC);
				npcs[npc.id] = npc;
			}
			npcList = null; // Manual cleanup.

			if (loadObj) {
				for (var i in loadObj.triggers){
					triggers[i]=loadObj.triggers[i];
				}
				for (var j in loadObj.notes) {
					notes[j]=loadObj.notes[j];
				}
				for (var k in loadObj.quests) {
					addQuest(k, loadObj.quests[k]);
				}
				for (var l in loadObj.lands) {//!!!!!
					if (lands[l]) lands[l].load(loadObj.lands[l]);
				}
				
				if (triggers['noreturn'] > 0) mReturn = false; 
				else mReturn = true;
			}

			baseId		= 'rbl';
			curLandId	= 'rbl';

			if (loadObj) {
				curLandId = loadObj.land;
				if (curLandId != 'rbl') missionId=loadObj.land;
			}
			else if (opt && opt.propusk == true) {
				triggers["dial_dialCalam2"] = 1;	// [Skip training]
				setTrigger("Quickstart", 1);
				
			}
			else {
				curLandId = 'begin';				// [Start the tutorial]
			}

			for each(var q in quests) {
				if (q != null && q.state == 2 && q.xml.next.length()) {
					for each (var nq in q.xml.next) {
						addQuest(nq.@id);
					}
				}
			}

			if (lands[curLandId] == null || lands[curLandId].rnd) {
				curLandId = 'rbl';
			}
			
			addNote('helpControl');
			addNote('helpGl1');
			addNote('helpGl2');
			
			dBeg = new Date();
			
			if (loadObj == null) {
				triggers['nomed'] = 1;
			}
		}
		
		public function changeDif(ndif:int):Boolean {
			if (ndif == globalDif) {
				return false;
			}
			
			globalDif=ndif;
			
			// Clamp the difficulty level between 0-4 (inclusive)
			if (globalDif < 0) {
				globalDif = 0;
			}
			else if (globalDif > 4) {
				globalDif = 4;
			}
			
			World.w.pers.setGlobalDif(globalDif);
			World.w.pers.setParameters();
			
			return true;
		}
		
		public function enterToCurLand():void {
			Land.locN += 5;
			World.w.time___metr();

			if (World.w.land && objs) World.w.land.saveObjs(objs);
			// Check for random encounter(?)
			Encounter();

			curLand = lands[curLandId];
			
			if (curLand == null) {
				curLand = lands['rbl'];
			}
			
			var first:Boolean = false;
			
			if (!curLand.rnd && !curLand.visited) {
				first = true;
			}
			
			if (curLand.land == null || crea) {
				var n:int = 0;
				if (triggers['firstroom'] > 0) {
					n = 1;
					if (World.w.pers.level > 1) {
						n = World.w.pers.level - 1;
					}
				}
				curLand.land = new Land(World.w.gg, curLand, n);
			}

			World.w.time___metr('Creating level');

			if (!first) {
				triggers['firstroom'] = 1;
			}
			
			crea = false;
			World.w.ativateLand(curLand.land);
			World.w.land.enterLand(first, curCoord);
			curCoord = null;
			
			if (curLand.id == 'rbl') {
				triggers['noreturn'] = 0;
				triggers['nomed'] = 0;
				triggers['rbl_visited'] = 1;
			}
			else {
				if (curLand.tip!='base') {
					missionId=curLand.id;
					trace(curLand.tip=='base')
				}
			}
			
			World.w.gg.remEffect('potion_fly');
			World.w.gui.messText('', Res.txt('m', curLand.id) + (curLand.rnd? (' - ' + (curLand.landStage + 1)):''), World.w.gg.coordinates.Y < 300);
			
			if (!curLand.rnd) curLand.visited=true;
			
			if (triggers['noreturn']>0) mReturn=false; else mReturn=true;
			
			if (curLand.upStage) {
				curLand.upStage=false;
			}
			
			World.w.time___metr('Entering level');
		}
		
		// [Redirect to another location]
		private function Encounter():void {
			if (curLandId=='random_canter' && !(triggers['encounter_way'] > 0)) curLandId = 'way';
			if (curLandId=='random_encl' && !(triggers['encounter_post'] > 0)) curLandId = 'post';
			if (curLandId=='stable_pi' && triggers['storm'] == 4) curLandId = 'stable_pi_atk';
			if (curLandId=='stable_pi' && triggers['storm'] == 5) curLandId = 'stable_pi_surf';
		}
		
		public function gotoLand(nland:String, coord:String=null, fast:Boolean=false) {
			if (nland != baseId && !World.w.pers.dopusk()) {
				World.w.gui.messText('nocont');
			}
			else if (nland != baseId && World.w.pers.speedShtr >= 3) {
				World.w.gui.messText('nocont2');
			}
			else {
				curLandId = nland;
				curCoord = coord;
				World.w.exitLand(fast);
			}
		}
		
		public function beginMission(nid:String = null) {
			if (nid == curLandId) return;
			if (nid && lands[nid]) {
				if (lands[nid].tip != 'base') {
					missionId = nid;
					crea = true;
				}
			}
			gotoLand(nid);
		}
		
		public function gotoNextLevel():void {
			World.w.pers.prevCPCode = null;
			World.w.pers.currentCPCode = null;
			curLand.land.currentCP = null;
			crea = true;
			curLand.land.refill();
			gotoLand(missionId);
		}
		
		public function upLandLevel():void {
			if (!curLand.upStage) {
				curLand.landStage++;
			}
			curLand.upStage = true;
		}
		
		// [Check the possibility of traveling through the map]
		public function checkTravel(lid):Boolean {
			if (this.curLandId == 'grave') {
				return false;
			}
			
			if (!triggers['fin'] > 0) {
				return true;
			}
			
			if (triggers['fin'] == 1) {
				return lands[lid].fin == 0 || lands[lid].fin == 1;
			}
			
			if (triggers['fin'] == 2) {
				return lands[lid].fin == 0 || lands[lid].fin == 2;
			}
			
			if (triggers['fin'] == 3) {
				return lands[lid].fin == 2;
			}
			
			return true;
		}
		
		public function refillAllVendors() {
			
			vendorManager.refillAllVendors();

			for (var tr in triggers) {
				if (triggers[tr] == "wait") {
					triggers[tr] = 1;
				}
			}
			
			World.w.invent.good.kol = World.w.pers.goodHp;
			World.w.gui.infoText("refill");
		}
		
		public function addQuest(questID:String, loadObj:Object=null, noVis:Boolean=false, snd:Boolean=true, showDial:Boolean=true):Quest {
			// [If the quest already exists]
			if (quests[questID]) {
				// [If there is, but is not active, make it active]
				if (quests[questID].state==0) {
					quests[questID].state=1;
					World.w.gui.infoText('addTask',quests[questID].nazv);
					Snd.ps('quest');
					// [Check the steps, if all are completed, then close immediately]
					quests[questID].isClosed();
					quests[questID].deposit();
					if (quests[questID].state==2) World.w.gui.infoText('doneTask',quests[questID].nazv);
				}
				return quests[questID];
			}

			var xq:XML = XMLDataGrabber.getNodeFromAllWithAttributeThatMatches("core", "GameData", "Quests", "id", questID);
			var q:Quest = new Quest(xq, loadObj);
			
			quests[q.id] = q;
			if (noVis && !q.auto) {
				q.state = 0;
			}
			
			if (loadObj == null && q.state > 0) {
				World.w.gui.infoText('addTask', q.nazv);
				quests[questID].deposit();
				if (snd) {
					Snd.ps('quest');
				}
			}
			
			if (loadObj==null && showDial && q.begDial && World.w.dialOn && World.w.loc.prob==null) {
				World.w.pip.onoff(-1);
				World.w.gui.dialog(q.begDial);
			}
			
			return q;
		}
		
		public function showQuest(id:String, sid:String) {
			var q:Quest = quests[id];
			if (q == null) {
				q = addQuest(id, null, true);
			}
			if (q == null || q.state == 2) {
				return;
			}
			q.showSub(sid);
			
			for each (var q1 in q.subs) {
				if (q1.id == sid) {
					World.w.gui.infoText('addTask2', q1.nazv);
					Snd.ps('quest');
					break;
				}
			}
		}
		
		public function closeQuest(id:String, sid:String=null) {
			var q:Quest = quests[id];
			// If a quest stage is completed and the quest is not accepted, add it as inactive
			if (q == null) {
				q = addQuest(id, null, true);
			}
			if (q == null || q.state == 2) {
				return;
			}
			if (sid == null || sid == '' || int(sid) < 0) {
				q.close();
			}
			else {
				q.closeSub(sid);
			}
		}
		
		public function checkQuests(cid:String):String {
			var res:String;
			var res2:String;
			for each(var q:Quest in quests) {
				if (q.state == 1 && q.isCheck) {
					res = q.check(cid);
					if (res != null) {
						res2 = res;
					}
				}
			}
			return res2;
		}

		public function incQuests(cid:String, kol:int = 1) {
			for each(var q:Quest in quests) {
				if (q.state == 1 && q.isCheck) {
					q.inc(cid, kol);
					q.check(cid);
				}
			}
		}
		
		public function addNote(id:String) {
			if (triggers['note_'+id]) return;
			triggers['note_'+id]=1;
			notes.push(id);
		}
		
		public function setTrigger(id:String, n=1) {
			triggers[id]=n;
		}
		
		// [Determine how many items were generated]
		public function getLimit(id:String):int {
			if (limits[id]) return limits[id];
			if (triggers[id]) {
				limits[id] = triggers[id];
				return limits[id];
			}
			limits[id] = 0;
			return 0;
		}
		
		// [Increase the limit by 1, etap = 1 - when generating, etap = 2 - when taking]
		public function addLimit(id:String, etap:int):void {
			if (etap == 1) {
				if (limits[id]) {
					limits[id]++;
				}
				else {
					limits[id] = 1;
				}
			}
			
			if (etap == 2) {
				if (triggers[id]) {
					triggers[id]++;
				}
				else {
					triggers[id] = 1;
				}
			}
		}
		
		// [Run script from GameData]
		public function runScript(scriptID:String, own:Obj=null):Boolean {
			var xml1:XML = XMLDataGrabber.getNodeFromAllWithAttributeThatMatches("core", "GameData", "Scripts", "id", scriptID);
			var	runScr:Script=new Script(xml1,World.w.land,own);
			runScr.start();
			return true;
		}
		
		// [Create script from GameData]
		public function getScript(scriptID:String, own:Obj=null):Script {
			var xml1:XML = XMLDataGrabber.getNodeFromAllWithAttributeThatMatches("core", "GameData", "Scripts", "id", scriptID);
			return new Script(xml1,(own==null)?World.w.land:own.loc.land,own);
		}
		
		// [String representation of game time]
		public function gameTime(n:Number=0):String {
			if (n == 0) {
				var dNow:Date = new Date();
				playTime = dNow.getTime() - dBeg.getTime();
				n = t_save + playTime;
			}
			return Res.gameTime(n);
		}
	}
}
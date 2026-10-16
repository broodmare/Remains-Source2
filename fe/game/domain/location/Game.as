package fe.game.domain.location {

	import fe.game.GameContainer;
	import fe.engine.SaveConverter;
	import fe.engine.text.XMLDataGrabber;
	import fe.engine.text.TextParser;
	import fe.engine.audio.Sound;
	import fe.game.VendorManager;
	import fe.game.World;
	import fe.game.ui.GUIManager;
	import fe.game.domain.serv.Script;
	import fe.game.domain.serv.Npc;
	import fe.game.domain.entities.Obj;
	import fe.engine.Engine;
	import fe.game.domain.serv.Quest;
	
	public class Game {       

		// Level information
		public var globalDif:int = 2			// [Global difficulty level]
		public var curLevelId:String = "test";	// Current level ID
		public var curCoord:String = null;		// 
		public var curLevel:LevelSettings;				//
		
		// Game data storage
		public var lands:Object		= {};	// Dictionary of level data stored by level.id
		public var challengeSettings:Object		= {};	// Dictionary of challenge room data stored by challenge.id
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
		public var baseId:String		= "";		// Where to send the player when returning from a level
		public var missionId:String		= "";		// 
		public var crea:Boolean			= false;	// 
		public var mReturn:Boolean		= true;		// [You can return to base camp]
		
		// All in-game data
		public var objs:Array;

		public function Game() {
			var landList:XMLList = XMLDataGrabber.getNodesWithName("core", "GameData", "Levels", "land");
			
			for each(var xl:XML in landList) {
				var land:LevelSettings = new LevelSettings(xl);
				
				if (World.w.landData[xl.@id] && World.w.landData[xl.@id].allroom) {
					land.allroom = World.w.landData[xl.@id].allroom;
					land.loaded = true;
				}
				
				if (!land.isChallenge) {
					lands[land.id] = land;
				}
				else {
					challengeSettings[land.id] = land;
				}
			}
			
			landList = null; // Manual cleanup.
		}

		public function save():Object {
			var saveData:Object = {};
			var currentTime:Date = new Date();
			var elapsedTime:Number = currentTime.getTime() - dBeg.getTime();

			saveData.dif = globalDif;
			saveData.land = curLevelId;
			
			// Save objects
			World.w.land.saveObjs(objs);
			saveData.objs = cloneObjects(objs);
			
			// Game data storage cloning
			saveData.lands = saveCollection(lands, "save");
			saveData.notes = cloneCollection(notes);
			saveData.vendors = saveCollection(GameContainer.reference.vendorManager.vendors, "save");
			saveData.npcs = saveCollection(npcs, "save");
			saveData.triggers = cloneCollection(triggers);
			saveData.quests = saveCollection(quests, "save");
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
				var convertedLoadObj:Object = {};
				SaveConverter.convertSave(loadObj, convertedLoadObj);
				loadObj = convertedLoadObj;
			}
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
				for (var uid:String in loadObj.objs) {
					var obj:Object = loadObj.objs[uid];
					var nobj:Object = {};
					
					for (var n:String in obj) {
						nobj[n] = obj[n];
					}
					
					objs[uid] = nobj;
				}
			}

			// Initialize the vendor manager with the save data
			if (loadObj) {
				GameContainer.reference.vendorManager = new VendorManager(loadObj.vendors);
			}
			else {
				GameContainer.reference.vendorManager = new VendorManager({});	// Call with an empty object
			}
			

			var npcList:XMLList = XMLDataGrabber.getNodesWithName("core", "GameData", "Npcs", "npc");
			var npc:Npc;
			var loadNPC:Object;		// The NPC's save data
			for each(var xl:XML in npcList) {
				loadNPC = null;
				if (loadObj && loadObj.npcs && loadObj.npcs[xl.@id]) {
					loadNPC = loadObj.npcs[xl.@id];
				}
				npc = new Npc(xl, loadNPC);
				npcs[npc.id] = npc;
			}
			npcList = null; // Manual cleanup.

			if (loadObj) {
				for (var i:String in loadObj.triggers) {
					triggers[i] = loadObj.triggers[i];
				}
				for (var j:String in loadObj.notes) {
					notes[j]=loadObj.notes[j];
				}
				for (var k:String in loadObj.quests) {
					addQuest(k, loadObj.quests[k]);
				}
				for (var l:String in loadObj.lands) {//!!!!!
					if (lands[l]) lands[l].load(loadObj.lands[l]);
				}
				
				if (triggers['noreturn'] > 0) mReturn = false; 
				else mReturn = true;
			}

			baseId		= 'rbl';
			curLevelId	= 'rbl';

			if (loadObj) {
				curLevelId = loadObj.land;
				if (curLevelId != 'rbl' && curLevelId != 'challenge') missionId=curLevelId;
			}
			else if (opt && opt.propusk == true) {
				triggers["dial_dialCalam2"] = 1;	// [Skip training]
				setTrigger("Quickstart", 1);
				
			}
			else {
				curLevelId = 'begin';				// [Start the tutorial]
			}

			for each(var q:Quest in quests) {
				if (q != null && q.state == 2 && q.xml.next.length()) {
					for each (var nq:XML in q.xml.next) {
						addQuest(nq.@id);
					}
				}
			}

			if (lands[curLevelId] == null || lands[curLevelId].rnd) {
				curLevelId = 'rbl';
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
			
			GameContainer.reference.pers.setGlobalDif(globalDif);
			GameContainer.reference.pers.setParameters();
			
			return true;
		}
		
		public function enterToCurLevel():void {
			Level.locN += 5;
			Engine.reference.time___metr();

			if (World.w.land && objs) World.w.land.saveObjs(objs);
			// Check for random encounter(?)
			Encounter();

			curLevel = lands[curLevelId];
			
			if (curLevel == null) {
				curLevel = lands['rbl'];
			}
			
			var first:Boolean = false;
			
			if (!curLevel.rnd && !curLevel.visited) {
				first = true;
			}
			
			if (curLevel.land == null || crea) {
				var n:int = 0;
				if (triggers['firstroom'] > 0) {
					n = 1;
					if (GameContainer.reference.pers.level > 1) {
						n = GameContainer.reference.pers.level - 1;
					}
				}
				curLevel.land = new Level(GameContainer.reference.gg, curLevel, n);
			}

			Engine.reference.time___metr('Creating level');

			if (!first) {
				triggers['firstroom'] = 1;
			}
			
			crea = false;
			World.w.ativateLevel(curLevel.land);
			World.w.land.enterLevel(first, curCoord);
			curCoord = null;
			
			if (curLevel.id == 'rbl') {
				triggers['noreturn'] = 0;
				triggers['nomed'] = 0;
				triggers['rbl_visited'] = 1;
			}
			else {
				if (curLevel.tip!='base') {
					missionId=curLevel.id;
				}
			}
			
			GameContainer.reference.gg.remEffect('potion_fly');
			GUIManager.reference.gui.messText('', TextParser.txt('m', curLevel.id) + (curLevel.rnd? (' - ' + (curLevel.landStage + 1)):''), GameContainer.reference.gg.coordinates.Y < 300);
			
			if (!curLevel.rnd) curLevel.visited=true;
			
			if (triggers['noreturn']>0) mReturn=false; else mReturn=true;
			
			if (curLevel.upStage) {
				curLevel.upStage=false;
			}
			
			Engine.reference.time___metr('Entering level');
		}
		
		// [Redirect to another location]
		private function Encounter():void {
			if (curLevelId=='random_canter' && !(triggers['encounter_way'] > 0)) curLevelId = 'way';
			if (curLevelId=='random_encl' && !(triggers['encounter_post'] > 0)) curLevelId = 'post';
			if (curLevelId=='stable_pi' && triggers['storm'] == 4) curLevelId = 'stable_pi_atk';
			if (curLevelId=='stable_pi' && triggers['storm'] == 5) curLevelId = 'stable_pi_surf';
		}
		
		public function gotoLevel(nland:String, coord:String=null, fast:Boolean=false):void {
			if (nland != baseId && !GameContainer.reference.pers.dopusk()) {
				GUIManager.reference.gui.messText('nocont');
			}
			else if (nland != baseId && GameContainer.reference.pers.speedShtr >= 3) {
				GUIManager.reference.gui.messText('nocont2');
			}
			else {
				curLevelId = nland;
				curCoord = coord;
				World.w.exitLevel(fast);
			}
		}
		
		public function beginMission(nid:String = null):void {
			if (nid == curLevelId) return;
			if (nid && lands[nid]) {
				if (lands[nid].tip != 'base') {
					missionId = nid;
					crea = true;
				}
			}
			gotoLevel(nid);
		}
		
		public function gotoNextLevel():void {
			GameContainer.reference.pers.prevCPCode = null;
			GameContainer.reference.pers.currentCPCode = null;
			curLevel.land.currentCP = null;
			crea = true;
			curLevel.land.refill();
			gotoLevel(missionId);
		}
		
		public function upLevelLevel():void {
			if (!curLevel.upStage) {
				curLevel.landStage++;
			}
			curLevel.upStage = true;
		}
		
		// [Check the possibility of traveling through the map]
		public function checkTravel(lid:String):Boolean {
			if (this.curLevelId == 'grave') {
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
		
		public function refillAllVendors():void {
			
			GameContainer.reference.vendorManager.refillAllVendors();

			for (var tr:String in triggers) {
				if (triggers[tr] == "wait") {
					triggers[tr] = 1;
				}
			}
			
			GameContainer.reference.invent.setQuantity("good", GameContainer.reference.pers.goodHp);	// TODO: ????? What is a good item, why are we putting it in the player's inventory????
			GUIManager.reference.gui.infoText("refill");
		}
		
		public function addQuest(questID:String, loadObj:Object = null, noVis:Boolean = false, snd:Boolean = true, showDial:Boolean = true):Quest {
			// [If the quest already exists]
			if (quests[questID]) {
				// [If there is, but is not active, make it active]
				if (quests[questID].state==0) {
					quests[questID].state=1;
					GUIManager.reference.gui.infoText('addTask',quests[questID].nazv);
					Sound.ps('quest');
					// [Check the steps, if all are completed, then close immediately]
					quests[questID].isClosed();
					quests[questID].deposit();
					if (quests[questID].state==2) GUIManager.reference.gui.infoText('doneTask',quests[questID].nazv);
				}
				return quests[questID];
			}

			var xq:XML = XMLDataGrabber.getNodeWithAttributeThatMatches("core", "GameData", "Quests", "id", questID);
			var q:Quest = new Quest(xq, loadObj);
			
			quests[q.id] = q;
			if (noVis && !q.auto) {
				q.state = 0;
			}
			
			if (loadObj == null && q.state > 0) {
				GUIManager.reference.gui.infoText('addTask', q.nazv);
				quests[questID].deposit();
				if (snd) {
					Sound.ps('quest');
				}
			}
			
			if (loadObj==null && showDial && q.begDial && GameContainer.reference.dialOn && World.w.loc.challenge==null) {
				GUIManager.reference.pip.onoff(-1);
				GUIManager.reference.gui.dialog(q.begDial);
			}
			
			return q;
		}
		
		public function showQuest(id:String, sid:String):void {
			var q:Quest = quests[id];
			if (q == null) {
				q = addQuest(id, null, true);
			}
			if (q == null || q.state == 2) {
				return;
			}
			q.showSub(sid);
			
			for each (var q1:Quest in q.subs) {
				if (q1.id == sid) {
					GUIManager.reference.gui.infoText('addTask2', q1.nazv);
					Sound.ps('quest');
					break;
				}
			}
		}
		
		public function closeQuest(id:String, sid:String=null):void {
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

		public function incQuests(cid:String, kol:int = 1):void {
			for each(var q:Quest in quests) {
				if (q.state == 1 && q.isCheck) {
					q.inc(cid, kol);
					q.check(cid);
				}
			}
		}
		
		public function addNote(id:String):void {
			if (triggers['note_'+id]) {
				return;
			}

			triggers['note_'+id]=1;
			notes.push(id);
		}
		
		// A trigger holds a number, or "wait" until the next refill turns it into 1
		public function setTrigger(id:String, n:Object = 1):void {
			triggers[id] = n;
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
			var xml1:XML = XMLDataGrabber.getNodeWithAttributeThatMatches("core", "GameData", "Scripts", "id", scriptID);
			var	runScr:Script=new Script(xml1,World.w.land,own);
			runScr.start();
			return true;
		}
		
		// [Create script from GameData]
		public function getScript(scriptID:String, own:Obj=null):Script {
			var xml1:XML = XMLDataGrabber.getNodeWithAttributeThatMatches("core", "GameData", "Scripts", "id", scriptID);
			return new Script(xml1,(own==null)?World.w.land:own.loc.land,own);
		}
		
		// [String representation of game time]
		public function gameTime(n:Number=0):String {
			if (n == 0) {
				var dNow:Date = new Date();
				playTime = dNow.getTime() - dBeg.getTime();
				n = t_save + playTime;
			}
			return TextParser.gameTime(n);
		}

		// Check if an object is empty, Eg. '{}'
		private function isEmpty(obj:Object):Boolean {
			for (var key:String in obj) {
				return false; // Found a property, so it's not empty
			}
			return true; // No properties found, it's empty
		}
	}
}
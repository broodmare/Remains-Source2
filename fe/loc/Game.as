package fe.loc
{
	import fe.*;
	import fe.serv.Vendor;
	import fe.serv.Script;
	import fe.serv.NPC;
	import fe.entities.Obj;
	
	public class Game
	{       // Dictionary of level data stored by level.id
		public var lands:Object;
                // Dictionary of challenge room data stored by prob.id
		public var probs:Object;
		public var vendors:Array;
		public var npcs:Array;
		public var curLandId:String='test';
		public var curCoord:String=null;
		public var curLand:LandAct;
		public var triggers:Array;
		public var notes:Array;
		public var limits:Array;
		public var quests:Array;
		public var names:Array;
		
		//время игры
		public var dBeg:Date;			//время начала игры
		public var t_proshlo:Number;	//время текущей сессии
		public var t_save:Number=0;		//сохранённое время
		
		public var globalDif:int=2;	//глобальный уровень сложности
		public var baseId:String='';	//местность, в которую происходит возврат
		public var missionId:String='';
		public var crea:Boolean=false;
		public var mReturn:Boolean=true;	//можно возвратиться в базовый лагерь
		
		var objs:Array;
		

		public function Game()
		{
			lands		= {};
			probs		= {};
			notes		= [];
			vendors		= [];
			npcs		= [];
			triggers	= [];
			limits		= [];
			quests		= [];
			names		= [];
			
			var landList:XMLList = XMLDataGrabber.getNodesWithName("core", "GameData", "Lands", "land");
			for each(var xl:XML in landList)
			{
				var land:LandAct = new LandAct(xl);
				if (World.w.landData[xl.@id] && World.w.landData[xl.@id].allroom)
				{
					land.allroom=World.w.landData[xl.@id].allroom;
					land.loaded=true;
				}
				if (land.prob==0) lands[land.id]=land;
				else probs[land.id]=land;
			}
			landList = null; // Manual cleanup.
		}

		public function save():Object {
			var obj:Object=new Object;
			obj.dif=globalDif;
			obj.land=curLandId;
			World.w.land.saveObjs(objs);	//сохранить массив объектов с id
			obj.objs=[];
			for (var uid in objs) {
				var obj1=objs[uid];
				var nobj=new Object();
				for (var n in obj1) {
					nobj[n]=obj1[n];
				}
				obj.objs[uid]=nobj;
			}
			obj.vendors=[];
			obj.npcs=[];
			obj.notes=[];
			obj.quests=[];
			obj.lands=[];
			obj.triggers=[];
			for (var i in vendors) {
				var v=vendors[i].save();
				if (v!=null) obj.vendors[i]=v;
			}
			for (i in npcs) {
				var npc=npcs[i].save();
				if (npc!=null) obj.npcs[i]=npc;
			}
			for (i in triggers) {
				obj.triggers[i]=triggers[i];
			}
			for (i in notes) {
				obj.notes[i]=notes[i];
			}
			for (i in quests) {
				var q:Object=quests[i].save();
				if (q!=null) obj.quests[i]=q;
			}
			for (var i in lands) {
				var l=lands[i].save();
				if (l!=null) obj.lands[i]=l;
			}
			var dNow:Date=new Date();
			t_proshlo=dNow.getTime()-dBeg.getTime();
			obj.t_save=t_save+t_proshlo;
			return obj;
		}
		
		public function init(loadObj:Object=null, opt:Object=null):void {
			if (loadObj) {
				if (loadObj.dif == null) {
					globalDif = 2;
				} else globalDif = loadObj.dif;
				if (loadObj.t_save) t_save=loadObj.t_save;
			}
                        else {
				if (opt && opt.dif!=null) globalDif=opt.dif;
				else globalDif=2;
				triggers['noreturn']=1;
			}
			objs = [];
			if (loadObj && loadObj.objs)
			{
				for (var uid in loadObj.objs)
				{
					var obj=loadObj.objs[uid];
					var nobj=new Object();
					for (var n in obj) {
						nobj[n]=obj[n];
					}
					objs[uid]=nobj;
				}
			}

			var vendorList:XMLList = XMLDataGrabber.getNodesWithName("core", "GameData", "Vendors", "vendor");
			for each(var xl:XML in vendorList)
			{
				var loadVendor = null;
				if (loadObj && loadObj.vendors && loadObj.vendors[xl.@id]) loadVendor = loadObj.vendors[xl.@id];
				var v:Vendor = new Vendor(0, xl, loadVendor);
				vendors[v.id]=v;
			}
			vendorList = null; // Manual cleanup.

			var npcList:XMLList = XMLDataGrabber.getNodesWithName("core", "GameData", "Npcs", "npc");
			for each(var xl:XML in npcList)
			{
				var loadNPC=null;
				if (loadObj && loadObj.npcs && loadObj.npcs[xl.@id]) loadNPC=loadObj.npcs[xl.@id];
				var npc:NPC=new NPC(xl,loadNPC);
				npcs[npc.id]=npc;
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

			if (loadObj)
			{
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

			if (lands[curLandId] == null || lands[curLandId].rnd) curLandId = 'rbl';
			addNote('helpControl');
			addNote('helpGl1');
			addNote('helpGl2');
			dBeg=new Date();
			if (loadObj == null) triggers['nomed']=1;
		}
		
		public function changeDif(ndif):Boolean {
			if (ndif==globalDif) return false;
			globalDif=ndif;
			if (globalDif<0) globalDif=0;
			if (globalDif>4) globalDif=4;
			World.w.pers.setGlobalDif(globalDif);
			World.w.pers.setParameters();
			return true;
		}
		
		public function enterToCurLand()
		{
			Land.locN += 5;
			World.w.time___metr();

			if (World.w.land && objs) World.w.land.saveObjs(objs);
			// Check for random encounter(?)
			Encounter();

			curLand = lands[curLandId];
			if (curLand == null) curLand = lands['rbl'];
			var first = false;
			if (!curLand.rnd && !curLand.visited) first=true;
			if (curLand.land==null || crea) {
				var n:int=0;
				if (triggers['firstroom']>0) {
					n=1;
					if (World.w.pers.level>1) n=World.w.pers.level-1;
				}
				curLand.land = new Land(World.w.gg, curLand, n);
			}

			World.w.time___metr('Creating level');

			if (!first) triggers['firstroom'] = 1;
			crea=false;
			World.w.ativateLand(curLand.land);
			World.w.land.enterLand(first, curCoord);
			curCoord=null;
			if (curLand.id=='rbl') {
				triggers['noreturn']=0;
				triggers['nomed']=0;
				triggers['rbl_visited']=1;
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
		
		//Перенаправление на другую локацию
		private function Encounter():void
		{
			if (curLandId=='random_canter' && !(triggers['encounter_way']>0)) curLandId='way';
			if (curLandId=='random_encl' && !(triggers['encounter_post']>0)) curLandId='post';
			if (curLandId=='stable_pi' && triggers['storm']==4) curLandId='stable_pi_atk';
			if (curLandId=='stable_pi' && triggers['storm']==5) curLandId='stable_pi_surf';
		}
		
		public function gotoLand(nland:String, coord:String=null, fast:Boolean=false) {
			if (nland!=baseId && !World.w.pers.dopusk()) {
				World.w.gui.messText('nocont');
			} else if (nland!=baseId && World.w.pers.speedShtr>=3) {
				World.w.gui.messText('nocont2');
			} else {
				curLandId=nland;
				curCoord=coord;
				World.w.exitLand(fast);
			}
		}
		
		public function beginMission(nid:String=null)
		{
			if (nid==curLandId) return;
			if (nid && lands[nid])
			{
				if (lands[nid].tip!='base') {
					missionId=nid;
					crea=true;
				}
			}
			gotoLand(nid);
		}
		
		public function gotoNextLevel() {
			World.w.pers.prevCPCode=null;
			World.w.pers.currentCPCode=null;
			curLand.land.currentCP=null;
			crea=true;
			curLand.land.refill();
			gotoLand(missionId);
		}
		
		public function upLandLevel() {
			if (!curLand.upStage) curLand.landStage++;
			curLand.upStage=true;
		}
		
		//проверить возможность путешествия через карту
		public function checkTravel(lid):Boolean {
			if (this.curLandId=='grave') return false;
			if (!triggers['fin']>0) return true;
			if (triggers['fin']==1) return lands[lid].fin==0 || lands[lid].fin==1;
			if (triggers['fin']==2) return lands[lid].fin==0 || lands[lid].fin==2;
			if (triggers['fin']==3) return lands[lid].fin==2;
			return true;
		}
		
		public function refillVendors() {
			for each(var vend:Vendor in vendors) vend.refill();
			for (var tr in triggers) {
				if (triggers[tr]=='wait') triggers[tr]=1;
			}
			World.w.invent.good.kol=World.w.pers.goodHp;
			World.w.gui.infoText('refill');
		}
		
		public function addQuest(questID:String, loadObj:Object=null, noVis:Boolean=false, snd:Boolean=true, showDial:Boolean=true):Quest {
			//Если квест уже есть
			if (quests[questID]) {
				//Если есть, но не активен, сделать активным
				if (quests[questID].state==0) {
					quests[questID].state=1;
					World.w.gui.infoText('addTask',quests[questID].nazv);
					Snd.ps('quest');
					//проверить этапы, если все выполнены, то сразу и закрыть
					quests[questID].isClosed();
					quests[questID].deposit();
					if (quests[questID].state==2) World.w.gui.infoText('doneTask',quests[questID].nazv);
				}
				return quests[questID];
			}

			var xq:XML = XMLDataGrabber.getNodeFromAllWithAttributeThatMatches("core", "GameData", "Quests", "id", questID);

			var q:Quest=new Quest(xq,loadObj);
			quests[q.id]=q;
			if (noVis && !q.auto) q.state=0;
			if (loadObj==null && q.state>0) {
				World.w.gui.infoText('addTask',q.nazv);
				quests[questID].deposit();
				if (snd) Snd.ps('quest');
			}
			if (loadObj==null && showDial && q.begDial && World.w.dialOn && World.w.loc.prob==null) {
				World.w.pip.onoff(-1);
				World.w.gui.dialog(q.begDial);
			}
			return q;
		}
		
		public function showQuest(id:String, sid:String) {
			var q:Quest=quests[id];
			if (q==null) {
				q=addQuest(id,null,true);
			}
			if (q==null || q.state==2) {
				return;
			}
			q.showSub(sid);
			
			for each (var q1 in q.subs) {
				if (q1.id==sid) {
					World.w.gui.infoText('addTask2',q1.nazv);
					Snd.ps('quest');
					break;
				}
			}
		}
		
		public function closeQuest(id:String, sid:String=null) {
			var q:Quest=quests[id];
			//Если этап квеста выполнен, а квест не взят, добавить его как неактивный
			if (q==null) {
				q=addQuest(id,null,true);
			}
			if (q==null || q.state==2) {
				return;
			}
			if (sid==null || sid=='' || int(sid)<0) {
				q.close();
			} else {
				q.closeSub(sid);
			}
		}
		
		public function checkQuests(cid:String):String {
			var res2, res:String;
			for each(var q:Quest in quests) {
				if (q.state==1 && q.isCheck) {
					res=q.check(cid);
					if (res!=null) res2=res;
				}
			}
			return res2;
		}
		public function incQuests(cid:String, kol:int=1) {
			for each(var q:Quest in quests) {
				if (q.state==1 && q.isCheck) {
					q.inc(cid,kol);
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
		
		//определить, сколько предметов было сгенерировано
		public function getLimit(id:String):int {
			if (limits[id]) return limits[id];
			if (triggers[id]) {
				limits[id]=triggers[id];
				return limits[id];
			}
			limits[id]=0;
			return 0;
		}
		
		//увеличить лимит на 1, etap=1 - при генерации, etap=2 - при взятии
		public function addLimit(id:String, etap:int) {
			if (etap==1) {
				if (limits[id]) limits[id]++;
				else limits[id]=1;
			}
			if (etap==2) {
				if (triggers[id]) triggers[id]++;
				else triggers[id]=1;
			}
		}
		
		//Запустить скрипт из gamedata
		public function runScript(scriptID:String, own:Obj=null):Boolean
		{
			var xml1:XML = XMLDataGrabber.getNodeFromAllWithAttributeThatMatches("core", "GameData", "Scripts", "id", scriptID);
			var	runScr:Script=new Script(xml1,World.w.land,own);
			runScr.start();
			return true;
		}
		
		//создать скрипт из gamedata
		public function getScript(scriptID:String, own:Obj=null):Script
		{
			var xml1:XML = XMLDataGrabber.getNodeFromAllWithAttributeThatMatches("core", "GameData", "Scripts", "id", scriptID);
			return new Script(xml1,(own==null)?World.w.land:own.loc.land,own);
		}
		
		//строковое представление времени игры
		public function gameTime(n:Number=0):String {
			if (n==0) {
				var dNow:Date=new Date();
				t_proshlo=dNow.getTime()-dBeg.getTime();
				n=t_save+t_proshlo;
			}
			return Res.gameTime(n);
		}
	}
}

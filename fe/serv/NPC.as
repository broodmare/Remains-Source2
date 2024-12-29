package fe.serv {

	import fe.*;
	import fe.entities.Obj;
	import fe.unit.UnitNPC;

	public class Npc {

		public var xml:XML;				// [XML from GameData]
		public var id:String = "";		// Npc ID
		public var vid:String;			// [Linked merchant ID]
		public var owner:Obj;			// [owner, physical object, such as a unit]
		public var vendor:Vendor;		// [Linked merchant object]
		public var inter:Interact;		// [owner interactive]

		public var hidden:Boolean = false;	// [A unit associated with an Npc will be hidden]
		// [{ersisted states]
		public var rep:int = 0;
		public var zzzGen:Boolean=false;
		
		public var npcInter:String = '';		// [Type of interaction]
		// Interaction options displayed near the cursor. Eg. "talk". [The second string is for when there is no more dialogue]
		public var userAction1:String;
		public var userAction2:String;
		public var ndial:String;	// [Dialogue when there is nothing more to say]
		
		// Constructor
		public function Npc(nxml:XML, loadObj:Object = null, nvid:String = null, ndif:int = 100) {
			xml = nxml;
			
			if (xml) {
				id=xml.@id;
				if (xml.@vendor.length()) vid=xml.@vendor;
				if (xml.@inter.length()) npcInter=xml.@inter;
				if (xml.@ua1.length()) userAction1=xml.@ua1;
				if (xml.@ua2.length()) userAction2=xml.@ua2;
				if (xml.@ndial.length()) ndial=xml.@ndial;
			}
			
			if (loadObj) {
				if (loadObj.rep!=null) rep=loadObj.rep;
			}
			
			if (nvid != null) {
				vid = nvid;
			}
			
			// [Create a merchant object]
			if (vid != null && vid != "") {
				if (World.w.game.vendorManager.vendors[vid]){
					vendor = World.w.game.vendorManager.vendors[vid];
				}
				else {
					vendor = new Vendor();
					if (vid == 'doctor') {
						npcInter = 'doc';
					}
					else {
						npcInter = 'vr';
					}
				}
			}
		}

		public function save():Object {
			var obj:Object = {};
			obj.rep = rep;
			return obj;
		}
		
		// [Interaction settings, called when connecting to a unit]
		public function setInter() {
			if (id == 'adoc' && rep <= 1) inter.t_action = 45;
		}
		
		// [The function is called when a unit is created]
		public function init() {
			if (id == 'calam') {
				if (rep == 0 || trig('rbl_visited') > 0) {
					hidden = true;
				}
				
				if (rep == 1) {
					(owner as UnitNPC).aiTip = 'agro';
				}
			}
			
			if (id == 'steel2') {
				refresh();
			}
		}
		
		private function trig(s:String):* {
			return World.w.game.triggers[s];
		}
		
		// [The function is called when generating a map with a unit]
		public function refresh() {
			switch (id) {
				case "calam":
					if (rep == 0 && owner) {
						owner.command("ai", "");
					}
					break;
				case "calam2":
					hidden = (trig("storm") > 0);
					break;
				case "calam3":
					hidden = (trig("storm") != 1);
					break;
				case "calam4":
					hidden = (trig("storm") != 2 && trig("storm") != 3);
					break;
				case "calam5":
					hidden = (trig("storm") != 3);
					break;
				case "steel2":
					hidden = (trig("mbase_visited") > 0);
					break;
				case "steel":
					hidden = (trig("storm") == 5);
					break;
				case "askari":
					hidden = (trig("story_ranger") > 0);
					break;
				case "askari2":
					hidden = !(trig("story_ranger") > 0) || trig("storm") > 0;
					break;
				case "patient":
					zzzGen = (rep == 2);
					break;
				case "observer":
					hidden = (trig("observer") != 1);
					break;
				case "observer2":
					hidden = (trig("storm") != 2);
					break;
				case "askari3":
					hidden = !(trig("storm") >= 2);
					break;
				case "mentor":
					hidden = (trig("theend") > 0);
					break;
				default:
					// Do nothing
					break;
			}
		}
		
		// [The function is called when the flying aircraft lands]
		public function landing() {
			if (id == 'calam') {
				rep = 1;
			}
		}
		
		// [Activate interaction with npc]
		public function activate() {
			if (check(true) && npcInter != 'patient') {
				return;
			}

			if (npcInter == 'travel') {
				World.w.pip.travel = true;
				World.w.pip.onoff(3, 3);
				World.w.pip.travel = true;
			}
			else if (npcInter=='doc' || npcInter=='vdoc') {
				pip(6);
			}
			else if (npcInter=='adoc') {
				if (rep <= 1)	{
					repair();
				}
				else {
					pip(6);
				}
			}
			else if (npcInter=='patient') {
				patient();
			}
			else if (vendor) {
				pip(4);
			}
			else {
				if (ndial) World.w.gui.dialog(ndial);
				else if (owner) owner.command('tell', 'dial');
			}
		}
		
		public function pip(n:int) {
			World.w.pip.vendor = vendor;
			World.w.pip.npcId = id;
			World.w.pip.npcInter = npcInter;
			World.w.pip.onoff(n);
			if (owner) owner.command('replicVse');
		}
		
		
		// [Check for quest actions, if us, then perform the actions, if not, then just set the status]
		public function check(us:Boolean=false):Boolean {
			if (xml && xml.dial.length()) {
				for each (var dial in xml.dial) {
					if (trig('dial_'+dial.@id)) continue;
					if (dial.@lvl.length() && dial.@lvl>World.w.pers.level) continue; 
					if (dial.@barter.length() && dial.@barter>World.w.pers.getSkLevel(World.w.pers.skills['barter'])) continue; 
					if (dial.@trigger.length()) {
						if (dial.@n.length()) {
							if (trig(dial.@trigger)!=dial.@n) continue;
						}
						else {
							if (trig(dial.@trigger)!=1) continue;
						}
					}
					if (dial.@prev.length() && trig('dial_'+dial.@prev)!=1) continue; 
					if (dial.@land.length() && !World.w.game.lands[dial.@land].access) continue; 
					if (dial.@armor.length() && (World.w.gg.currentArmor==null || World.w.gg.currentArmor.id!=dial.@armor)) continue; 
					if (dial.@pet.length() && World.w.gg.currentPet!=dial.@pet) continue; 
					if (dial.@quest.length()) {						//если активен квест
						var quest=World.w.game.quests[dial.@quest];
						if (quest==null || quest.state!=1) continue; 
						if (dial.@sub.length()) {					//если видимый подквест
							if (quest.subsId[dial.@sub]==null || quest.subsId[dial.@sub].invis) continue; 
						}
					}
					if (us) {
						if (dial.scr.length()) {
							var scr:Script=new Script(dial.scr[0],World.w.land,owner,true);
							if (World.w.dialOn) {
								var did:String=dial.@id;
								scr.acts.unshift({act:'dialog', val:did, t:0, n:-1, opt1:0, opt2:0, targ:""});
							}
							scr.acts.push({act:'trigger', val:('dial_'+dial.@id), t:0, n:1, opt1:0, opt2:0, targ:""});
							scr.acts.push({act:'checkall', val:0, t:0, n:1, opt1:0, opt2:0, targ:""});
							scr.start();
						}
						else {
							if (World.w.dialOn) World.w.gui.dialog(dial.@id);
							World.w.game.setTrigger('dial_'+dial.@id);

						}
						if (dial.reward.length()) {
							for each(var rew in dial.reward) {
								if (rew.@id.length()) {
									var item:Item;
									if (rew.@kol.length()) item=new Item('', rew.@id, rew.@kol);
									else item=new Item('', rew.@id);
									World.w.invent.take(item,2);
								}
							}
						}
						if (dial.@music.length()) {
							Snd.playMusic(dial.@music);
						}
						check();
					}
					else {
						if (dial.@imp.length()) setStatus(2);
						else setStatus(1);
					}
					
					return true;
				}
			}
			if (!us) {
				setStatus(0);
			}
			
			return false;
		}
		
		public function setStatus(dial:int=0) {
			if (dial>0) {
				setIco('dial'+dial);
				if (userAction1) inter.userAction=userAction1;
				else inter.userAction='dial';
				owner.command('sign');
			}
			else {
				if (userAction2) {
					inter.userAction=userAction2;
				}
				else if (npcInter=='doc' || npcInter=='vdoc') {
					inter.userAction='therapy';
				}
				else if (npcInter=='patient') {
					if (trig('patient_tr2')=='1') {//вылечили
						inter.t_action=0;
						inter.userAction='dial';
					}
					else {
						inter.t_action=30;
						inter.userAction='see';
					}
				}
				else if (npcInter=='adoc') {
					if (rep<=1)	inter.userAction='repair';
					else inter.userAction='therapy';
				}
				else if (vendor) {
					inter.userAction='trade';
				}
				else {
					inter.userAction='dial';
				}
				
				setIco();
			}
			
			inter.update();
		}
		
		// [Set top icon]
		private function setIco(n:String=null) {
			if (n==null) owner['ico'].gotoAndStop(owner['icoFrame']);
			else owner['ico'].gotoAndStop(n);
		}
		
		public function repair() {
			if (xml && xml.quest.length()) {
				if (World.w.game.quests[xml.quest.@id]==null) {
					World.w.game.addQuest(xml.quest.@id);
					return;
				}
			}
			if (World.w.pers.skills[xml.@needskill]==null) return;
			var sk:int=World.w.pers.getSkLevel(World.w.pers.skills[xml.@needskill]);
			var ok:Boolean=false;
			if (sk<2) {
				World.w.gui.dialog('rblAutoDocR1');
			}
			else if (sk>=5) {
				World.w.gui.dialog('rblAutoDocR5');
				ok=true;
			}
			else if (rep==1) {
				ok=true;
				for each(var node in xml.rep) {
					if (World.w.invent.items[node.@id] && World.w.invent.items[node.@id].kol<node.@kol) {
						World.w.gui.infoText('required',World.w.invent.items[node.@id].nazv, node.@kol-World.w.invent.items[node.@id].kol);
						ok=false;
					}
				}
				if (ok) {
					for each(node in xml.rep) {
						if (World.w.invent.items[node.@id]) {
							World.w.invent.minusItem(node.@id, node.@kol);
							World.w.gui.infoText('withdraw',World.w.invent.items[node.@id].nazv, node.@kol);
						}
					}
					World.w.gui.dialog('rblAutoDocR4');
				}
				else {
					World.w.gui.dialog('rblAutoDocR3');
				}
			}
			else {
				World.w.gui.dialog('rblAutoDocR2');
				rep=1;
			}
			
			if (ok) {
				rep=2;
				inter.t_action=0;
				setStatus();
				if (xml && xml.quest.length()) {
					World.w.game.closeQuest(xml.quest.@id,xml.quest.@cid);
				}
			}
		}
		
		public function patient() {
			if (World.w.pers.skills[xml.@needskill]==null) {
				return;
			}
			
			var sk:int = World.w.pers.getSkLevel(World.w.pers.skills[xml.@needskill]);
			
			if (rep == 2) {	//вылечил
				if (trig('patient_tr2')=='1') {//вылечили
					if (owner) owner.command('openEyes');
				}
				else {
					World.w.gui.dialog('dialPatient7');
				}
			}
			else if (rep == 1) { //после осмотра
				if (World.w.invent.items[xml.@needitem] && World.w.invent.items[xml.@needitem].kol>0) {	//есть лекарство
					World.w.invent.minusItem(xml.@needitem, 1);
					rep=2;
					World.w.gui.dialog('dialPatient5');
					World.w.game.triggers['patient_tr2']='wait';
					World.w.game.closeQuest('patientHeal', '3');
					World.w.game.showQuest('patientHeal', '4');
				}
				else {	//нет лекарства
					World.w.gui.dialog('dialPatient8');
				}
			}
			else if (sk<4) {	//уровень медицины не достаточный
				World.w.gui.dialog('dialPatient2');
			}
			else {
				World.w.gui.dialog('dialPatient3');
				rep=1;
				World.w.game.triggers['patient_tr1']=1;
				World.w.game.closeQuest('patientHeal', '1');
				World.w.game.showQuest('patientHeal', '2');
				World.w.game.showQuest('patientHeal', '3');
			}
			
			refresh();
		}
	}
}
package fe.unit {
	import flash.filters.GlowFilter;
	import flash.display.MovieClip;
	
//	import fe.serv.Interact;
	import fe.*;
	
	public class UnitCaptive extends Unit{
		
		var tr:int=1;
		var sr:int=0;
		var statusCapt=0;
		var novoi:Boolean=false;
		
		public function UnitCaptive(cid:String=null, ndif:Number=100, xml:XML=null, loadObj:Object=null) {
			super(cid, ndif, xml, loadObj);
			id='captive';
			//if (questId==null) questId=id;
			npc=true;
			getXmlParam();
			if (loadObj && loadObj.tr) {			//из загружаемого объекта
				tr=loadObj.tr;
			} else if (xml && xml.@tr.length()) {	//из настроек карты
				tr=xml.@tr;
			} else {
				tr=Math.floor(Math.random()*11+1);
			}
			if (loadObj && loadObj.sr) {			//из загружаемого объекта
				sr=loadObj.sr;
			} else if (xml && xml.@sr.length()) {	//из настроек карты
				sr=xml.@sr;
			}
			if (loadObj && loadObj.statusCapt) {			//из загружаемого объекта
				statusCapt=loadObj.statusCapt;
			} else if (xml && xml.@st.length()) {	//из настроек карты
				statusCapt=xml.@st;
			}
			if (tr>=9) msex=true;
			else msex=false;
			if (tr==12) novoi=true;
			if (xml==null || xml.@lock.length()==0) inter.lock=1;
			inter.active=true;
			inter.action=1;
			inter.actFun=free;
			inter.update();
			vis=new visualCaptive();
			vis.osn.pon.gotoAndStop(tr);
			vis.osn.cage.gotoAndStop(sr+1);
			if (statusCapt>0) {
				vis.osn.gotoAndStop('opened');
				inter.active=false;
				id='cage';
				nazv=Res.txt('u',id);
				npc=false;
				fraction=0;
			}
			invulner=true;
			t_replic=Math.random()*1500;
			
		}
		
		public override function save():Object {
			var obj:Object=super.save();
			if (obj==null) obj=new Object();
			obj.tr=tr;
			obj.sr=sr;
			obj.statusCapt=statusCapt;
			return obj;
		}	
	
		public override function animate() {
		}
		
		public override function command(com:String, val:String=null) {
			inter.command(com,val);
		}
		
		public function free() {
			if (statusCapt>0) return;
			sound('metal_door_open');
			t_replic=0;
			if (!novoi) replic('vse');
			vis.osn.gotoAndPlay('open');
			inter.active=false;
			id='cage';
			nazv=Res.txt('u',id);
			npc=false;
			loc.takeXP(500,World.w.gg.X, World.w.gg.Y-100,true);
			fraction=0;
			if (questId) {
				if (loc.land.itemScripts[questId]) loc.land.itemScripts[questId].start();
				World.w.game.incQuests(questId);
			}
			statusCapt=1;
		}
		
		public override function control() {
			if (statusCapt>0 || novoi) return;
			t_replic--;
			if (t_replic<=0) {
				replic('neutral');
				t_replic=Math.random()*500+1000;
			}
		}
		
	
	}
}

package fe.unit {

	import fe.*;
	import fe.serv.Interact;
	import fe.loc.Tile;
	import fe.loc.Location;
	import fe.util.Vector2;
	import fe.entities.BoundingBox;
	import fe.entities.Obj;
	
	//различные ловушки, активирующиеся если войти в зону их действия - нажимные плиты, растяжки, лазерные датчики
	
	public class UnitTrigger extends Unit {

		private var status:int=0;	//0 - взведён, 1 - активирован, 2 - отключён
		private var trapT:int=0;	//тип области

		private var triggerBounds:BoundingBox;
		
		private var trapL:int=2;	//1 - нажимная плита, 2 - обычная
		private var needSkill:String='repair';
		private var isAct:Boolean=false;
		private var one:Boolean=false;	//одноразовая
		private var allid:String;
		private var allact:String;
		private var vNoise:int=1200;
		
		private var res:String='';
		private var damager:Unit;
		
		private var sndAct:String;

		private static var tileX:int = Tile.tileX;
		private static var tileY:int = Tile.tileY;

		// Constructor
		public function UnitTrigger(cid:String=null, ndif:Number=100, xml:XML=null, loadObj:Object=null) {
			super(cid, ndif, xml, loadObj);
			
			if (cid==null) {
				id='triglaser';
			}
			else {
				id=cid;
			}
			
			mat=1;
			vis=Res.getVis('vis'+id, vismtrap);	// .SWF Dependency
			setVis(false);
			getXmlParam();
			visibility=300;
			showNumbs=levitPoss=isSats=false;
			doop=true;
			sloy=0;
			noBox=true;
			
			if (xml) {
				if (xml.@allid.length()) allid=xml.@allid;
				if (xml.@allact.length()) allact=xml.@allact;
				if (xml.@res.length()) res=xml.@res;
			}
			
			fixed=true;
			inter = new Interact(this);
			inter.active=true;
			inter.action=100;
			inter.userAction='disarm';
			inter.actFun=disarm;
			inter.t_action=30;
			inter.needSkill=needSkill;
			inter.needSkillLvl=1;
			setStatus();
		}
		
		public override function save():Object {
			var obj:Object=super.save();
			if (obj==null) obj=new Object();
			obj.status=status;
			return obj;
		}
		
		public override function getXmlParam(mid:String=null) {
			super.getXmlParam();
			var node0:XML = XMLDataGrabber.getNodeWithAttributeThatMatches("core", "AllData", "units", "id", id);
			if (node0.un.length()) {
				if (node0.un.@skill.length()) needSkill=node0.un.@skill;		//требуемый скилл
				if (node0.un.@res.length()) res=node0.un.@res;
				if (node0.un.@one.length()) one=true;		//одноразовая
				if (node0.un.@plate.length()) trapL=1;		//напольная
			}
			if (node0.snd.length()) {
				if (node0.snd.@act.length()) sndAct=node0.snd.@act;
			}
		}
		
		public override function putLoc(nloc:Location, nx:Number, ny:Number) {
			super.putLoc(nloc,nx,ny);
			setArea();
			if (loc.tipEnemy==2 && fraction==F_RAIDER) fraction=Unit.F_ROBOT;
			if (allid==null || allid=='') setDamager();
		}
		
		public override function setLevel(nlevel:int=0) {
			level+=nlevel;
			var sk:int=Math.round(level*0.25*(Math.random()*0.7+0.3));
			if (sk<1) sk=1;
			if (sk>5) sk=5;
			inter.needSkillLvl=sk;
		}
		
		private function setDamager():void
		{
			if (res=='noise' || res=='') return;
			var i:int=1;
			var nx:Number = coordinates.X;
			var ny:Number = coordinates.Y;
			var nxml=<obj/>;
			var ok:Boolean=false;
			if (res=='damgren' && isrnd(0.25) && coordinates.Y < loc.maxY - 100 && loc.getAbsTile(coordinates.X, coordinates.Y + 60).phis==0) {
				ny = coordinates.Y + 2 * tileY;
				res='expl1';
				ok=true;
			}
			else for (var i=1; i<=10; i++) {
				if (res=='damgren' || res=='hturret2') {
					if (loc.getAbsTile(coordinates.X, coordinates.Y - 10 - i * tileY).phis) {
						if (i==1) break;
						ny = coordinates.Y - (i - 1) * tileY;
						ok=true;
						break;
					}
					if (res=='hturret2') {
						if (loc.getAbsTile(coordinates.X - tileX, coordinates.Y - 10 - i * tileY).phis) {
							ny = coordinates.Y - (i-1) * tileY;
							nx = coordinates.X - tileX;
							ok=true;
							break;
						}
						if (loc.getAbsTile(coordinates.X + tileX, coordinates.Y - 10 - i * tileY).phis) {
							ny = coordinates.Y - (i-1) * tileY;
							nx = coordinates.X + tileX;
							ok=true;
							break;
						}
					}
				}
				if (res=='damshot') {
					if (i>1 && loc.getAbsTile(coordinates.X - i * tileX, coordinates.Y).phis) {
						nx = coordinates.X - (i-1) * tileX;
						nxml=<obj turn="1"/>;
						ok=true;
						break;
					}
					if (i>1 && loc.getAbsTile(coordinates.X + i * tileX, coordinates.Y).phis) {
						nx = coordinates.X + (i-1) * tileX;
						nxml=<obj turn="-1"/>;
						ok=true;
						break;
					}
				}
			}
			if (ok)	{
				damager=loc.createUnit(res,nx,ny,true, nxml);
				if (damager) {
					damager.fraction=fraction;
				}
			}
			else if (res=='damgren' || res=='hturret2') {
				res='damshot';
				setDamager();
			}
			else {
				res='damshot';
				if (isrnd()) {
					nx=coordinates.X+(3+int(Math.random()*8))*tileX;
					nxml=<obj turn="-1"/>;
				} else {
					nx = coordinates.X - (3 + int(Math.random() * 8)) * tileX;
					nxml=<obj turn="1"/>;
				}
				damager=loc.createUnit(res,nx,ny,true, nxml);
				if (damager) {
					damager.fraction=fraction;
				}
			}
		}

		private function setStatus() {
			if (status>0) {
				warn=0;
				inter.active=false;
			}
			else {
				warn=1;
				inter.active=true;
			}
			vis.gotoAndStop(status+1);
			inter.update();
		}
		
		public override function die(sposob:int=0) {
			super.die(sposob);
			if (status==0) activate();
		}
		
		public function setVis(v:Boolean) {
			isVis=v;
			vis.visible=v;
			vis.alpha=v?1:0.1;
		}
		
		public override function expl()	{
			newPart('metal',3);
		}
		
		// [Set activation boundaries]
		private function setArea() {
			var bb:BoundingBox = new BoundingBox(coordinates);
			var l:Number;
			var r:Number;
			var t:Number;
			var b:Number;
			
			if (id=='trigridge' || id=='triglaser') {
				l = coordinates.X - 5
				r = coordinates.X + 5;
				t = coordinates.Y - 30;
				b = coordinates.Y - 20;
				
			}
			else if (id=='trigplate') {
				l = bb.left;
				r = bb.right;
				t = coordinates.Y - 1;
				b = coordinates.Y - 1;
			}
			else {
				l = bb.left;
				r = bb.right;
				t = bb.top;
				b = bb.bottom;
			}

			bb.setBounds(l, r, t, b);
			this.triggerBounds = bb;
		}
		
		//обезвредить
		private function disarm():void {
			status=2;
			setStatus();
			World.w.gui.infoText('trapDisarm')
		}
		
		//реактивировать
		private function rearm():void {
			status=0;
			setStatus();
		}
		
		//активировать
		private function activate():void {
			if (status!=0) return;
			setVis(true);
			status=1;
			var act:Boolean = false;
			if (allact=='spawn') {
				loc.enemySpawn(true,true);
				return;
			}
			if (allid!=null && allid!='') {
				for each (var un:Unit in loc.units) {
					if (un!=this && (un is UnitDamager) && (un as UnitDamager).allid==allid) {
						(un as UnitDamager).activate();
						act=true;
					}
				}
				if (allact) loc.allAct(this,allact,allid);
			}
			celX = coordinates.X;
			celY = coordinates.Y;
			if (res=='noise' || res=='hturret2') {
				budilo(vNoise);
				act=true;
				if (res=='hturret2' && damager) damager.command('alarma');
			}
			if (damager && damager.sost<2) {
				damager.command('dam');
				act=true;
			}
			if (sndAct) sound(sndAct);
			setStatus();
			if (act) World.w.gui.infoText('trapActivate')
		}
		
		private var aiN:int = Math.floor(Math.random() * 5);
		
		override protected function control():void {
			if (sost>1 || status==2 || one && status==1) return;
			aiN++;
			if (aiN%5==0) {
				var act:Boolean=false;
				for each (var un:Unit in loc.units) {
					if (un.activateTrap==0 || un.fraction==fraction || !isMeet(un)) continue;
					if (trapL<2 && (un.massa<0.5 || un.activateTrap<=1 || !un.stay)) continue;
					if (this.triggerBounds != null && this.triggerBounds.intersects(un.boundingBox)) act = true;
				}
				if (!isAct && act) activate();
				if (isAct && !act && !one) rearm();
				isAct=act;
			}
			if (aiN%10==0 && !isVis) {
				isVis=World.w.gg.lookInvis(this);
				if (isVis) {
					setVis(true);
				}
			}
		}
	}
}
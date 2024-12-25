package fe.loc {

	import flash.display.MovieClip;
	
	import fe.*;
	import fe.entities.Obj;
	import fe.serv.Interact;
	
	public class CheckPoint extends Obj {

		public var id:String;
		public var vis2:MovieClip;
		
		public var active:int = 0;
		public var teleOn:Boolean=false;
		public var used:Boolean=false;
		public var main:Boolean=false;
		public var hide:Boolean=false;
		
		private var locked:Boolean=false;
		
		public var area:Area;

		private static var tileX:int = Tile.tileX;
		private static var tileY:int = Tile.tileY;

		public function CheckPoint(nloc:Location, nid:String, nx:int=0, ny:int=0, xml:XML=null, loadObj:Object=null) {
			id=nid;
			loc=nloc;
			sloy=0;
			prior=1;
			id=nid;
			levitPoss=false;
			
			var node:XML = XMLDataGrabber.getNodeWithAttributeThatMatches("core", "AllData", "objs", "id", id);
			
			coordinates.X = nx;
			coordinates.Y = ny;
			objectWidth = node.@size * tileX;
			objectHeight = node.@wid * tileY;
			nazv=Res.txt('o','checkpoint');
			
			leftBound = coordinates.X - objectWidth / 2;
			rightBound = coordinates.X + objectWidth / 2;
			topBound = coordinates.Y - objectHeight;
			bottomBound = coordinates.Y;
			coordinates.X  = nx;
			coordinates.Y  = ny;
			var vClass:Class = Res.getClass('vischeckpoint', null, vischeckpoint); // SWF Dependency
			vis=new vClass();
			vis.x = coordinates.X;
			vis.y = coordinates.Y;
			vis.gotoAndStop(1);
			if (id.charAt(10)) {
				vis.lock.gotoAndStop(int(id.charAt(10)));
				locked=true;
			}
			else vis.lock.visible=false;
			leftBound = coordinates.X - objectWidth / 2;
			rightBound = coordinates.X + objectWidth / 2;
			topBound = coordinates.Y - objectHeight;
			bottomBound = coordinates.Y;
			cTransform=loc.cTransform;
			loc.getAbsTile(coordinates.X - 20, coordinates.Y + 10).shelf = true;
			loc.getAbsTile(coordinates.X + 20, coordinates.Y + 10).shelf = true;
			
			inter = new Interact(this,node,xml,loadObj);
			inter.userAction='activate';
			inter.actFun=activate;
			inter.update();
			inter.active=true;
			inter.action=100;
			
			area=new Area(loc);
			area.setSize(leftBound,topBound,rightBound,bottomBound);
			area.over=areaActivate;
			
			if (xml && xml.@main.length()) main=true;
			if (xml && xml.@tele.length()) teleOn=true;
			if (xml && xml.@hide.length()) hide=true;
			
			if (loadObj) {
				active=loadObj.act;
				if (active==undefined) active=0;
				if (active==1)  vis.osn.gotoAndStop('reopen');
				if (active==2)  {
					vis.osn.gotoAndStop('open');
				}
				if (loadObj.used) used=true;
			}
			if (main) {
				area=null;
				active=2;
				teleOn=true;
				vis.osn.gotoAndStop('open');
				loc.land.currentCP=this;
				inter.actFun=teleport;
				inter.userAction='returnm';
				inter.t_action=30;
				inter.update();
				vis.fiol.gotoAndStop(25);
			}
			if (hide) {
				vis.visible=false;
				nazv='';
				inter.active=false;
			}
		}
		
		public override function addVisual():void {
			if (vis && !hide) {
				World.w.grafon.visObjs[sloy].addChild(vis);
				if (cTransform) {
					vis.transform.colorTransform=cTransform;
				}
			}
		}
		public override function remVisual():void {
			super.remVisual();
		}
		
		public override function save():Object {
			if (active==0) return null;
			var obj:Object=new Object();
			inter.save(obj);
			obj.act=active;
			if (used) obj.used=1;
			return obj;
		}
		
		public override function command(com:String, val:String=null) {
			activate();
		}
		
		//активировать контрольную точку. если параметр true - не добавлять скилл-поинт
		public function activate(first:Boolean=false):void {
			if (inter.lock>0 || inter.mine>0) return;
			if (active==2) {
				return;
			}
			if (active==0 && first==false) {
				if (World.w.pers.manaCPres) World.w.pers.heal(World.w.pers.manaCPres,6);
				if (World.w.pers.xpCPadd) World.w.pers.expa(loc.unXp*3);
			}
			active=2;
			World.w.pers.currentCP=this;
			World.w.pers.currentCPCode=code;
			if (code) {
				World.w.pers.prevCPCode=code;
				loc.land.act.lastCpCode=code;
			}
			loc.land.currentCP=this;
			if (first) {
				vis.osn.gotoAndStop('open');
				if (World.w.game.mReturn && teleOn && !used) vis.fiol.gotoAndStop(25);
			} else {
				vis.osn.play();
				if (World.w.game.mReturn && teleOn && !used) vis.fiol.gotoAndPlay(1);
			}
			if (used) vis.fiol.gotoAndStop(1);
			if (World.w.game.mReturn && teleOn && !used) {
				inter.actFun=teleport;
				inter.userAction='returnb';
				inter.t_action=30;
				inter.update();
			} else {
				inter.active=false;
				inter.actionText='';
			}
			World.w.gui.infoText('checkPoint');
			World.w.saveGame();
		}
		
		public function teleport():void {
			if (main) {
				if (World.w.game.missionId != 'rbl') World.w.game.gotoLand(World.w.game.missionId);
			}
			else {
				World.w.game.gotoLand(World.w.game.baseId);
				if (World.w.hardInv && World.w.land.rnd) {
					used = true;
					inter.active = false;
					inter.actionText = '';
					vis.fiol.gotoAndStop(1);
				}
			}
		}
		
		public function areaActivate():void {
			if (active==0) activate();
		}
		
		public function deactivate():void {
			if (main) return;
			inter.active=!hide;
			active=1;
			vis.osn.gotoAndStop('reopen');
			vis.fiol.gotoAndStop(1);
			inter.actFun=activate;
			inter.userAction='activate';
			inter.t_action=0;
			inter.update();
		}
		
		public override function step():void {
			onCursor=(leftBound<World.w.celX && rightBound>World.w.celX && topBound<World.w.celY && bottomBound>World.w.celY)?prior:0;
			if (inter) inter.step();
			if (main) {
				if (World.w.game.missionId && World.w.game.lands[World.w.game.missionId] && World.w.game.lands[World.w.game.missionId].tip!='base') inter.active=true;
				else inter.active=false;
				return;
			}
			if (locked && inter.lock==0 && inter.mine==0) {
				locked=false;
				vis.lock.visible=false;
			}
			if (area) area.step();
			if (active==2 && World.w.pers.currentCP!=this) deactivate();
		}
	}
}
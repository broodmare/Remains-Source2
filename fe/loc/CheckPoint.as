package fe.loc {
	
	import flash.geom.ColorTransform;
	import flash.display.MovieClip;
	
	import fe.*;
	import fe.serv.Interact;
	
	public class CheckPoint extends Obj{

		public var id:String;
		public var vis2:MovieClip;
		
		public var active=0;
		public var teleOn:Boolean=false;
		public var used:Boolean=false;
		public var main:Boolean=false;
		public var hide:Boolean=false;
		
		var locked:Boolean=false;
		
		public var area:Area;

		public function CheckPoint(nloc:Location, nid:String, nx:int=0, ny:int=0, xml:XML=null, loadObj:Object=null) {
			id=nid;
			loc=nloc;
			sloy=0;
			prior=1;
			id=nid;
			levitPoss=false;
			var node:XML=AllData.d.obj.(@id==id)[0];
			
			X=nx, Y=ny;
			scX=node.@size*World.tileX;
			scY=node.@wid*World.tileY;
			nazv=Res.txt('o','checkpoint');
			
			X1=X-scX/2, X2=X+scX/2, Y1=Y-scY, Y2=Y;
			X=nx, Y=ny;
			var vClass:Class=Res.getClass('vischeckpoint', null, vischeckpoint);
			//var vClass2:Class=AllData.getClass('vistrap'+id+'2', null, null);
			vis=new vClass();
			vis.x=X, vis.y=Y;
			/*if (vClass2!=null) {
				vis2=new vClass2();
				vis2.x=X, vis2.y=Y;
			}*/
			vis.gotoAndStop(1);
			try {
				if (id.charAt(10)) {
					vis.lock.gotoAndStop(int(id.charAt(10)));
					locked=true;
				} else vis.lock.visible=false;
			} catch (err) {}
			//if (!anim) vis.cacheAsBitmap=true;
			//if (vis2 && !anim) vis2.cacheAsBitmap=true;
			X1=X-scX/2, X2=X+scX/2, Y1=Y-scY, Y2=Y;
			cTransform=loc.cTransform;
			loc.getAbsTile(X-20,Y+10).shelf=true;
			loc.getAbsTile(X+20,Y+10).shelf=true;
			
			inter = new Interact(this,node,xml,loadObj);
			inter.userAction='activate';
			inter.actFun=activate;
			inter.update();
			inter.active=true;
			inter.action=100;
			
			area=new Area(loc);
			area.setSize(X1,Y1,X2,Y2);
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
			//trace(main);
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
		
		public override function addVisual() {
			if (vis && !hide) {
				World.w.grafon.visObjs[sloy].addChild(vis);
				if (cTransform) {
					vis.transform.colorTransform=cTransform;
				}
			}
		}
		public override function remVisual() {
			super.remVisual();
			//if (vis2 && vis2.parent) vis2.parent.removeChild(vis2);
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
		public function activate(first:Boolean=false) {
			if (inter.lock>0 || inter.mine>0) return;
			if (active==2) {
				return;
			}
			/*if (active==0 && World.w.addCheckSP && first==false) {
				World.w.pers.addSkillPoint();
			}*/
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
			//trace(World.w.game.mReturn)
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
		
		public function teleport() {
			if (!main) {
				World.w.game.gotoLand(World.w.game.baseId);
				if (World.w.hardInv && World.w.land.rnd) {
					used=true;
					inter.active=false;
					inter.actionText='';
					vis.fiol.gotoAndStop(1);
				}
			} else if (World.w.game.missionId!='rbl') World.w.game.gotoLand(World.w.game.missionId);
			//trace('GOTO '+World.w.game.curLandId);
		}
		
		public function areaActivate() {
			if (active==0) activate();
		}
		
		public function deactivate() {
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
		
		public override function step() {
			onCursor=(X1<World.w.celX && X2>World.w.celX && Y1<World.w.celY && Y2>World.w.celY)?prior:0;
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

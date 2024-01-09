package fe.loc {
	
	import flash.geom.ColorTransform;
	import flash.display.MovieClip;
	
	import fe.*;
	import fe.unit.Unit;
	
	public class Trap extends Obj{

		public var id:String;
		public var vis2:MovieClip;
		
		//public var maxhp:Number=100;
		//public var armor:Number=0;		
		public var dam:Number=0;
		public var tipDamage:int=0;
		
		public var spDam:int=1;		//способ нанесения урона
		public var spBind:int=1;	//способ прикрепления
		public var floor:Boolean=false;
		
		var anim:Boolean=false;


		public function Trap(nloc:Location, nid:String, nx:int=0, ny:int=0) {
			loc=nloc;
			sloy=0;
			prior=1;
			id=nid;
			X=nx, Y=ny;
			var vClass:Class=Res.getClass('vistrap'+id, null, vistrapspikes);
			var vClass2:Class=Res.getClass('vistrap'+id+'2', null, null);
			vis=new vClass();
			vis2=new vClass2();
			var n1=Math.floor(Math.random()*vis.totalFrames)+1;
			var n2=Math.floor(Math.random()*vis.totalFrames)+1;
			levitPoss=false;
			vis.gotoAndStop(n1);
			vis2.gotoAndStop(n2);
			getXmlParam()
			if (!anim) vis.cacheAsBitmap=true;
			if (vis2 && !anim) vis2.cacheAsBitmap=true;
			X1=X-scX/2, X2=X+scX/2;
			if (floor) {
				Y1=Y-scY, Y2=Y;
			} else {
				Y1=Y-World.tileY, Y2=Y1+scY;
			}
			vis.x=X, vis.y=Y;
			vis2.x=X, vis2.y=Y;
			cTransform=loc.cTransform;
			bindTile();
		}
		
		public function getXmlParam() {
			var node:XML=AllData.d.obj.(@id==id)[0];
			nazv=Res.txt('u',id);
			if (node.@sX>0) scX=node.@sX; else scX=node.@size*World.tileX;
			if (node.@sY>0) scY=node.@sY; else scY=node.@wid*World.tileY;
			//armor=node.@armor;
			//if (node.@hp>0) hp=maxhp=node.@hp;
			dam=node.@damage;
			if (node.@tipdam.length()) tipDamage=node.@tipdam;
			if (node.@anim.length()) anim=true;
			if (node.@floor.length()) floor=true;
			if (node.@att.length()) spDam=node.@att;
			if (node.@bind.length()) spBind=node.@bind;
			//if (node.@sprX>0) {blitX=node.@sprX, blitY=node.@sprX;}
		}
		
		public override function addVisual() {
			if (vis) {
				World.w.grafon.visObjs[sloy].addChild(vis);
				if (cTransform) {
					vis.transform.colorTransform=cTransform;
				}
			}
			if (vis2) {
				World.w.grafon.visObjs[3].addChild(vis2);
				if (cTransform) {
					vis2.transform.colorTransform=cTransform;
				}
			}
		}
		public override function remVisual() {
			super.remVisual();
			if (vis2 && vis2.parent) vis2.parent.removeChild(vis2);
		}
		
		public override function step() {
			if(!loc.active) return;
			for each (var un:Unit in loc.units) {
				if (!un.activateTrap || un.sost==4) continue;
				attKorp(un);
			}
		}
		
		public function bindTile() {
			if (spBind==1) {		//прикрепление к полу
				loc.getAbsTile(X,Y+10).trap=this;
			}
			if (spBind==2) {		//прикрепление к потолку
				loc.getAbsTile(X,Y-50).trap=this;
			}
		}
		
		public override function die(sposob:int=0) {
			loc.remObj(this);
		}
		
		public function attKorp(cel:Unit):Boolean {
			if (cel==null || cel.neujaz) return false;
			if (spDam==1 && !cel.isFly && cel.dy>8 && cel.X<=X2 && cel.X>=X1 && cel.Y<=Y2 && cel.Y>=Y1) {		//шипы
				cel.damage(cel.massa*cel.dy/20*dam*(1+loc.locDifLevel*0.1), tipDamage);
				cel.neujaz=cel.neujazMax;
			}
			if (spDam==2 && !cel.isFly && (cel.dy+cel.osndy<0) && cel.X<=X2 && cel.X>=X1 && cel.Y1<=Y2 && cel.Y1>=Y1) {		//шипы
				cel.damage(cel.massa*dam*(1+loc.locDifLevel*0.1), tipDamage);
				cel.neujaz=cel.neujazMax;
			}
			return true;
		}

	}
	
}

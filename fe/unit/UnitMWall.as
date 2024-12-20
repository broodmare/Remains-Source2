package fe.unit {
	
	import fe.*;
	import fe.util.Vector2;
	import fe.graph.Emitter;

	public class UnitMWall extends Unit {
		
		var rearm:Boolean=false;

		// Constructor
		public function UnitMWall(cid:String=null, ndif:Number=100, xml:XML=null, loadObj:Object=null) {
			if (cid==null) {
				id='mwall';
			}
			else id=cid
			
			mat=7;
			vis=Res.getVis('vis'+id,vismwall);
			getXmlParam();
			vulner[D_NECRO]=begvulner[D_NECRO]=1;
			nazv='';
			this.levitPoss=false;
			showNumbs=false;
			doop=true;
			transT=true;
		}

		public override function expl()	{
			Emitter.emit('pole', loc, coordinates.X, coordinates.Y-objectHeight/2,{kol:12,rx:objectWidth, ry:objectHeight});
		}
		
		public override function addVisual() {
			if (disabled) return;
			if (vis && loc && loc.active) World.w.grafon.visObjs[sloy].addChild(vis);
		}
		
		public override function visDetails() {

		}
		
		override protected function control():void {
			hp-=0.2;
			if (hp<50) vis.alpha=hp/50;
			if (hp<=0) exterminate();
		}
		
		public override function setNull(f:Boolean=false) {
			exterminate();
		}		
		
		public override function die(sposob:int=0) {
			expl();
			exterminate();
		}
	}
}
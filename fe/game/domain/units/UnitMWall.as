package fe.game.domain.units {
	
	import flash.display.MovieClip;
	
	import fe.engine.utils.SymbolFactory;
	import fe.game.rendering.Emitter;
	import fe.game.GameContainer;
	import fe.game.enums.E_Material;
	import fe.game.domain.units.enums.E_Resistances;

	public class UnitMWall extends Unit {
		
		private var rearm:Boolean=false;

		public function UnitMWall(cid:String=null, ndif:Number=100, xml:XML=null, loadObj:Object=null) {
			if (cid == null) {
				id = "mwall";
			}
			else id = cid
			
			mat = E_Material.FORCE_FIELD;
			var vClass:Class = SymbolFactory.fetchSymbolClass("vis" + String(id)) || SymbolFactory.fetchSymbolClass("vismwall");
			vis = new vClass() as MovieClip;
			getXmlParam();
			vulnerabilities.setResist(E_Resistances.DAM_DEATH, 1);
			begvulner.setResist(E_Resistances.DAM_DEATH, 1);
			nazv = "";
			levitPoss = false;
			showNumbs = false;
			doop = true;
			transT = true;
		}

		public override function expl():void {
			Emitter.emit("pole", loc, coordinates.X, coordinates.Y - this.boundingBox.halfHeight, {kol:12,rx:this.boundingBox.width, ry:this.boundingBox.height});
		}
		
		public override function addVisual():void {
			if (disabled) return;
			if (vis && loc && loc.active) GameContainer.reference.grafon.visObjs[sloy].addChild(vis);
		}
		
		public override function visDetails():void {

		}
		
		override protected function control():void {
			hp-=0.2;
			if (hp<50) vis.alpha=hp/50;
			if (hp<=0) exterminate();
		}
		
		public override function setNull(f:Boolean=false):void {
			exterminate();
		}		
		
		public override function die(sposob:int=0):void {
			expl();
			exterminate();
		}
	}
}

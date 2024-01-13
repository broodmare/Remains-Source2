package fe.entities
{
	//Базовый класс для всех объектов
	import flash.display.MovieClip;

	import fe.World;
	import fe.loc.Location;
	
	public class Pt
	{
		public var vis:MovieClip; // Movieclip Object holding the entity's (sprite?).

		public var loc:Location;			// What room the entity is currently in
		public var nobj:Pt, pobj:Pt;		// Next Obj in processing chain, Previous Obj in processing chain
		public var in_chain:Boolean=false;
		
		public var stay:Boolean=false;
		public var X:Number;
		public var Y:Number;
		public var sloy:int=0;
		
		// Movement
		public var dx:Number=0, dy:Number=0;
		
		public function Pt() {
		}

		public function addVisual() {
			if (vis && loc && loc.active) World.w.grafon.visObjs[sloy].addChild(vis);
		}

		public function remVisual() {
			if (vis && vis.parent) vis.parent.removeChild(vis);
		}

		public function setNull(f:Boolean=false) {
		}
		
		public function err():String {
			if (loc) loc.remObj(this);
			return null;
		}
		
		public function step() {
		}
	}
}
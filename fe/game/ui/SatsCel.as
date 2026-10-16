package fe.game.ui {

	import fe.engine.utils.SymbolFactory;
	import fe.game.World;
	import fe.game.domain.entities.Obj;

	public class SatsCel extends Obj {

		public var kol:int = 1;
		public var cons:Number;
		public var un:Object;
		public var begined:Boolean = false;

		public function SatsCel(nUn:Object, nx:Number, ny:Number, ncons:Number, nkol:int=1) {
			layer = 5;
			loc = World.w.loc;
			var ramka:int = 10;
			
			if (nUn == null) {
				vis = SymbolFactory.createInstance("satsCel");		// Red crosshairs on a targeted spot
				coordinates.X = nx;
				coordinates.Y = ny;
				vis.x = coordinates.X;
				vis.y = coordinates.Y;
			}
			else {
				un = nUn;
				vis = SymbolFactory.createInstance("satsUnCel");	// Red square around a targeted unit
				un.n++;
				run();
				vis.scaleX = (un.u.boundingBox.width + ramka * un.n) / 100;
				vis.scaleY = (un.u.boundingBox.height + ramka * un.n) / 100;
			}
			
			cons = ncons / nkol;
			kol = nkol;
			addVisual();
		}
		
		public function remove():void {
			remVisual();
		}
		
		public function run():void {
			if (un) {
				coordinates.X = un.u.coordinates.X;
				coordinates.Y = un.u.coordinates.Y - un.u.boundingBox.halfHeight;
				vis.x = coordinates.X;
				vis.y = coordinates.Y;
			}
		}
	}
}
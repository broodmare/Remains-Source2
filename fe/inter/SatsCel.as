package fe.inter {

	import fe.*;
	import fe.entities.Obj;

	import fe.stubs.satsCel;	// Red crosshairs used when a coordinate is targeted instead of a unit.
	import fe.stubs.satsUnCel;	// Red square around units that have been targeted in vats.

	public class SatsCel extends Obj {

		var kol:int = 1;
		var cons:Number;
		var un:Object;
		var begined:Boolean = false;

		// Constructor
		public function SatsCel(nUn:Object, nx:Number, ny:Number, ncons:Number, nkol:int=1) {
			sloy = 5;
			loc = World.w.loc;
			var ramka:int = 10;
			
			if (nUn == null) {
				vis = new satsCel();
				coordinates.X = nx;
				coordinates.Y = ny;
				vis.x = coordinates.X;
				vis.y = coordinates.Y;
			}
			else {
				un = nUn;
				vis = new satsUnCel();
				un.n++;
				run();
				vis.scaleX = (un.u.objectWidth + ramka * un.n) / 100;
				vis.scaleY = (un.u.objectHeight + ramka * un.n) / 100;
			}
			
			cons = ncons / nkol;
			kol = nkol;
			addVisual();
		}
		
		public function remove() {
			remVisual();
		}
		
		public function run() {
			if (un) {
				coordinates.X = un.u.coordinates.X;
				coordinates.Y = un.u.coordinates.Y - un.u.objectHeight / 2;
				vis.x = coordinates.X;
				vis.y = coordinates.Y;
			}
		}
	}
}
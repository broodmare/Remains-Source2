package  fe.unit {

	import fe.loc.Location;
	import fe.util.Calc;
	
	public class Coord {

		public var tip:String;
		public var loc:Location;
		
		public var t1:int;
		public var t2:int;
		
		public var tr:int;
		public var liv1:Boolean = false;
		public var liv2:Boolean = false;
		public var liv3:Boolean = false;
		
		private static var kolAll:int = 6;
		private static var kolClosed:int = 3;
		public var opened:Array = [];

		// Constructor
		public function Coord(nloc:Location, ntip:String = null) {
			loc = nloc;
			tip = ntip;
			tr = 1;
			t1 = 100;
			t2 = 150;
			rndOpened();
		}
		
		private function rndOpened():void {
			for (var i:int = 1; i <= kolAll; i++) {
				opened[i] = true;
			}
			for (var j:int = 1; j <= kolClosed; j++) {
				var randomIndex:int = Calc.intBetween(1, kolAll);
        		opened[randomIndex] = false;
			}
		}
		
		public function step():void {
			t1--;
			if (t1 <= 0) {
				t1 = Calc.intBetween(150, 209);
				for (var i:int = 1; i <= 3; i++) {
					tr++;
					if (tr > 3) tr = 1;
					if (this['liv' + tr]) break;
				}
			}
			t2--;
			if (t2 == 75) {
				for (var j:int = 1;j <= kolAll; j++) {
					loc.allAct(null, opened[j] ? 'red': 'green', 'a' + j);
				}
			}
			if (t2 == 0) {
				for (var k:int = 1; k <= kolAll; k++) {
					loc.allAct(null, opened[k] ? 'open' : 'close', 'a' + k);
				}
				t2 = 300;
				rndOpened();
			}
		}
	}	
}
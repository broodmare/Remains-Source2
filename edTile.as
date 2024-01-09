package {
	
	import flash.display.MovieClip;
	
	
	public class edTile extends MovieClip {
		
		//для блоков-образцов
		public var tip:int=0;	//слой, он же индекс ids. 1-фронт, 2-зад, 3-лестница, 4-балка или ступеньки, 5-вода
		public var id:String;
		
		//для блоков рабочей области
		public var ids:Array=['','','','','',''];
		public var frames:Array=[0,0,0,0,0,0];
		public var zForm:int=0; //0-полный, 1-3/4, 2-1/3, 3-1/4
		
		public var vis2:MovieClip;
		
		public function edTile() {
			cacheAsBitmap=true;
			// constructor code
		}
		
		public function upd() {
			for (var i=1; i<ids.length; i++) {
				this['vis'+i].gotoAndStop(frames[i]+1)
			}
			vis1.y=zForm*5;
			vis1.scaleY=1-zForm/4;
		}
		public function enc():String {
			var s=ids[1];
			if (s=='') s='_';
			if (zForm==1) s+=',';
			if (zForm==2) s+=';';
			if (zForm==3) s+=':';
			for (var i=2; i<ids.length; i++) {
				if (ids[i]!='') s+=ids[i];
			}
			return s;
		}
		
		public function pipetka(t:edTile) {
			t.ids=['','','','','',''];
			t.frames=[0,0,0,0,0,0];
			if (pip(1,t) || pip(3,t) || pip(4,t) || pip(5,t) || pip(2,t)) return;
		}
		
		function pip(n:int, t:edTile):Boolean {
			if (ids[n]!='') {
				t.ids[n]=ids[n];
				t.frames[n]=frames[n];
				return true;
			}
			return false
		}
		
		//для определения проходов
		public function isPhis():Boolean {
			if (ids[1]=='') return false;
			else return true;
		}
		
		public function dec(s:String, fronts:Array, backs:Array) {
			ids=['','','','','',''];
			frames=[0,0,0,0,0,0];
			zForm=0;
			var fr:String=s.charAt(i);
			if (fr=='_') fr='';
			ids[1]=fr;
			frames[1]=fronts[fr].frame;
			if (s.length>1) {
				for (var i=1; i<s.length; i++) {
					fr = s.charAt(i);
					if (fr==',') {
						zForm=1;
					} else if (fr==';') {
						zForm=2;
					} else if (fr==':') {
						zForm=3;
					} else {
						var obj:Object=backs[fr];	//достаём нужный объект из массива
						ids[obj.tip]=fr;			//назначаем нужный id
						frames[obj.tip]=obj.frame;	//назначаем нужный кадр
					}
				}
			}
		}
	}
	
}

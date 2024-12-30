package  fe.loc {

	import fe.util.Vector2;
	import fe.entities.BoundingBox;
	import fe.entities.Obj;
	
	public class Tile {
		
		private static var tileSize:int = 40; // Size in pixels
		public static var tileX:int = tileSize;	// TODO: Replace this better with tileSize
		public static var tileY:int = tileSize;
		
		public var coords:Vector2;

		// Bounding box
		public var boundingBox:BoundingBox;
		
		public var indestruct:Boolean=false;
		public var phis:int=0;
		public var shelf:Boolean=false;
		public var hp:int=1000, thre:int=0;
		
		
		public var zForm:int=0;
		public var diagon:int=0;
		public var stair:int=0;
		public var water:int=0;
		
		public var fake:Boolean=false;
		public var t_ghost:int=0;
		
		public var recalc:Boolean=false;
		
		public var vid:int=0, vid2:int=0; 
		public var front:String = '';
		public var back:String = '';
		public var zad:String = '';
		public var fRear:Boolean=false, vRear:Boolean=false, v2Rear:Boolean=false;
		
		public var visi:Number=0, t_visi:Number=0;
		public var opac:Number=0;	//непрозрачность блока
		
		//материал
		//0 - хз что
		//1 - металл
		//2 - камень
		//3 - дерево
		//4 - кирпич
		//5 - стекло
		//6 - земля
		//7 - силовое поле
		//10 - мясо
		public var mat:int=0;
		
		public var grav:Number=1;
		public var lurk:int=0;
		public var kontur:int=0;
		public var konturRot:int=0;
		public var floor:int=0;
		public var place:Boolean=true;	//место под объекты
		
		public var kont1:int=0, kont2:int=0, kont3:int=0, kont4:int=0;
		public var pont1:int=0, pont2:int=0, pont3:int=0, pont4:int=0;
		
		public var door:Box;
		public var trap:Obj;
		
		// Constructor
		public function Tile(nx:Number, ny:Number) {
			coords = new Vector2(nx, ny);
			boundingBox = new BoundingBox(coords);
			
			var l:Number = coords.X * tileSize;
			var r:Number = (coords.X + 1) * tileSize;
			var t:Number = coords.Y * tileSize;
			var b:Number = (coords.Y + 1) * tileSize;
			boundingBox.setBounds(l, r, t, b);
		}
		
		private function inForm(f:Form):void {
			if (f==null) return;
			if (f.tip==2) {
				if (f.front) back=f.front;
			}
			else {
				if (f.front) {
					front=f.front;
					if (f.rear) fRear=true;
				}
				if (f.back) zad=f.back;
			}
			if (f.vid>0) {
				if (vid==0)	{
					vid=f.vid;
					if (f.rear) vRear=true;
				}
				else {
					vid2=f.vid;
					if (f.rear) v2Rear=true;
				}
			}
			if (f.mat) mat=f.mat;
			
			if (f.hp) hp=f.hp;
			if (f.thre) thre=f.thre;
			if (f.indestruct) indestruct=true;
			
			if (f.lurk) lurk=f.lurk; 
			if (f.phis) phis=f.phis;
			if (f.shelf) shelf=true;
			if (f.diagon) diagon=f.diagon;
			if (f.stair) stair=f.stair;
			if (phis>0) opac=1;
		}
		
		public function dec(s:String, mirror:Boolean=false):void {
			
			phis = 0;
			vid = 0;
			vid2 = 0;
			diagon = 0;
			stair = 0;
			water = 0;
			front=back=zad='';
			shelf=indestruct=false;
			setZForm(0);
			
			var fr:int = s.charCodeAt(0);
			
			if (fr>64 && fr!=95) {
				inForm(Form.fForms[s.charAt(0)]);
			}
			
			if (s.length>1) {
				for (var i:int = 1; i<s.length; i++) {
					fr = s.charCodeAt(i);
					var sym:String=s.charAt(i);
					if (sym=='*') {
						water=1;
					}
					else if (sym==',') {
						setZForm(1);
					}
					else if (sym==';') {
						setZForm(2);
					}
					else if (sym==':') {
						setZForm(3);
					}
					else {
						if (mirror && Form.oForms[sym].idMirror) inForm(Form.oForms[Form.oForms[sym].idMirror]);
						else inForm(Form.oForms[sym]);
					}
				}
			}
			if (zForm==0) {
				if (zad!='') back=zad;
			}
		}
		
		public function hole():Boolean {
			if (phis>0) {
				phis=0;
				return true;
			}
			phis=0;
			return false;
		}
		
		public function updVisi():Number {
			visi+=0.1;
			if (visi>t_visi) visi=t_visi;
			return visi;
		}

		public function setZForm(n:int):void {
			if (n < 0) n = 0;
			if (n > 3) n = 3;
			zForm = n;
			boundingBox.top = ( coords.Y + zForm / 4) * tileSize;
			if (n > 0) opac = 0;
		}

		public function mainFrame(nfront:String='A'):void {
			phis=1;
			vid=vid2=diagon=stair=0;
			mat=Form.fForms[nfront].mat;
			front=nfront;
			back=Form.fForms[nfront].back;
			indestruct=true;
			hp=10000;
			opac=1;
		}
		
		public function getMaxY(rx:Number):Number {
			if (diagon == 0) {
				return boundingBox.top;
			}
			else if (diagon > 0) {
				if (rx < boundingBox.left) {
					return boundingBox.bottom;
				}
				else if (rx > boundingBox.right) {
					return boundingBox.top;
				}
				else {
					return boundingBox.bottom - (boundingBox.bottom - boundingBox.top) * ((rx - boundingBox.left) / (boundingBox.right - boundingBox.left));
				}
			}
			else {
				if (rx < boundingBox.left) {
					return boundingBox.top;
				}
				else if (rx > boundingBox.right) {
					return boundingBox.bottom;
				}
				else {
					return boundingBox.bottom - (boundingBox.bottom - boundingBox.top) * ((boundingBox.right - rx) / (boundingBox.right - boundingBox.left));
				}
			}
		}
		
		//нанести урон блоку, вернуть true если урон был
		public function udar(hit:int):Boolean {
			if (indestruct || thre>hit) return false;
			hp-=hit;
			return true;
		}
		
		//уничтожить блок
		public function die():void {
			if (phis!=3) front='';
			phis=0;
			opac=0;
			vid=vid2=0;
			
			t_ghost=0;
			if (trap) trap.die();	//уничтожить привязки
		}
	}
}
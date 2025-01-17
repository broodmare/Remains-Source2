package  fe.loc {

	import fe.util.Vector2;
	import fe.entities.BoundingBox;
	import fe.entities.Obj;
	
	public class Tile {
		
		private static var tileSize:int = 40; // Size in pixels
		public static var tileX:int = tileSize;	// TODO: Replace this better with tileSize
		public static var tileY:int = tileSize;
		
		public var coords:Vector2;					// (is this raw coords or tilespace coords??)
		public var boundingBox:BoundingBox;			// Bounding box
		
		public var indestruct:Boolean	= false;
		public var phis:int				= 0;			// 4 States 0: No Collision, 1: Collision, 2: Grate, 3: Ghost Wall
		public var hp:int				= 1000;			// Hitpoints before the block breaks
		public var thre:int				= 0;			// Amount of damage needed to affect the tile's HP

		public var zForm:int			= 0;
		public var shelf:Boolean		= false;		// Does this tile have a beam the player can jump on/fall through
		public var diagon:int			= 0;			// Does this tile have stairs
		public var stair:int			= 0;			// Does this tile have a ladder
		public var water:int			= 0;			// Does this tile have water
		
		public var fake:Boolean			= false;		// ??
		public var t_ghost:int			= 0;			// Ghost wall lifetime timer(?)
		
		public var recalc:Boolean		= false;
		
		public var vid:int				= 0;
		public var vid2:int				= 0; 
		public var front:String			= "";
		public var back:String			= "";
		public var zad:String			= "";
		
		public var fRear:Boolean		= false;
		public var vRear:Boolean		= false;
		public var v2Rear:Boolean		= false;
		
		public var visi:Number			= 0.00;
		public var t_visi:Number		= 0.00;
		public var opac:Number			= 0.00;	// [Block opacity]
		
		// Material
		//  0 - [whatever] 	--	 1 - [metal]
		//  2 - [stone]		--	 3 - [wood]
		//  4 - [brick]		--	 5 - [glass]
		//  6 - [earth]		--	 7 - [force field]
		// 10 - [meat]
		public var mat:int			= 0;
		
		public var grav:Number		= 1.00;
		public var lurk:int			= 0;
		public var kontur:int		= 0;
		public var konturRot:int	= 0;
		public var floor:int		= 0;
		public var place:Boolean	= true;	// objects can be placed in this tile
		
		// Kont
		public var kont1:int		= 0;
		public var kont2:int		= 0;
		public var kont3:int		= 0;
		public var kont4:int		= 0;

		// Pont
		public var pont1:int		= 0;
		public var pont2:int		= 0;
		public var pont3:int		= 0;
		public var pont4:int		= 0;
		
		public var door:Box;		// Reference to (a door if it's contained in this tile?)
		public var trap:Obj;		// Reference to (a trap if it's contained in this tile?)
		
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
			if (f == null) {
				return;
			}
			
			if (f.tip == 2) {
				if (f.front) {
					back = f.front;
				}
			}
			else {
				if (f.front) {
					front = f.front;
					
					if (f.rear) {
						fRear = true;
					}
				}
				
				if (f.back) {
					zad = f.back;
				}
			}
			
			if (f.vid > 0) {
				if (vid == 0)	{
					vid = f.vid;
					
					if (f.rear) {
						vRear = true;
					}
				}
				else {
					vid2 = f.vid;
					
					if (f.rear) {
						v2Rear = true;
					}
				}
			}
			
			if (f.mat) {
				mat = f.mat;
			}
			
			if (f.hp) {
				hp = f.hp;
			}
			
			if (f.thre) {
				thre = f.thre;
			}
			
			if (f.indestruct) {
				indestruct = true;
			}
			
			if (f.lurk) {
				lurk = f.lurk;
			}
			
			if (f.phis) {
				phis = f.phis;
			}
			
			if (f.shelf) {
				shelf = true;
			}
			
			if (f.diagon) {
				diagon = f.diagon;
			}
			
			if (f.stair) {
				stair = f.stair;
			}
			
			if (phis > 0) {
				opac = 1;
			}
		}
		
		public function dec(s:String, mirror:Boolean=false):void {
			
			phis		= 0;
			vid			= 0;
			vid2		= 0;
			diagon		= 0;
			stair		= 0;
			water		= 0;
			front		= "";
			back		= "";
			zad			= "";
			shelf		= false;
			indestruct	= false;
			
			setZForm(0);
			
			var fr:int = s.charCodeAt(0);
			
			if (fr > 64 && fr != 95) {
				inForm(Form.fForms[s.charAt(0)]);
			}
			
			if (s.length > 1) {
				for (var i:int = 1; i < s.length; i++) {
					fr = s.charCodeAt(i);
					var sym:String = s.charAt(i);
					
					if (sym == "*") {
						water = 1;
					}
					else if (sym == ",") {
						setZForm(1);
					}
					else if (sym == ";") {
						setZForm(2);
					}
					else if (sym == ":") {
						setZForm(3);
					}
					else {
						if (mirror && Form.oForms[sym].idMirror) {
							inForm(Form.oForms[Form.oForms[sym].idMirror]);
						}
						else {
							inForm(Form.oForms[sym]);
						}
					}
				}
			}
			
			if (zForm == 0) {
				if (zad != "") {
					back = zad;
				}
			}
		}
		
		public function hole():Boolean {
			if (phis > 0) {
				phis = 0;
				return true;
			}
			
			phis = 0;
			
			return false;
		}
		
		public function updVisi():Number {
			visi += 0.10;
			
			if (visi > t_visi) {
				visi = t_visi;
			}
			
			return visi;
		}

		public function setZForm(n:int):void {
			if (n < 0) {
				n = 0;
			}
			else if (n > 3) {
				n = 3;
			}
			
			zForm = n;
			boundingBox.top = ( coords.Y + zForm / 4) * tileSize;
			
			if (n > 0) {
				opac = 0;
			}
		}

		public function mainFrame(nfront:String = "A"):void {
			phis		= 1;
			vid			= 0;
			vid2		= 0;
			diagon		= 0;
			stair		= 0;
			mat = Form.fForms[nfront].mat;
			front = nfront;
			back = Form.fForms[nfront].back;
			indestruct = true;
			hp = 10000;
			opac = 1;
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
		
		// [Cause damage to the block, return true if there was damage]
		public function udar(hit:int):Boolean {
			if (indestruct || thre > hit) {
				return false;
			}

			hp -= hit;
			
			return true;
		}
		
		// [Destroy the block]
		public function die():void {
			if (phis != 3) {
				front = "";
			}

			phis		= 0;
			opac		= 0;
			vid			= 0;
			vid2		= 0;
			t_ghost		= 0;
			
			if (trap) {
				trap.die();	// [Destroy bindings]
			}
		}
	}
}
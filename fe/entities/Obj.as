package  fe.entities {
	
	// [Base class for objects that interact with the player or the world]
	import flash.display.MovieClip;
	import flash.geom.ColorTransform;
	
	import fe.util.Vector2;
	import fe.World;
	import fe.serv.Interact;
	import fe.projectile.Bullet;
	import fe.inter.Appear;
	
	public class Obj extends Entity {
		
		public var code:String;		// [Individual code]
		public var uid:String;		// [Unique identifier used for script access to the object]
		
		public var prior:Number = 1;			// Priority?
		
		public var storona:int = 1;				// Sprite Facing (Left/Right)

		public var rasst2:Number=0;				// Distance to player squared
		public var massa:Number=1;
		public var levit:int=0;
		public var levitPoss:Boolean=true;		// [ability to move using levitation]
		public var fracLevit:int=0;				// [was levitated]
		public var radioactiv:Number=0;			// [Radioactivity]
		public var radrad:Number=250;			// [Radius of radioactivity]
		public var radtip:int=0;				// [0 - Radiation, 1 - Poison, 2 - Pink Cloud, 3 - Death]
		public var warn:int=0;					// [Float color tips]
		
		public var nazv:String = '';			// Name
		
		public var inter:Interact;				// Player interaction script 
		
		// Bounding box
		public var boundingBox:BoundingBox;
		
		public var onCursor:Number=0;
		//цветовой фильтр
		
		public static var nullTransfom:ColorTransform = new ColorTransform();
		public var cTransform:ColorTransform = nullTransfom;
		
		// Constructor
		public function Obj() {
			boundingBox = new BoundingBox(this.coordinates);
		}
		
		public override function remVisual():void {
			super.remVisual(); 
			onCursor = 0;
		}
		
		public function setVisState(s:String) {

		}
		
		public function die(sposob:int = 0):void {

		}
		
		public function checkStay():Boolean {
			return false;
		}
		
		public function getRasst2(obj:Obj=null):Number {
			if (obj == null) obj = World.w.gg;
			var nx:Number = obj.coordinates.X - coordinates.X;
			var ny:Number = obj.coordinates.Y - obj.boundingBox.halfHeight - coordinates.Y + this.boundingBox.halfHeight
			if (obj == World.w.gg) ny = obj.coordinates.Y - obj.boundingBox.height * 0.75 - coordinates.Y + this.boundingBox.halfHeight;
			rasst2 = nx * nx + ny * ny;
			if (isNaN(rasst2)) rasst2 = -1;
			return rasst2;
		}
		
		public function save():Object {
			return null;
		}
		
		//Interpret a script command
		public function command(com:String, val:String = null) {
			if (com == 'show') {
				World.w.cam.showOn	= true;
				World.w.cam.showX	= coordinates.X;
				World.w.cam.showY	= coordinates.Y;
			}
		}
		
		// If the object and the player are in the same location, and the object is radioactive, and the player is within the radioactive radius,
		// deal radiation damage to the player 
		public function ggModum() {
			if (loc == World.w.gg.loc && radioactiv && rasst2 >= 0 && rasst2 < radrad * radrad) {
				World.w.gg.raddamage((radrad - Math.sqrt(rasst2)) / radrad, radioactiv, radtip);
			}
		}
		
		// Remove the object and return an error message
		public override function err():String {
			if (loc) {
				loc.remObj(this);
			}
			return 'Error obj ' + nazv;
		}
		
		// A “normalize” method that caps the length of vector p to mr. If p is longer than mr, it scales it down to exactly mr
		public function norma(p:Object, mr:Number) {
			if (p.x * p.x + p.y * p.y > mr * mr) {
				var nr = Math.sqrt(p.x * p.x + p.y * p.y);
				p.x *= mr / nr;
				p.y *= mr / nr;
			}
		}
		
		// Change the object’s position a given location and then re-center the bounding box.
		public function bindMove(v:Vector2, ox:Number = -1, oy:Number = -1) {
			coordinates = v;
			boundingBox.center(v);
		}
		
		//копирование состояния в другой объект
		public function copy(un:Obj) {
			un.coordinates = coordinates;
			un.boundingBox = boundingBox;
			un.storona = storona;
		}
		
		// [Check if a bullet hit the object]
		public function udarBullet(bul:Bullet, sposob:int = 0):int {
			return -1;
		}
		
		// Triggers when the (player? object?) leaves a location. 
		public function locout() {

		}
		
		public static function setArmor(m:MovieClip) {
			var aid:String = '';
			if (World.w) {
				if (World.w.pip && World.w.pip.active || World.w.mmArmor && World.w.allStat == 0) aid = World.w.pip.armorID;
				else if (World.w.armorWork != '') aid = World.w.armorWork;
				else if (World.w.alicorn) aid = 'ali';
				else aid = Appear.ggArmorId;
			}
			if (aid == '') {
				m.gotoAndStop(1);
				return;
			}
			
			try {
				m.gotoAndStop(aid);
			}
			catch (err) {
				//trace('ERROR: (00:51) - Could not apply armor: "' + aid + '"!');
				m.gotoAndStop(1);
			}
		}
		
		// Set the head of the player to something
		public static function setMorda(m:MovieClip, c:int) {
			if (World.w && World.w.gg) m.gotoAndStop(World.w.gg.mordaN);
			else m.gotoAndStop(1);
		}
		
		public static function setColor(m:MovieClip, c:int) {
			if (Appear.transp) {
				m.visible=false;
				return;
			}
			if (c == 0) m.transform.colorTransform=Appear.trFur;
			if (c == 1) m.transform.colorTransform=Appear.trHair;
			if (c == 2) {
				if (Appear.visHair1) {
					m.visible=true;
					m.transform.colorTransform=Appear.trHair1;
				}
				else m.visible=false;
			}
			if (c==3) m.transform.colorTransform=Appear.trEye;
			if (c==4) m.transform.colorTransform=Appear.trMagic;
		}
		
		public static function setVisible(m:MovieClip) {
			var h:int;
			if (World.w && World.w.pip && World.w.pip.active) h=World.w.pip.hideMane;
			else h = Appear.hideMane;
			m.visible = (h==0);
		}
		
		public static function setEye(m:MovieClip) {	// SWF Depenency (Called by SWF)
			m.gotoAndStop(Appear.fEye);
		}

		public static function setHair(m:MovieClip) {	// SWF Dependency (Called by SWF)
			m.gotoAndStop(Appear.fHair);
		}
	}
}
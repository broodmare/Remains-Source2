package fe.game.domain.entities {
	
	// [Base class for objects that interact with the player or the world]
	import flash.display.MovieClip;
	import flash.filters.GlowFilter;
	import flash.geom.ColorTransform;
	
	import fe.engine.utils.Vec2;
	import fe.game.World;
	import fe.game.ui.GUIManager;
	import fe.game.GameContainer;
	import fe.game.domain.serv.Interact;
	import fe.game.domain.projectile.Bullet;
	import fe.game.ui.Appear;
	import fe.game.enums.E_Direction;
	
	public class Obj extends Entity {
		
		private static const NULL_TRANSFORM:ColorTransform = new ColorTransform();	// Re-use this instead of creating a new color transform every time

		public var code:String;								// [Individual code]
		public var uid:String;								// [Unique identifier used for script access to the object]
		public var nazv:String				= "";			// Name

		public var prior:Number				= 1.00;			// Priority?
		public var storona:Vec2				= E_Direction.RIGHT;	// Sprite Facing (Left/Right)

		public var rasst2:Number			= 0.00;			// Distance to player squared
		public var massa:Number				= 1.00;			//
		
		public var levitPoss:Boolean		= true;			// [ability to move using levitation]
		public var levit:int				= 0;			//
		public var fracLevit:int			= 0;			// [was levitated]
		public var teleHolder:Obj;							// Who holds this with telekinesis, null if nobody. The holder steers it directly, so levitation drag is skipped
		
		public var radioactiv:Number		= 0.00;			// [Radioactivity]
		public var radrad:Number			= 250.00;		// [Radius of radioactivity]
		public var radtip:int				= 0;			// [0 - Radiation, 1 - Poison, 2 - Pink Cloud, 3 - Death]
		public var warn:int					= 0;			// [Float color tips]
		
		public var inter:Interact;							// Player interaction script 
		public var boundingBox:BoundingBox;
		
		public var onCursor:int				= 0;

		public var cTransform:ColorTransform = NULL_TRANSFORM;	// [Color filter]
		
		public function Obj() {
			boundingBox = new BoundingBox(coordinates);
		}
		
		public override function remVisual():void {
			super.remVisual(); 
			onCursor = 0;
		}
		
		public function setVisState(s:String):void {

		}

		// Draws it through a Flash colour transform
		public function setTint(tint:ColorTransform):void {
			if (vis) {
				vis.transform.colorTransform = tint;
			}
		}

		// Surrounds it with a glow, or takes the glow away for null
		public function setGlow(glow:GlowFilter):void {
			if (vis) {
				vis.filters = glow ? [glow] : [];
			}
		}

		// Draws it in front of everything else in its layer
		public function bringToFront():void {
			if (vis && vis.parent) {
				vis.parent.setChildIndex(vis, vis.parent.numChildren - 1);
			}
		}
		
		public function die(sposob:int = 0):void {

		}
		
		public function checkStay():Boolean {
			return false;
		}
		
		// Calculate the distance to an object or player
		public function getRasst2(obj:Obj = null):Number {
			// Default to the player if obj is not provided
			obj = obj || GameContainer.reference.gg;
			
			// Cache frequently accessed properties
			var objCoords:Vec2			= obj.coordinates;
			var objBB:BoundingBox		= obj.boundingBox;
			var thisCoords:Vec2			= coordinates;
			var thisBB:BoundingBox		= boundingBox;
			
			// Calculate differences in X and Y coordinates
			var deltaX:Number = objCoords.X - thisCoords.X;
			var deltaY:Number;
			
			// ??
			if (obj === GameContainer.reference.gg) {
				deltaY = objCoords.Y - (objBB.height * 0.75) - thisCoords.Y + thisBB.halfHeight;
			}
			else {
				deltaY = objCoords.Y - objBB.halfHeight - thisCoords.Y + thisBB.halfHeight;
			}
			
			// Compute squared distance
			var distanceSquared:Number = (deltaX * deltaX) + (deltaY * deltaY);
			
			// Kept in rasst2 for the many readers between steps; -1 if the result is NaN
			rasst2 = isNaN(distanceSquared) ? -1 : distanceSquared;

			return rasst2;
		}
		
		public function save():Object {
			return null;
		}
		
		//Interpret a script command
		public function command(com:String, val:String = null):void {
			if (com == "show") {
				GameContainer.reference.cam.showOn	= true;
				GameContainer.reference.cam.showX	= coordinates.X;
				GameContainer.reference.cam.showY	= coordinates.Y;
			}
		}
		
		// If the object and the player are in the same location, and the object is radioactive, and the player is within the radioactive radius,
		// deal radiation damage to the player 
		public function ggModum():void {
			if (loc == GameContainer.reference.gg.loc && radioactiv && rasst2 >= 0 && rasst2 < radrad * radrad) {
				GameContainer.reference.gg.raddamage((radrad - Math.sqrt(rasst2)) / radrad, radioactiv, radtip);
			}
		}
		
		// Remove the object and return an error message
		public override function err():String {
			if (loc) {
				loc.remObj(this);
			}
			
			return "Error obj " + nazv;
		}
		
		// A “normalize” method that caps the length of vector p to mr. If p is longer than mr, it scales it down to exactly mr
		public function norma(p:Object, mr:Number):void {
			if (p.x * p.x + p.y * p.y > mr * mr) {
				var nr:Number = Math.sqrt(p.x * p.x + p.y * p.y);
				p.x *= mr / nr;
				p.y *= mr / nr;
			}
		}
		
		// Change the object’s position a given location and then re-center the bounding box.
		public function bindMove(v:Vec2, ox:Number = -1, oy:Number = -1):void {
			coordinates = v;
			boundingBox.center(v);
		}
		
		// [copying state to another object]
		public function copy(un:Obj):void {
			un.coordinates = coordinates;
			un.boundingBox.width = boundingBox.width;
			un.boundingBox.height = boundingBox.height;
			un.boundingBox.left = boundingBox.left;
			un.boundingBox.right = boundingBox.right;
			un.boundingBox.top = boundingBox.top;
			un.boundingBox.bottom = boundingBox.bottom;
			un.storona = storona;
		}
		
		// [Check if a bullet hit the object]
		public function udarBullet(bul:Bullet, sposob:int = 0):int {
			return Bullet.MISS;
		}
		
		// Triggers when the (player? object?) leaves a location. 
		public function locout():void {

		}
		
		public static function setArmor(m:MovieClip):void {
			var aid:String = "";
			
			if (World.w) {
				if (GUIManager.reference.pip && GUIManager.reference.pip.active || GameContainer.reference.mmArmor && GameContainer.reference.allStat == 0) {
					aid = GUIManager.reference.pip.armorID;
				}
				else if (GameContainer.reference.armorWork != "") {
					aid = GameContainer.reference.armorWork;
				}
				else if (GameContainer.reference.alicorn) {
					aid = "ali";
				}
				else {
					aid = Appear.ggArmorId;
				}
			}
			
			if (aid == "") {
				m.gotoAndStop(1);
				return;
			}
			
			try {
				m.gotoAndStop(aid);
			}
			catch (err:Error) {
				//trace("ERROR: (00:51) - Could not apply armor: \"" + aid + "\"!");
				m.gotoAndStop(1);
			}
		}
		
		// Set the head of the player to something
		public static function setMorda(m:MovieClip, c:int):void {
			if (World.w && GameContainer.reference.gg) {
				m.gotoAndStop(GameContainer.reference.gg.mordaN);
			}
			else {
				m.gotoAndStop(1);
			}
		}
		
		public static function setColor(m:MovieClip, c:int):void {
			if (Appear.transp) {
				m.visible = false;
				return;
			}
			
			switch(c) {
				case 0:
					m.transform.colorTransform = Appear.trFur;
					break;
				case 1:
					m.transform.colorTransform = Appear.trHair;
					break;
				case 2:
					if (Appear.visHair1) {
						m.visible = true;
						m.transform.colorTransform = Appear.trHair1;
					}
					else {
						m.visible = false;
					}
					break;
				case 3:
					m.transform.colorTransform = Appear.trEye;
					break;
				case 4:
					m.transform.colorTransform = Appear.trMagic;
					break;
				default:
					trace("Obj.as/setColor() - ERROR: unknown color id: " + c)
					break;
			}
		}
		
		public static function setVisible(m:MovieClip):void {
			var h:Boolean;
			
			if (World.w && GUIManager.reference.pip && GUIManager.reference.pip.active) {
				h = GUIManager.reference.pip.hideMane;
			}
			else {
				h = Appear.hideMane;
			}
			
			m.visible = !h;
		}
		
		public static function setEye(m:MovieClip):void {	// .SWF Depenency
			m.gotoAndStop(Appear.fEye);
		}

		public static function setHair(m:MovieClip):void {	// .SWF Dependency
			m.gotoAndStop(Appear.fHair);
		}
	}
}

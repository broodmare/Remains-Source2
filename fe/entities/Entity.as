package fe.entities {
	
	import flash.display.MovieClip;

	import fe.World;
	import fe.util.Vector2;
	import fe.loc.Location;
	
	public class Entity {

		// Precomputed values for speed
		protected static const ONE_SIXTH:Number					= 1 / 6;
		protected static const FIVE_SIXTH:Number				= 5 / 6;
		protected static const HALF_PI:Number					= ONE_PI / 2;
		protected static const QUARTER_PI:Number				= ONE_PI / 4;
		protected static const SIXTH_PI:Number					= ONE_PI / 6;
		protected static const RAD_TO_DEG:Number				= 180 / ONE_PI;
		protected static const DEG_TO_RAD:Number				= ONE_PI / 180;
		protected static const ONE_PI:Number					= Math.PI;
		protected static const TWO_PI:Number					= 2 * ONE_PI;
		protected static const NEGATIVE_SIXTH_PI:Number			= -SIXTH_PI;
		protected static const NEGATIVE_HALF_PI:Number			= -HALF_PI;
		protected static const NEGATIVE_FIVE_SIXTH_PI:Number	= -ONE_PI * FIVE_SIXTH;
		protected static const POSITIVE_FIVE_SIXTH_PI:Number	= ONE_PI * FIVE_SIXTH;

		// Visual and location
		public var vis:MovieClip;							// Movieclip that holds the entity's sprite
		public var loc:Location;							// What room the entity is currently in
		
		// Object processing
		public var nobj:Entity								// Next Obj in processing chain
		public var pobj:Entity;								// Previous Obj in processing chain
		public var in_chain:Boolean		= false;
		
		// Entity state
		public var stay:Boolean			= false;
		public var sloy:int				= 0;
		
		// Movement
		public var coordinates:Vector2	= new Vector2();	// The entity's [X, Y] coordinates stored as a vector
		public var velocity:Vector2 	= new Vector2();	// The entity's [X, Y] movement stored as a vector
		
		// Constructor
		public function Entity() {

		}

		public function addVisual():void {
			if (vis && loc && loc.active) {
				World.w.grafon.visObjs[sloy].addChild(vis);
			}
		}

		public function remVisual():void {
			if (vis && vis.parent) {
				vis.parent.removeChild(vis);
			}
		}

		public function setNull(f:Boolean=false):void {

		}
		
		public function err():String {
			if (loc) {
				loc.remObj(this);
			}
			
			return null;
		}
		
		public function step():void {

		}

		// Check if an object is empty, Eg. '{}'
		private static function isEmpty(obj:Object):Boolean {
			for (var key:String in obj) {
				return false; // Found a property, so it's not empty
			}
			return true; // No properties found, it's empty
		}
	}
}
package fe.game.domain.entities {
	
	import flash.display.MovieClip;

	import fe.game.GameContainer;
	import fe.engine.utils.Vec2;
	import fe.game.domain.location.Location;
	
	public class Entity {

		// Visual and location
		public var vis:MovieClip;							// Movieclip that holds the entity's sprite
		public var loc:Location;							// What room the entity is currently in
		
		// Object processing
		public var nobj:Entity								// Next Obj in processing chain
		public var pobj:Entity;								// Previous Obj in processing chain
		public var in_chain:Boolean		= false;
		
		// Entity state
		public var stay:Boolean			= false;
		public var layer:int			= 0;		// Which of Grafon's object layers (visObjs) it draws in, counted from the back
		
		// Movement
		public var coordinates:Vec2		= new Vec2();	// The entity's [X, Y] coordinates stored as a vector
		public var velocity:Vec2 		= new Vec2();	// The entity's [X, Y] movement stored as a vector
		
		public function Entity() {}

		public function addVisual():void {
			if (vis && loc && loc.active) {
				GameContainer.reference.grafon.visObjs[layer].addChild(vis);
			}
		}

		public function remVisual():void {
			if (vis && vis.parent) {
				vis.parent.removeChild(vis);
			}
		}

		public function setNull(f:Boolean=false):void {}
		
		public function err():String {
			if (loc) {
				loc.remObj(this);
			}
			
			return null;
		}
		
		public function step():void {}

		// Check if an object is empty, Eg. '{}'
		private static function isEmpty(obj:Object):Boolean {
			for (var key:String in obj) {
				return false; // Found a property, so it's not empty
			}
			return true; // No properties found, it's empty
		}
	}
}
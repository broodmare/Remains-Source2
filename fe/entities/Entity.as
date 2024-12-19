package fe.entities
{
	//Базовый класс для всех объектов
	import flash.display.MovieClip;

	import fe.World;
	import fe.util.Vector2;
	import fe.loc.Location;
	
	public class Entity
	{
		public var vis:MovieClip; // Movieclip that holds the entity's sprite

		public var loc:Location;	// What room the entity is currently in
		public var nobj:Entity
		public var pobj:Entity;		// Next Obj in processing chain, Previous Obj in processing chain
		public var in_chain:Boolean=false;
		
		public var stay:Boolean=false;

		public var sloy:int=0;
		
		public var coordinates:Vector2 = new Vector2();	// The entity's [X, Y] coordinates stored as a vector
		public var velocity:Vector2 = new Vector2();	// The entity's [X, Y] movement stored as a vector
		
		public function Entity() {
		}

		public function addVisual() {
			if (vis && loc && loc.active) World.w.grafon.visObjs[sloy].addChild(vis);
		}

		public function remVisual() {
			if (vis && vis.parent) vis.parent.removeChild(vis);
		}

		public function setNull(f:Boolean=false) {
		}
		
		public function err():String {
			if (loc) loc.remObj(this);
			return null;
		}
		
		public function step()
		{

		}

	}
}
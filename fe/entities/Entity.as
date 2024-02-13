package fe.entities
{
	import flash.display.MovieClip;

	import fe.World;
	import fe.util.Vector2;
	import fe.loc.Location;
	
	public class Entity // Base class for all objects
	{
		public var vis:MovieClip; // Movieclip that holds the entity's sprite

		public var loc:Location;	// What room the entity is currently in

		// Processing chain (Doubly linked list, allows for bi-directional travel along the chain and dynamic sizing or insertion/deletion)
		public var nobj:Entity		// Next Obj in processing chain
		public var pobj:Entity;		// Previous Obj in processing chain
		public var in_chain:Boolean = false;
		
		public var stay:Boolean = false;

		public var sloy:int=0;
		
		public var coordinates:Vector2 = new Vector2();
		//public var moveVector:Vector2 = new Vector2();

		public var dx:Number = 0;
		public var dy:Number = 0;
		
		public function Entity()
		{

		}

		public function addVisual()
		{
			if (vis && loc && loc.active) World.w.grafon.visObjs[sloy].addChild(vis);
		}

		public function remVisual()
		{
			if (vis && vis.parent) vis.parent.removeChild(vis);
		}

		public function setNull(f:Boolean=false)
		{

		}
		
		public function err():String
		{
			if (loc) loc.remObj(this);
			return null;
		}
		
		public function step()
		{

		}

	}
}
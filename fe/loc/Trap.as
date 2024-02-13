package fe.loc
{
	import flash.display.MovieClip;
	
	import fe.*;
	import fe.entities.Obj;
	import fe.unit.Unit;
	import fe.loc.Tile;

	import fe.stubs.vistrapspikes
	
	public class Trap extends Obj
	{
		public var id:String;
		public var vis2:MovieClip;

		public var dam:Number=0;
		public var tipDamage:int=0;
		
		public var spDam:int = 1;		//способ нанесения урона
		public var spBind:int = 1;	//способ прикрепления
		public var floor:Boolean = false;
		
		var anim:Boolean = false;
		
		private static var tileX:int = Tile.tileX;
		private static var tileY:int = Tile.tileY;

		public function Trap(loc:Location, id:String, X:int = 0, Y:int = 0)
		{
			this.loc = loc;
			this.id = id;
			this.coordinates.X = X;
			this.coordinates.Y = Y;
			sloy = 0;
			prior = 1;

			var vClass:Class  = Res.getClass('vistrap' + id, null, vistrapspikes);
			var vClass2:Class = Res.getClass('vistrap' + id + '2', null, null);
			vis  = new vClass();
			vis2 = new vClass2();
			var n1 = int(Math.random() * vis.totalFrames) + 1;
			var n2 = int(Math.random() * vis.totalFrames) + 1;
			levitPoss = false;
			vis.gotoAndStop(n1);
			vis2.gotoAndStop(n2);
			getXmlParam()
			if (!anim) vis.cacheAsBitmap = true;
			if (vis2 && !anim) vis2.cacheAsBitmap = true;
			leftBound = coordinates.X - objectWidth / 2;
			rightBound = coordinates.X + objectWidth / 2;
			
			if (floor)
			{
				topBound = coordinates.Y - objectHeight; 
				bottomBound = coordinates.Y;
			}
			else
			{
				topBound = coordinates.Y - tileY;
				bottomBound = topBound + objectHeight;
			}

			vis.x  = coordinates.X;
			vis.y  = coordinates.Y;
			vis2.x = coordinates.X;
			vis2.y = coordinates.Y;

			cTransform = loc.cTransform;
			bindTile();
		}
		
		public function getXmlParam()
		{
			var node:XML = XMLDataGrabber.getNodeWithAttributeThatMatches("core", "AllData", "objs", "id", id);
			nazv=Res.txt('u',id);

			if (node.@sX>0) objectWidth = node.@sX;
			else objectWidth = node.@size * tileX;
			
			if (node.@sY>0) objectHeight=node.@sY;
			else objectHeight = node.@wid * tileY;
			
			dam=node.@damage;
			if (node.@tipdam.length()) tipDamage=node.@tipdam;
			if (node.@anim.length()) anim=true;
			if (node.@floor.length()) floor=true;
			if (node.@att.length()) spDam=node.@att;
			if (node.@bind.length()) spBind=node.@bind;
		}
		
		public override function addVisual()
		{
			if (vis)
			{
				World.w.grafon.visObjs[sloy].addChild(vis);
				if (cTransform) vis.transform.colorTransform = cTransform;
			}
			if (vis2)
			{
				World.w.grafon.visObjs[3].addChild(vis2);
				if (cTransform) vis2.transform.colorTransform=cTransform;
			}
		}
		public override function remVisual()
		{
			super.remVisual();
			if (vis2 && vis2.parent) vis2.parent.removeChild(vis2);
		}
		
		public override function step():void
		{
			if(!loc.active) return;
			for each (var un:Unit in loc.units)
			{
				if (!un.activateTrap || un.sost == 4) continue;
				attKorp(un);
			}
		}
		
		private function bindTile():void
		{
			//прикрепление к полу
			if (spBind == 1) loc.getAbsTile(coordinates.X, coordinates.Y + 10).trap = this;	
			//прикрепление к потолку
			if (spBind == 2) loc.getAbsTile(coordinates.X, coordinates.Y - 50).trap = this;
		}
		
		public override function die(sposob:int = 0)
		{
			loc.remObj(this);
		}
		
		public function attKorp(cel:Unit):Boolean
		{
			if (cel==null || cel.neujaz) return false;
			if (spDam == 1 && !cel.isFly && cel.dy > 8 && cel.coordinates.X <= rightBound && cel.coordinates.X >= leftBound && cel.coordinates.Y <= bottomBound && cel.coordinates.Y >= topBound) //шипы
			{		
				cel.damage(cel.massa*cel.dy/20*dam*(1+loc.locDifLevel*0.1), tipDamage);
				cel.neujaz=cel.neujazMax;
			}
			if (spDam==2 && !cel.isFly && (cel.dy + cel.osndy < 0) && cel.coordinates.X <= rightBound && cel.coordinates.X >= leftBound && cel.topBound <= bottomBound && cel.topBound >= topBound) //шипы
			{
				cel.damage(cel.massa * dam * (1 + loc.locDifLevel * 0.1), tipDamage);
				cel.neujaz = cel.neujazMax;
			}
			return true;
		}
	}
}
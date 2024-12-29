package fe.loc {

	import flash.display.MovieClip;
	
	import fe.*;
	import fe.entities.BoundingBox;
	import fe.entities.Obj;
	import fe.unit.Unit;
	import fe.loc.Tile;

	import fe.stubs.vistrapspikes
	
	public class Trap extends Obj {

		public var id:String;
		public var vis2:MovieClip;

		public var dam:Number=0;
		public var tipDamage:int=0;
		
		public var spDam:int = 1;	// [Method of dealing damage]
		public var spBind:int = 1;	// [Attachment method]
		public var floor:Boolean = false;
		
		private var anim:Boolean = false;
		
		private static var tileX:int = Tile.tileX;
		private static var tileY:int = Tile.tileY;

		public function Trap(loc:Location, id:String, X:int = 0, Y:int = 0) {

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
			var n1:int = int(Math.random() * vis.totalFrames) + 1;
			var n2:int = int(Math.random() * vis.totalFrames) + 1;
			levitPoss = false;
			vis.gotoAndStop(n1);
			vis2.gotoAndStop(n2);
			getXmlParam()
			if (!anim) vis.cacheAsBitmap = true;
			if (vis2 && !anim) vis2.cacheAsBitmap = true;
			this.boundingBox.left = coordinates.X - this.boundingBox.halfWidth;
			this.boundingBox.right = coordinates.X + this.boundingBox.halfWidth;
			
			if (floor) {
				this.boundingBox.top = coordinates.Y - this.boundingBox.height; 
				this.boundingBox.bottom = coordinates.Y;
			}
			else {
				this.boundingBox.top = coordinates.Y - tileY;
				this.boundingBox.bottom = this.boundingBox.top + this.boundingBox.height;
			}

			vis.x  = coordinates.X;
			vis.y  = coordinates.Y;
			vis2.x = coordinates.X;
			vis2.y = coordinates.Y;

			cTransform = loc.cTransform;
			bindTile();
		}
		
		public function getXmlParam():void {
			var node:XML = XMLDataGrabber.getNodeWithAttributeThatMatches("core", "AllData", "objs", "id", id);
			nazv=Res.txt('u', id);

			if (node.@sX > 0) this.boundingBox.width = node.@sX;
			else this.boundingBox.width = node.@size * tileX;
			
			if (node.@sY > 0) this.boundingBox.height = node.@sY;
			else this.boundingBox.height = node.@wid * tileY;
			
			dam=node.@damage;
			if (node.@tipdam.length()) tipDamage=node.@tipdam;
			if (node.@anim.length()) anim=true;
			if (node.@floor.length()) floor=true;
			if (node.@att.length()) spDam=node.@att;
			if (node.@bind.length()) spBind=node.@bind;
		}
		
		public override function addVisual():void {
			if (vis) {
				World.w.grafon.visObjs[sloy].addChild(vis);
				if (cTransform) vis.transform.colorTransform = cTransform;
			}
			if (vis2) {
				World.w.grafon.visObjs[3].addChild(vis2);
				if (cTransform) vis2.transform.colorTransform = cTransform;
			}
		}
		public override function remVisual():void {
			super.remVisual();
			if (vis2 && vis2.parent) vis2.parent.removeChild(vis2);
		}
		
		public override function step():void {
			if(!loc.active) return;
			for each (var un:Unit in loc.units) {
				if (!un.activateTrap || un.sost == 4) continue;
				attKorp(un);
			}
		}
		
		private function bindTile():void {
			// [Attachment to the floor]
			if (spBind == 1) {
				loc.getAbsTile(coordinates.X, coordinates.Y + 10).trap = this;
			}
			// [Attachment to the ceiling]
			if (spBind == 2) {
				loc.getAbsTile(coordinates.X, coordinates.Y - 50).trap = this;
			}
		}
		
		public override function die(sposob:int = 0):void {
			loc.remObj(this);
		}
		
		public function attKorp(cel:Unit):Boolean {
			if (cel==null || cel.neujaz) return false;
			if (spDam == 1 && !cel.isFly && cel.velocity.Y > 8 && cel.coordinates.X <= this.boundingBox.right && cel.coordinates.X >= this.boundingBox.left && cel.coordinates.Y <= this.boundingBox.bottom && cel.coordinates.Y >= this.boundingBox.top) { //шипы 
				cel.damage(cel.massa*cel.velocity.Y/20*dam*(1+loc.locDifLevel*0.1), tipDamage);
				cel.neujaz=cel.neujazMax;
			}
			if (spDam==2 && !cel.isFly && (cel.velocity.Y + cel.osndy < 0) && cel.coordinates.X <= this.boundingBox.right && cel.coordinates.X >= this.boundingBox.left && cel.boundingBox.top <= this.boundingBox.bottom && cel.boundingBox.top >= this.boundingBox.top) { //шипы
				cel.damage(cel.massa * dam * (1 + loc.locDifLevel * 0.1), tipDamage);
				cel.neujaz = cel.neujazMax;
			}
			return true;
		}
	}
}
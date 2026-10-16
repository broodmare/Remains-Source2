package fe.game.domain.objects {

	import flash.display.MovieClip;
	import flash.geom.ColorTransform;

	import fe.engine.text.TextParser;
	import fe.engine.text.XMLDataGrabber;
	import fe.game.GameContainer;
	import fe.game.domain.entities.Obj;
	import fe.game.domain.units.Unit;
	import fe.game.domain.units.Resistances;
	import fe.game.domain.location.tile.Tile;
	import fe.game.domain.units.enums.E_Resistances;
	import fe.game.rendering.Flipbook;
	import fe.game.domain.location.Location;

	public class Trap extends Obj {

		public var id:String;
		public var art:Flipbook;		// The trap, in object layer 0
		public var vis2:MovieClip;		// What shows in front of units, in Flash's object layer 3

		public var dam:Number=0;
		public var tipDamage:String = E_Resistances.DAM_PIERCE;
		
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
			layer = 0;
			prior = 1;

			var vClass2:Class = TextParser.getClass('vistrap' + id + '2', null, null);
			art  = new Flipbook(GameContainer.reference.grafon.flipbooks.viewDefinition(id));
			vis2 = new vClass2();
			var n1:int = int(Math.random() * art.frameCount);
			var n2:int = int(Math.random() * art.frameCount) + 1;
			levitPoss = false;
			art.goTo(n1, false);
			vis2.gotoAndStop(n2);
			getXmlParam()
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

			art.x  = coordinates.X;
			art.y  = coordinates.Y;
			vis2.x = coordinates.X;
			vis2.y = coordinates.Y;

			cTransform = loc.cTransform;
			bindTile();
		}
		
		public function getXmlParam():void {
			var node:XML = XMLDataGrabber.getNodeWithAttributeThatMatches("core", "AllData", "objs", "id", id);
			nazv=TextParser.txt('u', id);

			if (node.@sX > 0) this.boundingBox.width = node.@sX;
			else this.boundingBox.width = node.@size * tileX;
			
			if (node.@sY > 0) this.boundingBox.height = node.@sY;
			else this.boundingBox.height = node.@wid * tileY;
			
			dam=node.@damage;
			if (node.@tipdam.length()) tipDamage=Resistances.parseDamageType(node.@tipdam, E_Resistances.DAM_PIERCE);
			if (node.@anim.length()) anim=true;
			if (node.@floor.length()) floor=true;
			if (node.@att.length()) spDam=node.@att;
			if (node.@bind.length()) spBind=node.@bind;
		}
		
		public override function addVisual():void {
			GameContainer.reference.grafon.objectLayers.add(art, layer);
			if (cTransform) {
				art.setTint(cTransform);
			}
			if (vis2) {
				GameContainer.reference.grafon.visObjs[3].addChild(vis2);
				if (cTransform) vis2.transform.colorTransform = cTransform;
			}
		}
		public override function remVisual():void {
			super.remVisual();
			art.removeFromParent();
			if (vis2 && vis2.parent) vis2.parent.removeChild(vis2);
		}

		public override function setTint(tint:ColorTransform):void {
			art.setTint(tint);
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
			if (spDam == 1 && !cel.isFly && cel.velocity.Y > 8 && this.boundingBox.intersectsCoordinate(cel.coordinates)) { //шипы
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
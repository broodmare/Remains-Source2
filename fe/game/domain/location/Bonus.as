package fe.game.domain.location {

	import flash.display.MovieClip;

	import fe.engine.utils.SymbolFactory;
	import fe.engine.audio.Sound;
	import fe.game.ui.GUIManager;
	import fe.game.GameContainer;
	import fe.game.domain.entities.Obj;
	
	//Бонусы, которые подбираются путём контакта с ними
	public class Bonus extends Obj {

		public var sost:int			= 1; 	//состояние 0-неактивен, 1-активен, 2-взят
		public var id:String		= "";
		public var val:Number		= 100.00;
		public var liv:int			= 1000000;

		public function Bonus(nloc:Location, nid:String, nx:int=0, ny:int=0, xml:XML=null, loadObj:Object=null) {
			loc = nloc;
			id = nid;
			coordinates.X = nx;
			coordinates.Y = ny;
			setSize();
			if (loadObj) sost = loadObj.sost;
			levitPoss = false;
			sloy = 3;
			if (sost == 1) {
				if (id == 'heal') {
					vis = SymbolFactory.createInstance("visualHealBonus") as MovieClip;
				}
				else {
					vis = SymbolFactory.createInstance("visualBonus") as MovieClip;
				}
			}
			if (vis) {
				vis.bonus.cacheAsBitmap = true;
				vis.x = coordinates.X;
				vis.y = coordinates.Y;
			}
		}
		
		private function setSize():void {
			boundingBox.width = 40;
			boundingBox.height = 40;

			// Bonuses are centered on their map cell, unlike bottom-anchored units and boxes.
			boundingBox.setBounds(
				coordinates.X - boundingBox.halfWidth,
				coordinates.X + boundingBox.halfWidth,
				coordinates.Y - boundingBox.halfHeight,
				coordinates.Y + boundingBox.halfHeight
			);
		}
		
		public override function save():Object {
			var obj:Object = new Object();
			obj.sost = sost;
			return obj;
		}
		
		public override function step():void {
			if (liv < 1000000) {
				liv--;
				if (!loc.active || liv==0) {
					liv=0;
					sost=2;
					vis.gotoAndPlay(22);
				}
			}
			
			if (liv<-25) {
				loc.remObj(this);
			}
			
			if (sost!=1 || !loc.active) {
				return;
			}
			
			if (boundingBox.intersects(loc.gg.boundingBox)) {
				take();
			}
		}
		
		public function take():void {
			sost = 2;
			liv = 0;
			vis.gotoAndPlay(2);
			
			if (id == 'xp') {
				loc.kolXp--;
				
				if (loc.kolXp == 0 && loc.maxXp > 1) { //собрали все бонусы 
					GameContainer.reference.pers.expa(loc.unXp * loc.maxXp);
				
					if (!loc.detecting && loc.summXp > 0) {
						loc.takeXP(loc.summXp, GameContainer.reference.gg.coordinates.X, GameContainer.reference.gg.coordinates.Y - 100, true);
						GUIManager.reference.gui.infoText('sneakBonus');
					}
					Sound.ps('bonus2');
				}
				else {
					GameContainer.reference.pers.expa(loc.unXp);
					Sound.ps('bonus1');
				}
				
			}
			if (id == 'heal') {
				GameContainer.reference.gg.heal(val);
				Sound.ps('bonus1');
			}
		}
	}
}

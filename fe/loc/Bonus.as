package fe.loc {
	import fe.*;
	import fe.serv.Script;
	import fe.graph.Emitter;
	import fe.unit.Unit;
	
	//Бонусы, которые подбираются путём контакта с ними
	
	public class Bonus extends Obj{
		
		public var sost:int=1; 	//состояние 0-неактивен, 1-активен, 2-взят
		public var id:String='';
		public var val:Number=100;
		public var liv:int=1000000;

		public function Bonus(nloc:Location, nid:String, nx:int=0, ny:int=0, xml:XML=null, loadObj:Object=null) {
			loc=nloc;
			id=nid;
			X=nx;
			Y=ny;
			setSize();
			if (loadObj) {
				sost=loadObj.sost;
			}
			levitPoss=false;
			sloy=3;
			if (sost==1) {
				if (id=='heal') vis=new visualHealBonus();
				else vis=new visualBonus();
			}
			if (vis) {
				vis.bonus.cacheAsBitmap=true;
				vis.x=X, vis.y=Y;
			}
		}
		
		function setSize() {
			scX=scY=40;
			X1=X-scX/2;
			X2=X+scX/2;
			Y1=Y-scY/2;
			Y2=Y+scY/2;
		}
		
		public override function save():Object {
			var obj:Object=new Object();
			obj.sost=sost;
			return obj;
		}
		
		public override function step() {
			if (liv<1000000) {
				liv--;
				if (!loc.active || liv==0) {
					liv=0;
					sost=2;
					vis.gotoAndPlay(22);
				}
			}
			if (liv<-25) loc.remObj(this);
			if (sost!=1 || !loc.active) return;
			if (areaTest(loc.gg)) take();
		}
		
		public function take() {
			sost=2;
			liv=0;
			vis.gotoAndPlay(2);
			if (id=='xp') {
				loc.kolXp--;
				if (loc.kolXp==0 && loc.maxXp>1) {	//собрали все бонусы
					World.w.pers.expa(loc.unXp*loc.maxXp);
					if (!loc.detecting && loc.summXp>0) {
						loc.takeXP(loc.summXp,World.w.gg.X, World.w.gg.Y-100,true);
						World.w.gui.infoText('sneakBonus');
					}
					Snd.ps('bonus2');
				} else {
					World.w.pers.expa(loc.unXp);
					Snd.ps('bonus1');
				}
				
			}
			if (id=='heal') {
				World.w.gg.heal(val);
				Snd.ps('bonus1');
			}
		}
		
	}
	
}

package fe.weapon  {
	import flash.display.MovieClip;
	
	import fe.unit.Unit;
	import fe.unit.UnitPlayer;
	import fe.unit.Pers;
	import fe.loc.Tile;
	import fe.*;
	
	public class WPaint extends Weapon {
		
		var del:Object={x:0, y:0};
		var celX:Number, celY:Number;
		var pX:Number=-1, pY:Number=-1;
		
		public var color:int=1;
		public var paintId:String='p_black';
		public var paintNazv:String='';

		public function WPaint(own:Unit, id:String, nvar:int=0) {
			super(own, id,nvar);
			vWeapon=visualpaint;
			vis=new vWeapon();
		}
		
	
		public function lineCel():int {
			var res=0;
			var bx:Number=owner.X;
			var by:Number=owner.Y-owner.scY*0.75;
			var ndx:Number=(celX-bx);
			var ndy:Number=(celY-by);
			var div=Math.floor(Math.max(Math.abs(ndx),Math.abs(ndy))/World.maxdelta)+1;
			for (var i=1; i<div; i++) {
				celX=bx+ndx*i/div;
				celY=by+ndy*i/div;
				var t:Tile=World.w.loc.getAbsTile(Math.floor(celX),Math.floor(celY));
				if (t.phis==1 && celX>=t.phX1 && celX<=t.phX2 && celY>=t.phY1 && celY<=t.phY2) {
					return 0
				}
			}
			return 1;
		}
		
		public override function actions() {
			var ds=40*owner.storona;
			if (owner.player) {
				celX=owner.celX;
				celY=owner.celY;
				//lineCel();
				storona=owner.storona;
				del.x=(celX-(owner.X+ds));
				del.y=(celY-owner.weaponY);
				norma(del,600);
				ds=(owner as UnitPlayer).pers.meleeS*owner.storona;
				
				var tx=celX-X;
				var ty=celY-Y;
				ready=((tx*tx+ty*ty)<100);
				del.x=((owner.X+ds+del.x)-X)/2;
				del.y=((owner.weaponY+del.y)-Y)/2;
				if (owner.player) {
					norma(del,20);
				}
				pX=X, pY=Y;
				X+=del.x;//(tx)/Math.max(3,massa*50);
				Y+=del.y;//(ty)/Math.max(3,massa*50);
			}
		}
		
		public override function attack(waitReady:Boolean=false):Boolean {
			World.w.grafon.paint(pX,pY,X,Y,World.w.ctr.keyRun);
			return true;
		}

		public function setPaint(npaint:String, ncolor:uint, nblend:String) {
			paintId=npaint;
			paintNazv=Res.txt('i',paintId);
			World.w.grafon.brTrans.color=ncolor
			/*try {
				World.w.grafon.pa.gotoAndStop(paintId);
				World.w.grafon.pb.gotoAndStop(paintId);
			} catch (err) {}*/
		}
		
		public override function animate() {
			if (vis) {
				vis.y=Y;
				vis.x=X;
				vis.scaleX=storona;
			}
		}
	}
	
}

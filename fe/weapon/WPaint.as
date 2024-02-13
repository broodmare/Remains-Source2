package fe.weapon 
{
	import fe.*;
	import fe.unit.Unit;
	import fe.unit.unitTypes.UnitPlayer;
	import fe.loc.Tile;
	
	public class WPaint extends Weapon
	{
		var del:Object={x:0, y:0};
		var celX:Number, celY:Number;
		var pX:Number=-1, pY:Number=-1;
		
		public var color:int=1;
		public var paintId:String='p_black';
		public var paintNazv:String='';

		public function WPaint(own:Unit, id:String, nvar:int=0)
		{
			super(own, id,nvar);
			vWeapon=visualpaint;
			vis=new vWeapon();
		}
		
		public function lineCel():int
		{
			var res=0;
			var bx:Number=owner.coordinates.X;
			var by:Number=owner.coordinates.Y - owner.objectHeight * 0.75;
			var ndx:Number = (celX - bx);
			var ndy:Number = (celY - by);
			var div=int(Math.max(Math.abs(ndx),Math.abs(ndy))/World.maxdelta)+1;
			for (var i=1; i<div; i++) {
				celX=bx+ndx*i/div;
				celY=by+ndy*i/div;
				var t:Tile=World.w.loc.getAbsTile(int(celX), int(celY));
				if (t.phis==1 && celX>=t.phX1 && celX<=t.phX2 && celY>=t.phY1 && celY<=t.phY2) {
					return 0
				}
			}
			return 1;
		}
		
		public override function actions():void
		{
			var ds=40*owner.storona;
			if (owner.player) {
				celX=owner.celX;
				celY=owner.celY;
				storona=owner.storona;
				del.x=(celX-(owner.coordinates.X+ds));
				del.y=(celY-owner.weaponY);
				norma(del,600);
				ds=(owner as UnitPlayer).pers.meleeS*owner.storona;
				
				var tx=celX - coordinates.X;
				var ty=celY - coordinates.Y;
				ready=((tx*tx+ty*ty)<100);
				del.x=((owner.coordinates.X + ds + del.x) - coordinates.X) / 2;
				del.y=((owner.weaponY + del.y) - coordinates.Y) / 2;
				if (owner.player) {
					norma(del,20);
				}
				pX = coordinates.X;
				pY = coordinates.Y;
				coordinates.X += del.x;
				coordinates.Y += del.y;
			}
		}
		
		public override function attack(waitReady:Boolean=false):Boolean
		{
			World.w.grafon.paint(pX, pY, coordinates.X, coordinates.Y,World.w.ctr.keyRun);
			return true;
		}

		public function setPaint(npaint:String, ncolor:uint, nblend:String)
		{
			paintId=npaint;
			paintNazv=Res.txt('i',paintId);
			World.w.grafon.brTrans.color=ncolor
		}
		
		public override function animate():void
		{
			if (vis) {
				vis.y = coordinates.Y;
				vis.x = coordinates.X;
				vis.scaleX=storona;
			}
		}
	}	
}
package fe.unit
{
	import fe.*;
	import fe.loc.Location;
	
	public class UnitScythe extends Unit
	{
		var napr:Number=-1;
		var dr:Number=0;
		var t:int=0;
		var skor=1.5;
		
		var cel:Unit;
		
		var owner:Unit;
		var por:int=0;
		
		public var bindN:int=0;
		var bindRad:int=200;
		var bindKoef=0.05;
		
		public function UnitScythe (cid:String=null, ndif:Number=100, xml:XML=null, loadObj:Object=null)
		{
			super(cid, ndif, xml, loadObj);
			id='scythe';
			vis=new visualScythe();
			vis.gotoAndPlay(Math.floor(Math.random()*vis.totalFrames+1));
			vis.osn.alpha=0;
			vis.vzz.alpha=0;
			mater=false;
			getXmlParam();
			levitPoss=false;
			brake=accel/2;
			doop=true;		//не отслеживает цели
			collisionTip=0;
		}

		var aiN:int=Math.floor(Math.random()*5);
		
		public override function setNull(f:Boolean=false)
		{
			super.setNull(f);
			getNapr();
		}
		
		public override function forces()
		{

		}
		
		public override function putLoc(nloc:Location, nx:Number, ny:Number)
		{
			super.putLoc(nloc, nx, ny);
			cel = World.w.gg;
			getNapr();
		}
		
		public override function animate() {
			if (dr<30) dr+=0.5;
			vis.osn.rotation+=dr;
			vis.vzz.rotation=vis.osn.rotation;
			if (vis.osn.alpha<1) vis.osn.alpha+=0.05;
			if (vis.vzz.alpha<1) vis.vzz.alpha+=0.02;
		}
		
		public function getNapr()
		{
			if (cel==null) return;
			var napr2 = Math.atan2(cel.coordinates.X - coordinates.X, cel.coordinates.Y - coordinates.Y);
			if (napr==-1) napr=napr2;
		}
		
		public override function run(div:int=1)
		{
			if (bind) {
				coordinates.X = bind.coordinates.X - Math.sin(t*bindKoef+Math.PI*2*bindN/6)*bindRad;
				coordinates.Y = bind.coordinates.Y - bind.objectHeight / 2 - Math.cos(t*bindKoef+Math.PI*2*bindN/6)*bindRad;
			} else {
				coordinates.X += dx/div;
				coordinates.Y += dy/div;
				if (coordinates.X >= loc.maxX || coordinates.X <= 0 || coordinates.Y >= loc.maxY || coordinates.Y <= 0) die();
			}
			leftBound = coordinates.X - objectWidth / 2;
			rightBound = coordinates.X + objectWidth / 2;
			topBound = coordinates.Y - objectHeight;
			bottomBound = coordinates.Y;
		}
		
		override protected function control():void
		{
			if (sost>=3) return;
			t++;
			if (bind==null) {
				skor*=1.05;
				dx=Math.sin(napr)*skor;
				dy=Math.cos(napr)*skor;
			}
			if (bind && (bind as Unit).sost>=3) die();
			if (t>60) attKorp(cel);
		}
	}
}
package fe.serv {

	import flash.display.MovieClip;
	import flash.filters.GlowFilter;
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;

	import fe.*;
	import fe.util.Vector2;
	import fe.entities.Obj;
	import fe.graph.Emitter;
	
	// Constructor
	public class Desintegr { // Handles disintegration effect for units
	
		public var owner:Obj;
		
		private var burnBmp:BitmapData;
		private var burnBm:Bitmap;
		private var burnN:int=0;
		private var burnTip:int=0;
		private var burnPart:String;
		private var burnGlowColor:uint;
		private var burnCt:ColorTransform;
		private var burnRnd:int=Math.random() * int.MAX_VALUE;
		private var burnKolPix:int;
		private var burnTime1:int=10;
		private var burnTime2:int=30;
		
		public var vse:Boolean=false;

		public function Desintegr(own:Obj, sposob:int) {
			owner=own;
			burnTip=sposob;
			burnBmp=new BitmapData(owner.vis.width,owner.vis.height,true,0);
			var m:Matrix=new Matrix();
			var rect:Rectangle=owner.vis.getBounds(owner.vis);
			m.tx=-rect.left;
			m.ty=-rect.top;
			burnBmp.draw(owner.vis,m);
			
			owner.vis=new MovieClip();
			burnBm=new Bitmap(burnBmp);
			owner.vis.addChild(burnBm);
			burnBm.x=rect.left;
			burnBm.y=rect.top;
			if (burnTip==1) {
				burnCt=new ColorTransform(1,1,1,1,255/burnTime1,100/burnTime1,0,0);
				burnPart='burn';
				burnGlowColor=0xFFAA00;
				Snd.ps('desintegr_f', owner.coordinates.X, owner.coordinates.Y);
			}
			else if (burnTip==2) {
				burnCt=new ColorTransform(1,1,1,1,0,255/burnTime1,100/burnTime1,0);
				burnPart='plakap';
				burnGlowColor=0x00FF00;
				Snd.ps('liquid_f', owner.coordinates.X, owner.coordinates.Y);
			}
			else if (burnTip==3) {
				burnCt=new ColorTransform(1,1,1,1,155/burnTime1,155/burnTime1,255/burnTime1,0);
				burnPart='burn';
				burnGlowColor=0x4444FF;
				Snd.ps('desintegr_f', owner.coordinates.X, owner.coordinates.Y);
			}
			else if (burnTip==4) {
				burnCt=new ColorTransform(1,1,1,1,100/burnTime1,100/burnTime1,255/burnTime1,0);
				burnPart='krupa';
				burnGlowColor=0x0000FF;
				Snd.ps('freezing_f', owner.coordinates.X, owner.coordinates.Y);
			}
			else if (burnTip==5) {
				burnCt=new ColorTransform(1,0.85,0.85,1,0,0,0,0);
				burnPart='blood';
				burnGlowColor=0xFF0000;
			}
			else if (burnTip==6) {
				burnCt=new ColorTransform(0.9,1,0.85,1,0,0,0,0);
				burnPart='gblood';
				burnGlowColor=0x66CC33;
			}
			else if (burnTip==7) {
				burnCt=new ColorTransform(1,0.85,0.88,1,0,0,0,0);
				burnPart='pblood';
				burnGlowColor=0xFF66FF;
			}
			burnKolPix = burnBmp.height * burnBmp.width;
			burnN = 1;
		}
		
		public function step():void {
			if (burnN>0 && burnN<=burnTime1) {
				burnBmp.colorTransform(burnBmp.rect,burnCt);
				burnBm.filters=[new GlowFilter(burnGlowColor,burnN/burnTime1,3,3,2,3)];
			}
			else if (burnN>burnTime1 && burnN<=burnTime2+burnTime1)  {
	   			burnBmp.pixelDissolve(burnBmp, burnBmp.rect, new Point(0,0), burnRnd, burnKolPix*(burnN-burnTime1)/burnTime2, 0x00FF0000);
				if (owner.massa>=0.25 || Math.random()<owner.massa*4) Emitter.emit(burnPart, owner.loc, owner.coordinates.X, owner.coordinates.Y - owner.boundingBox.halfHeight, {rx:owner.boundingBox.width*0.75, ry:owner.boundingBox.height*0.5});
			}
			else if (burnN>=burnTime2+burnTime1) {
				vse=true;
			}
			burnN++;
		}
	}	
}
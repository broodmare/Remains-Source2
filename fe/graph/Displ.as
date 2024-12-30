package fe.graph {

	import flash.display.MovieClip;
    import flash.display.BitmapData;
    import flash.display.BitmapDataChannel;
    import flash.filters.DisplacementMapFilter;
    import flash.filters.DisplacementMapFilterMode;
    import flash.geom.Matrix;
    import flash.geom.Point;
	
	import fe.stubs.displVolna;		// .fla linkage
	import fe.stubs.visWav;			// .fla linkage
	import fe.stubs.visSerost;		// .fla linkage
	
	import fe.util.Calc;

	//класс отвечает за анимацию главного меню	
	public class Displ {
		
		private var mm:MovieClip;
		private var gr:MovieClip;
		
		private var displFilter1:DisplacementMapFilter;
		private var displFilter2:DisplacementMapFilter;
		private var displBmpd:BitmapData;
		private var displStamp:MovieClip;
		private var displPoint:Point=new Point(0,0);
		private var displMatrix:Matrix=new Matrix();
		private var displX:Number=10;
		private var displY:Number=15;
		private var disp_t:int=0;
		
		private var wavKol:int=10;
		private var wavArr:Array=[];
		private var disX = 200;
		private var disY = 250;
		private var spd:Number=1;
		
		private var t_anim:int=0;
		private var t_klip:int=60;
		private var t_groza:int=120;
		private var p_x:Number;
		private var p_y:Number;
		
		public function Displ(nmm:MovieClip, ngr:MovieClip=null) {
			mm=nmm;
			gr=ngr;
			displBmpd=new BitmapData(240,300,false,0x7F7F7F);
			displStamp=new displVolna();
			displMatrix.tx=mm.target.x-mm.displ1.x;
			displMatrix.ty=mm.target.y-mm.displ1.y;
			displFilter1=new DisplacementMapFilter(displBmpd,displPoint,BitmapDataChannel.RED,BitmapDataChannel.RED,displX,displY,DisplacementMapFilterMode.COLOR);
			displFilter2=new DisplacementMapFilter(displBmpd,displPoint,BitmapDataChannel.RED,BitmapDataChannel.RED,0,5,DisplacementMapFilterMode.COLOR);
			for (var i:int = 0; i < wavKol; i++) {
				var v:MovieClip=new visWav();
				v.x = Calc.floatBetween(-disX, disX);
            	v.y = Calc.floatBetween(-disY, disY);
				v.scaleX = Calc.floatBetween(2, 3);
				v.scaleY = 3;
				displStamp.addChild(v);
				wavArr[i]=v;
			}
			v=new visSerost();
			displStamp.addChild(v);
			p_x=mm.pistol.x;
			p_y=mm.pistol.y;
			if (gr) {
				gr.tuchi.cacheAsBitmap=gr.maska.cacheAsBitmap=true;
				gr.tuchi.blendMode='screen';
				gr.tuchi.mask=gr.maska;
			}
		}
		
		public function anim():void {
			t_anim++;
			t_klip--;
			if (t_klip<=0) {
				mm.eye.play();
				t_klip = Calc.intBetween(60, 169);
			}
			for (var i:int=0; i<wavKol; i++) {
				var v:MovieClip=wavArr[i];
				v.x-=(spd+i/2);
				v.y+=(spd+i/2)*0.3;
				if (v.x<-disX*2) {
					v.x=disX;
					v.scaleX = Calc.floatBetween(2, 3);
					v.scaleY=3;
					v.alpha = Calc.floatBetween(0.5, 1);
				}
				if (v.y>disY) v.y=-disY;
			}
			displBmpd.draw(displStamp,displMatrix);
			mm.displ1.filters=[displFilter1];
			mm.displ2.filters=[displFilter2];
			mm.pistol.x=p_x+Math.sin(t_anim/100)*2;
			mm.pistol.y=p_y-(Math.cos(t_anim/100)-1)*8;
			mm.pistol.magic.krug.rotation=t_anim;
			mm.pistol.magic2.krug.rotation=90+t_anim*0.67;
			mm.horn.magic.krug.rotation=90+t_anim*0.67;
			if (gr) {
				t_groza--;
				if (t_groza == 0) {
					gr.x = Calc.floatBetween(0, 1800);
					gr.y = Calc.floatBetween(0, 350);
					gr.scaleX = gr.scaleY = 1 - gr.y / 800;
					gr.moln.moln.rotation = Calc.floatBetween(0, 360);
					gr.moln.moln.gotoAndStop(Calc.intBetween(1, gr.moln.moln.totalFrames));
					gr.alpha = 1;
					gr.visible = true;
					gr.tuchi.x = Calc.floatBetween(-600, -200);
					gr.tuchi.y = Calc.floatBetween(-500, -200);
				}
				else if (t_groza < 0) {
					gr.alpha = Math.min(1, Calc.floatBetween(0, 0.5) + t_groza / 12 + 0.7);
					if (t_groza < -6 && Calc.floatBetween(0, 1) < 0.1) t_groza = -100;
				}
				if (t_groza < -30) {
					t_groza = Calc.intBetween(100, 300);
					gr.visible = false;
				}
			}
		}
	}
}
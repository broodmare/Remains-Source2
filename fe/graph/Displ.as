package fe.graph {
	
	import flash.display.MovieClip;
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.BitmapDataChannel;
    import flash.display.GradientType;
    import flash.display.SpreadMethod;
    import flash.filters.BitmapFilter;
    import flash.filters.DisplacementMapFilter;
    import flash.filters.DisplacementMapFilterMode;
    import flash.geom.Matrix;
    import flash.geom.Point;
	
	//класс отвечает за анимацию главного меню
	
	public class Displ {
		
		var mm:MovieClip, gr:MovieClip;
		
		var displFilter1:DisplacementMapFilter;
		var displFilter2:DisplacementMapFilter;
		var displBmpd:BitmapData;
		var displStamp:MovieClip;
		var displPoint:Point=new Point(0,0);
		var displMatrix:Matrix=new Matrix();
		var displX:Number=10;
		var displY:Number=15;
		var disp_t:int=0;
		
		var wavKol:int=10;
		var wavArr:Array=new Array();
		var disX=200, disY=250;
		var spd:Number=1;
		
		var t_anim:int=0;
		var t_klip:int=60;
		var t_groza:int=120;
		var p_x:Number, p_y:Number;
		
		public function Displ(nmm:MovieClip, ngr:MovieClip=null) {
			mm=nmm;
			gr=ngr;
			displBmpd=new BitmapData(240,300,false,0x7F7F7F);
			displStamp=new displVolna();
			/*displStamp.blendMode='overlay';
			displStamp.alpha=0.5;
			addChild(displStamp);
			displStamp.x=volna.x;
			displStamp.y=volna.y;*/
			//displMatrix.d=2;
			displMatrix.tx=mm.target.x-mm.displ1.x;
			displMatrix.ty=mm.target.y-mm.displ1.y;
			displFilter1=new DisplacementMapFilter(displBmpd,displPoint,BitmapDataChannel.RED,BitmapDataChannel.RED,displX,displY,DisplacementMapFilterMode.COLOR);
			displFilter2=new DisplacementMapFilter(displBmpd,displPoint,BitmapDataChannel.RED,BitmapDataChannel.RED,0,5,DisplacementMapFilterMode.COLOR);
			for (var i:int=0; i<wavKol; i++) {
				var v:MovieClip=new visWav();
				v.x=Math.random()*disX*2-disX;
				v.y=Math.random()*disY*2-disY;
				v.scaleX=Math.random()+2;
				v.scaleY=3;
				displStamp.addChild(v);
				wavArr[i]=v;
			}
			v=new visSerost();
			displStamp.addChild(v);
			p_x=mm.pistol.x, p_y=mm.pistol.y;
			if (gr) {
				gr.tuchi.cacheAsBitmap=gr.maska.cacheAsBitmap=true;
				gr.tuchi.blendMode='screen';
				gr.tuchi.mask=gr.maska;
			}
		}
		
		public function anim() {
			t_anim++;
			t_klip--;
			if (t_klip<=0) {
				mm.eye.play();
				t_klip=Math.floor(Math.random()*110+60);
			}
			//var sc:Number=1+Math.sin(disp_t/100)*0.5;
			for (var i:int=0; i<wavKol; i++) {
				var v:MovieClip=wavArr[i];
				v.x-=(spd+i/2);
				v.y+=(spd+i/2)*0.3;
				if (v.x<-disX*2) {
					v.x=disX;
					v.scaleX=Math.random()+2;
					v.scaleY=3;
					v.alpha=Math.random()*0.5+0.5;
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
				if (t_groza==0) {
					gr.x=Math.random()*1800;
					gr.y=Math.random()*350;
					gr.scaleX=gr.scaleY=1-gr.y/800;
					gr.moln.moln.rotation=Math.random()*360;
					gr.moln.moln.gotoAndStop(Math.floor(Math.random()*gr.moln.moln.totalFrames+1));
					gr.alpha=1;
					gr.visible=true;
					gr.tuchi.x=-200-Math.random()*400
					gr.tuchi.y=-200-Math.random()*300
				} else if (t_groza<0) {
					gr.alpha=Math.min(1,Math.random()*0.5+t_groza/12+0.7);
					if (t_groza<-6 && Math.random()<0.1) t_groza=-100;
				}
				if (t_groza<-30) {
					t_groza=Math.floor(Math.random()*200+100);
					gr.visible=false;
				}
			}
		}
		
		
	}
	
}

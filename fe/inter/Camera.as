package fe.inter {
	
	import fe.unit.Unit;
	import fe.World;
	import fe.Snd;
	import fe.loc.Location;
	import flash.display.DisplayObject;
	
	public class Camera {
		
		public var w:World;
		public var moved:Boolean;
		public var screenX:int=1280; //размеры экрана
		public var screenY:int=800;
		public var X:int=200; //координаты центра камеры в мире
		public var Y:int=200;
		public var vx:int;		//визуальные координаты мира по отношению к экрану
		public var vy:int, ovy:int;
		public var maxsx:int=2000;	//размеры локации
		public var maxsy:int=2000;
		public var maxvx:int=2000;	//визуальные границы локации
		public var maxvy:int=2000;
		public var celX:int;	//координаты курсора мыши относительно экрана
		public var celY:int;
		public var camRun:Boolean=false;
		public var otryv:Number=0;
		public var quakeX:Number=0;
		public var quakeY:Number=0;
		public var isZoom:int=0;
		public var scaleV=1;
		public var scaleS=1;
		public var dblack:Number=0;
		
		//режим показа
		public var showOn:Boolean=false;
		public var showX:Number=-1;
		public var showY:Number=0;
		
		public function Camera(nw:World) {
			w=nw;
		}
		
		public function setLoc(loc:Location) {
			if (loc==null) return;
			screenX=w.swfStage.stageWidth;
			screenY=w.swfStage.stageHeight;
			maxsx=loc.limX;
			maxsy=loc.limY;
			maxvx=maxsx-screenX;
			maxvy=maxsy-screenY;
			quakeX=quakeY=0;
			if (loc.limX-40<=screenX && loc.limY-40<=screenY) {
				moved=false;
				vx=-maxvx/2;
				vy=-maxvy/2;
				w.visual.x=w.sats.vis.x=vx;
				w.visual.y=w.sats.vis.y=vy;
			} else {
				moved=true;
			}
			//moved=true;
			setZoom();
		}
		
		public function setKoord(mc:DisplayObject, nx:Number, ny:Number) {
			mc.x=nx*scaleV+vx;
			mc.y=ny*scaleV+vy;
		}
		
		public function setZoom(turn:int=-1000) {
			if (turn==1000) {
				isZoom++;
				if (isZoom>2) isZoom=0;
				World.w.gui.infoText('zoom'+isZoom);
			} else if (turn>=0) {
				isZoom=turn;
			}
			
			if (isZoom==1) {
				scaleV=Math.max(screenX/maxsx, screenY/maxsy);
			} else if (isZoom==2) {
				scaleV=Math.min(screenX/maxsx, screenY/maxsy);
			} else {
				scaleV=1;
			}
			scaleS=Math.min(screenX/1920, screenY/1000);
			//scaleV*=0.5;
			if (scaleV>0.98) scaleV=1;
			maxvx=maxsx*scaleV-screenX;
			maxvy=maxsy*scaleV-screenY;
			w.visual.scaleX=w.sats.vis.scaleX=w.visual.scaleY=w.sats.vis.scaleY=scaleV;
			w.vscene.scaleX=w.vscene.scaleY=scaleS;
			if (screenY>maxsy*scaleV) {
				World.w.grafon.ramT.scaleY=-(screenY-maxsy*scaleV)/100/scaleV-0.5;
				World.w.grafon.ramB.scaleY=(screenY-maxsy*scaleV+5)/100/scaleV+0.5;
			} else {
				World.w.grafon.ramT.scaleY=-0.5/scaleV;
				World.w.grafon.ramB.scaleY=0.6/scaleV;
			}
			if (screenX>maxsx*scaleV) {
				World.w.grafon.ramL.scaleX=-(screenX-maxsx*scaleV)/100/scaleV-0.5;
				World.w.grafon.ramR.scaleX=(screenX-maxsx*scaleV+5)/100/scaleV+0.5;
			} else {
				World.w.grafon.ramL.scaleX=-0.5/scaleV;
				World.w.grafon.ramR.scaleX=0.5/scaleV;
			}
		}
		
		public function calc(un:Unit) {
			if (w.ctr.keyZoom) {
				if (World.w.loc && World.w.loc.sky) {
					setZoom(2);
				} else {
					setZoom(1000);
				}
				w.ctr.keyZoom=false;
			}
			if (moved) {
				if ((w.ctr.keyLook || showOn) && otryv<1) {
					if (showOn) otryv+=0.2;
					else otryv+=0.05;
				}
				if (!w.ctr.keyLook && !showOn && otryv>0) {
					otryv-=0.2;
					if (otryv<0) otryv=0;
				}
				if (w.ctr.keyLook) {
					showX=-1;
				}
				if (!camRun) {
					if (otryv>0) {
						if (showX>=0) {
							X=un.X*scaleV+otryv*(showX-screenX/2)*1.3;
							Y=un.Y*scaleV+otryv*(showY-screenY/2)*1.3;
						} else {
							X=un.X*scaleV+otryv*(celX-screenX/2);
							Y=un.Y*scaleV+otryv*(celY-screenY/2);
						}
					} else {
						X=un.X*scaleV;
						if (ovy-un.Y*scaleV>5 && ovy-un.Y*scaleV<50) {
							Y=ovy-(ovy-un.Y*scaleV)/4;
						} else Y=un.Y*scaleV;
					}
				}
				ovy=Y;
				if (maxvx<0) {
					vx=-maxvx/2;
				} else {
					vx=-X+screenX/2;
					if (vx>0) vx=0;
					if (vx<-maxvx) vx=-maxvx;
				}
				if (maxvy<0) {
					vy=-maxvy/2;
				} else {
					vy=-Y+screenY/2+100;
					if (vy>0) vy=0;
					if (vy<-maxvy) vy=-maxvy;
				}
			}
			if (quakeX!=0) {
				if (Math.random()>0.2) quakeX*=-(Math.random()*0.3+0.5);
				if (quakeX<1 && quakeX>-1) quakeX=0;
			}
			if (quakeY!=0) {
				if (Math.random()>0.2) quakeY*=-(Math.random()*0.3+0.5);
				if (quakeY<1 && quakeY>-1) quakeY=0;
			}
			w.visual.x=w.sats.vis.x=vx+quakeX;
			w.visual.y=w.sats.vis.y=vy+quakeY;
			Snd.centrX=X, Snd.centrY=Y;
			
			w.celX=(celX-vx)/scaleV;
			w.celY=(celY-vy)/scaleV;
			if (dblack>0) {
				w.vblack.visible=true;
				w.vblack.alpha+=dblack/100;
				if (w.vblack.alpha>=1) {
					dblack=0;
				}
			}
			if (dblack<0) {
				w.vblack.alpha+=dblack/100;
				if (w.vblack.alpha<=0) {
					dblack=0;
					w.vblack.visible=false;
				}
			}
		}

	}
	
}

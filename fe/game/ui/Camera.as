package fe.game.ui {

	import flash.display.DisplayObject;

	import fe.engine.utils.Vec2;
	import fe.engine.utils.Calc;
	import fe.game.domain.units.Unit;
	import fe.game.World;
	import fe.engine.Engine;
	import fe.game.GameContainer;
	import fe.engine.audio.Sound;
	import fe.game.domain.location.Location;
	
	public class Camera {

		public var moved:Boolean;
		public var screenX:int=1280; //размеры экрана
		public var screenY:int=800;
		public var coord:Vec2 = new Vec2(200, 200); // [Coordinates of the camera center in the world]
		public var vx:int;				// [Visual coordinates of the world relative to the screen]
		public var vy:int;
		public var ovy:int;
		public var maxsx:int = 2000;	// [Location dimensions]
		public var maxsy:int = 2000;
		public var maxvx:int = 2000;	// [Visual boundaries of the location]
		public var maxvy:int = 2000;
		public var celX:int;			// [Coordinates of the mouse cursor relative to the screen]
		public var celY:int;
		public var camRun:Boolean=false;
		public var otryv:Number=0;
		public var quakeX:Number=0;
		public var quakeY:Number=0;
		public var isZoom:int=0;
		public var scaleV:Number = 1;
		public var scaleS:Number = 1;
		public var dblack:Number=0;
		
		//режим показа
		public var showOn:Boolean=false;
		public var showX:Number=-1;
		public var showY:Number=0;
		
		public function Camera() {
		}
		
		public function setLoc(loc:Location):void {
			if (loc == null) return;
			screenX = Engine.reference.stage.stageWidth;
			screenY = Engine.reference.stage.stageHeight;
			maxsx = loc.maxX;
			maxsy = loc.maxY;
			maxvx = maxsx - screenX;
			maxvy = maxsy - screenY;
			quakeX = 0;
			quakeY = 0;
			if (loc.maxX-40<=screenX && loc.maxY-40<=screenY) {
				moved=false;
				vx = -maxvx / 2;
				vy = -maxvy / 2;
				GUIManager.reference.visual.x = GUIManager.reference.sats.vis.x = vx;
				GUIManager.reference.visual.y = GUIManager.reference.sats.vis.y = vy;
			}
			else moved = true;
			setZoom();
		}
		
		public function setKoord(mc:DisplayObject, nx:Number, ny:Number):void {
			
			mc.x = nx * scaleV + vx;
			mc.y = ny * scaleV + vy;
		}
		
		public function setZoom(turn:int=-1000):void {
			if (turn == 1000) {
				isZoom++;
				if (isZoom > 2) isZoom = 0;
				GUIManager.reference.gui.infoText('zoom' + isZoom);
			}
			else if (turn >= 0) isZoom = turn;
			
			if (isZoom==1) scaleV = Math.max(screenX / maxsx, screenY / maxsy);
			else if (isZoom == 2) scaleV = Math.min(screenX / maxsx, screenY / maxsy);
			else scaleV = 1;

			scaleS = Math.min(screenX / 1920, screenY / 1000);
			if (scaleV > 0.98) scaleV = 1;
			maxvx = maxsx * scaleV - screenX;
			maxvy = maxsy * scaleV - screenY;

			GUIManager.reference.visual.scaleX		= scaleV;
			GUIManager.reference.sats.vis.scaleX	= scaleV;
			GUIManager.reference.visual.scaleY		= scaleV;
			GUIManager.reference.sats.vis.scaleY	= scaleV;
			GUIManager.reference.vscene.scaleX		= scaleS;
			GUIManager.reference.vscene.scaleY		= scaleS;
			
			if (screenY>maxsy*scaleV)
			{
				GameContainer.reference.grafon.ramT.scaleY=-(screenY-maxsy*scaleV)/100/scaleV-0.5;
				GameContainer.reference.grafon.ramB.scaleY=(screenY-maxsy*scaleV+5)/100/scaleV+0.5;
			}
			else
			{
				GameContainer.reference.grafon.ramT.scaleY=-0.5/scaleV;
				GameContainer.reference.grafon.ramB.scaleY=0.6/scaleV;
			}
			
			if (screenX>maxsx*scaleV) {
				GameContainer.reference.grafon.ramL.scaleX=-(screenX-maxsx*scaleV)/100/scaleV-0.5;
				GameContainer.reference.grafon.ramR.scaleX=(screenX-maxsx*scaleV+5)/100/scaleV+0.5;
			}
			else
			{
				GameContainer.reference.grafon.ramL.scaleX=-0.5/scaleV;
				GameContainer.reference.grafon.ramR.scaleX=0.5/scaleV;
			}
		}
		
		public function calc(un:Unit):void {
			if (GameContainer.reference.ctr.keyZoom) {
				if (World.w.loc && World.w.loc.sky) {
					setZoom(2);
				} else {
					setZoom(1000);
				}
				GameContainer.reference.ctr.keyZoom=false;
			}
			if (moved) {
				if ((GameContainer.reference.ctr.keyLook || showOn) && otryv<1) {
					if (showOn) otryv+=0.2;
					else otryv+=0.05;
				}
				if (!GameContainer.reference.ctr.keyLook && !showOn && otryv>0) {
					otryv-=0.2;
					if (otryv<0) otryv=0;
				}
				if (GameContainer.reference.ctr.keyLook) {
					showX=-1;
				}
				if (!camRun) {
					
					var x:Number;
					var y:Number;

					// Set the x and y value of our new coordinate vector
					if (otryv > 0) {
						
						if (showX >= 0) {
							x = un.coordinates.X * scaleV + otryv * (showX - screenX / 2) * 1.3;
							y = un.coordinates.Y * scaleV + otryv * (showY - screenY / 2) * 1.3;
						}
						else {
							x = un.coordinates.X * scaleV + otryv * (celX - screenX / 2);
							y = un.coordinates.Y * scaleV + otryv * (celY - screenY / 2);
						}
					}
					else
					{
						x = un.coordinates.X * scaleV;
						if (ovy - un.coordinates.Y * scaleV > 5 && ovy - un.coordinates.Y * scaleV < 50) {
							y = ovy-(ovy - un.coordinates.Y * scaleV) / 4;
						}
						else y = un.coordinates.Y * scaleV;
					}

					// Update our coordinates
					coord.set(x, y);
				}
				
				ovy = coord.Y;
				
				if (maxvx < 0) {
					vx = -maxvx / 2;
				}
				else {
					vx = -coord.X + screenX / 2;
					if (vx > 0) vx = 0;
					if (vx < -maxvx) vx = -maxvx;
				}
				
				if (maxvy < 0) {
					vy = -maxvy / 2;
				}
				else {
					vy = -coord.Y + screenY / 2 + 100;
					if (vy > 0) vy = 0;
					if (vy < -maxvy) vy = -maxvy;
				}
			}
			if (quakeX != 0) {
				if (Math.random() > 0.2) quakeX *= Calc.floatBetween(-0.5, -0.8);
				if (quakeX<1 && quakeX>-1) quakeX=0;
			}
			if (quakeY != 0) {
				if (Math.random() > 0.2) quakeY *= Calc.floatBetween(-0.5, -0.8);
				if (quakeY<1 && quakeY>-1) quakeY=0;
			}
			GUIManager.reference.visual.x=GUIManager.reference.sats.vis.x=vx+quakeX;
			GUIManager.reference.visual.y=GUIManager.reference.sats.vis.y=vy+quakeY;
			Sound.center.setVector(coord);
			
			GameContainer.reference.celX = (celX - vx) / scaleV;
			GameContainer.reference.celY = (celY - vy) / scaleV;
			if (dblack > 0) {
				GUIManager.reference.vblack.visible = true;
				GUIManager.reference.vblack.alpha += dblack / 100;
				if (GUIManager.reference.vblack.alpha >= 1) {
					dblack = 0;
				}
			}
			// The room fades in once its units' sheets have decoded
			if (dblack < 0 && GameContainer.reference.grafon.unitSheets.isLoaded) {
				GUIManager.reference.vblack.alpha += dblack / 100;
				if (GUIManager.reference.vblack.alpha <= 0) {
					dblack = 0;
					GUIManager.reference.vblack.visible = false;
				}
			}
		}
	}
}
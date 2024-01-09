package fe.weapon {
	
	import fe.*;
	import fe.unit.Unit;
	import fe.unit.UnitPlayer;
	import fe.graph.Emitter;
	import fe.loc.Tile;
	import fe.loc.Box;
	
	public class PhisBullet extends Bullet {
		
		var brake=2;
		var dr:Number=0;
		var lip:Boolean=false, prilip:Boolean=false, bumc:Boolean=false;
		
		var skok:Number=0.5, tormoz:Number=0.7;
		var isSensor:Boolean=false;
		
		public var sndHit:String='';

		public function PhisBullet(own:Unit, nx:Number, ny:Number, visClass:Class=null) {
			super(own,nx,ny,visClass);
			ddy=World.ddy;
			massa=0.1;
			warn=1;
			levitPoss=true;
			inWater=0;
			scX=scY=30;
			if (vis) vis.visible=true;
			// constructor code
		}
		public override function step() {
			if (levit) {
				dy*=0.8; dx*=0.8;
			} else dy+=ddy;
			if (stay) {
				if (dx>1) dx-=brake;
				else if (dx<-1) dx+=brake;
				else dx=0;
				dr=dx;
			}
			if (inWater) {
				dy*=0.8; dx*=0.8;
			}
			if (!babah && !prilip) {
				if (Math.abs(dx)<World.maxdelta && Math.abs(dy)<World.maxdelta)	run();
				else {
					var div=Math.floor(Math.max(Math.abs(dx),Math.abs(dy))/World.maxdelta)+1;
					for (var i=0; (i<div && !babah); i++) run(div);
				}
			}
			checkWater();
			if (vis) {
				vis.rotation+=dr;
				vis.x=X;
				vis.y=Y;
			}
			if (isSensor || loc.sky) sensor();
			if (expl_t>0) expl_t--;
			else liv--;
			if (liv==3) {
				if ((World.w.gg as UnitPlayer).teleObj==this) (World.w.gg as UnitPlayer).dropTeleObj();
				explosion();
				liv=1;
			}
			if (expl_t>0 && expl_t%explPeriod==1) explRun();
			if (liv<=0) { 
				onCursor=0;
				vse=true;
			}
			if (explRadius>0) loc.warning=10;	//команда для ИИ следить за гранатами
			if (vse) {
				loc.remObj(this);
				loc.remGrenade(this);
			}
			//trace(liv,expl_t);
			onCursor=(liv>5 && X-scX/2<World.w.celX && X+scX/2>World.w.celX && Y-scY/2<World.w.celY && Y+scY/2>World.w.celY)?3:0;
		}
		
		private function sensor():Boolean {
			for each (var un:Unit in loc.units) {
				if (!un.disabled && un.fraction!=owner.fraction && X>=un.X1 && X<=un.X2 && Y>=un.Y1 && Y<=un.Y2 && un.sost<3) {
					explosion();
					onCursor=0;
					vse=true;
					return true;
				}
			}
			return false;
		}
		
		//поиск жидкости
		public function checkWater():int {
			var pla=inWater;
			inWater=0;
			try {
				if ((loc.space[Math.floor(X/Tile.tileX)][Math.floor(Y/Tile.tileY)] as Tile).water>0) {
					inWater=1;
				}
			} catch (err) {
				
			}
			if (pla!=inWater && dy>5) {
				Emitter.emit('kap',loc,X,Y,{dy:-Math.abs(dy)*(Math.random()*0.3+0.3), kol:5});
				Snd.ps('fall_item_water',X,Y,0, dy/10);
			}
			return inWater;
		}
		
		public override function popadalo(res:int=0) {
			if (res<0) return;			//не попал
			dx=dy=0;
			if (explRadius) {
				explosion();
				if (vis) vis.visible=false;
			} 
			if (liv>1) liv=1;
			babah=true;
		}
		
		public override function run(div:int=1) {
			var t:Tile;
			X+=dx/div;
			if (lip) {
				if (loc.celObj && (loc.celObj is Box) && (loc.celObj as Box).explcrack && owner && owner.player && X>=loc.celObj.X1 && X<=loc.celObj.X2 && Y>=loc.celObj.Y1 && Y<=loc.celObj.Y2) {
					targetObj=loc.celObj;
					prilip=true;
					return;
				}
			}
			if (loc.sky) {
				Y+=dy/div;
				if (X<0 || X>=loc.limX || Y<0 || Y>=loc.limY) {
					vse=true;
					return;
				}
			} else {
				if (X<0 || X>=loc.spaceX*Tile.tileX) {
					vse=true;
					return;
				}
				if (dx<0) {
					t=loc.getAbsTile(X,Y);
					if (t.phis==1 && X<=t.phX2 && X>=t.phX1 && Y>=t.phY1 && Y<=t.phY2) {
						if (sndHit!='') Snd.ps(sndHit,X,Y,0,Math.abs(dx/10));
						if (bumc) {
							popadalo();
						}
						X=t.phX2+1;
						dx=Math.abs(dx*skok);
						if (lip) prilip=true;
					}
				}
				//движение вправо
				if (dx>0) {
					t=loc.getAbsTile(X,Y);
					if (t.phis==1 && X>=t.phX1 && X<=t.phX2 && Y>=t.phY1 && Y<=t.phY2) {
						if (sndHit!='') Snd.ps(sndHit,X,Y,0,Math.abs(dx/10));
						if (bumc) {
							popadalo();
						}
						X=t.phX1-1;
						dx=-Math.abs(dx*skok);
						if (lip) prilip=true;
					}
				}
				//ВЕРТИКАЛЬ
				//движение вверх
				if (dy<0) {
					stay=false;
					Y+=dy/div;
					t=loc.getAbsTile(X,Y);
					if (t.phis==1 && Y<=t.phY2 && Y>=t.phY1 && X>=t.phX1 && X<=t.phX2) {
						if (sndHit!='') Snd.ps(sndHit,X,Y,0,Math.abs(dy/10));
						if (bumc) {
							popadalo();
						}
						Y=t.phY2+1;
						dy=Math.abs(dy*skok);
						if (lip) prilip=true;
					}
				}
				//движение вниз
				var newmy:Number=0;
				if (dy>0) {
					stay=false;
					Y+=dy/div;
					if (Y>=loc.spaceY*Tile.tileY) {
						vse=true;
						return;
					}
					t=loc.getAbsTile(X,Y);
					if (t.phis==1 && Y>=t.phY1 && Y<=t.phY2 && X>=t.phX1 && X<=t.phX2) {
						if (bumc) {
							if (sndHit!='') Snd.ps(sndHit,X,Y,0,Math.abs(dy/10));
							popadalo();
						}
						Y=t.phY1-1;
						if (lip) prilip=true;
						if (dy>2) {
							dy=-Math.abs(dy*skok);
							dx*=tormoz;
							if (sndHit!='') Snd.ps(sndHit,X,Y,0,Math.abs(dy/10));
						} else {
							dy=0;
							stay=true;
						}
					}
				}
			}
		}
	}
	
}

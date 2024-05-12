package fe.projectile
{
	import fe.*;
	import fe.unit.Unit;
	import fe.unit.UnitPlayer;
	import fe.graph.Emitter;
	import fe.loc.Tile;
	import fe.loc.Box;
	import fe.entities.Obj;
	
	public class PhisBullet extends Bullet
	{
		public var brake=2;
		public var dr:Number=0;
		public var lip:Boolean=false;
		public var prilip:Boolean=false;
		public var bumc:Boolean=false;
		
		public var skok:Number=0.5;
		public var tormoz:Number=0.7;
		public var isSensor:Boolean=false;
		
		public var sndHit:String='';

		public function PhisBullet(own:Unit, nx:Number, ny:Number, visClass:Class=null)
		{
			super(own,nx,ny,visClass);
			ddy=World.ddy;
			massa=0.1;
			warn=1;
			levitPoss=true;
			inWater=0;
			objectWidth = 30;
			objectHeight = 30;
			if (vis) vis.visible = true;
		}

		public override function step()
		{
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
					var div = int(Math.max(Math.abs(dx),Math.abs(dy))/World.maxdelta)+1;
					for (var i=0; (i<div && !babah); i++) run(div);
				}
			}
			checkWater();
			if (vis) {
				vis.rotation+=dr;
				vis.x = coordinates.X;
				vis.y = coordinates.Y;
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
			onCursor = (liv > 5 && coordinates.X - objectWidth / 2 < World.w.celX && coordinates.X + objectWidth / 2 > World.w.celX && coordinates.Y - objectHeight / 2 < World.w.celY && coordinates.Y + objectHeight / 2 > World.w.celY)? 3:0;
		}
		
		private function sensor():Boolean {
			for each (var un:Unit in loc.units) {
				if (!un.disabled && un.fraction != owner.fraction && coordinates.X >= un.leftBound && coordinates.X <= un.rightBound && coordinates.Y >= un.topBound && coordinates.Y <= un.bottomBound && un.sost < 3) {
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
			var pla = inWater;
			inWater = 0;
			try {
				if ((loc.space[int(coordinates.X/Tile.tileX)][int(coordinates.Y/Tile.tileY)] as Tile).water > 0)
				{
					inWater = 1;
				}
			}
			catch (err)
			{
				trace('ERROR: (00:22)');
			}

			if (pla!=inWater && dy>5) {
				Emitter.emit('kap', loc, coordinates.X, coordinates.Y, {dy:-Math.abs(dy)*(Math.random()*0.3+0.3), kol:5});
				Snd.ps('fall_item_water', coordinates.X, coordinates.Y, 0, dy/10);
			}
			return inWater;
		}
		
		public override function popadalo(res:int=0) {
			if (res<0) return;			//не попал
			dx = 0; 
			dy = 0;
			if (explRadius) {
				explosion();
				if (vis) vis.visible=false;
			} 
			if (liv>1) liv=1;
			babah=true;
		}
		
		public override function run(div:int=1):void {
			var t:Tile;
			coordinates.X += dx/div;
			if (lip) {
				if (loc.celObj && (loc.celObj is Box) && (loc.celObj as Box).explcrack && owner && owner.player && coordinates.X >= loc.celObj.leftBound && coordinates.X <= loc.celObj.rightBound && coordinates.Y >= loc.celObj.topBound && coordinates.Y <= loc.celObj.bottomBound)
				{
					targetObj=loc.celObj;
					prilip=true;
					return;
				}
			}
			if (loc.sky)
			{
				coordinates.Y += dy / div;
				if (coordinates.X < 0 || coordinates.X >= loc.maxX || coordinates.Y < 0 || coordinates.Y >= loc.maxY)
				{
					vse=true;
					return;
				}
			} else {
				if (coordinates.X < 0 || coordinates.X >= loc.spaceX * Tile.tileX)
				{
					vse=true;
					return;
				}
				if (dx<0) {
					t=loc.getAbsTile(coordinates.X, coordinates.Y);
					if (t.phis==1 && coordinates.X <= t.phX2 && coordinates.X >= t.phX1 && coordinates.Y >= t.phY1 && coordinates.Y <= t.phY2)
					{
						if (sndHit!='') Snd.ps(sndHit,coordinates.X, coordinates.Y, 0, Math.abs(dx/10));
						if (bumc) {
							popadalo();
						}
						coordinates.X = t.phX2 + 1;
						dx = Math.abs(dx*skok);
						if (lip) prilip=true;
					}
				}
				//движение вправо
				if (dx>0) {
					t = loc.getAbsTile(coordinates.X, coordinates.Y);
					if (t.phis == 1 && coordinates.X >= t.phX1 && coordinates.X <= t.phX2 && coordinates.Y >= t.phY1 && coordinates.Y <= t.phY2)
					{
						if (sndHit!='') Snd.ps(sndHit, coordinates.X, coordinates.Y, 0, Math.abs(dx/10));
						if (bumc) {
							popadalo();
						}
						coordinates.X = t.phX1 - 1;
						dx = -Math.abs(dx*skok);
						if (lip) prilip=true;
					}
				}
				//ВЕРТИКАЛЬ
				//движение вверх
				if (dy<0) {
					stay=false;
					coordinates.Y += dy / div;
					t = loc.getAbsTile(coordinates.X, coordinates.Y);
					if (t.phis==1 && coordinates.Y <= t.phY2 && coordinates.Y >= t.phY1 && coordinates.X >= t.phX1 && coordinates.X <= t.phX2)
					{
						if (sndHit!='') Snd.ps(sndHit, coordinates.X, coordinates.Y, 0, Math.abs(dy/10));
						if (bumc) {
							popadalo();
						}
						coordinates.Y = t.phY2 + 1;
						dy = Math.abs(dy*skok);
						if (lip) prilip=true;
					}
				}
				//движение вниз
				var newmy:Number=0;
				if (dy>0) {
					stay=false;
					coordinates.Y += dy / div;
					if (coordinates.Y >= loc.spaceY * Tile.tileY)
					{
						vse=true;
						return;
					}
					t = loc.getAbsTile(coordinates.X, coordinates.Y);
					if (t.phis==1 && coordinates.Y >= t.phY1 && coordinates.Y <= t.phY2 && coordinates.X >= t.phX1 && coordinates.X <= t.phX2)
					{
						if (bumc) {
							if (sndHit!='') Snd.ps(sndHit, coordinates.X, coordinates.Y, 0, Math.abs(dy/10));
							popadalo();
						}
						coordinates.Y = t.phY1 - 1;
						if (lip) prilip=true;
						if (dy > 2)
						{
							dy = -Math.abs(dy*skok);
							dx *= tormoz;
							if (sndHit != '') Snd.ps(sndHit, coordinates.X, coordinates.Y, 0, Math.abs(dy/10));
						}
						else
						{
							dy=0;
							stay=true;
						}
					}
				}
			}
		}
	}	
}
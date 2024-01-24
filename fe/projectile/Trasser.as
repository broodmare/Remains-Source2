package fe.projectile
{
	import fe.*;
	import fe.loc.*;
	import flash.display.Graphics;

	public class Trasser
	{
		public var loc:Location;
		public var X:Number, Y:Number, dx:Number, dy:Number, begx:Number, begy:Number, begdx:Number, begdy:Number, ddx:Number=0, ddy:Number=0;
		public var is_skok:Boolean=false, vse:Boolean=false, stay:Boolean=false;
		public var liv:int=100;
		public var sled:Array;
		public var explRadius:Number=0;	//радиус взрыва, если 0, то взрыва нет
		
		public var brake=2;
		public var skok:Number=0.5;
		public var tormoz:Number=0.7;

		private static var tileX:int = Tile.tileX;
		private static var tileY:int = Tile.tileY;

		public function Trasser() 
		{

		}
		
		public function trass(gr:Graphics)
		{
			sled=new Array();
			X=begx;
			Y=begy;
			dx=begdx;
			dy=begdy;
			vse=stay=false;
			gr.clear();
			gr.lineStyle(5,0x00FF99,0.5);
			gr.moveTo(X,Y);
			
			for (var i=0; i<liv; i++)
			{
				dy+=ddy;
				dx+=ddx;
				if (stay)
				{
					if (dx>1) dx-=brake;
					else if (dx<-1) dx+=brake;
					else dx=0;
				}
				if (Math.abs(dx)<World.maxdelta && Math.abs(dy)<World.maxdelta)	run();
				else
				{
					var div:int = int(Math.max(Math.abs(dx),Math.abs(dy))/World.maxdelta)+1;
					for (var j:int = 0; (j < div && !vse); j++) run(div);
				}
				gr.lineTo(X,Y);
				sled.push({x:X, y:Y});
				if (vse) break;
			}
		}
		
		public function run(div:int=1)
		{
			if (vse) return;
			var t:Tile;
			X += dx / div;
			if (X < 0 || X >= loc.spaceX * tileX)
			{
				vse=true;
				return;
			}
			if (dx<0) {
				t=loc.getAbsTile(X,Y);
				if (t.phis==1 && X<=t.phX2 && X>=t.phX1 && Y>=t.phY1 && Y<=t.phY2)
				{
					if (!is_skok) vse=true;
					else
					{
						X=t.phX2+1;
						dx=Math.abs(dx*skok);
					}
				}
			}
			//движение вправо
			if (dx>0)
			{
				t=loc.getAbsTile(X,Y);
				if (t.phis==1 && X>=t.phX1 && X<=t.phX2 && Y>=t.phY1 && Y<=t.phY2)
				{
					if (!is_skok) vse=true;
					else
					{
						X=t.phX1-1;
						dx=-Math.abs(dx*skok);
					}
				}
			}
			if (vse)
			{
				Y+=dy/div;
				return;
			}
			//ВЕРТИКАЛЬ
			//движение вверх
			if (dy<0)
			{
				Y+=dy/div;
				t=loc.getAbsTile(X,Y);
				if (t.phis==1 && Y<=t.phY2 && Y>=t.phY1 && X>=t.phX1 && X<=t.phX2)
				{
					if (!is_skok) vse=true;
					else
					{
						Y=t.phY2+1;
						dy=Math.abs(dy*skok);
					}
				}
			}
			//движение вниз
			var newmy:Number=0;
			if (dy > 0)
			{
				Y += dy / div;
				if (Y >= loc.spaceY * tileY)
				{
					vse=true;
					return;
				}
				t=loc.getAbsTile(X,Y);
				if (t.phis==1 && Y>=t.phY1 && Y<=t.phY2 && X>=t.phX1 && X<=t.phX2)
				{
					Y=t.phY1-1;
					if (!is_skok) vse=true;
					else
					{
						if (dy>2)
						{
							dy=-Math.abs(dy*skok);
							dx*=tormoz;
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
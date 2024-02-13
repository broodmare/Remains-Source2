package  fe.unit.unitTypes
{
	import fe.*;
	import fe.weapon.Weapon;
	import fe.unit.Unit;
	
	public class UnitThunderTurret extends Unit
	{
		public var head:UnitThunderHead;
		var bindX:Number=0, bindY:Number=0;
		public var tr:int;
		
		var attTurN:int=15;
		var t_wait:int=0;

		public function UnitThunderTurret(cid:String=null, ndif:Number=100, xml:XML=null, loadObj:Object=null) {
			super(cid, ndif, xml, loadObj);
			id='ttur';
			tr=int(cid);
			getXmlParam();
			vis=new visualTTurret();
			vis.osn.scaleX=vis.osn.scaleY=3;
			vis.osn.pole.visible=false;
			mater=false;
			mat=1;
			fixed=true;
			nazv='';
			friendlyExpl=0;
			currentWeapon=new Weapon(this,'ttweap'+tr);
			childObjs=new Array(currentWeapon);
			t_wait=Math.round(Math.random()*100);
		}
		
		public function mega() {
			vis.osn.pole.visible=true;
			invulner=true;
			hp=maxhp=maxhp*10;
		}
		
		public override function run(div:int=1) {
			if (head) {
				coordinates.X = head.coordinates.X + bindX;
				coordinates.Y = head.coordinates.Y + bindY;
			}
			topBound = coordinates.Y - objectHeight;
			bottomBound = coordinates.Y;
			leftBound = coordinates.X - objectWidth / 2;
			rightBound = coordinates.X + objectWidth / 2;
			setVisPos();
		}
		
		override protected function control():void {
			if (head==null || loc==null) return;
			if (sost>1 || head.sost>1) return;
			if (head.isAtt && coordinates.X > 200 && coordinates.Y > 200 && coordinates.X < loc.maxX - 200 && coordinates.Y < loc.maxY - 200) {
				if (t_wait>0) {
					t_wait--;
					return;
				}
				currentWeapon.reloadMult=1/head.reloadDiv;
				setCel(World.w.gg);
				storona=(celDX>0)?1:-1;
					currentWeapon.attack();
				if (isShoot) {
					head.attTur=attTurN;
					isShoot=false;
				}
			}
		}
		
		public override function setLevel(nlevel:int=0)
		{
			if (World.w.game.globalDif == 3)
			{
				hp=maxhp=hp*1.5;
			}
			if (World.w.game.globalDif == 4)
			{
				hp=maxhp=hp*2;
			}
		}
		
		public override function expl()
		{
			head.dieTurret();
			newPart('metal',4);
			newPart('expl');
		}
		public override function animate()
		{
			if (sost>1) return;
		}

		public override function setVisPos()
		{
			if (vis)
			{
				vis.x = coordinates.X;
				vis.y = coordinates.Y;
				currentWeapon.vis.x = coordinates.X;
				currentWeapon.vis.y = this.topBoundToCenter;
			}
		}

		public override function makeNoise(n:int, hlup:Boolean=false)
		{
			
		}

		public override function setHpbarPos()
		{
			hpbar.y = coordinates.Y - 140;
			hpbar.x = coordinates.X;
			if (loc && loc.zoom!=1) hpbar.scaleX=hpbar.scaleY=loc.zoom;
		}
	}
}
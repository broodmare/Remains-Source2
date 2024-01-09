package  fe.unit {
	
	import fe.*;
	import fe.weapon.Weapon;
	import fe.weapon.Bullet;
	
	public class UnitThunderTurret extends Unit{
		
		public var head:UnitThunderHead;
		var bindX:Number=0, bindY:Number=0;
		public var tr:int;
		
		var attTurN:int=15;
		//var waitTur:Boolean=true; //очерёдность
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
				X=head.X+bindX;
				Y=head.Y+bindY;
			}
			Y1=Y-scY, Y2=Y;
			X1=X-scX/2, X2=X+scX/2;
			//setWeaponPos();
			setVisPos();
		}
		
		public override function control() {
			if (head==null || loc==null) return;
			if (sost>1 || head.sost>1) return;
			if (head.isAtt && X>200 && Y>200 && X<loc.limX-200 && Y<loc.limY-200) {
				if (t_wait>0) {
					t_wait--;
					return;
				}
				currentWeapon.reloadMult=1/head.reloadDiv;
					//setCel(null, World.w.gg.X+Math.random()*500-250, World.w.gg.Y+Math.random()*400-200);
				setCel(World.w.gg);
				storona=(celDX>0)?1:-1;
				//if (head.attTur<=0) 
					currentWeapon.attack();
				if (isShoot) {
					head.attTur=attTurN;
					isShoot=false;
				}
			}
		}
		
		public override function setLevel(nlevel:int=0) {
			if (World.w.game.globalDif==3) {
				hp=maxhp=hp*1.5;
			}
			if (World.w.game.globalDif==4) {
				hp=maxhp=hp*2;
			}
		}
		
		public override function expl()	{
			head.dieTurret();
			newPart('metal',4);
			newPart('expl');
		}
		public override function animate() {
			if (sost>1) return;
			try {
				//vis.osn.puha.gotoAndStop(tr);
				//vis.osn.puha.rotation=currentWeapon.rot*180/Math.PI+90*(1-storona);
			} catch(err) {}
		}

		public override function setVisPos() {
			if (vis) {
				vis.x=X,vis.y=Y;
				currentWeapon.vis.x=X;
				currentWeapon.vis.y=Y-scY/2;
			}
		}
		public override function makeNoise(n:int, hlup:Boolean=false) {}
		public override function setHpbarPos() {
			hpbar.y=Y-140;
			hpbar.x=X;
			if (loc && loc.zoom!=1) hpbar.scaleX=hpbar.scaleY=loc.zoom;
		}
	}
	
}

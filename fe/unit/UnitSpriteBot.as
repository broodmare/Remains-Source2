package fe.unit {
	
	import fe.*;
	import fe.weapon.Weapon;
	
	public class UnitSpriteBot extends Unit{
		
		var cDam:Number;

		public function UnitSpriteBot(cid:String=null, ndif:Number=100, xml:XML=null, loadObj:Object=null) {
			super(cid, ndif, xml, loadObj);
			id='spritebot';
			vis=new visualSpriteBot();
			vis.osn.gotoAndStop(1);
			getXmlParam();
			maxSpeed+=Math.random()*2-1;
			walkSpeed=maxSpeed;
			runSpeed=maxSpeed*1.5;
			isFly=true;
			mat=1;
			acidDey=1;
			elast=0.8;
			currentWeapon=new Weapon(this,'robolaser');
			childObjs=new Array(currentWeapon);
		}

		public override function expl()	{
			newPart('metal',4);
			newPart('miniexpl');
		}
		
		public override function forces() {
			if (isFly) {
				dx*=0.95;
				dy*=0.95;
			} else super.forces();
		}
		
		public override function setNull(f:Boolean=false) {
			super.setNull(f);
			if (f) {
				vis.osn.gotoAndStop(1);
				vision=0.3;
				aiState=0;
				aiTCh=Math.floor(Math.random()*50)+5;
			}
		}
		
		public override function setWeaponPos(tip:int=0) {
			weaponX=X;
			weaponY=Y-1;
		}
		
		public override function alarma(nx:Number=-1,ny:Number=-1) {
			super.alarma(nx,ny);
			if (sost==1) {
				zlo();
				aiTCh=3;
			}
		}
		
		public override function animate() {
		}
		
		public function zlo() {
			vision=1;
			aiState=1;
			if (vis.osn.currentFrame!=2) vis.osn.gotoAndStop(2);
		}
		
		var aiDx:Number=0, aiDy:Number=0, aiRasst:Number;
		
		//состояния
		//0 - летает
		//1 - видит цель, стреляет
		
		public override function control() {
			if (sost>=3) return;
			if (World.w.enemyAct<=0) {
				return;
			}
			if (stun) {
				return;
			}
			if (aiTCh>0) aiTCh--;		//счётчик смены состояний
			else {						//смена состояний
				if (celUnit) {
					maxSpeed=runSpeed*(Math.random()*0.6+0.7);
					aiRasst=Math.sqrt(celDX*celDX+celDY*celDY);
					aiTCh=Math.floor(Math.random()*50)+20;
				} else {
					maxSpeed=walkSpeed*(Math.random()+0.5);
					aiRasst=0;
					aiTCh=Math.floor(Math.random()*150)+30;
					storona=(dx>0)?1:-1;
					setCel(null,X+dx*10, Y+dy*10);
				}
				if (aiRasst>500) {
					aiDx=celDX/aiRasst;
					aiDy=celDY/aiRasst;
				} else {
					var napr=Math.random()*360;
					aiDx=Math.sin(napr);
					aiDy=Math.cos(napr);
				}
				dx=aiDx*maxSpeed;
				dy=aiDy*maxSpeed;
				if (celUnit) {
					storona=(celDX>0)?1:-1;
				} else {
					storona=(dx>0)?1:-1;
				}
			}
			//поиск цели
			if (World.w.enemyAct>1 && aiTCh%10==1) {
				if (findCel()) {
					zlo();
					storona=(celDX>0)?1:-1;
				}
			}
			
			//vision=(aiState==0)?0.4:1;
	
			if (turnX) {
				storona=turnX;
				//dx=Math.abs(dx)*turnX;
				turnX=0;
			}
			if (turnY) {
				//dy=Math.abs(dy)*turnY;
				turnY=0;
			}
			//атака
			if (World.w.enemyAct>=3 && aiState==1 && celUnit && shok<=0) {
				if (isrnd(0.1)) currentWeapon.attack();
			}
		}
	}
	
}

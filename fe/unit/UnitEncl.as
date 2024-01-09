package fe.unit {
	import fe.*;
	import fe.serv.BlitAnim;
	import fe.weapon.Weapon;
	import fe.weapon.WThrow;
	import flash.display.MovieClip;
	import flash.geom.Point;
	
	public class UnitEncl extends UnitRaider{
		
		var thWeapon:Weapon;
		var t_gren:int=Math.round(Math.random()*150+50);
		
		public function UnitEncl(cid:String=null, ndif:Number=100, xml:XML=null, loadObj:Object=null) {
			parentId='encl';
			flyer=true;
			kolTrs=1;
			super(cid, ndif, xml, loadObj);
			tupizna=10;
			visionMult=1.5;
			durak=false;
			allLink=true;
			maxSpok=50;
			//if (msex) wPos=BlitAnim.wPosEncl1;
			//else wPos=BlitAnim.wPosEncl2;
			wPos=BlitAnim.wPosEncl1;
			if (grenader>0) {
				thWeapon=Weapon.create(this,'mercgr');
				(thWeapon as WThrow).kolAmmo=grenader;
				childObjs.push(thWeapon);
			}
			if (enclWeap) {
				isDropArm=false;
				if (currentWeapon) {
					currentWeapon.svis='encl';
					currentWeapon.vis=new visencl();
				}
			}
			if (currentWeapon.damage<20) currentWeapon.damage*=1.2;
			currentWeapon.damage*=1.2;
		}
		
		public override function addVisual() {
			if (disabled) return;
			trigDis=!checkTrig();
			if (trigDis) return;
			super.addVisual();
			if (currentWeapon) {
				currentWeapon.recoil=0;
				currentWeapon.recoilUp*=0.25;
			}
		}
		
		public override function setLevel(nlevel:int=0) {
			super.setLevel(nlevel);
			if (currentWeapon) {
				currentWeapon.damage*=1.25;
			}			
		}
		
		public override function attack() {
			if (!sniper) mazil=(aiState==4)?5:16;		//стоя на месте стрельба точнее
			if (aiAttackOch==0 && shok<=0 && (celUnit!=null && isrnd(0.1) || celUnit==null && isrnd(0.03))) currentWeapon.attack();	//стрельба одиночными
			if (aiAttackOch>0 && (!sniper || celUnit)) {										//стрельба очередями
				if (aiAttackT<=0) aiAttackT=Math.round((Math.random()*0.4+0.8)*aiAttackOch);
				if (aiAttackT>aiAttackOch*0.25) currentWeapon.attack();
				aiAttackT--;
			}
			if ((celDX*celDX+celDY*celDY<100*100) && isrnd(0.1)) attKorp(celUnit,0.5);
			if (thWeapon) {
				t_gren--;
				if (t_gren<=0) {
					if (celUnit && isrnd()) thWeapon.attack();
					t_gren=Math.round(Math.random()*150+50);
				}
			}
		}
		
		public override function animate() {
			var cframe:int;
			var revers:Boolean=false;
			//поворот
			if (sost==2 || sost==3) { //сдох
				if (stay) {
					if (animState=='fall') {
					} else if (animState=='death') animState='fall';
					else animState='die';
				} else animState='death';
			} else {
				if (stay) {
					if  (dx==0) {
						animState='stay';
					} else if (walker && (aiState<=1 || aiState==4)) {
						animState='walk';
						sndStep(anims[animState].f,1);
					} else {
						animState='trot';
						if (aiNapr*storona<0) revers=true;
						sndStep(anims[animState].f,1);
					}
				} else if (isFly || aiPlav || levit) {
					animState='fly';
				} else {
					animState='stay';
				}
			}
			if (animState!=animState2) {
				anims[animState].restart();
				animState2=animState;
			}
			if (!anims[animState].st) {
				if (revers) blit(anims[animState].id,anims[animState].maxf-anims[animState].f-1);
				else blit(anims[animState].id,anims[animState].f);
			}
			anims[animState].step();
		}
	}
}

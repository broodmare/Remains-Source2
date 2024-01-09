package fe.unit {
	import fe.*;
	import fe.serv.BlitAnim;
	import fe.weapon.Weapon;
	import fe.weapon.WThrow;
	import flash.display.MovieClip;
	import flash.geom.Point;
	
	public class UnitMerc extends UnitRaider{
		
		var arm:MovieClip;
		var thWeapon:Weapon;
		var t_gren:int=Math.round(Math.random()*150+50);
		
		public function UnitMerc(cid:String=null, ndif:Number=100, xml:XML=null, loadObj:Object=null) {
			parentId='merc';
			flyer=true;
			kolTrs=1;
			super(cid, ndif, xml, loadObj);
			//if (msex) wPos=BlitAnim.wPosRaider1;
			//else wPos=BlitAnim.wPosRaider2;
			tupizna=10;
			visionMult=1.5;
			maxSpok=50;
			wPos=BlitAnim.wPosGriffon1;
			arm=Res.getVis('visualGrifArm'+tr, visualGrifArm1);
			if (grenader>0) {
				thWeapon=Weapon.create(this,'mercgr');
				(thWeapon as WThrow).kolAmmo=grenader;
				childObjs.push(thWeapon);
			}
		}
		
		public override function addVisual() {
			if (disabled) return;
			trigDis=!checkTrig();
			if (trigDis) return;
			super.addVisual();
			if (arm) World.w.grafon.visObjs[sloy].addChild(arm);
			if (cTransform) arm.transform.colorTransform=cTransform;
			if (currentWeapon) {
				currentWeapon.recoil=0;
				currentWeapon.recoilUp*=0.25;
			}
		}
		public override function remVisual() {
			super.remVisual();
			try {
				World.w.grafon.visObjs[sloy].removeChild(arm);
			} catch (err) {}
		}
		public override function setVisPos() {
			if (vis) {
				vis.x=X,vis.y=Y;
				vis.scaleX=storona;
			}
			if (arm) {
				if (currentWeapon) arm.rotation=currentWeapon.rot*180/Math.PI+90*(1-storona);
				arm.scaleX=storona;
			}
		}
		//задать положение оружия
		public override function setWeaponPos(tip:int=0) {
			if (arm==null || arm.parent==null) {
				super.setWeaponPos(tip);
				return;
			}
			var p:Point, p1:Point;
			p=new Point(arm.emit.x,arm.emit.y);
			p1=arm.localToGlobal(p);
			p1=vis.parent.globalToLocal(p1);
			weaponX=p1.x;
			weaponY=p1.y;
		}
		
		public override function dropLoot() {
			budilo(2000);
			arm.visible=false;
			super.dropLoot();
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
				if (arm) arm.visible=false;
				if (stay) {
					if (animState=='fall') {
					} else if (animState=='death') animState='fall';
					else animState='die';
				} else animState='death';
			} else {
				if (stay) {
					if  (dx==0) {
						animState='stay';
					} else {
						animState='walk';
						if (aiNapr*storona<0) revers=true;
						//sndStep(anims[animState].f,1);
					}
				} else if (isFly || aiPlav || levit) {
					animState='fly';
				} else {
					animState='jump';
					anims[animState].setStab((dy*0.6+8)/16);
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
			//положение руки
			var obj:Object=wPos[anims[animState].id][Math.floor(anims[animState].f)];
				arm.x=X+(obj.x+visBmp.x)*storona;
				arm.y=Y+obj.y+visBmp.y;
		}
	}
}

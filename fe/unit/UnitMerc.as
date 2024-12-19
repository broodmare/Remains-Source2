package fe.unit {
	
	import fe.*;
	import fe.serv.BlitAnim;
	import fe.serv.AnimationSet;
	import fe.weapon.Weapon;
	import fe.weapon.WThrow;
	import flash.display.MovieClip;
	import flash.geom.Point;
	
	public class UnitMerc extends UnitRaider {
		
		var arm:MovieClip;
		var thWeapon:Weapon;
		var t_gren:int=Math.round(Math.random()*150+50);
		
		// Constructor
		public function UnitMerc(cid:String=null, ndif:Number=100, xml:XML=null, loadObj:Object=null) {
			parentId='merc';
			flyer=true;
			kolTrs=1;
			super(cid, ndif, xml, loadObj);
			tupizna=10;
			visionMult=1.5;
			maxSpok=50;
			wPos = AnimationSet.getWeaponOffset("wPosGriffon1");
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
			}
			catch (err) {
				trace('ERROR: (00:8)');
			}
		}

		public override function setVisPos() {
			if (vis) {
				vis.x = coordinates.X;
				vis.y = coordinates.Y;
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
			var revers:Boolean=false;
			//поворот
			if (sost==2 || sost==3) { //сдох
				if (arm) arm.visible=false;
				if (stay) {
					if (animState=='fall') {
					} else if (animState=='death') animState='fall';
					else animState='die';
				} else animState='death';
			}
			else {
				if (stay) {
					if  (velocity.X == 0) {
						animState='stay';
					}
					else {
						animState='walk';
						if (aiNapr*storona<0) revers=true;
					}
				}
				else if (isFly || aiPlav || levit) {
					animState='fly';
				}
				else {
					animState='jump';
					// Commented out, there is no setStab function
					//anims[animState].setStab((dy*0.6+8)/16);
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
			
			// Far arm position
			var animId:int = anims[animState].id;			// 'id' is an integer index (0-3) which corresponds the current animation
			var frameIndex:int = int(anims[animState].f);	// Current frame of the animation (used to get the correct weapon position from wPos using animId as an index)

			// Validate 'animId' and 'frameIndex' before accessing
			if (animId >= 0 && animId < wPos.length) {
				var animFrames:Array = wPos[animId];
				
				if (animFrames != null) {
					if (frameIndex >= 0 && frameIndex < animFrames.length) {
						var obj:Object = animFrames[frameIndex];
						arm.x = coordinates.X + (obj.x + visBmp.x) * storona;
						arm.y = coordinates.Y + obj.y + visBmp.y;
					}
					else {
						trace("UnitMerc.as/animate() - Frame index out of bounds. animId:", animId, " frameIndex:", frameIndex, " total frames:", animFrames.length);
					}
				}
				else {
					trace("UnitMerc.as/animate() - animFrames is null for animId:", animId);
				}
			}
			else {
				trace("UnitMerc.as/animate() - animId out of bounds. animId:", animId, " total animIds:", wPos.length);
			}
		}
	}
}
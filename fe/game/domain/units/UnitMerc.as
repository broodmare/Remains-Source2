package fe.game.domain.units {
	
	import fe.game.domain.serv.BlitAnim;
	import fe.game.domain.serv.AnimationSet;
	import fe.game.domain.units.attack.SideWeaponAttack;
	import fe.game.domain.units.attack.SideWeaponAttack_Definition;
	import fe.game.domain.weapon.Weapon;
	import fe.game.domain.weapon.WThrow;
	import fe.engine.utils.Numbers;
	import fe.engine.utils.SymbolFactory;
	import fe.game.WeaponManager;
	import fe.game.GameContainer;
	import flash.display.MovieClip;
	import flash.geom.Point;

	// Griffon mercenaries: flying gunners with a far arm that holds the weapon, some with grenades
	public class UnitMerc extends UnitRaider {

		private static const GRENADE_CHANCE:Number = 0.5;		// Chance a grenade that is due is thrown

		private var arm:MovieClip;

		public function UnitMerc(cid:String = null, ndif:Number = 100.0, xml:XML = null, loadObj:Object = null) {
			var grenadeDefinition:SideWeaponAttack_Definition = new SideWeaponAttack_Definition();
			var grenades:WThrow;
			var armClass:Class;

			parentId = "merc";
			flyer = true;
			kolTrs = 1;
			tupizna = 10;
			visionMult = 1.5;
			maxSpok = 50;
			super(cid, ndif, xml, loadObj);
			wPos = AnimationSet.getWeaponOffset("wPosGriffon1");
			armClass = SymbolFactory.fetchSymbolClass("visualGrifArm" + String(tr)) || SymbolFactory.fetchSymbolClass("visualGrifArm1");
			arm = new armClass() as MovieClip;

			if (grenader > 0) {
				grenades = WeaponManager.reference.cloneWeapon("mercgr", this) as WThrow;
				grenades.kolAmmo = grenader;
				childObjs.push(grenades);
				grenadeDefinition.chance = GRENADE_CHANCE;
				attacks.push(new SideWeaponAttack(this, grenadeDefinition, grenades, null));
			}

			// Griffons keep their aim while levitated, and their walk makes no footstep sounds
			gunDefinition.isShakenWhenLifted = false;

			animatorDefinition.trot = "walk";
			animatorDefinition.run = "walk";
			animatorDefinition.walkStep = 0;
			animatorDefinition.backpedal = "walk";
			animatorDefinition.fly = "fly";
			animatorDefinition.levitate = "fly";
			animatorDefinition.swim = "fly";
		}
		
		public override function addVisual():void {
			if (disabled) {
				return;
			}
			
			trigDis=!checkTrig();
			
			if (trigDis) {
				return;
			}
			
			super.addVisual();
			
			if (arm) {
				GameContainer.reference.grafon.visObjs[layer].addChild(arm);
			}
			
			if (cTransform) {
				arm.transform.colorTransform = cTransform;
			}
			
			if (currentWeapon) {
				currentWeapon.recoil = 0;
				currentWeapon.recoilUp *= 0.25;
			}
		}

		public override function remVisual():void {
			super.remVisual();
			
			try {
				GameContainer.reference.grafon.visObjs[layer].removeChild(arm);
			}
			catch (err:Error) {
				trace('ERROR: (00:8)');
			}
		}

		public override function setVisPos():void {
			super.setVisPos();
			
			if (arm) {
				if (currentWeapon) {
					arm.rotation = currentWeapon.rot * Numbers.RAD_TO_DEG + 90 * (1 - storona.X);
				}
				
				arm.scaleX=storona.X;
			}
		}
		
		//задать положение оружия
		public override function setWeaponPos(tip:String = "internal"):void {
			if (arm==null || arm.parent==null) {
				super.setWeaponPos(tip);
				return;
			}
			
			var p:Point, p1:Point;
			p = new Point(arm.emit.x, arm.emit.y);
			p1 = arm.localToGlobal(p);
			p1 = arm.parent.globalToLocal(p1);
			weaponX=p1.x;
			weaponY=p1.y;
		}
		
		public override function dropLoot():void {
			budilo(2000);
			arm.visible = false;
			super.dropLoot();
		}
		
		public override function animate():void {
			var animId:int;
			var frameIndex:int;
			var animFrames:Array;
			var obj:Object;

			if ((sost == 2 || sost == 3) && arm) {
				arm.visible = false;
			}

			super.animate();

			// Far arm position, from the weapon offsets of the current animation frame
			animId = anims[animState].id;
			frameIndex = int(anims[animState].f);
			if (animId < 0 || animId >= wPos.length) {
				trace("UnitMerc.as/animate() - Warning: animId out of bounds. animId: " + animId + " total animIds: " + wPos.length);
				return;
			}

			animFrames = wPos[animId];
			if (animFrames == null) {
				trace("UnitMerc.as/animate() - Warning: animFrames is null for animId: " + animId);
				return;
			}

			if (frameIndex < 0 || frameIndex >= animFrames.length) {
				trace("UnitMerc.as/animate() - Warning: Frame index out of bounds. animId: " + animId + " frameIndex: " + frameIndex + " total frames: " + animFrames.length);
				return;
			}

			obj = animFrames[frameIndex];
			arm.x = coordinates.X + (obj.x + cellLeft) * storona.X;
			arm.y = coordinates.Y + obj.y + cellTop;
		}
	}
}
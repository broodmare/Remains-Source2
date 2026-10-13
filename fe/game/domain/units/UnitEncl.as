package fe.game.domain.units {

	import flash.display.MovieClip;

	import fe.engine.utils.SymbolFactory;
	import fe.game.WeaponManager;
	import fe.game.domain.serv.AnimationSet;
	import fe.game.domain.units.attack.SideWeaponAttack;
	import fe.game.domain.units.attack.SideWeaponAttack_Definition;
	import fe.game.domain.weapon.WThrow;

	// Enclave soldiers: flying pegasus gunners in power armour, some with grenades
	public class UnitEncl extends UnitRaider {

		private static const GRENADE_CHANCE:Number		= 0.5;		// Chance a grenade that is due is thrown
		private static const DAMAGE_BONUS:Number		= 1.2;		// Damage multiplier of the main weapon, applied twice below WEAK_DAMAGE
		private static const WEAK_DAMAGE:Number			= 20.0;

		public function UnitEncl(cid:String = null, ndif:Number = 100.0, xml:XML = null, loadObj:Object = null) {
			var grenadeDefinition:SideWeaponAttack_Definition = new SideWeaponAttack_Definition();
			var grenades:WThrow;

			parentId = "encl";
			flyer = true;
			kolTrs = 1;
			tupizna = 10;
			visionMult = 1.5;
			durak = false;
			allLink = true;
			maxSpok = 50;
			super(cid, ndif, xml, loadObj);
			wPos = AnimationSet.getWeaponOffset("wPosEncl1");

			if (grenader > 0) {
				grenades = WeaponManager.reference.cloneWeapon("mercgr", this) as WThrow;
				grenades.kolAmmo = grenader;
				childObjs.push(grenades);
				grenadeDefinition.chance = GRENADE_CHANCE;
				attacks.push(new SideWeaponAttack(this, grenadeDefinition, grenades, null));
			}

			if (enclWeap) {
				isDropArm = false;

				if (currentWeapon) {
					currentWeapon.svis = "encl";
					currentWeapon.vis = SymbolFactory.createInstance("visencl") as MovieClip;
				}
			}

			if (currentWeapon.damage < WEAK_DAMAGE) {
				currentWeapon.damage *= DAMAGE_BONUS;
			}

			currentWeapon.damage *= DAMAGE_BONUS;

			// Power armour keeps its aim while levitated
			gunDefinition.isShakenWhenLifted = false;

			animatorDefinition.backpedal = "trot";
			animatorDefinition.fly = "fly";
			animatorDefinition.levitate = "fly";
			animatorDefinition.swim = "fly";
			animatorDefinition.jump = "stay";
		}

		public override function addVisual():void {
			if (disabled) return;
			trigDis=!checkTrig();
			if (trigDis) return;
			super.addVisual();
			if (currentWeapon) {
				currentWeapon.recoil=0;
				currentWeapon.recoilUp*=0.25;
			}
		}

		public override function setLevel(nlevel:int=0):void {
			super.setLevel(nlevel);
			if (currentWeapon) {
				currentWeapon.damage *= 1.25;
			}
		}
	}
}
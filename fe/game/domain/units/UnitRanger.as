package fe.game.domain.units {

	import fe.game.WeaponManager;
	import fe.game.domain.serv.AnimationSet;
	import fe.game.domain.units.attack.SideWeaponAttack;
	import fe.game.domain.units.attack.SideWeaponAttack_Definition;
	import fe.game.domain.weapon.Weapon;

	// Steel Rangers: armoured gunners with a shoulder rocket launcher, which sprays gas instead with no target in sight
	public class UnitRanger extends UnitRaider {

		private static const LAUNCHER_INTERVAL_MIN:int	= 50;		// Ticks between launcher shots, picked between these
		private static const LAUNCHER_INTERVAL_MAX:int	= 140;
		private static const ROCKET_BLAST:Number		= 0.8;		// Blast damage multiplier of the rockets
		private static const DAMAGE_BONUS:Number		= 1.2;		// Damage multiplier of the main weapon, applied twice below WEAK_DAMAGE
		private static const WEAK_DAMAGE:Number			= 20.0;
		private static const ALARM_OBSERVATION:int		= 5;		// Observation gained once alarmed

		public function UnitRanger(cid:String = null, ndif:Number = 100.0, xml:XML = null, loadObj:Object = null) {
			var launcherDefinition:SideWeaponAttack_Definition = new SideWeaponAttack_Definition();
			var rockets:Weapon;
			var gas:Weapon;

			parentId = "ranger";
			kolTrs = 3;
			tupizna = 10;
			durak = false;
			allLink = true;
			super(cid, ndif, xml, loadObj);
			isDropArm = false;
			plusObserv = ALARM_OBSERVATION;
			wPos = AnimationSet.getWeaponOffset("wPosRanger1");

			rockets = WeaponManager.reference.cloneWeapon("robomlau", this);
			gas = WeaponManager.reference.cloneWeapon("robogas", this);
			rockets.damageExpl *= ROCKET_BLAST;
			childObjs.push(rockets, gas);

			if (currentWeapon.damage < WEAK_DAMAGE) {
				currentWeapon.damage *= DAMAGE_BONUS;
			}

			currentWeapon.damage *= DAMAGE_BONUS;

			// Power armour keeps its aim while levitated and on ladders
			gunDefinition.isShakenWhenLifted = false;
			gunDefinition.whileClimbing = true;

			launcherDefinition.intervalMin = LAUNCHER_INTERVAL_MIN;
			launcherDefinition.intervalMax = LAUNCHER_INTERVAL_MAX;
			attacks.push(new SideWeaponAttack(this, launcherDefinition, rockets, gas));

			animatorDefinition.levitate = "";
			animatorDefinition.swim = "";
		}
	}
}
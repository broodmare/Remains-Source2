package fe {

	import fe.unit.Armor;

	public class ArmorFactory {

		// Initialize a base set of armor using the data passed to this function
		public static function createArmor(data:Object):Armor {
			var armor = new Armor();
			
			if ("id" in data) {
				armor.id = data.id;
			}

			if ("tip" in data) {
				armor.tip = data.tip;
			}

			if ("clo" in data) {
				armor.clo = data.clo;
			}

			if ("upgrades" in data) {
				armor.maxlvl = data.upgrades;
			}

			if ("unbreakable" in data) {
				armor.und = data.unbreakable;
			}

			if ("hp" in data) {
				armor.hp = data.hp;
				armor.maxhp = data.maxhp;
			}

			if ("noRepair" in data) {
				armor.norep = data.noRepair;
			}

			if ("h2oMult" in data) {
				armor.h2oMult = data.h2oMult;
			}

			if ("tre" in data) {
				armor.tre = data.tre;
			}

			if ("meleeMult" in data) {
				armor.meleeMult = data.meleeMult;
			}

			if ("gunsMult" in data) {
				armor.gunsMult = data.gunsMult;
			}

			if ("magicMult" in data) {
				armor.magicMult = data.magicMult;
			}

			if ("crit" in data) {
				armor.crit = data.crit;
			}

			// Get the name of the item needed to repair this armor set, if one doesn't exist use "id_comp"
			if ("idComp" in data) {
				armor.idComp = data.idComp;
			}
			else {
				armor.idComp = armor.id + "_comp";
			}

			if ("kolComp" in data) {
				armor.kolComp = data.kolComp;
			}

			if ("price" in data) {
				armor.price = data.price;
			}

			if ("sort" in data) {
				armor.sort = data.sort;
			}

			if ("abil" in data) {
				armor.abil = data.abil;
			}

			if ("ableFly" in data) {
				armor.ableFly = data.ableFly;
			}

			if ("hideMane" in data) {
				armor.hideMane = data.hideMane;
			}

			if ("radx" in data) {
				armor.radVul = 1 - data.radx;
			}

			if ("dexter" in data) {
				armor.dexter = data.dexter;
			}

			if ("sneak" in data) {
				armor.sneak = data.sneak;
			}

			if ("maxmana" in data) {
				armor.maxmana = data.maxmana;
			}

			if ("act" in data) {
				armor.dmana_act = data.act;
			}

			if ("used" in data) {
				armor.dmana_use = data.used;
			}

			if ("res" in data) {
				armor.dmana_res = data.res;
			}

			return armor;
		}
	}
}
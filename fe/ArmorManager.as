package fe {

	import flash.utils.Dictionary;

	import fe.unit.Armor;

	public class ArmorManager {

		private static const _armorPath:String = "Modules/core/AllData/armors.json";
		public static var reference:ArmorManager;		// Publically acessable reference to this instance

		private static var _armorData:Object;			// An object containing the JSON data of all armor sets
		private static var _armors:Vector.<Armor>;		// Vector that stores a contigious collection of <Armor> references for fast iteration
		private static var _armorMap:Dictionary;		// Dictionary to map each armor.id to a reference to the Armor (Key-Pair)

		// Constructor
		public function ArmorManager() {
			
			reference	= this;
			_armors		= new Vector.<Armor>();
			_armorMap	= new Dictionary();

			loadArmorData();
			initializeAllArmors();
		}

		private function loadArmorData():void {
			
			// Create the JSON loader
			var loader:TextLoader = new TextLoader();

			// Load the data for all armor sets into memory
			_armorData = loader.syncLoad(_armorPath);
		}

		private function initializeAllArmors():void {

			// Initialize and store a base version of each armor set
			for each (var data:Object in _armorData) {
				var armor:Armor = new Armor();

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

				// TODO: This won't work as-is because armors are always initialized at lvl 0 
				setArmorLevel(armor);

				_armors.push(armor)
				_armorMap[armor.id] = armor;
			}
		}

		// Set the armor set's protection stats based on it's upgrade level
		public static function setArmorLevel(armor:Armor):void {
			// Get the localized name of the armor set
			armor.nazv = LanguageManager.reference.localText("armor", armor.id);
			
			// Indicate in the name if the armor is upgraded
			if (armor.lvl > 0) {
				armor.nazv += " - " + armor.lvl;
			}

			// Retrieve the level-specific data for the armor set
			var data:Object = _armorData[armor.id].upd[armor.lvl];
			
			// Create the armor's resistance values
			armor.resistances.importResistances(data);

			// If this is armor (not an amulet) make it weak to pink cloud
			if (armor.tip == 1) {
				armor.resistances.changeResist("pinkCloud", -0.50);
			}

			// Get upgrade-level dependant stats
			if ("armor" in data) {
				armor.armor = data.armor;
			}

			if ("marmor" in data) {
				armor.marmor = data.marmor;
			}

			if ("armorQual" in data) {
				armor.armorQual = data.armorQual;
			}

			if ("radx" in data) {
				armor.radVul = 1 - data.radx;
			}

			if ("dexter" in data) {
				armor.dexter = data.dexter;
			}

			if ("sneak" in data) {
				armor.sneak = data.sneak;
				armor.showObsInd = true;
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
		}

		public function damage(armor:Armor, dam:Number, tip:String):void {
			// This armor set is invulnerable, don't do anything
			if (armor.und) {
				return;
			}

			if (tip != "venom" && tip != "emp" && tip != "poison" && tip != "bleed" && tip != "inside") {
				dam *= 1 - armor.resistances.getResist(tip);
				
				if (tip == "acid") {
					dam *= 2;
				}
				
				if (tip == "pinkCloud") {
					dam *= 3;
				}
				
				armor.hp -= dam;
				
				// If the armor broke from the damage received, set the HP to 0 and remove the armor from the player
				if (armor.hp < 0) {
					armor.hp = 0;
					World.w.gg.changeArmor("off");
				}
			}
			
			setArmor(armor);
		}

		public function repair(armor:Armor, nhp:int):void {
			armor.hp += nhp;
			
			if (armor.hp > armor.maxhp) {
				armor.hp = armor.maxhp;
			}
			
			setArmor(armor);
		}
		
		
		// Update the armor's effectiveness based on it's condition
		public function setArmor(armor:Armor):void {
			if (armor.owner && armor.active) {
				var koef:Number = 1.00;
				
				if (armor.hp < armor.maxhp / 2) {
					koef = 0.5 + armor.hp / armor.maxhp;
				}
				
				armor.owner.armor		= armor.armor * koef;
				armor.owner.marmor		= armor.marmor * koef;
				armor.owner.armorQual	= armor.armorQual * koef;
			}
		}

		public static function upgradeArmor(armor:Armor):void {
			// This armor is already fully upgraded, do nothing
			if (armor.lvl >= armor.maxlvl) {
				return;
			}

			// Increase the armor level and update the stats
			armor.lvl++;
			setArmorLevel(armor);
		}

		public static function upgradeComponentsNeeded(armor:Armor):int {
			if (armor.lvl + 1 < armor.maxlvl) {
				return _armorData[armor.id].upd[armor.lvl + 1].kol;
			}
			
			return 0;
		}

		// Returns an entire new deep copy of a set of armor, NOT just the reference
		public static function cloneArmor(id:String):Armor {
			if (_armorMap[id] == null) {
				throw new ArgumentError("Could not clone armor set: " + id);
			}

			var armor:Object = Cloner.deepClone(_armorMap[id]);
			var clonedArmor:Armor = armor as Armor;

			if (clonedArmor == null) {
				throw new ArgumentError("Cloning failed: Object: " + id + " is not compatible with the Armor type.");
			}

			return clonedArmor;
		}
	}
}
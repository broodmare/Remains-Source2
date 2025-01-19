package fe {

	import flash.utils.Dictionary;

	import fe.unit.Armor;
	import fe.unit.Resistances;

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
		}

		private function loadArmorData():void {
			
			// Create the JSON loader
			var loader:TextLoader = new TextLoader();

			// Load the data for all armor sets into memory
			_armorData = loader.syncLoad(_armorPath);
		}

		public function armorData(id:String):Object {
			if (id in _armorData) {
				return _armorData[id];
			}

			return {};
		}
		
		public function armor(id:String):Armor {
			if (id in _armors) {
				return _armorData[id];
			}

			return null;
		}

		// Returns an array of references to ALL armor sets
		public function get armors():Vector.<Armor> {
			return _armors;
		}

		public function cloneArmor(id:String):Armor {
			
			var data:Object = _armorData[id];
			var armor:Armor = ArmorFactory.createArmor(data);

			

			// TODO: This won't work as-is because armors are always initialized at lvl 0 
			setArmorLevel(armor);

			return armor;
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
			var lvlData:Object = _armorData[armor.id].upd[armor.lvl];
			
			// Create the armor's resistance values
			armor.resistances.importResistances(lvlData);

			// If this is armor (not an amulet) make it weak to pink cloud
			if (armor.tip == 1) {
				armor.resistances.changeResist(Resistances.DAM_PINKCLOUD, -0.50);
			}

			// Get upgrade-level dependant stats
			if ("armor" in lvlData) {
				armor.armor = lvlData.armor;
			}

			if ("marmor" in lvlData) {
				armor.marmor = lvlData.marmor;
			}

			if ("armorQual" in lvlData) {
				armor.armorQual = lvlData.armorQual;
			}

			if ("radx" in lvlData) {
				armor.radVul = 1 - lvlData.radx;
			}

			if ("dexter" in lvlData) {
				armor.dexter = lvlData.dexter;
			}

			if ("sneak" in lvlData) {
				armor.sneak = lvlData.sneak;
				armor.showObsInd = true;
			}

			if ("maxmana" in lvlData) {
				armor.maxmana = lvlData.maxmana;
			}

			if ("act" in lvlData) {
				armor.dmana_act = lvlData.act;
			}

			if ("used" in lvlData) {
				armor.dmana_use = lvlData.used;
			}

			if ("res" in lvlData) {
				armor.dmana_res = lvlData.res;
			}
		}

		public function damage(armor:Armor, dam:Number, tip:String):void {
			// This armor set is invulnerable, don't do anything
			if (armor.und) {
				return;
			}

			if (tip != Resistances.DAM_VENOM && tip != Resistances.DAM_EMP && tip != Resistances.DAM_POISON && tip != Resistances.DAM_BLEED && tip != Resistances.DAM_INTERNAL) {
				dam *= 1 - armor.resistances.getResist(tip);
				
				if (tip == Resistances.DAM_ACID) {
					dam *= 2;
				}
				
				if (tip == Resistances.DAM_PINKCLOUD) {
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
				
				if (armor.hp < armor.maxhp * 0.50) {
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
	}
}
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
		
		// Original resistance names used in the armor data mapped to their damage types
		private static const RESIST_KEYS:Object = {
			bul: Resistances.DAM_PIERCE,	blade: Resistances.DAM_CUT,		phis: Resistances.DAM_BLUNT,	fire: Resistances.DAM_BURN,
			expl: Resistances.DAM_EXPLOSION,	laser: Resistances.DAM_LASER,	plasma: Resistances.DAM_PLASMA,	venom: Resistances.DAM_VENOM,
			spark: Resistances.DAM_ELECTRIC,	acid: Resistances.DAM_ACID,		cryo: Resistances.DAM_COLD,		fang: Resistances.DAM_BITE,
			necro: Resistances.DAM_DEATH
		};

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
			
			// Create a default copy of every armor set (used for lists of all armor, eg. the weapon stand)
			for (var id:String in _armorData) {
				var armor:Armor = cloneArmor(id);
				_armors.push(armor);
				_armorMap[id] = armor;
			}
			
			// Ties are sorted by ID, the order of the JSON data isn't kept so the order would change between sessions otherwise
			_armors.sort(function(a:Armor, b:Armor):int {
				if (a.sort != b.sort) {
					return a.sort - b.sort;
				}
				return (a.id < b.id) ? -1 : ((a.id > b.id) ? 1 : 0);
			});
		}
		
		public function hasArmor(id:String):Boolean {
			return id != null && _armorData[id] != null;
		}

		public function armorData(id:String):Object {
			if (id in _armorData) {
				return _armorData[id];
			}

			return {};
		}
		
		// The default copy of an armor set, use cloneArmor() to get one that can be used
		public function armor(id:String):Armor {
			return _armorMap[id] as Armor;
		}

		// Returns an array of references to ALL armor sets
		public function get armors():Vector.<Armor> {
			return _armors;
		}

		// Create a new armor set, a level of -1 means it's a blueprint that hasn't been crafted yet
		public function cloneArmor(id:String, lvl:int = 0):Armor {
			var data:Object = _armorData[id];
			if (data == null) {
				trace("ArmorManager.as/cloneArmor() - Error: Unknown armor: \"" + id + "\"");
				return null;
			}
			
			var armor:Armor = ArmorFactory.createArmor(data);
			armor.lvl = lvl;
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

			// Retrieve the level-specific data for the armor set (blueprints use the first level)
			var lvlData:Object = _armorData[armor.id].upd[Math.max(armor.lvl, 0)];
			
			// Create the armor's resistance values
			armor.resistances.importResistances(lvlData);
			
			for (var key:String in RESIST_KEYS) {
				if (key in lvlData) {
					armor.resistances.setResist(RESIST_KEYS[key], lvlData[key]);
				}
			}

			// If this is armor (not an amulet) make it weak to pink cloud
			if (armor.tip == Armor.TYPE_ARMOR) {
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
			var upgrades:Array = _armorData[armor.id].upd;
			
			if (armor.lvl + 1 < upgrades.length) {
				return upgrades[armor.lvl + 1].kol;
			}
			
			return 0;
		}
	}
}
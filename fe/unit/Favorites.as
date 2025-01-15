package fe.unit {

	public class Favorites {

		public var fav:Array		= [];	// [Array of favorites by cell number]
		public var favIds:Array		= [];	// [Array of favorites by item id]

		// Constructor
		public function Favorites(saveDataObject:Object = null) {
			/*
			if (saveDataObject != null) {
				loadFavorites(saveDataObject);
			}
			*/
		}

		public function useFav(n:int):void {
			/*
			// This function is called with an integer (assumed 1-9) and that's used as an index to get the ID of the item for that number
			var ci:String = fav[n];
			
			// Index returned nothing, abort
			if (ci == null) {
				return;
			}
			
			var ID:String;

			// Check the weaponlist for the ID we retrieved
			ID = itemManager.getWeapon(ci).id;
			if (ID) {
				gg.changeWeapon(ci);
				return;
			}
			
			// We didn't find it, check the armorList for the ID
			ID = itemManager.getArmor(ci).id
			if (ID) {
				gg.changeArmor(ci);
				return;
			}
			
			// We still didn't find it, check the itemList for the ID
			ID = itemManager.getItem(ci).id
			if (ID) {
				useItem(ci);
			}
			else {
				trace("Favorites.as/useFav() - Tried to use favorite item: " + ci);
			}
			*/
		}

		public function favItem(id:String, cell:int):void {
			/*
			if (gg && (cell==29 || cell==30)) {
				if (weapons[id]==null || (weapons[id].tip!=4 && weapons[id].tip!=5) || weapons[id].spell) {
					World.w.gui.infoText('onlyExpl');
					return;
				}
				if (cell == 29) {
					if (gg.throwWeapon && id == gg.throwWeapon.id) {
						gg.throwWeapon = null;
					}
					else {
						gg.throwWeapon = weapons[id];
						gg.throwWeapon.setNull();
						gg.throwWeapon.setPers(gg, gg.pers);
						gg.throwWeapon.addVisual();
						
						if (gg.throwWeapon.tip==4) {
							gg.throwWeapon.remVisual();
						}
					}
				}
				if (cell==30) {
					if (gg.magicWeapon && id==gg.magicWeapon.id) gg.magicWeapon=null;
					else {
						gg.magicWeapon=weapons[id];
						gg.magicWeapon.setNull();
						gg.magicWeapon.setPers(gg,gg.pers);
						gg.magicWeapon.addVisual();
						
						if (gg.magicWeapon.tip==4) {
							gg.magicWeapon.remVisual();
						}
					}
				}
			}
			
			if (cell<29 && cell>=25) {
				if (itemManager.getItem(id).tip != "magic") {
					World.w.gui.infoText('onlySpell');
					return;
				}
			}
			
			var prevCell:int = favIds[id];
			var prevId:int = fav[cell];
			
			if (fav[prevCell]) {
				fav[prevCell] = null;
			}
			
			if (favIds[prevId]) {
				favIds[prevId] = null;
			}
			
			if (prevCell != cell) {
				fav[cell] = id;
				favIds[id] = cell;
			}

			*/
		}

		public function save():Object {
				/*
				var obj:Object = new Object;
				obj.fav = [];

				var w;

				for (w in fav) {
					obj.fav[w] = fav[w];
				}
				
				return obj;
				*/
				return {};
		}
		
		public function addLoad(saveData:Object):void {
			/*
			// Restore the player's favorites
			for (w in saveData.fav) {
				favItem(saveData.fav[w], w);
			}
			*/
		}
	}
}
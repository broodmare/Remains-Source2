package fe.unit {

	// The items assigned to the hotkey cells, ItemInteraction.favItem() and useFav() handle the gameplay side
	public class Favorites {

		// [Cells 1-24 are item hotkeys, 25-28 are spells, 29 is the explosive and 30 is the spell used by their own keys]
		public static const CELL_THROW:int	= 29;
		public static const CELL_MAGIC:int	= 30;

		public var fav:Array		= [];	// [Array of favorites by cell number]
		public var favIds:Object	= {};	// [Array of favorites by item id]

		// Constructor
		public function Favorites() {

		}

		public function getCell(id:String):int {
			return (id in favIds) ? favIds[id] : -1;
		}

		// Put an item in a cell, putting it in the cell it's already in removes it
		public function setFavorite(id:String, cell:int):void {
			var prevCell:int = getCell(id);
			var prevId:String = fav[cell];

			if (prevCell >= 0) {
				fav[prevCell] = null;
				delete favIds[id];
			}

			if (prevId != null) {
				delete favIds[prevId];
				fav[cell] = null;
			}

			if (prevCell != cell) {
				fav[cell] = id;
				favIds[id] = cell;
			}
		}

		// Remove an item from the favorites (eg. it was sold)
		public function removeFavorite(id:String):void {
			var cell:int = getCell(id);

			if (cell >= 0) {
				fav[cell] = null;
				delete favIds[id];
			}
		}

		// Change the ID of a favorite, used when converting old saves
		public function renameFavorite(oldId:String, newId:String):void {
			var cell:int = getCell(oldId);

			if (cell >= 0) {
				delete favIds[oldId];
				fav[cell] = newId;
				favIds[newId] = cell;
			}
		}

		public function save():Object {
			var obj:Object = {};

			for (var cell:String in fav) {
				if (fav[cell] != null) {
					obj[cell] = fav[cell];
				}
			}

			return obj;
		}

		public function load(saveData:Object):void {
			fav = [];
			favIds = {};

			// Restore the player's favorites
			for (var cell:String in saveData) {
				if (saveData[cell] != null) {
					setFavorite(saveData[cell], int(cell));
				}
			}
		}
	}
}

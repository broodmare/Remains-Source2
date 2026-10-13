package fe.engine {

	import flash.net.SharedObject;

	import fe.game.GameContainer;
	import fe.game.World;
	import fe.game.ui.GUIManager;

	// The user's settings and the save slots on disk, and writing the current game into them
	public class SaveManager {

		public static var reference:SaveManager;		// Publically accessable reference to this instance

		private static const CONFIG_NAME:String			= "RemainsConfig";	// Shared object names; a slot's name ends in its number
		private static const SAVE_NAME:String			= "RemainsSave";
		private static const LEGACY_CONFIG_NAME:String	= "config";			// The names vanilla and older builds stored under
		private static const LEGACY_SAVE_NAME:String	= "PFEgame";

		private var saveArr:Vector.<SharedObject>;		// One shared object per slot

		public var configObj:SharedObject;				// The user's stored settings
		public var saveKol:int		= 10;				// Highest slot number
		public var t_save:int		= 0;				// Game frames since the autosave slot was last written
		public var loaddata:Object;						// [Data loaded from file]

		// Whether a store holds anything
		private static function hasData(store:SharedObject):Boolean {
			var key:String;
			for (key in store.data) { return true; }
			return false;
		}

		// Whether anything is stored under the current names yet
		private function hasCurrentData():Boolean {
			var slot:SharedObject;

			if (hasData(configObj)) {
				return true;
			}
			for each (slot in saveArr) {
				if (hasData(slot)) {
					return true;
				}
			}

			return false;
		}

		// Copies whatever is stored under the legacy names into the current ones; the legacy stores are only read
		private function importLegacy():void {
			var legacy:SharedObject;
			var configFound:Boolean = false;
			var slotsFound:int = 0;
			var i:int;

			legacy = SharedObject.getLocal(LEGACY_CONFIG_NAME, null);
			if (hasData(legacy)) {
				SaveConverter.convertConfig(legacy.data, configObj.data);
				configObj.flush();
				configFound = true;
			}

			for (i = 0; i <= saveKol; i++) {
				legacy = SharedObject.getLocal(LEGACY_SAVE_NAME + i, null);
				if (hasData(legacy)) {
					SaveConverter.convertSave(legacy.data, saveArr[i].data);
					saveArr[i].flush();
					slotsFound++;
				}
			}

			trace("SaveManager.as/importLegacy() - Info: legacy settings " + configFound + ", legacy slots " + slotsFound);
		}

		public function SaveManager() {
			var i:int;

			reference = this;
			configObj = SharedObject.getLocal(CONFIG_NAME, null);
			saveArr = new Vector.<SharedObject>();
			for (i = 0; i <= saveKol; i++) {
				saveArr.push(SharedObject.getLocal(SAVE_NAME + i, null));
			}

			// The first run under the current names starts from the legacy settings and saves, if there are any
			if (!hasCurrentData()) {
				importLegacy();
			}
		}

		// Writes the current game into data
		public function saveToObj(data:Object):void {
			var now:Date = new Date();

			data.game = GameContainer.reference.game.save();
			data.pers = GameContainer.reference.pers.save();
			data.invent = GameContainer.reference.gg.itemInteraction.save();
			data.app = GUIManager.reference.app.save();
			data.date = now.time;
			data.n = World.w.autoSaveN;
			data.hardInv = GameContainer.reference.hardInv;
			data.ver = GameContainer.reference.version;
			data.est = 1;
		}

		// Writes the current game into slot n; -1 autosaves unless one ran in the last 100 frames outside hardcore, -2 autosaves regardless
		public function saveGame(n:int = -1):void {
			var slot:int = n;
			var save:SharedObject;
			var status:String;

			if (n == -2) {
				save = saveArr[World.w.autoSaveN];
				saveToObj(save.data);
				save.flush();	// Save SharedObject to disk
				trace("SaveManager.as/saveGame() - End");
				return;
			}

			if (t_save < 100 && n == -1 && !GameContainer.reference.pers.hardcore) {
				return;
			}

			if (GUIManager.reference.pip.noAct) {
				return;
			}

			if (n == -1) {
				slot = World.w.autoSaveN;
			}

			if (slot < 0 || slot >= saveArr.length) {
				trace("SaveManager.as/saveGame() - Warning: there is no save slot " + slot);
				return;
			}

			save = saveArr[slot];
			saveToObj(save.data);
			status = save.flush();	// Save SharedObject to disk
			trace("SaveManager.as/saveGame() - Saving: " + status);

			// Differs from vanilla, which reset only on slot 0, so a hardcore game in another slot autosaved every frame
			if (slot == World.w.autoSaveN) {
				t_save = 0;
			}
		}

		// The data stored in slot n, or null if there is no such slot
		public function getSave(n:int):Object {
			if (n < 0 || n >= saveArr.length) {
				return null;
			}

			return saveArr[n].data;
		}

		// Deletes everything stored in slot n
		public function clearSave(n:int):void {
			saveArr[n].clear();
		}
	}
}
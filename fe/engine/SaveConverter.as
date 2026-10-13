package fe.engine {

	import flash.utils.ByteArray;

	// Copies settings and saves written by vanilla and older builds into the current format
	public class SaveConverter {

		// Auto-pickup switches, which legacy settings stored as numbers, 0 for on and 1 for off
		private static const AUTO_PICKUP_IDS:Vector.<String> = new <String>["vsWeaponNew", "vsWeaponRep", "vsAmmoAll",
			"vsAmmoTek", "vsExplAll", "vsMedAll", "vsHimAll", "vsEqipAll", "vsStuffAll", "vsVal", "vsBook", "vsFood",
			"vsComp", "vsIngr"];

		// Fills target with a deep copy of source, so nothing done to target reaches the legacy data
		private static function copyInto(source:Object, target:Object):void {
			var bytes:ByteArray = new ByteArray();
			var copy:Object;
			var key:String;

			bytes.writeObject(source);
			bytes.position = 0;
			copy = bytes.readObject();
			for (key in copy) {
				target[key] = copy[key];
			}
		}

		// Copies legacy settings into target in the current format
		public static function convertConfig(legacy:Object, target:Object):void {
			var id:String;

			copyInto(legacy, target);
			for each (id in AUTO_PICKUP_IDS) {
				if (target[id] is Number) {
					target[id] = (target[id] == 0);
				}
			}
		}

		// Copies a legacy save into target in the current format
		public static function convertSave(legacy:Object, target:Object):void {
			copyInto(legacy, target);
		}
	}
}

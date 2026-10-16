package fe.game.rendering.rig {

	import flash.utils.Dictionary;

	// What a rig wears: the style picked in each style group (counted from 1) and its armour set ("" for none)
	public class RigLook {
		public var styles:Dictionary	= new Dictionary();
		public var armor:String			= "";

		// The style picked in group, the first when none is
		public function styleOf(group:String):int {
			return styles[group] ? int(styles[group]) : 1;
		}

		// The same text for any two looks that wear the same images
		public function get key():String {
			var parts:Array = [];
			var group:String;

			for (group in styles) {
				parts.push(group + "=" + styles[group]);
			}
			parts.sort();

			return parts.join(",") + "|" + armor;
		}

		public function clone():RigLook {
			var result:RigLook = new RigLook();
			var group:String;

			for (group in styles) {
				result.styles[group] = styles[group];
			}
			result.armor = armor;

			return result;
		}
	}
}

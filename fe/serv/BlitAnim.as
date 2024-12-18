package fe.serv
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;

	// [Weapon locations for each frame of a sprite sheet's animation]
        /* id: Likely refers to the identifier for the sprite or animation sequence.
           firstf: Starting frame index.
           maxf: Total number of frames in the animation.
           retf: The frame to return to after the animation completes.
           replay: Boolean indicating if the animation should loop.
           stab: Boolean indicating if the animation is stable or should stop.
           f: Current frame index.
           df: Frame increment per tick (speed of animation).
        
          TODO: un-hardcode these to JSON files
        */

	public class BlitAnim {
		// Where the weapon offset JSON is stored
		private static var offsetPath:String = "Modules/core/spritesheets/weaponPositions.json"
		// Valid weapon offset keys
		private static var weaponOffsets:Array = ["wPosRaider1", "wPosRaider2", "wPosGutsy", "wPosAlicorn", "wPosAlicornBoss", "wPosGriffon1", "wPosZebra1", "wPosRanger1", "wPosEncl1"];
		// Dictionary to store the parsed JSON data
        private static var weaponData:Dictionary = new Dictionary();
		// Loader to load the JSON file
        private static var loader:URLLoader = new URLLoader();
        // Flag to check if data is loaded
        private static var isDataLoaded:Boolean = false;

		public var id:int = 0;				// [line number in the sprite sheet]
		public var firstf:int=0;			// [starting frame]
		public var maxf:int=1;				// [animation duration] (in frames?)
		public var retf:int=0;				// [the frame the animation returns to]
		public var replay:Boolean = false;	// [automatically repeat]
		public var st:Boolean = false;
		public var stab:Boolean = false;	// Holds the current frame at the end, eg. for jumping
		public var f:Number=0;				// [current frame]
		public var df:Number=1;				// [frames per tick]

		public function BlitAnim(xml:XML) {
			if (xml.@y.length())	id = xml.@y;
			if (xml.@len.length())	maxf = xml.@len;
			if (xml.@ff.length())	firstf = xml.@ff;
			if (xml.@rf.length())	retf = xml.@rf;
			if (xml.@df.length())	df = xml.@df;
			if (xml.@rep.length())	replay = true ;
			if (xml.@stab.length())	stab = true ;
			f = firstf;
		}

		// Function to get weapon offset by key
        public static function getWeaponOffset(key:String):Array {
            // Check if weapon offset data is loaded and if not, load it now
			if (!isDataLoaded) {
                trace("BlitAnim.as/getWeaponOffset() - Initializing weapon offset data");
				try {
					// Import data from the weapon offset JSON
					var file:File = File.applicationDirectory.resolvePath(offsetPath);
					var stream:FileStream = new FileStream();
					stream.open(file, FileMode.READ);
					var fileData:String = stream.readUTFBytes(stream.bytesAvailable);
					stream.close();

					// Parse JSON
					var parsedData:Object = JSON.parse(fileData);

					// Populate weaponData dictionary
					for each (var weaponKey:String in weaponOffsets) {
						if (parsedData.hasOwnProperty(weaponKey)) {
							weaponData[weaponKey] = parsedData[weaponKey];
						}
						else {
							trace("BlitAnim.as/getWeaponOffset() - Weapon key missing in JSON: " + weaponKey);
						}
					}

					isDataLoaded = true;
					trace("BlitAnim.as/getWeaponOffset() - Weapon offset data loaded successfully");

					// Return the requested key
					if (weaponData.hasOwnProperty(key)) {
						return weaponData[key];
					}
					else {
						trace("BlitAnim.as/getWeaponOffset() - Weapon position key not found after loading: " + key);
						return [];
					}
				}
				catch (error:Error) {
					trace("BlitAnim.as/getWeaponOffset() - Error loading/parsing JSON: " + error.message);
					return [];
				}
            }

            if (weaponData.hasOwnProperty(key)) {
                return weaponData[key];
            }
			else {
                trace("Weapon position key not found: " + key);
                return [];
            }
        }
		
		public function step() {
			if (stab) return;
			if (f < firstf + maxf - 1) f += df;
			else if (replay) f = retf;
			else st = true;
		}
		
		public function restart() {
			st = false;
			f = firstf;
		}
	}
}

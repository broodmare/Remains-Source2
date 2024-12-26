package fe.serv
{
    import flash.filesystem.File;
    import flash.filesystem.FileMode;
    import flash.filesystem.FileStream;
    import flash.utils.Dictionary;

    public class AnimationSet {

        private static var spriteSheetManifestPath:String = "Modules/core/spritesheets/spritesheets.json";
        private static var spritesheetData:Dictionary = new Dictionary();	// Stores information for animations for each spritesheet name
        private static var spritesheetDataLoaded:Boolean = false;

        // Where to position weapons for each animation
		private static var weaponOffsetFilePath:String = "Modules/core/spritesheets/weaponPositions.json"
        private static var weaponData:Dictionary = new Dictionary();	// Stores parsed weapon offset arrays
        private static var weaponOffsetsLoaded:Boolean = false;

        // Returns data for every animation for a given creature
        public static function loadAnimations(creatureID:String):Object {
            // Load sprite sheet data if it hasn't been done yet
            if (!spritesheetDataLoaded) {
                trace("AnimationSet.as/loadAnimations - Initializing spritesheet data");
                try {
                    // Resolve the path to the JSON file
                    var file:File = File.applicationDirectory.resolvePath(spriteSheetManifestPath);
                    var stream:FileStream = new FileStream();
                    stream.open(file, FileMode.READ);
                    
                    // Read the entire JSON file as a string
                    var fileData:String = stream.readUTFBytes(stream.bytesAvailable);
                    stream.close();

                    // Parse the JSON data
                    var parsedData:Object = JSON.parse(fileData);

                    // Load each sprite sheets data into the dictionary
                    for (var sheetKey:String in parsedData) {
                        spritesheetData[sheetKey] = parsedData[sheetKey];
                    }

                    spritesheetDataLoaded = true;
                    trace("AnimationSet.as/loadAnimations - Spritesheet data loaded successfully");
                }
                catch (error:Error) {
                    trace("AnimationSet.as/loadAnimations - Error loading/parsing spritesheet JSON: " + error.message);
                    return null;
                }
            }

            var blitAnims:Object = {};

            // Get all data for animations for the spritesheet
            var sheetData:Object = spritesheetData[creatureID];
            
            if (sheetData) {
                for (var animation:String in sheetData) {
                    var animData:Object = sheetData[animation];
                    
                    // Check if animData has at least one property
                    var hasProperties:Boolean = false;
                    for (var prop:String in animData) {
                        hasProperties = true;
                        break;
                    }
                    
                    if (hasProperties) {
                        // Store the animation by name (eg. "Fly")
                        blitAnims[animation] = new BlitAnim(animData);
                        //trace("AnimationSet.as/loadAnimations - Loaded animation: " + animation + " for creature " + creatureID);
                    }
                    else {
                        // Add a default BlitAnim with no animation
                        blitAnims[animation] = new BlitAnim({});
                        //trace("AnimationSet.as/loadAnimations - Added default animation for: " + animation + " in creature " + creatureID);
                    }
                }
                //trace("AnimationSet.as/loadAnimations - All animations for '" + creatureID + "' loaded successfully");
            }
            else {
                //trace("AnimationSet.as/loadAnimations - Creature ID not found: " + creatureID);
            }

            return blitAnims;
        }

        // Function to get weapon offset by key
        public static function getWeaponOffset(key:String):Array {
            // Check if weapon offset data is loaded and if not, load it now
			if (!weaponOffsetsLoaded) {
                trace("AnimationSet.as/getWeaponOffset() - Initializing weapon offset data");
				try {
					// Import data from the weapon offset JSON
					var file:File = File.applicationDirectory.resolvePath(weaponOffsetFilePath);
					var stream:FileStream = new FileStream();
					stream.open(file, FileMode.READ);
					var fileData:String = stream.readUTFBytes(stream.bytesAvailable);
					stream.close();

					// Parse JSON
					var parsedData:Object = JSON.parse(fileData);

					// Populate weaponData dictionary for each object in the JSON
					for (var weaponKey:String in parsedData) {
						weaponData[weaponKey] = parsedData[weaponKey];
					}

					weaponOffsetsLoaded = true;
					trace("AnimationSet.as/getWeaponOffset() - Weapon offset data loaded successfully");

					// Return the requested key
					if (weaponData.hasOwnProperty(key)) {
						return weaponData[key];
					}
					else {
						trace("AnimationSet.as/getWeaponOffset() - Weapon position key not found after loading: " + key);
						return [];
					}
				}
				catch (error:Error) {
					trace("AnimationSet.as/getWeaponOffset() - Error loading/parsing JSON: " + error.message);
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
    }
}
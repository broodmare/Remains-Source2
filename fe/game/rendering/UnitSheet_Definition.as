package fe.game.rendering {

	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.utils.Dictionary;

	import starling.textures.Texture;

	// One unit sprite sheet from data/core/spritesheets/units: where each animation's frames lie on it, and the sheet itself while it is loaded
	public class UnitSheet_Definition {
		public var name:String;										// Its key in units.json
		public var image:String;									// Its PNG, which other sheets can share; null when units.json lacks it
		public var density:Number				= 1.0;				// Sheet pixels per game pixel
		public var transform:Matrix;								// Places its frames in the unit's space, or null to leave them as drawn
		public var stateTransforms:Dictionary	= new Dictionary();	// By animation name, a Matrix placing its frames before transform, for the few that have one
		public var hubX:Number					= 0.0;				// Where the body turns and scales, in the unit's space: the inner clip's origin in Flash
		public var hubY:Number					= 0.0;
		public var animations:Dictionary		= new Dictionary();	// By animation name, its frames by column; null at a column it lacks
		public var repeats:Dictionary			= new Dictionary();	// By animation name, how often it plays before resting on its last frame; the rest loop
		public var bitmap:BitmapData;								// The decoded sheet, or null until it has decoded
		public var texture:Texture;									// The sheet on the GPU, or null until something shows it
	}
}
package fe.game.rendering {

	// One modifier from effects.json: how a texture is recoloured and blended where an effect uses it
	public class Modifier_Definition {
		public var ramp:Vector.<uint>;			// Colour and alpha by the texture's red value, 256 entries; null to keep its colours
		public var blend:String = "normal";		// The Starling blend mode it draws with
	}
}
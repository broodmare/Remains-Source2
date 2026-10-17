package fe.game.rendering {

	// One effect from effects.json: catalog textures through a modifier, still or keyed by an animation
	public class Effect_Definition {
		public var name:String;
		public var textures:Vector.<String>;	// Their names in textures/manifest.json; the first shows unless a key picks another
		public var modifier:String	= "";		// "" for none
		public var animation:String	= "";		// "" for a still
		public var scale:Number		= 1.0;		// Its size against the texture's drawSize
	}
}
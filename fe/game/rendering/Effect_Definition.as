package fe.game.rendering {

	// One effect from effects.json: a catalog texture through a modifier, still or keyed by an animation
	public class Effect_Definition {
		public var name:String;
		public var texture:String;				// Its name in textures/manifest.json
		public var modifier:String	= "";		// "" for none
		public var animation:String	= "";		// "" for a still
		public var scale:Number		= 1.0;		// Its size against the texture's drawSize
	}
}
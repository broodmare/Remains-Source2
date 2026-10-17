package fe.game.rendering {

	import flash.geom.ColorTransform;

	// One keyed animation from effects.json, worked out for every frame: its keys are joined in straight lines, and a frame
	// after the last key holds it
	public class EffectAnimation_Definition {
		public var scales:Vector.<Number>;			// Per frame
		public var tints:Vector.<ColorTransform>;	// Per frame, or null where the frame keeps its colours
		public var hidden:Vector.<Boolean>;			// Per frame, whether it draws nothing
		public var stops:Vector.<Boolean>;			// Per frame, whether the playhead stops once it reaches it
		public var textures:Vector.<int>;			// Per frame, which of the effect's textures it shows
		public var randomTurns:Vector.<Boolean>;	// Per frame, whether reaching it turns the effect to a random angle
	}
}
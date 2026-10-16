package fe.game.rendering.rig {

	import flash.utils.Dictionary;

	// Shows one group of drawings at a time, such as the eye open, wide, closed or squinting.
	// Drawings in none of its states are left alone.
	public class RigSwitch_Definition {
		public var name:String;
		public var initial:String;
		public var isPerAnimation:Boolean	= false;				// Goes back to initial whenever another animation starts
		public var states:Dictionary		= new Dictionary();		// Vector.<String> of the drawings shown, by state
	}
}

package fe.unit.motor.system {

	// Moves a unit the way its brain asks
	public interface IMotor {
		function tick():void;					// Per-tick upkeep, run before the brain decides anything
		function rethink():void;				// The brain has just picked a new state
		function idle():void;					// Stand still
		function patrol():void;					// Wander toward aiNapr
		function chase():void;					// Close in on the target point (celX, celY) heading aiNapr
		function hold():void;					// Stand ground facing the target
		function jump(power:Number):void;		// Jump, or swim upward, with a fraction of full strength
	}
}
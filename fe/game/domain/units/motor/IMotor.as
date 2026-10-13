package fe.game.domain.units.motor {

	import fe.engine.utils.Vec2;

	// Moves a unit the way its brain asks
	public interface IMotor {
		function tick():void;					// Per-tick upkeep, run before the brain decides anything
		function rethink():void;				// The brain has just picked a new state
		function idle():void;					// Stand still
		function patrol():void;					// Wander toward aiNapr
		function chase():void;					// Close in on the target point (celX, celY) heading aiNapr
		function rush():void;					// Run headlong toward aiNapr, as when fleeing or dashing, without taking to ladders
		function hold():void;					// Stand ground facing the target
		function leapBack():void;				// Leap away from the target
		function turnTo(direction:Vec2):void;	// Face a direction, as soon as the unit can turn
		function jump(power:Number):void;		// Jump, or swim upward, with a fraction of full strength
	}
}
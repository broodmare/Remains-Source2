package fe.game.enums {

	import fe.engine.utils.Vec2;

	public class E_Direction {
		public static const UP:Vec2			= new Vec2(  0.0, -1.0 );	// -Y is up
		public static const DOWN:Vec2		= new Vec2(  0.0,  1.0 );	// +Y is down
		public static const LEFT:Vec2		= new Vec2( -1.0,  0.0 );	// -X is left
		public static const RIGHT:Vec2		= new Vec2(  1.0,  0.0 );	// +X is right
		public static const NEUTRAL:Vec2	= new Vec2(  0.0,  0.0 );
		// For future use: +Z is away from the camera
		// For future use: -Z is towards the camera

		// The direction pointing the other way
		public static function opposite(direction:Vec2):Vec2 {
			if (direction == LEFT)		{ return RIGHT; }
			if (direction == RIGHT)		{ return LEFT; }
			if (direction == UP)		{ return DOWN; }
			if (direction == DOWN)		{ return UP; }

			return NEUTRAL;
		}
	}
}
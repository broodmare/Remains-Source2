package fe.util {

	// 2D Vector made of two Numbers [X, Y]
	public class Vec2 {

		private var x:Number;
		private var y:Number;

		public function Vec2(x_:Number = 0.0, y_:Number = 0.0) {
			x = x_;
			y = y_;
		}

		public function get X():Number			{ return x; }
		public function get Y():Number			{ return y; }

		public function set X(x_:Number):void	{ x = x_; }
		public function set Y(y_:Number):void	{ y = y_; }

		// A new copy of this vector
		public function getVec2():Vec2 {
			return new Vec2(x, y);
		}
		// Replace each number individually
		public function set(x_:Number, y_:Number):void {
			x = x_;
			y = y_;
		}
		// Replace the entire vector at once
		public function setVector(v:Vec2):void {
			x = v.X;
			y = v.Y;
		}

		// Adds the passed value to each index of the vector
		public function sum(n:Number):void {
			x += n;
			y += n;
		}
		// Adds the passed vector to the stored vector
		public function sumVectors(v:Vec2):void {
			x += v.X;
			y += v.Y;
		}
		// Subtracts the passed vector from the stored vector
		public function subtractVectors(v:Vec2):Vec2 {
			x -= v.X;
			y -= v.Y;
			return this;
		}

		// Multiplies the stored vector by the passed vector
		public function multiplyVectors(v:Vec2):void {
			x *= v.X;
			y *= v.Y;
		}
		// Multiplies the stored vector by the passed value
		public function multiply(n:Number):void {
			x *= n;
			y *= n;
		}
		// Divides the vector by the passed value
		public function divide(n:Number):void {
			x /= n;
			y /= n;
		}

		// Calculates the vector's exact magnitude (or length) squared, without taking the square root
		public function magnitudeSquared():Number {
			var n:Number = x * x + y * y;
			return n;
		}
		// Calculates the vector's exact magnitude (or length)
		public function magnitude():Number {
			var n:Number = Math.sqrt(x * x + y * y);
			return n;
		}
	}
}
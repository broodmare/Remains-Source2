package fe.util {

	// 2D Vector made of two Numbers [X, Y]
	public class Vec2 {

		public var X:Number;
		public var Y:Number;

		public function Vec2(x_:Number = 0.0, y_:Number = 0.0) {
			X = x_;
			Y = y_;
		}

		// A new copy of this vector
		public function getVec2():Vec2 {
			return new Vec2(X, Y);
		}
		// Replace each number individually
		public function set(x_:Number, y_:Number):void {
			X = x_;
			Y = y_;
		}
		// Replace the entire vector at once
		public function setVector(v:Vec2):void {
			X = v.X;
			Y = v.Y;
		}

		// Adds the passed value to each index of the vector
		public function sum(n:Number):void {
			X += n;
			Y += n;
		}
		// Adds the passed vector to the stored vector
		public function sumVectors(v:Vec2):void {
			X += v.X;
			Y += v.Y;
		}
		// Subtracts the passed vector from the stored vector
		public function subtractVectors(v:Vec2):Vec2 {
			X -= v.X;
			Y -= v.Y;
			return this;
		}

		// Multiplies the stored vector by the passed vector
		public function multiplyVectors(v:Vec2):void {
			X *= v.X;
			Y *= v.Y;
		}
		// Multiplies the stored vector by the passed value
		public function multiply(n:Number):void {
			X *= n;
			Y *= n;
		}
		// Divides the vector by the passed value
		public function divide(n:Number):void {
			X /= n;
			Y /= n;
		}

		// Calculates the vector's exact magnitude (or length) squared, without taking the square root
		public function magnitudeSquared():Number {
			var n:Number = X * X + Y * Y;
			return n;
		}
		// Calculates the vector's exact magnitude (or length)
		public function magnitude():Number {
			var n:Number = Math.sqrt(X * X + Y * Y);
			return n;
		}
	}
}
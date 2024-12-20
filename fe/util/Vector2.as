package fe.util {

    public class Vector2 {
        
        // The coordinates -- [X, Y]
        private var vector:Vector.<Number>;

        // Constructor
        public function Vector2(x:Number = 0, y:Number = 0)  {
            vector = new Vector.<Number>(2, true); // Fixed size for performance
            vector[0] = x;
            vector[1] = y;
        }

        public function get X():Number {
            return vector[0];
        }
        public function set X(x:Number):void {
            vector[0] = x;
        }

        public function get Y():Number {
            return vector[1];
        }
        public function set Y(y:Number):void {
            vector[1] = y;
        }

        // Explicitly returns the number vector -- [X, Y]
        public function getVector2():Vector.<Number> {
            return vector;
        }
        // Replace each number individually
        public function set(x:Number, y:Number):void {
            vector[0] = x;
            vector[1] = y;
        }
        // Replace the entire vector at once
        public function setVector(v:Vector2):void {
            vector[0] = v.X;
            vector[1] = v.Y;
        }

        // Adds the passed value to each index of the vector
        public function sum(n:Number):void {
            vector[0] += n;
            vector[1] += n;
        }
        // Adds the passed vector to the stored vector
        public function sumVectors(v:Vector2):void {
            vector[0] += v.X;
            vector[1] += v.Y;
        }
        // Subtracts the passed vector from the stored vector
        public function subtractVectors(v:Vector2):Vector2 {
            vector[0] -= v.X;
            vector[1] -= v.Y;
            return this;
        }

        // Multiplies the stored vector by the passed vector
        public function multiplyVectors(v:Vector.<Number>):void {
            vector[0] *= v[0];
            vector[1] *= v[1];
        }
        // Multiplies the stored vector by the passed value
        public function multiply(n:Number):void {
            vector[0] *= n;
            vector[1] *= n;
        }
        // Divides the vector by the passed value
        public function divide(n:Number):void {
            vector[0] /= n;
            vector[1] /= n;
        }

        // Calculates the vector's approximate magnitude (or length) without taking the square root
        public function magnitudeSquared():Number {
            var n:Number = vector[0] * vector[0] + vector[1] * vector[1];
            return n;
        }
        // Calculates the vector's exact magnitude (or length) squared
        public function magnitude():Number {
            var n:Number = Math.sqrt(vector[0] * vector[0] + vector[1] * vector[1]);
            return n;
        }
    }
}

package fe.util
{
    public class Vector2
    {
        // These just make the code easier to read
        private static const X:int = 0;
        private static const Y:int = 1;

        // The coordinates -- [X, Y]
        private var vector:Vector.<Number>;

        // Constructor
        public function Vector2(x:Number = 0, y:Number = 0)  {
            vector = new Vector.<Number>(2, true); // Fixed size for performance
            vector[X] = x;
            vector[Y] = y;
        }

        public function get X():Number {
            return vector[X];
        }
        public function set X(x:Number):void {
            vector[X] = x;
        }

        public function get Y():Number {
            return vector[Y];
        }
        public function set Y(y:Number):void {
            vector[Y] = y;
        }

        // Explicitly returns the number vector -- [X, Y]
        public function getVector2():Vector.<Number> {
            return vector;
        }
        public function setVector2(x:Number, y:Number):void {
            vector[X] = x;
            vector[Y] = y;
        }

        // Adds the numbers input to the current vector
        public function sumVector2(x:Number, y:Number):void {
            vector[X] += x;
            vector[Y] += y;
        }
    }
}

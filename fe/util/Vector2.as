package fe.util
{
    public class Vector2
    {
        private static const X:int = 0;
        private static const Y:int = 1;
        private var vector:Vector.<Number>;
        
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

        public function getCoords:Vector {
            return vector;
        }
    }
}

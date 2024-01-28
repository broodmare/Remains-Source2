package fe.util
{
    public class Vector2
    {
        private var vector = [];
        
        public function Vector2(x:Number = 0, y:Number = 0)
        {
            vector[X] = x;
            vector[Y] = y;
        }

        public function get X():Number
        {
            return vector[0];
        }
        public function set X(x:Number):void
        {
            vector[0] = x;
        }

        public function get Y():Number
        {
            return vector[1];
        }
        public function set Y(y:Number):void
        {
            vector[1] = y;
        }
    }
}
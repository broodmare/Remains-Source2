package  fe.entities {

    import fe.util.Vector2;

    public class BoundingBox {
        
        private var _top:Number;
        private var _bottom:Number;
        private var _left:Number;
        private var _right:Number;
        
        private var _width:Number = 10;     // Width in pixels (This WILL change during gameplay!)
        private var _height:Number = 10;    // Height in pixels (This WILL change during gameplay!)

        private var _standingHeight:Number;  // Standing height (Constant)
        private var _standingWidth:Number;   // Standing width (Constant)
        private var _crouchingHeight:Number; // Crouching height (Constant)
        private var _crouchingWidth:Number;  // Crouching width (Constant)

        public function BoundingBox(vec:Vector2) {
            _width = width;
            _height = height;

            _left   = vec.X - width * 0.5;
            _right  = vec.X + width * 0.5;
            _top    = vec.Y - _height;
            _bottom = vec.Y;
        }

        //Updates the boundaries based on new coordinate
        public function center(vec:Vector2):void {
            _left   = vec.X - halfWidth;
            _right  = vec.X + halfWidth;
            _top    = vec.Y - _height;
            _bottom = vec.Y;
        }

        public function centerHorizontally(vec:Vector2):void {
            _left   = vec.X - halfWidth;
            _right  = vec.X + halfWidth;
        }

        public function setBounds(left:Number, right:Number, top:Number, bottom:Number):void {
            _left = left;
            _right = right;
            _top = top;
            _bottom = bottom;
        }

        public function duck():void {
            _top = _bottom - height;
        }

        public function get top():Number {
            return _top;
        }
        public function get bottom():Number {
            return _bottom;
        }
        public function get left():Number {
            return _left;
        }
        public function get right():Number {
            return _right;
        }

        public function set top(n:Number):void {
            _top = n;
        }
        public function set bottom(n:Number):void {
            _bottom = n;
        }
        public function set left(n:Number):void {
            _left = n;
        }
        public function set right(n:Number):void {
            _right = n;
        }

        public function get width():Number {
            return _width;
        }
        public function get height():Number {
            return _height;
        }
        public function set width(n:Number):void {
            _width = n;
        }
        public function set height(n:Number):void {
            _height = n;
        }
        public function get halfHeight():Number {
            return _height * 0.5;
        }
        public function get halfWidth():Number {
            return _width * 0.5;
        }
        public function get standingHeight():Number {
            return _standingHeight;
        }
        public function get standingWidth():Number {
            return _standingWidth;
        }
        public function get crouchingHeight():Number {
            return _crouchingHeight;
        }
        public function get crouchingWidth():Number {
            return _crouchingWidth;
        }

        public function set standingHeight(n:Number):void {
            _standingHeight = n;
        }
        public function set standingWidth(n:Number):void {
            _standingWidth = n;
        }
        public function set crouchingHeight(n:Number):void {
            _crouchingHeight = n;
        }
        public function set crouchingWidth(n:Number):void {
            _crouchingWidth = n;
        }

        // Returns the center X coordinate of the bounding box.
        public function get centerX():Number {
            return (_left + _right) / 2;
        }

        // Checks intersection with another bounding box.
        public function intersects(other:BoundingBox):Boolean {
            // Basic AABB overlap check
            return !(other.left > _right ||
                     other.right < _left ||
                     other.top > _bottom ||
                     other.bottom < _top);
        }

        public function intersectsPoint(x:Number, y:Number):Boolean {
            return (x >= _left && x <= _right && y >= _top && y <= _bottom);
        }

        public function intersectsCoordinate(vec:Vector2):Boolean {
            return intersectsPoint(vec.X, vec.Y);
        }

        public function getCenter(vec:Vector2):Number {
            return vec.Y - halfHeight;
        }

		public function flatten(vec:Vector2):void {
            _top    = vec.Y - _height;
            _bottom = vec.Y;
        }
    }
}
	package  fe.entities {

	import fe.util.Vector2;

	public class BoundingBox {
		
		private var _top:Number;
		private var _bottom:Number;
		private var _left:Number;
		private var _right:Number;
		
		private var _width:Number	= 10.00;     // Width in pixels
		private var _height:Number	= 10.00;    // Height in pixels

		public function BoundingBox(vec:Vector2) {
			_left	= vec.X - (_width * 0.50) + 0.01;	// Slight offset to avoid overlapping with the floor tiles
			_right	= vec.X + (_width * 0.50) - 0.01;	// Slight offset to avoid overlapping with the floor tiles
			_top	= vec.Y - _height + 0.01;
			_bottom	= vec.Y - 0.01;				// Slight offset to avoid overlapping with the floor tiles
		}

		//Updates the boundaries based on new coordinate
		public function center(vec:Vector2):void {
			_left	= vec.X - halfWidth + 0.01;
			_right	= vec.X + halfWidth - 0.01;
			_top	= vec.Y - _height + 0.01;
			_bottom	= vec.Y - 0.01;	// To avoid overlapping with the floor tiles
		}

		public function setBounds(left:Number, right:Number, top:Number, bottom:Number):void {
			_left	= left; + 0.01;	// Slight offset to avoid overlapping with the floor tiles
			_right	= right - 0.01;	// Slight offset to avoid overlapping with the floor tiles
			_top	= top + 0.01;
			_bottom	= bottom - 0.01;	// To avoid overlapping with the floor tiles
		}

		public function duck():void {
			_top = _bottom - _height;
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
		public function setSize(n:int):void {
			_width = n;
			_height = n;
		}

		public function get halfHeight():Number {
			return _height * 0.5;
		}
		public function get halfWidth():Number {
			return _width * 0.5;
		}

		// Returns the center X coordinate of the bounding box.
		public function get centerX():Number {
			return (_left + _right) * 0.50;
		}

		// Checks intersection with another bounding box (AABB overlap check)
		public function intersects(other:BoundingBox):Boolean {
			return !(other.left > _right ||
					 other.right < _left ||
					 other.top > _bottom ||
					 other.bottom < _top);
		}

		// Checks horizontal intersection with another bounding box
        public function intersectsHorizontally(other:BoundingBox):Boolean {
            return !(other.left > right || other.right < left);
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
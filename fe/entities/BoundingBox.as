	package  fe.entities {

	import fe.util.Vec2;

	public class BoundingBox {
		
		public var top:Number;
		public var bottom:Number;
		public var left:Number;
		public var right:Number;
		public var width:Number		= 10.00;			// Width in pixels
		public var height:Number	= 10.00;			// Height in pixels

		public function BoundingBox(vec:Vec2) {
			left	= vec.X - (width * 0.50) + 0.01;	// Slight offset to avoid overlapping with the floor tiles
			right	= vec.X + (width * 0.50) - 0.01;	// Slight offset to avoid overlapping with the floor tiles
			top	= vec.Y - height + 0.01;
			bottom	= vec.Y - 0.01;						// Slight offset to avoid overlapping with the floor tiles
		}

		//Updates the boundaries based on new coordinate
		public function center(vec:Vec2):void {
			left	= vec.X - halfWidth + 0.01;
			right	= vec.X + halfWidth - 0.01;
			top	= vec.Y - height + 0.01;
			bottom	= vec.Y - 0.01;			// To avoid overlapping with the floor tiles
		}

		public function setBounds(left_:Number, right_:Number, top_:Number, bottom_:Number):void {
			left	= left_ + 0.01;			// Slight offset to avoid overlapping with the floor tiles
			right	= right_ - 0.01;			// Slight offset to avoid overlapping with the floor tiles
			top	= top_ + 0.01;
			bottom	= bottom_ - 0.01;		// To avoid overlapping with the floor tiles
		}

		public function duck():void {
			top = bottom - height;
		}

		public function setSize(n:int):void {
			width = n;
			height = n;
		}

		public function get halfHeight():Number {
			return height * 0.5;
		}
		public function get halfWidth():Number {
			return width * 0.5;
		}

		// Returns the center X coordinate of the bounding box.
		public function get centerX():Number {
			return (left + right) * 0.50;
		}

		// Checks intersection with another bounding box (AABB overlap check)
		public function intersects(other:BoundingBox):Boolean {
			return !(other.left > right ||
					 other.right < left ||
					 other.top > bottom ||
					 other.bottom < top);
		}

		// Checks horizontal intersection with another bounding box
        public function intersectsHorizontally(other:BoundingBox):Boolean {
            return !(other.left > right || other.right < left);
        }

		public function intersectsPoint(x:Number, y:Number):Boolean {
			return (x >= left && x <= right && y >= top && y <= bottom);
		}

		public function intersectsCoordinate(vec:Vec2):Boolean {
			return intersectsPoint(vec.X, vec.Y);
		}

		public function getCenter(vec:Vec2):Number {
			return vec.Y - halfHeight;
		}

		public function flatten(vec:Vec2):void {
			top    = vec.Y - height;
			bottom = vec.Y;
		}
	}
}
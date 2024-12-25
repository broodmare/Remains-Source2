package  fe.entities {

    import fe.util.Vector2;

    public class BoundingBox {
        
        private var top:Number;
		private var bottom:Number;
		private var left:Number;
		private var right:Number;

        var halfWidth:Number;
        var halfHeight:Number;

        public function BoundingBox(v:Vector2, width:Number, height:Number) {
            this.halfWidth = width / 2;
            this.halfHeight = height / 2;

            this.left = v.x - halfWidth;
            this.right = v.x + halfWidth;
            this.top = v.y - halfHeight;
            this.bottom = v.y + halfHeight;

            
        }

        //Updates the boundaries based on new coordinate
        public function center(v:Vector2):void {
            this.left = v.x - halfWidth;
            this.right = v.x + halfWidth;
            this.top = v.y - halfHeight;
            this.bottom = v.y + halfHeight;
        }

        // Returns the width of the bounding box.
        public function get width():Number {
            return this.right - this.left;
        }

        // Returns the height of the bounding box.
        public function get height():Number {
            return this.bottom - this.top;
        }

        // Returns the center X coordinate of the bounding box.
        public function get centerX():Number {
            return (this.left + this.right) / 2;
        }

        // Returns the center Y coordinate of the bounding box.
        public function get centerY():Number {
            return (this.top + this.bottom) / 2;
        }

        // Checks if this bounding box intersects with another bounding box
        public function intersects(other:BoundingBox):Boolean {
            return !(other.left > this.right ||
                     other.right < this.left ||
                     other.top > this.bottom ||
                     other.bottom < this.top);
        }
    }
}
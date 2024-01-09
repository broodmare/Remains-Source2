package fe.loc
{
    public class ColorFilter
    {
        public var red:Number   = 1.00;
        public var green:Number = 1.00;
        public var blue:Number  = 1.00;

        private static const ColorTable:Object = 
        {
            'green'		: [0.80, 1.16, 0.80],
            'red'		: [1.10, 0.90, 0.70],
            'fire'		: [1.10, 0.70, 0.50],
            'lab'		: [0.90, 1.10, 0.70],
            'black'		: [0.50, 0.70, 0.60],
            'blue'		: [0.80, 0.80, 1.16],
            'sky'		: [0.85, 1.12, 1.12],
            'yellow'	: [1.25, 1.20, 0.90],
            'purple'	: [1.08, 0.80, 1.12],
            'pink'		: [1.10, 0.90, 1.00],
            'blood'		: [1.08, 0.60, 1.08],
            'blood2'	: [1.00, 0.10, 0.10],
            'dark'		: [0.00, 0.00, 0.00],
            'mf'		: [0.50, 0.50, 1.08]
        }

        public function ColorFilter(rgbArray:Array = null)
        {
            if (rgbArray != null) setColor(rgbArray);
        }

        public function setColor(rgbArray:Array):void
        {
            red     = rgbArray[0];
            green   = rgbArray[1];
            blue    = rgbArray[2];
        }

        public static function getColorFromTable(colorName:String):ColorFilter
        {
            var filter:ColorFilter = new ColorFilter();

            if (ColorTable.hasOwnProperty(colorName)) 
            {
                filter.setColor(ColorTable[colorName]);
            }
            return filter;
        }
    }
}
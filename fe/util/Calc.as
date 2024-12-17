package fe.util
{
    public class Calc
    {
		// Generate a random int between min (inclusive) and max (inclusive)
		public static function intBetween(min:int, max:int):int {
    		var range:int = max - min + 1;
    		var number:int = int(Math.random() * range) + min;
    		return number;
		}

		//Generates a random floating-point number between min (inclusive) and max (exclusive).
		public static function floatBetween(min:Number, max:Number):Number {
			return Math.random() * (max - min) + min;
		}
    }
}
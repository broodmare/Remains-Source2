package fe.util
{
    public class Calc
    {
        public static function intBetweenZeroAnd(max:int):int
		{
			var number:int = Math.floor(Math.random() * (max + 1));
			return number;
		}
		public static function intBetweenOneAnd(max:int):int
		{
			var number:int = Math.floor(Math.random() * max) + 1;
			return number;
		}
		public static function intBetween(min:int, max:int):int
		{
    		var range:int = max - min + 1;
    		var number:int = Math.floor(Math.random() * range) + min;
    		return number;
		}
    }
}
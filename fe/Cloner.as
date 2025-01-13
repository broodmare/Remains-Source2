package fe {
	
	import flash.utils.ByteArray;
	
	public class Cloner {

		// Copies all passed data into a new area, instead of copying the reference
		public static function deepClone(object:Object):Object {
			var byteArray:ByteArray = new ByteArray();
			byteArray.writeObject(object);
			byteArray.position = 0;
			return byteArray.readObject();
		}
	}
}
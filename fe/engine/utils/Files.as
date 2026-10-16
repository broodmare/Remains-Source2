package fe.engine.utils {

	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;

	// Reads whole files from disk at once
	public class Files {

		public static function readText(file:File):String {
			var stream:FileStream = new FileStream();
			var text:String;

			stream.open(file, FileMode.READ);
			text = stream.readUTFBytes(stream.bytesAvailable);
			stream.close();

			return text;
		}

		public static function readBytes(file:File):ByteArray {
			var stream:FileStream = new FileStream();
			var bytes:ByteArray = new ByteArray();

			stream.open(file, FileMode.READ);
			stream.readBytes(bytes);
			stream.close();

			return bytes;
		}
	}
}
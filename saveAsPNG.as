/**
 * Example that Saves a MovieClip / Sprite as a PNG locally or to a web server
 * 
 * 24th Feb 2010
 * 
 * Created at the request of a few cool peeps on twitter
 * 
 * @author Richard Davey <rich@photonstorm.com>
 */
	
package  
{
	import fl.controls.Button;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.net.FileReference;
	import flash.text.TextField;
	import flash.net.NetConnection;
	import flash.net.Responder;
	import flash.events.NetStatusEvent;
	import flash.utils.ByteArray;

	import com.adobe.images.PNGEncoder;
	
	public class saveAsPNG extends Sprite
	{
		var theMovieClip:MovieClip;
		var saveButton:Button;
		var file:FileReference = new FileReference();
		
		public function saveAsPNG() 
		{
			theMovieClip = MovieClip(getChildByName("theMovieClipMC"));
			
			saveButton = Button(getChildByName("savePNGButton"));
			
			saveButton.addEventListener(MouseEvent.CLICK, saveLocalPNG);
		}
		
		private function getMovieClipAsBitmap():Bitmap
		{
			var bounds:Rectangle = theMovieClip.getBounds(theMovieClip);
			
			//	The * 2 is because we're scaling the clip up by a factor of two, to result in a larger PNG
			//	If you don't need this, remove it and comment out the m.scale call below
			var theBitmap:Bitmap = new Bitmap(new BitmapData(bounds.width * 2, bounds.height * 2, true, 0x0));
			
			var m:Matrix = new Matrix(1, 0, 0, 1, -bounds.x, -bounds.y);
			
			//	Simply scale the matrix to make a bigger PNG. Here we are doubling it. Comment this out if you don't need it.
			m.scale(2, 2);
			
			//	Need to crop the PNG to a given size? Pass it a Rectangle as the 5th parameter to draw()
			//var r:Rectangle = new Rectangle(0, 0, 50, 40);
			
			theBitmap.bitmapData.draw(theMovieClip, m, null, null, null, true);
			
			return theBitmap;
		}
		
		//	This could really be bundled with the getMovieClipAsBitmap method, but I wanted to split them up as they perform different tasks
		private function getMovieClipAsByteArrayPNG():ByteArray
		{
			var data:Bitmap = getMovieClipAsBitmap();
			
			var ba:ByteArray = PNGEncoder.encode(data.bitmapData);
			
			return ba;
		}
		
		//	Uses FileReference to save the PNG locally to the hard drive (see "saveToServer" for an alternative)
		private function saveLocalPNG(event:MouseEvent):void
		{
			var ba:ByteArray = getMovieClipAsByteArrayPNG();
			
			file.save(ba, "BirdyNamNam.png");
		}
		
		
		
		/*
		 * If you want to save the PNG to a web server instead of a local file then the easiest way if via AMFPHP
		 * 
		 * I have included a basic example php script to do this, it would go into your amfphp services folder
		 * 
		 * See http://www.amfphp.org for more details about AMFPHP
		 * 
		 */
		
		private function saveToServer(event:MouseEvent):void
		{
			//	This is a standard AMFPHP call set-up, we're doing nothing complex here - just calling the method on the Gateway
			//	and passing it our raw ByteArray, AMFPHP will do the rest
			
			var responder:Responder = new Responder(bitmapSaveResult, bitmapSaveError);
			
			var connection:NetConnection = new NetConnection;
			
			connection.addEventListener(NetStatusEvent.NET_STATUS, connectFailed);
			
			connection.connect("http://www.yoursite.com/yourAMFPHPgateway/");
			
			var ba:ByteArray = getMovieClipAsByteArrayPNG();
			
			connection.call("Avatar.saveImage", responder, ba, true);
		}
		
		private function bitmapSaveResult(result:Object):void
		{
			trace("Bitmap Save Result: " + String(result));
			
			if (result.success == true)
			{
				saveButton.label = "PNG Saved!";
				trace("PNG saved to the server with filename: " + result.filename);
			}
			else
			{
				trace("Error with bitmap save from the PHP side");
			}
		}
		
		private function connectFailed(event:NetStatusEvent):void
		{
			trace("NetConnection error: " + event);
		}
		
		private function bitmapSaveError(fault:Object):void
		{
			trace("AMFPHP Error: " + String(fault));
		}
	}

}
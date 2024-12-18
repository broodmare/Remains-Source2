package fe.serv
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;

	// Class containing the info for a single animation on a spritesheet
	public class BlitAnim {

		public var id:int = 0;				// Row index in the sprite sheet
		public var firstf:int = 0;			// Starting frame index.
		public var maxf:int = 1;			// Frames in the animation
		public var retf:int = 0;			// What frame to return to if the animation loops
		public var replay:Boolean = false;	// Loop the animation
		public var st:Boolean = false;		// Whether to start the animation?
		public var stab:Boolean = false;	// Holds the current frame at the end, eg. for jumping
		public var f:Number = 0;			// Current Frame index
		public var df:Number = 1;			// Animation speed (frames per tick), so 0.5f is half speed

		public function BlitAnim(animData:Object) {
			
			// Initialize properties passed data
			id = animData.hasOwnProperty("y") ? animData.y : 0;
			maxf = animData.hasOwnProperty("len") ? animData.len : 1;
			firstf = animData.hasOwnProperty("ff") ? animData.ff : 0;
			retf = animData.hasOwnProperty("rf") ? animData.rf : 0;
			df = animData.hasOwnProperty("df") ? animData.df : 1;
			replay = animData.hasOwnProperty("rep") && animData.rep == 1;
			stab = animData.hasOwnProperty("stab") && animData.stab == 1;
			f = firstf;
		}

		public function step() {
			if (stab) return;
			if (f < firstf + maxf - 1) f += df;
			else if (replay) f = retf;
			else st = true;
		}
		
		public function restart() {
			st = false;
			f = firstf;
		}
	}
}
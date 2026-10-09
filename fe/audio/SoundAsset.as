package fe.audio {

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;

	public class SoundAsset extends EventDispatcher {
		public static const LOAD_ERROR:String = "soundAssetLoadError";

		private var path:String;
		private var source:Sound;
		private var loadStarted:Boolean = false;
		private var loadComplete:Boolean = false;
		private var loadFailed:Boolean = false;

		public function SoundAsset(path:String) {
			this.path = path;
			source = new Sound();
			source.addEventListener(Event.COMPLETE, onSourceComplete);
			source.addEventListener(IOErrorEvent.IO_ERROR, onSourceError);
		}

		public function load():void {
			var request:URLRequest;

			if (loadStarted || loadComplete || loadFailed) {
				return;
			}

			loadStarted = true;
			request = new URLRequest(path);

			try {
				source.load(request);
			}
			catch (caughtError:Error) {
				failLoad(caughtError.message);
			}
		}

		private function onSourceComplete(event:Event):void {
			loadComplete = true;
			source.removeEventListener(Event.COMPLETE, onSourceComplete);
			source.removeEventListener(IOErrorEvent.IO_ERROR, onSourceError);
			dispatchEvent(new Event(Event.COMPLETE));
		}

		private function onSourceError(event:IOErrorEvent):void {
			failLoad(event.text);
		}

		private function failLoad(message:String):void {
			var errorEvent:IOErrorEvent;

			if (loadFailed || loadComplete) {
				return;
			}

			loadFailed = true;
			source.removeEventListener(Event.COMPLETE, onSourceComplete);
			source.removeEventListener(IOErrorEvent.IO_ERROR, onSourceError);
			errorEvent = new IOErrorEvent(LOAD_ERROR, false, false, message);
			dispatchEvent(errorEvent);
		}

		public function play(startMilliseconds:Number, loops:int, transform:SoundTransform):SoundChannel {
			if (!isLoaded) {
				return null;
			}

			return source.play(startMilliseconds, loops, transform);
		}

		public function get assetPath():String {
			return path;
		}

		public function get isLoaded():Boolean {
			return loadComplete;
		}

		public function get isLoadFinished():Boolean {
			return loadComplete || loadFailed;
		}

		public function get isLoadFailed():Boolean {
			return loadFailed;
		}
	}
}

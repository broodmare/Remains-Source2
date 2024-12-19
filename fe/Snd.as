package fe
{
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;

	import fe.util.Calc;
	import fe.util.Vector2;
	
	public class Snd {
		public static var soundMap:Object = {};
		public static var musicMap:Object = {};

		public static var music:Sound;
		public static var trackName:String = '';

		public static var globalVol = 0.4;		// Used by pipbuckOpt as a string.
		public static var stepVol = 0.5;		// Used by pipbuckOpt as a string.
		public static var musicVol = 0.2;		// Used by pipbuckOpt as a string.
		
		
		public static var sndNames:Array = ['mp5'];
		
		public static var soundMuted:Boolean=false;
		public static var onMusic:Boolean=true;
		
		public static var musicCh:SoundChannel;
		public static var musicPrevCh:SoundChannel;
		public static var actionCh:SoundChannel;

		public static var currentMusicPriority:int = 0;
		
		public static var hitTimer:int = 0;
		public static var combatTimer:int = 0;

		// Center for directional audio purposes, set by the Camera 
		public static var center:Vector2 = new Vector2(100, 500);

		public static var widthX:Number = 2000; 
		public static var musicTimer:int = 0;
		
		
		public static var tempMuted:Boolean = true;
		
		public static var shumArr:Array;
		public static var t_shum:int = 0;

		// Moved here from world class
		private static var soundPath = 'Modules/core/sound/';
		private static var musicPath = 'Modules/core/sound/music';

		private static var soundXML:XML;	// XML Containing file names of all songs, weapon noises, creature noises, etc. (Does not have file extension)
		private static var xmlPath:String = "Modules/core/sounds.xml";

		private static var xmlData:XML;

		private static var startedLoading:Boolean = false;
		private static var finishedLoading:Boolean = false;

		// Counters so I can load all files into memory ahead of time
		private static var totalSoundsToLoad:int = 0;
		private static var totalSoundsLoaded:int = 0;
		
		public static function pan(x:Number):Number {
			return (x - 250) / 500;
		}

		public static function initSnd():void {
			
			// If we're already initialized, in the process of initializing, or all sounds are muted, stop
			if (finishedLoading || startedLoading || soundMuted) {
				return;
			}

			// Load and parse the XML synchronously
			var xmlLoader:XMLLoader = new XMLLoader();
			xmlData = xmlLoader.syncLoad(xmlPath);

			// Reset counters before starting
			totalSoundsToLoad = 0;
			totalSoundsLoaded = 0;

			// Load the main menu song first
			var mmSongPath:String = soundPath + "music/" + "mainmenu.mp3";
			trace("Snd.as/initSnd() - Trying to load MainMenu song from: " + mmSongPath);
			var req:URLRequest = new URLRequest(mmSongPath);
			var s:Sound = new Sound();
			s.addEventListener(Event.COMPLETE, onAnySoundLoaded);
			s.addEventListener(IOErrorEvent.IO_ERROR, onSoundLoadError);
			s.load(req);
			musicMap['mainmenu'] = s;
			totalSoundsToLoad++;

			// Load all resources from XML
			for each (var i:XML in xmlData.res) {
				var folderName:String = i.@id;
				for each (var sndXML:XML in i.s) {
					loadSoundResource(folderName, sndXML);
				}
			}

			/* Load all music upfront:
			for each (var j:XML in xmlData.music.s) {
				var id:String = j.@id;
				req = new URLRequest(soundPath + "music/" + id + ".mp3");
				s = new Sound();
				s.addEventListener(Event.COMPLETE, onAnySoundLoaded);
				s.addEventListener(IOErrorEvent.IO_ERROR, onSoundLoadError);
				s.load(req);
				musicMap[id] = s;
				totalSoundsToLoad++;
			}
			*/

			shumArr = [];
			startedLoading = true;
		}

		private static function loadSoundResource(subDir:String, sndXML:XML):void {
			var soundID:String = sndXML.@id;
			// Check if this <s> has nested <s>, indicating multiple variations:
			if (sndXML.s.length() > 0) {
				// We have multiple sounds under this ID
				soundMap[soundID] = [];
				for each (var variant:XML in sndXML.s) {
					var variantID:String = variant.@id;
					var variantReq:URLRequest = new URLRequest(soundPath + subDir + "/" + variantID + ".mp3");
					var variantSound:Sound = new Sound();
					variantSound.addEventListener(Event.COMPLETE, onAnySoundLoaded);
					variantSound.addEventListener(IOErrorEvent.IO_ERROR, onSoundLoadError);
					variantSound.load(variantReq);
					soundMap[soundID].push(variantSound);
					totalSoundsToLoad++;
				}
			}
			else {
				// Single sound
				var req:URLRequest = new URLRequest(soundPath + subDir + "/" + soundID + ".mp3");
				var s:Sound = new Sound();
				s.addEventListener(Event.COMPLETE, onAnySoundLoaded);
				s.addEventListener(IOErrorEvent.IO_ERROR, onSoundLoadError);
				s.load(req);
				soundMap[soundID] = s;
				totalSoundsToLoad++;
			}
		}
		
		public static function loadMusic():void {
			var req:URLRequest;
			var s:Sound;
			for each (var j:XML in xmlData.music.s) {
				var id:String = j.@id;
				try {
					req = new URLRequest(soundPath + "music/" + id + ".mp3");
					s = new Sound(req);
					s.addEventListener(Event.COMPLETE, musicLoaded);
					s.addEventListener(IOErrorEvent.IO_ERROR, onSoundLoadError);
					musicMap[id] = s;
					World.w.musicKol++;
				}
				catch (err:Error) {
					trace('ERROR: (00:1E) - music load err', req.url);
				}
			}
		}

		private static function onAnySoundLoaded(event:Event):void {
			event.currentTarget.removeEventListener(Event.COMPLETE, onAnySoundLoaded);
			event.currentTarget.removeEventListener(IOErrorEvent.IO_ERROR, onSoundLoadError);
			totalSoundsLoaded++;
			if (totalSoundsLoaded == totalSoundsToLoad) {
				trace("All sounds have finished loading!");
				finishedLoading = true;
				if (musicVol > 0 && musicMap['mainmenu']) {
					playMusic('mainmenu');
				}
			}
		}

		private static function onSoundLoadError(e:IOErrorEvent):void {
			trace("Error loading sound: " + e.text);
			// Even if there's an error, we should count this as "finished" loading attempt, so that we don't get stuck waiting for a missing file.
			totalSoundsLoaded++;
			if (totalSoundsLoaded == totalSoundsToLoad) {
				finishedLoading = true;
				trace("All available sounds attempted; some errors occurred.");
			}
		}

		static private function musicLoaded(event:Event):void {
			World.w.musicLoaded++;
			event.currentTarget.removeEventListener(Event.COMPLETE, musicLoaded);
			event.currentTarget.removeEventListener(IOErrorEvent.IO_ERROR, onSoundLoadError);
		}
		
		public static function combatMusic(trackName:String, newMusicPriority:int=0, n:int = 150):void {
			combatTimer = n;
			if (newMusicPriority > currentMusicPriority) {
				currentMusicPriority = newMusicPriority;
				playMusic(trackName);
			}
		}
		
		public static function playMusic(nextTrackName:String=null, rep:int=10000):void {
			if (!finishedLoading) {
				return;
			}
			
			if (nextTrackName != null && musicCh && nextTrackName == trackName) {
				return;
			}
			
			if (nextTrackName != null) {
				trackName = nextTrackName;
			}

			var trans:SoundTransform = new SoundTransform(musicVol, 0);
			
			if (musicCh) {
				if (musicPrevCh || musicTimer > 0) musicPrevCh.stop();
				musicPrevCh = musicCh;
				musicCh = null;
				musicTimer = 100;
			}

			currentMusicPriority = 0;

			if (onMusic && musicMap[trackName] && musicMap[trackName].bytesTotal && musicMap[trackName].bytesLoaded == musicMap[trackName].bytesTotal) {
				musicCh = musicMap[trackName].play(0, rep, trans);
			}
		}

		public static function stopMusic():void {
			if (!finishedLoading || !musicCh) { 
				return;
			}
			musicCh.stop();
		}

		public static function updateMusicVol():void {
			if (musicCh) {
				var trans:SoundTransform = new SoundTransform(musicVol, 0);
				musicCh.soundTransform = trans;
			} 
			else {
				playMusic();
			}
		}
		
		public static function ps(soundName:String,nx:Number=-1000,ny:Number=-1000,msec:Number=0,vol:Number=1):SoundChannel
		{
			// If we're finished loading sounds and not muted
			if (!finishedLoading || soundMuted || tempMuted) {
				return null;
			}
			
			// and find an entry in the sound map
			if (soundMap[soundName]) {
				var s:Sound;
				// If the entry is an array of sounds...
				if (soundMap[soundName] is Array) {
					// Pick one at random to use
					s = soundMap[soundName][Calc.intBetween(0, soundMap[soundName].length - 1)];
				}
				// If it's just one sound, use it
				else {
					s = soundMap[soundName] as Sound;
				}

				// Check the sound is properly loaded before trying to do anything with it
				if (s.bytesTotal > 0 && s.bytesLoaded >= s.bytesTotal) {
					// Positional audio
					var pan:Number = (nx - center.X) / widthX;
					if (nx == -1000) {
						pan = 0;
					}
					// Create the sound transform
					var trans:SoundTransform = new SoundTransform(vol * globalVol * Calc.floatBetween(0.9, 1.0), pan);
					// Play the sound
					return s.play(msec, 0, trans);
				}
				else {
					trace("Snd.as/ps() - Error: Tried to play a sonud before it was loaded")
				}
			}
			return null;
		}
		
		public static function pshum(soundName:String, vol:Number=1):void
		{
			if (!finishedLoading || soundMuted || tempMuted) return;
			var shum:Object;
			if (shumArr[soundName]) {
				shum = shumArr[soundName];
				if (shum.maxVol < vol) shum.maxVol = vol;
			}
			else if (soundMap[soundName]) {
				shum = {};
				shum.soundName = soundName;
				shum.curVol = vol;
				shum.maxVol = vol;
				shum.pl = false;
				shumArr[soundName] = shum;
			}
		}
		
		public static function step():void {
			if (hitTimer > 0) {
				hitTimer--;
			}

			if (musicTimer>0 && musicPrevCh) {
				var trans:SoundTransform;
				
				if (musicTimer % 10 == 1) {
					trans = new SoundTransform(musicVol * musicTimer / 100, 0);
					musicPrevCh.soundTransform = trans;
				}

				if (musicTimer <= 5) {
					musicPrevCh.stop();
					musicPrevCh = null;
					musicTimer = 0;
				}

				if (combatTimer > 0) {
					musicTimer -= 5;
				}
				else {
					musicTimer--;
				}
			}

			if (combatTimer > 0) {
				if (combatTimer == 1) {
					currentMusicPriority = 0;
					playMusic(World.w.currentMusic);
				}
				if (World.w.pip == null || !World.w.pip.active && !World.w.sats.active) {
					combatTimer--;
				}
			}

			// Something to do with units?
			t_shum--;
			if (t_shum <= 0) {
				t_shum = 5;
				for each (var obj:Object in shumArr) {
					if (obj.curVol != obj.maxVol) {
						if (!obj.pl && obj.maxVol > 0) {
							var s:Sound = soundMap[obj.soundName] as Sound;
							trans = new SoundTransform(obj.maxVol * globalVol, 0); 
							obj.ch = s.play(0, 10000, trans);
							obj.pl = true;
						} 
						else if (obj.pl && obj.maxVol<=0 && obj.ch) {
							obj.ch.stop();
							obj.pl = false;
						} 
						else if (obj.pl && obj.maxVol > 0 && obj.ch) {
							trans = new SoundTransform(obj.maxVol * globalVol, 0);
							obj.ch.soundTransform = trans;
							obj.curVol = obj.maxVol;
						}
					}
					obj.maxVol -= 0.2;
					if (obj.maxVol < 0) {
						obj.maxVol = 0;
					}
				}
			}
		}

		public static function save():* {
			var obj:Object = {};
			obj.globalVol = globalVol;
			obj.stepVol = stepVol;
			obj.musicVol = musicVol;
			return obj;
		}
		
		public static function load(obj:Object):void {
			if (obj.globalVol != null && !isNaN(obj.globalVol)) globalVol = obj.globalVol;
			if (obj.stepVol != null && !isNaN(obj.stepVol)) stepVol = obj.stepVol;
			if (obj.musicVol != null && !isNaN(obj.musicVol)) musicVol = obj.musicVol;
			if (musicCh) updateMusicVol();
		}
	}
}
package fe {

	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.events.IOErrorEvent;

	import fe.util.Calc;
	import fe.util.Vector2;
	
	public class Snd {
		
		// Holds either sound objects or arrays of sound objects (For sounds with more than one variation)
		private static var soundMap:Object = {};
		private static var musicMap:Object = {};

		private static var music:Sound;
		private static var trackName:String = '';	// The currently playing song

		public static var globalVol:Number = 0.4;
		public static var stepVol:Number = 0.5;
		public static var musicVol:Number = 0.2;
		
		// Sound state flags
		private static var soundMuted:Boolean = false;
		private static var onMusic:Boolean = true;
		private static var tempMuted:Boolean = true;
		
		private static var musicCh:SoundChannel;		// ..
		private static var musicPrevCh:SoundChannel;	// ..
		public static var actionCh:SoundChannel;		// Seems exclusively used for the player interacting with objects (Accessed by UnitPlayer.as and Interact.as) 

		private static var currentMusicPriority:int = 0;

		public static var center:Vector2 = new Vector2(1000, 500); // Center for directional audio purposes, (Accessed and set by the Camera) 

		// Timers
		private static var musicTimer:int = 0;
		public static var hitTimer:int = 0; // (Accessed by Bullet.as)
		private static var combatTimer:int = 0;
		private static var shumTimer:int = 0;
		
		private static var shumArr:Array;
		

		// Moved here from world class
		private static var xmlPath:String = "Modules/core/sounds.xml";	// Manifest of all sounds/songs
		private static var soundPath:String = 'Modules/core/sound/';			// Sounds path
		private static var musicPath:String = 'Modules/core/sound/music/';		// Songs path
		

		// Loading flags and counters
		private static var startedLoading:Boolean = false;
		private static var finishedLoading:Boolean = false;
		private static var totalSoundsToLoad:int = -1;
		private static var totalSoundsLoaded:int = 0;
		public static var totalSongsToLoad:int = -1;	// (Accessed by MainMenu)
		public static var totalSongsLoaded:int = 0;		// (Accessed by MainMenu)
		private static var startedMainMenuMusic:Boolean = false;
		
		public static function initSnd():void {
			
			trace("Sound.as/initSnd() - Initializing sound");

			// If we're already initialized, in the process of initializing, or all sounds are muted, stop
			if (finishedLoading || startedLoading || soundMuted) {
				return;
			}

			// Load and parse the XML synchronously
			var xmlLoader:XMLLoader = new XMLLoader();
			var xmlData:XML = xmlLoader.syncLoad(xmlPath);

			totalSongsToLoad = 0;
			
			// Load all music tracks from XML
			for each (var j:XML in xmlData.music.s) {
				loadMusicResource(j.@id);
				totalSongsToLoad++;
			}

			totalSoundsToLoad = 0;
			// Load all sound resources from XML
			for each (var i:XML in xmlData.res) {
				var folderName:String = i.@id;
				for each (var sndXML:XML in i.s) {
					loadSoundResource(folderName, sndXML);
				}
			}
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
					variantSound.addEventListener(Event.COMPLETE, onSoundEffectLoaded);
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
				s.addEventListener(Event.COMPLETE, onSoundEffectLoaded);
				s.addEventListener(IOErrorEvent.IO_ERROR, onSoundLoadError);
				s.load(req);
				soundMap[soundID] = s;
				totalSoundsToLoad++;
			}
		}

		private static function loadMusicResource(musicID:String):void {
			var req:URLRequest = new URLRequest(musicPath + musicID + ".mp3");
			var m:Sound = new Sound();
			m.addEventListener(Event.COMPLETE, onMusicLoaded);
			m.addEventListener(IOErrorEvent.IO_ERROR, onSongLoadError);
			m.load(req);
			musicMap[musicID] = m;
		}

		private static function onSoundEffectLoaded(event:Event):void {
			event.currentTarget.removeEventListener(Event.COMPLETE, onSoundEffectLoaded);
			event.currentTarget.removeEventListener(IOErrorEvent.IO_ERROR, onSoundLoadError);
			totalSoundsLoaded++;
			checkIfAllSoundsLoaded()
		}
		
		private static function onMusicLoaded(event:Event):void {
			event.currentTarget.removeEventListener(Event.COMPLETE, onMusicLoaded);
			event.currentTarget.removeEventListener(IOErrorEvent.IO_ERROR, onSongLoadError);
			totalSongsLoaded++;
			checkIfAllSoundsLoaded()
		}

		private static function onSongLoadError(e:IOErrorEvent):void {
			trace("Error loading sound: " + e.text);
			// Even if there's an error, we should count this as "finished" loading attempt, so that we don't get stuck waiting for a missing file.
			totalSongsLoaded++;
			checkIfAllSoundsLoaded()
		}
		private static function onSoundLoadError(e:IOErrorEvent):void {
			trace("Error loading sound: " + e.text);
			// Even if there's an error, we should count this as "finished" loading attempt, so that we don't get stuck waiting for a missing file.
			totalSoundsLoaded++;
			checkIfAllSoundsLoaded()
		}

		private static function checkIfAllSoundsLoaded():void {
			if (totalSoundsToLoad != -1 && totalSongsToLoad != -1) {
				if (totalSoundsLoaded >= totalSoundsToLoad && totalSongsLoaded >= totalSongsToLoad) {
					finishedLoading = true;
					trace("All sounds are finished loading: Sounds: (" + totalSoundsToLoad + "/" + totalSoundsLoaded + ") Songs: (" + totalSongsToLoad + "/" + totalSongsLoaded + ")");
				
					if (musicMap['mainmenu'] && musicVol > 0) {
						playMusic('mainmenu');
					}
				}
			}
		}
		
		public static function combatMusic(nextTrackName:String, newMusicPriority:int=0, n:int = 150):void {
			combatTimer = n;
			if (newMusicPriority > currentMusicPriority) {
				currentMusicPriority = newMusicPriority;
				playMusic(nextTrackName);
			}
		}
		
		public static function playMusic(nextTrackName:String = null, rep:int = 10000):void {
			if (nextTrackName != null && musicCh && nextTrackName == trackName) {
				trace("Snd.as/playMusic() - Error: Tried to play song: " + nextTrackName + ", but it's already playing");
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

			if (onMusic && musicMap[trackName]) {
				musicCh = musicMap[trackName].play(0, rep, trans);
			}

			trace("Snd.as/playMusic() - Playing song: " + nextTrackName);
		}

		public static function stopMusic():void {
			if (!musicCh) { 
				return;
			}
			trace("Snd.as/stopMusic() - Stopping music");
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

		public static function setGameMuted(b:Boolean):void {
			b? trace("Snd.as/setGameMuted() - Sound unmuted") : trace("Snd.as/setTempMute() - Sound muted");
			soundMuted = b;
		}
		public static function getGameMuted():Boolean {
			return soundMuted;
		}
		public static function setTempMute(b:Boolean):void {
			b? trace("Snd.as/setTempMute() - Temporary mute disabled") : trace("Snd.as/setTempMute() - Temporarily muting sound");
			tempMuted = b;
		}
		public static function getTempMute():Boolean {
			return tempMuted;
		}
		public static function setMusicOption(b:Boolean):void {
			b? trace("Snd.as/onMusic() - Music enabled") : trace("Snd.as/onMusic() - Music disabled");
			onMusic = b;
		}
		public static function getMusicOption():Boolean {
			return onMusic;
		}
		
		public static function ps(soundName:String,nx:Number=-1000,ny:Number=-1000,msec:Number=0,vol:Number=1):SoundChannel {
			const WIDTH_X:Number = 2000; 
			
			// If we're finished loading sounds and not muted
			if (soundMuted || tempMuted) {
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
					var pan:Number = (nx - center.X) / WIDTH_X;
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
		
		public static function pshum(soundName:String, vol:Number=1):void {
			if (soundMuted || tempMuted) return;
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

		private static function pan(x:Number):Number {
			return (x - 250) / 500;
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
			shumTimer--;
			if (shumTimer <= 0) {
				shumTimer = 5;
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
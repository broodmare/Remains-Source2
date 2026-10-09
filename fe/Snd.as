package fe {

	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;

	import fe.audio.SoundAsset;
	import fe.util.Calc;
	import fe.util.Vector2;
	
	public class Snd {
		
		// Holds either sound assets or vectors of sound assets for sounds with variations.
		private static var soundMap:Object = {};
		private static var musicMap:Object = {};
		private static var activeSoundChannels:Vector.<Object>;
		private static var channelOrder:int = 0;
		private static var pendingEffectLoads:Vector.<SoundAsset> = new Vector.<SoundAsset>();
		private static var activeEffectLoads:int = 0;
		private static var pendingMusicLoads:Vector.<SoundAsset> = new Vector.<SoundAsset>();
		private static var activeMusicLoads:int = 0;

		// AIR has a small global SoundChannel limit. Music owns two persistent channels;
		// the remaining channels are managed explicitly for effects.
		private static const MAX_SOUND_CHANNELS:int = 32;
		private static const MUSIC_CHANNELS:int = 2;
		private static const MAX_EFFECT_CHANNELS:int = MAX_SOUND_CHANNELS - MUSIC_CHANNELS;
		private static const HUM_RELEASE_FRAMES:int = 3;
		// These assets contain long trailing silence; cap overlapping retriggers so
		// the silent tail cannot consume every AIR effect channel.
		private static const MAX_FOOTSTEP_CHANNELS:int = 8;
		private static const MAX_WEAPON_FIRE_CHANNELS:int = 12;

		// Loading a bounded number of loose files avoids starting hundreds of decoders at once.
		private static const MAX_CONCURRENT_EFFECT_LOADS:int = 32;
		private static const MAX_CONCURRENT_MUSIC_LOADS:int = 2;

		// Music has two persistent slots: the location track and the combat track.
		private static var musicCh:SoundChannel;
		private static var combatCh:SoundChannel;
		private static var trackName:String = "";
		private static var combatTrackName:String = "";
		private static var baseMusicGain:Number = 1;
		private static var combatMusicGain:Number = 0;
		private static var targetBaseMusicGain:Number = 1;
		private static var targetCombatMusicGain:Number = 0;
		private static var baseMusicLoops:int = 10000;
		private static var combatMusicLoops:int = 10000;
		private static const MUSIC_FADE_STEP:Number = 0.05;

		public static var globalVol:Number = 0.40;
		public static var stepVol:Number = 0.50;
		public static var musicVol:Number = 0.20;
		
		// Sound state flags
		private static var soundMuted:Boolean = false;
		private static var tempMuted:Boolean = true;
		public static var actionCh:SoundChannel;
		private static var currentMusicPriority:int = 0;

		public static var center:Vector2 = new Vector2(1000, 500);

		// Timers
		public static var hitTimer:int = 0;
		private static var combatTimer:int = 0;
		private static var shumArr:Array = [];
		
		// Moved here from world class
		private static var xmlPath:String = "Modules/core/sounds.xml";
		private static var soundPath:String = "Modules/core/sound/";
		private static var musicPath:String = "Modules/core/sound/music/";
		
		// Loading flags and counters
		private static var startedLoading:Boolean = false;
		private static var finishedLoading:Boolean = false;
		public static var totalSoundsToLoad:int = -1;
		public static var totalSoundsLoaded:int = 0;
		public static var totalSongsToLoad:int = -1;
		public static var totalSongsLoaded:int = 0;
		
		public static function initSnd(configObj:Object):void {
			var textLoader:TextLoader;
			var xmlData:XML;
			var musicNode:XML;
			var resourceNode:XML;
			var folderName:String;
			var soundNode:XML;

			trace("Snd.as/initSnd() - Initializing sound");

			if (activeSoundChannels == null) {
				activeSoundChannels = new Vector.<Object>();
			}

			if (configObj.data.snd) {
				load(configObj);
			}

			// Loading remains enabled while muted so unmuting does not leave audio cold.
			if (finishedLoading || startedLoading) {
				return;
			}

			textLoader = new TextLoader();
			xmlData = textLoader.syncLoad(xmlPath);

			totalSongsToLoad = 0;
			for each (musicNode in xmlData.music.s) {
				loadMusicResource(String(musicNode.@id));
				totalSongsToLoad++;
			}

			totalSoundsToLoad = 0;
			for each (resourceNode in xmlData.res) {
				folderName = String(resourceNode.@id);
				for each (soundNode in resourceNode.s) {
					loadSoundResource(folderName, soundNode);
				}
			}

			startedLoading = true;
			startQueuedMusicLoads();
			startQueuedEffectLoads();
		}

		private static function loadSoundResource(subDir:String, sndXML:XML):void {
			var soundID:String;
			var asset:SoundAsset;
			var assetVariants:Vector.<SoundAsset>;
			var variant:XML;
			var variantID:String;
			var path:String;
			var resident:Boolean;

			soundID = String(sndXML.@id);
			resident = isResidentEffect(subDir, soundID);

			if (sndXML.s.length() > 0) {
				assetVariants = new Vector.<SoundAsset>();
				soundMap[soundID] = assetVariants;

				for each (variant in sndXML.s) {
					variantID = String(variant.@id);
					path = soundPath + subDir + "/" + variantID + ".mp3";
					asset = createEffectAsset(path, resident || isResidentEffect(subDir, variantID));
					assetVariants.push(asset);
					totalSoundsToLoad++;
				}
			}
			else {
				path = soundPath + subDir + "/" + soundID + ".mp3";
				asset = createEffectAsset(path, resident);
				soundMap[soundID] = asset;
				totalSoundsToLoad++;
			}
		}

		private static function isResidentEffect(subDir:String, soundID:String):Boolean {
			if (subDir == "unit") {
				return true;
			}

			if (subDir == "weapons") {
				return true;
			}

			if (subDir == "misc") {
				return soundID == "hit_flesh" || soundID == "hit_concrete" || soundID == "hit_metal" ||
					soundID == "hit_wood" || soundID == "hit_bullet" || soundID == "electro" || soundID == "acid";
			}

			return false;
		}

		private static function loadMusicResource(musicID:String):void {
			var asset:SoundAsset;

			asset = new SoundAsset(musicPath + musicID + ".mp3");
			asset.addEventListener(Event.COMPLETE, onMusicLoaded);
			asset.addEventListener(SoundAsset.LOAD_ERROR, onSongLoadError);
			musicMap[musicID] = asset;
			pendingMusicLoads.push(asset);
		}

		private static function startQueuedMusicLoads():void {
			var asset:SoundAsset;

			while (activeMusicLoads < MAX_CONCURRENT_MUSIC_LOADS && pendingMusicLoads.length > 0) {
				asset = pendingMusicLoads.shift();
				activeMusicLoads++;
				asset.load();
			}
		}

		private static function createEffectAsset(path:String, resident:Boolean):SoundAsset {
			var asset:SoundAsset;

			asset = new SoundAsset(path);
			asset.addEventListener(Event.COMPLETE, onSoundEffectLoaded);
			asset.addEventListener(SoundAsset.LOAD_ERROR, onSoundLoadError);
			if (resident) {
				pendingEffectLoads.unshift(asset);
			}
			else {
				pendingEffectLoads.push(asset);
			}
			return asset;
		}

		private static function startQueuedEffectLoads():void {
			var asset:SoundAsset;

			while (activeEffectLoads < MAX_CONCURRENT_EFFECT_LOADS && pendingEffectLoads.length > 0) {
				asset = pendingEffectLoads.shift();
				activeEffectLoads++;
				asset.load();
			}
		}

		private static function onSoundEffectLoaded(event:Event):void {
			var asset:SoundAsset;

			asset = event.currentTarget as SoundAsset;
			if (asset == null) {
				return;
			}

			asset.removeEventListener(Event.COMPLETE, onSoundEffectLoaded);
			asset.removeEventListener(SoundAsset.LOAD_ERROR, onSoundLoadError);
			if (activeEffectLoads > 0) {
				activeEffectLoads--;
			}
			totalSoundsLoaded++;
			startQueuedEffectLoads();
			checkIfAllSoundsLoaded();
		}
		
		private static function onMusicLoaded(event:Event):void {
			var asset:SoundAsset;

			asset = event.currentTarget as SoundAsset;
			if (asset == null) {
				return;
			}

			asset.removeEventListener(Event.COMPLETE, onMusicLoaded);
			asset.removeEventListener(SoundAsset.LOAD_ERROR, onSongLoadError);
			if (activeMusicLoads > 0) {
				activeMusicLoads--;
			}
			totalSongsLoaded++;
			startQueuedMusicLoads();
			tryStartBaseMusic();
			tryStartCombatMusic();
			checkIfAllSoundsLoaded();
		}

		private static function onSongLoadError(event:IOErrorEvent):void {
			var asset:SoundAsset;

			asset = event.currentTarget as SoundAsset;
			if (asset != null) {
				asset.removeEventListener(Event.COMPLETE, onMusicLoaded);
				asset.removeEventListener(SoundAsset.LOAD_ERROR, onSongLoadError);
				trace("Error loading music: " + asset.assetPath + " - " + event.text);
			}

			if (activeMusicLoads > 0) {
				activeMusicLoads--;
			}
			totalSongsLoaded++;
			startQueuedMusicLoads();
			checkIfAllSoundsLoaded();
		}

		private static function onSoundLoadError(event:IOErrorEvent):void {
			var asset:SoundAsset;

			asset = event.currentTarget as SoundAsset;
			if (asset != null) {
				asset.removeEventListener(Event.COMPLETE, onSoundEffectLoaded);
				asset.removeEventListener(SoundAsset.LOAD_ERROR, onSoundLoadError);
				trace("Error loading sound: " + asset.assetPath + " - " + event.text);
			}

			if (activeEffectLoads > 0) {
				activeEffectLoads--;
			}
			totalSoundsLoaded++;
			startQueuedEffectLoads();
			checkIfAllSoundsLoaded();
		}

		private static function checkIfAllSoundsLoaded():void {
			if (totalSoundsToLoad != -1 && totalSongsToLoad != -1 &&
				totalSoundsLoaded >= totalSoundsToLoad && totalSongsLoaded >= totalSongsToLoad) {
				if (!finishedLoading) {
					finishedLoading = true;
					trace("All audio is ready: Sounds: (" + totalSoundsToLoad + "/" + totalSoundsLoaded + ") Songs: (" + totalSongsToLoad + "/" + totalSongsLoaded + ")");
				}

				if (musicMap["mainmenu"] && trackName == "") {
					playMusic("mainmenu");
				}
			}
		}

		public static function get audioReady():Boolean {
			return finishedLoading;
		}
		
		public static function combatMusic(nextTrackName:String, newMusicPriority:int=0, n:int=150):void {
			var shouldSwitch:Boolean;

			combatTimer = n;
			targetBaseMusicGain = 0;
			targetCombatMusicGain = 1;
			shouldSwitch = combatCh == null || newMusicPriority > currentMusicPriority;
			if (shouldSwitch) {
				if (combatCh != null && combatTrackName != nextTrackName) {
					combatCh.stop();
					combatCh = null;
					combatMusicGain = 0;
				}
				currentMusicPriority = newMusicPriority;
				combatTrackName = nextTrackName;
				tryStartCombatMusic();
			}
		}

		public static function playMusic(nextTrackName:String=null, rep:int=10000):void {
			var asset:SoundAsset;

			if (nextTrackName != null) {
				if (musicCh != null && nextTrackName == trackName) {
					return;
				}

				trackName = nextTrackName;
				baseMusicLoops = rep;
				currentMusicPriority = 0;

				if (musicCh != null) {
					musicCh.stop();
					musicCh = null;
				}
				baseMusicGain = combatMusicActive() ? 0 : 1;
				targetBaseMusicGain = combatMusicActive() ? 0 : 1;
			}

			asset = musicMap[trackName] as SoundAsset;
			if (asset == null || asset.isLoadFailed) {
				return;
			}

			tryStartBaseMusic();
		}

		private static function tryStartBaseMusic():void {
			var asset:SoundAsset;
			var transform:SoundTransform;

			if (musicCh != null || trackName == "") {
				return;
			}

			asset = musicMap[trackName] as SoundAsset;
			if (asset == null || !asset.isLoaded) {
				return;
			}

			transform = new SoundTransform(musicVol * baseMusicGain, 0);
			musicCh = asset.play(0, baseMusicLoops, transform);
		}

		private static function tryStartCombatMusic():void {
			var asset:SoundAsset;
			var transform:SoundTransform;

			if (!combatMusicActive() || combatTrackName == "") {
				return;
			}

			if (combatCh != null) {
				return;
			}

			asset = musicMap[combatTrackName] as SoundAsset;
			if (asset == null || !asset.isLoaded) {
				return;
			}

			transform = new SoundTransform(musicVol * combatMusicGain, 0);
			combatCh = asset.play(0, combatMusicLoops, transform);
		}

		private static function combatMusicActive():Boolean {
			return combatTimer > 0;
		}

		private static function updateMusicMix():void {
			var transform:SoundTransform;

			if (baseMusicGain < targetBaseMusicGain) {
				baseMusicGain = Math.min(targetBaseMusicGain, baseMusicGain + MUSIC_FADE_STEP);
			}
			else if (baseMusicGain > targetBaseMusicGain) {
				baseMusicGain = Math.max(targetBaseMusicGain, baseMusicGain - MUSIC_FADE_STEP);
			}

			if (combatMusicGain < targetCombatMusicGain) {
				combatMusicGain = Math.min(targetCombatMusicGain, combatMusicGain + MUSIC_FADE_STEP);
			}
			else if (combatMusicGain > targetCombatMusicGain) {
				combatMusicGain = Math.max(targetCombatMusicGain, combatMusicGain - MUSIC_FADE_STEP);
			}

			if (musicCh != null) {
				transform = new SoundTransform(musicVol * baseMusicGain, 0);
				musicCh.soundTransform = transform;
			}

			if (combatCh != null) {
				transform = new SoundTransform(musicVol * combatMusicGain, 0);
				combatCh.soundTransform = transform;
			}
		}

		public static function stopMusic():void {
			if (musicCh != null) {
				musicCh.stop();
				musicCh = null;
			}
			if (combatCh != null) {
				combatCh.stop();
				combatCh = null;
			}
			trackName = "";
			combatTrackName = "";
			baseMusicGain = 0;
			combatMusicGain = 0;
			targetBaseMusicGain = 0;
			targetCombatMusicGain = 0;
		}

		public static function updateMusicVol():void {
			tryStartBaseMusic();
			tryStartCombatMusic();
			updateMusicMix();
		}

		public static function setGameMuted(b:Boolean):void {
			b ? trace("Snd.as/setGameMuted() - Sound muted")
			  : trace("Snd.as/setGameMuted() - Sound unmuted");
			soundMuted = b;
		}
		public static function getGameMuted():Boolean {
			return soundMuted;
		}

		public static function setTempMute(b:Boolean):void {
			b ? trace("Snd.as/setTempMute() - Temporarily muting sound")
			  : trace("Snd.as/setTempMute() - Temporary mute disabled");
			tempMuted = b;
		}
		public static function getTempMute():Boolean {
			return tempMuted;
		}
		
		private static function getLoadedSoundAsset(soundName:String):SoundAsset {
			var entry:*;
			var variants:Vector.<SoundAsset>;
			var variantIndex:int;
			var i:int;
			var asset:SoundAsset;

			entry = soundMap[soundName];
			if (entry == null) {
				return null;
			}

			if (entry is Vector.<SoundAsset>) {
				variants = entry as Vector.<SoundAsset>;
				if (variants.length == 0) {
					return null;
				}

				// Try every variant, starting at a random one, so partial loading
				// cannot make an otherwise ready sound silently fail.
				variantIndex = Calc.intBetween(0, variants.length - 1);
				for (i = 0; i < variants.length; i++) {
					asset = variants[(variantIndex + i) % variants.length];
					if (asset != null && asset.isLoaded) {
						return asset;
					}
				}
				return null;
			}

			asset = entry as SoundAsset;
			return asset != null && asset.isLoaded ? asset : null;
		}

		private static function getEffectPriority(soundName:String):int {
			if (soundName.indexOf("footstep") == 0 || soundName.indexOf("metalstep") == 0 || soundName.indexOf("lazstep") == 0) {
				return 30;
			}

			// Weapon fire and weapon charge sounds use the *_s naming convention.
			if (soundName.length >= 2 && soundName.substr(soundName.length - 2) == "_s") {
				return 40;
			}

			return 10;
		}

		private static function getEffectFamily(soundName:String):String {
			if (soundName.indexOf("footstep") == 0 || soundName.indexOf("metalstep") == 0 || soundName.indexOf("lazstep") == 0) {
				return "footstep";
			}

			if (soundName.length >= 2 && soundName.substr(soundName.length - 2) == "_s") {
				return "weaponFire";
			}

			return "";
		}

		private static function getEffectFamilyLimit(family:String):int {
			if (family == "footstep") {
				return MAX_FOOTSTEP_CHANNELS;
			}

			if (family == "weaponFire") {
				return MAX_WEAPON_FIRE_CHANNELS;
			}

			return 0;
		}

		private static function findSoundChannelIndex(channel:SoundChannel):int {
			var i:int;
			var record:Object;

			if (channel == null || activeSoundChannels == null) {
				return -1;
			}

			for (i = 0; i < activeSoundChannels.length; i++) {
				record = activeSoundChannels[i];
				if (record.channel == channel) {
					return i;
				}
			}

			return -1;
		}

		private static function releaseSoundChannel(channel:SoundChannel, stop:Boolean):void {
			var index:int;
			var record:Object;
			var hum:Object;

			if (channel == null) {
				return;
			}

			index = findSoundChannelIndex(channel);
			if (index == -1) {
				if (stop) {
					channel.stop();
				}
				return;
			}

			record = activeSoundChannels[index];
			channel.removeEventListener(Event.SOUND_COMPLETE, onSoundChannelComplete);
			hum = record.hum as Object;
			if (hum != null && hum.ch == channel) {
				hum.ch = null;
				hum.pl = false;
				hum.curVol = 0;
			}
			if (stop) {
				channel.stop();
			}
			activeSoundChannels.splice(index, 1);
		}

		private static function makeEffectChannelRoom(priority:int, family:String):Boolean {
			var i:int;
			var candidateIndex:int = -1;
			var candidatePriority:int = 2147483647;
			var candidateOrder:int = 2147483647;
			var familyCandidateIndex:int = -1;
			var familyCandidateOrder:int = 2147483647;
			var familyCount:int = 0;
			var familyLimit:int;
			var record:Object;

			if (activeSoundChannels == null) {
				activeSoundChannels = new Vector.<Object>();
			}

			familyLimit = getEffectFamilyLimit(family);
			if (familyLimit > 0) {
				for (i = 0; i < activeSoundChannels.length; i++) {
					record = activeSoundChannels[i];
					if (record.family == family) {
						familyCount++;
						if (record.order < familyCandidateOrder) {
							familyCandidateIndex = i;
							familyCandidateOrder = record.order;
						}
					}
				}

				if (familyCount >= familyLimit && familyCandidateIndex != -1) {
					releaseSoundChannel(activeSoundChannels[familyCandidateIndex].channel as SoundChannel, true);
				}
			}

			if (activeSoundChannels.length < MAX_EFFECT_CHANNELS) {
				return true;
			}

			for (i = 0; i < activeSoundChannels.length; i++) {
				record = activeSoundChannels[i];
				if (record.priority < candidatePriority ||
					(record.priority == candidatePriority && record.order < candidateOrder)) {
					candidateIndex = i;
					candidatePriority = record.priority;
					candidateOrder = record.order;
				}
			}

			// Never cut an equal or more important sound just to make room.
			if (candidateIndex == -1 || candidatePriority >= priority) {
				return false;
			}

			releaseSoundChannel(activeSoundChannels[candidateIndex].channel as SoundChannel, true);
			return true;
		}

		private static function registerSoundChannel(channel:SoundChannel, priority:int, family:String, hum:Object=null):void {
			var record:Object;

			if (channel == null) {
				return;
			}

			if (activeSoundChannels == null) {
				activeSoundChannels = new Vector.<Object>();
			}

			record = {channel:channel, priority:priority, family:family, order:channelOrder++, hum:hum};
			activeSoundChannels.push(record);
			channel.addEventListener(Event.SOUND_COMPLETE, onSoundChannelComplete);
		}

		private static function playEffect(asset:SoundAsset, startMilliseconds:Number, loops:int,
			transform:SoundTransform, priority:int, family:String, hum:Object=null):SoundChannel {
			var channel:SoundChannel;

			if (asset == null || !asset.isLoaded || !makeEffectChannelRoom(priority, family)) {
				return null;
			}

			channel = asset.play(startMilliseconds, loops, transform);
			if (channel != null) {
				if (hum != null) {
					hum.ch = channel;
				}
				registerSoundChannel(channel, priority, family, hum);
			}
			return channel;
		}
		
		public static function ps(soundName:String, nx:Number=-1000, ny:Number=-1000, msec:Number=0, vol:Number=1):SoundChannel {
			const WIDTH_X:Number = 2000;
			var asset:SoundAsset;
			var pan:Number;
			var transform:SoundTransform;
			var channel:SoundChannel;

			if (soundMuted || tempMuted || globalVol <= 0 || vol <= 0) {
				return null;
			}

			asset = getLoadedSoundAsset(soundName);
			if (asset == null) {
				return null;
			}

			pan = (nx - center.X) / WIDTH_X;
			if (nx == -1000) {
				pan = 0;
			}

			transform = new SoundTransform(vol * globalVol * Calc.floatBetween(0.9, 1.0), pan);
			return playEffect(asset, msec, 0, transform, getEffectPriority(soundName), getEffectFamily(soundName));
		}

		private static function onSoundChannelComplete(event:Event):void {
			var channel:SoundChannel;

			channel = event.currentTarget as SoundChannel;
			releaseSoundChannel(channel, false);
		}

		public static function stopChannel(channel:SoundChannel):void {
			releaseSoundChannel(channel, true);
		}

		public static function pshum(soundName:String, vol:Number=1):void {
			var shum:Object;

			if (soundMuted || tempMuted || globalVol <= 0 || vol <= 0) {
				return;
			}

			if (shumArr[soundName]) {
				shum = shumArr[soundName];
				if (shum.targetVol < vol) {
					shum.targetVol = vol;
				}
			}
			else if (soundMap[soundName] != null) {
				shum = {};
				shum.soundName = soundName;
				shum.curVol = 0;
				shum.targetVol = vol;
				shum.silentFrames = 0;
				shum.pl = false;
				shum.ch = null;
				shumArr[soundName] = shum;
			}
		}

		public static function step():void {
			var transform:SoundTransform;
			var obj:Object;
			var asset:SoundAsset;
			var channel:SoundChannel;

			if (hitTimer > 0) {
				hitTimer--;
			}

			if (combatTimer > 0) {
				if (World.w.pip == null || !World.w.pip.active && !World.w.sats.active) {
					combatTimer--;
				}
				if (combatTimer == 1) {
					currentMusicPriority = 0;
					targetCombatMusicGain = 0;
					targetBaseMusicGain = 1;
				}
			}

			if (combatMusicActive()) {
				tryStartCombatMusic();
			}
			else if (combatCh != null && combatMusicGain <= 0) {
				combatCh.stop();
				combatCh = null;
				combatTrackName = "";
			}

			tryStartBaseMusic();
			updateMusicMix();

			for each (obj in shumArr) {
				if (obj.targetVol > 0) {
					obj.silentFrames = 0;
					transform = new SoundTransform(obj.targetVol * globalVol, 0);

					if (!obj.pl || obj.ch == null) {
						obj.pl = false;
						obj.ch = null;
						obj.curVol = 0;
						asset = getLoadedSoundAsset(obj.soundName);
						if (asset != null && asset.isLoaded) {
							channel = playEffect(asset, 0, 10000, transform, 0, "hum", obj);
							if (channel != null) {
								obj.pl = true;
								obj.curVol = obj.targetVol;
							}
						}
					}
					else {
						obj.ch.soundTransform = transform;
						obj.curVol = obj.targetVol;
					}
				}
				else {
					obj.silentFrames++;
					if (obj.pl && obj.ch != null && obj.silentFrames >= HUM_RELEASE_FRAMES) {
						stopChannel(obj.ch);
						obj.ch = null;
						obj.pl = false;
						obj.curVol = 0;
					}
				}

				// Snd.step() runs before the game step, so the next pshum() call
				// supplies the request for the following frame.
				obj.targetVol = 0;
			}
		}

		public static function save():* {
			var obj:Object;

			obj = {};
			obj.globalVol = globalVol;
			obj.stepVol = stepVol;
			obj.musicVol = musicVol;
			return obj;
		}
		
		public static function load(obj:Object):void {
			if (obj.data.snd.globalVol != null && !isNaN(obj.data.snd.globalVol)) {
				globalVol = obj.data.snd.globalVol;
			}
			
			if (obj.data.snd.stepVol != null && !isNaN(obj.data.snd.stepVol)) {
				stepVol = obj.data.snd.stepVol;
			}
			
			if (obj.data.snd.musicVol != null && !isNaN(obj.data.snd.musicVol)) {
				musicVol = obj.data.snd.musicVol;
			}
		
			updateMusicVol();
		}
	}
}

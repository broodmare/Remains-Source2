package fe
{
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	
	public class Snd {
		public static var snd:Object = {};
		public static var globalVol = 0.4;		// Used by pipbuckOpt as a string.
		public static var stepVol = 0.5;		// Used by pipbuckOpt as a string.
		public static var musicVol = 0.2;		// Used by pipbuckOpt as a string.
		public static var music:Sound;
		public static var musics:Object = {};
		public static var sndNames:Array = ['mp5'];
		public static var musicName:String='';
		public static var onSnd:Boolean=true;
		public static var onMusic:Boolean=true;
		
		public static var musicCh:SoundChannel;
		public static var musicPrevCh:SoundChannel;
		public static var actionCh:SoundChannel;

		public static var currentMusicPrior:int = 0;
		
		public static var t_hit:int = 0;
		public static var t_combat:int = 0;

		public static var centrX:Number = 1000;
		public static var centrY:Number = 500;
		public static var widthX:Number = 2000; 
		public static var t_music:int = 0;
		public static var t_shum:int = 0;
		private static var inited:Boolean = false;
		public static var off:Boolean = true;
		
		public static var shumArr:Array;

		// Moved here from world class
		private static var soundPath = 'Modules/core/sound/';
		private static var musicPath = 'Modules/core/sound/music';

		private static var soundXML:XML;	// XML Containing file names of all songs, weapon noises, creature noises, etc. (Does not have file extension)
		private static var xmlPath:String = "Modules/core/sounds.xml";

		private static var d:XML;
		
		public static function pan(x:Number):Number {
			return (x - 250) / 500;
		}

		public static function initSnd():void {
			var xmlLoader:XMLLoader = new XMLLoader();
			d = xmlLoader.syncLoad(xmlPath);

			if (inited || !onSnd) return;

			// Load main menu sound:
			var mmSongPath:String = soundPath + "music/" + "mainmenu.mp3";
			trace("Snd.as/initSnd() - Trying to load MainMenu song from: " + mmSongPath);
			var req:URLRequest = new URLRequest(mmSongPath);
			var s:Sound = new Sound(req);
			s.addEventListener(Event.COMPLETE, mmLoaded);
			s.addEventListener(IOErrorEvent.IO_ERROR, onSoundLoadError);
			snd['mainmenu'] = s;

			// Now load all resources:
			for each (var i:XML in d.res) {
				// Get folder name from i.@id, e.g. "weapons"
				var folderName:String = i.@id;

				for each (var sndXML:XML in i.s) {
					loadSoundResource(folderName, sndXML);
				}
			}

			shumArr = [];
			inited = true;
		}

		private static function loadSoundResource(subDir:String, sndXML:XML):void {
			var soundID:String = sndXML.@id;
			// Check if this <s> has nested <s>, indicating multiple variations:
			if (sndXML.s.length() > 0) {
				// We have multiple sounds under this ID
				snd[soundID] = [];
				for each (var variant:XML in sndXML.s) {
					var variantID:String = variant.@id;
					var variantReq:URLRequest = new URLRequest(soundPath + subDir + "/" + variantID + ".mp3");
					var variantSound:Sound = new Sound(variantReq);
					variantSound.addEventListener(IOErrorEvent.IO_ERROR, onSoundLoadError);
					snd[soundID].push(variantSound);
				}
			}
			else {
				// Single sound
				var req:URLRequest = new URLRequest(soundPath + subDir + "/" + soundID + ".mp3");
				var s:Sound = new Sound(req);
				s.addEventListener(IOErrorEvent.IO_ERROR, onSoundLoadError);
				snd[soundID] = s;
			}
		}
		
		public static function loadMusic():void {
			var req:URLRequest;
			var s:Sound;
			for each (var j:XML in d.music.s) {
				var id:String = j.@id;
				try {
					req = new URLRequest(soundPath + "music/" + id + ".mp3");
					s = new Sound(req);
					s.addEventListener(Event.COMPLETE, musicLoaded);
					s.addEventListener(IOErrorEvent.IO_ERROR, onSoundLoadError);
					snd[id] = s;
					World.w.musicKol++;
				}
				catch (err:Error) {
					trace('ERROR: (00:1E) - music load err', req.url);
				}
			}
		}

		private static function onSoundLoadError(e:IOErrorEvent):void {
			trace("Error loading sound: " + e.text);
			
		}
		
		static private function mmLoaded(event:Event):void {
			// Clean up listeners
			event.currentTarget.removeEventListener(Event.COMPLETE, mmLoaded);
			event.currentTarget.removeEventListener(IOErrorEvent.IO_ERROR, onSoundLoadError);
			// Play the song if applicable
			if (musicVol > 0) {
				playMusic('mainmenu');
			}
		}

		static private function musicLoaded(event:Event):void {
			World.w.musicLoaded++;
			event.currentTarget.removeEventListener(Event.COMPLETE, musicLoaded);  
		}
		
		public static function combatMusic(sndMusic:String, sndMusicPrior:int=0, n:int=150):void {
			t_combat = n;
			if (sndMusicPrior > currentMusicPrior) {
				currentMusicPrior = sndMusicPrior;
				playMusic(sndMusic);
			}
		}
		
		
		public static function playMusic(sndMusic:String=null, rep:int=10000):void {
			if (!inited) {
				return;
			}
			
			if (sndMusic != null && musicCh && sndMusic == musicName) {
				return;
			}
			
			if (sndMusic != null) {
				musicName = sndMusic;
			}

			var trans:SoundTransform = new SoundTransform(musicVol, 0);
			
			if (musicCh) {
				if (musicPrevCh || t_music > 0) musicPrevCh.stop();
				musicPrevCh = musicCh;
				musicCh = null;
				t_music = 100;
			}

			currentMusicPrior = 0;

			if (onMusic && snd[musicName] && snd[musicName].bytesTotal && snd[musicName].bytesLoaded == snd[musicName].bytesTotal) {
				musicCh = snd[musicName].play(0, rep, trans);
			}
		}

		public static function stopMusic():void {
			if (!inited || !musicCh) { 
				return;
			}
			musicCh.stop();
		}

		public static function updateMusicVol():void {
			if (musicCh) {
				var trans:SoundTransform = new SoundTransform(musicVol, 0);
				musicCh.soundTransform=trans;
			} 
			else {
				playMusic();
			}
		}
		
		public static function ps(txt:String,nx:Number=-1000,ny:Number=-1000,msec:Number=0,vol:Number=1):SoundChannel
		{
			if (!inited || !onSnd || off) return null;
			if (snd[txt])
			{
				var s:Sound;
				if (snd[txt] is Array) s = snd[txt][Math.floor(Math.random()*snd[txt].length)];
				else s = snd[txt] as Sound;
				if (s.bytesTotal>0 && s.bytesLoaded>=s.bytesTotal)
				{
					var pan:Number=(nx-centrX)/widthX;
					if (nx==-1000) pan=0;
					var trans:SoundTransform = new SoundTransform(vol*globalVol*(Math.random()*0.1+0.9),pan); 
					return s.play(msec,0,trans);
				}
			}
			return null;
		}
		
		public static function pshum(txt:String,vol:Number=1):void
		{
			if (!inited || !onSnd || off) return;
			var shum:Object;
			if (shumArr[txt])
			{
				shum=shumArr[txt];
				if (shum.maxVol<vol) shum.maxVol=vol;
			}
			else if (snd[txt])
			{
				shum=new Object();
				shum.txt=txt;
				shum.curVol=vol;
				shum.maxVol=vol;
				shum.pl=false;
				shumArr[txt]=shum;
			}
		}
		
		public static function resetShum():void
		{

		}
		
		public static function step():void
		{
			if (t_hit>0) t_hit--;

			if (t_music>0 && musicPrevCh)
			{
				var trans:SoundTransform;
				if (t_music%10==1)
				{
					trans = new SoundTransform(musicVol*t_music/100, 0);
					musicPrevCh.soundTransform=trans;
				}
				if (t_music<=5)
				{
					musicPrevCh.stop();
					musicPrevCh=null;
					t_music=0;
				}
				if (t_combat>0) t_music -= 5;
				else t_music--;
			}

			if (t_combat > 0)
			{
				if (t_combat == 1)
				{
					currentMusicPrior = 0;
					playMusic(World.w.currentMusic);
				}
				if (World.w.pip == null || !World.w.pip.active && !World.w.sats.active) t_combat--;
			}

			t_shum--;

			if (t_shum <= 0)
			{
				t_shum = 5;
				for each (var obj:Object in shumArr)
				{
					if (obj.curVol!=obj.maxVol)
					{
						if (!obj.pl && obj.maxVol>0)
						{
							var s:Sound = snd[obj.txt] as Sound;
							trans = new SoundTransform(obj.maxVol*globalVol,0); 
							obj.ch=s.play(0,10000,trans);
							obj.pl=true;
						} 
						else if (obj.pl && obj.maxVol<=0 && obj.ch)
						{
							obj.ch.stop();
							obj.pl=false;
						} 
						else if (obj.pl && obj.maxVol>0 && obj.ch)
						{
							trans = new SoundTransform(obj.maxVol*globalVol,0);
							obj.ch.soundTransform=trans;
							obj.curVol=obj.maxVol;
						}
					}
					obj.maxVol-=0.2;
					if (obj.maxVol<0) obj.maxVol=0;
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
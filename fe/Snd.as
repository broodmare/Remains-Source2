package fe{
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.utils.*;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	
	public class Snd {
		public static var snd:Array=new Array();
		public static var globalVol=0.4;
		public static var stepVol=0.5;
		public static var musicVol=0.2;
		public static var music:Sound;
		public static var musics:Array=new Array();
		public static var sndNames:Array = ['mp5'];
		public static var musicName:String='';
		public static var onSnd:Boolean=true;
		public static var onMusic:Boolean=true;
			
		public static var resSnd:Loader;
		public static var resSounds:*;
		//public static var resIsLoad:Boolean=false;
		
		public static var musicCh:SoundChannel;
		public static var musicPrevCh:SoundChannel;
		public static var actionCh:SoundChannel;
		public static var currentMusicPrior:int=0;
		
		public static var t_hit:int=0;
		public static var t_combat:int=0;
		public static var centrX:Number=1000, centrY:Number=500, widthX=2000;
		public static var t_music:int=0;
		public static var t_shum:int=0;
		static var inited:Boolean=false;
		public static var off:Boolean=true;
		
		public static var shumArr:Array;
		
		function Snd() {
		}
		
		public static var d:XML=
		<all>
			<music>
				<s id='music_begin'/>
				<s id='music_strange'/>
				<s id='music_base'/>
				<s id='music_surf'/>
				<s id='music_enc'/>
				<s id='music_raiders'/>
				<s id='music_plant_1'/>
				<s id='music_plant_2'/>
				<s id='music_sewer_1'/>
				<s id='music_stable_1'/>
				<s id='music_stable_2'/>
				<s id='music_cat_1'/>
				<s id='music_mane_1'/>
				<s id='music_mane_2'/>
				<s id='music_mbase'/>
				<s id='music_covert'/>
				<s id='music_minst'/>
				<s id='music_encl_1'/>
				<s id='music_encl_2'/>
				<s id='music_pi'/>
				<s id='music_workshop'/>
				<s id='music_hql'/>
				<s id='music_red'/>
				<s id='music_fall_1'/>
				<s id='music_fall_2'/>
				<s id='music_end'/>
				<s id='pre_1'/>
				<s id='combat_1'/>
				<s id='boss_1'/>
				<s id='boss_2'/>
				<s id='boss_3'/>
				<s id='boss_4'/>
				<s id='boss_5'/>
				<s id='boss_6'/>
			</music>
			<res id='sound_weapon.swf'>
				<!-- выстрелы -->
				<s id='p10mm_s'/>
				<s id='silen_s'/>
				<s id='revo_s'/>
				<s id='p127_s'/>
				<s id='smg10mm_s'/>
				<s id='rifle_s'/>
				<s id='zebr_s'/>
				<s id='pp127_s'/>
				<s id='lmg_s'/>
				<s id='hmg_s'/>
				<s id='oldshot_s'/>
				<s id='shotgun_s'/>
				<s id='saf9_s'/>
				<s id='pshot_s'/>
				<s id='hunt_s'/>
				<s id='winchester_s'/>
				<s id='brushgun_s'/>
				<s id='sniper_s'/>
				<s id='anti_s'/>
				<s id='antidrak_s'/>
				<s id='spitfire_s'/>
				<s id='minigun_s'/>

				<s id='las_s'/>
				<s id='plap_s'/>
				<s id='laser_s'/>
				<s id='laser2_s'/>
				<s id='prisma_s'/>
				<s id='plasma_s'/>
				<s id='caster_s'/>
				<s id='spark_s'/>
				<s id='grom_s'/>
				<s id='rail_s'/>
				<s id='gatl_s'/>
				<s id='arson_s'/>
				<s id='flamer_s'/>
				<s id='bfg_s'/>
				<s id='bfg_p'/>
				<s id='incin_s'/>
				<s id='termo_s'/>
				<s id='pulse_s'/>
				<s id='cryo_s'/>
				<s id='quick_s'/>
				<s id='blaster_s'/>
				<s id='lasercraft_s'/>
				<s id='owl_s'/>

				<s id='railway_s'/>
				<s id='sawgun_s'/>
				
				<s id='glau_s'/>
				<s id='rocket_s'/>

				<!-- перезарядка -->
				<s id='no_ammo'/>
				<s id='p10mm_r'/>
				<s id='revo_r'/>
				<s id='rifle_r'/>
				<s id='rifle2_r'/>
				<s id='sniper_r'/>
				<s id='shotgun_r'/>
				<s id='laser_r'/>
				<s id='flamer_r'/>
				
				<!-- холодное оружие -->
				<s id='m_big'/>
				<s id='m_med'/>
				<s id='m_small'/>
				<s id='lasm_s'/>
				<s id='lasm_h'/>
				<s id='pila_s'/>
				<s id='autoaxe_s'/>
				<s id='bsaw_s'/>
				
				<s id='artfire'>
					<s id='artfire1'/>
					<s id='artfire2'/>
				</s>
			</res>
			<res id='sound.swf'>
				<!-- удары по разным предметам -->
				<s id='hit_concrete'/>
				<s id='hit_flesh'/>
				<s id='hit_blade'/>
				<s id='hit_bullet'/>
				<s id='hit_wood'/>
				<s id='hit_metal'/>
				<s id='hit_pole'/>
				<s id='hit_glass'/>
				<s id='hit_water'/>
				<s id='hit_necr'/>
				<s id='break_glass'/>
				<s id='break_wood'/>
				<s id='break_metal'/>
				<s id='electro'/>
				<s id='acid'/>
				<s id='fang_hit'>
					<s id='fang_hit1'/>
					<s id='fang_hit2'/>
					<s id='fang_hit3'/>
				</s>
				<s id='hit_slime'/>
				
				<!-- падение предметов -->
				<s id='fall_grenade'/>
				<s id='fall_metal_big'/>
				<s id='fall_metal_item'/>
				<s id='fall_metal_small'/>
				<s id='fall_metal_safe'/>
				<s id='fall_wood_small'/>
				<s id='fall_wood_big'/>
				<s id='fall_item'/>
				<s id='fall_item_water'/>
				<s id='fall_hammer'/>
				<s id='fall_armor'/>
				<s id='fall_weapon'/>
				<s id='fall_potion'/>
				<s id='fall_paper'/>
				<s id='fall_caps'/>
				<s id='fall_gem'/>
				<s id='fall_body'/>
				<s id='fall_hbody'/>
				<s id='fall_water0'/>
				<s id='fall_water1'/>
				<s id='fall_water2'/>
				
				<!-- двери -->
				<s id='big_door_close'/>
				<s id='metal_door_close'/>
				<s id='metal_door_open'/>
				<s id='wood_door_close'/>
				<s id='wood_door_open'/>
				<s id='metal_open'/>
				<s id='wood_open'/>
				<s id='small_open'/>
				<s id='safe_open'/>
				<s id='pole_off'/>
				
				<!-- дезинтеграция -->
				<s id='desintegr_f'/>
				<s id='liquid_f'/>
				<s id='freezing_f'/>
				<!-- врывчатка -->
				<s id='expl_e'/>
				<s id='fire_e'/>
				<s id='acid_e'/>
				<s id='gas_e'/>
				<s id='cryo_e'/>
				<s id='exppla_e'/>
				<s id='emp_e'/>
				<s id='mine_bip'/>
				<s id='mine_dem'/>
				<s id='mine_s'/>
				<s id='dinamit_f'/>
				<s id='expl_uw'/>
				<s id='bottle_hit'/>
				<s id='bale_e'/>
				<s id='unreal'/>
				
				<!-- магия -->
				<s id='telebul'/>
				<s id='ice'/>
				<s id='lightning'/>
				<s id='mray'/>
				<s id='mwall'/>
				<s id='mshit'/>
				<s id='blast'/>
				<s id='blade'/>
				<s id='blade2'/>
				<s id='crystal'/>
				<s id='dash'/>
				<s id='dray'/>
				<s id='fireball'/>
				<s id='slow'/>
				<s id='teleport'/>
				<s id='wavedef'/>
				
				<!-- использование -->
				<s id='pot_use'/>
				<s id='lock_act'/>
				<s id='term_act'/>
				<s id='rem_act'/>
				<s id='button'/>
				<s id='move'/>
				<s id='alarm'/>

				<!-- интерфейс -->
				<s id='geiger'>
					<s id='geiger1'/>
					<s id='geiger2'/>
					<s id='geiger3'/>
				</s>
				<s id='bonus1'/>
				<s id='bonus2'/>
				<s id='levelup'/>
				<s id='skill'/>
				<s id='pip1'/>
				<s id='pip2'/>
				<s id='pip3'/>
				<s id='quest'/>
				<s id='quest_ok'/>
				<s id='harddie'/>
				<s id='lowhp'/>
				<s id='nomagic'/>
			</res>
			<res id='sound_unit.swf'>
				<!-- шаги -->
				<s id='footstep1'/>
				<s id='footstep2'/>
				<s id='footstep3'/>
				<s id='footstep4'/>
				<s id='footstep1a'/>
				<s id='footstep2a'/>
				<s id='footstep3a'/>
				<s id='footstep4a'/>
				<s id='metalstep1'/>
				<s id='metalstep2'/>
				<s id='metalstep3'/>
				<s id='metalstep4'/>
				<s id='metalstep1a'/>
				<s id='metalstep2a'/>
				<s id='metalstep3a'/>
				<s id='metalstep4a'/>
				<s id='lazstep1'/>
				<s id='lazstep2'/>
				<s id='lazstep3'/>
				<s id='lazstep4'/>
				
				<!-- юниты -->
				<s id='trup'/>
				<s id='trap_a'/>
				<s id='trap_reload'/>
				<s id='cans'/>
				<s id='expl1'/>
				<s id='expl2'/>
				<s id='expl3'/>
				<s id='transmitter'/>
				<s id='vortex'/>
				<s id='vortex_cut'>
					<s id='vortex_cut1'/>
					<s id='vortex_cut2'/>
					<s id='vortex_cut3'/>
				</s>
				<s id='rm'>
					<s id='rm1'/>
					<s id='rm2'/>
					<s id='rm3'/>
					<s id='rm4'/>
					<s id='rm5'/>
					<s id='rm6'/>
				</s>
				<s id='rw'>
					<s id='rw1'/>
					<s id='rw2'/>
					<s id='rw3'/>
					<s id='rw4'/>
					<s id='rw5'/>
					<s id='rw6'/>
				</s>
				<s id='ali'>
					<s id='ali1'/>
					<s id='ali2'/>
					<s id='ali3'/>
				</s>
				<s id='sr'>
					<s id='sr1'/>
					<s id='sr2'/>
					<s id='sr3'/>
				</s>
				<s id='zm'>
					<s id='zm1'/>
					<s id='zm2'/>
					<s id='zm3'/>
				</s>
				<s id='zw'>
					<s id='zw1'/>
					<s id='zw2'/>
					<s id='zw3'/>
				</s>
				<s id='bat'>
					<s id='bat1'/>
					<s id='bat2'/>
				</s>
				<s id='bloat'>
					<s id='bloat1'/>
					<s id='bloat2'/>
					<s id='bloat3'/>
					<s id='bloat4'/>
				</s>
				<s id='scorp'/>
				<s id='slime'/>
				<s id='rat'/>
				<s id='molerat'/>
				<s id='nest'/>
				<s id='drone'/>
				<s id='zombie_res'/>
				<s id='al_armor'/>
			</res>

		
		</all>
		
		public static function save():* {
			var obj:Object=new Object();
			obj.globalVol=globalVol;
			obj.stepVol=stepVol;
			obj.musicVol=musicVol;
			return obj;
		}
		public static function load(obj) {
			if (obj.globalVol!=null && !isNaN(obj.globalVol)) globalVol=obj.globalVol;
			if (obj.stepVol!=null && !isNaN(obj.stepVol)) stepVol=obj.stepVol;
			if (obj.musicVol!=null && !isNaN(obj.musicVol)) musicVol=obj.musicVol;
			if (musicCh) updateMusicVol();
		}
		
		public static function pan(x:Number):Number {
			return (x-250)/500;
		}
		public static function initSnd() {
			if (inited || !onSnd) return;
			var req:URLRequest;
			var s:Sound;
			req = new URLRequest(World.w.musicPath+"mainmenu.mp3");
			s = new Sound(req);
			s.addEventListener(IOErrorEvent.IO_ERROR, onIOError); 
			snd['mainmenu']=s;
			s.addEventListener(Event.COMPLETE, mmLoaded);  
			for each (var i in d.res) {
				resSnd = new Loader();
				var fileSound:String=World.w.soundPath+i.@id;
				if (World.w.playerMode=='PlugIn') {
					//fileSound+='?u='+World.w.fileVersion;
					//fileSound+='?u='+ Math.random().toFixed(5);
				}
				//trace(fileSound+'?u='+World.w.fileVersion);
				var urlReq:URLRequest = new URLRequest(fileSound);
				resSnd.load(urlReq);
				resSnd.contentLoaderInfo.addEventListener(Event.COMPLETE, resLoaded);  
			}
			shumArr=new Array();
			inited=true;
		}
		
		public static function loadMusic() {
			var req:URLRequest;
			var s:Sound;
			for each (var j in d.music.s) {
				var id:String=j.@id;
				try {
					req = new URLRequest(World.w.musicPath+id+".mp3");
					s = new Sound(req);
					s.addEventListener(IOErrorEvent.IO_ERROR, onIOError); 
					s.addEventListener(Event.COMPLETE, musicLoaded);  
					snd[id]=s;
					World.w.musicKol++;
				} catch (err) {
					trace('music load err', req.url);
				}
			}
		}
		
		static function onIOError(event:IOErrorEvent) { }
		
		static function mmLoaded(event:Event):void {
			if (musicVol>0) playMusic('mainmenu');
		}
		static function musicLoaded(event:Event):void {
			World.w.musicLoaded++;
			event.currentTarget.removeEventListener(Event.COMPLETE, musicLoaded);  
			event.currentTarget.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
		}
		
		static function resLoaded(event:Event):void 
		{
			var str:String=event.target.url;
			str=str.substr(str.lastIndexOf('/')+1);
			resSounds = event.target.content;
			var s:Sound;
			var xml=d.res.(@id==str);
			if (xml.length()) {
				for each (var j in xml.s) {
					var id=j.@id;
					if (j.s.length()) {
						snd[id]=new Array();
						for each (var e in j.s) {
							s=resSounds.getSnd(e.@id);
							if (s!=null) snd[id].push(s);
							else trace('res sound err '+id+'.'+e.@id);
						}
					} else {
						s=resSounds.getSnd(id);
						if (s!=null) snd[id]=s;
						else trace('res sound err '+id);
					}
				}
			}
    		//resIsLoad=true;
		}
		
		public static function combatMusic(sndMusic:String, sndMusicPrior:int=0, n:int=150) {
			t_combat=n;
			if (sndMusicPrior>currentMusicPrior) {
				currentMusicPrior=sndMusicPrior;
				playMusic(sndMusic);
			}
		}
		
		
		public static function playMusic(sndMusic:String=null, rep:int=10000) {
			//trace('musvol',musicVol);
			if (!inited) return;
			if (sndMusic!=null && musicCh && sndMusic==musicName) return;
			if (sndMusic!=null) musicName=sndMusic;
			var trans:SoundTransform = new SoundTransform(musicVol, 0);
			if (musicCh) {
				if (musicPrevCh || t_music>0) musicPrevCh.stop();
				musicPrevCh=musicCh;
				musicCh=null;
				t_music=100;
			}
			currentMusicPrior=0;
			if (onMusic && snd[musicName] && snd[musicName].bytesTotal && snd[musicName].bytesLoaded==snd[musicName].bytesTotal) musicCh=snd[musicName].play(0,rep,trans);
		}
		public static function stopMusic() {
			if (!inited || !musicCh) return;
			musicCh.stop();
		}
		public static function updateMusicVol() {
			//if (!onMusic) musicName='';
			if (musicCh) {
				var trans:SoundTransform = new SoundTransform(musicVol, 0);
				musicCh.soundTransform=trans;
			} else {
				playMusic();
			}
		}
		
		public static function ps(txt:String,nx:Number=-1000,ny:Number=-1000,msec:Number=0,vol:Number=1):SoundChannel {
			//trace(txt);
			if (!inited || !onSnd || off) return null;
			if (snd[txt]) {
				var s:Sound;
				if (snd[txt] is Array) s = snd[txt][Math.floor(Math.random()*snd[txt].length)];
				else s = snd[txt] as Sound;
				if (s.bytesTotal>0 && s.bytesLoaded>=s.bytesTotal) {
					var pan:Number=(nx-centrX)/widthX;
					if (nx==-1000) pan=0;
					var trans:SoundTransform = new SoundTransform(vol*globalVol*(Math.random()*0.1+0.9),pan); 
					return s.play(msec,0,trans);
				}
			}
			return null;
		}
		
		public static function pshum(txt:String,vol:Number=1) {
			if (!inited || !onSnd || off) return null;
			var shum:Object;
			if (shumArr[txt]) {
				shum=shumArr[txt];
				if (shum.maxVol<vol) shum.maxVol=vol;
			} else if (snd[txt]) {
				shum=new Object();
				shum.txt=txt;
				shum.curVol=vol;
				shum.maxVol=vol;
				shum.pl=false;
				shumArr[txt]=shum;
			}
		}
		
		public static function resetShum() {
		}
		
		public static function step() {
			//if (World.w.currentMusic!='' && World.w.currentMusic!=currentMusic
			if (t_hit>0) t_hit--;
			if (t_music>0 && musicPrevCh) {
				if (t_music%10==1) {
					var trans:SoundTransform = new SoundTransform(musicVol*t_music/100, 0);
					musicPrevCh.soundTransform=trans;
				}
				if (t_music<=5) {
					musicPrevCh.stop();
					musicPrevCh=null;
					t_music=0;
				}
				if (t_combat>0) t_music-=5;
				else t_music--;
			}
			if (t_combat>0) {
				if (t_combat==1) {
					currentMusicPrior=0;
					playMusic(World.w.currentMusic);
				}
				if (World.w.pip==null || !World.w.pip.active && !World.w.sats.active) t_combat--;
			}
			//if (shumArr.length) {
				t_shum--;
				if (t_shum<=0) {
					t_shum=5;
					for each (var obj in shumArr) {
						if (obj.curVol!=obj.maxVol) {
							if (!obj.pl && obj.maxVol>0) {
								var s:Sound = snd[obj.txt] as Sound;
								var trans:SoundTransform = new SoundTransform(obj.maxVol*globalVol,0); 
								obj.ch=s.play(0,10000,trans);
								obj.pl=true;
								//trace(obj.txt,'play')
							} else if (obj.pl && obj.maxVol<=0 && obj.ch) {
								obj.ch.stop();
								obj.pl=false;
								//trace(obj.txt,'stop')
							} else if (obj.pl && obj.maxVol>0 && obj.ch) {
								var trans:SoundTransform = new SoundTransform(obj.maxVol*globalVol,0);
								obj.ch.soundTransform=trans;
								obj.curVol=obj.maxVol;
							}
						}
						obj.maxVol-=0.2;
						if (obj.maxVol<0) obj.maxVol=0;
					}
				}
			//}
		}
		
	}
}

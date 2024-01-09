package fe {
	
	public class GameData {

		public function GameData() {}

		public static var d:XML=<game>
		
<!-- ============================================== ЛОКАЦИИ ============================================== -->
			<land1 id='test' autolevel='1' file='rooms' locx='0' locy='0' stage='4' limit='1' test='1' list='-11' tip='test'>
				<options  music='music_cat_1' fon='fonRuins'/>
				<scr eve='take' item='captive'>
					<s act="quest" val="freeCaptive"/>
				</scr>
			</land1>
			<land1 id='test2' dif='0' file='rooms2' locx='0' locy='0' stage='4' limit='1' test='1' list='-10' tip='test' fin='0'>
				<options backwall='sky' fon='fonFinalb'  music='music_encl_1' xp='500' color='blue' border='S'/>
				<scr eve='take' item='diary'>
					<s act="dialog" val="velvetDial6"/>
					<s act="stage" val="storyFind" n="2"/>
					<s act="xp" val="5000"/>
				</scr>
			</land1>
		
			<land id='begin' dif='0' file='rooms_begin' locx='0' locy='0' stage='1' limit='1' list='2' tip='story'>
				<options backwall="tBackWall" music='music_begin'/>
				<scr eve='take' item='mont'>
					<s1 act="mess" val="trMont" opt1="1"/>
					<s act="on" targ="trDestroy"/>
					<s act="on" targ="trDoor"/>
				</scr>
				<scr eve='take' item='screwdriver'>
					<s act="on" targ="trDoor"/>
					<s targ="trSign5" act="sign" val="1"/>
				</scr>
				<scr eve='take' item='rech'>
					<s act="weapch" val="rech"/>
				</scr>
				<scr eve='take' item='r32'>
					<s act="weapch" val="r32"/>
				</scr>
				<scr eve='take' item='s_arson'>
					<s act="mess" val="trScheme" opt1="1"/>
				</scr>
				<scr eve='take' item='col1'>
					<s act="quest" val="collectHS"/>
				</scr>
			</land>
			
			<land id='surf' dif='0' file='rooms_surf' locx='0' locy='1' stage='2' limit='1' list='3' tip='story'>
				<options backwall='sky' fon='fonDarkClouds' color='blue' vis='10' music='music_surf'/>
			</land>
			
			<land id='rbl' autolevel='1' dif='0' file='rooms_rbl' locx='0' locy='0' stage='1' list='1' tip='base' fin='0'>
				<options backwall="tStConcrete" fon='fonWay' music='music_base'/>
				<prob id='bossraider1' level='0' tip='2' close='1'>
					<con tip='unit' uid='bossraider1F1'/>
				</prob>
				<prob id='bossraider2' level='0' tip='2' close='1'>
					<con tip='unit' uid='bossraider2F1'/>
				</prob>
				<prob id='bossultra1' level='0' tip='2' close='1'>
					<con tip='unit' uid='bossultra1F1'/>
				</prob>
				<prob id='bossalicorn1' level='0' tip='2' close='1'>
					<con tip='unit' uid='bossalicorn1F1'/>
				</prob>
				<prob id='bossnecr1' level='0' tip='2' close='1'>
					<con tip='unit' uid='bossnecr1F1'/>
				</prob>
				<prob id='bossdron1' level='0' tip='2' close='1'>
					<con tip='unit' uid='bossdron1F1'/>
				</prob>
				<prob id='bossencl' level='0' tip='2' close='1'>
					<con tip='unit' uid='bossenclF1'/>
					<con tip='unit' uid='bossenclF2'/>
					<con tip='unit' uid='bossenclF3'/>
				</prob>
			</land>
			
			<land id='random_plant' tip='rnd' rnd='1' dif='0' biom='0' conf='0' file='rooms_plant' stage='3' exit='exit_plant' mx='4' my='6' locx='0' locy='0' list='4' loadscr='1'>
				<options backwall="tBackWall" music='music_plant_1' fon='fonDarkClouds' xp='100'/>
				<!-- 13 -->
				<prob id='labirint' prize='1' tip='1'>
					<con tip='box' uid='labirintF1'/>
				</prob>
				<prob id='buttons1' tip='1'><!-- ящик с болтами -->
					<con tip='box' uid='buttons1F1'/>
					<con tip='box' uid='buttons1F2'/>
					<con tip='box' uid='buttons1F3'/>
				</prob>
				<prob id='radioactive' level='1' prize='1' tip='1'><!-- схема ультра-дэша -->
					<con tip='box' uid='radioactiveF1'/>
					<con tip='box' uid='radioactiveF2'/>
				</prob>
				<prob id='buttons2' level='1' tip='1'>
					<con tip='box' uid='buttons2F1'/>
					<con tip='box' uid='buttons2F2'/>
				</prob>
				<prob id='buttons3' level='2' tip='1'><!-- нужна "взрывчатка", глицерин -->
					<con tip='box' uid='buttons3F1'/>
					<con tip='box' uid='buttons3F2'/>
					<con tip='box' uid='buttons3F3'/>
					<con tip='box' uid='buttons3F4'/>
					<con tip='box' uid='buttons3F5'/>
					<con tip='box' uid='buttons3F6'/>
					<con tip='box' uid='buttons3F7'/>
				</prob>
				<prob id='sliv' level='2' prize='1' tip='1'><!-- ящик с гайками -->
					<con tip='box' uid='slivF1'/>
				</prob>
				<prob id='tower2' level='2' prize='1' tip='1'><!-- нужен "телекинез", штангенциркуль -->
					<con tip='box' uid='tower2F1'/>
				</prob>
				<prob id='ant_breeding' tip='2'><!-- квест с муравьями -->
					<con tip='unit' qid='antF1'/>
				</prob>
				<prob id='scorpions' level='1' tip='2'><!-- табак -->
					<con tip='unit' qid='scorpionsF1'/>
				</prob>
				<prob id='bloat_breeding' level='2' tip='2'><!-- квест с блотспрайтами -->
					<con tip='unit' qid='bloatF1'/>
				</prob>
				<prob id='director' level='1' tip='2'> <!-- схема секретной брони, импульсный пистолет -->
					<con tip='box' uid='directorF1'/>
					<scr eve='alarm'>
						<s targ="directorA1" act="dam" val="10000"/>
						<s targ="directorA2" act="dam" val="10000"/>
					</scr>
				</prob>
				<prob id='lair' level='2' tip='2'><!-- Бешеный Лис -->
					<con tip='unit' uid='raidersF1'/>
				</prob>
					<prob1 id='bossraider' level='2' tip='2' imp='1' close='1'>
						<con tip='unit' uid='bossraiderF1'/>
					</prob1>
				<prob id='w_raiders' level='2' tip='2'>
					<con tip='wave'/>
					<wave t='15'>
						<obj id='raider'/>
						<obj id='raider'/>
						<obj id='robot'/>
					</wave>
					<wave t='20'>
						<obj id='protect'/>
						<obj id='gutsy'/>
						<obj id='robot'/>
						<obj id='roller'/>
						<obj id='roller'/>
					</wave>
					<wave t='25'>
						<obj id='raider' tr='2'/>
						<obj id='raider' tr='3'/>
						<obj id='raider' tr='4'/>
						<obj id='raider' tr='5'/>
						<obj id='raider' tr='6'/>
					</wave>
					<wave>
						<obj id='raider' tr='5'/>
						<obj id='raider' tr='6'/>
						<obj id='raider' tr='8'/>
						<obj id='raider' tr='9'/>
						<obj id='raider' tr='7' hero='1'/>
					</wave>
				</prob>
				
				<prob id='generator' level='2' tip='2'> <!-- ЭДЖ -->
					<con tip='unit' uid='generatorU1'/>
				</prob>
			</land>
			
			<land id='nio' dif='7' file='rooms_nio' locx='-1' locy='0' stage='2' list='3' tip='story'>
				<options backwall="tTiles" color='lab' music='music_plant_2' xp='100'/>
			</land>
			
			<land id='random_sewer' tip='rnd' rnd='1' dif='10' biom='1' conf='2' file='rooms_sewer' stage='4' exit='exit_sewer' mx='8' my='3' locx='0' locy='0' list='6'>
				<options backwall="tMossy" music='music_sewer_1' xp='200' border='M' color='green' wtip='1' wrad='3'/>
				<!-- 6 -->
				<prob id='slimes' prize='1' tip='1'><!-- бонг -->
					<con tip='box' uid='slimesF1'/>
				</prob>
				<prob id='tower1' prize='1' tip='1'> <!-- болторез??? -->
					<con tip='box' uid='tower1F1'/>
				</prob>
				<prob id='zombies' tip='2'><!-- схема стампида -->
					<con tip='unit' uid='zombiesF1'/>
				</prob>
				<prob id='pit' tip='2'><!-- Люцерна -->
					<con tip='unit' qid='pitF1'/>
				</prob>
				<prob id='camp' prize='1' tip='1' imp='1'> <!-- дневник -->
					<con tip='box' uid='campF1'/>
				</prob>
				<prob id='w_zombie' tip='2' level='1'>
					<con tip='wave'/>
					<wave t='15'>
						<obj id='bloodwing'/>
						<obj id='bloodwing'/>
						<obj id='scorp'/>
						<obj id='scorp'/>
					</wave>
					<wave t='20'>
						<obj id='zombie' tr='0'/>
						<obj id='zombie' tr='1'/>
						<obj id='zombie' tr='2'/>
						<obj id='bloat' tr='4'/>
						<obj id='bloat' tr='4'/>
					</wave>
					<wave t='25'>
						<obj id='zombie' tr='0'/>
						<obj id='zombie' tr='1'/>
						<obj id='zombie' tr='2'/>
						<obj id='zombie' tr='5'/>
						<obj id='zombie' tr='6'/>
					</wave>
					<wave>
						<obj id='zombie' tr='2'/>
						<obj id='zombie' tr='3'/>
						<obj id='zombie' tr='4'/>
						<obj id='zombie' tr='5' hero='1'/>
						<obj id='zombie' tr='6' hero='1'/>
					</wave>
				</prob>
				<scr eve='take' item='diary'>
					<s act="dialog" val="velvetDial6"/>
					<s act="stage" val="storyFind" n="2"/>
					<s act="xp" val="5000"/>
				</scr>
			</land>
			
			<land id='raiders' dif='10' file='rooms_raiders' locx='0' locy='1' stage='3' list='5' tip='story' loadscr='2'>
				<options backwall='sky' fon='fonDarkClouds' color='blue' vis='10' music='music_raiders'/>
				<scr eve='take' item='sl_note1'>
					<s act="control off"/>
					<s act="dial" val="surfDialNote" n="0"/>
					<s act="dialog" val="slNote1"/>
					<s act="dial" val="surfDialNote" n="1"/>
					<s act="showstage" val="storyFind" n="3"/>
					<s act="control on"/>
					<s act="xp" val="5000"/>
				</scr>
			</land>
			
			<land id='random_stable' tip='rnd' rnd='1' dif='12' biom='2' conf='1' file='rooms_stable' exit='exit_stable' stage='5' mx='4' my='6' locx='0' locy='0' list='7' loadscr='3'>
				<options backwall="tStConcrete" music='music_stable_1' xp='200'/>
				<!-- 13 -->
				<prob id='doors' level='0' prize='1' tip='1'><!-- криопушка -->
					<con tip='box' uid='doorsF1'/>
				</prob>
				<prob id='buttons4' level='0' tip='1'><!-- особый изумруд -->
					<con tip='box' uid='buttons4F1'/>
					<con tip='box' uid='buttons4F2'/>
					<con tip='box' uid='buttons4F3'/>
					<con tip='box' uid='buttons4F4'/>
					<con tip='box' uid='buttons4F5'/>
					<con tip='box' uid='buttons4F6'/>
				</prob>
				<prob id='lift' level='0' prize='1' tip='1'><!-- схема пр. минталок -->
					<con tip='box' uid='liftF1'/>
				</prob>
				<prob id='platform' level='0' prize='1' tip='1'><!-- трубка -->
					<con tip='box' uid='platformF1'/>
				</prob>
				<prob id='digger' level='1' prize='1' tip='1'><!-- особый сапфир -->
					<con tip='box' uid='diggerF1'/>
				</prob>
				<prob id='tech' level='1' prize='1' tip='1'><!-- осциллограф -->
					<con tip='box' uid='techF1'/>
				</prob>
				<prob id='data' level='2' tip='1'><!-- база данных паролей, информация об эквидроидах -->
					<con tip='box' uid='dataF1'/>
				</prob>
				<prob id='floating' level='1' tip='1'><!-- глицерин -->
					<con tip='box' uid='floatingF1'/>
					<con tip='box' uid='floatingF2'/>
				</prob>
				<prob id='lasertag' level='1' prize='1' tip='1'><!-- особый рубин -->
					<con tip='box' uid='lasertagF1'/>
					<scr eve='out'>
						<s act='allact' val='close' n='d1'/>
						<s act='allact' val='close' n='d3'/>
					</scr>
				</prob>
				<prob id='turrets' level='0' prize='1' tip='2'><!-- импульсная винтовка -->
					<con tip='box' uid='turretsF1'/>
				</prob>
				<prob id='robots' level='1' tip='2'><!-- фокусирующий кристалл -->
					<con tip='unit' qid='robotsF1'/>
					<scr eve='out' act='allact' val='close' n='1'/>
				</prob>
				<prob id='sentinels' level='2' tip='2'><!-- медицинский талисман -->
					<con tip='unit' qid='sentinelsF1'/>
				</prob>
					<prob1 id='bossultra' level='2' tip='2' imp='1' close='1'> <!-- ключ от катакомб, медицинский талисман -->
						<con tip='unit' uid='bossultraF1'/>
					</prob1>
				<prob id='telekin' level='2' tip='2' prize='1'> <!-- ПП -->
					<con tip='box' uid='telekinF1'/>
				</prob>
				<prob id='w_robots' tip='2' level='2'>
					<con tip='wave'/>
					<wave t='25'>
						<obj id='landturret'/>
						<obj id='landturret'/>
						<obj id='protect'/>
						<obj id='protect'/>
						<obj id='spritebot'/>
						<obj id='spritebot'/>
					</wave>
					<wave t='45'>
						<obj id='slaver' tr='1'/>
						<obj id='slaver' tr='2'/>
						<obj id='slaver' tr='3'/>
						<obj id='protect'/>
						<obj id='gutsy'/>
						<obj id='landturret'/>
					</wave>
					<wave t='60'>
						<obj id='slaver' tr='1'/>
						<obj id='slaver' tr='2'/>
						<obj id='slaver' tr='3'/>
						<obj id='slaver' tr='4'/>
						<obj id='slaver' tr='5'/>
						<obj id='slaver' tr='6'/>
					</wave>
					<wave>
						<obj id='gutsy'/>
						<obj id='gutsy'/>
						<obj id='gutsy' hero='1'/>
						<obj id='eqd'/>
						<obj id='sentinel'/>
					</wave>
				</prob>
			</land>
			
			<land id='core' dif='15' file='rooms_core' locx='5' locy='0' stage='6' list='3' tip='story'>
				<options backwall="tStConcrete" color='blue' music='music_stable_2' xp='200'/>
				<scr eve='take' item='sl_note2'>
					<s act="control off"/>
					<s act="dial" val="stableDialNote2" n="0"/>
					<s act="dial" val="stableDialNote2" n="1"/>
					<s act="dial" val="slNote2" n="0"/>
					<s act="dial" val="slNote2" n="1"/>
					<s act="dial" val="stableDialNote2" n="2"/>
					<s act="dial" val="slNote2" n="2"/>
					<s act="dial" val="slNote2" n="3"/>
					<s act="dial" val="stableDialNote2" n="3"/>
					<s act="dial" val="slNote2" n="4"/>
					<s act="dial" val="slNote2" n="5"/>
					<s act="dial" val="stableDialNote2" n="4"/>
					<s act="stage" val="storyFind" n="3"/>
					<s act="control on"/>
					<s act="xp" val="5000"/>
				</scr>
				<scr eve='take' item='kogit'>
					<s act="control off"/>
					<s act="stage" val="storyStable" n="3"/>
					<s act="open" targ="coreD5"/>
					<s act="dialog" val="stableDialKogit"/>
					<s act="control on"/>
				</scr>
			</land>
			
			<land id='garages' dif='15' file='rooms_garages' locx='0' locy='0' stage='6' list='5' tip='story'>
				<options backwall='sky' fon='fonDarkClouds' color='blue' vis='10' music='music_surf'/>
			</land>
			
			<land id='random_mane' tip='rnd' rnd='1' dif='15' biom='3' conf='3' file='rooms_mane' exit='exit_mane' stage='7' mx='5' my='5' locx='0' locy='4' list='9' loadscr='4'>
				<options backwall="tWindows" fon='fonRuins' music='music_mane_1' vis='2' xp='300' border='N' darkness="-20"/>
				<!-- 10 -->
				<prob id='away' level='0' prize='1' tip='1'><!-- фокусирующий кристалл -->
					<con tip='box' uid='awayF1'/>
				</prob>
				<prob id='buttons5' level='0' tip='1'><!-- схема спаркл-гранаты -->
					<con tip='box' uid='buttons5F1'/>
					<con tip='box' uid='buttons5F2'/>
					<con tip='box' uid='buttons5F3'/>
					<con tip='box' uid='buttons5F4'/>
				</prob>
				<prob id='speed' level='0' prize='1' tip='1'><!-- сигары -->
					<con tip='box' uid='speedF1'/>
				</prob>
				<prob id='bloatking' level='0' tip='2'><!-- улучш. импульсная винтовка -->
					<con tip='unit' qid='bloatkingF1'/>
				</prob>
				<prob id='griff' level='1' tip='2' imp='1'> <!-- записка -->
					<con tip='unit' qid='griffF1'/>
				</prob>
				<prob id='slavers' level='1' tip='2'><!-- Рубанок -->
					<con tip='unit' uid='slaversF1'/>
				</prob>
				<prob id='blaster' level='1' tip='2'><!-- база данных паролей, Бластер -->
					<con tip='unit' qid='blasterF1'/>
				</prob>
				<prob id='grav' level='2' tip='2'><!-- Антидракон -->
					<con tip='unit' qid='gravF1'/>
				</prob>
					<prob1 id='bossalicorn' level='2' tip='2' imp='1' close='1'> <!-- пока что финальный босс -->
						<con tip='unit' uid='bossalicornF1'/>
					</prob1>
				<prob id='biblio' level='2' tip='2'> <!-- ТВ -->
					<con tip='unit' uid='biblioU1'/>
				</prob>
				<prob id='w_grif' tip='2' level='2'>
					<con tip='wave'/>
					<wave t='30'>
						<obj id='slaver' tr='1'/>
						<obj id='slaver' tr='2'/>
						<obj id='slaver' tr='3'/>
						<obj id='vortex'/>
						<obj id='vortex'/>
						<obj id='vortex'/>
					</wave>
					<wave t='60'>
						<obj id='zebra' tr='1'/>
						<obj id='zebra' tr='2'/>
						<obj id='zebra' tr='3'/>
						<obj id='zebra' tr='4'/>
						<obj id='msp'/>
						<obj id='msp'/>
					</wave>
					<wave t='80'>
						<obj id='merc' tr='1'/>
						<obj id='merc' tr='2'/>
						<obj id='merc' tr='3'/>
						<obj id='merc' tr='4'/>
						<obj id='merc' tr='5'/>
					</wave>
					<wave>
						<obj id='alicorn' tr='1'/>
						<obj id='alicorn' tr='2'/>
						<obj id='alicorn' tr='1' hero='1'/>
						<obj id='alicorn' tr='3'/>
					</wave>
				</prob>
			</land>
			
			<land id='mtn' dif='17' file='rooms_mtn' locx='0' locy='8' stage='8' biom='3' list='5' tip='story'>
				<options backwall="tTower" fon='fonRuins' music='music_mane_2' vis='2' xp='300' border='N'/>
				<scr eve='take' item='amul_al'>
					<s act="control off"/>
					<s act="stage" val="storyMane" n="5"/>
					<s act="stage" val="storyMane"/>
					<s act="dialog" val="maneDialAmul"/>
					<s act="trigger" val="story_canter" n="1"/>
					<s act="quest" val="storyCanter"/>
					<s act="passed"/>
					<s act="refill"/>
					<s act="control on"/>
				</scr>
			</land>
			
			<land id='way' dif='0' file='rooms_way' locx='0' locy='0' stage='8' tip='base'>
				<options backwall='sky' fon='fonWay' vis='10' music='music_surf'/>
			</land>
			<land id='covert' dif='0' file='rooms_covert' locx='-1' locy='0' tip='base' fin='0'>
				<options backwall='sky' fon='fonWay' vis='10' music='music_covert'/>
			</land>
			<land id='src' dif='0' file='rooms_src' locx='0' locy='0' tip='base' fin='0'>
				<options backwall='tRustPlates' fon='fonWay' vis='10' music='music_base'/>
			</land>
			
			<land id='random_canter' tip='rnd' rnd='1' dif='18' biom='5' conf='5' file='rooms_canter' exit='exit_canter' stage='9' mx='8' my='3' locx='0' locy='0' list='10' loadscr='5'>
				<options backwall="tConRough" fon='fonCanter' music='music_cat_1' xp='400' color='pink' border='Q' wtip='3' wrad='0' wdam='10' wtipdam='19'/>
				<!-- 9 -->
				<prob id='buttons6' level='0' tip='1'>
					<con tip='box' uid='buttons6F1'/>
					<con tip='box' uid='buttons6F2'/>
					<con tip='box' uid='buttons6F3'/>
					<con tip='box' uid='buttons6F4'/>
					<con tip='box' uid='buttons6F5'/>
					<con tip='box' uid='buttons6F6'/>
				</prob>
				<prob id='jump' level='0' prize='1' tip='1'>
					<con tip='box' uid='jumpF1'/>
				</prob>
				<prob id='sphera' level='0' prize='1' tip='1'>
					<con tip='box' uid='spheraF1'/>
				</prob>
				<prob id='zaput' level='0' prize='1' tip='1'>
					<con tip='box' uid='zaputF1'/>
				</prob>
				<prob id='talisman' level='0' tip='1'prize='1'><!-- водный талисман -->
					<con tip='box' uid='talismanF1'/>
				</prob>
				<prob id='podval' level='1' tip='0' prize='1'><!-- Рар -->
					<con tip='box' uid='podvalF1'/>
				</prob>
				<prob id='sttech' level='1' tip='1'><!-- данные по гидропонике -->
					<con tip='box' uid='sttechF1'/>
				</prob>
				<prob id='w_necros' tip='2' level='1'>
					<con tip='wave'/>
					<wave t='30'>
						<obj id='bloodwing' tr='2'/>
						<obj id='bloodwing' tr='2'/>
						<obj id='bloodwing' tr='2' hero='1'/>
						<obj id='scorp3'/>
						<obj id='scorp3'/>
						<obj id='bloat' tr='5'/>
						<obj id='bloat' tr='5'/>
					</wave>
					<wave t='60'>
						<obj id='zombie' tr='5'/>
						<obj id='zombie' tr='6'/>
						<obj id='zombie' tr='7'/>
						<obj id='zombie' tr='8'/>
						<obj id='zombie' tr='9'/>
						<obj id='bloat' tr='6'/>
						<obj id='bloat' tr='6'/>
					</wave>
					<wave t='80'>
						<obj id='alicorn' tr='1'/>
						<obj id='alicorn' tr='2'/>
						<obj id='alicorn' tr='3'/>
						<obj id='necros'/>
						<obj id='necros'/>
					</wave>
					<wave>
						<obj id='zombie' tr='7' hero='1'/>
						<obj id='zombie' tr='8' hero='1'/>
						<obj id='zombie' tr='9' hero='1'/>
						<obj id='alicorn' tr='3'/>
						<obj id='necros'/>
						<obj id='necros'/>
					</wave>
				</prob>
				<prob id='barahlo' level='2' tip='2'> <!-- РД -->
					<con tip='box' uid='barahloF1'/>
					<scr eve='close'>
						<s t="3" act="-"/>
						<s act="control off"/>
						<s t="1" targ="barahloU1" act="show"/>
						<s t="1" targ="barahloA1" act="dam" val="10000"/>
						<s t="1" act="turn" val="-1"/>
						<s act="dial" val="probBarahloDial" n="0"/>
						<s act="dial" val="probBarahloDial" n="1"/>
						<s act="dial" val="probBarahloDial" n="2"/>
						<s act="dial" val="probBarahloDial" n="3"/>
						<s t="1" act="turn" val="1"/>
						<s act="eff" val="horror" opt2="3"/>
						<s act="control on"/>
					</scr>
				</prob>
			</land>
			
			<land id='minst' dif='20' file='rooms_minst' locx='0' locy='0' stage='9' biom='5' list='5' tip='story'>
				<options backwall="tConRough" fon='fonCanter' music='music_minst' xp='400' color='pink' border='Q' wtip='3' wrad='0' wdam='10' wtipdam='19'/>
				<scr eve='take' item='blackbook'>
					<s act="control off"/>
					<s act="stage" val="storyCanter" n="4"/>
					<s act="stage" val="storyCanter"/>
					<s act="dialog" val="dialMinst2"/>
					<s act="quest" val="storyHome"/>
					<s act="trigger" val="story_book" n="1"/>
					<s act="check" targ="minstComm"/>
					<s act="control on"/>
				</scr>
			</land>
			
			<land id='random_mbase' tip='story' rnd='1' dif='22' biom='4' conf='4' file='rooms_mbase' stage='10' mx='5' my='3' locx='0' locy='0' list='10' loadscr='6'>
				<options backwall="tMbase" fon='fonWay' music='music_mbase' xp='500' color='red' border='O'/>
			</land>
			<land id='bunker' tip='hard' rnd='1' dif='24' biom='4' conf='7' file='rooms_mbase' stage='10' mx='6' my='3' locx='0' locy='0' list='10'>
				<options backwall="tMbase" music='music_mbase' xp='500' color='green' border='O'/>
			</land>
			
			<land id='workshop' dif='25' file='rooms_workshop' stage='10' locx='0' locy='0' tip='story'>
				<options backwall="tBackWall" music='music_workshop' xp='500'/>
			</land>
			
			<land id='hql' dif='26' file='rooms_hql' stage='10' locx='0' locy='0' tip='story'>
				<options backwall='sky' fon='fonWay' color='blue' vis='10' music='music_hql'/>
			</land>
			
			<land id='post' dif='27' file='rooms_post' stage='11' locx='0' locy='0' tip='story'>
				<options backwall='sky' fon='fonWay' color='sky' vis='10' music='music_encl_1'/>
			</land>
			
			<land id='random_encl' tip='rnd' rnd='1' dif='27' biom='6' conf='6' file='rooms_encl' exit='exit_encl' stage='11' mx='3' my='8' locx='0' locy='7' list='10' loadscr='7'>
				<options backwall="tEncl3" fon='fonEnclave' music='music_encl_1' postmusic='1' xp='500' color='sky' border='S' darkness="-30"/>
				<prob id='buttons7' level='0' tip='1'>
					<con tip='box' uid='buttons7F1'/>
					<con tip='box' uid='buttons7F2'/>
					<con tip='box' uid='buttons7F3'/>
					<con tip='box' uid='buttons7F4'/>
					<con tip='box' uid='buttons7F5'/>
					<con tip='box' uid='buttons7F6'/>
				</prob>
				<prob id='dressing' level='1' tip='2'><!-- броня анклава  -->
					<con tip='unit' qid='dressingE1'/>
				</prob>
				<prob id='electro' level='0' prize='1' tip='1'>
					<con tip='box' uid='electroF1'/>
				</prob>
				<prob id='moln' level='1' prize='1' tip='1'>
					<con tip='box' uid='molnF1'/>
				</prob>
				<prob id='hounds' level='1' tip='2'><!--  -->
					<con tip='unit' qid='houndF1'/>
				</prob>
				<prob id='w_encl' tip='2' level='1'>
					<con tip='wave'/>
					<wave t='30'>
						<obj id='roller' tr='2'/>
						<obj id='roller' tr='2'/>
						<obj id='roller' tr='2'/>
						<obj id='dron' tr='1'/>
						<obj id='dron' tr='2'/>
						<obj id='dron' tr='3'/>
						<obj id='dron' tr='3'/>
					</wave>
					<wave t='60'>
						<obj id='encl' tr='1' hero='1'/>
						<obj id='encl' tr='1'/>
						<obj id='encl' tr='2'/>
						<obj id='encl' tr='3'/>
						<obj id='encl' tr='4'/>
					</wave>
					<wave t='90'>
						<obj id='hellhound'/>
						<obj id='dron' tr='3'/>
						<obj id='hellhound' hero='1'/>
						<obj id='dron' tr='3'/>
						<obj id='hellhound'/>
					</wave>
					<wave>
						<obj id='encl' tr='2' hero='1'/>
						<obj id='encl' tr='3' hero='1'/>
						<obj id='encl' tr='4' hero='1'/>
						<obj id='hellhound'/>
						<obj id='hellhound'/>
					</wave>
				</prob>
			</land>
			
			<land id='comm' dif='29' file='rooms_comm' stage='11' locx='0' locy='0' tip='story'>
				<options backwall="tEncl3" fon='fonEnclave' music='music_encl_1' xp='500' color='sky' border='S' darkness="-30"/>
			</land>
			
			<land id='art' dif='30' file='rooms_art' stage='12' locx='0' locy='0' tip='story' fin='1'>
				<options backwall="tMbase" fon='fonDarkClouds' music='music_red' postmusic='1' xp='500' color='red' border='O' art='art_trigger'/>
			</land>
			
			<land id='stable_pi' tip='base' rnd='1' conf='10' biom='10' file='rooms_pi' mx='4' my='6' locx='3' locy='5' fin='2'>
				<options backwall="tStConcrete" music='music_pi' darkness="-15"/>
			</land>
			<land id='stable_pi_atk' tip='rnd' stage='12' rnd='1' conf='11' biom='11' file='rooms_pi' mx='6' my='2' locx='0' locy='0'>
				<options backwall="tStConcrete" music='music_red' color='fire'/>
			</land>
			
			<land id='stable_pi_surf' tip='story' biom='11' file='rooms_pis' stage='12' locx='1' locy='7'>
				<options backwall='sky' fon='fonFire' vis='3' music='music_encl_2' postmusic='1' color='fire'/>
			</land>
			
			<land id='thunder' tip='story' biom='11' file='rooms_thunder' stage='12' locx='0' locy='0'>
				<options backwall='sky' fon='fonFinalb' vis='3' music='music_encl_2' postmusic='1' color='blue'/>
			</land>
			
			<land id='grave' tip='story' file='rooms_grave' locx='0' locy='0'>
				<options backwall='sky' fon='fonClear' vis='10' music='music_end' darkness="-50"/>
			</land>
			
			<land id='prob' tip='prob' prob='1' file='rooms_prob'>
				<options/>
			</land>
			
			
<!-- ============================================== NPC ============================================== -->
			<npc id='calam'	vis='Calam' ua1='dial' ua2='dial' ico='10' inter='travel' weap='sniper'><!-- Каламити, поверхность -->
				<dial id='dialCalam2' imp='1'>
					<scr>
						<s act="passed"/>
						<s act="openland" val="rbl"/>
					</scr>
				</dial>
			</npc>
			<npc id='calam2'	vis='Calam' ua1='dial' ua2='dial' ico='10' inter='travel'><!-- Каламити, бар -->
				<dial id='dialCalam3' trigger='rbl_visited'/>
				<dial id='dialCalam4' land='raiders'/>
				<dial id='velvetDial2' prev='velvetDial1'/>
				<dial id='dialCalam5' land='random_mane'/>
				<dial id='dialCanter1' trigger='story_canter' imp='1'>
					<scr>
						<s act="stage" val="storyCanter" n="1"/>
						<s act="showstage" val="storyCanter" n="2"/>
						<s act="openland" val="random_canter"/>
					</scr>
				</dial>
			</npc>
			<npc id='calam3'	vis='Calam' ua1='dial' ua2='dial' ico='10' name='calam2' inter='travel'><!-- Каламити, Ковертсайн -->
				<dial id='dialStorm1' quest='storyStorm' sub='1' imp='1'>
					<scr>
						<s act="stage" val="storyStorm" n="1"/>
						<s act="showstage" val="storyStorm" n="2"/>
						<s act="trigger" val="storm" n="2"/>
					</scr>
				</dial>
			</npc>
			<npc id='calam4'	vis='Calam' name='calam2'><!-- Каламити, водоочистная -->
			</npc>
			<npc id='calam5'	vis='Calam' ua1='dial' ua2='dial' ico='10' name='calam2' inter='travel'><!-- Каламити, форт Рокс -->
				<dial id='dialStorm4'/>
			</npc>
			<npc id='calam6' vis='CalamEncl' name='calam2' weap='anti^1' ua1='dial' ua2='dial'><!-- Каламити, поле боя -->
				<dial id='dialFB3' imp='1'>
					<scr>
						<s act="stage" val="storyFbattle" n="3"/>
						<s act="showstage" val="storyFbattle" n="4"/>
					</scr>
				</dial>
				<dial id='dialFB4' imp='1'>
					<scr>
						<s act="gotoland" val="thunder"/>
					</scr>
				</dial>
			</npc>
			<npc id='velvet'	vis='Velvet' vendor='nope' inter='vdoc' ico='3'>
				<dial id='dialVelvet2'/>
				<dial id='dialHelpCovert4' imp='1' quest='storyHelpCovert' sub='8' music='music_encl_1'>
					<scr>
						<s act="openland" val="random_encl"/>
						<s act="stage" val="storyHelpCovert" n="8"/>
						<s act="stage" val="storyHelpCovert"/>
						<s act="stage" val="storyHome" n="2"/>
						<s act="showstage" val="storyHome" n="3"/>
						<s act="quest" val="storyEncl"/>
						<s act="trigger" val="dial_dialHelpCovert4" n="1"/>
						<s act="check" targ="observer"/>
					</scr>
				</dial>
				<dial id='dialEncl6' imp='1' quest='storyHome' sub='4'>
					<scr>
						<s act="stage" val="storyHome" n="4"/>
						<s act="showstage" val="storyHome" n="5"/>
						<s act="check" targ="observer"/>
					</scr>
				</dial>
				<dial id='dialStorm1' quest='storyStorm' sub='1' imp='1'>
					<scr>
						<s act="stage" val="storyStorm" n="1"/>
						<s act="showstage" val="storyStorm" n="2"/>
						<s act="trigger" val="storm" n="2"/>
					</scr>
				</dial>
				<dial id='dialVelvet5' trigger='colonel_show' n='2'/>
				<dial id='dialVelvet6' trigger='colonel_show' n='3'/>
				<dial id='dialPatient6' trigger='patient_tr2'>
					<scr>
						<s act="stage" val="patientHeal" n="4"/>
						<s act="stage" val="patientHeal"/>
					</scr>
				</dial>
				<dial id='dialVelvet4' prev='dialHelpCovert4'/>
				<dial id='dialVelvet3' pet='phoenix'/>
			</npc>
			<npc id='steel'	vis='Steel' ua1='dial' ua2='dial' ico='10' inter='travel' weap='aglau'>
				<dial id='dialCanter6' imp='1'>
					<scr>
						<s act="quest" val="hydroPon"/>
					</scr>
				</dial>
				<dial id='dialRanger1' imp='1' trigger="story_ranger">
					<scr>
						<s act="stage" val="storyRanger" n="1"/>
						<s act="showstage" val="storyRanger" n="2"/>
						<s act="showstage" val="storyRanger" n="8"/>
						<s act="trigger" val="ranger_q3" n="1"/>
					</scr>
				</dial>
				<dial id='dialReadyToGo' imp='1' trigger="ranger_q4">
					<scr>
						<s act="openland" val="random_mbase"/>
						<s act="gotoland" val="random_mbase"/>
					</scr>
				</dial>
				<!-- ЛП решает предупредить об угрозе жителей двух поселений -->
				<dial id='dialRanger5' imp='1' trigger="cold_death">
					<scr>
						<s act="stage" val="storyRanger" n="4"/>
						<s act="showstage" val="storyRanger" n="7"/>
						<s act="trigger" val="ranger_q1" n="1"/>
					</scr>
				</dial>
				<dial id='dialRanger6' imp='1' trigger="cold_death">
					<scr>
						<s act="openland" val="bunker"/>
					</scr>
				</dial>
				<!-- спросить о местонахождении штаба легиона -->
				<dial id='dialHelpCovert2' imp='1' quest='storyHelpCovert' sub='3'>
					<scr>
						<s act="stage" val="storyHelpCovert" n="3"/>
						<s act="openland" val="hql"/>
					</scr>
				</dial>
				<!-- военный совет -->
				<dial id='dialStorm2' quest='storyStorm' sub='2' imp='1'>
					<scr>
						<s act="take" val="potion_rat" n="1"/>
						<s act="stage" val="storyStorm" n="2"/>
						<s act="showstage" val="storyStorm" n="3"/>
						<s act="showstage" val="storyStorm" n="4"/>
						<s act="trigger" val="storm" n="3"/>
						<s act="openland" val="art"/>
						<s act="dial" val="dialNoReturn" n="0"/>
					</scr>
				</dial>
				<!-- победа -->
				<dial id='dialStorm5' quest='storyStorm' sub='5' imp='1'>
					<scr>
						<s act="stage" val="storyStorm" n="5"/>
						<s act="stage" val="storyStorm"/>
						<s act="control off"/>
						<s act="music" val="pre_1"/>
						<s act="show" targ="observer2" t="2"/>
						<s act="dialog" val="dialStorm6"/>
						<s act="trigger" val="storm" n="4"/>
						<s act="trigger" val="fin" n="2"/>
						<s act="quest" val="storyFbattle"/>
						<s act="music" val="music_red"/>
					</scr>
				</dial>
			</npc>
			<npc id='steel2' name='steel' vis='Steel' ua1='dial' ua2='dial' weap='antidrak' weap2='robomlau'>
				<dial id='dialRanger3' imp='1'/>
			</npc>
			<npc id='steel3' name='steel' vis='Steel' ua1='dial' ua2='dial' weap='antidrak' weap2='robomlau' ndial='dialFC1'>
				<dial id='dialFB1'/>
			</npc>
			<npc id='mainframe'	vis='Mainframe' ua1='use' ua2='use' noturn='1' sloy='2' replic='mainframe' ndial='mainframeOff' ico='1'>
				<dial id='storyDial2' imp='1'>
					<scr>
						<s act="stage" val="storyMain" n="5"/>
						<s act="stage" val="storyMain"/>
						<s act="quest" val="storyStable"/>
						<s act="trigger" val="story_stable" n="1"/>
						<s act="refill"/>
						<s act="passed"/>
					</scr>
				</dial>
				<dial id='velvetDial1' imp='1'/>
			</npc>
			<npc id='mainframe2'	vis='Mainframe' ua1='use' ua2='use' noturn='1' sloy='2' replic='mainframe' ndial='mainframeOff' ico='1'>
				<dial id='storyDial3' imp='1'>
					<scr>
						<s act="stage" val="storyStable" n="4"/>
						<s act="stage" val="storyStable"/>
						<s act="quest" val="storyMeet"/>
						<s act="openland" val="garages"/>
						<s act="refill"/>
						<s act="passed"/>
					</scr>
				</dial>
			</npc>
			<npc id='comm'	vis='Comm' ua1='use' ua2='use' noturn='1' sloy='1' ico='1'>
				<dial id='dialMinst3' imp='1' trigger="story_book">
					<scr>
						<s act="stage" val="storyHome" n="1"/>
						<s act="showstage" val="storyHome" n="2"/>
						<s act="quest" val="storyRanger"/>
						<s act="trigger" val="story_ranger" n="1"/>
						<s act="refill"/>
						<s act="passed"/>
					</scr>
				</dial>
			</npc>
			<npc id='askari' vis='Askari' ua1='dial' ua2='dial' ndial='askariDial'>
				<dial id='dialZebra2'/>
			</npc>
			<npc id='askari2' vis='Askari' ua1='dial' ua2='dial' ndial='askariDial2' name='askari'>
				<dial id='dialRanger9' imp='1' trigger='ranger_q1'>
					<scr>
						<s act="stage" val="storyRanger" n="7"/>
						<s act="quest" val="storyHelpCovert"/>
						<s act="showstage" val="storyRanger" n="5"/>
					</scr>
				</dial>
				<dial id='dialHelpCovert1' imp='1' trigger='soviet'>
					<scr>
						<s act="dblack" val="3" t="2"/>
						<s act="goto" val="-1 1"/>
					</scr>
				</dial>
				<dial id='dialHelpCovert3' imp='1' quest='storyHelpCovert' sub='7'>
					<scr>
						<s act="stage" val="storyHelpCovert" n="7"/>
						<s act="showstage" val="storyHelpCovert" n="8"/>
						<s act="trigger" val="observer" n="1"/>
					</scr>
				</dial>
			</npc>
			<npc id='askari3' vis='Askari' name='askari'/>
			<npc id='askari4' vis='Askari' name='askari' ua1='dial' ua2='dial' ndial='dialFC2'>
				<dial id='dialFB2'/>
			</npc>
			<npc id='observer' vis='SpriteBot' name='spritebot'>
				<dial id='dialWat1' prev='dialHelpCovert4'>
					<scr>
						<s act="trigger" val="observer" n="2"/>
						<s act="turn" targ="observer" val="-1"/>
						<s act="mater" targ="observer" val="0" t="1"/>
						<s act="fly" targ="observer" val="1:21"/>
						<s act="rem" targ="observer"/>
					</scr>
				</dial>
				<dial id='dialEncl6' imp='1' quest='storyHome' sub='4'>
					<scr>
						<s act="stage" val="storyHome" n="4"/>
						<s act="showstage" val="storyHome" n="5"/>
						<s act="check" targ="velvet"/>
					</scr>
				</dial>
				<dial id='dialWat2' imp='1' quest='storyHome' sub='5'>
					<scr>
						<s act="control off"/>
						<s act="openland" val="stable_pi"/>
						<s act="stage" val="storyHome" n="5"/>
						<s act="showstage" val="storyHome" n="6"/>
						<s act="trigger" val="observer" n="2"/>
						<s act="turn" targ="observer" val="-1"/>
						<s act="mater" targ="observer" val="0" t="1"/>
						<s act="fly" targ="observer" val="1:21"/>
						<s act="rem" targ="observer"/>
						<s act="dialog" val="dialWat3"/>
						<s act="control on"/>
					</scr>
				</dial>
			</npc>
			<npc id='observer2' vis='SpriteBot' name='spritebot'/>
			<npc id='mentor' vis='Mentor'>
				<dial id='dialMen3'/>
			</npc>
			<npc id='sc1' vis='Sc1'>
				<dial id='dialEnd_sc1' trigger='theend'/>
				<dial id='dialSc1'>
					<scr>
						<s act="take" val="mod_trans" n="1"/>
					</scr>
				</dial>
			</npc>
			<npc id='sc2' vis='Sc2'>
				<dial id='dialEnd_sc2' trigger='theend'/>
				<dial id='dialSc2'/>
			</npc>
			<npc id='sc3' vis='Sc3'>
				<dial id='dialEnd_sc3' trigger='theend'/>
				<dial id='dialSc3'/>
			</npc>
			<npc id='sc4' vis='Sc4'>
				<dial id='dialEnd_sc4' trigger='theend'>
					<scr>
						<s act="take" val="blackbook" n="1"/>
					</scr>
				</dial>
				<dial id='dialSc4'/>
			</npc>
			<npc id='mentor2' vis='Mentor2' name='mentor' noturn='1'/>
			<npc id='sc12' vis='Sc1' name='sc1' noturn='1'/>
			<npc id='sc22' vis='Sc2' name='sc2' noturn='1'/>
			<npc id='sc32' vis='Sc3' name='sc3'>
				<dial id='dialFin2'/>
			</npc>
			<npc id='sc42' vis='Sc4' name='sc4' noturn='1'/>
			<npc id='vendor_bar'	vendor='vendor_bar' 	inter='v' 	vis='VendorBar' 		ico='9' silent='1'>
				<dial id='dialEnd_vendor_bar' trigger='theend'/>
				<dial id='vendor_bar_hi' imp='1'>
					<scr>
						<s act="stage" val="storyContact" n="2"/>
						<s act="unlock" targ="doorRBL1"/>
					</scr>
				</dial>
				<dial id='vendor_bar_task' imp='1'>
					<scr>
						<s act="stage" val="storyMain" n="1"/>
						<s act="openland" val="random_plant"/>
						<s targ="worldMap" act="sign" val="1"/>
					</scr>
				</dial>
				<dial id='vendor_bar_stable' trigger='story_stable' imp='1'>
					<scr>
						<s act="stage" val="storyStable" n="1"/>
						<s act="openland" val="raiders"/>
						<s act="check" targ="rblCalam"/>
					</scr>
				</dial>
				<dial id='vendor_bar_mane' trigger='story_mane' imp='1'>
					<scr>
						<s act="stage" val="storyMane" n="1"/>
						<s act="showstage" val="storyMane" n="2"/>
						<s act="openland" val="random_mane"/>
						<s act="check" targ="rblCalam"/>
						<s act="take" val="money" n="5000"/>
						<s act="take" val="binoc" n="1"/>
					</scr>
				</dial>
				<dial id='dialRanger7' imp='1' trigger="ranger_q1">
					<scr>
						<s act="stage" val="storyRanger" n="5"/>
						<s act="showstage" val="storyRanger" n="6"/>
						<s act="trigger" val="ranger_q2" n="1"/>
					</scr>
				</dial>
			</npc>
			<npc id='vendor_armor' vendor='vendor_armor' 	inter='vr' vis='VendorArmor' 	ico='8'>
				<dial id='vendor_armor_hi'/>
				<dial id='dialRanger8' imp='1' trigger="ranger_q2">
					<scr>
						<s act="stage" val="storyRanger" n="6"/>
						<s act="quest" val="storyHelpCamp"/>
					</scr>
				</dial>
				<dial id='vendor_armor_help1' imp='1' quest='storyHelpCamp'>
					<scr>
						<s act="stage" val="storyHelpCamp" n="1"/>
						<s act="showstage" val="storyHelpCamp" n="2"/>
						<s act="openland" val="workshop"/>
					</scr>
				</dial>
				<dial id='vendor_armor_help2' imp='1' quest='storyHelpCamp' sub='3'>
					<scr>
						<s act="stage" val="storyHelpCamp" n="3"/>
						<s act="stage" val="storyHelpCamp"/>
						<s act="stage" val="storyHelpCovert" n="1"/>
						<s act="showstage" val="storyHelpCovert" n="2"/>
						<s act="trigger" val="helpcamp" n="wait"/>
						<s act="trigger" val="soviet" n="1"/>
					</scr>
				</dial>
				<dial id='vendor_armor_new1' lvl='5'/>
				<dial id='vendor_armor_chitin' lvl='5' barter='1'/>
				<dial id='vendor_armor_new2' lvl='12'/>
				<dial id='vendor_armor_expl' lvl='10' trigger='pro_armor'/>
				<dial id='vendor_armor_paint' lvl='20' trigger='colors3'>
					<reward id='key_tumba' kol='1'/>
				</dial>
				<dial id='vendor_armor_power' lvl='20' trigger='power_armor'/>
				<dial id='vendor_armor_quest3' trigger='ranger_q3' imp='1'>
					<scr>
						<s act="quest" val="collectPowerArmor"/>
						<s act="stage" val="storyRanger" n="8"/>
						<s act="trigger" val="ranger_q4" n="1"/>
					</scr>
				</dial>
				<dial id='dialEnd_vendor_armor' armor='ali'/>
			</npc>
			<npc id='vendor_weapon'	vendor='vendor_weapon' 	inter='vr' 	vis='VendorWeapon' 		ico='4'>
				<dial id='vendor_weap_hi'/>
				<dial id='vendor_weap_new1' lvl='10'/>
			</npc>
			<npc id='vendor_expl' 	vendor='vendor_expl' 	inter='vr' 	vis='VendorExpl' 	ico='5'>
				<dial id='vendor_expl_hi'/>
				<dial id='vendor_expl_new1' lvl='5'/>
				<dial id='vendor_expl_new2' lvl='8'/>
				<dial id='vendor_expl_sapper' armor='sapper'/>
			</npc>
			<npc id='vendor_medic' 	vendor='vendor_medic' 	inter='doc' vis='Doctor' 		ico='3'>
				<dial id='vendor_medic_hi'/>
				<dial id='velvetDial3' prev='velvetDial2'>
					<scr>
						<s act="stage" val="storyFind" n="1"/>
						<s act="xp" val="3000"/>
					</scr>
				</dial>
				<dial id='vendor_medic_new1' lvl='9'/>
				<dial id='dialPatient4' trigger='patient_tr1'/>
			</npc>
			<npc id='vendor_mech' 	vendor='vendor_mech' 	inter='vr' 	vis='VendorMech' 	ico='6'>
				<dial id='vendor_mech_hi'/>
				<dial id='vendor_mech_autodoc_rep' trigger='autodoc_rep'/>
			</npc>
			<npc id='vendor_mage' 	vendor='vendor_mage' 	inter='v' 	vis='VendorMage'	ico='7' silent='1'>
				<dial id='vendor_mage_hi'/>
				<dial id='dialEnd_vendor_mage' trigger='theend'/>
			</npc>
			<npc id='vendor_cook' 	vendor='vendor_cook' 	inter='v' 	vis='VendorCook'	ico='11' silent='1'>
				<dial id='vendor_cook_hi'/>
			</npc>
			<npc id='vendor_zebr' 	vendor='vendor_zebr' 	inter='v' 	vis='VendorZebr'	ico='12' silent='1'>
				<dial id='dialCanter2'/>
				<dial id='dialEnd_vendor_zebr' trigger='theend'/>
			</npc>
			<npc id='vendor_sr' 	vendor='vendor_sr' 	inter='vr' 	vis='VendorSR'	ico='4' silent='1'>
				<dial id='vendor_sr_hi'/>
				<dial id='vendor_sr_quest3' trigger='encl_armor'>
					<scr>
						<s act="take" val="encl" n="1"/>
						<s act="xp" val="1000"/>
					</scr>
				</dial>
				<dial id='vendor_sr_bunker' land='bunker'/>
				<dial id='vendor_sr_power_armor' armor='power'/>
			</npc>
			<npc id='vendor_maps' vendor='vendor_maps' 	inter='v' vis='VendorMaps' ico='2' silent='1'>
				<dial id='vendor_maps_key' barter='4'/>
			</npc>
			<npc id='vendor_random' 	vendor='random' 	inter='v' 	vis='Vendor'	ico='2'>
			</npc>
			<npc id='autodoc' 		vendor='nope' 			inter='adoc' vis='Autodoc' 		ico='3' needskill='repair' noturn='1' replic=''>
				<quest id='repairAutoDoc' cid='1'/>
				<rep id='glue' kol='3'/>
				<rep id='tape' kol='3'/>
				<rep id='tubing' kol='2'/>
				<rep id='pbatt' kol='1'/>
				<rep id='motor' kol='1'/>
				<rep id='spring' kol='2'/>
				<rep id='condens' kol='1'/>
				<rep id='chip' kol='1'/>
				<rep id='elcomp' kol='10'/>
				<rep id='uscan' kol='1'/>
				<rep id='tlaser' kol='1'/>
			</npc>
			<npc id='patient' 	inter='patient' 	vis='Patient' needskill='medic' needitem='vaccine' noturn='1' replic=''>
				<dial id='dialPatient9' trigger='patient_tr2'/>
			</npc>
			<npc id='zeb1' vis='Zeb1'/>
			<npc id='zeb2' vis='Zeb2'/>
			<npc id='zeb3' vis='Zeb3'/>
			<npc id='zeb4' vis='Zeb4'/>
			<npc id='askari_s' vis='Askari' name='askari' inter=''/>
			<npc id='velvet_s'	vis='Velvet' name='velvet' inter=''/>
			
			<!-- все, кладбище -->
			<npc id='calam_end'	vis='Calam' name='calam2'>
				<dial id='dialEnd_calam'/>
			</npc>
			<npc id='velvet_end'	vis='Velvet' name='velvet'>
				<dial id='dialEnd_velvet'/>
			</npc>
			<npc id='observer_end'	vis='SpriteBot' name='watcher'>
				<dial id='dialEnd_wat'/>
			</npc>
			<npc id='steel_end'	vis='Steel' name='steel'>
				<dial id='dialEnd_steel'/>
			</npc>
			<npc id='askari_end'	vis='Askari' name='askari'>
				<dial id='dialEnd_askari'/>
			</npc>
			
<!-- ============================================== СКРИПТЫ ============================================== -->
		<!-- приручить феникса -->
			<scr id='tamePhoenix'>
				<s act="dialog" val="dialTamePhoenix"/>
				<s targ="this" act="tame"/>
				<s act="stage" val="tamePhoenix" n="2"/>
				<s t="3" act="take" val="whistle" n="1"/>
				<s act="dialog" val="dialTakeWhistle"/>
			</scr>
		<!-- выкурить косяк -->
			<scr id='smokeRollup'>
				<s act="control off"/>
				<s act="dial" val="dialSmoke" n="0"/>
				<s act="dial" val="dialSmoke" n="1" t="2"/>
				<s act="dial" val="dialSmoke" n="2"/>
				<s act="dial" val="dialSmoke" n="1" t="2"/>
				<s act="speceffect" n="1"/>
				<s act="dial" val="dialSmoke" n="4"/>
				<s act="speceffect" n="2" t="3"/>
				<s act="dial" val="dialSmoke" n="5"/>
				<s act="speceffect" n="3" t="3"/>
				<s act="dial" val="dialSmoke" n="6"/>
				<s act="speceffect" n="4" t="3"/>
				<s act="dial" val="dialSmoke" n="7"/>
				<s act="speceffect" n="5" t="3"/>
				<s act="dial" val="dialSmoke" n="8"/>
				<s act="dblack" val="2" t="3"/>
				<s act="speceffect" n="6"/>
				<s act="dblack" val="-3" t="3"/>
				<s act="black" val="0"/>
				<s act="dial" val="dialSmoke" n="9"/>
				<s act="speceffect" n="0"/>
				<s act="dial" val="dialSmoke" n="10"/>
				<s act="control on"/>
				<s act="xp" val="500"/>
			</scr>
		<!-- починка генератора -->
			<scr id='fixGenerator'>
				<s act="control off"/>
				<s act="dblack" val="2" t="3"/>
				<s act="locon"/>
				<s act="control on"/>
				<s act="dblack" val="-3" t="3"/>
				<s act="black" val="0"/>
			</scr>
			
		<!-- самое начало игры -->
			<scr id='beginBeg'>
				<s act="black" val="1"/>
				<s act="gui off"/>
				<s act="control off"/>
				<s act="anim" val="die" opt1="1"/>
				<s act="mess" val="beginMess" t="2"/>
				<s act="dblack" val="-2"/>
				<s act="dial" val="begDial" n="0" t="4"/>
				<s act="dial" val="begDial" n="1" t="2"/>
				<s act="anim" val="res" t="2"/>
				<s act="dial" val="begDial" n="2" t="2"/>
				<s act="control on" t="1"/>
				<s act="off" targ="this"/>
				<s act="mess" val="trWalk"/>
			</scr>
		<!-- контакт с терминалом мтн -->
			<scr id='beginMtn'>
				<s act="control off"/>
				<s act="music" val="music_strange"/>
				<s act="dial" val="begDialCP" n="0" t="2"/>
				<s act="dial" val="begDialCP" n="1" t="2"/>
				<s act="dial" val="begDialCP" n="2"/>
				<s act="on" targ="begCP" t="2"/>
				<s act="dial" val="begDialCP" n="3"/>
				<s act="dial" val="begDialCP" n="4"/>
				<s act="dial" val="begDialCP" n="5"/>
				<s act="dial" val="begDialCP" n="6"/>
				<s act="quest" val="toExit"/>
				<s act="gui on"/>
				<s act="unlock" targ="begDoor"/>
				<s act="off" targ="this"/>
				<s act="control on" t="1"/>
			</scr>
		<!-- получение перка самолевитации -->
			<scr id='beginLevit'>
				<s act="control off"/>
				<s act="dial" val="begDialLevit" n="0" t="2"/>
				<s act="dial" val="begDialLevit" n="1" t="1"/>
				<s act="dial" val="begDialLevit" n="2"/>
				<s act="perk" val="levitation"/>
				<s act="mess" val="perkLevit" t="1"/>
				<s act="off" targ="this"/>
				<s act="on" targ="trLevit"/>
				<s act="control on" t="0.2"/>
			</scr>
		<!-- Добраться до точки выхода, получить левелап -->
			<scr id='beginUp'>
				<s act="control off"/>
				<s act="dial" val="begDialExit" n="0"/>
				<s act="dial" val="begDialExit" n="1"/>
				<s act="dial" val="begDialExit" n="2"/>
				<s act="stage" val="toExit" n="1" t="2"/>
				<s act="dial" val="begDialExit" n="3"/>
				<s act="dial" val="begDialExit" n="4"/>
				<s act="off" targ="this"/>
				<s act="control on"/>
				<s act="pip" val="1" n="2"/>
				<s act="on" targ="trCrossroad"/>
			</scr>
		<!-- разговор с Наставником через пипбак -->
			<scr id='beginStory'>
				<s act="control off"/>
				<s act="dialog" val="storyDial1"/>
				<s act="quest" val="storyContact"/>
				<s act="quest" val="storyFind"/>
				<s act="quest" val="storyMain"/>
				<s act="control on"/>
			</scr>
		<!-- встреча с Каламити -->
			<scr id='surfStory'>
				<s act="control off"/>
				<s act="dial" val="dialCalam1" n="0"/>
				<s act="dial" val="dialCalam1" n="1"/>
				<s act="dial" val="dialCalam1" n="2"/>
				<s act="dial" val="dialCalam1" n="3"/>
				<s targ="surfCalam" act="fly" val="40:7"/>
				<s targ="surfCalam" act="show" t="2.5"/>
				<s targ="surfCalam" act="sign"/>
				<s act="dial" val="dialCalam1" n="4" t="1.5"/>
				<s targ="surfCalam" act="ai" val="agro"/>
				<s targ="surfCalam" act="rep" val="1"/>
				<s act="show"/>
				<s act="off" targ="this"/>
				<s act="control on"/>
			</scr>
		<!-- первое появление в лагере -->
			<scr id='rblVisit'>
				<s act="dialog" val="rblDialM"/>
				<s act="trigger" val="rbl_visited" n="1"/>
				<s act="stage" val="storyContact" n="1"/>
				<s act="off" targ="this"/>
			</scr>
		<!-- разговор с Наставником через пипбак в лагере, если не было в обучении -->
			<scr id='rblStory'>
				<s act="control off"/>
				<s act="music" val="music_strange"/>
				<s act="dialog" val="storyDial1"/>
				<s act="quest" val="storyContact"/>
				<s act="quest" val="storyFind"/>
				<s act="quest" val="storyMain"/>
				<s act="control on"/>
			</scr>
		<!-- на переходе между 1 и 2 уровнями завода -->
			<scr id='plantStory1'>
				<s act="stage" val="storyMain" n="2"/>
				<s act="showstage" val="storyMain" n="3"/>
				<s act="showstage" val="storyMain" n="4"/>
				<s act="dialog" val="plantNextLevel"/>
			</scr>
		<!-- вход в отдел особых исседований -->
			<scr id='plantStory2'>
				<s act="dialog" val="nioDial1"/>
				<s act="stage" val="storyMain" n="4"/>
				<s act="off" targ="this"/>
			</scr>
			<scr id='raidersCapt'>
				<s act="dialog" val="surfDialCaptive"/>
				<s act="quest" val="freeCaptive"/>
				<s act="off" targ="this"/>
			</scr>
		<!-- вход в стойло -->
			<scr id='stableStory'>
				<s act="stage" val="storyStable" n="2"/>
				<s act="gotoland" val="random_stable"/>
				<s act="passed"/>
			</scr>
		<!-- явиться к гаражам -->
			<scr id='garages'>
				<s act="stage" val="storyMeet" n="1"/>
				<s act="off" targ="this"/>
			</scr>
		<!-- осмотр обломков спрайт-бота -->
			<scr id='brspr'>
				<s act="dialog" val="meetDial2"/>
				<s act="stage" val="storyMeet" n="3"/>
				<s act="stage" val="storyMeet"/>
				<s act="quest" val="storyMane"/>
				<s act="trigger" val="story_mane" n="1"/>
				<s act="passed"/>
			</scr>
		<!-- осмотр с крыши высотки -->
			<scr id='maneStory0'>
				<s act="dialog" val="maneNextLevel"/>
				<s act="stage" val="storyMane" n="2"/>
				<s act="showstage" val="storyMane" n="3"/>
			</scr>
		<!-- встреча с аликорнами -->
			<scr id='maneStory1'>
				<s act="control off"/>
				<s act="music" val="pre_1"/>
				<s act="stage" val="storyMane" n="3"/>
				<s act="allact" val="activate" n="1"/>
				<s act="dialog" val="dialAlicorn1"/>
				<s act="showstage" val="storyMane" n="4"/>
				<s act="off" targ="this"/>
				<s act="control on"/>
			</scr>
		<!-- встреча с боссом аликорнов -->
			<scr id='maneStory2'>
				<s act="control off"/>
				<s act="music" val="pre_1"/>
				<s act="turn" val="-1"/>
				<s act="dialog" val="dialAlicorn2"/>
				<s act="stage" val="storyMane" n="4"/>
				<s act="off" targ="this"/>
				<s act="control on"/>
			</scr>
		<!-- встреча с Зебрами -->
			<scr id='zebraWay'>
				<s act="control off"/>
				<s act="dialog" val="dialZebra1"/>
				<s act="trigger" val="encounter_way" n="1"/>
				<s act="gotoland" val="covert"/>
				<s act="control on"/>
			</scr>
		<!-- встреча с Вельвет -->
			<scr id='covertStory'>
				<s act="control off"/>
				<s act="music" val="music_enc"/>
				<s act="dialog" val="dialVelvet1"/>
				<s act="trigger" val="rbl_visited" n="1"/>
				<s act="stage" val="storyFind" n="4"/>
				<s act="stage" val="storyFind"/>
				<s act="off" targ="this"/>
				<s act="control on"/>
			</scr>
		<!-- квест на лечение -->
			<scr id='coverPatient'>
				<s act="control off"/>
				<s act="dialog" val="dialPatient1"/>
				<s act="quest" val="patientHeal"/>
				<s act="off" targ="this"/>
				<s act="control on"/>
			</scr>
		<!-- кантерлот, вход -->
			<scr id='canterStory1'>
				<s act="stage" val="storyCanter" n="2"/>
				<s act="dialog" val="dialCanter3"/>
			</scr>
		<!-- кантерлот, встреча с СР -->
			<scr id='canterRangers'>
				<s act="control off"/>
				<s act="dialog" val="dialCanter5"/>
				<s act="openland" val="src"/>
				<s act="control on"/>
				<s act="refill"/>
				<s act="upland"/>
				<s act="off" targ="this"/>
			</scr>
		<!-- мин ст, вход -->
			<scr id='canterStory2'>
				<s act="stage" val="storyCanter" n="3"/>
				<s act="off" targ="this"/>
			</scr>
		<!-- мин ст, встреча с боссом -->
			<scr id='canterStory3'>
				<s act="control off"/>
				<s act="music" val="pre_1"/>
				<s act="turn" val="1"/>
				<s targ="minstMchavi" act="show" t="1"/>
				<s act="dialog" val="dialMinst1"/>
				<s act="show"/>
				<s act="stage" val="storyMane" n="4"/>
				<s act="off" targ="this"/>
				<s act="control on"/>
			</scr>
		<!-- база СР, диалог с охраной -->
			<scr id='rangerStory1'>
				<s act="control off"/>
				<s act="music" val="pre_1" t="1"/>
				<s act="turn" val="1"/>
				<s act="dialog" val="dialRanger2"/>
				<s targ="mbaseSteel" act="ai" val="agro"/>
				<s act="showstage" val="storyRanger" n="3"/>
				<s act="off" targ="this"/>
				<s act="control on"/>
			</scr>
		<!-- база СР, вход -->
			<scr id='rangerStory2'>
				<s act="trigger" val="mbase_visited" n="1"/>
				<s act="stage" val="storyRanger" n="2"/>
				<s act="off" targ="this"/>
			</scr>
		<!-- база СР, встреча с Колдсайтом -->
			<scr id='rangerStory3'>
				<s act="music" val="pre_1"/>
				<s act="dialog" val="dialRanger4"/>
			</scr>
		<!-- база СР, убийство Колдсайта -->
			<scr id='rangerStoryOk'>
				<s act="stage" val="storyRanger" n="3"/>
				<s act="showstage" val="storyRanger" n="4"/>
				<s act="trigger" val="cold_death" n="1"/>
				<s act="refill"/>
				<s act="passed"/>
			</scr>
		<!-- исследовать орудийный цех -->
			<scr id='helpCampOk'>
				<s act="dialog" val="dialHelpCamp3"/>
				<s act="stage" val="storyHelpCamp" n="2"/>
				<s act="showstage" val="storyHelpCamp" n="3"/>
				<s act="passed"/>
			</scr>
		<!-- совет общины -->
			<scr id='sovietStory'>
				<s act="control off"/>
				<s act="dblack" val="-3" t="2"/>
				<s act="black" val="0"/>
				<s act="dialog" val="dialSoviet"/>
				<s act="stage" val="storyHelpCovert" n="2"/>
				<s act="showstage" val="storyHelpCovert" n="3"/>
				<s act="showstage" val="storyHelpCovert" n="4"/>
				<s act="showstage" val="storyHelpCovert" n="5"/>
				<s act="showstage" val="storyHelpCovert" n="6"/>
				<s act="dblack" val="3" t="2"/>
				<s act="control on"/>
				<s act="goto" val="1 0"/>
				<s act="black" val="0"/>
			</scr>
		<!-- войти в орудийный цех -->
			<scr id='workshopIn'>
				<s act="off" targ="this"/>
				<s act="dialog" val="dialHelpCamp1"/>
				<s act="close" targ="elpanel1" t="1"/>
				<s act="dialog" val="dialHelpCamp2"/>
			</scr>
		<!-- войти в штаб -->
			<scr id='hqlIn'>
				<s act="stage" val="storyHelpCovert" n="4"/>
				<s act="off" targ="this"/>
			</scr>
		<!-- убить центуриона -->
			<scr id='zebraKill'>
				<s act="stage" val="storyHelpCovert" n="5"/>
			</scr>
		<!-- пост анклава, встреча с охраной -->
			<scr id='postStory1'>
				<s act="control off"/>
				<s act="music" val="pre_1" t="1"/>
				<s act="dialog" val="dialEncl1"/>
				<s act="off" targ="this"/>
				<s act="control on" t="1"/>
				<s act="fraction" val="4" targ="postE2"/>
				<s act="fraction" val="4" targ="postE1" t="5"/>
				<s act="alarm"/>
			</scr>
		<!-- пост анклава, вход на базу -->
			<scr id='postStory3'>
				<s act="dialog" val="dialEncl2"/>
				<s act="stage" val="storyEncl" n="1"/>
				<s act="showstage" val="storyEncl" n="2"/>
				<s act="showstage" val="storyEncl" n="3"/>
				<s act="trigger" val="encounter_post" n="1"/>
				<s act="passed"/>
				<s act="gotoland" val="random_encl"/>
			</scr>
		<!-- командный центр, вход -->
			<scr id='commStory0'>
				<s act="dialog" val="dialEncl3"/>
				<s act="stage" val="storyEncl" n="2"/>
				<s targ="commCheck" act="check"/>
				<s targ="this" act="off"/>
			</scr>
			<scr id='commStory1'>
				<s val="colonel_show" act="trigger" n="1"/>
				<s targ="this" act="off"/>
			</scr>
		<!-- командный центр, разговор с полковником -->
			<scr id='commStory2'>
				<s val="colonel_show" act="trigger" n="2"/>
				<s act="dialog" val="dialEncl4"/>
				<s act="take" val="key_encl" n="1"/>
				<s act="stage" val="storyEncl" n="3"/>
				<s act="stage" val="storyHome" n="3"/>
				<s act="showstage" val="storyHome" n="4"/>
				<s act="trigger" val="observer" n="1"/>
				<s act="trigger" val="dial_dialWat1" n="1"/>
				<s act="passed"/>
				<s targ="this" act="off"/>
			</scr>
		<!-- командный центр, убить полковника -->
			<scr id='commStory3'>
				<s val="colonel_show" act="trigger" n="3"/>
				<s act="dialog" val="dialEncl5"/>
			</scr>
		<!-- стойло пи, первое посещение -->
			<scr id='stablePi0'>
				<s act="control off"/>
				<s act="turn" val="1"/>
				<s act="dialog" val="dialMen1"/>
				<s act="control off"/>
				<s act="dblack" val="3" t="2"/>
				<s act="mess" val="mentorMess" t="2"/>
				<s act="dblack" val="-3" t="2"/>
				<s act="black" val="0"/>
				<s act="dialog" val="dialMen2"/>
				<s act="stage" val="storyHome" n="6"/>
				<s act="stage" val="storyHome"/>
				<s act="take" val="kogit" n="-1"/>
				<s act="take" val="amul_al" n="-1"/>
				<s act="take" val="blackbook" n="-1"/>
				<s act="quest" val="storyStorm"/>
				<s act="trigger" val="storm" n="1"/>
				<s act="trigger" val="pi_visited" n="1"/>
				<s act="control on"/>
			</scr>
			
		<!-- стойло пи, комната ЛП -->
			<scr id='stablePi1'>
				<s act="music" val="music_enc"/>
				<s act="dialog" val="roomLP"/>
			</scr>
			
		<!-- форт Рокс, вход -->
			<scr id='fortRocks1'>
				<s act="stage" val="storyStorm" n="3"/>
				<s act="trigger" val="fin" n="1"/>
				<s targ="artF1" act="check"/>
				<s targ="this" act="off"/>
			</scr>
		<!-- форт Рокс, отключение генераторов -->
			<scr id='fortRocks2'>
				<s act="control off"/>
				<s act="dial" val="dialStorm3" n="0"/>
				<s act="control off"/>
				<s act="black" val="1"/>
				<s act="allact" val="open" n="a1"/>
				<s act="trigger" val="art_trigger" n="1"/>
				<s act="trigger" val="storm" n="3"/>
				<s act="passed"/>
				<s act="locoff"/>
				<s act="dial" val="dialStorm3" n="1"/>
				<s act="control off"/>
				<s act="dblack" val="-3" t="2"/>
				<s act="black" val="0"/>
				<s act="stage" val="storyStorm" n="4"/>
				<s act="showstage" val="storyStorm" n="5"/>
				<s act="dial" val="dialStorm3" n="2"/>
				<s targ="this" act="off"/>
				<s act="control on"/>
			</scr>
		<!-- атакованное стойло пи, вход -->
			<scr id='stablePi2'>
				<s act="dialog" val="dialFin1"/>
				<s act="open" targ="piF2"/>
			</scr>
		<!-- атакованное стойло пи, разговор с наставником -->
			<scr id='stablePi3'>
				<s act="dialog" val="dialFin3"/>
				<s act="stage" val="storyFbattle" n="1"/>
				<s act="showstage" val="storyFbattle" n="2"/>
				<s act="sign" targ="piF3" n="1"/>
				<s targ="this" act="off"/>
			</scr>
		<!-- атакованное стойло пи, получение брони аликорна -->
			<scr id='stablePi4'>
				<s act="dialog" val="dialFin4"/>
				<s act="control off"/>
				<s act="dblack" val="1" t="4"/>
				<s act="music" val="music_strange"/>
				<s act="open" targ="piF4"/>
				<s act="alicorn" val="1"/>
				<s act="dblack" val="-10" t="1"/>
				<s act="black" val="0"/>
				<s act="trigger" val="storm" n="5"/>
				<s act="trigger" val="fin" n="3"/>
				<s act="stage" val="storyFbattle" n="2"/>
				<s act="dialog" val="dialFin5"/>
				<s act="showstage" val="storyFbattle" n="3"/>
				<s act="showstage" val="storyFbattle" n="5"/>
				<s targ="this" act="off"/>
				<s act="control on"/>
				<s act="dialog" val="alicornArmor"/>
			</scr>
		<!-- тандерхед -->
			<scr id='megabossDie'>
				<s act="control off" t="1"/>
				<s act="dialog" val="dialFB5"/>
				<s act="dblack" val="1.6"/>
				<s act="vsos" targ="megaboss" t="2"/>
				<s act="black" val="1"/>
				<s act="goto" val="1 0"/>
				<s act="black" val="0"/>
				<s act="control on"/>
			</scr>
			<scr id='megabossDie2'>
				<s act="trus" val="1"/>
				<s act="open" targ="th1"/>
				<s act="open" targ="th2"/>
				<s act="dialog" val="dialFB6" t="1"/>
				<s act="stage" val="storyFbattle" n="4"/>
			</scr>
			<scr id='lp_fall'>
				<s act="music" val="music_fall_1" n="1"/>
				<s act="scene" val="thunder1" t="7"/>
				<s act="dblack" val="3" t="1"/>
				<s act="black" val="1" t="1"/>
				<s act="scene" val="thunder2"/>
				<s act="dblack" val="-1" t="3"/>
				<s act="black" val="0" t="1"/>
				<s act="dialog" val="dialFB7"/>
				<s act="music" val="music_fall_2"/>
				<s act="scene" val="thunder2" t="2"/>
				<s act="scene" val="thunder2" n="3" t="1"/>
				<s act="dblack" val="3" t="1"/>
				<s act="scene" val="thunder3"/>
				<s act="dblack" val="-1" t="3"/>
				<s act="black" val="0"/>
				<s act="dialog" val="dialFB8"/>
				<s act="scene" val="thunder3" n="3" t="1"/>
				<s act="dialog" val="dialFB9"/>
				<s act="scene" val="thunder3" n="51"/>
				<s act="dblack" val="1" t="5"/>
				<s act="black" val="1" t="1"/>
				<s act="trigger" val="theend" n="1"/>
				<s act="scene"/>
				<s act="gotoland" val="grave" n="2"/>
			</scr>
		<!-- кладбище -->
			<scr id='vse'>
				<s act="black" val="1"/>
				<s act="black" val="1"/>
				<s act="dblack" val="0"/>
				<s act="black" val="1"/>
				<s act="mess" val="graveMess"/>
				<s act="music" val="music_end"/>
				<s act="control off" t="2"/>
				<s act="trigger" val="fin" n="0"/>
				<s act="trigger" val="storm" n="0"/>
				<s act="trigger" val="dial_dialSc1" n="1"/>
				<s act="trigger" val="dial_dialSc2" n="1"/>
				<s act="trigger" val="dial_dialSc3" n="1"/>
				<s act="trigger" val="dial_dialSc4" n="1"/>
				<s act="alicorn" val="0"/>
				<s act="armor" val="pip"/>
				<s act="turn" val="-1"/>
				<s act="dblack" val="-1.1" t="3"/>
				<s act="black" val="0"/>
				<s act="dialog" val="dialEnd0"/>
				<s act="stage" val="storyFbattle" n="5"/>
				<s act="stage" val="storyFbattle"/>
				<s act="take" val="ali" n="1"/>
				<s act="control on"/>
				<s targ="this" act="off"/>
			</scr>
			<scr id='endgame'>
				<s act="control off"/>
				<s act="dblack" val="1" t="5"/>
				<s act="black" val="1"/>
				<s act="endgame"/>
				<s act="dblack" val="-3" t="1"/>
				<s act="black" val="0"/>
				<s act="wait"/>
				<s act="dblack" val="2" t="2"/>
				<s act="black" val="1"/>
				<s act="dialog" val="dial_endgame"/>
				<s act="gotoland" val="rbl" n="2"/>
			</scr>
			<scr id='gameover'>
				<s act="gameover"/>
				<s act="dblack" val="-3" t="1"/>
				<s act="black" val="0"/>
				<s act="wait"/>
				<s act="pip" val="5" n="1"/>
			</scr>

<!-- ============================================== КВЕСТЫ ============================================== 
	main='1' - квест основной сюжетной линии
	xp - награда в опыте
	sp - добавить скилл-поинты
	rep - добавить репутацию
	
	invis='1' - подквест остаётся невидимым, пока его не откроют
	result='1' - подквест открывается автоматически когда выполнены все предыдущие пункты
	nn='1' - не обязательный подквест
	hidden='1' - пункт квеста будет заменён на ????
	collect='key_sewer' kol='1' - предмет и количество для сборки, сборка автоматически закрывает пункт
		 del='1' - предметы будут удалены при закрытии квеста
	
	next - квест, который автоматом будет выдан при загрузке игры, если квест закрыт
	deposit - дать при взятии (активации) квеста
	reward - дать при закрытии квеста
-->
			<quest id='test' sp='3' main='1'>
				<q id='1'/>
				<q id='2'/>
				<q id='3'/>
			</quest>
			<quest id='toExit' xp='5000' main='1'>
				<q id='1'/>
			</quest>
			<quest id='storyContact' xp='1000' main='1'>
				<q id='1'/>
				<q id='2'/>
			</quest>
			<quest id='storyFind' xp='10000' main='1'>
				<q id='1'/>
				<q id='2' invis='1'/>
				<q id='3' invis='1'/>
				<q id='4'/>
			</quest>
			<quest id='storyMain' xp='10000' main='1'>
				<q id='1'/>
				<q id='2'/>
				<q id='3' invis='1' collect='key_sewer' kol='1'/>
				<q id='4' invis='1'/>
				<q id='5'/>
			</quest>
			<quest id='storyStable' xp='25000' main='1'>
				<q id='1'/>
				<q id='2'/>
				<q id='3'/>
				<q id='4'/>
			</quest>
			<quest id='storyMeet' xp='25000' main='1'>
				<q id='1'/>
				<q id='2'/>
				<q id='3' invis='1'/>
			</quest>
			<quest id='storyMane' xp='50000' main='1'>
				<q id='1'/>
				<q id='2' invis='1'/>
				<q id='3' invis='1'/>
				<q id='4' invis='1'/>
				<q id='5'/>
			</quest>
			<quest id='storyCanter' xp='50000' main='1'>
				<q id='1'/>
				<q id='2' invis='1'/>
				<q id='3' invis='1'/>
				<q id='4'/>
			</quest>
			<quest id='storyHome' xp='100000' main='1'>
				<q id='1'/>
				<q id='2' invis='1'/>
				<q id='3' invis='1'/>
				<q id='4' invis='1'/>
				<q id='5' invis='1'/>
				<q id='6' invis='1'/>
			</quest>
			<quest id='storyRanger' xp='100000' main='1'>
				<q id='1'/>
				<q id='8' invis='1' nn='1'/>
				<q id='2' invis='1'/>
				<q id='3' invis='1'/>
				<q id='4' invis='1'/>
				<q id='5' invis='1'/>
				<q id='6' invis='1'/>
				<q id='7' invis='1'/>
				<next id='storyHelpCamp'/>
				<next id='storyHelpCovert'/>
			</quest>
			<quest id='storyHelpCamp' xp='50000' main='1'>
				<q id='1'/>
				<q id='2' invis='1'/>
				<q id='3' invis='1'/>
				<reward id='money' kol='10000'/>
			</quest>
			<quest id='storyHelpCovert' xp='50000' main='1'>
				<q id='1'/>
				<q id='2' invis='1'/>
				<q id='3' invis='1'/>
				<q id='4' invis='1'/>
				<q id='5' invis='1'/>
				<q id='6' invis='1' collect='secret_doc' kol='1' del='1'/>
				<q id='7' invis='1' result='1'/>
				<q id='8' invis='1'/>
				<reward id='potHP' kol='1'/>
				<reward id='potMP' kol='1'/>
			</quest>
			<quest id='storyEncl' xp='100000' main='1'>
				<q id='1'/>
				<q id='2' invis='1'/>
				<q id='3' invis='1'/>
			</quest>
			<quest id='storyStorm' xp='100000' main='1'>
				<q id='1'/>
				<q id='2' invis='1'/>
				<q id='3' invis='1'/>
				<q id='4' invis='1'/>
				<q id='5' invis='1'/>
			</quest>
			<quest id='storyFbattle' xp='100000' main='1'>
				<q id='1'/>
				<q id='2' invis='1'/>
				<q id='3' invis='1'/>
				<q id='4' invis='1'/>
				<q id='5' invis='1'/>
			</quest>
			
			<quest id='collectHS' sp='1' xp='1000'>
				<q id='1' collect='col1' kol='20' del='1'/>
			</quest>
			<quest id='tamePhoenix' xp='10000'>
				<q id='1' collect='tame_ph' kol='5'/>
				<q id='2'/>
			</quest>
			<quest id='freeCaptive' sp='1' xp='10000' rep='5'>
				<q id='1' collect='capt_raiders' kol='12'/>
			</quest>
			<quest id='patientHeal' xp='20000' rep='3'>
				<q id='1'/>
				<q id='2' invis='1' collect='vaccine' kol='1' us='1'/>
				<q id='3' invis='1'/>
				<q id='4' invis='1'/>
				<reward id='stat_fl' kol='1'/>
			</quest>
			
			<quest id='findProArmor' empl='vendor_armor' rep='2' begdial='vendor_armor_quest1' enddial='vendor_armor_quest2' trigger='pro_armor' triggerset='wait'>
				<q id='1' collect='pro_armor' kol='1' del='1'/>
				<q id='2' report='vendor_armor'/>
				<reward id='money' kol='1000'/>
				<reward id='metal_comp' kol='5'/>
				<reward id='skin_comp' kol='5'/>
			</quest>
			<quest id='killMadfox' empl='vendor_armor' rep='2'><!--амулет -->
				<q id='1'/>
				<q id='2' report='vendor_armor'/>
				<reward id='money' kol='2000'/>
				<reward id='amul_bul' kol='1'/>
			</quest>
			<quest id='collectPaintsA' empl='vendor_armor' rep='1' trigger='colors1'>
				<deposit id='p_black' kol='1'/>
				<q id='1' collect='p_red' kol='1'/>
				<q id='2' collect='p_green' kol='1'/>
				<q id='3' collect='p_blue' kol='1'/>
				<q id='4' collect='p_yellow' kol='1'/>
				<q id='5' collect='p_white' kol='1'/>
				<q id='6' report='vendor_armor'/>
				<reward id='intel_comp' kol='3'/>
				<reward id='money' kol='500'/>
			</quest>
			<quest id='collectPaintsB' empl='vendor_armor' rep='1' trigger='colors2'>
				<q id='1' collect='p_gray' kol='1'/>
				<q id='2' collect='p_purple' kol='1'/>
				<q id='3' collect='p_orange' kol='1'/>
				<q id='4' collect='p_brown' kol='1'/>
				<q id='5' collect='p_lblue' kol='1'/>
				<q id='6' collect='p_khaki' kol='1'/>
				<q id='7' collect='p_dgreen' kol='1'/>
				<q id='8' report='vendor_armor'/>
				<reward id='battle_comp' kol='3'/>
				<reward id='money' kol='500'/>
			</quest>
			<quest id='collectPaintsC' empl='vendor_armor' rep='1' trigger='colors3' triggerset='wait'><!--амулет -->
				<q id='1' collect='p_cyan' kol='1'/>
				<q id='2' collect='p_pink' kol='1'/>
				<q id='3' collect='p_burgundy' kol='1'/>
				<q id='4' collect='p_crimson' kol='1'/>
				<q id='5' collect='p_lime' kol='1'/>
				<q id='6' collect='p_fire' kol='1'/>
				<q id='7' collect='p_beige' kol='1'/>
				<q id='8' report='vendor_armor'/>
				<reward id='magus_comp' kol='3'/>
				<reward id='money' kol='1000'/>
				<reward id='amul_fang' kol='1'/>
			</quest>
			<quest id='collectPowerArmor' empl='vendor_armor' rep='3' enddial='vendor_armor_quest4' trigger='power_armor' triggerset='wait'>
				<q id='1' collect='power_comp' kol='20' del='1'/>
				<q id='2' report='vendor_armor'/>
			</quest>
			
			<quest id='killBloats' empl='vendor_weapon' rep='2'>
				<q id='1'/>
				<q id='2' collect='bloatF1' kol='5'/>
				<q id='3' report='vendor_weapon'/>
				<reward id='p127' kol='80'/>
				<reward id='p12' kol='32'/>
				<reward id='p308' kol='18'/>
				<reward id='money' kol='1000'/>
			</quest>
			<quest id='collectFcrystal' empl='vendor_weapon' rep='2'>
				<q id='1' collect='fcrystal' kol='1' del='1'/>
				<q id='2' report='vendor_weapon'/>
				<reward id='energ_6' kol='200'/>
				<reward id='crystal_6' kol='400'/>
				<reward id='money' kol='1000'/>
			</quest>
			<quest id='killLucerne' empl='vendor_weapon' rep='3'><!--оружие -->
				<q id='1'/>
				<q id='2' report='vendor_weapon'/>
				<reward id='money' kol='2500'/>
				<reward id='pp127mm^1' kol='1'/>
			</quest>
			<quest id='retPistol' empl='vendor_weapon' rep='3' begdial='vendor_weapon_quest1' enddial='vendor_weapon_quest2'>
				<q id='1' collect='wquest1' coltip='1' kol='1' del='1'/>
				<q id='2' report='vendor_weapon'/>
				<reward id='psc^1' kol='2'/>
				<reward id='p50mg' kol='50'/>
			</quest>
			<quest id='collectBlaster' empl='vendor_weapon' rep='3' enddial='vendor_weapon_quest3'>
				<q id='1' collect='blaster' coltip='1' kol='1'/>
				<q id='2' report='vendor_weapon'/>
				<reward id='bcell' kol='70'/>
			</quest>
			
			<quest id='repairAutoDoc' empl='vendor_medic' rep='2' begdial='vendor_medic_quest1' enddial='vendor_medic_quest2' trigger='autodoc_rep'>
				<q id='1'/>
				<q id='2' report='vendor_medic'/>
				<reward id='gel' kol='5000'/>
			</quest>
			<quest id='collectFishfat' empl='vendor_medic' rep='1'>
				<q id='1' collect='fishfat' kol='20' del='1'/>
				<q id='2' report='vendor_medic'/>
				<reward id='money' kol='500'/>
				<reward id='pot3' kol='1'/>
				<reward id='radx' kol='1'/>
				<reward id='antiradin' kol='1'/>
			</quest>
			<quest id='collectTmed' empl='vendor_medic' rep='2'>
				<q id='1' collect='tmed' kol='1' del='1'/>
				<q id='2' report='vendor_medic'/>
				<reward id='money' kol='2500'/>
			</quest>
			<quest id='collectRecipes' empl='vendor_medic' rep='2'>
				<q id='1' collect='s_ultradash' kol='1'/>
				<q id='2' collect='s_stampede' kol='1'/>
				<q id='3' collect='s_pmint' kol='1'/>
				<q id='4' report='vendor_medic'/>
				<reward id='money' kol='2500'/>
				<reward id='detoxin' kol='3'/>
			</quest>
			
			<quest id='collectNitro' empl='vendor_expl' rep='1'>
				<q id='1' collect='acid' kol='100' del='1'/>
				<q id='2' collect='glycerol' kol='1' del='1'/>
				<q id='3' report='vendor_expl'/>
				<reward id='money' kol='1000'/>
				<reward id='grenade' kol='6'/>
				<reward id='gasgr' kol='3'/>
				<reward id='fgren' kol='3'/>
				<reward id='plagr' kol='3'/>
			</quest>
			<quest id='killAnthills' empl='vendor_expl' rep='2' begdial='vendor_expl_quest1'>
				<deposit id='dinamit' kol='10'/>
				<q id='1' collect='antF1' kol='5'/>
				<q id='2' report='vendor_expl'/>
				<reward id='money' kol='1500'/>
			</quest>
			<quest id='testCryo' empl='vendor_expl' rep='3' begdial='vendor_expl_quest2' enddial='vendor_expl_quest3' trigger='test_cryo' triggerset='wait'>
				<deposit id='s_cryogr' kol='1'/>
				<deposit id='s_cryomine' kol='1'/>
				<deposit trigger='look_cryogr' set='1'/>
				<deposit trigger='look_cryomine' set='1'/>
				<q id='1' collect='pcryo' kol='100' nn='1' us='1'/>
				<q id='2' collect='cryogr' kol='1' us='1'/>
				<q id='3' collect='cryomine' kol='1' us='1'/>
				<q id='4' collect='kill_cryogr' kol='5'/>
				<q id='5' collect='kill_cryomine' kol='5'/>
				<q id='6' report='vendor_expl'/>
				<reward id='money' kol='2000'/>
				<reward id='x37' kol='4'/>
				<reward trigger='look_cryogr' set='0'/>
				<reward trigger='look_cryomine' set='0'/>
			</quest>
			<quest id='collectSpgren' empl='vendor_expl' rep='2'>
				<q id='1' collect='s_spgren' kol='1'/>
				<q id='2' report='vendor_expl'/>
				<reward id='s_balemine' kol='1'/>
			</quest>
			<quest id='collectSmoke' empl='vendor_expl' rep='2'>
				<q id='1' collect='rollup' kol='1' hidden='1' give='vendor_expl' pay='100'/>
				<q id='2' collect='tabak' kol='1' hidden='1' give='vendor_expl' pay='250'/>
				<q id='3' collect='bong' kol='1' hidden='1' give='vendor_expl' pay='500'/>
				<q id='4' collect='tpipe' kol='1' hidden='1' give='vendor_expl' pay='750'/>
				<q id='5' collect='cigars' kol='1' hidden='1' give='vendor_expl' pay='1000'/>
				<reward id='amul_expl' kol='1'/>
			</quest>
			
			<quest id='collectGems' empl='vendor_mage' rep='2'>
				<q id='1' collect='gem1' kol='10' pay='70' give='vendor_mage'/>
				<q id='2' collect='gem2' kol='10' pay='130' give='vendor_mage'/>
				<q id='3' collect='gem3' kol='10' pay='200' give='vendor_mage'/>
				<q id='4' collect='super_emerald' kol='1' del='1'/>
				<q id='5' collect='super_sapphire' kol='1' del='1'/>
				<q id='6' collect='super_ruby' kol='1' del='1'/>
				<q id='7' report='vendor_mage'/>
				<reward id='money' kol='1000'/>
				<reward id='amul_fire' kol='1'/>
			</quest>
			<quest id='collectBooks' empl='vendor_mage' rep='2' begdial='vendor_mage_quest1' enddial='vendor_mage_quest2'>
				<q id='1' collect='lbook' kol='50' pay='150' give='vendor_mage'/>
				<q id='2' collect='book_cm' kol='5' pay='500' give='vendor_mage'/>
				<q id='3' report='vendor_mage'/>
				<reward id='book_alicorn' kol='1'/>
			</quest>
			<quest id='collectDust' empl='vendor_mage' rep='2'>
				<q id='1' collect='mdust' kol='10' del='1'/>
				<q id='2' collect='firecrystal' kol='3' del='1'/>
				<q id='3' report='vendor_mage'/>
				<reward id='s_potion_elements' kol='1'/>
			</quest>
			
			<quest id='collectMolefat' empl='vendor_mech' rep='1'>
				<q id='1' collect='molefat' kol='25' pay='100' give='vendor_mech'/>
			</quest>
			<quest id='collectTools' empl='vendor_mech' rep='2' begdial='vendor_mech_quest1'>
				<q id='1' collect='tool_calipers' kol='1' give='vendor_mech' pay='750'/>
				<q id='2' collect='tool_boltcutter' kol='1' give='vendor_mech' pay='750'/>
				<q id='3' collect='tool_oscilloscope' kol='1' give='vendor_mech' pay='1500'/>
				<reward id='reboot' kol='3'/>
				<reward id='runa' kol='3'/>
			</quest>
			<quest id='collectFans' empl='vendor_mech' rep='1'>
				<q id='1' collect='fan' kol='10' pay='20' give='vendor_mech'/>
				<q id='2' collect='lamp' kol='10' pay='30' give='vendor_mech'/>
				<q id='3' collect='kofe' kol='10' pay='50' give='vendor_mech'/>
				<q id='4' report='vendor_mech'/>
				<reward id='strickle' kol='1'/>
			</quest>
			<quest id='collectScrew' empl='vendor_mech' rep='1'>
				<q id='1' collect='box_screw' kol='1' del='1'/>
				<q id='2' collect='box_nut' kol='1' del='1'/>
				<q id='3' report='vendor_mech'/>
				<reward id='money' kol='1000'/>
				<reward id='rep' kol='3'/>
			</quest>
			<quest id='collectData' empl='vendor_mech' rep='2' begdial='vendor_mech_quest2' enddial='vendor_mech_quest3'>
				<deposit id='s_mod_hacker' kol='1'/>
				<q id='1'/>
				<q id='2' collect='bdpass' kol='1' nn='1' us='1'/>
				<q id='3' collect='mod_hacker' kol='1' nn='1'/>
				<q id='4' collect='data_eqd' kol='1' del='1'/>
				<q id='5' report='vendor_mech'/>
				<reward id='money' kol='2000'/>
				<reward id='amul_phis' kol='1'/>
			</quest>
			<quest id='collectCol2' empl='vendor_mech' rep='2'>
				<q id='1' collect='col2' kol='12' pay='200' give='vendor_mech'/>
				<reward id='money' kol='1000'/>
				<reward id='repair' kol='1'/>
			</quest>
			
			<quest id='collectCanter' empl='vendor_zebr' rep='1'>
				<q id='1' collect='pinkslime' kol='14' pay='10' give='vendor_zebr'/>
				<q id='2' collect='dsoul' kol='4' pay='40' give='vendor_zebr'/>
				<q id='3' collect='whorn' kol='2' pay='100' give='vendor_zebr'/>
				<q id='4' report='vendor_zebr'/>
				<reward id='s_potion_dexter' kol='1'/>
			</quest>
			<quest id='collectTalisman' empl='vendor_zebr' rep='2'>
				<q id='1' collect='wtal' kol='1' del='1'/>
				<q id='2' report='vendor_zebr'/>
				<reward id='money' kol='1000'/>
				<reward id='amul_dark' kol='1'/>
			</quest>
			
			<quest id='hydroPon' rep='2' enddial='dialCanter8'>
				<q id='1'/>
				<q id='2'/>
				<q id='3' report='vendor_sr'/>
				<reward id='money' kol='1000'/>
				<reward id='p50mg_1' kol='40'/>
				<reward id='gren40_8' kol='20'/>
				<reward id='crystal_6' kol='120'/>
			</quest>
			<quest id='collectDatast' empl='vendor_sr' rep='1'>
				<q id='1' collect='datast' kol='8' pay='500' give='vendor_sr'/>
				<reward id='amul_energ' kol='1'/>
			</quest>
			<quest id='collectMotiv' empl='vendor_sr' rep='1'>
				<q id='1' collect='motiv' kol='10' pay='300' give='vendor_sr'/>
				<reward id='money' kol='1000'/>
				<reward id='impgr' kol='10'/>
			</quest>
			<quest id='collectBbatt' empl='vendor_sr' rep='2'>
				<q id='1' collect='bbatt' kol='1' del='1'/>
				<q id='2' report='vendor_sr'/>
				<reward id='money' kol='2500'/>
				<reward id='energ_6' kol='250'/>
				<reward id='p308_2' kol='40'/>
			</quest>
			<quest id='collectTech' empl='vendor_sr' rep='3'>
				<q id='1' collect='tech1' kol='1' give='vendor_sr' pay='1000'/>
				<q id='2' collect='tech2' kol='1' give='vendor_sr' pay='1500'/>
				<q id='3' collect='tech3' kol='1' give='vendor_sr' pay='2000'/>
				<q id='4' collect='tech4' kol='1' give='vendor_sr' pay='2500'/>
				<q id='5' collect='tech5' kol='1' give='vendor_sr' pay='3000'/>
				<reward id='bel^1' kol='1'/>
			</quest>
			<quest id='enclArmor' empl='vendor_sr' rep='2' trigger='encl_armor' triggerset='wait' begdial='vendor_sr_quest1' enddial='vendor_sr_quest2'>
				<q id='1' collect='enclarmor' kol='1' del='1'/>
				<q id='2' report='vendor_sr'/>
			</quest>
			
			<quest id='collectAlc' empl='vendor_bar' rep='3' begdial='vendor_bar_quest1'>
				<q id='1' collect='alc1' kol='1' give='vendor_bar' pay='250' hidden='1'/>
				<q id='2' collect='alc2' kol='1' give='vendor_bar' pay='500' hidden='1'/>
				<q id='3' collect='alc3' kol='1' give='vendor_bar' pay='750' hidden='1'/>
				<q id='4' collect='alc4' kol='1' give='vendor_bar' pay='1000' hidden='1'/>
				<q id='5' collect='alc5' kol='1' give='vendor_bar' pay='1250' hidden='1'/>
				<q id='6' collect='alc6' kol='1' give='vendor_bar' pay='1500' hidden='1'/>
				<q id='7' collect='alc7' kol='1' give='vendor_bar' pay='2000' hidden='1'/>
				<reward id='socks' kol='1'/>
			</quest>
			
			
<!-- ============================================== ТОРГОВЛЯ ============================================== -->
			<vendor id='nope'>
			</vendor>
			<vendor id='random'>
			</vendor>
			<vendor id='vendor_bar'>
				<buy id='sparklecola' n='20'/>
				<buy id='radcola' n='5' barter='3'/>
				<buy id='sars' n='20'/>
				<buy id='coffee' n='5'/>
				<buy id='beer' n='20'/>
				<buy id='braga' n='20'/>
				<buy id='cordial' n='10'/>
				<buy id='schnapps' n='10'/>
				<buy id='hooch' n='10'/>
				<buy id='spirt' n='5' barter='2'/>
				<task id='collectAlc'/>
			</vendor>
			<vendor id='vendor_weapon'>
				<buy id='p10s' n='1'/>
				<buy id='plap' n='1' />
				<buy id='revo' n='1' />
				<buy id='p308c' n='1'  lvl='10'/>
				<buy id='smg10' n='1'/>
				<buy id='carbine' n='1'  lvl='6'/>
				<buy id='sparkl' n='1'  lvl='7'/>
				<buy id='shotgun' n='1' />
				<buy id='prism' n='1' lvl='4'/>
				<buy id='hunt' n='1' />
				<buy id='winchester' n='1' barter='1'/>
				<buy id='rechr' n='1' />
				<buy id='lasr' n='1' />
				<buy id='plar' n='1'  lvl='8'/>
				<buy id='sniper' n='1'  lvl='6'/>
				<buy id='lassn' n='1'  lvl='8'/>
				<buy id='flamer' n='1' />
				<buy id='incin' n='1'  lvl='8' barter='2'/>
				<buy id='shotgun^1' n='2' lvl='10'/>
				<buy id='sniper^1' n='2' lvl='10'/>
				<buy id='plap^1' n='2' lvl='6'/>
				<buy id='plar^1' n='2' lvl='11' barter='2'/>
				<buy id='lassn^1' n='2' lvl='11'/>
				
				<buy id='p127mm' n='1'  lvl='10'/>
				<buy id='plamg' n='1'  lvl='12'/>
				<buy id='pp127mm' n='2' lvl='10'/>
				<buy id='plam' n='1'  lvl='10'/>
				<buy id='minigun' n='1'  lvl='12'/>
				<buy id='termo' n='2'  lvl='12'/>
				<buy id='brushgun' n='1'  lvl='13'/>
				<buy id='nova' n='1'  lvl='13' barter='3'/>
				<buy id='saf9' n='1' lvl='13' />
				<buy id='zebr' n='1' lvl='13' barter='3'/>
				<buy id='plamg^1' n='2' lvl='14' barter='4'/>
				<buy id='plam^1' n='2' lvl='12' barter='3'/>
				<buy id='gatl' n='2'  lvl='14' barter='3'/>
				
				<buy id='psc' n='1'  lvl='14'/>
				<buy id='pshot' n='1'  lvl='16' barter='3'/>
				<buy id='lmg' n='1' lvl='14'/>
				<buy id='grom' n='1'  lvl='17'/>
				<buy id='anti' n='2'  lvl='16'/>
				<buy id='pshot^1' n='2' lvl='18' barter='5'/>
				<buy id='autor' n='1'  lvl='15' barter='3'/>
				<buy id='quick' n='2'  lvl='15' barter='4'/>
				<buy id='rail' n='2'  lvl='16' barter='3'/>
				
				<buy id='amul_sniper' n='1' lvl='22' noref='1'/>
				<buy id='bag1' n='1' lvl='12' noref='1' hardinv='1'/>
				
				<buy id='p32' n='200' />
				<buy id='p32_1' n='50' />
				<buy id='p32_2' n='60' />
				<buy id='p20' n='300' />
				<buy id='p12' n='120' />
				<buy id='p12_3' n='30' lvl='8'/>
				<buy id='p12_4' n='30' lvl='8' barter='1'/>
				<buy id='p12_5' n='30' lvl='8' barter='3'/>
				<buy id='p9' n='300' />
				<buy id='p10' n='300' />
				<buy id='p10_1' n='80' />
				<buy id='p375' n='140' />
				<buy id='p375_1' n='40' />
				<buy id='p375_2' n='30' />
				<buy id='p44' n='150' />
				<buy id='p44_1' n='30' barter='1'/>
				<buy id='p44_2' n='40' />
				<buy id='p127' n='160' lvl='7' />
				<buy id='p127_2' n='30' lvl='7' />
				<buy id='p308' n='80' lvl='8'/>
				<buy id='p308_1' n='20' lvl='8' barter='2'/>
				<buy id='p308_2' n='30' lvl='8' barter='1'/>
				<buy id='p50mg' n='25' lvl='15'/>
				<buy id='p50mg_1' n='10' lvl='13' barter='5'/>
				<buy id='p556' n='1300' />
				<buy id='p556_1' n='200' />
				<buy id='p556_2' n='150' />
				<buy id='p556_5' n='100' barter='3'/>
				<buy id='p5' n='2500' />
				<buy id='batt' n='800' />
				<buy id='batt_6' n='300' />
				<buy id='energ' n='1000' />
				<buy id='energ_6' n='400' />
				<buy id='crystal' n='1000' lvl='14'/>
				<buy id='fuel' n='2000' />
				<buy id='fuel_7' n='400' barter='1'/>
				<task id='killBloats'/>
				<task id='killLucerne' land='raiders'/>
				<task id='collectFcrystal' land='random_stable'/>
				<task id='retPistol' land='random_mane'/>
				<task id='collectBlaster' land='random_mane'/>
			</vendor>
			<vendor id='vendor_expl'>
				<buy id='glau1' n='1'/>
				<buy id='glau' n='1' lvl='8'/>
				<buy id='mlau' n='1' lvl='12'/>
				<buy id='aglau' n='2' lvl='15'/>
				<buy id='bel' n='1' lvl='15' barter='5'/>
				<buy id='dinamit' n='25'/>
				<buy id='grenade' n='25'/>
				<buy id='gasgr' n='25' barter='2'/>
				<buy id='plagr' n='20' lvl='5'/>
				<buy id='impgr' n='10' lvl='5'/>
				<buy id='molotov' n='20'/>
				<buy id='fgren' n='25'/>
				<buy id='hmine' n='25'/>
				<buy id='mine' n='10'/>
				<buy id='plamine' n='10'  barter='1'/>
				<buy id='impmine' n='10'  barter='2'/>
				<buy id='dbomb' n='10'/>
				<buy id='bomb' n='5' lvl='8'/>
				<buy id='x37' n='5' lvl='10'  barter='2'/>
				<buy id='exc4' n='3' lvl='12'/>
				<buy id='s_molotov' n='1'/>
				<buy id='s_hmine' n='1'/>
				<buy id='s_hgren' n='1'/>
				<buy id='s_acidgr' n='1'  barter='1'/>
				<buy id='s_dbomb' n='1'  barter='2'/>
				<buy id='s_bomb' n='1'  barter='3'/>
				<buy id='gren40' n='35' />
				<buy id='gren40_8' n='10' lvl='7'/>
				<buy id='gren40_9' n='7' lvl='7' barter='2'/>
				<buy id='rocket' n='10' lvl='8' />
				<buy id='egg' n='5' lvl='12' barter='5'/>
				<buy id='balemine' n='4' barter='5' lvl='18'/>
				<buy id='detonat' n='10' />
				<buy id='sensor' n='10' />
				<buy id='powder' n='15' />
				<buy id='timer' n='5' />
				<buy id='turp' n='5' />
				<buy id='tnt' n='5' />
				<buy id='glau^1' n='2' barter='4'/>
				<buy id='mworkexpl' n='1' lvl='5' nocheap='1' noref='1'/>
				<buy id='pcryo' n='50' trigger='test_cryo'/>
				<buy id='cryogr' n='10' lvl='12' trigger='test_cryo'/>
				<buy id='cryomine' n='10' lvl='12' trigger='test_cryo'/>
				<task id='collectNitro'/>
				<task id='collectSmoke'/>
				<task id='killAnthills'/>
				<task id='testCryo' skill='explosives' skilln='9' land='random_stable'/>
				<task id='collectSpgren' skill='explosives' skilln='14' land='random_mane'/>
			</vendor>
			<vendor id='vendor_medic'>
				<buy id='pot1' n='25'/>
				<buy id='pot2' n='15'/>
				<buy id='pot3' n='10'/>
				<buy id='antiradin' n='15'/>
				<buy id='pot0' n='20'/>
				<buy id='antidote' n='10'/>
				<buy id='radx' n='5'/>
				<buy id='firstaid' n='5'/>
				<buy id='doctor' n='3'/>
				<buy id='surgeon' n='2'/>
				<buy id='bloodpak' n='5'/>
				<buy id='dash' n='5'/>
				<buy id='rage' n='6'/>
				<buy id='buck' n='8'/>
				<buy id='medx' n='10'/>
				<buy id='hydra' n='5'  barter='4'/>
				<buy id='mint' n='5'  barter='2'/>
				<buy id='stampede' n='5'  barter='3'/>
				<buy id='pmint' n='5'  barter='5'/>
				<buy id='detoxin' n='5'/>
				<buy id='stethoscope' n='1' lvl='10' noref='1'/>
				<buy id='impl_skin' n='1' lvl='9' nocheap='1' noref='1'/>
				<buy id='impl_regen' n='1' lvl='15' nocheap='1' noref='1'/>
				<buy id='impl_mrech' n='1' lvl='12' nocheap='1' noref='1'/>
				<buy id='impl_intel' n='1' lvl='20' nocheap='1' noref='1'/>
				<buy id='potHP' n='1' barter='5' noref='1'/>
				<task id='repairAutoDoc'/>
				<task id='collectFishfat' land='raiders'/>
				<task id='collectTmed' land='random_stable'/>
				<task id='collectRecipes'/>
				<buy id='vaccine' n='1' nocheap='1' noref='1' trigger='patient_tr1'/>
			</vendor>
			<vendor id='vendor_armor'>
				<buy id='kombu' n='1'/>
				<buy id='antirad' n='1'/>
				<buy id='antihim' n='1'/>
				<buy id='tre' n='2' barter='5'/>
				<buy id='skin' n='2' lvl='5'/>
				<buy id='metal' n='2' lvl='5'/>
				<buy id='intel' n='2' lvl='8'/>
				<buy id='sapper' n='2' lvl='10' trigger='pro_armor'/>
				<buy id='battle' n='2' lvl='12'/>
				<buy id='polic' n='2' lvl='12'/>
				<buy id='magus' n='2' lvl='12'/>
				<buy id='astealth' n='2' lvl='15'/>
				<buy id='assault' n='2' lvl='18'/>
				<buy id='spec' n='2' lvl='18'/>
				<buy id='moon' n='2' lvl='18'/>
				<buy id='power' n='2' lvl='20' trigger='power_armor' pmult='0.4'/><!---->
				<buy id='amul_war' n='1' lvl='22' noref='1'/>
				
				<buy id='s_chitin' n='1' nocheap='1' lvl='5' barter='1'/>
				<buy id='kombu_comp' n='6'/>
				<buy id='antirad_comp' n='3'/>
				<buy id='antihim_comp' n='3'/>
				<buy id='skin_comp' n='4' lvl='5'/>
				<buy id='metal_comp' n='3' lvl='5'/>
				<buy id='intel_comp' n='3' lvl='8'/>
				<buy id='battle_comp' n='5' lvl='11'/>
				<buy id='polic_comp' n='5' lvl='8'/>
				<buy id='magus_comp' n='5' lvl='11'/>
				
				<task id='findProArmor'/>
				<task id='killMadfox'/>
				<task id='collectPaintsA'/>
				<task id='collectPaintsB' trigger='colors1' land='random_stable'/>
				<task id='collectPaintsC' trigger='colors2' land='random_mane'/>
				<task id='collectPowerArmor' land='random_mbase'/>
			</vendor>
			<vendor id='vendor_mech'>
				<buy id='mont' n='1'/>
				<buy id='mach' n='1' lvl='3'/>
				<buy id='hammer' n='1' lvl='10'/>
				<buy id='spear' n='1' />
				<buy id='axe' n='1' lvl='8'/>
				<buy id='zsword' n='1' lvl='6'/>
				<buy id='sword' n='1' lvl='14'/>
				<buy id='elsword' n='1' lvl='12' barter='2'/>
				<buy id='tlance' n='1' lvl='12'/>
				<buy id='ripper' n='1' lvl='7'/>
				<buy id='autoaxe' n='1' lvl='10'/>
				<buy id='bsaw' n='1'  lvl='12'/>
				<buy id='sledge' n='1'  lvl='14'/>
				<buy id='lsword' n='2' lvl='17'/>
				<buy id='mspear' n='2' lvl='15'/>
				<buy id='cknife^1' n='2' lvl='10'/>
				<buy id='ripper^1' n='2' lvl='12'/>
				<buy id='mont^1' n='2' lvl='10' barter='2'/>
				<buy id='hammer^1' n='2' lvl='14' barter='3'/>
				<buy id='sword^1' n='2' lvl='16' barter='5'/>
				<buy id='mspear^1' n='2' lvl='18'/>
				<buy id='amul_berserk' n='1' lvl='22' noref='1'/>
				
				<buy id='s_hsword' n='1'/>
				<buy id='s_arson' n='1'/>
				<buy id='s_dartgun' n='1' lvl='3'/>
				<buy id='s_acidgun' n='1' lvl='6'/>
				<buy id='s_sawgun' n='1' lvl='9'/>
				<buy id='s_buckshot' n='1' lvl='12'/>
				<buy id='s_railway' n='1' lvl='15'/>
				<buy id='s_bfg' n='1' lvl='12' barter='5'/>
				<buy id='s_mod_metal' n='1' lvl='5'/>
				<buy id='s_mod_analis' n='1' lvl='8'/>
				<buy id='s_mod_target' n='1' lvl='11'/>
				<buy id='s_mod_holo' n='1' lvl='14'/>
				<buy id='s_mod_reanim' n='1' lvl='17'/>
				<buy id='s_cdagger' n='1' lvl='20'/>
				<buy id='aero' n='400'/>
				<buy id='dart' n='50'/>
				<buy id='acid' n='30'/>
				<buy id='saw' n='30'/>
				<buy id='spikenail' n='100'/>
				<buy id='runa' n='4'/>
				<buy id='reboot' n='4'/>
				<buy id='pin' n='10'/>
				<buy id='stealth' n='5'/>
				<buy id='rep' n='6' barter='3' nocheap='1'/>
				
				<buy id='strap' n='3' lvl='9'/>
				<buy id='tape' n='3' lvl='9'/>
				<buy id='glue' n='3' lvl='9'/>
				<buy id='tubing' n='3' lvl='10'/>
				<buy id='pulv' n='1' lvl='12'/>
				<buy id='compress' n='1' lvl='12'/>
				<buy id='motor' n='1' lvl='13'/>
				<buy id='spring' n='2' lvl='13'/>
				<buy id='resscook' n='1' lvl='15'/>
				<buy id='mano' n='1' lvl='15'/>
				<buy id='tlevit' n='1' lvl='18'/>
				<buy id='superc' n='1' lvl='18'/>
				<buy id='condens' n='5' lvl='20'/>
				<buy id='magnit' n='5' lvl='20'/>
				<buy id='elcomp' n='30'/>
				<buy id='pbatt' n='1'/>
				
				<buy id='screwdriver' n='1' noref='1'/>
				<buy id='titansd' n='1' noref='1' nocheap='1'/>
				<buy id='mworkbench' n='1' lvl='5' noref='1' nocheap='1'/>
				<buy id='s_owl' n='1' lvl='20' noref='1' nocheap='1'/>
				<buy id='c_owl' n='1' lvl='20' noref='1' nocheap='1'/>
				
				<task id='collectScrew'/>
				<task id='collectTools'/>
				<task id='collectFans'/>
				<task id='collectMolefat'/>
				<task id='collectCol2'/>
				<task id='collectData' land='random_stable' skill='science' skilln='9'/>
			</vendor>
			<vendor id='vendor_mage'>
				<buy id='telebul' n='2'/>
				<buy id='mbul' n='2'/>
				<buy id='ice' n='2' lvl='4'/>
				<buy id='dragon' n='2' lvl='6'/>
				<buy id='blades' n='2' lvl='8'/>
				<buy id='mbul^1' n='2' lvl='9'/>
				<buy id='lightning' n='2' lvl='10'/>
				<buy id='ice^1' n='2' lvl='11'/>
				<buy id='fireball' n='2' lvl='12'/>
				<buy id='dragon^1' n='2' lvl='13'/>
				<buy id='mray' n='2' lvl='14'/>
				<buy id='blades^1' n='2' lvl='15'/>
				<buy id='defwave' n='2' lvl='16'/>
				<buy id='lightning^1' n='2' lvl='17'/>
				<buy id='eclipse' n='2' lvl='18'/>
				<buy id='fireball^1' n='2' lvl='19'/>
				<buy id='dray' n='2' lvl='20'/>
				<buy id='mray^1' n='2' lvl='21'/>
				<buy id='udar' n='2' lvl='22'/>
				<buy id='defwave^1' n='2' lvl='23'/>
				<buy id='skybolt' n='2' lvl='24'/>
				<buy id='eclipse^1' n='2' lvl='25'/>
				<buy id='sp_slow' n='1' lvl='3' noref='1'/>
				<buy id='sp_mwall' n='1' lvl='6' noref='1'/>
				<buy id='sp_blast' n='1' lvl='9' noref='1'/>
				<buy id='sp_cryst' n='1' lvl='12' noref='1'/>
				<buy id='sp_kdash' n='1' lvl='15' noref='1'/>
				<buy id='sp_mshit' n='1' lvl='18' noref='1'/>
				<buy id='sp_gwall' n='1' lvl='21' noref='1'/>
				<buy id='sp_invulner' n='1' lvl='24' noref='1'/>
				<buy id='amul_spark' n='2' lvl='13' noref='1'/>
				<buy id='amul_mage' n='1' lvl='22' noref='1'/>
				
				<buy id='potm1' n='45'/>
				<buy id='potm2' n='25'/>
				<buy id='potm3' n='15'/>
				<buy id='potion_consc' n='1' lvl='12' noref='1' hardinv='1'/>
				<buy id='potion_mage' n='5' barter='2'/>
				<buy id='potion_shadow' n='4' barter='4'/>
				<buy id='potion_infra' n='3' barter='3'/>
				<buy id='potion_fly' n='2' barter='5'/>
				<buy id='herbs' n='100'/>
				<buy id='sphera' n='1' barter='5' noref='1' nocheap='1'/>
				<buy id='s_potion_mage' n='1' lvl='4'/>
				<buy id='s_potion_swim' n='1' lvl='6'/>
				<buy id='s_potion_stim' n='1' lvl='7'/>
				<buy id='s_potion_infra' n='1' lvl='10'/>
				<buy id='s_potion_shadow' n='1' lvl='13'/>
				<buy id='s_potion_fly' n='1' lvl='16'/>
				<buy id='s_potion_immun' n='1' lvl='6'/>
				<buy id='s_potion_speed' n='1' lvl='9'/>
				<buy id='s_potion_dskel' n='1' lvl='12'/>
				<buy id='s_potion_might' n='1' lvl='15'/>
				<buy id='s_potion_prec' n='1' lvl='18'/>
				<buy id='taintextract' n='1' barter='3' noref='1'/>
				<buy id='hydrablood' n='1' barter='4' noref='1'/>
				<buy id='rainbow' n='1' barter='5' noref='1'/>
				<buy id='stardust' n='1' barter='5' noref='1'/>
				<buy id='moonstone' n='1' barter='5' noref='1'/>
				<buy id='retr' n='5'/>
				<buy id='mworklab' n='1' lvl='5' noref='1' nocheap='1'/>
				<buy id='tal_star' n='1' lvl='25' noref='1' nocheap='1'/>
				<buy id='tal_moon' n='1' lvl='30' noref='1' nocheap='1'/>
				<buy id='tal_sun' n='1' lvl='35' noref='1' nocheap='1'/>
				<buy id='tal_ether' n='1' lvl='40' noref='1' nocheap='1'/>
				
				<task id='collectBooks'/>
				<task id='collectGems' land='random_stable'/>
				<task id='collectDust' land='random_mane'/>
			</vendor>
			<vendor id='vendor_cook'>
				<buy id='meat' n='5'/>
				<buy id='bread' n='12'/>
				<buy id='oats' n='10'/>
				<buy id='milk' n='5'/>
				<buy id='butter' n='3'/>
				<buy id='potato' n='10'/>
				<buy id='cucumber' n='10'/>
				<buy id='tomato' n='10' lvl='3'/>
				<buy id='cabbage' n='10' lvl='3'/>
				<buy id='mushroom' n='5' lvl='5'/>
				<buy id='cheese' n='3' lvl='5'/>
				<buy id='flour' n='3' lvl='8'/>
				<buy id='tegg' n='10' lvl='8'/>
				<buy id='carrot' n='3' lvl='8'/>
				<buy id='onion' n='3' lvl='8'/>
				<buy id='apple' n='3' lvl='12'/>
				<buy id='sugar' n='1' lvl='12'/>
				<buy id='garlic' n='1' lvl='15'/>
				<buy id='chips' n='3' lvl='15' barter='3'/>
				<buy id='bananas' n='2' lvl='15' barter='4'/>
				<buy id='honey' n='1' lvl='15' barter='4'/>
				
				<buy id='frpot' n='1'/>
				<buy id='oatmeal' n='1'/>
				<buy id='cucsand' n='1'/>
				<buy id='salad' n='1' lvl='7'/>
				<buy id='chpasta' n='1' lvl='7'/>
				<buy id='omelet' n='1' lvl='7'/>
				<buy id='butterbr' n='1' lvl='7'/>
				<buy id='soup' n='1' lvl='11'/>
				<buy id='casser' n='1' lvl='11'/>
				<buy id='pizza' n='1' lvl='14'/>
				<buy id='ragu' n='1' lvl='17'/>
				<buy id='spsalad' n='1' lvl='18'/>
				<buy id='patty' n='1' lvl='19'/>
				<buy id='maffin' n='1' lvl='20'/>
				
				<buy id='s_frmeat' n='1' noref='1'/>
				<buy id='s_cucsand' n='1' lvl='3' noref='1'/>
				<buy id='s_frpot' n='1' lvl='3' noref='1'/>
				<buy id='s_oatmeal' n='1' lvl='3' barter='1' noref='1'/>
				<buy id='s_salad' n='1' lvl='3' barter='1' noref='1'/>
				<buy id='s_chpasta' n='1' lvl='5' barter='2' noref='1'/>
				<buy id='s_omelet' n='1' lvl='6' barter='2' noref='1'/>
				<buy id='s_butterbr' n='1' lvl='7' barter='2' noref='1'/>
				<buy id='s_breakfast' n='1' lvl='8' barter='1' noref='1'/>
				<buy id='s_soup' n='1' lvl='8' barter='1' noref='1'/>
				<buy id='s_pizza' n='1' lvl='12' barter='3' noref='1'/>
				<buy id='s_casser' n='1' lvl='10' barter='2' noref='1'/>
				<buy id='s_ragu' n='1' lvl='11' barter='2' noref='1'/>
				<buy id='s_spsalad' n='1' lvl='14' barter='2' noref='1'/>
				<buy id='s_patty' n='1' lvl='13' barter='3' noref='1'/>
				<buy id='s_maffin' n='1' lvl='15' barter='4' noref='1'/>
			</vendor>
			<vendor id='vendor_zebr'>
				<buy id='elsword^1' n='2' lvl='10' barter='3'/>
				<buy id='amul_sneak' n='1' lvl='13' noref='1'/>
				<buy id='amul_adept' n='1' lvl='22' noref='1'/>
				<buy id='potion_purif' n='10'/>
				<buy id='herbs' n='200'/>
				<buy id='taintextract' n='1' noref='1'/>
				<buy id='hydrablood' n='1' noref='1'/>
				<buy id='rainbow' n='1' barter='1' noref='1'/>
				<buy id='stardust' n='1' barter='2' noref='1'/>
				<buy id='moonstone' n='1' barter='3' noref='1'/>
				<buy id='firecrystal' n='1' barter='4' noref='1'/>
				<buy id='essence' n='1' barter='5' noref='1'/>
				<buy id='spirt' n='5'/>
				<buy id='firegland' n='3'/>
				<buy id='mdust' n='4'/>
				<buy id='vampfang' n='2'/>
				<buy id='ghoulblood' n='5'/>
				<buy id='wingmembrane' n='3'/>
				<buy id='mint' n='5'  barter='1'/>
				<buy id='stampede' n='5'  barter='2'/>
				<buy id='pmint' n='5'  barter='3'/>
				<buy id='potm1' n='10'/>
				<buy id='potm2' n='20'/>
				<buy id='potm3' n='25'/>
				<buy id='zebmine' n='20' trigger='encounter_post'/>
				
				<buy id='s_potion_mage' n='1' lvl='4'/>
				<buy id='s_potion_swim' n='1' lvl='6'/>
				<buy id='s_potion_stim' n='1' lvl='7'/>
				<buy id='s_potion_infra' n='1' lvl='10'/>
				<buy id='s_potion_shadow' n='1' lvl='12'/>
				<buy id='s_potion_fly' n='1' lvl='13'/>
				<buy id='s_potion_immun' n='1' lvl='6'/>
				<buy id='s_potion_speed' n='1' lvl='9'/>
				<buy id='s_potion_dskel' n='1' lvl='10'/>
				<buy id='s_potion_might' n='1' lvl='12'/>
				<buy id='s_potion_purif' n='1' lvl='15'/>
				<buy id='s_potion_prec' n='1' lvl='15'/>
				<buy id='s_potion_dexter' n='1' lvl='26'/>
				<buy id='s_potion_crit' n='1' lvl='20'/>
				<buy id='s_apie' n='1' lvl='12'/>
				<buy id='s_mpie' n='1' lvl='14'/>
				<buy id='s_ppie' n='1' lvl='16'/>
				<buy id='s_spie' n='1' lvl='18'/>
				<buy id='s_borsch' n='1' lvl='20'/>
				<buy id='potion_consc' n='1' lvl='12' noref='1' hardinv='1'/>
				
				<task id='collectCanter' man='1'/>
				<task id='collectTalisman' man='1'/>
			</vendor>
			<vendor id='vendor_sr'>
				<buy id='minigun^1' n='2' lvl='18'/>
				<buy id='plamg^1' n='2' lvl='20'/>
				<buy id='plam^1' n='2' lvl='18'/>
				<buy id='psc' n='1'  lvl='13'/>
				<buy id='cflamer' n='1' lvl='14'/>
				<buy id='pshot' n='1'  lvl='15'/>
				<buy id='rail' n='2'  lvl='16'/>
				<buy id='lmg' n='1' lvl='13'/>
				<buy id='grom' n='1'  lvl='16'/>
				<buy id='anti' n='2'  lvl='16'/>
				<buy id='gatl' n='2'  lvl='16'/>
				<buy id='gatp' n='2' lvl='18'/>
				<buy id='autor' n='1'  lvl='17'/>
				<buy id='hmg' n='2'  lvl='17'/>
				<buy id='quick' n='2'  lvl='18'/>
				<buy id='grom^1' n='2' lvl='23'/>
				<buy id='cflamer^1' n='2' lvl='20' barter='4'/>
				<buy id='anti^1' n='2' lvl='20'/>
				<buy id='mlau' n='1' lvl='10'/>
				<buy id='aglau' n='2' lvl='14'/>
				<buy id='bel' n='1' lvl='20'/>
				<buy id='sword^1' n='2' lvl='20'/>
				
				<buy id='p12' n='50' />
				<buy id='p12_3' n='30' barter='4'/>
				<buy id='p12_4' n='30' barter='5'/>
				<buy id='p12_5' n='30' barter='5'/>
				<buy id='p127' n='140' />
				<buy id='p127_2' n='30' barter='4'/>
				<buy id='p308' n='50' />
				<buy id='p308_1' n='20' barter='3'/>
				<buy id='p308_2' n='30' barter='4'/>
				<buy id='p50mg' n='60'/>
				<buy id='p50mg_1' n='15' barter='4'/>
				<buy id='p50mg_4' n='15' barter='5'/>
				<buy id='p556' n='400' />
				<buy id='p556_1' n='100' barter='3'/>
				<buy id='p556_2' n='80' barter='3'/>
				<buy id='p556_5' n='50' barter='4'/>
				<buy id='p5' n='2500' />
				<buy id='p5_1' n='400' />
				<buy id='energ' n='500' />
				<buy id='energ_6' n='200' barter='3' />
				<buy id='crystal' n='1500'/>
				<buy id='crystal_6' n='500' barter='4'/>
				<buy id='fuel' n='2500'/>
				<buy id='fuel_7' n='400' barter='4'/>
				<buy id='p145' n='40'/>
				<buy id='gren40' n='40' />
				<buy id='gren40_8' n='20' barter='2'/>
				<buy id='gren40_9' n='10' barter='4'/>
				<buy id='rocket' n='30'/>
				<buy id='empbomb' n='5' />
				<buy id='s_empbomb' n='1'/>
				
				<buy id='bag2' n='1' lvl='12' noref='1' hardinv='1'/>
				
				<task id='hydroPon' man='1'/>
				<task id='collectDatast' man='1'/>
				<task id='collectMotiv' man='1'/>
				<task id='collectBbatt' man='1' land='bunker'/>
				<task id='enclArmor' man='1' land='bunker'/>
				<task id='collectTech' man='1' land='bunker'/>
			</vendor>
			<vendor id='vendor_maps'>
				<buy id='card0' n='3' nocheap='1' noref='1'/>
				<buy id='card1' n='3' nocheap='1' noref='1'/>
				<buy id='card2' n='3' nocheap='1' noref='1'/>
				<buy id='card3' n='3' nocheap='1' noref='1'/>
				<buy id='card4' n='3' nocheap='1' noref='1'/>
				<buy id='key_rar' n='1' barter='4' noref='1'/>
			</vendor>
			
		</game>
	}
	
}

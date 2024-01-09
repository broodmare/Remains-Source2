package fe {
	
	//var ClassRef:Class = getDefinitionByName("int") as Class;
	
	public class AllData {

		public function AllData() {
		}
		
		public static var d:XML=
		<all>
			
			<unit id='training' fraction='1'>
				<phis sX='60' sY='75' massa='120'/>
				<move knocked='1' damwall='100'/>
				<comb hp='500' armor='0' marmor='0'/>
				<param blood='0'/>
				<vulner emp='1'/>
			</unit>
			
		
	<!--       *******   Юниты   *******         -->
			
			<!-- игрок и союзники -->
			<unit id='littlepip'>
				<phis sX='50' sY='70' massa='50'/>
				<move speed='7' accel='3.5'/>
				<comb hp='40'/>
			</unit>
			<weapon id='punch' tip='0' cat='0' skill='1' tipdec='5'>
				<char rapid='13' damage='10' tipdam='2' knock='5' destroy='4'/>
				<phis speed='9' deviation='0'/>
				<snd noise='400'/>
				<vis tipdec='4'/>
			</weapon>
			
			<unit id='npc' fraction='100'>
				<phis sX='60' sY='79' massa='120'/>
				<move knocked='0' plav='0' levit='0'/>
				<comb hp='10000' dexter='100'/>
				<param invulner='1' acttrap='0' sats='0' npc='1'/>
			</unit>
			<unit id='vendor' fraction='100'>
				<phis sX='60' sY='75' massa='120'/>
				<move knocked='0' plav='0' levit='0'/>
				<comb hp='10000' dexter='100'/>
				<vis replic='vendor'/>
				<param invulner='1' acttrap='0' sats='0' npc='1'/>
			</unit>
			<unit id='doctor' fraction='100'>
				<phis sX='60' sY='75' massa='120'/>
				<move knocked='0' plav='0' levit='0'/>
				<comb hp='10000' dexter='100'/>
				<vis replic='doctor'/>
				<param invulner='1' acttrap='0' sats='0' npc='1'/>
			</unit>
			<unit id='captive' fraction='100'>
				<phis sX='60' sY='75' massa='250'/>
				<move knocked='0' plav='0' fixed='1' levit='0'/>
				<comb hp='100' dexter='100'/>
				<vis replic='captive'/>
				<param invulner='1' acttrap='0' sats='0' npc='1'/>
			</unit>
			<unit id='ponpon' fraction='100'>
				<phis sX='60' sY='75' massa='50'/>
				<move knocked='0' plav='0' fixed='1' levit='0'/>
				<comb hp='100' dexter='100'/>
				<vis replic='ponpon'/>
				<param invulner='1' acttrap='0' sats='0' npc='1'/>
			</unit>
			
			<!-- пони -->
			<unit id='pony' cat='1'/>
			<unit id='raider' fraction='2' cat='2'>
				<move brake='0.3' levit_max='60' levitaccel='1.6' damwall='25'/>
				<comb skill='0.8' aqual='0.5' damage='8' levitatk='0'/>
				<vis noise='600' replic='raider' visdam='1'/>
				<snd music='combat_1' die='rm'/>
				<param overlook='0' blood='1' pony='1' hero='raider' hbonus='1' izvrat='1'/>
				<un dist='500'/>
				<n>Общие параметры рейдеров</n>
				<blit id='stay'/>
				<blit id='trot' y='1' len='17' rf='1' rep='1'/>
				<blit id='run' y='2' len='8' rep='1'/>
				<blit id='jump' y='3' len='16' stab='1'/>
				<blit id='die' y='4' len='20'/>
				<blit id='death' y='5'/>
				<blit id='fall' y='5' len='13'/>
				<blit id='derg' y='6' len='8' rep='1'/>
				<blit id='plav' y='7' len='24' rep='1'/>
				<blit id='laz' y='8' len='12' rep='1'/>
				<blit id='walk' y='9' len='24' rep='1'/>
			</unit>
			<unit id='raider1' cont='raider' xp='100' cat='3' parent='raider'>
				<phis sX='55' sY='70' massa='55'/>
				<move speed='4' jump='18' accel='3'/>
				<comb hp='50' damage='11' krep='1'/>
				<vis blit='sprRaider1' sprX='120' sex='w'/>
				<n>Рейдер-садист</n>
				<w id='cknife' ch='0.2' dif='6'/>
				<w id='mach' ch='0.1'/>
				<w id='armature' ch='0.3'/>
				<w id='chopper' ch='0.3'/>
				<w id='zknife' ch='0.5'/>
				<w id='knife'/>
			</unit>
			<unit id='raider2' cont='raider' xp='100' cat='3' parent='raider'>
				<phis sX='55' sY='70' massa='50'/>
				<move speed='5' jump='18' accel='3' brake='1'/>
				<comb hp='40' dexter='1.2' damage='10' krep='0'/>
				<vis blit='sprRaider2' sprX='120' sex='w' telecolor='0xFF9900'/>
				<n>Рейдер-бродяга</n>
				<w id='mach' ch='0.3' dif='6'/>
				<w id='bat' ch='0.3'/>
				<w id='chopper' ch='0.3'/>
				<w id='armature' ch='0.5'/>
				<w id='spear'/>
			</unit>
			<unit id='raider3' cont='raider' xp='150' cat='3' parent='raider'>
				<phis sX='60' sY='75' massa='110'/>
				<move speed='4' jump='15' accel='1'/>
				<comb hp='60' armor='15' aqual='0.5' dexter='0.9' damage='15' krep='1'/>
				<vulner laser='0.5'/>
				<vis blit='sprRaider3' sprX='130'/>
				<n>Рейдер-металлист</n>
				<w id='pipe' ch='0.3' dif='5'/>
				<w id='bat' ch='0.3'/>
			</unit>
			<unit id='raider4' cont='raider' xp='150' cat='3' parent='raider'>
				<phis sX='60' sY='75' massa='75'/>
				<move speed='4' jump='18' accel='2.6' brake='1'/>
				<comb hp='60' armor='3' aqual='0.5' dexter='1.2' damage='18' krep='0'/>
				<vis blit='sprRaider4' sprX='130' telecolor='0xFF0066'/>
				<n>Рейдер-развратник</n>
				<w id='hammer' ch='0.5' dif='10'/>
				<w id='axe' ch='0.5' dif='5'/>
				<w id='mace' ch='0.5'/>
				<w id='shovel'/>
			</unit>
			<unit id='raider5' cont='raider' xp='150' cat='3' parent='raider'>
				<phis sX='55' sY='70' massa='55'/>
				<move speed='4' jump='18' accel='3'/>
				<comb hp='50' dexter='0.9' damage='15' krep='1'/>
				<vis blit='sprRaider5' sprX='120' sex='w'/>
				<n>Рейдер-бунтарь</n>
				<w id='smg10' ch='0.3' dif='7'/>
				<w id='smg9' ch='0.3' dif='5'/>
				<w id='p10mm' ch='0.25'/>
				<w id='p9mm' ch='0.5'/>
				<w id='r32'/>
			</unit>
			<unit id='raider6' cont='raider' xp='200' cat='3' parent='raider'>
				<phis sX='55' sY='70' massa='60'/>
				<move speed='4' jump='18' accel='3'/>
				<comb hp='80' armor='2' aqual='0.5' dexter='0.9' damage='10' krep='0' skill='1'/>
				<un dist='500'/>
				<vis blit='sprRaider6' sprX='120' sex='w' telecolor='0x6699FF'/>
				<n>Рейдер-палач</n>
				<w id='shotgun' ch='0.5' dif='5'/>
				<w id='lshot' ch='0.5'/>
				<w id='oldshot'/>
			</unit>
			<unit id='raider7' cont='raider' xp='220' cat='3' parent='raider'>
				<phis sX='60' sY='75' massa='85'/>
				<move speed='4' jump='18' accel='2'/>
				<comb hp='100' armor='3' aqual='0.75' armorhp='200' damage='18' krep='1' skill='1.2' observ='3'/>
				<un och='60' walker='1'/>
				<vis blit='sprRaider7' sprX='130'/>
				<n>Рейдер-мастер</n>
				<w id='winchester' ch='0.2' dif='8'/>
				<w id='assr' ch='0.4'/>
				<w id='oldr' ch='0.5'/>
				<w id='hunt'/>
			</unit>
			<unit id='raider8' cont='raider' xp='200' cat='3' parent='raider'>
				<phis sX='60' sY='75' massa='90'/>
				<move speed='4' jump='17' accel='3'/>
				<comb hp='80' marmor='5' aqual='0.5' armorhp='120' dexter='0.9' damage='10' krep='0'/>
				<un och='120' dist='500'/>
				<vulner fire='0.5'/>
				<vis blit='sprRaider8' sprX='130' telecolor='0xFFFF00'/>
				<n>Рейдер-поджигатель</n>
				<w id='molotov' ch='0.05' dif='5'/>
				<w id='flamer' ch='0.4' dif='5'/>
				<w id='flaregun'/>
			</unit>
			<unit id='raider9' cont='raider' xp='150' cat='3' parent='raider'>
				<phis sX='55' sY='70' massa='55'/>
				<move speed='5' jump='18' accel='3'/>
				<comb hp='60' dexter='1.2' damage='15' krep='0'/>
				<un dist='700' gren='1'/>
				<vulner expl='0.5'/>
				<vis blit='sprRaider9' sprX='120' sex='w' telecolor='0xFF0000'/>
				<n>Рейдер-подрывник</n>
				<w id='hgren' ch='0.7'/>
				<w id='grenade'/>
			</unit>
			<unit id='bossraider' fraction='2' xp='1500' cat='3'>
				<phis sX='100' sY='100' massa='250'/>
				<move brake='0.3' speed='3' accel='2.5' jump='12' levit_max='60' levitaccel='1.6' damwall='25' krep='1'/>
				<comb hp='2000' skill='1.2' aqual='0.25' armor='10' damage='19' dexter='0.5'/>
				<vulner fire='0.3'/>
				<vis noise='600' vclass='visualRaiderBoss2' dkill='0'/>
				<snd music='boss_1'/>
				<param overlook='1' blood='1' pony='1'/>
				<w id='flamer' f='1'/>
				<w id='assr' f='1'/>
			</unit>
			
			<unit id='slaver' fraction='2' cat='2'>
				<move brake='0.3' levit_max='60' levitaccel='1.6' damwall='35'/>
				<comb skill='1' aqual='0.65' damage='8' levitatk='0'/>
				<vis noise='600' replic='raider' visdam='1'/>
				<snd music='combat_1' die='rm'/>
				<param overlook='0' blood='1' pony='1' hero='slaver' hbonus='1' izvrat='1'/>
				<blit id='stay'/>
				<blit id='trot' y='1' len='17' rf='1' rep='1'/>
				<blit id='run' y='2' len='8' rep='1'/>
				<blit id='jump' y='3' len='16' stab='1'/>
				<blit id='die' y='4' len='20'/>
				<blit id='death' y='5'/>
				<blit id='fall' y='5' len='13'/>
				<blit id='derg' y='6' len='8' rep='1'/>
				<blit id='plav' y='7' len='24' rep='1'/>
				<blit id='laz' y='8' len='12' rep='1'/>
				<blit id='walk' y='9' len='24' rep='1'/>
			</unit>
			<unit id='slaver1' cont='raider' xp='250' cat='3' parent='slaver'>
				<phis sX='55' sY='70' massa='65'/>
				<move speed='5' jump='18' accel='3' brake='1'/>
				<comb hp='80' damage='20' skill='1' krep='1' armor='5' aqual='0.65' dexter='1.2' observ='3'/>
				<vis blit='sprSlaver1' sprX='120' sex='w'/>
				<un walker='1'/>
				<n>Погонщик</n>
				<w id='cknife' ch='0.2'/>
				<w id='mach' ch='0.4'/>
				<w id='hunt' ch='0.3'/>
				<w id='lshot' ch='0.3'/>
				<w id='zknife' ch='0.5'/>
				<w id='pipe'/>
			</unit>
			<unit id='slaver2' cont='raider' xp='300' cat='3' parent='slaver'>
				<phis sX='60' sY='75' massa='75'/>
				<move speed='4.5' jump='18' accel='3'/>
				<comb hp='100' armor='5' aqual='0.65' damage='18' krep='0' observ='6'/>
				<vis blit='sprSlaver2' sprX='130' telecolor='0xFF0000'/>
				<un walker='1'/>
				<n>Ловчий</n>
				<w id='sledge' ch='0.04' dif='18'/>
				<w id='hammer' ch='0.25' dif='12'/>
				<w id='p308c' ch='0.3' dif='15'/>
				<w id='revo' ch='0.4'/>
				<w id='r375' ch='0.5'/>
				<w id='smg10' ch='0.5'/>
				<w id='spear'/>
			</unit>
			<unit id='slaver3' cont='raider' xp='300' cat='3' parent='slaver'>
				<phis sX='55' sY='70' massa='65'/>
				<move speed='4' jump='18' accel='2' brake='1'/>
				<comb hp='110' dexter='1.2' damage='20' krep='0' armor='5' aqual='0.75' observ='6'/>
				<vis blit='sprSlaver3' sprX='120' sex='w' telecolor='0xFFCC00'/>
				<un och='60' walker='1'/>
				<n>Надзиратель</n>
				<w id='lmg' ch='0.04' dif='17'/>
				<w id='zebr' ch='0.1' dif='15'/>
				<w id='carbine' ch='0.3' dif='12'/>
				<w id='assr' ch='0.3'/>
				<w id='zsword' ch='0.5'/>
				<w id='flamer'/>
			</unit>
			<unit id='slaver4' cont='raider' xp='450' cat='3' parent='slaver'>
				<phis sX='60' sY='75' massa='140'/>
				<move speed='4' jump='18' accel='2'/>
				<comb hp='125' armor='10' marmor='5' aqual='0.65' armorhp='250' dexter='0.9' damage='25' krep='1' skill='1.2' observ='3'/>
				<vis blit='sprSlaver4' sprX='130'/>
				<n>Охранник</n>
				<un dist='500'/>
				<w id='pshot' ch='0.04' dif='18'/>
				<w id='saf9' ch='0.3' dif='12'/>
				<w id='shotgun' ch='0.5'/>
				<w id='lshot' ch='0.5'/>
				<w id='prism'/>
			</unit>
			<unit id='slaver5' cont='raider' xp='600' cat='3' parent='slaver'>
				<phis sX='60' sY='75' massa='180'/>
				<move speed='3.5' jump='16' accel='2'/>
				<comb hp='150' armor='15' marmor='10' aqual='0.8' armorhp='400' dexter='0.8' damage='25' krep='1' skill='1.5' observ='3'/>
				<vis blit='sprSlaver5' sprX='130'/>
				<un walker='1'/>
				<n>Элитный</n>
				<w id='anti' ch='0.04' dif='18'/>
				<w id='brushgun' ch='0.2' dif='14'/>
				<w id='sniper' ch='0.3' dif='12'/>
				<w id='plar' ch='0.1' dif='14'/>
				<w id='lasr' ch='0.3'/>
				<w id='winchester'/>
			</unit>
			<unit id='slaver6' cont='raider' xp='800' cat='3' parent='slaver'>
				<phis sX='60' sY='75' massa='140'/>
				<move speed='3.5' jump='18' accel='2'/>
				<comb hp='200' armor='5' marmor='15' aqual='0.8' armorhp='400' damage='25' krep='0' skill='1.5' observ='6'/>
				<vis blit='sprSlaver6' sprX='130' telecolor='0xFF55FF'/>
				<un walker='1'/>
				<w id='rail' ch='0.04' dif='18'/>
				<w id='nova' ch='0.2' dif='14'/>
				<w id='lassn' ch='0.3' dif='12'/>
				<w id='plamg' ch='0.1' dif='14'/>
				<w id='plam' ch='0.3'/>
				<w id='sparkl'/>
			</unit>
			
			<unit id='zebra' fraction='2' cat='2'>
				<move brake='0.3' levit_max='30' levitaccel='1.6' damwall='25'/>
				<comb skill='1.2' damage='15' levitatk='0.7'/>
				<vis noise='0' visdam='1'/>
				<snd music='combat_1' die='rm'/>
				<param overlook='0' blood='1' pony='1' hero='zebra' hbonus='1'/>
				<blit id='stay'/>
				<blit id='trot' y='1' len='17' rf='1' rep='1'/>
				<blit id='run' y='2' len='8' rep='1'/>
				<blit id='jump' y='3' len='16' stab='1'/>
				<blit id='die' y='4' len='20'/>
				<blit id='death' y='5'/>
				<blit id='fall' y='5' len='13'/>
				<blit id='derg' y='6' len='8' rep='1'/>
				<blit id='plav' y='7' len='24' rep='1'/>
				<blit id='laz' y='8' len='12' rep='1'/>
				<blit id='walk' y='9' len='24' rep='1'/>
			</unit>
			<unit id='zebra1' cont='raider' xp='300' cat='3' parent='zebra'>
				<phis sX='60' sY='75' massa='65'/>
				<move speed='4' jump='20' accel='3' brake='1'/>
				<comb hp='100' damage='20' skill='1.2' krep='1' dexter='1.5' observ='12'/>
				<vis blit='sprZebra1' sprX='130' sex='w'/>
				<vulner laser='0.8'/>
				<un walker='1' sniper='1'/>
				<n>Зебра-шпион</n>
				<w id='p127mm' ch='0.2' dif='17'/>
				<w id='elsword' ch='0.1' dif='17'/>
				<w id='p308c' ch='0.3' dif='12'/>
				<w id='zsword' ch='0.3' dif='12'/>
				<w id='cknife' ch='0.5'/>
				<w id='p10s'/>
			</unit>
			<unit id='zebra2' cont='raider' xp='350' cat='3' parent='zebra'>
				<phis sX='60' sY='75' massa='85'/>
				<move speed='4' jump='18' accel='3' brake='1'/>
				<comb hp='130' damage='16' skill='1.2' krep='1' dexter='1.2' observ='8'/>
				<vis blit='sprZebra2' sprX='130'/>
				<vulner expl='0.5' fire='0.7'/>
				<un walker='1' sniper='1' drop='bomb'/>
				<n>Зебра-диверсант</n>
				<w id='plamg' ch='0.2' dif='18'/>
				<w id='termo' ch='0.1' dif='18'/>
				<w id='sparkl' ch='0.15' dif='14'/>
				<w id='plar' ch='0.3' dif='12'/>
				<w id='lasr' ch='0.5'/>
				<w id='plap'/>
			</unit>
			<unit id='zebra3' cont='raider' xp='450' cat='3' parent='zebra'>
				<phis sX='60' sY='75' massa='65'/>
				<move speed='4' jump='20' accel='3' brake='1'/>
				<comb hp='100' damage='14' skill='1.3' krep='1' dexter='1.5' observ='12'/>
				<vis blit='sprZebra3' sprX='130' sex='w'/>
				<vulner laser='0.7' plasma='0.8'/>
				<un walker='1' sniper='1' stay='1'/>
				<n>Зебра-ассасин</n>
				<w id='anti' ch='0.1' dif='18'/>
				<w id='grom' ch='0.1' dif='18'/>
				<w id='rail' ch='0.15' dif='16'/>
				<w id='lassn' ch='0.3' dif='12'/>
				<w id='sniper'/>
			</unit>
			<unit id='zebra4' cont='raider' xp='500' cat='3' parent='zebra'>
				<phis sX='60' sY='75' massa='90'/>
				<move speed='4' jump='18' accel='3' brake='1'/>
				<comb hp='120' damage='20' armor='10' marmor='10' aqual='0.7' armorhp='250' skill='1.2' krep='1' dexter='1.2' observ='8'/>
				<vis blit='sprZebra4' sprX='130'/>
				<vulner phis='0.8' blade='0.8' bullet='0.9'/>
				<un walker='1' sniper='1' och='16'/>
				<n>Зебра-боевик</n>
				<w id='lmg' ch='0.2' dif='18'/>
				<w id='pshot' ch='0.1' dif='18'/>
				<w id='zebr'/>
			</unit>
			<unit id='zebra5' cont='raider' xp='750' cat='3' parent='zebra'>
				<phis sX='60' sY='75' massa='110'/>
				<move speed='4' jump='18' accel='3' brake='1'/>
				<comb hp='200' damage='60' armor='10' marmor='20' aqual='0.7' armorhp='250' skill='1.8' krep='1' dexter='1' observ='6'/>
				<vis blit='sprZebra5' sprX='130'/>
				<vulner laser='0.7' bullet='0.8'/>
				<un walker='1' sniper='1' och='16'/>
				<w id='lsword' ch='0.15'/>
				<w id='sword' ch='0.1'/>
				<w id='zsword' ch='0.15'/>
				<w id='lmg' ch='0.1'/>
				<w id='zebr'/>
			</unit>
			<unit id='bossnecr' fraction='2' xp='20000' cat='3'>
				<phis sX='70' sY='70' massa='100'/>
				<move brake='0.3' speed='6' accel='2.5' jump='20' levit_max='60' levitaccel='1.6' damwall='25' krep='1'/>
				<comb hp='3200' skill='2' damage='30'/>
				<vulner pink='0'/>
				<vis noise='600' vclass='visualNecrBoss' visdam='2' sdamage='22' stipdam='16' dkill='0'/>
				<snd music='boss_3'/>
				<param trup='0' overlook='1' blood='1'/>
			</unit>
				<weapon id='necrbullet' tip='0'>
					<char damage='22' rapid='6' prec='0' tipdam='16' destroy='0'/>
					<phis speed='50' deviation='30'/>
					<vis vbul='necrbullet' tipdec='11' flare='' phisbul='1'/> 
					<snd shoot='dash' noise='800'/>
				</weapon>
			
			<unit id='merc' fraction='2' cat='2'>
				<move brake='0.3' levit_max='30' levitaccel='2' damwall='25'/>
				<comb skill='1.2' aqual='0.65' damage='8' ear='1.4' levitatk='0.5'/>
				<vis noise='600' replic='merc' visdam='1'/>
				<snd music='combat_1' die='rm'/>
				<param overlook='0' blood='1' hero='merc' hbonus='1' izvrat='1'/>
				<blit id='stay'/>
				<blit id='walk' y='0' len='25' rf='1' rep='1'/>
				<blit id='fly' y='1' len='14' rep='1'/>
				<blit id='jump' y='1' len='14' stab='1'/>
				<blit id='die' y='2' len='25'/>
				<blit id='death' y='3'/>
				<blit id='fall' y='3' len='17'/>
			</unit>
			<unit id='merc1' cont='raider' xp='300' cat='3' parent='merc'>
				<phis sX='60' sY='70' massa='65'/>
				<move speed='4' jump='12' accel='3' brake='1'/>
				<comb hp='80' damage='20' skill='1' krep='1' dexter='1.8' armor='5' marmor='5' aqual='0.65' armorhp='200' observ='10'/>
				<vis blit='sprGriffon1' sprX='170' sprDX='96' sprDY='132' icoY='2' sex='w'/>
				<vulner fire='1.2'/>
				<un walker='1' stalk='500' sniper='1'/>
				<w id='mercgr' f='1'/>
				<w id='psc' ch='0.1' dif='18'/>
				<w id='p127mm' ch='0.25' dif='16'/>
				<w id='p308c' ch='0.5'/>
				<w id='revo'/>
			</unit>
			<unit id='merc2' cont='raider' xp='500' cat='3' parent='merc'>
				<phis sX='60' sY='70' massa='65'/>
				<move speed='4' jump='12' accel='3' brake='1'/>
				<comb hp='120' damage='20' skill='1' krep='1' dexter='1.5' armor='10' marmor='10' aqual='0.75' armorhp='400' observ='5'/>
				<vis blit='sprGriffon2' sprX='170' sprDX='96' sprDY='132' icoY='2'/>
				<vulner phis='0.75' blade='0.75' fire='0.75'/>
				<un walker='1' stalk='500' och='3' dist='600' sniper='1'/>
				<w id='mercgr' f='1'/>
				<w id='pshot' ch='0.25' dif='18'/>
				<w id='zebr' ch='0.1' dif='17'/>
				<w id='nova' ch='0.04' dif='17'/>
				<w id='plam' ch='0.3' dif='15'/>
				<w id='saf9' ch='0.3' dif='15'/>
				<w id='shotgun' ch='0.2'/>
				<w id='carbine' ch='0.6'/>
				<w id='prism'/>
			</unit>
			<unit id='merc3' cont='raider' xp='500' cat='3' parent='merc'>
				<phis sX='60' sY='70' massa='65'/>
				<move speed='4' jump='12' accel='3' brake='1'/>
				<comb hp='140' damage='20' skill='1' krep='1' dexter='1.3' armor='15' marmor='5' aqual='0.75' armorhp='400' observ='8'/>
				<vis blit='sprGriffon3' sprX='170' sprDX='96' sprDY='132' icoY='2'/>
				<vulner phis='0.85' blade='0.85' bullet='0.85' expl='0.85'/>
				<un walker='1' stalk='1000' och='45' sniper='1' grenader='4'/>
				<w id='mercgr' f='1'/>
				<w id='cflamer' ch='0.01' dif='19'/>
				<w id='autor' ch='0.1' dif='18'/>
				<w id='gatp' ch='0.1' dif='20'/>
				<w id='quick' ch='0.1' dif='19'/>
				<w id='gatl' ch='0.1' dif='15'/>
				<w id='plamg' ch='0.2'/>
				<w id='lmg' ch='0.5'/>
				<w id='minigun'/>
			</unit>
			<unit id='merc4' cont='raider' xp='500' cat='3' parent='merc'>
				<phis sX='60' sY='70' massa='65'/>
				<move speed='4' jump='12' accel='3' brake='1'/>
				<comb hp='100' damage='20' skill='1.3' krep='1' dexter='1.5' armor='5' marmor='10' aqual='0.65' armorhp='200' observ='10'/>
				<vis blit='sprGriffon4' sprX='170' sprDX='96' sprDY='132' icoY='2' sex='w'/>
				<vulner laser='0.85' plasma='0.85' spark='0.85'/>
				<un walker='1' sniper='1' stalk='1500'/>
				<w id='mercgr' f='1'/>
				<w id='grom' ch='0.15' dif='19'/>
				<w id='anti' ch='0.25' dif='18'/>
				<w id='rail' ch='0.15' dif='15'/>
				<w id='lassn' ch='0.4'/>
				<w id='sniper'/>
			</unit>
			<unit id='merc5' cont='raider' xp='800' cat='3' parent='merc'>
				<phis sX='60' sY='70' massa='65'/>
				<move speed='4' jump='12' accel='3' brake='1'/>
				<comb hp='170' damage='20' tipdam='1' skill='1.6' krep='1' dexter='1.3' armor='15' marmor='15' aqual='0.8' armorhp='500' observ='5'/>
				<vis blit='sprGriffon5' sprX='170' sprDX='96' sprDY='132' icoY='2'/>
				<vulner phis='0.75' blade='0.75' plasma='0.85' laser='0.85'/>
				<un walker='1' sniper='1' stalk='500' och='25' grenader='2'/>
				<w id='mercgr' f='1'/>
				<w id='anti' ch='0.25' dif='19'/>
				<w id='lmg' ch='0.5'/>
				<w id='hmg' ch='0.2'/>
				<w id='gatl' ch='0.3'/>
				<w id='gatp' ch='0.2'/>
				<w id='pshot'/>
			</unit>
				<weapon id='mercgr' tip='4' throwtip='2'>
					<char rapid='90' damexpl='250' tipdam='6' knock='10' destroy='300' expl='200' time='120'/>
					<phis speed='30' deviation='5'/>
					<vis tipdec='19'/> 
					<snd fall='fall_grenade'/>
				</weapon>
			
			<unit id='ranger' fraction='4' cat='2'>
				<move brake='0.3' levit_max='60' levitaccel='1.3' plav='0' damwall='70'/>
				<comb skill='1' aqual='0.9' armor='15' marmor='15' damage='16' levitatk='0.5'/>
				<vis noise='600' replic='ranger' visdam='1'/>
				<snd music='combat_1' die='sr'/>
				<param overlook='0' blood='1' pony='1' hero='ranger' hbonus='1'/>
				<vulner venom='0' poison='0' emp='0.25' cryo='0.5' fire='0.5' expl='0.8'/>
				<blit id='stay'/>
				<blit id='walk' y='1' len='24' rep='1'/>
				<blit id='trot' y='2' len='17' rf='1' rep='1'/>
				<blit id='run' y='3' len='8' rep='1'/>
				<blit id='laz' y='4' len='12' rep='1'/>
				<blit id='jump' y='5' len='16' stab='1'/>
				<blit id='die' y='6' len='20'/>
				<blit id='death' y='7'/>
				<blit id='fall' y='7' len='13'/>
			</unit>
			<unit id='ranger1' xp='500' cat='3' parent='ranger'>
				<phis sX='70' sY='75' massa='150'/>
				<move speed='5' jump='14' accel='1.8' brake='1'/>
				<comb hp='180' damage='16' skill='1.2' krep='1' dexter='0.8' aqual='1' armor='25' marmor='15' armorhp='600' observ='6'/>
				<vis blit='sprRanger1' sprX='140'/>
				<un walker='1' sniper='1' och='60'/>
				<n>Рейнджер-рыцарь</n>
				<w id='robomlau' f='1'/>
				<w id='robogas' f='1'/>
				<w id='glau' ch='0.2'/>
				<w id='lmg' ch='0.4'/>
				<w id='minigun'/>
			</unit>
			<unit id='ranger2' xp='750' cat='3' parent='ranger'>
				<phis sX='70' sY='75' massa='170'/>
				<move speed='5' jump='14' accel='1.8' brake='1'/>
				<comb hp='210' damage='24' skill='1.5' krep='1' dexter='0.8' aqual='1' armor='20' marmor='25' armorhp='600' observ='8'/>
				<vulner bul='0.8' phis='0.8' blade='0.8'/>
				<vis blit='sprRanger2' sprX='140'/>
				<un walker='1' sniper='1' och='60'/>
				<n>Рейнджер-рыцарь</n>
				<w id='robomlau' f='1'/>
				<w id='robogas' f='1'/>
				<w id='cflamer' ch='0.3'/>
				<w id='gatl' ch='0.7'/>
				<w id='gatp'/>
			</unit>
			<unit id='ranger3' xp='1000' cat='3' parent='ranger'>
				<phis sX='70' sY='75' massa='200'/>
				<move speed='5' jump='14' accel='1.8' brake='1'/>
				<comb hp='250' damage='30' skill='1.8' krep='1' dexter='0.8' aqual='1' armor='25' marmor='25' armorhp='600' observ='10'/>
				<vulner laser='0.8' plasma='0.8' spark='0.8'/>
				<vis blit='sprRanger3' sprX='140'/>
				<un walker='1' sniper='1' och='60'/>
				<n>Рейнджер-рыцарь</n>
				<w id='robomlau' f='1'/>
				<w id='robogas' f='1'/>
				<w id='gatp' ch='0.2'/>
				<w id='hmg' ch='0.7'/>
				<w id='antidrak'/>
			</unit>
			<unit id='encl' fraction='4' cat='2'>
				<move brake='0.3' levit_max='30' levitaccel='2.5' damwall='25'/>
				<comb skill='1.2' aqual='1' damage='8' ear='1.4'/>
				<vis noise='600' replic='encl' visdam='1'/>
				<snd music='combat_1' die='rm'/>
				<param overlook='0' blood='1' hero='encl' hbonus='1'/>
				<blit id='stay'/>
				<blit id='walk' y='2' len='24' rep='1'/>
				<blit id='trot' y='1' len='17' rf='1' rep='1'/>
				<blit id='fly' y='3' len='8' rep='1'/>
				<blit id='die' y='4' len='20'/>
				<blit id='death' y='5'/>
				<blit id='fall' y='5' len='13'/>
			</unit>
			<unit id='encl1' xp='400' cat='3' parent='encl'>
				<phis sX='70' sY='75' massa='50'/>
				<move speed='5' jump='14' accel='2.5' brake='1'/>
				<comb hp='120' damage='16' skill='1.6' krep='1' dexter='1.2' aqual='0.5' armor='5' marmor='5' armorhp='200'/>
				<vulner spark='0.75'/>
				<vis blit='sprEncl1' sprX='130'/>
				<un walker='1' sniper='1'/>
				<n>Офицер</n>
				<w id='plar' ch='0.2'/>
				<w id='sparkl' ch='0.4'/>
				<w id='cryo' ch='0.1'/>
				<w id='prism'/>
			</unit>
			<unit id='encl2' xp='600' cat='3' parent='encl'>
				<phis sX='70' sY='75' massa='70'/>
				<move speed='6' jump='14' accel='2.5' brake='1'/>
				<comb hp='140' damage='16' skill='1.6' krep='1' dexter='1.8' aqual='0.9' armor='10' marmor='15' armorhp='400' observ='20' ear='2.5'/>
				<vulner laser='0.7' plasma='0.85' venom='0.5'/>
				<vis blit='sprEncl2' sprX='130'/>
				<snd die='sr'/>
				<un walker='1' enclweap='1' stalk='1000' sniper='1'/>
				<n>Разведчик</n>
				<w id='nova' ch='0.2'/>
				<w id='plam' ch='0.3'/>
				<w id='lassn' ch='0.5'/>
				<w id='grom' ch='0.1'/>
				<w id='plamg'/>
			</unit>
			<unit id='encl3' xp='800' cat='3' parent='encl'>
				<phis sX='70' sY='75' massa='80'/>
				<move speed='5' jump='14' accel='2.5' brake='1'/>
				<comb hp='180' damage='40' tipdam='1' skill='1.8' krep='1' dexter='1.6' aqual='1' armor='15' marmor='25' armorhp='600' observ='8'/>
				<vulner laser='0.5' plasma='0.75' venom='0.5'/>
				<vis blit='sprEncl3' sprX='130'/>
				<snd die='sr'/>
				<un walker='1' enclweap='1' sniper='1' grenader='2'/>
				<n>Штурмовик</n>
				<w id='plamg' ch='0.2'/>
				<w id='gatl' ch='0.3'/>
				<w id='termo' ch='0.3'/>
				<w id='grom' ch='0.3'/>
				<w id='nova'/>
			</unit>
			<unit id='encl4' xp='1200' cat='3' parent='encl'>
				<phis sX='70' sY='75' massa='80'/>
				<move speed='6' jump='14' accel='2.8' brake='1'/>
				<comb hp='220' damage='50' tipdam='6' skill='2' krep='1' dexter='1.6' aqual='1' armor='25' marmor='25' armorhp='600' observ='10'/>
				<vulner laser='0.5' plasma='0.75' venom='0.5'/>
				<vis blit='sprEncl4' sprX='130'/>
				<snd die='sr'/>
				<un walker='1' enclweap='1' sniper='1' grenader='4'/>
				<n>Штурмовик</n>
				<w id='gatl' ch='0.3'/>
				<w id='gatp' ch='0.3'/>
				<w id='rail' ch='0.3'/>
				<w id='grom' ch='0.3'/>
				<w id='quick'/>
			</unit>
			<unit id='bossencl' fraction='4' xp='7000' cat='3'>
				<phis sX='100' sY='100' massa='250'/>
				<move brake='0.3' speed='15' accel='1.5' jump='12' levit_max='15' levitaccel='1.6' krep='1'/>
				<comb hp='1800' skill='2' aqual='1' armorhp='1500' damage='45'/>
				<vulner laser='0.7' plasma='0.85' venom='0.5'/>
				<vis blit='sprEnclboss1' sprX='130' sprY='150' dkill='0'/>
				<snd music='boss_6'/>
				<param overlook='1' blood='1' pony='1'/>
				<blit id='stay'/>
				<blit id='fly' y='1' len='8' rep='1'/>
			</unit>
			
			
			<!-- аликорны -->
			<unit id='monster' cat='1'/>
			<unit id='alicorn' cat='2'>
				<phis sX='70' sY='100' sitY='70' massa='110'/>
				<move speed='3' run='10' accel='2' brake='0.4' jump='15' levit_max='90' plav='0' levitaccel='1.2' damwall='50'/>
				<comb hp='200' damage='15'/>
				<vis sprX='150' sprY='150' sprDX='95' sprDY='127' sex='w' noise='600' visdam='3' sdamage='50' stipdam='9'/>
				<snd music='combat_1' die='ali'/>
				<param overlook='0' blood='1' hero='alicorn' alicorn='1' hbonus='1'/>
				<blit id='stay' y='0'/>
				<blit id='walk' y='0' len='29' rf='1' rep='1'/>
				<blit id='sit' y='4'/>
				<blit id='polz' y='4' len='29' rf='1' rep='1'/>
				<blit id='fly' y='1' len='14' rep='1'/>
				<blit id='die' y='2' len='20'/>
				<blit id='death' y='3'/>
				<blit id='fall' y='3' len='13'/>
			</unit>
			<unit id='alicorn1' fraction='1' xp='500' cat='3' parent='alicorn'>
				<comb hp='350' damage='18' observ='10'/>
				<vulner venom='0.5' acid='0.25' cryo='0.5' plasma='0.5' pink='0'/>
				<vis blit='sprAlicorn1' sprX='150' sprY='150' sprDX='95' sprDY='127'/>
			</unit>
			<unit id='alicorn2' fraction='1' xp='500' cat='3' parent='alicorn'>
				<move levit_max='30' levitaccel='1.5' damwall='0'/>
				<comb hp='250' damage='15' observ='5'/>
				<vulner venom='0.5' acid='0.25' laser='0.5' spark='0.5' pink='0'/>
				<vis blit='sprAlicorn2' sprX='150' sprY='150' sprDX='95' sprDY='127'/>
			</unit>
			<unit id='alicorn3' fraction='1' xp='500' cat='3' parent='alicorn'>
				<comb hp='250' damage='12' observ='5'/>
				<vulner venom='0.5' acid='0.25' fire='0.5' expl='0.5' pink='0'/>
				<vis blit='sprAlicorn3' sprX='150' sprY='150' sprDX='95' sprDY='127'/>
			</unit>
				<weapon id='alilight' tip='0'>
					<char damage='50' rapid='35' prep='12' prec='0' tipdam='9' destroy='50'/>
					<phis speed='50' deviation='7'/>
					<vis vweap='visalilight' tipdec='11' vbul='lightning' flare='spark' bulanim='1'/> 
					<snd shoot='lightning' noise='800'/>
					<n>Молния</n>
				</weapon>
				<weapon id='alipsy' tip='0'>
					<char damage='5' rapid='5' prec='0' tipdam='9' destroy='0'/>
					<phis speed='35' deviation='7'/>
					<vis vweap='vismray' vbul='psy' flare='plasma'/> 
					<dop effect='psy' ch='1'/>
					<snd shoot='psy'/>
					<n>Пси-атака</n>
				</weapon>
			<unit id='bossalicorn' fraction='1' xp='10000' cat='3'>
				<phis sX='100' sY='100' massa='110'/>
				<move speed='3' run='10' accel='2' brake='0.4' jump='15' levit_max='90' plav='0' levitaccel='1.2' damwall='25'/>
				<comb hp='4500' damage='35'/>
				<vulner venom='0.5' acid='0.25'/>
				<vis blit='sprAlicorn4' sprX='170' sprY='170' sprDX='105' sprDY='150' visdam='3' sdamage='70' stipdam='9' dkill='0'/>
				<snd music='boss_2'/>
				<param trup='0' overlook='1' alicorn='1'/>
				<blit id='stay' y='0' len='20' rep='1'/>
				<blit id='fly' y='1' len='14' rep='1'/>
				<blit id='die' y='2' len='14'/>
				<w id='aliblade' f='1'/>
				<w id='alimray' f='1'/>
			</unit>
				<weapon id='alilight2' tip='0'>
					<char damage='70' rapid='20' prec='0' tipdam='9' destroy='0'/>
					<phis speed='55' deviation='20'/>
					<vis vweap='visbloodlight' tipdec='11' vbul='bloodlight' flare='laser' bulanim='1'/> 
					<snd shoot='lightning' noise='800'/>
				</weapon>
				<weapon id='aliblade' tip='0'>
					<char damage='24' rapid='10' prec='12' tipdam='1' destroy='0'/>
					<phis speed='70' deviation='6'/>
					<dop effect='cut' damage='5' ch='0.5'/>
					<vis vweap='visbloodlight' tipdec='1' vbul='blood'/> 
					<snd shoot='blade2' noise='400'/>
				</weapon>
				<weapon id='alipsy2' tip='0'>
					<char damage='15' rapid='30' prec='0' tipdam='8' destroy='0'/>
					<phis speed='35' deviation='7'/>
					<vis vweap='visbloodlight' vbul='bloodpsy' flare='laser'/> 
					<dop shoot='psy' effect='psy' ch='1'/>
					<snd/>
				</weapon>
				<weapon id='alimray' tip='0'>
					<char damage='12' pier='30' rapid='1' prec='0' prep='24' tipdam='16' destroy='10'/>
					<phis speed='2000' deviation='0' drot2='1'/>
					<vis vweap='visalimray' tipdec='12' vbul='laser7' spring='2' flare='laser'/> 
					<snd prep='mray' t1='2540' t2='3040' noise='400'/>
					<com price='2500' chance='0' stage='3'/>
				</weapon>
			<unit id='spectre' fraction='0'>
				<phis sX='80' sY='80' massa='110'/>
				<move speed='1' accel='0.5' brake='0.4'/>
				<comb hp='350' damage='1000' tipdam='16' ear='0' observ='200'/>
			</unit>
			<unit id='hellhound' fraction='4' cat='2'>
				<phis sX='70' sY='100' sitY='70' massa='250'/>
				<move speed='3' run='18' accel='3' brake='0.4' jump='18' levit_max='30' plav='0' levitaccel='1.2' damwall='100' porog='20'/>
				<vis noise='600' visdam='1'/>
				<snd music='combat_1'/>
				<param overlook='0' blood='1' hero='hellhound'/>
				<blit id='stay' y='0'/>
				<blit id='walk' y='0' len='25' rf='1' rep='1'/>
				<blit id='sit' y='1'/>
				<blit id='polz' y='1' len='25' rf='1' rep='1'/>
				<blit id='run' y='2' len='12' rep='1'/>
				<blit id='jump' y='3' len='16' stab='1'/>
				<blit id='die' y='4' len='20'/>
				<blit id='death' y='5'/>
				<blit id='fall' y='5' len='13'/>
				<blit id='laz' y='6' len='12' rep='1'/>
			</unit>
			<unit id='hellhound1' xp='500' cat='3' parent='hellhound'>
				<comb hp='300' damage='100' tipdam='14'/>
				<vis blit='sprHellhound' sprX='200' sprY='170' sprDX='100' sprDY='160'/>
			</unit>
				
			<!-- зомби -->
			<unit id='zombie' fraction='1' cat='2'>
				<move brake='0.3' levit_max='90' plav='0' levitaccel='1.2' damwall='25'/>
				<vis noise='600' visdam='1'/>
				<snd music='combat_1' die='zw'/>
				<param overlook='0' blood='2' zombie='1' hero='zombie'/>
				<n>Общие параметры зомби</n>
				<blit id='stay'/>
				<blit id='trot' y='1' len='17' rf='1' rep='1'/>
				<blit id='run' y='2' len='8' rep='1'/>
				<blit id='jump' y='3' len='16' stab='1'/>
				<blit id='die' y='4' len='20'/>
				<blit id='death' y='5'/>
				<blit id='fall' y='5' len='13'/>
				<blit id='dig' y='6' len='24'/>
				<blit id='walk' y='7' len='24' rep='1'/>
			</unit>
			<unit id='zombie0' cont='zombie' xp='100' cat='3' parent='zombie'>
				<phis sX='55' sY='70' massa='40'/>
				<move speed='1.5' run='10' jump='18' accel='2' damwall='25'/>
				<comb hp='50' damage='14'/>
				<vulner venom='0' poison='0' bleed='0.5' acid='0.25'/>
				<vis blit='sprZombie0' sprX='120' sex='w'/>
				<n>Дикий гуль</n>
			</unit>
			<unit id='zombie1' cont='zombie' xp='150' cat='3' parent='zombie'>
				<un ss='1'/>
				<phis sX='55' sY='70' massa='40'/>
				<move speed='2' run='13' jump='18' accel='3' damwall='35'/>
				<comb hp='80' damage='15'/>
				<vulner bul='0.75' venom='0' poison='0' bleed='0.5' acid='0.25'/>
				<vis blit='sprZombie1' sprX='120' sex='w'/>
				<blit id='pre' y='8' len='24'/>
				<n>Прыгун</n>
			</unit>
			<unit id='zombie2' cont='zombie' xp='150' cat='3' parent='zombie'>
				<un ss='2'/>
				<phis sX='55' sY='70' massa='55'/>
				<move speed='1.5' run='12' jump='18' accel='2' damwall='35'/>
				<comb hp='80' damage='18'/>
				<vulner bul='0.75' venom='0' poison='0' bleed='0.5' acid='0.25'/>
				<vis blit='sprZombie2' sprX='120' sex='w'/>
				<blit id='super' y='8' len='4' rep='1'/>
				<n>Телекинетик</n>
			</unit>
			<unit id='zombie3' cont='zombie' xp='150' cat='3' parent='zombie'>
				<un ss='3'/>
				<phis sX='55' sY='70' massa='65'/>
				<move speed='1.5' run='10' jump='18' accel='2' damwall='35'/>
				<comb hp='85' damage='15'/>
				<vulner bul='0.75' venom='0' poison='0' bleed='0.5' acid='0.25'/>
				<vis blit='sprZombie3' sprX='120' sex='w' visdam='3' sdamage='15' stipdam='7'/>
				<blit id='pre' y='8' len='18'/>
				<n>Ядовитый</n>
			</unit>
				<weapon id='zombivenom' tip='0'>
					<char damexpl='15' damage='0' expltip='2' explkol='12' rapid='90' prec='0' destroy='0' crit='0' tipdam='7' expl='200'/>
					<phis speed='15' deviation='3'/>
					<vis vbul='venom'/> 
				</weapon>
			<unit id='zombie4' xp='300' cat='3' parent='zombie'>
				<un glow='1' ss='5'/>
				<phis sX='60' sY='75' massa='75'/>
				<move speed='1.5' run='12' jump='18' accel='2' damwall='40'/>
				<comb hp='100' damage='20' raddamage='6'/>
				<vulner bul='0.75' laser='0.5' venom='0' poison='0' bleed='0.5' acid='0.25'/>
				<snd die='zm'/>
				<vis blit='sprZombie4' sprX='130'/>
				<n>Светящийся гуль</n>
			</unit>
			<unit id='zombie5' xp='450' cat='3' parent='zombie'>
				<un ss='6'/>
				<phis sX='60' sY='75' massa='200'/>
				<move speed='1.6' run='11' jump='16' accel='1' damwall='55'/>
				<comb hp='140' damage='25' armor='12' aqual='0.4' observ='3'/>
				<vulner fire='0.5' bul='0.75' venom='0' poison='0' bleed='0.5' acid='0.25' pink='0'/>
				<snd die='zm'/>
				<vis blit='sprZombie5' sprX='130'/>
				<blit id='super' y='1' len='17' rf='1' df='2' rep='1'/>
				<n>Гуль-солдат</n>
			</unit>
			<unit id='zombie6' xp='600' cat='3' parent='zombie'>
				<un ss='4'/>
				<phis sX='55' sY='70' massa='65'/>
				<move speed='2' run='14' jump='18' accel='3' damwall='55' levit_max='45'/>
				<comb hp='180' damage='30' skin='3' observ='6'/>
				<vulner acid='0' bul='0.75' venom='0' poison='0' bleed='0.5' pink='0'/>
				<vis blit='sprZombie6' sprX='120' sex='w' visdam='3' sdamage='20' stipdam='10'/>
				<blit id='pre' y='8' len='18'/>
				<n>Потрошитель</n>
			</unit>
				<weapon id='zombiacid' tip='0'>
					<char damexpl='20' damage='0' expltip='3' explkol='12' rapid='90' prec='0' destroy='50' crit='0' tipdam='10' expl='200'/>
					<phis speed='45' deviation='6'/>
					<dop effect='acid' damage='3' ch='1'/>
					<vis vbul='venom'/> 
				</weapon>
			<unit id='zombie7' xp='450' cat='3' parent='zombie'>
				<un ss='7' res='1'/>
				<phis sX='55' sY='70' massa='55'/>
				<move speed='1.5' run='12' jump='18' accel='2' damwall='50' levit_max='45'/>
				<comb hp='150' damage='30' tipdam='16'/>
				<param blood='3'/>
				<vulner bul='0.5' venom='0' poison='0' pink='0' bleed='0.5' acid='0.25'/>
				<vis blit='sprZombie7' sprX='120' sex='w' visdam='3' sdamage='15' stipdam='16'/>
				<blit id='super' y='8' len='4' rep='1'/>
			</unit>
				<weapon id='zombinecro' tip='0'>
					<char damage='15' kol='5' rapid='60' prec='6' tipdam='16' knock='0' destroy='0'/>
					<phis speed='70' deviation='6'/>
					<vis vbul='necro' flare=''/> 
					<snd shoot='telebul' noise='300'/>
				</weapon>
			<unit id='zombie8' xp='650' cat='3' parent='zombie'>
				<un ss='8' res='1'/>
				<phis sX='60' sY='75' massa='95'/>
				<move speed='1.5' run='12' jump='18' accel='2' damwall='80'/>
				<comb hp='200' damage='35'/>
				<snd die='zm'/>
				<param blood='3'/>
				<vulner bul='0.5' venom='0' poison='0' pink='0' bleed='0.5' acid='0.25'/>
				<vis blit='sprZombie8' sprX='130' visdam='3' sdamage='25' stipdam='19'/>
			</unit>
				<weapon id='zombipink' tip='0'>
					<char damexpl='25' damage='0' expltip='2' explkol='12' rapid='90' prec='0' destroy='0' crit='0' tipdam='19' expl='200'/>
					<phis speed='15' deviation='3'/>
					<vis vbul='pink'/> 
				</weapon>
			<unit id='zombie9' xp='1000' cat='3' parent='zombie'>
				<un ss='9' res='1'/>
				<phis sX='55' sY='70' massa='55'/>
				<move speed='1.5' run='16' jump='18' accel='2' damwall='65' levit_max='45'/>
				<comb hp='250' damage='50' observ='6'/>
				<param blood='3'/>
				<vulner bul='0.5' venom='0' poison='0' pink='0' bleed='0.5' acid='0.25'/>
				<vis blit='sprZombie9' sprX='130' sex='w'/>
				<blit id='pre' y='8' len='24'/>
			</unit>
			
			<!-- монстры -->
			<unit id='bloat' fraction='1' cat='2'>
				<phis sX='30' sY='30' massa='10'/>
				<move speed='5' accel='2' brake='0.3' levit_max='90'/>
				<comb hp='12' damage='8' tipdam='14' vision='0.8'/>
				<param blood='2' trup='0' acttrap='1' insect='1'/>
				<vis visdam='1'/>
				<snd die='bloat'/>
				<n>Блотспрайт</n>
			</unit>
			<unit id='bloat0' xp='20' cat='3' parent='bloat'>
				<phis sX='25' sY='25' massa='6'/>
				<move speed='6' accel='2' brake='0.3'/>
				<comb hp='8' dexter='1.3' damage='4' tipdam='14'/>
				<vulner bul='0.5' fire='1.25' laser='1.25' plasma='1.25' cryo='1.25'/>
				<vis vclass='visualBloat0'/>
				<un attch='0.6' attr='600'/>
				<n>Блотспрайт</n>
			</unit>
			<unit id='bloat1' xp='40' cat='3' parent='bloat'>
				<phis/>
				<move speed='5' accel='2' brake='0.3'/>
				<param hero='bloat'/>
				<vulner bul='0.25' fire='1.25' laser='1.25' plasma='1.25' cryo='1.25' acid='0'/>
				<comb hp='12' dexter='1.3' damage='3' tipdam='14'/>
				<vis vclass='visualBloat1' visdam='3' sdamage='5' stipdam='10'/>
				<w id='bloat' no='1'/>
			</unit>
				<weapon id='bloat' tip='0'>
					<char damage='5' rapid='60' prec='6' tipdam='10' knock='2' destroy='10'/>
					<phis speed='25' deviation='10'/>
					<vis vbul='plevok'/>
				</weapon>
			<unit id='bloat2' xp='40' cat='3' parent='bloat'>
				<phis/>
				<move speed='5' accel='2' brake='0.3'/>
				<comb hp='14' dexter='1.3' damage='3' tipdam='14'/>
				<param hero='bloat'/>
				<vulner bul='0.25' fire='1.25' laser='1.25' plasma='1.25' cryo='1.25' venom='0' poison='0'/>
				<vis vclass='visualBloat2' visdam='3' sdamage='3' stipdam='14'/>
				<w id='ship' no='1'/>
				<n>Блотспрайт</n>
			</unit>
				<weapon id='ship' tip='0'>
					<char damage='3' rapid='80' prec='8' tipdam='14' knock='2' destroy='0'/>
					<phis speed='30' deviation='8'/>
					<vis vbul='ship' flare=''/>
					<dop effect='poison' damage='1' ch='1'/>
				</weapon>
				
			<unit id='bloat3' xp='60' cat='3' parent='bloat'>
				<phis sX='40' sY='40' massa='15'/>
				<move speed='4' accel='1.2' brake='0.3'/>
				<comb hp='24' damage='9' tipdam='14' skin='5'/>
				<param hero='bloat'/>
				<vis vclass='visualBloat3'/>
				<vulner bul='0.25' fire='0.75' laser='0.75' plasma='0.75' cryo='0.75' phis='0.75' blade='0.75'/>
				<un bulb='1'/>
				<n>Толстый Блотспрайт</n>
			</unit>
			<unit id='bloat4' xp='60' cat='3' parent='bloat'>
				<phis/>
				<move speed='7' run='18' accel='2.5' brake='0.3'/>
				<comb hp='16' dexter='1.2' damage='9' tipdam='14' skin='3'/>
				<param hero='bloat'/>
				<vis vclass='visualBloat4'/>
				<vulner bul='0.5'/>
				<un attch='0.8' attr='700'/>
				<n>Зубастый Блотспрайт</n>
			</unit>
			<unit id='bloat5' xp='120' cat='3' parent='bloat'>
				<phis/>
				<move speed='5' accel='2' brake='0.3'/>
				<param hero='bloat' blood='3'/>
				<vulner bul='0.25' pink='0' fire='1.25' laser='1.25' plasma='1.25' cryo='1.25' acid='0'/>
				<comb hp='30' dexter='1.3' damage='15' tipdam='14'/>
				<vis vclass='visualBloat5' visdam='3' sdamage='15' stipdam='19'/>
				<w id='pinkbloat' no='1'/>
			</unit>
				<weapon id='pinkbloat' tip='0'>
					<char damage='15' rapid='60' prec='6' tipdam='19' knock='2' destroy='10'/>
					<phis speed='25' deviation='10'/>
					<vis vbul='pinkplevok' flare=''/>
				</weapon>
			<unit id='bloat6' xp='180' cat='3' parent='bloat'>
				<phis/>
				<move speed='8' run='20' accel='2.5' brake='0.3'/>
				<comb hp='36' dexter='1.3' damage='20' tipdam='14' skin='6'/>
				<param hero='bloat' blood='3'/>
				<vis vclass='visualBloat6'/>
				<vulner bul='0.25' pink='0'/>
				<un attch='1' attr='700' gryz='1'/>
			</unit>
			<unit id='bloat7' xp='50'>
				<phis massa='10' sX='30' sY='30'/>
				<move speed='7' run='18' accel='2.5' brake='0.3'/>
				<comb hp='25' dexter='1.2' damage='9' tipdam='14'/>
				<vulner bul='0.75' acid='0' venom='0' poison='0'/>
				<un attch='0.8' attr='700'/>
				<snd music='boss_2'/>
			</unit>
			<unit id='bloat8' xp='100'>
				<phis massa='20' sX='35' sY='35'/>
				<move speed='7' run='15' accel='2.5' brake='0.3'/>
				<comb hp='75' damage='10' tipdam='14' skin='2'/>
				<vulner bul='0.75' acid='0' venom='0'/>
				<w id='bloat'/>
				<un chootch='0.05'/>
				<snd music='boss_2'/>
			</unit>
			<unit id='bloat9' xp='300'>
				<phis massa='50' sX='40' sY='40'/>
				<move speed='7' run='12' accel='2.5' brake='0.3'/>
				<comb hp='200' damage='12' tipdam='14' skin='4'/>
				<vulner bul='0.75' acid='0' venom='0' poison='0'/>
				<w id='zombivenom'/>
				<un chootch='0.02'/>
				<snd music='boss_2'/>
			</unit>
			<unit id='bloat10' xp='1000' cat='3' parent='bloat'>
				<phis massa='100' sX='50' sY='50'/>
				<move speed='7' run='12' accel='2.5' brake='0.3'/>
				<comb hp='500' damage='18' tipdam='14' skin='6'/>
				<vulner bul='0.75' acid='0' venom='0' poison='0'/>
				<vis vclass='visualBloat10' dkill='0'/>
				<w id='zombiacid' no='1'/>
				<un chootch='0.02'/>
				<snd music='boss_2'/>
			</unit>
				
			<unit id='ebloat' fraction='1' xp='1000' cat='3'>
				<phis sX='80' sY='120' massa='500'/>
				<move fixed='1' levit='0'/>
				<comb hp='300' dexter='0.5' damage='30' tipdam='10' skin='3'/>
				<param blood='2' trup='0' acttrap='1' retdam='1'/>
				<snd die='nest'/>
				<vis vclass='visualBloatEmitter' visdam='1' dkill='1'/>
				<vulner bul='0.5'/>
				<n>гнездо</n>
			</unit>
			
			<unit id='other' cat='2'/>
			<unit id='bloodwing' fraction='1' xp='100' cat='3'>
				<phis sX='38' sY='38' massa='25'/>
				<move speed='5' accel='2' brake='0.3' float='-0.3' damwall='15' levit_max='45'/>
				<comb hp='40' dexter='1.2' damage='10' tipdam='14'/>
				<vulner fire='1.25'/>
				<param blood='1' monster='1' hero='bloodwing' acttrap='1'/>
				<snd die='bat'/>
				<vis vclass='visualBloodwing' visdam='1'/>
				<n>Кровокрыл</n>
			</unit>
			<unit id='bloodwing2' fraction='1' xp='400' cat='3'>
				<phis sX='38' sY='38' massa='45'/>
				<move speed='5' accel='2' brake='0.3' float='-0.3' damwall='35' levit_max='45'/>
				<comb hp='120' dexter='1.2' damage='20' tipdam='14'/>
				<vulner fire='1.25'/>
				<param blood='3' monster='1' hero='bloodwing' acttrap='1'/>
				<snd die='bat'/>
				<vis vclass='visualBloodwing2' visdam='1'/>
				<n>Кровокрыл</n>
			</unit>
			<unit id='fish1' fraction='1' xp='50' cat='3'>
				<phis sX='32' sY='32' massa='10'/>
				<move speed='3.2' accel='2' brake='0.3' float='0' jump='15' levit_max='45'/>
				<comb hp='20' dexter='1.2' damage='7' tipdam='14' damwall='15'/>
				<snd die='bloat'/>
				<param blood='1' monster='1' hero='fish'/>
				<vis vclass='visualFish1' visdam='1'/>
				<n>Рыба</n>
			</unit>
			<unit id='fish2' fraction='1' xp='100' cat='3'>
				<phis sX='38' sY='38' massa='25'/>
				<move speed='2.6' accel='1.8' brake='0.3' float='0' jump='15' damwall='15'/>
				<comb hp='35' dexter='1.2' damage='10' tipdam='14'/>
				<snd die='bloat'/>
				<param blood='1' monster='1' hero='fish'/>
				<vis vclass='visualFish2' visdam='1'/>
				<n>Рыба</n>
			</unit>
			<unit id='fish3' fraction='1' xp='300' cat='3'>
				<phis sX='38' sY='38' massa='25'/>
				<move speed='3.6' accel='2' brake='0.5' float='0' jump='15' damwall='25'/>
				<comb hp='100' dexter='1.2' damage='20' tipdam='14'/>
				<snd die='bloat'/>
				<param monster='1' hero='fish'/>
				<vulner pink='0'/>
				<vis vclass='visualFish3' visdam='1'/>
			</unit>
			<unit id='tarakan' fraction='1' xp='10' cat='3'>
				<phis sX='30' sY='15' massa='5'/>
				<move speed='1.2' run='4' accel='0.5' jump='5' brake='1' porog='0' levitaccel='0.5' levit_max='60' damwall='4'/>
				<comb hp='8' damage='4' tipdam='14'/>
				<param blood='2' trup='0' acttrap='1' overlook='0' insect='1'/>
				<vis blit='sprTarakan' sprX='60' sprY='30' sprDX='27' sprDY='27' visdam='1'/>
				<snd die='bloat'/>
				<n>Радтаракан</n>
				<blit id='stay'/>
				<blit id='walk' len='8' rep='1'/>
				<blit id='run' len='8' rep='1'/>
				<blit id='jump' len='8' rep='1'/>
				<blit id='plav' len='8' rep='1'/>
			</unit>
			<unit id='rat' fraction='1' xp='20' cat='3'>
				<phis sX='40' sY='15' massa='6'/>
				<move speed='2.5' run='6' accel='1' jump='8' brake='1' levitaccel='1.5' levit_max='50' porog='10' damwall='5'/>
				<comb hp='15' damage='6' tipdam='14'/>
				<param blood='1' trup='0' acttrap='1' overlook='0' hero='rat'/>
				<vis blit='sprRat' sprX='70' sprY='30' sprDX='43' sprDY='27' visdam='1'/>
				<snd die='rat'/>
				<n>Крыса</n>
				<blit id='stay'/>
				<blit id='walk' len='9' ff='1' rf='2' df='0.5' rep='1'/>
				<blit id='run' len='9' ff='1' rf='2' rep='1'/>
				<blit id='jump' ff='10'/>
				<blit id='plav' len='9' ff='1' rf='2' df='0.25' rep='1'/>
			</unit>
			<unit id='molerat' fraction='1' xp='60' cat='3'>
				<phis sX='55' sY='40' massa='45'/>
				<move speed='2' run='8' accel='1' jump='14' brake='0.5' levitaccel='0.9' levit_max='50' porog='10' damwall='12'/>
				<comb hp='34' damage='10' tipdam='14'/>
				<param blood='1' acttrap='1' overlook='0' monster='1' hero='rat'/>
				<vulner cryo='0.5'/>
				<vis blit='sprMolerat' sprX='85' sprY='58' sprDX='46' sprDY='49' visdam='1'/>
				<snd die='molerat'/>
				<n>Кротокрыс</n>
				<blit id='stay'/>
				<blit id='walk' len='13' ff='1' rf='2' df='0.5' rep='1'/>
				<blit id='run' len='13' ff='1' rf='2' rep='1'/>
				<blit id='jump' y='1' len='10' df='0.4'/>
				<blit id='plav' y='2' len='8' df='0.5' rep='1'/>
				<blit id='die' y='3' len='10'/>
				<blit id='death' y='3' ff='9'/>
			</unit>
			<unit id='scorp1' fraction='1' cont='scorp' xp='100' cat='3'>
				<phis sX='55' sY='39' massa='35'/>
				<move speed='1.5' run='5' accel='0.6' jump='10' brake='1' levitaccel='0.7' levit_max='120' porog='10' damwall='8'/>
				<comb hp='40' damage='7' skin='5' tipdam='14'/>
				<vulner phis='0.75' blade='0.5' venom='0.5' acid='0.5' laser='0.5'/>
				<param blood='2' acttrap='1' overlook='0' insect='1' hero='scorp'/>
				<vis blit='sprScorp1' sprX='85' sprY='58' sprDX='38' sprDY='56' visdam='1'/>
				<snd die='scorp'/>
				<n>Радскорпион</n>
				<blit id='stay'/>
				<blit id='attack' len='15' ff='1'/>
				<blit id='walk' y='1' len='18' rep='1' df='0.5'/>
				<blit id='run' y='1' len='18' rep='1'/>
				<blit id='plav' y='1' len='18' rep='1'/>
				<blit id='jump' y='1' len='18' rep='1'/>
				<blit id='die' y='2' len='20'/>
				<blit id='death' y='2' ff='19'/>
			</unit>
				<weapon id='scorppunch' punch='1' tip='0'>
					<char damage='12' rapid='15' tipdam='14' knock='16'/>
					<phis speed='9' deviation='0'/>
					<dop effect='poison' damage='2' ch='1'/>
					<vis tipdec='3'/>
				</weapon>
			<unit id='scorp2' fraction='1' cont='scorp' xp='100' cat='3'>
				<phis sX='55' sY='39' massa='35'/>
				<move speed='1.5' run='8' accel='0.8' jump='10' brake='1' levitaccel='1.2' levit_max='60' porog='10' damwall='12'/>
				<comb hp='60' damage='10' skin='2' tipdam='14'/>
				<vulner phis='0.75' blade='0.5' venom='0.5' acid='0.5' laser='0.5'/>
				<param blood='2' acttrap='1' overlook='0' insect='1' hero='scorp'/>
				<vis blit='sprScorp2' sprX='85' sprY='58' sprDX='38' sprDY='56' visdam='1'/>
				<snd die='scorp'/>
				<n>Радскорпион</n>
				<blit id='stay'/>
				<blit id='attack' len='15' ff='1'/>
				<blit id='walk' y='1' len='18' rep='1' df='0.5'/>
				<blit id='run' y='1' len='18' rep='1'/>
				<blit id='plav' y='1' len='18' rep='1'/>
				<blit id='jump' y='1' len='18' rep='1'/>
				<blit id='die' y='2' len='20'/>
				<blit id='death' y='2' ff='19'/>
			</unit>
				<weapon id='scorp2punch' punch='1' tip='0'>
					<char damage='18' rapid='15' tipdam='14' knock='16'/>
					<phis speed='9' deviation='0'/>
					<dop effect='cut' damage='3' ch='1'/>
					<vis tipdec='3'/>
				</weapon>
			<unit id='scorp3' fraction='1' cont='scorp' xp='300' cat='3'>
				<phis sX='70' sY='39' massa='65'/>
				<move speed='1.5' run='8' accel='0.8' jump='10' brake='1' levitaccel='1.2' levit_max='60' porog='10' damwall='32'/>
				<comb hp='120' damage='32' skin='10' tipdam='14'/>
				<vulner phis='0.75' blade='0.5' venom='0.5' acid='0.5' pink='0' laser='0.5'/>
				<param blood='3' acttrap='1' overlook='0' insect='1' hero='scorp'/>
				<vis blit='sprScorp3' sprX='106' sprY='76' sprDX='50' sprDY='67' visdam='1'/>
				<snd die='scorp'/>
				<n>Радскорпион</n>
				<blit id='stay'/>
				<blit id='attack' len='15' ff='1'/>
				<blit id='walk' y='1' len='18' rep='1' df='0.5'/>
				<blit id='run' y='1' len='18' rep='1'/>
				<blit id='plav' y='1' len='18' rep='1'/>
				<blit id='jump' y='1' len='18' rep='1'/>
				<blit id='die' y='2' len='20'/>
				<blit id='death' y='2' ff='19'/>
			</unit>
				<weapon id='scorp3punch' punch='1' tip='0'>
					<char damage='48' rapid='15' tipdam='14' knock='20'/>
					<phis speed='9' deviation='0'/>
					<dop effect='pink' damage='20' ch='1'/>
					<vis tipdec='3'/>
				</weapon>
			
			<unit id='ant' fraction='1'>
				<phis sX='40' sY='19' massa='7'/>
				<move speed='4' run='8' accel='1' jump='5' brake='1' porog='10' levitaccel='0.5' levit_max='60' damwall='4'/>
				<comb hp='16' damage='7' tipdam='14'/>
				<param blood='2' trup='0' acttrap='1' overlook='0' insect='1'/>
				<n>Муравей</n>
				<vis visdam='1'/>
				<snd die='bloat'/>
				<blit id='stay'/>
				<blit id='walk' len='14' rf='1' rep='1'/>
				<blit id='run' len='14' rf='1' rep='1'/>
				<blit id='jump' len='14' rf='1' rep='1'/>
				<blit id='plav' len='14' rf='1' rep='1'/>
			</unit>
			<unit id='ant1' xp='30' cat='3' parent='ant'>
				<phis massa='7'/>
				<comb hp='16' damage='7' dexter='1.1' skin='2'/>
				<vulner cryo='1.5'/>
				<vis blit='sprAnt1' sprX='78' sprY='32' sprDX='34' sprDY='30'/>
				<n>Муравей-рабочий</n>
			</unit>
			<unit id='ant2' xp='60' cat='3' parent='ant'>
				<phis massa='10'/>
				<comb hp='32' damage='14' skin='4'/>
				<vulner cryo='1.5'/>
				<param hero='ant'/>
				<vis blit='sprAnt2' sprX='78' sprY='32' sprDX='34' sprDY='30'/>
				<n>Муравей-солдат</n>
			</unit>
			<unit id='ant3' xp='80' cat='3' parent='ant'>
				<phis massa='10'/>
				<comb hp='32' damage='7' skin='2'/>
				<vulner cryo='1.5' fire='0.25'/>
				<param hero='ant'/>
				<vis blit='sprAnt3' sprX='78' sprY='32' sprDX='34' sprDY='30' visdam='3' sdamage='2' stipdam='3'/>
				<n>Огненный муравей</n>
			</unit>
				<weapon id='antfire' tip='0'>
					<char damage='2' rapid='2' prec='4' crit='0' tipdam='3' knock='0' destroy='3'/>
					<phis speed='10' deviation='6' flame='2'/>
					<vis tipdec='11' vbul='arson' bulanim='1'/> 
					<snd prep='arson_s' t1='990' t2='2270'/>
					<dop effect='igni' damage='2' ch='0.1'/>
				</weapon>
			<unit id='eant' fraction='1' xp='1000' cat='3'>
				<phis sX='80' sY='80' massa='500'/>
				<move fixed='1' levit='0'/>
				<comb hp='300' dexter='0.5' damage='30' tipdam='10' skin='10'/>
				<param trup='0' acttrap='1'/>
				<vis vclass='visualAntEmitter' visdam='1' dkill='0'/>
				<snd die='nest'/>
				<vulner phis='0.5' blade='0.5' expl='3'/>
				<n>муравейник</n>
			</unit>
			<unit id='slime' fraction='1' xp='50' cat='3'>
				<phis sX='40' sY='30' massa='15'/>
				<move speed='1.5' accel='0.4' knocked='0' levit_max='35' float='-0.5'/>
				<comb hp='60' damage='6' tipdam='10'/>
				<snd die='slime'/>
				<w id='slime' no='1'/>
				<vis vclass='visualSlime' noise='0' visdam='1'/>
				<vulner bul='0.05' blade='0.25' bleed='0' phis='0.25' acid='0' venom='0' poison='0' expl='0.7' laser='0.7' spark='0.5'/>
				<param blood='2' trup='0' acttrap='1' retdam='1'/>
				<n>Ужасная слизь</n>
			</unit>
				<weapon id='slime' tip='0'>
					<char damage='5' rapid='10' prec='0' tipdam='10' knock='0' destroy='0'/>
					<phis speed='1' grav='1' deviation='10'/>
					<vis vbul='kapl' flare='plevok' phisbul='1'/>
					<snd noise='0'/>
				</weapon>
			<unit id='cryoslime' fraction='1' xp='150' cat='3'>
				<phis sX='40' sY='30' massa='15'/>
				<move speed='1.3' accel='0.4' knocked='0' levit_max='35' float='-0.5'/>
				<comb hp='120' damage='12' tipdam='11'/>
				<snd die='slime'/>
				<w id='slime' no='1'/>
				<vis vclass='visualCryoSlime' noise='0' visdam='1' dkill='2'/>
				<vulner bul='0.05' blade='0.25' bleed='0' phis='0.25' cryo='0' venom='0' poison='0' expl='0.7' laser='0.7' spark='0.5'/>
				<param blood='2' trup='0' acttrap='1' retdam='1'/>
				<n>Ужасная слизь</n>
			</unit>
			<unit id='pinkslime' fraction='1' xp='250' cat='3'>
				<phis sX='40' sY='30' massa='15'/>
				<move speed='1.7' accel='0.4' knocked='0' levit_max='35' float='-0.5'/>
				<comb hp='200' damage='20' tipdam='19'/>
				<snd die='slime'/>
				<w id='pinkslime' no='1'/>
				<vis vclass='visualPinkSlime' noise='0' visdam='1'/>
				<vulner bul='0.05' blade='0.25' bleed='0' phis='0.25' pink='0' venom='0' poison='0' expl='0.7' laser='0.7' spark='0.5'/>
				<param blood='3' trup='0' acttrap='1' retdam='1'/>
				<n>Ужасная слизь</n>
			</unit>
				<weapon id='pinkslime' tip='0'>
					<char damage='25' rapid='10' prec='0' tipdam='19' knock='0' destroy='0'/>
					<phis speed='1' grav='1' deviation='10'/>
					<vis vbul='pinkkapl' flare='pinkplevok' phisbul='1'/>
					<snd noise='0'/>
				</weapon>
			<unit id='necros' fraction='1' xp='850' cat='3'>
				<phis sX='60' sY='60' massa='15'/>
				<move speed='4' accel='0.5' knocked='0' levit_max='45'/>
				<comb hp='400' dexter='2' damage='80' tipdam='16'/>
				<vis blit='sprNecros' sprX='160' sprY='160' sprDX='80' sprDY='120' visdam='1'/>
				<vulner bul='0' blade='0' bleed='0' phis='0' pink='0' venom='0' poison='0' laser='0.7' expl='0.7' spark='0.5' cryo='0.2'/>
				<param trup='0' acttrap='1' retdam='1'/>
				<blit id='stay' len='24' rep='0'/>
			</unit>
			<unit id='phoenix' fraction='1' cat='3'>
				<phis sX='38' sY='38' massa='6'/>
				<move speed='5' run='15' jump='12' accel='1.5' float='-0.5'/>
				<comb hp='10'/>
				<vulner fire='0.5' plasma='0.5' laser='0.75' expl='0.25'/>
				<vis blit='sprPhoenix' sprX='121' sprY='121' sprDX='76' sprDY='72'/>
				<blit id='stay'/>
				<blit id='fly' len='10' ff='1' rf='2' rep='1'/>
				<w id='phoenix' no='1'/>
			</unit>
				<weapon id='phoenix' tip='0'>
					<char damage='2' rapid='2' prec='8' crit='0' tipdam='3' destroy='10' prep='10' pier='5'/>
					<phis speed='40' deviation='8' flame='2' drot2='5'/>
					<vis tipdec='11' vbul='dflame' flare='flame' bulanim='1'/> 
					<snd prep='arson_s' t1='990' t2='2270' noise='300'/>
					<ammo holder='30' reload='60'/>
				</weapon>
			<unit id='moon' fraction='1' cat='3'>
				<phis sX='38' sY='38' massa='6'/>
				<move speed='7' run='15' accel='1.5'/>
				<comb hp='10' damage='1' tipdam='1'/>
				<vulner necr='0.5' pink='0.5' cryo='0.5' venom='0' poison='0' bleed='0'/>
				<param acttrap='0' mech='1'/>
				<vis vclass='visualMoon'/>
			</unit>
				
			
			
			<unit id='robot' cat='1'/>
			<!-- роботы -->
			<unit id='bigrobot' cat='2'/>
			<unit id='robobrain' fraction='4' xp='150' cat='3'>
				<phis sX='55' sY='70' massa='85'/>
				<move speed='2' accel='2' jump='0' brake='1' plav='0' levitaccel='1.2' damwall='30' levit_max='90'/>
				<comb hp='60' armor='5' krep='1' aqual='0.75' armorhp='120'/>
				<vulner emp='1' fire='0.5' cryo='0.5' spark='1.5' venom='0' poison='0' bleed='0'/>
				<param overlook='0' robot='1' hero='robot'/>
				<vis noise='500' replic='robobrain' vclass='visualRobobrain' visdam='1'/>
				<snd music='combat_1' die='expl2'/>
				<n>Робомозг</n>
				<w id='robolaser' ch='0.5'/>
				<w id='robospark'/>
			</unit>
				<weapon id='robolaser' tip='0'>
					<char damage='7' rapid='30' prec='10' tipdam='5' knock='0' destroy='30'/>
					<phis speed='2000' deviation='5'/>
					<vis tipdec='13' vweap='visrobolaser' vbul='laser2' spring='2'/> 
					<snd shoot='las_s' noise='400'/>
				</weapon>
				<weapon id='robospark' tip='0'>
					<char damage='12' rapid='40' prec='0' tipdam='9' knock='0' destroy='0'/>
					<phis speed='30' deviation='5'/>
					<vis tipdec='11' vweap='visrobospark' vbul='spark' bulanim='1'/> 
					<snd shoot='spark_s' noise='400'/>
				</weapon>
			<unit id='protect' fraction='4' xp='250' cat='3'>
				<phis sX='60' sY='70' massa='160'/>
				<move speed='2' accel='1' jump='6' brake='1' plav='0' levitaccel='1.1' damwall='40' levit_max='60'/>
				<comb hp='100' armor='10' marmor='5' krep='1' aqual='0.8' armorhp='250' observ='3'/>
				<vulner emp='1' fire='0.5' cryo='0.5' spark='1.25' expl='0.7' blade='0.5' venom='0' poison='0' bleed='0'/>
				<param overlook='0' robot='1' hero='robot'/>
				<vis blit='sprProtect' noise='500' sprX='130' replic='protect'/>
				<snd music='combat_1' die='expl1'/>
				<n>Протектопон</n>
				<blit id='stay' len='1' rep='0'/>
				<blit id='trot' y='1' len='17' rf='1' rep='1'/>
				<blit id='walk' y='4' len='24' rep='1'/>
				<blit id='jump' y='5' len='1'/>
				<blit id='fly' y='5' len='16' rf='8' rep='1'/>
				<blit id='die' y='2' len='16'/>
				<blit id='death' y='3'/>
				<blit id='fall' y='3' len='11'/>
				<w id='roboplasma' ch='0.3' dif='10'/>
				<w id='robolaser2' ch='0.5'/>
				<w id='robospark2'/>
			</unit>
				<weapon id='robolaser2' tip='0'>
					<char damage='11' rapid='30' prec='10' tipdam='5' knock='0' destroy='30' noise='400'/>
					<phis speed='2000' deviation='5'/>
					<dop effect='blind' ch='0.05'/>
					<vis tipdec='13' vweap='visrobolaser' vbul='laser' spring='2'/> 
					<snd shoot='las_s'/>
				</weapon>
				<weapon id='robospark2' tip='0'>
					<char damage='16' rapid='40' prec='0' tipdam='9' knock='0' destroy='0' noise='400'/>
					<phis speed='30' deviation='5'/>
					<vis tipdec='11' vweap='visrobospark' vbul='spark' bulanim='1'/> 
					<snd shoot='spark_s'/>
				</weapon>
			<unit id='gutsy' fraction='4' xp='450' cat='3'>
				<phis sX='60' sY='75' massa='105'/>
				<move speed='4' accel='1' jump='10' brake='1' plav='0' float='-0.3' levitaccel='1.6' damwall='50' levit_max='30'/>
				<comb hp='140' armor='12' marmor='10' krep='1' aqual='0.85' armorhp='350' damage='18' tipdam='1' observ='5'/>
				<vulner emp='1' fire='0.5' cryo='0.5' spark='1.25' expl='0.7' laser='0.7' blade='0.5' venom='0' poison='0' bleed='0'/>
				<param robot='1' hero='gutsy'/>
				<vis blit='sprGutsy' noise='500' sprX='130' replic='gutsy' visdam='1'/>
				<snd music='combat_1' die='expl1'/>
				<n>Храбрец</n>
				<blit id='stay' len='40' rep='0'/>
				<blit id='die' y='1' len='20'/>
				<blit id='death' y='1' len='1'/>
				<w id='robofire' f='1'/>
				<w id='roboplasma2' ch='0.3' dif='18'/>
				<w id='roboplasma'/>
			</unit>
				<weapon id='roboplasma' tip='0'>
					<char damage='22' rapid='40' prec='10' tipdam='6' knock='10' destroy='100'/>
					<phis speed='40' deviation='8'/>
					<vis tipdec='15' vweap='visroboplasma' vbul='plasma1'/> 
					<snd shoot='plap_s' noise='400'/>
				</weapon>
				<weapon id='roboplasma2' tip='0'>
					<char damage='27' rapid='40' prec='10' tipdam='6' knock='10' destroy='100'/>
					<phis speed='50' deviation='8'/>
					<vis tipdec='17' vweap='visroboplasma' vbul='plasma5' flare='laser'/> 
					<snd shoot='plasma_s' noise='400'/>
				</weapon>
				<weapon id='robofire' tip='0'>
					<char damage='2.2' rapid='1' prec='5' crit='0' holder='100' reload='45' tipdam='3' knock='0' destroy='10'/>
					<phis speed='40' drot='5' deviation='6' flame='1'/>
					<vis tipdec='11' vbul='flame' bulanim='1'/> 
					<snd prep='flamer_s' t1='1540' t2='2840' noise='400'/>
					<ammo holder='90' reload='45'/>
					<dop effect='igni' damage='5' ch='0.002'/>
				</weapon>
			<unit id='eqd' fraction='4' xp='600' cat='3'>
				<phis sX='55' sY='70' massa='100'/>
				<move speed='5' accel='1.5' jump='18' brake='1' plav='0' levitaccel='1.5' damwall='50' levit_max='60'/>
				<comb hp='150' armor='6' marmor='15' krep='1' aqual='0.8' armorhp='400' observ='8'/>
				<vulner emp='1' fire='0.7' cryo='0.5' laser='0.7' plasma='0.7' acid='0.5' venom='0' poison='0' bleed='0'/>
				<param overlook='0' robot='1' hero='eqd'/>
				<vis blit='sprEqd1' noise='500' sprX='120' replic='eqd'/>
				<snd music='combat_1'/>
				<n>Эквидроид</n>
				<blit id='stay' len='1' rep='0'/>
				<blit id='trot' y='1' len='17' rf='1' rep='1'/>
				<blit id='walk' y='6' len='24' rep='1'/>
				<blit id='run' y='2' len='8' rep='1'/>
				<blit id='jump' y='3' len='16' stab='1'/>
				<blit id='die' y='4' len='20'/>
				<blit id='death' y='5'/>
				<blit id='fall' y='5' len='13'/>
				<w id='robonova' ch='0.3' dif='18'/>
				<w id='robosparkl' ch='0.5'/>
				<w id='roboplam'/>
			</unit>
				<weapon id='roboplam' tip='0'>
					<char damage='13' rapid='5' prec='8' tipdam='6' knock='3' holder='30' reload='45' destroy='80'/>
					<phis speed='60' drot='11' deviation='5'/>
					<vis tipdec='16' vbul='plasma2' vweap='visroboplam'/> 
					<snd shoot='caster_s' reload='laser_r' noise='500'/>
				</weapon>
				<weapon id='robosparkl' tip='0'>
					<char damage='10' rapid='3' dkol='3' prec='10' tipdam='5' knock='0' holder='60' reload='45' destroy='50'/>
					<phis speed='2000' drot='15' deviation='3'/>
					<dop effect='blind' ch='0.05'/>
					<vis tipdec='12' vbul='sparkl' spring='2' vweap='visrobosparkl'/> 
					<snd shoot='laser_s' reload='laser_r' noise='500'/>
				</weapon>
				<weapon id='robonova' tip='0'>
					<char damage='20' rapid='7' prec='10' tipdam='5' knock='0' holder='30' reload='45' destroy='50'/>
					<phis speed='2000' drot='15' deviation='3'/>
					<dop effect='blind' ch='0.1'/>
					<vis tipdec='12' vbul='laser5' spring='2' flare='laser' vweap='visrobonova'/> 
					<snd shoot='laser_s' reload='laser_r' noise='500'/>
				</weapon>
			<unit id='protect1' fraction='4' cont='protect' xp='500' cat='3'>
				<phis sX='60' sY='70' massa='240'/>
				<move speed='3' accel='1' jump='8' brake='1' plav='0' levitaccel='1.3' damwall='50' levit_max='60'/>
				<comb hp='120' armor='25' marmor='15' krep='1' aqual='0.9' armorhp='450' observ='3'/>
				<vulner emp='0.5' fire='0.5' cryo='0.5' expl='0.7' blade='0.5' venom='0' poison='0' bleed='0'/>
				<param overlook='0' robot='1' hero='robot'/>
				<vis blit='sprProtect1' noise='500' sprX='140' replic='protect'/>
				<snd music='combat_1' die='expl1'/>
				<n>aj-17</n>
				<blit id='stay' len='1' rep='0'/>
				<blit id='trot' y='1' len='17' rf='1' rep='1'/>
				<blit id='walk' y='4' len='24' rep='1'/>
				<blit id='jump' y='5' len='1'/>
				<blit id='fly' y='5' len='16' rf='8' rep='1'/>
				<blit id='die' y='2' len='16'/>
				<blit id='death' y='3'/>
				<blit id='fall' y='3' len='11'/>
				<w id='robonova' ch='0.3'/>
				<w id='robosparkl' ch='0.5'/>
				<w id='roboplam'/>
			</unit>
			<unit id='gutsy1' fraction='4' cont='gutsy' xp='750' cat='3'>
				<phis sX='60' sY='75' massa='125'/>
				<move speed='5' accel='2' jump='12' brake='1' plav='0' float='-0.3' levitaccel='1.6' damwall='60' levit_max='45'/>
				<comb hp='240' armor='16' marmor='16' krep='1' aqual='0.85' armorhp='350' damage='36' tipdam='1' observ='10'/>
				<vulner emp='1' fire='0.5' cryo='0.5' spark='1.25' expl='0.7' laser='0.7' blade='0.5' venom='0' poison='0' bleed='0'/>
				<param robot='1' hero='robot'/>
				<vis blit='sprGutsy1' noise='500' sprX='130' replic='gutsy'/>
				<snd music='combat_1' die='expl1'/>
				<n>Защитник</n>
				<blit id='stay' len='40' rep='0'/>
				<blit id='die' y='1' len='20'/>
				<blit id='death' y='1' len='1'/>
				<w id='roboplasma2'/>
			</unit>
				<weapon id='robofire2' tip='0'>
					<char damage='5' rapid='1' prec='5' crit='0' tipdam='3' knock='0' destroy='10'/>
					<phis speed='40' drot='5' deviation='6' flame='1'/>
					<vis tipdec='11' vbul='flame2' bulanim='1'/> 
					<snd prep='flamer_s' t1='1540' t2='2840' noise='400'/>
					<dop effect='igni' damage='10' ch='0.002'/>
					<ammo holder='90' reload='45'/>
				</weapon>
			<unit id='sentinel' fraction='4' xp='2000' cat='3'>
				<phis sX='110' sY='110' massa='400'/>
				<move speed='3' accel='1' jump='6' brake='1' plav='0' levitaccel='1.1' damwall='90' levit_max='90'/>
				<comb hp='360' armor='18' marmor='6' krep='1' aqual='0.8' damage='25' dexter='0.7' armorhp='750' observ='5'/>
				<vulner emp='0.75' fire='0.5' cryo='0.5' bul='0.85' blade='0.5' expl='0.5' venom='0' poison='0' bleed='0'/>
				<param overlook='0' robot='1' hero='sentinel'/>
				<vis noise='500' sprX='130' replic='sentinel' vclass='visualSentinel2' visdam='1'/>
				<snd music='combat_1' die='expl1'/>
				<n>Страж</n>
				<w id='robomlau' f='1'/>
				<w id='robogatl' ch='0.5'/>
				<w id='robominigun'/>
			</unit>
				<weapon id='robominigun' tip='0'>
					<char damage='8' rapid='2' prec='10' knock='1' holder='60' reload='50' prep='32' destroy='10'/>
					<phis speed='200' drot='12' deviation='5'/>
					<vis tipdec='1' shell='1' vweap='visrobominigun'/> 
					<snd prep='minigun_s' t1='1030' t2='3060' noise='1300'/>
				</weapon>
				<weapon id='robogatl' tip='0'>
					<char damage='12' rapid='3' prec='8' tipdam='5' knock='0' holder='60' reload='30' destroy='20'/>
					<phis speed='2000' drot='12' deviation='6'/>
					<dop effect='blind' ch='0.05'/>
					<vis tipdec='12' vbul='laser' spring='2' vweap='visrobogatl'/> 
					<snd shoot='laser_s' noise='500'/>
				</weapon>
				<weapon id='robomlau' tip='0'>
					<char damexpl='150' damage='50' rapid='150' prec='9' crit='0' tipdam='4' knock='20' destroy='150' expl='180'/>
					<phis speed='10' deviation='3' accel='0.7'/>
					<vis tipdec='9' vbul='rocket' bulanim='1' spring='0' phisbul='1'/> 
					<snd shoot='rocket_s' noise='800'/>
				</weapon>
			<unit id='bossultra' fraction='4' xp='5000' cat='3'>
				<phis sX='100' sY='100' massa='550'/>
				<move brake='0.3' speed='4.5' accel='2.5' levitaccel='1' levit_max='45'/>
				<comb hp='3600' skill='1.6' aqual='1' armor='10' marmor='10' armorhp='3000' damage='12' dexter='0.5'/>
				<vis noise='600' vclass='visualUltraSentinel2' replic='sentinel' visdam='1' dkill='0'/>
				<vulner emp='1' fire='0.5' cryo='0.5' venom='0' poison='0' bleed='0'/>
				<snd music='boss_4'/>
				<param trup='0' overlook='1' robot='1'/>
				<w id='robogatp' f='1'/>
				<w id='robomlau2' f='1'/>
				<w id='robogas' f='1'/>
				<w id='roboplagr' f='1'/>
			</unit>
				<weapon id='robogatp' tip='0'>
					<char damage='15' rapid='4' prec='10' tipdam='6' knock='5' holder='60' reload='30' destroy='50'/>
					<phis speed='80' deviation='6' drot='12'/>
					<vis tipdec='15' vbul='plasma3' flare='plasma' vweap='visrobogatp'/> 
					<snd prep='gatl_s' t1='100' t2='1500' reload='laser_r' noise='400'/>
				</weapon>
				<weapon id='robogatp2' tip='0'>
					<char damage='18' rapid='4' prec='10' tipdam='6' knock='5' holder='60' reload='30' destroy='100'/>
					<phis speed='80' deviation='6' drot='12'/>
					<vis tipdec='15' vbul='plasma3a' flare='plasma' vweap='visrobogatp2'/> 
					<snd prep='gatl_s' t1='100' t2='1500' reload='laser_r' noise='400'/>
				</weapon>
				<weapon id='robomlau2' tip='0'>
					<char damexpl='100' damage='50' rapid='12' prec='6' crit='0' tipdam='4' knock='20' destroy='400' expl='180'/>
					<phis speed='10' deviation='8' accel='0.7'/>
					<vis tipdec='9' vbul='rocket' bulanim='1' spring='0' phisbul='1'/> 
					<snd shoot='rocket_s' noise='800'/>
				</weapon>
				<weapon id='robogas' tip='0'>
					<char damexpl='20' damage='0' expltip='2' explkol='12' rapid='90' prec='0' destroy='0' crit='0' tipdam='7' expl='200'/>
					<phis speed='10' deviation='2' accel='1'/>
					<vis tipdec='9' vbul='rocketgas' bulanim='1' spring='0'/> 
					<snd shoot='rocket_s' noise='800'/>
				</weapon>
				<weapon id='roboplagr' tip='4'>
					<char rapid='15' damexpl='140' tipdam='6' knock='10' destroy='300' expl='200' time='75'/>
					<phis speed='20' deviation='18'/>
					<vis tipdec='19'/> 
					<snd fall='fall_grenade'/>
				</weapon>
			<unit id='bossdron' fraction='4' xp='5000' cat='3'>
				<phis sX='90' sY='90' massa='550'/>
				<move brake='0.3' speed='3.7' accel='2.5' levitaccel='1' levit_max='45'/>
				<comb hp='5000' skill='1.6' aqual='1' armor='10' marmor='10' armorhp='3000' damage='100' tipdam='9' dexter='0.5'/>
				<vis noise='600' vclass='visualMegaDron' replic='sentinel' visdam='1' dkill='0'/>
				<vulner emp='0.5' fire='0.5' cryo='0.5' venom='0' poison='0' bleed='0'/>
				<snd music='boss_3'/>
				<param trup='0' overlook='1' robot='1'/>
				<w id='dronmlau' f='1'/>
				<w id='drongr' f='1'/>
			</unit>
				<weapon id='dronmlau' tip='0'>
					<char damexpl='150' damage='50' rapid='150' prec='9' crit='0' tipdam='4' knock='20' destroy='150' expl='250'/>
					<phis speed='15' deviation='3' accel='0.7'/>
					<vis tipdec='9' vbul='rocket' bulanim='1' spring='0' phisbul='1'/> 
					<snd shoot='rocket_s' noise='800'/>
				</weapon>
				<weapon id='drongr' tip='4' throwtip='2'>
					<char rapid='10' damexpl='250' tipdam='6' knock='10' destroy='300' expl='200' time='60'/>
					<phis speed='30' deviation='45'/>
					<vis tipdec='19'/> 
					<snd fall='fall_grenade'/>
				</weapon>
			
			<!-- мелкие роботы -->
			<unit id='smallrobot' cat='2'/>
			<unit id='spritebot' fraction='4' xp='60' cat='3'>
				<phis sX='30' sY='40' massa='15'/>
				<move speed='8' brake='1' damwall='15' levit_max='90'/>
				<comb hp='30' armor='3' aqual='0.75' armorhp='60' dexter='1.2' vision='0.3' ear='0'/>
				<param trup='0' robot='1' acttrap='1'/>
				<vis vclass='visualSpriteBot'/>
				<snd die='expl2'/>
				<vulner emp='1' fire='0.75' cryo='0.5' spark='1.5' venom='0' poison='0' bleed='0'/>
				<n>Спрайтбот</n>
			</unit>
			<unit id='vortex' fraction='2' xp='30' cat='3'>
				<phis sX='30' sY='30' massa='6'/>
				<move speed='4' accel='1.5' brake='0.8' knocked='1' damwall='15' levit_max='90'/>
				<comb hp='15' armor='3' aqual='0.5' armorhp='60' dexter='1.5' damage='12' ear='0' tipdam='1' observ='5'/>
				<param trup='0' robot='1' acttrap='1' retdam='1'/>
				<vulner emp='1' spark='1.5' venom='0' poison='0' bleed='0'/>
				<vis vclass='visualVortex' visdam='1'/>
				<snd die='expl2' run='vortex'/>
				<n>Вертушка</n>
			</unit>
			<unit id='roller' fraction='4' xp='60' cat='3'>
				<phis sX='30' sY='30' massa='25'/>
				<move speed='11' accel='0.8' jump='19' brake='0.5' knocked='1.5' levitaccel='0'/>
				<comb hp='20' armor='20' marmor='20' aqual='1' armorhp='120' damage='18' ear='0' tipdam='9'/>
				<param trup='0' robot='1' acttrap='1' retdam='1'/>
				<vulner emp='1' fire='0.5' cryo='0.5' spark='0' laser='0.5' expl='3' venom='0' poison='0' bleed='0'/>
				<snd die='expl3'/>
				<vis vclass='visualRoller' visdam='1'/>
			</unit>
			<unit id='msp' fraction='4' xp='50' cat='3'>
				<phis sX='30' sY='30' massa='25'/>
				<move speed='11' accel='0.8' jump='16' brake='0.5' plav='0' damwall='15' levitaccel='0.8' levit_max='90'/>
				<comb hp='14' armor='5' aqual='1' armorhp='50' damage='60' tipdam='4'/>
				<param trup='0' robot='1' acttrap='1'/>
				<vulner emp='0.25' fire='0.5' cryo='0.5' expl='0.1' venom='0' poison='0' bleed='0'/>
				<vis vclass='visualMsp' visdam='1'/>
			</unit>
			<unit id='roller2' fraction='4' xp='240' cat='3'>
				<phis sX='35' sY='35' massa='45'/>
				<move speed='11' accel='1' jump='21' brake='0.5' knocked='1.2' levitaccel='1.5' levit_max='90'/>
				<comb hp='40' armor='20' marmor='20' aqual='1' armorhp='180' damage='30' ear='0' tipdam='9'/>
				<param trup='0' robot='1' acttrap='1' retdam='1'/>
				<vulner emp='1' fire='0.5' cryo='0.5' spark='0' laser='0.5' expl='1.5' venom='0' poison='0' bleed='0'/>
				<snd die='expl3'/>
				<vis vclass='visualRoller2' visdam='1'/>
			</unit>
			<unit id='dron1' fraction='4' xp='250' cat='3'>
				<phis sX='35' sY='38' massa='35'/>
				<move speed='4' accel='2' brake='1' damwall='35' levit_max='45'/>
				<comb hp='100' armor='15' aqual='0.85' armorhp='220' dexter='1' damage='16' tipdam='9'/>
				<param trup='0' robot='1' acttrap='1'/>
				<vis vclass='visualDron1' visdam='1'/>
				<snd die='expl2' run='drone'/>
				<vulner emp='1' fire='0.75' laser='0.5' cryo='0.5' venom='0' poison='0' bleed='0'/>
				<w id='dronlaser'/>
				<n>Дрон</n>
			</unit>
				<weapon id='dronlaser' tip='0'>
					<char damage='3' pier='50' dkol='15' rapid='1' prec='15' crit='0' prep='10' tipdam='5' destroy='10'/>
					<phis speed='2000' deviation='0' drot2='1'/>
					<vis vweap='visdronlaser' tipdec='12' vbul='laser8' spring='2' flare='plasma'/> 
					<snd prep='lasercraft_s' t11='440' t21='1200' noise='400'/>
					<ammo holder='15' reload='55'/>
				</weapon>
			<unit id='dron2' fraction='4' xp='250' cat='3'>
				<phis sX='35' sY='38' massa='35'/>
				<move speed='6' accel='3' brake='2' damwall='35' levit_max='45'/>
				<comb hp='80' armor='10' aqual='0.85' armorhp='120' dexter='1.3' damage='24' tipdam='9'/>
				<param trup='0' robot='1' acttrap='1'/>
				<vis vclass='visualDron2' visdam='1'/>
				<snd die='expl2' run='drone'/>
				<vulner emp='1' fire='0.75' plasma='0.5' cryo='0.5' venom='0' poison='0' bleed='0'/>
				<w id='dronplasma'/>
				<n>Дрон</n>
			</unit>
				<weapon id='dronplasma' tip='0'>
					<char damage='12' rapid='5' prec='20' dkol='3' tipdam='6' knock='0' destroy='10' noise='400'/>
					<phis speed='30'/>
					<vis tipdec='17' vweap='visbloodlight' vbul='plasma5' flare='laser'/> 
					<snd shoot='termo_s'/>
					<ammo holder='3' reload='60'/>
				</weapon>
			<unit id='dron3' fraction='4' xp='300' cat='3'>
				<phis sX='35' sY='38' massa='35'/>
				<move speed='8' accel='4' brake='2' damwall='35' levit_max='15'/>
				<comb hp='60' marmor='10' aqual='0.85' armorhp='80' dexter='1.6' damage='24' tipdam='9'/>
				<param trup='0' robot='1' acttrap='1'/>
				<vis vclass='visualDron3' visdam='1'/>
				<snd die='expl2' run='drone'/>
				<vulner emp='1' fire='0.5' spark='0.5' cryo='0.5' venom='0' poison='0' bleed='0'/>
				<w id='dronpspark'/>
				<n>Дрон</n>
			</unit>
				<weapon id='dronpspark' tip='0'>
					<char damage='12' rapid='5' prec='20' dkol='3' tipdam='9' knock='0' destroy='10' noise='400'/>
					<phis speed='30'/>
					<vis tipdec='17' vweap='vislightning' vbul='spark' bulanim='1' flare='spark'/> 
					<snd shoot='spark_s'/>
					<ammo holder='3' reload='60'/>
				</weapon>
			<unit id='owl' fraction='1' cat='3'>
				<phis sX='38' sY='38' massa='6'/>
				<move speed='5' run='15' jump='12' accel='1.5' float='-0.5'/>
				<comb hp='10'/>
				<param acttrap='0' robot='1'/>
				<vulner fire='0.5' bul='0.75' laser='0.75' expl='0.25' venom='0' poison='0' necro='0.25'/>
				<vis blit='sprOwl' sprX='61' sprY='61' sprDX='31' sprDY='48'/>
				<blit id='stay'/>
				<blit id='fly' len='8' ff='1' rf='2' rep='1'/>
				<w id='owllaser'/>
			</unit>
				<weapon id='owllaser' tip='0'>
					<char damage='2' rapid='2' prec='15' pier='50' crit='0' prep='10' tipdam='5' destroy='10'/>
					<phis speed='2000' deviation='0' drot2='1'/>
					<vis vweap='visowllaser' tipdec='12' vbul='laser2' spring='2'/> 
					<snd shoot='owl_s' noise='200'/>
					<dop effect='blind' ch='0.02'/>
					<ammo holder='15' reload='30'/>
				</weapon>
				<weapon1 id='phoenix' tip='0'>
					<char damage='2' rapid='2' prec='8' pier='5' crit='0' tipdam='3' destroy='10' prep='10'/>
					<phis speed='40' deviation='8' flame='2' drot2='5'/>
					<vis tipdec='11' vbul='dflame' flare='flame' bulanim='1'/> 
					<snd prep='arson_s' t1='990' t2='2270' noise='300'/>
					<ammo holder='30' reload='60'/>
				</weapon1>
			
			<unit id='turret' cat='2'/>
			<unit id='turret0' fraction='4' cont='turret' xp='80' cat='3'>
				<phis sX='38' sY='38' massa='40' massafix='250'/>
				<move fixed='1'/>
				<comb hp='46' armor='5' krep='0' ear='0' aqual='0.85' armorhp='120'/>
				<vulner emp='1' fire='0.75' cryo='0.5' spark='1.25' venom='0' poison='0' bleed='0'/>
				<param trup='0' overlook='0' robot='1' acttrap='1'/>
				<snd die='expl2'/>
				<vis vclass='visualTurret0'/>
				<w id='turret1'/><w id='turret2'/><w id='turret3'/><w id='turret4'/><w id='turret5'/><w id='turret6'/><w id='turret7'/>
			</unit>
			<unit id='turret1' fraction='4' cont='turret1' xp='150' cat='3'>
				<phis sX='38' sY='60' massa='110' massafix='500'/>
				<move knocked='0.3' damwall='25'/>
				<comb hp='88' armor='8' marmor='8' krep='0' ear='0' aqual='0.9' armorhp='250' dexter='0.5'/>
				<vulner emp='1' fire='0.75' cryo='0.5' spark='1.25' venom='0' poison='0' bleed='0'/>
				<param trup='0' overlook='0' robot='1' acttrap='1'/>
				<snd die='expl1'/>
				<vis vclass='visualTurret1'/>
				<w id='turret1'/><w id='turret2'/><w id='turret3'/><w id='turret4'/><w id='turret5'/><w id='turret6'/><w id='turret7'/>
			</unit>
			<unit id='turret2' fraction='4' cont='turret' xp='120' cat='3'>
				<phis sX='38' sY='28' massa='40' massafix='500'/>
				<move fixed='1'/>
				<comb hp='52' armor='4' marmor='4' krep='0' ear='0' aqual='0.8' armorhp='120'/>
				<vulner emp='1' fire='0.75' cryo='0.5' spark='1.25' venom='0' poison='0' bleed='0'/>
				<param trup='0' overlook='1' robot='1' acttrap='1'/>
				<vis vclass='visualTurret2'/>
				<snd die='expl2'/>
				<w id='turret1'/><w id='turret2'/><w id='turret3'/><w id='turret4'/><w id='turret5'/><w id='turret6'/><w id='turret7'/>
			</unit>
			<unit id='turret3' fraction='4' cont='turret1' xp='160' cat='3'>
				<phis sX='40' sY='70' massa='160' massafix='1000'/>
				<move knocked='0.3' damwall='35'/>
				<comb hp='104' armor='10' marmor='10' krep='0' ear='0' aqual='1' armorhp='500' dexter='0.5' damage='24' tipdam='9'/>
				<vulner emp='1' fire='0.5' cryo='0.5' spark='1.25' expl='0.5' acid='0' venom='0' poison='0' bleed='0'/>
				<param trup='0' robot='1' acttrap='1' retdam='1'/>
				<vis vclass='visualTurret3'/>
				<snd die='expl3'/>
				<w id='turret1'/><w id='turret2'/><w id='turret3'/><w id='turret4'/><w id='turret5'/><w id='turret6'/><w id='turret7'/>
			</unit>
			<unit id='turret4' fraction='4' cont='turret' xp='180' cat='3'>
				<phis sX='38' sY='38' massa='120' massafix='1000'/>
				<move fixed='1'/>
				<comb hp='85' armor='10' marmor='10' krep='0' ear='0' aqual='1' armorhp='240'/>
				<vulner emp='1' fire='0.75' cryo='0.5' venom='0' poison='0' bleed='0'/>
				<param trup='0' overlook='0' robot='1' acttrap='1'/>
				<snd die='expl3'/>
				<vis vclass='visualTurret4'/>
				<w id='turret1'/><w id='turret2'/><w id='turret3'/><w id='turret4'/><w id='turret5'/><w id='turret6'/><w id='turret7'/>
			</unit>
				<weapon id='turret1' tip='0'>
					<char damage='6.5' rapid='3' prec='10' knock='3' destroy='10'/>
					<phis speed='200' deviation='8'/>
					<vis tipdec='1' vweap='viswturret'/> 
					<snd shoot='lmg_s' noise='1000'/>
					<ammo holder='100' reload='60'/>
				</weapon>
				<weapon id='turret2' tip='0'>
					<char damage='8' rapid='10' prec='12' tipdam='5' knock='0' destroy='30'/>
					<phis speed='2000' deviation='5'/>
					<dop effect='blind' ch='0.05'/>
					<vis tipdec='12' vweap='viswturret' vbul='laser' spring='2'/> 
					<snd shoot='laser_s' noise='400'/>
					<ammo holder='12' reload='60'/>
				</weapon>
				<weapon id='turret3' tip='0'>
					<char damage='26' rapid='40' prec='8' tipdam='6' knock='10' destroy='100'/>
					<phis speed='50' deviation='8'/>
					<vis tipdec='15' vweap='viswturret' vbul='plasma'/> 
					<snd shoot='plasma_s' noise='400'/>
					<ammo holder='12' reload='60'/>
				</weapon>
				<weapon id='turret4' tip='0'>
					<char damage='50' rapid='30' prec='11' tipdam='3' knock='0' destroy='50'/>
					<phis speed='2000' deviation='5'/>
					<vis vbul='termo' vweap='viswturret' tipdec='11' flare='laser' spring='2'/> 
					<snd shoot='termo_s' noise='200'/>
					<dop effect='igni' damage='5' ch='1'/>
					<ammo holder='15' reload='60'/>
				</weapon>
				<weapon id='turret5' tip='0'>
					<char damage='15' rapid='3' prec='16' tipdam='5' destroy='30'/>
					<phis speed='2000' deviation='3'/>
					<vis tipdec='12' vbul='laser1' spring='2' flare='plasma2' vweap='viswturret'/> 
					<snd shoot='laser_s' noise='500'/>
					<dop effect='blind' ch='0.1'/>
					<ammo holder='20' reload='60'/>
				</weapon>
				<weapon id='turret6' tip='0'>
					<char damage='11' rapid='2' prec='12' knock='5' pier='15' destroy='10'/>
					<phis speed='200' drot2='6' deviation='5'/>
					<vis tipdec='2' vweap='viswturret'/> 
					<snd shoot='hmg_s' noise='1200'/>
					<ammo holder='90' reload='60'/>
				</weapon>
				<weapon id='turret7' tip='0'>
					<char damage='60' rapid='25' prec='20' tipdam='9' crit='2' knock='0' destroy='50'/>
					<phis speed='2000' deviation='2'/>
					<vis vbul='laser3' vweap='viswturret' tipdec='12' spring='2'/> 
					<snd shoot='grom_s' noise='1000'/>
					<ammo holder='5' reload='30'/>
					<dop probiv='1'/>
				</weapon>
				<weapon id='turret10' tip='0'>
					<char damage='25' rapid='3' prec='0' tipdam='18' knock='5' destroy='10'/>
					<phis speed='200' deviation='3'/>
					<ammo holder='30' reload='55'/>
					<vis tipdec='15' vbul='plasma3a' flare='plasma'/> 
					<snd shoot='quick_s' noise='500'/>
				</weapon>
			<unit id='turret5' fraction='4' cont='turret' xp='180' cat='3'>
				<phis sX='38' sY='38' massa='10000' massafix='10000'/>
				<move fixed='1'/>
				<comb hp='1000' krep='0' ear='0'/>
				<param trup='0' overlook='0' robot='1' acttrap='1'/>
				<snd die='expl3' music='boss_3'/>
				<vis vclass='visualTurret5'/>
			</unit>
			
			<!-- ловушки -->
			<unit id='mtrap'>
				<phis sX='20' sY='20' massa='15'/>
				<move brake='10' knocked='0.1' damwall='10'/>
				<vulner fire='0.1' cryo='0.1' spark='0.25' venom='0' poison='0' bleed='0'/>
				<comb hp='100' skin='10' damage='24' tipdam='14' dexter='0.7'/>
				<param trup='0' acttrap='0' mech='1'/>
				<n>Капкан</n>
			</unit>
			<unit id='trigcans' fraction='2'>
				<phis sX='40' sY='70'/>
				<move fixed='1'/>
				<comb hp='10' dexter='3'/>
				<param trup='0' acttrap='0' mech='1'/>
				<un skill='sneak' res='noise'/>
				<snd act='cans'/>
				<n>Банки</n>
			</unit>
			<unit id='trigridge' fraction='2'>
				<phis sX='20' sY='40'/>
				<move fixed='1'/>
				<comb hp='10' dexter='10'/>
				<param trup='0' acttrap='0' mech='1'/>
				<un skill='repair' one='1' res='damgren'/>
				<n>Растяжка</n>
			</unit>
			<unit id='trigplate' fraction='2'>
				<phis sX='40' sY='10'/>
				<move fixed='1'/>
				<comb hp='100' dexter='2'/>
				<param trup='0' acttrap='0' mech='1'/>
				<un skill='repair' plate='1' res='damshot'/>
				<snd act='button'/>
				<n>Плита</n>
			</unit>
			<unit id='triglaser' fraction='4'>
				<phis sX='20' sY='40'/>
				<move fixed='1'/>
				<comb hp='100' dexter='10'/>
				<param trup='0' mech='1' acttrap='0' robot='1'/>
				<un skill='science' res='hturret2' robot='1'/>
				<snd act='mine_bip'/>
				<n>Лазер</n>
			</unit>
			<unit id='damshot' fraction='2'>
				<phis sX='40' sY='70'/>
				<move fixed='1'/>
				<comb hp='30' dexter='2'/>
				<param trup='0' acttrap='0' mech='1'/>
				<un tip='1' skill='repair'/>
				<n>Пушка</n>
			</unit>
			<unit id='damgren' fraction='2'>
				<phis sX='20' sY='20'/>
				<move fixed='1'/>
				<comb hp='20' dexter='3'/>
				<param trup='0' acttrap='0' mech='1'/>
				<un tip='2' skill='explosives'/>
				<n>Гранаты</n>
			</unit>
			<unit id='damexpl1' fraction='2'>
				<phis sX='36' sY='36'/>
				<move fixed='1'/>
				<comb hp='20'/>
				<param trup='0' acttrap='0' mech='1'/>
				<un tip='3' skill='explosives'/>
				<n>Взрывчатка</n>
			</unit>
			<unit id='transmitter' fraction='1'>
				<phis sX='30' sY='20'/>
				<comb hp='20' dexter='3' damage='20' tipdam='16'/>
				<param trup='0' mech='1' acttrap='0' robot='1'/>
				<snd run='transmitter' die='expl3'/>
			</unit>
			
			<!-- силовое поле -->
			<unit id='mwall'>
				<phis sX='40' sY='120'/>
				<move fixed='1' knocked='0'/>
				<comb hp='200' dexter='0'/>
				<param trup='0' acttrap='0' mech='1'/>
				<n>силовое поле</n>
			</unit>
			<unit id='scythe'>
				<phis sX='60' sY='60' massa='5'/>
				<move brake='1' knocked='0'/>
				<vulner fire='0.1'/>
				<comb hp='40' damage='40' tipdam='14'/>
				<param trup='0' acttrap='0' mech='1'/>
				<n>Лезвие</n>
			</unit>
			<unit id='thunderhead' fraction='4'>
				<phis sX='6000' sY='3000' massa='100000'/>
				<move brake='1' knocked='0' speed='40'/>
				<comb hp='200000'/>
				<param mech='1'/>
			</unit>
			<unit id='dront' fraction='4'>
				<phis sX='120' sY='120' massa='1200'/>
				<move speed='15' accel='6' brake='3'/>
				<comb hp='7000' dexter='1' damage='2000' tipdam='9'/>
				<param trup='0' robot='1'/>
				<snd die='expl'/>
				<vulner emp='1' fire='0.75' laser='0.5' cryo='0.5' venom='0' poison='0' bleed='0'/>
			</unit>
			<unit id='ttur' fraction='4'>
				<phis sX='90' sY='90' massa='1000'/>
				<move/>
				<comb hp='4000' dexter='0.5'/>
				<snd die='expl'/>
				<param trup='0' robot='1'/>
				<vulner blade='0.7'/>
			</unit>
				<weapon id='ttweap1' tip='0'><!--  пулемёт -->
					<char damage='140' rapid='3' prec='50' knock='1'/>
					<phis speed='200' drot='12' drot2='5' deviation='5'/>
					<vis vweap='visttweap1'/> 
					<snd shoot='zebr_s'/>
					<ammo holder='30' reload='120'/>
				</weapon>
				<weapon id='ttweap2' tip='0'><!--  волна -->
					<char damage='800' kol='5' rapid='5' prec='60' knock='1' tipdam='6'/>
					<phis speed='50' accel='0.2' deviation='8' volna='1' drot='10'/>
					<vis vweap='visttweap2' vbul='ttplasma' flare=''/> 
					<snd shoot='termo_s'/>
					<ammo holder='1' reload='110'/>
				</weapon>
				<weapon id='ttweap3' tip='0'><!--  лазер -->
					<char damage='400' rapid='5' prec='0' tipdam='5'/>
					<phis speed='2000' deviation='6' drot='1.3'/>
					<vis vweap='visttweap3' vbul='ttlaser' spring='2' flare='laser'/> 
					<snd shoot='laser2_s'/>
					<ammo holder='1' reload='90'/>
				</weapon>
				<weapon id='ttweap4' tip='0'><!--  массовые ракеты -->
					<char damexpl='800' damage='100' rapid='5' prec='20' crit='0' tipdam='4' expl='300'/>
					<phis speed='50' deviation='15' distexpl='1' drot='6'/>
					<vis vweap='visttweap4' vbul='ttzalp' flare='' visexpl='ttexpl'/> 
					<snd shoot='fireball'/>
					<ammo holder='4' reload='300'/>
				</weapon>
				<weapon id='ttweap5' tip='0'><!--  самонавод ракеты -->
					<char damexpl='1100' damage='100' rapid='5' prec='0' crit='0' tipdam='4' expl='300'/>
					<phis speed='15' accel='0.65' deviation='1' navod='5' drot='10'/>
					<vis vweap='visttweap5' vbul='ttnavod' flare='' visexpl='ttplaexpl'/> 
					<snd shoot='fireball'/>
					<ammo holder='1' reload='150'/>
				</weapon>
				<weapon id='ttweap6' tip='0'><!--  самонавод снаряды -->
					<char damage='700' rapid='5' prec='0' tipdam='18'/>
					<phis speed='50' accel='0.2' deviation='8' navod='4' drot='1'/>
					<vis vweap='visttweap6' vbul='ttmoln' flare=''/> 
					<snd shoot='fireball'/>
					<ammo holder='3' reload='160'/>
				</weapon>
			<unit id='destr1'>
				<phis sX='160' sY='800' massa='100000'/>
				<move knocked='0'/>
				<comb hp='5000'/>
				<param mech='1'/>
			</unit>
			
	<!--       *******   Оружие   *******         -->
			<!--
			Основные:
				tip - тип оружия
					0 - внутреннее
					1 - холодное
					2 - маленькое (пистолеты)
					3 - большое (винтовки и больше)
					4 - метательное
					5 - магия
				mtip - тип холодного оружия
					0 - обычное
					1 - копья
					2 - цепная пила
				throwtip - тип взрывчатки
					0 - граната
					1 - мина
					2 - липкая бомба
				skill - требуемый навык
					1 - холодное
					2 - лёгкое
					3 - самодельное
					4 - энергомагическое
					5 - взрывчатка
					6 - магия
				lvl - уровень навыка
				perk - связанный перк
				cat - категория
					1 - холодное
					2 - пистолеты
					3 - автоматы
					4 - дробовики
					5 - винтовки
					6 - тяжёлое
					7 - снайперки
					8 - взрывчатка
					9 - магия
				crack='1' - холодное оружие может взламывать контейнеры (монтировка)
					
			com - параметры, связанные с нахождением, покупкой и ремонтом
				price - цена покупки и ремонта
				worth - где встречается
					1 - хлам
					2 - инструмент
					3 - обычное оружие
					4 - боевое оружие (оружейный шкаф)
					5 - большое и тяжёлое оружие (оружейный ящик)
				stage - этап сюжета
				chance - шанс на рандомное выпадение
				uniq - шанс найти уникальный вариант (если он есть)
				rep - эффективность ремонта инструментами
				
			char - характеристики
				
				maxhp - выстрелов или ударов до поломки
				damage - урон
				rapid - тактов на выстрел (30 в сек)
				prep - тактов на запуск (для минигана)
				tipdam - Типы урона
					0 - пуля
					1 - лезвие или шипы
					2 - физический
					3 - огонь
					4 - взрыв
					5 - лазер
					6 - плазма
					7 - яд
					8 - эми
				knock - отброс
				destroy - урон стенам
				prec - прицельная точность в блоках (на этой дистации шанс попасть 100%), 0 - если попадание всегда
				holder - магазин
				rashod - затраты на один выстрел
				reload - время на перезарядку в тактах
				kol - пуль за один выстрел (для дробовиков)
				pier - бронебойность
				expl - радиус взрыва
				time - задержка взрыва
				sens - радиус срабатывания
				
			phis - физические параметры оружия и снарядов
			
				speed - скорость полёта снаряда
				deviation - разлёт пуль, в градусах
				minlong - минимальная длина холодного оружия (от основания)
				long - длина холодного оружия
				minlong - длина, с которой начинается ударная часть
				drot - скорость вращения, если не задано, то мгновенная
				drot2 - скорость вращения при стрельбе
				massa - вес оружия
				
			vis - визуальные эффекты
				
				tipdec - тип оставляемых на стенах следов
					1-3 - дырки от пуль
					4-6 - трещины от ударов
					9	- трещины от взрывов
					11 - огонь
					12 - лазер
					13 - слабый лазер
					15 - зелёная плазма
					16 - синяя плазма
					17 - малиновая плазма
					19 - взрыв плазмы
				shell - выброс гильзы
				vbul - вид снаряда
				laser - снаряд в виде луча
				flame - огонь
				
			snd - звуки
				noise - шум от выстрела
			
			-->
			
			<weapon id='armature' tip='1' cat='1' skill='1' lvl='0' perk='stunning'>
				<char maxhp='180' damage='11' rapid='15' tipdam='2' knock='5' destroy='20'/>
				<phis massa='2' minlong='30' long='50'/>
				<vis tipdec='4'/>
				<snd shoot='m_med' fall='fall_metal_item' noise='400'/>
				<sats cons='18'/>
				<com price='28' chance='1' stage='1' worth='1' rep='0'/>
				<n>Кусок арматуры</n>
			</weapon>
			<weapon id='bat' tip='1' cat='1' skill='1' lvl='0' perk='stunning'>
				<char maxhp='100' damage='10' rapid='12' tipdam='2' knock='5' destroy='10'/>
				<phis massa='1' minlong='30' long='50'/>
				<vis tipdec='4'/>
				<snd shoot='m_med' fall='falll_item' noise='200'/>
				<sats cons='18'/>
				<com price='20' chance='1' stage='1' worth='1' rep='2'/>
				<n>Бита с гвоздями</n>
			</weapon>
			<weapon id='hsword' tip='1' cat='1' skill='1' lvl='0' perk='acute'>
				<char maxhp='200' damage='12' rapid='12' tipdam='1' knock='5' destroy='10'/>
				<phis massa='4' m='2' minlong='20' long='60'/>
				<vis tipdec='4'/>
				<snd shoot='m_med' fall='fall_metal_item' noise='400'/>
				<sats cons='16'/>
				<dop effect='cut' damage='2' ch='0.5'/>
				<com price='85' chance='0' stage='1' worth='2' rep='2'/>
				<n>Самодельный меч</n>
			</weapon>
			<weapon id='knife' tip='1' cat='1' skill='1' lvl='0' perk='acute'>
				<char maxhp='100' damage='9' rapid='8' tipdam='1' knock='2' destroy='10' auto='1'/>
				<phis massa='2' minlong='10' long='30'/>
				<vis tipdec='4'/>
				<snd shoot='m_small' fall='fall_metal_item' noise='200'/>
				<sats cons='24' que='3'/>
				<dop effect='cut' damage='1' ch='0.25'/>
				<com price='25' chance='1' stage='1' worth='2' rep='2'/>
				<n>Нож</n>
			</weapon>
			<weapon id='mont' tip='1' cat='1' skill='1' lvl='1' perk='stunning' crack='1' mess='mont'>
				<char maxhp='300' damage='14' rapid='15' tipdam='2' knock='5' destroy='80' auto='1'/>
				<char maxhp='800' rapid='12' destroy='150' auto='1'/>
				<phis massa='2' minlong='20' long='30'/>
				<vis tipdec='4'/>
				<snd shoot='m_med' fall='fall_metal_item' noise='400'/>
				<sats cons='25'/>
				<com price='500' chance='0.3' stage='1' worth='2' rep='0' uniq='0'/>
				<n>Монтировка</n>
			</weapon>
			<weapon id='chopper' tip='1' cat='1' skill='1' lvl='1' perk='acute'>
				<char maxhp='180' damage='14' rapid='12' tipdam='1' knock='5' destroy='10'/>
				<phis massa='3' minlong='15' long='43'/>
				<vis tipdec='4'/>
				<snd shoot='m_med' fall='fall_metal_item' noise='400'/>
				<sats cons='18'/>
				<dop effect='cut' damage='2' ch='0.5'/>
				<com price='180' chance='1' stage='1' worth='2' rep='2'/>
				<n>Тесак</n>
			</weapon>
			<weapon id='shovel' tip='1' cat='1' skill='1' lvl='1' perk='acute'>
				<char maxhp='100' damage='18' rapid='20' tipdam='1' knock='10' destroy='20' pow='1'/>
				<phis massa='7' m='2' minlong='40' long='60'/>
				<vis tipdec='5'/>
				<snd shoot='m_med' fall='fall_hammer' noise='500'/>
				<sats cons='25'/>
				<dop effect='cut' damage='2' ch='0.25'/>
				<com price='150' worth='2' stage='2' chance='1' rep='2'/>
				<n>Лопата</n>
			</weapon>
			<weapon id='spear' tip='1' mtip='1' cat='1' skill='1' lvl='2' perk='acute'>
				<char maxhp='100' damage='32' rapid='20' tipdam='1' knock='5' destroy='10' pow='1'/>
				<char maxhp='200' damage='30'/>
				<phis massa='2' m='2' long='50'/>
				<vis tipdec='4'/>
				<dop/>
				<dop effect='poison' damage='4' ch='0.5'/>
				<snd shoot='m_med' fall='falll_item' noise='400'/>
				<sats cons='20'/>
				<com price='180' worth='1' chance='1' stage='1' rep='2' uniq='1'/>
				<n>Копьё</n>
			</weapon>
			<weapon id='mach' tip='1' cat='1' skill='1' lvl='2' perk='acute'>
				<char maxhp='300' damage='16' rapid='12' tipdam='1' knock='5' destroy='10' combo='1'/>
				<char maxhp='300' damage='18' knock='10'/>
				<phis massa='3' m='2' minlong='20' long='60'/>
				<vis tipdec='4'/>
				<snd shoot='m_med' fall='fall_metal_item' noise='400'/>
				<sats cons='18'/>
				<dop effect='cut' damage='2' ch='0.5'/>
				<com price='400' worth='2' chance='0.6' stage='1' uniq='1'/>
				<n>Мачете</n>
			</weapon>
			<weapon id='zknife' tip='1' cat='1' skill='1' lvl='1' perk='acute'>
				<char maxhp='200' damage='12' rapid='8' tipdam='1' knock='2' destroy='10' auto='1'/>
				<char maxhp='250' damage='13' auto='1'/>
				<phis massa='2' minlong='10' long='30'/>
				<vis tipdec='4'/>
				<snd shoot='m_small' fall='fall_metal_item' noise='200'/>
				<sats cons='24' que='3'/>
				<dop effect='cut' damage='2' ch='0.2'/>
				<dop effect='cut' damage='4' ch='0.5'/>
				<com price='210' chance='1' stage='1' worth='2' rep='2' uniq='1'/>
				<n>Нож</n>
			</weapon>
			<weapon id='cknife' tip='1' cat='1' skill='1' lvl='2' perk='acute'>
				<char maxhp='450' damage='15' rapid='8' tipdam='1' knock='2' destroy='10' auto='1'/>
				<char maxhp='550' damage='17' auto='1'/>
				<phis massa='2' minlong='10' long='30'/>
				<vis tipdec='4'/>
				<snd shoot='m_small' fall='fall_metal_item' noise='200'/>
				<sats cons='24' que='3'/>
				<dop effect='cut' damage='2' ch='0.5'/>
				<com price='600' worth='4' chance='1' stage='1' uniq='0'/>
				<n>Боевой Нож</n>
			</weapon>
			<weapon id='edagger' tip='1' cat='1' skill='1' lvl='3'>
				<char maxhp='500' damage='18' rapid='9' tipdam='6' knock='2' destroy='10' auto='1'/>
				<phis massa='2' minlong='10' long='40'/>
				<vis tipdec='15'/>
				<snd shoot='m_small' fall='fall_metal_item' noise='200'/>
				<sats cons='24' que='3'/>
				<com price='1600' chance='0.7' stage='1' worth='4' rep='1'/>
			</weapon>
			<weapon id='cdagger' tip='1' cat='1' skill='1' lvl='4'>
				<char maxhp='500' damage='25' rapid='8' tipdam='1' pier='15' knock='3' destroy='10' auto='1'/>
				<phis massa='2' minlong='10' long='50'/>
				<vis tipdec='15'/>
				<snd shoot='m_small' fall='fall_metal_item' noise='200'/>
				<sats cons='24' que='3'/>
				<com price='1500' chance='0' stage='1' worth='4' rep='1'/>
			</weapon>
			<weapon id='mace' tip='1' cat='1' skill='1' lvl='2' perk='stunning'>
				<char maxhp='140' damage='30' rapid='20' tipdam='2' knock='10' destroy='80' pow='1'/>
				<phis massa='7' m='2' minlong='40' long='60'/>
				<vis tipdec='5' flare='bum'/>
				<snd shoot='m_big' fall='fall_hammer' noise='500'/>
				<sats cons='25'/>
				<com price='350' worth='2' stage='2' chance='0.6' rep='0'/>
				<n>Палица</n>
			</weapon>
			<weapon id='pipe' tip='1' cat='1' skill='1' lvl='3' perk='stunning'>
				<char maxhp='120' damage='26' rapid='15' tipdam='2' knock='8' destroy='30'/>
				<phis massa='2' minlong='20' long='45'/>
				<vis tipdec='4'/>
				<snd shoot='m_med' fall='fall_metal_item' noise='400'/>
				<sats cons='18'/>
				<com chance='1' stage='1' price='200' worth='2' rep='0'/>
				<n>Труба</n>
			</weapon>
			<weapon id='zsword' tip='1' cat='1' skill='1' lvl='3' perk='acute'>
				<char maxhp='300' damage='24' rapid='12' crit='1.5' tipdam='1' knock='5' destroy='10'/>
				<char maxhp='400' damage='25' rapid='10'/>
				<phis massa='5' m='2' minlong='30' long='75'/>
				<vis tipdec='4'/>
				<snd shoot='m_med' fall='fall_hammer' noise='300'/>
				<sats cons='18'/>
				<dop effect='cut' damage='3' ch='0.5'/>
				<com price='800' chance='0.5' stage='3' worth='4' uniq='1' rep='0.5'/>
				<n>Меч</n>
			</weapon>
			<weapon id='ripper' tip='1' mtip='2' cat='1' skill='1' lvl='3'>
				<char maxhp='900' damage='10' rapid='3' tipdam='1' knock='2' destroy='10'/>
				<char maxhp='1500' damage='11' pier='15'/>
				<phis massa='10' m='2' minlong='30' long='80'/>
				<vis tipdec='5' lasm='1'/>
				<snd prep='pila_s' t1='800' t2='4000' reload='laser_r' fall='fall_metal_item' noise='800'/>
				<sats cons='24' que='6'/>
				<dop effect='cut' damage='4' ch='0.1'/>
				<ammo holder='200' reload='30'/>
				<a>batt</a>
				<com price='1200' worth='2' stage='2' chance='0.1' rep='0.5' uniq='0'/>
				<n>Потрошитель</n>
			</weapon>
			<weapon id='axe' tip='1' cat='1' skill='1' lvl='3' perk='acute'>
				<char maxhp='240' damage='34' rapid='17' tipdam='1' knock='12' destroy='80' pow='1'/>
				<phis massa='10' m='2' minlong='50' long='60'/>
				<vis tipdec='5'/>
				<snd shoot='m_big' fall='fall_hammer' noise='400'/>
				<sats cons='36'/>
				<dop effect='cut' damage='4' ch='0.5'/>
				<com price='600' worth='2' stage='2' chance='0.5'/>
				<n>Топор</n>
			</weapon>
			<weapon id='hammer' tip='1' cat='1' skill='1' lvl='4' perk='stunning'>
				<char maxhp='200' damage='44' rapid='20' tipdam='2' knock='15' destroy='350' pow='1'/>
				<char maxhp='400' damage='50'/>
				<phis massa='15' m='2' minlong='50' long='60'/>
				<vis tipdec='5' flare='bum'/>
				<snd shoot='m_big' fall='fall_hammer' noise='500'/>
				<sats cons='32'/>
				<com price='500' worth='2' stage='2' chance='0.5' rep='0.5' uniq='0'/>
				<n>Кувалда</n>
			</weapon>
			<weapon id='tlance' tip='1' mtip='1' cat='1' skill='1' lvl='4'>
				<char maxhp='350' damage='50' rapid='18' tipdam='3' knock='5' destroy='200' pow='1'/>
				<phis massa='6' m='2' long='60'/>
				<vis tipdec='12' flare='flame'/>
				<snd shoot='m_big' fall='falll_item' noise='400'/>
				<sats cons='25'/>
				<dop effect='igni' damage='8' ch='1'/>
				<com price='2800' worth='4' chance='0.1' stage='3' rep='0.25'/>
				<n>Копьё</n>
			</weapon>
			<weapon id='elsword' tip='1' cat='1' skill='1' lvl='4'>
				<char maxhp='350' damage='30' rapid='12' crit='2' tipdam='9' knock='5' destroy='10'/>
				<char maxhp='480' damage='35'/>
				<phis massa='5' m='2' minlong='30' long='75'/>
				<vis tipdec='4' lasm='1' flare='spark'/>
				<snd shoot='lasm_s' hit='hit_pole' fall='fall_hammer' noise='300'/>
				<sats cons='25'/>
				<com price='1900' worth='4' chance='0.1' stage='5' rep='0.25' uniq='0'/>
				<n>Меч</n>
			</weapon>
			<weapon id='autoaxe' tip='1' mtip='2' cat='1' skill='1' lvl='4'>
				<char maxhp='400' damage='25' rapid='6' tipdam='1' pier='30' knock='2' destroy='80' auto='1'/>
				<phis massa='10' m='3' minlong='30' long='70'/>
				<vis tipdec='5' lasm='1'/>
				<snd prep='autoaxe_s' t1='300' t2='1450' reload='laser_r' fall='fall_hammer' noise='800'/>
				<sats cons='36' que='3'/>
				<dop effect='cut' damage='9' ch='0.1'/>
				<ammo holder='300' reload='30' rashod='3'/>
				<a>energ</a>
				<com price='1100' worth='2' stage='5' chance='0.1' rep='0.25'/>
				<n>Автотопор</n>
			</weapon>
			<weapon id='mspear' tip='1' mtip='1' cat='1' skill='1' lvl='5'>
				<char maxhp='350' damage='64' rapid='20' tipdam='6' knock='5' destroy='300' pow='1'/>
				<char maxhp='400' damage='74' rapid='20' destroy='500'/>
				<phis massa='6' m='3' long='50'/>
				<vis tipdec='15' lasm='1' flare='plasma'/>
				<vis tipdec='16' flare='plasma1'/>
				<snd shoot='m_med' fall='fall_metal_item' flare='plasma' noise='400'/>
				<sats cons='18'/>
				<com price='4500' worth='5' chance='0.1' stage='3' rep='0.12' uniq='0'/>
				<n>МКопьё</n>
			</weapon>
			<weapon id='sword' tip='1' cat='1' skill='1' lvl='5' perk='acute'>
				<char maxhp='500' damage='35' rapid='12' crit='2' tipdam='1' knock='5' destroy='10'/>
				<char maxhp='1000' damage='40' pier='25'/>
				<phis massa='5' m='2' minlong='30' long='80'/>
				<phis massa='5' m='2' minlong='30' long='90'/>
				<vis tipdec='4'/>
				<snd shoot='m_med' fall='fall_hammer' noise='300'/>
				<sats cons='25'/>
				<dop effect='cut' damage='6' ch='0.5'/>
				<dop effect='cut' damage='10' ch='0.5'/>
				<com price='3500' chance='0.2' stage='5' worth='4' rep='0' uniq='0'/>
				<n>Меч</n>
			</weapon>
			<weapon id='lsword' tip='1' cat='1' skill='1' lvl='5'>
				<char maxhp='320' damage='45' rapid='15' crit='2' tipdam='5' knock='2' destroy='250'/>
				<char maxhp='450' damage='52'/>
				<phis massa='2' m='2' minlong='30' long='80'/>
				<vis tipdec='12' lasm='1' flare='bum'/>
				<snd shoot='lasm_s' hit='lasm_h' noise='400'/>
				<sats cons='22'/>
				<com price='4500' chance='0.1' stage='7' worth='4' rep='0.12' uniq='0'/>
				<n>ЛазМеч</n>
			</weapon>
			<weapon id='bsaw' tip='1' mtip='2' cat='1' skill='1' lvl='5'>
				<char maxhp='1500' damage='14' rapid='3' pier='15' tipdam='1' knock='2' destroy='10'/>
				<phis massa='10' m='3' minlong='10' long='60'/>
				<vis tipdec='5' lasm='1'/>
				<snd prep='bsaw_s' t1='800' t2='3000' reload='laser_r' fall='fall_hammer' noise='800'/>
				<sats cons='36' que='6'/>
				<dop effect='cut' damage='5' ch='0.1'/>
				<ammo holder='600' reload='30' rashod='3'/>
				<a>energ</a>
				<com price='2100' worth='2' stage='5' chance='0.2' rep='0.2'/>
				<n>Цепная пила</n>
			</weapon>
			<weapon id='sledge' tip='1' cat='1' skill='1' lvl='5' perk='stunning'>
				<char maxhp='500' damage='75' rapid='25' tipdam='2' knock='25' destroy='500' pow='1'/>
				<char maxhp='500' damage='85' knock='28'/>
				<phis massa='15' m='3' minlong='60' long='70'/>
				<vis tipdec='5' flare='bum'/>
				<snd shoot='m_big' fall='fall_hammer' noise='500'/>
				<sats cons='32'/>
				<com price='5800' worth='5' stage='7' chance='0.3' uniq='0.3' rep='0.15'/>
				<n>Кувалда</n>
			</weapon>
			<weapon id='kosa' tip='1' cat='1' skill='1' lvl='5'>
				<char maxhp='400' damage='66' rapid='20' crit='2' tipdam='16' knock='1' destroy='10' pow='1'/>
				<phis massa='6' m='3' minlong='70' long='80'/>
				<vis tipdec='12' lasm='1' flare='bumn'/>
				<snd shoot='m_big' hit='hit_necr' noise='300'/>
				<sats cons='32'/>
				<com price='7500' chance='0' rep='0.12'/>
				<n>Коса смерти</n>
			</weapon>
			
			<weapon id='p9mm' tip='2' cat='2' skill='2' lvl='0' perk='pistol'>
				<char maxhp='200' damage='8' rapid='9' prec='8' knock='2' destroy='10'/>
				<phis speed='150' deviation='5' recoil='5' massa='2'/>
				<vis tipdec='1' shell='1'/>
				<snd shoot='p10mm_s' reload='p10mm_r' noise='700'/>
				<sats cons='17'/>
				<ammo holder='8' reload='30'/>
				<a>p9</a>
				<com price='275' worth='3' chance='1' stage='1' rep='2'/>
				<n>10-мм пистолет</n>
			</weapon>
			<weapon id='r32' tip='2' cat='2' skill='2' lvl='0' perk='pistol' mess='r32'>
				<char maxhp='200' damage='14' rapid='16' prec='8' knock='2' destroy='10'/>
				<phis speed='150' deviation='5' recoil='10' massa='2'/>
				<vis tipdec='1'/> 
				<snd shoot='p10mm_s' reload='revo_r' noise='800'/>
				<sats cons='32'/>
				<ammo holder='5' reload='45'/>
				<a>p32</a>
				<com price='180' worth='3' chance='1' stage='1' rep='2'/>
				<n>Револьвер .32</n>
			</weapon>
			<weapon id='r375' tip='2' cat='2' skill='2' lvl='2' perk='pistol'>
				<char maxhp='350' damage='24' rapid='18' prec='10' crit='2' knock='8' destroy='10'/>
				<phis speed='150' deviation='5' recoil='10' massa='2'/>
				<vis tipdec='1'/> 
				<snd shoot='revo_s' reload='revo_r' noise='800'/>
				<sats cons='32'/>
				<ammo holder='6' reload='45'/>
				<a>p375</a>
				<com price='500' worth='3' chance='1' stage='1' rep='2'/>
				<n>Револьвер .375</n>
			</weapon>
			<weapon id='p10mm' tip='2' cat='2' skill='2' lvl='1' perk='pistol'>
				<char maxhp='300' damage='11' rapid='7' prec='8' knock='4' destroy='10'/>
				<char maxhp='400' damage='12' rapid='7' prec='10'/>
				<phis speed='150' deviation='5' recoil='5' massa='2'/>
				<vis tipdec='1' shell='1'/>
				<snd shoot='p10mm_s' reload='p10mm_r' noise='700'/>
				<sats cons='17'/>
				<ammo holder='12' reload='35'/>
				<a>p10</a>
				<com price='275' worth='3' chance='1' stage='1' rep='2' uniq='1'/>
				<n>10-мм пистолет</n>
			</weapon>
			<weapon id='p10s' tip='2' cat='2' skill='2' lvl='2' perk='pistol'>
				<char maxhp='300' damage='9' rapid='7' prec='8' knock='4' destroy='10'/>
				<phis speed='150' deviation='5' recoil='4' massa='2.5'/>
				<vis tipdec='1' shell='1' shine='100'/> 
				<snd shoot='silen_s' reload='p10mm_r' noise='200'/>
				<sats cons='17'/>
				<ammo holder='12' reload='35'/>
				<a>p10</a>
				<com price='360' worth='3' chance='0.2' stage='1' rep='2'/>
				<n>10-мм пистолет с глушителем</n>
			</weapon>
			<weapon id='revo' tip='2' cat='2' skill='2' lvl='3' perk='pistol'>
				<char maxhp='400' damage='36' rapid='16' prec='13' crit='2' knock='12' destroy='10'/>
				<char maxhp='500' damage='44' prec='14'/>
				<phis speed='200' deviation='3' recoil='10' massa='2'/>
				<phis deviation='1.5'/>
				<vis tipdec='2'/> 
				<snd shoot='revo_s' reload='revo_r' noise='1200'/>
				<dop vision='2'/>
				<sats cons='32'/>
				<ammo holder='6' reload='30'/>
				<a>p44</a>
				<com price='1550' worth='3' chance='0.25' stage='2' uniq='0'/>
				<n>Револьвер .44</n>
			</weapon>
			<weapon id='p308c' tip='2' cat='2' skill='2' lvl='3' perk='pistol'>
				<char maxhp='600' damage='26' rapid='9' prec='10' crit='2' knock='10' destroy='10'/>
				<phis speed='250' deviation='5' recoil='6' massa='3'/>
				<vis tipdec='2' shell='1'/> 
				<snd shoot='p127_s' reload='p10mm_r' noise='1200'/>
				<sats cons='17'/>
				<ammo holder='12' reload='30'/>
				<a>p308</a>
				<com price='1000' worth='3' chance='0.3' stage='3'/>
				<n>308 пистолет</n>
			</weapon>
			<weapon id='p127mm' tip='2' cat='2' skill='2' lvl='4' perk='pistol'>
				<char maxhp='400' damage='32' rapid='8' prec='10' crit='2' knock='18' destroy='30'/>
				<char maxhp='400' damage='36' prec='11' crit='2' knock='26' destroy='150'/>
				<phis speed='250' deviation='5' recoil='12' massa='3'/>
				<vis tipdec='2' shell='1'/> 
				<snd shoot='p127_s' reload='p10mm_r' noise='1700'/>
				<sats cons='17'/>
				<ammo holder='7' reload='30'/>
				<a>p127</a>
				<com price='2000' worth='4' chance='0.4' stage='5' uniq='0.5'/>
				<n>12,7-мм пистолет</n>
			</weapon>
			<weapon id='psc' tip='2' cat='2' skill='2' lvl='5' perk='pistol'>
				<char maxhp='360' damage='55' rapid='12' prec='9' crit='2' knock='20' destroy='30'/>
				<char maxhp='420' damage='60' prec='10'/>
				<phis speed='250' deviation='5' recoil='15' massa='3'/>
				<vis tipdec='2' shell='1'/> 
				<snd shoot='p127_s' reload='p10mm_r' noise='1700'/>
				<sats cons='17'/>
				<ammo holder='7' reload='30'/>
				<a>p50mg</a>
				<com price='2500' worth='4' chance='0.3' stage='7' uniq='0' rep='0.5'/>
			</weapon>
			<weapon id='shok' tip='2' cat='2' skill='4' lvl='0'>
				<char maxhp='200' damage='10' rapid='15' prec='0' tipdam='9' destroy='0'/>
				<phis speed='30' deviation='7' recoil='2' massa='2'/>
				<vis tipdec='11' vbul='spark' bulanim='1'/> 
				<snd shoot='spark_s' reload='p10mm_r' noise='400'/>
				<sats cons='24'/>
				<ammo holder='10' rashod='1' reload='45'/>
				<a>batt</a>
				<com price='300' worth='3' chance='0.5' stage='1' rep='2'/>
				<n>Шоковый пистолет</n>
			</weapon>
			<weapon id='rech' tip='2' cat='2' skill='4' lvl='0' perk='laser' mess='rech'>
				<char maxhp='200' damage='5' rapid='12' prec='8' tipdam='5' destroy='10' auto='1'/>
				<phis speed='200' deviation='5' recoil='2' massa='2'/>
				<vis tipdec='11' vbul='blump'/> 
				<snd shoot='las_s' reload='p10mm_r' noise='300'/>
				<sats cons='20'/>
				<ammo holder='20' rashod='1' reload='600' recharg='30'/>
				<a>recharg</a>
				<com price='250' worth='3' chance='0.25' stage='1' rep='2'/>
				<n>Пистолет с подзарядкой</n>
			</weapon>
			<weapon id='flaregun' tip='2' cat='2' skill='4' lvl='1' perk='pyro'>
				<char maxhp='100' damage='15' rapid='20' prec='8' tipdam='3' knock='5' destroy='20'/>
				<phis speed='50' deviation='5' recoil='5' massa='3'/>
				<vis tipdec='11' vbul='flare'/> 
				<snd shoot='incin_s' reload='p10mm_r' noise='400'/>
				<dop effect='igni' damage='6' ch='1'/>
				<sats cons='24'/>
				<ammo holder='30' rashod='5' reload='45'/>
				<a>fuel</a>
				<com price='200' worth='3' chance='0.5' stage='1' rep='2'/>
				<n>Сигнальный пистолет</n>
			</weapon>
			<weapon id='lasp' tip='2' cat='2' skill='4' lvl='1' perk='laser'>
				<char maxhp='275' damage='8' rapid='7' prec='9' tipdam='5' destroy='10' auto='1'/>
				<char maxhp='275' damage='10' auto='1'/>
				<phis speed='2000' deviation='5' recoil='2' massa='2'/>
				<vis tipdec='13' vbul='laser2' spring='2'/> 
				<snd shoot='las_s' reload='p10mm_r' noise='300'/>
				<dop effect='blind' ch='0.1'/>
				<sats cons='17'/>
				<ammo holder='15' rashod='1' reload='45'/>
				<ammo holder='30'/>
				<a>batt</a>
				<com price='450' worth='3' chance='0.5' stage='1' rep='2' uniq='1'/>
				<n>Лазерный пистолет</n>
			</weapon>
			<weapon id='plap' tip='2' cat='2' skill='4' lvl='2' perk='plasma'>
				<char maxhp='300' damage='20' rapid='12' prec='6' tipdam='6' knock='3' destroy='50'/>
				<char maxhp='300' rapid='10' prec='9'/>
				<phis speed='70' deviation='5' recoil='2' massa='2'/>
				<phis speed='150'/>
				<vis tipdec='15' vbul='plasma1'/> 
				<snd shoot='plap_s' reload='p10mm_r' noise='400'/>
				<sats cons='17'/>
				<ammo holder='40' rashod='4' reload='45'/>
				<ammo holder='60' rashod='3'/>
				<a>batt</a>
				<com worth='3' price='850' chance='0.25' stage='1' uniq='0'/>
				<n>Плазменный пистолет</n>
			</weapon>
			<weapon id='pulsep' tip='2' cat='2' skill='4' lvl='3'>
				<char maxhp='100' damage='40' rapid='15' prec='6' tipdam='8' knock='0' destroy='0'/>
				<phis speed='70' deviation='5' recoil='0' massa='2'/>
				<vis vbul='pulse' flare=''/> 
				<snd shoot='pulse_s' reload='p10mm_r' noise='200'/>
				<sats cons='17'/>
				<ammo holder='40' rashod='4' reload='45'/>
				<a>batt</a>
				<com worth='3' price='1200' chance='0.125' stage='5'/>
				<n>Импульсный пистолет</n>
			</weapon>
			<weapon id='blaster' tip='2' cat='2' skill='4' lvl='5'>
				<char maxhp='500' damage='120' rapid='10' prec='10' tipdam='18' knock='0' destroy='300'/>
				<phis speed='2000' deviation='5' recoil='0' massa='2'/>
				<vis vbul='laser1' spring='2' flare='plasma2' tipdec='12'/> 
				<snd shoot='blaster_s' reload='p10mm_r' noise='500'/>
				<sats cons='20'/>
				<ammo holder='12' rashod='1' reload='45'/>
				<a>bcell</a>
				<com worth='3' price='10000' chance='0' rep='0.12'/>
			</weapon>
			<!-- квестовый-->
			<weapon id='wquest1' tip='2' cat='2' skill='2' lvl='3' perk='pistol' nostand='1'>
				<char maxhp='600' damage='26' rapid='9' prec='10' crit='2' knock='10' destroy='10'/>
				<phis speed='250' m='1' deviation='5' recoil='6' massa='3'/>
				<vis vweap='visp308c' tipdec='2' shell='1'/> 
				<snd shoot='p127_s' reload='p10mm_r' noise='1200'/>
				<sats cons='17'/>
				<ammo holder='12' reload='30'/>
				<a>p308</a>
				<com price='1000' worth='3' chance='0' stage='3'/>
			</weapon>
			
			<weapon id='smg9' tip='2' cat='3' skill='2' lvl='1' perk='pistol'>
				<char maxhp='500' damage='7' rapid='3' prec='6' knock='3' destroy='10'/>
				<phis speed='150' deviation='10' recoil='5' massa='3'/>
				<vis tipdec='1' shell='1'/> 
				<snd shoot='smg10mm_s' reload='p10mm_r' noise='800'/>
				<sats que='4' cons='20'/>
				<ammo holder='24' reload='45'/>
				<a>p9</a>
				<com price='500' worth='3' chance='0.7' stage='1'/>
				<n>9-мм пистолет-пулемёт</n>
			</weapon>
			<weapon id='smg10' tip='2' cat='3' skill='2' lvl='2' perk='pistol'>
				<char maxhp='600' damage='10' rapid='3' prec='6' knock='3' destroy='10'/>
				<phis speed='150' deviation='10' recoil='5' massa='3'/>
				<vis tipdec='1' shell='1'/> 
				<snd shoot='smg10mm_s' reload='p10mm_r' noise='900'/>
				<sats que='4' cons='20'/>
				<ammo holder='24' reload='35'/>
				<a>p10</a>
				<com price='650' worth='3' chance='0.5' stage='1'/>
				<n>10-мм пистолет-пулемёт</n>
			</weapon>
			<weapon id='pp127mm' tip='3' cat='3' skill='2' lvl='4' perk='pistol'>
				<char maxhp='1400' damage='16' rapid='3' prec='7' knock='6' destroy='10'/>
				<char maxhp='1800' damage='17' prec='9'/>
				<phis speed='200' deviation='10' recoil='5' massa='4'/>
				<vis tipdec='1' shell='1'/> 
				<snd shoot='pp127_s' reload='p10mm_r' noise='850'/>
				<sats que='4' cons='20'/>
				<ammo holder='24' reload='30'/>
				<a>p127</a>
				<com price='2450' worth='4' chance='0.25' stage='5' uniq='0.05' rep='0.5'/>
				<n>12,7-мм пистолет-пулемёт</n>
			</weapon>
			
			<weapon id='assr' tip='3' cat='3' skill='2' lvl='2' perk='commando'>
				<char maxhp='800' damage='9' rapid='3' prec='10' knock='3' destroy='10'/>
				<char maxhp='1000' damage='11' prec='11' knock='5'/>
				<phis speed='200' m='2' drot='15' deviation='5' recoil='5' massa='5'/>
				<vis tipdec='1' shell='1'/> 
				<snd shoot='rifle_s' reload='rifle_r' noise='1000'/>
				<sats que='3' cons='25'/>
				<ammo holder='24' reload='40'/>
				<a>p556</a>
				<com price='750' worth='4' chance='1' stage='1' uniq='1'/>
				<n>Штурмовая винтовка</n>
			</weapon>
			<weapon id='carbine' tip='3' cat='3' skill='2' lvl='3' perk='commando'>
				<char maxhp='900' damage='12' rapid='3' prec='13' knock='3' destroy='10'/>
				<char maxhp='1100' damage='13' prec='15'/>
				<phis speed='200' m='2' drot='15' deviation='5' recoil='5' massa='5'/>
				<vis tipdec='1' shell='1'/> 
				<snd shoot='rifle_s' reload='rifle_r' noise='1000'/>
				<dop vision='2'/>
				<sats que='3' cons='25'/>
				<ammo holder='32' reload='40'/>
				<ammo holder='40' reload='30'/>
				<a>p556</a>
				<com price='1900' worth='4' chance='0.5' stage='3' uniq='1' rep='0.5'/>
				<n>Штурмовой карабин</n>
			</weapon>
			<weapon id='zebr' tip='3' cat='3' skill='2' lvl='4' perk='commando'>
				<char maxhp='800' damage='14' rapid='3' prec='16' dkol='3' knock='4' destroy='10'/>
				<char maxhp='1100' damage='16' prec='20'/>
				<phis speed='200' m='2' deviation='2' drot='15' recoil='3' massa='5'/>
				<vis tipdec='1' shell='1' shine='200'/> 
				<snd shoot='zebr_s' reload='rifle_r' noise='200'/>
				<sats que='3' cons='30'/>
				<dop effect='igni' damage='6' ch='1' vision='2'/>
				<dop effect='igni' damage='24'/>
				<ammo holder='24' reload='40'/>
				<a>p556</a>
				<com price='2700' worth='4' chance='0.2' stage='5' rep='0.25' uniq='0'/>
				<n>Зебринская винтовка</n>
			</weapon>
			<weapon id='lmg' tip='3' cat='3' skill='2' lvl='5' perk='commando'>
				<char maxhp='1200' damage='12' rapid='2' prec='12' knock='3' destroy='10'/>
				<char maxhp='1500' damage='14' prec='14'/>
				<phis speed='200' m='2' drot='13' deviation='6' recoil='5' massa='12'/>
				<vis tipdec='1' shell='1'/> 
				<snd shoot='lmg_s' reload='rifle_r' noise='1000'/>
				<sats que='6' cons='25'/>
				<ammo holder='90' reload='60'/>
				<a>p556</a>
				<com price='3500' worth='5' chance='0.5' stage='5' rep='0.25' uniq='0'/>
				<n>Лёгкий пулемёт</n>
			</weapon>
			<weapon id='autor' tip='3' cat='3' skill='2' lvl='5' perk='perf'>
				<char maxhp='900' damage='30' rapid='5' prec='16' knock='6' destroy='10'/>
				<phis speed='300' m='2' drot='12' deviation='4' recoil='7' massa='15'/>
				<vis tipdec='2' shell='1'/> 
				<snd shoot='hmg_s' reload='rifle_r' noise='1000'/>
				<sats que='3' cons='32'/>
				<ammo holder='20' reload='45'/>
				<a>p308</a>
				<com price='2800' worth='5' chance='0.25' stage='7' rep='0.25'/>
				<n>Автоматическая</n>
			</weapon>
			<weapon id='sparkl' tip='3' cat='3' skill='4' lvl='3' perk='laser'>
				<char maxhp='1100' damage='14' rapid='3' prec='16' tipdam='5' dkol='3' destroy='50'/>
				<char maxhp='1200' damage='15' dkol='0'/>
				<phis speed='2000' m='2' drot='15' deviation='3' recoil='2' massa='5'/>
				<vis tipdec='12' vbul='sparkl' spring='2'/> 
				<snd shoot='laser_s' reload='laser_r' noise='500'/>
				<dop effect='blind' ch='0.05'/>
				<sats que='3' cons='25'/>
				<ammo holder='120' rashod='4' reload='45'/>
				<ammo holder='160'/>
				<a>energ</a>
				<com price='1500' worth='4' chance='0.5' stage='5' rep='0.5' uniq='0.6'/>
				<n>Спаркл-пушка</n>
			</weapon>
			<weapon id='plamg' tip='3' cat='3' skill='4' lvl='4' perk='plasma'>
				<char maxhp='1200' damage='17' rapid='4' prec='8' tipdam='6' knock='2' destroy='150'/>
				<char maxhp='1200' damage='18' pier='10'/>
				<phis speed='80' m='2' drot='11' deviation='5' recoil='2' massa='7'/>
				<vis tipdec='16' vbul='plasma2'/> 
				<snd shoot='caster_s' reload='laser_r' noise='500'/>
				<sats que='3' cons='25'/>
				<ammo holder='180' rashod='5' reload='45'/>
				<a>energ</a>
				<com price='2900' worth='4' chance='0.25' stage='5' rep='0.25' uniq='0'/>
				<n>Плазмомёт</n>
			</weapon>
			<weapon id='nova' tip='3' cat='3' skill='4' lvl='4' perk='laser'>
				<char maxhp='1000' damage='25' rapid='6' prec='13' tipdam='5' destroy='150'/>
				<char maxhp='1500' damage='28'/>
				<phis speed='2000' m='2' drot='13' deviation='3' recoil='2' massa='5'/>
				<vis tipdec='12' vbul='laser5' spring='2' flare='laser'/> 
				<snd shoot='laser_s' reload='laser_r' noise='500'/>
				<dop effect='blind' ch='0.1'/>
				<sats que='3' cons='30'/>
				<ammo holder='240' rashod='8' reload='45'/>
				<ammo holder='320'/>
				<a>energ</a>
				<com price='2850' worth='4' chance='0.25' stage='7' rep='0.25' uniq='0.25'/>
				<n>Прибой</n>
			</weapon>
			<weapon id='quick' tip='3' cat='3' skill='4' lvl='5' perk='plasma'>
				<char maxhp='1500' damage='13' rapid='2' prec='10' tipdam='6' knock='2' destroy='150'/>
				<char maxhp='2000' damage='15' prec='11'/>
				<phis speed='80' m='2' drot='11' deviation='5' recoil='2' massa='8'/>
				<vis tipdec='17' vbul='plasma6' flare='laser'/> 
				<snd shoot='quick_s' reload='laser_r' noise='500'/>
				<sats que='6' cons='25'/>
				<ammo holder='160' rashod='4' reload='45'/>
				<ammo holder='200'/>
				<a>energ</a>
				<com price='4200' worth='4' chance='0.1' stage='7' rep='0.15' uniq='0'/>
				<n>Плазмомёт</n>
			</weapon>
			
			<weapon id='oldshot' tip='2' cat='4' skill='2' lvl='1' perk='shot'>
				<char maxhp='150' damage='6' kol='5' rapid='10' prec='6' knock='3' destroy='10'/>
				<char maxhp='250' damage='7' rapid='10' prec='7'/>
				<phis speed='150' m='2' drot='13' deviation='5' recoil='12' massa='5'/>
				<vis tipdec='1' shell='1'/> 
				<snd shoot='oldshot_s' reload='shotgun_r' noise='1200'/>
				<sats cons='32'/>
				<ammo holder='2' reload='45'/>
				<a>p20</a>
				<com price='360' worth='4' chance='1' stage='1' uniq='1'/>
				<n>Старый дробовик</n>
			</weapon>
			<weapon id='lshot' tip='2' cat='4' skill='2' lvl='2' perk='shot'>
				<char maxhp='200' damage='8' kol='5' rapid='15' prec='4' knock='3' destroy='10'/>
				<phis speed='150' m='2' drot='10' deviation='7' recoil='12' massa='4'/>
				<vis tipdec='1' shell='1'/> 
				<snd shoot='oldshot_s' reload='rifle2_r' noise='1200'/>
				<sats cons='32'/>
				<ammo holder='5' reload='60'/>
				<a>p20</a>
				<com price='950' worth='4' chance='1' stage='1'/>
				<n>Рычажный</n>
			</weapon>
			<weapon id='shotgun' tip='2' cat='4' skill='2' lvl='3' perk='shot'>
				<char maxhp='200' damage='9' kol='5' rapid='12' prec='4' knock='3' destroy='10' auto='1'/>
				<char maxhp='300' damage='10' rapid='10' prec='6' auto='1'/>
				<phis speed='150' m='1' drot='15' deviation='7' recoil='12' massa='3'/>
				<vis tipdec='1' shell='1'/> 
				<snd shoot='shotgun_s' reload='shotgun_r' noise='1200'/>
				<sats cons='25'/>
				<ammo holder='2' reload='30'/>
				<a>p20</a>
				<com price='900' worth='3' chance='0.25' stage='1' uniq='0'/>
				<n>Обрез</n>
			</weapon>
			<weapon id='saf9' tip='2' cat='4' skill='2' lvl='4' perk='shot'>
				<char maxhp='350' damage='10' kol='5' rapid='11' prec='7' knock='3' destroy='10' auto='1'/>
				<char maxhp='350' rapid='9' prec='9' knock='5' auto='1'/>
				<phis speed='150' m='1' drot='15' deviation='5' recoil='10' massa='3'/>
				<vis tipdec='1' shell='1'/> 
				<snd shoot='saf9_s' reload='shotgun_r' noise='1200'/>
				<sats cons='25'/>
				<ammo holder='8' reload='45'/>
				<ammo holder='12'/>
				<a>p12</a>
				<com price='3000' worth='4' chance='0.25' stage='5' rep='0.5' uniq='0.5'/>
				<n>Боевой дробовик АФ-9</n>
			</weapon>
			<weapon id='pshot' tip='3' cat='4' skill='2' lvl='5' perk='shot'>
				<char maxhp='300' damage='12' kol='5' rapid='10' prec='7' knock='3' destroy='10' auto='1'/>
				<char maxhp='400' damage='14' prec='9' knock='5' auto='1'/>
				<phis speed='150' m='2' drot='13' deviation='5' recoil='10' massa='4'/>
				<vis tipdec='1' shell='1'/> 
				<snd shoot='pshot_s' reload='shotgun_r' noise='1200'/>
				<sats cons='25'/>
				<ammo holder='12' reload='60'/>
				<ammo reload='30'/>
				<a>p12</a>
				<com price='4200' worth='4' chance='0.15' stage='7' rep='0.2' uniq='0'/>
				<n>Полицейский дробовик</n>
			</weapon>
			<weapon id='prism' tip='3' cat='4' skill='4' lvl='2' perk='laser'>
				<char maxhp='200' damage='8' kol='6' rapid='15' prec='8' tipdam='5' destroy='20'/>
				<char maxhp='250' damage='10' knock='5'/>
				<phis speed='2000' drot='15' deviation='8' recoil='2' massa='6' m='2'/>
				<vis tipdec='12' vbul='laser6' spring='3' flare='laser'/> 
				<snd shoot='prisma_s' reload='laser_r' noise='400'/>
				<dop effect='blind' ch='0.05'/>
				<sats cons='32'/>
				<ammo holder='60' rashod='12' reload='60'/>
				<a>energ</a>
				<com price='1400' worth='4' chance='0.5' stage='5' rep='0.75' uniq='0.7'/>
				<n>Призма</n>
			</weapon>
			<weapon id='cryo' tip='3' cat='4' skill='4' lvl='3'>
				<char maxhp='200' damage='18' kol='5' rapid='20' prec='6' tipdam='11' knock='5' destroy='10'/>
				<phis speed='80' drot='15' deviation='8' recoil='3' massa='10' m='2'/>
				<vis vbul='cryo' flare='' tipdec='18'/> 
				<snd shoot='cryo_s' reload='laser_r' noise='400'/>
				<dop effect='ice' ch='0.2'/>
				<sats cons='32'/>
				<ammo holder='12' rashod='1' reload='45'/>
				<a>pcryo</a>
				<com price='2800' worth='4' chance='0.1' stage='5' rep='0.5'/>
				<n>Криопушка</n>
			</weapon>
			<weapon id='plam' tip='3' cat='4' skill='4' lvl='4' perk='plasma'>
				<char maxhp='200' damage='32' kol='3' rapid='20' prec='6' tipdam='6' knock='8' destroy='150'/>
				<char maxhp='250' damage='38' prec='7'/>
				<phis speed='80' drot='15' deviation='8' recoil='3' massa='10' m='2'/>
				<vis tipdec='15' vbul='plasma'/> 
				<vis tipdec='17' vbul='plasma5' flare='laser'/> 
				<snd shoot='plasma_s' reload='laser_r' noise='400'/>
				<sats cons='32'/>
				<ammo holder='200' rashod='25' reload='60'/>
				<ammo holder='300'/>
				<a>energ</a>
				<com price='3750' worth='4' chance='0.25' stage='5' rep='0.3' uniq='0'/>
				<n>Мультикристальный плазменный дробовик</n>
			</weapon>
			
			<weapon id='oldr' tip='3' cat='5' skill='2' lvl='1' perk='rifle'>
				<char maxhp='100' damage='16' rapid='25' prec='16' crit='1.5' knock='5' destroy='10'/>
				<char maxhp='100' damage='18'/>
				<phis speed='300' drot='15' deviation='3' recoil='10' massa='3' m='2'/>
				<vis tipdec='2' shell='1'/> 
				<snd shoot='hunt_s' reload='rifle2_r' noise='1000'/>
				<sats cons='25'/>
				<ammo holder='2' reload='40'/>
				<a>p32</a>
				<com price='250' worth='3' chance='0.5' stage='1' uniq='0.01'/>
				<n>Старое ружьё</n>
			</weapon>
			<weapon id='hunt' tip='3' cat='5' skill='2' lvl='2' perk='rifle'>
				<char maxhp='200' damage='22' rapid='25' prec='18' crit='1.5' knock='8' destroy='10'/>
				<phis speed='300' drot='15' deviation='2' recoil='10' massa='3' m='2'/>
				<dop probiv='0.3'/>
				<vis tipdec='2' shell='1'/> 
				<snd shoot='hunt_s' reload='rifle2_r'  noise='1000'/>
				<sats cons='25'/>
				<ammo holder='5' reload='50'/>
				<a>p32</a>
				<com price='850' worth='4' chance='1' stage='1'/>
				<n>Охотничья винтовка</n>
			</weapon>
			<weapon id='winchester' tip='3' cat='5' skill='2' lvl='3' perk='rifle'>
				<char maxhp='250' damage='36' rapid='20' prec='16' crit='1.5' knock='12' destroy='10'/>
				<char maxhp='300' damage='38' rapid='16' prec='18'/>
				<phis speed='300' drot='15' deviation='2' recoil='10' massa='4' m='2'/>
				<dop probiv='0.3'/>
				<vis tipdec='2' shell='1'/> 
				<snd shoot='winchester_s' reload='rifle2_r'  noise='1000'/>
				<sats cons='25'/>
				<ammo holder='8' reload='40'/>
				<a>p375</a>
				<com price='1400' worth='4' chance='0.5' stage='3' uniq='1' rep='0.5'/>
				<n>Винтовка ковпони</n>
			</weapon>
			<weapon id='brushgun' tip='3' cat='5' skill='2' lvl='4' perk='rifle'>
				<char maxhp='200' damage='58' rapid='25' prec='16' crit='1.5' knock='18' destroy='30'/>
				<char maxhp='200' damage='64' rapid='20' knock='22'/>
				<phis speed='300' drot='15' deviation='2'  recoil='10' massa='6' m='2'/>
				<dop probiv='0.4'/>
				<vis tipdec='2' shell='1'/> 
				<snd shoot='brushgun_s' reload='rifle2_r' noise='1200'/>
				<sats cons='30'/>
				<ammo holder='5' reload='60'/>
				<a>p44</a>
				<com price='2750' worth='4' chance='0.25' stage='5' uniq='0.5' rep='0.25'/>
				<n>Медвежье</n>
			</weapon>
			<weapon id='rechr' tip='2' cat='2' skill='4' lvl='1' perk='laser'>
				<char maxhp='200' damage='10' rapid='15' prec='12' crit='1.5' tipdam='5' knock='0' destroy='10'/>
				<phis speed='300' deviation='5' recoil='2' massa='4' m='2'/>
				<vis tipdec='11' vbul='blump'/> 
				<snd shoot='laser_s' noise='300'/>
				<sats cons='17'/>
				<ammo holder='20' rashod='1' reload='600' recharg='30'/>
				<a>recharg</a>
				<com price='550' worth='3' chance='0.5' stage='1'/>
				<n>Винтовка с подзарядкой</n>
			</weapon>
			<weapon id='lasr' tip='3' cat='5' skill='4' lvl='2' perk='laser'>
				<char maxhp='350' damage='18' rapid='13' prec='15' crit='1.5' tipdam='5' knock='0' destroy='50'/>
				<char maxhp='450' damage='20' prec='17'/>
				<phis speed='2000' deviation='4' drot='15' recoil='2' massa='5' m='2'/>
				<phis deviation='2'/>
				<vis tipdec='12' vbul='laser' spring='2'/> 
				<snd shoot='laser_s' reload='laser_r' noise='400'/>
				<dop effect='blind' ch='0.15' probiv='0.3'/>
				<sats cons='17'/>
				<ammo holder='60' rashod='4' reload='40'/>
				<ammo holder='120'/>
				<a>energ</a>
				<com price='800' worth='4' chance='0.75' stage='3' rep='0.75' uniq='1'/>
				<n>Лазерная винтовка</n>
			</weapon>
			<weapon id='plar' tip='3' cat='5' skill='4' lvl='3' perk='plasma'>
				<char maxhp='300' damage='44' rapid='20' prec='10' crit='1.5' tipdam='6' knock='10' destroy='300'/>
				<char maxhp='400' rapid='18'/>
				<phis speed='80' drot='15' deviation='8' recoil='2' massa='10' m='2'/>
				<phis speed='120'/>
				<vis tipdec='15' vbul='plasma'/> 
				<snd shoot='plasma_s' reload='laser_r' noise='400'/>
				<dop probiv='0.3'/>
				<sats cons='25'/>
				<ammo holder='100' rashod='10' reload='60'/>
				<ammo holder='120' rashod='8'/>
				<a>energ</a>
				<com price='1550' worth='4' chance='0.35' stage='4' rep='0.5' uniq='0'/>
				<n>Плазменная винтовка</n>
			</weapon>
			<weapon id='pulser' tip='3' cat='5' skill='4' lvl='4'>
				<char maxhp='100' damage='110' rapid='25' prec='8' tipdam='8' knock='0' destroy='0'/>
				<char maxhp='100' rapid='18' prec='9'/>
				<phis speed='70' deviation='5' recoil='0' massa='8' m='2'/>
				<vis vbul='pulse' flare=''/> 
				<snd shoot='pulse_s' reload='laser_r' noise='200'/>
				<sats cons='25'/>
				<ammo holder='200' rashod='20' reload='60'/>
				<ammo holder='300'/>
				<a>energ</a>
				<com worth='4' price='3000' chance='0.1' stage='6' uniq='0.05' rep='0.25'/>
			</weapon>
			<weapon id='termo' tip='3' cat='5' skill='4' lvl='4'>
				<char maxhp='300' damage='58' rapid='14' prec='11' tipdam='3' knock='0' destroy='0'/>
				<char maxhp='300' damage='75' rapid='12' destroy='50'/>
				<phis speed='2000' deviation='5' recoil='0' massa='8' m='2'/>
				<vis vbul='termo' tipdec='11' flare='laser' spring='2'/> 
				<snd shoot='termo_s' reload='laser_r' noise='200'/>
				<dop effect='igni' damage='20' ch='1' probiv='0.4'/>
				<dop effect='igni' damage='36'/>
				<sats cons='25'/>
				<ammo holder='75' rashod='15' reload='60'/>
				<ammo holder='90'/>
				<a>energ</a>
				<com worth='4' price='3000' chance='0.1' stage='5' rep='0.5' uniq='0'/>
			</weapon>
			<weapon id='rail' tip='3' cat='5' skill='4' lvl='5' perk='rifle'>
				<char maxhp='300' damage='66' rapid='15' prec='18' crit='1.5' pier='15' knock='15' destroy='30'/>
				<char maxhp='300' damage='72'/>
				<phis speed='500' drot='6' deviation='4' recoil='10' massa='10' m='2'/>
				<vis tipdec='3' vbul='rail' flare=''/> 
				<snd shoot='rail_s' reload='laser_r'  noise='500'/>
				<dop vision='2' probiv='0.4'/>
				<sats cons='25'/>
				<ammo holder='80' rashod='8' reload='75'/>
				<ammo holder='105' rashod='7' reload='45'/>
				<a>crystal</a>
				<com price='4800' worth='5' chance='0.2' stage='7' rep='0.15' uniq='0.2'/>
				<n>Рельсотрон</n>
			</weapon>
			
			<weapon id='sniper' tip='3' cat='7' skill='2' lvl='3' perk='rifle'>
				<char maxhp='300' damage='40' rapid='24' prec='24' antiprec='8' crit='2' critdam='0.5' knock='10' destroy='10'/>
				<char maxhp='400' rapid='20' prec='28'/>
				<phis speed='500' drot='10' deviation='1' recoil='5' massa='5' m='2'/>
				<vis tipdec='2' shell='1'/> 
				<snd shoot='sniper_s' reload='sniper_r'  noise='1000'/>
				<dop vision='2' probiv='0.4'/>
				<sats cons='40'/>
				<ammo holder='5' reload='60'/>
				<ammo holder='8' reload='45'/>
				<a>p308</a>
				<com price='2200' worth='4' chance='0.3' stage='2' rep='0.5' uniq='0'/>
				<n>Снайперская винтовка</n>
			</weapon>
			<weapon id='lassn' tip='3' cat='5' skill='4' lvl='3' perk='laser'>
				<char maxhp='500' damage='30' rapid='15' prec='24' antiprec='8' crit='2' critdam='0.5' tipdam='5' destroy='50'/>
				<char maxhp='500' damage='40'/>
				<phis speed='2000' drot='10' deviation='1' recoil='1' massa='6' m='2'/>
				<vis tipdec='12' vbul='laser4' spring='2' flare='plasma'/> 
				<snd shoot='laser2_s' reload='laser_r' noise='400'/>
				<dop vision='2' effect='blind' ch='0.3' probiv='0.4'/>
				<sats cons='40'/>
				<ammo holder='80' rashod='8' reload='60'/>
				<a>energ</a>
				<com price='2400' worth='4' chance='0.2' stage='2' rep='0.5' uniq='0'/>
				<n>Лазерная снайперка</n>
			</weapon>
			<weapon id='grom' tip='3' cat='7' skill='4' lvl='5' perk='rifle'>
				<char maxhp='250' damage='76' rapid='20' prec='24' antiprec='8' crit='2' critdam='0.5' tipdam='9' destroy='300'/>
				<char maxhp='250' damage='85' pier='20'/>
				<phis speed='2000' drot='7' deviation='2' massa='10' m='3'/>
				<vis tipdec='12' vbul='laser3' spring='2'/> 
				<snd shoot='grom_s' reload='laser_r' noise='1000'/>
				<dop vision='2' probiv='0.85'/>
				<sats cons='48'/>
				<ammo holder='80' reload='60' rashod='8'/>
				<a>crystal</a>
				<com price='5200' worth='5' chance='0.3' stage='6' rep='0.12' uniq='0'/>
				<n>Грозовая</n>
			</weapon>
			<weapon id='anti' tip='3' cat='7' skill='2' lvl='5' perk='rifle'>
				<char maxhp='250' damage='85' rapid='25' prec='24' antiprec='8' crit='2' critdam='0.5' knock='15' destroy='30'/>
				<char maxhp='300' damage='95' prec='27' pier='10' knock='18'/>
				<phis speed='500' drot='8' deviation='2' recoil='10' massa='10' m='3'/>
				<phis drot='10' deviation='2' recoil='0'/>
				<vis tipdec='3' shell='1'/> 
				<snd shoot='anti_s' reload='sniper_r' noise='1200'/>
				<snd shoot='spitfire_s' noise='2200'/>
				<dop vision='2' probiv='0.6'/>
				<sats cons='55'/>
				<ammo holder='5' reload='60'/>
				<a>p50mg</a>
				<com price='5400' worth='5' chance='0.4' stage='5' rep='0.12' uniq='0'/>
				<n>Антимех-винтовка</n>
			</weapon>
			
			<weapon id='minigun' tip='3' cat='8' skill='2' lvl='4' perk='perf'>
				<char maxhp='3000' damage='7' rapid='1' prec='10' knock='3' prep='32' destroy='10'/>
				<char maxhp='4000' damage='9' prec='12'/>
				<phis speed='200' deviation='5' drot='6' drot2='3' recoil='1' massa='20' m='3'/>
				<vis tipdec='1' shell='1'/> 
				<snd prep='minigun_s' t1='1030' t2='3060' reload='flamer_r' noise='1300'/>
				<sats que='15' cons='25'/>
				<ammo holder='500' reload='60'/>
				<a>p5</a>
				<com price='5000' worth='5' chance='0.5' rep='0.2' stage='3' uniq='0'/>
				<n>Миниган</n>
			</weapon>
			<weapon id='hmg' tip='3' cat='8' skill='2' lvl='5' perk='perf'>
				<char maxhp='1500' damage='18' rapid='2' prec='12' knock='5' destroy='20'/>
				<phis speed='200' drot='6' deviation='5' recoil='5' massa='20' m='3'/>
				<vis tipdec='2' shell='1'/> 
				<snd shoot='hmg_s' reload='rifle_r' noise='1200'/>
				<sats que='6' cons='25'/>
				<ammo holder='90' reload='60'/>
				<a>p127</a>
				<com price='4800' worth='5' chance='0.15' stage='7' rep='0.12'/>
				<n>Станковый</n>
			</weapon>
			<weapon id='antidrak' tip='3' cat='8' skill='2' lvl='5' perk='perf'>
				<char maxhp='600' damage='44' rapid='5' prec='14' knock='8' destroy='50'/>
				<char maxhp='750' damage='50' prec='15' knock='9'/>
				<phis speed='200' drot='5' deviation='5' recoil='8' massa='25' m='3'/>
				<vis tipdec='3' shell='1'/> 
				<snd shoot='antidrak_s' reload='flamer_r' noise='1500'/>
				<sats que='3' cons='32'/>
				<ammo holder='45' reload='60'/>
				<a>p145</a>
				<com price='6000' worth='5' chance='0.05' stage='7' rep='0.12' uniq='0'/>
				<n>Антидракон</n>
			</weapon>
			<weapon id='gatl' tip='3' cat='8' skill='4' lvl='4' perk='laser'>
				<char maxhp='3000' damage='12' rapid='2' prec='8' tipdam='5' knock='0' destroy='20'/>
				<char maxhp='4000' prec='10'/>
				<phis speed='2000' deviation='6' drot='6' drot2='3' massa='20' m='3'/>
				<phis speed='2000' deviation='3' drot='12' drot2='3' massa='15'/>
				<vis tipdec='12' vbul='laser' spring='2'/> 
				<snd prep='gatl_s' t1='100' t2='1500' reload='laser_r' noise='500'/>
				<dop effect='blind' ch='0.05'/>
				<sats que='6' cons='20'/>
				<ammo holder='300' rashod='2' reload='60'/>
				<ammo holder='600'/>
				<a>crystal</a>
				<com price='5000' worth='5' chance='0.3' stage='5' rep='0.25' uniq='0.3'/>
				<n>Лазерный миниган</n>
			</weapon>
			<weapon id='gatp' tip='3' cat='5' skill='4' lvl='5' perk='plasma'>
				<char maxhp='2000' damage='25' rapid='3' prec='8' tipdam='6' knock='3' destroy='100'/>
				<char maxhp='2500' damage='28' prec='10' destroy='150'/>
				<phis speed='80' drot='6' deviation='8' recoil='2' massa='20' m='3'/>
				<phis speed='110' deviation='5'/>
				<vis tipdec='15' vbul='plasma3' flare='plasma'/> 
				<snd prep='gatl_s' t1='100' t2='1500' reload='laser_r' noise='400'/>
				<sats que='6' cons='25'/>
				<ammo holder='1000' rashod='5' reload='60'/>
				<a>crystal</a>
				<com price='6500' worth='4' chance='0.2' stage='5' rep='0.15' uniq='0.2'/>
				<n>Плазменный миниган</n>
			</weapon>
			<weapon id='flamer' tip='3' cat='8' skill='4' lvl='2' perk='pyro'>
				<char maxhp='3000' damage='2.5' rapid='1' pier='10' prec='6' crit='0' tipdam='3' knock='0' destroy='10'/>
				<char maxhp='3500' damage='3' prec='8' pier='12'/>
				<phis speed='40' drot='10' drot2='3' deviation='6' flame='1' massa='10' m='2'/>
				<phis speed='45'/>
				<vis tipdec='11' vbul='flame' bulanim='1'/> 
				<snd prep='flamer_s' t1='1540' t2='2840' reload='flamer_r' noise='400'/>
				<dop effect='igni' damage='10' ch='0.2'/>
				<sats que='10' cons='32'/>
				<ammo holder='200' reload='60'/>
				<a>fuel</a>
				<com price='600' worth='5' chance='1' stage='1' uniq='0.8'/>
				<n>Огнемёт</n>
			</weapon>
			<weapon id='incin' tip='3' cat='8' skill='4' lvl='3' perk='pyro'>
				<char maxhp='300' damage='12' damexpl='20' pier='10' expl='50' rapid='10' prec='6' crit='0' tipdam='3' knock='0' destroy='10'/>
				<phis speed='35' grav='1' drot='5' deviation='4' massa='15' m='2'/>
				<vis tipdec='11' vbul='fireball' visexpl='react'/> 
				<snd shoot='incin_s' reload='flamer_r' noise='400'/>
				<dop effect='igni' damage='15' ch='1'/>
				<sats cons='32'/>
				<ammo holder='360' rashod='12' reload='60'/>
				<a>fuel</a>
				<com price='1400' worth='5' chance='0.6' stage='4' rep='0.5'/>
				<n>Инсинератор</n>
			</weapon>
			<weapon id='cflamer' tip='3' cat='8' skill='4' lvl='5' perk='pyro'>
				<char maxhp='3000' damage='6' rapid='1' pier='16' prec='6' crit='0' tipdam='3' knock='0' destroy='10'/>
				<char maxhp='3600' damage='7' prec='8' pier='20'/>
				<phis speed='40' drot='5' drot2='3' deviation='4' grav='1' massa='20' m='3'/>
				<phis speed='45' drot='8' massa='15'/>
				<vis tipdec='11' vbul='flame' flare='flame' bulanim='1'/> 
				<vis tipdec='11' vbul='flame2' flare='flame' bulanim='1'/> 
				<snd prep='flamer_s' t1='1540' t2='2840' reload='flamer_r' noise='400'/>
				<dop effect='igni' damage='15' ch='0.2'/>
				<dop effect='igni' damage='25' ch='0.2'/>
				<sats que='10' cons='32'/>
				<ammo holder='600' rashod='3' reload='60'/>
				<a>fuel</a>
				<com price='3000' worth='5' chance='0.4' stage='5' rep='0.25' uniq='0'/>
				<n>Боевой огнемёт</n>
			</weapon>
			<weapon id='bfg' tip='3' cat='5' skill='4' lvl='5' perk='plasma'>
				<char maxhp='50' damage='80' damexpl='100' expl='200' rapid='15' prep='30' prec='7' tipdam='6' knock='20' destroy='350' auto='1'/>
				<phis speed='30' drot='6' deviation='5' recoil='12' massa='20' m='3'/>
				<vis tipdec='19' vbul='plasma4' flare='' shine='1000'/> 
				<snd shoot='bfg_s' prep='bfg_p' t2='950' reload='laser_r' noise='400'/>
				<sats noperc='1' cons='60'/>
				<ammo holder='20' rashod='20' reload='30'/>
				<a>crystal</a>
				<com price='2000' worth='5' chance='0' rep='0.2'/>
				<n>BFG</n>
			</weapon>
			
			<weapon id='arson' tip='2' cat='2' skill='3' lvl='0' perk='pyro'>
				<char maxhp='1500' damage='1.6' pier='5' rapid='1' prec='4' crit='0' tipdam='3' destroy='3'/>
				<char maxhp='2000' damage='2' pier='10'/>
				<phis speed='14' deviation='6' flame='2' massa='2'/>
				<vis tipdec='11' vbul='arson' bulanim='1'/> 
				<snd prep='arson_s' t1='990' t2='2270' noise='200'/>
				<dop effect='igni' damage='3' ch='0.1'/>
				<sats que='20' cons='32'/>
				<ammo holder='100' reload='40'/>
				<a>aero</a>
				<com worth='3' price='100' chance='0' rep='2' uniq='0'/>
				<n>Поджигалка</n>
			</weapon>
			<weapon id='dartgun' tip='2' cat='2' skill='3' lvl='1'>
				<char maxhp='100' damage='5' pier='20' rapid='10' prec='8' destroy='0'/>
				<char maxhp='130'/>
				<phis speed='100' deviation='5' massa='2'/>
				<vis vbul='dart' flare='' phisbul='1' spring='0' shine='0'/> 
				<snd shoot='silen_s' noise='50'/>
				<sats cons='18'/>
				<dop effect='poison' damage='10' ch='1'/>
				<dop effect='poison' damage='16' ch='1'/>
				<ammo holder='1' reload='45'/>
				<a>dart</a>
				<com worth='3' price='200' chance='0' rep='2' uniq='0'/>
				<n>Дротикомёт</n>
			</weapon>
			<weapon id='acidgun' tip='2' cat='4' skill='3' lvl='2'>
				<char maxhp='150' damage='7' kol='5' rapid='15' prec='7' tipdam='10' knock='0' destroy='10'/>
				<char maxhp='200' damage='10' prec='8'/>
				<phis speed='100' deviation='7' recoil='10' massa='4' m='2'/>
				<vis tipdec='15' vbul='plevok' shine='100'/> 
				<snd shoot='incin_s' reload='flamer_r' noise='300'/>
				<sats cons='22'/>
				<ammo holder='10' reload='45'/>
				<a>acid</a>
				<com price='500' worth='3' chance='0' uniq='0'/>
				<n>Кислотная пушка</n>
			</weapon>
			<weapon id='sawgun' tip='3' cat='5' skill='3' lvl='3'>
				<char maxhp='100' damage='45' rapid='10' tipdam='1' prec='0' crit='1.5' knock='16' destroy='40'/>
				<char maxhp='130' damage='55' pier='10'/>
				<phis speed='150' drot='15' deviation='5' recoil='10' massa='6' m='2'/>
				<vis vbul='saw' tipdec='5' flare='' phisbul='1' spring='0' shine='100'/> 
				<snd shoot='sawgun_s' noise='700'/>
				<sats cons='25'/>
				<dop probiv='0.7'/>
				<ammo holder='1' reload='30'/>
				<a>saw</a>
				<com worth='3' price='900' chance='0' uniq='0'/>
				<n>Пиломёт</n>
			</weapon>
			<weapon id='buckshot' tip='3' cat='4' skill='3' lvl='4'>
				<char maxhp='50' damage='16' kol='5' rapid='18' prec='6' knock='10' destroy='10'/>
				<char maxhp='70' damage='20'/>
				<phis speed='200' deviation='5' drot='8' recoil='10' massa='11' m='2'/>
				<vis tipdec='1'  shine='100'/> 
				<snd shoot='pshot_s' noise='600'/>
				<sats cons='25'/>
				<ammo holder='2' rashod='2' reload='0'/>
				<a>scrap</a>
				<com price='1400' worth='3' chance='0' rep='0.5' uniq='0'/>
				<n>Картечная пушка</n>
			</weapon>
			<weapon id='railway' tip='3' cat='3' skill='3' lvl='5'>
				<char maxhp='400' damage='30' rapid='6' prec='10' knock='20' destroy='50' auto='1'/>
				<char maxhp='550' damage='36' pier='10'/>
				<phis speed='150' drot='12' deviation='5' recoil='5' massa='8' m='2'/>
				<vis tipdec='3' vbul='spikenail' flare=''/> 
				<snd shoot='railway_s' reload='flamer_r' noise='500'/>
				<sats que='3' cons='35'/>
				<ammo holder='12' reload='45'/>
				<a>spikenail</a>
				<com price='1800' worth='4' chance='0' rep='0.5' uniq='0'/>
				<n>ЖД-винтовка</n>
			</weapon>
			<weapon id='friend' tip='3' cat='3' skill='3' lvl='5'>
				<char maxhp='400' damage='25' rapid='3' prec='16' destroy='50' tipdam='101' dkol='5'/>
				<char maxhp='550' damage='30' prec='20'/>
				<phis speed='2000' drot='12' deviation='3' massa='8' m='2'/>
				<vis tipdec='12' vbul='friend' spring='2' flare='sparkl'/> 
				<snd shoot='laser2_s' reload='laser_r' noise='500'/>
				<dop effect='blind' ch='0.05'/>
				<sats que='5' cons='35'/>
				<ammo holder='100' rashod='5' reload='60'/>
				<a>crystal</a>
				<com price='2000' worth='4' chance='0' rep='0.5' uniq='0'/>
			</weapon>
			
			<!-- взрывчатка -->
			<weapon id='glau1' tip='3' cat='6' skill='5' lvl='2'>
				<char maxhp='50' damage='0' damexpl='120' rapid='20' prec='6' crit='0' tipdam='4' knock='50' destroy='600' expl='150'/>
				<phis speed='35' grav='1' grav2='0' drot='8' deviation='10' recoil='10' massa='10' m='2'/>
				<vis tipdec='9' vbul='gren40' spring='0'/> 
				<snd shoot='glau_s' reload='flamer_r' noise='800'/>
				<sats noperc='1' cons='32'/>
				<ammo holder='1' reload='30'/>
				<a>gren40</a>
				<com price='800' worth='5' chance='1' stage='1' rep='0.5'/>
				<n>Гранатомёт</n>
			</weapon>
			<weapon id='glau' tip='3' cat='6' skill='5' lvl='3'>
				<char maxhp='100' damexpl='120' damage='0' rapid='25' prec='6' crit='0' tipdam='4' knock='50' destroy='600' expl='150'/>
				<char maxhp='140' rapid='15'/>
				<phis speed='35' grav='1' grav2='0' drot='8' deviation='8' recoil='5' massa='10' m='2'/>
				<vis tipdec='9' vbul='gren40' spring='0'/> 
				<snd shoot='glau_s' reload='flamer_r' noise='800'/>
				<sats noperc='1' cons='32'/>
				<ammo holder='6' reload='60'/>
				<ammo holder='10'/>
				<a>gren40</a>
				<com price='2200' worth='5' chance='0.7' stage='3' rep='0.5' uniq='0.4'/>
				<n>Гранатомёт</n>
			</weapon>
			<weapon id='aglau' tip='3' cat='6' skill='5' lvl='4'>
				<char maxhp='200' damage='0' damexpl='130' rapid='12' prec='7' crit='0' tipdam='4' knock='50' destroy='600' expl='150' auto='1'/>
				<phis speed='45' grav='1' grav2='0' drot='8' deviation='8' recoil='5' massa='14' m='2'/>
				<vis tipdec='9' vbul='gren40' spring='0'/> 
				<snd shoot='glau_s' reload='flamer_r' noise='800'/>
				<sats noperc='1' cons='32'/>
				<ammo holder='12' reload='45'/>
				<a>gren40</a>
				<com price='5000' worth='5' chance='0.1' stage='5' rep='0.3'/>
			</weapon>
			<weapon id='mlau' tip='3' cat='6' skill='5' lvl='4'>
				<char maxhp='50' damexpl='250' damage='50' pier='20' rapid='30' prec='9' crit='0' tipdam='4' knock='50' destroy='600' expl='180'/>
				<char maxhp='70' pier='40' prec='12'/>
				<phis speed='15' accel='1' drot='5' deviation='3' recoil='15' massa='20' m='3'/>
				<phis speed='18' deviation='2' recoil='10'/>
				<vis tipdec='9' vbul='rocket' bulanim='1' spring='0' phisbul='1'/> 
				<snd shoot='rocket_s' reload='flamer_r' noise='800'/>
				<sats noperc='1' cons='60'/>
				<ammo holder='1' reload='60'/>
				<a>rocket</a>
				<com price='3500' worth='5' chance='0.3' stage='5' rep='0.3' uniq='0'/>
				<n>Ракетная установка</n>
			</weapon>
			<weapon id='bel' tip='3' cat='6' skill='5' lvl='5'>
				<char maxhp='25' damexpl='800' damage='0' rapid='30' prec='9' crit='0' tipdam='15' knock='150' destroy='5000' expl='270'/>
				<char maxhp='50' rapid='20' prec='13'/>
				<phis speed='40' accel='1' drot='5' deviation='3' recoil='15' massa='20' m='3'/>
				<vis tipdec='9' vbul='baleegg' spring='0' grav='1'/> 
				<snd shoot='glau_s' reload='flamer_r' noise='800'/>
				<sats noperc='1' cons='60'/>
				<ammo holder='1' reload='60'/>
				<ammo holder='1' reload='30'/>
				<a>egg</a>
				<com price='2000' worth='5' chance='0.2' stage='5' rep='0.5' uniq='0'/>
				<n>Яйцемёт</n>
			</weapon>
			
			<weapon id='dinamit' tip='4' cat='9' skill='5' lvl='0'>
				<char rapid='15' damexpl='75' tipdam='4' knock='15' destroy='300' expl='130' time='150'/>
				<phis speed='20' deviation='6'/>
				<vis tipdec='9' icomult='2'/> 
				<snd shoot='dinamit_f'/>
				<sats cons='32'/>
				<n>Динамит</n>
			</weapon>
			<weapon id='hgren' tip='4' cat='9' skill='5' lvl='0'>
				<char rapid='15' damexpl='110' tipdam='4' knock='20' destroy='60' expl='250' time='75'/>
				<phis speed='20' deviation='6'/>
				<vis tipdec='9' icomult='2'/> 
				<sats cons='24'/>
				<snd fall='fall_metal_small'/>
				<n>Самодельная граната</n>
			</weapon>
			<weapon id='grenade' tip='4' cat='9' skill='5' lvl='1'>
				<char rapid='15' damexpl='150' tipdam='4' knock='25' destroy='80' expl='300' time='75'/>
				<phis speed='20' deviation='6'/>
				<vis tipdec='9' icomult='2'/> 
				<sats cons='24'/>
				<snd fall='fall_grenade'/>
				<n>Осколочная граната</n>
			</weapon>
			<weapon id='gasgr' tip='4' cat='9' skill='5' lvl='1'>
				<char rapid='15' damexpl='25' explkol='12' expltip='2' crit='0' tipdam='7' destroy='0' expl='200' time='75'/>
				<phis speed='20' deviation='6'/>
				<vis tipdec='9' icomult='2'/> 
				<sats cons='24'/>
				<snd fall='fall_grenade'/>
				<n>Газовая граната</n>
			</weapon>
			<weapon id='acidgr' tip='4' cat='9' skill='5' lvl='1'>
				<char rapid='15' damexpl='20' explkol='12' crit='0' expltip='3' tipdam='10' destroy='10' expl='200' time='75'/>
				<phis speed='20' deviation='6' bumc='1'/>
				<vis tipdec='19' icomult='2'/> 
				<sats cons='24'/>
				<snd fall='bottle_hit'/>
				<dop effect='acid' damage='8' ch='1'/>
				<n>Пузырёк с кислотой</n>
			</weapon>
			<weapon id='plagr' tip='4' cat='9' skill='5' lvl='2'>
				<char rapid='15' damexpl='225' tipdam='6' knock='10' destroy='300' expl='230' time='75'/>
				<phis speed='20' deviation='6'/>
				<vis tipdec='19' icomult='2'/> 
				<sats cons='24'/>
				<snd fall='fall_grenade'/>
				<n>Плазменная граната</n>
			</weapon>
			<weapon id='impgr' tip='4' cat='9' skill='5' lvl='3'>
				<char rapid='15' damexpl='300' expltip='1' tipdam='8' knock='0' destroy='0' expl='200' time='75'/>
				<phis speed='20' deviation='6'/>
				<vis icomult='2'/> 
				<snd fall='fall_grenade'/>
				<sats cons='24'/>
				<n>Импульсная граната</n>
			</weapon>
			<weapon id='cryogr' tip='4' cat='9' skill='5' lvl='3'>
				<char rapid='15' damexpl='250' tipdam='11' knock='10' destroy='30' expl='230' time='75'/>
				<phis speed='20' deviation='6'/>
				<vis icomult='2'/> 
				<dop effect='ice' ch='1'/>
				<sats cons='24'/>
				<snd fall='fall_metal_small'/>
			</weapon>
			<weapon id='molotov' tip='4' cat='9' skill='5' perk='pyro' lvl='1'>
				<char rapid='25' damexpl='20' explkol='10' tipdam='3' knock='0' destroy='30' expl='150' time='75'/>
				<phis speed='20' deviation='6' bumc='1'/>
				<vis icomult='2'/> 
				<sats cons='24'/>
				<snd fall='bottle_hit'/>
				<dop effect='igni' damage='10' ch='1'/>
				<n>Зажигательный коктейль</n>
			</weapon>
			<weapon id='fgren' tip='4' cat='9' skill='5' perk='pyro' lvl='2'>
				<char rapid='25' damexpl='30' explkol='10' tipdam='3' knock='0' destroy='30' expl='200' time='75'/>
				<phis speed='20' deviation='6'/>
				<vis icomult='2'/> 
				<sats cons='24'/>
				<dop effect='igni' damage='15' ch='1'/>
				<snd fall='fall_grenade'/>
				<n>Огненная бомба</n>
			</weapon>
			<weapon id='spgren' tip='4' cat='9' skill='5' lvl='5'>
				<char rapid='15' damexpl='666' tipdam='4' knock='40' destroy='1000' expl='350' time='75'/>
				<phis speed='20' deviation='6'/>
				<vis tipdec='19' icomult='2' visexpl='sparkle'/> 
				<sats cons='24'/>
				<snd fall='fall_metal_small'/>
				<n>Спаркл граната</n>
			</weapon>
			
			<weapon id='hmine' tip='4' cat='9' skill='5' throwtip='1' sX='30' sY='20' lvl='1'>
				<char rapid='30' maxhp='10' time='15' massafix='70' sens='100' damexpl='125' tipdam='4' knock='25' destroy='80' expl='180'/>
				<phis speed='5'/>
				<vis tipdec='9' icomult='2'/> 
				<snd shoot='mine_s' dem='mine_dem' sens='mine_bip' fall='fall_metal_small'/>
				<sats no='1'/>
				<n>Самодельная мина</n>
			</weapon>
			<weapon id='mine' tip='4' cat='9' skill='5' throwtip='1' sX='30' sY='20' lvl='2'>
				<char rapid='30' maxhp='10' time='15' massafix='100' sens='100' damexpl='170' tipdam='4' knock='25' destroy='80' expl='180'/>
				<phis speed='5'/>
				<vis tipdec='9' icomult='2'/> 
				<snd shoot='mine_s' dem='mine_dem' sens='mine_bip' fall='fall_metal_small'/>
				<sats no='1'/>
				<n>Осколочная мина</n>
			</weapon>
			<weapon id='cryomine' tip='4' cat='9' skill='5' throwtip='1' sX='30' sY='20' lvl='3'>
				<char rapid='30' maxhp='10' time='15' massafix='100' sens='100' damexpl='250' tipdam='11' knock='10' destroy='30' expl='150'/>
				<phis speed='5'/>
				<vis icomult='2'/> 
				<snd shoot='mine_s' dem='mine_dem' sens='mine_bip' fall='fall_metal_small'/>
				<sats no='1'/>
				<n>Криомина</n>
			</weapon>
			<weapon id='plamine' tip='4' cat='9' skill='5' throwtip='1' sX='30' sY='20' lvl='3'>
				<char rapid='30' maxhp='10' time='15' massafix='200' sens='100' damexpl='275' tipdam='6' knock='25' destroy='300' expl='150'/>
				<phis speed='5'/>
				<vis tipdec='19' icomult='2'/> 
				<snd shoot='mine_s' dem='mine_dem' sens='mine_bip' fall='fall_metal_small'/>
				<sats no='1'/>
				<n>Плазменная мина</n>
			</weapon>
			<weapon id='impmine' tip='4' cat='9' skill='5' throwtip='1' sX='30' sY='20' lvl='4'>
				<char rapid='30' maxhp='10' time='15' massafix='200' sens='100' damexpl='325' expltip='1' tipdam='8' knock='25' destroy='0' expl='150'/>
				<phis speed='5'/>
				<vis icomult='2'/> 
				<snd shoot='mine_s' dem='mine_dem' sens='mine_bip' fall='fall_metal_small'/>
				<sats no='1'/>
				<n>Имп мина</n>
			</weapon>
			<weapon id='x37' tip='4' cat='9' skill='5' throwtip='1' sX='30' sY='20' lvl='4'>
				<char rapid='30' maxhp='10' time='15' massafix='200' sens='0' damexpl='350' tipdam='4' knock='25' destroy='1000' expl='150' radio='1'/>
				<phis speed='5'/>
				<vis icomult='2'/> 
				<snd shoot='mine_s' dem='mine_dem' sens='mine_bip' fall='fall_metal_small'/>
				<sats no='1'/>
				<n>Радиомина</n>
			</weapon>
			<weapon id='zebmine' tip='4' cat='9' skill='5' throwtip='1' sX='30' sY='20' lvl='4'>
				<char rapid='30' maxhp='10' time='15' massafix='200' sens='100' damexpl='350' tipdam='4' knock='25' destroy='200' expl='200'/>
				<phis speed='5'/>
				<vis tipdec='9' icomult='2'/> 
				<snd shoot='mine_s' dem='mine_dem' sens='mine_bip' fall='fall_metal_small'/>
				<sats no='1'/>
			</weapon>
			<weapon id='balemine' tip='4' cat='9' skill='5' throwtip='1' sX='30' sY='20' lvl='5'>
				<char rapid='30' maxhp='10' time='15' massafix='200' sens='100' damexpl='750' tipdam='15' knock='25' destroy='5000' expl='300'/>
				<phis speed='5'/>
				<vis tipdec='19' icomult='2'/> 
				<snd shoot='mine_s' dem='mine_dem' sens='mine_bip' fall='fall_metal_small'/>
				<sats no='1'/>
				<n>Плазменная мина</n>
			</weapon>
			
			<weapon id='dbomb' tip='4' cat='9' skill='5' throwtip='2' lvl='2'>
				<char rapid='60' time='90' damexpl='250' tipdam='4' knock='20' destroy='1000' expl='120'/>
				<phis speed='10'/>
				<vis tipdec='9' icomult='2'/> 
				<snd shoot='dinamit_f'/>
				<sats no='1'/>
				<n>Связка динамита</n>
			</weapon>
			<weapon id='bomb' tip='4' cat='9' skill='5' throwtip='2' lvl='3'>
				<char rapid='60' time='90' damexpl='400' tipdam='4' knock='25' destroy='1500' expl='120'/>
				<phis speed='10'/>
				<vis tipdec='9' icomult='2'/> 
				<snd shoot='mine_s'/>
				<sats no='1'/>
				<n>Самодельная бомба</n>
			</weapon>
			<weapon id='exc4' tip='4' cat='9' skill='5' throwtip='2' lvl='5'>
				<char rapid='60' time='90' damexpl='700' tipdam='4' knock='25' destroy='5000' expl='120'/>
				<phis speed='10'/>
				<vis tipdec='9' icomult='2'/> 
				<snd shoot='mine_s'/>
				<sats no='1'/>
				<n>Взрывчатка C-4</n>
			</weapon>
			
			<weapon id='telebul' tip='5' cat='2' skill='7' perslvl='0' mess='telebul'>
				<char damage='15' rapid='16' prec='8' tipdam='2' knock='25' destroy='10'/>
				<phis speed='80' deviation='5'/>
				<vis tipdec='5' vbul='telebullet' loot='telebul'/> 
				<snd shoot='telebul' noise='500'/>
				<sats cons='18'/>
				<ammo magic='150' mana='4'/>
				<com price='100' chance='0' stage='1'/>
			</weapon>
			<weapon id='mbul' tip='5' cat='2' skill='6' perslvl='2'>
				<char damage='8' rapid='6' prec='9' tipdam='6' knock='5' destroy='10'/>
				<char damage='16'/>
				<phis speed='50' deviation='5'/>
				<vis tipdec='16' vbul='mbul' flare='sparkl'/> 
				<snd shoot='plap_s' noise='500'/>
				<sats cons='24' que='3'/>
				<ammo magic='50' mana='2'/>
				<ammo mana='4'/>
				<com price='200' chance='0' stage='1' uniq='0'/>
				<com price='1200'/>
			</weapon>
			<weapon id='ice' tip='5' cat='2' skill='6' perslvl='4'>
				<char damage='5' kol='5' rapid='15' prec='4' tipdam='11' knock='5' destroy='10'/>
				<char damage='10'/>
				<phis speed='70' deviation='6'/>
				<vis vbul='ice'/> 
				<dop effect='ice' ch='0.1'/>
				<snd shoot='ice' noise='300'/>
				<sats cons='32'/>
				<ammo magic='200' mana='5'/>
				<ammo mana='13'/>
				<com price='400' chance='0' stage='1' uniq='0'/>
				<com price='1800'/>
			</weapon>
			<weapon id='dragon' tip='5' cat='2' skill='6' perslvl='6'>
				<char damage='1.8' rapid='1' pier='5' prec='8' crit='0' tipdam='3' destroy='10'/>
				<char damage='3.5' pier='10'/>
				<phis speed='40' deviation='8' flame='2'/>
				<vis tipdec='11' vbul='dflame' flare='flame' bulanim='1'/> 
				<snd prep='arson_s' t1='990' t2='2270' noise='300'/>
				<dop effect='igni' damage='5' ch='0.1'/>
				<sats que='20' cons='32'/>
				<ammo magic='10' mana='0.5'/>
				<ammo mana='1'/>
				<com price='700' chance='0' stage='1' uniq='0'/>
				<com price='2300'/>
			</weapon>
			<weapon id='blades' tip='5' cat='2' skill='6' perslvl='8'>
				<char damage='14' kol='5' rapid='24' prec='6' tipdam='1' knock='5' destroy='10'/>
				<char damage='22'/>
				<phis speed='70' deviation='6' volna='1'/>
				<vis vbul='blade' flare=''/> 
				<snd shoot='blade' noise='300'/>
				<sats cons='32'/>
				<ammo magic='330' mana='20'/>
				<ammo mana='35'/>
				<com price='1100' chance='0' stage='1' uniq='0'/>
				<com price='2800'/>
			</weapon>
			<weapon id='lightning' tip='5' cat='2' skill='6' perslvl='10'>
				<char damage='75' rapid='30' prec='0' tipdam='9' destroy='50'/>
				<char damage='120'/>
				<phis speed='100' deviation='7'/>
				<vis tipdec='11' vbul='lightning' flare='spark' bulanim='1'/> 
				<snd shoot='lightning' noise='800'/>
				<sats cons='32'/>
				<ammo magic='400' mana='30'/>
				<ammo mana='60'/>
				<com price='1500' chance='0' stage='2' uniq='0'/>
				<com price='3500'/>
			</weapon>
			<weapon id='fireball' tip='5' cat='6' skill='6' perslvl='12'>
				<char damexpl='85' damage='0' rapid='24' prec='10' crit='0' tipdam='3' knock='25' destroy='120' expl='100'/>
				<char damexpl='120'/>
				<phis speed='75' deviation='3'/>
				<vis tipdec='11' vbul='fireball' flare=''/> 
				<dop effect='igni' damage='15' ch='1'/>
				<snd shoot='fireball' noise='800'/>
				<sats cons='60'/>
				<ammo magic='500' mana='40'/>
				<ammo mana='75'/>
				<com price='2000' chance='0' stage='3' uniq='0'/>
				<com price='4500'/>
			</weapon>
			<weapon id='mray' tip='5' cat='5' skill='6' perslvl='14'>
				<char damage='4' rapid='1' prec='15' prep='18' tipdam='5' destroy='10'/>
				<char damage='6'/>
				<phis speed='2000' deviation='1' drot2='3'/>
				<vis tipdec='12' vbul='mray' spring='2' flare='plasma'/> 
				<snd prep='mray' t1='2540' t2='3040' noise='400'/>
				<sats que='10' cons='20'/>
				<ammo magic='25' mana='1.5'/>
				<ammo mana='2.5'/>
				<com price='2500' chance='0' stage='3' uniq='0'/>
				<com price='5500'/>
			</weapon>
			<weapon id='defwave' tip='5' cat='2' skill='6' perslvl='16'>
				<char damage='75' rapid='25' prec='0' knock='25' tipdam='4' destroy='300'/>
				<char damage='115'/>
				<phis speed='50' deviation='3'/>
				<vis tipdec='5' vbul='defwave' flare=''/> 
				<snd shoot='wavedef' noise='800'/>
				<dop probiv='0.7'/>
				<sats cons='32'/>
				<ammo magic='300' mana='30'/>
				<ammo mana='55'/>
				<com price='3000' chance='0' stage='2' uniq='0'/>
				<com price='6500'/>
			</weapon>
			<weapon id='eclipse' tip='5' cat='6' skill='6' perslvl='18'>
				<char damexpl='150' damage='0' rapid='40' prec='0' crit='0' tipdam='6' knock='25' destroy='300' expl='150'/>
				<char damexpl='200'/>
				<phis speed='35' deviation='5'/>
				<vis tipdec='19' vbul='eclipse' spring='0' visexpl='eclipse'/> 
				<snd shoot='plasma_s' noise='800'/>
				<sats noperc='1' cons='60'/>
				<ammo magic='800' mana='120'/>
				<ammo mana='160'/>
				<com price='4000' chance='0' stage='3' uniq='0'/>
				<com price='7500'/>
			</weapon>
			<weapon id='dray' tip='5' cat='5' skill='6' perslvl='20'>
				<char damage='90' rapid='20' prec='20' tipdam='16' destroy='0'/>
				<phis speed='2000' deviation='0'/>
				<vis vbul='dray' spring='2'/> 
				<dop probiv='0.5'/>
				<snd shoot='dray' noise='400'/>
				<sats cons='40'/>
				<ammo magic='500' mana='50'/>
				<com price='5000' chance='0' stage='3'/>
			</weapon>
			<weapon id='udar' tip='5' cat='2' skill='7' perslvl='22'>
				<char damage='28' kol='5' rapid='24' prec='6' tipdam='2' knock='15' destroy='10'/>
				<phis speed='80' deviation='5'/>
				<vis tipdec='5' vbul='telebullet' vweap='vistelebul'/> 
				<snd shoot='telebul' noise='800'/>
				<sats cons='32'/>
				<ammo magic='400' mana='40'/>
				<com price='6000' chance='0' stage='3'/>
			</weapon>
			<weapon id='skybolt' tip='5' cat='2' skill='6' perslvl='24'>
				<char damage='30' rapid='6' prec='8' tipdam='18' knock='5' destroy='30'/>
				<phis speed='70' deviation='5'/>
				<vis tipdec='12' flare='plasma2' vbul='skybolt'/> 
				<snd shoot='plap_s' noise='500'/>
				<sats cons='24' que='3'/>
				<ammo magic='150' mana='10'/>
				<com price='7000' chance='0' stage='1'/>
			</weapon>
			
			<weapon id='test' tip='2' cat='2' skill='2' lvl='0' nostand='1'>
				<char maxhp='200000' damage='1000' tipdam='0' rapid='10' prec='25' knock='2' destroy='300'/>
				<phis speed='200' deviation='5' recoil='10' massa='2'/>
				<vis tipdec='1'/> 
				<dop vision='2' probiv='0.5'/>
				<snd shoot='p10mm_s' noise='10'/>
				<sats cons='18'/>
				<ammo holder='100' reload='30'/>
				<a>p32</a>
				<com price='10' worth='3' chance='0' rep='2'/>
				<n>Тестовый</n>
			</weapon>
			
			<weapon id='a_melee' tip='1' cat='1' skill='1' lvl='5' nostand='1' alicorn='1'>
				<char maxhp='1000' damage='60' rapid='10' crit='2' tipdam='1' knock='5' destroy='10'/>
				<phis massa='5' m='0' minlong='70' long='140'/>
				<vis tipdec='4'/>
				<snd shoot='m_large' noise='300'/>
				<sats no='1'/>
				<com price='1000'/>
			</weapon>
			<weapon id='a_fire' tip='3' cat='3' skill='2' lvl='5' nostand='1' alicorn='1'>
				<char maxhp='100000' damage='11' rapid='2' prec='12' knock='3' destroy='100'/>
				<phis speed='200' drot='10' deviation='5' recoil='3' massa='12' m='0'/>
				<vis tipdec='1'/> 
				<snd shoot='lmg_s' reload='rifle_r' noise='1000'/>
				<sats no='1'/>
				<ammo holder='90' reload='60'/>	<a>not</a>
				<com price='1000'/>
			</weapon>
			<weapon id='a_energ' tip='3' cat='3' skill='4' lvl='5' nostand='1' alicorn='1'>
				<char maxhp='100000' damage='16' rapid='3' prec='12' tipdam='6' knock='2' destroy='150'/>
				<phis speed='150' drot='11' deviation='5' recoil='2' massa='12' m='0'/>
				<vis tipdec='16' vbul='plasma2'/> 
				<snd shoot='quick_s' reload='laser_r' noise='500'/>
				<sats no='1'/>
				<ammo holder='30' reload='30'/>	<a>not</a>
				<com price='1000'/>
			</weapon>
			<weapon id='a_expl' tip='3' cat='6' skill='5' lvl='5' nostand='1' alicorn='1'>
				<char maxhp='100000' damage='0' damexpl='50' rapid='7' prec='6' crit='0' tipdam='4' knock='50' destroy='600' expl='150' expltip='1'  auto='1'/>
				<phis speed='25' accel='2' drot='10' drot2='5' deviation='20' recoil='5' massa='20' m='0'/><!--  navod='5'-->
				<vis tipdec='9' vbul='gren50' spring='0' phisbul='1'/> 
				<snd shoot='glau_s' reload='flamer_r' noise='800'/> 
				<sats no='1'/>
				<ammo holder='10' reload='90'/>	<a>not</a>
				<com price='1000'/>
			</weapon>
			<weapon id='a_magic' tip='5' cat='2' skill='6' perslvl='28' nostand='1' alicorn='1'>
				<char damage='38' rapid='8' prec='12' tipdam='18' knock='5' destroy='30'/>
				<phis speed='140' deviation='10'/>
				<vis tipdec='12' flare='plasma2' vbul='sel'/> 
				<snd shoot='plap_s' noise='500'/>
				<sats no='1'/>
				<ammo magic='0' mana='7'/>
				<com price='1000'/>
			</weapon>
			
			
			<weapon id='paint' tip='0'>
				<phis massa='1'/>
				<sats no='1'/>
			</weapon>
			
	<!--       *******   Боеприпасы   *******         -->
			
			<!-- патроны -->
			<!-- модификаторы
				mod - тип модификации, 1-бронебойный, 2-экспансивный, 
				damage - множитель урона
				pier - прибавка к бронебойности
				armor - множитель брони цели
				knock - множитель отбрасывания
				prec - множитель точности
				det='1' - прибавка к износу оружия
				fire - зажигательный
				tipdam - изменение типа урона
			-->
			<item base='p9' id='p9'	 tip='a' kol='12' chance='1.2' stage='1' lvl='0' price='1.5' sell='0.3' m='1'/>
			
			<item base='p32' id='p32' tip='a' kol='5' chance='1.2' stage='1' lvl='0' price='2.5' sell='0.5' m='1'/>
			<item base='p32' id='p32_1' tip='a' kol='5' chance='0.5' stage='2' lvl='1' price='3.5' sell='0.7' mod='1' pier='10' knock='0.8' damage='0.9' m='1'/>
			<item base='p32' id='p32_2' tip='a' kol='5' chance='0.5' stage='2' lvl='1' price='3.5' sell='0.7' mod='2' armor='3' damage='1.5' m='1'/>
			
			<item base='p10' id='p10'	 tip='a' kol='12' chance='1.2' stage='1' lvl='0' price='2.5' sell='0.5' m='1'/>
			<item base='p10' id='p10_1'	 tip='a' kol='12' chance='0.6' stage='2' lvl='1' price='3.5' sell='0.7' mod='1' pier='15' knock='0.8' damage='0.9' m='1'/>
			
			<item base='p375' id='p375'	 tip='a' kol='6' chance='0.55' stage='3' lvl='1' price='6' sell='1.2' m='2'/>
			<item base='p375' id='p375_1'	 tip='a' kol='6' chance='0.3' stage='3' lvl='2' price='8' sell='1.8' m='2' mod='1' pier='20' probiv='0.2' knock='0.8' damage='0.9'/>
			<item base='p375' id='p375_2'	 tip='a' kol='6' chance='0.25' stage='3' lvl='2' price='9' sell='1.8' m='2' mod='2' armor='4' probiv='-1' damage='1.6'/>
			
			<item base='p44' id='p44'	 tip='a' kol='6' chance='0.4' stage='3' lvl='3' price='9' sell='1.8' m='3'/>
			<item base='p44' id='p44_1'	 tip='a' kol='6' chance='0.25' stage='4' lvl='3' price='12' sell='2.4' m='3' mod='1' pier='40' probiv='0.2' knock='0.8' damage='0.95'/>
			<item base='p44' id='p44_2'	 tip='a' kol='6' chance='0.2' stage='4' lvl='3' price='12' sell='2.4' m='3' mod='2' armor='4' probiv='-1' damage='1.6'/>
			
			<item base='p127' id='p127'	 tip='a' kol='12' chance='0.55' stage='3' lvl='3' price='6' sell='1.2' m='2'/>
			<item base='p127' id='p127_1'	 tip='a' kol='12' chance='0.2' stage='4' lvl='3' price='9' sell='1.8' m='2' mod='1' pier='40' probiv='0.2' knock='0.8' damage='0.95'/>
			<item base='p127' id='p127_2'	 tip='a' kol='12' chance='0.25' stage='4' lvl='3' price='9' sell='1.8' m='2' mod='2' armor='4' damage='1.6' knock='1.2'/>
			
			<item base='p145' id='p145'	 tip='a' kol='30' chance='0.25' stage='7' lvl='4' price='18' sell='4' m='4'/>
			
			<item base='p308' id='p308'	 	tip='a' kol='5' chance='0.5' stage='3' lvl='3' price='6' sell='1.2' m='2'/>
			<item base='p308' id='p308_1'	tip='a' kol='5' chance='0.25' stage='4' lvl='4' price='11' sell='2' m='2' mod='1' pier='50' probiv='0.2' knock='0.8' damage='0.95'/>
			<item base='p308' id='p308_2'	tip='a' kol='5' chance='0.2' stage='4' lvl='4' price='12' sell='2' m='2' mod='2' armor='5' probiv='-1' damage='1.6'/>
			
			<item base='p50mg' id='p50mg'	tip='a' kol='5' chance='0.3' stage='5' lvl='4' price='15' sell='3' m='4' pier='10'/>
			<item base='p50mg' id='p50mg_1'	tip='a' kol='5' chance='0.2' stage='5' lvl='4' price='20' sell='4' m='4' mod='1' pier='70' probiv='0.2' damage='0.95' knock='0.8'/>
			<item base='p50mg' id='p50mg_4'	tip='a' kol='5' chance='0.15' stage='5' lvl='4' price='20' sell='4' m='4' mod='4' pier='10' fire='8'/>
			
			<item base='p556' id='p556'	 tip='a' kol='24' chance='1' stage='2' lvl='2' price='2.5' sell='0.5' m='1'/>
			<item base='p556' id='p556_1'	 tip='a' kol='24' chance='0.5' stage='2' lvl='2' price='5' sell='1' m='1' mod='1' pier='30' knock='0.8' damage='0.9'/>
			<item base='p556' id='p556_2'	 tip='a' kol='24' chance='0.5' stage='2' lvl='2' price='4.5' sell='0.9' m='1' mod='2' armor='3' damage='1.6'/>
			<item base='p556' id='p556_5'	 tip='a' kol='24' chance='0.2' stage='3' lvl='4' price='5' sell='1' m='1' mod='5' pier='15' damage='0.9' tipdam='6'/>
			
			<item base='p5' id='p5'	 tip='a' kol='100' chance='0.8' stage='3' lvl='3' price='1' sell='0.2' m='0.5' pier='10'/>
			<item base='p5' id='p5_1'	 tip='a' kol='100' chance='0.4' stage='3' lvl='4' price='2' sell='0.4' m='0.5' mod='1' pier='40' knock='0.8' damage='0.9'/>
			
			<item base='p20' id='p20'	 tip='a' kol='8' chance='1' stage='1' lvl='1' price='8' sell='1' m='3'/>
			<item base='p12' id='p12'	 tip='a' kol='8' chance='1' stage='3' lvl='3' price='12' sell='2' m='3'/>
			<item base='p12' id='p12_3'	 tip='a' kol='8' chance='0.3' stage='5' lvl='3' price='16' sell='3' m='3' mod='3' pier='30' knock='0.6'/>
			<item base='p12' id='p12_4'	 tip='a' kol='8' chance='0.3' stage='5' lvl='4' price='18' sell='3.5' m='3' mod='4' fire='10'/>
			<item base='p12' id='p12_5'	 tip='a' kol='8' chance='0.25' stage='5' lvl='4' price='20' sell='4' m='3' mod='5' pier='15' tipdam='6'/>
			
			<item base='batt' id='batt' tip='a' kol='20' chance='1' stage='1' lvl='0' price='1' sell='0.2' m='0.3'/>
			<item base='batt' id='batt_6' tip='a' kol='20' chance='0.3' stage='1' lvl='1' price='2' sell='0.4' m='0.5' mod='6' pier='15' damage='1.4' det='1'/>
			<item base='energ' id='energ' tip='a' kol='50' chance='0.9' stage='3' lvl='1' price='1' sell='0.2' m='0.3'/>
			<item base='energ' id='energ_6' tip='a' kol='50' chance='0.3' stage='3' lvl='2' price='2' sell='0.4' m='0.5' mod='6' pier='25' damage='1.5' det='1'/>
			<item base='crystal' id='crystal' tip='a' kol='100' chance='0.75' stage='5' lvl='3' price='2.5' sell='0.5' m='0.5'/>
			<item base='crystal' id='crystal_6' tip='a' kol='100' chance='0.25' stage='5' lvl='4' price='5' sell='1' m='0.7' mod='6' pier='40' damage='1.5' det='1'/>
			
			<item base='fuel' id='fuel' tip='a' kol='100' chance='0.5' stage='3' lvl='3' price='0.7' sell='0.1' m='0.3'/>
			<item base='fuel' id='fuel_7' tip='a' kol='100' chance='0.16' stage='3' lvl='4' price='1.2' sell='0.2' m='0.3' mod='7' armor='0.2' damage='1.25'/>
			<item id='bcell' tip='a' lvl='4' kol='12' chance='0.1' stage='7' price='50' sell='12' m='0.3'/>
			
			<item base='gren40' id='gren40' tip='a' kol='3' chance='0.5' stage='2' lvl='3' price='25' sell='5' m='8'/>
			<item base='gren40' id='gren40_8' tip='a' kol='3' chance='0.2' stage='5' lvl='3' price='40' sell='8' m='8' mod='8' damage='1.25' tipdam='6'/>
			<item base='gren40' id='gren40_9' tip='a' kol='3' chance='0.15' stage='5' lvl='3' price='50' sell='10' m='8' mod='9' damage='1.5' tipdam='8'/>
			
			<item id='rocket' tip='a' kol='1' chance='0.5' stage='5' lvl='4' price='75' sell='15' m='20'/>
			<item id='egg' tip='a' kol='1' chance='0.15' stage='7' lvl='4' price='600' sell='120' m='20'/>
			<item id='recharg' tip='a' chance='0' invis='1'/>
			<item id='not' tip='a' chance='0' invis='1'/>
			
			<item id='aero' tip='compw' chance='0.5' kol='100' price='0.3' m='0.1' fc='3'/>
			<item id='dart' tip='compw' chance='0.3' lvl='1' kol='8' price='5' sell='1' fc='3' m='1'/>
			<item id='saw' tip='compw' chance='0.5' stage='3' lvl='2' kol='5' price='10' sell='2' fc='3' m='5'/>
			<item id='acid' tip='compw' chance='0.65' stage='3' lvl='2' kol='5' price='10' sell='2' fc='3' m='1.5'/>
			<item id='pcryo' tip='compw' chance='0.1' stage='5' lvl='3' kol='10' price='10' sell='2' fc='3' m='1.5'/>
			<item id='spikenail' tip='compw' chance='0.5' stage='5' lvl='3' kol='10' price='5' sell='1' fc='3' m='2'/>
			
			<!-- взрывчатка -->
			<item id='dinamit' tip='e' chance='0.8' stage='1' lvl='1' price='25' sell='5' m='5'/>
			<item id='hgren' tip='e' chance='1' stage='1' lvl='1' price='30' sell='6' m='8'/>
			<item id='molotov' tip='e' chance='1' stage='1' lvl='1' price='20' sell='4' m='8'/>
			<item id='grenade' tip='e' chance='1' stage='2' lvl='2' price='50' sell='10' m='10'/>
			<item id='gasgr' tip='e' chance='0.3' stage='3' lvl='2' price='60' sell='12' m='10'/>
			<item id='acidgr' tip='e' chance='0' stage='3' lvl='2' price='60' sell='12' m='10'/>
			<item id='fgren' tip='e' chance='0.75' stage='3' lvl='2' price='50' sell='10' m='10'/>
			<item id='plagr' tip='e' chance='0.7' stage='3' lvl='3' price='100' sell='20' m='10'/>
			<item id='impgr' tip='e' chance='0.5' stage='5' lvl='3' price='100' sell='20' m='10'/>
			<item id='cryogr' tip='e' chance='0' stage='5' lvl='3' price='100' sell='20' m='10'/>
			<item id='spgren' tip='e' chance='0.1' stage='7' lvl='4' price='250' sell='50' m='10'/>
			<item id='hmine' tip='e' chance='0.3' stage='2' lvl='2' price='40' sell='5' m='10'/>
			<item id='mine' tip='e' chance='0.25' stage='2' lvl='2' price='60' sell='10' m='12'/>
			<item id='plamine' tip='e' chance='0.2' stage='3' lvl='4' price='150' sell='20' m='12'/>
			<item id='impmine' tip='e' chance='0.25' stage='5' lvl='4' price='180' sell='25' m='12'/>
			<item id='cryomine' tip='e' chance='0' stage='5' lvl='3' price='250' sell='50' m='12'/>
			<item id='zebmine' tip='e' chance='0' stage='7' lvl='4' price='150' sell='20' m='12'/>
			<item id='balemine' tip='e' chance='0.05' stage='7' lvl='4' price='600' sell='120' m='20'/>
			<item id='x37' tip='e' chance='0.3' stage='7' lvl='2' price='200' sell='40' m='10'/>
			<item id='dbomb' tip='e' chance='0.5' stage='3' lvl='2' price='100' sell='20' m='16'/>
			<item id='bomb' tip='e' chance='0.3' stage='3' lvl='3' price='200' sell='40' m='16'/>
			<item id='exc4' tip='e' chance='0.15' stage='5' lvl='4' price='500' sell='100' m='25'/>
			
	<!--       *******   Снаряжение   *******         -->

			<item id='money' tip='money' fall='fall_caps' fc='2'/>
			
			<!--       Медикаменты         -->
			<item id='pot1'		tip='med' sort='0' chance='1.8' 		stage='1' us='2' heal='hp'	 hhp='40' hhplong='60' horgans='20' hblood='20' price='50' sell='10' m='1' fall='fall_potion' uses='pot_use'/>
			<item id='pot2' 	tip='med' sort='2' chance='1.2' 	stage='2' us='2' heal='hp'	 hhp='60' hhplong='140' horgans='30' hblood='35' price='90' sell='15' m='2' fall='fall_potion' uses='pot_use'/>
			<item id='pot3' 	tip='med' sort='3' chance='0.6' 	stage='3' us='2' heal='hp'	 hhp='100' hhplong='400' horgans='60' hblood='50' price='160' sell='20' m='3' fall='fall_potion' uses='pot_use'/>
			<item id='antiradin' 	tip='med' sort='6' chance='0.5' 	stage='1' us='2' heal='rad'	 hrad='200' price='130' sell='20' m='1'/>
			<item id='pot0'		tip='med' sort='4' chance='1' 		stage='1' us='2' heal='cut'	 hhp='25' hcut='5' price='25' sell='5' m='0.5'/>
			<item id='potm1' 	tip='med' sort='5' chance='0.5' 	stage='1' us='2' heal='mana'	hmana='200' price='300' sell='30' m='1' fall='fall_potion' uses='pot_use'/>
			<item id='potm2' 	tip='med' sort='5' chance='0.2' 	stage='3' us='2' heal='mana'	hmana='400' price='500' sell='50' m='2' fall='fall_potion' uses='pot_use'/>
			<item id='potm3' 	tip='med' sort='5' chance='0.1' 	stage='3' us='2' heal='mana'	hmana='800' price='800' sell='80' m='3' fall='fall_potion' uses='pot_use'/>
			<item id='antidote' tip='med' sort='7' chance='0.3' 	stage='1' us='2' heal='poison'	hpoison='10' effect='antidote' price='50' sell='10' m='1' fall='fall_potion' uses='pot_use'/>
			<item id='firstaid'	tip='med' sort='21' chance='0' 		stage='3' us='1' heal='organ'	horgan='150' minmed='2' price='150' sell='15' m='1'/>
			<item id='doctor'	tip='med' sort='22' chance='0' 		stage='3' us='1' heal='organ'	horgan='400' minmed='3' price='300' sell='30' m='2'/>
			<item id='surgeon'	tip='med' sort='23' chance='0' 		stage='5' us='1' heal='organ'	horgan='1000' minmed='4' price='600' sell='60' m='3'/>
			<item id='bloodpak'	tip='med' sort='20' chance='0.5' 	stage='3' us='1' heal='blood'	hblood='150' minmed='1' price='50' sell='5' m='1'/>
			<item id='detoxin'	tip='med' sort='24' chance='0.2' 	stage='3' us='1' heal='detoxin'	hpoison='50' detox='250' price='300' sell='50' m='1'/>
			<item id='radx'		tip='med' sort='8' chance='0.5' 	stage='3' us='1' effect='radx' price='75' sell='15' m='1'/>

			<!--       Химия         -->
			<item id='mint'	tip='him' chance='1' stage='3' us='2' effect='mint'	price='200' sell='20' m='1' ad='post_mint' admin='10' admax='30'/>
			<item id='pmint'	tip='him' chance='0.25' stage='3' us='2' effect='pmint'	price='500' sell='50' m='1' ad='post_mint' admin='30' admax='60'/>
			<item id='dash'	tip='him' chance='1' stage='2' us='2' effect='dash'	price='150' sell='15' m='1' ad='post_dash' admin='10' admax='30'/>
			<item id='rage'	tip='him' chance='1' stage='2' us='2' effect='rage'	price='130' sell='15' m='1' ad='post_rage' admin='5' admax='25'/>
			<item id='medx'	tip='him' chance='2' stage='1' us='2' effect='medx'	price='100' sell='10' m='1' ad='post_medx' admin='5' admax='25'/>
			<item id='stampede'	tip='him' chance='0.3' stage='3' us='2' effect='stampede'	price='200' sell='20' m='1' ad='post_stampede' admin='15' admax='40'/>
			<item id='buck'	tip='him' chance='1' stage='2' us='2' effect='buck'	price='100' sell='10' m='1' ad='post_buck' admin='5' admax='25'/>
			<item id='ultradash'	tip='him' chance='0.2' stage='3' us='2' effect='ultradash'	price='300' sell='30' m='1' ad='post_dash' admin='30' admax='60'/>
			<item id='hydra'	tip='him' chance='0.25' stage='3' us='2' effect='hydra'	price='400' sell='40' m='3'/>

			<!--       Зебринские зелья         -->
			<item id='potion_stim'	tip='pot' chance='0' us='2' hhp='400' hpoison='-10' sell='30' m='1' 	price='150' uses='pot_use'/>
			<item id='potion_fly'	tip='pot' chance='0' us='2' effect='potion_fly' sell='100' m='3' 	price='440' uses='pot_use'/>
			<item id='potion_shadow'	tip='pot' chance='0' us='2' effect='potion_shadow' sell='60' m='3' 	price='300' uses='pot_use'/>
			<item id='potion_mage'	tip='pot' chance='0' us='2' effect='potion_mage' sell='40' m='1' 	price='200' uses='pot_use'/>
			<item id='potion_infra'	tip='pot' chance='0' us='2' effect='potion_infra' sell='50' m='2' 	price='250' uses='pot_use'/>
			<item id='potion_swim'	tip='pot' chance='0' us='2' effect='potion_swim' sell='30' m='1' 	price='150' uses='pot_use'/>
			<item id='potion_pink'	tip='pot' chance='0' us='2' effect='potion_pink' sell='50' m='2' 	price='250' uses='pot_use'/>
			<item id='potion_chance'	tip='pot' chance='0' us='2' effect='potion_chance' sell='100' m='3' 	price='500' uses='pot_use'/>
			<item id='potion_purif'	tip='pot' chance='0' us='2' hpurif='1' sell='80' 	price='400' m='3' uses='pot_use'/>
			<item id='potion_rat'	tip='pot' chance='0' us='2' rad='5' effect='potion_rat' m='0' uses='pot_use' inf='1'/>
			<item id='rollup'	tip='pot' chance='0' us='1' sell='10' m='0.2' price='50'/>

			<item id='potion_dskel'	tip='pot' chance='0' us='1' perk='potion_dskel' maxperk='5' sell='400' m='3' price='1000' uses='pot_use'/>
			<item id='potion_might'	tip='pot' chance='0' us='1' perk='potion_might' maxperk='5' sell='400' m='3' price='1000' uses='pot_use'/>
			<item id='potion_immun'	tip='pot' chance='0' us='1' perk='potion_immun' maxperk='5' sell='400' m='3' price='1000' uses='pot_use'/>
			<item id='potion_speed'	tip='pot' chance='0' us='1' perk='potion_speed' maxperk='5' sell='400' m='3' price='1000' uses='pot_use'/>
			<item id='potion_prec'	tip='pot' chance='0' us='1' perk='potion_prec' maxperk='5' sell='400' m='3' price='1000' uses='pot_use'/>
			<item id='potion_elements'	tip='pot' chance='0' us='1' perk='potion_elements' maxperk='5' sell='400' m='3' price='1000' uses='pot_use'/>
			<item id='potion_dexter'	tip='pot' chance='0' us='1' perk='potion_dexter' maxperk='5' sell='400' m='3' price='1000' uses='pot_use'/>
			<item id='potion_crit'	tip='pot' chance='0' us='1' perk='potion_crit' maxperk='5' sell='400' m='3' price='1000' uses='pot_use'/>
			<item id='potion_consc'	tip='pot' chance='0' us='1' perk='potion_consc' maxperk='2' m='3' price='10000' uses='pot_use'/>
			
			<item id='potHP' 			tip='pot' chance='0' stage='2' us='1' perk='life' maxperk='40'	limit='potHP' mlim='1.2' price='1000' sell='400' m='3' fall='fall_potion' uses='pot_use' mess='potHP'/>
			<item id='potMP' 			tip='pot' chance='0' stage='3' us='1' perk='spirit' maxperk='30' limit='potMP' mlim='1' price='1500' sell='600' m='3' fall='fall_potion' uses='pot_use'/>

			<!--       Едьба  (ftip=1 - напиток)   food-выпадает из контейнеров, eda-выпадает из рейдеров     -->
			<item id='radcookie' 	tip='food' sort='4' ftip='0' us='2' chance='0.6' heal='pet' pet='phoenix' hpet='200' stage='3' price='20' sell='5' m='1'/>
			<item id='sparklecola' 	tip='food' sort='3' ftip='1' us='1' chance='1' hmana='40' stage='1' price='40' sell='10' m='2'/>
			<item id='radcola' 		tip='food' sort='3' ftip='1' us='1' chance='0.1' hmana='100' rad='10' stage='5' price='120' sell='20' m='4'/>
			<item id='sars' 		tip='food' sort='3' ftip='1' us='1' chance='1' hhplong='50' stage='1' price='20' sell='4' m='2'/>
			<item id='coffee' 		tip='food' sort='3' ftip='1' us='1' chance='0' stage='1' price='50' sell='10' effect='coffee' m='2'/>
			<item id='milk' 		tip='food' sort='3' chance='0' tip2='eda' chance2='1' ftip='1' us='1' stage='1' hrad='50' price='40' sell='8' m='2'/>
			<item id='beer' 		tip='food' sort='3' tip2='eda' ftip='1' us='1' chance='0.2' chance2='2' alc='5' stage='1' price='20' sell='4' m='2'/>
			<item id='braga' 		tip='food' sort='3' tip2='eda' ftip='1' us='1' chance='0.15' chance2='1' alc='10' stage='1' price='30' sell='6' m='2'/>
			<item id='cordial' 		tip='food' sort='3' tip2='eda' ftip='1' us='1' chance='0.1' chance2='0.5' alc='20' stage='2' price='40' sell='8' m='2'/>
			<item id='schnapps' 	tip='food' sort='3' tip2='eda' ftip='1' us='1' chance='0.1' chance2='0.5' alc='40' stage='2' price='50' sell='10' m='2'/>
			<item id='hooch' 		tip='food' sort='3' tip2='eda' ftip='1' us='1' chance='0.1' chance2='0.5' alc='60' stage='3' price='60' sell='12' m='2'/>
			<item id='spirt' 		tip='food' sort='3' tip2='eda' ftip='1' us='1' chance='0' chance2='0.1' alc='100' stage='5' price='100' sell='20' m='2'/>

			<item id='noodles'	 tip='food' sort='2' tip2='eda' chance='0.5' chance2='1'	 us='1' stage='1' price='20' sell='4' effect='f_hp' m='1'/>
			<item id='pasta'	 tip='food' sort='2' tip2='eda' chance='0.5' chance2='1'	 us='1' stage='1' price='20' sell='4' effect='f_hp' m='1'/>
			<item id='corn'		 tip='food' sort='2' tip2='eda' chance='0.25' chance2='1'	 us='1' stage='1' price='30' sell='6' effect='f_hp' m='2'/>
			<item id='dinner'	 tip='food' sort='2' tip2='eda' chance='0.5' chance2='1'	 us='1' stage='1' price='20' sell='4' effect='f_hp' m='2'/>
			<item id='beans'	 tip='food' sort='2' tip2='eda' chance='0.5' chance2='1'	 us='1' stage='1' price='20' sell='4' effect='f_hp' m='2'/>
			<item id='bread'	 tip='food' sort='2' tip2='eda' chance='0'	 chance2='1'	 us='1' stage='1' price='20' sell='4' effect='f_hp' m='2'/>
			<item id='oats'		 tip='food' sort='2' tip2='eda' chance='0'	 chance2='1'	 us='1' stage='1' price='20' sell='4' effect='f_hp' m='2'/>
			<item id='chips'	 tip='food' sort='2' tip2='eda' chance='0.12' chance2='0.1'	 us='1' stage='3' price='100' sell='20' effect='f_mana' m='1'/>
			<item id='crackers'	 tip='food' sort='2' tip2='eda' chance='0.5' chance2='1'	 us='1' stage='1' price='20' sell='4' effect='f_mana' m='1'/>
			<item id='nuts'		 tip='food' sort='2' tip2='eda' chance='0.25' chance2='0.4'	 us='1' stage='1' price='40' sell='8' effect='f_mana' m='1'/>
			<item id='sbombs'	 tip='food' sort='2' tip2='eda' chance='0.5' chance2='1'	 us='1' stage='1' price='20' sell='4' effect='f_prec' m='2'/>
			<item id='lollipops' tip='food' sort='2' tip2='eda' chance='0.25' chance2='0.5'	 us='1' stage='1' price='50' sell='10' effect='f_prec' m='1'/>
			<item id='bananas'	 tip='food' sort='2' tip2='eda' chance='0.1' chance2='0.1'	 us='1' stage='1' price='100' sell='20' effect='f_prec' m='1'/>
			<item id='halva'	 tip='food' sort='2' tip2='eda' chance='0.25' chance2='0.5'	 us='1' stage='1' price='50' sell='10' effect='f_prec' m='2'/>
			<item id='honey'	 tip='food' sort='2' tip2='eda' chance='0.1' chance2='0.2'	 us='1' stage='1' price='100' sell='20' effect='f_prec' m='2'/>
			<item id='apple'	 tip='food' sort='2' tip2='eda' chance='0'	 chance2='1'	 us='1' stage='1' price='20' sell='4' effect='f_speed' m='1'/>
			<item id='carrot'	 tip='food' sort='2' tip2='eda' chance='0'	 chance2='1'	 us='1' stage='1' price='10' sell='2' effect='f_speed' m='1'/>
			<item id='onion'	 tip='food' sort='2' tip2='eda' chance='0'	 chance2='1'	 us='1' stage='1' price='10' sell='2' effect='f_speed' m='1'/>
			<item id='tomato'	 tip='food' sort='2' tip2='eda' chance='0'	 chance2='1'	 us='1' stage='1' price='10' sell='2' effect='f_speed' m='1'/>
			<item id='cucumber'	 tip='food' sort='2' tip2='eda' chance='0'	 chance2='1'	 us='1' stage='1' price='10' sell='2' effect='f_speed' m='1'/>
			<item id='cabbage'	 tip='food' sort='2' tip2='eda' chance='0'	 chance2='1'	 us='1' stage='1' price='10' sell='2' effect='f_speed' m='1'/>
			<item id='butter'	 tip='food' sort='2' tip2='eda' chance='0'	 chance2='1'	 us='1' stage='1' price='20' sell='4' effect='f_od' m='1'/>
			<item id='cheese'	 tip='food' sort='2' tip2='eda' chance='0'	 chance2='1'	 us='1' stage='3' price='40' sell='8' effect='f_vulner' m='2'/>
			<item id='tegg'		 tip='food' sort='2' tip2='eda' chance='0'	 chance2='1'	 us='1' stage='1' price='10' sell='2' effect='f_od' m='1'/>
			<item id='meat'		 tip='food' sort='2' 			chance='0' 					 price='20' sell='4' m='1'/>
			<item id='mushroom'	 tip='food' sort='2' tip2='eda' chance='0' 	chance2='1'		stage='3' price='30' sell='6' m='1'/>
			<item id='potato'	 tip='food' sort='2' tip2='eda' chance='0' 	chance2='1'		stage='1' price='10' sell='2' m='2'/>
			<item id='flour'	 tip='food' sort='2' tip2='eda' chance='0' 	chance2='0.2'	stage='1' price='20' sell='4' m='2'/>
			<item id='garlic'	 tip='food' sort='2' tip2='eda' chance='0' 	chance2='0.2' 	stage='5' price='50' sell='10' m='2'/>
			<item id='sugar'	 tip='food' sort='2' tip2='eda' chance='0.1' chance2='0.1'	stage='3' price='50' sell='10' m='1'/>
			<item id='ketchup'	 tip='food' sort='2' tip2='eda' chance='0.5' chance2='1'	stage='3' price='20' sell='4' m='1'/>
			
			<item id='frmeat'	 tip='food' chance='0' us='1' price='30' sell='4' effect='f_melee' m='1'/>	<!-- урон хо -->
			<item id='cucsand'	 tip='food' chance='0' us='1' price='40' sell='8' effect='f_cucsand' m='3'/>	<!-- хп, защита от зверей -->
			<item id='frpot'	 tip='food' chance='0' us='1' price='40' sell='8' effect='f_frpot' m='3'/>	<!-- скорость, ОД -->
			<item id='oatmeal'	 tip='food' chance='0' us='1' price='75' sell='15' effect='f_oatmeal' m='3'/>	<!-- хп, защита от радиации -->
			<item id='salad'	 tip='food' chance='0' us='1' price='60' sell='12' effect='f_salad' m='3'/>	<!-- скорость -->
			<item id='chpasta'	 tip='food' chance='0' us='1' price='120' sell='24' effect='f_chpasta' m='4'/><!-- хп, защита -->
			<item id='omelet'	 tip='food' chance='0' us='1' price='100' sell='20' effect='f_omelet' m='4'/>	<!-- магия -->
			<item id='butterbr'	 tip='food' chance='0' us='1' price='100' sell='20' effect='f_butterbr' m='4'/><!-- ПУ -->
			<item id='breakfast' tip='food' chance='0' us='1' price='180' sell='36' effect='f_breakfast' m='5'/><!-- много хп -->
			<item id='soup'		 tip='food' chance='0' us='1' price='120' sell='24' effect='f_soup' m='5'/>	<!-- уклонение -->
			<item id='pizza'	 tip='food' chance='0' us='1' price='200' sell='40' effect='f_pizza' m='5'/>	<!-- криты -->
			<item id='casser'	 tip='food' chance='0' us='1' price='140' sell='28' effect='f_casser' m='5'/>	<!-- скрытность -->
			<item id='ragu'		 tip='food' chance='0' us='1' price='160' sell='32' effect='f_ragu' m='5'/>	<!-- урон хо, скорость атаки -->
			<item id='spsalad'	 tip='food' chance='0' us='1' price='200' sell='40' effect='f_spsalad' m='5'/><!-- магия, урон от телекинеза -->
			<item id='patty'	 tip='food' chance='0' us='1' price='150' sell='30' effect='f_patty' m='5'/>	<!-- хп, защита от молний -->
			<item id='maffin'	 tip='food' chance='0' us='1' price='200' sell='40' effect='f_maffin' m='5'/>	<!-- взлом всего -->
			<item id='apie'		 tip='food' chance='0' us='1' price='300' sell='60' effect='f_apie' m='6'/>	<!-- хп, лечение, регенерация -->
			<item id='mpie'		 tip='food' chance='0' us='1' price='300' sell='60' effect='f_mpie' m='6'/>	<!-- урон от всего -->
			<item id='ppie'		 tip='food' chance='0' us='1' price='500' sell='100' effect='f_ppie' m='6'/>	<!-- урон от стрельбы, перезарядка -->
			<item id='spie'		 tip='food' chance='0' us='1' price='500' sell='100' effect='f_spie' m='6'/>	<!-- меткость, криты, скорость атаки -->
			<item id='borsch'	 tip='food' chance='0' us='1' price='300' sell='60' effect='f_borsch' m='6'/>	<!-- защита, spellPower -->

			<!--       Краска         -->
			<item id='p_black' tip='paint' chance='1' stage='3' price='50' us='1' paint='0x000000'/>
			<item id='p_white' tip='paint' chance='1' stage='3' price='50' us='1' paint='0xCCCCCC'/>
			<item id='p_red' tip='paint' chance='1' stage='3' price='50' us='1' paint='0xBB0000'/>
			<item id='p_green' tip='paint' chance='1' stage='3' price='50' us='1' paint='0x00BB00'/>
			<item id='p_blue' tip='paint' chance='1' stage='3' price='50' us='1' paint='0x0000BB'/>
			<item id='p_yellow' tip='paint' chance='1' stage='3' price='50' us='1' paint='0xCCBB00'/>
			
			<item id='p_gray' tip='paint' chance='2' stage='5' price='200' us='1' paint='0x888888'/>
			<item id='p_purple' tip='paint' chance='2' stage='5' price='200' us='1' paint='0x8800BB'/>
			<item id='p_orange' tip='paint' chance='2' stage='5' price='200' us='1' paint='0xBB7700'/>
			<item id='p_brown' tip='paint' chance='2' stage='5' price='200' us='1' paint='0x553322'/>
			<item id='p_lblue' tip='paint' chance='2' stage='5' price='200' us='1' paint='0x0088BB'/>
			<item id='p_khaki' tip='paint' chance='2' stage='5' price='200' us='1' paint='0x888800'/>
			<item id='p_dgreen' tip='paint' chance='2' stage='5' price='200' us='1' paint='0x007700'/>
			
			<item id='p_cyan' tip='paint' chance='3' stage='7' price='500' us='1' paint='0x00BB88'/>
			<item id='p_pink' tip='paint' chance='3' stage='7' price='500' us='1' paint='0xCC2277'/>
			<item id='p_burgundy' tip='paint' chance='3' stage='7' price='500' us='1' paint='0x770000'/>
			<item id='p_crimson' tip='paint' chance='3' stage='7' price='500' us='1' paint='0xBB0055'/>
			<item id='p_lime' tip='paint' chance='3' stage='7' price='500' us='1' paint='0x88BB00'/>
			<item id='p_fire' tip='paint' chance='3' stage='7' price='500' us='1' paint='0xCC5500'/>
			<item id='p_beige' tip='paint' chance='3' stage='7' price='500' us='1' paint='0xCC9966'/>
			
			<!--       Не атакующие заклинания         -->
			<item id='sp_slow' tip='spell' us='1' price='2000' hp='60' magic='500' mana='30' culd='10' rad='200' snd='slow' mess='spell'/>
			<item id='sp_mwall' tip='spell' us='1' price='1000' atk='1' hp='200' magic='300' culd='20' mana='30' dist='300' line='1' snd='mwall' mess='spell'/>
			<item id='sp_blast' tip='spell' us='1' price='2500' atk='1' dam='20' magic='300' culd='10' mana='30' rad='500' tele='1' snd='blast' mess='spell'/>
			<item id='sp_cryst' tip='spell' us='1' price='2000' atk='1' prod='1' magic='50'  culd='0' mana='5' snd='crystal' mess='spell'/>
			<item id='sp_kdash' tip='spell' us='1' price='2000' dam='20' magic='100' mana='10' culd='3' tele='1' snd='dash' mess='spell'/>
			<item id='sp_mshit' tip='spell' us='1' price='2000' atk='1' hp='150' magic='500' mana='100' culd='30' snd='mshit' mess='spell'/>
			<item id='sp_moon' tip='spell' us='1' price='3000' atk='1' magic='800' mana='300' snd='crystal' culd='60' mess='spell' pet_info='moon'/>
			<item id='sp_gwall' tip='spell' us='1' price='3000' atk='1' magic='500' mana='50' hp='100' dam='10' dist='300' line='1' snd='mwall' culd='6' mess='spell'/>
			<item id='sp_invulner' tip='spell' us='1' price='4000' atk='1' dam='50' magic='800' mana='200' snd='mshit' culd='12' mess='spell'/>
			<weapon id='sp_slow' tip='5' skill='6' perslvl='3' spell='1'/>
			<weapon id='sp_mwall' tip='5' skill='6' perslvl='6' spell='1'/>
			<weapon id='sp_blast' tip='5' skill='7' perslvl='9' spell='1'/>
			<weapon id='sp_cryst' tip='5' skill='6' perslvl='12' spell='1'/>
			<weapon id='sp_kdash' tip='5' skill='7' perslvl='15' spell='1'/>
			<weapon id='sp_mshit' tip='5' skill='6' perslvl='18' spell='1'/>
			<weapon id='sp_moon' tip='5' skill='6' perslvl='20' spell='1'/>
			<weapon id='sp_gwall' tip='5' skill='6' perslvl='21' spell='1'/>
			<weapon id='sp_invulner' tip='5' skill='6' perslvl='24' spell='1'/>

			<!--       Ценные вещи        -->
			<item id='bit' tip='valuables' sell='1' fall='fall_caps' fc='2'/>
			<item id='gem1' tip='valuables' sell='50' fall='fall_gem' fc='2' m='1'/>
			<item id='gem2' tip='valuables' sell='100' fall='fall_gem' fc='2' m='1'/>
			<item id='gem3' tip='valuables' sell='150' fall='fall_gem' fc='2' m='1'/>
			<item id='data' tip='valuables' sell='150' fall='fall_gem' fc='2' m='1'/>
			<item id='disc' tip='valuables' sell='400' fall='fall_gem' fc='2' m='1'/>
			<item id='lbook' tip='valuables' sell='100' fc='2' m='3'/>
			
			<!--       Квестовые предметы        -->
			<item id='col1' tip='spec' fall='fall_gem'/>
			<item id='col2' tip='spec' fall='fall_paper'/>
			<item id='pro_armor' tip='spec' fall='fall_paper'/>
			<item id='super_sapphire' tip='spec' fall='fall_gem'/>
			<item id='super_ruby' tip='spec' fall='fall_gem'/>
			<item id='super_emerald' tip='spec' fall='fall_gem'/>
			<item id='tool_calipers' tip='spec' fall='fall_metal_item'/>
			<item id='tool_boltcutter' tip='spec' fall='fall_metal_item'/>
			<item id='tool_oscilloscope' tip='spec' fall='fall_metal_item'/>
			<item id='cigars' tip='spec'/>
			<item id='tabak' tip='spec'/>
			<item id='tpipe' tip='spec'/>
			<item id='bong' tip='spec'/>
			<item id='glycerol' tip='spec'/>
			<item id='book_cm' tip='spec' limit='book_cm' mlim='0.41' maxlim='5'/>
			<item id='data_eqd' tip='spec'/>
			<item id='box_screw' tip='spec'/>
			<item id='box_nut' tip='spec'/>
			<item id='alc1' tip='spec' fall='fall_potion'/>
			<item id='alc2' tip='spec' fall='fall_potion'/>
			<item id='alc3' tip='spec' fall='fall_potion'/>
			<item id='alc4' tip='spec' fall='fall_potion'/>
			<item id='alc5' tip='spec' fall='fall_potion'/>
			<item id='alc6' tip='spec' fall='fall_potion'/>
			<item id='alc7' tip='spec' fall='fall_potion' limit='alc7' mlim='1' maxlim='1'/>
			<item id='vaccine' tip='spec' price='5000'/>
			<item id='wtal' tip='spec'/>
			<item id='bbatt' tip='spec' price='1000' sell='1000'/>
			<item id='datast' tip='spec' sell='250' price='250' fall='fall_gem' fc='2' m='1'/>
			<item id='secret_doc' tip='spec'/>
			<item id='tech1' tip='spec'/>
			<item id='tech2' tip='spec'/>
			<item id='tech3' tip='spec'/>
			<item id='tech4' tip='spec'/>
			<item id='tech5' tip='spec'/>
			<item id='enclarmor' tip='spec'/>
			
			<!--       Ключи        -->
			<item id='key_raiders' tip='key'/>
			<item id='key_sewer' tip='key'/>
			<item id='key_cat' tip='key'/>
			<item id='key_gruz' tip='key'/>
			<item id='key_tumba' tip='key'/>
			<item id='key_necr' tip='key'/>
			<item id='key_ranger' tip='key'/>
			<item id='key_rar' tip='key' price='20000'/>
			<item id='key_zebra' tip='key'/>
			<item id='key_encl' tip='key'/>

			<!--       Снаряжение        -->
			<item id='stealth' tip='equip' us='2' price='180' sell='40' fc='8' m='3'/>
			<item id='rep' tip='equip' us='2' hp='100' price='100' sell='20' fc='8' m='3'/>
			<item id='runa' tip='equip' us='1' price='400' sell='80' fc='8' m='2'/>
			<item id='reboot' tip='equip' us='1' price='400' sell='80' fc='8' m='2'/>
			<item id='retr' tip='equip' price='250' sell='50' us='1' fc='8' m='3'/>
			<item id='pin' tip='stuff' chance='1' price='10' m='0.2' keep='1'/>
			<item id='empbomb' tip='equip' chance='0' price='2000' sell='1000' m='30' invcat='3' keep='1'/>
			<item id='mworkbench' tip='equip' us='1' price='1000' m='30' invcat='3' keep='1'/>
			<item id='mworkexpl' tip='equip' us='1' price='1000' m='20' invcat='3' keep='1'/>
			<item id='mworklab' tip='equip' us='1' price='1000' m='30' invcat='3' keep='1'/>
			<item id='whistle' tip='equip' us='1' price='1000' pet='phoenix' pet_info='phoenix'/>
			<item id='owl' tip='equip' us='1' price='1000' pet='owl' one='1' mess='owl' pet_info='owl'/>
			
			<item id='card0' tip='equip' us='1' chdif='0' price='200' sell='200' m='1' invcat='3'/>
			<item id='card1' tip='equip' us='1' chdif='1' price='400' sell='400' m='1' invcat='3'/>
			<item id='card2' tip='equip' us='1' chdif='2' price='600' sell='600' m='1' invcat='3'/>
			<item id='card3' tip='equip' us='1' chdif='3' price='800' sell='800' m='1' invcat='3'/>
			<item id='card4' tip='equip' us='1' chdif='4' price='1000' sell='1000' m='1' invcat='3'/>
	
			<!--       Инструменты       -->
			<item id='screwdriver' tip='instr' price='10' mess='screwdriver'>
				<sk id='possLockPick' v1='1'/>
			</item>
			<item id='titansd' tip='instr' price='500'>
				<sk id='possLockPick' v1='1'/>
				<sk id='lockPick' ref='add' v1='1'/>
				<textvar s1='1'/>
			</item>
			<item id='stethoscope' tip='instr' price='2000'>
				<sk id='lockPick' ref='add' v1='1'/>
				<textvar s1='1'/>
			</item>
			<item id='strickle' tip='instr' price='500'>
				<sk id='acuteDam' v0='1' v1='1.1'/>
				<textvar s1='10%'/>
			</item>
			<item id='binoc' tip='instr'/>
			<item id='bag1' tip='instr' price='5000'>
				<sk tip='m' id='maxm2' v1='500'/>
			</item>
			<item id='bag2' tip='instr' price='15000'>
				<sk tip='m' id='maxm2' v1='1000'/>
			</item>

			<!--       Имплантаты и модули       -->
			<item id='impl_skin' tip='impl' price='10000' mess='impl'>
				<sk id='skin' v1='3' ref='add'/>
				<textvar s1='3'/>
			</item>
			<item id='impl_mrech' tip='impl' price='10000' mess='impl'>
				<sk id='manaMin' v1='75'/>
			</item>
			<item id='impl_regen' tip='impl' price='15000' mess='impl'>
				<sk id='regenFew' v1='0.1'/>
				<sk id='regenMax' v1='0.25'/>
				<textvar s1='3' s2='25%'/>
			</item>
			<item id='impl_intel' tip='impl' price='15000' mess='impl'>
				<sk id='lockPick' ref='add' v1='1'/>
				<sk id='hacker' ref='add' v1='1'/>
				<textvar s1='1' s2='1'/>
			</item>
			<item id='mod_metal' tip='impl' price='1000' mess='mod'>
				<sk id='modMetal' v1='0.5'/>
			</item>
			<item id='mod_analis' tip='impl' price='1000' mess='mod'>
				<sk id='modAnalis' v1='1'/>
			</item>
			<item id='mod_target' tip='impl' price='1000' mess='mod'>
				<sk id='modTarget' v1='1'/>
			</item>
			<item id='mod_holo' tip='impl' price='1000' mess='mod'>
				<sk id='dexter' ref='add' vd='0.1'/>
				<sk id='visiMult' ref='mult' v1='0.9'/>
				<textvar s1='10%'/>
			</item>
			<item id='mod_reanim' tip='impl' price='1000' mess='mod'>
				<sk id='reanimHp' v1='200'/>
			</item>
			<item id='mod_hacker' tip='impl' price='1000' mess='mod'>
				<sk id='hacker' ref='add' v1='2'/>
				<textvar s1='2'/>
			</item>
			<item id='owl_weapon' tip='impl' price='1000'>
				<sk id='owlDam' ref='add' v1='1'/>
			</item>
			<item id='owl_armor' tip='impl' price='1000'>
				<sk id='owlSkin' ref='add' v1='3'/>
				<sk id='owlVulner' ref='add' v1='-0.1'/>
			</item>
			<item id='kogit' tip='instr' price='500' mess='kogit'>
				<sk id='hacker' ref='add' v1='1'/>
				<sk id='lockPick' ref='add' v1='1'/>
				<sk id='maxOd' ref='add' vd='25'/>
				<textvar s1='1' s2='25'/>
			</item>
			<item id='mod_trans' tip='impl'>
				<sk id='hacker' ref='add' v1='1'/>
				<sk id='lockPick' ref='add' v1='1'/>
				<sk id='maxOd' ref='add' vd='25'/>
				<textvar s1='1' s2='25'/>
			</item>
			
			<!--       Статуэтки       -->
			<item id='stat_tw' tip='art' price='1' mess='stat_tw'>
				<sk id='spellsDamMult' ref='add' v1='0.1'/>
				<sk id='upChance' v1='1'/>
				<textvar s1='10%'/>
			</item>
			<item id='stat_aj' tip='art' price='1' mess='stat_aj'>
				<sk id='meleeDamMult' ref='add' v1='0.1'/>
				<sk id='punchDamMult' ref='add' v1='0.5'/>
				<sk id='maxhp' v1='25' ref='add'/>
				<textvar s1='10%' s2='50%' s3='25'/>
			</item>
			<item id='stat_fl' tip='art' price='1' mess='stat_fl'>
				<sk id='healMult' ref='add' v1='0.1'/>
				<sk id='barterMult' ref='mult' v1='0.9'/>
				<textvar s1='10%' s2='10%'/>
			</item>
			<item id='stat_rr' tip='art' price='1' mess='stat_rr'>
				<sk id='skin' v1='2' ref='add'/>
				<sk id='stamRun' ref='mult' v1='0.9'/>
				<sk id='allDManaMult' ref='mult' v1='0.9'/>
				<textvar s1='2' s2='10%'/>
			</item>
			<item id='stat_pp' tip='art' price='1' mess='stat_pp'>
				<sk id='visiMult' ref='mult' v1='0.9'/>
				<sk id='allPrecMult' ref='add' v1='0.1'/>
				<textvar s1='10%' s2='10%'/>
			</item>
			<item id='stat_rd' tip='art' price='1' mess='stat_rd'>
				<sk id='gunsDamMult' ref='add' v1='0.05'/>
				<sk id='speedPlavMult' ref='mult' v1='1.1'/>
				<sk id='runSpeedMult' ref='mult' v1='1.1'/>
				<textvar s1='5%' s2='10%'/>
			</item>
			<item id='amul_al' tip='art' price='1' mess='amul_al'>
				<sk id='spellsDamMult' ref='add' v1='0.1'/>
				<sk id='warlockDManaMult' ref='mult' v1='0.9'/>
				<textvar s1='10%' s2='10%'/>
			</item>
			<item id='blackbook' tip='art' price='1' mess='blackbook'>
				<sk tip='res' id='16' v0='0' v1='0.2'/>
				<sk tip='res' id='19' v0='0' v1='0.2'/>
				<sk id='bonusHeal' ref='add' v1='100'/>
				<eff id='necro' n1='+20%'/>
				<eff id='pink' n1='+20%'/>
			</item>
			<item id='tal_star' tip='art' price='25000'>
				<sk id='allDamMult' ref='mult' v1='1.1'/>
				<textvar s1='10%'/>
			</item>
			<item id='tal_moon' tip='art' price='50000'>
				<sk id='allDamMult' ref='mult' v1='1.1'/>
				<textvar s1='10%'/>
			</item>
			<item id='tal_sun' tip='art' price='75000'>
				<sk id='allDamMult' ref='mult' v1='1.1'/>
				<textvar s1='10%'/>
			</item>
			<item id='tal_ether' tip='art' price='100000'>
				<sk id='allDamMult' ref='mult' v1='1.1'/>
				<textvar s1='10%'/>
			</item>
			
			<!--       Книги        -->
			<item id='sphera' 	tip='sphera' chance='1' limit='sphera' mlim='1.1' us='1' price='500' m='3' fall='fall_gem' fc='4' mess='sphera' invcat='3'/>
			<item id='repair'		tip='book' chance='1' limit='book' mlim='1.4' us='1' mess='book' m='3'/>
			<item id='medic' 		tip='book' chance='1' limit='book' mlim='1.4' us='1' mess='book' m='3'/>
			<item id='magic' 		tip='book' chance='1' limit='book' mlim='1.4' us='1' mess='book' m='3'/>
			<item id='lockpick' 	tip='book' chance='1' limit='book' mlim='1.4' us='1' mess='book' m='3'/>
			<item id='science' 		tip='book' chance='1' limit='book' mlim='1.4' us='1' mess='book' m='3'/>
			<item id='explosives' 	tip='book' chance='1' limit='book' mlim='1.4' us='1' mess='book' m='3'/>
			<item id='smallguns' 	tip='book' chance='1' limit='book' mlim='1.4' us='1' mess='book' m='3'/>
			<item id='melee' 		tip='book' chance='1' limit='book' mlim='1.4' us='1' mess='book' m='3'/>
			<item id='energy' 		tip='book' chance='1' limit='book' mlim='1.4' us='1' mess='book' m='3'/>
			<item id='sneak' 		tip='book' chance='1' limit='book' mlim='1.4' us='1' mess='book' m='3'/>
			<item id='barter' 		tip='book' chance='1' limit='book' mlim='1.4' us='1' mess='book' m='3'/>
			<item id='tele' 		tip='book' chance='1' limit='book' mlim='1.4' us='1' mess='book' m='3'/>
			<item id='survival'		tip='book' chance='1' limit='book' mlim='1.4' us='1' mess='book' m='3'/>
			<item id='book_alicorn'	tip='book' chance='0' perk='dam_alicorn' us='1' m='3'/>
			<item id='diary'	tip='note' chance='0' us='1' text='diaryText' perk='dam_zombie'/>
			<item id='sl_note1'	tip='note' chance='0' us='1' text='slNote1'/>
			<item id='sl_note2'	tip='note' chance='0' us='1' text='slNote2'/>
			<item id='merc_note1'	tip='note' chance='0' us='1' text='mercNote1'/>
			<item id='lp_item' tip='note' chance='0' us='1' limit='lp_item' mlim='1' maxlim='1' text='roomLPbook'/>
			
			
			<!--       Компоненты        -->
			<item id='kombu_comp' tip='compa' chance='0.3' stage='1' lvl='1' price='40' sell='3' m='1'/>
			<item id='antirad_comp' tip='compa' chance='0.5' stage='2' lvl='2' price='60' sell='5' m='1'/>
			<item id='antihim_comp' tip='compa' chance='0.5' stage='2' lvl='2' price='60' sell='5' m='1'/>
			<item id='skin_comp' tip='compa' chance='0.5' stage='3' lvl='3' price='100' sell='10' m='2'/>
			<item id='metal_comp' tip='compa' chance='0.5' stage='3' lvl='3' price='100' sell='10' m='3'/>
			<item id='battle_comp' tip='compa' chance='1.2' stage='5' lvl='4' price='250' sell='25' m='3'/>
			<item id='magus_comp' tip='compa' chance='1.2' stage='5' lvl='4' price='300' sell='25' m='2'/>
			<item id='polic_comp' tip='compa' chance='1.2' stage='5' lvl='4' price='200' sell='20' m='2'/>
			<item id='chitin_comp' tip='compa' chance='0' stage='1' price='100' sell='10' m='3'/>
			<item id='intel_comp' tip='compa' chance='1.2' stage='5' lvl='3' price='250' sell='25' m='2'/>
			<item id='power_comp' tip='compa' chance='0' stage='7' lvl='4' price='500' sell='50' m='8'/>
			
			<item id='frag' tip='compw' chance='1' stage='1' price='10' sell='1' m='1'/>
			<item id='strap' tip='compw' chance='0.5' stage='1' price='40' sell='4' m='3'/>
			<item id='turp' tip='compw' chance='1' stage='1' price='20' sell='2' m='2'/>
			<item id='pbatt' tip='compw' chance='0.45' stage='1' price='100' sell='20' m='10'/>
			<item id='tape' tip='compw' chance='0.5' stage='1' price='20' sell='2' m='1'/>
			<item id='glue' tip='compw' chance='0.4' stage='1' price='30' sell='3' m='1'/>
			<item id='tubing' tip='compw' chance='0.2' stage='1' price='40' sell='4' m='1'/>
			<item id='spring' tip='compw' chance='0.2' stage='1' price='50' sell='5' m='1'/>
			<item id='fblade' tip='compw' chance='0.2' stage='1' lvl='1' price='80' sell='8' m='10'/>
			<item id='lighter' tip='compw' chance='0.2' stage='1' lvl='1' price='60' sell='10' m='1'/>
			<item id='pulv' tip='compw' chance='0.1' stage='1' lvl='2' price='40' sell='4' m='4'/>
			<item id='compress' tip='compw' chance='0.1' stage='3' lvl='2' price='100' sell='20' m='10'/>
			<item id='motor' tip='compw' chance='0.1' stage='3' lvl='3' price='200' sell='40' m='20'/>
			<item id='resscook' tip='compw' chance='0.1' stage='3' lvl='4' price='300' sell='30' m='10'/>
			<item id='mano' tip='compw' chance='0.15' stage='3' lvl='4' price='100' sell='10' m='5'/>
			<item id='kogt' tip='compw' chance='0' lvl='4' price='3000' sell='1000' m='5'/>
			<item id='hcrystal' tip='compw' chance='0' lvl='5' price='1000' sell='200' m='1'/>
			
			<item id='elcomp' tip='compm' chance='3' stage='1' price='10' sell='1' m='1'/>
			<item id='chip' tip='compm' chance='0.3' stage='3' price='500' limit='chip' mlim='0.35' m='1'/>
			<item id='impgen' tip='compm' chance='0' price='500' sell='100' m='5'/>
			<item id='uscan' tip='compm' chance='0' price='800' sell='150' m='5'/>
			<item id='tlaser' tip='compm' chance='0' price='1300' sell='200' m='5'/>
			<item id='pcrystal' tip='compm' chance='0' price='2000' sell='300' m='3'/>
			<item id='tmed' tip='compm' chance='0' price='3000' sell='400' m='3'/>
			<item id='magnit' tip='compm' chance='0.2' stage='3' lvl='3' price='100' sell='10' m='5'/>
			<item id='tlevit' tip='compm' chance='0.05' stage='5' lvl='3' price='500' sell='100' m='5'/>
			<item id='fcrystal' tip='compm' chance='0.01' stage='5' lvl='5' price='1000' sell='200' m='3'/>
			<item id='superc' tip='compm' chance='0.15' stage='5' lvl='5' price='500' sell='100' m='5'/>
			<item id='condens' tip='compm' chance='0.2' stage='3' lvl='4' price='200' sell='20' m='5'/>
			<item id='bdpass' tip='compm' chance='0' price='2000' sell='500' m='1'/>
			<item id='c_owl' tip='compm' chance='0' lvl='4' price='5000' sell='1000' m='10'/>
			<item id='motiv' tip='compm' chance='0' price='500' sell='100' m='10'/>
			
			<item id='bottle' tip='stuff' chance='1' stage='1' price='1' m='1'/>
			<item id='can' tip='stuff' chance='1' stage='1' price='1' m='1'/>
			<item id='lunchbox' tip='stuff' chance='0.5' stage='1' price='10' m='3'/>
			<item id='app' tip='stuff' chance='0.2' stage='1' price='1' m='3'/>
			<item id='scrap' tip='stuff' chance='1' stage='1' price='1' kol='3' m='1'/>
			<item id='detonat' tip='compe' chance='1' stage='1' price='10' kol='3' sell='1' m='1'/>
			<item id='sensor' tip='compe' chance='1' stage='1' price='20' kol='3' sell='4' m='1'/>
			<item id='powder' tip='compe' chance='1' stage='1' price='20' kol='6' sell='4' m='1'/>
			<item id='tnt' tip='compe' chance='0.3' stage='3' price='100' sell='20' m='10'/>
			<item id='timer' tip='compw' chance='0.3' stage='1' price='10' sell='1' m='5'/>
			
			<item id='fan' tip='stuff' chance='0' lvl='0' price='25' sell='5' m='5'/>
			<item id='lamp' tip='stuff' chance='0' lvl='0' price='25' sell='5' m='5'/>
			<item id='kofe' tip='stuff' chance='0' lvl='0' price='25' sell='5' m='5'/>
			
			<item id='gland' tip='compp' chance='0' price='80' sell='5' m='4'/>
			<item id='acidslime' tip='compp' chance='0' price='20' sell='1' m='1'/>
			<item id='ghoulblood' tip='compp' chance='0' price='20' sell='1' m='1'/>
			<item id='radslime' tip='compp' chance='0' price='40' sell='5' m='1'/>
			<item id='wingmembrane' tip='compp' chance='0' price='60' sell='5' m='1'/>
			<item id='vampfang' tip='compp' chance='0' price='40' sell='5' m='1'/>
			<item id='bloatwing' tip='compp' chance='0' price='10' sell='1' m='1'/>
			<item id='bloateye' tip='compp' chance='0' price='10' sell='1' m='1'/>
			<item id='ratliver' tip='compp' chance='0' price='20' sell='1' m='1'/>
			<item id='rattail' tip='compp' chance='0' price='10' sell='1' m='1'/>
			<item id='molefat' tip='compp' chance='0' price='40' sell='5' m='3'/>
			<item id='firegland' tip='compp' chance='0' price='80' sell='10' m='3'/>
			<item id='fishfat' tip='compp' chance='0' price='10' sell='1' m='2'/>
			<item id='mdust' tip='compp' chance='0' price='100' sell='10' m='1'/>
			
			<item id='pinkslime' tip='compp' chance='0' price='100' sell='10' m='1'/>
			<item id='dsoul' tip='compp' chance='0' price='250' sell='30' m='1'/>
			<item id='whorn' tip='compp' chance='0' price='300' sell='30' m='5'/>
			
			<item id='gel' tip='compp' chance='0' kol='100' stage='4' price='1' sell='0.1' keep='1'/>
			<item id='good' tip='compp' chance='0' invis='1'/>
			<item id='herbs' tip='compp' chance='0' stage='1' price='20' sell='1' m='0.5'/>
			<item id='taintextract' tip='compp' chance='0.1' stage='3' price='400' sell='100' m='5'/>
			<item id='hydrablood' tip='compp' chance='0.1' stage='3' price='400' sell='100' m='5'/>
			<item id='rainbow' tip='compp' chance='0.1' stage='3' price='400' sell='100' m='5'/>
			<item id='stardust' tip='compp' chance='0.1' stage='3' price='400' sell='100' m='5'/>
			<item id='moonstone' tip='compp' chance='0.1' stage='5' price='400' sell='100' m='5'/>
			<item id='firecrystal' tip='compp' chance='0.1' stage='5' price='400' sell='100' m='5'/>
			<item id='abssalt' tip='compp' chance='0.15' stage='9' price='600' sell='150' m='5'/>
			<item id='darkfrag' tip='compp' chance='0' price='600' sell='150' m='5'/>
			<item id='essence' tip='compp' chance='0' stage='1' price='500' limit='essence' mlim='0.95' m='1'/>
			
			<!--       Схемы        -->
			<!--   Самодельное оружие   -->
			<item id='s_hsword' tip='scheme' cat='weapon' work='work' chance='1' stage='1' price='100' skill='repair' lvl='1'>
				<craft id='strap' kol='1'/>
				<craft id='fblade' kol='1'/>
			</item>
			<item id='s_arson' tip='scheme' cat='weapon' work='work' chance='1' stage='1' price='100' skill='repair' lvl='0'>
				<craft id='tape' kol='1'/>
				<craft id='lighter' kol='1'/>
				<craft id='aero' kol='100'/>
			</item>
			<item id='s_dartgun' tip='scheme' cat='weapon' work='work' chance='1' stage='1' price='200' skill='repair' lvl='1'>
				<craft id='glue' kol='1'/>
				<craft id='gland' kol='1'/>
				<craft id='tubing' kol='2'/>
				<craft id='frag' kol='5'/>
			</item>
			<item id='s_acidgun' tip='scheme' cat='weapon' work='work' chance='1' stage='3' price='300' skill='repair' lvl='2'>
				<craft id='pulv' kol='1'/>
				<craft id='compress' kol='1'/>
				<craft id='pbatt' kol='1'/>
				<craft id='frag' kol='10'/>
			</item>
			<item id='s_sawgun' tip='scheme' cat='weapon' work='work' chance='1' stage='5' price='500' skill='repair' lvl='3'>
				<craft id='motor' kol='1'/>
				<craft id='spring' kol='4'/>
				<craft id='pbatt' kol='3'/>
				<craft id='frag' kol='20'/>
			</item>
			<item id='s_buckshot' tip='scheme' cat='weapon' work='work' chance='1' stage='5' price='700' skill='repair' lvl='4'>
				<craft id='resscook' kol='1'/>
				<craft id='mano' kol='1'/>
				<craft id='pbatt' kol='5'/>
				<craft id='frag' kol='25'/>
			</item>
			<item id='s_railway' tip='scheme' cat='weapon' work='work' chance='0.8' stage='7' price='1000' skill='repair' lvl='5'>
				<craft id='tlevit' kol='1'/>
				<craft id='condens' kol='2'/>
				<craft id='magnit' kol='5'/>
				<craft id='pbatt' kol='3'/>
				<craft id='frag' kol='30'/>
			</item>
			<item id='s_bfg' tip='scheme' cat='weapon' work='work' chance='0.5' stage='7' price='1200' skill='science' lvl='5'>
				<craft id='fcrystal' kol='1'/>
				<craft id='superc' kol='2'/>
				<craft id='condens' kol='5'/>
				<craft id='elcomp' kol='15'/>
				<craft id='frag' kol='30'/>
			</item>
			<item id='s_cdagger' tip='scheme' cat='weapon' work='work' chance='0' price='1000' skill='repair' lvl='4'>
				<craft id='kogt' kol='1'/>
				<craft id='strap' kol='1'/>
				<craft id='tape' kol='1'/>
				<craft id='glue' kol='1'/>
			</item>
			<item id='s_friend' tip='scheme' cat='weapon' work='work' chance='0' price='1200' skill='repair' lvl='5'>
				<craft id='hcrystal' kol='7'/>
				<craft id='superc' kol='1'/>
				<craft id='condens' kol='1'/>
				<craft id='elcomp' kol='20'/>
				<craft id='frag' kol='30'/>
			</item>
			
			<!--   Взрывчатка   -->
			<item id='s_hgren' tip='scheme' cat='weapon' work='expl' chance='1' price='500' skill='explosives' lvl='1'>
				<craft id='can' kol='1'/>
				<craft id='detonat' kol='1'/>
				<craft id='powder' kol='1'/>
				<craft id='scrap' kol='5'/>
			</item>
			<item id='s_molotov' tip='scheme' cat='weapon' work='expl' chance='1' price='200' skill='explosives' lvl='1'>
				<craft id='bottle' kol='1'/>
				<craft id='fuel' kol='25'/>
			</item>
			<item id='s_hmine' tip='scheme' cat='weapon' work='expl' chance='1' price='500' skill='explosives' lvl='1'>
				<craft id='lunchbox' kol='1'/>
				<craft id='sensor' kol='1'/>
				<craft id='powder' kol='1'/>
				<craft id='scrap' kol='5'/>
			</item>
			<item id='s_acidgr' tip='scheme' cat='weapon' work='expl' chance='1' stage='3' price='800' skill='explosives' lvl='2'>
				<craft id='bottle' kol='1'/>
				<craft id='acid' kol='3'/>
			</item>
			<item id='s_dbomb' tip='scheme' cat='weapon' work='expl' chance='0.5' stage='3' price='500' skill='explosives' lvl='2'>
				<craft id='dinamit' kol='3'/>
				<craft id='tape' kol='1'/>
			</item>
			<item id='s_bomb' tip='scheme' cat='weapon' work='expl' chance='0.5' stage='3' price='500' skill='explosives' lvl='3'>
				<craft id='tnt' kol='1'/>
				<craft id='detonat' kol='1'/>
				<craft id='timer' kol='1'/>
			</item>
			<item id='s_cryogr' tip='scheme' cat='weapon' work='expl' chance='0' price='500' skill='explosives' lvl='3'>
				<craft id='can' kol='1'/>
				<craft id='detonat' kol='1'/>
				<craft id='pcryo' kol='5'/>
			</item>
			<item id='s_cryomine' tip='scheme' cat='weapon' work='expl' chance='0' price='500' skill='explosives' lvl='3'>
				<craft id='lunchbox' kol='1'/>
				<craft id='sensor' kol='1'/>
				<craft id='pcryo' kol='5'/>
			</item>
			<item id='s_balemine' tip='scheme' cat='weapon' work='expl' chance='0' price='1000' skill='explosives' lvl='5'>
				<craft id='mine' kol='1'/>
				<craft id='egg' kol='1'/>
			</item>
			<item id='s_spgren' tip='scheme' cat='weapon' work='expl' chance='0' price='500' skill='explosives' lvl='5'>
				<craft id='can' kol='1'/>
				<craft id='radcola' kol='1'/>
				<craft id='turp' kol='1'/>
				<craft id='app' kol='1'/>
			</item>
			<item id='s_empbomb' tip='scheme' work='expl' chance='0' price='1000' skill='explosives' lvl='5'>
				<craft id='condens' kol='1'/>
				<craft id='magnit' kol='1'/>
				<craft id='impgr' kol='4'/>
				<craft id='crystal' kol='100'/>
			</item>
			
			<!--   Модули   -->
			<item id='s_mod_metal' tip='scheme' work='work' chance='1' stage='3' price='500' skill='science' lvl='1'>
				<craft id='impgen' kol='1'/>
				<craft id='chip' kol='1'/>
				<craft id='elcomp' kol='10'/>
			</item>
			<item id='s_mod_analis' tip='scheme' work='work' chance='1' stage='3' price='500' skill='science' lvl='2'>
				<craft id='uscan' kol='1'/>
				<craft id='chip' kol='1'/>
				<craft id='elcomp' kol='15'/>
			</item>
			<item id='s_mod_target' tip='scheme' work='work' chance='1' stage='5' price='500' skill='science' lvl='3'>
				<craft id='tlaser' kol='1'/>
				<craft id='chip' kol='1'/>
				<craft id='elcomp' kol='20'/>
			</item>
			<item id='s_mod_holo' tip='scheme' work='work' chance='1' stage='5' price='500' skill='science' lvl='4'>
				<craft id='pcrystal' kol='1'/>
				<craft id='chip' kol='1'/>
				<craft id='elcomp' kol='25'/>
			</item>
			<item id='s_mod_reanim' tip='scheme' work='work' chance='1' stage='7' price='500' skill='science' lvl='5'>
				<craft id='tmed' kol='1'/>
				<craft id='chip' kol='1'/>
				<craft id='elcomp' kol='30'/>
			</item>
			<item id='s_mod_hacker' tip='scheme' work='work' chance='0' price='500' skill='science' lvl='3'>
				<craft id='bdpass' kol='1'/>
				<craft id='chip' kol='1'/>
				<craft id='reboot' kol='1'/>
				<craft id='elcomp' kol='20'/>
			</item>
			
			<!--   Робо-сова   -->
			<item id='s_owl' tip='scheme' work='work' chance='0' price='10000' skill='repair' lvl='3'>
				<craft id='c_owl' kol='1'/>
				<craft id='tlevit' kol='1'/>
				<craft id='chip' kol='1'/>
				<craft id='pbatt' kol='3'/>
				<craft id='scrap' kol='30'/>
				<craft id='elcomp' kol='20'/>
			</item>
			<item id='s_owl_armor' tip='scheme' work='work' chance='0' price='2000' skill='repair' lvl='4'>
				<craft id='battle_comp' kol='5'/>
				<craft id='magus_comp' kol='5'/>
				<craft id='magnit' kol='1'/>
				<craft id='scrap' kol='20'/>
			</item>
			<item id='s_owl_weapon' tip='scheme' work='work' chance='0' price='1500' skill='repair' lvl='5'>
				<craft id='fcrystal' kol='1'/>
				<craft id='superc' kol='1'/>
				<craft id='elcomp' kol='20'/>
			</item>
			
			<!--   Броня   -->
			<item id='s_chitin' tip='scheme' cat='armor' work='work' chance='0' price='1000' skill='repair' lvl='3'>
				<craft id='chitin_comp' kol='20'/>
				<craft id='tape' kol='4'/>
				<craft id='strap' kol='4'/>
				<craft id='glue' kol='3'/>
			</item>
			
			<!--   Зелья   -->
			<item id='s_potion_stim'	tip='scheme' perk='potmaster' work='lab' chance='3' price='750' skill='survival' lvl='2'>
				<craft id='ghoulblood' kol='1'/>
				<craft id='ratliver' kol='3'/>
				<craft id='herbs' kol='3'/>
			</item>
			<item id='s_potion_swim'	tip='scheme' perk='potmaster' work='lab' chance='3' price='500' skill='survival' lvl='1'>
				<craft id='wingmembrane' kol='1'/>
				<craft id='fishfat' kol='2'/>
				<craft id='herbs' kol='3'/>
			</item>
			<item id='s_potion_fly'		tip='scheme' perk='potmaster' work='lab' chance='1' stage='7' price='3200' skill='survival' lvl='5'>
				<craft id='wingmembrane' kol='1'/>
				<craft id='bloatwing' kol='4'/>
				<craft id='herbs' kol='8'/>
			</item>
			<item id='s_potion_shadow'	tip='scheme' perk='potmaster' work='lab' chance='0.2' stage='5' price='1800' skill='survival' lvl='4'>
				<craft id='radslime' kol='1'/>
				<craft id='vampfang' kol='1'/>
				<craft id='herbs' kol='5'/>
			</item>
			<item id='s_potion_mage'	tip='scheme' perk='potmaster' work='lab' chance='1' stage='3' price='500' skill='survival' lvl='1'>
				<craft id='app' kol='1'/>
				<craft id='sparklecola' kol='1'/>
				<craft id='herbs' kol='3'/>
			</item>
			<item id='s_potion_infra'	tip='scheme' perk='potmaster' work='lab' chance='0.5' stage='5' price='1600' skill='survival' lvl='3'>
				<craft id='bloateye' kol='2'/>
				<craft id='rattail' kol='2'/>
				<craft id='herbs' kol='5'/>
			</item>
			<item id='s_potion_pink'	tip='scheme' perk='potmaster' work='lab' chance='0' price='1000' skill='survival' lvl='3'>
				<craft id='pinkslime' kol='3'/>
				<craft id='app' kol='1'/>
				<craft id='herbs' kol='5'/>
			</item>
			<item id='s_potion_purif'	tip='scheme' perk='potmaster' work='lab' chance='0' price='1200' skill='survival' lvl='4'>
				<craft id='dsoul' kol='1'/>
				<craft id='mdust' kol='3'/>
				<craft id='herbs' kol='5'/>
			</item>
			<item id='s_potion_chance'	tip='scheme' perk='potmaster' work='lab' chance='0' price='4000' skill='survival' lvl='5'>
				<craft id='molefat' kol='3'/>
				<craft id='dsoul' kol='1'/>
				<craft id='whorn' kol='1'/>
				<craft id='herbs' kol='5'/>
			</item>
			<item id='s_rollup'	tip='scheme' work='lab' chance='0.1' stage='3' price='100' skill='survival' lvl='0'>
				<craft id='app' kol='1'/>
				<craft id='herbs' kol='5'/>
			</item>
			<item id='s_acid' tip='scheme' cat='item' work='lab' kol='15' chance='1' stage='3' price='500' skill='survival' lvl='2'>
				<craft id='acidslime' kol='5'/>
			</item>
			<item id='s_fuel' tip='scheme' cat='item' work='lab' kol='100' chance='1' stage='3' price='500' skill='survival' lvl='1'>
				<craft id='firegland' kol='1'/>
			</item>

			<!--   Вещества   -->
			<item id='s_ultradash'	tip='scheme' work='lab' chance='0.05' stage='5' price='750' skill='medic' lvl='2'>
				<craft id='dash' kol='1'/>
				<craft id='sparklecola' kol='1'/>
				<craft id='bloatwing' kol='1'/>
				<craft id='herbs' kol='3'/>
			</item>
			<item id='s_stampede'	tip='scheme' work='lab' chance='0.04' stage='5' price='1500' skill='medic' lvl='3'>
				<craft id='medx' kol='1'/>
				<craft id='rage' kol='1'/>
				<craft id='fishfat' kol='1'/>
				<craft id='herbs' kol='3'/>
			</item>
			<item id='s_pmint'	tip='scheme' work='lab' chance='0.03' stage='5' price='2500' skill='medic' lvl='4'>
				<craft id='mint' kol='1'/>
				<craft id='mdust' kol='1'/>
				<craft id='app' kol='1'/>
				<craft id='herbs' kol='5'/>
			</item>
			
			<!--   Элексиры   -->
			<item id='s_potion_dskel'	tip='scheme' work='lab' chance='0.6' stage='5' price='1300' skill='survival' lvl='3'>
				<craft id='acidslime' kol='5'/>
				<craft id='ratliver' kol='3'/>
				<craft id='taintextract' kol='1'/>
				<craft id='herbs' kol='10'/>
				<craft id='essence' kol='1'/>
			</item>
			<item id='s_potion_immun'	tip='scheme' work='lab' chance='1' stage='3' price='500' skill='survival' lvl='1'>
				<craft id='ghoulblood' kol='5'/>
				<craft id='radslime' kol='3'/>
				<craft id='hydrablood' kol='1'/>
				<craft id='herbs' kol='10'/>
				<craft id='essence' kol='1'/>
			</item>
			<item id='s_potion_might'	tip='scheme' work='lab' chance='0.4' stage='5' price='1700' skill='survival' lvl='4'>
				<craft id='molefat' kol='5'/>
				<craft id='vampfang' kol='3'/>
				<craft id='stardust' kol='1'/>
				<craft id='herbs' kol='10'/>
				<craft id='essence' kol='1'/>
			</item>
			<item id='s_potion_speed'	tip='scheme' work='lab' chance='1' stage='4' price='1000' skill='survival' lvl='2'>
				<craft id='bloatwing' kol='5'/>
				<craft id='rattail' kol='3'/>
				<craft id='rainbow' kol='1'/>
				<craft id='herbs' kol='10'/>
				<craft id='essence' kol='1'/>
			</item>
			<item id='s_potion_prec'	tip='scheme' work='lab' chance='0.4' stage='7' price='2000' skill='survival' lvl='5'>
				<craft id='bloateye' kol='5'/>
				<craft id='firegland' kol='3'/>
				<craft id='gland' kol='3'/>
				<craft id='moonstone' kol='1'/>
				<craft id='herbs' kol='10'/>
				<craft id='essence' kol='1'/>
			</item>
			<item id='s_potion_elements'	tip='scheme' work='lab' chance='0' price='1000' skill='magic' lvl='3'>
				<craft id='mdust' kol='5'/>
				<craft id='firegland' kol='3'/>
				<craft id='firecrystal' kol='1'/>
				<craft id='herbs' kol='10'/>
				<craft id='essence' kol='1'/>
			</item>
			<item id='s_potion_dexter'	tip='scheme' work='lab' chance='0.3' stage='7' price='5000' skill='survival' lvl='4'>
				<craft id='acidslime' kol='5'/>
				<craft id='dsoul' kol='1'/>
				<craft id='darkfrag' kol='1'/>
				<craft id='herbs' kol='12'/>
				<craft id='essence' kol='1'/>
			</item>
			<item id='s_potion_crit'	tip='scheme' work='lab' chance='0.3' stage='8' price='2500' skill='survival' lvl='5'>
				<craft id='pinkslime' kol='5'/>
				<craft id='mdust' kol='3'/>
				<craft id='whorn' kol='1'/>
				<craft id='abssalt' kol='1'/>
				<craft id='herbs' kol='12'/>
				<craft id='essence' kol='1'/>
			</item>
			
			<!--   Едьба   -->
			<item id='s_frmeat' tip='scheme' tip2='co' chance2='1' work='stove' chance='0.1' price='100' skill='survival' lvl='0'>
				<craft id='meat' kol='1'/>
			</item>
			<item id='s_cucsand' tip='scheme' tip2='co' chance2='1' work='stove' chance='0.1' price='150' skill='survival' lvl='1'>
				<craft id='bread' kol='1'/>
				<craft id='cucumber' kol='1'/>
			</item>
			<item id='s_frpot' tip='scheme' tip2='co' chance2='1' work='stove' chance='0.1' price='200' skill='survival' lvl='1'>
				<craft id='potato' kol='1'/>
				<craft id='butter' kol='1'/>
			</item>
			<item id='s_oatmeal' tip='scheme' tip2='co' chance2='1' work='stove' chance='0.1' price='200' skill='survival' lvl='1'>
				<craft id='oats' kol='1'/>
				<craft id='milk' kol='1'/>
			</item>
			<item id='s_salad' tip='scheme' tip2='co' chance2='1' work='stove' chance='0.1' price='300' skill='survival' lvl='2'>
				<craft id='tomato' kol='1'/>
				<craft id='cucumber' kol='1'/>
				<craft id='cabbage' kol='1'/>
			</item>
			<item id='s_chpasta' tip='scheme' tip2='co' chance2='1' work='stove' chance='0.1' price='300' skill='survival' lvl='2'>
				<craft id='pasta' kol='1'/>
				<craft id='cheese' kol='1'/>
				<craft id='ketchup' kol='1'/>
			</item>
			<item id='s_omelet' tip='scheme' tip2='co' chance2='1' work='stove' chance='0.1' price='500' skill='survival' lvl='2'>
				<craft id='tegg' kol='2'/>
				<craft id='mushroom' kol='1'/>
				<craft id='crackers' kol='1'/>
			</item>
			<item id='s_butterbr' tip='scheme' tip2='co' chance2='1' work='stove' chance='0' price='300' skill='survival' lvl='2'>
				<craft id='bread' kol='1'/>
				<craft id='cheese' kol='1'/>
				<craft id='butter' kol='1'/>
			</item>
			<item id='s_breakfast' tip='scheme' tip2='co' chance2='1' work='stove' chance='0' price='500' skill='survival' lvl='3'>
				<craft id='bread' kol='1'/>
				<craft id='noodles' kol='1'/>
				<craft id='dinner' kol='1'/>
				<craft id='sbombs' kol='1'/>
			</item>
			<item id='s_soup' tip='scheme' tip2='co' chance2='1' work='stove' chance='0' price='500' skill='survival' lvl='3'>
				<craft id='potato' kol='1'/>
				<craft id='carrot' kol='1'/>
				<craft id='oats' kol='1'/>
				<craft id='onion' kol='1'/>
			</item>
			<item id='s_pizza' tip='scheme' tip2='co' chance2='1' work='stove' chance='0' price='800' skill='survival' lvl='3'>
				<craft id='flour' kol='1'/>
				<craft id='tomato' kol='1'/>
				<craft id='cheese' kol='1'/>
				<craft id='mushroom' kol='1'/>
				<craft id='ketchup' kol='1'/>
			</item>
			<item id='s_casser' tip='scheme' tip2='co' chance2='1' work='stove' chance='0' price='600' skill='survival' lvl='3'>
				<craft id='potato' kol='1'/>
				<craft id='cabbage' kol='1'/>
				<craft id='carrot' kol='1'/>
				<craft id='cheese' kol='1'/>
			</item>
			<item id='s_ragu' tip='scheme' tip2='co' chance2='0.8' work='stove' chance='0' price='1000' skill='survival' lvl='4'>
				<craft id='meat' kol='1'/>
				<craft id='potato' kol='1'/>
				<craft id='carrot' kol='1'/>
				<craft id='onion' kol='1'/>
				<craft id='ketchup' kol='1'/>
			</item>
			<item id='s_spsalad' tip='scheme' tip2='co' chance2='0.8' work='stove' chance='0' price='1200' skill='survival' lvl='4'>
				<craft id='corn' kol='1'/>
				<craft id='apple' kol='1'/>
				<craft id='cheese' kol='1'/>
				<craft id='cucumber' kol='1'/>
				<craft id='nuts' kol='1'/>
			</item>
			<item id='s_patty' tip='scheme' tip2='co' chance2='0.8' work='stove' chance='0' price='1200' skill='survival' lvl='4'>
				<craft id='milk' kol='1'/>
				<craft id='flour' kol='1'/>
				<craft id='tegg' kol='1'/>
				<craft id='butter' kol='1'/>
				<craft id='cabbage' kol='1'/>
			</item>
			<item id='s_maffin' tip='scheme' tip2='co' chance2='0.8' work='stove' chance='0' price='1500' skill='survival' lvl='4'>
				<craft id='flour' kol='1'/>
				<craft id='butter' kol='1'/>
				<craft id='sugar' kol='1'/>
				<craft id='tegg' kol='2'/>
				<craft id='coffee' kol='1'/>
			</item>
			<item id='s_apie' tip='scheme' tip2='co' chance2='0.5' work='stove' chance='0' price='2000' skill='survival' lvl='5'>
				<craft id='apple' kol='3'/>
				<craft id='milk' kol='1'/>
				<craft id='flour' kol='1'/>
				<craft id='sugar' kol='1'/>
				<craft id='butter' kol='1'/>
				<craft id='tegg' kol='1'/>
			</item>
			<item id='s_mpie' tip='scheme' tip2='co' chance2='0.5' work='stove' chance='0' price='2000' skill='survival' lvl='5'>
				<craft id='meat' kol='2'/>
				<craft id='milk' kol='1'/>
				<craft id='onion' kol='1'/>
				<craft id='flour' kol='1'/>
				<craft id='garlic' kol='1'/>
				<craft id='tegg' kol='1'/>
			</item>
			<item id='s_ppie' tip='scheme' tip2='co' chance2='0.5' work='stove' chance='0' price='2500' skill='survival' lvl='5'>
				<craft id='firegland' kol='1'/>
				<craft id='hooch' kol='1'/>
				<craft id='garlic' kol='1'/>
				<craft id='flour' kol='1'/>
				<craft id='chips' kol='1'/>
				<craft id='tegg' kol='1'/>
				<craft id='mushroom' kol='1'/>
			</item>
			<item id='s_spie' tip='scheme' tip2='co' chance2='0.5' work='stove' chance='0' price='2500' skill='survival' lvl='5'>
				<craft id='honey' kol='1'/>
				<craft id='lollipops' kol='1'/>
				<craft id='bananas' kol='1'/>
				<craft id='halva' kol='1'/>
				<craft id='sugar' kol='1'/>
				<craft id='flour' kol='1'/>
				<craft id='milk' kol='1'/>
			</item>
			<item id='s_borsch' tip='scheme' tip2='co' chance2='0.2' work='stove' chance='0' price='2000' skill='survival' lvl='5'>
				<craft id='beans' kol='1'/>
				<craft id='cabbage' kol='1'/>
				<craft id='potato' kol='1'/>
				<craft id='carrot' kol='1'/>
				<craft id='onion' kol='1'/>
				<craft id='tomato' kol='1'/>
				<craft id='garlic' kol='1'/>
			</item>
			
	<!--       *******   Активные объекты   *******         -->
			
			<!-- контейнеры -->
			<obj ed='2' ico='cont' id='safe' tip='box' explcrack='1' xp='50' hp='1200' shield='0.5' thre='200' mat='1' inter='1' cont='safe' lock='2.2' lockhp='16' mine='2' minech='0.6' massaMult='1.5' lurk='2' size='2' wid='2' fall='fall_metal_safe' open='safe_open'/>
			<obj ed='2' ico='cont' id='wallsafe' tip='box' explcrack='1' xp='50' hp='1200' thre='200' mat='1' inter='1' hack='1' wall='2' cont='safe' mine='3' minech='0.75' lock='2.5' lockhp='13' massaMult='1.5' size='1' wid='1' open='safe_open'/>
			<obj ed='2' ico='cont' id='chest' tip='box' inter='1' hp='400' shield='0.25' montdam='15' mat='1' cont='chest' rem='1' plav='0.5' lurk='3' lock='1.5' low='0.4' lockch='0.85' size='2' wid='1' fall='fall_metal_big' open='metal_open'/>
			<obj ed='3' ico='cont' id='case' inter='1' tip='box' cont='case' rem='1' plav='-1' size='1' wid='1' fall='fall_metal_small' massaMult='0.5'/>
			<obj ed='3' ico='cont' id='ammobox' inter='1' tip='box' hp='200' montdam='8' mat='1' cont='ammo' rem='1' lock='1' low='0.5' lockch='0.25' size='1' wid='1' fall='fall_metal_small' open='small_open'/>
			<obj ed='3' ico='cont' id='explbox' inter='1' tip='box' hp='200' montdam='8' mat='1' cont='expl' rem='1' lock='1.2' low='0.5' lockch='0.35' size='1' wid='1' fall='fall_metal_small' open='small_open'/>
			<obj ed='2' ico='cont' id='bigexpl' inter='1' tip='box' hp='400' shield='0.5' montdam='10' mat='3' cont='bigexpl' lock='1.2' low='0.2' lockch='0.75' size='3' wid='1' fall='fall_wood_big' open='wood_open'/>
			<obj ed='2' ico='cont' id='weapbox' inter='1' tip='box' hp='400' shield='0.5' montdam='15' mat='1' cont='wbattle' massaMult='1.5' lurk='2' lock='1.5' low='0.3' lockch='0.9' size='2' wid='2' fall='fall_metal_big' open='metal_open'/>
			<obj ed='2' ico='cont' id='weapcase' inter='1' tip='box' hp='500' shield='0.3' montdam='25' mat='1' cont='wbig' massaMult='2' lock='1.8' lockch='0.9' lurk='3' size='3' wid='1' fall='fall_metal_big' open='metal_open'/>
			<obj ed='2' ico='cont' id='bookcase' inter='1' tip='box' cont='book' mat='3' wall='1' size='2' plav='0.3' wid='3' fall='fall_wood_big'/>
			<obj ed='3' ico='cont' id='medbox' inter='1' tip='box' cont='med' mat='3' wall='1' size='1' wid='1' open='wood_open'/>
			<obj ed='2' ico='cont' id='bigmed' inter='1' tip='box' cont='med2' mat='3' massaMult='0.5' plav='0.3' lurk='2' size='2' wid='3' fall='fall_wood_big' open='wood_open'/>
			<obj ed='3' ico='cont' id='instr1' inter='1' tip='box' cont='instr' shield='0.3' mat='3' rem='1' massaMult='1.2' lock='1' low='0.7' lockch='0.3' lurk='3' size='2' wid='2' fall='fall_wood_big' open='wood_open'/>
			<obj ed='3' ico='cont' id='instr2' inter='1' tip='box' cont='instr2' mat='3' rem='1' wall='1' size='2' wid='1'/>
			<obj ed='3' ico='cont' id='table' inter='1' tip='box' cont='table' sur='1' shield='0.3' lock='1' low='0.5' lockch='0.25' mat='3' rem='1' plav='0.3' lurk='3' massaMult='0.5' size='2' wid='1' fall='fall_wood_small' open='wood_open'/>
			<obj ed='3' ico='cont' id='wallcab' tip='box' inter='1' cont='case' mat='1' rem='1' wall='2' lock='1' low='0.5' lockch='0.2' size='1' wid='1' open='wood_open'/>
			<obj ed='3' ico='cont' id='locker' inter='1' tip='box' cont='chest' mat='1' wall='1' lock='1' low='0.5' lockch='0.4' size='2' wid='3' open='metal_open'/>
			<obj ed='3' ico='cont' id='trash' inter='1' tip='box' cont='trash' rem='1' plav='-0.3' massaMult='0.5' size='1' wid='1' fall='fall_metal_small' open='small_open'/>
			<obj ed='3' ico='cont' id='cup' tip='box' inter='1' cont='cup' mat='3' shield='0.3' rem='1' plav='-0.5' lock='1' lockch='0.4' lurk='2' size='2' wid='2' fall='fall_wood_big' open='wood_open'/>
			<obj ed='3' ico='cont' id='tumba1' tip='box' inter='1' cont='case' mat='3' rem='1' size='1' wid='1' open='wood_open' fall='fall_wood_small'/>
			<obj ed='3' ico='cont' id='tumba2' tip='box' inter='1' cont='case' mat='1' rem='1' size='1' wid='1' fall='fall_metal_small' open='metal_open'/>
			<obj ed='3' ico='cont' id='filecab' tip='box' inter='1' cont='filecab' mat='1' rem='1' size='1' lurk='2' wid='2' fall='fall_metal_big' open='metal_open'/>
			<obj ed='3' ico='cont' id='fridge' tip='box' inter='1' cont='fridge' mat='1' shield='0.3' rem='1' size='1' wid='2' lurk='2' fall='fall_metal_big' open='metal_open'/>
			<obj ed='3' ico='cont' id='ccup' tip='box' inter='1' massaMult='1.5' mat='3' cont='food' rem='1' size='1' wid='1' fall='fall_wood_big' open='wood_open'/>
			<obj ed='3' ico='cont' id='wcup' tip='box' inter='1' wall='1' cont='food' mat='3' rem='1' size='1' wid='1' fall='fall_wood_big' open='wood_open'/>
			<obj ed='3' ico='cont' id='tap' tip='box' inter='1' massaMult='1.5' cont='trash' mat='3' rem='1' size='1' wid='1' scy='45' fall='fall_wood_big' open='wood_open'/>
			<obj ed='2' ico='cont' id='cryocap' inter='1' tip='box' cont='cryo' mat='1' wall='1' size='2' wid='3'/>
			<obj ed='2' ico='cont' id='basechest' n='Сундук базы' tip='box' inter='1' hp='400' shield='0.25' montdam='25' mat='1' cont='chest' rem='1' plav='0.5' lurk='3' lock='1.5' locktip='2' low='0.4' lockch='0.85' size='2' wid='1' fall='fall_metal_big' open='metal_open'/>
			<obj ed='2' ico='cont' id='enclchest' n='Сундук Анклава' tip='box' inter='1' hp='400' shield='0.25' montdam='25' mat='1' cont='chest' rem='1' plav='0.5' lurk='3' lock='1.5' low='0.4' lockch='0.85' size='2' wid='1' fall='fall_metal_big' open='metal_open'/>
			<obj ed='2' ico='cont' id='enclcase' n='Ящик Анклава' inter='1' tip='box' hp='500' shield='0.3' montdam='25' mat='1' cont='wbig' massaMult='2' lock='1.8' lockch='0.9' lurk='3' size='3' wid='1' fall='fall_metal_big' open='metal_open'/>
			
			<!-- двери -->
			<obj ed='6' ico='door' id='septum' tip='door' door='1' wall='2' hp='30' mat='3' size='1' wid='3' n='Деревянная стенка' die='break_wood'/>
			<obj ed='6' ico='door' id='grate' inter='0' tip='door' door='1' phis='2' wall='2' opac='0.1' hp='1000' thre='100' mat='1' size='1' wid='3' n='Решётка верт' open='big_door_close' close='big_door_close' die='break_metal'/>
			<obj ed='6' ico='door' id='hgrate' inter='0' tip='door' door='1' phis='2' wall='2' opac='0.1' hp='1000' thre='100' mat='1' size='3' wid='1' n='Решётка гор' open='big_door_close' close='big_door_close' die='break_metal'/>
			<obj ed='6' ico='door' id='platform1' inter='0' tip='door' door='1' wall='2' hp='5000' thre='800' mat='1' size='3' wid='1' open='big_door_close' close='big_door_close' n='Твёрдая платформа' die='break_metal'/>
			<obj ed='7' ico='door' id='window1' tip='door' door='1' wall='2'  opac='0.2' hp='10' mat='5' size='1' wid='2' n='Окно' die='break_glass'/>
			<obj ed='6' ico='door' id='window2' tip='door' door='1' wall='2' opac='0.2' hp='1000' thre='100' mat='5' size='1' wid='2' n='Бронированное окно' die='break_glass'/>
			<obj ed='7' ico='door' id='door1' inter='1' tip='door' door='1' opac='0.8' wall='2' hp='60' thre='10' lockch='0.3' low='0.8' lock='1' mat='3' size='1' wid='2' open='wood_door_open' close='wood_door_close' die='break_wood'/>
			<obj ed='7' ico='door' id='door1a' inter='1' tip='door' door='1' opac='0.8' wall='2' hp='300' thre='50' lock='1' low='0.8' lockch='0.6' mat='3' size='1' wid='2' open='wood_door_open' close='wood_door_close' die='break_wood'/>
			<obj ed='7' ico='door' id='door1b' inter='1' tip='door' door='1' opac='0.8' wall='2' hp='400' thre='50' lock='1.3' low='0.8' lockch='0.8' mat='1' size='1' wid='2' open='metal_door_open' close='metal_door_close' die='break_metal'/>
			<obj ed='6' ico='door' id='door2' inter='1' tip='door' hack='1' door='2' wall='1'  hp='1000' thre='100' lock='1.5' low='0.8' lockch='0.8' mat='1' size='1' wid='2' open='metal_door_open' close='metal_door_close' die='break_metal'/>
			<obj ed='6' ico='door' id='door2a' inter='1' tip='door' door='2' wall='1' scx='40'  hp='1000' thre='100' locktip='2' low='0.5' lock='1.4' mat='1' size='1' wid='2' open='metal_door_open' close='metal_door_close' n='Дверь с электронным замком' die='break_metal'/>
			<obj ed='6' ico='door' id='stdoor' inter='1' time='15' tip='door' hack='1' door='2' wall='1' mine='1' minetip='6' minech='0.2' low='0.7' hp='1000' thre='100' lock='1.2' lockch='0.8' mat='1' size='1' wid='3' open='metal_door_open' close='metal_door_close' die='break_metal'/>
			<obj ed='6' ico='door' id='basedoor' inter='1' time='15' tip='door' hack='1' door='2' wall='1' mine='1' minetip='6' minech='0.2' low='0.7' hp='4000' thre='800' lock='1.2' lockch='0.8' mat='1' size='1' wid='3' open='metal_door_open' close='metal_door_close' die='break_metal'/>
			<obj ed='6' ico='door' id='door3' inter='1' time='15' tip='door' hack='1' door='1' wall='2'  hp='5000' thre='800' lock='3' lockhp='16' mat='1' size='1' wid='3' open='big_door_close' close='big_door_close' die='break_metal'/>
			<obj ed='6' ico='door' id='door4' inter='1' time='15' tip='door' hack='1' locktip='4' once='1' door='1' opac='0.3' wall='2'  hp='5000' thre='800' lock='3' lockhp='10' mat='7' size='1' wid='3' open='pole_off' die='pole_off'/>
			<obj ed='7' ico='door' id='hatch1' inter='1' tip='door' door='1' opac='0.8' wall='2' hp='60' thre='10' lock='1' low='0.8' lockch='0.2' mat='3' size='2' wid='1' open='wood_door_open' close='wood_door_close' die='break_wood'/>
			<obj ed='6' ico='door' id='hatch2' inter='1' tip='door' door='1' wall='2' hp='1000' thre='100' lock='1.5' low='0.8' lockch='0.8'  mat='1' size='2' wid='1' open='metal_door_open' close='metal_door_close' die='break_metal'/>
			<obj ed='6' ico='door' id='encldoor' inter='1' time='15' tip='door' hack='1' door='2' wall='1' mine='1' minetip='6' minech='0.2' low='0.7' hp='4000' thre='800' lock='1.2' lockch='0.8' mat='1' size='1' wid='3' open='metal_door_open' close='metal_door_close' die='break_metal'/>
			<obj ed='6' ico='door' id='enclpole' inter='1' time='15' tip='door' hack='1' locktip='4' once='1' door='1' opac='0.3' wall='2'  hp='5000' thre='800' lock='3' lockhp='10' mat='7' size='1' wid='3' open='pole_off' die='pole_off'/>
			<!-- физические объекты -->
			<obj ed='1' ico='phis' id='woodbox' tip='box' mat='3' massa='15' shield='0.4' lurk='2' size='2' plav='-0.5' wid='2' fall='fall_wood_big'/>
			<obj ed='1' ico='phis' id='mcrate1' tip='box' mat='1' massa='25' shield='0.5' lurk='2' size='2' plav='-0.5' wid='2' fall='fall_metal_big' n='м ящик 25 кг'/>
			<obj ed='1' ico='phis' id='box' tip='box' mat='3' massa='50' size='2' shield='0.7' lurk='2' plav='0.5' wid='2' fall='fall_wood_big'/>
			<obj ed='1' ico='phis' id='mcrate2' tip='box' mat='1' massa='75' size='2' shield='0.75' lurk='2' wid='2' fall='fall_metal_big' n='м ящик 75 кг'/>
			<obj ed='1' ico='phis' id='mcrate3' tip='box' mat='1' massa='120' size='2' shield='0.75' lurk='2' wid='2' fall='fall_metal_big' n='м ящик 120 кг'/>
			<obj ed='1' ico='phis' id='bigbox' tip='box' mat='1' massa='175' size='3' shield='0.85' lurk='2' wid='2' fall='fall_metal_big'/>
			<obj ed='1' ico='phis' id='bigbox2' tip='box' mat='1' massa='500' size='3' shield='0.85' lurk='2' wid='3' fall='fall_metal_big'/>
			<obj ed='1' ico='phis' id='mcrate4' tip='box' mat='1' massa='1000' size='2' shield='0.9' lurk='2' wid='2' fall='fall_metal_safe' n='м ящик 1000 кг'/>
			<obj ed='1' ico='phis' id='mcrate5' tip='box' mat='1' massa='500' size='3' shield='0.85' lurk='2' wid='3' fall='fall_metal_safe' n='м ящик 500 кг'/>
			<obj ed='1' ico='phis' id='radbarrel' tip='box' mat='1' massa='100' size='1' shield='0.2' wid='2' rad='3' fall='fall_metal_big'/>
			<obj ed='1' ico='phis' id='radbigbarrel' tip='box' mat='1' massa='1100' size='2' shield='0.75' lurk='2' wid='3' rad='9' radrad='400' radtip='0' fall='fall_metal_big'/>
			
			<obj ed='1' ico='phis' id='couch' tip='box' mat='3' massaMult='4' size='2' shield='0.2' plav='0.5' lurk='3' wid='1' scy='20' fall='fall_wood_big'/>
			<obj ed='1' ico='phis' id='bed' tip='box' mat='3' massaMult='1' size='4' plav='0.5' wid='1' lurk='3' scy='28' fall='fall_wood_big'/>
			<obj ed='1' ico='phis' id='table1' mat='3' tip='box' massaMult='0.5' size='2' plav='-0.2' lurk='3' wid='1' fall='fall_wood_small'/>
			<obj ed='1' ico='phis' id='table2' mat='1' tip='box' sur='1' massaMult='0.5' size='2' plav='0.7' lurk='3' wid='1' fall='fall_metal_small'/>
			<obj ed='1' ico='phis' id='table4' mat='1' tip='box' sur='1' massaMult='0.5' size='2' plav='0.7' lurk='3' wid='1' fall='fall_metal_small'/>
			<obj ed='1' ico='phis' id='longtable' mat='1' tip='box' sur='1' massaMult='0.5' size='2' plav='0.7' lurk='3' wid='1' fall='fall_metal_small'/>
			
			<obj ed='1' ico='phis' id='niche1' tip='box' wall='2' lurk='1' size='2' wid='2' n='Ниша с трубами'/>
			<!-- терминалы -->
			<obj ed='5' ico='term' id='term' inter='2' locktip='2' tip='box' wall='1' size='1' wid='1'/>
			<obj ed='5' ico='term' id='term1' inter='2' locktip='2' tip='box' lock='3' time='30' allact='hack_robot' wall='1' size='1' wid='1'/>
			<obj ed='5' ico='term' id='term2' inter='2' locktip='2' tip='box' lock='2' time='30' allact='hack_lock' wall='1' size='1' wid='1'/>
			<obj ed='5' ico='term' id='term3' inter='2' locktip='2' tip='box' xp='50' cont='info' time='30' lock='2' mine='1' minetip='6' minech='0.3' wall='1' size='1' wid='1'/>
			<obj ed='5' ico='term' id='termh' inter='2' locktip='2' tip='box' wall='1' time='20' allact='prob_help' size='1' wid='1'/>
			<obj ed='5' ico='term' id='elpanel' inter='2' locktip='2' tip='box' lock='3' wall='2' time='20' knop='1' allact='electro_check' electro='100' size='1' wid='1'/>
			
			<!-- кнопки -->
			<obj ed='4' ico='but' id='knop1' nazv='knop' n='Кнопка' inter='4' tip='box' knop='1' wall='1' size='1' wid='1' open='button' close='button'/>
			<obj ed='4' ico='but' id='knop2' nazv='knop' n='Кнопка, нажимается пулями' actdam='1' inter='4' tip='box' knop='1' wall='1' size='1' wid='1'/>
			<obj ed='4' ico='but' id='knop3' nazv='knop' n='Кнопка, нуждается в ремонте' inter='4' lock='2' locktip='5' tip='box' knop='1' wall='1' size='1' wid='1' open='button' close='button'/>
			<obj ed='4' ico='but' id='knop4' nazv='knop' n='Кнопка с кодовым замком' inter='4' lock='2' locktip='2' tip='box' knop='1' wall='1' size='1' wid='1' open='button' close='button'/>
			<obj ed='4' ico='but' id='platform2' inter='0' tip='box' shelf='1' wall='1' sloy='1' mat='1' size='3' wid='1' scy='39' n='Платформа'/>
			<obj ed='4' ico='but' id='platform3' inter='0' tip='box' shelf='1' wall='1' sloy='1' size='3' wid='1' scy='39' n='Платформа пл'/>
			<obj ed='4' ico='but' id='dsph' n='Тёмная сфера' inter='2' tip='box' knop='1' allact='bind' wall='1' size='1' wid='1' open='button' close='button'/>

			<!-- двери z-->
			<obj ed='8' ico='door' id='indoor1' inter='8' tip='box' wall='2' size='2' wid='2' time='10' allact='comein' open='wood_door_open' n='Деревянная дверь Z'/>
			<obj ed='8' ico='door' id='indoor2' inter='8' tip='box' wall='2' size='2' wid='2' time='10' allact='comein' open='wood_door_open' n='Усиленная дверь Z'/>
			<obj ed='8' ico='door' id='indoor3' inter='8' tip='box' wall='2' size='2' wid='2' time='10' allact='comein' open='metal_door_open' n='Вентиляция Z'/>
			<obj ed='8' ico='door' id='indoor4' inter='8' tip='box' wall='2' size='2' wid='2' time='10' allact='comein' open='metal_door_open' n='Прочная дверь Z'/>
			<obj ed='8' ico='door' id='instdoor' inter='8' tip='box' wall='2' size='3' wid='3' time='10' allact='comein' open='metal_door_open' n='Дверь стойла Z'/>
			<obj ed='8' ico='door' id='inbasedoor' inter='8' tip='box' wall='2' size='3' wid='3' time='10' allact='comein' open='metal_door_open' n='Дверь базы Z'/>
			<obj ed='8' ico='door' id='inencldoor' inter='8' tip='box' wall='2' size='3' wid='3' time='10' allact='comein' open='metal_door_open' n='Дверь Анклава Z'/>
			
			<!-- активные объекты -->
			<obj ed='11' ico='npc' tip='spawnpoint' id='player' n='Точка появления' size='2' wid='2'/>
			<obj ed='12' ico='npc' tip='unit' id='npc' cl='UnitNPC' n='NPC' size='2' wid='2'/>
			<obj ed='12' ico='npc' tip='unit' id='vendor' cl='UnitNPC' cid='vendor' n='Торговец' size='2' wid='2'/>
			<obj ed='12' ico='npc' tip='unit' id='doctor' cl='UnitNPC' cid='doctor' n='Доктор' size='2' wid='2'/>
			
			<!-- случайные противники -->
			<obj ed='13' ico='rnd' rem='1' tip='up' tipn='1' id='enl1' n='Враг мелкий ползучий' size='1' wid='1'/>
			<obj ed='13' ico='rnd' rem='1' tip='up' tipn='2' id='enl2' n='Враг обычный' size='2' wid='2'/>
			<obj ed='13' ico='rnd' rem='1' tip='up' tipn='3' id='enf1' n='Враг мелкий летучий' size='1' wid='1'/>
			<obj ed='13' ico='rnd' rem='1' tip='up' tipn='4' id='enc1' n='Враг мелкий потолочный' size='1' wid='1'/>
			<obj ed='18' ico='rnd' rem='1' tip='up' tipn='5' id='lov' n='Ловушка' size='1' wid='1'/>
			
			<!-- заданные противники -->
			<obj ed='14' ico='pon' tip='unit' id='raider' cl='UnitRaider' n='Рейдер' size='2' wid='2'/>
			<obj ed='14' ico='pon' tip='unit' id='slaver' cl='UnitSlaver' n='Работорговец' size='2' wid='2'/>
			<obj ed='14' ico='pon' tip='unit' id='zebra' cl='UnitZebra' n='Зебра' size='2' wid='2'/>
			<obj ed='14' ico='pon' tip='unit' id='ranger' cl='UnitRanger' n='Стальной Рейнджер' size='2' wid='2'/>
			<obj ed='14' ico='pon' tip='unit' id='merc' cl='UnitMerc' n='Наёмник' size='2' wid='2'/>
			<obj ed='14' ico='pon' tip='unit' id='encl' cl='UnitEncl' n='Солдат Анклава' size='2' wid='2'/>
			<obj ed='14' ico='pon' tip='unit' id='bossraider' cl='UnitBossRaider' n='Главарь рейдеров' size='3' wid='3'/>
			<obj ed='14' ico='pon' tip='unit' id='bossnecr' cl='UnitBossNecr' n='Некромант' size='2' wid='2'/>
			<obj ed='14' ico='pon' tip='unit' id='bossencl' cl='UnitBossEncl' n='Командир Анклава' size='3' wid='3'/>
			<obj ed='14' ico='pon' tip='unit' id='zombie' cl='UnitZombie' n='Зомби' size='2' wid='2'/>
			<obj ed='14' ico='pon' tip='unit' id='alicorn' cl='UnitAlicorn' n='Аликорн' size='2' wid='3'/>
			<obj ed='14' ico='pon' tip='unit' id='bossalicorn' cl='UnitBossAlicorn' n='Супер-Аликорн' size='3' wid='3'/>
			<obj ed='14' ico='mon' tip='unit' id='hellhound' cl='UnitHellhound' n='Гончая' size='2' wid='3'/>
			<obj ed='15' ico='mon' tip='unit' id='bloat' cl='UnitBloat' n='Блотспрайт' size='1' wid='1'/>
			<obj ed='15' ico='mon' tip='unit' id='tarakan' cl='UnitMonstrik' cid='tarakan' n='Таракан' size='1' wid='1'/>
			<obj ed='15' ico='mon' tip='unit' id='rat' cl='UnitMonstrik' cid='rat' n='Крыса' size='1' wid='1'/>
			<obj ed='15' ico='mon' tip='unit' id='ant' cl='UnitAnt' n='Муравей' size='1' wid='1'/>
			<obj ed='15' ico='mon' tip='unit' id='molerat' cl='UnitMonstrik' cid='molerat' n='Кротокрыс' size='2' wid='1'/>
			<obj ed='15' ico='mon' tip='unit' id='scorp' cl='UnitMonstrik' cid='scorp' n='Радскорпион' size='2' wid='1'/>
			<obj ed='15' ico='mon' tip='unit' id='scorp3' cl='UnitMonstrik' cid='scorp3' n='Ужасный скорпион' size='2' wid='1'/>
			<obj ed='15' ico='mon' tip='unit' id='slime' cl='UnitSlime' n='Слизень' size='1' wid='1'/>
			<obj ed='15' ico='mon' tip='unit' id='bloodwing' cl='UnitBat' n='Кровокрыл' size='1' wid='1'/>
			<obj ed='15' ico='mon' tip='unit' id='fish' cl='UnitFish' n='Рыба' size='1' wid='1'/>
			<obj ed='15' ico='mon' tip='unit' id='necros' cl='UnitNecros' n='Некроспрайты' size='2' wid='2'/>
			<obj ed='15' ico='mon' tip='unit' id='ebloat' cl='UnitBloatEmitter' n='Гнездо' size='2' wid='3'/>
			<obj ed='15' ico='mon' tip='unit' id='eant' cid='eant' cl='UnitBloatEmitter' n='Муравейник' size='2' wid='2'/>
			
			<obj ed='16' ico='tur' tip='unit' id='turret' cl='UnitTurret' cid='floor' n='Потолочная турель' size='1' wid='1'/>
			<obj ed='16' ico='tur' tip='unit' id='landturret' cl='UnitTurret' cid='land' n='Наземная турель' size='1' wid='2'/>
			<obj ed='16' ico='tur' tip='unit' id='armturret' cl='UnitTurret' cid='arm' n='Усиленная турель' size='1' wid='2'/>
			<obj ed='16' ico='tur' tip='unit' id='hturret' cl='UnitTurret' cid='hidden' n='Спрятанная турель' size='1' wid='1'/>
			<obj ed='16' ico='tur' tip='unit' id='hturret2' cl='UnitTurret' cid='hidden2' n='Неактивная турель' size='1' wid='1'/>
			<obj ed='16' ico='tur' tip='unit' id='wturret' cl='UnitTurret' cid='wall' n='Стенная турель' size='1' wid='1'/>
			<obj ed='16' ico='tur' tip='unit' id='cturret' cl='UnitTurret' cid='combat' n='Боевая турель' size='1' wid='1'/>
			<obj ed='16' ico='tur' tip='unit' id='bossturret' cl='UnitTurret' cid='boss' n='Турель-босс' size='1' wid='1'/>
			<obj ed='17' ico='rob' tip='unit' id='robot' cl='UnitRobobrain' n='Робот' size='2' wid='2'/>
			<obj ed='17' ico='rob' tip='unit' id='protect' cl='UnitProtect' n='Протектопон' size='2' wid='2'/>
			<obj ed='17' ico='rob' tip='unit' id='gutsy' cl='UnitGutsy' n='Мистер Храбрец' size='2' wid='2'/>
			<obj ed='17' ico='rob' tip='unit' id='eqd' cl='UnitEqd' n='Эквидроид' size='2' wid='2'/>
			<obj ed='17' ico='rob' tip='unit' id='sentinel' cl='UnitSentinel' n='Страж' size='3' wid='3'/>
			<obj ed='17' ico='rob' tip='unit' id='ultra' cl='UnitBossUltra' n='Ультра-Страж' size='3' wid='3'/>
			<obj ed='17' ico='rob' tip='unit' id='megadron' cl='UnitBossDron' n='Мега-Дрон' size='3' wid='3'/>
			<obj ed='17' ico='rob' tip='unit' id='roller' cl='UnitRoller' n='Роллер' size='1' wid='1'/>
			<obj ed='17' ico='rob' tip='unit' id='spritebot' cl='UnitSpriteBot' n='Спрайтбот' size='1' wid='1'/>
			<obj ed='17' ico='rob' tip='unit' id='vortex' cl='UnitVortex' n='Вертушка' size='1' wid='1'/>
			<obj ed='17' ico='rob' tip='unit' id='dron' cl='UnitDron' n='Дрон' size='1' wid='1'/>
			<obj ed='17' ico='rob' tip='unit' id='msp' cl='UnitMsp' n='Мина-паук' size='1' wid='1'/>
			<obj ed='17' ico='rob' tip='unit' id='thunderhead' cl='UnitThunderHead' n='Тандерхед' size='3' wid='3'/>
			
			
			<!-- ловушки -->
			<obj ed='18' ico='mine' tip='unit' id='mine' cl='Mine' n='Мина' size='1' wid='1'/>
			<obj ed='18' ico='mine' tip='unit' id='trap' cl='UnitTrap' n='Капкан' size='1' wid='1'/>
			<obj ed='18' ico='mine' tip='unit' id='trcans' cl='UnitTrigger' cid='trigcans' n='Банки' size='1' wid='2'/>
			<obj ed='18' ico='mine' tip='unit' id='trridge' cl='UnitTrigger' cid='trigridge' n='Растяжка' size='1' wid='1'/>
			<obj ed='18' ico='mine' tip='unit' id='trplate' cl='UnitTrigger' cid='trigplate' n='Плита' size='1' wid='1'/>
			<obj ed='18' ico='mine' tip='unit' id='trlaser' cl='UnitTrigger' cid='triglaser' n='Лазер' size='1' wid='1'/>
			<obj ed='18' ico='mine' tip='unit' id='damshot' cl='UnitDamager' cid='damshot' n='Пушка' size='1' wid='2'/>
			<obj ed='18' ico='mine' tip='unit' id='damgren' cl='UnitDamager' cid='damgren' n='Связка гранат' size='1' wid='1'/>
			<obj ed='18' ico='mine' tip='unit' id='expl1' cl='UnitDamager' cid='damexpl1' n='Взрывчатка' size='1' wid='1'/>
			<obj ed='18' ico='mine' tip='unit' id='transm' cl='UnitTransmitter' n='Передатчик' size='1' wid='1'/>
			<obj ed='18' ico='mine' tip='unit' id='mines' n='Минное поле' size='5' wid='1'/>
			<obj ed='19' ico='mine' id='spikes' n='Шипы' tip='trap' att='1' bind='1' size='1' wid='1' damage='50'/>
			<obj ed='19' ico='mine' id='fspikes' n='Потолочные шипы' att='2' bind='2' floor='1' sY='20' tip='trap' size='1' wid='1' damage='15'/>
			<obj ed='19' ico='mine' id='moln1' tip='box' knop='1' wall='2' moln='400' period='40' size='1' wid='3' scx='30'/>
			
			
			<!-- особое -->
			<obj ed='10' ico='area' tip='area' id='area' n='Область' size='2' wid='2'/>
			<obj ed='9' ico='' tip='checkpoint' id='checkpoint' n='Контрольная точка' size='2' wid='3'/>
			<obj ed='9' ico='' tip='checkpoint' id='checkpoint1' nazv='checkpoint' n='КТ с замком' locktip='1' low='0.2' lock='1.4' size='2' wid='3'/>
			<obj ed='9' ico='' tip='checkpoint' id='checkpoint2' nazv='checkpoint' n='КТ с эл замком' locktip='2' low='0.2' lock='1.4' size='2' wid='3'/>
			<obj ed='9' ico='' tip='checkpoint' id='checkpoint3' nazv='checkpoint' n='КТ сломанный' locktip='5' lock='2' size='2' wid='3'/>
			<obj ed='9' ico='' tip='checkpoint' id='checkpoint4' nazv='checkpoint' n='КТ с бомбой'  mine='1' minetip='3' size='2' wid='3'/>
			<obj ed='9' ico='' tip='checkpoint' id='checkpoint5' nazv='checkpoint' n='КТ с сигнал'  mine='1' minetip='6' size='2' wid='3'/>
			<obj ed='5' ico='' id='work' inter='2' tip='box' allact='work' n='Верстак' lurk='3' size='2' wid='2' scy='37' fall='fall_wood_big'/>
			<obj ed='5' ico='' id='himlab' inter='2' tip='box' massaMult='0.5' allact='lab' lurk='3' n='Лаборатория' size='2' wid='2' scy='33' fall='fall_wood_ыьфдд'/>
			<obj ed='5' ico='' id='stove' tip='box' inter='2' massaMult='2' allact='stove' mat='1' size='1' wid='1' fall='fall_metal_big'/>
			<obj ed='9' ico='' id='exit' inter='9' time='60' tip='box' wall='1' allact='exit' n='Выход с уровня' size='2' wid='3'/>
			<obj ed='9' ico='' id='doorout' inter='11' time='10' tip='box' allact='probreturn' wall='1' n='Дверь возврата' size='2' wid='3'/>
			<obj ed='9' ico='' id='doorprob' inter='8' time='30' tip='box' wall='1' n='Дверь испытания' size='2' wid='3'/>
			<obj ed='9' ico='' id='doorboss' inter='8' time='30' tip='box' wall='1' n='Дверь битвы' size='2' wid='3'/>
			<obj ed='9' ico='' id='wmap' inter='10' tip='box' wall='1' allact='map' n='Карта' size='4' wid='3'/>
			<obj ed='9' ico='' id='stand' inter='2' tip='box' wall='1' allact='stand' n='Стенд' size='4' wid='3'/>
			<obj ed='9' ico='' id='vault' inter='2' tip='box' wall='1' allact='vault' n='Хранилище' size='2' wid='1'/>
			<obj ed='1' ico='' id='table3' inter='2' allact='app' mat='3' tip='box' massaMult='0.5' size='2' plav='-0.2' lurk='3' scy='28' wid='1' fall='fall_wood_small'/>
			<obj ed='9' ico='' tip='enspawn' id='enspawn' n='Точка спавна врагов' size='2' wid='2'/>
			<obj ed='5' ico='' id='p_luna' tip='box' inter='2' wall='1' allact='take' size='3' wid='4'/>
			<obj ed='5' ico='' id='barst' tip='box' wall='1' size='3' wid='1' n='Стойка бара'/>
			<obj ed='5' ico='' id='smotr' tip='box' size='5' wall='1' wid='1' n='Стол смотрителя' scy='40' />
			<obj ed='5' ico='' id='camp' tip='box' wall='1' size='6' wid='2' n='Лагерь'/>
			<obj ed='5' ico='' id='brspr' tip='box' wall='1' size='2' wid='1' n='Обломки спрайтбота'/>
			<obj ed='9' ico='' id='xp' tip='bonus' n='Опыт' size='1' wid='1'/>
			<obj ed='4' ico='' id='detonator' n='Детонатор' inter='4' tip='box' knop='1' scy='30' scx='36' size='1' wid='1' fall='fall_wood_small'/>
			<obj ed='4' ico='' id='robocell' cont='robocell' inter='5' locktip='2' lock='2' allact='robocell' once='1' tip='box' wall='1' size='2' wid='2'/>
			<obj ed='4' ico='' id='alarm' inter='5' mine='1' minetip='6' allact='alarm' once='1' tip='box' wall='1' size='1' wid='2'/>
			<obj ed='5' ico='' id='reactor' tip='box' size='8' wid='18' scy='220' massa='50000' n='Реактор' rad='25' radrad='400'/>
			<obj ed='4' ico='' id='generat' tip='box' wall='1' size='6' wid='4'/>
			<obj ed='1' ico='' id='tcloud1' tip='box' wall='2' size='1' wid='1' rad='5' radtip='1' radrad='200' n='Облако газа' sloy='3' scy='1' scx='1'/>
			<obj ed='1' ico='' id='pcloud1' tip='box' wall='2' size='1' wid='1' rad='25' radtip='2' radrad='200' n='Розовое облако' sloy='3' scy='1' scx='1'/>
			<obj ed='6' ico='' id='alib1' inter='0' tip='door' door='1' phis='1' wall='2' opac='0.1' hp='10000' thre='1000' mat='7' size='1' wid='7' n='А-Поле верт' open='pole_off' die='pole_off'/>
			<obj ed='6' ico='' id='alib2' inter='0' tip='door' door='1' phis='1' wall='2' opac='0.1' hp='10000' thre='1000' mat='7' size='7' wid='1' n='А-Поле гор' open='pole_off' die='pole_off'/>
			<obj ed='8' ico='' id='door_st1' inter='8' tip='box' wall='2' size='6' wid='6' allact='comein' n='Дверь стойла снаружи'/>
			<obj ed='8' ico='' id='door_st2' inter='8' tip='box' wall='2' size='6' wid='6' allact='comein' n='Дверь стойла изнутри'/>
			<obj ed='8' ico='' id='aaa' inter='0' knop='1' tip='box' wall='1' size='4' wid='5' n='Стенд с бронёй'/>
			<obj ed='8' ico='' id='tomb' inter='0' tip='box' wall='1' size='2' wid='2' n='Могила'/>
			<obj ed='12' ico='npc' tip='unit' id='ponpon' cl='UnitPonPon' n='Пони' size='2' wid='2'/>
			<obj ed='12' ico='npc' tip='unit' id='zebpon' cl='UnitPonPon' cid='zebra' n='Зебра' size='2' wid='2'/>
			<obj ed='12' ico='npc' tip='unit' id='stabpon' cl='UnitPonPon' cid='stab' n='Житель стойла' size='2' wid='2'/>
			<obj ed='12' ico='npc' tip='unit' id='captive' cl='UnitCaptive' n='Пленник в клетке' size='2' wid='3'/>
			<obj ed='13' ico='pon' tip='unit' id='training' cl='UnitTrain' n='Тренировочный' size='2' wid='2'/>
			<obj ed='14' ico='' tip='unit' id='spectre' cl='UnitSpectre' n='Призрак' size='2' wid='2'/>
			<obj ed='14' ico='' tip='unit' id='stolp' cid='1' cl='UnitDestr' n='Реактор тандерхеда' size='4' wid='20'/>
			
	<!--       *******   Броня   *******         -->
			
			<armor id='pip' sort='0' clo='1' hp='5000' price='100' und='1' norep='1'>
				<upd dexter='0.2'/>
			</armor>
			<armor id='kombu' sort='1' hp='2000' price='800' lvl='2' kolcomp='2'>
				<upd armor='4' marmor='3' qual='0.6' fire='0.1' cryo='0.1' dexter='0.15'/>
				<upd armor='5' marmor='4' qual='0.7' fire='0.1' cryo='0.1' dexter='0.15' kol='10'/>
				<upd armor='6' marmor='5' qual='0.8' fire='0.1' cryo='0.1' dexter='0.15' kol='20'/>
			</armor>
			<armor id='antirad' sort='21' clo='1' hp='2000' price='1500' h2o='0.25' lvl='2' kolcomp='2' hide='1'>
				<upd armor='2' marmor='1' qual='1' radx='0.5' venom='0.25' acid='0.25'/>
				<upd armor='3' marmor='1' qual='1' radx='0.6' venom='0.3' acid='0.3' kol='15'/>
				<upd armor='4' marmor='1' qual='1' radx='0.7' venom='0.35' acid='0.35' kol='30'/>
			</armor>
			<armor id='antihim' sort='22' clo='1' hp='3000' price='2200' h2o='0.25' lvl='2' kolcomp='2' hide='1'>
				<upd armor='1' marmor='2' qual='1' venom='0.7' acid='0.7' spark='0.25'/>
				<upd armor='1' marmor='3' qual='1' venom='0.75' acid='0.75' spark='0.25' kol='15'/>
				<upd armor='1' marmor='4' qual='1' venom='0.8' acid='0.8' spark='0.25' kol='30'/>
			</armor>
			<armor id='skin' sort='2' hp='4000' price='5000' lvl='2' kolcomp='4'>
				<upd armor='5' marmor='5' qual='0.7' fire='0.2' fang='0.2' laser='0.1' spark='0.1'/>
				<upd armor='6' marmor='6' qual='0.75' fire='0.25' fang='0.25'  laser='0.1' spark='0.1' kol='15'/>
				<upd armor='7' marmor='7' qual='0.8' fire='0.3' fang='0.3' laser='0.1' spark='0.1' kol='30'/>
			</armor>
			<armor id='metal' sort='3' hp='5000' price='4000' lvl='2' kolcomp='4'>
				<upd armor='12' qual='0.5' bul='0.2' phis='0.1' blade='0.1' fang='0.1' expl='0.1' laser='0.25' spark='-0.3' dexter='-0.3'/>
				<upd armor='14' qual='0.6' bul='0.2' phis='0.1' blade='0.1' fang='0.1' expl='0.1' laser='0.25' spark='-0.2' dexter='-0.25' kol='15'/>
				<upd armor='16' qual='0.7' bul='0.2' phis='0.1' blade='0.1' fang='0.1' expl='0.1' laser='0.25' spark='-0.1' dexter='-0.2' kol='20'/>
			</armor>
			<armor id='chitin' sort='4' hp='4000' price='4000' lvl='2' kolcomp='4'>
				<upd armor='8' marmor='5' qual='0.6' fang='0.4' fire='0.2' blade='0.2' phis='0.2' acid='0.3'/>
				<upd armor='11' marmor='7' qual='0.7' fang='0.5' fire='0.2' blade='0.25' phis='0.25' acid='0.3' kol='20'/>
				<upd armor='14' marmor='9' qual='0.8' fang='0.6' fire='0.2' blade='0.3' phis='0.3' acid='0.3' kol='40'/>
			</armor>
			<armor id='intel' sort='5' hp='3500' price='6000' lvl='2' crit='0.05' kolcomp='4' hide='1'>
				<upd armor='4' marmor='8' qual='0.9' laser='0.1' dexter='0.2' sneak='0.2'/>
				<upd armor='4' marmor='9' qual='0.9' laser='0.15' dexter='0.3' sneak='0.25' kol='15'/>
				<upd armor='4' marmor='10' qual='0.9' laser='0.20' dexter='0.4' sneak='0.3' kol='30'/>
			</armor>
			<armor id='sapper' sort='4' hp='5000' comp='metal_comp' price='5000' lvl='2' kolcomp='6'>
				<upd armor='12' marmor='5' qual='0.8' bul='0.2' expl='0.5' fire='0.3' blade='0.2' phis='0.2' dexter='-0.3'/>
				<upd armor='13' marmor='5' qual='0.8' bul='0.2' expl='0.55' fire='0.35' blade='0.2' phis='0.2' dexter='-0.25' kol='20'/>
				<upd armor='14' marmor='5' qual='0.8' bul='0.2' expl='0.6' fire='0.4' blade='0.2' phis='0.2' dexter='-0.3' kol='40'/>
			</armor>
			<armor id='battle' sort='6' hp='10000' price='11000' lvl='2' guns='1.1' kolcomp='6'>
				<upd armor='14' marmor='8' qual='0.75' 	bul='0.25' fang='0.2' blade='0.1' phis='0.1' expl='0.25' fire='0.1' />
				<upd armor='16' marmor='9' qual='0.75' bul='0.3' fang='0.2' blade='0.15' phis='0.15' expl='0.25' fire='0.15' kol='20'/>
				<upd armor='18' marmor='10' qual='0.75' bul='0.35' fang='0.2' blade='0.2' phis='0.2' expl='0.25' fire='0.2' kol='20'/>
			</armor>
			<armor id='polic' sort='6' hp='10000' price='12000' lvl='2' melee='1.1' kolcomp='6'>
				<upd armor='11' marmor='11' qual='0.75' bul='0.1' blade='0.2' phis='0.2' expl='0.1' fire='0.3' laser='0.1' spark='0.1' acid='0.2'/>
				<upd armor='12' marmor='13' qual='0.75' bul='0.1' blade='0.25' phis='0.25' expl='0.1' fire='0.4' laser='0.1' spark='0.1' acid='0.2' kol='20'/>
				<upd armor='14' marmor='14' qual='0.75' bul='0.1' blade='0.3' phis='0.3' expl='0.1' fire='0.5' laser='0.1' spark='0.1' acid='0.2' kol='20'/>
			</armor>
			<armor id='magus' sort='7' hp='8000' price='12000' lvl='2' magic='1.1' kolcomp='6'>
				<upd armor='8' marmor='14' qual='0.75' fire='0.25' laser='0.3' spark='0.4' plasma='0.25'/>
				<upd armor='9' marmor='16' qual='0.75' fire='0.25' laser='0.4' spark='0.45' plasma='0.3' kol='20'/>
				<upd armor='10' marmor='18' qual='0.75' fire='0.25' laser='0.5' spark='0.5' plasma='0.35' kol='20'/>
			</armor>
			<armor id='astealth' sort='8' hp='8000' price='18000' comp='intel_comp' lvl='2' crit='0.1' abil='stealth_armor' kolcomp='8' hide='1'>
				<upd armor='12' marmor='12' qual='1' dexter='0.4' laser='0.25' sneak='0.3' mana='1000' act='100' used='1' res='1'/>
				<upd armor='14' marmor='14' qual='1' dexter='0.45' laser='0.25' sneak='0.35' kol='20' mana='1000' act='100' used='1' res='1'/>
				<upd armor='16' marmor='16' qual='1' dexter='0.5' laser='0.25' sneak='0.4' kol='40' mana='1000' act='100' used='1' res='1'/>
			</armor>
			<armor id='assault' sort='9' hp='20000' price='30000' comp='battle_comp' lvl='2' guns='1.2' kolcomp='12'>
				<upd armor='18' marmor='10' qual='0.75' bul='0.3' fang='0.25' blade='0.2' phis='0.2' expl='0.3' fire='0.2'/>
				<upd armor='20' marmor='11' qual='0.8' bul='0.35' fang='0.25' blade='0.2' phis='0.2' expl='0.35' fire='0.25' kol='20'/>
				<upd armor='22' marmor='12' qual='0.85' bul='0.4' fang='0.25' blade='0.2' phis='0.2' expl='0.4' fire='0.3' kol='40'/>
			</armor>
			<armor id='spec' sort='9' hp='20000' price='30000' comp='polic_comp' lvl='2' melee='1.2' kolcomp='12'>
				<upd armor='14' marmor='14' qual='0.75' bul='0.2' blade='0.2' phis='0.3' expl='0.2' fire='0.5' laser='0.2' spark='0.1' acid='0.2'/>
				<upd armor='15' marmor='15' qual='0.75' bul='0.2' blade='0.25' phis='0.4' expl='0.2' fire='0.5' laser='0.2' spark='0.15' acid='0.2' kol='20'/>
				<upd armor='16' marmor='16' qual='0.75' bul='0.2' blade='0.3' phis='0.5' expl='0.2' fire='0.5' laser='0.2' spark='0.2' acid='0.2' kol='40'/>
			</armor>
			<armor id='moon' sort='10' hp='18000' price='30000' comp='magus_comp' magic='1.2' lvl='2' kolcomp='12'>
				<upd armor='10' marmor='20' qual='0.75' fire='0.3' laser='0.5' spark='0.5' plasma='0.3' />
				<upd armor='11' marmor='22' qual='0.75' fire='0.35' laser='0.5' spark='0.5' plasma='0.4' kol='20'/>
				<upd armor='12' marmor='24' qual='0.75' fire='0.4' laser='0.5' spark='0.5' plasma='0.5' kol='40'/>
			</armor>
			<armor id='power' sort='11' hp='30000' price='50000' comp='power_comp' lvl='2' kolcomp='12' hide='1'>
				<upd armor='25' marmor='14' qual='1' bul='0.4' fang='0.25' blade='0.25' phis='0.25' expl='0.3' fire='0.3' radx='0.5' venom='0.75' dexter='-0.5'/>
				<upd armor='27' marmor='16' qual='1' bul='0.45' fang='0.25' blade='0.25' phis='0.25' expl='0.35' fire='0.35' radx='0.5' venom='0.75' dexter='-0.5' kol='20'/>
				<upd armor='30' marmor='18' qual='1' bul='0.5' fang='0.25' blade='0.25' phis='0.25' expl='0.4' fire='0.4' radx='0.5' venom='0.75' dexter='-0.5' kol='40'/>
			</armor>
			<armor id='encl' sort='11' hp='20000' price='40000' comp='power_comp' lvl='2' kolcomp='12' hide='1'>
				<upd armor='15' marmor='25' qual='1' bul='0.2' fire='0.5' laser='0.5' spark='0.5' plasma='0.5' acid='0.3' venom='0.75' dexter='-0.2'/>
				<upd armor='15' marmor='25' qual='1' bul='0.2' fire='0.55' laser='0.55' spark='0.55' plasma='0.5' acid='0.3' venom='0.75' dexter='-0.2' kol='20'/>
				<upd armor='15' marmor='25' qual='1' bul='0.2' fire='0.6' laser='0.6' spark='0.6' plasma='0.5' acid='0.3' venom='0.75' dexter='-0.2' kol='40'/>
			</armor>
			<armor id='ali' sort='11' hp='40000' price='70000' comp='power_comp' lvl='2' kolcomp='15' hide='1' fly='1'>
				<upd armor='20' marmor='20' qual='1' bul='0.3' fang='0.3' blade='0.3' phis='0.3' expl='0.3' fire='0.3' laser='0.3' spark='0.3' plasma='0.3' acid='0.3' venom='0.75'/>
				<upd armor='20' marmor='20' qual='1' bul='0.35' fang='0.3' blade='0.3' phis='0.35' expl='0.3' fire='0.3' laser='0.35' spark='0.3' plasma='0.35' acid='0.3' venom='0.75' kol='20'/>
				<upd armor='20' marmor='20' qual='1' bul='0.4' fang='0.3' blade='0.3' phis='0.4' expl='0.3' fire='0.3' laser='0.4' spark='0.3' plasma='0.4' acid='0.3' venom='0.75' kol='40'/>
			</armor>
			<armor id='tre' sort='31' clo='1' hp='6000' price='5000' tre='3' norep='1'>
				<upd armor='3' marmor='3' qual='0.4' fang='0.2' dexter='0.2' sneak='0.1'/>
			</armor>
			<armor id='socks' sort='32' clo='1' hp='5000' price='1000' norep='1' und='1'>
				<upd dexter='0.2'/>
			</armor>
			
			<armor id='amul_bul' tip='3' price='2000' und='1' norep='1'>
				<upd bul='0.15'/>
			</armor>
			<armor id='amul_phis' tip='3' price='2500' und='1' norep='1'>
				<upd phis='0.15' blade='0.15'/>
			</armor>
			<armor id='amul_expl' tip='3' price='2000' und='1' norep='1'>
				<upd expl='0.25' fire='0.1'/>
			</armor>
			<armor id='amul_fang' tip='3' price='3000' und='1' norep='1'>
				<upd fang='0.3' acid='0.15'/>
			</armor>
			<armor id='amul_fire' tip='3' price='2000' und='1' norep='1'>
				<upd fire='0.2' laser='0.1' spark='0.1'/>
			</armor>
			<armor id='amul_energ' tip='3' price='2000' und='1' norep='1'>
				<upd laser='0.15' plasma='0.15'/>
			</armor>
			<armor id='amul_spark' tip='3' price='3000' und='1' norep='1'>
				<upd spark='0.3'/>
			</armor>
			<armor id='amul_sneak' tip='3' price='3000' und='1' norep='1'>
				<upd sneak='0.2' dexter='0.2'/>
			</armor>
			<armor id='amul_dark' tip='3' price='2000' und='1' norep='1'>
				<upd necro='0.3' cryo='0.1'/>
			</armor>
			<armor id='amul_mage' tip='3' price='10000' und='1' norep='1'>
				<upd fire='0.15' cryo='0.15' laser='0.15' spark='0.15' plasma='0.15'/>
			</armor>
			<armor id='amul_war' tip='3' price='10000' und='1' norep='1'>
				<upd bul='0.15' phis='0.15' blade='0.15' expl='0.15'/>
			</armor>
			<armor id='amul_sniper' tip='3' price='5000' und='1' norep='1' guns='1.16'>
				<upd sneak='0.2'/>
			</armor>
			<armor id='amul_berserk' tip='3' price='5000' und='1' norep='1' melee='1.16'>
				<upd blade='0.2'/>
			</armor>
			<armor id='amul_adept' tip='3' price='5000' und='1' norep='1' magic='1.16'>
				<upd dark='0.2'/>
			</armor>
			
	<!--       *******   Эффекты и скиллы   *******         -->

			<!-- скиллы -->
			<!-- 
				id - имя переменной или номер в массиве
				tip - где находится переменная
					по умолчанию - Pers или UnitPlayer
					weap - массив оружейных навыков
					res - массив сопротивлений
					v1-v5 - значения
					v0,vd - нулевое значение и дельта
			-->
			<skill id='tele' sort='1'>
				<sk id='teleMult' dop='1' v0='2.2' vd='-0.1'/>
				<sk id='throwDmana' v0='250' v1='250' v2='250' v3='200' v4='150' v5='100'/>
				<sk id='maxTeleMassa' v0='0.6' v1='1.6' v2='3' v3='6' v4='12' v5='25'/>
				<sk id='telePorog' v0='0.1' v1='0.2' v2='0.3' v3='0.5' v4='0.8' v5='1.2'/>
				<sk id='teleAccel' v0='1' v1='1.1' v2='1.2' v3='1.35' v4='1.6' v5='2'/>
				<sk id='teleSpeed' v0='8' vd='1.5'/>
				<sk id='unitLevitMult' v0='0.5' v1='1' v2='1.3' v3='1.6' v4='2' v5='2.5'/>
				<sk id='djumpdy' v0='6' vd='1'/>
				<sk id='telePower' dop='1' v0='1' vd='0.1'/>
				<sk tip='weap' dop='1' id='7' v0='1' vd='0.05'/>
				<sk id='teleEnemy' v0='90' v1='60' v2='40' v3='30' v4='20' v5='10'/>
				<textvar s1='5%'/>
				<sk id='alicornRunMana' v0='5' v1='4' v2='3.2' v3='2.5' v4='2' v5='1.6'/>
				<sk id='alicornFlyMult' v0='1' vd='0.1'/>
			</skill>
			<skill id='melee' sort='2'>
				<sk id='meleeR' v0='100' vd='30'/>
				<sk id='meleeRun' v0='10' vd='3'/>
				<sk tip='weap' dop='1' id='1' v0='1' vd='0.05'/>
				<textvar s1='5%'/>
			</skill>
			<skill id='smallguns' sort='3'>
				<sk tip='weap' dop='1' id='2' v0='1' vd='0.05'/>
				<textvar s1='5%'/>
			</skill>
			<skill id='energy' sort='4'>
				<sk tip='weap' dop='1' id='4' v0='1' vd='0.05'/>
				<textvar s1='5%'/>
			</skill>
			<skill id='explosives' sort='5'>
				<sk id='remine' v0='1' vd='1'/>
				<sk id='visiTrap' v0='1' vd='0.4'/>
				<sk tip='weap' dop='1' id='5' v0='1' vd='0.05'/>
				<textvar s1='5%'/>
			</skill>
			<skill id='magic' sort='6'>
				<sk id='recManaMin' ref='add' vd='0.75'/>
				<sk id='spellDown' v0='1' vd='-0.1'/>
				<sk tip='weap' dop='1' id='6' v0='1' vd='0.05'/>
				<sk id='spellPower' dop='1' v0='1' vd='0.1'/>
				<textvar s1='5%' s2='10%' s3='10%'/>
			</skill>
			<skill id='repair' sort='7'>
				<sk id='repair' v0='1' vd='1'/>
				<sk tip='weap' dop='1' id='3' v0='1' vd='0.05'/>
				<sk id='repairMult' dop='1' v0='0.2' vd='0.04'/>
				<textvar s1='4%' s2='20%' s3='5%'/>
				<sk id='alicornSkin' v0='10' vd='2'/>
			</skill>
			<skill id='medic' sort='8'>
				<sk id='medic' v0='0' vd='1'/>
				<sk tip='unit' id='maxhp' ref='add' v1='20' v2='50' v3='90' v4='140' v5='200'/>
				<sk id='healMult' dop='1' v0='0.4' vd='0.03'/>
				<textvar s1='3%' s2='40%'/>
				<eff id='hp' n1='+20' n2='+50' n3='+90' n4='+140' n5='+200'/>
				<sk id='alicornHeal' v0='0.5' vd='0.1'/>
			</skill>
			<skill id='lockpick' sort='9'>
				<sk id='lockPick' dop='1' v0='0' vd='1'/>
				<sk id='unlockMaster' v0='0' vd='1'/>
				<sk id='alicornPortMana' v0='500' vd='-60'/>
			</skill>
			<skill id='science' sort='10'>
				<sk id='hacker' dop='1' v0='0' vd='1'/>
				<sk id='hackerMaster' v0='0' vd='1'/>
				<sk id='alicornShitHP' v0='1000' vd='200'/>
			</skill>
			<skill id='sneak' sort='11'>
				<sk id='sneak' dop='1' v0='0' vd='1'/>
				<sk id='noiseRun' v0='300' vd='-60'/>
				<sk id='critInvis' v0='0' vd='0.05'/>
				<sk id='signal' v0='1' vd='1'/>
				<sk id='sneakLurk' v0='2.5' vd='0.5'/>
				<textvar s1='5%'/>
				<sk id='alicornDexter' v0='0' vd='0.1'/>
			</skill>
			<skill id='barter' sort='12'>
				<sk id='barterLvl' v0='0' vd='1'/>
				<sk id='limitBuys' v0='1' vd='0.2'/>
				<sk id='barterMult' dop='1' v0='1' vd='-0.03'/>
				<textvar s1='3%'/>
				<sk id='alicornVulner' v0='0.7' vd='-0.04'/>
			</skill>
			<skill id='survival' sort='13'>
				<sk id='skin' v0='0' vd='1'/>
				<sk id='allVulnerMult' dop='1' ref='mult' vd='-0.01'/>
				<textvar s1='1%' s2='1'/>
			</skill>
			<skill id='attack' sort='14' post='1'>
				<sk id='allDamMult' ref='add' v0='0' vd='0.05'/>
				<textvar s1='5%'/>
			</skill>
			<skill id='defense' sort='15' post='1'>
				<sk id='allVulnerMult' ref='mult' vd='-0.03'/>
				<textvar s1='3%'/>
			</skill>
			<skill id='knowl' sort='16' post='1'>
			</skill>
			
			<eff id='alicorn' tip='4' t='20'>
				<sk id='ableFly' v1='1'/>
				<sk id='maxhp' ref='mult' v1='5'/>
				<sk id='healMult' ref='mult' v1='2.5'/>
				<sk id='allSpeedMult' ref='mult' v1='1.8'/>
				<sk id='knocked' ref='mult' v1='0.1'/>
				<sk id='allDamMult' ref='mult' v1='5'/>
				<sk id='allPrecMult' ref='mult' v1='2'/>
				<sk id='meleeR' ref='mult' v1='1.5'/>
				<sk id='runForever' ref='add' v1='-1'/>
				<sk id='shitArmor' ref='add' v1='30'/>
				<sk id='recManaMin' ref='add' v1='2'/>
				<sk id='allDManaMult' ref='mult' v1='0.75'/>
				<sk id='pipEmpVulner' v1='0'/>
			</eff>
			
			<!-- перки -->
			<!-- телекинез -->
			<perk id='levitation' tip='1'>
				<req id='level' lvl='1'/>
				<sk id='isDJ' v1='1'/>
			</perk>
			<perk id='selflevit' tip='1' lvl='2'>
				<req id='tele' lvl='2' dlvl='3'/>
				<sk id='levitOn' v0='0' v1='1' v2='1'/>
				<sk id='levitDMana' v1='5' v2='1'/>
				<sk id='levitDManaUp' v1='20' v2='4'/>
				<sk tip='m' id='maxmM' vd='1'/>
			</perk>
			<perk id='telemaster' tip='1'>
				<req id='tele' lvl='4'/>
				<req id='level' lvl='15'/>
				<sk id='telemaster' v0='0' v1='1'/>
				<sk id='teleDist' v0='360000' v1='640000'/>
				<sk tip='m' id='maxmM' v1='1'/>
				<textvar s1='33%'/>
			</perk>
			<perk id='telethrow' tip='1' lvl='2'>
				<req id='tele' lvl='2' dlvl='2'/>
				<sk id='throwForce' v0='0' v1='25' v2='35'/>
				<sk id='throwDmagic' v0='300' v1='200' v2='150'/>
				<sk tip='m' id='maxmM' vd='1'/>
			</perk>
			
			<!-- магия -->
			<perk id='spell_port' tip='1'>
				<req id='level' lvl='12'/>
				<req id='magic' lvl='4'/>
				<sk id='portPoss' v0='0' vd='1'/>
				<sk tip='m' id='maxm1' v1='10'/>
			</perk>
			<perk id='diel' tip='1'>
				<req id='magic' lvl='2'/>
				<sk tip='res' id='9' v1='0.2'/>
				<sk tip='m' id='maxmM' v1='1'/>
				<sk tip='m' id='maxm1' v1='10'/>
				<eff id='spark' n1='+20%'/>
			</perk>
			<perk id='warlock' tip='1' lvl='3'>
				<req id='magic' lvl='1' dlvl='2'/>
				<sk id='warlockDManaMult' v0='1' v1='0.8' v2='0.65' v3='0.5'/>
				<sk tip='m' id='maxmM' vd='1'/>
				<eff id='wmana' n1='-20%' n2='-35%' n3='-50%'/>
			</perk>
			
			<!-- холодное оружие -->
			<perk id='oak' tip='1'>
				<req id='melee' lvl='1'/>
				<sk tip='res' id='1' v0='0' v1='0.25'/>
				<sk tip='m' id='maxmW' v1='1'/>
				<eff id='blade' n1='+25%'/>
			</perk>
			<perk id='stonewall' tip='1'>
				<req id='melee' lvl='2'/>
				<sk tip='res' id='2' v0='0' v1='0.25'/>
				<sk tip='m' id='maxmW' v1='1'/>
				<eff id='phis' n1='+25%'/>
			</perk>
			<perk id='acute' tip='1'>
				<req id='melee' lvl='3'/>
				<sk id='acutePier' v0='0' v1='25'/>
				<sk tip='m' id='maxmW' v1='2'/>
				<eff id='pier' n1='+25'/>
			</perk>
			<perk id='stunning' tip='1'>
				<req id='melee' lvl='4'/>
				<sk id='stunningStun' v0='0' v1='90'/>
				<sk id='stunningKnock' v0='1' v1='1.25'/>
				<sk tip='m' id='maxmW' v1='2'/>
				<textvar s1='3'/>
				<eff id='knock' n1='+25%'/>
			</perk>
			<perk id='mmaster' tip='1'>
				<req id='melee' lvl='5'/>
				<sk id='meleeSpdMult' ref='add' v1='0.15'/>
				<sk tip='m' id='maxmW' v1='1'/>
				<textvar s1='15%'/>
			</perk>
			
			<!-- огнестрельное оружие -->
			<perk id='pistol' tip='1'>
				<req id='smallguns' lvl='1'/>
				<sk id='pistolPrec' v0='1' v1='1.25'/>
				<sk id='pistolCons' v0='1' v1='0.75'/>
				<sk tip='m' id='maxmW' v1='1'/>
				<sk tip='m' id='maxm2' v1='200'/>
				<eff id='prec' n1='+25%'/>
				<textvar s1='25%'/>
			</perk>
			<perk id='reinforced' tip='1'>
				<req id='level' lvl='10'/>
				<req id='smallguns' lvl='2'/>
				<sk tip='res' id='0' v0='0' v1='0.15'/>
				<sk tip='m' id='maxm2' v1='200'/>
				<eff id='bullet' n1='+15%'/>
			</perk>
			<perk id='shot' tip='1'>
				<req id='smallguns' lvl='2'/>
				<sk id='shotPier' v0='0' v1='15'/>
				<sk id='shotKnock' v0='1' v1='1.25'/>
				<sk tip='m' id='maxmW' v1='1'/>
				<sk tip='m' id='maxm2' v1='100'/>
				<eff id='pier' n1='+15'/>
				<eff id='knock' n1='+25%'/>
			</perk>
			<perk id='commando' tip='1'>
				<req id='smallguns' lvl='3'/>
				<sk id='commandoDet' v0='0' v1='3'/>
				<sk tip='m' id='maxmW' v1='1'/>
				<sk tip='m' id='maxm2' v1='100'/>
				<eff id='damage' n1='+3'/>
			</perk>
			<perk id='hardness' tip='1'>
				<req id='smallguns' lvl='4'/>
				<req id='tele' lvl='3'/>
				<sk id='recoilMult' v0='1' v1='0.2'/>
				<sk id='commandoPrec' v0='1' v1='1.15'/>
				<sk tip='m' id='maxmW' v1='1'/>
				<sk tip='m' id='maxm2' v1='100'/>
				<eff id='recoil' n1='-80%'/>
				<eff id='prec' n1='+15%'/>
			</perk>
			<perk id='perf' tip='1'>
				<req id='smallguns' lvl='5'/>
				<sk id='perfPier' v0='0' v1='20'/>
				<sk id='perfDev' v0='1' v1='0.5'/>
				<sk tip='m' id='maxm2' v1='200'/>
				<eff id='pier' n1='+20'/>
				<textvar s1='2'/>
			</perk>

			<!-- энерг оружие -->
			<perk id='antifire' tip='1'>
				<req id='level' lvl='5'/>
				<req id='energy' lvl='2'/>
				<sk tip='res' id='3' v0='0' v1='0.25'/>
				<sk tip='m' id='maxm2' v1='200'/>
				<eff id='fire' n1='+25%'/>
			</perk>
			<perk id='laser' tip='1'>
				<req id='energy' lvl='2'/>
				<sk id='laserDam' v0='1' v1='1.15'/>
				<sk tip='m' id='maxmW' v1='1'/>
				<sk tip='m' id='maxm2' v1='100'/>
				<eff id='damage' n1='+15%'/>
			</perk>
			<perk id='plasma' tip='1'>
				<req id='energy' lvl='3'/>
				<sk id='plasmaPrec' v0='1' v1='1.25'/>
				<sk id='plasmaSpeed' v0='1' v1='1.5'/>
				<sk tip='m' id='maxmW' v1='1'/>
				<sk tip='m' id='maxm2' v1='100'/>
				<eff id='prec' n1='+25%'/>
				<textvar s1='50%'/>
			</perk>
			<perk id='pyro' tip='1'>
				<req id='energy' lvl='3'/>
				<sk id='pyroDam' v0='1' v1='1.25'/>
				<sk tip='m' id='maxmW' v1='1'/>
				<sk tip='m' id='maxm2' v1='200'/>
				<eff id='damage' n1='+25%'/>
			</perk>
			<perk id='recyc' tip='1'>
				<req id='energy' lvl='4'/>
				<sk id='recyc' v0='0' v1='0.25'/>
				<sk tip='m' id='maxm2' v1='300'/>
				<textvar s1='25%'/>
			</perk>
			<perk id='desintegr' tip='1'>
				<req id='level' lvl='15'/>
				<req id='energy' lvl='5'/>
				<sk id='desintegr' v0='0' v1='0.05'/>
				<sk tip='m' id='maxmW' v1='1'/>
				<sk tip='m' id='maxm2' v1='100'/>
				<textvar s1='5%' s2='20%'/>
			</perk>
			
			<!-- огнестрельное или энерг. оружие -->
			<perk id='fastreload' tip='1'>
				<req id='guns' lvl='2'/>
				<sk id='reloadMult' v0='1' v1='0.5'/>
				<sk tip='m' id='maxm2' v1='300'/>
				<eff id='reload' n1='-50%'/>
			</perk>
			<perk id='rungun' tip='1'>
				<req id='level' lvl='4'/>
				<req id='guns' lvl='2'/>
				<sk id='runPenalty' v0='0.5' v1='0.25'/>
				<sk id='jumpPenalty' v0='0.3' v1='0.15'/>
				<sk tip='m' id='maxmW' v1='1'/>
				<sk tip='m' id='maxm2' v1='100'/>
				<textvar s1='-25%' s2='-50%' s3='-15%' s4='-30%'/>
			</perk>
			<perk id='composure' tip='1'>
				<req id='level' lvl='6'/>
				<req id='guns' lvl='3'/>
				<sk id='backPenalty' v0='0.4' v1='0.2'/>
				<sk id='stayBonus' v0='0.3' v1='0.45'/>
				<sk tip='m' id='maxmW' v1='1'/>
				<sk tip='m' id='maxm2' v1='100'/>
				<textvar s3='-20%' s4='-40%' s1='+45%' s2='+30%'/>
			</perk>
			<perk id='rifle' tip='1'>
				<req id='guns' lvl='4'/>
				<sk id='rifleCritch' v0='0' v1='0.2'/>
				<sk tip='m' id='maxm2' v1='200'/>
				<eff id='critch' n1='+20%'/>
			</perk>
			<perk id='bigsize' tip='1'>
				<req id='level' lvl='10'/>
				<sk id='bigGunsSlow' v0='1' v1='0'/>
				<sk id='drotMult' v0='1' v1='2'/>
				<sk tip='m' id='maxmW' v1='1'/>
				<sk tip='m' id='maxm2' v1='100'/>
			</perk>
			
			<!-- взрывчатка -->
			<perk id='babah' tip='1'>
				<req id='level' lvl='6'/>
				<req id='explosives' lvl='2'/>
				<sk tip='res' id='4' v0='0' v1='0.25'/>
				<sk tip='m' id='maxm2' v1='300'/>
				<eff id='expl' n1='+25%'/>
			</perk>
			<perk id='grenader' tip='1'>
				<req id='explosives' lvl='4'/>
				<sk id='grenader' v0='0' v1='1'/>
				<sk tip='m' id='maxm2' v1='200'/>
			</perk>
			<perk id='zona' tip='1'>
				<req id='explosives' lvl='3'/>
				<sk id='explRadMult' v0='1' v1='1.25'/>
				<sk tip='m' id='maxm2' v1='200'/>
				<textvar s1='25%'/>
			</perk>
			<perk id='sapper' tip='1'>
				<req id='explosives' lvl='4'/>
				<sk id='sapper' v0='1' v1='1.25'/>
				<sk tip='m' id='maxm2' v1='200'/>
				<textvar s1='25%'/>
			</perk>
			<perk id='friendly' tip='1'>
				<req id='explosives' lvl='5'/>
				<req id='survival' lvl='3'/>
				<sk id='autoExpl' v0='1' v1='0.25'/>
				<sk tip='m' id='maxm2' v1='300'/>
				<textvar s1='25%'/>
			</perk>
			
			<!-- взлом -->
			<perk id='fortune' tip='1' lvl='2'>
				<req id='lockpick' lvl='3' dlvl='2'/>
				<sk id='capsMult' v0='1' v1='2' v2='3'/>
				<sk id='bitsMult' v0='1' v1='1.5' v2='2'/>
				<sk tip='m' id='maxm3' vd='100'/>
			</perk>
			<perk id='infiltrator' tip='1'>
				<req id='lockpick' lvl='2'/>
				<sk id='lockAtt' v0='1' v1='0.75'/>
				<sk id='pinBreak' v0='1' v1='0.5'/>
				<sk tip='m' id='maxm3' v1='200'/>
				<textvar s1='25%'/>
			</perk>
			<perk id='freel' tip='1'>
				<req id='lockpick' lvl='4'/>
				<sk id='freel' v0='0' v1='1'/>
				<sk tip='m' id='maxm2' v1='200'/>
			</perk>
			
			<!-- наука -->
			<perk id='entomolog' tip='1'>
				<req id='science' lvl='1'/>
				<sk id='damInsect' v0='1' v1='1.4'/>
				<sk tip='m' id='maxm3' v1='200'/>
				<textvar s1='40%'/>
			</perk>
			<perk id='coolhacker' tip='1'>
				<req id='level' lvl='10'/>
				<req id='science' lvl='3'/>
				<sk id='hackAtt' v0='3' v1='5'/>
				<sk tip='m' id='maxm1' v1='10'/>
				<textvar s1='5' s2='3'/>
			</perk>
			<perk id='robot' tip='1'>
				<req id='level' lvl='6'/>
				<req id='science' lvl='3'/>
				<sk id='damRobot' v0='1' v1='1.2'/>
				<sk tip='m' id='maxm1' v1='10'/>
				<textvar s1='20%'/>
			</perk>
			<perk id='security' tip='1'>
				<req id='science' lvl='4'/>
				<sk id='security' v0='0' v1='1'/>
				<sk tip='m' id='maxm1' v1='10'/>
			</perk>
			<perk id='mathlogic' tip='1' lvl='2'>
				<req id='science' lvl='3' dlvl='2'/>
				<sk id='satsMult' v0='1' v1='0.85' v2='0.75'/>
				<sk tip='m' id='maxm1' vd='10'/>
				<textvar s1='15%' s2='25%'/>
			</perk>
			
			<!-- ремонт -->
			<perk id='remont' tip='1'>
				<req id='repair' lvl='1'/>
				<sk id='jammedMult' v0='1' v1='0.2'/>
				<sk tip='m' id='maxmW' v1='1'/>
				<sk tip='m' id='maxm2' v1='100'/>
				<textvar s1='5'/>
			</perk>
			<perk id='sparepart' tip='1'>
				<req id='repair' lvl='2'/>
				<sk id='barahlo' v0='0' v1='1'/>
				<sk tip='m' id='maxm3' v1='100'/>
			</perk>
			<perk id='uparmor' tip='1' lvl='2'>
				<req id='repair' lvl='3' dlvl='2'/>
				<sk id='maxArmorLvl' v0='0' v1='1' v2='2'/>
				<sk tip='m' id='maxm3' vd='50'/>
			</perk>
			<perk id='durable' tip='1'>
				<req id='repair' lvl='4'/>
				<sk id='armorVulner' v0='1' v1='0.8'/>
				<sk tip='m' id='maxm3' v1='100'/>
				<textvar s1='20%'/>
			</perk>
			
			<!-- медицина -->
			<perk id='metabol' tip='1'>
				<req id='medic' lvl='1'/>
				<sk id='metaMult' v0='1' v1='2.5'/>
				<sk id='healMult' ref='add' v1='0.1'/>
				<sk tip='m' id='maxm1' v1='10'/>
				<textvar s1='10%' s2='2.5'/>
			</perk>
			<perk id='anatomy' tip='1'>
				<req id='level' lvl='10'/>
				<req id='medic' lvl='4'/>
				<sk id='damPony' v0='1' v1='1.15'/>
				<sk tip='m' id='maxmW' v1='1'/>
				<textvar s1='15%'/>
			</perk>
			<perk id='longtime' tip='1'>
				<req id='medic' lvl='3'/>
				<sk id='himTimeMult' v0='1' v1='2'/>
				<sk tip='m' id='maxm1' v1='10'/>
				<textvar s1='2'/>
			</perk>
			<perk id='fightstim' tip='1'>
				<req id='medic' lvl='5'/>
				<sk id='himLevel' v0='1' v1='2'/>
				<sk id='himBadMult' v0='1' v1='0.5'/>
				<sk tip='m' id='maxm1' v1='10'/>
				<textvar s1='2'/>
			</perk>
			
			<!-- скрытность -->
			<perk id='jump' tip='1'>
				<req id='level' lvl='8'/>
				<req id='sneak' lvl='3'/>
				<sk id='jumpdy' ref='add' v1='2'/>
				<sk tip='m' id='maxm3' v1='100'/>
			</perk>
			<perk id='lightstep' tip='1'>
				<req id='level' lvl='12'/>
				<req id='sneak' lvl='4'/>
				<req id='explosives' lvl='2'/>
				<sk id='activateTrap' v0='2' v1='1'/>
				<sk tip='m' id='maxm3' v1='100'/>
			</perk>
			<perk id='dexter' tip='1' lvl='3'>
				<req id='sneak' lvl='1' dlvl='2'/>
				<sk id='dexter' ref='add' vd='0.15'/>
				<sk tip='m' id='maxm3' vd='100'/>
				<textvar s1='15%'/>
			</perk>
			
			<!-- выживание -->
			<perk id='stamina' tip='1'>
				<req id='survival' lvl='1'/>
				<sk id='stamRun' ref='mult' v1='0.6'/>
				<sk tip='m' id='maxm2' v1='200'/>
				<sk tip='m' id='maxm3' v1='100'/>
				<textvar s1='40%'/>
			</perk>
			<perk id='envir' tip='1'>
				<req id='survival' lvl='2'/>
				<sk tip='res' id='7' v0='0' v1='0.2'/>
				<sk tip='res' id='10' v0='0' v1='0.2'/>
				<sk id='radX' ref='add' v1='-0.2'/>
				<sk tip='m' id='maxm1' v1='10'/>
				<sk tip='m' id='maxm3' v1='100'/>
				<eff id='radx' n1='+20%'/>
				<eff id='venom' n1='+20%'/>
				<eff id='acid' n1='+20%'/>
			</perk>
			<perk id='wild' tip='1'>
				<req id='survival' lvl='3'/>
				<sk tip='res' id='12' v0='0' v1='0.1'/>
				<sk tip='res' id='13' v0='0' v1='0.1'/>
				<sk tip='res' id='14' v0='0' v1='0.2'/>
				<sk tip='m' id='maxm1' v1='10'/>
				<sk tip='m' id='maxm3' v1='100'/>
				<eff id='fang' n1='+20%'/>
				<eff id='respoison' n1='+10%'/>
				<eff id='resbleeding' n1='+10%'/>
			</perk>
			<perk id='purifier' tip='1'>
				<req id='survival' lvl='3'/>
				<sk id='damMonster' v0='1' v1='1.2'/>
				<sk id='damZombie' ref='add' v1='0.2'/>
				<sk tip='m' id='maxm2' v1='200'/>
				<textvar s1='20%'/>
			</perk>
			<perk id='potmaster' tip='1'>
				<req id='survival' lvl='4'/>
				<sk id='potmaster' v0='0' v1='1'/>
				<sk tip='m' id='maxm1' v1='10'/>
			</perk>
			<perk id='radchild' tip='1'>
				<req id='survival' lvl='5'/>
				<sk id='radChild' v0='0' v1='0.2'/>
				<sk tip='m' id='maxm3' v1='100'/>
				<textvar s1='80%'/>
			</perk>
			
			<!-- торговля -->
			<perk id='econom' tip='1'>
				<req id='barter' lvl='3'/>
				<sk id='limitBuys' ref='add' v1='0.4'/>
				<sk id='eco' v0='0' v1='1'/>
				<sk tip='m' id='maxm1' v1='10'/>
				<sk tip='m' id='maxm2' v1='100'/>
				<sk tip='m' id='maxm3' v1='100'/>
			</perk>
			
			<!-- прочее -->
			<perk id='action' tip='1' lvl='3'>
				<req id='level' lvl='5' dlvl='5'/>
				<sk id='maxOd' ref='add' vd='25'/>
				<sk tip='m' id='maxm1' vd='10'/>
				<sk tip='m' id='maxm2' vd='100'/>
				<textvar s1='25' s2='75'/>
			</perk>
			<perk id='critch' tip='1' lvl='3'>
				<req id='level' lvl='8' dlvl='4'/>
				<sk id='critCh' ref='add' vd='0.05'/>
				<textvar s1='5%'/>
			</perk>
			<perk id='critdam' tip='1'>
				<req id='level' lvl='20'/>
				<sk id='critDamMult' ref='add' v1='0.4'/>
				<textvar s1='40%'/>
			</perk>
			<perk id='powerkick' tip='1'>
				<sk id='punchDamMult' ref='add' v1='0.5'/>
				<sk id='kickDestroy' v0='30' v1='80'/>
				<sk tip='m' id='maxm3' v1='100'/>
				<textvar s1='50%'/>
			</perk>
			<perk id='empathy' tip='1' lvl='3'>
				<req id='level' lvl='5' dlvl='5'/>
				<sk id='petDam' v0='2' vd='0.5'/>
				<sk id='petSkin' v0='0' vd='4'/>
				<sk id='petVulner' v0='1' vd='-0.2'/>
				<sk id='owlDam' v0='3' vd='0.3'/>
				<sk id='owlSkin' v0='5' vd='1'/>
				<sk id='owlVulner' v0='1' vd='-0.1'/>
				<sk tip='m' id='maxm1' vd='10'/>
			</perk>
			
			<perk id='dead' tip='0' lvl='10000' val='1'>
			</perk>
			<perk id='life' tip='0' lvl='40'>
				<sk id='maxhp' ref='add' vd='5'/>
				<textvar s1='5'/>
			</perk>
			<perk id='spirit' tip='0' lvl='30'>
				<sk id='inMaxMana' ref='add' vd='20'/>
				<textvar s1='20'/>
			</perk>
			
			<!-- зелья -->
			<perk id='potion_dskel' tip='0' lvl='5'>
				<sk id='organMultPot' v0='1' vd='-0.05'/>
				<textvar s1='5%'/>
			</perk>
			<perk id='potion_immun' tip='0' lvl='5'>
				<sk tip='res' id='12' v0='0' vd='0.05'/>
				<sk tip='res' id='13' v0='0' vd='0.05'/>
				<sk id='radX' ref='add' vd='-0.05'/>
				<textvar s1='5%'/>
			</perk>
			<perk id='potion_might' tip='0' lvl='5'>
				<sk id='meleeDamMult' v0='1' vd='0.05'/>
				<textvar s1='5%'/>
			</perk>
			<perk id='potion_speed' tip='0' lvl='5'>
				<sk id='runSpeedMult' ref='mult' vd='0.05'/>
				<sk id='stamRun' ref='mult' v0='1' vd='-0.05'/>
				<textvar s1='5%'/>
			</perk>
			<perk id='potion_prec' tip='0' lvl='5'>
				<sk id='allPrecMult' v0='1' vd='0.05'/>
				<textvar s1='5%'/>
			</perk>
			<perk id='potion_elements' tip='0' lvl='5'>
				<sk id='spellsDamMult' ref='add' vd='0.05'/>
				<textvar s1='5%'/>
			</perk>
			<perk id='potion_dexter' tip='0' lvl='5'>
				<sk id='dexter' ref='add' vd='0.05'/>
				<textvar s1='5%'/>
			</perk>
			<perk id='potion_crit' tip='0' lvl='5'>
				<sk id='critCh' ref='add' vd='0.02'/>
				<textvar s1='2%'/>
			</perk>
			<perk id='potion_consc' tip='0' lvl='2'>
				<sk tip='m' id='maxmM' vd='3'/>
			</perk>
			
			<perk id='dam_alicorn' tip='0'>
				<sk id='damAlicorn' v0='1' v1='1.15'/>
				<textvar s1='15%'/>
			</perk>
			<perk id='dam_zombie' tip='0'>
				<sk id='damZombie' ref='add' v1='0.1'/>
				<textvar s1='10%'/>
			</perk>
			
			<!-- травмы -->
			<perk id='trauma_head' tip='0' lvl='3'>
				<sk id='allPrecMult' ref='mult' v1='0.9' v2='0.8' v3='0.7'/>
				<sk id='meleeSpdMult' ref='mult' v1='0.9' v2='0.8' v3='0.7'/>
				<sk id='allDManaMult' ref='mult' v1='1' v2='1.5' v3='2'/>
				<sk id='mazilAdd' ref='add' v1='0' v2='5' v3='15'/>
				<textvar s1='10%' s2='10%' s3='0%'/>
				<textvar s1='20%' s2='20%' s3='50%'/>
				<textvar s1='30%' s2='30%' s3='100%'/>
			</perk>
			<perk id='trauma_tors' tip='0' lvl='3'>
				<sk id='maxhp' ref='mult' v1='0.9' v2='0.8' v3='0.6'/>
				<sk id='stamRun' ref='mult' v1='1.5' v2='2' v3='3'/>
				<sk id='stamRes' ref='mult' v1='0.66' v2='0.5' v3='0.25'/>
				<textvar s1='10%' s2='50%' s3='33%'/>
				<textvar s1='20%' s2='100%' s3='50%'/>
				<textvar s1='40%' s2='200%' s3='75%'/>
			</perk>
			<perk id='trauma_legs' tip='0' lvl='3'>
				<sk id='runSpeedMult' ref='mult' v1='0.85' v2='0.7' v3='0.5'/>
				<sk id='allSpeedMult' ref='mult' v1='1' v2='0.9' v3='0.75'/>
				<sk id='jumpdy' ref='add' v1='0' v2='0' v3='-2'/>
				<textvar s1='30%' s2='0%'/>
				<textvar s1='60%' s2='10%'/>
				<textvar s1='100%' s2='25%'/>
			</perk>
			<perk id='trauma_blood' tip='0' lvl='3'>
				<sk id='allVulnerMult' ref='mult' v1='1.1' v2='1.2' v3='1.3'/>
				<sk id='allDamMult' ref='mult' v1='1' v2='0.9' v3='0.8'/>
				<textvar s1='10%' s2='0%'/>
				<textvar s1='20%' s2='10%'/>
				<textvar s1='30%' s2='20%'/>
			</perk>
			<perk id='trauma_mana' tip='0' lvl='4'>
				<sk id='maxTeleMassa' ref='mult' v1='1' v2='1' v3='0.8' v4='0.3'/>
				<sk id='spellsDamMult' ref='mult' v1='1' v2='1' v3='0.75' v4='0'/>
				<textvar/>
				<textvar/>
				<textvar s1='20%' s2='25%'/>
				<textvar s1='70%' s2='100%'/>
			</perk>
			
			
			<!-- эффекты -->
			<eff id='burning' tip='2' t='7' val='2'>
				<sk id='runForever' ref='add' v1='1'/>
				<sk tip='res' id='11' v1='0.5'/>
				<del id='freezing'/>
				<eff id='crio' n1='+50%'/>
			</eff>
			<eff id='chemburn' tip='2' t='15' val='2'>
			</eff>
			<eff id='inhibitor' tip='2' t='60'>
			</eff>
			<eff id='freezing' tip='2' t='15' val='2'>
				<sk tip='res' id='0' v1='-0.3'/>
				<sk tip='res' id='2' v1='-0.3'/>
				<sk tip='res' id='4' v1='-0.3'/>
				<sk tip='res' id='3' v1='0.25'/>
				<sk id='tormoz' ref='mult' v1='0.75'/>
				<del id='burning'/>
				<textvar s1='25%'/>
				<eff id='bullet' n1='-30%'/>
				<eff id='phis' n1='-30%'/>
				<eff id='expl' n1='-30%'/>
				<eff id='fire' n1='+25%'/>
			</eff>
			<eff id='blindness' tip='2' t='15'>
				<sk id='precMultCont' ref='mult' v1='0.4'/>
				<textvar s1='60%'/>
			</eff>
			<eff id='contusion' tip='2' t='60'>
				<sk id='tormoz' ref='mult' v1='0.75'/>
				<sk id='precMultCont' ref='mult' v1='0.8'/>
				<sk id='rapidMultCont' ref='mult'  v1='0.8'/>
				<sk id='allDManaMult' ref='mult' v1='1.5'/>
				<textvar s1='25%' s2='20%' s3='20%' s4='50%'/>
			</eff>
			<eff id='namok' tip='2' t='60' val='2'>
				<sk tip='res' id='3' v1='0.25'/>
				<sk tip='res' id='11' v1='-0.25'/>
				<sk tip='res' id='9' v1='-0.5'/>
				<eff id='fire' n1='+25%'/>
				<eff id='crio' n1='-25%'/>
				<eff id='spark' n1='-50%'/>
			</eff>
			<eff id='stealth' tip='2' t='60' val='0.2'>
				<sk id='showObsInd' v0='0' v1='1'/>
				<sk id='stealthMult' v1='0.2'/>
				<del id='potion_shadow'/>
			</eff>
			<eff id='stealth_armor' tip='2'>
				<sk id='stealthMult' v1='0.2'/>
				<del id='potion_shadow'/>
			</eff>
			<eff id='curse' tip='0'>
				<sk id='healMult' ref='mult' v1='0'/>
			</eff>
			<eff id='reanim' tip='2' t='60'>
			</eff>
			<eff id='disorient' tip='4' t='15'>
				<sk id='zaput' v0='0' v1='1'/>
			</eff>
			<eff id='horror' tip='4' t='15'>
				<sk id='runForever' ref='add' v1='1'/>
				<sk id='mazilAdd' ref='add' v1='25'/>
			</eff>
			<eff id='vote' tip='4' t='8'>
				<sk id='attackForever' ref='add' v1='1'/>
				<sk id='autoAttack' v0='0' v1='1'/>
			</eff>
			<eff id='antidote' tip='2' t='30'>
				<sk tip='res' id='12' v1='0.5'/>
				<textvar s1='50%'/>
			</eff>
			<eff id='radx' tip='2' t='120' him='1'>
				<sk id='radX' ref='add' v1='-0.25'/>
				<textvar s1='25%'/>
			</eff>
			<eff id='bloodinv' tip='2' t='4'>
				<sk id='allVulnerMult' ref='mult' v1='0'/>
			</eff>
			<eff id='drunk' tip='2' t='120' val='3' him='1' add='1' lvl1='150' lvl2='350' lvl3='750'>
				<sk id='tormoz' ref='mult' v1='0.9' v2='0.8' v3='0.6' v4='0.2'/>
				<sk id='precMultCont' ref='mult' v1='0.9' v2='0.8' v3='0.5' v4='0.2'/>
				<sk id='allDManaMult' ref='mult' v1='1.2' v2='1.5' v3='2' v4='3'/>
				<sk id='meleeDamMult' ref='mult' v1='1.1' v2='1.2' v3='1.5' v4='0.5'/>
				<sk id='allVulnerMult' ref='mult' v1='0.95' v2='0.9' v3='0.85' v4='0.85'/>
				<sk id='dexter' ref='mult' v1='0.9' v2='0.8' v3='0.6' v4='0.2'/>
				<sk id='mordaN' v0='1' v1='1' v2='2' v3='2' v4='3'/>
				<textvar s1='+5%' s2='+10%' s3='-10%' s4='-10%' s5='+20%'/>
				<textvar s1='+10%' s2='+20%' s3='-20%' s4='-20%' s5='+50%'/>
				<textvar s1='+15%' s2='+50%' s3='-50%' s4='-40%' s5='+100%'/>
				<textvar s1='+15%' s2='-50%' s3='-80%' s4='-80%' s5='+200%'/>
			</eff>
			<eff id='coffee' tip='2' t='120' him='1'>
				<sk id='lockPick' ref='add' v1='1'/>
				<sk id='hacker' ref='add' v1='1'/>
				<textvar s1='1' s2='1'/>
			</eff>
			<eff id='stupor' tip='4' t='9'>
				<sk id='tormoz' ref='mult' v1='0.25'/>
				<sk id='runSpeedMult' ref='mult' v1='0.5'/>
				<sk id='jumpdy' ref='add' v1='-3'/>
				<sk id='stamRes' ref='mult' v1='0'/>
			</eff>
			<eff id='weak' tip='4' t='15'>
				<sk id='precMultCont' ref='mult' v1='0.5'/>
				<sk id='meleeDamMult' ref='mult' v1='0.7'/>
				<sk id='spellsDamMult' ref='mult' v1='0.7'/>
				<sk id='throwForce' ref='mult' v1='0.8'/>
			</eff>
			<eff id='sacrifice' tip='4' t='10'>
				<textvar s1='50%'/>
			</eff>
			<eff id='relat' tip='4' t='10'>
				<sk id='relat' v1='0.2'/>
				<textvar s1='20%'/>
			</eff>
			<eff id='fetter' tip='4' t='7'>
				<sk id='isFetter' v1='130'/>
			</eff>
			<eff id='pinkcloud' tip='4' t='15' val='20'>
			</eff>
			<eff id='antil' tip='4' t='20'>
				<sk id='healMult' ref='mult' v1='0'/>
			</eff>
			
			<!-- боевая химия -->
			<eff id='mint' tip='2' t='100' him='1' postbad='post_mint'>
				<sk id='lockPick' ref='add' v1='2' v2='3'/>
				<sk id='hacker' ref='add' v1='2' v2='3'/>
				<sk id='remine' ref='add' v1='1' v2='1'/>
				<sk id='repair' ref='add' v1='1' v2='1'/>
				<sk id='unlockMaster' ref='add' v1='1' v2='1'/>
				<sk id='hackerMaster' ref='add' v1='1' v2='1'/>
				<del id='pmint'/>
				<textvar s1='2' s2='2' s3='1'/>
				<textvar s1='3' s2='3' s3='1'/>
			</eff>
			<eff id='pmint' tip='2' t='100' him='1' postbad='post_mint'>
				<sk id='lockPick' ref='add' v1='4' v2='5'/>
				<sk id='hacker' ref='add' v1='4' v2='5'/>
				<sk id='remine' ref='add' v1='1' v2='1'/>
				<sk id='repair' ref='add' v1='1' v2='1'/>
				<sk id='unlockMaster' ref='add' v1='1' v2='1'/>
				<sk id='hackerMaster' ref='add' v1='1' v2='1'/>
				<del id='mint'/>
				<textvar s1='4' s2='4' s3='1'/>
				<textvar s1='5' s2='5' s3='1'/>
			</eff>
				<eff id='post_mint' tip='2' him='2' t='100'>
					<sk id='lockPick' ref='add' vd='-1'/>
					<sk id='hacker' ref='add' vd='-1'/>
					<textvar s1='1' s2='1'/>
					<textvar s1='2' s2='2'/>
					<textvar s1='3' s2='3'/>
				</eff>
			<eff id='dash' tip='2' t='180' him='1' postbad='post_dash'>
				<sk id='runSpeedMult' ref='mult' v1='1.3' v2='1.4'/>
				<sk id='allSpeedMult' ref='mult' v1='1.1' v2='1.2'/>
				<sk id='jumpdy' ref='add' v1='2' v2='2'/>
				<sk id='maxOd' ref='add' v1='30' v2='40'/>
				<del id='ultradash'/>
				<textvar s1='30%' s2='30'/>
				<textvar s1='40%' s2='40'/>
			</eff>
			<eff id='ultradash' tip='2' t='180' him='1' postbad='post_dash'>
				<sk id='runSpeedMult' ref='mult' v1='1.5' v2='1.6'/>
				<sk id='allSpeedMult' ref='mult' v1='1.1' v2='1.2'/>
				<sk id='jumpdy' ref='add' v1='4' v2='4'/>
				<sk id='maxOd' ref='add' v1='70' v2='90'/>
				<del id='dash'/>
				<textvar s1='50%' s2='70'/>
				<textvar s1='60%' s2='90'/>
			</eff>
				<eff id='post_dash' tip='2' him='2' t='120'>
					<sk id='allSpeedMult' ref='mult' v1='0.9' v2='0.82' v3='0.75'/>
					<sk id='maxOd' ref='add' vd='-10'/>
					<textvar s1='10%' s2='10'/>
					<textvar s1='18%' s2='20'/>
					<textvar s1='25%' s2='30'/>
				</eff>
			<eff id='rage' tip='2' t='180' him='1' postbad='post_rage'>
				<sk id='allDamMult' ref='mult' v1='1.25' v2='1.35'/>
				<del id='stampede'/>
				<textvar s1='25%'/>
				<textvar s1='35%'/>
			</eff>
				<eff id='post_rage' tip='2' him='2' t='120'>
					<sk id='allDamMult' ref='mult' v1='0.9' v2='0.8' v3='0.7'/>
					<textvar s1='10%'/>
					<textvar s1='20%'/>
					<textvar s1='30%'/>
				</eff>
			<eff id='medx' tip='2' t='180' him='1' postbad='post_medx'>
				<sk id='allVulnerMult' ref='mult' v1='0.75' v2='0.7'/>
				<sk id='runForever' ref='add' v1='-1' v2='-1'/>
				<del id='stampede'/>
				<textvar s1='25%'/>
				<textvar s1='30%'/>
			</eff>
				<eff id='post_medx' tip='2' him='2' t='120'>
					<sk id='allVulnerMult' ref='mult' v1='1.1' v2='1.2' v3='1.3'/>
					<textvar s1='10%'/>
					<textvar s1='20%'/>
					<textvar s1='30%'/>
				</eff>
			<eff id='stampede' tip='2' t='180' him='1' postbad='post_stampede'>
				<sk id='allDamMult' ref='mult' v1='1.3' v2='1.4'/>
				<sk id='allVulnerMult' ref='mult' v1='0.75' v2='0.7'/>
				<sk id='runForever' ref='add' v1='-1' v2='-1'/>
				<del id='rage'/>
				<del id='medx'/>
				<textvar s1='30%' s2='25%'/>
				<textvar s1='40%' s2='30%'/>
			</eff>
				<eff id='post_stampede' tip='2' him='2' t='120'>
					<sk id='allDamMult' ref='mult' v1='0.9' v2='0.8' v3='0.7'/>
					<sk id='allVulnerMult' ref='mult' v1='1.1' v2='1.2' v3='1.3'/>
					<textvar s1='10%' s2='10%'/>
					<textvar s1='20%' s2='20%'/>
					<textvar s1='30%' s2='30%'/>
				</eff>
			<eff id='buck' tip='2' t='180' him='1' postbad='post_buck'>
				<sk id='stamRun' ref='mult' v1='0.5' v2='0.35'/>
				<sk id='maxhp' ref='mult' v1='1.25' v2='1.35'/>
				<sk id='skin' ref='add' v1='3' v2='4'/>
				<sk id='punchDamMult' ref='add' v1='0.5' v2='0.7'/>
				<sk id='kickDestroy' ref='add' v1='50' v2='80'/>
				<textvar s1='25%' s2='-50%' s3='3' s4='50%'/>
				<textvar s1='35%' s2='-65%' s3='4' s4='70%'/>
			</eff>
				<eff id='post_buck' tip='2' him='2' t='120'>
					<sk id='stamRun' ref='mult' v1='1.5' v2='2' v3='2.5'/>
					<sk id='maxhp' ref='mult' v1='0.9' v2='0.8' v3='0.7'/>
					<textvar s1='10%' s2='+50%'/>
					<textvar s1='20%' s2='+100%'/>
					<textvar s1='30%' s2='+150%'/>
				</eff>
			<eff id='hydra' tip='2' t='30' him='1' val='10' postbad='post_hydra'>
			</eff>
				<eff id='post_hydra' tip='2' him='2' t='120'>
					<sk id='healMult' ref='mult' v1='0.5'/>
					<textvar s1='50%'/>
				</eff>
			
			<!-- зелья -->
			<eff id='potion_fly' tip='2' t='120' him='1'>
				<sk id='ableFly' v1='1'/>
			</eff>
			<eff id='potion_shadow' tip='2' t='60' him='1'>
				<sk id='atkPoss' v1='0'/>
				<sk id='visiMult' ref='mult' v1='0'/>
				<sk id='noiseRun' ref='mult' v1='0'/>
				<sk id='stealthMult' v1='0.01'/>
				<sk id='allDamMult' ref='mult' v1='0'/>
				<sk id='allVulnerMult' ref='mult' v1='0.1'/>
				<sk id='maxTeleMassa' ref='mult' v1='0.01'/>
				<sk id='activateTrap' ref='mult' v1='0'/>
				<sk id='potShad' v1='1'/>
				<del id='stealth'/>
			</eff>
			<eff id='potion_mage' tip='2' t='120' him='1'>
				<sk id='recManaMin' ref='add' v1='5'/>
				<sk id='allDManaMult' ref='mult' v1='0.75'/>
				<sk id='spellDown' ref='mult' v1='0.75'/>
				<sk id='spellsDamMult' ref='add' v1='0.2'/>
				<textvar s1='25%' s2='20%'/>
			</eff>
			<eff id='potion_infra' tip='2' t='30' him='1'>
				<sk id='infravis' v1='1'/>
				<sk id='visiTrap' ref='mult' v1='10'/>
			</eff>
			<eff id='potion_swim' tip='2' t='300' him='1'>
				<sk id='h2oPlav' ref='mult' v1='0'/>
				<sk id='speedPlavMult' ref='mult' v1='2'/>
				<sk id='ddyPlav' ref='mult' v1='0'/>
			</eff>
			<eff id='potion_pink' tip='2' t='300' him='1'>
				<sk tip='res' id='19' v0='0' v1='0.5'/>
				<eff id='pink' n1='+50%'/>
			</eff>
			<eff id='potion_chance' tip='2' t='120' him='1'>
				<sk id='lastCh' v1='300'/>
			</eff>
			<eff id='post_chance' tip='2' t='5'>
				<sk id='allVulnerMult' ref='mult' v1='0'/>
				<sk id='metaMult' ref='mult' v1='10'/>
			</eff>
			<eff id='potion_rat' tip='2' t='30' him='1'>
				<sk id='atkPoss' v1='0'/>
				<sk id='visiMult' ref='mult' v1='0.1'/>
				<sk id='noiseRun' ref='mult' v1='0'/>
				<sk id='allDamMult' ref='mult' v1='0'/>
				<sk id='maxTeleMassa' ref='mult' v1='0'/>
				<sk id='activateTrap' ref='mult' v1='0'/>
				<sk id='runSpeedMult' v1='1'/>
				<sk id='jumpdy' v1='11'/>
				<sk id='isDJ' v1='0'/>
				<sk id='levitOn' v1='0'/>
				<sk id='maxhp' ref='mult' v1='0.2'/>
				<del id='stealth'/>
				<del id='potion_shadow'/>
			</eff>
			
			<!-- еда -->
			<eff id='f_hp' tip='3' t='900'>
				<sk id='maxhp' ref='mult' v1='1.1'/>
				<textvar s1='10%'/>
			</eff>
			<eff id='f_speed' tip='3' t='450'>
				<sk id='stamRun' ref='mult' v1='0.9'/>
				<sk id='allSpeedMult' ref='mult' v1='1.1'/>
				<textvar s1='10%'/>
			</eff>
			<eff id='f_prec' tip='3' t='450'>
				<sk id='allPrecMult' ref='add' v1='0.1'/>
				<textvar s1='10%'/>
			</eff>
			<eff id='f_melee' tip='3' t='900'>
				<sk id='meleeDamMult' ref='add' v1='0.1'/>
				<textvar s1='10%'/>
			</eff>
			<eff id='f_mana' tip='3' t='450'>
				<sk id='warlockDManaMult' ref='mult' v1='0.9'/>
				<textvar s1='10%'/>
			</eff>
			<eff id='f_od' tip='3' t='450'>
				<sk id='maxOd' ref='add' v1='20'/>
				<textvar s1='20'/>
			</eff>
			<eff id='f_vulner' tip='3' t='900'>
				<sk id='allVulnerMult' ref='mult' v1='0.93'/>
				<textvar s1='7%'/>
			</eff>
			<eff id='f_cucsand' tip='3' t='900'>
				<sk id='maxhp' ref='mult' v1='1.1'/>
				<sk tip='res' id='14' v1='0.1'/>
				<sk tip='res' id='1' v1='0.1'/>
				<sk tip='res' id='2' v1='0.1'/>
				<textvar s1='10%' s2='10%'/>
			</eff>
			<eff id='f_frpot' tip='3' t='900'>
				<sk id='stamRun' ref='mult' v1='0.9'/>
				<sk id='allSpeedMult' ref='mult' v1='1.1'/>
				<sk id='maxOd' ref='add' v1='20'/>
				<textvar s1='10%' s2='20'/>
			</eff>
			<eff id='f_oatmeal' tip='3' t='900'>
				<sk id='maxhp' ref='mult' v1='1.1'/>
				<sk tip='res' id='7' v1='0.2'/>
				<sk id='radX' ref='add' v1='-0.2'/>
				<textvar s1='10%' s2='20%'/>
			</eff>
			<eff id='f_salad' tip='3' t='900'>
				<sk id='stamRun' ref='mult' v1='0.9'/>
				<sk id='allSpeedMult' ref='mult' v1='1.1'/>
				<sk id='runSpeedMult' ref='mult' v1='1.1'/>
				<sk id='dexter' ref='add' v1='0.1'/>
				<sk id='dodgePlus' ref='add' v1='0.1'/>
				<textvar s1='10%' s2='10%'/>
			</eff>
			<eff id='f_chpasta' tip='3' t='900'>
				<sk id='maxhp' ref='mult' v1='1.12'/>
				<sk id='allVulnerMult' ref='mult' v1='0.92'/>
				<textvar s1='12%' s2='8%'/>
			</eff>
			<eff id='f_omelet' tip='3' t='900'>
				<sk id='warlockDManaMult' ref='mult' v1='0.9'/>
				<sk id='spellsDamMult' ref='add' vd='0.1'/>
				<textvar s1='10%' s2='10%'/>
			</eff>
			<eff id='f_butterbr' tip='3' t='900'>
				<sk id='skin' ref='add' v1='3'/>
				<sk id='allVulnerMult' ref='mult' v1='0.95'/>
				<textvar s1='3' s2='5%'/>
			</eff>
			<eff id='f_breakfast' tip='3' t='900'>
				<sk id='maxhp' ref='mult' v1='1.25'/>
				<textvar s1='25%'/>
			</eff>
			<eff id='f_soup' tip='3' t='900'>
				<sk id='dexter' ref='add' v1='0.2'/>
				<sk id='dodgePlus' ref='add' v1='0.2'/>
				<textvar s1='20%'/>
			</eff>
			<eff id='f_pizza' tip='3' t='900'>
				<sk id='critCh' ref='add' v1='0.05'/>
				<sk id='critDamMult' ref='add' v1='0.2'/>
				<textvar s1='5%' s2='20%'/>
			</eff>
			<eff id='f_casser' tip='3' t='900'>
				<sk id='visiMult' ref='mult' v1='0.8'/>
				<sk id='noiseRun' ref='mult' v1='0.33'/>
				<textvar s1='20%' s2='3'/>
			</eff>
			<eff id='f_ragu' tip='3' t='900'>
				<sk id='meleeDamMult' ref='add' v1='0.1'/>
				<sk id='meleeSpdMult' ref='add' v1='0.1'/>
				<sk id='punchDamMult' ref='add' v1='0.5'/>
				<textvar s1='10%' s2='50%'/>
			</eff>
			<eff id='f_spsalad' tip='3' t='900'>
				<sk id='spellsDamMult' ref='add' v1='0.15'/>
				<sk id='throwForce' ref='mult' v1='1.25'/>
				<textvar s1='15%' s2='25%'/>
			</eff>
			<eff id='f_patty' tip='3' t='900'>
				<sk id='maxhp' ref='mult' v1='1.15'/>
				<sk tip='res' id='9' v1='0.3'/>
				<sk id='teleEnemy' ref='mult' v1='0.1'/>
				<textvar s1='15%' s2='30%'/>
			</eff>
			<eff id='f_maffin' tip='3' t='900'>
				<sk id='lockPick' ref='add' v1='1'/>
				<sk id='hacker' ref='add' v1='1'/>
				<sk id='remine' ref='add' v1='1'/>
				<sk id='repair' ref='add' v1='1'/>
				<sk id='unlockMaster' ref='add' v1='1'/>
				<sk id='hackerMaster' ref='add' v1='1'/>
				<textvar s1='1' s2='1'/>
			</eff>
			<eff id='f_apie' tip='3' t='900'>
				<sk id='maxhp' ref='mult' v1='1.25'/>
				<sk id='metaMult' ref='add' v1='1.5'/>
				<sk id='healMult' ref='add' v1='0.1'/>
				<textvar s1='25%' s2='10%'/>
			</eff>
			<eff id='f_mpie' tip='3' t='900'>
				<sk id='allDamMult' ref='mult' v1='1.12'/>
				<textvar s1='12%'/>
			</eff>
			<eff id='f_ppie' tip='3' t='900'>
				<sk id='gunsDamMult' ref='add' v1='0.15'/>
				<sk id='reloadMult' ref='mult' v1='0.5'/>
				<textvar s1='15%' s2='2'/>
			</eff>
			<eff id='f_spie' tip='3' t='900'>
				<sk id='allPrecMult' ref='add' v1='0.15'/>
				<sk id='meleeSpdMult' ref='add' v1='0.15'/>
				<sk id='critCh' ref='add' v1='0.05'/>
				<textvar s1='15%' s2='15%' s3='5%'/>
			</eff>
			<eff id='f_borsch' tip='3' t='900'>
				<sk id='allVulnerMult' ref='mult' v1='0.88'/>
				<sk id='spellPower' ref='add' v1='1'/>
				<textvar s1='12%' s2='100%'/>
			</eff>
			
			<!-- отслеживаемые и требующие начальной установки параметры
				f='1' - отслеживать факторы
				show
					1 - показывать в пипбаке всегда
					2 - показывать, если надета броня
					3 - показывать, если достигнут Кантерлот
				tip - способ показа
					0 - абсолютное значение
					1 - мультипликатор, показывать в процентах, только если !=1
					2 - показывать в процентах всех
					3 - способ показа обратных величин
					4 - сопротивления
					5 - обратный мультипликатор
					
			-->
			<param id='hp' v='maxhp' f='1' tip='0'/>
			<param id='resbleeding' v='13' f='1' tip='4'/>
			<param id='respoison' v='12' f='1' tip='4'/>
			<param id='radx' v='radX' f='1' tip='3'/>
			
			<param id='param_atk' v='' show='1'/>
			<param id='alldamage' v='allDamMult' f='1' show='1' tip='1'/>
			<param id='meleedamage' v='meleeDamMult' f='1' show='1' tip='1'/>
			<param id='meleerapid' v='meleeSpdMult' f='1' show='1' tip='1'/>
			<param id='gunsdamage' v='gunsDamMult' f='1' show='1' tip='1'/>
			<param id='allprec' v='allPrecMult' f='1' show='1' tip='1'/>
			<param id='reload' v='reloadMult' f='1' show='1' tip='1'/>
			<param id='spelldamage' v='spellsDamMult' f='1' show='1' tip='1'/>
			<param id='punchdamage' v='punchDamMult' f='1' show='1' tip='1'/>
			
			<param id='param_def' v='' show='1'/>
			<param id='skin' v='skin' f='1' show='1' tip='0'/>
			<param id='armor' v='armor' show='1' tip='0'/>
			<param id='marmor' v='marmor' show='1' tip='0'/>
			<param id='aqual' v='armor_qual' show='2' tip='2'/>
			<param id='dexter' v='dexter' f='1' show='1' tip='1'/>
			
			<param id='allresist' v='allVulnerMult' f='1' show='1' tip='3'/>
			<param id='bullet' v='0' f='1' show='1' tip='4'/>
			<param id='blade' v='1' f='1' show='1' tip='4'/>
			<param id='phis' v='2' f='1' show='1' tip='4'/>
			<param id='fang' v='14' f='1' show='1' tip='4'/>
			<param id='expl' v='4' f='1' show='1' tip='4'/>
			<param id='fire' v='3' f='1' show='1' tip='4'/>
			<param id='crio' v='11' f='1' show='1' tip='4'/>
			<param id='laser' v='5' f='1' show='1' tip='4'/>
			<param id='plasma' v='6' f='1' show='1' tip='4'/>
			<param id='spark' v='9' f='1' show='1' tip='4'/>
			<param id='venom' v='7' f='1' show='1' tip='4'/>
			<param id='acid' v='10' f='1' show='1' tip='4'/>
			<param id='pink' v='19' f='1' show='3' tip='4'/>
			<param id='necro' v='16' f='1' show='1' tip='4'/>
			
			<param id='param_oth' v='' show='1'/>
			<param id='sneak' v='visiMult' f='1' show='1' tip='3'/>
			<param id='allspeed' v='allSpeedMult' f='1' show='1' tip='1'/>
			<param id='runspeed' v='runSpeedMult' f='1' show='1' tip='1'/>
			<param id='stamrun' v='stamRun' f='1' show='1' tip='2'/>
			<param id='alldmana' v='allDManaMult' f='1' show='1' tip='2'/>
			<param id='wmana' v='warlockDManaMult' f='1' show='1' tip='2'/>
			<param id='healeff' v='healMult' f='1' show='1' tip='2' nobeg='1'/>
			<param id='lockpick' v='lockPick' f='1' show='1' tip='0' nobeg='1'/>
			<param id='hacker' v='hacker' f='1' show='1' tip='0' nobeg='1'/>
			<param id='od' v='maxOd' f='1' show='1' tip='0'/>
			
			<!--       *******   Материалы   *******         -->
			
			<!-- передний план -->
			<mat ed='1' id='A' n='Сталь' phis='1' hp='30000' thre='1200' back='A' indestruct='1' mat='1'>
				<main tex='tMetal'/>
				<border tex='tKlep' mask='maskSimple'/>
				<filter f='cont'/>
			</mat>
			<mat ed='1' id='B' n='Супербетон' phis='1' hp='5000' thre='1200' back='A' mat='2'>
				<main tex='tSuperCon' mask='maskBare'/>
				<border tex='tBorder' mask='maskBorderBare'/>
				<filter f='potek'/>
			</mat>
			<mat ed='1' id='C' n='Бетон' phis='1' hp='1000' thre='100' back='A' mat='2'>
				<main tex='tConcrete' mask='maskBare'/>
				<border tex='tBorder' mask='maskBorderBare'/>
				<floor tex='tFloor' mask='maskFloor'/>
			</mat>
			<mat ed='1' id='D' n='Побитый бетон' phis='1' hp='1000' thre='100' back='A' mat='2'>
				<main tex='tConcreteD' mask='maskDamaged'/>
				<border tex='tSkol' mask='maskSkol'/>
				<filter f='potek'/>
			</mat>
			<mat ed='1' id='E' n='Трещины' phis='1' hp='150' thre='10' back='A' mat='2'>
				<main tex='tCracked' mask='maskDamaged'/>
				<border tex='tSkol' mask='maskSkol'/>
				<filter f='potek'/>
			</mat>
			<mat ed='1' id='F' n='Рухлядь' phis='1' hp='40' mat='3'>
				<main tex='tWood' mask='maskDamaged'/>
				<filter f='cont_th'/>
			</mat>
			<mat ed='1' id='G' n='Камень' phis='1' hp='1000' thre='100' back='A' mat='2'>
				<main tex='tRock' mask='maskStone'/>
				<border tex='tSkol' mask='maskStoneBorder'/>
			</mat>
			<mat ed='1' id='H' n='Земля' phis='1' hp='1000' thre='100' back='L' mat='6'>
				<main tex='tStones' mask='maskDirt'/>
				<border tex='tDirt2' mask='maskDirtBorder'/>
				<filter f='potek'/>
			</mat>
			<mat ed='1' id='I' n='Кирпич' phis='1' hp='1000' thre='100' back='A' mat='4'>
				<main tex='tBrick2' mask='maskBare'/>
				<floor tex='tFloor' mask='maskFloor'/>
			</mat>
			<mat ed='1' id='J' n='Железная стенка' phis='1' hp='5000' thre='1200' back='A' mat='1'>
				<main tex='tMWall'/>
				<filter f='cont_metal'/>
				<floor tex='tFloorMetal' mask='maskFloor'/>
				<border tex='tKlep2' mask='maskMetalBorder'/>
			</mat>
			<mat ed='1' id='K' n='Железные конструкции' phis='1' hp='1000' thre='100' back='A' mat='1'>
				<main tex='tMWall2'/>
				<floor tex='tFloorMetal' mask='maskFloor'/>
				<filter f='cont_metal'/>
			</mat>
			<mat ed='1' id='L' n='Мох' phis='1' hp='1000' thre='100' back='A' mat='2'>
				<main tex='tConcreteMoss' mask='maskDirt'/>
				<border tex='tMoss' mask='maskDirtBorder'/>
				<filter f='potek'/>
			</mat>
			<mat ed='1' id='M' n='Ржавый металл' phis='1' hp='5000' thre='1200' back='A' mat='1'>
				<main tex='tRust'/>
				<border tex='tKlep' mask='maskSimple'/>
				<filter f='cont'/>
			</mat>
			<mat ed='1' id='N' n='Стена здания' phis='1' hp='1000' thre='100' back='A' mat='2'>
				<main tex='tBuild' mask='maskDirt'/>
				<border tex='tConRough' mask='maskDirtBorder'/>
				<floor tex='tFloor' mask='maskFloor'/>
			</mat>
			<mat ed='1' id='O' n='Стена базы' phis='1' hp='5000' thre='4000' back='A' mat='1'>
				<main tex='tBaseMetal'/>
				<filter f='cont_metal'/>
				<floor tex='tFloorMetal' mask='maskFloor'/>
				<border tex='tKlep2' mask='maskMetalBorder'/>
			</mat>
			<mat ed='1' id='P' n='Кирпич Кантерлота' phis='1' hp='1000' thre='100' back='A' mat='2'>
				<main tex='tCanBrick' mask='maskBare'/>
				<floor tex='tFloor' mask='maskFloor'/>
			</mat>
			<mat ed='1' id='Q' n='Бетон Кантерлота' phis='1' hp='1000' thre='100' back='A' mat='2'>
				<main tex='tConRough' mask='maskBare'/>
				<border tex='tBorder' mask='maskBorderBare'/>
				<floor tex='tFloor' mask='maskFloor'/>
			</mat>
			<mat ed='1' id='R' n='Крыша' phis='1' hp='150' thre='10' back='A' mat='4'>
				<main tex='tRoof' mask='maskDirt'/>
				<floor tex='tRoofFloor' mask='maskFloor'/>
				<filter f='potek'/>
			</mat>
			<mat ed='1' id='S' n='Прочная Стена Анклава' phis='1' hp='5000' thre='4000' back='A' mat='1'>
				<main tex='tEncl1'/>
				<filter f='cont_metal'/>
				<floor tex='tFloorMetal' mask='maskFloor'/>
				<border tex='tKlep3' mask='maskMetalBorder'/>
			</mat>
			<mat ed='1' id='T' n='Стена Анклава' phis='1' hp='1000' thre='100' back='A' mat='1'>
				<main tex='tEncl2'/>
				<filter f='cont_metal'/>
				<floor tex='tFloorMetal' mask='maskFloor'/>
				<border tex='tKlep3' mask='maskMetalBorder'/>
			</mat>
			
			<mat ed='0' id='100' n='Граница' phis='1' hp='10000' back='A' indestruct='1' mat='1'>
				<main tex='tMetal' mask='TileMask'/>
				<border tex='tKlep' mask='maskSimple'/>
				<filter f='cont'/>
			</mat>
			
			<mat ed='3' id='А' n='Лестница справа' m='Б' vid='3' mat='1' stair='1'>
			</mat>
			<mat ed='3' id='Б' n='Лестница слева' m='А' vid='1' mat='1' stair='-1'>
			</mat>
			
			<mat ed='4' id='-' n='Ржавая балка' mat='1' shelf='1' rear='1'>
				<main tex='tShelf' mask='TileMask'/>
			</mat>
			<mat ed='4' id='В' n='Ступеньки /' m='Г' vid='6' mat='1' diagon='1' rear='1'>
			</mat>
			<mat ed='4' id='Г' n='Ступеньки \\' m='В' vid='5' mat='1' diagon='-1' rear='1'>
			</mat>
			<mat ed='4' id='Д' n='Деревянная балка' mat='3' shelf='1' rear='1'>
				<main tex='tWoodBeam' mask='TileMask'/>
				<filter f='cont_th'/>
			</mat>
			<mat ed='4' id='Ж' n='Деревянные ст. /' m='З' vid='8' mat='3' diagon='1' rear='1'>
			</mat>
			<mat ed='4' id='З' n='Деревянные ст. \\' m='Ж' vid='7' mat='3' diagon='-1' rear='1'>
			</mat>
			<mat ed='4' id='Е' n='Стальная балка' mat='1' shelf='1' rear='1'>
				<main tex='tStShelf' mask='TileMask'/>
				<filter f='cont'/>
			</mat>
			<mat ed='4' id='И' n='Стальные ст. /' m='Й' vid='10' mat='1' diagon='1' rear='1'>
			</mat>
			<mat ed='4' id='Й' n='Стальные ст. \\' m='И' vid='9' mat='1' diagon='-1' rear='1'>
			</mat>
			<mat ed='4' id='К' n='Бетонная балка' mat='2' shelf='1' rear='1'>
				<main tex='tConBeam' mask='TileMask'/>
				<filter f='cont'/>
			</mat>
			<mat ed='4' id='Л' n='Бетонные ст. /' m='М' vid='12' mat='2' diagon='1' rear='1'>
			</mat>
			<mat ed='4' id='М' n='Бетонные ст. \\' m='Л' vid='11' mat='2' diagon='-1' rear='1'>
			</mat>
			<mat ed='4' id='Н' n='Кант балка' mat='2' shelf='1' rear='1'>
				<main tex='tCanBeam' mask='TileMask'/>
			</mat>
			<mat ed='4' id='О' n='Кант ст. /' m='П' vid='14' mat='2' diagon='1' rear='1'>
			</mat>
			<mat ed='4' id='П' n='Кант ст. \\' m='О' vid='13' mat='2' diagon='-1' rear='1'>
			</mat>
			<mat ed='4' id='Р' n='Облачная балка' mat='2' shelf='1' rear='1'>
				<main tex='tCloudBeam' mask='TileMask'/>
			</mat>
			<mat ed='4' id='С' n='Облачные ст. /' m='Т' vid='16' mat='2' diagon='1' rear='1'>
			</mat>
			<mat ed='4' id='Т' n='Облачные ст. \\' m='С' vid='15' mat='2' diagon='-1' rear='1'>
			</mat>
			
			<!-- задний план -->
			<mat ed='2' n='Задник стены' id='A'>
				<main tex='tConcreteBack' mask='maskDirt'/>
			</mat>
			<mat ed='2' n='Плитка' id='B'>
				<main tex='tKaf'/>
				<filter f='plitka'/>
			</mat>
			<mat ed='2' n='Бетонные плиты' id='C'>
				<main tex='tConPlates'/>
				<filter f='plitka'/>
			</mat>
			<mat ed='2' n='Кирпичная стенка' id='D' slit='1'>
				<main tex='tBrick' mask='maskCTiles'/>
				<filter f='plitka'/>
			</mat>
			<mat ed='2' n='Большие блоки' id='E'>
				<main tex='tBlocks'/>
				<filter f='plitka'/>
			</mat>
			<mat ed='2' n='Металл. плиты' id='F'>
				<main tex='tMetalPlates'/>
				<filter f='plitka'/>
			</mat>
			<mat ed='2' n='Металл. профиль' id='G'>
				<main tex='tMetalVert'/>
			</mat>
			<mat ed='2' n='Ржавый металл' id='H'>
				<main tex='tMetalRust'/>
			</mat>
			<mat ed='2' n='Вентиляция' id='I'>
				<main tex='tVent'/>
			</mat>
			<mat ed='2' n='Облезлая штукатурка' id='J'>
				<main tex='tShtuk' mask='maskCTiles'/>
			</mat>
			<mat ed='2' n='Сетка' id='K'>
				<main tex='tSetka'/>
			</mat>
			<mat ed='2' n='Земля' id='L'>
				<main tex='tDirt2'  mask='maskDirt'/>
			</mat>
			<mat ed='2' n='Доски' id='M'>
				<main tex='tWoodPlanks'/>
				<filter f='plitka'/>
			</mat>
			<mat ed='2' n='Плиты стойла' id='N'>
				<main tex='tStPlates'/>
				<filter f='plitka'/>
			</mat>
			<mat ed='2' n='Механизмы' id='O' lurk='1'>
				<main tex='tMeh'/>
				<filter f='dyrka'/>
			</mat>
			<mat ed='2' n='Тёмная стенка' id='P'>
				<main tex='tDarkMetal' alt='tMbase'/>
			</mat>
			<mat ed='2' n='Тёмные плиты' id='Q'>
				<main tex='tDarkPlates' alt='tLightPlate'/>
			</mat>
			<mat ed='2' n='Тёмные заклёпки' id='R'>
				<main tex='tDarkRivets' alt='tPlates2'/>
			</mat>
			<mat ed='2' n='Трубы' id='S' lurk='1'>
				<main tex='tPipes' mask='maskCrack'/>
				<filter f='dyrka'/>
			</mat>
			<mat ed='2' n='Ржавые плиты' id='T'>
				<main tex='tRustPlates'/>
			</mat>
			<mat ed='2' n='Стена базы' id='U'>
				<main tex='tBase'/>
				<filter f='plitka'/>
			</mat>
			<mat ed='2' n='Стена Кантерлота' id='V'>
				<main tex='tCanStuc' mask='maskCTiles'/>
				<filter f='plitka'/>
			</mat>
			<mat ed='2' n='Плитка Кантерлота' id='W'>
				<main tex='tCanTiles' mask='maskCTiles'/>
				<filter f='plitka'/>
			</mat>
			<mat ed='2' n='Орнамент' id='X'>
				<main tex='tOrn'/>
			</mat>
			<mat ed='2' n='Стена Аклава' id='Y'>
				<main tex='tEncl2'/>
				<filter f='plitka'/>
			</mat>
			<mat ed='2' n='Облачная стена' id='Z'>
				<main tex='tCloud'/>
				<filter f='cloud'/>
			</mat>
			
	<!--       *******   Объекты заднего плана   *******         -->
			
			<back id='' n='окна и двери'/>
			<back id='fwindow' er='1' n='Окно завода' x2='6' y2='6'/>
			<back id='bwindow' er='1' n='Большое окно' x2='4' y2='2'/>
			<back id='swindow' er='1' n='Маленькое окно' x2='2' y2='1'/>
			<back id='cwindow' er='1' n='Окно Кантерлота' x2='2' y2='4'/>
			<back id='awindow' er='1' n='Окно Кантерлота 2' x2='1' y2='3'/>
			<back id='zhaluzi' s='1' n='Жалюзи' x2='4' y2='2'/>
			<back id='stwindow' n='Окно стойла' x2='4' y2='2'/>
			<back id='stwindow2' n='Окно стойла пи' tid='stwindow' fr='3' x2='4' y2='2'/>
			<back id='illum' n='Иллюминатор' x2='3' y2='3'/>
			<back id='vent' n='Решётка вентиляции' x2='1' y2='1'/>
			<back id='door' n='Дверь' x2='2' y2='3'/>
			<back id='stabledoor' n='Дверь стойла' x2='3' y2='3'/>
			<back id='stabledoor2' n='Входная дверь стойла' x2='6' y2='6'/>
			<back id='gate' n='Ворота' x2='3' y2='3'/>
			<back id='biggate' n='Большие ворота' x2='7' y2='6'/>
			<back id='plantgate' n='Ворота завода' x2='7' y2='6'/>
			<back id='doorbase1' n='Дверь базы' x2='3' y2='3'/>
			<back id='doorbase2' n='Дверь базы круглая' x2='4' y2='3'/>
			<back id='enclwindow' er='1' n='Окно Анклава' x2='4' y2='2'/>
			<back id='enil' er='1' n='Круглое окно' x2='2' y2='2'/>
			<back id='doorencl1' n='Дверь Анклава' x2='3' y2='3'/>
			
			<back id='' n='балки'/>
			<back id='konstr' s='1' n='Вертикальные балки' x2='1' y2='4'/>
			<back id='bigbeam' s='1' n='Большие балки' x2='10' y2='11'/>
			<back id='vkonstr' s='1' n='Толстые балки' x2='2' y2='3'/>
			<back id='hkonstr' s='1' n='Горизонтальные балки' x2='6' y2='2'/>
			<back id='hrail' s='1' n='Гор. рельс' x2='4' y2='1'/>
			<back id='vrail' s='1' n='Верт. рельс' x2='1' y2='4'/>
			<back id='railing' s='1' n='Перила' x2='4' y2='1'/>
			<back id='karniz1' s='1' n='Карниз1' x2='6' y2='1'/>
			<back id='karniz2' s='1' n='Карниз2' x2='4' y2='1'/>
			<back id='karniz2a' s='1' n='Карниз2 битый' x2='4' y2='1'/>
			<back id='karniz3' s='1' n='Карниз3' x2='6' y2='1'/>
			<back id='kolonna' s='2' n='Колонна' x2='2' y2='7'/>
			<back id='arc' s='0' n='Арка' x2='6' y2='4'/>
			<back id='balus' s='1' n='Балюстрада' x2='3' y2='1'/>
			<back id='ugolr' s='1' n='Уголок справа' x2='1' y2='1' mirr='1'/>
			<back id='ugoll' s='1' n='Уголок слева' x2='1' y2='1' mirr='1'/>
			<back id='awningr' s='3' n='Навес справа' x2='2' y2='2' mirr='1'/>
			<back id='awningl' s='3' n='Навес слева' x2='2' y2='2' mirr='1'/>
			<back id='opora' s='-1' n='Бетонная опора' x2='3' y2='25' mirr='2'/>
			
			<back id='' n='трубы'/>
			<back id='pipes' s='1' n='Трубы' x2='3' y2='3'/>
			<back id='pipes2' s='1' n='Трубы2' x2='4' y2='3'/>
			<back id='pipe1' s='2' n='Труба гор толстая' x2='10' y2='2'/>
			<back id='pipe2' s='2' n='Магистраль' x2='12' y2='3'/>
			<back id='pipe3' s='2' n='Труба гор тонкая' x2='2' y2='1'/>
			<back id='pipe4' s='2' n='Труба верт тонкая' x2='1' y2='2'/>
			<back id='stok' s='1' n='Сточная труба' x2='3' y2='3'/>
			<back id='stok2' s='1' n='Маленькая сточная труба' x2='2' y2='2'/>
			<back id='battery' s='2' n='Батарея' x2='2' y2='1'/>
			<back id='unitaz' s='3' n='Унитаз' x2='1' y2='2'/>
			<back id='unitazm' s='3' n='Унитаз металл' x2='1' y2='2'/>
			<back id='rak' s='3' n='Раковина' x2='1' y2='2'/>
			<back id='shower' s='1' n='Душ' x2='2' y2='3'/>
			<back id='vpipe' s='1' n='Вент труба' x2='2' y2='1'/>
			<back id='vpipel' s='2' n='Вент труба слева' x2='1' y2='1' mirr='1'/>
			<back id='vpiper' s='2' n='Вент труба справа' x2='1' y2='1' mirr='1'/>
			<back id='vyt' s='2' n='Вытяжка' x2='3' y2='2'/>
			<back id='vpipes' s='1' n='Вентиляция' x2='8' y2='1'/>

			<back id='' n='освещение'/>
			<back id='light1' s='1' n='Круглая лампа' x2='1' y2='1' lon='1' loff='2'/>
			<back id='stlight1' s='1' n='Круглая лампа стойла' x2='1' y2='1' lon='1' loff='2'/>
			<back id='light2' s='1' n='Плафон прямоугольный' x2='2' y2='1' lon='1' loff='3'/>
			<back id='light3' s='1' n='Плафон скруглённый' x2='2' y2='1' lon='1' loff='2'/>
			<back id='stlight3' s='1' n='Плафон стойла скруглённый' x2='2' y2='1' lon='1' loff='3'/>
			<back id='light4' s='3' n='Потолочный плафон' x2='2' y2='1' lon='1' loff='2'/>
			<back id='stlight4' s='3' n='Потолочный плафон стойла' x2='2' y2='1' lon='1' loff='3'/>
			<back id='light5' s='1' n='Красная лампочка' x2='1' y2='1'/>
			<back id='light6' s='1' n='Лампочка базы' x2='1' y2='1' lon='1' loff='2'/>
			<back id='light7' s='1' n='Лампочка анклава' x2='1' y2='1' lon='1' loff='2'/>
			
			<back id='' n='оборудование'/>
			<back id='pult' s='1' n='Пульты' x2='2' y2='1'/>
			<back id='pult2' s='3' n='Странный пульт' x2='1' y2='2'/>
			<back id='komp' s='1' n='Компы' x2='2' y2='4'/>
			<back id='monitor' s='1' n='Мониторы' x2='2' y2='1'/>
			<back id='monitor2' s='1' n='Большой монитор' x2='4' y2='3'/>
			<back id='electro' s='1' n='Электротехника' x2='3' y2='4' mirr='2'/>
			<back id='server' s='1' n='Сервер' x2='2' y2='4'/>
			<back id='fuse' s='1' n='Будка' x2='4' y2='3'/>
			<back id='vents' n='Вентилятор' x2='2' y2='2'/>
			<back id='wires1' s='1' n='Провода1' x2='1' y2='2'/>
			<back id='wires2' s='2' n='Провода2' x2='1' y2='2'/>
			<back id='bvent' n='Большие вентиляторы' x2='4' y2='2'/>
			<back id='zavod1' s='3' n='Машины' x2='4' y2='3' mirr='2'/>
			<back id='zavod2' s='3' n='Куча металла' x2='3' y2='2' mirr='2'/>
			<back id='generator' s='3' n='Генератор' x2='5' y2='4'/>
			<back id='orudie' s='3' n='Орудие' x2='10' y2='2'/>
			
			<back id='' n='интерьер'/>
			<back id='clock' s='1' n='Часы' x2='1' y2='1'/>
			<back id='vase' s='3' n='Ваза' x2='1' y2='2'/>
			<back id='barrow' s='3' n='Каталка' x2='3' y2='2' mirr='2'/>
			<back id='oper' s='3' n='Операционный стол' x2='3' y2='3' mirr='2'/>
			<back id='cot' s='3' n='Трёхэтажная кровать' x2='3' y2='3' mirr='2'/>
			<back id='lab' s='3' n='Лабораторный стол' x2='3' y2='2' mirr='2'/>
			<back id='chert' s='3' n='Чертёжный стол' x2='3' y2='3'/>
			<back id='kolb' s='3' n='Колба' x2='2' y2='3'/>
			<back id='vitrina' s='3' n='Витрина Мин Ст' x2='2' y2='3'/>
			
			<back id='' n='склады'/>
			<back id='depot' s='1' n='Склады' x2='2' y2='3'/>
			<back id='storage' s='1' n='Камеры хранения' x2='4' y2='3'/>
			<back id='books' s='0' n='Книжные полки' x2='2' y2='2'/>
			<back id='stillage' s='1' n='Стеллаж' x2='3' y2='3'/>
			<back id='dresser' s='1' n='Шкафчики для раздевалки' x2='2' y2='3'/>
			<back id='barf' s='1' n='Бар' x2='5' y2='4'/>
			<back id='snar' s='3' n='Ящик снарядов' x2='4' y2='3'/>
			
			<back id='' n='изображения'/>
			<back id='poster' n='Плакат' x2='2' y2='2'/>
			<back id='med' n='Медицинский плакат' x2='2' y2='2'/>
			<back id='schem' n='Схема чего-то' x2='3' y2='2'/>
			<back id='paint' s='1' n='Картина' x2='2' y2='2'/>
			<back id='draw' n='Чертёж' x2='3' y2='2'/>
			<back id='rgraff' n='Граффити рейдеров' x2='4' y2='3' alpha='0.9'/>
			<back id='minkrut' n='Знак МК' x2='2' y2='2' alpha='0.9'/>
			<back id='rangers' n='Знак Рейнджеров' x2='2' y2='2' alpha='0.9'/>
			<back id='banner' n='Флаг Эквестрии' x2='2' y2='2'/>
			<back id='bannerl' n='Флаг Легиона' x2='2' y2='2'/>
			<back id='rad' n='Знак рад' x2='2' y2='2' alpha='0.9'/>
			<back id='bio' n='Знак био' x2='2' y2='2' alpha='0.9'/>
			<back id='signboard' n='Вывеска' s='3' x2='2' y2='2'/>
			<back id='znak' n='Предупреждающий знак' s='3' x2='2' y2='5'/>
			<back id='enclave' n='Знак Анклава' x2='2' y2='2' alpha='0.9'/>
			<back id='enclbanner' n='Флаг Анклава' x2='2' y2='4'/>
			<back id='stbanner' n='Флаг Мин Ст' x2='2' y2='10'/>
			<back id='minst' n='Знак Мин Ст' x2='4' y2='4'/>
			<back id='pi' n='Знак пи' x2='2' y2='2' alpha='0.9'/>
			
			<back id='' n='пятна'/>
			<back id='potek' n='Потёки' x2='10' y2='2' mirr='2'/>
			<back id='plesen' n='Плесень' x2='10' y2='2' mirr='2'/>
			<back id='moss' n='Мох' x2='10' y2='2' mirr='2'/>
			<back id='blood1' n='Кровища' x2='4' y2='3' blend='multiply' mirr='2'/>
			<back id='blood2' n='Потёк крови' x2='2' y2='3' blend='multiply' mirr='2'/>
			<back id='web1tl' n='Паутина слева-вверху' x2='3' y2='3' mirr='1'/>
			<back id='web1tr' n='Паутина справа-вверху' x2='3' y2='3' mirr='1'/>
			<back id='web1bl' n='Паутина слева-внизу' x2='3' y2='3' mirr='1'/>
			<back id='web1br' n='Паутина справа-внизу' x2='3' y2='3' mirr='1'/>
			
			<back id='' n='дырки'/>
			<back id='chole' er='1' n='Дырки в бетоне' x2='11' y2='8' mirr='1'/>
			<back id='chole1' er='1' n='Дырка в бетоне 8x5' x2='8' y2='5' tid='chole' fr='1' mirr='1'/>
			<back id='chole2' er='1' n='Дырка в бетоне 6x9' x2='6' y2='9' tid='chole' fr='2' mirr='1'/>
			<back id='chole3' er='1' n='Дырка в бетоне 9x6' x2='9' y2='6' tid='chole' fr='3' mirr='1'/>
			<back id='chole4' er='1' n='Дырка в бетоне 11x8' x2='11' y2='8' tid='chole' fr='4' mirr='1'/>
			<back id='chole5' er='1' n='Дырка в бетоне 6x5' x2='6' y2='5' tid='chole' fr='5' mirr='1'/>
			<back id='chole6' er='1' n='Дырка в бетоне 11x4' x2='11' y2='4' tid='chole' fr='6' mirr='1'/>
			<back id='hole' er='1' n='Дырки' x2='10' y2='10' blend='overlay' mirr='1'/>
			<back id='hole1' er='1' n='Дырки 1' x2='10' y2='10' blend='overlay' mirr='1'/>
			<back id='hole2' er='1' n='Дырки 2' x2='10' y2='10' blend='overlay' mirr='1'/>
			<back id='hole3' er='1' n='Дырки 3' x2='10' y2='10' blend='overlay' mirr='1'/>
			<back id='hole4' er='1' n='Дырки 4' x2='10' y2='10' blend='overlay' mirr='1'/>
			<back id='hole5' er='1' n='Дырки 5' x2='10' y2='10' blend='overlay' mirr='1'/>
			<back id='heap1' s='3' n='Куча обломков 1' x2='6' y2='3' mirr='2'/>
			<back id='heap2' s='3' n='Куча обломков 2' x2='6' y2='2' mirr='2'/>
			<back id='heap3' s='3' n='Куча обломков 3' x2='3' y2='1' mirr='2'/>
			<back id='musor1' s='3' n='Мусор' x2='8' y2='1' mirr='2'/>
			<back id='musor2' s='3' n='Мелкий мусор' x2='8' y2='1' mirr='2'/>

			<back id='' n='подсветка'/>
			<back id='shadow' n='Тень' alpha='0.9'/>
			<back id='lwhite' n='Белый' tid='lcolor' fr='1' alpha='0.5'/>
			<back id='lred' n='Красный' tid='lcolor' fr='2' alpha='0.5'/>
			<back id='lorange' n='Оранжевый' tid='lcolor' fr='3' alpha='0.5'/>
			<back id='lyellow' n='Жёлтый' tid='lcolor' fr='4' alpha='0.5'/>
			<back id='lacid' n='Кислотный' tid='lcolor' fr='5' alpha='0.5'/>
			<back id='lgreen' n='Зелёный' tid='lcolor' fr='6' alpha='0.5'/>
			<back id='lcyan' n='Голубой' tid='lcolor' fr='7' alpha='0.5'/>
			<back id='lblue' n='Синий' tid='lcolor' fr='8' alpha='0.5'/>
			<back id='lpurple' n='Фиолетовый' tid='lcolor' fr='9' alpha='0.5'/>
			<back id='lpink' n='Розовый' tid='lcolor' fr='10' alpha='0.5'/>
			
			<back id='' n='всякое'/>
			<back id='chains' n='Цепи' s='3' x2='5' y2='3' mirr='2'/>
			<back id='skel' n='Скелет' s='3' x2='3' y2='1' mirr='2'/>
			<back id='stenka1' s='1' n='Стенка1' x2='12' y2='6'/>
			<back id='stenka2' s='1' n='Стенка2' x2='6' y2='7'/>
			<back id='stenka3' s='1' n='Стенка3' x2='12' y2='2'/>
			<back id='trava' s='1' n='Трава' x2='12' y2='1' mirr='2'/>
			<back id='tree' s='0' n='Дерево большое' x2='7' y2='9' mirr='2'/>
			<back id='stree' s='0' n='Дерево поменьше' x2='5' y2='6' mirr='2'/>
			<back id='remains1' s='-1' n='Силуэты домов' x2='12' y2='9' mirr='2'/>
			<back id='remains2' s='-1' n='Силуэты домов поменьше' x2='8' y2='6' mirr='2'/>
			<back id='metal' s='-1' n='Металл' x2='8' y2='3' mirr='2'/>
			<back id='exit_light' s='2' n='Выход' x2='10' y2='7' nope='1'/>
			<back id='bar' s='1' n='Вывеска бара' x2='4' y2='2' lon='1' loff='2'/>
			<back id='h109' x2='3' y2='3' nope='1' alpha='0.5'/>
			<back id='qgraff' x2='25' y2='13' s='-1' nope='1' alpha='0.85'/>
			<back id='celest' n='Статуя Селестии' s='2' x2='12' y2='11'/>
			<back id='pink' n='Розовое облако' nope='1' s='3' x2='48' y2='12'/>
			
			
			
	<!--       *******   Частицы   *******         -->
			<!--
				vis - визуальный класс
				blit - блиттинг
				blitx, blity - размеры блиттинга
				blitf - количество кадров в повторяющейся анимации
				
				anim='1' - частица анимируется 
				anim='1' - частица анимируется со случайной позиции
				alph='1' - частица становится прозрачной под конец жизни
				ctrans='1' - применяются цветовые настройки локации
				rsc - случайный масштаб, вычитается из 1
				
				minliv, rliv - время жизни
				
				minv, rv - начальная скорость в случайном направлении
				rx, ry - случайное начальное отклонение
				rdx, rdy - случайная скорость по направлению x,y
				dx, dy - заданная скорость по направлению x,y
				rr - случайная скорость вращения
				rot='1' - случайный начальный угол поворота
				grav - степень подверженности гравитации
				water='1' - частица существует только вне воды
				water='2' - частица существует только в воде
			-->
			
			<!-- Разрушение стен -->
			<part id='kusok' vis='visualKusok' alph='1' ctrans='1' minliv='20' rliv='40' grav='1' minv='2' rv='10' rot='1' dy='-5'/>
			<part id='kusokB' vis='visualKusokB' alph='1' ctrans='1' minliv='20' rliv='40' grav='1' minv='2' rv='10' rot='1' dy='-5'/>
			<part id='kusokD' vis='visualKusokD' alph='1' ctrans='1' minliv='20' rliv='40' grav='1' minv='2' rv='10' rot='1' dy='-5'/>
			<part id='steklo' vis='visualSteklo' alph='1' ctrans='1' minliv='20' rliv='40' grav='1' minv='2' rv='10' rot='1' dy='-5'/>
			<part id='kusoch' vis='visualKusoch' alph='1' ctrans='1' minliv='20' rliv='40' grav='1' minv='2' rv='6' rot='1' dy='-5'/>
			<part id='kusochB' vis='visualKusochB' alph='1' ctrans='1' minliv='20' rliv='40' grav='1' minv='2' rv='6' rot='1' dy='-5'/>
			<part id='schep' vis='visualSchep' alph='1' ctrans='1' minliv='20' rliv='40' grav='1' minv='2' rv='10' rot='1' dy='-5'/>
			<part id='schepoch' vis='visualSchepoch' alph='1' ctrans='1' minliv='20' rliv='40' grav='1' minv='2' rv='6' rot='1' dy='-5'/>
			<part id='metal' vis='visualMetal' alph='1' ctrans='1' minliv='20' rliv='40' grav='1' minv='2' rv='10' rot='1' dy='-5' rsc='0.4'/>
			<part id='pole' vis='visualPole' alph='1' ctrans='1' minliv='20' blend='screen' rliv='10' minv='3' rv='8' rsc='0.4' brake='0.92'/>
			<part id='bur' vis='visualBur' anim='1' minliv='10' filter='bur' blend='screen' imp='1'/>
			<part id='plav' vis='visualPlav' anim='1' minliv='10' filter='plav' blend='hardlight' imp='1'/>
			<part id='fake' vis='visualFake' anim='1' minliv='8' blend='screen' alph='1' imp='1'/>
			<part id='gwall' vis='visualGwall' anim='1' minliv='12' blend='screen' imp='1'/>
			<part id='iskr_wall' blit='sprIskr' blitx='3' blity='3' alph='1' minliv='10' rliv='10' grav='0.5' minv='1' rv='2' dy='-2' blend='screen'/>

			<!-- взрывы -->
			<part id='expl' blit='sprExpl' blitx='240' blity='240' anim='1' minliv='15' imp='1'/>
			<part id='explw' blit='sprExplW' blitx='240' blity='240' ctrans='1' anim='1' minliv='15' blend='hardlight' imp='1'/>
			<part id='fireexpl' blit='sprExpl' blitx='240' blity='240' anim='1' minliv='15' blend='screen' imp='1'/>
			<part id='plaexpl' vis='visualPlaExpl' anim='1' minliv='25' imp='1'/>
			<part id='impexpl' vis='visualImpExpl' anim='1' minliv='25' imp='1'/>
			<part id='iceexpl' vis='visualIceExpl' anim='1' minliv='25' imp='1'/>
			<part id='sparkleexpl' vis='visualSparkleExpl' anim='1' minliv='25' imp='1'/>
			<part id='blast' vis='visualBlast' anim='1' minliv='10' imp='1'/>
			<part id='balefire' blit='sprBale' blitx='240' blity='360' blitd='0.5' anim='1' minliv='60' imp='1'/>
			<part id='baleblast' vis='visualBaleblast' anim='1' minliv='30' imp='1'/>
			<part id='acidexpl' vis='visualAcidExpl' anim='1' minliv='10' imp='1'/>
			<part id='eclipse' vis='visualEclipse' anim='1' minliv='25' imp='1'/>
			<part id='gas' vis='visualGas' ctrans='1' alph='1' prealph='1' minliv='60' rr='6' rdy='1' rd='-2' rot='1' maxkol='1' imp='1'/>
			<part id='pinkgas' vis='visualPinkGas' ctrans='1' alph='1' prealph='1' minliv='60' rr='6' rdy='1' rd='-2' rot='1' maxkol='1' imp='1'/>
			<part id='miniexpl' vis='visualMiniexpl' minliv='5' anim='1' imp='1'/>
			<part id='magsymbol' vis='visualMagSymbol' minliv='30' anim='1' sloy='2' imp='1'/>
			<part id='throw' vis='visualThrow' minliv='5' anim='1' imp='1'/>
			<part id='ttexpl' blit='sprExpl' blitx='240' blity='240' anim='1' minliv='15' scale='2' rsc='0.5' imp='1'/>
			<part id='ttplaexpl' vis='visualPlaExpl' anim='1' minliv='25' scale='2' rsc='0.5' imp='1'/>
			<part id='bloodblast' vis='visualBloodblast' anim='1' minliv='30' imp='1'/>
			<part id='bloodblast2' vis='visualBloodblast2' anim='1' minliv='120' imp='1'/>
			<part id='necrblast' vis='visualNecrblast' anim='1' minliv='30' imp='1'/>
			<part id='necrblast2' vis='visualNecrblast2' anim='1' minliv='120' imp='1'/>
			<part id='necrblast3' vis='visualNecrblast3' anim='1' minliv='30' imp='1'/>
			
			<!-- Эффекты оружия -->
			<part id='gilza' vis='visualGilza' ctrans='1' minliv='20' rliv='10' grav='1' rdx='4' rdy='4'/>
			<part id='react' blit='sprReact' blitx='60' blity='60' anim='1' minliv='15' blend='screen'/>
			<part id='snow' vis='visualSnow' alph='1' ctrans='1' minliv='20' rliv='10' minv='15' rv='5' rr='20' rot='1' rsc='0.6' brake='0.95'/>
			<part id='acid' vis='visualAcid' ctrans='1' alph='1' prealph='1' anim='2' minliv='100' rliv='30' imp='1'/>
			<part id='fire' blit='sprFire' blitf='17' blitx='50' blity='67' anim='2' alph='1' prealph='1' minliv='100' rliv='30' blend='hardlight' imp='1'/>
			<part id='acidkap' blit='sprGBlood' blitx='5' blity='5' alph='1' minliv='20' rliv='20' grav='1' minv='0' rv='10' dy='-6'/>
			<part id='steam' vis='visualSteam' ctrans='1' minliv='30' rr='12' rdy='1' grav='-0.2' rd='-2' rot='1' anim='1' rsc='0.3' maxkol='1'/>
			<part id='iskr' blit='sprIskr' blitx='3' blity='3' alph='1' minliv='20' rliv='20' grav='0.5' minv='10' rv='5' dy='-5' blend='screen'/>
			<part id='iskr_bul' blit='sprIskr' blitx='3' blity='3' alph='1' minliv='15' rliv='5' grav='0.7' minv='5' rv='3' dy='-5' blend='screen'/>
			
			<!-- Вспышки при ударах пуль и корпуса -->
			<part id='flare' vis='visualFlare' minliv='10' anim='1'/>
			<part id='bum' vis='visualBum' minliv='5' anim='1'/>
			<part id='buma' vis='visualBumAcid' minliv='5' anim='1'/>
			<part id='bumn' vis='visualBumNecro' minliv='5' anim='1'/>
			<part id='flame' vis='visualFlame' alph='1' minliv='15' grav='-1' rx='20' ry='20' rdx='4' rdy='4' blend='screen'/>
			<part id='arson' vis='visualFlame' alph='1' minliv='10' grav='-1' rx='20' ry='20' rdx='4' rdy='4' blend='screen'/>
			<part id='plasma' vis='flPlasma' minliv='3' anim='1'/>
			<part id='plasma1' vis='flPlasma' minliv='3' anim='1'/>
			<part id='plasma2' vis='flPlasma2' minliv='3' anim='1'/>
			<part id='blump' vis='flLaser' minliv='3' anim='1'/>
			<part id='laser' vis='flLaser' minliv='3' anim='1'/>
			<part id='laser2' vis='flLaser2' minliv='3' anim='1'/>
			<part id='laser3' vis='flPlasma2' minliv='3' anim='1'/>
			<part id='spark' vis='flSpark' minliv='3' anim='1'/>
			<part id='sparkl' vis='flSparkl' minliv='3' anim='1'/>
			<part id='dray' vis='flDray' minliv='3' anim='1'/>
			<part id='telebullet' vis='visualTeleFlare' minliv='4' anim='1'/>
			<part id='ice' vis='visualIceFlare' minliv='4' anim='1'/>
			<part id='plevok' vis='flPlevok' minliv='3' anim='1'/>
			<part id='pinkplevok' vis='flPinkPlevok' minliv='3' anim='1'/>
			
			<!-- Кровь -->
			<part id='bloodexpl1' blit='sprBl1' blitx='240' blity='240' anim='1' minliv='20'/>
			<part id='bloodexpl2' blit='sprBl2' blitx='240' blity='240' anim='1' minliv='20'/>
			<part id='bloodexpl3' blit='sprBl3' blitx='240' blity='240' anim='1' minliv='20'/>
			<part id='blood' blit='sprBlood' blitx='5' blity='5' alph='1' minliv='20' rliv='20' grav='1' minv='0' rv='5' dy='-6'/>
			<part id='gblood' blit='sprGBlood' blitx='5' blity='5' alph='1' minliv='20' rliv='20' grav='1' minv='0' rv='5' dy='-5'/>
			<part id='pblood' blit='sprPBlood' blitx='5' blity='5' alph='1' minliv='20' rliv='20' grav='1' minv='0' rv='5' dy='-6'/>
			
			<!-- Удары и смерть -->
			<part id='pole2' vis='visualPole2' alph='1' minliv='10' rliv='5'/>
			<part id='burn' blit='sprIskr' blitx='3' blity='3' alph='1' minliv='20' rliv='20' grav='-0.5' minv='0' rv='5' dy='-3' blend='screen'/>
			<part id='krupa' blit='sprKrupa' blitx='5' blity='5' alph='1' minliv='20' rliv='20' grav='0.5' minv='0' rv='5' dy='3'/>
			<part id='discharge' vis='visualDischarge' alph='1' minliv='5' rr='10' rot='1' blend='screen'/>
			<part id='plakap' vis='PlasmaKap' alph='1' minliv='15' rliv='5' grav='0.6' rgrav='0.4' rdx='1' rdy='2'/>
			<part id='die_spark' vis='die_spark' alph='1' minliv='20' rliv='20' grav='-0.1' rgrav='-0.2' rdx='1' rdy='1' rsc='0.7' blend='screen'/>
			<part id='shmatok' vis='visualShmatok' alph='1' ctrans='1' minliv='20' rliv='40' grav='0.8' minv='2' rv='10' rr='20' rot='1' dy='-5'/>
			<part id='bloat_kap' vis='bloat_kap' alph='1' ctrans='1' minliv='20' rliv='40' grav='0.8' minv='2' rv='10' dy='-5'/>
			<part id='black' vis='visualBlack' alph='1' ctrans='1' minliv='20' rliv='10' minv='3' rv='8' rsc='0.4' brake='0.92'/>
			
			<!-- Эффекты -->
			<part id='poison' vis='visualPoison' alph='1' ctrans='1' minliv='20' rliv='10' grav='-0.2' minv='0' rv='3' rsc='0.6' brake='0.95'/>
			<part id='stun' vis='visualStun' alph='1' ctrans='1' minliv='20' rliv='10' minv='5' rv='5' rr='20' rot='1' rsc='0.6' brake='0.91'/>
			<part id='slow' vis='visualSlow' alph='1' ctrans='1' minliv='20' rliv='10' rsc='0.2' brake='0.91'/>
			<part id='blind' vis='visualBlind' alph='1' minliv='40' rliv='20' rsc='0.5' blend='multiply'/>
			
			<!-- Способности -->
			<part id='teleport' vis='visualTele' minliv='12' anim='1' imp='1'/>
			<part id='tele' blit='sprBSpark' blitx='9' blity='9' alph='1' minliv='10' rliv='20' rv='5' blend='screen'/>
			<part id='telered' blit='sprRSpark' blitx='9' blity='9' alph='1' minliv='10' rliv='20' rv='5' blend='screen'/>
			<part id='radioblast' vis='visualRadioblast' anim='1' minliv='30' imp='1'/>
			<part id='quake' vis='visualQuake' anim='1' minliv='10'/>
			<part id='necronoise' vis='visualNecroNoise' minliv='9' anim='1' sloy='4'/>
			<part id='zzz' vis='visualZzz' alph='1' ctrans='1' minliv='20' rliv='10' grav='-0.2' minv='0' rv='3' rsc='0.6' brake='0.95'/>
			<part id='magrun' blit='sprKap' blitx='3' blity='3' alph='1' minliv='15' rliv='5'/>
			<part id='redray' vis='visualRedRay' minliv='50' rot='1' rsc='0.7' anim='1' otklad='15'/>
			<part id='vsos' vis='visualVsos' alph='1' minliv='30' rsc='0.2'/>
			
			<!-- Прочие -->
			<part id='kap' blit='sprKap' blitx='3' blity='3' alph='1' minliv='15' rliv='5' grav='1' minv='3' rv='3' dy='-5'/>
			<part id='unlock' vis='flUnlock' minliv='17' anim='1' blend='screen'/>
			<part id='lift' blit='sprBSpark' blitx='9' blity='9' alph='1' minliv='20' rliv='20' dy='-5' rdy='-5' blend='screen'/>
			<part id='moln' vis='flMoln' minliv='8' anim='1' blend='screen'/>
			<part id='bubble' vis='visualBubble' alph='1' ctrans='1' minliv='20' rliv='10' grav='-0.4' minv='0' rv='3' rsc='0.6' brake='0.95' water='2'/>
			<part id='purple_spark' vis='purple_spark' alph='1' minliv='40' rsc='0.7' blend='screen'/>
			<part id='green_spark' vis='green_spark' alph='1' ctrans='1' minliv='20' blend='screen' rliv='10' minv='8' rv='1' rsc='0.4' brake='0.92'/>
			<part id='gold_spark' vis='gold_spark' alph='1' ctrans='1' minliv='20' blend='screen' rliv='10' minv='8' rv='1' rsc='0.4' brake='0.92'/>
			<part id='blue_spark' vis='blue_spark' alph='1' ctrans='1' minliv='20' blend='screen' rliv='10' minv='8' rv='1' rsc='0.4' brake='0.92'/>
			<part id='orange_spark' vis='orange_spark' alph='1' ctrans='1' minliv='20' blend='screen' rliv='10' minv='8' rv='1' rsc='0.4' brake='0.92'/>
			<part id='electro' vis='visualElectro' minliv='5' blend='screen' alph='1' rot='1'/>
			<part id='noise' vis='visualNoise' minliv='10' anim='1' sloy='4'/>
			<part id='sign1' vis='visualSign1' minliv='20' anim='1' sloy='4'/>
			<part id='green' vis='flGreen' minliv='30' rliv='15' alph='1'/>
			<part id='red' vis='flRed' minliv='30' rliv='15' alph='1'/>
			<part id='marker' vis='visualMarker' minliv='10' sloy='4' camscale='1'/>
			
			<!-- Числа урона и надписи -->
			<part id='numb' vis='visualNumb' minliv='60' dy='-1' brake='0.98' sloy='4' camscale='1'/>
			<part id='replic' vis='visReplic' minliv='100' alph='1' sloy='4' camscale='1' imp='1'/>
			<part id='replic2' vis='visReplic2' minliv='100' alph='1' sloy='4' camscale='1' imp='1'/>
			<part id='gui' vis='visBulb' minliv='50' alph='1' sloy='5' camscale='1' imp='1'/>
			<part id='take' vis='visBulb' minliv='50' alph='1' sloy='5' dy='-1' camscale='1' imp='1'/>
			
			
			
			
	</all>
		
		
		
	}
	
}

package fe.unit.unitTypes
{
	import flash.utils.Dictionary;

	import fe.Res;
	import fe.World;
	import fe.unit.Unit;
	import fe.XMLDataGrabber;
	import fe.serv.BlitAnim;

    public class UnitTypeDataLoader
    {
		public static var opts:Array = [];			// ????
		public static var begvulners:Array = [];	// ????

        public static function getXmlParam(unit:Unit, mid:String = null):void
		{
			var setOpts:Boolean = false;

			if (opts[unit.id])
            {
				unit.opt = opts[unit.id];
				unit.begvulner = begvulners[unit.id];
			}
            else
            {
				unit.opt = {};
				opts[unit.id] = unit.opt;

				unit.begvulner = [];
				begvulners[unit.id] = unit.begvulner;

				setOpts = true;
			}

			var node:XML;
			var isHero:Boolean = false;
			
			if (mid == null)
            {
				if (unit.hero > 0) isHero = true;
				mid = unit.id;
			}
			
			var node0:XML = XMLDataGrabber.getNodeWithAttributeThatMatches("core", "AllData", "units", "id", mid);

			if (mid && !unit.uniqName) unit.nazv = Res.txt("u", mid);					// Get unit name
			if (node0.@fraction.length()) unit.fraction=node0.@fraction;			// Get unit faction
			unit.inter.cont = mid;
			if (node0.@cont.length() && unit.inter) unit.inter.cont = node0.@cont;
			if (unit.fraction == Unit.F_PLAYER) unit.warn = 0;
			if (node0.@xp.length()) unit.xp = node0.@xp * World.unitXPMult;
			//физические параметры
			if (node0.phis.length())
			{
				node = node0.phis[0];

				if (node.@sX.length()) unit.stayX = unit.objectWidth = node.@sX;
				if (node.@sY.length()) unit.stayY = unit.objectHeight = node.@sY;
				if (node.@sitX.length()) unit.sitX = node.@sitX; else unit.sitX = unit.stayX;
				if (node.@sitY.length()) unit.sitY = node.@sitY; else unit.sitY = unit.stayY / 2;
				if (node.@massa.length()) unit.massaMove = node.@massa / 50;

				if (node.@massafix.length()) unit.massaFix = node.@massafix / 50;
				else unit.massaFix = unit.massaMove;
			}
			unit.massa = unit.massaFix;
			if (unit.massa >= 1) unit.destroy = 0;

			//параметры движения
			if (node0.move.length())
            {
				node = node0.move[0];

				if (node.@speed.length()) unit.maxSpeed = node.@speed;
				if (node.@run.length()) unit.runSpeed = node.@run;
				if (node.@accel.length()) unit.accel = node.@accel;
				if (node.@jump.length()) unit.jumpdy = node.@jump;
				if (node.@knocked.length()) unit.knocked = node.@knocked;		//множитель отбрасывания оружием
				if (node.@plav.length()) unit.plav = (node.@plav>0);			//если =0, юнит не плавает, а ходит по дну
				if (node.@brake.length()) unit.brake = node.@brake;			//торможение
				if (node.@levit.length()) unit.levitPoss = (node.@levit>0);	//если =0, юнит нельзя поднимать телекинезом
				if (node.@levit_max.length()) unit.levit_max = node.@levit_max;//максимальное время левитации
				if (node.@levitaccel.length()) unit.levitaccel = node.@levitaccel;	//ускорение в поле левитации, определяет возможность врага вырываться из телекинетического захвата
				if (node.@float.length()) unit.ddyPlav = node.@float;			//значение выталкивающей силы
				if (node.@porog.length()) unit.porog = node.@porog;			//автоподъём при движении по горизонтали
				if (node.@fixed.length()) unit.fixed = (node.@fixed > 0);		//если =1, юнит является прикреплённым
				if (node.@damwall.length()) unit.damWall = node.@damwall;		//урон от удара ап стену
			}

			//боевые параметры
			if (node0.comb.length())
			{
				node = node0.comb[0];
				if (node.@hp.length()) unit.hp = unit.maxhp = node.@hp * unit.hpmult;
				if (unit.fraction != Unit.F_PLAYER && World.w.game.globalDif <= 1)
				{
					if (World.w.game.globalDif==0) unit.maxhp *= 0.4;
					if (World.w.game.globalDif==1) unit.maxhp *= 0.7;
					unit.hp = unit.maxhp;
				}
				if (node.@skin.length())	unit.skin = node.@skin;
				if (node.@armor.length())	unit.armor = node.@armor;
				if (node.@marmor.length())	unit.marmor = node.@marmor;
				if (node.@aqual.length())	unit.armor_qual = node.@aqual;		//качество брони

				if (node.@armorhp.length())	unit.armor_hp = unit.armor_maxhp = node.@armorhp * unit.hpmult;
				else unit.armor_hp = unit.armor_maxhp = unit.hp;
				
				if (node.@krep.length()) unit.weaponKrep = node.@krep;			//способ держать оружие, 0 - телекинез
				if (node.@dexter.length()) unit.dexter = node.@dexter;			//уклонение
				if (node.@damage.length()) unit.dam = node.@damage;			//собственный урон
				if (node.@tipdam.length()) unit.tipDamage = node.@tipdam;		//тип собственного урона
				if (node.@skill.length()) unit.weaponSkill = node.@skill;		//владение оружием
				if (node.@raddamage.length()) unit.radDamage = node.@raddamage;//собственный урон радиацией
				if (node.@vision.length()) unit.vision = node.@vision;			//зрение
				if (node.@observ.length()) unit.observ += node.@observ;		//наблюдательность
				if (node.@ear.length()) unit.ear = node.@ear;					//слух
				if (node.@levitatk.length()) unit.levitAttack = node.@levitatk;//атака при левитации
			}

			// Vulnerabilities
			if (node0.vulner.length())
			{
				node = node0.vulner[0];

				if (node.@bul.length())		unit.vulner[Unit.D_BUL]=node.@bul;
				if (node.@blade.length())	unit.vulner[Unit.D_BLADE]=node.@blade;
				if (node.@phis.length())	unit.vulner[Unit.D_PHIS]=node.@phis;
				if (node.@fire.length())	unit.vulner[Unit.D_FIRE]=node.@fire;
				if (node.@expl.length())	unit.vulner[Unit.D_EXPL]=node.@expl;
				if (node.@laser.length())	unit.vulner[Unit.D_LASER]=node.@laser;
				if (node.@plasma.length())	unit.vulner[Unit.D_PLASMA]=node.@plasma;
				if (node.@venom.length())	unit.vulner[Unit.D_VENOM]=node.@venom;
				if (node.@emp.length())		unit.vulner[Unit.D_EMP]=node.@emp;
				if (node.@spark.length())	unit.vulner[Unit.D_SPARK]=node.@spark;
				if (node.@acid.length())	unit.vulner[Unit.D_ACID]=node.@acid;
				if (node.@cryo.length())	unit.vulner[Unit.D_CRIO]=node.@cryo;
				if (node.@poison.length())	unit.vulner[Unit.D_POISON]=node.@poison;
				if (node.@bleed.length())	unit.vulner[Unit.D_BLEED]=node.@bleed;
				if (node.@fang.length())	unit.vulner[Unit.D_FANG]=node.@fang;
				if (node.@pink.length())	unit.vulner[Unit.D_PINK]=node.@pink;
			}

			// [visual parameters]
			if (node0.vis.length())
			{
				node = node0.vis[0];

				if (node.@sex == "w") unit.msex = false;
				if (node.@blit.length())
				{
					unit.blitId = node.@blit;
					if (node.@sprX > 0) unit.blitX = node.@sprX;

					if (node.@sprY > 0) unit.blitY = node.@sprY;
					else unit.blitY = node.@sprX;

					if (node.@sprDX.length()) unit.blitDX = node.@sprDX;
					if (node.@sprDY.length()) unit.blitDY = node.@sprDY;
				}
				if (node.@replic.length()) unit.id_replic = node.@replic;
				if (node.@noise.length()) unit.noiseRun = node.@noise;
			}

			// [sound parameters]
			if (node0.snd.length())
			{
				node = node0.snd[0];

				if (node.@music.length())
				{
					unit.sndMusic = node.@music;
					unit.sndMusicPrior = 1;
				}
				if (node.@musicp.length())	unit.sndMusicPrior = node.@musicp;
				if (node.@die.length())		unit.sndDie = node.@die;
				if (node.@run.length())		unit.sndRun = node.@run;
			}

			// [other parameters]
			if (node0.param.length())
			{
				node = node0.param[0];

				if (node.@invulner.length()) unit.invulner=(node.@invulner>0);	//полная неуязвимость
				if (node.@overlook.length()) unit.overLook=(node.@overlook>0);	//может смотреть за спину
				if (node.@sats.length()) unit.isSats=(node.@sats>0);				//отображать как цель в ЗПС
				if (node.@acttrap.length()) unit.activateTrap=node.@acttrap;		//юнит активирует ловушки: 0 - никак, 1 - только установленные игроком
				if (node.@npc.length()) unit.npc=(node.@npc>0);					//отображать на карте как npc
				if (node.@trup.length()) unit.trup=(node.@trup>0);				//оставлять труп после смерти
				if (node.@blood.length()) unit.blood=node.@blood;				//кровь
				if (node.@retdam.length()) unit.retDamage=node.@retdam>0;		//возврат урона
				if (node.@hero.length())
				{
					unit.mHero = true;						//может быть героем
					unit.id_name = node.@hero;
				}
				if (setOpts)
				{
					if (node.@pony.length())	unit.opt.pony = true;					//является пони
					if (node.@zombie.length())	unit.opt.zombie = true;					//является зомби
					if (node.@robot.length())	unit.opt.robot = true;					//является роботом
					if (node.@insect.length())	unit.opt.insect = true;					//является насекомым
					if (node.@monster.length())	unit.opt.monster = true;					//является насекомым
					if (node.@alicorn.length())	unit.opt.alicorn = true;					//является аликорном
					if (node.@mech.length())
					{
						unit.opt.mech = true;					//является механизмом
						unit.mech = true;
					}
					if (node.@hbonus.length()) unit.opt.hbonus = true;					//является пони
					if (node.@izvrat.length()) unit.opt.izvrat = true;					//является пони
				}
			}

			if (unit.blood == 0) unit.vulner[Unit.D_BLEED] = 0;

			if (unit.opt)
            {
				if (unit.opt.robot || unit.opt.mech)
                {
					unit.vulner[Unit.D_NECRO]     = 0;
                    unit.vulner[Unit.D_BLEED]     = 0;
                    unit.vulner[Unit.D_VENOM]     = 0;
                    unit.vulner[Unit.D_POISON]    = 0;
				}
			}

			if (node0.blit.length())
            {
				if (unit.anims == null) unit.anims = [];
				for each(var xbl:XML in node0.blit)
				{
					unit.anims[xbl.@id] = new BlitAnim(xbl);
				}
			}

			if (setOpts)
			{
				for (var i:int = 0; i < Unit.kolVulners; i++)
				{
					unit.begvulner[i] = unit.vulner[i];
				}
			}
		}
    }
}
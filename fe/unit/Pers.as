package fe.unit {
	
	import fe.*;
	import fe.loc.CheckPoint;
	import fe.serv.LootGen;
	import flash.display.MovieClip;
	
	public dynamic class Pers {
		
		public var gg:UnitPlayer;
		
		public var persName:String='LP';

		public var skills:Array;		//значения скиллов по id
		public var skill_ids:Array;		//список id скиллов по порядку
		public var perks:Array;
		public var addictions:Array;
		
		//уровень, очки обучения
		public var xpCur:int=0, xpPrev:int=0, xpNext:int=5000, xpDelta:int=5000;
		public var xpVer:int=0, xpCurVer:int=1;		//версия формулы рассчёта опыта
		public var level:int=1;
		public var skillPoint:int=0, dopPoint:int=0;
		public var perkPoint:int=0;
		public var perkPointExtra:int=0;
		public var xpCPadd:int=300;
		
		public var rep:int=0;	//репутация
		var rep1:int=10, rep2:int=20, rep3:int=35, rep4:int=50;
		public var repGood:int=70;	//репутация для хорошей концовки
		
		public static var maxSkLvl:int=20;
		public static var maxPostSkLvl:int=100;
		public static var levelSkAdd:int=5;
		public static var postPersLevel:int=20;
		
		public var owlhp:Number=0;			//макс здоровье робосовы
		public var owlhpProc:Number=1;		//процент здоровья робосовы
		
		//опции
		public var hardcore:Boolean=false;		//хардкор
		public var dead:Boolean=false;			//смерть в режиме хардкора
		public var rndpump:Boolean=false;		//случайная прокачка
		
		//сложность игры
		public var begHP:int=70, lvlHP:int=15;
		public var organMult:Number=1;
		public var dieDamage:Number=0.25;
		public var critHeal:Number=0.2;
		public var teleMana:Number=1;			//расход маны на телекинез, в зависимости от уровня сложности
		public var difCapsMult:Number=1;
		
		//цены на лечение
		public var priceHP:Number=0.5;
		public var priceBlood:Number=0.5;
		public var priceRad:Number=1;
		public var priceMana:Number=1;
		public var priceOrgan:Number=0.5;
		public var priceCut:Number=4;
		public var pricePoison:Number=4;
		public var priceRepArmor:Number=0.5;
		
		//медицина
		public var headHP:Number;
		public var torsHP:Number;
		public var legsHP:Number;
		public var bloodHP:Number;
		public var headSt:int=0;
		public var torsSt:int=0;
		public var legsSt:int=0;
		public var bloodSt:int=0;
		public var headMin:Number=0;
		public var torsMin:Number=0;
		public var legsMin:Number=0;
		public var bloodMin:Number=0;
		var xml_head:XML;
		var xml_tors:XML;
		var xml_legs:XML;
		var xml_blood:XML;
		var xml_mana:XML;

		public var manaHP:Number;
		public var manaSt:int=0;
		public var manaMin:Number=0;
		public var manahpMult:Number=0.02;
		public var manaCPres:Number=50;		//восст. маны на контрольной точке
		public var manaHPRes:Number=0.1;

		public var inMaxHP:Number=200;
		public var inMaxMana:Number=400;
		public var lvlOrganHp:Number=40;
		//выносливость
		public var h2oPlav:Number=1;
		public var stamRun:Number=1;
		public var stamRes:Number=2;
		public var stamDash=40;		//мультипликатор расхода выносливости на рывок
		public var stamJump=20;		//мультипликатор расхода выносливости на прыжок

		public var weaponSkills:Array=[1,1,1,1,1,1,1,1];
		//melee
		public var meleeR:Number=100, meleeS:Number=40;
		public var meleeRun:Number=10;
		public var meleeSpdMult:Number=1;	//скорость атаки
		public var meleeDamMult:Number=1;
		
		//guns
		public var gunsDamMult:Number=1;
		public var bigGunsSlow:Number=1;
		public var drotMult:Number=1;
		public var reloadMult:Number=1;
		public var runPenalty:Number=0.5;
		public var jumpPenalty:Number=0.3;
		public var backPenalty:Number=0.4;
		public var stayBonus:Number=0.3;
		//smallguns
		public var recoilMult:Number=1;		//отдача вверх

		//energy
		public var desintegr:Number=0;
		public var recyc:Number=0;	//рециклинг
		//explosives
		public var remine:int=0, visiTrap:Number;
		public var grenader:int=0;
		public var explRadMult:Number=1;
		public var sapper:Number=1;
		public var autoExpl:Number=1;
		//tele
		public var teleManaMult:Number=0.04;	//соотношение затрат магии и маны
		public var telePorog:Number=0, maxTeleMassa:Number=1;	//вес левитируемых объектов
		public var teleMult:Number=1, levitDMana:Number=0, levitDManaUp:Number=0, allDManaMult:Number=1;	//расход маны
		public var recManaMin:Number=0, recMana:Number=0.012;
		public var telemaster:int=0;
		public var teleDist:int=600*600;
		public var throwForce:Number=0, throwDmagic:Number=200, throwDmanaMult:Number=0.05;	//расход магии и множитель расхода маны
		public var unitLevitMult:Number=1;	//время левитации юнитов
		public var teleEnemy:int=60;		//сила левитации игрока врагами
		public var telePower:Number=1;//	мощность заклинаний, основанных на телекинезе
		//repair
		public var repairMult:Number=0.25;
		public var jammedMult:Number=1;
		public var maxArmorLvl:int=0;
		public var barahlo:int=0;
		public var repair:int=0;
		public var armorVulner:Number=1;
		//medic
		public var medic:int=0;
		public var healMult:Number=1;
		public var metaMult:Number=1;		//скорость действия лечебных зелий
		public var himLevel:int=1;			//уровень эффектов химии
		public var himTimeMult:Number=1;	//длительность эффектов химии
		public var himBadMult:Number=1;		//зависимость от химии, перк - в invent
		public var himBadDif:Number=1;		//зависимость от химии, сложность
		//lockpick
		public var possLockPick:int=0;
		public var lockPick:int=0;			//уровень взлома
		public var lockPickTime:int=30;		//время работы с замком
		public var unlockMaster:int=0;
		public var capsMult:Number=1;
		public var bitsMult:Number=1;
		public var lockAtt:Number=1;
		public var pinBreak:Number=1;
		public var upChance:int=0;
		public var freel:int=0;
		//science
		public var hacker:int=0;
		public var hackerMaster:int=0;
		public var hackAtt:int=3;
		public var satsMult:Number=1;
		public var security:int=0;
		//sneak
		public var visiMult:Number=1;
		public var signal:int=0;
		public var noiseDoorOpen:int=300;
		public var sneakLurk:Number=5;		//бонус к скрытности лёжа и в укрытии
		//barter
		public var barterMult:Number=1;
		public var barterLvl:int=0;
		public var limitBuys:Number=1;
		public var eco:int=0;
		//magic
		public var healManaMult:Number=1;
		public var warlockDManaMult:Number=1;	//расход маны на боевую магию
		//survival
		public var potmaster:int=0;
		public var radChild:Number=0;
		
		//perks
		public var maxOd:int=75;
		public var hpM:int;
		public var punchDamMult:Number=1;
		public var kickDestroy:Number=30;//80
		
		//урон отдельным типам
		public var damPony:Number=1;
		public var damZombie:Number=1;
		public var damRobot:Number=1;
		public var damInsect:Number=1;
		public var damMonster:Number=1;
		public var damAlicorn:Number=1;
		
		//движение
		
		public var isDJ:int=0; //двойной прыжок		//возможность
		public var allSpeedMult:Number=1;
		public var runSpeedMult:Number=1;
		public var ableFly:int=0;
		public var speedPlavMult:Number=1;
		//штрафы за перегрузку
		public var speedShtr:int=0;		//количество штрафов
		public var maxSpeed:Number=100;	//ограничение максимальной скорости
		public var accelMult:Number=1;
		public var jumpMult:Number=1;
		public var shtrManaRes:Number=1;	//расход маны на боевую магию
		
		//модификаторы общей меткости
		public var allPrecMult:Number=1;
		public var mazilAdd:Number=0;

		public var allDamMult:Number=1;
		
		//прочее
		public var dexterNoArmor:Number=0.25;	//уклонение без брони
		public var regenFew:Number=0;	//авторегененерация, сколько за такт
		public var regenMax:Number=0;	//авторегененерация, до скольких 
		public var neujazMax:int=30;
		public var bonusHeal:Number=0;	//бонусы жизни
		public var bonusHealMult:Number=1;	//бонусы жизни
		public var goodHp:int=1000;		//восст. доброты
		public var socks:Boolean=false;
		public var potShad:int=0;
		//public var regenMana:Number=0;	//регененерация маны
		public var infravis:int=0;
		public var pipEmpVulner:Number=3;	//уязвимость пипбака к emp, по умолчанию 3
		public var dropTre:Number=0;
		public var sitDexterPlus:Number=0.3;
		public var lurkDexterPlus:Number=2;
		public var lastCh:Number=0;
		//модули
		public var modMetal:Number=0;
		public var modAnalis:int=0;
		public var modTarget:Number=0;
		public var reanimHp:Number=0;

		public var currentCP:CheckPoint;
		public var currentCPCode:String;
		public var prevCPCode:String;
		public var currentPet:String;
		
		//мутагенные перки
		public var organMultPot:Number=1;
		
		//заклинания
		public var spellsPoss:int=1;
		public var spellsDamMult:Number=1;	//урон от атакующих заклинаний
		public var spellDown:Number=1;
		public var portDown:int=300;
		
		public var portPoss:int=0;
		public var portTime:int=25;
		public var portMagic:Number=950;
		public var portMana:Number=25;
		
		//спутник-феникс
		public var petHP:Number=50;
		public var petDam:Number=2;
		public var petSkin:Number=0;
		public var petVulner:Number=1;
		public var petRes:int=30;
		//спутник-сова
		public var owlHP:Number=200;
		public var owlDam:Number=3;
		public var owlSkin:Number=5;
		public var owlVulner:Number=1;
		//спутник-лунный
		public var moonHP:Number=70;
		public var moonDam:Number=15;
		
		public var alicornHeal:Number=2;
		public var alicornManaHeal:Number=0.1;
		public var alicornPortMana:Number=500;
		public var alicornShitHP:Number=2000;
		public var alicornRunMana:Number=2;
		public var alicornFlyMult:Number=1;
		public var alicornSkin:Number=5;
		public var alicornDexter:Number=0;
		public var alicornVulner:Number=0.7;
		
		//максимальный вес
		public var maxmW:int, maxmM:int, maxm1:Number, maxm2:Number, maxm3:Number;
		
		//зависимости
		public var ad1:int=100, ad2:int=250, ad3:int=500, admax:int=750;
		
		public var factor:Array;
		
		public function Pers(loadObj:Object=null, opt:Object=null) {
			skill_ids=new Array();
			skills=new Array();
			addictions=new Array();
			var ndif:int=2;
			//if (opt && opt.dif!=null) ndif=opt.dif;
			ndif=World.w.game.globalDif;
			//for (var i in skills) trace(i,skills[i]);
			for each (var sk in AllData.d.skill) {
				skill_ids.push({id:sk.@id, sort:sk.@sort, post:sk.@post});
				if (loadObj==null || loadObj.skills[sk.@id]==null) {
					skills[sk.@id]=0;//Math.floor(Math.random()*10);
				} else {
					skills[sk.@id]=loadObj.skills[sk.@id];
				}
			}
			//сложность игры
			setGlobalDif(ndif);
			
			skill_ids.sortOn('sort',Array.NUMERIC);
			headHP=inMaxHP;
			torsHP=inMaxHP;
			legsHP=inMaxHP;
			bloodHP=inMaxHP;
			manaHP=inMaxMana;
			if (loadObj) {
				if (loadObj.dead) {
					dead=true;
				}
				skillPoint=loadObj.skillPoint;
				perkPoint=loadObj.perkPoint;
				if (loadObj.perkPointExtra>0) perkPointExtra=loadObj.perkPointExtra;
				level=loadObj.level;
				if (loadObj.xpDelta!=null) xpDelta=loadObj.xpDelta;
				if (loadObj.levelSkAdd!=null) levelSkAdd=loadObj.levelSkAdd;
				if (loadObj.xp) xpCur=loadObj.xp;
				else {	//установить xp соразмерно левелу (старые сейвы версии 0.4)
					setForcLevel(Math.floor(level/5)+1);
					xpVer=xpCurVer;
				}
				if (loadObj.xpVer) xpVer=loadObj.xpVer;
				if (xpVer!=xpCurVer) {	//другая формула расчёта опыта из старой версии игры (0.6), пересчитать
					recalcXP();
				}
				xpPrev=xpProgress(level-1);
				xpNext=xpProgress(level);
				if (loadObj.hardcore) hardcore=true;
				if (loadObj.rndpump) rndpump=true;
				if (loadObj.cp) currentCPCode=loadObj.cp;
				if (loadObj.prevcp) prevCPCode=loadObj.prevcp;
				//if (loadObj.isDJ!=null) isDJ=loadObj.isDJ;
				if (loadObj.hasOwnProperty('headHP')) headHP=loadObj.headHP*inMaxHP;
				if (loadObj.hasOwnProperty('torsHP')) torsHP=loadObj.torsHP*inMaxHP;
				if (loadObj.hasOwnProperty('legsHP')) legsHP=loadObj.legsHP*inMaxHP;
				if (loadObj.hasOwnProperty('bloodHP')) bloodHP=loadObj.bloodHP*inMaxHP;
				if (loadObj.hasOwnProperty('manaHP')) manaHP=loadObj.manaHP*inMaxMana;
				if (loadObj.hasOwnProperty('owlhp')) owlhpProc=loadObj.owlhp;
				if (headHP>inMaxHP) headHP=inMaxHP;
				if (torsHP>inMaxHP) torsHP=inMaxHP;
				if (legsHP>inMaxHP) legsHP=inMaxHP;
				if (bloodHP>inMaxHP) bloodHP=inMaxHP;
				if (manaHP>inMaxMana) manaHP=inMaxMana;
				currentPet=loadObj.pet;
				if (loadObj.addictions) {
					for (var ad in loadObj.addictions) {
						addictions[ad]=loadObj.addictions[ad];
					}
				}
				if (loadObj.rep) rep=loadObj.rep;
				World.w.alicorn=false;
				if (loadObj.alicorn) World.w.alicorn=loadObj.alicorn;
			} else if (opt) {
				if (opt.hardcore) hardcore=true;
				if (opt.fastxp) xpDelta=3000;
				if (opt.rndpump) rndpump=true;
				if (opt.hardskills) levelSkAdd=3;
				//if (opt.djump) isDJ=true;
				xpNext=xpDelta;
			}
			setAllSt();
			perks=new Array();
			if (loadObj && loadObj.perks) {
				for (var pid in loadObj.perks) {
					perks[pid]=loadObj.perks[pid];
					//trace(pid,loadObj.perks[pid]);
				}
			}
			if (loadObj && loadObj.persName) persName=loadObj.persName;
			if (loadObj==null && opt && opt.propusk) {
				perks['levitation']=1;
			}
			xml_head=AllData.d.perk.(@id=='trauma_head')[0]
			xml_tors=AllData.d.perk.(@id=='trauma_tors')[0]
			xml_legs=AllData.d.perk.(@id=='trauma_legs')[0]
			xml_blood=AllData.d.perk.(@id=='trauma_blood')[0]
			xml_mana=AllData.d.perk.(@id=='trauma_mana')[0]
			//подсчёт таблицы опыта
			/*var prXP:int=0;
			for (var i=1; i<=50; i++) {
				var arXP:int=xpProgress(i);
				trace(i+'\t'+(arXP-prXP)+'\t'+arXP);
				prXP=arXP;
			}*/
			factor=new Array();
			for each (var param in AllData.d.param) {
				if (param.@f>0 && param.@v.length() && param.@v!='')	factor[param.@v]=new Array();
			}
		}
		
		public function save():Object {
			var obj:Object=new Object;
			obj.skills=new Array();
			obj.perks=new Array();
			obj.addictions=new Array();
			for (var sk in skills) obj.skills[sk]=skills[sk];
			for (var pid in perks) {
				obj.perks[pid]=perks[pid];
			}
			for (var ad in addictions) {
				obj.addictions[ad]=addictions[ad];
			}
			obj.dead=dead;
			obj.level=level;
			obj.xp=xpCur;
			obj.xpVer=xpCurVer;
			obj.xpDelta=xpDelta;
			obj.levelSkAdd=levelSkAdd;
			obj.skillPoint=skillPoint;
			obj.perkPoint=perkPoint;
			obj.perkPointExtra=perkPointExtra;
			obj.rndpump=rndpump;
			obj.hardcore=hardcore;
			obj.headHP=headHP/inMaxHP;
			obj.torsHP=torsHP/inMaxHP;
			obj.legsHP=legsHP/inMaxHP;
			obj.bloodHP=bloodHP/inMaxHP;
			obj.manaHP=manaHP/inMaxMana;
			
			obj.persName=persName;
			obj.cp=currentCPCode;
			obj.prevcp=prevCPCode;
			
			obj.rep=rep;
			obj.alicorn=World.w.alicorn;
			//obj.isDJ=isDJ;
			
			obj.pet=gg.currentPet;
			setRoboowl();
			obj.owlhp=owlhpProc;
			
			return obj;
			
		}
		
		public function setGlobalDif(ndif:int=2) {
			//trace('difff',ndif);
			if (ndif==0) {
				begHP=200, lvlHP=25;
				organMult=0.2;
				dieDamage=0;
				critHeal=0.2;
				teleMana=0;
				priceBlood=priceOrgan=0.5, priceRad=1, pricePoison=priceCut=4;
				difCapsMult=1;
				himBadDif=1;
				petRes=20;
			} else if (ndif==1) {
				begHP=150, lvlHP=25;
				organMult=0.5;
				dieDamage=0;
				critHeal=0.2;
				teleMana=0;
				priceBlood=priceOrgan=0.5, priceRad=1, pricePoison=priceCut=4;
				difCapsMult=1;
				himBadDif=1;
				petRes=20;
			} else if (ndif==2) {
				begHP=100, lvlHP=20;
				organMult=1;
				dieDamage=0.15;
				critHeal=0.2;
				teleMana=0.5;
				priceBlood=priceOrgan=0.5, priceRad=1, pricePoison=priceCut=4;
				difCapsMult=1;
				himBadDif=1.3;
				petRes=30;
			} else if (ndif==3) {
				begHP=70, lvlHP=15;
				organMult=1;
				dieDamage=0.25;
				critHeal=0.1;	//восстановление от критических эффектов
				teleMana=1;
				priceBlood=priceOrgan=1, priceRad=1.5,	pricePoison=priceCut=6;
				difCapsMult=1;
				himBadDif=2;
				petRes=60;
				neujazMax=20;
				bonusHealMult=0.75;
			} else if (ndif==4) {
				begHP=40, lvlHP=10;
				organMult=1;
				dieDamage=0.35;
				critHeal=0.1;	//восстановление от критических эффектов
				teleMana=1;
				priceBlood=priceOrgan=1, priceRad=1.5,	pricePoison=priceCut=6;
				difCapsMult=0.5;
				himBadDif=2.5;
				petRes=90;
				neujazMax=15;
				bonusHealMult=0.5;
			}
		}
		
		public function defaultParams() {
			//параметры по умолчанию
			gg.maxhp=begHP;
			gg.critHeal=critHeal;
			
			inMaxHP=200;
			inMaxMana=400;
			gg.jumpdy=12;
			gg.djumpdy=6;
			gg.maxdjumpp=10;
			maxOd=75;
			kickDestroy=30;//80
			stamRes=2;
			recMana=0.025;
			levitDMana=5;
			levitDManaUp=20;
			runSpeedMult=2;
			
			petHP=50;
			petDam=2;
			petRes=30;
			petSkin=0;
			petVulner=1;
			owlHP=200;
			owlDam=3;
			owlSkin=5;
			owlVulner=1;
			
			maxmW=7;
			maxmM=3;
			maxm1=40;
			maxm2=1000;
			maxm3=500;
			
			gg.radX=1;
			gg.dexter=1;
			gg.dodgePlus=0;
			gg.armor=0;
			gg.marmor=0;
			gg.skin=0;
			gg.critCh=0;
			gg.critDamMult=2;
			gg.knocked=1;
			gg.shitArmor=20;
			
			//мультипликаторы
			gg.tormoz=1;
			gg.stealthMult=1;
			gg.allVulnerMult=1;
			gg.precMultCont=1;			
			gg.rapidMultCont=1;	
			//флаги
			gg.levitOn=0;
			gg.atkPoss=1;
			gg.runForever=0;
			gg.attackForever=0;
			gg.zaput=0;
			gg.activateTrap=2;
			gg.mordaN=1;
			gg.ddyPlav=1;
			gg.relat=0;
			gg.eyeMind=0;
			gg.isFetter=0;
			
			//мультипликаторы
			allSpeedMult=1;
			allPrecMult=1;
			allDamMult=1;
			allDManaMult=1;
			warlockDManaMult=1;
			meleeSpdMult=1;
			meleeDamMult=1;
			gunsDamMult=1;
			spellsDamMult=1;
			visiMult=1;
			h2oPlav=1;
			speedPlavMult=1;
			punchDamMult=1;
			metaMult=1;
			reloadMult=1;
			recoilMult=1;
			healMult=0.4;
			stamRun=1;
			pipEmpVulner=3;
			//урон отдельным типам
			damPony=1;
			damZombie=1;
			damRobot=1;
			damInsect=1;
			damMonster=1;
			damAlicorn=1;
			//прибавки
			manaMin=0;
			recManaMin=0;
			reanimHp=0;
			mazilAdd=0;
			regenFew=regenMax=0;
			bonusHeal=0;
			lockPick=hacker=0;
			//флаги
			possLockPick=0;
			spellsPoss=1;
			infravis=0;
			lastCh=0;
			freel=0;
			telemaster=0;
			dropTre=0;
			modAnalis=0;
			modTarget=0;
			modMetal=0;
			upChance=0;
			ableFly=0;
			socks=false;
			potShad=0;
			//аликорн
			alicornRunMana=5;
			
			//сопротивления и оружейные скиллы
			for (var i in gg.vulner) gg.vulner[i]=1;
			gg.vulner[Unit.D_EMP]=0;
			for (i in weaponSkills) weaponSkills[i]=1;
			for (i in factor) factor[i]=new Array();
		}
		
		//получение опыта
		public function expa(dxp:int, nx:Number=-1, ny:Number=-1) {
			if (dxp<=0) return;
			xpCur+=dxp;
			if (nx<0 || ny<0) {
				nx=gg.X;
				ny=gg.Y-gg.scY;
			}
			if (World.w.testLoot) {
				World.w.summxp+=dxp;
			} else {
				gg.numbEmit.cast(gg.loc,nx,ny,{txt:('+'+dxp+'xp'), frame:8, rx:20, ry:20, alpha:0.5, scale:1.5});
			}
			if (xpCur>=xpNext) upLevel();
			World.w.gui.setXp();
		}
		
		//вернуть уровень навыка в зависимости от вложенных очков
		public function getSkLevel(n:int):int {
			if (n>=20) return 5;
			if (n>=14) return 4;
			if (n>=9) return 3;
			if (n>=5) return 2;
			if (n>=2) return 1;
			return 0;
		}
		public function getSkBonus(n:int):int {
			if (n==20) return 5;
			if (n==14) return 4;
			if (n==9) return 3;
			if (n==5) return 2;
			if (n==2) return 1;
			return 0;
		}
		
		//пост-скиллы
		public var postSkTab:Array=[5,11,18,26,35,45,56,68,82,100];
		public function skillIsPost(id:String):Boolean {
			if (id=='attack' || id=='defense' || id=='knowl') return true;
			return false;
		}
		public function getPostSkLevel(n:int):int {
			if (n<postSkTab[0]) return 0;
			var res=0;
			for (var i=0; i<postSkTab.length; i++) {
				if (n>=postSkTab[i]) res=i+1;
			}
			return res;
		}
		
		//вернуть уровень, соответствующий параметру skill оружия
		public function getWeapLevel(sk:int):int {
			if (sk==1) return getSkLevel(skills['melee']);
			if (sk==2) return getSkLevel(skills['smallguns']);
			if (sk==3) return getSkLevel(skills['repair']);
			if (sk==4) return getSkLevel(skills['energy']);
			if (sk==5) return getSkLevel(skills['explosives']);
			if (sk==6) return getSkLevel(skills['magic']);
			if (sk==7) return getSkLevel(skills['tele']);
			return 100;
		}
		//вернуть уровень скилла по его названию
		public function getSkillLevel(sk:String):int {
			if (skills[sk]==undefined) return 0;
			return getSkLevel(skills[sk]);
		}
		
		//принудительно установить уровень перса
		public function setForcLevel(lvl:int) {
			trace('Установлен уровень',lvl);
			level=lvl;
			xpPrev=xpCur=xpProgress(lvl-1);
			xpNext=xpProgress(lvl);
		}
		
		public function upLevel() {
			xpPrev=xpProgress(level);
			level++;
			World.w.gui.messText('levelUp', ' '+level);
			xpNext=xpProgress(level);
			addSkillPoint(levelSkAdd, false, false);
			perkPoint++;
			if (rndpump) autoPump();
			if (gg.pet) gg.pet.setLevel(level);
			World.w.gui.infoText('perkPoint');
			Snd.ps('levelup');
			gg.newPart('gold_spark',25);
		}
		
		//опыта на уровень
		public function xpProgress(lvl:int):int {
			var mn:Number=1;
			if (lvl>10) mn=(lvl-10)/30+1;
			return Math.round(xpDelta*(lvl)*(lvl+1)/2*mn*mn/1000)*1000;
		}
		//формула из версии 0.6
		public function xpProgress06(lvl:int):int {
			return xpDelta*(lvl)*(lvl+1)/2;
		}
		
		//принудительно установить количество опыта для сейва старой версии
		public function recalcXP() {
			if (xpVer==0) {
				var razn:int=xpProgress(level-1)-xpProgress06(level-1);
				trace('Формулы расчёта опыта разных версий, разница:', razn);
				xpCur+=razn;
			}
		}
		
		//добавить скиллпоинты, если dop==true, не повышать левел
		public function addSkillPoint(numb:int=1, dop:Boolean=false, snd:Boolean=true) {
			skillPoint+=numb;
			if (numb==1) World.w.gui.infoText('skillPoint');
			else World.w.gui.infoText('skillPoints',numb);
			if (snd) Snd.ps('skill');
			if (rndpump) autoPump();
		}
		
		//поднять скилл
		public function addSkill(id:String, numb:int, minus:Boolean=false) {
			if (minus && numb>skillPoint) numb=skillPoint;
			if (numb<=0) return;
			var preNumb=skills[id];
			skills[id]+=numb;
			var postNumb=skills[id];
			if (!skillIsPost(id)) {
				for (var i=preNumb+1; i<=postNumb; i++) {
					var bonus=getSkBonus(i);
					if (bonus>0) World.w.gui.infoText('skill',Res.txt('e',id)+'-'+bonus);
				}
			} else {
				if (id=='knowl') {
					var sklvl=getPostSkLevel(skills[id]);
					if (sklvl>perkPointExtra) {
						perkPoint+=sklvl-perkPointExtra;
						perkPointExtra=sklvl;
						World.w.gui.infoText('perkPoint');
					}
				}
			}
			if (minus) skillPoint-=numb;
		}
		
		//поднять скилл на 1 (книгой), вернуть false если поднимать некуда
		public function upSkill(id:String):Boolean {
			if (skills[id]<maxSkLvl) {
				World.w.gui.infoText('skillUp',Res.txt('e',id));
				Snd.ps('skill');
				addSkill(id,1);
				setParameters();
				World.w.gui.setAll();
				return true;
			} else {
				var n=Math.floor(Math.random()*3);
				if (n==0) id='attack';
				else if (n==1) id='defense';
				else id='knowl';
				if (skills[id]<maxPostSkLvl) {
					World.w.gui.infoText('skillUp',Res.txt('e',id));
					Snd.ps('skill');
					addSkill(id,1);
					setParameters();
					World.w.gui.setAll();
					return true;
				} else {
					World.w.gui.infoText('noSkill');
					return false;
				}
			}
		}
		
		//установить уровень скилла принудительно
		public function setSkill(id:String, n:int) {
			if (n<0) n=0;
			if (n>maxSkLvl) n=maxSkLvl;
			if (skills[id]) skills[id]=n;
			setParameters();
			World.w.gui.setAll();
		}
		
		public function addPerk(id:String, minus:Boolean=false) {
			var maxlvl=AllData.d.perk.(@id==id).@lvl;
			if (!(maxlvl>0)) maxlvl=1;
			if (perks[id]) {
				if (perks[id]<maxlvl) {
					perks[id]++;
					World.w.gui.infoText('perk',Res.txt('e',id)+'-'+perks[id]);
					Snd.ps('skill');
				} else {
					World.w.gui.infoText('noPerk');
					return;
				}
			} else {
				//нужного перка нет, добавить
				perks[id]=1;
				World.w.gui.infoText('perk',Res.txt('e',id));
				Snd.ps('skill');
			}
			if (minus) perkPoint--;
			setParameters();
		}
		
		//рандомная прокачка
		function autoPump() {
			var n:int=1000;
			while (skillPoint>0 && n>0) {
				//определить скиллы, доступные для увеличения
				var dost:Array=new Array();
				for (var sk in skills) {
					if (skills[sk]<maxSkLvl && !skillIsPost(sk)) dost.push(sk);
				}
				//если уже все прокачаны, вкачать дополнительные
				if (dost.length==0 || level>=postPersLevel && Math.random()<0.2) {
					for (var sk in skills) {
						if (skillIsPost(sk) && skills[sk]<maxPostSkLvl) dost.push(sk);
					}
					if (dost.length==0) break;
				}
				sk=dost[Math.floor(Math.random()*dost.length)];
				//определить, на сколько поднимать
				var kol:int=(Math.random()<0.5)?2:1;
				if (Math.random()<0.15) kol=3;
				if (skillIsPost(sk)) kol=Math.min(skillPoint,kol,maxPostSkLvl-skills[sk]);
				else kol=Math.min(skillPoint,kol,maxSkLvl-skills[sk]);
				addSkill(sk,kol,true);
				n--;
			}
			n=100;
			while (perkPoint>0 && n>0) {
				dost=new Array();
				for each(var dp:XML in AllData.d.perk) {
					if (dp.@tip==1) {
						var res:int=perkPoss(dp.@id, dp);
						if (res==1) dost.push(dp.@id);
					}
				}
				if (dost.length==0) break;
				sk=dost[Math.floor(Math.random()*dost.length)];
				addPerk(sk,true);
				n--;
			}
		}
		
		//вернуть -1 если перк уже вкачан по максимуму, вернуть 0 если не выполнены условия, вернуть 1 если условия выполнены
		public function perkPoss(nid:String, dp:XML=null):int {
			if (dp==null) dp=AllData.d.perk.(@id==nid)[0];
			if (dp==null) return -1;
			var numb=perks[nid];
			if (numb==null) numb=0;
			var maxlvl=1;
			if (dp.@lvl.length()) maxlvl=dp.@lvl;
			if (numb>=maxlvl) return -1;
			var ok:int=1;
			if (dp.req.length()) {
				for each(var req in dp.req) {
					var reqlevel:int=1;
					if (req.@lvl.length()) reqlevel=req.@lvl;
					if (numb>0 && req.@dlvl.length()) reqlevel+=numb*req.@dlvl;
					if (req.@id=='level') {
						if (level<reqlevel) ok=0;
					} else if (req.@id=='guns') {
						if (getSkLevel(skills['smallguns'])<reqlevel && getSkLevel(skills['energy'])<reqlevel) ok=0;
					} else {
						if (getSkLevel(skills[req.@id])<reqlevel) ok=0;
					}
				}
			}
			return ok;
		}
		
		//lvl1-уровень основных параметров, lvl2-уровень дополнительных параметров с тегом dop=1
		function setSkillParam(xml:XML, lvl1:int, lvl2:int=0) {
			for each(var sk in xml.sk) {
				var val:Number, lvl:int, val0:Number=0;
				if (sk.@dop.length()) lvl=lvl2;
				else lvl=lvl1;
				//исходное значение
				if (sk.@v0.length()) val0=Number(sk.@v0);
				else if (sk.@ref=='add' || sk.@tip=='res') val0=0;
				else if (sk.@ref=='mult') val0=1;
				//устанавливаемое значение
				if (lvl==0) val=val0;
				else if (sk.@vd.length()) val=val0+lvl*Number(sk.@vd);
				else if (sk.attribute('v'+lvl).length()) val=Number(sk.attribute('v'+lvl));
				else val=Number(sk.@v1);
				//установить значение
				if (sk.@tip=='weap') weaponSkills[sk.@id]=val;		//оружейное умение
				else if (sk.@tip=='res') {
					gg.vulner[sk.@id]-=val;	//сопротивление
					setFactor(sk.@id, xml.@id, 'min', val, gg.vulner[sk.@id]);
				} else if (sk.@tip=='m') this[sk.@id]+=val;			//максимум веса
				else if (gg.hasOwnProperty(sk.@id)) {				//переменная юнита
					setBegFactor(sk.@id,gg[sk.@id]);
					if (sk.@ref=='add') gg[sk.@id]+=val;
					else if (sk.@ref=='mult') gg[sk.@id]*=val;
					else gg[sk.@id]=val;
					setFactor(sk.@id, xml.@id, sk.@ref, val, gg[sk.@id]);
				} else if (this.hasOwnProperty(sk.@id)) {											//переменная перса
					setBegFactor(sk.@id,this[sk.@id]);
					if (sk.@ref=='add') this[sk.@id]+=val;
					else if (sk.@ref=='mult') this[sk.@id]*=val;
					else this[sk.@id]=val;
					setFactor(sk.@id, xml.@id, sk.@ref, val, this[sk.@id]);
				} else {
					if (sk.@ref=='add') this[sk.@id]+=val;
					else if (sk.@ref=='mult') this[sk.@id]*=val;
					else this[sk.@id]=val;
				}
			}
		}
		
		function setBegFactor(id:String, res) {
			if ((factor[id] is Array) && factor[id].length==0) factor[id].push({id:'beg', res:res});
		}
		function setFactor(id:String, fact:String, ref:String, val, res, tip=null) {
			if (ref=='add' && val==0 || ref=='mult' && val==1) return;
			if (factor[id] is Array) factor[id].push({id:fact, ref:ref, val:val, res:res, tip:tip});
		}
		
		function setAllSt() {
			headSt=4-Math.ceil(headHP/inMaxHP*4);
			torsSt=4-Math.ceil(torsHP/inMaxHP*4);
			legsSt=4-Math.ceil(legsHP/inMaxHP*4);
			bloodSt=4-Math.ceil(bloodHP/inMaxHP*4);
			manaSt=4-Math.ceil(manaHP/inMaxMana*4);
		}
		
		public function setPonpon(mc:MovieClip) {
			mc.tors.gotoAndStop(torsSt+1);
			mc.head.gotoAndStop(headSt+1);
			mc.legs.gotoAndStop(legsSt+1);
			mc.magic.gotoAndStop(manaSt+1);
			mc.blood.gotoAndStop(bloodSt+1);
			mc.armor.gotoAndStop(1);
			if (gg.currentArmor) {
				var armorSt=4-Math.ceil(gg.currentArmor.hp/gg.currentArmor.maxhp*4);
				mc.armor.gotoAndStop(armorSt+1);
			}
		}
		
		function trauma(st:int, organ:int) {
			if (st>4) st=4;
			if (organ==3 && st==4) st=3;
			if (organ==4) {
				if (st>0) World.w.gui.infoText('blood'+st, persName);
			} else if (organ==5) {
				if (st>1) World.w.gui.infoText('tmana'+st);
			} else {
				if (st>0) World.w.gui.infoText('trauma'+st, persName);
			}
		}
		
		public function damage(dam:Number, tip:int, isDie:Boolean=false) {
			if (isDie) dam=dieDamage*inMaxHP;
			if (dam<=0 || tip==Unit.D_INSIDE || tip==Unit.D_BLEED) return;
			if (tip==Unit.D_NECRO) dam*=0.1;
			dam*=organMult;
			dam*=organMultPot;
			if (radChild>0) dam*=(gg.maxhp-gg.rad)/gg.maxhp;
			var rnd=Math.random();
			var sst:int;
			if (rnd<0.2) {
				if (!isDie) dam*=2;
				sst=4-Math.ceil(headHP/inMaxHP*4);
				headHP-=dam;
				if (headHP<headMin) headHP=headMin;
				if (headHP<=0) {
					headHP=1;
					die();
				}
				headSt=4-Math.ceil(headHP/inMaxHP*4);
				if (sst!=headSt) setParameters();
				if (headSt>sst) trauma(headSt,1);
			} else if (rnd<0.6 || tip==Unit.D_POISON || tip==Unit.D_VENOM) {
				sst=4-Math.ceil(torsHP/inMaxHP*4);
				torsHP-=dam;
				if (torsHP<torsMin) torsHP=torsMin;
				if (torsHP<=0) {
					torsHP=1;
					die();
				}
				torsSt=4-Math.ceil(torsHP/inMaxHP*4);
				if (sst!=torsSt) setParameters();
				if (torsSt>sst) trauma(torsSt,2);
			} else {
				sst=4-Math.ceil(legsHP/inMaxHP*4);
				legsHP-=dam;
				if (legsHP<legsMin) legsHP=legsMin;
				if (legsHP<=0) {
					legsHP=1;
					die();
				}
				legsSt=4-Math.ceil(legsHP/inMaxHP*4);
				if (sst!=legsSt) setParameters();
				if (legsSt>sst) trauma(legsSt,3);
			}
		}
		
		public function die() {
			gg.poison=0;
			gg.cut=0;
			World.w.gui.messText('gameover');
			if (gg.sost==1) gg.die(10);
			else gg.sost=3;
		}
		
		public function bloodDamage(dam:Number, tip:int) {
			if (dam<=0) return;
			dam*=3;
			if (tip==Unit.D_BLEED || tip==Unit.D_BLADE || tip==Unit.D_BUL || tip==Unit.D_FANG) {
				dam*=organMult;
				dam=Math.random()*dam;
				if (tip==Unit.D_BUL || tip==Unit.D_FANG) dam*=0.5;
				var sst:int=4-Math.ceil(bloodHP/inMaxHP*4);
				bloodHP-=dam;
				if (bloodHP<bloodMin) bloodHP=bloodMin;
				if (bloodHP<=0) {
					bloodHP=1;
					die();
				}
				bloodSt=4-Math.ceil(bloodHP/inMaxHP*4);
				if (sst!=bloodSt) setParameters();
				if (bloodSt>sst) trauma(bloodSt,4);
			}
		}
		
		public function manaDamage(dam:Number) {
			if (dam<=0) return;
			//if (dam>0.5) gg.numbEmit.cast(gg.loc,gg.X,gg.Y-gg.scY/2,{txt:Math.round(dam), frame:6, rx:20, ry:20});
			if (gg.loc.train) return;
			//dam*=manahpMult;
			var sst:int=4-Math.ceil(manaHP/inMaxMana*4);
			manaHP-=dam;
			if (manaMin>0 && manaHP<1) manaHP=1;
			if (manaHP<0) {
				manaHP=0;
			}
			manaSt=4-Math.ceil(manaHP/inMaxMana*4);
			if (sst!=manaSt) setParameters();
			if (manaSt>sst) trauma(manaSt,5);
		}
		
		//исцеление 0-самого повреждённого места, 1-голова, 2-корпус, 3-ноги, 4-всё, 5-кровь, 6-мана
		public function heal(hhp:Number, tip:int) {
			var sst:int;
			if (hhp==0) return;
			if (tip==0) {
				if (legsHP<headHP && legsHP<torsHP) tip=3;
				else if (headHP<torsHP) tip=1;
				else tip=2;
			}
			if (tip==1 || tip==4) {
				sst=4-Math.ceil(headHP/inMaxHP*4);
				headHP+=hhp;
				if (headHP>inMaxHP) headHP=inMaxHP;
				headSt=4-Math.ceil(headHP/inMaxHP*4);
				if (sst!=headSt) setParameters();
			}
			if (tip==2 || tip==4) {
				sst=4-Math.ceil(torsHP/inMaxHP*4);
				torsHP+=hhp;
				if (torsHP>inMaxHP) torsHP=inMaxHP;
				torsSt=4-Math.ceil(torsHP/inMaxHP*4);
				if (sst!=torsSt) setParameters();
			}
			if (tip==3 || tip==4) {
				sst=4-Math.ceil(legsHP/inMaxHP*4);
				legsHP+=hhp;
				if (legsHP>inMaxHP) legsHP=inMaxHP;
				legsSt=4-Math.ceil(legsHP/inMaxHP*4);
				if (sst!=legsSt) setParameters();
			}
			if (tip==5) {
				var sst:int=4-Math.ceil(bloodHP/inMaxHP*4);
				bloodHP+=hhp;
				if (bloodHP>inMaxHP) bloodHP=inMaxHP;
				bloodSt=4-Math.ceil(bloodHP/inMaxHP*4);
				if (sst!=bloodSt) setParameters();
			}
			if (tip==6) {
				if (manaHP<inMaxMana && hhp>5) gg.numbEmit.cast(gg.loc,gg.X,gg.Y-gg.scY/2,{txt:('+'+Math.round(hhp)), frame:6, rx:20, ry:20});
				var sst:int=4-Math.ceil(manaHP/inMaxMana*4);
				manaHP+=hhp;
				if (manaHP>inMaxMana) manaHP=inMaxMana;
				manaSt=4-Math.ceil(manaHP/inMaxMana*4);
				if (sst!=manaSt) setParameters();
				World.w.gui.setMana();
			}
		}
		
		public function healAll() {
			headHP=inMaxHP;
			torsHP=inMaxHP;
			legsHP=inMaxHP;
			bloodHP=inMaxHP;
			manaHP=inMaxMana;
		}
		
		public function checkHP() {
			if (headHP>inMaxHP) headHP=inMaxHP;
			if (torsHP>inMaxHP) torsHP=inMaxHP;
			if (legsHP>inMaxHP) legsHP=inMaxHP;
			if (bloodHP>inMaxHP) bloodHP=inMaxHP;
			if (manaHP>inMaxMana) manaHP=inMaxMana;
		}
		
		function traumaParameters() {
			if (headSt>0) setSkillParam(xml_head, Math.min(headSt,3));
			if (torsSt>0) setSkillParam(xml_tors, Math.min(torsSt,3));
			if (legsSt>0) setSkillParam(xml_legs, Math.min(legsSt,3));
			if (bloodSt>0) setSkillParam(xml_blood, Math.min(bloodSt,3));
			if (manaSt>0) setSkillParam(xml_mana, manaSt);
			if (manaSt>=4) {
				if (teleMana>0) gg.levitOn=0;
				isDJ=0;
				spellsPoss=0;
			}
		}
		
		//function armorParam(fact:String, arm:Armor, ref:String
		
		public function armorParameters(arm:Armor) {
			if (arm.dexter!=0) {
				setBegFactor('dexter',gg.dexter);
				gg.dexter+=arm.dexter;
				gg.dodgePlus+=arm.dexter;
				setFactor('dexter', arm.id, 'add', arm.dexter, gg.dexter, 'a');
			}
			if (arm.crit!=0) {
				gg.critCh+=arm.crit;
			}
			gg.showObsInd=gg.showObsInd || arm.showObsInd;
			if (arm.sneak!=1) {
				setBegFactor('visiMult',visiMult);
				visiMult*=(1-arm.sneak);
				setFactor('visiMult', arm.id, 'mult', (1-arm.sneak), visiMult, 'a');
			}
			if (arm.radVul!=1) {
				setBegFactor('radX',gg.radX);
				gg.radX*=arm.radVul;
				setFactor('radX', arm.id, 'mult', arm.radVul, gg.radX, 'a');
			}
			h2oPlav*=arm.h2oMult;
			if (arm.meleeMult!=1) {
				setBegFactor('meleeDamMult',meleeDamMult);
				meleeDamMult*=arm.meleeMult;
				setFactor('meleeDamMult', arm.id, 'mult', arm.meleeMult, meleeDamMult, 'a');
			}
			if (arm.gunsMult!=1) {
				setBegFactor('gunsDamMult',gunsDamMult);
				gunsDamMult*=arm.gunsMult;
				setFactor('gunsDamMult', arm.id, 'mult', arm.gunsMult, gunsDamMult, 'a');
			}
			if (arm.magicMult!=1) {
				setBegFactor('throwForce',throwForce);
				setBegFactor('spellsDamMult',spellsDamMult);
				throwForce*=arm.magicMult;
				spellsDamMult*=arm.magicMult;
				setFactor('throwForce', arm.id, 'mult', arm.magicMult, throwForce, 'a');
				setFactor('spellsDamMult', arm.id, 'mult', arm.magicMult, spellsDamMult, 'a');
			}
			dropTre+=arm.tre;
			if (arm.ableFly) ableFly=1;
			for (var i=0; i<Unit.kolVulners; i++) {
				gg.vulner[i]*=(1 - arm.resist[i]);
				setFactor(i, arm.id, 'mult', (1 - arm.resist[i]), gg.vulner[i], 'a');
			}
			if (arm.id=='socks') socks=true;
		}
		
		//вычислить и установить штрафы на перегрузку
		public function invMassParam() {
			var inv:Invent=World.w.invent;
			maxSpeed=100;
			accelMult=1;
			speedShtr=0;
			jumpMult=1;
			shtrManaRes=1;
			gg.noStairs=false;
			if (!World.w.hardInv) return;
			if (inv.massW>maxmW) speedShtr++; 
			if (inv.massW>maxmW+2) speedShtr++; 
			if (inv.massW>maxmW+4) speedShtr++; 
			if (inv.mass[2]>maxm2) speedShtr++;
			if (inv.mass[2]>maxm2*1.2) speedShtr++;
			if (inv.mass[3]>maxm3) speedShtr++;
			if (inv.mass[3]>maxm3*1.2) speedShtr++;
			if (World.w.loc && !World.w.loc.base && !World.w.loc.train && !World.w.alicorn) {
				if (speedShtr>=3) {
					maxSpeed=0;
					accelMult=0.1;
					jumpMult=0;
					gg.noStairs=true;
					World.w.gui.infoText('overMass');
					World.w.gui.bulb(gg.X, gg.Y-100);
				} else if (speedShtr==2) {
					maxSpeed=3.5;
					accelMult=0.5;
					jumpMult=0.5;
				} else if (speedShtr==1) {
					maxSpeed=7;
					accelMult=0.7;
				}
			}
			//штраф на магию
			if (inv.massM>maxmM && !World.w.alicorn) shtrManaRes-=0.25*(inv.massM-maxmM);
			if (shtrManaRes<0) shtrManaRes=0;
			gg.setSpeeds();
		}
		
		//запомнить процент ХП
		//параметры по умолчанию
		//увеличение хп от уровня
		//скиллы
		//перки
		//восст. хп органов
		//травмы
		//эффекты
		//броня
		//амулеты
		//инструменты и артефакты
		//восст. хп
		
		public function setParameters() {
			//запомнить процент ХП
			var procHP=gg.hp/gg.maxhp;
			var procHead=headHP/inMaxHP;
			var procTors=torsHP/inMaxHP;
			var procLegs=legsHP/inMaxHP;
			var procBlood=bloodHP/inMaxHP;
			var procMana=manaHP/inMaxMana;
			//параметры по умолчанию
			defaultParams();

			var xml:XML;
			//увеличение хп от уровня
			gg.maxhp+=(level-1)*lvlHP;
			inMaxHP+=(level-1)*lvlOrganHp;
			//скиллы
			for (var id in skills) {
				var lvl=0;
				if (skillIsPost(id)) lvl=getPostSkLevel(skills[id]); //trace(id,lvl);
				else lvl=getSkLevel(skills[id]);
				xml=AllData.d.skill.(@id==id)[0];
				setSkillParam(xml, lvl, skills[id]);
			}
			//перки
			for (id in perks) {
				xml=AllData.d.perk.(@id==id)[0];
				setSkillParam(xml, perks[id]);
			}
			//trace('et2',runSpeedMult,stamRun);
			//восст. хп органов
			headHP=procHead*inMaxHP;
			torsHP=procTors*inMaxHP;
			legsHP=procLegs*inMaxHP;
			bloodHP=procBlood*inMaxHP;
			manaHP=procMana*inMaxMana;
			//уменьшение характеристик от состояния здоровья
			if (!World.w.alicorn) traumaParameters();
			//trace('et3',runSpeedMult,stamRun);
			gg.showObsInd=false;
			//trace('-------------');
				//эффекты
			for each(var eff:Effect in gg.effects) {
				id=eff.id;
				if (eff.vse) continue;
				xml=AllData.d.eff.(@id==id)[0];
				setSkillParam(xml, eff.vse?0:eff.lvl);
			}
			//броня и защиты
			if (gg.rat>0) {
			} else if (!World.w.alicorn) {
				if (gg.currentArmor) {
					gg.currentArmor.setArmor();
					armorParameters(gg.currentArmor)
				} else {
					setBegFactor('dexter',gg.dexter);
					gg.dexter+=dexterNoArmor;
					gg.dodgePlus+=dexterNoArmor;
					setFactor('dexter', 'noArmor', 'add', dexterNoArmor, gg.dexter, 'e');
				}
				if (gg.currentAmul) armorParameters(gg.currentAmul);
				//параметры от предметов из инвентаря
				if (gg.invent) setInvParameters(gg.invent);
			} else {
				xml=AllData.d.eff.(@id=='alicorn')[0];
				setSkillParam(xml, 1);
				
				setBegFactor('skin',gg.skin);
				gg.skin+=alicornSkin;
				setFactor('skin', 'alicorn', 'add', alicornSkin, gg.skin, 'e');
				setBegFactor('dexter',gg.dexter);
				gg.dexter+=alicornDexter;
				setFactor('dexter', 'alicorn', 'add', alicornDexter, gg.dexter, 'e');
				setBegFactor('allVulnerMult',gg.allVulnerMult);
				gg.allVulnerMult*=alicornVulner;
				setFactor('allVulnerMult', 'alicorn', 'mult', alicornVulner, gg.allVulnerMult, 'e');
			}
			//восст. хп
			gg.hp=gg.maxhp*procHP;
			if (gg.rad>gg.maxhp-1) gg.rad=gg.maxhp-1;
			gg.setSpeeds();
			if (gg.currentWeapon) gg.currentWeapon.setPers(gg,this);
			if (gg.magicWeapon) gg.magicWeapon.setPers(gg,this);
			if (gg.throwWeapon) gg.throwWeapon.setPers(gg,this);
			World.w.gui.setHp();
			if (World.w.game.triggers['nomed']) {
				organMult=0.5;
				headMin=156;
				torsMin=86;
				legsMin=167;
				bloodMin=113;
				manaMin=56;
			} else {
				headMin=torsMin=legsMin=bloodMin=-1;
			}
			if (gg.pet) gg.pet.setLevel(level);
			World.w.game.triggers['eco']=eco;
			invMassParam();
		}
		
		public function setInvParameters(inv:Invent) {
			if (inv==null) return;
			
			for each (var w in LootGen.arr['pers']) {
				if (inv.items[w].kol>0) {
					if (inv.items[w].xml && inv.items[w].xml.sk.length()) {
						setSkillParam(inv.items[w].xml, 1);	
					} else {
						var xml=AllData.d.eff.(@id==w);
						if (xml.length()) setSkillParam(xml[0], 1);
					}
				}
			}
		}
		//определить уровень требуемого скилла		
		public function getLockTip(lockTip:int):int {
			if (lockTip==1) {
				if (possLockPick>0) return lockPick;
				else return -100;
			}
			if (lockTip==2) return hacker;
			if (lockTip==3) return remine;
			if (lockTip==4) return repair;
			if (lockTip==5) return repair;
			if (lockTip==6) return signal;
			return 0
		}
		
		public function dopusk():Boolean {
			if (headHP<=1 || torsHP<=1 || legsHP<=1 || bloodHP<=1) return false;
			else return true;
		}
		
		//определить уровень мастерства для взлома замка
		public function getLockMaster(lockTip:int):int {
			if (lockTip==1) return unlockMaster;
			if (lockTip==2) return hackerMaster;
			return 100;
		}
		
		public function setRoboowl() {
			owlhp=0;
			owlhpProc=1;
			if (gg.pets['owl']) {
				gg.pets['owl'].setLevel(level);
				owlhp=gg.pets['owl'].maxhp;
				owlhpProc=gg.pets['owl'].hp/gg.pets['owl'].maxhp;
			}
		}
		
		//определить необходимое для действия время
		public function getLockPickTime(lock:int, lockTip:int):int {
			var pick=getLockTip(lockTip);
			//if (lock>pick+1) return lockPickTime*(1+(lock-pick-1)*0.5);
			//if (lock>pick+1) return Math.min(lockPickTime*(1+(lock-pick-1)*0.2),100);
			if (lock<pick) return lockPickTime*0.6;
			return lockPickTime;
		}
		
		public function repTex():String {
			if (rep>=repGood) return Res.pipText('reputmax');
			if (rep>=rep4) return Res.pipText('reput4');
			if (rep>=rep3) return Res.pipText('reput3');
			if (rep>=rep2) return Res.pipText('reput2');
			if (rep>=rep1) return Res.pipText('reput1');
			return Res.pipText('reput0');
		}
		
		
	}
	
}

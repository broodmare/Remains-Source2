package fe.game.domain.units {

	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	
	import starling.display.BlendMode;
	
	import fe.game.domain.location.tile.Tile;
	import fe.game.domain.serv.BlitAnim;
	import fe.game.domain.serv.LootGen;
	import fe.game.rendering.Emitter;
	import fe.game.domain.projectile.Bullet;
	import fe.game.domain.projectile.MagSymbol;
	import fe.engine.audio.Sound;
	import fe.game.WeaponManager;
	import fe.game.GameContainer;
	import fe.game.enums.E_Direction;
	
	public class UnitBossNecr extends UnitPon {

		public var scrAlarmOn:Boolean = true;
		public var controlOn:Boolean = true;
		public var kol_emit:int = 6;
		public var called:int=0;
		public var timeProtectCuld:int=600;
		public var timeAttackCuld:int=350;
		public var timeProtect:int=250;
		public var timeCurseCuld:int=300;
		
		public var phase:int=1;
		
		private var atk_t:int=150, throu_t:int=0;
		private var atk_n:int=-1, prot_n:int=1;
		private var protculd_t:int=timeProtectCuld/3;
		private var curseculd_t:int=timeCurseCuld/2;
		private var prot_t:int=0;
		private var healHp:Number=100;
		private var summonAtkMult:Number=0.5;
		
		private var isShadow:Boolean=false;
		//невидимость
		private var superInvis:Boolean=false;
		private var curA:int=100, celA:int=100;
		
		private var curses:Array=['stupor','weak','pinkcloud','relat','fetter','sacrifice','sacrifice','antil','antil'];
		
		protected var shadowFilter:DropShadowFilter;
		protected var ghostFilter:GlowFilter;
		
		public function UnitBossNecr(cid:String=null, ndif:Number=100, xml:XML=null, loadObj:Object=null) {
			super(cid, ndif, xml, loadObj);
			
			id='bossnecr';
			initArt(id);
			art.play('stay');
			getXmlParam();
			walkSpeed=maxSpeed;
			plavSpeed=maxSpeed;
			runSpeed=maxSpeed*3;
			plavdy=accel;
			porog=45;
			boss=true;
			aiTCh=80;
			destroy=110;
			
			//дать оружие
			currentWeapon = WeaponManager.reference.cloneWeapon("necrbullet");
			WeaponManager.reference.setOwner(currentWeapon, this);
			
			if (currentWeapon) {
				childObjs = new Array(currentWeapon);
			}
			
			areaTestTip='en';
			aiNapr=storona;
			
			shadowFilter=new DropShadowFilter(0,90,0,0.5,3,3,1,3,false,false,true);
			ghostFilter=new GlowFilter(0x9999FF,1,6,6,2,3);
			timerDie=90;
			
			if (GameContainer.reference.game.globalDif==3) {
				summonAtkMult = 0.65;
			}
			else if (GameContainer.reference.game.globalDif==4) {
				summonAtkMult = 0.80;
			}
		}
		

		public override function setLevel(nlevel:int=0):void {
			super.setLevel(nlevel);
			
			var wMult:Number = (1 + level * 0.08);
			var dMult:Number = 1;
			healHp = maxhp / 10;
			
			if (GameContainer.reference.game.globalDif==3) {
				dMult = 1.20;
			}
			
			if (GameContainer.reference.game.globalDif==4) {
				dMult = 1.50;
			}
			
			hp=maxhp=hp*dMult;
			dam*=dMult;
			
			if (currentWeapon) {
				currentWeapon.damage*=dMult;
			} 
		}
		
		public override function animate():void {
			if (sost==3) { //сдох
				if (animState!='die') {
					art.play('die');
					animState='die';
				}
			}
			else if (sost==2) { 
				if (animState!='die') {
					newPart('necrblast2');
					art.play('die');
					animState='die';
				}
			}
			else if (aiState==3) {
				if (animState!='cast') {
					art.play('cast');
					animState='cast';
				}
			}
			else if (stay) {
				if (velocity.X < 1 && velocity.X > -1) {
					if (animState!='stay') {
						art.play('stay');
						animState='stay';
					}
				}
				else if (aiState==1) {
					if (animState!='run') {
						art.play('run');
						animState='run';
					}
				}
				else {
					if (animState!='trot') {
						art.play('trot');
						animState='trot';
					}
				}
			}
			else if (levit) {
				if (animState!='derg') {
					art.play('derg');
					animState='derg';
				}
			}
			else {
				if (animState!='jump') {
					animState='jump';
					var cframe:int = Math.round(16+velocity.Y);
					
					if (cframe > 32) {
						cframe = 32;
					}
					
					if (cframe < 1) {
						cframe = 1;
					}
					
					art.show('jump', Math.min(cframe, art.frameCount('jump')) - 1);	// The pose for its take-off speed, held; past the last pose, the last
				}
			} 
			
			if (superInvis && GameContainer.reference.pers.infravis == 0) {
				celA = 0;
			}
			else {
				celA = 100;
			}
			
			if (curA > celA) {
				curA -= 5;
			}
			
			if (curA < celA) {
				curA += 5;
			}
			
			art.alpha = curA / 100;
		}
		
		public override function setWeaponPos(tip:String = "internal"):void {
			weaponX = coordinates.X;
			weaponY = coordinates.Y - this.boundingBox.height * 0.58;
		}
		
		public override function damage(dam:Number, tip:String, bul:Bullet=null, tt:Boolean=false):Number {
			var td:Number = super.damage(dam, tip, bul, tt);
			
			if (aiState==0) {
				aiState=1;
			}
			
			if (protculd_t<=0 && td>0 && aiState!=3 && aiState!=2) {
				aiState=3;
				aiTCh=30;
			}
		
			curseculd_t-=Math.floor(td/40);
			atk_t-=Math.floor(td/30);
		
			return td;
		}
		
		public override function setNull(f:Boolean=false):void {
			if (isNoResBoss()) {
				f = false;
			}
			
			super.setNull(f);

			//вернуть в исходную точку
			if (begX>0 && begY>0) {
				setPos(begX, begY);
			}

			velocity.set(0, 0);

			if (f) {
				phase=1;
				sost=1;
				visDetails();
				setVis();
				
				timeCurseCuld=300;
				dexter=1;
				blood=1;
			}

			setWeaponPos();
			aiState=aiSpok=0;
		}
		
		public function jump(v:Number=1):void  {
			if (stay) {		//прыжок
				velocity.Y = -jumpdy * v;
			}

			if (stay) {
				if (aiNapr==E_Direction.LEFT) velocity.X *= 0.8;
				else velocity.X += storona.X * accel * 2;
			}
		}
		
		//aiState
		//0 - стоит на месте
		//1 - бегает
		//2 - атакует
		//3 - защита
		
		override protected function control():void {
			var t:Tile;
			
			//если сдох, то не двигаться
			if (sost==3) {
				return;
			}
			
			if (sost==2) {
				velocity.X = 0;
				return;
			}
			
			var jmp:Number=0;
			
			if (!controlOn) {
				return;
			}
			
			if (loc.gg.invulner) {
				return;
			}
			
			if (GameContainer.reference.enemyAct<=0) {
				celY = coordinates.Y - this.boundingBox.height;
				celX = coordinates.X + this.boundingBox.width * storona.X * 2;
				return;
			}
			
			if (levit && protculd_t<=0) {
				castProtect(1);
			}
			
			if (throu_t>0) {
				throu_t--;
			}
			else {
				throu=false;
			}
			
			if (prot_t>0) {
				prot_t--;
			}
			
			if (prot_t==1) {
				resetProtect();
			}
			
			if (protculd_t>0) {
				protculd_t--;
			}
			
			if (curseculd_t>0) {
				curseculd_t--;
			}
			else {
				if (phase==2 && isrnd(0.25)) {
					castCurse(2,0);
					castCurse(2,4);
					castCurse(2,8);
					castCurse(2,12);
					castCurse(2,16);
				}
				else if (isrnd(0.25)) {
					castCurse(1,0);
					castCurse(1,10);
					castCurse(1,20);
				}
				else {
					castCurse();
				}
				curseculd_t=Math.floor((Math.random()*1.6+0.2)*timeCurseCuld);
			}
			
			if (aiState!=3 && aiState!=2) {
				if (atk_t>0) {
					atk_t--;
				}
				else {
					atk_n++;
					
					if (atk_n%2==0) {
						if (!isShadow && findCel()) {
							aiState=2;
							aiTCh=140;
							newPart('necrblast3');
							velocity.X *= 0.5;
							walk=E_Direction.NEUTRAL;
							resetProtect();
						}
						else {
							atk_n++;
						}
					}
					
					if (atk_n%2==1) {
						spawn(atk_n%((phase==1)?6:8));
					}
					
					atk_t=Math.floor((Math.random()*0.6+0.7)*timeAttackCuld);
				}
			}
			
			invis = superInvis;
			
			//таймер смены состояний
			if (aiTCh>0) {
				aiTCh--;
			}
			else {
				if (aiState==3) {
					aiState=0;
					castProtect();
				}
				
				if (aiState==0) {
					aiState=1;
					if (isrnd(0.8)) aiNapr=(celDX>0)?E_Direction.LEFT:E_Direction.RIGHT;
					else aiNapr=(celDX>0)?E_Direction.RIGHT:E_Direction.LEFT;
					storona=aiNapr;
				}
				else {
					if (isrnd(0.5)) aiNapr=(celDX>0)?E_Direction.LEFT:E_Direction.RIGHT;
					aiState=isrnd(0.7)?1:0;
					storona=aiNapr;
				}
				
				if (isrnd(0.3)) {
					jmp=1;
				}
				
				if (isrnd(0.3)) {
					throu_t=5;
					throu=true;
				}
				
				aiTCh=Math.floor(Math.random()*100+40);
			}
			
			//поиск цели
			if (aiTCh%10==1) {
				if (loc.gg.pet && loc.gg.pet.sost==1 && isrnd(0.4)) {
					setCel(loc.gg.pet);
				}
				else {
					setCel(loc.gg);
				}
			}
			
			//направление
			celDX = celX - coordinates.X;
			celDY = celY - coordinates.Y + this.boundingBox.height;
			
			//поворот от игрока
			if (aiTCh%10==1 && aiState==1 && celDY<80 && celDY>-80) {
				if (celDX<0 && celDX>-400) aiNapr=storona=E_Direction.RIGHT;
				if (celDX>0 && celDX<400) aiNapr=storona=E_Direction.LEFT;
			}
			
			//скорость
			maxSpeed=walkSpeed;
			
			if (aiState==1) {
				maxSpeed=runSpeed;
			}
			
			//поведение при различных состояниях
			if (aiState==0) {
				if (velocity.X > 0.5) {
					storona=E_Direction.RIGHT;
				}
				
				if (velocity.X < -0.5) {
					storona=E_Direction.LEFT;
				}

				walk=E_Direction.NEUTRAL;
			}
			else if (aiState==1) {
				//определить, куда двигаться

				if (levit) {
					if (aiNapr==E_Direction.LEFT) {
						if (velocity.X > -maxSpeed) {
							velocity.X -= levitaccel;
						}
					}
					else {
						if (velocity.X < maxSpeed) {
							velocity.X += levitaccel;
						}
					}
				}
				else if (stay || isPlav) {
					if (aiNapr==E_Direction.LEFT) {
						if (velocity.X > -maxSpeed) {
							velocity.X -= accel;
						}

						walk = E_Direction.LEFT;
					}
					else {
						if (velocity.X < maxSpeed) {
							velocity.X += accel;
						}

						walk = E_Direction.RIGHT;
					}
				}
				else {
					if (aiNapr==E_Direction.LEFT) {
						if (velocity.X > -maxSpeed) {
							velocity.X -= accel * 0.25;
						}
					}
					else  if (aiNapr==E_Direction.RIGHT){
						if (velocity.X < maxSpeed) {
							velocity.X += accel * 0.25;
						}
					}
				}
				
				if (stay && (shX1>0.5 && aiNapr==E_Direction.LEFT || shX2>0.5 && aiNapr==E_Direction.RIGHT) && isrnd(0.8)) {
					jmp=0.40;
				}
				
				if (stay && coordinates.Y-begY>=35) {
					jmp=0.60;
				}
				
				if (turnX!=E_Direction.NEUTRAL) {
					if (celDX*aiNapr.X<0) {				//повернуться, если цель сзади
						aiNapr=storona=turnX;
						aiTTurn=Math.floor(Math.random()*20)+5;
					}
					else {							//попытаться перепрыгнуть, если цель спереди
						aiTTurn--;
						
						if (aiTTurn<0) {
							aiNapr=storona=turnX;
							aiTTurn=Math.floor(Math.random()*20)+5;
						}
					}
					
					turnX=turnY=E_Direction.NEUTRAL;
				}
				
				if (jmp>0) {
					storona=aiNapr;
					jump(jmp);
					jmp=0;
				}
			}
			else if (aiState==2) {
				celA=100;
				velocity.X *= 0.7;
				aiNapr=storona=(celDX>0)?E_Direction.RIGHT:E_Direction.LEFT;
				
				if (aiTCh<120) {
					currentWeapon.attack();
				}
			}
			
		}
		
		public override function die(sposob:int=0):void {
			resetProtect();
			
			if (phase==1) {
				phase=2;
				sost=1;
				hp=maxhp-0.1;
				aiState=0;
				aiTCh=10;
				visDetails();
				setVis();
				timerDie=0;
				
				timeCurseCuld=220;
				dexter=2;
				blood=0;
			}
			else {
				for each(var un:Unit in loc.units) {
					if (un.mother==this) {
						un.die();
					}
				}
				
				super.die();
			}
		}
		
		public function castProtect(n:int=0):void {
			protculd_t=timeProtectCuld;
			newPart('black', 20);
			
			if (n==0 && prot_n==0) {
				heal(healHp);
				this.visDetails();
			}
			else if (n==1 || prot_n==1) {
				isShadow=true;
				invulner=transp=true;
				levitPoss=false;
				setVis();
				prot_t=timeProtect;
				atk_t=5;
			}
			else {
				superInvis=true;
				isVis=false;
				curA=celA=0;
				prot_t=timeProtect;
			}
			
			prot_n++;

			if (prot_n>=3) {
				prot_n=0;
			}
		}
		
		private function spawn(n:int=0):void {
			if (kolChild >= kol_emit) {
				return;
			}
			
			loc.resetUnits();
			
			for (var i:int = 0; i < 3; i++) {
				var xmlun:XML;
				
				if (n==1) {
					xmlun=<un id='zombie' tr='7' hpmult='0.85'/>;
				}
				else if (n==3) {
					xmlun=<un id='zombie' tr='8' hpmult='0.75'/>;
				}
				else if (n==5) {
					xmlun=<un id='necros'  hpmult='0.65'/>;
				}
				else if (n==7) {
					xmlun=<un id='zombie' tr='9' hpmult='0.65'/>;
				}
				else {
					return;
				}
				
				var un:Unit=loc.waveSpawn(xmlun,i,'magsymbol');
				
				if (un) {
					un.fraction=fraction;
					un.inter.cont='';
					un.mother=this;
					un.sndMusic=null;
					un.areaTestTip=areaTestTip;
					un.dam*=summonAtkMult;
				
					if (un.currentWeapon) {
						un.currentWeapon.damage*=summonAtkMult;
						un.currentWeapon.damageExpl*=summonAtkMult;
					}
				
					kolChild++;
				}
				
				if (kolChild>=kol_emit) {
					return;
				}
			}
		}

		public function castCurse(n:int=0, otlozh:int=0):void {
			var nx:Number = loc.gg.coordinates.X + loc.gg.velocity.X * 15 + (Math.random()-0.5)*50;
			var ny:Number = loc.gg.coordinates.Y - loc.gg.boundingBox.halfHeight + loc.gg.velocity.Y * 15 + (Math.random() - 0.5) * 30;
			
			if (n == 2) {
				nx = loc.gg.coordinates.X + loc.gg.velocity.X * 15 + (otlozh - 8) * 20 * ((int(loc.gg.coordinates.X)%2 == 0)? E_Direction.RIGHT.X : E_Direction.LEFT.X);
				ny = loc.gg.coordinates.Y - loc.gg.boundingBox.halfHeight + loc.gg.velocity.Y * 15;
			}
			
			if (n == 1) {
				nx += Math.random() * 200 - 100;
				ny += Math.random() * 100 - 50;
			}
			
			if (nx>loc.maxX-100) nx=loc.maxX-100;
			
			if (nx<100) nx=100;
			
			if (ny>loc.maxY-100) ny=loc.maxY-100;
			
			if (ny<100) ny=100;
			
			var ms:MagSymbol=new MagSymbol(this,curses[int(Math.random()*(phase==2?9:5))],nx,ny,otlozh);
		}
		
		public function resetProtect():void {
			superInvis=false;
			isVis=levitPoss=true;
			isShadow=invulner=transp=false;
			setVis();
		}
		
		public function setVis():void {
			art.blendMode=BlendMode.NORMAL;
			if (isShadow) art.setFilters([shadowFilter]);
			else if (phase==2) {
				art.blendMode=BlendMode.SCREEN;
				art.setFilters([ghostFilter]);
			}
			else art.setFilters(null);
		}
		
		public override function dropLoot():void {
			newPart('necrblast');
			Sound.ps('unreal');
			super.dropLoot();
		}
		
		public override function command(com:String, val:String=null):void {
			super.command(com, val);
			
			if (com=='off') {
				walk=E_Direction.NEUTRAL;
				controlOn=false;
			} else if (com=='on') {
				controlOn=true;
			}
		}		
	}
}
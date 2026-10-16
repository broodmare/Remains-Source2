package fe.game.domain.units {
	
	import fe.engine.utils.Numbers;
	import fe.engine.utils.Vec2;
	import fe.game.rendering.Emitter;
	import fe.game.domain.entities.BoundingBox;
	import fe.game.domain.objects.Box;
	import fe.game.World;
	import fe.game.ui.GUIManager;
	import fe.game.GameContainer;
	import fe.game.domain.units.enums.E_Resistances;
	import fe.game.enums.E_Direction;

	import starling.textures.TextureSmoothing;
	
	public class UnitPet extends Unit {

		private static const MOON_HUB_X:Number		= -1.5;		// Where the moon's body turns, from its origin, as its sheet is drawn
		private static const MOON_HUB_Y:Number		= -0.95;
		private static const MOON_FAST_TURN:Number	= 30.0 * Numbers.DEG_TO_RAD;	// Each tick while it hunts or fights
		private static const MOON_SLOW_TURN:Number	= 3.0 * Numbers.DEG_TO_RAD;
		
		private var moonTurn:Number = 0.0;		// How far the moon's body has turned from its sheet's drawing
		private var spd:Object;
		private var flyX:Number=0, flyY:Number=0, flyDX:Number=0, flyDY:Number=0, flyR:Number, flyBox:Box;	//точка, в которую надо лететь
		private var iskr:Emitter;
		public var gg:UnitPlayer;
		public var active:Boolean=false;
		private var rasstGG:Number=200;		//дистанция до ГГ, больше которой включается следование
		private var rasstUnmat:Number=400;		//дистанция до ГГ, больше которой включается нематериальность
		private var rasstVisEn:Number=800;	//максимальная дистанция атаки
		private var rasstWeap:Number=200;	//дистанция атаки
		private var rasstOut:Number=100;	//дистанция отлёта
		private var tempUnmat:Boolean=false;
		
		private var optEnW:Boolean=true;	//энергетическое оружие
		private var optSit:Boolean=true;	//садиться на ящики
		public var optAutores:Boolean=true;	//автовозрождение
		private var optUncall:Boolean=false;	//отзыв при смерти
		private var optTurn:Boolean=true;	//поворачиваться

		public function UnitPet(cid:String=null, ndif:Number=100, xml:XML=null, loadObj:Object=null) {

			super(cid, ndif, xml, loadObj);
			id = 'phoenix';
			if (cid != null) id = cid;
			getXmlParam();
			fraction = Unit.F_PLAYER;
			
			if (id == 'moon') {
				sheetName = 'moon';
				initBlit();
				art.smoothing = TextureSmoothing.BILINEAR;	// Its sheet is drawn from vector art, which Flash smoothed
				art.pivotX = MOON_HUB_X;
				art.pivotY = MOON_HUB_Y;
			}
			else {
				initBlit();
				animState='fly';
			}
			aiState=1;
			walkSpeed=maxSpeed;
			runSpeed=maxSpeed*2;
			isFly=true;
			isSats=false;
			spd=new Object();
			elast=0.2;
			plaKap=true;
			mater=false;
			activateTrap=0;
			currentWeapon=getXmlWeapon(ndif);
			if (currentWeapon) {
				childObjs = new Array(currentWeapon);
			}
			if (id == 'phoenix') {
				optAutores=true;
				rasstWeap=200;
			}
			if (id == 'owl') {
				optAutores=false;
				rasstWeap=400;
				vulnerabilities.setResist(E_Resistances.DAM_DEATH, 0.20);
			}
			if (id == 'moon') {
				knocked=0;
				optAutores=false;
				optSit=false;
				optUncall=true;
				rasstWeap=400;
				optTurn=false;
				storona=E_Direction.RIGHT;
				vulnerabilities.setResist(E_Resistances.DAM_DEATH, 0.5);
			}
			transT = true;
			sost = 4;
		}

		public override function expl():void {
			if (id == 'phoenix') {
				newPart('green_spark', 25);
			}
			if (id == 'owl') {
				newPart('orange_spark', 25);
			}
			if (id == 'moon') {
				newPart('blue_spark', 25);
			}
		}
		
		public override function step():void {
			if (World.w.loc.petOn) super.step();
		}
		
		public override function forces():void {
			if (isFly) {
				if (velocity.X * velocity.X + velocity.Y * velocity.Y > maxSpeed * maxSpeed) {
					velocity.multiply(0.80);
				}
				if (isPlav) {
					velocity.multiply(0.90);
					if (mater) velocity.Y += GameContainer.ddy * ddyPlav;
				}
			}
			else {
				super.forces();
			}
		}
		
		//лечение 0-предметами, 1-радиацией
		public override function heal(hl:Number, tip:int=0, ismess:Boolean=true):void {
			if (tip == 1 && (id != 'phoenix' || sost >= 3)) return;
			hp += hl;
			if (hp>maxhp) hp=maxhp;
			if (hl > 0) visDetails();
			if ((tip == 0 || hl >= 10) && active && ismess) {
				numbEmit.cast(loc, coordinates.X, coordinates.Y - this.boundingBox.halfHeight, {txt:'+' + Math.round(hl), frame:4, rx:10, ry:10});
			}
		}
		
		public override function setNull(f:Boolean=false):void {
			super.setNull(f);
			aiState=1;
			getFlyPoint();
			if (optTurn) storona = (celX > coordinates.X)? E_Direction.RIGHT:E_Direction.LEFT;
		}
		
		//настройка силы спутника
		public override function setLevel(nlevel:int = 1):void {
			level = nlevel - 1;
			var koef:Number = hp / maxhp;

			if (id == 'phoenix') {
				maxhp=gg.pers.petHP*(1+level*0.12);
				dam=gg.pers.petDam*(1+level*0.1);
				currentWeapon.damage=gg.pers.petDam*(1+level*0.1);
				skin=gg.pers.petSkin;
				allVulnerMult=gg.pers.petVulner;
			}
			else if (id == 'owl') {
				maxhp=gg.pers.owlHP*(1+level*0.1);
				dam=gg.pers.owlDam*(1+level*0.1);
				currentWeapon.damage=gg.pers.owlDam*(1+level*0.1);
				skin=gg.pers.owlSkin;
				allVulnerMult=gg.pers.owlVulner;
			}
			else if (id == 'moon') {
				maxhp=gg.pers.moonHP*(1+level*0.1)*gg.spellPower;
				dam=gg.pers.moonDam*(1+level*0.1)*gg.spellPower;
			}
			hp=koef*maxhp;
		}
		
		public override function setWeaponPos(tip:String = "internal"):void {
			if (id == 'phoenix') {
				weaponX = coordinates.X + 15 * storona.X;
				weaponY = coordinates.Y - 20;
			}
			else {
				weaponX = coordinates.X + 11 * storona.X;
				weaponY = coordinates.Y - 18;
			}
			
			magicX = weaponX;
			magicY = weaponY;
		}
		
		public override function animate():void {
			if (detectionDelay > 30) art.alpha = 0;
			else if (detectionDelay > 0) art.alpha = 1 - detectionDelay / 30;
			else art.alpha=1;
			
			if (id=='moon') {
				if (aiState==4 || aiState==5 || aiState==2) {
					art.show('active', 0);
					moonTurn += MOON_FAST_TURN;
				} else {
					art.show('stay', 0);
					moonTurn += MOON_SLOW_TURN;
				}
				art.rotation = moonTurn * storona.X;
			}
			else {
				if (aiState==0) animState='stay';
				else animState='fly';
				if (animState!=animState2) {
					anims[animState].restart();
					animState2=animState;
				}
				if (!anims[animState].st) {
					blit(animState, Math.floor(anims[animState].f));
				}
				anims[animState].step();
			}
			
			if (hpbar) {
				hpbar.alpha = art.alpha;
			}
		}

		// The moon's body turns about its hub, which the way it faces mirrors
		public override function setVisPos():void {
			super.setVisPos();
			if (id == 'moon') {
				art.x = coordinates.X + MOON_HUB_X * storona.X;
				art.y = coordinates.Y + MOON_HUB_Y;
			}
		}

		public override function visDetails():void {
			super.visDetails();
			GUIManager.reference.gui.setPet();
		}
		
		//найти точку следования
		private function getFlyPoint():void {
			var rx:Number=-120;
			var ry:Number=-80;
			flyBox=null;
			flyX = gg.coordinates.X + gg.storona.X * rx;
			flyY = gg.coordinates.Y + ry;
			
			if (flyX<60) flyX=60;
			
			if (flyX>loc.maxX-60) flyX=loc.maxX-60;
			
			if (flyY<80) flyY=80;
			
			if (flyY>loc.maxY-40) flyY=loc.maxY-40;
			
			if (optSit) {
				for each (var b:Box in loc.objs) {
					if (b.wall == 0 && b.stay && !b.invis && b.boundingBox.left<flyX && b.boundingBox.right>flyX && flyY-b.boundingBox.top<80 &&  flyY-b.boundingBox.top>-40) {
						flyY = b.boundingBox.top;
						flyX = b.coordinates.X;
						flyBox = b;
						break;
					}
				}
			}
			
			if (!loc.collisionUnit(flyX, flyY, this.boundingBox.width, this.boundingBox.height)) {
				return;
			}
			
			flyX = int(flyX / 40) * 40 + 20; // Weird math is grid alignment
			flyY = int(flyY / 40) * 40 + 39;
			
			if (loc.getAbsTile(flyX,flyY).collision == 0) return;
			
			flyX += 40 * gg.storona.X;
			flyY += 40;
			
			if (loc.getAbsTile(flyX, flyY).collision == 0) return;
			
			flyY += 40;
			
			if (loc.getAbsTile(flyX, flyY).collision == 0) return;
			
			flyX += 40 * gg.storona.X;
			
			if (loc.getAbsTile(flyX, flyY).collision == 0) return;

			flyX = gg.coordinates.X;
			flyY = gg.coordinates.Y - 1;
		}
		
		private function visCelUnit(un:Unit):Boolean {
			return loc.isLine(coordinates.X, coordinates.Y - 30, un.coordinates.X, un.coordinates.Y - un.boundingBox.halfHeight);
		}
		
		public override function findCel(over:Boolean = false):Boolean {
			celUnit=null;
			if (gg.invulner) {
				return false;	// Changed from null to false
			}
			
			for each (var un:Unit in loc.units) {
				if (un.disabled || un.sost>=3 || un.fraction==fraction || un.doop || un.invis || un.invulner || un.noAgro || un.trigDis) continue;
				
				if (un is UnitTurret && un.aiState<=1) continue;
				
				var tx:Number = un.coordinates.X - coordinates.X;
				var ty:Number = un.coordinates.Y - coordinates.Y;
				
				if (tx * tx + ty * ty > rasstVisEn * rasstVisEn) continue;	//если расстояние больше расстояния атаки, игнорировать
				
				if (optEnW && un.isPlav) continue;	//если враг под водой, игнорировать 
				
				if (currentWeapon && currentWeapon.damage * un.vulnerabilities.getResist(currentWeapon.tipDamage) < (optEnW?un.marmor:un.armor)+un.skin+1-currentWeapon.pier) continue;	//если оружие не наносит урона, игнорировать
				
				if (visCelUnit(un)) {
					setCel(un);
					return true;
				}
			}
			
			return false;
		}
		
		//приказ двигаться
		public function moveto(nx:Number, ny:Number, unmat:Boolean=false):void {
			if (sost==4 || detectionDelay > 0) return;
			tempUnmat=unmat;
			flyBox=null;
			if (!loc.base && loc.getAbsTile(nx,ny).visibility<0.5) {
				//не лететь в неразведанное место
				return;
			}
			flyX=nx;
			flyY=ny+20;
			aiState=3;
			
			if (optTurn) storona=(flyX > coordinates.X)? E_Direction.RIGHT:E_Direction.LEFT;
			
			aiTCh=100;
		}
		
		//приказ атаковать
		public function atk(un:Unit):void {
			tempUnmat=false;
			if (visCelUnit(un)) {
				setCel(un);
				flyBox=null;
				aiState=2;
			}
		}
		
		public function call():void {
			active=true;
			
			if (hp<=0 && !optAutores) return;
			
			if (sost == 4 && optAutores) resurrect();
			
			detectionDelay = 60;
			art.alpha=0;
			art.visible=true;
			aiState=1;
			sost=1;
			addVisual();
			flyX = gg.coordinates.X;
			flyY = gg.coordinates.Y - 20;
			setLevel(gg.pers.level);
			
			if (loc && loc.units) loc.units[1]=this;
		}
		
		//отзыв
		public function recall():void {
			active = false;
			sost = 4;
			
			if (art.visible) {
				expl();
			}
			
			art.visible = false;
			
			remVisual();
		}
		
		public override function die(sposob:int=0):void {
			if (sost>=3) return;
			
			if (optAutores)	GUIManager.reference.gui.infoText('petDie', nazv, GameContainer.reference.pers.petRes);
			else GUIManager.reference.gui.infoText('petDie2',nazv);
			
			if (optUncall) {
				recall();
				gg.pet=null;
				gg.childObjs[2]=null;
				gg.currentPet='';
				return;
			}
			
			if (hpbar) hpbar.visible=false;
			
			art.visible=false;
			hp=0;
			poison=stun=cut=0;
			sost=4;
			expl();
			if (optAutores)	gg.noPet=GameContainer.reference.pers.petRes*30;
			GUIManager.reference.gui.setPet();
		}
		
		public function resurrect():void {
			GUIManager.reference.gui.infoText('petRes', nazv);
			if (hpbar) hpbar.visible=false;
			hp=Math.min(100,maxhp/2);
			setLevel(gg.pers.level);
			visDetails();
			coordinates.X = gg.coordinates.X;
			coordinates.Y = gg.coordinates.Y - 20;
			detectionDelay = 60;
			art.alpha=0;
			cut=0;
			poison=0;
			stun=0;
			art.visible=true;
			sost=1;
			aiState=1;
			GUIManager.reference.gui.setPet();
		}
		
		public function repair(hl:Number):Boolean {
			if (hp<0) hp=0;
			if (hp>=maxhp) return false;
			heal(hl,0,false);
			if (sost==4) {
				sost=1;
				if (gg.currentPet==id) {
					GUIManager.reference.gui.infoText('petRes', nazv);
					setLevel(gg.pers.level);
					visDetails();
					coordinates.X = gg.coordinates.X;
					coordinates.Y = gg.coordinates.Y - 20;
					detectionDelay = 60;
					art.alpha = 0;
					cut=0;
					poison=0;
					stun=0;
					art.visible=true;
					aiState=1;
					GUIManager.reference.gui.setPet();
				}
			}
			return true;
		}
		
		//состояния
		//0 - сидит на месте
		//1 - следует
		//2 - атакует
		//3 - движется в указанное место
		//4 - атакует корпусом
		//5 - после атаки корпусом
		
		override protected function control():void
		{
			if (sost>=3 || !active) return;
			if (stun) {
				return;
			}
			if ((rasst2<rasstUnmat*rasstUnmat) || celUnit) {
				if (!mater && aiTCh%10==1 && !collisionAll()) mater=true;
			} else {
				mater=false;
			}
			if (tempUnmat) mater=false;
			if (aiTCh>0) aiTCh--;		//счётчик смены состояний
			else {						//смена состояний
				tempUnmat=false;
				if (aiState==0 || aiState==1) {	//выбрать точку следования
					if (rasst2>rasstGG*rasstGG || isPlav) {
						aiState=1;
						getFlyPoint();
						if (optTurn) storona=(flyX > coordinates.X)? E_Direction.RIGHT:E_Direction.LEFT;
					} else {
						if (optTurn) storona=(flyX > gg.coordinates.X)? E_Direction.LEFT:E_Direction.RIGHT;
					}
				} else if (aiState==2) {
					if (rasst2>rasstGG*rasstGG*9) getFlyPoint();
					if (celUnit==null) setCel(null, celX+Math.random()*300-150, celY+Math.random()*120-60);
				} else if (aiState==4 || aiState==5) {
					aiState=2;
				} else if (aiState==3) {
					if (GameContainer.reference.t_battle<=0) aiState=1;
					else aiState=2;
				}
				if (gg.velocity.X > 2 || gg.velocity.X < -2) aiTCh=int(Math.random()*20)+10;
				else aiTCh=int(Math.random()*100)+30;
			}
			//движение
			if (isFly) {
				flyDX = flyX - coordinates.X;
				flyDY = flyY - coordinates.Y;
				var flyR:Number = Math.sqrt(flyDX*flyDX+flyDY*flyDY);
				
				if (aiState==0) {
					velocity.set(0, 0);
					spd.x = 0;
					spd.y = 0;
					if (flyBox && !flyBox.stay) {
						aiState=1;
						flyBox=null;
					}
				}
				
				if (aiState==2) {
					if (optTurn) storona=(celX > coordinates.X)? E_Direction.RIGHT:E_Direction.LEFT;
					if (flyR>rasstWeap*0.9 || !mater) {
						spd.x=flyDX;
						spd.y=flyDY;
						norma(spd,Math.min(accel*2,accel*flyR/200));
					}
					else if (flyR<rasstOut) {	//улетать от цели
						spd.x=-flyDX;
						spd.y=-flyDY/2-3;
						norma(spd,accel);
					}
					else {
						velocity.multiply(0.85);
						spd.x = 0;
						spd.y = 0;
					}

					if (turnX != E_Direction.NEUTRAL) {
						velocity.Y += Math.random() * 8 - 4;
						turnX = E_Direction.NEUTRAL;
					}
					if (turnY != E_Direction.NEUTRAL) {
						velocity.X += Math.random() * 8 - 4;
						turnY = E_Direction.NEUTRAL;
					}
				}
				else if (aiState==5) {
					spd.x*=0.95;
					spd.y*=0.95;
					velocity.multiply(0.90);
				}
				else if (aiState==4) {

				}
				else {
					if (flyR<20 && flyBox && mater) {	//сесть на предмет
						spd.x = 0;
						spd.y = 0;
						velocity.X = flyX - coordinates.X;
						velocity.Y = flyY - coordinates.Y;
						aiState = 0;
					}
					else if (flyR<100 && mater) {
						velocity.multiply(0.95);
						spd.x = 0;
						spd.y = 0;
					}
					else {
						spd.x = flyDX;
						spd.y = flyDY;
						norma(spd, Math.min(accel * 2, accel * flyR / 200));
					}
				}
				velocity.X += spd.x;
				velocity.Y += spd.y;
			}
			if (celUnit && celUnit.fraction==fraction) celUnit=null;
			//поиск цели
			if (aiState<=1 && aiTCh%30==1 && detectionDelay <= 0) {
				if (findCel() || GameContainer.reference.t_battle>0) {
					aiState=2;
				}
			}
			if ((aiState==2 || aiState==5) && aiTCh%15==1) {
				if (celUnit && !celUnit.disabled && celUnit.sost<3 && visCelUnit(celUnit)) {	//цель установлена и видна
					
				}
				else if (findCel()) {		//найти новую цель
				}
				else {					//успокоиться
					if (GameContainer.reference.t_battle<=0) aiState=1;
				}
			}
			else if (aiState==3) {
				//достиг точки назначения
				if (flyR<20) {
					if (GameContainer.reference.t_battle<=0) aiState=1;
					else aiState=2;
				}
			}
			if (aiState==2 && flyR<rasstWeap && currentWeapon==null && celUnit) {
				aiState=4;
				aiTCh=15;
				spd.x = celUnit.coordinates.X - coordinates.X;
				spd.y = celUnit.coordinates.Y - celUnit.boundingBox.halfHeight - coordinates.Y + this.boundingBox.halfHeight;
				norma(spd, runSpeed);
			}
			if (aiState==4) {
				if (celUnit) {
					if (attKorp(celUnit)) {
						spd.x *= 0.50;
						spd.y *= 0.50;
						aiState = 5;
						aiTCh = 15;
						damage(dam * 0.02, E_Resistances.DAM_INTERNAL);
					}
				}
				else aiState=2;
			}
			
			if (aiState <= 1) {
				maxSpeed = walkSpeed;
			}
			else {
				maxSpeed = runSpeed;
			}
	
			//атака
			if (aiState==2 && celUnit && !isPlav) {
				celX = celUnit.coordinates.X;
				celY = celUnit.coordinates.Y - celUnit.boundingBox.halfHeight;
				flyX = celUnit.coordinates.X;
				flyY = celUnit.coordinates.Y - 80;
				
				if (flyR <= rasstWeap && currentWeapon) {
					currentWeapon.attack();
				}
			}
		}
	}	
}
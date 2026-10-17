package fe.game.domain.units {
	
	import starling.display.BlendMode;

	import fe.engine.text.TextParser;
	import fe.engine.utils.Numbers;
	import fe.game.WeaponManager;
	import fe.game.domain.projectile.Bullet;
	import fe.game.enums.E_Material;
	import fe.game.enums.E_Direction;
	import fe.game.GameContainer;
	import fe.game.rendering.Flipbook;
	
	public class UnitDron extends Unit {
		
		private static const SPARKS:Object = {1: "drone_spark", 2: "drone_spark_orange", 3: "drone_spark_teal", 100: "drone_bolts"};	// Its spark's effect, by variant

		private var spd:Object;
		private var br:Number			= 0.00;
		private var stuk:int			= 0;

		public var tr:int				= 1;
		private var weap:String;
		private var atkDist:Number		= 250.00;
		private var aiAgr:Boolean		= false;
		private var floatX:Number		= 1.00;
		private var floatY:Number		= 0.00;
		private var t_float:Number		= Math.random();
		private var atkRasst:Number		= 0.00;
		
		private var t_krut:int			= 0;	// [dodging bullets]
		private var discharge:Flipbook;			// The spark it gives off at its target, over its body

		public function UnitDron(cid:String = null, ndif:Number = 100.00, xml:XML = null, loadObj:Object = null) {
			
			super(cid, ndif, xml, loadObj);
			
			// [from loadable object]
			if (loadObj && loadObj.tr) {			
				tr = loadObj.tr;
			}
			// [from map settings]
			else if (xml && xml.@tr.length()) {
				tr = xml.@tr;
			}
			// [from given cid]
			else if (cid) {
				tr = int(cid);
			}
			// [randomly by ndif parameter]
			else {
				tr = int(Math.random() * 2 + 1);
			}
			
			id = "dron" + tr;
			
			if (tr == 100) {
				id = "dront";
			}
			
			getXmlParam();
			initArt(id);	// The big drone's sheet draws its body half again as large, as Flash scaled it
			art.play("stay");
			discharge = GameContainer.reference.grafon.effects.createEffect(SPARKS[tr]);
			discharge.blendMode = BlendMode.SCREEN;
			discharge.visible = false;
			discharge.x = art.definition.hubX;		// At its middle, where its body turns
			discharge.y = art.definition.hubY;
			art.carry(discharge);
			walkSpeed = maxSpeed;
			runSpeed = maxSpeed * 3;
			isFly = true;
			mat = E_Material.METAL;
			acidDey = 1;
			elast = 0.60;
			spd = {};
			
			if (tr == 100) {
				aiAgr = true;
				nazv = "";
			}

			if (tr == 2) {
				aiAgr = true;
			}
			
			// [give weapons]
			if (tr == 100) {
				currentWeapon = WeaponManager.reference.cloneWeapon("ttweap" + int(Math.random() * 6 + 1), this);
			}
			else {
				currentWeapon = getXmlWeapon(ndif);
			}
			
			if (currentWeapon) {
				childObjs = new Array(currentWeapon);
				currentWeapon.magazineRounds = currentWeapon.magazineCapacity;
			}
			
			sndRunOn = true;
		}
		
		public override function save():Object {
			var obj:Object = super.save();
			
			if (obj == null) {
				obj = {};
			}

			obj.tr = tr;
			obj.weap = weap;

			return obj;
		}	

		public override function expl():void {
			newPart("metal", 4);
			newPart("miniexpl");
		}
		
		public override function forces():void {
			if (isFly) {
				if (t_throw <= 0 && velocity.X * velocity.X + velocity.Y * velocity.Y > maxSpeed * maxSpeed) {
					spd.x = velocity.X;
					spd.y = velocity.Y;
					norma(spd, maxSpeed);
					velocity.X = spd.x;
					velocity.Y = spd.y;
				}
				
				if (isPlav) {
					velocity.multiply(0.90);
				}
			}
			else {
				super.forces();
			}
		}
		
		public override function alarma(nx:Number=-1,ny:Number=-1):void {
			super.alarma(nx, ny);

			if (sost == 1) {
				aiState = 2;
				aiTCh = 3;
			}
		}
		
		public override function animate():void {
			br += (velocity.X * 1.5 - br) / 4;
			art.setBodyRotation(br * storona.X);
			
			// One of the first four frames of its spark, of those it has: the big drone's first bolt as it fades
			if (celUnit && aiTCh%15==1) {
				discharge.visible=true;
				discharge.alpha=1;
				discharge.rotation=Math.random()*Numbers.TWO_PI;
				discharge.goTo(Math.min(Math.floor(Math.random()*4), discharge.frameCount - 1), false);
			}
			
			if (discharge.alpha > 0.10) {
				discharge.alpha -= 0.20;
			}
			else {
				discharge.visible = false;
			}
		}
		
		public override function setWeaponPos(tip:String = "internal"):void {
			weaponX = coordinates.X;
			weaponY = coordinates.Y - this.boundingBox.halfHeight;
			if (tr >= 100) {
				weaponY += 40;
			}
		}
		//состояния
		//0 - летает
		//1 - видит цель, летит к ней
		//2 - потерял цель
		//3 - удаляется для новой атаки
		
		override protected function control():void {
			if (sost >= 3) {
				return;
			}
			
			if (GameContainer.reference.enemyAct <= 0) {
				return;
			}
			
			if (stun) {
				return;
			}
			
			if (t_krut > 0) {
				t_krut--;
			}
			
			if (aiTCh > 0) {
				aiTCh--;		//счётчик смены состояний
			}
			else {						//смена состояний
				if (aiSpok == 0) {	//перейти в пассивный режим
					aiState = 0;
				}
				else if (aiSpok >= maxSpok) {	//агрессивный
					aiState = 1;
				}
				else {
					aiState = 2;
				}
				
				aiTCh = Math.floor(Math.random() * 100) + 100;
				
				if (aiState == 0) {		//выбрать случайную цель в пассивном режиме
					celX = coordinates.X + (Math.random() * 300 + 400) * (isrnd() ? E_Direction.RIGHT.X : E_Direction.LEFT.X);
					celY = coordinates.Y - this.boundingBox.halfHeight;
				}
			}
			
			//поиск цели
			if (GameContainer.reference.enemyAct > 1 && aiTCh % 10 == 1) {
				if (findCel()) {
					stuk = 0;
					aiSpok = maxSpok + 10;
					
					if (aiState != 3) {
						aiState = 1;
					}
					
					storona = (celX > coordinates.X) ? E_Direction.RIGHT : E_Direction.LEFT;
				}
				else {
					if (aiSpok>0) {
						aiSpok--;
						
						if (aiSpok % 10 == 1) {
							setCel(null, celX + Math.random() * 80 - 40, celY + Math.random() * 80 - 40);
						}
					}
				}
				
				atkRasst = celDX * celDX + celDY * celDY;
				spd.x = celX - coordinates.X;
				spd.y = celY - (coordinates.Y - this.boundingBox.halfHeight);
				norma(spd, aiState == 0 ? accel * 0.50 : accel);
				
				if (aiState == 3) {
					velocity.X -= spd.x;
					velocity.Y -= spd.y;
				}
				else if (aiAgr || atkRasst < atkDist * atkDist || aiState == 2) {
					velocity.X += spd.x;
					velocity.Y += spd.y;
				}
				else {
					t_float += 0.97;
					floatX = Math.sin(t_float);
					floatY = Math.cos(t_float);
					velocity.X += floatX * accel;
					velocity.Y += floatY * accel;
				}
			}
			
			if (aiState == 0) {
				maxSpeed = walkSpeed;
			}
			else {
				maxSpeed = runSpeed;
			}
			
			if (tr == 1) {
				storona = (celX > coordinates.X) ? E_Direction.RIGHT : E_Direction.LEFT;
			}
	
			if (turnX != E_Direction.NEUTRAL) {
				stuk++;
				storona = turnX;
				turnX = E_Direction.NEUTRAL;

				if (aiState == 0) {
					celX = coordinates.X + 400 * storona.X;
				}
				
				if (stuk > 5) {
					setCel(null, celX + (Math.random() * 80 + 40) * storona.X, celY + Math.random() * 80 - 40);
				}
			}
			
			if (turnY != E_Direction.NEUTRAL) {
				if (turnY == E_Direction.UP) {
					velocity.Y = -6;
				}
				turnY = E_Direction.NEUTRAL;
			}
			//атака
			if (GameContainer.reference.enemyAct >= 3 && aiState == 1 && celUnit && shok <= 0) {
				critCh = 0;
				
				if (celUnit && (atkRasst>atkDist*atkDist)) {
					currentWeapon.attack();
				}
				
				if (attKorp(celUnit, 1)) {
					celY += 20;
					aiTCh = Math.floor(Math.random() * 20) + 20;
					aiState = 3;
				}
			}
		}
		
		public override function udarBullet(bul:Bullet, sposob:int = 0):int {
			if (t_krut > 0 || tr != 3
				|| (bul.targetObj == this)
				|| (bul.vel >= 1000)
				|| (bul.tipBullet == 1 && bul.weap && Math.random() < 6 / bul.weap.rapid)
				|| (bul.tipBullet == 0 && Math.random() < bul.vel / 300)
				) {
				return super.udarBullet(bul, sposob);
			}
			else {
				var p:Object={x:bul.velocity.Y, y:-bul.velocity.X};
				
				if (Math.random() < 0.50) {
					p.x = -p.x;
					p.y = -p.y;
				}
				
				norma(p, maxSpeed * 3);
				velocity.X += p.x;
				velocity.Y += p.y;
				
				if (GameContainer.reference.showHit == 1 || GameContainer.reference.showHit == 2 && t_hitPart == 0) {
					visDamDY -= 15;
					t_hitPart = 10;
					if (sost < 3 && isVis && !invulner && bul.flame == 0) numbEmit.cast(loc, coordinates.X, coordinates.Y - this.boundingBox.halfHeight + visDamDY, {txt:txtMiss, frame:10, rx:40, alpha:0.5});
				}
				
				t_krut = 45;
				
				return Bullet.MISS;
			}
		}
	}
	
}

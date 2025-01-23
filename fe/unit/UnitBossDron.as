package fe.unit {

	import flash.display.MovieClip;
	
	
	import fe.*;
	import fe.SymbolFactory;
	import fe.weapon.*;
	import fe.util.Vector2;
	import fe.graph.Emitter;
	
	public class UnitBossDron extends Unit {
		
		public var controlOn:Boolean		= true;
		public var kol_emit:int				= 5;
		private var spd:Object;
		private var dopWeapon:Weapon;
		private var thWeapon:Weapon;
		private var shitMaxHp:Number		= 500.00;
		private var visshit:MovieClip;
		
		private var emit_t:int				= 120;
		
		private var moveX:Number			= 0.00;
		private var moveY:Number			= 0.00;
		private var t_atk:int				= 100;
		private var t_shit:int				= 300;
		private var kolth:int				= 0;
		private var speedBonus:Number		= 1.00;

		// Constructor
		public function UnitBossDron(cid:String = null, ndif:Number = 100.00, xml:XML = null, loadObj:Object = null) {
			
			super(cid, ndif, xml, loadObj);
			id = "bossdron";
			
			// [take parameters from xml]
			vis = SymbolFactory.createInstance("visualMegaDron") as MovieClip;
			vis.osn.gotoAndStop(1);
			visshit = SymbolFactory.createInstance("visShit") as MovieClip;
			vis.addChild(visshit);
			visshit.gotoAndStop(1);
			visshit.visible = false;
			visshit.y = -70;
			visshit.scaleX = 1.70;
			visshit.scaleY = 1.70;
			
			getXmlParam();
			walkSpeed = maxSpeed;
			plavSpeed = maxSpeed;
			boss = true;
			isFly = true;
			aiTCh = 80;
			undodge = 1;
			
			shitArmor = 15;
			mater = false;
			collisionTip = 0;
			
			// [Give weapons]
			var clone:Function = WeaponManager.reference.cloneWeapon;
			currentWeapon = clone("dronmlau");
			thWeapon = clone("drongr");
			(thWeapon as WThrow).kolAmmo = 100000;
			childObjs = [currentWeapon, thWeapon];
			
			spd = new Object();
			
			timerDie = 150;
		}
		
		public override function dropLoot():void {
			newPart("baleblast");
			Snd.ps("bale_e");
			super.dropLoot();
		}
		
		public override function setLevel(nlevel:int=0):void {
			super.setLevel(nlevel);
			var wMult:Number = (1 + level * 0.07);
			var dMult:Number = 1;
			
			if (World.w.game.globalDif == 3) {
				dMult = 1.20;
			}
			else if (World.w.game.globalDif == 4) {
				dMult = 1.50;
			}
			
			hp = maxhp = hp * dMult;
			shitMaxHp *= (1 + level * 0.12) * dMult;
			dam *= dMult;
			
			if (thWeapon) {
				thWeapon.damageExpl *= wMult * dMult;
				thWeapon.damage *= wMult * dMult;
			}
		}
		
		public override function expl():void {
			newPart("metal", 22);
		}
		
		public override function setNull(f:Boolean=false):void {
			if (sost == 1 && dopWeapon) {
				dopWeapon.setNull();
			}
			
			super.setNull(f);
		}

		public override function animate():void {
			thWeapon.vis.visible = false;
			
			//щит
			if (visshit && !visshit.visible && shithp > 0) {
				visshit.visible = true;
				visshit.gotoAndPlay(1);
			}
			
			if (visshit && visshit.visible && shithp <= 0) {
				visshit.visible = false;
				visshit.gotoAndStop(1);
				Emitter.emit("pole", loc, coordinates.X, coordinates.Y - 50, {kol:12, rx:100, ry:100});
			}
			
			if (sost == 2) {
				if (isrnd(0.3 - timerDie / 500)) {
					Emitter.emit("expl", loc, coordinates.X+Math.random()*120-60, coordinates.Y-Math.random()*120);
					newPart("metal");
					Snd.ps("expl_e");
				}
			}
		}
		
		public override function setVisPos():void {
			if (vis) {
				if (sost == 2) {
					vis.x = coordinates.X + (Math.random() - 0.5) * (150 - timerDie) / 15;
					vis.y = coordinates.Y + (Math.random() - 0.5) * (150 - timerDie) / 15;
				}
				else {
					vis.x = coordinates.X;
					vis.y = coordinates.Y;
				}
			}
		}
		
		private function emit():void {
			if (kolChild >= kol_emit) {
				return;
			}
			
			var un:Unit = loc.createUnit("dron", coordinates.X, coordinates.Y - this.boundingBox.halfHeight, true);
			un.fraction = fraction;
			un.inter.cont = "";
			un.mother = this;
			un.sndMusic = null;
			un.detectionDelay = 0;
			kolChild++;
			emit_t = 500;
		}
		

		//aiState
		//0 - стоит на месте
		//1 - движется
		
		override protected function control():void {

			if (sost == 3) {
				return;
			}

			if (sost == 2) {
				velocity.set(0, 0);
				return;
			}
			
			if (loc.gg.invulner) {
				return;
			}

			if (World.w.enemyAct <= 0) {
				return;
			}
			if (t_shit > 0) {
				t_shit--;
			}
			
			if (loc.active) {
				aiState = 1;
			}
			else {
				aiState = 0;
			}
			
			aiTCh++;

			if (aiState == 1 && aiTCh % 10 == 1) {
				if (loc.gg.pet && loc.gg.pet.sost==1 && isrnd(0.2)) {
					setCel(loc.gg.pet);
				}
				else {
					setCel(loc.gg);
				}
			}

			if (World.w.gg.isFly) {
				speedBonus = 1.60;
			}
			else {
				speedBonus = 1.00;
			}

			celDX = celX - coordinates.X;
			celDY = celY - coordinates.Y;
			storona = (celDX > 0) ? 1 : -1;
			var dist2:Number = celDX * celDX + celDY * celDY;
			var dist:Number = (moveX - coordinates.X) * (moveX - coordinates.X) + (moveY - coordinates.Y) * (moveY - coordinates.Y);
			
			//поведение при различных состояниях
			if (aiState == 0) {
				walk = 0;
			}
			else if (aiState == 1) {
				moveX = loc.gg.coordinates.X;
				moveY = loc.gg.coordinates.Y;
				spd.x = moveX - coordinates.X;
				spd.y = moveY - coordinates.Y;
				norma(spd,Math.min(accel,accel*dist/1000));
				
				maxSpeed=walkSpeed*(2-(hp/maxhp))*(1-Math.sin(aiTCh/12)*0.3)*speedBonus;
				velocity.X += spd.x;
				velocity.Y += spd.y;
				spd.x = velocity.X;
				spd.y = velocity.Y;
				norma(spd,maxSpeed);
				velocity.X = spd.x;
				velocity.Y = spd.y;
				
				if (dist < 1000) {
					velocity.multiply(0.80);
				}
				
				attack();
				emit_t--;
				
				if (emit_t<=0) {
					emit();
				}
			}
		}
		
		private function castShit():void {
			if (shithp <= 0 && t_shit <= 0 && (World.w.game.globalDif == 4 || World.w.game.globalDif == 3 && hp < maxhp * 0.50)) {
				shithp = shitMaxHp;
				t_shit = 1000;
			}
		}
		
		public function attack():void {
			if (sost != 1) {
				return;
			}
			
			if (aiState == 1 && celUnit) {	//атака холодным оружием без левитации или корпусом
				attKorp(celUnit, 1);
			}
			
			t_atk--;
			
			if (t_atk <= 0) {
				t_atk = Math.floor(Math.random() * 60 + 40);
				
				if (isrnd()) {
					currentWeapon.attack();
				}
				else {
					kolth = 3;
				}
			}
			
			if (kolth > 0) {
				thWeapon.attack();
				
				if (thWeapon.is_shoot) {
					kolth--;
					thWeapon.is_shoot = false;
				}
			}
		}
		
		public override function command(com:String, val:String=null):void {
			if (com == "off") {
				walk = 0;
				controlOn = false;
			}
			else if (com == "on") {
				controlOn = true;
			}
		}
	}
}
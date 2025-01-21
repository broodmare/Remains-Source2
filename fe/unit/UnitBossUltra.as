package fe.unit {

	import flash.display.MovieClip;
	
	import fe.*;
	import fe.SymbolFactory;
	import fe.util.Vector2;
	import fe.weapon.*;
	import fe.loc.Location;
	import fe.graph.Emitter;
	
	public class UnitBossUltra extends Unit {
		
		private var weap:String;
		public var tr:int				= 1;
		public var scrAlarmOn:Boolean	= true;
		public var controlOn:Boolean	= true;
		public var kol_emit:int			= 3;
		public var called:Boolean		= false;
		private var spd:Object;
		
		// Weapons
		private var dopWeapon:Weapon;
		private var gasWeapon:Weapon;
		//		var	currentWeapon -- Defined in Unit
		private var currentWeapon2:Weapon;
		private var thWeapon:Weapon;
		
		private var visshit:MovieClip;
		private var shitMaxHp:Number	= 500.00;
		private var usil:Boolean		= false;

		private var emit_t:int			=   0;
		private var mp:int				=   3;
		private var moveX:Number		=   0.00;
		private var moveY:Number		=   0.00;
		private var attState:int		=   0;
		private var t_turn:int			=  15;
		private var t_shit:int			= 300

		private var movePoints:Array = [
			{x:10, y:7},
			{x:37, y:7},
			{x:24, y:13},
			{x:7, y:18},
			{x:40, y:18}
		];

		// Constructor
		public function UnitBossUltra(cid:String=null, ndif:Number=100, xml:XML=null, loadObj:Object=null) {
			
			super(cid, ndif, xml, loadObj);
			id = 'bossultra';
			tr = 1;
			
			// [Take parameters from xml]
			vis = SymbolFactory.createSymbol("visualUltraSentinel") as MovieClip;
			vis.osn.gotoAndStop(1);
			
			visshit = SymbolFactory.createSymbol("visShit") as MovieClip;
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
			shitArmor = 15;
			
			
			// [Give weapons]
			var clone:Function = WeaponManager.reference.cloneWeapon;
			
			// Weapon 1
			currentWeapon = clone("robogatp");
			
			// Weapon 2
			currentWeapon2 = clone("robogatp2");
			currentWeapon2.vis.visible = false;
			
			// Weapon 3
			dopWeapon = clone("robomlau2");
			
			// Weapon 4
			gasWeapon = clone("robogas");

			// Weapon 5
			thWeapon = clone("roboplagr");
			thWeapon.findCel = false;
			(thWeapon as WThrow).kolAmmo = 100000;
			
			childObjs = [currentWeapon, currentWeapon2, dopWeapon, gasWeapon, thWeapon];
			
			spd = new Object();
			aiNapr = storona;
			timerDie = 150;
		}
		
		public override function dropLoot():void {
			newPart('baleblast');
			Snd.ps('bale_e');
			currentWeapon.vis.visible = false;
			super.dropLoot();
		}
		
		public override function setLevel(nlevel:int = 0):void {
			super.setLevel(nlevel);
			
			var wMult:Number = (1 + level * 0.07);
			var dMult:Number = 1;
			
			if (World.w.game.globalDif == 3) {
				dMult = 1.2;
			}
			else if (World.w.game.globalDif == 4) {
				dMult = 1.5;
			}
			
			hp = maxhp = hp * dMult;
			shitMaxHp *= (1 + level * 0.12) * dMult;
			dam *= dMult;
			
			if (dopWeapon) {
				dopWeapon.damageExpl *= wMult * dMult;
				dopWeapon.damage *= wMult * dMult;
			}
			
			if (gasWeapon) {
				gasWeapon.damageExpl *= wMult * dMult;
				gasWeapon.damage *= wMult * dMult;
			}
			
			if (thWeapon) {
				thWeapon.damageExpl *= wMult * dMult;
				thWeapon.damage *= wMult * dMult;
			}
			
			if (currentWeapon) {
				currentWeapon.damage *= dMult;
				currentWeapon2.damage *= dMult;
			} 
		}
		
		public override function expl():void {
			newPart("metal", 22);
		}
		
		public override function putLoc(nloc:Location, nx:Number, ny:Number):void {
			super.putLoc(nloc,nx,ny);
			setCel(null,nx+200*storona, ny-50);
		}
		
		public override function setNull(f:Boolean=false):void {
			if (sost==1) {
				if (dopWeapon) {
					dopWeapon.setNull();
				}
			}
			
			super.setNull(f);
			
			aiState = 0;
			aiSpok = 0;
			
			if (hp > maxhp / 2) {
				usil = false;
				currentWeapon.vis.visible = true;
				currentWeapon2.vis.visible = false;
			}
		}

		public override function save():Object {
			var obj:Object = super.save();
			
			if (obj == null) {
				obj = new Object();
			}
			
			obj.tr = tr;
			obj.weap = weap;
			
			return obj;
		}	
		
		public override function animate():void {
			thWeapon.vis.visible = false;
			
			// [Shield]
			if (visshit && !visshit.visible && shithp > 0) {
				visshit.visible = true;
				visshit.gotoAndPlay(1);
			}
			
			if (visshit && visshit.visible && shithp <= 0) {
				visshit.visible = false;
				visshit.gotoAndStop(1);
				Emitter.emit('pole', loc, coordinates.X, coordinates.Y - 50, {kol:12, rx:100, ry:100});
			}
			
			if (sost == 2) {
				if (isrnd(0.3 - timerDie / 500)) {
					Emitter.emit('expl', loc, coordinates.X + Math.random() * 120 - 60, coordinates.Y - Math.random() * 120);
					newPart('metal');
					Snd.ps('expl_e');
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
				
				vis.scaleX = storona;
			}
		}
		
		public override function setWeaponPos(tip:String = "internal"):void {
			weaponX = vis.x;
			weaponY = vis.y - 110;
		}
		
		private function emit():void {
			var un:Unit = loc.createUnit('vortex', coordinates.X, coordinates.Y - this.boundingBox.halfHeight, true);
			un.fraction = fraction;
			un.detectionDelay = 0;
			emit_t = 500;
			kol_emit--;
		}

		//aiState
		//0 - [Stands still]
		//1 - [Moves]
		//2 - [Preparing to perform an action]
		//3 - [Performs an action]
		override protected function control():void {

			// [If you're dead, don't move]
			if (sost == 3) {
				return;
			}
			
			if (sost == 2) {
				velocity.set(0, 0);
				return;
			}
			
			t_replic--;
			var jmp:Number = 0;

			if (loc.gg.invulner) {
				return;
			}
			
			if (World.w.enemyAct <= 0) {
				celY = coordinates.Y - this.boundingBox.height;
				celX = coordinates.X + this.boundingBox.width * storona * 2;
				return;
			}
			
			if (t_shit > 0) {
				t_shit--;
			}

			vulnerabilities.setResist(Resistances.DAM_EMP, (shithp > 0) ? 0.20 : 1);	// [Considered invulnerable to emp]
			
			// [State change timer]
			if (aiTCh > 0) {
				aiTCh--;
			}
			else {
				aiState++;
				if (aiState>3) {
					if (attState==4) {
						aiState=2;
					}
					else {
						aiState=1;
					}
				}
				if (aiState == 1) {	//выбор точки перемещения
					var nmp:int = int(Math.random() * 5);
					
					if (nmp == mp) {
						nmp++;
					}
					
					if (nmp >= 5) {
						nmp = 0;
					}
					
					mp = nmp;
					moveX = movePoints[mp].x * 40 + 20;
					moveY = movePoints[mp].y * 40 + 40;
					aiTCh = 60;
					castShit();
				}
				else if (aiState == 2) {
					aiTCh = 30;
					
					if (attState != 4 && isrnd(0.33)) {
						attState = 4;
					}
					else {
						attState=int(Math.random()*2);
					}
					
					if (coordinates.Y < 17 * 40 && celY > 16 * 40 && isrnd(0.33)) {
						attState = 2;
						aiTCh = 5;
					}
					
					if (attState == 4) {
						aiTCh = 15;
					}
					
					if (attState == 0) {
						setCel(loc.gg);
					}
				}
				else if (aiState==3) {
					replic('attack');
					
					if (attState==0) {
						aiTCh=80;
					}
					else if (attState==2) {
						aiTCh=120;
					}
					else if (attState==4) {
						aiTCh=60;
					}
					else {
						aiTCh=int(Math.random()*100)+150;
					}
				}
			}
			
			//поиск цели
			if ((aiState == 1 || aiState > 1 && attState == 1) && aiTCh % 10 == 1) {
				setCel(loc.gg);
			}
			
			celDX = celX - coordinates.X;
			celDY = celY - coordinates.Y;
			
			var dist2:Number=celDX*celDX+celDY*celDY;
			var dist:Number = (moveX - coordinates.X) * (moveX - coordinates.X) + (moveY - coordinates.Y) * (moveY - coordinates.Y);
			
			//поведение при различных состояниях
			if (aiState==0) {
				if (velocity.X > 0.5) {
					storona = 1;
				}
			
				if (velocity.X < -0.50) {
					storona = -1;
				}
				
				walk=0;
			}
			else if (aiState == 1) {
				spd.x = moveX - coordinates.X;
				spd.y = moveY - coordinates.Y;
				norma(spd,Math.min(accel, accel * dist / 10000));
				velocity.X += spd.x;
				velocity.Y += spd.y;
				
				if (dist < 1000) {
					velocity.multiply(0.80);
				}
			}
			else if (aiState >= 2) {
				velocity.multiply(0.70);
			}
			
			if (aiState==2 && aiTCh%5==1) {
				if (attState == 0) {
					Emitter.emit('laser', loc, celX + Math.random()*100-50, celY-Math.random()*50);
				}
				if (attState == 1) {
					Emitter.emit('plasma', loc, celX + Math.random()*50-25, celY-Math.random()*20);
				}
				if (attState == 4) {
					Emitter.emit('spark', loc, celX + Math.random()*100-50, celY-Math.random()*50);
				}
			}
			
			if (aiState > 0 && !(aiState == 3 && attState == 2)) {
				aiNapr = (celX > coordinates.X) ? 1 : -1;
				
				if (storona == aiNapr) {
					t_turn = 15;
				}
				else {
					t_turn--;
					
					if (t_turn <= 0) {
						storona = aiNapr;
						t_turn = 15;
					}
				}
			}
			
			attack();
			
			if (!usil && hp < maxhp / 2) {
				usil = true;
				shithp = shitMaxHp * 4;
				t_shit = 2000;
				currentWeapon.vis.visible = false;
				currentWeapon2.vis.visible = true;
			}
		}
		
		private function castShit():void {
			if (shithp <= 0 && t_shit <= 0 && (World.w.game.globalDif == 4 || World.w.game.globalDif == 3 && hp < maxhp / 2)) {
				shithp = shitMaxHp;
				t_shit = 1000;
			}
		}
		
		public function attack():void {
			if (sost != 1) {
				return;
			}
			
			if (aiState==1 && celUnit) {	// [Attack with a melee weapon without levitation or with the body]
				attKorp(celUnit, 1);
			}
			else if (aiState == 3) {							// [Firing]
				if (attState == 0) {
					dopWeapon.attack();
				}
				else if (attState == 1) {
					if (usil) {
						currentWeapon2.attack();
					}
					else {
						currentWeapon.attack();
					}
				}
				else if (attState == 4) {
					gasWeapon.attack();
				}
				else {
					thWeapon.forceRot += 0.1;
					thWeapon.attack();
				}
				
				if (rasst2 < 10000 && isrnd(0.1)) {	//Changed to use rasst2 instead of dist2
					attKorp(celUnit, 0.5);
				}
			}
		}
		
		public override function command(com:String, val:String=null):void {
			if (com == 'off') {
				walk = 0;
				controlOn = false;
			}
			else if (com == 'on') {
				controlOn = true;
			}
		}
		
	}
}
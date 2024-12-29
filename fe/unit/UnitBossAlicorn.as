package fe.unit {

	import flash.filters.GlowFilter;
	import flash.display.MovieClip;
	
	import fe.*;
	import fe.util.Vector2;
	import fe.weapon.*;
	import fe.entities.Obj;
	import fe.serv.BlitAnim;
	import fe.serv.AnimationSet;
	import fe.graph.Emitter;
	import fe.loc.Box;
	import fe.loc.Tile;
	import fe.loc.Location;
	import fe.projectile.Bullet;
	
	public class UnitBossAlicorn extends UnitPon {
		
		public var wPos:Array;
		public var tr:int=1;
		var weap:String;
		public var scrAlarmOn:Boolean=true;
		public var controlOn:Boolean=true;
		public var kol_emit=3;
		var spd:Object;
		public var called:Boolean=false;
		var shitMaxHp:Number=400;
		var isShit:Boolean=true;
		var visshit:MovieClip;
		
		var isBlast:Boolean=false;
		
		var t_float:Number=0;
		var floatX:Number=1, floatY:Number=0;
		
		//телекинез
		var teleObj:Obj;
		var throwForce:Number=60;
		var teleX:Number=0, teleY:Number=0;
		var teleSpeed:Number=24;
		var teleAccel:Number=6;
		var derp:Number=15;
		var optDistTele:int=1000;	
		
		//невидимость
		var superInvis:Boolean=false;
		var curA:int=100, celA:int=100;
		
		var weaps:Array;

		// Constructor
		public function UnitBossAlicorn(cid:String=null, ndif:Number=100, xml:XML=null, loadObj:Object=null) {
			
			super(cid, ndif, xml, loadObj);
			id='bossalicorn';
			tr=1;
			
			getXmlParam();
			walkSpeed=maxSpeed;
			plavSpeed=maxSpeed;
			boss=true;
			aiTCh=80;
			
			shitArmor=15;
			
			initBlit();
			animState='stay';
			wPos = AnimationSet.getWeaponOffset("wPosAlicornBoss");
			visshit=new visShit3();
			vis.addChild(visshit);
			visshit.gotoAndStop(1);
			visshit.y=-50;
			visshit.scaleX=visshit.scaleY=1.5;
			
			//дать оружие
			weaps=[Weapon.create(this, 'alilight2'), Weapon.create(this,'aliblade'), Weapon.create(this,'alipsy2'), Weapon.create(this,'alimray')]
			currentWeapon=weaps[0];
			childObjs=weaps;
			
			spd=new Object();
			aiNapr=storona;
			teleFilter=new GlowFilter(0xFF0000,1,6,6,1,3);
			
			blood=0;
			bloodEmit=Emitter.arr['pole'];
			mat=1;
			this.knocked=0;
			timerDie=90;
		}
		
		public override function setLevel(nlevel:int=0):void {
			super.setLevel(nlevel);
			var wMult=(1+level*0.07);
			var dMult=1;
			if (World.w.game.globalDif==3) dMult=1.2;
			if (World.w.game.globalDif==4) dMult=1.5;
			hp=maxhp=hp*dMult;
			dam*=dMult;
			if (weaps[1]) {
				weaps[1].damage*=wMult*dMult;
			}
			if (currentWeapon) {
				currentWeapon.damage*=dMult;
			} 
		}
		
		public override function dropLoot():void {
			newPart('bloodblast');
			Snd.ps('bale_e');
			currentWeapon.vis.visible = false;
			super.dropLoot();
		}
		
		public override function setWeaponPos(tip:int=0):void {
			try {
				var obj:Object=wPos[anims[animState].id][int(anims[animState].f)];
				weaponX = magicX = coordinates.X + (obj.x+visBmp.x)*storona;
				weaponY = magicY = coordinates.Y + obj.y+visBmp.y;
				weaponR=obj.r;
			}
			catch (err) {
				super.setWeaponPos(tip);
			}
		}
		
		public override function expl():void {
			newPart('blood',100);
		}
		
		public override function putLoc(nloc:Location, nx:Number, ny:Number) {
			super.putLoc(nloc,nx,ny);
			setCel(null,nx+200*storona, ny-50);
		}
		
		public override function setNull(f:Boolean=false):void {
			if (!isNoResBoss()) isShit=true;
			super.setNull(f);
			if (teleObj) dropTeleObj();
			aiState=aiSpok=0;
		}

		public override function animate():void {
			try {
				var cframe:int;
				if (sost==2) { 
					animState='die';
					if (!isBlast) {
						newPart('bloodblast2');
						isBlast=true;
					}
				}
				else if (isFly) { 
					animState='fly';
				}
				else {
					if (stay && (velocity.X > 1 || velocity.X < -1)) {
						animState = 'walk';
						sndStep(anims[animState].f, 4);
					}
					else {
						animState = 'stay';
					}
				}
				if (animState!=animState2) {
					anims[animState].restart();
					animState2=animState;
				}
				if (!anims[animState].st) {
					blit(anims[animState].id,anims[animState].f);
				}
				anims[animState].step();
				//невидимость
				if (superInvis && World.w.pers.infravis==0) {
					celA=0;
				}
				else celA=100;
				if (curA>celA) curA-=5;
				if (curA<celA) curA+=5;
				vis.alpha=curA/100;
			}
			catch(err) {

			}
		}
		
		public override function setVisPos() {
			if (vis) {
				if (sost==2) {
					vis.x = coordinates.X+(Math.random()-0.5)*(150-timerDie)/15;
					vis.y = coordinates.Y+(Math.random()-0.5)*(150-timerDie)/15;
				}
				else {
					vis.x = coordinates.X;
					vis.y = coordinates.Y;
				}
				vis.scaleX=storona;
			}
		}
		
		private function emit(n:int=-1) {
			var un:Unit=loc.createUnit('scythe',Math.random()*1600+160,Math.random()*500+100,true);
			un.fraction=fraction;
			un.dam*=(1+level*0.1);
			un.detectionDelay = 0;
			if (n>=0) {
				un.bind=this;
				un.maxhp*=8;
				un.hp=un.maxhp;
				(un as UnitScythe).bindN=n;
			}
		}
		
		//телепортация
		public override function teleport(nx:Number,ny:Number,eff:int=0) {
			Emitter.emit('telered',loc, coordinates.X, coordinates.Y - this.boundingBox.halfHeight,{rx:this.boundingBox.width, ry:this.boundingBox.height, kol:30});
			setPos(nx,ny);
			velocity.set(0, 0);
			if (currentWeapon) {
				setWeaponPos(currentWeapon.tip);
				currentWeapon.setNull();
			}
			var t:Tile=loc.getAbsTile(coordinates.X, coordinates.Y + 10);
			if (t.phis || t.shelf) isFly=false;
			else isFly=true;
			levit=0;
			if (eff>0) Emitter.emit('teleport', loc, coordinates.X, coordinates.Y - this.boundingBox.halfHeight);
		}

		//проверка на попадание пули, наносится урон, если пуля попала, возвращает -1 если не попала
		public override function udarBullet(bul:Bullet, sposob:int=0):int {
			var res:int=super.udarBullet(bul, sposob);
			if (res>0) curA=100;
			return res;
		}

		var emit_t:int=0;
		
		var movePoints:Array=[{x:24,y:5}, {x:8,y:7}, {x:40,y:7}, {x:7,y:11}, {x:42,y:11}, {x:11,y:15}, {x:38,y:15}];
		var mp=3;
		var moveX:Number=0, moveY:Number=0;
		var attState:int=0;
		var t_turn:int=15;
		var t_shit:int=300;
		var t_fly:int=3;

		//aiState
		//0 - стоит на месте
		//1 - движется
		//2 - готовится выполнить действие
		//3 - выполняет действие
		
		override protected function control():void {
			//если сдох, то не двигаться
			if (sost==3) return;
			if (sost==2) {
				velocity.set(0, 0);
				return;
			}
			
			t_replic--;
			var jmp:Number=0;
			
			if (loc.gg.invulner) return;
			if (World.w.enemyAct<=0) {
				celY = coordinates.Y - this.boundingBox.height;
				celX = coordinates.X + this.boundingBox.width * storona * 2;
				return;
			}
			if (t_shit>0) t_shit--;
			if (!stay && !isFly) {
				t_fly--;
				if (t_fly<=0) isFly=true;
			} else t_fly=3;
			invis=superInvis;
			//таймер смены состояний
			if (aiTCh>0) aiTCh--;
			else {
				aiState++;
				if (aiState>3) aiState=1;
				if (aiState==1) {	//выбор точки перемещения
					attState = int(Math.random() * 5);
					var nmp  = int(Math.random() * 7);
					if (nmp==mp) nmp++;
					if (nmp>=7) nmp=0;
					mp=nmp;
					teleport(movePoints[mp].x*40+20, movePoints[mp].y*40+40, (attState==4)?0:1);
					aiTCh=30;
					if (World.w.game.globalDif==4 && isrnd(0.2) || World.w.game.globalDif==3 && isrnd(0.1))	attState=5;
					if (attState<=2) currentWeapon=weaps[attState]
					if (attState==4) {
						superInvis=true;
						isVis=false;
						curA=celA=0;
					} else {
						superInvis=false;
						isVis=true;
					}
					if (attState==5) currentWeapon=weaps[3];
				} else if (aiState==2) {
					aiTCh=30;
					if (attState==3) {
						aiTCh=45;
						if (!findBox()) aiTCh=15;
					}
					if (attState==4) aiTCh=20;
				} else if (aiState==3) {
					if (attState==3) {
						throwTele();
						aiTCh=30;
					} else if (attState==4) aiTCh=120;
					else if (attState==5) aiTCh=75;
					else aiTCh=int(Math.random()*100)+50;
				}
			}
			//поиск цели
			if ((aiState==1 || aiState>1 && attState<=2) && aiTCh%10==1 || attState==5 && aiState==3) {
				if (attState<2 && loc.gg.pet && loc.gg.pet.sost==1 && isrnd(0.2)) setCel(loc.gg.pet);
				else setCel(loc.gg);
			}
			if (isFly) {
				t_float += 0.0726;
				floatX = Math.sin(t_float) * 2;
				floatY = Math.cos(t_float) * 2;
				velocity.multiply(0.90);
				velocity.X += floatX;
				velocity.Y += floatY;
			}
			celDX = celX - coordinates.X;
			celDY = celY - coordinates.Y;
			var dist2:Number = celDX * celDX + celDY * celDY;
			var dist:Number = (moveX - coordinates.X) * (moveX - coordinates.X) + (moveY - coordinates.Y) * (moveY - coordinates.Y);
			//поведение при различных состояниях
			if (aiState == 0) {
				if (velocity.X > 0.5) storona = 1; 
				if (velocity.X < -0.5) storona = -1;
				walk=0;
			}
			if (aiState>0) {
				aiNapr=(celX > coordinates.X)?1:-1;
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
			

			if (teleObj) {
				if (teleObj is Unit) {
					teleX = coordinates.X + storona * 150;
					teleY = coordinates.Y - 40;
				}
				else {
					teleX = coordinates.X + storona * 80;
					teleY = coordinates.Y - 40;
				} 				
				if (teleObj.coordinates.X < teleX - derp && teleObj.velocity.X < teleSpeed) teleObj.velocity.X += teleAccel;
				if (teleObj.coordinates.X > teleX + derp && teleObj.velocity.X > -teleSpeed) teleObj.velocity.X -= teleAccel;
				if (teleObj.coordinates.Y < teleY - derp && teleObj.velocity.Y < teleSpeed) teleObj.velocity.Y += teleAccel;
				if (teleObj.coordinates.Y > teleY + derp && teleObj.velocity.Y > -teleSpeed) teleObj.velocity.Y -= teleAccel;
				if (teleObj.levit == 1) {
					dropTeleObj();
				}
			}
		}
		
		public function attack() {
			if (sost!=1) return;
			if (aiState==3) {							//пальба
				if (attState<=2 || attState==5) currentWeapon.attack();
				if (attState==4 && aiTCh%30==1) emit();
				if (attState!=4 && (rasst2 < 100 * 100) && isrnd(0.1)) attKorp(celUnit,0.5); //Changed to use rasst2 instead of dist2
			}
		}
		
		//найти подходящий для телекинеза ящик и поднять его
		private function findBox():Obj {
			if (celUnit && isrnd(0.5)) {
				upTeleObj(celUnit);
				if (teleObj is UnitPlayer) {
					(teleObj as UnitPlayer).levitFilter2=teleFilter;
					(teleObj as UnitPlayer).isLaz=0;
				}
				return teleObj;
			}
			for each (var b:Box in loc.objs) {
				if (b.levitPoss && b.wall==0 && b.levit==0 && b.massa>=1 && isrnd(0.3)) {
					if (getRasst2(b)>optDistTele*optDistTele) continue;
					if (loc.isLine(coordinates.X, this.boundingBox.top, b.coordinates.X, b.boundingBox.top)) {
						upTeleObj(b);
						return b;
					}
				}
			}
			return null;
		}
		//подянть объект телекинезом
		private function upTeleObj(obj:Obj) {
			if (obj==null) return;
			teleObj=obj;
			if (!(teleObj is UnitPlayer) && teleObj.vis) {
				teleObj.vis.filters=[teleFilter];
			}
			teleObj.fracLevit=fraction;
			if (teleObj is UnitPlayer) teleObj.levit=World.w.pers.teleEnemy;
			else teleObj.levit=2;
		}
		
		//уронить левитируемый объект
		public function dropTeleObj() {
			if (teleObj) {
				if (!(teleObj is UnitPlayer) && teleObj.vis) {
					teleObj.vis.filters=[];
				}
				teleObj.levit=0;
				teleObj=null;
			}
		}
		
		//бросок телекинезом
		private function throwTele() {
			if (teleObj) {
				var p:Object;
				var tspeed:Number=throwForce;
				
				if (teleObj.massa>1) tspeed=throwForce/Math.sqrt(teleObj.massa);
				
				if (teleObj.coordinates.X<200 || teleObj.coordinates.X>loc.maxX-200) tspeed*=0.6;
				
				if (teleObj is Unit) {
					p={x:100*storona, y:-30};
				}
				else {
					p={x:(celX-teleObj.coordinates.X), y:(celY-(teleObj.coordinates.Y - teleObj.boundingBox.halfHeight)-Math.abs(celX-teleObj.coordinates.X)/4)};
				}
				
				if (teleObj is UnitPlayer) {
					(teleObj as UnitPlayer).damWall=dam/2;
					(teleObj as UnitPlayer).t_throw=30;
				}
				
				if (teleObj is Box) (teleObj as Box).isThrow=true;
				
				norma(p,tspeed);
				var dm = 0;
				teleObj.velocity.X += p.x;
				teleObj.velocity.Y += p.y;
				dropTeleObj();
			}
			
		}
		
		public override function die(sposob:int=0):void {
			superInvis=false;
			dropTeleObj();
			isBlast=false;
			
			if (isShit) {
				isShit=false;
				visshit.gotoAndPlay(2);
				hp=maxhp-0.1;
				aiState=0;
				aiTCh=10;
				blood=1;
				bloodEmit=Emitter.arr['blood'];
				bloodEmit.cast(loc, coordinates.X, coordinates.Y-50,{kol:100, rx:this.boundingBox.halfWidth, ry:this.boundingBox.halfHeight});
				visDetails();
				sost=1;
				mat=0;
				timerDie=90;
				for (var i = 0; i < 6; i++) {
					emit(i);
				}
			}
			else {
				super.die();
			}
		}
		
		public override function command(com:String, val:String=null) {
			if (com=='off') {
				walk=0;
				controlOn=false;
			}
			else if (com=='on') {
				controlOn=true;
			}
		}
	}
}
package fe.unit {

	import flash.filters.GlowFilter;
	import flash.display.MovieClip;
	
	import fe.*;
	import fe.entities.Obj;
	import fe.serv.AnimationSet;
	import fe.loc.Tile;
	import fe.loc.Location;
	import fe.graph.Emitter;
	import fe.weapon.Weapon;
	import fe.projectile.Bullet;
	import fe.loc.Box;
	
	public class UnitAlicorn extends UnitPon {

		public var tr:int=0;
		
		protected var animFrame:int=0;
		private var spd:Object;
		public var wPos:Array;
		private var floatX:Number=1, floatY:Number=0;
		private var resmana=5;
		private var visshit:MovieClip;
		private var shitMaxHp:Number=300;

		//суперсила
		private var superSilaTip:int=1;	//1-невидимость, 2-телепортация, 3-телепатия
		private var tGotov:int=90, tUsed:int=-500;	//сколько нужно для готовности, сколько будет после готовности
		private var tSuper:int=300;	//продолжительность
		private var tNomater:int=-200;	//отброс готовности при дематриализации
		private var psyWeapon:Weapon;
		
		//невидимость
		private var superInvis:Boolean=false;
		private var curA:int=100, celA:int=100;
		
		//телекинез
		private var teleObj:Obj;
		private var tTeleThrow:int=60;
		private var tTeleRes:int=600;
		private var throwForce:Number=30;
		private var teleX:Number=0, teleY:Number=0;
		private var teleSpeed:Number=16;
		private var teleAccel:Number=4;
		private var derp:Number=15;
		
		private var tlColor:uint=0x3366FF;
		private var nmColor:uint=0x253B8E;
		private var nomaterFilter:GlowFilter;
		
		private var blasted:Boolean=false;
		private var osob:Boolean=false;
		private var mblast:Spell;
		
		public var stroll:Boolean=true;		//патрулирует в спокойном состоянии
		public var moving:Boolean=true;		//двигается
		public var quiet:Boolean=false;		//молчит
		public var pole:Boolean=false;		//не двигается, не реагирует ни на что
		public var poleId:String='';
		private var t_pole:int=0;

		private static var tileX:int = Tile.tileX;
		private static var tileY:int = Tile.tileY;

		// Constructor
		public function UnitAlicorn(cid:String=null, ndif:Number=100, xml:XML=null, loadObj:Object=null) {
			
			super(cid, ndif, xml, loadObj);
			
			//определить разновидность tr
			if (loadObj && loadObj.tr) {			//из загружаемого объекта
				tr=loadObj.tr;
			}
			else if (xml && xml.@tr.length()) {	//из настроек карты
				tr=xml.@tr;
			}
			else if (cid) {						//из заданного идентификатора cid
				tr=int(cid);
			}
			else {								//случайно по параметру ndif
				tr=Math.floor(Math.random()*7);
			}
			
			if (!(tr>=0)) tr=Math.floor(Math.random()*3+1);
			
			id='alicorn'+tr;
			getXmlParam();
			
			currentWeapon=Weapon.create(this,'alilight');
			
			if (currentWeapon) {
				childObjs=new Array(currentWeapon);
				currentWeapon.fromWall=true;
			}
			
			shitArmor=25;
			
			if (tr==1) {//синий
				osob=(Math.random()<0.7);
			}
			
			if (tr==2) {//фиолетовый
				superSilaTip=2;
				throwForce=45;
				teleSpeed=20;
				teleAccel=5;
				tTeleRes=400;
				tUsed=-250;
				tlColor=0xBB33FF;
				nmColor=0x550088;
				osob=(Math.random()<0.5);
			}
			
			if (tr==3) {//зелёный
				superSilaTip=3;
				shitArmor=50;
				shitMaxHp=500;
				psyWeapon=Weapon.create(this,'alipsy');
				childObjs.push(psyWeapon);
				tlColor=0x00FF55;
				nmColor=0x009900;
				t_shit=45;
				osob=(Math.random()<0.4);
			}
			
			if (World.w.game.globalDif==4) osob=true;
			
			mana=maxmana=2000;
			dmana=5;
			walkSpeed=maxSpeed;

			initBlit();
			animState='stay';
			wPos = AnimationSet.getWeaponOffset("wPosAlicorn");
			
			if (tr==3) visshit = new visShit2();	// SWF Dependency
			else visshit = new visShit();			// SWF Dependency
			
			vis.addChild(visshit);
			visshit.gotoAndStop(1);
			visshit.visible=false;
			visshit.y=-50;
			visshit.scaleX=visshit.scaleY=1.5;
			
			spd=new Object();
			aiNapr=storona;
			
			if (aiTip=='stay') stroll=false;
			
			if (aiTip=='quiet') {
				stroll=false;
				quiet=true;
			}
			
			if (xml && xml.@pole.length()) {
				poleId=xml.@pole;
				pole=true;
			}
			
			if (aiTip=='pole') {
				pole=true;
			}
			
			sit(true);
			nomaterFilter=new GlowFilter(nmColor,1,15,5,2,3,true,true);
			teleFilter=new GlowFilter(tlColor,1,6,6,1,3);
			spellPower=2;
			mblast=new Spell(this,'sp_blast');
		}
		
		public override function getXmlParam(mid:String=null):void {
			super.getXmlParam('alicorn');
			super.getXmlParam();
		}
		
		public override function setWeaponPos(tip:int=0):void {
			var obj:Object=wPos[anims[animState].id][int(anims[animState].f)];
			weaponX = magicX = coordinates.X + (obj.x+visBmp.x)*storona;
			weaponY = magicY = coordinates.Y + obj.y+visBmp.y;
			weaponR=obj.r;
		}
		
		public override function setLevel(nlevel:int=0):void {
			super.setLevel(nlevel);
			currentWeapon.damage*=(1+level*0.05);
			shitMaxHp*=(1+level*0.1);
		}
		
		public override function putLoc(nloc:Location, nx:Number, ny:Number) {
			super.putLoc(nloc,nx,ny);
			unsit();
		}
		
		public override function save():Object {
			var obj:Object=super.save();
			if (obj==null) obj=new Object();
			obj.tr=tr;
			return obj;
		}	
		
		public override function animate():void {
			if (sost==2 || sost==3) { //сдох
				if (stay) {
					if (animState=='fall') {
					}
					else if (animState=='death') animState='fall';
					else animState='die';
				}
				else animState='death';
			}
			else {
				if (isFly) {
					animState='fly';
				}
				else if (isSit) {
					if (stay && (velocity.X > 1 || velocity.X < -1)) {
						animState='polz';
						sndStep(anims[animState].f,4);
					}
					else {
						animState='sit';
					}
				}
				else {
					if (stay && (velocity.X > 1 || velocity.X < -1)) {
						animState='walk';
						sndStep(anims[animState].f,4);
					}
					else {
						animState='stay';
					}
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
			
			//щит
			if (visshit && !visshit.visible && shithp>0) {
				visshit.visible=true;
				visshit.gotoAndPlay(1);
			}
			
			if (visshit && visshit.visible && shithp<=0) {
				visshit.visible=false;
				visshit.gotoAndStop(1);
				Emitter.emit('pole', loc, coordinates.X, coordinates.Y-50,{kol:12,rx:100, ry:100});
			}
			
			//невидимость
			if (superInvis && World.w.pers.infravis==0) {
				if (isShoot) {
					curA=50;
					isShoot=false;
				}
				
				if (velocity.X > 2 || velocity.X < -2 || velocity.Y > 2 || velocity.Y < -2) {
					celA = 5;
				}
				else {
					celA = 0;
				}
			}
			else {
				celA = 100;
			}
			
			if (curA>celA) curA-=5;
			
			if (curA<celA) curA+=5;
			
			vis.alpha=curA/100;
			
			if (hpbar) hpbar.alpha=vis.alpha;
			
			if (!mater && visBmp.filters.length==0) visBmp.filters=[nomaterFilter];
			
			if (mater && visBmp.filters.length>0) visBmp.filters=[];
		}
		
		public override function budilo(rad:Number=500) {
			if (celUnit==null) {
				celX = coordinates.X;
				celY = coordinates.Y;
			}
			for each(var un:Unit in loc.units) {
				if (un!=this && un.fraction==fraction && un.sost==1 && !un.unres) {
					un.alarma(celX,celY);
				}
			}
		}
		
		public function telepat():void {
			for each(var un:Unit in loc.units) {
				if (un!=this && un.fraction==fraction && un.sost==1 && !un.unres && un.celUnit==null) {
					un.setCel(celUnit);
				}
			}
		}
		
		public override function damage(dam:Number, tip:int, bul:Bullet=null, tt:Boolean=false):Number {
			if (tr==1 && osob && !blasted && bul && bul.weap && bul.weap.tip==1 && aiState<=1) {
				mblast.cast(coordinates.X, coordinates.Y);
				blasted=true;
			}
			if (tr==2 && osob && !blasted && bul && bul.weap && bul.weap.owner && bul.weap.owner.player && aiState<=1) {
				actPort(true);
				blasted=true;
				return 0;
			}
			return super.damage(dam,tip,bul,tt);
		}
		
		public override function alarma(nx:Number=-1,ny:Number=-1):void {
			if (sost==1 && aiState<=1) {
				super.alarma(nx,ny);
				aiState=3;
				if (loc.land.aliAlarm) maxSpok=75;
				else maxSpok=30;
				aiSpok=maxSpok+10;
				aiState=3;
				overLook=true;
				shok=Math.floor(Math.random()*15+5);
			}
		}
		
		public override function die(sposob:int=0):void {
			superSilaVse();
			dropTeleObj();
			budilo();
			blasted=true;
			if (pole) {
				loc.allAct(this,'unlock',poleId);
				loc.allAct(this,'open',poleId);
				pole=false;
			}
			visBmp.filters=[];
			loc.land.aliAlarm=true;
			this.boundingBox.crouchingHeight = 30;
			super.die(sposob);
		}
		
		public override function setNull(f:Boolean=false):void {
			super.setNull(f);
			if (f) aiState=aiSpok=0;
			if (teleObj) dropTeleObj();
			blasted=false;
		}
		
		public function jump(v:Number=1):void {
			if (!isFly) {
				velocity.Y =- jumpdy * v;
			}
			isFly = true;
		}

		private var optDistAtt:int = 200;
		private var optDistTele:int = 600;
		private var stalkDist:int = 500;
		private var aiAttackT:int = 0;
		private var t_landing:int = 0;
		private var t_float:Number = Math.random();
		private var t_fall:int = 0;
		private var t_nomater:int = 0;
		private var t_shit:int = 90;
		private var t_gotov:int = 0;
		private var t_super:int = 0;
		private var t_tele:int = -100;
		private var t_alarm:int = Math.round(Math.random() * 600 + 1500);
		
		//aiState
		//0 - стоит на месте
		//1 - ходит туда-сюда
		//2 - не видит цели, летает и ищет цель
		//3 - видит цель, летает, атакует
		//4 - приземляется
		
		override protected function control():void {
			//если сдох, то не двигаться
			var t:Tile;
			if (sost==3) {
				try {
					if (!mater && !collisionAll()) {
						mater=true;
						visBmp.filters=[];
					}
				}
				catch(err) {
					trace('ERROR: (00:6)');
				}
				return;
			}
			if (levit && stun==0) {
				if (aiState<=1) {
					aiState=3;
					budilo();
				}
			}
			if (stun) {
				aiState=0; aiTCh=3; walk=0;
			}
			if (t_super>0) {
				t_super--;
				if (t_super<=0) superSilaVse();
			}
			if (pole) {
				t_pole++;
				if (t_pole>=5) {
					t_pole=0;
					Emitter.emit('unlock', loc, magicX, magicY,{rx:20, ry:20});
				}
				if (hp<maxhp*0.7) {
					loc.allAct(this,'unlock',poleId);
					loc.allAct(this,'open',poleId);
					pole=false;
				} else return;
			}

			var jmp:Number=0;
			invis=superInvis;
			if (World.w.pers.infravis==0) dexter=2-curA/100;
			else dexter=1;
			if (mana<maxmana) mana+=resmana;
			if (World.w.enemyAct<=0) return;
			if (aiSpok>0 || tr==3 && osob || t_shit>150) t_shit--;
			if (shithp<=0 && t_shit<=0) castShit();
			if (aiState==2 && t_alarm>=0) {
				t_alarm--;
				if (t_alarm==0) loc.enemySpawn(false,false,'alicorn');
			}
			if (tr==3) allVulnerMult=(shithp>0)?0.4:1;	//под считом урон от атак режется вдвое
			else allVulnerMult=(shithp>0)?0.6:1;	//под считом урон от атак режется вдвое
			//таймер смены состояний
			if (aiTCh>0) aiTCh--;
			else {
				if (aiSpok==0) {
					if (isFly && aiState!=4) {
						setCel(null, coordinates.X+Math.random()*200-100, coordinates.Y+1000);
						aiState=4;
						aiVNapr=1;
					}
					else if (stroll)	aiState=Math.floor(Math.random()*2);
					else aiState=0;

					if (isPlav && aiState==0) aiState=1;
					if (aiState==0 && superSilaTip==1 && isrnd() && stroll) superSila();	//включить невидимость в спокойном состоянии
					storona=aiNapr;
				}
				if (aiSpok>0) aiState=2;
				if (aiSpok>=maxSpok) {
					if (aiState!=3) budilo();
					aiState=3;
				}
				if (aiState<=1) aiTCh=Math.floor(Math.random()*50)+40;
				else aiTCh=Math.floor(Math.random()*100)+100;
			}
			if (World.w.enemyAct>1 && aiTCh%10==1) {
				//установить точку зрения
				var obj:Object=wPos[anims[animState].id][Math.floor(anims[animState].f)];
				eyeX = coordinates.X + (obj.x+visBmp.x)*storona;
				eyeY = coordinates.Y + obj.y+visBmp.y;
				if (loc.getAbsTile(eyeX,eyeY).phis) {
					eyeY+=20;
				}
				//отклонения в полёте
				if (isFly) {
					t_float+=0.212;
					floatX=Math.sin(t_float)*2;
					floatY=Math.cos(t_float)*2;
				}
				//встать
				if (isSit) unsit();
				//материализоваться
				if (!mater && !collisionAll()) mater=true;
				//поиск цели
				if (findCel()) {
					//увидели
					if (celUnit) {
						if (aiTCh%30==1) telepat();
						aiSpok=maxSpok+10;
					//услышали
					} else {
						aiSpok=maxSpok-1;
					}
				} else {
					if (aiTCh%50==1 && (aiState==2 || aiState==3)) setCel(null, celX+Math.random()*320-160, celY+Math.random()*160-80);
					if (aiSpok>0) {
						aiSpok--;
					}
				}
			}
			//направление
			celDX = celX - coordinates.X;
			celDY = celY - coordinates.Y + this.boundingBox.height;
			if (celDY>40) aiVNapr=1;		//вниз
			else if(celDY<-40) aiVNapr=-1;	//прыжок
			else aiVNapr=0;
			porog=10;
			if (celDY>70) porog=0;

			//в возбуждённом состоянии наблюдательность увеличивается
			if (aiSpok==0) {
				vision=0.7;
				if (loc && loc.land.aliAlarm) vision=1.5;
				celY = coordinates.Y - this.boundingBox.height;
				celX = coordinates.X + this.boundingBox.width * storona * 2;
			}
			else {
				t_gotov++;
				if (t_gotov>tGotov) superSila();
				vision=2;
			}
			
			//скорость
			maxSpeed=walkSpeed;
			
			//движение
			//пешком
			if (stay) {
				if (aiState>0) {
					if (aiNapr==-1) {
						walk=-1;
						if (velocity.X > -maxSpeed) {
							velocity.X -= accel;
						}
					}
					else if (aiNapr==1) {
						walk=1;
						if (velocity.X < maxSpeed) {
							velocity.X += accel;
						}
					}
					//пригнуться
					if (turnX==-1) {
						if (loc.getAbsTile(this.boundingBox.right + 2, this.boundingBox.top).phis && loc.getAbsTile(this.boundingBox.right + 2, this.boundingBox.top + 40).phis==0 && loc.getAbsTile(this.boundingBox.right + 2,this.boundingBox.top + 80).phis==0) {
							sit(true);
							turnX=0;
						}
					}
					if (turnX==1) {
						if (loc.getAbsTile(this.boundingBox.left - 2, this.boundingBox.top).phis && loc.getAbsTile(this.boundingBox.left - 2,this.boundingBox.top + 40).phis==0 && loc.getAbsTile(this.boundingBox.left - 2,this.boundingBox.top + 80).phis==0) {
							sit(true);
							turnX=0;
						}
					}
				}
				else {
					walk=0;
				}
				t_fall=0;
			//полёт
			}
			else if (isFly) {
				if (celUnit && rasst2 < stalkDist * stalkDist && mater) {
					velocity.multiply(0.85);
					velocity.X += floatX;
					velocity.Y += floatY;
				}
				else {
					spd.x = celX - coordinates.X;
					
					if (aiState==4) spd.y=200;
					else spd.y = celY - this.boundingBox.top;
					
					//дематериализоваться
					if (aiSpok>10 && celUnit==null && (turnX!=0 || turnY!=0)) {
						t_nomater++;
						if (t_nomater>=30 && mater && t_gotov>=0) {
							castNomater();
						}
					}
					else {
						if (turnX!=0) spd.x=0;
						if (turnY!=0) spd.y=0;
						t_nomater=0;
					}
					
					norma(spd,aiState<=1?accel/2:Math.min(accel,accel*(celDX*celDX+celDY*celDY)/10000));
					velocity.X += spd.x + floatX;
					velocity.Y += spd.y + floatY;
				}
				
				//приземлиться
				if (turnY<0) {
					if (aiState!=4) {
						t_landing++;
					}
					else if (aiState==4 || t_landing>20) {
						t_landing=0;
						isFly=false;
						if (aiState==4) aiState=1;
						turnY=0;
					}
				}
				turnX=turnY=t_fall=0;
			}
			else if (levit) {
				if (aiNapr==-1) {
					if (velocity.X > -maxSpeed) velocity.X -= levitaccel;
				}
				else if (aiNapr==1) {
					if (velocity.X < maxSpeed) velocity.X += levitaccel;
				}
			}
			else {
				t_fall++;
				if (t_fall>6) isFly=true;
			}
			
			//поведение при различных состояниях
			if (aiState==0) {
				overLook=false;
				if (stay && shX1>0.5 && aiNapr<0) turnX=1;
				if (stay && shX2>0.5 && aiNapr>0) turnX=-1;
			}
			else if (aiState==1) {
				//поворачиваем, если впереди некуда бежать
				overLook=false;
				if (stay && shX1>0.25 && aiNapr<0) {
					if (aiState==1 && isrnd(0.1)) {
						t=loc.getAbsTile(coordinates.X+storona*80,coordinates.Y+10);
						if (t.phis==1 || t.shelf) {
							jump(0.5);
						}
						else turnX=1;
					}
					else turnX=1;
				}
				if (stay && shX2>0.25 && aiNapr>0) {
					if (aiState==1 && isrnd(0.1)) {
						t=loc.getAbsTile(coordinates.X+storona*80,coordinates.Y+10);
						if (t.phis==1 || t.shelf) {
							jump(0.5);
						}
						else turnX=-1;
					}
					else turnX=-1;
				}
				
				if (stay && turnX!=0) {
					aiNapr=storona=turnX;
					turnX=0;
				}
				
				if (isPlav) {
					isFly=true;
				}
				//в возбуждённом или атакующем состоянии
			}
			else if (aiState==2 || aiState==3) {
				//определить, куда двигаться
				overLook=true;
				if (aiVNapr<0) jmp=1;		//взлететь
				if (aiTCh%15==1) {
					if (isrnd(0.8)) {
						if (celDX>100) aiNapr=storona=1;
						if (celDX<-100) aiNapr=storona=-1;
					}
				}
				if (celDY>80) throu=true;
				else throu=false;
				if (turnX!=0) {
					if (isFly) {
						if (aiState!=3) setCel(null, celX+turnX*(Math.random()*200+200), celY+Math.random()*120-60);
						turnX=0;
					}
					else {
						aiTTurn--;
						if (isrnd(0.03) || turnY>0) aiTTurn-=10;
						else if (isrnd(0.5)) jmp=1;
						else aiTTurn-=10;
						if (aiTTurn<0) {
							aiNapr=storona=turnX;
							aiTTurn=Math.floor(Math.random()*20)+5;
						}
						turnX=0;
					}
				}
				if (jmp>0) {
					if (isPlav) jmp*=1.5;
					jump(jmp);
					jmp=0;
				}
			}

			pumpObj=null;
			
			if (coordinates.Y>loc.spaceY*tileY-80) throu=false;
			
			if (celUnit && t_shit<900 && aiTCh%5==1 && isrnd(0.25) && aiAttackT<=-15 && currentWeapon.t_attack<=0) aiAttackT=16;
			
			if (aiAttackT>-15) {
				aiAttackT--;
				if (aiAttackT>0) currentWeapon.attack();
			}
			
			//телекинез
			t_tele++;
			if (t_tele==0) {
				if (aiState<=1 || findBox()==null) t_tele = -int(Math.random()*100+50);
			}
			if (t_tele>=tTeleThrow+10) t_tele = -int(Math.random()*100+50);
			if (teleObj) {
				if (teleObj is Unit) {
					teleX = coordinates.X + storona * 150;
					teleY = coordinates.Y - 40;
				} else {
					teleX = coordinates.X + storona * 80;
					teleY = coordinates.Y - 40;
				} 
				if (teleObj.coordinates.X < teleX - derp && teleObj.velocity.X < teleSpeed) teleObj.velocity.X += teleAccel;
				if (teleObj.coordinates.X > teleX + derp && teleObj.velocity.X > -teleSpeed) teleObj.velocity.X -= teleAccel;
				if (teleObj.coordinates.Y < teleY - derp && teleObj.velocity.Y < teleSpeed) teleObj.velocity.Y += teleAccel;
				if (teleObj.coordinates.Y > teleY + derp && teleObj.velocity.Y > -teleSpeed) teleObj.velocity.Y -= teleAccel;
				if (t_tele>=tTeleThrow) {
					if (celUnit) {
						throwTele();
						t_tele=-tTeleRes;
					}
					else {
						dropTeleObj();
						t_tele=-tTeleRes/2;
					}
				}
				if (teleObj && teleObj.levit==1) {
					dropTeleObj();
					t_tele=-tTeleRes;
				}
			}
		}
		
		private function castShit():void {
			curA=100;
			shithp=shitMaxHp;
			t_shit=1000;
			visDetails();
		}
		
		private function castNomater():void {
			mater=false;
			t_nomater=0;
			t_gotov=tNomater;
		}
		
		private function superSila():void {
			if (superSilaTip == 1) {
				superInvis = true;
				isVis = false;
			}
			else if (superSilaTip == 2) {
				if (aiState == 2) actPort();
				else if (aiState == 3 && (rasst2 < 40000 || isrnd())) actPort();
			}
			else if (superSilaTip == 3) {
				if (psyWeapon) psyWeapon.attack();
			}
			
			t_gotov = Math.floor(tUsed * (Math.random() * 0.4 + 0.8));
			t_super = tSuper;
		}
		
		private function superSilaVse():void {
			if (superSilaTip==1) {
				superInvis=false;
				isVis=true;
			}
		}
		
		//найти подходящий для телекинеза ящик и поднять его
		private function findBox():Obj {
			if (celUnit && isrnd(0.25)) {
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
					if (loc.isLine(coordinates.X, this.boundingBox.top, b.coordinates.X, b.boundingBox.top))
					{
						upTeleObj(b);
						return b;
					}
				}
			}
			return null;
		}
		
		//подянть объект телекинезом
		private function upTeleObj(obj:Obj):void {
			if (obj==null) return;
			teleObj=obj;
			if (!(teleObj is UnitPlayer) && teleObj.vis) {
				teleObj.vis.filters=[teleFilter];
			}
			teleObj.fracLevit=fraction;
			if (teleObj is UnitPlayer) teleObj.levit=(tr==2)?World.w.pers.teleEnemy:World.w.pers.teleEnemy*0.5;
			else teleObj.levit=2;
		}
		
		//уронить левитируемый объект
		public function dropTeleObj():void {
			if (teleObj) {
				if (!(teleObj is UnitPlayer) && teleObj.vis) {
					teleObj.vis.filters=[];
				}
				teleObj.levit=0;
				teleObj=null;
			}
		}
		
		//бросок телекинезом
		private function throwTele():void {
			if (teleObj) {
				var p:Object;
				var tspeed:Number = throwForce;
				
				if (teleObj.massa > 1) {
					tspeed = throwForce / Math.sqrt(teleObj.massa);
				}
				
				if (teleObj is Unit) {
					p = {x:100 * storona, y:-30};
				}
				else {
					p = {x:(celX - teleObj.coordinates.X), y:(celY-(teleObj.coordinates.Y - teleObj.boundingBox.halfHeight) - Math.abs(celX - teleObj.coordinates.X) / 4)};
				}
				
				if (teleObj is UnitPlayer) {
					(teleObj as UnitPlayer).damWall = dam / 2;
					(teleObj as UnitPlayer).t_throw = 30;
				}
				
				if (teleObj is Box) {
					(teleObj as Box).isThrow = true;
				}
				
				norma(p, tspeed);
				teleObj.velocity.X += p.x;
				teleObj.velocity.Y += p.y;
				dropTeleObj();
			}
		}
		
		public function actPort(rnd:Boolean=false):void {
			var cel:Unit = World.w.gg;
			var nx:Number = 0;
			var ny:Number = 0;
			for (var i:int = 1; i <= 20; i++) {
				if (i < 5 && !rnd) {
					if (isrnd(0.7)) {
						nx = cel.coordinates.X - cel.storona * (Math.random() * 300 + 200);
					}
					else {
						nx = cel.coordinates.X + cel.storona * (Math.random() * 300 + 200);
					}
					ny=cel.coordinates.Y;
				}
				else if (i < 10 && !rnd) {
					if (isrnd()) {
						nx = cel.coordinates.X - cel.storona * (Math.random() * 800 + 200);
					}
					else  {
						nx = cel.coordinates.X + cel.storona * (Math.random() * 800 + 200);
					}
					ny = cel.coordinates.Y + Math.random() * 160 - 80;
				}
				else {
					nx = Math.random() * loc.maxX;
					ny = Math.random() * loc.maxY;
				}
				
				nx = Math.round(nx / tileX) * tileX
				ny = Math.ceil(ny / tileY) * tileY - 1;
				
				if (nx < this.boundingBox.width) {
					nx = this.boundingBox.width;
				}
				
				if (ny < this.boundingBox.height + 40) {
					ny = this.boundingBox.height + 40;
				}
				
				if (nx > loc.maxX - this.boundingBox.width) {
					nx = loc.maxX - this.boundingBox.width;
				}
				
				if (ny > loc.maxY - 40) {
					ny = loc.maxY - 40;
				}
				
				if (!collisionAll(nx - coordinates.X, ny - coordinates.Y)) {
					teleport(nx, ny, 1);
					velocity.set(0, 0);
					setWeaponPos();
					if (findCel(true) && celUnit) {
						aiSpok = 0;
						storona = (celX > coordinates.X)? 1:-1;
					}
					return;
				}
			}
		}
		
		public override function visDetails():void {
			if (hpbar==null) {
				return;
			}
			
			super.visDetails();
			
			if (shithp > 0) {
				hpbar.armor.visible = true;
				hpbar.armor.gotoAndStop(int((1 - shithp / shitMaxHp) * 20 + 1));
			}
			else {
				hpbar.armor.visible = false;
			}
			
		}
	}
}
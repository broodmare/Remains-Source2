package fe.unit {

	import flash.filters.GlowFilter;
	import flash.display.MovieClip;
	
	import fe.*;
	import fe.util.Vector2;
	import fe.loc.Tile;
	import fe.graph.Emitter;
	import fe.weapon.Weapon;

	public class UnitZombie extends UnitPon {

		public var tr:int=0;
		
		protected var animFrame:int=0;
		protected var digger:int=0;		//нужно ли закапываться, 0-не нужно, 1-закопаться просто, 2-закопаться конкретно, 3-закопаться навсегда
		protected var kop1:Tile, kop2:Tile;
		
		var superX:Number=0, superY:Number=0;

		protected var zak:Boolean=false;
		
		//свечение
		var glowTip:int=0;
		var vlight:MovieClip;
		
		var knocked2:Number;
		
		//суперсила
		var superSilaTip:int=0;	//1-высокий прыжок, 2-телекинез, 3-ядовитый снаряд, 4-кислотный снаряд, 5-вспышка радиации, 6-трясучка,
								//7-телекинез+магия, 8-розовое облако
		var tZlo:int=120;		//время накопления силы
		var tPrepSuper:int=30;	//время подготовки суперсилы
		var tSuper:int=75;		//время использования суперсилы
		var vJump:int=30, teleAccel:Number=2, teleSpeed:Number=10, teleUnit:Unit, vDestroy:Number=20;
		var radMin:int=0, radMax:int=0, radradMin:int=200, radradMax:int=800, radHeal:Number=30;
		var superQuake:Number=0;
		var super_on:Boolean=false;
		
		var tIsRes:int=300;//750;
		var t_res:int=tIsRes;
		
		var t_ca:int=0;	//смена анимации
		
		protected var levitFilter:GlowFilter;

		private static var tileX:int = Tile.tileX;
		private static var tileY:int = Tile.tileY;

		// Constructor
		public function UnitZombie(cid:String=null, ndif:Number=100, xml:XML=null, loadObj:Object=null) {
			super(cid, ndif, xml, loadObj);
			//определить разновидность tr
			if (loadObj && loadObj.tr) {			//из загружаемого объекта
				tr=loadObj.tr;
			} else if (xml && xml.@tr.length()) {	//из настроек карты
				tr=xml.@tr;
			} else if (cid) {						//из заданного идентификатора cid
				tr=int(cid);
			} else {								//случайно по параметру ndif
				tr=Math.floor(Math.random()*7);
			}
			if (!(tr>=0)) tr=0;
			id='zombie'+tr;
			getXmlParam();
			walkSpeed=maxSpeed;
			knocked2=knocked;

			initBlit();
			animState='stay';
			
			if (glowTip>0) {
				vlight=new visZombieLight();	// .SWF Dependency
				vis.addChild(vlight);
				vlight.y = -this.boundingBox.halfHeight;
				vlight.blendMode='screen';
				vlight.cacheAsBitmap=true;
			}
			setSuper();
			
			plavdy=3;
			
			if (xml && xml.@dig.length()) digger=xml.@dig;
			else digger=isrnd(Math.min(ndif/20+0.25,0.75))?1:0;
			aiNapr=storona;
			if (!msex) id_name+='_f';
			
		}
		
		//сделать героем
		public override function setHero(nhero:int=1):void {
			super.setHero(nhero);
			if (hero==1) {
				tZlo=Math.round(tZlo*0.6);
			}
		}
		
		public override function getXmlParam(mid:String=null):void {
			super.getXmlParam('zombie');
			super.getXmlParam();
			var node0:XML = XMLDataGrabber.getNodeWithAttributeThatMatches("core", "AllData", "units", "id", id);
			if (node0.un.length()) {
				if (node0.un.@ss.length()) superSilaTip=node0.un.@ss;		//суперсила
				if (node0.un.@glow.length()) glowTip=node0.un.@glow;		//свечение
				if (node0.un.@res.length()) isRes=true;		//рес
			}
		}
		
		public override function setLevel(nlevel:int=0):void {
			super.setLevel(nlevel);
			radMax*=(1+0.05*level);
			radHeal*=(1+level*0.16);
		}
		
		public override function setWeaponPos(tip:int=0):void {
			weaponX = coordinates.X + storona * 30;
			weaponY = coordinates.Y - this.boundingBox.height * 0.8;
		}
		
		public override function save():Object {
			var obj:Object=super.save();
			if (obj==null) obj=new Object();
			obj.tr=tr;
			return obj;
		}	
		
		public override function setPos(nx:Number,ny:Number):void {
			super.setPos(nx,ny);
			if (digger && loc && !loc.active) {
				kop1 = loc.getAbsTile(coordinates.X - 10, coordinates.Y + 10);
				kop2 = loc.getAbsTile(coordinates.X + 10, coordinates.Y + 10);
				if (kop1.phis>0 && kop2.phis>0) {
					zak=true;
					zakop();
				}
				else {
					zak=false;
					if (digger==2) exterminate();
				}
			}
		}
		
		public override function animate():void {
			var cframe:int;
			if (sost==3 && isRes && t_res<20) {
				animState='die';
				blit(anims[animState].id,t_res);
				for (var j:int=1; j<=3; j++) Emitter.emit('die_spark', loc, coordinates.X+(Math.random()-0.5) * this.boundingBox.width, coordinates.Y - Math.random() * 10);
				return;
			}
			else if (sost==2 || sost==3) { //сдох
				if (stay) {
					if (animState=='fall') {
					}
					else if (animState=='death') animState='fall';
					else animState='die';
				}
				else animState='death';
				
				if (vlight && vlight.alpha>0) {
					vlight.alpha-=0.05;
				}
			}
			else if (aiState==4 && anims['pre']) {
				t_ca=0;
				animState='pre';
			}
			else if (aiState==7 && anims['super']) {
				animState='super';
			}
			else if (aiState==5) {
				vis.visible=false;
			}
			else if (aiState==6) {
				vis.visible=true;
				animState='dig';
				if (vlight && vlight.alpha<1) {
					vlight.alpha+=0.05;
					vlight.y -= this.boundingBox.standingHeight / 40;
				}
			}
			else {
				vis.visible=true;
				if (stay) {
					if  (velocity.X < 1 && velocity.X > -1) {
						animState='stay';
					}
					else if (aiState==3) {
						animState='run';
						sndStep(anims[animState].f,2);
					}
					else if (aiState==2 || velocity.X > 6 || velocity.X < -6) {
						animState='trot';
						sndStep(anims[animState].f,1);
					}
					else {
						animState='walk';
						sndStep(anims[animState].f,1);
					}
				}
				else {
					t_ca=0;
					animState='jump';
					// Commented out, there is no setStab function
					//anims[animState].setStab((dy*0.6+8)/16);
				}
				if (vlight && vlight.alpha != 1) {
					vlight.y = -this.boundingBox.halfHeight;
					vlight.alpha = 1;
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
		}
		
		
		public override function alarma(nx:Number=-1,ny:Number=-1):void {
			if (digger==3) return;
			if (sost==1 && (aiState<=1 || aiState==5)) {
				super.alarma(nx,ny);
				if (aiState==5) {
					aiState=6;
					aiTCh=24;
				}
				else if (aiState==6){
					
				}
				else {
					aiSpok=maxSpok+10;
					aiState=3;
					shok=Math.floor(Math.random()*15+5);
				}
			}
		}
		
		public override function die(sposob:int=0):void {
			superSilaVse();
			super.die(sposob);
		}

		// [script command]
		public override function command(com:String, val:String=null) {
			if (digger>=2) {
				digger=1;
				aiState=6;
				aiTCh=24;
			}
		}
		
		public override function actions() {
			super.actions();
			rasst=Math.sqrt(rasst2);
			volMinus=rasst/8000;
		}
		
		public override function setNull(f:Boolean=false):void {
			super.setNull(f);
			if (f) aiState=aiSpok=0;
			if (sost==1 && zak) {
				zakop();
			}
			visDetails();
		}
		
		public function jump(v:Number=1):void {
			if (stay) {		//прыжок
				velocity.Y = -jumpdy * v;
				aiJump=int(30+Math.random()*50);
			}
			else if (isPlav) {
				velocity.Y -= plavdy;
			}
		}
		
		public override function initBurn(sposob:int) {
			if (burn!=null) return;
			if (vlight) vlight.visible=false;
			super.initBurn(sposob);
		}
		
		public function zakop() {
			knocked=0;
			aiState=5;
			this.boundingBox.height = 0;
			this.boundingBox.flatten(coordinates);
			overLook=true;
			levitPoss=false;
			activateTrap=0;
			stealthMult=0;
			invis=true;
			fixed=true;
			if (digger==1) {
				vision=0.75;
				ear=0.2;
			}
			else if (digger==2){
				vision=0;
				ear=1.8;
			}
			else {
				vision=ear=0;
			}

			if (vlight) {
				vlight.alpha=0;
				vlight.y=0;
			}
		}
		public function vykop() {
			knocked=knocked2;
			this.boundingBox.height = this.boundingBox.standingHeight;
			this.boundingBox.top = coordinates.Y - this.boundingBox.height;
			aiState=3;
			aiSpok=maxSpok+10;
			overLook=false;
			fixed=false;
			invis=false;
			levitPoss=true;
			ear=1;
			activateTrap=2;
			stealthMult=1;
			vision=1;
			visDetails();
		}
		
		//проверка возможности прыжка
		private function checkJump():Boolean {
			if (loc.getAbsTile(coordinates.X, coordinates.Y - 85).phis!=0) return false;
			if (loc.getAbsTile(coordinates.X, coordinates.Y - 125).phis!=0) return false;
			if (loc.getAbsTile(coordinates.X + 40 * storona, coordinates.Y - 85).phis!=0) return false;
			if (loc.getAbsTile(coordinates.X + 40 * storona, coordinates.Y - 125).phis!=0) return false;
			return true;
		}
		
		public override function destroyWall(t:Tile, napr:int=0):Boolean {
			if (napr==3 && velocity.Y > 5 && superQuake && isrnd(0.2)) {
				quake(velocity.Y);
			}
			return super.destroyWall(t, napr);
		}
		
		private function resurrect() {
			hp=maxhp;
			sost=1;
			this.boundingBox.height = this.boundingBox.standingHeight;
			this.boundingBox.top = coordinates.Y - this.boundingBox.height;
			fraction=Unit.F_MONSTER;
			t_res=tIsRes;
			tZlo=120;
			aiTCh=30;
			transT=false;
			for (var i=int((this.boundingBox.left)/tileX); i<=int((this.boundingBox.right)/tileX); i++) {
				for (var j=int((this.boundingBox.top)/tileY); j<=int((this.boundingBox.bottom)/tileY); j++) {
					if (i<0 || i>=loc.spaceX || j<0 || j>=loc.spaceY) continue;
					if (collisionTile(loc.getTile(i, j))) loc.dieTile(loc.getTile(i, j));
				}
			}
		}
		
		private function quake(n:Number) {
			loc.budilo(coordinates.X, coordinates.Y, 500);
			loc.earthQuake(n*superQuake);
			Emitter.emit('quake', loc, coordinates.X+Math.random()*40-20, coordinates.Y);
		}
		
		var aiJump:int=0;
		var aiZlo:int=0;
		
		var optDistAtt:int=200;
		
		//aiState
		//0 - стоит на месте
		//1 - ходит туда-сюда
		//2 - не видит цели, бегает и ищет цель
		//3 - видит цель, бегает, атакует
		//4 - готовится спецприём
		//5 - закопался
		//6 - выкапывается
		//7 - спецприём
		
		override protected function control():void {
			var t:Tile;
			//если сдох, то не двигаться
			if (sost==3) {
				if (isRes) t_res--;
				if (t_res==25) sound('zombie_res');
				if (t_res==1) resurrect();
				return;
			}
			if (levit) {
				if (aiState<=1) {
					aiState=3;
					budilo();
				}
				shok=15;
			}
			if (stun) {
				aiState=0; aiTCh=3; walk=0;
			}

			var jmp:Number=0;
			
			if (World.w.enemyAct<=0) {
				celY = coordinates.Y - this.boundingBox.height;
				celX = coordinates.X + this.boundingBox.width * storona * 2;
				return;
			}
			
			if (aiState==5 && (kop1.phis==0 || kop2.phis==0)) {
				vykop();
			}
			
			if (digger==3) return;

			if (aiJump>0) aiJump--;
			
			//таймер смены состояний
			if (aiTCh>0) aiTCh--;
			else if (aiState==6) {
				vykop();
				aiTCh=30;
			} else if (aiState==5) {
				if (celUnit) {
					aiState=6;
					aiTCh=24;
				} else {
					aiTCh=30;
				}
			} else if (aiState==4) {
				if (superSilaTip>0) superSila();
				aiState=7;
				aiTCh=tSuper;
			} else if (aiState==7) {
				aiState=3;
				aiTCh=Math.floor(Math.random()*50)+50;
			} else {
				if (aiSpok==0) {
					aiState=Math.floor(Math.random()*2);
					aiZlo=0;
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
			//поиск цели
			if (World.w.enemyAct>1 && aiTCh%10==1 && aiState!=7 && !(aiState==5 && digger==2)) {
				if (findCel()) {
					//увидели
					if (celUnit) {
						teleUnit=celUnit;
						aiSpok=maxSpok+10;
					//услышали
					} else {
						aiSpok=maxSpok-1;
					}
				} else {
					setCel(null, celX+Math.random()*80-40, celY);
					if (aiSpok>0) {
						aiSpok--;
					}
					if (aiSpok<maxSpok+5) teleUnit=null
				}
			}
			//направление
			celDX=celX - coordinates.X;
			celDY=celY - coordinates.Y + this.boundingBox.height;
			if (celDY>40) aiVNapr=1;		//вниз
			else if(celDY<-40) aiVNapr=-1;	//прыжок
			else aiVNapr=0;
			porog=10;
			if (celDY>70) porog=0;

			//в возбуждённом состоянии наблюдательность увеличивается
			if (aiSpok==0) {
				vision=0.7;
				celY = coordinates.Y - this.boundingBox.height;
				celX = coordinates.X + this.boundingBox.width * storona * 2;
			} else {
				vision=1;
			}
			if (aiState==7) superSila2()
			
			
			//скорость
			maxSpeed=walkSpeed;
			if (aiState==2) maxSpeed=runSpeed*0.6;
			if (aiState==3) maxSpeed=runSpeed;
			if (velocity.X * diagon > 0) maxSpeed *= 0.5;

			if (aiState==3 && aiZlo<tZlo+10) aiZlo++;
			if (superSilaTip>0 && aiZlo>tZlo && (celUnit || aiState==3)) {
				if (teleUnit==null) teleUnit=celUnit;
				if (superSilaTip==1 || superSilaTip==2) findSuper();
				aiZlo=0;
				aiState=4;
				aiTCh=tPrepSuper;
			}
			
			if (aiState!=7 && super_on) superSilaVse();
			
			
			if (aiState==2 || aiState==3 || aiState==7) destroy=vDestroy;
			else destroy=0;

			
			//поведение при различных состояниях
			if (aiState==0) {
				if (stay && shX1>0.5 && aiNapr<0) turnX=1;
				if (stay && shX2>0.5 && aiNapr>0) turnX=-1;
			}
			else if (aiState==4) {
				if (celDX>40) aiNapr=storona=1;
				if (celDX<-40) aiNapr=storona=-1;
			}
			else if (aiState==1) {
				isLaz=0;
				//бегаем туда-сюда
				if (aiNapr==-1) {
					if (velocity.X > -maxSpeed) velocity.X -= accel;
				}
				else {
					if (velocity.X < maxSpeed) velocity.X += accel;
				}
				//поворачиваем, если впереди некуда бежать
				if (stay && shX1>0.25 && aiNapr<0) {
					if (aiState==1 && isrnd(0.1)) {
						t=loc.getAbsTile(coordinates.X + storona * 80, coordinates.Y + 10);
						if (t.phis==1 || t.shelf) {
							jump(0.5);
						}
						else turnX=1;
					}
					else turnX=1;
				}
				if (stay && shX2>0.25 && aiNapr>0) {
					if (aiState==1 && isrnd(0.1)) {
						t=loc.getAbsTile(coordinates.X + storona * 80, coordinates.Y + 10);
						if (t.phis==1 || t.shelf) {
							jump(0.5);
						}
						else turnX=-1;
					}
					else turnX=-1;
				}
				//если повернули, то можем остановиться
				if (stay && turnX!=0) {
					if (isrnd(0.1)) aiState=0;
					aiNapr=storona=turnX;
					turnX=0;
				}
				//в возбуждённом или атакующем состоянии
			}
			else if (aiState==2 || aiState==3) {
				
				//определить, куда двигаться
				if (aiVNapr<0 && aiJump<=0 && aiTCh%2==1 && checkJump()) jmp=1;		//проверить возможность прыжка перед прыжком
				if (aiTCh%15==1) {
					if (isrnd(0.8)) {
						if (celDX>100) aiNapr=storona=1;
						if (celDX<-100) aiNapr=storona=-1;
					}
				}
				if (celDY>80) throu=true;
				else throu=false;
				if (levit) {
					if (aiNapr==-1) {
						if (velocity.X > -maxSpeed) velocity.X -= levitaccel;
					}
					else {
						if (velocity.X < maxSpeed) velocity.X += levitaccel;
					}
				}
				else {
					if (aiNapr==-1) {
						if (velocity.X > -maxSpeed) velocity.X -= accel;
					}
					else {
						if (velocity.X < maxSpeed) velocity.X += accel;
					}
				}
				if (stay && (shX1>0.5 && aiNapr<0 || shX2>0.5 && aiNapr>0)) {
					if (aiVNapr<=0 && isrnd(0.5)) jmp=0.5;
					else if (velocity.X > 5 || velocity.X < -5) velocity.X *= 0.6;	//притормозить перед ямой
				}
				if (turnX!=0) {
					aiTTurn--;
					if (isrnd(0.03) || turnY>0) aiTTurn-=10;
					else if (isrnd(0.5) && checkJump()) jmp=1;
					else aiTTurn-=10;
					if (aiTTurn<0 && stay) {
						aiNapr=storona=turnX;
						aiTTurn=Math.floor(Math.random()*20)+5;
					}
					turnX=turnY=0;
				}
				if (jmp>0) {
					if (isPlav) jmp*=1.5;
					jump(jmp);
					jmp=0;
				}
			}
			pumpObj=null;
			
			if (coordinates.Y>loc.spaceY*tileY-80) throu=false;
			
			if (celUnit && celDX<optDistAtt && celDX>-optDistAtt && celDY<80 && celDY>-80 && aiState!=5 && aiState!=6) {
				if (attKorp(celUnit,(shok<=0?1:0.5)) || isrnd(0.2)) {
					if (aiZlo>80) aiZlo-=25;
				}
				if (superSilaTip==7 && isrnd(0.1)) currentWeapon.attack();
			} 
		}
		
		private function setSuper() {
			if (superSilaTip==1) {	//суперпрыжок
				tPrepSuper=30;
				tSuper=20;
				tZlo=90;
			}
			if (superSilaTip==9) {	//суперпрыжок
				superSilaTip=1;
				tPrepSuper=30;
				tSuper=20;
				tZlo=75;
				vJump=40;
			}
			if (superSilaTip==2 || superSilaTip==7) {	//телекинез
				tPrepSuper=10;
				tSuper=50;
				tZlo=120;
				levitFilter=new GlowFilter(0xFF0099,1,6,6,1,3);
			}
			if (superSilaTip==3) {	//плевок ядом
				tPrepSuper=18;
				tSuper=10;
				tZlo=150;
				if (currentWeapon==null) {
					currentWeapon=new Weapon(this,'zombivenom');
					childObjs=new Array(currentWeapon);
				}
			}
			if (superSilaTip==4) {	//плевок кислотой
				tPrepSuper=18;
				tSuper=10;
				tZlo=150;
				if (currentWeapon==null) {
					currentWeapon=new Weapon(this,'zombiacid');
					childObjs=new Array(currentWeapon);
				}
			}
			if (superSilaTip==5) {	//вспышка радиации
				tPrepSuper=30;
				tSuper=45;
				tZlo=140;
				radioactiv=radMin=1;
				radMax=20;
				radrad=radradMin=120;
				radradMax=1200;
			}
			if (superSilaTip==6) {	//трясучка
				tZlo=220;
				tPrepSuper=15;
				tSuper=45;
				superQuake=1;
				vDestroy=50;
			}
			if (superSilaTip==7) {
				optDistAtt=400;
				if (currentWeapon==null) {
					currentWeapon=new Weapon(this,'zombinecro');
					childObjs=new Array(currentWeapon);
				}
			}
			if (superSilaTip==8) {
				tPrepSuper=18;
				tSuper=10;
				tZlo=120;
				if (currentWeapon==null) {
					currentWeapon=new Weapon(this,'zombipink');
					childObjs=new Array(currentWeapon);
				}
			}
		}
		
		private function findSuper() {
			superX=-1;
			var nx:int = int(celX/tileX);
			var ny:int = int((celY+40)/tileY);
			if (superSilaTip==1) superY = ny * tileY + tileY + this.boundingBox.height;
			else if (superSilaTip==2 || superSilaTip==7) superY=celY+70;
			if (coordinates.Y-celY>120) {
				if (loc.getTile(nx,ny).phis==0) {
					if (loc.getTile(nx-1,ny).phis==0) {
						superX=nx*tileX;
					} else if (loc.getTile(nx+1,ny).phis==0) {
						superX=(nx+1)*tileX;
					}
				}
				if (superX<0 && loc.getTile(nx-2,ny).phis==0) {
					if (loc.getTile(nx-1,ny).phis==0) superX=(nx-1)*tileX;
					else if (loc.getTile(nx-3,ny).phis==0) superX=(nx-2)*tileX;
				}
				if (superX<0 && loc.getTile(nx+2,ny).phis==0) {
					if (loc.getTile(nx+1,ny).phis==0) superX=(nx+2)*tileX;
					else if (loc.getTile(nx+3,ny).phis==0) superX=(nx+3)*tileX;
				}
			} else {
				if (superSilaTip==1) {
					superY=celY;
					superX=celX;
				} else if (superSilaTip==2 || superSilaTip==7) {
					superX = coordinates.X;
					superY = coordinates.Y;
				}
			}
		}
		
		//суперсила в начальный момент
		private function superSila() {
			super_on=true;
			if (superSilaTip==1) {
				if (superX > 0 && superY > 0 && stay) {
					var tdx = superX - coordinates.X;
					var tdy = superY - coordinates.Y;
					var rasst=Math.sqrt(tdx * tdx + tdy * tdy);
					velocity.X = tdx / rasst * vJump;
					velocity.Y = tdy / rasst * vJump;
					tSuper=Math.round(rasst/vJump);
					if (tSuper>20) tSuper=20;
					grav=0;
				}
			} else if (superSilaTip==2 || superSilaTip==7) {
			} else if (superSilaTip==3 || superSilaTip==4 || superSilaTip==8) {
				currentWeapon.attack();
			} else if (superSilaTip==5) {
				radioactiv=radMax;
				radrad=radradMax;
				for each (var un:Unit in loc.units) {
					if (un is UnitZombie && un.sost==1) {
						var rasst=Math.sqrt((un.coordinates.X - coordinates.X)*(un.coordinates.X - coordinates.X)+(un.coordinates.Y - coordinates.Y)*(un.coordinates.Y - coordinates.Y));
						if (rasst<radrad) un.heal(radHeal*(radrad-rasst)/radrad);
					}
				}
				Emitter.emit('radioblast', loc, coordinates.X, coordinates.Y - this.boundingBox.halfHeight);
			} else if (superSilaTip==6) {
				loc.budilo(coordinates.X, coordinates.Y, 1000);
			}
		}
		
		//суперсила в действии
		private function superSila2() {
			if (superSilaTip==1) {
				grav=0;
			}
			else if (superSilaTip==2 || superSilaTip==7) {
				if (aiTCh==30) {
					superX = coordinates.X;
					superY = coordinates.Y;
				}
				if (teleUnit && teleUnit.levit!=1) {
					var tdx = superX - teleUnit.coordinates.X;
					var tdy = superY - teleUnit.coordinates.Y;
					var rasst=Math.sqrt(tdx*tdx+tdy*tdy);
					tdx=tdx/rasst*teleAccel;
					tdy=tdy/rasst*teleAccel;
					teleUnit.isLaz=0;
					teleUnit.levit=2;
					if (tdx>0 && teleUnit.velocity.X < teleSpeed || tdx < 0 && teleUnit.velocity.X > -teleSpeed) teleUnit.velocity.X += tdx;
					if (tdy>0 && teleUnit.velocity.Y < teleSpeed || tdy < 0 && teleUnit.velocity.Y > -teleSpeed) teleUnit.velocity.Y += tdy;
					if (teleUnit.player) (teleUnit as UnitPlayer).levitFilter2=levitFilter;
				}
			}
			else if (superSilaTip==5) {
				radioactiv-=(radMax-radMin)/tSuper;
			}
			else if (superSilaTip==6) {
				if (aiTCh%4==1) quake(12);
			}
		}
		
		//суперсила в конце
		private function superSilaVse() {
			super_on=false;
			if (superSilaTip==1) {
				maxSpeed=vJump+3;
				grav=1;
			}
			else if (superSilaTip==2 || superSilaTip==7) {
				if (teleUnit && teleUnit.levit==2) teleUnit.levit=0;
				teleUnit=null;
			}
			else if (superSilaTip==5) {
				radioactiv=radMin;
				radrad=radradMin
			}
		}
		
		public override function dropLoot():void {
			super.dropLoot();
			if (superSilaTip == 8) explosion(dam * 0.4, 19, 150, 15);
		}
	}
}
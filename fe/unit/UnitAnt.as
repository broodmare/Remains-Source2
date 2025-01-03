package fe.unit {
	
	import fe.*;
	import fe.serv.BlitAnim;
	import fe.loc.Tile;
	import fe.weapon.Weapon;
	
	public class UnitAnt extends Unit {

		public var tr:int;
		
		private var optDistAtt:int=100;
		private var optJumping:Boolean=false;
		private var optJumpAtt:Boolean=true;
		private var optAnimAtt:Boolean=false;
		private var t_punch:int=0;
		
		private var vstorona:int=0;

		private static var tileX:int = Tile.tileX;
		private static var tileY:int = Tile.tileY;
		
		// Constructor
		public function UnitAnt(cid:String=null, ndif:Number=100, xml:XML=null, loadObj:Object=null) {
			
			super(cid, ndif, xml, loadObj);
			
			if (loadObj && loadObj.tr) tr=loadObj.tr;		//из загружаемого объекта
			else if (xml && xml.@tr.length()) tr=xml.@tr;	//из настроек карты
			else if (cid) tr=int(cid);						//из заданного идентификатора cid
			else tr=1;										//случайно по параметру ndif

			id = 'ant' + tr;
			getXmlParam();
			initBlit();
			animState='stay';
			maxSpeed=maxSpeed*(0.9+Math.random()*0.2);
			sitSpeed=maxSpeed;
			walkSpeed=maxSpeed;
			lazSpeed=maxSpeed;
			plavdy=accel/4;
			
			if (tr==3) {
				currentWeapon=new Weapon(this,'antfire');
				childObjs=new Array(currentWeapon);
			}
			
			aiNapr=storona;
		}
		
		//сделать героем
		public override function setHero(nhero:int=1):void {
			super.setHero(nhero);
			if (hero==1) {
				skin+=4;
			}
		}
		
		public override function getXmlParam(mid:String=null):void {
			super.getXmlParam('ant');
			super.getXmlParam();
		}

		public override function alarma(nx:Number=-1,ny:Number=-1):void {
			if (sost==1 && aiState<=1) {
				super.alarma(nx,ny);
				aiSpok=maxSpok;
				aiState=2;
				shok = int(Math.random()*5+3);
				budilo(250);
			}
		}
		
		public override function expl():void {
			super.expl();
		}
		
		public override function setVisPos() {
			if (vis) {
				if (isLaz==0) {
					vis.x = coordinates.X;
					vis.y = coordinates.Y;
					vis.scaleX=storona;
					vis.scaleY=1;
					vis.rotation=0;
				}
				else if (isLaz==1) {
					vis.x = this.boundingBox.right;
					vis.y = this.boundingBox.top;
					vis.rotation=-90;
					vis.scaleX=-vstorona;
				}
				else if (isLaz==-1) {
					vis.x = this.boundingBox.left;
					vis.y = this.boundingBox.top;
					vis.rotation=90;
					vis.scaleX=vstorona;
				}
			}
		}

		public override function animate():void {
			var cframe:int;
			if (trup && (sost==2 || sost==3)) { //сдох
				if (stay && animState!='death') {
					animState='die';
				} else animState='death';
			}
			else if (t_punch>0){
				animState='attack';
				if (t_punch==15) anims[animState].restart();
			}
			else {
				if (stay) {
					if  (velocity.X == 0) {
						animState='stay';
					}
					else if  (velocity.X > 5 || velocity.X < -5) animState = 'run';
					else  animState='walk';
				}
				else if (isLaz) {
					if  (velocity.Y > 1 || velocity.Y < -1) animState='walk';
					else  animState='stay';
				}
				else if (aiPlav || levit) {
					animState='plav';
				}
				else {
					animState='jump';
				}
			}
			if (animState!=animState2) {
				anims[animState].restart();
				animState2=animState;
			}
			if (!anims[animState].st) {
				blit(anims[animState].id,Math.floor(anims[animState].f));
			}
			anims[animState].step();
		}
		
		public function jump(v:Number=1):void {
			if (stay) {		//прыжок
				velocity.Y = -jumpdy * v;
				velocity.X += storona * accel * 5;
			}
			if (!isPlav&&aiPlav) velocity.Y = -jumpdy * 0.6;	//выпрыгивание из воды
			if (isPlav) {
				velocity.Y -= plavdy;
			}
		}
		
		private var aiLaz:int=0;
		private var aiNeedLaz:int=0;
		
		private var aiVis=0.5;
		
		//aiState
		//0 - стоит на месте
		//1 - ходит туда-сюда
		//2 - видит цель, бежит к ней, атакует
		//3 - атакует оружием
		
		override protected function control():void {

			var t:Tile;
			
			//если сдох, то не двигаться
			if (sost==3) return;
			
			if (levit) {
				if (aiState<=1) {
					aiSpok=maxSpok;
				}
				shok=15;
			}
			
			if (stun) {
				aiState=0; aiTCh=3; walk=0;
			}
			
			if (t_punch>0) t_punch--;

			var jmp:Number=0;
			
			if (World.w.enemyAct<=0) {
				celY = coordinates.Y - this.boundingBox.height;
				celX = coordinates.X + this.boundingBox.width * storona * 2;
				return;
			}
			
			//таймер смены состояний
			if (aiTCh>0) aiTCh--;
			else {
				if (aiSpok==0) {
					aiState=int(Math.random()*2);
				}
				if (aiSpok>0) aiState=2;
				if (aiState==0) aiTCh=int(Math.random()*20)+10;
				else aiTCh=int(Math.random()*50)+40;
				if (isrnd(0.2)) aiNeedLaz=int(Math.random()*3-1);
				//атаковать оружием
			}
			//поиск цели
			if (World.w.enemyAct>1 && aiTCh%10==1) {
				if (findCel() && celUnit) {
					aiSpok=maxSpok;
				}
				else {
					setCel(null, celX+Math.random()*80-40, celY);
					if (aiSpok>0) {
						aiSpok--;
					}
				}
				if (celDY>40 && celDX<200 && celDX>-200) aiVNapr=1;		//вниз
				else if(celDY<-0 && celDX<200 && celDX>-200) aiVNapr=-1;	//прыжок
				else aiVNapr=0;
				if (currentWeapon && aiState==2 && celUnit && celDY<80 && celDY>-80 && celDX<120 && celDX>-120 && isrnd(0.7)) {
					aiState=3;
				}
			}
			
			//в возбуждённом состоянии наблюдательность увеличивается
			if (aiSpok==0) {
				vision=aiVis/2;
				celY = coordinates.Y - this.boundingBox.height;
				celX = coordinates.X + this.boundingBox.width * storona * 2;
			}
			else {
				vision=aiVis;
			}
			
			//поведение в воде
			if (isPlav) aiState=1;
			if (aiPlav>0) aiPlav--;
			if (isPlav) aiPlav=5;
			
			//скорость
			maxSpeed = walkSpeed;
			
			if (aiState==2) {
				maxSpeed=runSpeed;
			}
			if (velocity.X * diagon > 0) maxSpeed *= 0.5;
			walk = 0;
				
			if (isLaz) {
				overLook=true;
			}
			else {
				overLook=false;
				storona=aiNapr;	
			}
			//поведение при различных состояниях
			if (aiState==0 || aiState==3) {
				if (stay && shX1>0.5 && aiNapr<0) turnX=1;
				if (stay && shX2>0.5 && aiNapr>0) turnX=-1;
				if (isPlav) jump();
				if (isLaz) {
					velocity.Y = 0;
					checkStairs();
				}
			}

			if (aiState==1) {
				if (aiNapr==-1) {
					if (velocity.X > -maxSpeed) velocity.X -= accel;
					walk=-1;
				}
				else {
					if (velocity.X < maxSpeed) velocity.X += accel;
					walk=1;
				}
				//поворачиваем, если впереди некуда бежать
				if (stay && shX1>0.5 && aiNapr<0 && isrnd()) {
					if (optJumping && isrnd(0.1)) {
						t=loc.getAbsTile(coordinates.X + storona * 80, coordinates.Y + 10);
						if (t.phis==1 || t.shelf) {
							jump(0.5);
						}
						else turnX=1;
					}
					else turnX=1;
				}
				if (stay && shX2>0.5 && aiNapr>0 && isrnd()) {
					if (optJumping && isrnd(0.1)) {
						t=loc.getAbsTile(coordinates.X + storona * 80, coordinates.Y + 10);
						if (t.phis==1 || t.shelf) {
							jump(0.5);
						}
						else turnX=-1;
					}
					else turnX=-1;
				}
				if (stay && turnX!=0) {
					if (isrnd()) aiNeedLaz=-1;
					else aiNapr=storona=turnX;
					turnX=0;
				}
				if (isLaz==0 && aiNeedLaz==-1) {		//пытаться карабкаться вверх
					checkStairs();
				}
				if (isLaz==0 && aiNeedLaz==1) {		//пытаться карабкаться вниз
					checkStairs(2);
				}
				if (isLaz) {
					if (aiNeedLaz==-1) {
						if (velocity.Y > -lazSpeed) velocity.Y -= lazSpeed / 2;
						vstorona=-1;
						checkStairs();
					}
					else if (aiNeedLaz==1) {
						if (velocity.Y < lazSpeed) velocity.Y += lazSpeed / 2;
						vstorona=1;
						checkStairs();
					}
					else {
						isLaz=0;
					}
					if (turnY!=0) {
						aiNeedLaz=turnY;
						if (turnY<0 && isrnd()) aiNeedLaz=0;
						turnY=0;
					}
				} 
				if (isLaz==0) aiNeedLaz=0;
				//в воде всплываем
				if (isPlav) {
					jump();
					if (turnX!=0) {
						aiNapr=storona=turnX;
						turnX=0;
					}
				}
				//в возбуждённом или атакующем состоянии
			}
			else if (aiState==2) {
				//определить, куда двигаться
				if (aiTCh%10==1) {
					if (isrnd(0.9)) {
						if (celDY>80) throu=true;
						if (optJumping && aiVNapr<0 && isrnd()) jmp=1;
					}
					else {
						throu=false;
						jmp=0;
					}
					if (isrnd(0.7)) {
						if (celDX>80) aiNapr=storona=1;
						if (celDX<-80) aiNapr=storona=-1;
					}
				}
				
				if (isPlav && isrnd(0.7)&& celDY<0) {
					jmp=1;
				}
				
				if (isLaz==0 && aiVNapr==-1) {		//пытаться карабкаться вверх
					checkStairs();
				}
				
				if (isLaz==0 && aiVNapr==1) {		//пытаться карабкаться вниз
					checkStairs(2);
				}
				
				if (isLaz) {
					if (aiVNapr==-1) {
						if (velocity.Y > -lazSpeed) velocity.Y -= lazSpeed / 2;
						vstorona=-1;
						checkStairs();
					}
					else if (aiVNapr==1) {
						if (velocity.Y < lazSpeed) velocity.Y += lazSpeed / 2;
						vstorona=1;
						checkStairs();
					}
					else {
						isLaz=0;
					}
					
					if (turnY!=0) {
						isLaz=0;
						turnY=0;
					}
				} 
				
				if (levit) {
					if (aiNapr==-1) {
						if (velocity.X > -maxSpeed) velocity.X -= levitaccel;
					}
					else if (aiNapr==1){
						if (velocity.X < maxSpeed) velocity.X += levitaccel;
					}
				}
				else if (stay || isPlav) {
					if (aiNapr==-1) {
						if (velocity.X > -maxSpeed) velocity.X -= accel;
						walk=-1;
					}
					else if (aiNapr==1){
						if (velocity.X < maxSpeed) velocity.X += accel;
						walk=1;
					}
				}
				else {
					if (aiNapr==-1) {
						if (velocity.X > -maxSpeed) velocity.X -= accel / 4;
					}
					else  if (aiNapr==1){
						if (velocity.X < maxSpeed) velocity.X += accel / 4;
					}
				}
				
				if (optJumping && stay && isrnd(0.5) && aiVNapr<=0 && (shX1>0.5 && aiNapr<0 || shX2>0.5 && aiNapr>0)) jmp=0.5;
				
				//если наткнулся на препятствие
				if (turnX!=0) {
					if (celDX*aiNapr<0) {				//повернуться, если цель сзади
						aiNapr=storona=turnX;
					}
					else {							//попытаться перепрыгнуть
						aiTTurn--;
						if (isrnd(0.03) || turnY>0 || kray) aiTTurn-=10;
						else jmp=1;
						kray=false;
						if (aiTTurn<0) {
							aiNapr=storona=turnX;
							aiTTurn=int(Math.random()*20)+5;
						}
					}
					turnX=turnY=0;
				}
				
				if (jmp>0) {
					jump(jmp);
					jmp=0;
				}
				
				if (celUnit && celDX<optDistAtt && celDX>-optDistAtt && celDY<120 && celDY>-120) {
					attack();
				}
			}
			
			if (aiState==3) {
				currentWeapon.attack();
			}
			
			if (coordinates.Y > loc.spaceY * tileY - 80) {
				throu = false;
			}
		}
		
		//поиск лестницы
		public override function checkStairs(ny:int=-1, nx:int=0):Boolean {
			try
			{
				var i:int = int((coordinates.X + nx) / tileX);
				var j:int = int((coordinates.Y + ny) / tileY);
				
				if (j >= loc.spaceY) {
					j = loc.spaceY - 1;
				}
				
				if (loc.getTile(i, j).phis >= 1) {
					isLaz = 0;
					return false;
				}
				if (loc.getTile(i, j).stair) {
					isLaz = loc.getTile(i, j).stair;
				}
				else if (loc.getTile(i + storona, j).phis) {
					isLaz = storona;
				}
				else isLaz = 0;
				
				if (isLaz != 0) {
					storona = isLaz;

					if (isLaz == -1) coordinates.X = loc.getTile(i, j).boundingBox.left + this.boundingBox.halfWidth;
					else coordinates.X = loc.getTile(i, j).boundingBox.right - this.boundingBox.halfWidth;

					this.boundingBox.left = coordinates.X - this.boundingBox.halfWidth;
					this.boundingBox.right = coordinates.X + this.boundingBox.halfWidth;
					stay = false;
					return true;
				}
			}
			catch (err) { 

			}

			isLaz=0;
			return false;
		}
		
		public function attack():void {
			if (celUnit && shok <= 0) {	//атака холодным оружием без левитации или корпусом
				attKorp(celUnit, 1);
			}
			if (optJumpAtt && isLaz==0) {
				jump(0.5);
			}
		}
	}
}
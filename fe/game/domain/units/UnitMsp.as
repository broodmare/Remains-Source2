package fe.game.domain.units {
	
	import fe.engine.utils.Numbers;
	import fe.game.domain.location.tile.Tile;
	import fe.game.domain.location.Location;
	import fe.game.domain.entities.BoundingBox;
	import fe.game.enums.E_Material;
	import fe.game.rendering.enums.E_Decal;
	import fe.game.enums.E_Direction;
	import fe.game.GameContainer;

	public class UnitMsp extends Unit {

		public var tr:int;
		private var weap:String;
		private var cep:int = 0; //способ прикрепления 0-обычный, 1-к потолку, 2- к стене слева, 3-к стене справа
		
		private var tileY:int = Tile.tileY;

		public function UnitMsp(cid:String=null, ndif:Number=100, xml:XML=null, loadObj:Object=null) {

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
				tr=1;
			}
			
			id = 'msp';
			
			initArt(id);
			art.play('stay');
			
			getXmlParam();
			
			mat=E_Material.METAL;
			aiNapr=storona;
			t_replic=Math.random()*100-50;
		}

		//поместить созданный юнит в локацию
		public override function putLoc(nloc:Location, nx:Number, ny:Number):void {
			if (nloc.getAbsTile(nx, ny+10).collision==0) {
				if (nloc.getAbsTile(nx, ny-50).collision) {
					cep=1;
					ny-=40-this.boundingBox.height-1
					fixed=true;
				}
				else if (nloc.getAbsTile(nx-40, ny-10).collision) {
					cep=2;
					nx-=(40-this.boundingBox.width)/2-1;
					fixed=true;
				}
				else if (nloc.getAbsTile(nx+40, ny-10).collision) {
					cep=3;
					nx+=(40-this.boundingBox.width)/2-1;
					fixed=true;
				}
			}
			super.putLoc(nloc, nx, ny);
		}

		public override function expl():void {
			newPart('metal', 4);
			newPart('miniexpl');
		}
		
		public override function setVisPos():void {
			if (cep==0) {
				art.x = coordinates.X;
				art.y = coordinates.Y;
				art.rotation=0;
			}
			else if (cep==1) {
				art.x = coordinates.X;
				art.y = this.boundingBox.top;
				art.rotation=Numbers.ONE_PI;
			}
			else if (cep==3) {
				art.x = this.boundingBox.right;
				art.y = coordinates.Y - this.boundingBox.halfHeight;
				art.rotation = Numbers.NEGATIVE_HALF_PI;
			}
			else if (cep==2) {
				art.x = this.boundingBox.left;
				art.y = coordinates.Y - this.boundingBox.halfHeight;
				art.rotation = Numbers.HALF_PI;
			}
			art.scaleX = storona.X;
		}
		
		public override function animate():void {
			if (aiState==0 || aiState==1) { //сдох
				animState='stay';
			}
			else if (aiState==2 || aiState==4) {
				animState='wake';
			}
			else if (stay || levit){
				animState='walk';
			}
			else {
				animState='jump';
			}
			art.play(animState);
		}
		
		public function jump(v:Number=1):void {
			if (stay) {		//прыжок
				velocity.Y =- jumpdy * v;
			}
		}

		public override function dropLoot():void {
			explosion(dam, tipDamage, 150, 0, 20, 30, E_Decal.EXPLOSION);
		}

		public override function setLevel(nlevel:int=0):void {
			level+=nlevel;
			if (level<0) level=0;
			hp=maxhp=hp*(1+level*0.12);
			dam*=(1+level*0.2);
			observ+=Math.min(nlevel*0.6,15)*(0.9+Math.random()*0.2);
		}

		//состояния
		//0 - спит
		//1 - ищет цели
		//2 - готовится стрелять
		//3 - видит цель, атакует
		//4 - не видит цель
		
		override protected function control():void {

			//если сдох, то не двигаться
			if (sost==3) return;
			if (levit) {
				if (aiState<=1) {
					shok=15;
					aiState=3;
					budilo();
				}
			}
			if (stun) {
				aiState=0; aiTCh=3; walk=E_Direction.NEUTRAL;
			}

			var jmp:Number=0;
			
			if (GameContainer.reference.enemyAct<=0) {
				celY = coordinates.Y - this.boundingBox.height;
				celX = coordinates.X + this.boundingBox.width * storona.X * 2;
				return;
			}
			if (aiState>=3 && cep>0) {
				cep=0;
				fixed=false;
			}
			//таймер смены состояний
			if (aiTCh>0) aiTCh--;
			else if (aiState==2) {
				if (celUnit) {
					aiSpok=maxSpok+10;
					celDX = celX - coordinates.X;
					if (celDX>40) aiNapr=E_Direction.RIGHT;
					if (celDX<-40) aiNapr=E_Direction.LEFT;
					aiState=3;
				}
				else {
					aiState=1;
				}
			}
			else {
				if (aiSpok<=0) {
					aiState=1;
					aiTCh = int(Math.random()*40)+40;
				}
				else {
					aiTCh = int(Math.random()*50)+40;
				}
				if (aiSpok>0) aiState=4;
				if (aiSpok>=maxSpok) aiState=3;
			}
			//поиск цели
			if (GameContainer.reference.enemyAct>1 && aiTCh%10==1) {
				if (findCel()) {
					if (aiState<=1) {
						aiState=2;
						aiTCh=int(Math.random()*10)+30;
					}
					else if (aiState>=3) {
						aiState=3;
					}
				}
				else {
					if (aiSpok>0) {
						aiSpok--;
					}
				}
			}
			
			if (fixed) return;
			
			//направление
			celDX = celX - coordinates.X;
			celDY = celY - coordinates.Y + this.boundingBox.height;
			if (celDY>40) aiVNapr=E_Direction.DOWN;		//вниз
			else if(celDY<-40) aiVNapr=E_Direction.UP;	//прыжок
			else aiVNapr=E_Direction.NEUTRAL;

			//поведение при различных состояниях
			if (aiState==3) {
				//определить, куда двигаться
				if (aiTCh%15==1) {
					if (isrnd(0.9)) {
						if (celDY>80) throu=true;
						if (aiVNapr==E_Direction.UP && isrnd(0.2)) jmp=1;
					}
					else {
						throu=false;
						jmp=0;
					}
					if (celDX>40) aiNapr=E_Direction.RIGHT;
					if (celDX<-40) aiNapr=E_Direction.LEFT;
					storona=aiNapr;
				}
				if (levit) {
					if (aiNapr==E_Direction.LEFT) {
						if (velocity.X > -maxSpeed) velocity.X -= levitaccel;
					}
					else {
						if (velocity.X < maxSpeed) velocity.X += levitaccel;
					}
				}
				else {
					if (aiNapr==E_Direction.LEFT) {
						walk=E_Direction.LEFT;
						if (velocity.X > -maxSpeed) velocity.X -= accel;
					}
					else {
						walk=E_Direction.RIGHT;
						if (velocity.X < maxSpeed) velocity.X += accel;
					}
				}
				if (stay && isrnd(0.5) && aiVNapr!=E_Direction.DOWN && (shX1>0.5 && aiNapr==E_Direction.LEFT || shX2>0.5 && aiNapr==E_Direction.RIGHT)) jmp=0.5;
				if (turnX!=E_Direction.NEUTRAL) {
					aiTTurn--;
					if (isrnd(0.03) || turnY==E_Direction.DOWN) aiTTurn-=10;
					else jmp=1;
					if (aiTTurn<0) {
						aiNapr=storona=turnX;
						aiTTurn = int(Math.random()*20)+5;
					}
					turnX=turnY=E_Direction.NEUTRAL;
				}
				if (jmp>0) {
					jump(jmp);
					jmp=0;
				}
				if (celUnit)
				{
					if ((coordinates.X - celUnit.coordinates.X) * (coordinates.X - celUnit.coordinates.X) + (coordinates.Y - celUnit.coordinates.Y + celUnit.boundingBox.halfHeight) * (coordinates.Y - celUnit.coordinates.Y + celUnit.boundingBox.halfHeight) < 100 * 100) die();
				}
				pumpObj=null;
			}
			else {
				walk = E_Direction.NEUTRAL;
			}
			
			if (coordinates.Y > loc.spaceY * tileY - 80) throu = false;
		}
	}
}

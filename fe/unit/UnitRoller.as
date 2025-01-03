package fe.unit {
	
	import fe.*;
	import fe.loc.Tile;
	import fe.entities.BoundingBox;
	
	public class UnitRoller extends Unit {

		private var rollDr:Number = 0;
		private var tr:int = 1;

		private static var tileY:int = Tile.tileY;

		// Constructor
		public function UnitRoller(cid:String=null, ndif:Number=100, xml:XML=null, loadObj:Object=null) {

			super(cid, ndif, xml, loadObj);
			
			if (cid) tr=int(cid);							//из заданного идентификатора cid
			else tr=1;
			
			if (loadObj && loadObj.tr) tr=loadObj.tr;		//из загружаемого объекта
			else if (xml && xml.@tr.length()) tr=xml.@tr;	//из настроек карты

			if (!(tr>0)) tr=1;
			
			id='roller';
			
			if (tr>=2) id+=tr;
			
			getXmlParam();
			
			if (tr==2) vis=new visualRoller2();	// .SWF Dependency
			else vis=new visualRoller();		// .SWF Dependency
			
			vis.osn.rotation=Math.random()*360;
			vis.osn.stop();
			maxSpeed+=Math.random()*2-1;
			walkSpeed=sitSpeed=runSpeed=maxSpeed;
			mat=1;
			acidDey=1;
			jumpBall=0.5;	//подпрыгивание при падении
			elast=0.8;
			storona=1;
		}

		public override function expl():void {
			newPart('metal',4);
			newPart('miniexpl');
		}
		
		public override function setVisPos() {
			vis.x = coordinates.X;
			vis.y = this.boundingBox.getCenter(coordinates);
		}
		
		public override function dropLoot():void {
			if (tr == 2) explosion(dam * 4, Unit.D_PLASMA, 150, 0, 20, 30, 9);
			super.dropLoot();
		}
		
		public override function animate():void {
			if (aiState==0) {
				if (vis.osn.currentFrame!=1) {
					vis.osn.gotoAndStop(1);
				}
			}
			else {
				if (rasst2<200*200 && vis.osn.currentFrame==1) {
					vis.osn.gotoAndStop(2);
				}
				if (rasst2>600*600 && vis.osn.currentFrame==2) {
					vis.osn.gotoAndStop(1);
				}
			}
			if (stay || turnY==-1) rollDr = velocity.X * 1.5;
			turnY = 0;
			vis.osn.rotation += rollDr;
		}
		
		public override function setNull(f:Boolean=false):void {
			super.setNull(f);
			if (f) {
				aiState = 0;
				aiSpok = 0;
			}
		}
		
		public function jump(v:Number=1):void {
			if (stay) {		//прыжок
				velocity.Y = -jumpdy * v;
			}
		}
		
		private var aiVis = 0.5;
		
		private var optDistAtt:int=100;
		private var optJumpAtt:Boolean=true;
		
		//aiState
		//0 - стоит на месте
		//1 - видит цель, катится к ней, атакует
		
		override protected function control():void {
			
			var t:Tile;
			//если сдох, то не двигаться
			if (sost==3) return;

			var jmp:Number=0;
			
			if (World.w.enemyAct <= 0) {
				celY = coordinates.Y - this.boundingBox.height;
				celX = coordinates.X + this.boundingBox.width * storona * 2;
				return;
			}
			if (isPlav) {
				die();
				return;
			}
			
			//таймер смены состояний
			if (aiTCh>0) aiTCh--;
			else {
				if (aiSpok==0) {
					aiState=0;
				} else aiState=1;
				aiTCh=Math.floor(Math.random()*50)+40;
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
				if (celDY>40) aiVNapr=1;		//вниз
				else if(celDY<-40) aiVNapr=-1;	//прыжок
				else aiVNapr=0;
			}
			//поведение при различных состояниях
			if (aiState==0) {
				if (stay && shX1>0.5 && aiNapr<0) turnX=1;
				if (stay && shX2>0.5 && aiNapr>0) turnX=-1;
			}
			else if (aiState==1) {
				//определить, куда двигаться
				if (aiTCh%15==1) {
					if (isrnd(0.9)) {
						if (celDY>80) throu=true;
						if (aiVNapr<0 && isrnd()) jmp=Math.random()*0.5+0.5;
					}
					else {
						throu=false;
						jmp=0;
					}
					if (celDX>100) aiNapr=storona=1;
					if (celDX<-100) aiNapr=storona=-1;
				}
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
				if (stay && isrnd(0.5) && aiVNapr<=0 && (shX1>0.5 && aiNapr<0 || shX2>0.5 && aiNapr>0)) jmp=0.5;
				if (turnX!=0) {
					aiTTurn--;
					if (isrnd(0.03) || turnY>0) aiTTurn-=10;
					else jmp=1;
					if (aiTTurn<0) {
						aiNapr=storona=turnX;
						aiTTurn=Math.floor(Math.random()*20)+5;
					}
					turnX=turnY=0;
				}
				if (jmp>0) {
					jump(jmp);
					jmp=0;
				}
				if (celUnit && celDX<optDistAtt && celDX>-optDistAtt && celDY<80 && celDY>-80) {
					attack();
				}
			} 
			
			if (coordinates.Y > loc.spaceY * tileY - 80) throu=false;
		}
		
		public function attack() {
			if (celUnit && shok <= 0) {	//атака корпусом
				attKorp(celUnit, 1);
			}
			jump(0.3);
		}
	}
}
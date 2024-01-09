package fe.unit {
	
	import fe.*;
	import fe.serv.BlitAnim;
	import fe.loc.Tile;
	
	public class UnitRoller extends Unit{
		
		var rollDr:Number=0;
		var tr:int=1;

		public function UnitRoller(cid:String=null, ndif:Number=100, xml:XML=null, loadObj:Object=null) {
			super(cid, ndif, xml, loadObj);
			if (cid) {						//из заданного идентификатора cid
				tr=int(cid);
			} else {									
				tr=1;
			}
			if (loadObj && loadObj.tr) {			//из загружаемого объекта
				tr=loadObj.tr;
			} else if (xml && xml.@tr.length()) {	//из настроек карты
				tr=xml.@tr;
			} 
			if (!(tr>0)) tr=1;
			id='roller';
			if (tr>=2) id+=tr;
			getXmlParam();
			if (tr==2) vis=new visualRoller2();
			else vis=new visualRoller();
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

		public override function expl()	{
			newPart('metal',4);
			newPart('miniexpl');
		}
		
		public override function setVisPos() {
			vis.x=X,vis.y=Y-scY/2;
		}
		
		public override function dropLoot() {
			if (tr==2) explosion(dam*4,Unit.D_PLASMA,150,0,20,30,9);
			super.dropLoot();
		}
		
		public override function animate() {
			if (aiState==0) {
				if (vis.osn.currentFrame!=1) {
					vis.osn.gotoAndStop(1);
				}
			} else {
				if (rasst2<200*200 && vis.osn.currentFrame==1) {
					vis.osn.gotoAndStop(2);
				}
				if (rasst2>600*600 && vis.osn.currentFrame==2) {
					vis.osn.gotoAndStop(1);
				}
			}
			if (stay || turnY==-1) rollDr=dx*1.5;
			turnY=0;
			vis.osn.rotation+=rollDr;
		}
		
		public override function setNull(f:Boolean=false) {
			super.setNull(f);
			if (f) aiState=aiSpok=0;
		}
		
		public function jump(v:Number=1) {
			if (stay) {		//прыжок
				dy=-jumpdy*v;
			}
		}
		
		var aiVis=0.5;
		
		var optDistAtt:int=100;
		var optJumpAtt:Boolean=true;
		
		//aiState
		//0 - стоит на месте
		//1 - видит цель, катится к ней, атакует
		
		public override function control() {
			var t:Tile;
			//если сдох, то не двигаться
			if (sost==3) return;

			var jmp:Number=0;
			//return;
			
			if (World.w.enemyAct<=0) {
				celY=Y-scY;
				celX=X+scX*storona*2;
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
			//trace(aiState)
			if (World.w.enemyAct>1 && aiTCh%10==1) {
				if (findCel() && celUnit) {
					aiSpok=maxSpok;
				} else {
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
			} else if (aiState==1) {
				//определить, куда двигаться
				if (aiTCh%15==1) {
					if (isrnd(0.9)) {
						if (celDY>80) throu=true;
						if (aiVNapr<0 && isrnd()) jmp=Math.random()*0.5+0.5;
					} else {
						throu=false;
						jmp=0;
					}
					if (celDX>100) aiNapr=storona=1;
					if (celDX<-100) aiNapr=storona=-1;
				}
				if (levit) {
					if (aiNapr==-1) {
						if (dx>-maxSpeed) dx-=levitaccel;
					} else {
						if (dx<maxSpeed) dx+=levitaccel;
					}
				} else {
					if (aiNapr==-1) {
						if (dx>-maxSpeed) dx-=accel;
					} else {
						if (dx<maxSpeed) dx+=accel;
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
			
			if (Y>loc.spaceY*World.tileY-80) throu=false;
		}
		
		public function attack() {
			if (celUnit && shok<=0) {	//атака корпусом
				attKorp(celUnit,1);
			}
			jump(0.3);
		}

		
	}
	
}

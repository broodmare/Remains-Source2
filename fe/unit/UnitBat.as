package fe.unit {
	
	import fe.*;
	public class UnitBat extends Unit{
		
		var bleedDamage=5;
		var tr:int=1;
		
		public function UnitBat(cid:String=null, ndif:Number=100, xml:XML=null, loadObj:Object=null) {
			super(cid, ndif, xml, loadObj);
			if (cid) tr=int(cid);
			if (xml && xml.@tr.length()) tr=xml.@tr;
			id='bloodwing';
			if (tr>1) id+=tr;
			if (tr==2) vis=new visualBloodwing2();
			else vis=new visualBloodwing();
			vis.osn.gotoAndStop('stay');
			getXmlParam();
			maxSpeed+=Math.random()*2-1;
			walkSpeed=maxSpeed;
			runSpeed=maxSpeed*2;
			elast=0.5;
			isFly=true;
			plaKap=true;
		}

		//сделать героем
		public override function setHero(nhero:int=1) {
			super.setHero(nhero);
			if (hero==1) {
				vis.osn.scaleX=vis.osn.scaleY=vis.osn.scaleX*1.2;
				runSpeed=maxSpeed*2.5;
			}
		}
		
		public override function setNull(f:Boolean=false) {
			super.setNull(f);
			if (f) {
				aiState=aiSpok=0;
				aiTCh=Math.floor(Math.random()*10)+5;
			}
		}
		
		public override function animate() {
				if (sost==2 || sost==3) { //сдох
					if (animState!='die') {
						vis.osn.gotoAndStop('die');
						animState='die';
					}
				} else if (aiState==0) {
					if (animState!='stay') {
						vis.osn.gotoAndStop('stay');
						animState='stay';
					}
				} else if (aiState==6) {
					if (animState!='attack') {
						vis.osn.gotoAndStop('attack');
						animState='attack';
					}
				} else {
					if (animState!='fly') {
						vis.osn.gotoAndStop('fly');
						animState='fly';
					}
				}
			//vis.gotoAndStop(aiState+1);
		}
		public override function alarma(nx:Number=-1,ny:Number=-1) {
			super.alarma(nx,ny);
			if (sost==1 && aiState<=1) {
				aiSpok=maxSpok-1;
				aiState=2;
				budilo(250);
			}
		}

		var aiDx:Number=0, aiDy:Number=0, aiRasst:Number;
		
		//состояния
		//0 - неподвижен
		//2 - не видит цели
		//3 - видит цель, летит к ней
		//4 - атакует или ранен
		//5 - готовится к рывку
		//6 - рывок
		
		public override function control() {
			if (sost>=3) return;
			if (World.w.enemyAct<=0) {
				return;
			}
			if (stun) {
				return;
			}
			if (aiTCh>0) aiTCh--;		//счётчик смены состояний
			else {						//смена состояний
				if (aiState==6) {	
					aiState=4;
					aiTCh=Math.floor(Math.random()*100)+100;
				} else if (aiState==5) {	
					aiState=6;
					aiTCh=20;
				} else if (aiSpok==0) {	//перейти в пассивный режим
					if (aiState>1)	{
						aiState=1;
						aiDx=isrnd()?0.7:-0.7;
						aiDy=-0.7;
						if (aiDx>0) storona=1; else storona=-1;
					}
					aiTCh=10;
				} else if (aiSpok>=maxSpok) {	//агрессивный
					if (aiRasst<380) {
						if (!isPlav && isrnd()) {
							aiState=5;
							aiTCh=20;
						} else {
							aiState=4;
							aiTCh=Math.floor(Math.random()*100)+100;
						}
					} else {
						aiState=(hp<maxhp)?4:3;
						aiTCh=Math.floor(Math.random()*100)+100;
					}
				} else {	//режим поиска
					aiState=2;
					aiTCh=Math.floor(Math.random()*100)+100;
				}
			}
			//поиск цели
			if (World.w.enemyAct>1 && aiTCh%10==1 && aiState<6) {
				if (findCel()) {
					aiSpok=maxSpok+10;
					if (aiState<5) aiState=(hp<maxhp)?4:3;
				} else {
					if (aiSpok>0) aiSpok--;
				}
				if (aiState==2 || aiState==3 || aiState==4 || aiState==5) {
					if (celX!=X || celY!=Y-scY/2) {
						aiDx=celX-X;
						aiDy=celY-(Y-scY/2);
					}
					if (aiDx>0) storona=1; else storona=-1;
					aiRasst=Math.sqrt(aiDx*aiDx+aiDy*aiDy)+0.00001;
					aiDx=aiDx/aiRasst;
					aiDy=aiDy/aiRasst;
				}
			}
			if (isPlav) {
				turnY=-1;
				aiState=1;
			}
			
			/*if (disabled) {
				aiState=0;
				return;
			}*/
			vision=(aiState==0)?0.4:1;
			ear=(aiState==0)?0.6:1;
	
				if (turnX) {
					storona=turnX;
					aiDx=Math.abs(aiDx)*turnX;
					turnX=0;
				}
				if (turnY) {
					if (turnY==1 && aiState==1) {
						dx=aiDx=0;
						dy=aiDy=0;
						aiSpok=aiState=0;
					} else {
						aiDy=Math.abs(aiDy)*turnY;
					}
					turnY=0;
				}
			if (aiState==1 || aiState==2 || aiState==3 || aiState==4) {
				maxSpeed=(aiState==4)?runSpeed:walkSpeed;
				if (isPlav) {
					dx+=aiDx*accel*0.3;
					dy+=aiDy*accel*0.3;
				} else {
					dx+=aiDx*accel+Math.random()*2-1;
					dy+=aiDy*accel+Math.random()*2-1;
				}
			} else if (aiState==5) {
				maxSpeed=0;
			} else if (aiState==6) {
				maxSpeed=runSpeed*2.5;
				dx+=aiDx*accel*3;
				dy+=aiDy*accel*3;
			}
			
			if (World.w.enemyAct>=3) {
				if (aiState==3 && shok<=0 && isrnd(0.1)) attKorp(celUnit);
				if (aiState==4 && shok<=0) attKorp(celUnit);
				if (aiState==6) {
					if (attKorp(celUnit,2) && !celUnit.invulner) celUnit.cut+=dam/3;
				}
			}
		}
	}
	
}

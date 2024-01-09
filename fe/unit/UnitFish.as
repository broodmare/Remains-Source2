package fe.unit {
	
	import fe.*;
	public class UnitFish extends Unit{
		
		public var tr:int;
		
		public function UnitFish(cid:String=null, ndif:Number=100, xml:XML=null, loadObj:Object=null) {
			super(cid, ndif, xml, loadObj);
			if (loadObj && loadObj.tr) {			//из загружаемого объекта
				tr=loadObj.tr;
			} else if (xml && xml.@tr.length()) {	//из настроек карты
				tr=xml.@tr;
			} else if (cid) {						//из заданного идентификатора cid
				tr=int(cid);
			} else {								//случайно по параметру ndif
				tr=1;
			}
			id='fish'+tr;
			vis=Res.getVis('visualFish'+tr, visualFish1); 
			vis.osn.gotoAndStop('stay');
			getXmlParam();
			maxSpeed+=Math.random()*2-1;
			walkSpeed=maxSpeed;
			runSpeed=maxSpeed*2;
			aiState=1;
			aiDx=storona;
			elast=0.2;
			throu=true;
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
					vis.osn.rotation=0;
				} else if (isPlav) {
					if (aiState<=1) {
						if (animState!='plav') {
							vis.osn.gotoAndStop('plav');
							animState='plav';
						}
					} else if (aiState==6) {
						if (animState!='attack') {
							vis.osn.gotoAndStop('attack');
							animState='attack';
						}
					} else {
						if (animState!='run') {
							vis.osn.gotoAndStop('run');
							animState='run';
						}
					}
					vis.osn.rotation=dy*3;
				} else {
					if (animState!='stay') {
						vis.osn.gotoAndStop('stay');
						animState='stay';
					}
					vis.osn.rotation=dy*4;
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
		public function jump() {
			if (stay) {		//прыжок
				dy=-jumpdy*Math.random();
				dx=jumpdy*(Math.random()-0.5)*0.5;
			}
		}

		var aiDx:Number=0, aiDy:Number=0, aiRasst:Number;
		
		//состояния
		//0 - неподвижен
		//1 - плавает
		//2 - не видит цели
		//3 - видит цель, плывёт к ней
		//4 - атакует
		//5 - готовится к рывку
		//6 - рывок
		//7 - на берегу
		
		public override function control() {
			if (sost>=3) {
				ddyPlav=-0.2;
				return;
			}
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
				} else if (aiState==7 && isPlav) {	
					aiState=4;
					aiTCh=Math.floor(Math.random()*100)+100;
				} else if (aiState==5) {	
					aiState=6;
					aiTCh=20;
				} else if (aiSpok==0) {	//перейти в пассивный режим
					aiState=Math.floor(Math.random()*2);
					//if (aiState>1)	{
						aiDx=isrnd()?1:-1;
						if (aiDx>0) storona=1; else storona=-1;
					//}
					aiDy=Math.random()*0.2+0.1
					aiTCh=Math.floor(Math.random()*50)+40;
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
				if (findCel() && celUnit && celUnit.inWater) {
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
			if (!isPlav && aiTCh%10==1) {
				aiDy=Math.abs(aiDy);
				aiState==7;
				if (stay) {
					jump();
				}
			}
			

				if (turnX) {
					storona=turnX;
					aiDx=Math.abs(aiDx)*turnX;
					turnX=0;
				}
				if (turnY) {
					aiDy=Math.abs(aiDy)*turnY;
					turnY=0;
				}
			if (aiState==1) {
				maxSpeed=walkSpeed/5;
				if (isPlav) {
					dx+=aiDx*accel*0.2;
					dy+=aiDy*accel*0.2;
				}
			} else if(aiState==2 || aiState==3 || aiState==4 || aiState==8) {
				maxSpeed=(aiState==4)?runSpeed:walkSpeed;
				if (aiState==8) maxSpeed=walkSpeed/2;
				if (isPlav) {
					dx+=aiDx*accel;
					dy+=aiDy*accel;
				}
			} else if (aiState==5) {
				maxSpeed=0;
			} else if (aiState==6) {
				maxSpeed=runSpeed*2.5;
				dx+=aiDx*accel*3;
				dy+=aiDy*accel*3;
			}
			
			if ((aiState==3 || aiState==4 || aiState==7) && shok<=0 || aiState==6) {
				if (attKorp(celUnit, (aiState==6)?2:1) && isrnd(0.25)) {
					aiState=8;
					setCel(null,celX+Math.random()*800-400,celY+Math.random()*800-400);
					aiTCh=40;
				}
			}
		}
	}
	
}

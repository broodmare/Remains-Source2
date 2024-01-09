package fe.unit {
	
	import fe.*;
	import fe.weapon.Weapon;
	import fe.weapon.Bullet;
	import fe.serv.LootGen;
	import fe.graph.Emitter;
	public class UnitAIRobot extends UnitPon{

		public var tr:int=0;
		var weap:String;
		var isPort:Boolean=false;
		public var stroll:Boolean=true;		//патрулирует в спокойном состоянии
		public var quiet:Boolean=false;		//молчит
		var t_port:int=0;
		var kol_port:int=5;
		
		public function UnitAIRobot(cid:String=null, ndif:Number=100, xml:XML=null, loadObj:Object=null) {
			super(cid, ndif, xml, loadObj);
			//определить разновидность tr
			if (loadObj && loadObj.tr) {			//из загружаемого объекта
				tr=loadObj.tr;
			} else if (xml && xml.@tr.length()) {	//из настроек карты
				tr=xml.@tr;
			} else if (cid) {						//из заданного идентификатора cid
				tr=int(cid);
			} else {								//случайно по параметру ndif
				tr=0;
			}
			if (aiTip=='quiet') {
				stroll=false;
				quiet=true;
			}
			
			mat=1;
			acidDey=1;
			blood=0;
			aiNapr=storona;
			t_replic=Math.random()*100-50;
		}
		
		//сделать героем
		public override function setHero(nhero:int=1) {
			super.setHero(nhero);
			if (hero==1) {
				kol_port=20;
			}
		}
		
		//дать оружие
		public function getWeapon(ndif:int, xml:XML=null, loadObj:Object=null) {
			if (loadObj && loadObj.weap) {
				if (loadObj.weap!='') currentWeapon=Weapon.create(this,loadObj.weap);
			} else currentWeapon=getXmlWeapon(ndif);
			if (currentWeapon) weap=currentWeapon.id;
			else weap='';
			if (currentWeapon) {
				childObjs=new Array(currentWeapon);
				currentWeapon.hold=currentWeapon.holder;
			}
		}
		
		public override function save():Object {
			var obj:Object=super.save();
			if (obj==null) obj=new Object();
			obj.tr=tr;
			obj.weap=weap;
			return obj;
		}	

		public override function expl()	{
			newPart('metal',4);
			newPart('miniexpl');
		}
		
		public override function damage(dam:Number, tip:int, bul:Bullet=null, tt:Boolean=false):Number {
			if (sost==1) {
				if (aiState<=1) budilo();
			}
			return super.damage(dam, tip, bul,tt);
		}
				
		public override function budilo(rad:Number=500) {
			super.budilo(rad);
			loc.robocellActivate();
		}

		public override function alarma(nx:Number=-1,ny:Number=-1) {
			if (sost==1 && aiState<=1) {
				super.alarma(nx,ny);
				aiSpok=maxSpok+10;
				aiState=3;
				shok=Math.floor(Math.random()*15+5);
			}
		}
		

		var aiAttackT:int=80, aiAttackOch:int=100;	//стрельба очередью
		var aiDist:int=1000; //минимальная дистанция
		
		//aiState
		//0 - стоит на месте
		//1 - ходит туда-сюда
		//2 - не видит цели, бегает и ищет цель
		//3 - видит цель, бегает, атакует
		//4 - стоит на месте и стреляет
		//5 - увидел цель, тупит какое-то время
		
		public override function control() {
			//var t:Tile;
			//если сдох, то не двигаться
			if (sost==3) return;
			if (levit) {
				if (aiState<=1) {
					shok=15;
					aiState=3;
					budilo();
				}
				replic('levit');
			}
			if (stun) {
				aiState=0; aiTCh=3; walk=0;
			}

			if (t_port>0) t_port--;
			t_replic--;
			var jmp:Number=0;
			//return;
			
			if (World.w.enemyAct<=0) {
				celY=Y-scY;
				celX=X+scX*storona*2;
				return;
			}
			
			//таймер смены состояний
			if (aiTCh>0) aiTCh--;
			else if (aiState==5) {
				if (celUnit) {
					replic('attack');
					aiSpok=maxSpok+10;
					aiState=3;
				} else {
					aiState=1;
				}
			} else {
				if (aiSpok==0) {
					if (aiState>1) replic('vse');
					if (stroll)	aiState=Math.floor(Math.random()*2);
					else aiState=0;
					kol_port=5;
				}
				if (aiSpok>0) aiState=2;
				if (aiSpok>=maxSpok) {
					if (aiState!=3 && aiState!=4) budilo();
					if (aiSpok>=maxSpok+2 && (celDX*celDX+celDY*celDY<aiDist*aiDist)) aiState=isrnd(0.3)?3:4;
					else aiState=3;
				}
				if (aiState<=1) aiTCh=Math.floor(Math.random()*50)+40;
				else if (aiState==4) aiTCh=Math.floor(Math.random()*10)+10;
				else aiTCh=Math.floor(Math.random()*100)+100;
			}
			//поиск цели
			//trace(aiState)
			if (World.w.enemyAct>1 && aiTCh%10==1) {
				if (findCel(aiState>1)) {
					//увидели
					if (celUnit) {
						if (aiState<=1) {
							aiState=5;
							aiTCh=Math.floor(Math.random()*30)+20;
						} else {
							replic('attack');
							aiSpok=maxSpok+10;
						}
					//услышали
					} else {
						replic('ear');
						aiSpok=maxSpok-1;
					}
				} else {
					if (aiSpok%5==1) setCel(null, celX+Math.random()*80-40, celY+Math.random()*80-40);
					if (aiSpok>0) {
						aiSpok--;
					} else {
						setCel(null, X+storona*100, Y-scY*0.75);
					}
					if (aiSpok<maxSpok && aiSpok>0) {
						replic('find');
					}
				}
			}
			
			//направление
			celDX=celX-X;
			celDY=celY-Y+scY;
			if (celDY>40) aiVNapr=1;		//вниз
			else if(celDY<-40) aiVNapr=-1;	//прыжок
			else aiVNapr=0;

			//в возбуждённом состоянии наблюдательность увеличивается
			
			//скорость
			maxSpeed=walkSpeed;
			if (aiState==2) {
				maxSpeed=runSpeed;
			} else if (aiState==1 || aiState==0) {
				maxSpeed=sitSpeed;
			} 

			if (isPort && isPlav && t_port<=0) actPort(celUnit==null);
			
			if ((aiState==0 || aiState==1)  && aiTCh%30==1 && isrnd(0.02)) replic('neutral');
			//поведение при различных состояниях
			if (aiState==0) {
				if (stay && shX1>0.5 && aiNapr<0) turnX=1;
				if (stay && shX2>0.5 && aiNapr>0) turnX=-1;
				if (isPlav && plav) jump();
			} if (aiState==1) {
				//бегаем туда-сюда
				if (aiNapr==-1) {
					if (dx>-maxSpeed) dx-=accel;
				} else {
					if (dx<maxSpeed) dx+=accel;
				}
				//поворачиваем, если впереди некуда бежать
				if (stay && shX1>0.5 && aiNapr<0) {
					turnX=1;
				}
				if (stay && shX2>0.5 && aiNapr>0) {
					turnX=-1;
				}
				//если повернули, то можем остановиться
				if (stay && turnX!=0) {
					if (turnX*storona<0 && currentWeapon) {
						if (currentWeapon.rot>0) currentWeapon.rot=Math.PI-currentWeapon.rot;
						else currentWeapon.rot=-Math.PI-currentWeapon.rot;
					}
					aiNapr=storona=turnX;
					turnX=0;
				}
				//в возбуждённом или атакующем состоянии
			} else if (aiState==2 || aiState==3) {
				//определить, куда двигаться
				if (aiTCh%15==1) {
					if (isrnd(0.9)) {
						if (celDY>80) throu=true;
					} else {
						throu=false;
						jmp=0;
					}
					if (isrnd(0.5)) {
						if (celDX>100) aiNapr=1;
						if (celDX<-100) aiNapr=-1;
					}
					if (celDX>40) storona=1;
					if (celDX<-40) storona=-1;
				}
				if (isPort && aiState==2 && celUnit==null && t_port<=0 && kol_port>0) actPort();
				if (aiState==2 && aiVNapr<0 && t_port<=0) jmp=1; //(aiState==2 || ) && 
				else jmp=0;
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
					if (pumpObj && pumpObj.door) {		//наткнулся на дверь, открыть
						if (pumpObj.lock==0 && pumpObj.active && pumpObj.action==1) {//&& Math.abs(pumpObj.X-X)<150 && Math.abs(pumpObj.Y-Y)<100
							pumpObj.open=true;
							pumpObj.setDoor();
						}
					}
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
					
				}
				pumpObj=null;
			} else if (aiState==4 || aiState==3) {
				storona=(celX>X)?1:-1;
			}
			
			if (Y>loc.spaceY*World.tileY-80) throu=false;
			
			if ((aiState==3 || aiState==4) && World.w.enemyAct>=3) attack();

		}
		
		public function actPort(rnd:Boolean=false) {
			var cel:Unit=World.w.gg;
			//var dx:Number=0, dy:Number=0;
			var nx:Number=0;
			var ny:Number=0;
			for (var i=1; i<=20; i++) {
				if (i<5 && !rnd) {
					if (isrnd(0.7)) nx=cel.X-cel.storona*(Math.random()*300+200);
					else nx=cel.X+cel.storona*(Math.random()*300+200);
					ny=cel.Y;
				} else if (i<10 && !rnd) {
					if (isrnd()) nx=cel.X-cel.storona*(Math.random()*800+200);
					else  nx=cel.X+cel.storona*(Math.random()*800+200);
					ny=cel.Y+Math.random()*160-80;
				} else {
					nx=Math.random()*loc.limX;
					ny=Math.random()*loc.limY;
				}
				nx=Math.round(nx/World.tileX)*World.tileX
				ny=Math.ceil(ny/World.tileY)*World.tileY-1;
				if (nx<scX) nx=scX;
				if (ny<scY+40) ny=scY+40;
				if (nx>loc.limX-scX) nx=loc.limX-scX;
				if (ny>loc.limY-40) ny=loc.limY-40;
				if (!collisionAll(nx-X, ny-Y)) {
					teleport(nx,ny,1);
					dx=dy=0;
					setWeaponPos();
					if (findCel(true) && celUnit) {
						aiSpok=0;
						aiState=5;
						storona=(celX>X)?1:-1;
						aiTCh=Math.floor(Math.random()*30)+20;
						t_port=Math.floor(Math.random()*90+150);
					} else {
						t_port=Math.floor(Math.random()*90+30);
					}
					kol_port--;
					return;
				}
			}
		}
		
		//прыжок
		public function jump(v:Number=1) {
			if (stay) {		
				dy=-jumpdy*v;
			}
		}
		
		//атака
		public function attack() {
			if (aiAttackOch==0 && shok<=0 && isrnd(0.1)) currentWeapon.attack();	//стрельба одиночными
			if (aiAttackOch>0) {										//стрельба очередями
				if (aiAttackT<=0) aiAttackT=Math.round((Math.random()*0.4+0.8)*aiAttackOch);
				if (aiAttackT>aiAttackOch*0.25) currentWeapon.attack();
				aiAttackT--;
			}
		}
	}
	
}

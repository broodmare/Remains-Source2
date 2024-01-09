package fe.unit {
	
	import fe.*;
	import fe.serv.BlitAnim;
	import fe.loc.Tile;
	import fe.weapon.WPunch;
	
	public class UnitMonstrik extends Unit{

		var optDistAtt:int=100;
		var optJumping:Boolean=false;
		var optJumpAtt:Boolean=true;
		var optAnimAtt:Boolean=false;
		var t_punch:int=0;
		
		public function UnitMonstrik(cid:String=null, ndif:Number=100, xml:XML=null, loadObj:Object=null) {
			super(cid, ndif, xml, loadObj);
			id=cid;
			if (id=='scorp') id+=Math.floor(Math.random()*2+1);
			getXmlParam();
			initBlit();
			animState='stay';
			maxSpeed=maxSpeed*(0.9+Math.random()*0.2);
			sitSpeed=maxSpeed;
			walkSpeed=maxSpeed;
			plavdy=accel;
			
			
			if (id=='rat') {
				optJumping=true;
			}
			if (id=='molerat') {
				optJumping=true;
			}
			if (id=='scorp1') {
				optJumpAtt=false;
				optAnimAtt=true;
				currentWeapon=new WPunch(this,'scorppunch');
				childObjs=new Array(currentWeapon);
			}
			if (id=='scorp2') {
				optJumpAtt=false;
				optAnimAtt=true;
				currentWeapon=new WPunch(this,'scorp2punch');
				childObjs=new Array(currentWeapon);
			}
			if (id=='scorp3') {
				optJumpAtt=false;
				optAnimAtt=true;
				currentWeapon=new WPunch(this,'scorp3punch');
				childObjs=new Array(currentWeapon);
			}
			aiNapr=storona;
		}

		//сделать героем
		public override function setHero(nhero:int=1) {
			super.setHero(nhero);
			if (hero==1) {
				hp=maxhp=maxhp*2;
			}
		}
		
		public override function alarma(nx:Number=-1,ny:Number=-1) {
			if (sost==1 && aiState<=1) {
				super.alarma(nx,ny);
				aiSpok=maxSpok;
				aiState=2;
				shok=Math.floor(Math.random()*5+3);
				budilo(250);
			}
		}
		
		public override function expl()	{
			super.expl();
			if (id=='tarakan') {
				newPart('shmatok',2,1);
				//newPart('bloat_kap',Math.floor(Math.random()*3+4));
			}
		}
		
		public override function animate() {
			var cframe:int;
			if (trup && (sost==2 || sost==3)) { //сдох
				if (stay && animState!='death') {
					animState='die';
				} else animState='death';
			} else if (t_punch>0){
				animState='attack';
				if (t_punch==15) anims[animState].restart();
			} else {
				if (stay) {
					if  (dx==0) {
						animState='stay';
					} else if  (dx>5 || dx<-5) animState='run';
					else  animState='walk';
				} else if (aiPlav || levit) {
					animState='plav';
				} else {
					animState='jump';
					//anims[animState].setStab((dy+5)/10);
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
		
		public function jump(v:Number=1) {
			if (stay) {		//прыжок
				dy=-jumpdy*v;
				dx+=storona*accel*5;
			}
			if (!isPlav&&aiPlav) dy=-jumpdy*0.6;	//выпрыгивание из воды
			if (isPlav) {
				dy-=plavdy;
			}
		}
		
		var aiVis=0.5;
		
		//aiState
		//0 - стоит на месте
		//1 - ходит туда-сюда
		//2 - видит цель, бежит к ней, атакует
		//3 - атакует оружием
		
		public override function control() {
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
			//return;
			
			if (World.w.enemyAct<=0) {
				celY=Y-scY;
				celX=X+scX*storona*2;
				return;
			}
			
			//таймер смены состояний
			if (aiTCh>0) aiTCh--;
			else {
				if (aiSpok==0) {
					aiState=Math.floor(Math.random()*2);
					storona=aiNapr;
				}
				if (aiSpok>0) aiState=2;
				aiTCh=Math.floor(Math.random()*50)+40;
			}
			//атаковать оружием
			if (optAnimAtt && aiState==2 && celUnit && celDY<40 && celDY>-80 && celDX<80 && celDX>-80 && isrnd(0.7)) {
				aiState=3;
				aiTCh=15;
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
			//в возбуждённом состоянии наблюдательность увеличивается
			if (aiSpok==0) {
				vision=aiVis/2;
				celY=Y-scY;
				celX=X+scX*storona*2;
			} else {
				vision=aiVis;
			}
			
			//поведение в воде
			if (isPlav && aiState==0) aiState=1;
			if (aiPlav>0) aiPlav--;
			if (isPlav) aiPlav=5;
			
			//скорость
			maxSpeed=walkSpeed;
			if (aiState==2) {
				maxSpeed=runSpeed;
			}
			if (dx*diagon>0) maxSpeed*=0.5;
			walk=0;

			//if (id=='molerat') trace(maxSpeed,dx, aiState);
			//поведение при различных состояниях
			if (aiState==0) {
				if (stay && shX1>0.5 && aiNapr<0) turnX=1;
				if (stay && shX2>0.5 && aiNapr>0) turnX=-1;
				if (isPlav) jump();
			} if (aiState==1) {
				if (aiNapr==-1) {
					if (dx>-maxSpeed) dx-=accel;
					walk=-1;
				} else {
					if (dx<maxSpeed) dx+=accel;
					walk=1;
				}
				//поворачиваем, если впереди некуда бежать
				if (stay && shX1>0.5 && aiNapr<0) {
					if (optJumping && isrnd(0.1)) {
						t=loc.getAbsTile(X+storona*80,Y+10);
						if (t.phis==1 || t.shelf) {
							jump(0.5);
						} else turnX=1;
					} else turnX=1;
				}
				if (stay && shX2>0.5 && aiNapr>0) {
					if (optJumping && isrnd(0.1)) {
						t=loc.getAbsTile(X+storona*80,Y+10);
						if (t.phis==1 || t.shelf) {
							jump(0.5);
						} else turnX=-1;
					} else turnX=-1;
				}
				if (stay && turnX!=0) {
					aiNapr=storona=turnX;
					turnX=0;
				}
				//в воде всплываем
				if (isPlav) {
					jump();
					if (turnX!=0) {
						aiNapr=storona=turnX;
						turnX=0;
					}
				}
				//в возбуждённом или атакующем состоянии
			} else if (aiState==2) {
				//определить, куда двигаться
				if (aiTCh%10==1) {
					if (isrnd(0.9)) {
						if (celDY>80) throu=true;
						if (optJumping && aiVNapr<0 && isrnd()) jmp=1;
					} else {
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
				if (levit) {
					if (aiNapr==-1) {
						if (dx>-maxSpeed) dx-=levitaccel;
					} else  if (aiNapr==1){
						if (dx<maxSpeed) dx+=levitaccel;
					}
				} else if (stay || isPlav) {
					if (aiNapr==-1) {
						if (dx>-maxSpeed) dx-=accel;
						walk=-1;
					} else if (aiNapr==1){
						if (dx<maxSpeed) dx+=accel;
						walk=1;
					}
				} else {
					if (aiNapr==-1) {
						if (dx>-maxSpeed) dx-=accel/4;
					} else  if (aiNapr==1){
						if (dx<maxSpeed) dx+=accel/4;
					}
				}
				if (optJumping && stay && isrnd(0.5) && aiVNapr<=0 && (shX1>0.5 && aiNapr<0 || shX2>0.5 && aiNapr>0)) jmp=0.5;
				//если наткнулся на препятствие
				if (turnX!=0) {
					if (celDX*aiNapr<0) {				//повернуться, если цель сзади
						aiNapr=storona=turnX;
					} else {							//попытаться перепрыгнуть
						aiTTurn--;
						if (isrnd(0.03) || turnY>0 || kray) aiTTurn-=10;
						else jmp=1;
						kray=false;
						if (aiTTurn<0) {
							aiNapr=storona=turnX;
							aiTTurn=Math.floor(Math.random()*20)+5;
						}
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
			} else if (aiState==3) {
				if (t_punch==0) {
					if (celDY<-40) {
						jump();
						dx=walk*1.5;
					}
					currentWeapon.attack();
					t_punch=15;
				}
			}
			
			if (Y>loc.spaceY*World.tileY-80) throu=false;
		}
		
		public function attack() {
			if (celUnit && shok<=0) {	//атака холодным оружием без левитации или корпусом
				attKorp(celUnit,1);
			}
			if (optJumpAtt) jump(0.5);
		}

		
	}
	
}

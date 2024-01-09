package fe.unit {
	
	import fe.*;
	import fe.weapon.Weapon;
	import fe.serv.LootGen;
	import fe.loc.Location;
	import fe.weapon.Bullet;
	import fe.loc.Tile;

	public class UnitMsp extends Unit{

		public var tr:int;
		var weap:String;
		var cep:int=0; //способ прикрепления 0-обычный, 1-к потолку, 2- к стене слева, 3-к стене справа
		
		public function UnitMsp(cid:String=null, ndif:Number=100, xml:XML=null, loadObj:Object=null) {
			super(cid, ndif, xml, loadObj);
			//определить разновидность tr
			if (loadObj && loadObj.tr) {			//из загружаемого объекта
				tr=loadObj.tr;
			} else if (xml && xml.@tr.length()) {	//из настроек карты
				tr=xml.@tr;
			} else if (cid) {						//из заданного идентификатора cid
				tr=int(cid);
			} else {								//случайно по параметру ndif
				tr=1;
			}
			id='msp';
			
			vis=new visualMsp();
			vis.stop();
			//vis.osn.gotoAndStop(1);
			
			getXmlParam();
			
			mat=1;
			aiNapr=storona;
			t_replic=Math.random()*100-50;
		}

		//поместить созданный юнит в локацию
		public override function putLoc(nloc:Location, nx:Number, ny:Number) {
			if (nloc.getAbsTile(nx, ny+10).phis==0) {
				if (nloc.getAbsTile(nx, ny-50).phis) {
					cep=1;
					ny-=40-scY-1
					fixed=true;
				} else if (nloc.getAbsTile(nx-40, ny-10).phis) {
					cep=2;
					nx-=(40-scX)/2-1;
					fixed=true;
				} else if (nloc.getAbsTile(nx+40, ny-10).phis) {
					cep=3;
					nx+=(40-scX)/2-1;
					fixed=true;
				}
			}
			super.putLoc(nloc, nx, ny);
		}

		public override function expl()	{
			newPart('metal',4);
			newPart('miniexpl');
		}
		
		public override function setVisPos() {
			if (vis) {
				if (cep==0) {
					vis.x=X,vis.y=Y;
					vis.rotation=0;
				} else if (cep==1) {
					vis.x=X;
					vis.y=Y1;
					vis.rotation=180;
				} else if (cep==3) {
					vis.x=X2;
					vis.y=Y-scY/2;
					vis.rotation=-90;
				} else if (cep==2) {
					vis.x=X1;
					vis.y=Y-scY/2;
					vis.rotation=90;
				}
				vis.scaleX=storona;
			}
		}
		
		public override function animate() {
			vis.gotoAndStop(aiState);
			if (aiState==0 || aiState==1) { //сдох
				if (animState!='stay') {
					vis.osn.gotoAndStop('stay');
					animState='stay';
				}
			} else if (aiState==2 || aiState==4) {
				if (animState!='wake') {
					vis.osn.gotoAndStop('wake');
					animState='wake';
				}
			} else if (stay || levit){
				if (animState!='walk') {
					vis.osn.gotoAndStop('walk');
					animState='walk';
				}
			} else {
				if (animState!='jump') {
					vis.osn.gotoAndStop('jump');
					animState='jump';
				}
			} 
		}
		
		public function jump(v:Number=1) {
			if (stay) {		//прыжок
				dy=-jumpdy*v;
			}
			
		}
		public override function dropLoot() {
			explosion(dam,tipDamage,150,0,20,30,9);
		}
		public override function setLevel(nlevel:int=0) {
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
			}
			if (stun) {
				aiState=0; aiTCh=3; walk=0;
			}

			var jmp:Number=0;
			
			if (World.w.enemyAct<=0) {
				celY=Y-scY;
				celX=X+scX*storona*2;
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
					celDX=celX-X;
					if (celDX>40) aiNapr=1;
					if (celDX<-40) aiNapr=-1;
					aiState=3;
				} else {
					aiState=1;
				}
			} else {
				if (aiSpok<=0) {
					aiState=1;
					aiTCh=Math.floor(Math.random()*40)+40;
				} else {
					aiTCh=Math.floor(Math.random()*50)+40;
				}
				if (aiSpok>0) aiState=4;
				if (aiSpok>=maxSpok) aiState=3;
			}
			//поиск цели
			if (World.w.enemyAct>1 && aiTCh%10==1) {
				if (findCel()) {
					if (aiState<=1) {
						aiState=2;
						aiTCh=Math.floor(Math.random()*10)+30;
					} else if (aiState>=3) {
						aiState=3;
					}
				} else {
					if (aiSpok>0) {
						aiSpok--;
					}
				}
			}
			
			if (fixed) return;
			
			//направление
			celDX=celX-X;
			celDY=celY-Y+scY;
			if (celDY>40) aiVNapr=1;		//вниз
			else if(celDY<-40) aiVNapr=-1;	//прыжок
			else aiVNapr=0;

			//поведение при различных состояниях
			if (aiState==3) {
				//определить, куда двигаться
				if (aiTCh%15==1) {
					if (isrnd(0.9)) {
						if (celDY>80) throu=true;
						if (aiVNapr<0 && isrnd(0.2)) jmp=1;
					} else {
						throu=false;
						jmp=0;
					}
					if (celDX>40) aiNapr=1;
					if (celDX<-40) aiNapr=-1;
					storona=aiNapr;
				}
				if (levit) {
					if (aiNapr==-1) {
						if (dx>-maxSpeed) dx-=levitaccel;
					} else {
						if (dx<maxSpeed) dx+=levitaccel;
					}
				} else {
					if (aiNapr==-1) {
						walk=-1;
						if (dx>-maxSpeed) dx-=accel;
					} else {
						walk=1;
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
				if (celUnit) {
					if ((X-celUnit.X)*(X-celUnit.X)+(Y-celUnit.Y+celUnit.scY/2)*(Y-celUnit.Y+celUnit.scY/2)<100*100) die();
				}
				pumpObj=null;
			} else {
				walk=0;
			}
			
			if (Y>loc.spaceY*World.tileY-80) throu=false;
			
			//if ((aiState==3 || aiState==4) && World.w.enemyAct>=3) attack();

		}
		
	}
	
}

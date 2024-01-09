package fe.unit {
	import fe.*;
	import fe.loc.Location;
	import fe.loc.Tile;
	
	public class UnitHellhound extends UnitPon{
		
		var vDestroy:Number;
		var nuh:Number=400;
		
		public function UnitHellhound(cid:String=null, ndif:Number=100, xml:XML=null, loadObj:Object=null) {
			super(cid, ndif, xml, loadObj);
			var tr:int=1;
			if (loadObj && loadObj.tr) {			//из загружаемого объекта
				tr=loadObj.tr;
			} else if (xml && xml.@tr.length()) {	//из настроек карты
				tr=xml.@tr;
			} else if (cid) {						//из заданного идентификатора cid
				tr=int(cid);
			} else {								//случайно по параметру ndif
				tr=1;
			}
			id='hellhound'+tr;
			getXmlParam();
			vDestroy=1000;
			walkSpeed=maxSpeed;
			lazSpeed=runSpeed*0.6;
			initBlit();
			animState='stay';
			aiNapr=storona;
			sit(true);
		}
		public override function getXmlParam(mid:String=null) {
			super.getXmlParam('hellhound');
			super.getXmlParam();
		}
		
		public override function putLoc(nloc:Location, nx:Number, ny:Number) {
			super.putLoc(nloc,nx,ny);
			unsit();
		}
		//проверка возможности прыжка
		function checkJump():Boolean {
			if (loc.getAbsTile(X,Y-85).phis!=0) return false;
			if (loc.getAbsTile(X,Y-125).phis!=0) return false;
			if (loc.getAbsTile(X+40*storona,Y-85).phis!=0) return false;
			if (loc.getAbsTile(X+40*storona,Y-125).phis!=0) return false;
			return true;
		}
		
		public function jump(v:Number=1) {
			if (stay || isLaz) {		//прыжок
				dy=-jumpdy*v;
				isLaz=0;
				aiJump=Math.floor(30+Math.random()*50);
			} else if (isPlav) {
				dy-=plavdy;
			}
		}
		
		//aiState
		//0 - стоит на месте
		//1 - ходит туда-сюда
		//2 - не видит цели, бегает и ищет цель
		//3 - видит цель, бегает, атакует
		
		var aiJump:int=0;
		var aiLaz:int=0;
		var t_laz:int=0;	//прошло времени с начала лазения
		var r_laz:int=0;	//изменений направления лазения
		
		public override function control() {
			var t:Tile;
			//если сдох, то не двигаться
			if (sost==3) {
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
			//return;
			
			if (World.w.enemyAct<=0) {
				celY=Y-scY;
				celX=X+scX*storona*2;
				return;
			}
			if (aiLaz>0) aiLaz--;
			
			/*if (aiState==5 && (kop1.phis==0 || kop2.phis==0)) {
				vykop();
			}
			
			if (digger==3) return;
			*/
			/*overLook=(aiState==5);
			ear=(aiState==5)?0:1;*/
			
			if (aiJump>0) aiJump--;
			
			//таймер смены состояний
			if (aiTCh>0) aiTCh--;
			/*else if (aiState==4) {
				superSila();
				aiState=7;
				aiTCh=20;
			} else if (aiState==7) {
				aiState=3;
				aiTCh=Math.floor(Math.random()*50)+50;
			} */else {
				if (aiSpok==0) {
					aiState=Math.floor(Math.random()*2);
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
			//trace(aiState)
			if (World.w.enemyAct>1 && aiTCh%10==1) {
				if (findCel()) {
					//увидели
					if (celUnit) {
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
				}
				if (isSit) unsit();
				//if (aiState==2 || aiState==3) findSuper();
			}
			//направление
			celDX=celX-X;
			celDY=celY-Y+scY;
			if (celDY>40) aiVNapr=1;		//вниз
			else if(celDY<-40) aiVNapr=-1;	//прыжок
			else aiVNapr=0;
			porog=10;
			if (celDY>70) porog=0;

			//в возбуждённом состоянии наблюдательность увеличивается
			if (aiSpok==0) {
				vision=0.7;
				celY=Y-scY;
				celX=X+scX*storona*2;
			} else {
				vision=1;
			}
			
			//скорость
			maxSpeed=walkSpeed;
			if (aiState==2 || aiState==3) {
				if (!isSit) maxSpeed=runSpeed;
				else maxSpeed=walkSpeed*2;
			}
			
			if (dx*diagon>0) maxSpeed*=0.5;

			if ((aiState==2 || aiState==3)&& celDY>-80 && celDY<80) {
				if (hp<=maxhp*0.3) destroy=vDestroy*5;
				else destroy=vDestroy;
			} else destroy=0;

			
			//поведение при различных состояниях
			if (aiState==0) {
				if (stay && shX1>0.5 && aiNapr<0) turnX=1;
				if (stay && shX2>0.5 && aiNapr>0) turnX=-1;
				isLaz=0;
				if (isPlav) jump();
			} else if (aiState==4) {
				if (celDX>40) aiNapr=storona=1;
				if (celDX<-40) aiNapr=storona=-1;
			} else if (aiState==1) {
				isLaz=0;
				//бегаем туда-сюда
				if (aiNapr==-1) {
					if (dx>-maxSpeed) dx-=accel;
				} else {
					if (dx<maxSpeed) dx+=accel;
				}
				//поворачиваем, если впереди некуда бежать
				if (stay && shX1>0.25 && aiNapr<0) {
					if (aiState==1 && isrnd(0.1)) {
						t=loc.getAbsTile(X+storona*80,Y+10);
						if (t.phis==1 || t.shelf) {
							jump(0.5);
						} else turnX=1;
					} else turnX=1;
				}
				if (stay && shX2>0.25 && aiNapr>0) {
					if (aiState==1 && isrnd(0.1)) {
						t=loc.getAbsTile(X+storona*80,Y+10);
						if (t.phis==1 || t.shelf) {
							jump(0.5);
						} else turnX=-1;
					} else turnX=-1;
				}
				//в возбуждённом или атакующем состоянии
			} else if (aiState==2 || aiState==3) {
				
				//определить, куда двигаться
				if (aiVNapr<0 && aiJump<=0 && aiTCh%2==1 && checkJump()) jmp=1;		//проверить возможность прыжка перед прыжком
				if (aiTCh%15==1) {
					//if (isrnd(0.3)) jmp=1;
					if (isrnd(0.8)) {
						if (celDX>100) aiNapr=storona=1;
						if (celDX<-100) aiNapr=storona=-1;
					}
				}
				if (celDY>80) throu=true;
				else throu=false;
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
				if (stay && (shX1>0.5 && aiNapr<0 || shX2>0.5 && aiNapr>0)) {
					if (aiVNapr<=0 && isrnd(0.5)) jmp=0.5;
					else if (dx>5 || dx<-5) dx*=0.6;	//притормозить перед ямой
				}
				if (jmp>0) {
					if (isPlav) jmp*=1.5;
					//if (checkJump()) {
						jump(jmp);
						jmp=0;
					//}
				}
				if (isLaz==0 && aiVNapr==-1 && aiLaz<=0 && t_laz<-30) {		//пытаться карабкаться вверх
					checkStairs();
					if (isLaz && isLaz!=0) aiLaz=30;
				}
				if (isLaz==0 && aiVNapr==1 && aiLaz<=0 && t_laz<-30) {		//пытаться карабкаться вниз
					checkStairs(2);
					if (isLaz && isLaz!=0) aiLaz=30;
				}
				if (isLaz) {
					if (t_laz<0) t_laz=0;
					t_laz++;
					sit(true);
					if (celY<Y && r_laz<=0) {
						r_laz=-1;
						if (dy>-lazSpeed) dy-=lazSpeed/3;
						else (dy=-lazSpeed);
						checkStairs();
					} else if (aiVNapr==1 && r_laz>=0) {
						r_laz=1;
						if (dy<lazSpeed) dy+=lazSpeed/3;
						else (dy=lazSpeed);
						checkStairs();
					} else {
						isLaz=0;
						if (t_laz>20 && isrnd(0.7)) jmp=0.8;
					}
					if (turnY!=0) {
						isLaz=0;
						turnY=0;
					}
				} else {
					if (t_laz>0) t_laz=0;
					t_laz--;
					r_laz=0;
				}
			}
			if (stay && aiState>0) {
				//пригнуться
				if (turnX==-1) {
					if (loc.getAbsTile(X2+2,Y1).phis && loc.getAbsTile(X2+2,Y1+40).phis==0 && loc.getAbsTile(X2+2,Y1+80).phis==0) {
						sit(true);
						turnX=0;
					}
				}
				if (turnX==1) {
					if (loc.getAbsTile(X1-2,Y1).phis && loc.getAbsTile(X1-2,Y1+40).phis==0 && loc.getAbsTile(X1-2,Y1+80).phis==0) {
						sit(true);
						turnX=0;
					}
				}
				if (turnX!=0) {
					if (aiState==1) {
						if (isrnd(0.1)) aiState=0;
						aiNapr=storona=turnX;
						turnX=0;
					} else {
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
				}
			}
			pumpObj=null;
			
			if (Y>loc.spaceY*Tile.tileY-80) throu=false;
			
			if (celUnit && celDX<100 && celDX>-100 && celDY<80 && celDY>-80 && aiState>1) {
				attKorp(celUnit,(shok<=0?1:0.5));
			} 
			
		}
		//поиск лестницы
		public override function checkStairs(ny:int=-1, nx:int=0):Boolean {
			try {
				var i=Math.floor((X+nx)/Tile.tileX);
				var j=Math.floor((Y+ny)/Tile.tileY);
				if (j>=loc.spaceY) j=loc.spaceY-1;
				if (loc.space[i][j].phis>=1) {
					isLaz=0;
					return false;
				}
				if ((loc.space[i][j] as Tile).stair) {
					isLaz=(loc.space[i][j] as Tile).stair;
				} else if (loc.getTile(i+storona,j).phis) {
					isLaz=storona;
				} else isLaz=0;
				if (isLaz!=0) {
					storona=isLaz;
					if (isLaz==-1) X=(loc.space[i][j] as Tile).phX1+scX/2;
					else X=(loc.space[i][j] as Tile).phX2-scX/2;
					X1=X-scX/2, X2=X+scX/2;
					stay=false;
					return true;
				}
			} catch (err) {
			}
			isLaz=0;
			return false;
		}
		
		public override function look(ncel:Unit, over:Boolean=true, visParam:Number=0, nDist:Number=0):Number {
			if (ncel.player && rasst2<nuh*nuh) {
				return 20;
			} else return super.look(ncel, over, visParam, nDist);
		}
		
		public override function animate() {
			var cframe:int;
			if (sost==2 || sost==3) { //сдох
				if (stay) {
					if (animState=='fall') {
					} else if (animState=='death') animState='fall';
					else animState='die';
				} else animState='death';
			} else {
				if (stay) {
					if (isSit) {
						if (stay && (dx>1 || dx<-1)) {
							animState='polz';
							//sndStep(anims[animState].f,4);
						} else {
							animState='sit';
						}
					} else {
						if (stay && (dx>6 || dx<-6)) {
							animState='run';
							//sndStep(anims[animState].f,4);
						} else if (dx>1 || dx<-1) {
							animState='walk';
						} else {
							animState='stay';
						}
					}
				} else if (isLaz) {
					animState='laz';
					sndStep(anims[animState].f,3);
				} else {
					animState='jump';
					anims[animState].setStab((dy*0.6+8)/16);
				}
			}
			//trace(animState, anims[animState])
			if (animState!=animState2) {
				anims[animState].restart();
				animState2=animState;
			}
			if (!anims[animState].st) {
				blit(anims[animState].id,anims[animState].f);
			}
			anims[animState].step();
		}
	}
}

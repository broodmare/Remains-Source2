package fe.unit {
	
	import fe.*;
	import fe.weapon.Weapon;
	import fe.graph.Emitter;
	import fe.loc.Tile;
	
	public class UnitVortex extends Unit{
		
		var spd:Object;
		var br:Number=0;
		var iskr:Emitter;

		public function UnitVortex(cid:String=null, ndif:Number=100, xml:XML=null, loadObj:Object=null) {
			super(cid, ndif, xml, loadObj);
			id='vortex';
			vis=new visualVortex();
			//vis.osn.gotoAndStop(1);
			getXmlParam();
			walkSpeed=maxSpeed;
			runSpeed=maxSpeed*3;
			isFly=true;
			mat=1;
			acidDey=1;
			elast=0.8;
			spd=new Object();
			plaKap=true;
			iskr=Emitter.arr['iskr_bul'];
			destroy=20;
			sndRunOn=true;
			sndVolkoef=0;
		}

		public override function expl()	{
			newPart('metal',4);
			newPart('miniexpl');
		}
		
		public override function forces() {
			if (isFly) {
				if (dx*dx+dy*dy>maxSpeed*maxSpeed) {
					dx*=0.95;
					dy*=0.95;
				}
				if (isPlav) {
					dy*=0.9;
					dx*=0.9;
				}
			} else super.forces();
		}
		
		public override function destroyWall(t:Tile, napr:int=0):Boolean {
			if (sost!=1) return false;
			if (destroy>0 && napr==2 || napr==1) loc.hitTile(t,destroy,(t.X+0.5)*Tile.tileX,(t.Y+0.5)*Tile.tileY,4);
			if (t.phis==0) return true;
			return false;
		}
		
		public override function setNull(f:Boolean=false) {
			super.setNull(f);
		}
		
		public override function alarma(nx:Number=-1,ny:Number=-1) {
			super.alarma(nx,ny);
			if (sost==1) {
				aiState=2;
				aiTCh=3;
			}
		}
		
		public override function animate() {
			br+=(dx*2.5-br)/4;
			vis.osn.rotation=br*storona;
		}
		
		//состояния
		//0 - летает
		//1 - видит цель, летит к ней
		//2 - потерял цель
		
		public override function control() {
			if (sost>=3) return;
			if (rasst2<800*800) {
				
			}
			if (World.w.enemyAct<=0) {
				return;
			}
			if (stun) {
				return;
			}
			if (aiTCh>0) aiTCh--;		//счётчик смены состояний
			else {						//смена состояний
				if (aiSpok==0) {	//перейти в пассивный режим
					aiState=0;
				} else if (aiSpok>=maxSpok) {	//агрессивный
					aiState=1;
				} else {
					aiState=2;
				}
				aiTCh=Math.floor(Math.random()*100)+100;
				if (aiState==0) {		//выбрать случайную цель в пассивном режиме
					if (isrnd()) {
						celX=X+(Math.random()*300+400)*(isrnd()?1:-1);
						celY=Y+Math.random()*200-100;
					} else {
						celX=X, celY=Y-scY/2;
					}
				}
			}
			//поиск цели
			if (World.w.enemyAct>1 && aiTCh%10==1) {
				if (findCel()) {
					aiSpok=maxSpok+10;
					aiState=1;
					storona=(celX>X)?1:-1;
				} else {
					if (aiSpok>0) aiSpok--;
				}
				spd.x=celX-X;
				spd.y=celY-(Y-scY/2);
				norma(spd,aiState==0?accel/2:accel);
				dx+=spd.x;
				dy+=spd.y;
			}
			
			if (aiState==0) maxSpeed=walkSpeed;
			else maxSpeed=runSpeed;
	
			if (turnX!=0) {
				iskr.cast(loc,X+15*storona,Y-15,{dx:dx, kol:Math.floor(Math.random()*5+3)});
				Snd.ps('vortex_cut',X,Y,0,sndVolkoef);
				storona=turnX;
				aiTCh=0
				turnX=0;
			}
			if (turnY!=0) {
				dy=-dy*0.5;
				turnY=0;
			}
			//атака
			if (World.w.enemyAct>=3 && aiState==1 && celUnit && shok<=0) {
				attKorp(celUnit,1);
			}
		}
	}
	
}

package fe.unit {
	
	import fe.*;
	import fe.weapon.Bullet;
	import fe.graph.Emitter;
	import fe.loc.Tile;
	
	public class UnitSpectre extends Unit{
		
		var spd:Object;
		var br:Number=0;
		var iskr:Emitter;

		public function UnitSpectre(cid:String=null, ndif:Number=100, xml:XML=null, loadObj:Object=null) {
			super(cid, ndif, xml, loadObj);
			id='spectre';
			vis=new visualSpectre();
			vis.visible=false;
			//vis.osn.gotoAndStop(1);
			getXmlParam();
			walkSpeed=maxSpeed;
			runSpeed=maxSpeed*2;
			isFly=true;
			spd=new Object();
			invulner=true;
			iskr=Emitter.arr['iskr_bul'];
			destroy=20;
			knocked=0;
			undodge=1;
			doop=true;		//не отслеживает цели
			collisionTip=0;
			levitPoss=false;
			mater=false;
			ctrans=false;
		}

		public override function forces() {
			if (isFly) {
				if (dx*dx+dy*dy>maxSpeed*maxSpeed) {
					dx*=0.8;
					dy*=0.8;
				}
				if (isPlav) {
					dy*=0.9;
					dx*=0.9;
				}
			} else super.forces();
		}
		
		public override function udarBullet(bul:Bullet, sposob:int=0):int {	
			return -1;
			
		}
		
		public override function command(com:String, val:String=null) {
			if (com=='show') {
				vis.visible=true;
				loc.lighting(X, Y);
			}
		}
		
		public override function animate() {
			br+=(dx*4-br)/4;
			vis.osn.rotation=br*storona;
		}
		
		//состояния
		//0 - ничего не делает
		//1 - летит к цели
		
		public override function control() {
			if (sost>=3) return;
			if (World.w.enemyAct<=0) {
				return;
			}
			aiTCh++;
			//поиск цели
			if (World.w.enemyAct>1 && aiTCh%10==1) {
				if (findCel() && !World.w.gg.invulner) {
					aiSpok=maxSpok+10;
					aiState=1;
					vis.visible=true;
					if (maxSpeed<runSpeed) maxSpeed+=0.01;
				} else {
					celX=World.w.gg.X
					celY=World.w.gg.Y-World.w.gg.scY/2;
				}
				storona=(celX>X)?1:-1;
			}
			
			if (aiState==1 && World.w.gg.loc==loc) {
				spd.x=celX-X;
				spd.y=celY-(Y-scY/2);
				norma(spd,accel);
				dx+=spd.x;
				dy+=spd.y;
				if (celUnit && celUnit.player && aiTCh%30==1) celUnit.addEffect('horror',1,3);
			}
	
			if (turnX!=0) {
				storona=turnX;
				aiTCh=0
				turnX=0;
			}
			if (turnY!=0) {
				dy=-dy*0.5;
				turnY=0;
			}
			//атака
			if (World.w.enemyAct>=3 && aiState==1 && celUnit && celUnit.sost==1) {
				if (attKorp(celUnit,1)) celUnit.addEffect('curse');
			}
		}
	}
	
}

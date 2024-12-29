package fe.unit {

	import fe.*;
	import fe.projectile.Bullet;
	import fe.graph.Emitter;
	
	public class UnitSpectre extends Unit {
		
		private var spd:Object;
		private var br:Number=0;
		private var iskr:Emitter;

		// Constructor
		public function UnitSpectre(cid:String=null, ndif:Number=100, xml:XML=null, loadObj:Object=null) {
			super(cid, ndif, xml, loadObj);
			id='spectre';
			vis=new visualSpectre();	// .SWF Dependency
			vis.visible=false;
			getXmlParam();
			walkSpeed = maxSpeed;
			runSpeed = maxSpeed * 2;
			isFly = true;
			spd = {};
			invulner = true;
			iskr = Emitter.arr['iskr_bul'];
			destroy = 20;
			knocked = 0;
			undodge = 1;
			doop = true;		//не отслеживает цели
			collisionTip = 0;
			levitPoss = false;
			mater = false;
			ctrans = false;
		}

		public override function forces():void {
			if (isFly) {
				if (velocity.X * velocity.X + velocity.Y * velocity.Y > maxSpeed * maxSpeed) {
					velocity.multiply(0.80);
				}
				if (isPlav) {
					velocity.multiply(0.90);
				}
			}
			else {
				super.forces();
			}
		}
		
		public override function udarBullet(bul:Bullet, sposob:int = 0):int {	
			return -1;
		}
		
		public override function command(com:String, val:String = null) {
			if (com == 'show') {
				vis.visible = true;
				loc.lighting(coordinates.X, coordinates.Y);
			}
		}
		
		public override function animate():void {
			br += (velocity.X * 4 - br) / 4;
			vis.osn.rotation=br*storona;
		}
		
		//состояния
		//0 - ничего не делает
		//1 - летит к цели
		
		override protected function control():void {
			
			if (sost>=3) {
				return;
			}

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
				}
				else {
					celX = World.w.gg.coordinates.X
					celY = World.w.gg.coordinates.Y - World.w.gg.boundingBox.halfHeight;
				}
				storona = (celX > coordinates.X)? 1:-1;
			}
			
			if (aiState==1 && World.w.gg.loc==loc) {
				spd.x = celX - coordinates.X;
				spd.y = celY - this.boundingBox.top;
				norma(spd,accel);
				velocity.X += spd.x;
				velocity.Y += spd.y;
				if (celUnit && celUnit.player && aiTCh%30==1) celUnit.addEffect('horror',1,3);
			}
	
			if (turnX != 0) {
				storona = turnX;
				aiTCh = 0
				turnX = 0;
			}

			if (turnY != 0) {
				velocity.Y = -velocity.Y * 0.5;
				turnY = 0;
			}
			//атака
			if (World.w.enemyAct >= 3 && aiState == 1 && celUnit && celUnit.sost == 1) {
				if (attKorp(celUnit, 1)) celUnit.addEffect('curse');
			}
		}
	}
}
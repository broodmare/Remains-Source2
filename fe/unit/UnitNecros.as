package fe.unit {
	
	import fe.*;
	
	public class UnitNecros extends Unit {
		
		private var spd:Object;
		private var br:Number = 0;

		// Constructor
		public function UnitNecros(cid:String=null, ndif:Number=100, xml:XML=null, loadObj:Object=null) {
			super(cid, ndif, xml, loadObj);
			id='necros';
			getXmlParam();
			walkSpeed=maxSpeed;
			runSpeed=maxSpeed*2;
			initBlit();
			isFly=true;
			spd={x:0, y:0};
			destroy=20;
			knocked=0;
			undodge=1;
			doop=true;		//не отслеживает цели
			collisionTip=0;
			transp=true;
			mater=false;
			ctrans=false;
			grav=0;
			vulner[D_NECRO]=0;
		}

		public override function forces() {
			if (isFly) {
				if (velocity.X * velocity.X + velocity.Y * velocity.Y > maxSpeed * maxSpeed || rasst2 < 10000) {
					velocity.multiply(0.80);
				}
				if (aiState!=1) {
					velocity.multiply(0.80);
				}
			} else super.forces();
		}
		
		public override function expl()	{
			newPart('black', 24);
			isFly = true;
		}
		
		public override function animate():void {
			vis.scaleX=1;
			blit(anims[animState].id,Math.floor(anims[animState].f));
			anims['stay'].step();
		}
		
		//состояния
		//0 - ничего не делает
		//1 - летит к цели
		
		override protected function control():void {
			if (sost>=3) return;
			if (World.w.enemyAct<=0) {
				return;
			}
			if (aiTCh>0) aiTCh--;		//счётчик смены состояний
			else {						//смена состояний
				if (aiSpok==0) {	//перейти в пассивный режим
					aiState=0;
				}
				else if (aiSpok>=maxSpok) {	//агрессивный
					aiState=1;
				}
				else {
					aiState=2;
				}
				aiTCh=Math.floor(Math.random()*100)+100;
				if (aiState==0) {		//выбрать случайную цель в пассивном режиме
					if (aiTip!='stay' && isrnd()) {
						celX = coordinates.X + (Math.random() * 300 + 400) * (isrnd()? 1:-1);
						if (celX < 0) celX = 200;
						if (celX > loc.maxX) celX = loc.maxX - 200;
						celY = coordinates.Y + Math.random() * 200 - 100;
						if (celY < 0) celX = 200;
						if (celY > loc.maxY) celY = loc.maxY - 200;
					}
					else {
						celX = coordinates.X;
						celY = this.boundingBox.top;
					}
				}
			}
			//поиск цели
			if (World.w.enemyAct>1 && aiTCh%10==1) {
				if (findCel()) {
					aiSpok=maxSpok+10;
					aiState=1;
					storona = (celX > coordinates.X)?1:-1;
				}
				else {
					if (aiSpok>0) aiSpok--;
				}
				spd.x = celX - coordinates.X;
				spd.y = celY - this.boundingBox.top;
				norma(spd,aiState==0?accel/2:accel);
			}

			velocity.X += spd.x;
			velocity.Y += spd.y;
			
			if (aiState==0) maxSpeed=walkSpeed;
			else maxSpeed=runSpeed;
	
			//атака
			if (World.w.enemyAct>=3 && aiState==1 && celUnit && celUnit.sost==1) {
				attKorp(celUnit,1);
			}
		}
	}	
}
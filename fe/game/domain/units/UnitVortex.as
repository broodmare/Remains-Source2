package fe.game.domain.units {

	import flash.display.MovieClip;

	import fe.engine.utils.SymbolFactory;
	import fe.engine.utils.Vec2;
	import fe.game.rendering.Emitter;
	import fe.game.domain.location.tile.Tile;
	import fe.engine.audio.Sound;
	import fe.game.World;
	import fe.game.enums.E_Material;
	import fe.game.rendering.enums.E_Decal;
	import fe.game.enums.E_Direction;
	
	public class UnitVortex extends Unit {

		private var spd:Object;
		private var br:Number = 0;
		private var iskr:Emitter;

		public function UnitVortex(cid:String=null, ndif:Number=100, xml:XML=null, loadObj:Object=null) {
			super(cid, ndif, xml, loadObj);
			id='vortex';
			vis = SymbolFactory.createInstance("visualVortex") as MovieClip;
			getXmlParam();
			walkSpeed=maxSpeed;
			runSpeed=maxSpeed*3;
			isFly=true;
			mat=E_Material.METAL;
			acidDey=1;
			elast=0.8;
			spd=new Object();
			plaKap=true;
			iskr=Emitter.arr['iskr_bul'];
			destroy=20;
			sndRunOn=true;
			sndVolkoef=0;
		}

		public override function expl():void {
			newPart('metal',4);
			newPart('miniexpl');
		}
		
		public override function forces():void {
			if (isFly) {
				if (velocity.X * velocity.X + velocity.Y * velocity.Y > maxSpeed * maxSpeed) {
					velocity.multiply(0.95);
				}
				if (isPlav) {
					velocity.multiply(0.90);
				}
			}
			else {
				super.forces();
			}
		}
		
		public override function destroyWall(t:Tile, direction:Vec2):Boolean {
			if (sost != 1) {
				return false;
			}
			if (destroy > 0 && direction == E_Direction.RIGHT || direction == E_Direction.LEFT) {
				loc.hitTile(t, destroy,(t.coords.X + 0.5) * Tile.tileX, (t.coords.Y + 0.5) * Tile.tileY, E_Decal.BLOW_SMALL);
			}
			if (t.collision == 0) {
				return true;
			}
			return false;
		}
		
		public override function setNull(f:Boolean=false):void {
			super.setNull(f);
		}
		
		public override function alarma(nx:Number=-1,ny:Number=-1):void {
			super.alarma(nx, ny);
			if (sost == 1) {
				aiState = 2;
				aiTCh = 3;
			}
		}
		
		public override function animate():void {
			br += (velocity.X * 2.5 - br) / 4;
			vis.osn.rotation = br * storona.X;
		}
		
		//состояния
		//0 - летает
		//1 - видит цель, летит к ней
		//2 - потерял цель
		
		override protected function control():void {
			if (sost >= 3) {
				return;
			}
			
			if (rasst2 < 640000) {
				
			}
			
			if (World.w.enemyAct <= 0) {
				return;
			}
			
			if (stun) {
				return;
			}
			
			if (aiTCh > 0) aiTCh--;		//счётчик смены состояний
			else {						//смена состояний
				if (aiSpok == 0) {	//перейти в пассивный режим
					aiState = 0;
				}
				else if (aiSpok >= maxSpok) {	//агрессивный
					aiState = 1;
				}
				else {
					aiState = 2;
				}
				
				aiTCh = int(Math.random() * 100) + 100;
				
				if (aiState == 0) {		//выбрать случайную цель в пассивном режиме
					if (isrnd()) {
						celX = coordinates.X + (Math.random() * 300 + 400) * (isrnd()? E_Direction.RIGHT.X : E_Direction.LEFT.X);
						celY = coordinates.Y + Math.random() * 200 - 100;
					}
					else
					{
						celX = coordinates.X;
						celY = coordinates.Y - this.boundingBox.halfHeight;
					}
				}
			}
			
			//поиск цели
			if (World.w.enemyAct>1 && aiTCh%10==1) {
				if (findCel()) {
					aiSpok = maxSpok + 10;
					aiState = 1;
					storona = (celX > coordinates.X)? E_Direction.RIGHT : E_Direction.LEFT;
				}
				else {
					if (aiSpok > 0) aiSpok--;
				}
				spd.x = celX - coordinates.X;
				spd.y = celY - (coordinates.Y - this.boundingBox.halfHeight);
				norma(spd, aiState == 0? accel / 2 : accel);
				velocity.X += spd.x;
				velocity.Y += spd.y;
			}
			
			if (aiState == 0) {
				maxSpeed = walkSpeed;
			}
			else {
				maxSpeed = runSpeed;
			}
	
			if (turnX != E_Direction.NEUTRAL) {
				iskr.cast(loc, coordinates.X + 15 * storona.X, coordinates.Y - 15, {dx:velocity.X, kol:int(Math.random() * 5 + 3)});
				Sound.ps('vortex_cut', coordinates.X, coordinates.Y, 0, sndVolkoef);
				storona = turnX;
				aiTCh = 0
				turnX = E_Direction.NEUTRAL;
			}
			if (turnY!=E_Direction.NEUTRAL) {
				velocity.Y = -velocity.Y * 0.5;
				turnY = E_Direction.NEUTRAL;
			}
			
			//атака
			if (World.w.enemyAct >= 3 && aiState == 1 && celUnit && shok <= 0) {
				attKorp(celUnit, 1);
			}
		}
	}
}

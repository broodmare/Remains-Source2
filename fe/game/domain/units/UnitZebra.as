package fe.game.domain.units {

	import fe.game.domain.serv.BlitAnim;
	import fe.game.domain.serv.AnimationSet;
	import fe.game.domain.projectile.Bullet;
	import fe.game.domain.location.tile.Tile;
	import fe.game.World;
	import fe.GameContainer;
	
	public class UnitZebra extends UnitRaider {

		private var shine:int=0;
		private var shine2:int=0;
		private var red:Boolean=false;
		
		public function UnitZebra(cid:String=null, ndif:Number=100, xml:XML=null, loadObj:Object=null) {
			parentId = "zebra";
			kolTrs = 5;
			tupizna = 10;
			visionMult = 1.3;
			durak = false;
			dash = true;
			super(cid, ndif, xml, loadObj);
			if (xml && xml.@red.length()) {
				red=true;
				shine=100;
			}
			runSpeed=maxSpeed*3;
			wPos = AnimationSet.getWeaponOffset("wPosZebra1");
		}
		
		public override function animate():void {
			super.animate();
			if (!red) {
				//невидимость
				if (shine<150 && (velocity.X > 2 || velocity.X < -2 || velocity.Y > 2 || velocity.Y < -2) && aiTCh%10==5) {
					if (showThis()) {
						if (velocity.X>10 || velocity.X<-10 || velocity.Y>10 || velocity.Y<-10) shine+=15;
						else shine+=5;
						shine2=20;
						if (attackerType == 0 && isAttacking() && shine < 100) { shine = 100; }
					}
				}
				if (sost<1) shine=100;
				if (isShoot && currentWeapon) {
					shine=currentWeapon.shine;
					isShoot=false;
				}
				if (shine2>0) shine2--;
				else if (shine>0) shine--;
				if (shine/100-vis.alpha<0.1) vis.alpha=shine/100;
				else vis.alpha+=0.1;
				if (vis.alpha>1) vis.alpha=1;
				if (hpbar) hpbar.alpha=vis.alpha;
				if (currentWeapon) currentWeapon.vis.alpha=vis.alpha;
				isVis=vis.alpha>0.5;
			}
		}
		
		override protected function control():void {
			if (shine<100 && GameContainer.reference.pers.infravis>0) shine=100;
			if (sost>1) shine=100;
			invis=(shine<15);
			super.control();
		}
		
		public override function damage(dam:Number, tip:String, bul:Bullet=null, tt:Boolean=false):Number {
			if (bul && bul.owner && bul.owner.fraction == 4) return super.damage(dam * 0.3, tip, bul, tt);	// [Take less damage from CP]
			return super.damage(dam, tip, bul, tt);
		}
		
		public function showThis():Boolean {
			//проверить линию взгляда
			var cx:Number = -(coordinates.X - GameContainer.reference.gg.eyeX);
			var cy:Number = -(coordinates.Y - this.boundingBox.height * 0.6 - GameContainer.reference.gg.eyeY);
			if (cx*cx+cy*cy>1000*1000) return false;
			var div:int = int(Math.max(Math.abs(cx),Math.abs(cy))/World.maxdelta)+1;
			for (var i:int = 1; i < div; i++) {
				var nx:Number = coordinates.X + cx*i/div;
				var ny:Number = coordinates.Y - this.boundingBox.height * 0.6 + cy * i / div;
				var t:Tile=World.w.loc.getTile(int(nx/Tile.tileX), int(ny/Tile.tileY));
				if (t.collision==1 && t.boundingBox.intersectsPoint(nx, ny)) {
					return false;
				}
			}
			return true;
		}
	}
}
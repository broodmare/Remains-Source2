package fe.unit {
	import fe.*;
	import fe.serv.BlitAnim;
	import fe.weapon.Weapon;
	import fe.weapon.Bullet;
	import fe.loc.Tile;
	import fe.graph.Emitter;
	
	public class UnitZebra extends UnitRaider{
		
		var shine:int=0;
		var shine2:int=0;
		var red:Boolean=false;
		
		public function UnitZebra(cid:String=null, ndif:Number=100, xml:XML=null, loadObj:Object=null) {
			parentId='zebra';
			kolTrs=5;
			super(cid, ndif, xml, loadObj);
			tupizna=10;
			visionMult=1.3;
			durak=false;
			dash=true;
			if (xml && xml.@red.length()) {
				red=true;
				shine=100;
			}
			runSpeed=maxSpeed*3;
			wPos=BlitAnim.wPosZebra1;
		}
		
		public override function animate() {
			super.animate();
			if (!red) {
				//невидимость
				if (shine<150 && (dx>2 || dx<-2 || dy>2 || dy<-2) && aiTCh%10==5) {
					if (showThis()) {
						if (dx>10 || dx<-10 || dy>10 || dy<-10) shine+=15;
						else shine+=5;
						shine2=20;
						if (attackerType==0 && aiAttack && shine<100) shine=100;
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
		
		public override function control() {
			if (shine<100 && World.w.pers.infravis>0) shine=100;
			if (sost>1) shine=100;
			invis=(shine<15);
			super.control();
		}
		
		public override function damage(dam:Number, tip:int, bul:Bullet=null, tt:Boolean=false):Number {
			if (bul && bul.owner && bul.owner.fraction==4) return super.damage(dam*0.3,tip,bul,tt);	//получать меньше урона от СР
			return super.damage(dam,tip,bul,tt);
		}
		
		public function showThis():Boolean {
			//проверить линию взгляда
			var cx=-(X-World.w.gg.eyeX);
			var cy=-(Y-scY*0.6-World.w.gg.eyeY);
			if (cx*cx+cy*cy>1000*1000) return false;
			var div=Math.floor(Math.max(Math.abs(cy),Math.abs(cy))/World.maxdelta)+1;
			for (var i=1; i<div; i++) {
				var nx=X+cx*i/div;
				var ny=Y-scY*0.6+cy*i/div;
				var t:Tile=World.w.loc.getTile(Math.floor(nx/Tile.tileX),Math.floor(ny/Tile.tileY));
				//Emitter.emit('marker',loc,nx,ny);
				if (t.phis==1 && nx>=t.phX1 && nx<=t.phX2 && ny>=t.phY1 && ny<=t.phY2) {
					return false;
				}
			}
			return true;
		}
	}
}

package fe.unit {
	
	import fe.*;
	import fe.loc.Location;
	import fe.entities.BoundingBox;

	public class UnitSlime extends Unit {

		private var pluh:int = 100;
		private var tr:int = 0;
		
		private var isMine:Boolean=false;
		private var explDist:Number=80;
		private var isExpl:Boolean=false;

		// Constructor
		public function UnitSlime(cid:String=null, ndif:Number=100, xml:XML=null, loadObj:Object=null) {
			
			super(cid, ndif, xml, loadObj);
			
			if (xml && xml.@tr.length()) {
				tr=xml.@tr;
			}
			else if (cid) {
				tr=int(cid);
			}
			if (tr>=10) {
				isMine=true;
				tr-=10;
			}
			if (tr==1) {
				id='cryoslime';
				vis=new visualCryoSlime();	// .SWF Dependency
			}
			else if (tr==2) {
				id='pinkslime';
				vis=new visualPinkSlime();	// .SWF Dependency
			}
			else {
				id='slime';
				vis=new visualSlime();		// .SWF Dependency
			}

			vis.gotoAndPlay(Math.floor(Math.random()*vis.totalFrames+1));
			
			if (isMine) {
				levitPoss=false;
				setVis(false);
			}
			
			getXmlParam();
			maxSpeed*=(Math.random()*0.3+0.85);
			accel*=(Math.random()*0.3+0.85);
			walkSpeed=maxSpeed;
			brake=accel/2;
			doop=true;		//не отслеживает цели
			mat=12;
			collisionTip=0;
			currentWeapon=getXmlWeapon(ndif);
			if (currentWeapon) childObjs=new Array(currentWeapon);
			visibility=300;
		}

		private var aiN:int=Math.floor(Math.random()*5);
		
		public override function setNull(f:Boolean=false):void {
			super.setNull(f);
			detectionDelay = World.detectionDelay * 0.5;
		}
		
		public override function putLoc(nloc:Location, nx:Number, ny:Number) {
			super.putLoc(nloc,nx,ny);
			if (isMine) {
				aiState=2;
				vis.gotoAndStop(2);
				vis.scaleY=0.5;
			} else if (loc.getAbsTile(nx,ny+10).phis) aiState=0;
			else if (loc.getAbsTile(nx,ny-50).phis) {
				aiState=1;
				fixed=true;
			} else aiState=0;
		}
		
		public override function setVisPos() {
			if (vis) {
				if (aiState==1) {
					vis.rotation=180;
					vis.x = coordinates.X;
					vis.y = coordinates.Y - 40;
				}
				else
				{
					vis.rotation=0;
					vis.x = coordinates.X;
					vis.y = coordinates.Y;
					vis.scaleX=storona;
				}
			}
		}
		
		public function setVis(v:Boolean) {
			isVis=v;
			vis.visible=v;
			vis.alpha=v?1:0.1;
		}
		
		public override function setCel(un:Unit=null, cx:Number=-10000, cy:Number=-10000) {
			if (un && isMeet(un)) {
				celX = un.coordinates.X;
				celY = un.coordinates.Y - un.boundingBox.halfHeight;
			}
			else if (cx>-10000 && cy>-10000) {
				celX = cx;
				celY = cy;
			}
			else {
				celX = coordinates.X;
				celY = this.boundingBox.top;
			}
			celDX = celX - coordinates.X;
			celDY = celY - coordinates.Y + this.boundingBox.height;
		}
		
		public function activate() {
			if (sost>1) return;
			setVis(true);
			xp=0;
			if (!isExpl) explosion(dam*0.8,tipDamage,200,20);
			isExpl=true;
			die();
		}
		
		override protected function control():void {
			if (sost>=3) return;
			if (World.w.enemyAct<=0) {
				return;
			}
			aiN++;
	
			if (stay && shX1 > 0.5 && storona < 0) turnX =  1;
			if (stay && shX2 > 0.5 && storona > 0) turnX = -1;
			if (turnX) {
				storona=turnX;
				turnX=0;
			}
			if (aiState==0) {
				if (storona==-1) {
					if (velocity.X > -maxSpeed) velocity.X -= accel;
				}
				else {
					if (velocity.X < maxSpeed) velocity.X += accel;
				}
			}
			else if (aiState==1) {
				if (aiN%5==0 && loc.getAbsTile(coordinates.X, coordinates.Y - 50).phis==0) {
					aiState=0;
					fixed=false;
				}
				pluh--;
				if (pluh<=0) {
					setCel(null, coordinates.X, coordinates.Y + 100);
					currentWeapon.attack();
					pluh = int(Math.random()*75+40);
				}
			}
			else if (aiState==2) {
				if (detectionDelay <= 0 && aiN % 4 == 0) {
					if (loc==World.w.gg.loc && rasst2>0 && rasst2<explDist*explDist) activate();
				}
				if (aiN%10==0 && !isVis) {
					isVis=World.w.gg.lookInvis(this,1);
					if (isVis) {
						setVis(true);
					}
				}
			}
			
			//атака
			if (World.w.enemyAct >= 3 && detectionDelay <= 0) {
				if (aiN%5==0) {
					for each (var un:Unit in loc.units) {
						if (un.activateTrap<2 && !un.player || !isMeet(un) || un.sost==3 || un.fraction==fraction || un.fraction==0) continue;
						if (un.player && (un as UnitPlayer).lurked) continue;
						if (attKorp(un)) {
							if (tr==0) un.addEffect('chemburn',dam/5);
							if (tr==1) un.addEffect('freezing');
						}
					}
				}
			}
		}
	}
}
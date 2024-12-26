package fe.unit {

	import flash.filters.GlowFilter;

	import fe.Snd;
	import fe.loc.Tile;
	
	public class UnitPon extends Unit {

		public var teleColor:uint=0;
		protected var teleFilter:GlowFilter;
		protected var footstepVol:Number=0.2;

		private static var tileX:int = Tile.tileX;
		private static var tileY:int = Tile.tileY;
		
		// Constructor
		public function UnitPon(cid:String=null, ndif:Number=100, xml:XML=null, loadObj:Object=null) {
			super(cid, ndif, xml, loadObj);
			blood=1;
		}

		//положение оружия
		public override function setWeaponPos(tip:int=0) {
				if (weaponKrep==0) { //телекинез
					if (storona>0 && celX > this.boundingBox.right || storona < 0 && celX < this.boundingBox.left) weaponX = coordinates.X + this.boundingBox.width * storona;
					else weaponX = coordinates.X;
					if (isLaz) weaponX = coordinates.X;
					if (loc.getTile(int((weaponX + storona * 15) / tileX), int(weaponY / tileY)).phis == 1) weaponX = coordinates.X;
					if (tip==1) weaponY = coordinates.Y - this.boundingBox.height * 0.4;
					else weaponY = coordinates.Y - this.boundingBox.height * 0.7;
				}
				else if (tip==1 || tip==2 || tip==4) {	 //в зубах	
					weaponX = coordinates.X;
					weaponY = coordinates.Y - this.boundingBox.height * 0.5;
				}
				else { //сбоку
					weaponX = coordinates.X;
					weaponY = coordinates.Y - this.boundingBox.height * 0.5;
				}
		}
		
		public function weaponLevit() {
			if (!currentWeapon || !teleFilter) return;
			if (weaponKrep==0 && currentWeapon.tip!=5) {
				if (currentWeapon.vis.kor) currentWeapon.vis.kor.filters=[teleFilter];
				else currentWeapon.vis.filters=[teleFilter];
			} 
		}
		
		public function sndStep(faza:int,tip:int=0) {
			if (loc==null || !loc.active) return;
			var nstep:int;
			var nleg:int;
			var sst:String = 'footstep';
			if (mat==1) sst='metalstep';
			if (tip==0) {
				nleg=Math.floor(Math.random()*4)+1;
			}
			else if (tip==1) {
				nstep=faza%16;
				if (nstep==5) nleg=1;
				else if (nstep==7) nleg=4;
				else if (nstep==13) nleg=2;
				else if (nstep==15) nleg=3;
				else return;
			}
			else if (tip==2) {
				nstep=faza%8;
				if (nstep==1) nleg=4;
				else if (nstep==2) nleg=1;
				else if (nstep==5) nleg=2;
				else if (nstep==6) nleg=3;
				else return;
			}
			else if (tip==3) {
				nstep=faza%14;
				if (nstep==4) nleg=4;
				else if (nstep==6) nleg=1;
				else if (nstep==10) nleg=2;
				else if (nstep==12) nleg=3;
				else return;
				Snd.ps('lazstep' + nleg, coordinates.X, coordinates.Y, 0, (footstepVol*2-volMinus)*Snd.stepVol);
				return;
			}
			else if (tip==4) {
				nstep=faza%24;
				if (nstep==4) nleg=4;
				else if (nstep==9) nleg=1;
				else if (nstep==16) nleg=2;
				else if (nstep==21) nleg=3;
				else return;
			}
			var rnd:String = isrnd()? 'a' : '';
			if (stayMat==1) sst='metalstep';
			Snd.ps(sst + nleg + rnd, coordinates.X, coordinates.Y, 0, (footstepVol-volMinus)*Snd.stepVol);
		}
		
		protected override function sndFall() {
			if (loc==null || !loc.active) return;
			var rnd:String = isrnd()? 'a' : '';
			var nleg:int;
			var sst:String = 'footstep';
			if (stayMat==1) sst='metalstep';
			nleg = int(Math.random()*4)+1;
			Snd.ps(sst + nleg + rnd, coordinates.X, coordinates.Y, 0, footstepVol - volMinus);
			nleg=int(Math.random()*4)+1;
			Snd.ps(sst + nleg + rnd, coordinates.X, coordinates.Y, 0, footstepVol - volMinus);
		}
		
		public override function command(com:String, val:String=null) {
			super.command(com,val);
		}
	}
}
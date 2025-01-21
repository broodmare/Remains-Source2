package fe.unit {

	import flash.filters.GlowFilter;

	import fe.Snd;
	import fe.loc.Tile;
	import fe.weapon.Weapon;
	
	public class UnitPon extends Unit {

		protected var footstepVol:Number	= 0.2;
		public var teleColor:uint			= 0;
		protected var teleFilter:GlowFilter;
		
		private static var tileX:int = Tile.tileX;
		private static var tileY:int = Tile.tileY;
		
		// Constructor
		public function UnitPon(cid:String=null, ndif:Number=100, xml:XML=null, loadObj:Object=null) {
			super(cid, ndif, xml, loadObj);
			blood = 1;
		}

		// [weapon position]
		public override function setWeaponPos(tip:String = "internal"):void {
				if (weaponKrep==0) { // [telekinesis]
					if (storona>0 && celX > this.boundingBox.right || storona < 0 && celX < this.boundingBox.left) {
						weaponX = coordinates.X + this.boundingBox.width * storona;
					}
					else {
						weaponX = coordinates.X;
					}
					
					if (isLaz) {
						weaponX = coordinates.X;
					}
					
					if (loc.getTile(int((weaponX + storona * 15) / tileX), int(weaponY / tileY)).phis == 1) {
						weaponX = coordinates.X;
					}
					
					if (tip == Resistances.DAM_CUT) {
						weaponY = coordinates.Y - this.boundingBox.height * 0.40;
					}
					else {
						weaponY = coordinates.Y - this.boundingBox.height * 0.70;
					}
				}
				// TODO CHECK THIS THIS IS RIGHT vvv
				else if (tip == Resistances.DAM_CUT || tip == Resistances.DAM_BLUNT || tip == Resistances.DAM_EXPLOSION) {	 // [in the teeth]
					weaponX = coordinates.X;
					weaponY = coordinates.Y - this.boundingBox.height * 0.50;
				}
				else { // [from the side]
					weaponX = coordinates.X;
					weaponY = coordinates.Y - this.boundingBox.height * 0.50;
				}
		}
		
		public function weaponLevit():void {
			if (!currentWeapon || !teleFilter) {
				return;
			}
			
			if (weaponKrep == 0 && currentWeapon.tip != Weapon.TYPE_MAGIC) {
				if (currentWeapon.vis.kor) {
					currentWeapon.vis.kor.filters=[teleFilter];
				}
				else {
					currentWeapon.vis.filters=[teleFilter];
				}
			} 
		}
		
		public function sndStep(faza:int,tip:int=0):void {
			if (loc == null || !loc.active) {
				return;
			}
			
			var nstep:int;
			var nleg:int;
			var sst:String = "footstep";
			
			if (mat == 1) {
				sst = "metalstep";
			}
			
			if (tip == 0) {
				nleg = Math.floor(Math.random() * 4) + 1;
			}
			else if (tip == 1) {
				nstep=faza % 16;
				
				if (nstep==5) nleg=1;
				else if (nstep==7) nleg=4;
				else if (nstep==13) nleg=2;
				else if (nstep==15) nleg=3;
				else return;
			}
			else if (tip == 2) {
				nstep = faza % 8;
				
				if (nstep==1) nleg=4;
				else if (nstep==2) nleg=1;
				else if (nstep==5) nleg=2;
				else if (nstep==6) nleg=3;
				else return;
			}
			else if (tip == 3) {
				nstep = faza % 14;
				
				if (nstep==4) nleg=4;
				else if (nstep==6) nleg=1;
				else if (nstep==10) nleg=2;
				else if (nstep==12) nleg=3;
				else return;
				
				Snd.ps("lazstep" + nleg, coordinates.X, coordinates.Y, 0, (footstepVol*2-volMinus)*Snd.stepVol);
				
				return;
			}
			else if (tip == 4) {
				nstep = faza % 24;
				
				if (nstep==4) nleg=4;
				else if (nstep==9) nleg=1;
				else if (nstep==16) nleg=2;
				else if (nstep==21) nleg=3;
				else return;
			}
			
			var rnd:String = isrnd()? "a" : "";
			
			if (stayMat == 1) {
				sst="metalstep";
			}
			
			Snd.ps(sst + nleg + rnd, coordinates.X, coordinates.Y, 0, (footstepVol - volMinus) * Snd.stepVol);
		}
		
		protected override function sndFall():void {
			if (loc == null || !loc.active) {
				return;
			}
			
			var rnd:String = isrnd() ? "a" : "";
			var nleg:int;
			var sst:String = "footstep";
			
			if (stayMat == 1) {
				sst = "metalstep";
			}
			
			nleg = int(Math.random() * 4) + 1;
			Snd.ps(sst + nleg + rnd, coordinates.X, coordinates.Y, 0, footstepVol - volMinus);
			nleg = int(Math.random() * 4) + 1;
			Snd.ps(sst + nleg + rnd, coordinates.X, coordinates.Y, 0, footstepVol - volMinus);
		}
		
		public override function command(com:String, val:String = null):void {
			super.command(com, val);
		}
	}
}
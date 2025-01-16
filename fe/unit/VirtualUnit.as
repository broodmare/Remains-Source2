package fe.unit {

	import fe.entities.Obj;
	import fe.projectile.Bullet;
	import fe.loc.Box;
	
	public class VirtualUnit extends Unit {

		public var owner:Obj;
		private var nTipDam:String = "";

		// Constructor
		public function VirtualUnit(cid:String = null, ndif:Number = 100, xml:XML = null, loadObj:Object = null) {
			activateTrap	= 0;
			dexter			= 0;
			mat				= 1;
			showNumbs		= false;
			isSats			= false;
			doop			= true;
			levitPoss		= false;
			
			if (cid != null) {
				nTipDam = cid;
			}
		}
		
		// Changed nTipDam to a String, old check was (nTipDam >= 0)
		public override function damage(dam:Number, tip:String, bul:Bullet = null, tt:Boolean = false):Number {
			if (nTipDam != "" && nTipDam != tip) {
				return 0;
			}
			
			owner.command("dam");
			
			return 1;
		}
		
		// Changed nTipDam to a String, old check was (nTipDam >= 0)
		public override function udarBullet(bul:Bullet, sposob:int = 0):int {
			if (nTipDam != "" && nTipDam != bul.tipDamage) {
				return 0;
			}
			
			owner.command("dam");
			
			return 1;
		}

		public override function udarUnit(un:Unit, mult:Number=1):Boolean {
			return false;
		}
		
		public override function udarBox(un:Box):int {
			return 0;
		}

		public override function die(sposob:int=0):void {
			exterminate();
		}
	}
}
package fe.unit {

	public class UnitRobobrain extends UnitAIRobot {

		// Constructor
		public function UnitRobobrain(cid:String=null, ndif:Number=100, xml:XML=null, loadObj:Object=null) {
			super(cid, ndif, xml, loadObj);
			id='robobrain';
			vis=new visualRobobrain();
			vis.stop();
			vis.osn.gotoAndStop(1);
			getXmlParam();
			walkSpeed=maxSpeed;
			runSpeed=maxSpeed*2;
			sitSpeed=maxSpeed;
			
			// [Give weapons] | дать оружие
			getWeapon(ndif, xml, loadObj);
			if (quiet) id_replic = '';
		}
		
		public override function animate():void {
			if (sost==3) { //сдох
				if (animState!='die') {
					vis.osn.gotoAndStop('die');
					animState='die';
				}
			}
			else if (aiState==0 || aiState==4) {
				if (animState!='stay') {
					vis.osn.gotoAndStop('stay');
					animState='stay';
				}
			}
			else {
				if (animState!='walk') {
					vis.osn.gotoAndStop('walk');
					animState='walk';
				}
			} 
		}
		
		public override function setWeaponPos(tip:int=0):void {
			weaponX = coordinates.X;
			weaponY = coordinates.Y-40;
		}
	}
}
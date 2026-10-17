package fe.game.domain.units {

	public class UnitRobobrain extends UnitAIRobot {
		
		public function UnitRobobrain(cid:String=null, ndif:Number=100, xml:XML=null, loadObj:Object=null) {
			super(cid, ndif, xml, loadObj);
			id='robobrain';
			initArt(id);
			art.play('stay');
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
				animState='die';
			}
			else if (aiState==0 || aiState==4) {
				animState='stay';
			}
			else {
				animState='walk';
			}
			art.play(animState);
		}
		
		public override function setWeaponPos(tip:String = "internal"):void {
			weaponX = coordinates.X;
			weaponY = coordinates.Y-40;
		}
	}
}
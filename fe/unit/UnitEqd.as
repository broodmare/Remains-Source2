package fe.unit {

	public class UnitEqd extends UnitAIRobot {

		private var jump_n:int=100;
		
		// Constructor
		public function UnitEqd(cid:String=null, ndif:Number=100, xml:XML=null, loadObj:Object=null)
		{
			super(cid, ndif, xml, loadObj);
			id='eqd';
			getXmlParam();
			walkSpeed=maxSpeed;
			sitSpeed=maxSpeed*0.35;
			runSpeed=maxSpeed*2.5;
			initBlit();
			
			//дать оружие
			getWeapon(ndif, xml, loadObj);
			if (quiet) id_replic='';
			
			isPort = true;
		}
		
		public override function dropLoot():void {
			currentWeapon.vis.visible = false;
			super.dropLoot();
		}
		
		public override function animate():void {
			var revers:Boolean=false;
			if (sost==2 || sost==3) { //сдох
				if (stay) {
					if (animState=='fall') {

					}
					else if (animState=='death') animState='fall';
					else animState='die';
				}
				else animState='death';
			}
			else {
				vis.visible=true;
				if (stay) {
					if  (velocity.X==0) {
						animState='stay';
					}
					else if (velocity.X < 4 && velocity.X > -4) {
						animState='walk';
						sndStep(anims[animState].f,4);
						if (aiNapr*storona<0) revers=true;
					}
					else if (velocity.X > 9 || velocity.X < -9) {
						animState='run';
						sndStep(anims[animState].f,2);
					}
					else {
						animState='trot';
						sndStep(anims[animState].f,1);
						if (aiNapr*storona<0) revers=true;
					}
				}
				else {
					animState='jump';
					// Commented out, there is no setStab function
					//anims[animState].setStab((dy*0.6+8)/16);
				}
			}
			if (animState!=animState2) {
				anims[animState].restart();
				animState2=animState;
			}
			if (!anims[animState].st) {
				if (revers) blit(anims[animState].id,anims[animState].maxf-anims[animState].f-1);
				else blit(anims[animState].id,anims[animState].f);
			}
			anims[animState].step();
		}
		
		public override function setWeaponPos(tip:int=0):void {
			weaponX = coordinates.X;
			weaponY = coordinates.Y-40;
		}
	}
}
package fe.unit {

	import fe.*;
	import fe.weapon.Weapon;
	import fe.serv.LootGen;
	import fe.serv.BlitAnim;

	public class UnitProtect extends UnitAIRobot {

		private var jump_n:int=100;
		private var jump_m:int=90;
		
		// Constructor
		public function UnitProtect(cid:String=null, ndif:Number=100, xml:XML=null, loadObj:Object=null) {
			super(cid, ndif, xml, loadObj);
			id='protect';
			if (tr>0) id+=tr;
			getXmlParam();
			walkSpeed=maxSpeed;
			sitSpeed=maxSpeed;
			runSpeed=maxSpeed*3;
			initBlit();
			
			//дать оружие
			getWeapon(ndif, xml, loadObj);
			if (quiet) id_replic='';
		}
		
		public override function dropLoot():void {
			currentWeapon.vis.visible=false;
			super.dropLoot();
		}
		
		public override function setHero(nhero:int=1):void {
			super.setHero(nhero);
			if (hero==1) {
				jump_m=500;
			}
		}
		
		public override function animate():void {
			var revers:Boolean = false;
			if (sost == 2 || sost == 3) { //сдох
				if (stay) {
					if (animState == 'fall') {

					}
					else if (animState == 'death') {
						animState = 'fall';
					}
					else {
						animState = 'die';
					}
				}
				else animState = 'death';
			}
			else {
				vis.visible = true;
				if (stay) {
					if  (velocity.X==0) {
						animState='stay';
					}
					else if (velocity.X<3 && velocity.X>-3) {
						animState='walk';
						sndStep(anims[animState].f,4);
						if (aiNapr*storona<0) revers=true;
					}
					else {
						animState='trot';
						sndStep(anims[animState].f,1);
					}
				}
				else {
					if (jump_n>5) animState='fly';
					else animState='jump';
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
		
		public override function setWeaponPos(tip:int = 0):void {
			weaponX = coordinates.X;
			weaponY = coordinates.Y - 40;
		}
		
		public override function jump(v:Number=1):void {
			if (stay) jump_n=jump_m;
			else jump_n--;
			
			if (velocity.Y > -jumpdy && jump_n > 0) {
				velocity.Y -= jumpdy * v / 4;
			}
		}
	}
}
package fe.unit {
	
	import fe.*;
	import fe.weapon.Weapon;
	import fe.serv.LootGen;
	import fe.serv.BlitAnim;
	public class UnitSentinel extends UnitAIRobot{

		var jump_n:int=100;
		var dopWeapon:Weapon;
		var kolRock=6;
		
		public function UnitSentinel(cid:String=null, ndif:Number=100, xml:XML=null, loadObj:Object=null) {
			super(cid, ndif, xml, loadObj);
			id='sentinel';
			vis=new visualSentinel();
			vis.stop();
			vis.osn.gotoAndStop(1);
			getXmlParam();
			walkSpeed=maxSpeed;
			sitSpeed=maxSpeed;
			runSpeed=maxSpeed*2;
			//дать оружие
			getWeapon(ndif, xml, loadObj);
			dopWeapon=Weapon.create(this,'robomlau');
			childObjs=new Array(currentWeapon, dopWeapon);
			if (quiet) id_replic='';
		}
		
		public override function dropLoot() {
			newPart('expl');
			currentWeapon.vis.visible=false;
			super.dropLoot();
		}
		
		public override function setLevel(nlevel:int=0) {
			super.setLevel(nlevel);
			if (dopWeapon && dopWeapon.tip==0) {
				dopWeapon.damage*=(1+level*0.1);
			}
		}
		
		public override function expl()	{
			newPart('metal',12);
		}
		
		public override function setNull(f:Boolean=false) {
			super.setNull(f);
			if (sost==1) {
				if (dopWeapon) dopWeapon.setNull();
			}
			if (f) kolRock=6;
		}
		
		
		public override function animate() {
			if (sost==3) { //сдох
				if (animState!='die') {
					vis.osn.gotoAndStop('die');
					animState='die';
				}
			} else if (stay || jump_n<=0) {
				if (animState!='stay') {
					vis.osn.gotoAndStop('stay');
					animState='stay';
				}
			} else {
				if (animState!='jump') {
					vis.osn.gotoAndStop('jump');
					animState='jump';
				}
			} 
		}
		
		public override function setWeaponPos(tip:int=0) {
			weaponX=X;
			weaponY=Y-90;
		}
		
		public override function jump(v:Number=1) {
			if (stay) jump_n=90;
			else jump_n--;
			if (dy>-jumpdy && jump_n>0) {
				dy-=jumpdy*v/4;
			}
		}
		//атака
		public override function attack() {
			if (celDX<100 && celDX>-100 && celDY<80 && celDY>-80 && celUnit) attKorp(celUnit,1);
			currentWeapon.attack();
			if (celUnit && !(celDX<160 && celDX>-160 && celDY<80 && celDY>-80)) dopWeapon.attack();
		}
		

	}
	
}

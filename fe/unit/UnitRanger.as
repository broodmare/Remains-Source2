package fe.unit {

	import fe.serv.AnimationSet;
	import fe.weapon.Weapon;
	
	public class UnitRanger extends UnitRaider {

		private var dopWeapon1:Weapon;
		private var dopWeapon2:Weapon;
		private var t_gren:int=Math.round(Math.random()*120+50);
		
		// Constructor
		public function UnitRanger(cid:String=null, ndif:Number=100, xml:XML=null, loadObj:Object=null) {
			parentId='ranger';
			kolTrs=3;
			super(cid, ndif, xml, loadObj);
			tupizna=10;
			durak=false;
			allLink=true;
			isDropArm=false;
			wPos = AnimationSet.getWeaponOffset("wPosRanger1");
			if (1)
			{
				dopWeapon1=Weapon.create(this,'robomlau');
				dopWeapon2=Weapon.create(this,'robogas');
				childObjs.push(dopWeapon1, dopWeapon2);
			}
			if (currentWeapon.damage<20) currentWeapon.damage*=1.2;
			currentWeapon.damage*=1.2;
			dopWeapon1.damageExpl*=0.8;
			plusObserv=5;
		}
		
		public override function attack():void {
			if (!sniper) mazil=(aiState==4)?5:16;		//стоя на месте стрельба точнее
			if (aiAttackOch==0 && shok<=0 && (celUnit!=null && isrnd(0.1) || celUnit==null && isrnd(0.03))) currentWeapon.attack();	//стрельба одиночными
			if (aiAttackOch>0 && (!sniper || celUnit)) {										//стрельба очередями
				if (aiAttackT<=0) aiAttackT=Math.round((Math.random()*0.4+0.8)*aiAttackOch);
				if (aiAttackT>aiAttackOch*0.25) currentWeapon.attack();
				aiAttackT--;
			}
			if ((celDX*celDX+celDY*celDY<100*100) && isrnd(0.1)) attKorp(celUnit,0.5);
			if (dopWeapon1) {
				t_gren--;
				if (t_gren<=0) {
					if (celUnit) dopWeapon1.attack();
					else dopWeapon2.attack();
					t_gren=Math.round(Math.random()*90+50);
				}
			}
		}
		
		public override function animate():void {
			//поворот
			if (sost==2 || sost==3) { //сдох
				if (stay) {
					if (animState=='fall') {

					}
					else if (animState=='death') animState='fall';
					else animState='die';
				} else animState='death';
			}
			else {
				if (stay) {
					if  (velocity.X==0 || aiState==7) {
						animState='stay';
					}
					else if (attackerType==0 && aiAttack || aiState==8) {
						animState='run';
						sndStep(anims[animState].f,2);
					}
					else if (walker && (aiState<=1 || aiState==4)) {
						animState='walk';
						sndStep(anims[animState].f,1);
					}
					else {
						animState='trot';
						sndStep(anims[animState].f,1);
					}
				}
				else if (isLaz && mostLaz) {
					animState='laz';
					sndStep(anims[animState].f,3);
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
				blit(anims[animState].id,anims[animState].f);
			}
			anims[animState].step();
		}
	}
}
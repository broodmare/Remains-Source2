package fe.unit {

	import fe.weapon.Weapon;
	import fe.serv.BlitAnim;
	import fe.serv.AnimationSet;
	
	public class UnitGutsy extends UnitAIRobot {

		private var dopWeapon:Weapon;
		public var wPos:Array;
		
		// Constructor
		public function UnitGutsy(cid:String=null, ndif:Number=100, xml:XML=null, loadObj:Object=null) {
			super(cid, ndif, xml, loadObj);
			id='gutsy';
			
			if (tr>0) id+=tr;
			
			getXmlParam();
			walkSpeed=maxSpeed;
			runSpeed=maxSpeed*2;
			sitSpeed=maxSpeed*0.8;
			
			initBlit();
			//дать оружие
			getWeapon(ndif, xml, loadObj);
			dopWeapon=Weapon.create(this,'robofire');
			
			if (tr==1) dopWeapon.damage*=2;
			
			if (currentWeapon) childObjs=[currentWeapon, dopWeapon];
			
			if (quiet) id_replic='';
			
			wPos = AnimationSet.getWeaponOffset("wPosGutsy");
		}
		
		public override function forces():void {
			super.forces();
			
			if (sost < 3 && velocity.Y > 0) {
				velocity.Y *= 0.9;
			}
		}
		
		public override function setLevel(nlevel:int=0):void {
			super.setLevel(nlevel);
			if (dopWeapon && dopWeapon.tip==0) {
				dopWeapon.damage*=(1+level*0.12);
			}
		}
		
		public override function setNull(f:Boolean=false):void {
			super.setNull(f);
			if (sost==1) {
				if (dopWeapon) dopWeapon.setNull();
			}
		}
		
		public override function animate():void {
			var cframe:int;
			if (sost==3) { //сдох
				if (stay) {
					animState='die';
				} else animState='death';
			} else {
				animState='stay';
			}
			if (animState!=animState2) {
				anims[animState].restart();
				animState2=animState;
			}
			if (!anims[animState].st) {
				blit(anims[animState].id, int(anims[animState].f));
			}
			anims[animState].step();
		}
		
		public override function setWeaponPos(tip:int=0):void {
			var obj:Object=wPos[anims[animState].id][int(anims[animState].f)];
			weaponX = coordinates.X + (obj.x+visBmp.x)*storona;
			weaponY = coordinates.Y + obj.y+visBmp.y;
			weaponR=obj.r;
		}
		
		public override function jump(v:Number=1):void {
			if (velocity.Y > -jumpdy) {
				velocity.Y -= jumpdy * v / 4;
			}
		}
		
		public override function attack():void {
			if (celDX<100 && celDX>-100 && celDY<80 && celDY>-80 && celUnit) attKorp(celUnit,1);
			if (celDX<300 && celDX>-300 && celDY<300 && celDY>-300 || aiAttackT>0) {
				if (aiAttackOch>0) {										//стрельба очередями
					if (aiAttackT<=0) aiAttackT=Math.round((Math.random()*0.4+0.8)*aiAttackOch);
					if (aiAttackT>aiAttackOch*0.25) dopWeapon.attack();
					aiAttackT--;
				}
			}
			else {
				if (isrnd(0.1)) currentWeapon.attack();	//стрельба одиночными
			}
		}
	}
	
}

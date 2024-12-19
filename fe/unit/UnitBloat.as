package fe.unit {
	
	import fe.*;
	import fe.weapon.Weapon;
	import fe.projectile.Bullet;
	
	public class UnitBloat extends Unit {
		
		public var tr:int;
		var cDam:Number;
		var isEmit:Boolean=false;
		var gryz:Boolean=false;
		var isGryz:Boolean=false;
		var shootCh:Number=0.1;
		
		// Constructor
		public function UnitBloat(cid:String=null, ndif:Number=100, xml:XML=null, loadObj:Object=null) {
			super(cid, ndif, xml, loadObj);
			
			//определить разновидность tr
			if (loadObj && loadObj.tr) {			//из загружаемого объекта
				tr=loadObj.tr;
			}
			else if (xml && xml.@tr.length()) {	//из настроек карты
				tr=xml.@tr;
			}
			else if (cid) {						//из заданного идентификатора cid
				tr=int(cid);
			}
			else {
				tr = int(Math.random()*5);	//случайно по параметру ndif
			}

			if (!(tr>=0)) tr=0;
			id='bloat'+tr;
			var vClass:Class=Res.getClass('visualBloat'+tr,null,visualBloat1);
			vis=new vClass();
			vis.stop();
			runSpeed=0;
			getXmlParam();
			if (tr>=7) nazv=Res.txt('u','bloat10');
			maxSpeed=maxSpeed*(0.9+Math.random()*0.2);
			sitSpeed=maxSpeed*0.5;
			walkSpeed=maxSpeed;
			if (runSpeed==0) runSpeed=maxSpeed*2;
			
			isFly=true;
			plaKap=true;
			aiDx=isrnd()?0.7:-0.7;
			aiDy=isrnd()?0.7:-0.7;
			storona=(aiDx>0)?1:-1;
			currentWeapon=getXmlWeapon(ndif);
			if (currentWeapon) childObjs=new Array(currentWeapon);
		}

		public override function getXmlParam(mid:String=null) {
			super.getXmlParam('bloat');
			super.getXmlParam();
			var node0:XML = XMLDataGrabber.getNodeWithAttributeThatMatches("core", "AllData", "units", "id", id);
			if (node0.un.length()) {
				if (node0.un.@attr.length()) attRasst=node0.un.@attr;		//дистанция атаки
				if (node0.un.@attch.length()) attCh=node0.un.@attch;				//шанс атаки
				if (node0.un.@shootch.length()) shootCh=node0.un.@shootch;				//шанс атаки
				if (node0.un.@bulb.length()) isEmit=true;				//шанс атаки
				if (node0.un.@gryz.length()) gryz=true;					//грызун
			}
		}

		//сделать героем
		public override function setHero(nhero:int=1) {
			super.setHero(nhero);
			if (hero == 1) shootCh = 0.3;
		}

		public override function setNull(f:Boolean=false) {
			super.setNull(f);
			if (f) {
				aiState=0;
				aiTCh = int(Math.random()*10)+5;
			}
		}

		public override function save():Object {
			var obj:Object=super.save();
			if (obj==null) obj=new Object();
			obj.tr=tr;
			return obj;
		}
		
		public override function otbros(bul:Bullet) {
			if (bul && bul.knockx!=0 || bul.knocky!=0) isGryz=false;
			super.otbros(bul);
		}
		
		function emit() {
			var un:Unit=loc.createUnit('bloat', coordinates.X, coordinates.Y, true, null, '0');
		}
		
		public override function expl()	{
			newPart('shmatok',4,2);
			newPart('bloat_kap',int(Math.random()*3+4));
		}
		
		public override function dropLoot() {
			super.dropLoot();
			var un:Unit
			if (tr>=8) {
				un=loc.createUnit('bloat', coordinates.X, coordinates.Y, true, null, String(tr-1));
				un.questId=questId;
				un=loc.createUnit('bloat', coordinates.X, coordinates.Y, true, null, String(tr-1));
				un.questId=questId;
			} 
			if (isEmit) {
				emit();
				emit();
				if (hero) {
					emit();
					emit();
				}
			}
		}
		
		public override function incStat(sposob:int=0) {
			if (tr>=7 && tr<10) return;
			super.incStat(sposob);
		}
		
		public override function animate() {

		}
		
		var aiDx:Number=0;
		var aiDy:Number=0;
		var aiRasst:Number;

		var attRasst:int=400;
		var attCh:Number=0.4;
		
		//состояния
		//0 - летает
		//1 - видит цель, стреляет
		
		override protected function control():void {

			if (sost>=3) {
				return;
			}
			
			if (World.w.enemyAct<=0) {
				return;
			}
			
			if (stun) {
				return;
			}

			if (aiTCh>0) aiTCh--;		//счётчик смены состояний
			else {						//смена состояний
				aiTCh=Math.floor(Math.random()*50)+20;
				if (celUnit) {
					aiRasst=Math.sqrt(celDX*celDX+celDY*celDY);
					if (aiRasst<attRasst && isrnd(attCh)) {
						aiDx=celDX/aiRasst;
						aiDy=celDY/aiRasst;
						aiState=2;
						aiTCh=20;
						maxSpeed=runSpeed;
					}
					else {
						aiState=1;
						maxSpeed=walkSpeed;
					}
					storona=(celDX>0)?1:-1;
				}
				else {
					if (isrnd(0.1)) {
						aiDx=isrnd()?0.7:-0.7;
						aiDy=isrnd()?0.7:-0.7;
					}
					storona=(aiDx>0)?1:-1;
					aiState=0;
					maxSpeed=sitSpeed
				}
			}

			//поиск цели
			if (World.w.enemyAct>1 && aiTCh%10==1) {
				findCel();
			}

			if (isPlav) {
				turnY=-1;
			}

			if (levit) {
				isGryz=false;
			}
	
			if (turnX) {
				storona=turnX;
				aiDx=Math.abs(aiDx)*turnX;
				turnX=0;
			}

			if (turnY) {
				aiDy=Math.abs(aiDy)*turnY;
				turnY=0;
			}

			velocity.X += aiDx * accel + Math.random() * 2 - 1;
			velocity.Y += aiDy * accel + Math.random() * 2 - 1;
			
			if (isGryz) {
				if (celUnit && isMeet(celUnit)) {
					if ((celUnit.coordinates.X - coordinates.X) * (celUnit.coordinates.X - coordinates.X) + (celUnit.coordinates.Y - coordinates.Y) * (celUnit.coordinates.Y - coordinates.Y) > 10000)
					{
						isGryz = false;
					}
					else {
						velocity.X = celUnit.coordinates.X - coordinates.X;
						velocity.Y = celUnit.coordinates.Y - celUnit.objectHeight / 2 - coordinates.Y + objectHeight / 2;
					}
				}
				else {
					isGryz = false;
				}
			}
			
			//атака
			if (World.w.enemyAct>=3 && celUnit && shok<=0) {
				if (aiState==1 && currentWeapon) if (isrnd(shootCh)) currentWeapon.attack();
				var atk=attKorp(celUnit);
				if (atk && gryz) isGryz=true;
			}
		}
	}	
}
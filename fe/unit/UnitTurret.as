package fe.unit {
	
	import fe.*;
	import fe.weapon.Weapon;
	import fe.projectile.Bullet;
	import fe.serv.Interact;
	import fe.loc.Tile;
	import fe.loc.Location;
	
	// Cheat sheet
	// Puha = The gun part of the turret, not the base.
	//	Num	:	Gun Type
	//###################
	//	 1	:	Light
	//	 2	:	Red Barrel
	//	 3	:	Plasma
	//	 4	:	Fire
	//	 5	:	Radar dish
	//	 6	:	Chunky green
	//	 7	:	Lightning
	//	10	:	Chunky plasma

	public class UnitTurret extends Unit {
		
		public var tr:int;
		
		private var osnova:Tile;
		
		private var turrettip:int=0;
		private var hidden:int=0;	//1 - является срытой, 2 - скрыта и не реагирует пока не получит команду
		private var sleep:Boolean=false;	//отключена
		private var reprog:Boolean=false;	//перенастроена
		
		private var actDrot:Number=0.1;
		private var noTurn:Boolean=false;
		private var absVis:Boolean=false;
		private var watchDrot:Number=0.015;
		private var period:int=120;
		private var aRot:Array;		//массив углов поворота
		private var nRot:int=0;		//и текущий элемент массива
		private var mxml:XML;
		private var angle:String;

		private var tileX:int = Tile.tileX;
		private var tileY:int = Tile.tileY;
		
		// Constructor
		public function UnitTurret(cid:String=null, ndif:Number=100, xml:XML=null, loadObj:Object=null) {

			super(cid, ndif, xml, loadObj);
			
			

			// [Define turret type, tr. (Weapon used)]
			if (loadObj && loadObj.tr) { // [from the loaded object]
				tr = loadObj.tr;
			}
			else if (xml && xml.@tr.length()) {	// [from map settings]
				tr = xml.@tr;
			}
			else { // [randomly by ndif parameter]
				if (ndif < 10)		tr = int(Math.random() * 3 + 1);
				else if (ndif < 15)	tr = int(Math.random() * 5 + 1);
				else				tr = int(Math.random() * 7 + 1);
			}

			// [determine the turret type]
			if (cid=='land') turrettip=1;
			if (cid=='arm') turrettip=3;
			if (cid=='wall') turrettip=2;
			if (cid=='hidden') hidden=1;
			if (cid=='hidden2') hidden=2;
			if (cid=='combat') turrettip=4;
			if (cid=='boss') turrettip=5;
			
			id = 'turret' + turrettip;

			if (turrettip == 0)		vis = new visualTurret0();		// .SWF Dependency
			else if (turrettip==1)	vis = new visualTurret1();		// .SWF Dependency
			else if (turrettip==2)	vis = new visualTurret2();		// .SWF Dependency
			else if (turrettip==3)	vis = new visualTurret3();		// .SWF Dependency
			else if (turrettip==4)	vis = new visualTurret4();		// .SWF Dependency
			else if (turrettip==5)	vis = new visualTurret5();		// .SWF Dependency
			
			vis.stop();
			getXmlParam();
			
			if (turrettip == 5) {
				invulner = true;
				absVis = true;
			}
			
			currentWeapon = new Weapon(this, 'turretWep' + tr);
			childObjs = new Array(currentWeapon);
			mat = 1;
			currentWeapon.rot=currentWeapon.forceRot;
			currentWeapon.auto=true;
			currentWeapon.hold=currentWeapon.holder;

			if (xml && xml.move.length()) mxml = xml;
			if (xml && xml.vis.@vclass.length()) angle = xml.vis.@vclass;
			if (xml && xml.@fraction.length()) fraction = xml.@fraction;
			if (xml && xml.@hidden.length()) hidden = xml.@hidden;
			if (turrettip != 3) acidDey = 1;
			if (fraction == F_PLAYER) warn = 0;
			if (loadObj && loadObj.off) hack(0);
			if (loadObj && loadObj.reprog) hack(1);
		}
		
		public override function save():Object {
			var obj:Object=super.save();
			if (obj==null) obj=new Object();
			obj.tr=tr;
			obj.off=sleep;
			obj.reprog=reprog;
			return obj;
		}
		
		public override function putLoc(nloc:Location, nx:Number, ny:Number) {
			super.putLoc(nloc, nx, ny);
			if (mxml) inter = new Interact(this, null, mxml, null);
			// Turret aiming constraints
			if (turrettip == 0 || turrettip == 4) {
				currentWeapon.fixRot = 1;
				aRot = [30, 150];
				if (turrettip == 4) {
					period = 80;
					watchDrot = 0.05;
				}
			}
			else if (turrettip==1){
				aRot = [-15, -165];
				watchDrot = 0.1;
			}
			else if (turrettip == 2 || turrettip == 5){
				aRot = [45, 135, -135, -45];
				vKonus=Math.PI/2;
				if (loc.mirror) {
					if (angle=='left') angle='right';
					else if (angle=='right') angle='left';
				}
				if (angle == 'down')  aRot = [ 45,  135];
				if (angle == 'up')    aRot = [-45, -135];
				if (angle == 'left')  aRot = [135, -135];
				if (angle == 'right') aRot = [ 45,  -45];
			}
			else if (turrettip==3) {
				if (storona>0) {
					aRot = [-15, 15];
					currentWeapon.fixRot=2;
					vAngle=0;
				}
				else {
					aRot=[-165, 165]
					currentWeapon.fixRot=3;
					vAngle=Math.PI;
				}
				watchDrot=0.01;
				vKonus=Math.PI/4;
				noTurn=true;
				vis.osn.t1.scaleX=vis.osn.t2.scaleX=vis.osn.t3.scaleX=storona;
			}
			
			nRot = int(Math.random()*aRot.length);
			currentWeapon.rot=currentWeapon.forceRot=aRot[nRot];
			currentWeapon.findCel=false;
			aiState=1;
			
			if (hidden>0) {
				currentWeapon.rot=currentWeapon.forceRot=Math.PI/2;
				aiState=0;
				vis.osn.gotoAndStop(6);
			}
			try {
				vis.osn.puha.gotoAndStop(tr);
			}
			catch(err) {
				trace('ERROR: (00:10)');
			}
		}

		public override function setLevel(nlevel:int=0):void {
			level+=nlevel;
			if (level<0) level=0;
			hp=maxhp=hp*(1+level*0.2);
			critCh=level*0.01;
			armor*=(1+level*0.1);
			marmor*=(1+level*0.1);
			skin*=(1+level*0.1);
			armor_hp=armor_maxhp=armor_hp*(1+level*0.2);
			observ+=Math.min(nlevel,20)*(0.8+Math.random()*0.4);
			currentWeapon.damage*=(1+level*0.12);
		}
		
		public override function setVisPos() {
			vis.x = coordinates.X;
			vis.y = coordinates.Y;
		}

		public override function animate():void {
			if (vis.osn.currentFrame != tr) vis.osn.puha.gotoAndStop(tr);

			if (fixed && levit) vis.osn.rotation = Math.random() * 6 - 3;
			else if (vis.osn.rotation != 0) vis.osn.rotation = 0;

			if (vis.osn.currentFrame == 1) {
				vis.osn.puha.rotation = radiansToDegrees(currentWeapon.rot); // Rotate the gun of the turret.

				if (vis.osn.light.currentFrame != aiState + 1) vis.osn.light.gotoAndStop(aiState + 1);
				if (isShoot) {
					isShoot = false;
					vis.osn.puha.puha.gotoAndPlay(2); 
				}
				if (aiState == 0 && hidden && fixed) vis.osn.gotoAndPlay(2);
			} 
			else if (vis.osn.currentFrame == 6 && aiState > 0) vis.osn.gotoAndPlay(7);

		}

		private function radiansToDegrees(radians:Number):Number {
			return radians * 180 / Math.PI;
		}

		public override function setPos(nx:Number,ny:Number):void {
			super.setPos(nx,ny);
			if ((turrettip == 0 || turrettip == 4) && loc && !loc.active) osnova = loc.getAbsTile(coordinates.X, coordinates.Y - 50);
		}

		public override function alarma(nx:Number=-1,ny:Number=-1):void {
			super.alarma(nx, ny);
			if (turrettip == 3) return;
			if (sost==1 && !sleep) {
				ear=10;
				var vK = vKonus;
				vKonus=0;
				findCel();
				vKonus=vK;
				ear=0;
				aiSpok=maxSpok+10;
				aiState=3;
			}
		}
		
		public override function setNull(f:Boolean = false):void {
			super.setNull(f);
			if (f && !sleep) {
				aiState = hidden? 0 : 1;
				if (aiState == 0) vis.osn.gotoAndStop(6);
				aiTCh = int(Math.random()*10)+5;
			}
		}
		
		public override function hack(sposob:int=0) {
			if (sposob==0) {
				sleep=true;
				aiState=0;
				currentWeapon.forceRot=Math.PI/2;
				currentWeapon.findCel=false;
			}
			else if (sposob==1) {
				reprog=true;
				if (fraction!=Unit.F_PLAYER && xp>0 && loc) loc.takeXP(xp, coordinates.X, coordinates.Y, true);
				fraction=Unit.F_PLAYER;
				xp=0;
				aiState=1;
				aiSpok=0;
				celUnit=null;
			}
			else if (sposob==2) {
				reprog=true;
				fraction=Unit.F_PLAYER;
				xp=0;
			}
			warn=0;
		}

		public override function expl():void {
			newPart('metal',4);
			newPart('miniexpl');
		}
		
		public override function setWeaponPos(tip:int=0):void {
			weaponX = coordinates.X;
			if (turrettip==0 || turrettip==4) weaponY = coordinates.Y - 12;
			else if (turrettip==1) weaponY = coordinates.Y - 60;
			else if (turrettip==2 || turrettip==5) weaponY = coordinates.Y - 20;
			else if (turrettip==3) weaponY = coordinates.Y - 55;
		}
		
		// [Tear away from a fixed place]
		public override function otryv() {
			if (turrettip==5) return;
			if (turrettip==0 || turrettip==2 || turrettip==4) {
				newPart('iskr_bul',20);
				sleep=true;
				aiState=0;
				currentWeapon.findCel=false;
				warn=0;
				if (xp>0) loc.takeXP(xp, coordinates.X, coordinates.Y, true);
				xp=0;
			}
			fixed=false;
		}
		
		//команда скрипта
		public override function command(com:String, val:String=null) {
			if (com == 'shoot') currentWeapon.attack();
			if (com == 'alarma') alarma();
			if (com == 'hack') hack();
			if (com == 'port') {
				var arr:Array=val.split(':');
				var nx = (int(arr[0])+0.5) * tileX;
				var ny = (int(arr[1])+1) * tileY;
				teleport(nx,ny,1);
				aiState=2;
				aiTCh=60;
			}
		}
		
		public override function damage(dam:Number, tip:int, bul:Bullet=null, tt:Boolean=false):Number {
			if (turrettip==3) {
				shithp=1000;
				shitArmor=25;
				if (bul) {
					if (bul.weap!=null && bul.weap.tip==1) {	//холодное оружие
						var w:Weapon=bul.weap;
						if ((coordinates.X - w.coordinates.X) * storona > 25) shitArmor = 0;
					}
					else if (bul.velocity.X * storona > 0) shitArmor = 0;
				}
			}
			var ret:Number=super.damage(dam, tip, bul, tt);
			if (turrettip==3) {
				shithp=0;
				shitArmor=0;
			}
			return ret;
		}
		
		public override function findCel(over:Boolean=false):Boolean {
			if (absVis && loc==World.w.loc && !reprog && !sleep) {
				setCel(World.w.gg);
				return true;
			}
			if (!reprog) return super.findCel(over);
			if (detectionDelay > 0) return false;
			var ncel:Unit;
			if (priorUnit && isMeet(priorUnit) && priorUnit.sost<3 && priorUnit.hp>0 && !priorUnit.doop) {
				setCel(priorUnit);
				return true;
			}
			else {
				for each (var un:Unit in loc.units) {
					if (un.disabled || un.sost>=3 || un.fraction==fraction || un.doop || un.invis) continue;
					if (look(un)) {
						setCel(un);
						return true;
					}
				}
			}
			celUnit=priorUnit=null;
			return false;
		}
		
		//состояния
		//0 - спрятана
		//1 - ищет цели
		//2 - готовится стрелять
		//3 - видит цель, стреляет
		//4 - не видит цель
		
		override protected function control():void {
			if (levit && !reprog || !stay && !fixed && detectionDelay <= 0) {
				if (aiState<=1 && !sleep) {
					aiState=3;
				}
			}
			levitPoss=!hidden;
			if (World.w.enemyAct<=0 || sleep) {
				return;
			}
			if (aiTCh>0) aiTCh--;
			else if (aiState==2) {
				if (celUnit) {
					aiSpok=maxSpok+10;
					aiState=3;
					budilo(750);
				}
				else aiState=1;
			}
			else {
				if (aiSpok<=0) {
					if (aiState==1 && hidden) {
						aiState=0;
						currentWeapon.forceRot=Math.PI/2;
					}
					else if (aiState>0) aiState=1;

					if (aiState==1) {	//установить угол поворота
						nRot++;
						if (nRot>=aRot.length) nRot=0;
						currentWeapon.forceRot=aRot[nRot]*Math.PI/180;
					}
					aiTCh=period;
				}
				else aiTCh = int(Math.random() * 50) + 40;

				if (aiSpok>0) aiState=4;
				if (aiSpok>=maxSpok) aiState=3;
			}
			//поиск цели, мина
			if (!reprog && aiTCh%15==1 && findLevit() && celUnit!=loc.gg) {
				if (loc.gg.teleObj && (loc.gg.teleObj is Mine)) {
					priorUnit =(loc.gg.teleObj as Mine);
					aiSpok=maxSpok+10;
				}
			}
			if (World.w.enemyAct>1 && aiTCh%10==1) {
				if (!noTurn) vAngle=currentWeapon.rot;
				if (osnova && osnova.phis==0) die();
				if (!stun && findCel()) {
					if (aiState<=1) {
						aiState=2;
						if (celUnit && (celUnit is Mine)) aiTCh=5;
						else aiTCh=Math.floor(Math.random()*10)+30;
					}
					else if (aiState>=3) {
						aiState=3;
					}
				}
				else {
					setCel(null, celX+Math.random()*80-40, celY+Math.random()*80-40);
					if (aiSpok>0) {
						aiSpok--;
					}
				}
				if (inter) {
					if (aiState<=1) inter.moveSt=3;
					else inter.moveSt=0;
				}
				if (aiState==0)  {
					if (!noTurn) storona=(currentWeapon.rot>-Math.PI/2 && currentWeapon.rot<=Math.PI/2)?1:-1;
					currentWeapon.findCel=false;
					overLook=true;
					currentWeapon.drot=0.5;
					vision=0.35;
					if (hidden==2) vision=0;
					isVis=isSats=false;
					dexter=10;
				}
				else if (aiState==1) {
					if (!noTurn) storona=(currentWeapon.rot>-Math.PI/2 && currentWeapon.rot<=Math.PI/2)?1:-1;
					currentWeapon.findCel=false;
					currentWeapon.drot=watchDrot;
					overLook=false;
					vision=1;
					isVis=isSats=true;
					dexter=1;
				}
				else if (aiState>1) {
					if (!noTurn) storona=(celDX>0)?1:-1;
					currentWeapon.findCel=true;
					if (aiState==4) currentWeapon.drot=watchDrot;
					else currentWeapon.drot=actDrot;
					overLook=true;
					vision=1;
					isVis=isSats=true;
					dexter=1;
				}
			}
			//атака
			if (World.w.enemyAct>=3 && aiState==3 && !stun) {
				currentWeapon.attack();
			}
			if (World.w.enemyAct >= 3 && celUnit && dam>0 && detectionDelay <= 0) {	//атака корпусом
				attKorp(celUnit, 1);
			}
		}
	}
}
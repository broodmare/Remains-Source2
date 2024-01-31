package fe.unit {
	
	import fe.*;
	import fe.util.Vector2;
	import fe.graph.Emitter;
	import fe.loc.Box;
	
	public class UnitPet extends Unit{
		
		var spd:Object;
		var flyX:Number=0, flyY:Number=0, flyDX:Number=0, flyDY:Number=0, flyR:Number, flyBox:Box;	//точка, в которую надо лететь
		var iskr:Emitter;
		var gg:UnitPlayer;
		public var active:Boolean=false;
		var rasstGG:Number=200;		//дистанция до ГГ, больше которой включается следование
		var rasstUnmat:Number=400;		//дистанция до ГГ, больше которой включается нематериальность
		var rasstVisEn:Number=800;	//максимальная дистанция атаки
		var rasstWeap:Number=200;	//дистанция атаки
		var rasstOut:Number=100;	//дистанция отлёта
		var tempUnmat:Boolean=false;
		
		var optEnW:Boolean=true;	//энергетическое оружие
		var optSit:Boolean=true;	//садиться на ящики
		var optAutores:Boolean=true;	//автовозрождение
		var optUncall:Boolean=false;	//отзыв при смерти
		var optTurn:Boolean=true;	//поворачиваться

		public function UnitPet(cid:String=null, ndif:Number=100, xml:XML=null, loadObj:Object=null)
		{
			super(cid, ndif, xml, loadObj);
			id = 'phoenix';
			if (cid != null) id = cid;
			getXmlParam();
			fraction = Unit.F_PLAYER;
			
			if (id == 'moon')
			{
				vis = new visualMoon();
				vis.osn.stop();
			}
			else
			{
				initBlit();
				animState='fly';
			}
			aiState=1;
			walkSpeed=maxSpeed;
			runSpeed=maxSpeed*2;
			isFly=true;
			isSats=false;
			spd=new Object();
			elast=0.2;
			plaKap=true;
			mater=false;
			activateTrap=0;
			currentWeapon=getXmlWeapon(ndif);
			if (currentWeapon) childObjs=new Array(currentWeapon);
			if (id=='phoenix') {
				optAutores=true;
				rasstWeap=200;
			}
			if (id=='owl') {
				optAutores=false;
				rasstWeap=400;
				vulner[D_NECRO]=0.2;
			}
			if (id=='moon') {
				knocked=0;
				optAutores=false;
				optSit=false;
				optUncall=true;
				rasstWeap=400;
				optTurn=false;
				storona=1;
				vulner[D_NECRO]=0.5;
			}
			transT=true;
			sost=4;
		}

		public override function expl()	{
			if (id=='phoenix')	newPart('green_spark',25);
			if (id=='owl')	newPart('orange_spark',25);
			if (id=='moon')	newPart('blue_spark',25);
		}
		
		public override function step() {
			if (World.w.loc.petOn) super.step();
		}
		
		public override function forces() {
			if (isFly) {
				if (dx*dx+dy*dy>maxSpeed*maxSpeed) {
					dx*=0.8;
					dy*=0.8;
				}
				if (isPlav) {
					dy*=0.9;
					dx*=0.9;
					if (mater) dy+=World.ddy*ddyPlav;
				}
			} else super.forces();
		}
		
		//лечение 0-предметами, 1-радиацией
		public override function heal(hl:Number, tip:int=0, ismess:Boolean=true) {
			if (tip==1 && (id!='phoenix' || sost>=3)) return;
			hp+=hl;
			if (hp>maxhp) hp=maxhp;
			if (hl>0) visDetails();
			if ((tip==0 || hl>=10) && active && ismess) {
				numbEmit.cast(loc, coordinates.X, coordinates.Y-objectHeight/2, {txt:'+'+Math.round(hl), frame:4, rx:10, ry:10});
			}
		}
		
		public override function setNull(f:Boolean=false) {
			super.setNull(f);
			aiState=1;
			getFlyPoint();
			if (optTurn) storona = (celX > coordinates.X)? 1:-1;
		}
		
		//настройка силы спутника
		public override function setLevel(nlevel:int=1) {
			level=nlevel-1;
			var koef=hp/maxhp;
			if (id=='phoenix') {
				maxhp=gg.pers.petHP*(1+level*0.12);
				dam=gg.pers.petDam*(1+level*0.1);
				currentWeapon.damage=gg.pers.petDam*(1+level*0.1);
				skin=gg.pers.petSkin;
				allVulnerMult=gg.pers.petVulner;
			} else if (id=='owl') {
				maxhp=gg.pers.owlHP*(1+level*0.1);
				dam=gg.pers.owlDam*(1+level*0.1);
				currentWeapon.damage=gg.pers.owlDam*(1+level*0.1);
				skin=gg.pers.owlSkin;
				allVulnerMult=gg.pers.owlVulner;
			} else if (id=='moon') {
				maxhp=gg.pers.moonHP*(1+level*0.1)*gg.spellPower;
				dam=gg.pers.moonDam*(1+level*0.1)*gg.spellPower;
			}
			hp=koef*maxhp;
		}
		
		public override function setWeaponPos(tip:int=0)
		{
			if (id=='phoenix')
			{
				weaponX = coordinates.X + 15 * storona;
				weaponY = coordinates.Y - 20;
			}
			else
			{
				weaponX = coordinates.X + 11 * storona;
				weaponY = coordinates.Y - 18;
			}
			magicX = weaponX;
			magicY = weaponY;
		}
		
		public override function animate() {
			if (oduplenie>30) vis.alpha=0;
			else if (oduplenie>0) vis.alpha=1-oduplenie/30;
			else vis.alpha=1;
			if (id=='moon') {
				if (aiState==4 || aiState==5 || aiState==2) {
					vis.osn.gotoAndStop(2);
					vis.osn.rotation+=30;
				} else {
					vis.osn.gotoAndStop(1);
					vis.osn.rotation+=3; 
				}
			} else {
				if (aiState==0) animState='stay';
				else animState='fly';
				if (animState!=animState2) {
					anims[animState].restart();
					animState2=animState;
				}
				if (!anims[animState].st) {
					blit(anims[animState].id,Math.floor(anims[animState].f));
				}
				anims[animState].step();
			}
			if (hpbar) hpbar.alpha=vis.alpha;
		}
		public override function visDetails() {
			super.visDetails();
			World.w.gui.setPet();
		}
		
		//найти точку следования
		private function getFlyPoint()
		{
			var rx:Number=-120;
			var ry:Number=-80;
			flyBox=null;
			flyX = gg.coordinates.X + gg.storona * rx;
			flyY = gg.coordinates.Y + ry;
			if (flyX<60) flyX=60;
			if (flyX>loc.maxX-60) flyX=loc.maxX-60;
			if (flyY<80) flyY=80;
			if (flyY>loc.maxY-40) flyY=loc.maxY-40;
			if (optSit)
			{
				for each (var b:Box in loc.objs)
				{
					if (b.wall==0 && b.stay && !b.invis && b.leftBound<flyX && b.rightBound>flyX && flyY-b.topBound<80 &&  flyY-b.topBound>-40)
					{
						flyY=b.topBound;
						flyX=b.coordinates.X;
						flyBox=b;
						break;
					}
				}
			}
			if (!loc.collisionUnit(flyX,flyY,objectWidth,objectHeight)) return;
			flyX = int(flyX / 40) * 40 + 20; // Weird math is grid alignment
			flyY = int(flyY / 40) * 40 + 39;
			if (loc.getAbsTile(flyX,flyY).phis == 0) return;
			flyX += 40 * gg.storona;
			flyY += 40;
			if (loc.getAbsTile(flyX, flyY).phis == 0) return;
			flyY += 40;
			if (loc.getAbsTile(flyX, flyY).phis == 0) return;
			flyX += 40 * gg.storona;
			if (loc.getAbsTile(flyX, flyY).phis == 0) return;

			flyX = gg.coordinates.X;
			flyY = gg.coordinates.Y - 1;
		}
		
		function visCelUnit(un:Unit):Boolean
		{
			return loc.isLine(coordinates.X, coordinates.Y - 30, un.coordinates.X, un.coordinates.Y - un.objectHeight / 2);
		}
		
		public override function findCel(over:Boolean=false):Boolean {
			celUnit=null;
			if (gg.invulner) return null;
			for each (var un:Unit in loc.units) {
				if (un.disabled || un.sost>=3 || un.fraction==fraction || un.doop || un.invis || un.invulner || un.noAgro || un.trigDis) continue;
				if (un is UnitTurret && un.aiState<=1) continue;
				var tx = un.coordinates.X - coordinates.X;
				var ty = un.coordinates.Y - coordinates.Y;
				if (tx*tx+ty*ty>rasstVisEn*rasstVisEn) continue;	//если расстояние больше расстояния атаки, игнорировать
				if (optEnW && un.isPlav) continue;	//если враг под водой, игнорировать 
				if (currentWeapon && currentWeapon.damage*un.vulner[currentWeapon.tipDamage]<(optEnW?un.marmor:un.armor)+un.skin+1-currentWeapon.pier) continue;	//если оружие не наносит урона, игнорировать
				if (visCelUnit(un)) {
					setCel(un);
					return true;
				}
			}
			
			return false;
		}
		
		//приказ двигаться
		public function moveto(nx:Number, ny:Number, unmat:Boolean=false)
		{
			if (sost==4 || oduplenie>0) return;
			tempUnmat=unmat;
			flyBox=null;
			if (!loc.base && loc.getAbsTile(nx,ny).visi<0.5) {
				//не лететь в неразведанное место
				return;
			}
			//gotoX=nx, gotoY=ny;
			flyX=nx, flyY=ny+20;
			aiState=3;
			if (optTurn) storona=(flyX > coordinates.X)? 1:-1;
			aiTCh=100;
		}
		
		//приказ атаковать
		public function atk(un:Unit) {
			tempUnmat=false;
			if (visCelUnit(un)) {
				setCel(un);
				flyBox=null;
				aiState=2;
			}
		}
		
		public function call() {
			active=true;
			if (hp<=0 && !optAutores) return;
			if (sost==4 && optAutores) resurrect();
			oduplenie=60;
			vis.alpha=0;
			vis.visible=true;
			aiState=1;
			sost=1;
			addVisual();
			flyX = gg.coordinates.X;
			flyY = gg.coordinates.Y - 20;
			setLevel(gg.pers.level);
			if (loc && loc.units) loc.units[1]=this;
		}
		
		//отзыв
		public function recall() {
			active=false;
			sost=4;
			if (vis.visible) expl();
			vis.visible=false;
			remVisual();
		}
		
		public override function die(sposob:int=0) {
			if (sost>=3) return;
			if (optAutores)	World.w.gui.infoText('petDie', nazv, World.w.pers.petRes);
			else World.w.gui.infoText('petDie2',nazv);
			if (optUncall) {
				recall();
				gg.pet=null;
				gg.childObjs[2]=null;
				gg.currentPet='';
				return;
			}
			if (hpbar) hpbar.visible=false;
			vis.visible=false;
			hp=0;
			poison=stun=cut=0;
			sost=4;
			expl();
			if (optAutores)	gg.noPet=World.w.pers.petRes*30;
			World.w.gui.setPet();
		}
		
		public function resurrect() {
			World.w.gui.infoText('petRes', nazv);
			if (hpbar) hpbar.visible=false;
			hp=Math.min(100,maxhp/2);
			setLevel(gg.pers.level);
			visDetails();
			coordinates.X = gg.coordinates.X;
			coordinates.Y = gg.coordinates.Y - 20;
			oduplenie=60;
			vis.alpha=0;
			cut=0;
			poison=0;
			stun=0;
			vis.visible=true;
			sost=1;
			aiState=1;
			World.w.gui.setPet();
		}
		
		public function repair(hl:Number):Boolean {
			if (hp<0) hp=0;
			if (hp>=maxhp) return false;
			heal(hl,0,false);
			if (sost==4) {
				sost=1;
				if (gg.currentPet==id) {
					World.w.gui.infoText('petRes', nazv);
					setLevel(gg.pers.level);
					visDetails();
					coordinates.X = gg.coordinates.X;
					coordinates.Y = gg.coordinates.Y - 20;
					oduplenie = 60;
					vis.alpha = 0;
					cut=0;
					poison=0;
					stun=0;
					vis.visible=true;
					aiState=1;
					World.w.gui.setPet();
				}
			}
			return true;
		}
		
		//состояния
		//0 - сидит на месте
		//1 - следует
		//2 - атакует
		//3 - движется в указанное место
		//4 - атакует корпусом
		//5 - после атаки корпусом
		
		public override function control() {
			if (sost>=3 || !active) return;
			if (stun) {
				return;
			}
			if ((rasst2<rasstUnmat*rasstUnmat) || celUnit) {
				if (!mater && aiTCh%10==1 && !collisionAll()) mater=true;
			} else {
				mater=false;
			}
			if (tempUnmat) mater=false;
			if (aiTCh>0) aiTCh--;		//счётчик смены состояний
			else {						//смена состояний
				tempUnmat=false;
				if (aiState==0 || aiState==1) {	//выбрать точку следования
					if (rasst2>rasstGG*rasstGG || isPlav) {
						aiState=1;
						getFlyPoint();
						if (optTurn) storona=(flyX > coordinates.X)? 1:-1;
					} else {
						if (optTurn) storona=(flyX > gg.coordinates.X)? -1:1;
					}
				} else if (aiState==2) {
					if (rasst2>rasstGG*rasstGG*9) getFlyPoint();
					if (celUnit==null) setCel(null, celX+Math.random()*300-150, celY+Math.random()*120-60);
				} else if (aiState==4 || aiState==5) {
					aiState=2;
				} else if (aiState==3) {
					if (World.w.t_battle<=0) aiState=1;
					else aiState=2;
				}
				if (gg.dx>2 || gg.dx<-2) aiTCh=int(Math.random()*20)+10;
				else aiTCh=int(Math.random()*100)+30;
			}
			//движение
			if (isFly) {
				flyDX = flyX - coordinates.X;
				flyDY = flyY - coordinates.Y;
				var flyR=Math.sqrt(flyDX*flyDX+flyDY*flyDY);
				if (aiState==0) {
					dy=dx=0;
					spd.x=spd.y=0;
					if (flyBox && !flyBox.stay) {
						aiState=1;
						flyBox=null;
					}
				} if (aiState==2) {
					if (optTurn) storona=(celX > coordinates.X)? 1:-1;
					if (flyR>rasstWeap*0.9 || !mater) {
						spd.x=flyDX;
						spd.y=flyDY;
						norma(spd,Math.min(accel*2,accel*flyR/200));
					} else if (flyR<rasstOut) {	//улетать от цели
						spd.x=-flyDX;
						spd.y=-flyDY/2-3;
						norma(spd,accel);
					} else {
						dy*=0.85;
						dx*=0.85;
						spd.x=spd.y=0;
					}
					if (turnX!=0) {
						dy+=Math.random()*8-4;
						turnX=0;
					}
					if (turnY!=0) {
						dx+=Math.random()*8-4;
						turnY=0;
					}
				} else if (aiState==5) {
					spd.x*=0.95;
					spd.y*=0.95;
					dx*=0.9;
					dy*=0.9;
				} else if (aiState==4) {
				} else {
					if (flyR<20 && flyBox && mater) {	//сесть на предмет
						spd.x=spd.y=0;
						dx = flyX - coordinates.X;
						dy = flyY - coordinates.Y;
						aiState=0;
					} else if (flyR<100 && mater) {
						dy*=0.95;
						dx*=0.95;
						spd.x=spd.y=0;
					} else {
						spd.x=flyDX;
						spd.y=flyDY;
						norma(spd,Math.min(accel*2,accel*flyR/200));
					}
				}
				dx+=spd.x;
				dy+=spd.y;
			}
			if (celUnit && celUnit.fraction==fraction) celUnit=null;
			//поиск цели
			if (aiState<=1 && aiTCh%30==1 && oduplenie<=0) {
				if (findCel() || World.w.t_battle>0) {
					aiState=2;
				}
			} if ((aiState==2 || aiState==5) && aiTCh%15==1) {
				if (celUnit && !celUnit.disabled && celUnit.sost<3 && visCelUnit(celUnit)) {	//цель установлена и видна
					
				} else if (findCel()) {		//найти новую цель
					
				} else {					//успокоиться
					if (World.w.t_battle<=0) aiState=1;
				}
			} else if (aiState==3) {
				//достиг точки назначения
				if (flyR<20) {
					if (World.w.t_battle<=0) aiState=1;
					else aiState=2;
				}
			}
			if (aiState==2 && flyR<rasstWeap && currentWeapon==null && celUnit)
			{
				aiState=4;
				aiTCh=15;
				spd.x = celUnit.coordinates.X - coordinates.X;
				spd.y = celUnit.coordinates.Y - celUnit.objectHeight / 2 - coordinates.Y + objectHeight / 2;
				norma(spd, runSpeed);
			}
			if (aiState==4) {
				if (celUnit) {
					if (attKorp(celUnit)) {
						spd.x*=0.5;
						spd.y*=0.5;
						aiState=5;
						aiTCh=15;
						damage(dam*0.02,Unit.D_INSIDE);
					}
				} else aiState=2;
			}
			
			if (aiState<=1) maxSpeed=walkSpeed;
			else maxSpeed=runSpeed;
	
			//атака
			if (aiState==2 && celUnit && !isPlav) {
				celX = celUnit.coordinates.X;
				celY = celUnit.coordinates.Y - celUnit.objectHeight / 2;
				flyX = celUnit.coordinates.X;
				flyY = celUnit.coordinates.Y - 80;
				if (flyR<=rasstWeap && currentWeapon) currentWeapon.attack();
			}
		}
	}
	
}

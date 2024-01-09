package fe.unit {
	
	import fe.*;
	import fe.weapon.Weapon;
	import fe.weapon.Bullet;
	import fe.graph.Emitter;
	import fe.loc.Tile;
	
	public class UnitDron extends Unit{
		
		var spd:Object;
		var br:Number=0;
		var stuk:int=0;

		public var tr:int=1;
		var weap:String;
		var atkDist:Number=250;
		var aiAgr:Boolean=false;
		var floatX:Number=1, floatY:Number=0;
		var t_float:Number=Math.random();
		var atkRasst:Number=0;
		
		var t_krut:int=0;	//уклонение от пуль

		public function UnitDron(cid:String=null, ndif:Number=100, xml:XML=null, loadObj:Object=null) {
			super(cid, ndif, xml, loadObj);
			if (loadObj && loadObj.tr) {			//из загружаемого объекта
				tr=loadObj.tr;
			} else if (xml && xml.@tr.length()) {	//из настроек карты
				tr=xml.@tr;
			} else if (cid) {						//из заданного идентификатора cid
				tr=int(cid);
			} else {								//случайно по параметру ndif
				tr=Math.floor(Math.random()*2+1);
			}
			id='dron'+tr;
			if (tr==100) id='dront';
			getXmlParam();
			var vClass:Class=Res.getClass('visualDron'+tr,null,visualBloat1);
			if (tr==100) vClass=visualMegaDron;
			vis=new vClass();
			walkSpeed=maxSpeed;
			runSpeed=maxSpeed*3;
			isFly=true;
			mat=1;
			acidDey=1;
			elast=0.6;
			spd=new Object();
			if (tr==100) {
				vis.osn.scaleX=vis.osn.scaleY=1.5;
				aiAgr=true;
				nazv="";
			}

			if (tr==2) aiAgr=true;
			//дать оружие
			if (tr==100) {
				currentWeapon=Weapon.create(this, 'ttweap'+Math.floor(Math.random()*6+1));
			} else currentWeapon=getXmlWeapon(ndif);
			if (currentWeapon) {
				childObjs=new Array(currentWeapon);
				currentWeapon.hold=currentWeapon.holder;
			}
			vis.dis.stop();
			vis.dis.visible=false;
			sndRunOn=true;
		}
		
		public override function save():Object {
			var obj:Object=super.save();
			if (obj==null) obj=new Object();
			obj.tr=tr;
			obj.weap=weap;
			return obj;
		}	

		public override function expl()	{
			newPart('metal',4);
			newPart('miniexpl');
		}
		
		public override function forces() {
			if (isFly) {
				if (t_throw<=0 && dx*dx+dy*dy>maxSpeed*maxSpeed) {
					spd.x=dx;
					spd.y=dy;
					norma(spd,maxSpeed);
					dx=spd.x;
					dy=spd.y;
				}
				if (isPlav) {
					dy*=0.9;
					dx*=0.9;
				}
			} else super.forces();
		}
		
		public override function alarma(nx:Number=-1,ny:Number=-1) {
			super.alarma(nx,ny);
			if (sost==1) {
				aiState=2;
				aiTCh=3;
			}
		}
		
		public override function animate() {
			br+=(dx*1.5-br)/4;
			vis.osn.rotation=br*storona;
			if (celUnit && aiTCh%15==1) {
				vis.dis.visible=true;
				vis.dis.alpha=1;
				vis.dis.rotation=Math.random()*360;
				vis.dis.gotoAndStop(Math.floor(Math.random()*4+1));
			}
			if (vis.dis.alpha>0.1) vis.dis.alpha-=0.2;
			else vis.dis.visible=false;
			//vis.cif.text=aiState;
		}
		
		public override function setWeaponPos(tip:int=0) {
			weaponX=X;
			weaponY=Y-scY/2;
			if (tr>=100) {
				weaponY+=40;
			}
		}
		//состояния
		//0 - летает
		//1 - видит цель, летит к ней
		//2 - потерял цель
		//3 - удаляется для новой атаки
		
		public override function control() {
			if (sost>=3) return;
			if (World.w.enemyAct<=0) {
				return;
			}
			if (stun) {
				return;
			}
			if (t_krut>0) t_krut--;
			if (aiTCh>0) aiTCh--;		//счётчик смены состояний
			else {						//смена состояний
				if (aiSpok==0) {	//перейти в пассивный режим
					aiState=0;
				} else if (aiSpok>=maxSpok) {	//агрессивный
					aiState=1;
				} else {
					aiState=2;
				}
				aiTCh=Math.floor(Math.random()*100)+100;
				if (aiState==0) {		//выбрать случайную цель в пассивном режиме
					celX=X+(Math.random()*300+400)*(isrnd()?1:-1);
					celY=Y-scY/2;
				}
			}
			//поиск цели
			if (World.w.enemyAct>1 && aiTCh%10==1) {
				if (findCel()) {
					stuk=0;
					aiSpok=maxSpok+10;
					if (aiState!=3) aiState=1;
					storona=(celX>X)?1:-1;
				} else {
					if (aiSpok>0) {
						aiSpok--;
						if (aiSpok%10==1) setCel(null, celX+Math.random()*80-40, celY+Math.random()*80-40);
					}
				}
				atkRasst=celDX*celDX+celDY*celDY;
				spd.x=celX-X;
				spd.y=celY-(Y-scY/2);
				norma(spd,aiState==0?accel/2:accel);
				if (aiState==3) {
					dx-=spd.x;
					dy-=spd.y;
				} else if (aiAgr || atkRasst<atkDist*atkDist || aiState==2) {
					dx+=spd.x;
					dy+=spd.y;
				} else {
					t_float+=0.97;
					floatX=Math.sin(t_float);
					floatY=Math.cos(t_float);
					dx+=floatX*accel;
					dy+=floatY*accel;
				}
			}
			
			if (aiState==0) maxSpeed=walkSpeed;
			else maxSpeed=runSpeed;
			
			if (tr==1) storona=(celX>X)?1:-1;
	
			if (turnX!=0) {
				stuk++;
				storona=turnX;
				turnX=0;
				if (aiState==0) celX=X+400*storona;
				if (stuk>5) setCel(null, celX+(Math.random()*80+40)*storona, celY+Math.random()*80-40);
			}
			if (turnY!=0) {
				if (turnY<0) dy=-6;
				turnY=0;
			}
			//атака
			if (World.w.enemyAct>=3 && aiState==1 && celUnit && shok<=0) {
				critCh=0;
				if (celUnit && (atkRasst>atkDist*atkDist)) currentWeapon.attack();
				if (attKorp(celUnit,1)) {
					celY+=20;
					aiTCh=Math.floor(Math.random()*20)+20;
					aiState=3;
				}
			}
		}
		
		public override function udarBullet(bul:Bullet, sposob:int=0):int {
			if (t_krut>0 || tr!=3
				|| (bul.targetObj==this)
				|| (bul.vel>=1000)
				|| (bul.tipBullet==1 && bul.weap && Math.random()<6/bul.weap.rapid)
				|| (bul.tipBullet==0 && Math.random()<bul.vel/300)
			) {
				return super.udarBullet(bul, sposob);
			} else {
				var p:Object={x:bul.dy, y:-bul.dx};
				if (Math.random()<0.5) {
					p.x=-p.x; p.y=-p.y;
				}
				norma(p,maxSpeed*3);
				dx+=p.x;
				dy+=p.y;
				if (World.w.showHit==1 || World.w.showHit==2 && t_hitPart==0) {
					visDamDY-=15;
					t_hitPart=10;
					if (sost<3 && isVis && !invulner && bul.flame==0) numbEmit.cast(loc,X,Y-scY/2+visDamDY,{txt:txtMiss, frame:10, rx:40, alpha:0.5});
				}
				t_krut=45;
				return -1;
			}
		}
	}
	
}

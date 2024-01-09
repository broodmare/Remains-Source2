package fe.unit {
	import flash.filters.GlowFilter;
	import flash.display.MovieClip;
	
	import fe.weapon.*;
	import fe.*;
	import fe.loc.Location;
	import fe.serv.BlitAnim;
	import fe.serv.LootGen;
	import fe.graph.Emitter;
	
	public class UnitBossEncl extends UnitPon{
		
		public var tr:int=1;
		var weap:String;
		public var scrAlarmOn:Boolean=true;
		public var controlOn:Boolean=true;
		public var kol_emit=8;
		public var called:int=0;
		public var coord:Object;

		public function UnitBossEncl(cid:String=null, ndif:Number=100, xml:XML=null, loadObj:Object=null) {
			super(cid, ndif, xml, loadObj);
			id='bossencl';
			if (xml && xml.@tr.length()) {	//из настроек карты
				tr=xml.@tr;
			}
			//взять параметры из xml
			getXmlParam();
			//boss=true;
			aiTCh=30;
			aiVNapr=1;
			if (tr==1) {
				currentWeapon=Weapon.create(this,'lmg');
				armor=20;
				vulner[D_BUL]=vulner[D_PHIS]=vulner[D_BLADE]=0.7;
			}
			if (tr==2) {
				currentWeapon=Weapon.create(this,'quick');
				marmor=20;
				//currentWeapon.damage;
				vulner[D_LASER]=vulner[D_PLASMA]=vulner[D_SPARK]=0.7;
				blitId='sprEnclboss2';
			}
			if (tr==3) {
				currentWeapon=Weapon.create(this,'mlau');
				currentWeapon.speed=12;
				currentWeapon.accel=0.6;
				currentWeapon.reload=30;
				currentWeapon.damageExpl*=0.6;
				armor=marmor=10;
				vulner[D_EXPL]=vulner[D_FIRE]=vulner[D_CRIO]=0.7;
				blitId='sprEnclboss3';
			}
			initBlit();
			animState='fly';
			if (currentWeapon) weap=currentWeapon.id;
			else weap='';
			if (currentWeapon) childObjs=new Array(currentWeapon);
			if (currentWeapon && currentWeapon.uniq) {
				currentWeapon.updVariant(1);
			}
			isFly=true;
			aiNapr=storona;
		}
		
		public override function die(sposob:int=0) {
			super.die(3);
			coord['liv'+tr]=false;
		}
		
		public override function putLoc(nloc:Location, nx:Number, ny:Number) {
			super.putLoc(nloc,nx,ny);
			if (nloc.unitCoord==null) {
				nloc.unitCoord=new Coord(nloc);
			}
			coord=nloc.unitCoord;
			coord['liv'+tr]=true;
		}

		public override function setLevel(nlevel:int=0) {
			super.setLevel(nlevel);
			var wMult=(1+level*0.08);
			var dMult=1;
			if (World.w.game.globalDif==3) dMult=1.2;
			if (World.w.game.globalDif==4) dMult=1.5;
			hp=maxhp=hp*dMult;
			dam*=dMult;
			if (currentWeapon) {
				currentWeapon.damage*=dMult;
			} 
		}
		
		public override function animate() {
			var cframe:int;
			var revers:Boolean=false;
			if (isFly) {
				animState='fly';
			} else {
				animState='stay';
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
		
		public override function setWeaponPos(tip:int=0) {
			weaponX=X;
			weaponY=Y-scY*0.58;
		}
		
		public override function dropLoot() {
			super.dropLoot();
			if (currentWeapon) {
				if (currentWeapon.vis) currentWeapon.vis.visible=false;
				var cid:String=currentWeapon.id;
				if (currentWeapon.variant>0) cid+='^'+currentWeapon.variant;
				LootGen.lootId(loc,currentWeapon.X,currentWeapon.Y,cid,0);
			}
		}
		
/*		public override function damage(dam:Number, tip:int, bul:Bullet=null, tt:Boolean=false):Number {
			var td:Number=super.damage(dam, tip, bul,tt);
			if (tr==2 && World.w.game.globalDif>1) {
				var tc:int=Math.floor((maxhp-hp)/maxhp*4);
				if (tc>called) {
					loc.enemySpawn(true,true);
					called++;
				}
			}
			return td;
		}*/

		function emit() {
			var un:Unit=loc.createUnit('vortex',X,Y-scY/2,true);
			un.fraction=fraction;
			un.oduplenie=0;
			emit_t=500;
			kol_emit--;
		}
		
		public override function setNull(f:Boolean=false) {
			super.setNull(f);
			//вернуть в исходную точку
			if (begX>0 && begY>0) setPos(begX, begY);
			dx=dy=0;
			setWeaponPos();
			aiState=aiSpok=0;
		}
		
		var minY:int=250;
		var maxY:int=850;
		var minX:int=1000;
		var maxX:int=1600;
		var sinX:Number=Math.random()*10;
		var sinDX:Number=Math.random()*0.1+0.02;
		
		var emit_t:int=0;
		
		//aiState
		//0 - стоит на месте
		//1 - летает и атакует
		//2 - меняет оружие
		
		public override function control() {

			//World.w.gui.vis.vfc.text=(celUnit==null)?'no':(celUnit.nazv+celDY);
			//если сдох, то не двигаться
			if (sost==3) return;
			if (stun) {
				aiState=0; aiTCh=3; walk=0;
			}
			
			t_replic--;
			var jmp:Number=0;
			//return;
			
			if (loc.gg.invulner) return;
			if (World.w.enemyAct<=0) {
				celY=Y-scY;
				celX=X+scX*storona*2;
				return;
			}
			
			//таймер смены состояний
			if (aiTCh>0) aiTCh--;
			else {
					aiState=1;
					aiTCh=Math.floor(Math.random()*60+150);
				/*if (aiState==0 || aiState==2) {
				} else if (aiState==1) {
					aiState=2;
					aiTCh=45;
					sinDX=Math.random()*0.1+0.02;
				}*/
			}
			//поиск цели
			//trace(aiState)
			if (aiTCh%40==1) {
				if (loc.gg.pet && loc.gg.pet.sost==1 && isrnd(0.4)) setCel(loc.gg.pet);
				else setCel(loc.gg);
			}
			//направление
			storona=(celDX>0)?1:-1;

			
			destroy=0;
			//поведение при различных состояниях
			if (aiState==0) {
			} else {
				sinX+=sinDX;
				if (Y<minY && dy<maxSpeed) {
					dy+=accel;
					aiVNapr=1;
				}
				if (Y>maxY && dy>-maxSpeed) {
					dy-=accel;
					aiVNapr=-1;
				}
				if (Y>=minY && Y<=maxY) {
					if (aiVNapr==1 && dy<maxSpeed) dy+=accel;
					if (aiVNapr==-1 && dy>-maxSpeed) dy-=accel;
				}
				if (X<minX && dx<maxSpeed) {
					dx+=accel;
				}
				if (X>maxX && dx>-maxSpeed) {
					dx-=accel;
				}
				if (X>=minX && X<=maxX) {
					dx+=Math.sin(sinX)*accel/2;
				}
			} 
			if (aiState==1) {
				attack();
			}

		}
		
		public function attack() {
			if (celUnit) {	//атака холодным оружием без левитации или корпусом
				attKorp(celUnit);
				if (coord.tr==tr && coord.t1>45) currentWeapon.attack();
			}
		}
		
		public override function command(com:String, val:String=null) {
			if (com=='off') {
				walk=0;
				controlOn=false;
			} else if (com=='on') {
				controlOn=true;
			}
		}
		
	}
}

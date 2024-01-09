package fe.unit {
	import flash.filters.GlowFilter;
	import flash.display.MovieClip;
	
	import fe.weapon.*;
	import fe.*;
	import fe.loc.Location;
	import fe.serv.LootGen;
	import fe.graph.Emitter;
	
	public class UnitBossDron extends Unit{
		
		public var controlOn:Boolean=true;
		public var kol_emit=5;
		var spd:Object;
		var dopWeapon:Weapon;
		var thWeapon:Weapon;
		var shitMaxHp:Number=500;
		var visshit:MovieClip;
		
		var emit_t:int=120;
		
		var moveX:Number=0, moveY:Number=0;
		var t_atk:int=100;
		var t_shit:int=300;
		var kolth:int=0;
		var speedBonus:Number=1;

		public function UnitBossDron(cid:String=null, ndif:Number=100, xml:XML=null, loadObj:Object=null) {
			super(cid, ndif, xml, loadObj);
			id='bossdron';
			
			//взять параметры из xml
			vis=new visualMegaDron();
			vis.osn.gotoAndStop(1);
			visshit=new visShit();
			vis.addChild(visshit);
			visshit.gotoAndStop(1);
			visshit.visible=false;
			visshit.y=-70;
			visshit.scaleX=visshit.scaleY=1.7;
			
			getXmlParam();
			walkSpeed=maxSpeed;
			plavSpeed=maxSpeed;
			boss=true;
			isFly=true;
			aiTCh=80;
			undodge=1;
			
			shitArmor=15;
			mater=false;
			collisionTip=0;
			
			//дать оружие
			currentWeapon=Weapon.create(this, 'dronmlau');
			//dopWeapon=Weapon.create(this,'mercgr');
			thWeapon=Weapon.create(this,'drongr');
			(thWeapon as WThrow).kolAmmo=100000;
			childObjs=new Array(currentWeapon, thWeapon);
			
			spd=new Object();
			
			timerDie=150;
		}
		
		public override function dropLoot() {
			newPart('baleblast');
			Snd.ps('bale_e');
			//currentWeapon.vis.visible=false;
			super.dropLoot();
		}
		
		public override function setLevel(nlevel:int=0) {
			super.setLevel(nlevel);
			var wMult=(1+level*0.07);
			var dMult=1;
			if (World.w.game.globalDif==3) dMult=1.2;
			if (World.w.game.globalDif==4) dMult=1.5;
			hp=maxhp=hp*dMult;
			shitMaxHp*=(1+level*0.12)*dMult;
			dam*=dMult;
			/*if (dopWeapon) {
				dopWeapon.damageExpl*=wMult*dMult;
				dopWeapon.damage*=wMult*dMult;
			}*/
			if (thWeapon) {
				thWeapon.damageExpl*=wMult*dMult;
				thWeapon.damage*=wMult*dMult;
			}
		}
		
		public override function expl()	{
			newPart('metal',22);
		}
		
		public override function setNull(f:Boolean=false) {
			if (sost==1) {
				if (dopWeapon) dopWeapon.setNull();
			}
			super.setNull(f);
		}

		public override function animate() {
			thWeapon.vis.visible=false;
			//щит
			if (visshit && !visshit.visible && shithp>0) {
				visshit.visible=true;
				visshit.gotoAndPlay(1);
			}
			if (visshit && visshit.visible && shithp<=0) {
				visshit.visible=false;
				visshit.gotoAndStop(1);
				Emitter.emit('pole',loc,X,Y-50,{kol:12,rx:100, ry:100});
			}
			if (sost==2) {
				if (isrnd(0.3-timerDie/500)) {
					Emitter.emit('expl',loc,X+Math.random()*120-60,Y-Math.random()*120);
					newPart('metal');
					Snd.ps('expl_e');
				}
			}
		}
		
		public override function setVisPos() {
			if (vis) {
				if (sost==2) {
					vis.x=X+(Math.random()-0.5)*(150-timerDie)/15;
					vis.y=Y+(Math.random()-0.5)*(150-timerDie)/15;;
				} else {
					vis.x=X,vis.y=Y;
				}
			}
		}
		
		function emit() {
			if (kolChild>=kol_emit) return;
			var un:Unit=loc.createUnit('dron',X,Y-scY/2,true);
			un.fraction=fraction;
			un.inter.cont='';
			un.mother=this;
			un.sndMusic=null;
			un.oduplenie=0;
			kolChild++;
			emit_t=500;
		}
		

		//aiState
		//0 - стоит на месте
		//1 - движется
		
		public override function control() {

			if (sost==3) return;
			if (sost==2) {
				dx=0;
				dy=0;
				return;
			}
			
			if (loc.gg.invulner) return;
			if (World.w.enemyAct<=0) {
				return;
			}
			if (t_shit>0) t_shit--;
			
			if (loc.active) aiState=1;
			else aiState=0;
			
			aiTCh++;
			if (aiState==1 && aiTCh%10==1) {
				if (loc.gg.pet && loc.gg.pet.sost==1 && isrnd(0.2)) setCel(loc.gg.pet);
				else setCel(loc.gg);
			}
			if (World.w.gg.isFly) speedBonus=1.6;
			else speedBonus=1;
			celDX=celX-X;
			celDY=celY-Y;
			storona=(celDX>0)?1:-1;
			var dist2:Number=celDX*celDX+celDY*celDY;
			var dist:Number=(moveX-X)*(moveX-X)+(moveY-Y)*(moveY-Y);
			//поведение при различных состояниях
			if (aiState==0) {
				walk=0;
			} else if (aiState==1) {
				moveX=loc.gg.X;
				moveY=loc.gg.Y;
				spd.x=moveX-X;
				spd.y=moveY-Y;
				norma(spd,Math.min(accel,accel*dist/1000));
				
				maxSpeed=walkSpeed*(2-(hp/maxhp))*(1-Math.sin(aiTCh/12)*0.3)*speedBonus;
				dx+=spd.x;
				dy+=spd.y;
				spd.x=dx;
				spd.y=dy;
				norma(spd,maxSpeed);
				dx=spd.x;
				dy=spd.y;
				
				if (dist<1000) {
					dx*=0.8, dy*=0.8;
				}
				attack();
				emit_t--;
				if (emit_t<=0) emit();
			}
		}
		
		function castShit() {
			if (shithp<=0 && t_shit<=0 && (World.w.game.globalDif==4 || World.w.game.globalDif==3 && hp<maxhp/2)) {
				shithp=shitMaxHp;
				t_shit=1000;
			}
		}
		
		public function attack() {
			if (sost!=1) return;
			if (aiState==1 && celUnit) {	//атака холодным оружием без левитации или корпусом
				attKorp(celUnit,1);
			}
			t_atk--;
			if (t_atk<=0) {
				t_atk=Math.floor(Math.random()*60+40);
				if (isrnd()) currentWeapon.attack();
				else kolth=3;
			}
			if (kolth>0) {
				thWeapon.attack();
				if (thWeapon.is_shoot) {
					kolth--;
					thWeapon.is_shoot=false;
				}
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

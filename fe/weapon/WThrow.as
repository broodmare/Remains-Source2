package fe.weapon  {
	
	import fe.*;
	import fe.unit.Unit;
	import fe.unit.UnitPlayer;
	import fe.unit.Mine;
	import flash.display.Graphics;
	
	
	public class WThrow  extends Weapon{
		
		public var kolAmmo:int=4;
		public var detTime:int=75;
		var throwTip:int=0;
		var radio:Boolean=false;
		
		var brake=2, skok:Number=0.4, tormoz:Number=0.6, bumc:Boolean=false;
		public var sndFall:String='';
		
		
		public function WThrow(own:Unit, nid:String, nvar:int=0) {
			super(own,nid,nvar);
			noPerc=true;
			vBullet=vWeapon;
			animated=false;
			vis.gotoAndStop(1);
			holder=1;
			ammo=id;
			var node=AllData.d.weapon.(@id==id)[0];
			if (node.@throwtip>0) throwTip=node.@throwtip;
			if (throwTip>0) lvlNoUse=true;
			if (node.char.length() && node.char[0].@time>0) detTime=node.char[0].@time;
			if (node.char.length() && node.char.@radio.length()) radio=true;
			if (node.phis.length() && node.phis[0].@bumc>0) bumc=true;
			if (node.snd.length() && node.snd[0].@fall.length()) sndFall=node.snd[0].@fall;
		}

		public override function attack(waitReady:Boolean=false):Boolean {
			if (!waitReady && !World.w.alicorn && !auto && t_auto>0) {
				t_auto=3;
				return false;
			}
			skillConf=1;
			if (owner.player && World.w.weaponsLevelsOff) {
				if (lvlNoUse) {
					if ((owner as UnitPlayer).pers.getWeapLevel(skill)<lvl) {
						World.w.gui.infoText('weaponSkillLevel');
						return false;
					}
				} else {
					var razn=lvl-(owner as UnitPlayer).pers.getWeapLevel(skill);
					if (razn==1) skillConf=0.75;
					else if (razn==2) skillConf=0.5;
					else if (razn>2) {
						World.w.gui.infoText('weaponSkillLevel');
						return false;
					}
				}
			}
			if (t_attack<=0) {
				if (getAmmo()) {
					t_attack=rapid;
					//shoot();
				}
			}
			return true;
		}
		
		private function getVel(rx:Number, ry:Number, sk:Number):Number {
			return Math.min(speed*sk,Math.sqrt(rx*rx+ry*ry)/10*sk-ry/10*sk)
		}
		private function getRot(rx:Number, ry:Number, rvel:Number):Number {
			return -rx/(rvel+0.0001)/100;
		}
		
		protected override function shoot():Bullet {
			var sk=1;
			if (owner) {
				sk=owner.weaponSkill;
				if (owner.player) sk=weaponSkill;
			}
			var r=(Math.random()-0.5)*(deviation/(sk+0.01)+owner.mazil)*3.1415/180;
			var rasstx=owner.celX-X;
			var rassty=owner.celY-Y;
			if (throwTip==1) {
				var un:Mine = new Mine(id);
				un.massa=un.massaMove;
				un.putLoc(World.w.loc,X,Y);
				//un.loc=World.w.loc;
				un.loc.addObj(un);
				un.loc.units.push(un);
				un.fraction=owner.fraction;
				if (un.fraction==Unit.F_PLAYER) warn=0;
				un.damage1*=(1+(sk-1)*0.5);
				un.explTime*=0.3;
				un.explRadius*=explRadMult;
				un.reloadTime=75;
				un.vis.gotoAndStop(1);
				un.setVis(true);
				un.inter.mine=1;
				//un.setPos(X,Y);
				if (un.collisionAll()) un.setPos(owner.X,owner.Y);
				if (un.collisionAll()) un.fixed=true;
				if (owner && owner.player && World.w.pers.sapper>1) {
					un.damage1*=World.w.pers.sapper;
					un.vulner[Unit.D_EXPL]=un.vulner[Unit.D_PLASMA]=0;
				}
			} else {
				b = new PhisBullet(owner,X,Y,vBullet);
				b.weap=this;
				b.vel=getVel(rasstx, rassty, sk*skillConf);
				b.rot=rot+r+getRot(rasstx, rassty, b.vel);
				b.liv=detTime;
				b.dx=Math.cos(b.rot)*b.vel;
				b.dy=Math.sin(b.rot)*b.vel;
				(b as PhisBullet).bumc=bumc;
				b.damage=(damage+damAdd)*damMult*(1+(sk-1)*0.5);
				b.damageExpl=(damageExpl)*damMult*(1+(sk-1)*0.5)*skillConf;
				b.nazv=nazv;
				(b as PhisBullet).skok=skok;
				(b as PhisBullet).tormoz=tormoz;
				(b as PhisBullet).brake=brake;
				setBullet(b);
				(b as PhisBullet).dr=(throwTip==2)?0:b.dx;// owner.storona*Math.random()*15+5;
				(b as PhisBullet).lip=(throwTip==2);
				b.vis.play();
				b.critDamMult=1;
				(b as PhisBullet).sndHit=sndFall;
				if (owner.player) {
					if (World.w.pers.grenader && !World.w.ctr.keyRun) (b as PhisBullet).isSensor=true;
				}
				loc.newGrenade(b);
			}
			owner.isShoot=true;
			if (sndShoot!='') Snd.ps(sndShoot,X,Y);
			is_shoot=true;
			hold=0;
			if (owner.player && loc.train) {
				World.w.invent.items[ammo].kol++;
				World.w.invent.mass[2]+=World.w.invent.items[ammo].mass;
			}
			t_auto=3;
			return b;
		}
		
		public override function setTrass(gr:Graphics) {
			skillConf=1;
			var razn=lvl-World.w.pers.getWeapLevel(skill);
			if (razn==1) skillConf=0.75;
			else if (razn>=2) skillConf=0.5;
			var rot3=Math.atan2(World.w.celY-Y, World.w.celX-X);
			trasser.loc=owner.loc;
			var rasstx=World.w.celX-X;
			var rassty=World.w.celY-Y;
			trasser.X=trasser.begx=X;
			trasser.Y=trasser.begy=Y;
			trasser.ddy=World.ddy;
			trasser.skok=skok;
			trasser.tormoz=tormoz;
			trasser.brake=brake;
			var bvel=0;
			if (owner.player) bvel=getVel(rasstx, rassty, weaponSkill*skillConf);
			else bvel=getVel(rasstx, rassty, owner.weaponSkill*skillConf);
			var	brot=rot3+getRot(rasstx, rassty, bvel);
			trasser.dx=trasser.begdx=Math.cos(brot)*bvel;
			trasser.dy=trasser.begdy=Math.sin(brot)*bvel;
			trasser.liv=detTime;
			if (throwTip==0 && !bumc) trasser.is_skok=true;
			trasser.trass(gr);
		}

		public override function reloadWeapon() {
			
		}
		
		public function getAmmo():Boolean {
			if (owner.player) {
				return (owner as UnitPlayer).getInvAmmo(ammo,1,1,true)>0
			} else {
				if (kolAmmo<=0) {
					return false;
				} else {
					kolAmmo--
					return true;
				}
			}
			return false;
		}
		
		
		public override function animate() {
			super.animate();
			vis.rotation=0;
			vis.scaleX=1;
			if (t_attack>0 || kolAmmo<=0 || owner.player && (owner as UnitPlayer).getInvAmmo(ammo)<=0) vis.alpha=0;
			else vis.alpha=1;
		}
		
		public override function detonator():Boolean {
			if (radio) {
				for each (var un:Unit in loc.units) {
					if ((un is Mine) && un.id==id) {
						(un as Mine).activate();
					}
				}				
				return true;
			} else return false;
		}
		
		public override function setNull(f:Boolean=false) {
			super.setNull();
			//initReload();
		}
		
	}
	
}

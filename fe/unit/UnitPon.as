package fe.unit {
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import fe.Snd;
	
	import fe.World;
	
	public class UnitPon extends Unit{
		
		public var teleColor:uint=0;
		protected var teleFilter:GlowFilter;
		

		
		protected var footstepVol:Number=0.2;
		
		public function UnitPon(cid:String=null, ndif:Number=100, xml:XML=null, loadObj:Object=null) {
			super(cid, ndif, xml, loadObj);
			blood=1;
		}
		//положение оружия
		public override function setWeaponPos(tip:int=0) {
				if (weaponKrep==0) {			//телекинез
					if (storona>0 && celX>X2 || storona<0 && celX<X1) weaponX=X+scX*1*storona;
					else weaponX=X;
					if (isLaz) weaponX=X;
					if (loc.getTile(Math.floor((weaponX+storona*15)/World.tileX),Math.floor(weaponY/World.tileY)).phis==1) weaponX=X;
					if (tip==1) weaponY=Y-scY*0.4;
					else weaponY=Y-scY*0.7;
				} else if (tip==1 || tip==2 || tip==4) {	 //в зубах	
					weaponX=X;
					weaponY=Y-scY*0.5;
				} else { //сбоку
					weaponX=X;
					weaponY=Y-scY*0.5;
				}
		}
		
		public function weaponLevit() {
			if (!currentWeapon || !teleFilter) return;
			if (weaponKrep==0 && currentWeapon.tip!=5) {
				if (currentWeapon.vis.kor) currentWeapon.vis.kor.filters=[teleFilter];
				else currentWeapon.vis.filters=[teleFilter];
			} 
		}
		
		
		public function sndStep(faza:int,tip:int=0) {
			if (loc==null || !loc.active) return;
			var nstep:int;
			var nleg:int;
			var sst='footstep';
			if (mat==1) sst='metalstep';
			if (tip==0) {
				nleg=Math.floor(Math.random()*4)+1;
			} else if (tip==1) {
				nstep=faza%16;
				if (nstep==5) nleg=1;
				else if (nstep==7) nleg=4;
				else if (nstep==13) nleg=2;
				else if (nstep==15) nleg=3;
				else return;
			} else if (tip==2) {
				nstep=faza%8;
				if (nstep==1) nleg=4;
				else if (nstep==2) nleg=1;
				else if (nstep==5) nleg=2;
				else if (nstep==6) nleg=3;
				else return;
			} else if (tip==3) {
				nstep=faza%14;
				if (nstep==4) nleg=4;
				else if (nstep==6) nleg=1;
				else if (nstep==10) nleg=2;
				else if (nstep==12) nleg=3;
				else return;
				Snd.ps('lazstep'+nleg,X,Y,0,(footstepVol*2-volMinus)*Snd.stepVol);
				return;
			} else if (tip==4) {
				nstep=faza%24;
				if (nstep==4) nleg=4;
				else if (nstep==9) nleg=1;
				else if (nstep==16) nleg=2;
				else if (nstep==21) nleg=3;
				else return;
			}
			var rnd=isrnd()?'a':'';
			if (stayMat==1) sst='metalstep';
			Snd.ps(sst+nleg+rnd,X,Y,0,(footstepVol-volMinus)*Snd.stepVol);
		}
		
		protected override function sndFall() {
			if (loc==null || !loc.active) return;
			var rnd=isrnd()?'a':'';
			var nleg:int;
			var sst='footstep';
			if (stayMat==1) sst='metalstep';
			nleg=Math.floor(Math.random()*4)+1;
			Snd.ps(sst+nleg+rnd,X,Y,0,footstepVol-volMinus);
			nleg=Math.floor(Math.random()*4)+1;
			Snd.ps(sst+nleg+rnd,X,Y,0,footstepVol-volMinus);
		}
		
		public override function command(com:String, val:String=null) {
			super.command(com,val);
		}


//**********************************************************************************************************		
	}
		
//**********************************************************************************************************		
	
}

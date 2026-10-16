package fe.game.domain.location.factories {

	import fe.game.GameContainer;
	import fe.game.domain.location.Location;
	import fe.game.domain.location.tile.Tile;
	import fe.game.domain.objects.Box;
	import fe.game.domain.units.Unit;
	import fe.game.domain.units.UnitPhoenix;
	import fe.game.domain.units.UnitTransmitter;
	import fe.game.domain.units.UnitTurret;

	// Builds units for a location without adding them to it. The location registers what comes back
	public class UnitFactory {

		// A unit of type tip at nx, ny (in tiles, or in pixels when abs), placed in loc but not added to it. Null when nothing should spawn
		public static function createUnit(loc:Location, tip:String, nx:int, ny:int, abs:Boolean=false, xml:XML=null, cid:String=null):Unit {
			var loadObj:Object=null;
			var un:Unit;
			var scid:String;
			var hero:int=0;
			var inWater:Boolean=false;
			var s:String;
			var enl:int;
			var size:int;

			if (loc.land.rnd && tip=='transm') {
				if ((xml==null || xml.@on.length()==0) && Math.random()<0.5) return null;
			}

			if (xml && xml.@trigger.length() && GameContainer.reference.game.triggers[xml.@trigger]=='1') return null;

			if (xml && xml.@code.length() && GameContainer.reference.game.objs.hasOwnProperty(xml.@code)) loadObj=GameContainer.reference.game.objs[xml.@code];

			//не генерировать юнита, который сдох
			if (loadObj && loadObj.dead>0 && loadObj.loot!=2) return null;

			if ((loc.biom == 1 || loc.biom == 5) && abs == false) inWater = loc.getTile(nx, ny).water > 0;

			s=randomUnit(loc, tip, inWater); //определить, является ли юнит случайным, если да, то сгенерировать его id

			//если тип был случайным и удалось сгенерировать его id
			if (s!='') {
				if (cid) scid=cid;
				else scid=randomCid(loc, s);
				if (s=='slmine') s='slime';
				un=Unit.create(s,loc.locDifLevel,xml,loadObj,scid);
			}

			//если юнит не был случайным, или не получилось сгенерировать по id=s, попробовать сгенерировать по id=tip
			if ((s=='' && !loc.homeStable) || un==null) {
				if (cid) scid=cid;
				else scid=randomCid(loc, tip);
				un=Unit.create(tip,loc.locDifLevel,xml,loadObj,scid);
			}

			if (un==null) return null;

			enl = loc.enemyLevel;
			if (loc.land.rnd && loc.landProb=='') { //геройский юнит
				if (Math.random()<Math.min(0.05,loc.locDifLevel/100+0.02)) hero=Math.floor(Math.random()*4+1);
			}

			if (hero==0 && un.boss==false) enl=Math.round(enl*(1.1-Math.random()*0.4));

			un.setLevel(enl);
			un.setHero(hero);

			if (abs) {
				un.putLoc(loc,nx,ny);
			}
			else {
				size = Math.floor((un.boundingBox.width - 1) / 40)+1;
				un.putLoc(loc,(nx+0.5*size)*Tile.tileX,(ny+1)*Tile.tileY-1);
			}

			if (loc.homeStable) {
				un.fraction=Unit.F_PLAYER;
				un.warn=0;
			}

			if (loc.homeAtk && un is UnitTurret) (un as UnitTurret).hack(2);

			return un;
		}

		//создать феникса, сидящего на ящике
		public static function createPhoenix(loc:Location, box:Box):Unit {
			var un:Unit;

			if (box.wall || !box.shelf) return null;

			if (loc.collisionUnit(box.coordinates.X, box.boundingBox.top - 1, 38, 38)) return null;

			un=new UnitPhoenix();
			un.putLoc(loc, box.coordinates.X, box.boundingBox.top-1);

			return un;
		}

		//создать передатчик на ящике
		public static function createTransmitter(loc:Location, box:Box):Unit {
			var un:Unit;

			if (box.wall || !box.shelf) return null;

			if (loc.land.rnd && Math.random()<0.5) return null;

			if (loc.collisionUnit(box.coordinates.X, box.boundingBox.top - 1, 30, 20)) return null;

			un=new UnitTransmitter('box');
			un.setLevel(loc.enemyLevel);
			un.putLoc(loc, box.coordinates.X, box.boundingBox.top - 1);

			return un;
		}
		
		//определение id случайного юнита
		public static function randomUnit(loc:Location, tip:String, inWater:Boolean=false):String {
			var s:String='';
			switch (tip) {
				case 'enl2':
					if (loc.biom==10) s='stabpon';
					else if (loc.tipEnemy==0) s='zombie';
					else if (loc.tipEnemy==2) {
						if (loc.biom==2 && loc.locDifLevel>=12 && Math.random()<Math.min(loc.locDifLevel/100,0.15)) s='eqd';
						else if (loc.locDifLevel>=5 && Math.random()<0.1) s='landturret';
						else if (loc.locDifLevel>=6 && Math.random()<Math.min(loc.locDifLevel/40,0.3)) s='gutsy';
						else if (loc.locDifLevel>=2 && Math.random()<Math.min(loc.locDifLevel/10,0.5)) s='protect';
						else s='robot';
					} 
					else if (loc.tipEnemy==3) s='slaver';
					else if (loc.tipEnemy==4) s='merc';
					else if (loc.tipEnemy==5) s='alicorn';
					else if (loc.tipEnemy==6) s='zebra';
					else if (loc.tipEnemy==7) {
						if (Math.random()<0.4) {
							if (Math.random()<0.5) s='gutsy';
							else s='protect';
						}
						else s='ranger';
					}
					else if (loc.tipEnemy==8) {
						if (Math.random()<0.75) s='zombie';
						else s='necros'
					}
					else if (loc.tipEnemy==9) {
						if (Math.random()<0.1) s='hellhound';
						else if (Math.random()<0.07) s='landturret';
						else s='encl';
					}
					else if (loc.tipEnemy==10) s='hellhound';
					else if (loc.tipEnemy==11) {
						if (Math.random()<0.3) s='hellhound';
						else s='encl';
					}
					else s='raider';
				break;
				case 'enl1':
					if (loc.biom==10 || loc.biom==11) return '';
					if ((loc.biom==1 || loc.biom==5) && inWater) {
						s='fish';
					}
					else if (loc.biom==5) {
						if (Math.random()<0.3) s='scorp3';
						else s='slime';
					}
					else if (loc.biom==6) {
						s='roller';
					}
					else if (loc.tipEnemy==2 && loc.locDifLevel>=4 || loc.tipEnemy==7 || loc.tipEnemy==9 || loc.tipEnemy==10) {
						if ((loc.landX+loc.landY)%2==0) s='roller';
						else s='msp';
					}
					else if (loc.tipEnemy==0 || loc.tipEnemy==5 || loc.tipEnemy==6) {
						if (loc.locDifLevel>=2 && Math.random()<Math.min(loc.locDifLevel/30,0.5)) {
							s='scorp';
						}
						else if ((loc.landX+loc.landY)%2==0) s='slime';
						else s='ant';
						if (loc.biom==1 && Math.random()<0.25) s='rat';
					}
					else if (loc.locDifLevel>=2 && Math.random()<Math.min(loc.locDifLevel/30,0.5)) s='molerat';
					else if (Math.random()<0.6) s='tarakan';
					else s='rat';
				break;
				case 'enc1':
					if (loc.biom==10) {
						s='turret';
					}
					else if ((loc.biom==1 || loc.biom==5) && inWater) {
						s='fish';
					}
					else if (loc.biom==5) {
						if ((loc.landX+loc.landY)%2==0) s='bloodwing';
						else s='slime';
					}
					else if (loc.biom==6 || loc.biom==4) {
						s='cturret';
					}
					else if (loc.tipEnemy==0 || loc.tipEnemy==5 || loc.tipEnemy==6) {
						if (loc.biom==1 && Math.random()<0.6) s='slime';
						else s='bloodwing';
					}
					else s='turret';
				break;
				case 'enf1':
					if (loc.biom==10) return '';
					if ((loc.biom==1 || loc.biom==5) && inWater) {
						s='fish';
					}
					else if (loc.biom==5) {
						s='bloat';
					} 
				else if (loc.tipEnemy==0 || loc.tipEnemy==5) s='bloat';
					else if ((loc.tipEnemy==1 || loc.tipEnemy==3 || loc.tipEnemy==4 || loc.tipEnemy==6) && loc.locDifLevel>=3) s='vortex';
					else if (loc.tipEnemy==2 && loc.locDifLevel>=3) s='spritebot';
					else if (loc.tipEnemy==11 || loc.tipEnemy==7 || loc.tipEnemy==9 || loc.tipEnemy==10 || loc.tipEnemy==2 && loc.locDifLevel>10 && Math.random()<Math.min(loc.locDifLevel/40,0.5)) s='dron';
				break;
				case 'lov':
					if (loc.biom==10 || loc.biom==11) return '';
					if (loc.biom==5) {
						s='slmine';
					}
					else if (loc.tipEnemy==0) {
						if ((loc.landX+loc.landY)%2==0) s='slmine';
						else s='trap';
					}
					else if ((loc.tipEnemy==1 || loc.tipEnemy==3 || loc.tipEnemy==4 || loc.tipEnemy==6)&&(loc.landX+loc.landY)%2==0) {
						if (loc.locDifLevel>=10 && Math.random()<0.5) s='trridge';
						else if (Math.random()<0.5) s='trplate';
						else s='trcans';
					}
					else if ((loc.biom==2 && loc.tipEnemy==2 || loc.tipEnemy==7 || loc.tipEnemy==9) &&(loc.landX+loc.landY)%2==0) {
						s='trlaser';
					}
					else s='mine';
				break;
			}
			return s;
		}
		
		//определение сid случайного юнита
		public static function randomCid(loc:Location, tip:String):String {
			var tr:int=0;
			switch (tip) {
				case 'raider':
					if (loc.locDifLevel>=5) tr = int(Math.random()*9+1);
					else if (loc.locDifLevel>=2) tr = int(Math.random()*5+1);
					else tr = int(Math.random()*2+1);
					return tr.toString();
				break;
				case 'slaver':
					if (loc.locDifLevel>=18) tr = int(Math.random()*6+1);
					else if (loc.locDifLevel>=15) tr = int(Math.random()*5+1);
					else tr = int(Math.random()*4+1);
					return tr.toString();
				break;
				case 'zebra':
					if (loc.locDifLevel>=15) tr = int(Math.random()*4+1);
					else tr = int(Math.random()*2+1);
					if (loc.locDifLevel>=25 && Math.random()<0.1) tr=5; 
					return tr.toString();
				break;
				case 'ranger':
					if (loc.land.act.conf==7) tr = int(Math.random()*3+1);
					else if (loc.landY==0) tr=1;
					else tr = int(Math.random()*2+1);
					return tr.toString();
				break;
				case 'merc':
					if (loc.locDifLevel>=19) tr = int(Math.random()*5+1);
					else if (loc.locDifLevel>=15 && Math.random()>0.5) tr = int(Math.random()*4+1);
					else tr = int(Math.random()*2+1);
					return tr.toString();
				break;
				case 'encl':
					tr = int(Math.random()*4+1);
					return tr.toString();
				break;
				case 'protect':
					if (loc.tipEnemy==7) tr=1;
					return tr.toString();
				break;
				case 'gutsy':
					if (loc.tipEnemy==7) tr=1;
					return tr.toString();
				break;
				case 'dron':
					if (loc.tipEnemy==9) {
						tr = int(Math.random()*4+1);
						if (tr>3) tr=3;
					}
					else tr = int(Math.random()*2+1);
					return tr.toString();
				break;
				case 'roller':
					if (loc.biom==6) tr=2;
					else tr=1;
					return tr.toString();
				break;
				case 'zombie':
					if (loc.biom==5) {
						if (loc.locDifLevel>=20 && Math.random()<0.1) tr=9;
						else tr = int(Math.random()*4+5);
					}
					else if (loc.biom>=1 && loc.locDifLevel>=8) tr = int(Math.random()*7);
					else if (loc.locDifLevel>=5) tr = int(Math.random()*5);
					else if (loc.locDifLevel>=2) tr = int(Math.random()*4);
					else tr=0;
					return tr.toString();
				break;
				case 'alicorn':
					tr = int(Math.random()*3+1);
					return tr.toString();
				break;
				case 'hellhound':
					tr=1;
					return tr.toString();
				break;
				case 'bloat':
					if (loc.biom==5) tr = int(Math.random()*3+4);
					else if (loc.locDifLevel>=10) tr = int(Math.random()*5);
					else if (loc.locDifLevel>=4) tr = int(Math.random()*4);
					else if (loc.locDifLevel>=2) tr = int(Math.random()*3);
					else tr=0;
					return tr.toString();
				break;
				case 'ant':
					if (loc.biom>=1 && loc.locDifLevel>=6) tr = int(Math.random()*3+1);
					else if (loc.locDifLevel>=3) tr = int(Math.random()*2+1);
					else tr=1;
					return tr.toString();
				break;
				case 'fish':
					if (loc.biom==5) tr=3;
					else tr = int(Math.random()*2+1);
					return tr.toString();
				break;
				case 'slime':
					if (loc.biom==5) tr=2;
					else tr=0;
					return tr.toString();
				break;
				case 'slmine':
					if (loc.biom==5) tr=12;
					else tr=10;
					return tr.toString();
				break;
				case 'bloodwing':
					if (loc.biom==5) tr=2;
					else tr=1;
					return tr.toString();
				break;
				case 'scorp':
					if (loc.locDifLevel>=5) tr = int(Math.random()*2+1);
					else tr=1;
					return 'scorp'+tr;
				break;
				case 'mine':
					if (loc.biom==4) return 'plamine';
					if (loc.biom==2 && Math.random()<Math.min(loc.locDifLevel/20,0.4)) return 'plamine';
					else if (Math.random()<Math.min(loc.locDifLevel/20,0.75)) return 'mine';
					else return 'hmine';
				break;
			}
			return null;
		}
	}
}

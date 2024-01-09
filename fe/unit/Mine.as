package fe.unit {
	
	//import flash.utils.*;
	import fe.*;
	//import fe.weapon.Bullet;
	import fe.serv.Interact;
	import fe.serv.LootGen;
	import fe.loc.Location;
	
	public class Mine extends Unit{

		public var explRadius:Number=0;	//радиус взрыва, если 0, то взрыва нет
		public var wdestroy:Number=10;	//урон блокам
		public var damage1:Number=12;	//урон юнитам
		public var otbros1:Number=5;		//отброс
		public var tipDecal:int=0;		//тип оставляемых следов		
		public var explTime:int=15;		//задержка перед взрывом
		public var reloadTime:int=0;	//время на зарядку после установки
		public var sens:int=100;
		public var otschet:int=10;		//срабатывание вражеских мин при взятой способности лёгкий шаг
		
		public var sndSens:String='', sndDem:String='';
		public var tr:int=0;	
		
		public var chain:Boolean=false;
		public var TrapLvl:int=1;
		
		public function Mine(cid:String=null, ndif:Number=100, xml:XML=null, loadObj:Object=null) {
			prior=3;
			if (ndif>5) ndif=5;
			
			if (loadObj && loadObj.tr) {			//из загружаемого объекта
				tr=loadObj.tr;
			} else if (xml && xml.@tr.length()) {	//из настроек карты
				tr=xml.@tr;
			} else if (cid) {
				id=cid;
			} else {
				tr=1;
			}
			if (tr>0) {
				id='hmine';
				if (tr==1) id='hmine';
				if (tr==2) id='mine';
				if (tr==3) id='plamine';
				if (tr==4) id='impmine';
				if (tr==5) id='zebmine';
				if (tr==6) id='balemine';
			}
			vis=Res.getVis('vis'+id,vismine);
			
			if (reloadTime) vis.gotoAndStop(1);
			else vis.gotoAndStop(2);
			setVis(false);
			var node:XML=AllData.d.weapon.(@id==id)[0];
			nazv=Res.txt('w',id);
			scX=node.@sX;
			scY=node.@sY;
			
			if (node.snd.@dem.length()) sndDem=node.snd.@dem;
			if (node.snd.@sens.length()) sndSens=node.snd.@sens;

			massaMove=0.05;
			node=node.char[0];
			if (node.@massa>0) massaMove=node.@massa/50;
			if (node.@massafix.length()) massaFix=node.@massafix/50;
			else massaFix=massaMove;
			if (node.@maxhp>0) hp=maxhp=node.@maxhp;
			if (node.@damexpl.length()) damage1=node.@damexpl;
			if (node.@knock.length()) otbros1=node.@knock;
			if (node.@tipdam.length()) tipDamage=node.@tipdam;
			if (node.@destroy.length()) wdestroy=node.@destroy;
			if (node.@expl.length()) explRadius=node.@expl;
			if (node.@time.length()) explTime=node.@time;
			else if (Math.random()<Math.min(0.25,ndif/50)) explTime=5;
			if (node.@sens.length()) sens=node.@sens;
			massa=massaFix;
			
			damage1*=(Math.random()*0.3+0.85);
			node=AllData.d.weapon.(@id==id)[0].vis[0];
			if (node.@tipdec.length()) tipDecal=node.@tipdec;
			
			aiState=1;
			isFly=false;
			destroy=0;
			fraction=F_RAIDER;
			dexter=5;
			brake=100;
			showNumbs=false;
			activateTrap=0;
			trup=false;
			mech=true;
			visibility=300;
			doop=true;
			transT=true;
			
			//inter.t_action=30;
			vulner[D_EMP]=1;
			vulner[D_VENOM]=0;
			//inter = new Interact(this);
			inter.mine=Math.round(1+Math.random()*(ndif+1));
			if (inter.mine>inter.maxMechLvl) inter.mine=inter.maxMechLvl;
			if (tr>=5) {
				inter.mine=Math.floor(Math.random()*3+5);
				if (tr==5) {
					chain=true;
					visibility=180;
				}
			}
			inter.active=true;
			inter.action=3;
			inter.update();
			inter.successRemine=remine;
			inter.fiascoRemine=activate;
			
			//fixed=1;
		}
		
		public override function putLoc(nloc:Location, nx:Number, ny:Number) {
			super.putLoc(nloc,nx,ny);
			if (loc.tipEnemy==2 && fraction==F_RAIDER) fraction=Unit.F_ROBOT;
		}
		
		public override function setLevel(nlevel:int=0) {
			super.setLevel(nlevel);
			if (nlevel>10) damage1*=(1+(nlevel-10)*0.1);
		}
		
		public override function setNull(f:Boolean=false) {
			super.setNull(f);
			oduplenie=World.oduplenie/2;
		}

		public override function save():Object {
			var obj:Object=super.save();
			if (obj==null) obj=new Object();
			obj.tr=tr;
			return obj;
		}	
		
		public function setVis(v:Boolean) {
			isVis=v;
			levitPoss=v;
			vis.visible=v;
			vis.alpha=v?1:0.1;
		}
		
		public override function dropLoot() {
			explosion(damage1,tipDamage,explRadius,0,otbros1,wdestroy,tipDecal);
		}
		
		var aiN:int=Math.floor(Math.random()*5);
		
		public function remine() {
			inter.active=false;
			if (!loc.train) LootGen.lootId(loc,X,Y,id);
			if (sndDem!='') Snd.ps(sndDem,X,Y);
			sost=4;
			disabled=true;
			loc.remObj(this);
		}
		
		public function activate() {
			inter.active=0;
			aiState=2;
			setVis(true);
			vis.play();
		}
		
		public override function die(sposob:int=0) {
			super.die(0);
		}
		
		public override function control() {
			aiN++;
			if (levit || !stay && !fixed && oduplenie<=0 || !stay && fraction==F_PLAYER) {
				massa=0.06;
			}
			if (reloadTime>0) {
				reloadTime--;
				if (reloadTime==1) vis.gotoAndStop(2);
				return;
			}
			inter.X=X, inter.Y=Y;
			if (aiState==1 && oduplenie<=0 && sens>0) { //взведена, поиск целей
				if (aiN%4==0) {
					for each (var un:Unit in loc.units) {
						if (un==null || un.activateTrap==0 || un.activateTrap==1 && fraction!=Unit.F_PLAYER && un.fraction!=Unit.F_PLAYER || !isMeet(un) || un.sost==3 || un.fraction==fraction || un.fraction==0) continue;
						if (un.X-X<sens && un.X-X>-sens && un.Y-Y<sens*0.4 && un.Y-Y>-sens && (tipDamage!=8 || un.vulner[8]>0)) {
							if (otschet>0 && un.activateTrap==1 && un.fraction==Unit.F_PLAYER) {
								otschet--;
								continue;
							}
							if (un.player && chain) {
								World.w.gg.bindChain(X,Y);
							}
							activate();
							break;
						}
					}
				}
				if (levit && aiN%10==1 && isrnd(0.1)) {
					activate();
				}
			} else if (aiState==2) {
				if (sndSens!='' && explTime%5==3) Snd.ps(sndSens,X,Y);
				
				explTime--;
			}
			if (explTime<=0) {
				die();
			}
			if (aiN%10==0 && !isVis) {
				isVis=World.w.gg.lookInvis(this);
				if (isVis) {
					setVis(true);
				}
			}
		}
		
		//public override function animate() {
			
		//}
	}
	
}

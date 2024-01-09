package fe.unit {
	
	import fe.*;
	import fe.serv.Interact;
	import fe.loc.Location;
	import fe.weapon.Weapon;
	import fe.serv.LootGen;
	import fe.weapon.WThrow;
	import fe.weapon.Bullet;
	
	//механизмы, наносящие урон
	
	public class UnitDamager extends Unit{
		
		var tr:String='0';
		var weap:String;
		
		var tipDamager:int=1;	//1 - пушка, 2 взрывчатка
		var status:int=0;	//0 - взведён, 1 - активирован, 2 - отключён
		var needSkill:String='repair';
		var isAct:Boolean=false;
		var allid:String;
		
		var och:int=20;
		var noch:int=0;
		var kolammo:int=100;
		
		var damageExpl:Number=0;
		var destroyExpl:Number=0;
		var explRadius:Number=0;

		public function UnitDamager(cid:String=null, ndif:Number=100, xml:XML=null, loadObj:Object=null) {
			super(cid, ndif, xml, loadObj);
			if (cid==null) {
				id='damshot';
			} else {
				id=cid;
			}
			mat=1;
			vis=Res.getVis('vis'+id,vismtrap);
			getXmlParam();
			visibility=300;
			showNumbs=levitPoss=isSats=false;
			doop=true;
			sloy=0;
			noBox=true;
			if (loadObj && loadObj.tr!=null) {
				tr=loadObj.tr;
			}
			if (xml) {
				if (xml.@allid.length()) allid=xml.@allid;
				if (xml.@tr.length()) tr=xml.@tr;
			}
			setWeapon();
			if (xml) {
				if (xml.@kolammo.length()) kolammo=xml.@kolammo;
				if (xml.@och.length()) och=xml.@och;
				if (xml.@expl.length()) damageExpl=xml.@expl;
			}
			fixed=true;
			inter = new Interact(this);
			inter.active=true;
			inter.action=100;
			inter.userAction='disarm';
			inter.actFun=disarm;
			inter.t_action=30;
			inter.needSkill=needSkill;
			inter.needSkillLvl=1;
			setVis(false);
			setStatus();
		}
		
		function setWeapon() {
			if (tipDamager==1) {
				if (tr=='0') tr=Math.floor(Math.random()*5+1).toString();
				if (tr=='1') weap='lshot';
				else if (tr=='2') weap='hunt';
				else if (tr=='3') weap='assr';
				else if (tr=='4') weap='dartgun';
				else if (tr=='5') weap='flamer';
				else weap=tr;
			}
			if (tipDamager==2) {
				if (tr=='0') weap='hgren';
				else weap=tr;
				kolammo=och=3;
			}
			if (tipDamager==3) {
				damageExpl=250;
				destroyExpl=1000;
				explRadius=200;
				kolammo=1;
			}
			if (tipDamager==1 || tipDamager==2) {
				currentWeapon=Weapon.create(this,weap);
				if (currentWeapon==null) currentWeapon=Weapon.create(this,'lshot');
				currentWeapon.hold=currentWeapon.holder;
				if (tipDamager==1) {
					kolammo=currentWeapon.holder;
					och=currentWeapon.satsQue;
					if (och>1) och*=2;
					if (kolammo==1) kolammo=3;
				}
				if (currentWeapon.tip==4) {
					currentWeapon.rapid=1;
				}
				childObjs=new Array(currentWeapon);
			}
		}
		
		public override function save():Object {
			var obj:Object=super.save();
			if (obj==null) obj=new Object();
			obj.tr=tr;
			return obj;
		}
		
		public override function getXmlParam(mid:String=null) {
			super.getXmlParam();
			var node0:XML=AllData.d.unit.(@id==id)[0];
			if (node0.un.length()) {
				if (node0.un.@tip.length()) tipDamager=node0.un.@tip;		//требуемый скилл
				if (node0.un.@skill.length()) needSkill=node0.un.@skill;		//требуемый скилл

			}
		}
		
		public override function setLevel(nlevel:int=0) {
			level+=nlevel;
			var sk:int=Math.round(level*0.25*(Math.random()*0.7+0.3));
			if (sk<1) sk=1;
			if (sk>5) sk=5;
			inter.needSkillLvl=sk;
			if (currentWeapon) {
				currentWeapon.damage*=(1+level*0.05);
				currentWeapon.damageExpl*=(1+level*0.05);
			}
		}
		
		public override function putLoc(nloc:Location, nx:Number, ny:Number) {
			super.putLoc(nloc,nx,ny);
			if (loc.mirror) {
				storona=-storona;
				aiNapr=storona;
			}
			if (currentWeapon) {
				if (tipDamager==2) {
					celX=X, celY=Y;
					currentWeapon.rot=Math.PI/2;
					currentWeapon.rapid=1;
					(currentWeapon as WThrow).detTime=45;
				} else if (tipDamager==1) {
					celX=X+200*storona, celY=Y-scY/2;
					currentWeapon.rot=(storona<0)?Math.PI:0;
				}
			}
		}

		function setStatus() {
			if (status>0) {
				warn=0;
				inter.active=false;
			} else {
				warn=1;
				inter.active=true;
			}
			vis.gotoAndStop(status+1);
			inter.update();
		}
		
		/*public override function die(sposob:int=0) {
			super.die(sposob);
			//if (status==0) activate();
		}*/
		
		public function setVis(v:Boolean) {
			isVis=v;
			vis.visible=v;
			vis.alpha=v?1:0.1;
			if (currentWeapon) {
				currentWeapon.vis.visible=v;
				currentWeapon.vis.alpha=v?1:0.1;
			}
		}
		
		public override function expl()	{
			newPart('metal',3);
		}
		
		//обезвредить
		function disarm() {
			if (tipDamager==1) {
				LootGen.lootId(loc,currentWeapon.X,currentWeapon.Y,'frag',1);
				if (kolammo>0) LootGen.lootId(loc,currentWeapon.X,currentWeapon.Y,currentWeapon.ammo,kolammo);
			} else if (tipDamager==2 && kolammo>0) {
				LootGen.lootId(loc,currentWeapon.X,currentWeapon.Y,currentWeapon.id,1);
				LootGen.lootId(loc,currentWeapon.X,currentWeapon.Y,currentWeapon.id,1);
				LootGen.lootId(loc,currentWeapon.X,currentWeapon.Y,currentWeapon.id,1);
			} else if (tipDamager==3 && kolammo>0) {
				LootGen.lootCont(loc,X,Y-20,'bomb');
			}
			sost=4;
			disabled=true;
			loc.remObj(this);
		}
		
		//взорвать при нанесении урона
		public override function dropLoot() {
			super.dropLoot();
			if ((tipDamager==2 || tipDamager==3) && kolammo>0) iExpl();
			if (tipDamager==1) LootGen.lootId(loc,currentWeapon.X,currentWeapon.Y,'frag',1);
		}
		
		function iExpl() {
			var bul:Bullet;
			if (tipDamager==2) {
				damageExpl=currentWeapon.damageExpl*kolammo;
				destroyExpl=currentWeapon.destroy;
				explRadius=currentWeapon.explRadius;
			}
			if (currentWeapon) bul=new Bullet(this,currentWeapon.X,currentWeapon.Y,null,false);
			else bul=new Bullet(this,X,Y-20,null,false);
			bul.iExpl(damageExpl,destroyExpl,explRadius);
		}
		
		//активировать
		function activate() {
			if (status!=0 || sost>1) return;
			if (tipDamager==3) {
				iExpl();
				kolammo=0;
				disarm();
			} else {
				status=1;
				noch=0;
				setVis(true);
			}
		}
		
		//команда
		public override function command(com:String, val:String=null) {
			if (com=='dam') activate();
		}
		
		//не искать цели
		public override function setCel(un:Unit=null, cx:Number=-10000, cy:Number=-10000) {
		}
		
		var aiN:int=Math.floor(Math.random()*5);
		
		public override function control() {
			if (sost>1 || status==2 || kolammo<=0) return;
			aiN++;
			if (isShoot) {
				noch++;
				kolammo--;
				if (noch>=och) {
					status=0;
					//currentWeapon.initReload();
				}
				if (kolammo<=0) {
					disarm();
				}
				isShoot=false;
			}
			if (status==1) {
				if (tipDamager==2) {
					celX=X+Math.random()*80-40;
				}
				if (currentWeapon) currentWeapon.attack();
			}
			if (aiN%10==0 && !isVis) {
				isVis=World.w.gg.lookInvis(this);
				if (isVis) {
					setVis(true);
				}
			}
		}
	}
	
}

package fe.unit {
	
	import fe.*;
	
	public class Armor {

		public var id:String;
		public var nazv:String;
		public var owner:Unit;
		public var tip:int=1;		//1 - броня, 3 - амулет
		public var clo:int=0;		//броню можно переодевать в любой момент в огран инвентаре
		public var active:Boolean=false;
		public var xml:XML;
		//BUL=0, BLADE=1, PHIS=2, FIRE=3, EXPL=4, LASER=5, PLASMA=6, VENOM=7, EMP=8, SPARK=9, ACID=10;
		
		public var lvl:int=0, maxlvl:int=0;
		public var armor:Number=0, marmor:Number=0, armor_qual:Number=0;		//броня, вероятность того, что она сработает
		public var resist:Array;							//сопротивления
		public var dexter:Number=0;							//бонус уклонения
		public var sneak:Number=0;							//бонус скрытности
		public var radVul:Number=1;
		public var h2oMult:Number=1;		//дыхание
		public var meleeMult:Number=1;		//холодное
		public var gunsMult:Number=1;		//огнестрел
		public var magicMult:Number=1;		//магия
		public var crit:Number=0;		//шанс крита
		public var tre:Number=0;			//дополнительные сокровища
		public var ableFly:int=0;
		
		public var showObsInd:Boolean=false;		//показывать индикатор скрытности
		public var abil:String;		//особая функция
		public var mana:Number=0;
		public var maxmana:Number=0;
		public var dmana_act:Number=0;	//расход маны при активации функции
		public var dmana_use:Number=0;	//расход маны на поддержание
		public var dmana_res:Number=0;	//восстановление маны
		public var abilActive:Boolean=false;	//функция активна
		
		public var und:Boolean=false;	//не ломается
		public var norep:Boolean=false;	//не ремонтируется на верстаке
		public var hp:int=100, maxhp:int=100;
		public var idComp:String;
		public var kolComp:int=1;		//сколько пластин надо для ремонта
		public var price:int=0;
		public var sort:int=0;
		public var hideMane:int=0;
		
		public function Armor(nid:String, nlvl:int=0) {
			id=nid;
			lvl=nlvl;
			
			xml=AllData.d.armor.(@id==id)[0];
			if (xml.@tip.length()) tip=xml.@tip;
			if (xml.@clo.length()) clo=xml.@clo;
			if (xml.@hp.length()) hp=maxhp=(xml.@hp);
			if (xml.@lvl.length()) maxlvl=(xml.@lvl);
			if (xml.@und.length()) und=true;
			if (xml.@norep.length()) norep=true;
			if (xml.@h2o.length()) h2oMult=xml.@h2o;
			if (xml.@tre.length()) tre=xml.@tre;
			if (xml.@melee.length()) meleeMult=xml.@melee;
			if (xml.@guns.length()) gunsMult=xml.@guns;
			if (xml.@magic.length()) magicMult=xml.@magic;
			if (xml.@crit.length()) crit=xml.@crit;
			if (xml.@comp.length()) idComp=xml.@comp;
			else idComp=id+'_comp';
			if (xml.@kolcomp.length()) kolComp=xml.@kolcomp;
			price=xml.@price;
			if (xml.@sort.length()) sort=xml.@sort;
			if (xml.@abil.length()) abil=xml.@abil;
			if (xml.@fly.length()) ableFly=1;
			if (xml.@hide.length()) hideMane=xml.@hide;
			
			resist=new Array();
			for (var i=0; i<Unit.kolVulners; i++) resist[i]=0;
			if (tip==1) resist[Unit.D_PINK]=-0.5;
			if (lvl>=0) getXmlParam(xml.upd[lvl]);
			else getXmlParam(xml.upd[0])
		}
		
		public function getXmlParam(node:XML) {
			if (node.@armor.length()) armor=(node.@armor);
			if (node.@marmor.length()) marmor=(node.@marmor);
			if (node.@qual.length()) armor_qual=(node.@qual);
			
			if (node.@bul.length()) resist[Unit.D_BUL]=(node.@bul);
			if (node.@phis.length()) resist[Unit.D_PHIS]=(node.@phis);
			if (node.@blade.length()) resist[Unit.D_BLADE]=(node.@blade);
			if (node.@expl.length()) resist[Unit.D_EXPL]=(node.@expl);
			if (node.@fang.length()) resist[Unit.D_FANG]=(node.@fang);
			
			if (node.@fire.length()) resist[Unit.D_FIRE]=(node.@fire);
			if (node.@cryo.length()) resist[Unit.D_CRIO]=(node.@cryo);
			if (node.@laser.length()) resist[Unit.D_LASER]=(node.@laser);
			if (node.@plasma.length()) resist[Unit.D_PLASMA]=(node.@plasma);
			if (node.@spark.length()) resist[Unit.D_SPARK]=(node.@spark);
			if (node.@acid.length()) resist[Unit.D_ACID]=(node.@acid);
			if (node.@necro.length()) resist[Unit.D_NECRO]=(node.@necro);
			
			if (node.@venom.length()) resist[Unit.D_VENOM]=(node.@venom);
			if (node.@radx.length()) radVul=1-Number(node.@radx);
			
			if (node.@dexter.length()) dexter=(node.@dexter);
			if (node.@sneak.length()) {
				sneak=(node.@sneak);
				showObsInd=true;
			}
			
			if (node.@mana.length()) maxmana=node.@mana;
			if (node.@act.length()) dmana_act=node.@act;
			if (node.@used.length()) dmana_use=node.@used;
			if (node.@res.length()) dmana_res=node.@res;
			
			//showObsInd=true;//!!!!
			nazv=Res.txt('a',id);
			if (lvl>0) nazv+=' - '+lvl;
		}
		
		public function setArmor() {
			if (owner && active) {
				var koef:Number=1;
				if (hp<maxhp/2) koef=0.5+hp/maxhp;
				owner.armor=armor*koef;
				owner.marmor=marmor*koef;
				owner.armor_qual=armor_qual*koef;
			}
		}
		
		public function damage(dam:Number, tip:int) {
			if (und) return;
			if (tip!=Unit.D_VENOM && tip!=Unit.D_EMP && tip!=Unit.D_POISON && tip!=Unit.D_BLEED && tip!=Unit.D_INSIDE) {
				dam*=1-resist[tip];
				if (tip==Unit.D_ACID) dam*=2;
				if (tip==Unit.D_PINK) dam*=3;
				hp-=dam;
				if (hp<0) {
					hp=0;
					World.w.gg.changeArmor('off');
				}
			}
			setArmor();
		}
		
		public function repair(nhp:int) {
			hp+=nhp;
			if (hp>maxhp) hp=maxhp;
			setArmor();
		}
		
		public function needComp():int {
			if (xml.upd[lvl+1]) return xml.upd[lvl+1].@kol;
			else return 0;
		}
		
		public function upgrade() {
			if (lvl>=maxlvl) return;
			lvl++;
			for (var i=0; i<Unit.kolVulners; i++) resist[i]=0;
			getXmlParam(xml.upd[lvl]);
		}
		
	}
	
}

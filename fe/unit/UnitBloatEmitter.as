package fe.unit {
	import fe.*;
	
	public class UnitBloatEmitter  extends Unit{
		
		var emitId:String='bloat';

		public function UnitBloatEmitter(cid:String=null, ndif:Number=100, xml:XML=null, loadObj:Object=null) {
			super(cid, ndif, xml, loadObj);
			if (cid!=null) id=cid;
			else id='ebloat';
			if (id=='eant') {
				vis=new visualAntEmitter();
				emitId='ant';
			} else vis=new visualBloatEmitter();
			vis.stop();
			getXmlParam();
		}
		
		public override function setVisPos() {
			vis.x=X,vis.y=Y;
		}
		
		public override function setNull(f:Boolean=false) {
			if (sost==1) {
				if (f) {
					//сбросить эффекты
					if (effects.length>0) {
						for each (var eff in effects) eff.unsetEff();
						effects=new Array();
					}
					oduplenie=Math.round(World.oduplenie*(Math.random()*0.2+0.9));
					disabled=false;		//включить
				}
			}
		}
		
		function emit(d:Boolean=false) {
			var un:Unit;
			var emitTr:String='0';
			if (emitId=='bloat') {
				if (loc.locDifLevel>3) emitTr=loc.randomCid(emitId);
				un=loc.createUnit(emitId,X,Y,true,null,emitTr);
			}
			if (emitId=='ant') {
				emitTr=loc.randomCid(emitId);
				un=loc.createUnit(emitId,X,Y-40,true,null,emitTr);
			}
			if (un && d) {
				kolChild++;
				un.mother=this;
			}
		}
		
		var emit_t:int=0;
		
		public override function expl()	{
			super.expl();
			if (emitId=='ant') newPart('schep',16,2);
			else newPart('shmatok',16,2);
		}
		
		public override function dropLoot() {
			super.dropLoot();
			for (var i=0; i<5; i++) emit();
		}
		
		public override function control() {
			if (World.w.enemyAct<=0) {
				return;
			}
			//поиск цели
			if (aiTCh>0) aiTCh--;
			if (World.w.enemyAct>1 && aiTCh==0) {
				aiTCh=10;
				if (findCel()) {
					aiState=2;
				} else {
					aiState=1;		
				}
			}
			if (emit_t>0) emit_t--;
			else {
				if (aiState==2 && kolChild<5) {
					emit(true);
					emit_t=100;
				}
			}
			//атака
			if (World.w.enemyAct>=3 && celUnit) {
				attKorp(celUnit);
			}
		}
	}
	
}

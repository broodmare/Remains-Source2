package fe.game.domain.units {

	import flash.display.MovieClip;

	import fe.engine.utils.SymbolFactory;
	import fe.game.GameContainer;
	import fe.game.domain.location.factories.UnitFactory;
	
	public class UnitBloatEmitter  extends Unit {
		
		private var emitId:String = "bloat";
		private var emit_t:int = 0;

		public function UnitBloatEmitter(cid:String=null, ndif:Number=100, xml:XML=null, loadObj:Object=null) {
			super(cid, ndif, xml, loadObj);
			
			if (cid == null) {
                id = 'ebloat';
            }
			else {
				id = cid;
			}
			
			if (id=='eant') {
				vis = SymbolFactory.createInstance("visualAntEmitter") as MovieClip;
				emitId='ant';
			}
			else {
				vis = SymbolFactory.createInstance("visualBloatEmitter") as MovieClip;
			}
			
			vis.stop();
			getXmlParam();
		}
		
		public override function setVisPos():void {
			vis.x = coordinates.X;
			vis.y = coordinates.Y;
		}
		
		public override function setNull(f:Boolean=false):void {
			if (sost==1) {
				if (f) {
					//сбросить эффекты
					if (effects.length>0) {
						for each (var eff:Effect in effects) eff.unsetEff();
						effects = [];
					}
					
					detectionDelay = Math.round(GameContainer.detectionDelay * (Math.random() * 0.2 + 0.9));
					disabled=false;		//включить
				}
			}
		}
		
		private function emit(d:Boolean=false):void {
			var un:Unit;
			var emitTr:String='0';
		
			if (emitId == 'bloat') {
				if (loc.locDifLevel > 3) {
					emitTr=UnitFactory.randomCid(loc, emitId);
				}
				un=loc.createUnit(emitId, coordinates.X, coordinates.Y, true, null, emitTr);
			}
			
			if (emitId == 'ant') {
				emitTr=UnitFactory.randomCid(loc, emitId);
				un=loc.createUnit(emitId, coordinates.X, coordinates.Y - 40, true, null,emitTr);
			}
		
			if (un && d) {
				kolChild++;
				un.mother=this;
			}
		}
		
		public override function expl():void {
			super.expl();
		
			if (emitId=='ant') {
				newPart('schep', 16, 2);
			}
			else {
				newPart('shmatok', 16, 2);
			}
		}
		
		public override function dropLoot():void {
			super.dropLoot();
		
			for (var i:int = 0; i < 5; i++) {
				emit();
			}
		}
		
		override protected function control():void {
			if (GameContainer.reference.enemyAct<=0) {
				return;
			}
			
			//поиск цели
			if (aiTCh>0) aiTCh--;
			
			if (GameContainer.reference.enemyAct>1 && aiTCh==0) {
				aiTCh=10;
				if (findCel()) {
					aiState=2;
				}
				else {
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
			if (GameContainer.reference.enemyAct>=3 && celUnit) {
				attKorp(celUnit);
			}
		}
	}	
}
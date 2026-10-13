package fe.game.domain.units  {

	import flash.display.MovieClip;

	import fe.engine.utils.SymbolFactory;
	import fe.game.enums.E_Direction;

	public class UnitTrain extends Unit {

		private var tr:int=0;
		
		public function UnitTrain(cid:String=null, ndif:Number=100, xml:XML=null, loadObj:Object=null) {
			id='training';
			if (xml) {
				if (xml.@turn.length()) {
					if (xml.@turn>0) storona=E_Direction.RIGHT;
					if (xml.@turn<0) storona=E_Direction.LEFT;
				}
				else {
					storona=isrnd()?E_Direction.RIGHT:E_Direction.LEFT;
				}
				if (xml.@tr.length()) tr=xml.@tr;
				if (xml.@fix.length()) fixed=true;
			}
			getXmlParam();

			if (tr==1) {
				vis = SymbolFactory.createInstance("visualTrainArmor") as MovieClip;
				skin=20;
			}
			else {
				vis = SymbolFactory.createInstance("visualTrain") as MovieClip;
			}

			vis.gotoAndStop(1);
			doop=true;
		}

		override protected function control():void {
			hp=maxhp;
		}

		public override function setNull(f:Boolean=false):void {
			super.setNull(f);
			armor_hp=armor_maxhp;
		}

		public override function die(sposob:int=0):void {
			hp=maxhp;
		}

		public override function visDetails():void {
			if (hpbar) hpbar.visible=false;
		}

		public override function setLevel(nlevel:int=0):void {

		}
	}
}
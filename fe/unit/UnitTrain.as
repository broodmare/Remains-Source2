package fe.unit  {

	import flash.display.MovieClip;

	import fe.SymbolFactory;

	public class UnitTrain extends Unit {

		private var tr:int=0;
		
		// Constructor
		public function UnitTrain(cid:String=null, ndif:Number=100, xml:XML=null, loadObj:Object=null) {
			id='training';
			if (xml) {
				if (xml.@turn.length()) {
					if (xml.@turn>0) storona=1;
					if (xml.@turn<0) storona=-1;
				}
				else {
					storona=isrnd()?1:-1;
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
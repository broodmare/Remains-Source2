package fe.unit {
	
	import fe.*;
	import fe.util.Vector2;
	import fe.graph.Emitter;

	public class UnitDestr extends Unit {
		
		private var tr:int=1;
		private var t_part:int=10;
		
		// Constructor
		public function UnitDestr(cid:String=null, ndif:Number=100, xml:XML=null, loadObj:Object=null) {
			super(cid, ndif, xml, loadObj);
			id='destr';
			if (cid!=null) tr=int(cid);
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
			id=id+tr;
			getXmlParam();
			if (tr==1) {
				vis=new visualStolp();	// .SWF Dependency
				boss=true;
				noDestr=true;
			}
			doop=true;
			mat=1;
		}

		public override function setLevel(nlevel:int=0):void {

		}
		
		override protected function control():void {
			if (tr==1) {
				t_part--;
				if (t_part==0) t_part=10;
				if (sost==1) {
					vis.osn.gotoAndStop(1);
					Emitter.emit('lift', loc, coordinates.X+(Math.random()-0.5) * this.boundingBox.width, coordinates.Y - Math.random() * this.boundingBox.height);
				}
				else {
					vis.osn.gotoAndStop(2);
					if (t_part==3) Emitter.emit('explw', loc, coordinates.X+(Math.random()-0.5) * this.boundingBox.width, coordinates.Y - Math.random() * this.boundingBox.height);
				}
			}
		}
	}
}
package fe.game.domain.units {
	
	import fe.engine.utils.Vec2;
	import fe.game.rendering.Emitter;
	import fe.game.enums.E_Material;
	import fe.game.enums.E_Direction;

	public class UnitDestr extends Unit {
		
		private var tr:int=1;
		private var t_part:int=10;
		
		public function UnitDestr(cid:String=null, ndif:Number=100, xml:XML=null, loadObj:Object=null) {
			super(cid, ndif, xml, loadObj);
			id='destr';
			
			if (cid!=null) tr=int(cid);
			
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
			
			id=id+tr;
			getXmlParam();
			
			if (tr==1) {
				initArt(id);
				art.play('stay');
				boss=true;
				noDestr=true;
			}
			
			doop=true;
			mat=E_Material.METAL;
		}

		public override function setLevel(nlevel:int=0):void {

		}
		
		override protected function control():void {
			if (tr==1) {
				t_part--;
				
				if (t_part==0) {
					t_part=10;
				}
				
				if (sost==1) {
					art.play('stay');
					Emitter.emit('lift', loc, coordinates.X+(Math.random()-0.5) * this.boundingBox.width, coordinates.Y - Math.random() * this.boundingBox.height);
				}
				else {
					art.play('active');
					if (t_part==3) Emitter.emit('explw', loc, coordinates.X+(Math.random()-0.5) * this.boundingBox.width, coordinates.Y - Math.random() * this.boundingBox.height);
				}
			}
		}
	}
}
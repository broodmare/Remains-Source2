package fe.projectile
{
	import fe.*;
	import fe.unit.Unit;
	import fe.entities.Obj;
	import fe.graph.Emitter;
	
	public class MagSymbol extends Obj // MAGIC SYMBOL
	{
		
		protected var vse:Boolean=false;
		
		public var owner:Unit;
		public var spellId:String;
		public var rad:Number=100;
		public var liv:int=20;

		public function MagSymbol(own:Unit, spell:String, nx:Number, ny:Number, otlozh:int=0)
		{
			if (own==null) {
				owner=new Unit();
				loc=World.w.loc;
			} else {
				owner=own;
				loc=own.loc;
			}
			spellId=spell;
			coordinates.X = nx;
			coordinates.Y = ny;
			liv=20+otlozh;
			loc.addObj(this);
		}
		
		public override function step():void
		{
			if (liv==20) Emitter.emit('magsymbol', loc, coordinates.X, coordinates.Y);
			liv--;
			if (liv==1) spellCast();
			if (liv<=0) loc.remObj(this);
		}
		
		public override function setNull(f:Boolean=false)
		{
			loc.remObj(this);
		}
		
		public function spellCast()
		{
			var cel:Unit=World.w.gg;
			if (cel.loc==loc && !cel.invulner && cel.sost<=2) {
				if (getRasst2(cel)<rad*rad) {
					cel.addEffect(spellId);
				}
			}
		}
		
		public override function err():String
		{
			if (loc) loc.remObj(this);
			return null;
		}
	}
}
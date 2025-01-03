package fe.loc {

	import fe.*;
	import fe.util.Vector2;
	import fe.serv.Script;
	import fe.graph.Emitter;
	import fe.unit.Unit;
	import fe.entities.Obj;
	import fe.loc.Tile;
	
	//Активная область
	
	public class Area extends Obj {

		public var enabled:Boolean=true;
		public var tip:String='gg';	//1 - активируется ГГ
		
		//зазмеры в блоках
		var bx:int=0, by:int=0, rx:int=2, ry:int=2;
		
		var active:Boolean=false;		//область активна (активатор находится в ней)
		var preactive:Boolean=false;	//область была активна в предыдущем такте
		
		public var over:Function;
		public var out:Function;
		public var run:Function;
		
		public var scrOver:Script;
		public var scrOut:Script;
		
		public var mess:String;			//сообщение
		public var messDown:Boolean;	//показать сообщение внизу
		
		public var activator:Unit;
		public var allact:String;		//заданное действие на всю комнату
		public var allid:String;		//ид для заданного действия
		public var lift:Number=1;		//изменение гравитации
		public var onPort:Boolean=false;//телепортация
		public var portX:int=-1, portY:int=-1;
		public var noRad:Boolean=false;
		
		public var emit:Emitter;
		public var dens:Number=1;
		public var frec:Number=1, t_frec:Number=0;
		public var trig:Boolean;	//при первой активации отключить и установить триггер

		private static var tileX:int = Tile.tileX;
		private static var tileY:int = Tile.tileY;

		// Constructor
		public function Area(nloc:Location, xml:XML=null, loadObj:Object=null, mirror:Boolean=false) {
			loc=nloc;
			if (xml) {
				bx=xml.@x;
				by=xml.@y;
				if (xml.@w.length()) rx=xml.@w;
				if (mirror) {
					bx=loc.spaceX-bx-rx;
				}
				this.boundingBox.width = rx * tileX;
				this.coordinates.X  = bx * tileX;
				this.boundingBox.left = bx * tileX;
				this.coordinates.Y  = by * tileY + tileY;
				this.boundingBox.bottom = by * tileY + tileY;
				this.boundingBox.right = this.boundingBox.left + this.boundingBox.width;
				if (xml.@h.length()) ry=xml.@h;
				this.boundingBox.height = ry * tileY;
				this.boundingBox.top = this.boundingBox.bottom - this.boundingBox.height
				//визуал
				if (xml.@vis.length()) {
					vis=Res.getVis('vis'+xml.@vis,visArea);	// .SWF Dependency
				}
				if (World.w.showArea) {
					vis=new visArea();	// .SWF Dependency
				}
				if (xml.@tip.length()) tip=xml.@tip;
				if (xml.@mess.length()) mess=xml.@mess;
				if (xml.@down.length()) messDown=true;
				if (xml.@off.length()) enabled=xml.@off<=0;
				if (xml.@allact.length()) allact=xml.@allact;
				if (xml.@allid.length()) allid=xml.@allid;
				if (xml.@trig.length()) trig=true;
				//прикреплённые скрипты
				if (xml.scr.length()) {
					for each (var xscr in xml.scr) {
						var scr:Script=new Script(xscr,loc.land,this);
						if (scr.eve==null || scr.eve=='over') scrOver=scr;
						if (scr.eve=='out') scrOut=scr;
					}
				}
				if (xml.@scr.length()) scrOver=World.w.game.getScript(xml.@scr,this);
				if (xml.@scrout.length()) scrOut=World.w.game.getScript(xml.@scrout,this);
				//изменить стенки
				if (xml.@tilehp.length() || xml.@tileop.length() || xml.@tilethre.length()) {
					for (var i=bx; i<bx+rx; i++) {
						for (var j=by-ry+1; j<=by; j++) {
							var t:Tile=loc.getTile(i,j);
							if (xml.@tilehp.length()) {
								t.hp=xml.@tilehp;
								t.indestruct=false;
								if (t.hp<=1) t.fake=true;
								if (t.thre>t.hp) t.thre=t.hp;
							}
							if (xml.@tilethre.length()) {
								t.indestruct=false;
								t.thre=xml.@tilethre;
							}
							if (xml.@tileop.length()) {
								if (t.phis==0) t.opac=xml.@tileop;
							}
						}
					}
				}
				if (xml.@grav.length()) lift=xml.@grav;
				if (xml.@norad.length()) noRad=true;
				//эмиттер частиц
				if (xml.@emit.length()) emit=Emitter.arr[xml.@emit];
				if (xml.@dens.length()) dens=xml.@dens;
				frec=dens*rx*ry/100;
				//телепорт
				if (xml.@port.length()) {
					var s:String=xml.@port;
					var arr:Array=s.split(':');
					if (arr.length>=2) {
						onPort=true;
						portX=arr[0];
						portY=arr[1];
					}
				}
			}
			if (loadObj) enabled = loadObj.enabled;
			if (enabled && lift!=1) setLift();
			if (vis) {
				if (vis.totalFrames<=1) vis.cacheAsBitmap=true;
				vis.x = coordinates.X;
				vis.y = coordinates.Y;
				vis.scaleX = this.boundingBox.width / 100;
				vis.scaleY = this.boundingBox.height / 100;
				vis.alpha=enabled?1:0.1;
				vis.blendMode='screen';
			}
		}
		
		public override function save():Object {
			var obj:Object=new Object();
			obj.enabled=enabled;
			return obj;
		}
		
		public override function command(com:String, val:String=null) {
			if (com=='onoff') enabled=!enabled;
			if (com=='off') enabled=false;
			if (com=='on') enabled=true;
			if (lift!=1) setLift();
			if (vis) vis.alpha=enabled?1:0.1;
			if (com=='dam') damTiles(int(val));
		}
		
		public override function step():void {
			if (!enabled || !loc.active || tip=='') return;
			if (emit) {
				t_frec+=frec;
				if (t_frec>1) {
					var kol:int=int(t_frec);
					t_frec-=kol;
					emit.cast(loc,(this.boundingBox.left + this.boundingBox.right)/2,(this.boundingBox.bottom)/2,{rx:this.boundingBox.width, ry:this.boundingBox.height, kol:kol});
				}
			}
			activator=null;
			if (tip=='gg') {
				active = this.boundingBox.intersects(loc.gg.boundingBox);
				if (active && noRad) loc.gg.noRad=true;
				activator=loc.gg;
			}
			else {
				active=false;
				for each(var un:Unit in loc.units)
				{
					if (!un.disabled && un.sost<3 && un.areaTestTip==tip && this.boundingBox.intersects(un.boundingBox))
					{
						active=true;
						activator=un;
						break;
					}
				}
			}
			if (active && mess) World.w.gui.messText(mess, '', messDown);
			if (active && run) run();
			if (active && !preactive && allact) loc.allAct(this,allact,allid);
			if (active && !preactive && over) over();
			if (active && !preactive && onPort) teleport(activator);
			if (!active && preactive && out) out();
			if (active && !preactive && scrOver) {
				if (trig && uid) {
					if (World.w.game.triggers[uid]!=1) {
						World.w.game.triggers[uid]=1;
						scrOver.start();
					}
				}
				else scrOver.start();
			}
			if (!active && preactive && scrOut) scrOut.start();
			preactive=active;
		}
		
		public function setSize(x1:Number, y1:Number, x2:Number, y2:Number):void {
			coordinates.X  = x1;
			this.boundingBox.left = x1;
			this.boundingBox.top = y1;
			this.boundingBox.right = x2;
			coordinates.Y  = y2;
			this.boundingBox.bottom = y2;
			this.boundingBox.width = this.boundingBox.right - this.boundingBox.left;
			this.boundingBox.height = this.boundingBox.bottom - this.boundingBox.top;
		}
		
		// Grav lift effect
		public function setLift():void {
			for (var i:int = bx; i < bx + rx; i++) {
				for (var j:int = by - ry + 1; j <= by; j++) {
					loc.getTile(i, j).grav = enabled? lift:1;
				}
			}
		}
		
		public function damTiles(destroy:int,tipDam:int=11):void {
			for (var i:int = bx; i < bx + rx; i++) {
				for (var j:int = by - ry + 1; j <= by; j++) {
					loc.hitTile(loc.getTile(i, j), destroy, (i + 0.5) * tileY, (j + 0.5) * tileY, tipDam);
				}
			}
		}
		
		public function teleport(un:Unit) {
			if (!un) return;
			if (!loc.collisionUnit((portX + 1) * tileX, (portY + 1) * tileY - 1, un.boundingBox.width, un.boundingBox.height)) {
				un.teleport((portX + 1) * tileX, (portY + 1) * tileY - 1);
			}
		}
	}
}
package fe.game.domain.location {

	import fe.engine.text.TextParser;
	import fe.game.ui.GUIManager;
	import fe.game.GameContainer;
	import fe.game.domain.serv.Script;
	import fe.game.rendering.Emitter;
	import fe.game.domain.units.Unit;
	import fe.game.domain.entities.Obj;
	import fe.game.domain.location.tile.Tile;
	import fe.game.rendering.enums.E_Decal;
	import fe.engine.utils.SymbolFactory;
	
	//[Active area]
	public class Area extends Obj {

		public var enabled:Boolean=true;
		public var tip:String = "gg";	//[1 - GG is activated]
		
		//зазмеры в блоках
		private var bx:int = 0;
		private var by:int = 0; 
		private var rx:int = 2;
		private var ry:int = 2;
		
		private var active:Boolean = false;		//область активна (активатор находится в ней)
		private var preactive:Boolean = false;	//область была активна в предыдущем такте
		
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
		public var lift:Number = 1.00;		//изменение гравитации
		public var onPort:Boolean = false;//телепортация
		public var portX:int = -1;
		public var portY:int = -1;
		public var noRad:Boolean = false;
		
		public var emit:Emitter;
		public var dens:Number = 1.00;
		public var frec:Number = 1.00;
		public var t_frec:Number = 0.00;
		public var trig:Boolean;	//при первой активации отключить и установить триггер

		private static var tileX:int = Tile.tileX;
		private static var tileY:int = Tile.tileY;

		public function Area(nloc:Location, xml:XML=null, loadObj:Object=null, mirror:Boolean=false) {
			loc = nloc;
			
			if (xml) {
				bx=xml.@x;
				by=xml.@y;
				
				if (xml.@w.length()) rx=xml.@w;
				
				if (mirror) {
					bx=loc.spaceX-bx-rx;
				}
				
				boundingBox.width = rx * tileX;
				coordinates.X  = bx * tileX;
				coordinates.Y  = by * tileY + tileY;

				if (xml.@h.length()) ry=xml.@h;

				boundingBox.height = ry * tileY;
				// Inset so a unit standing on the area's top edge isn't inside it
				boundingBox.setBounds(coordinates.X, coordinates.X + boundingBox.width, coordinates.Y - boundingBox.height, coordinates.Y);
				
				//визуал
				if (xml.@vis.length()) {
					vis = TextParser.getVis('vis' + xml.@vis, SymbolFactory.fetchSymbolClass("visArea"));		// .SWF Dependency
				}
				if (GameContainer.reference.showArea) {
					vis = SymbolFactory.createInstance("visArea");								// .SWF Dependency
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
					for each (var xscr:XML in xml.scr) {
						var scr:Script=new Script(xscr,loc.land,this);
						if (scr.eve==null || scr.eve=='over') scrOver=scr;
						if (scr.eve=='out') scrOut=scr;
					}
				}
				
				if (xml.@scr.length()) scrOver=GameContainer.reference.game.getScript(xml.@scr,this);
				
				if (xml.@scrout.length()) scrOut=GameContainer.reference.game.getScript(xml.@scrout,this);
				
				//изменить стенки
				if (xml.@tilehp.length() || xml.@tileop.length() || xml.@tilethre.length()) {
					for (var i:int = bx; i<bx+rx; i++) {
						for (var j:int = by - ry + 1; j<=by; j++) {
							var t:Tile=loc.getTile(i,j);
							if (xml.@tilehp.length()) {
								t.hp=xml.@tilehp;
								t.indestructible=false;
								if (t.hp<=1) t.isFakeWall=true;
								if (t.damageThreshold>t.hp) t.damageThreshold=t.hp;
							}
							if (xml.@tilethre.length()) {
								t.indestructible=false;
								t.damageThreshold=xml.@tilethre;
							}
							if (xml.@tileop.length()) {
								if (t.collision==0) t.opacity=xml.@tileop;
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
			
			if (loadObj) {
				enabled = loadObj.enabled;
			}
			
			if (enabled && lift!=1) {
				setLift();
			}
			
			if (vis) {
				if (vis.totalFrames <= 1) {
					vis.cacheAsBitmap = true;
				}

				vis.x = coordinates.X;
				vis.y = coordinates.Y;
				vis.scaleX = boundingBox.width / 100;
				vis.scaleY = boundingBox.height / 100;
				vis.alpha = enabled ? 1 : 0.10;
				vis.blendMode = 'screen';
			}
		}
		
		public override function save():Object {
			var obj:Object = {};
			obj.enabled = enabled;
			return obj;
		}
		
		public override function command(com:String, val:String=null):void {
			if (com=='onoff') enabled=!enabled;
			if (com=='off') enabled=false;
			if (com=='on') enabled=true;
			if (lift!=1) setLift();
			if (vis) vis.alpha=enabled?1:0.1;
			if (com=='dam') damTiles(int(val), E_Decal.FIRE);
		}
		
		public override function step():void {
			if (!enabled || !loc.active || tip == "") {
				return;
			}
			
			if (emit) {
				t_frec+=frec;
				
				if (t_frec>1) {
					var kol:int=int(t_frec);
					t_frec-=kol;
					emit.cast(loc,(boundingBox.left + boundingBox.right)/2,(boundingBox.top + boundingBox.bottom)/2,{rx:boundingBox.width, ry:boundingBox.height, kol:kol});
				}
			}
			
			activator=null;
			
			if (tip == 'gg') {
				active = boundingBox.intersects(loc.gg.boundingBox);
				
				if (active && noRad) {
					loc.gg.noRad=true;
				}
				
				activator = loc.gg;
			}
			else {
				active = false;
				
				for each(var un:Unit in loc.units) {
					if (!un.disabled && un.sost<3 && un.areaTestTip==tip && boundingBox.intersects(un.boundingBox)) {
						active = true;
						activator = un;
						break;
					}
				}
			}
			
			if (active && mess) {
				GUIManager.reference.gui.messText(mess, '', messDown);
			}
			
			if (active && run != null) {
				run();
			}
			
			if (active && !preactive && allact) {
				loc.allAct(this,allact,allid);
			}
			
			if (active && !preactive && over != null) {
				over();
			}
			
			if (active && !preactive && onPort) {
				teleport(activator);
			}
			
			if (!active && preactive && out != null) {
				out();
			}
			
			if (active && !preactive && scrOver) {
				if (trig && uid) {
					if (GameContainer.reference.game.triggers[uid] != 1) {
						GameContainer.reference.game.triggers[uid] = 1;
						scrOver.start();
					}
				}
				else {
					scrOver.start();
				}
			}
			
			if (!active && preactive && scrOut) {
				scrOut.start();
			}
			
			preactive = active;
		}
		
		public function setSize(x1:Number, y1:Number, x2:Number, y2:Number):void {
			coordinates.X  = x1;
			coordinates.Y  = y2;
			boundingBox.setBounds(x1, x2, y1, y2);
			boundingBox.width = x2 - x1;
			boundingBox.height = y2 - y1;
		}
		
		// Grav lift effect
		public function setLift():void {
			for (var i:int = bx; i < bx + rx; i++) {
				for (var j:int = by - ry + 1; j <= by; j++) {
					loc.getTile(i, j).gravity = enabled ? lift : 1;
				}
			}
		}
		
		public function damTiles(destroy:int, tipDam:int):void {
			for (var i:int = bx; i < bx + rx; i++) {
				for (var j:int = by - ry + 1; j <= by; j++) {
					loc.hitTile(loc.getTile(i, j), destroy, (i + 0.5) * tileY, (j + 0.5) * tileY, tipDam);
				}
			}
		}
		
		public function teleport(un:Unit):void {
			if (!un) {
				return;
			}
			
			if (!loc.collisionUnit((portX + 1) * tileX, (portY + 1) * tileY - 1, un.boundingBox.width, un.boundingBox.height)) {
				un.teleport((portX + 1) * tileX, (portY + 1) * tileY - 1);
			}
		}
	}
}

package fe.game.domain.objects {

	import flash.display.MovieClip;
	import flash.geom.ColorTransform;

	import fe.game.World;
	import fe.game.ui.GUIManager;
	import fe.game.GameContainer;
	import fe.engine.text.XMLDataGrabber;
	import fe.engine.text.TextParser;
	import fe.game.domain.entities.Obj;
	import fe.game.domain.serv.Interact;
	import fe.game.domain.location.tile.Tile;
	import fe.engine.SaveManager;
	import fe.game.rendering.Flipbook;
	import fe.game.domain.location.Area;
	import fe.game.domain.location.Location;

	public class CheckPoint extends Obj {

		public var id:String;
		public var vis2:MovieClip;
		
		public var active:int = 0;
		public var teleOn:Boolean=false;
		public var used:Boolean=false;
		public var main:Boolean=false;
		public var hide:Boolean=false;
		
		private var locked:Boolean=false;
		private var gate:Flipbook;		// Opens when the checkpoint is activated
		private var lock:Flipbook;		// Shown while the checkpoint is locked, at its lock level
		private var glow:Flipbook;		// Lights up while the checkpoint can teleport

		public var area:Area;

		public function CheckPoint(nloc:Location, nid:String, nx:int=0, ny:int=0, xml:XML=null, loadObj:Object=null) {
			id=nid;
			loc=nloc;
			layer=0;
			prior=1;
			id=nid;
			levitPoss=false;
			
			var node:XML = XMLDataGrabber.getNodeWithAttributeThatMatches("core", "AllData", "objs", "id", id);
			
			coordinates.X = nx;
			coordinates.Y = ny;
			boundingBox.width = node.@size * Tile.tileX;
			boundingBox.height = node.@wid * Tile.tileY;
			nazv=TextParser.txt('o','checkpoint');
			
			boundingBox.center(coordinates);

			coordinates.X  = nx;
			coordinates.Y  = ny;
			gate = createPart("checkpoint");
			lock = createPart("checkpoint_lock");
			glow = createPart("checkpoint_glow");

			if (id.charAt(10)) {
				lock.goTo(int(id.charAt(10)) - 1, false);
				locked = true;
			}
			else {
				lock.visible = false;
			}
		
			boundingBox.center(coordinates);
			cTransform=loc.cTransform;
			loc.getAbsTile(coordinates.X - 20, coordinates.Y + 10).platform = true;
			loc.getAbsTile(coordinates.X + 20, coordinates.Y + 10).platform = true;
			
			inter = new Interact(this,node,xml,loadObj);
			inter.userAction='activate';
			inter.actFun=activate;
			inter.update();
			inter.active=true;
			inter.action=100;
			
			area=new Area(loc);
			area.setSize(boundingBox.left, boundingBox.top, boundingBox.right, boundingBox.bottom);
			area.over=areaActivate;
			
			if (xml && xml.@main.length()) main=true;
			if (xml && xml.@tele.length()) teleOn=true;
			if (xml && xml.@hide.length()) hide=true;
			
			if (loadObj) {
				active=loadObj.act;
			
				if (active==false) active=0;
			
				if (active==1)  gate.goToLabel('reopen', false);

				if (active==2)  {
					gate.goToLabel('open', false);
				}
			
				if (loadObj.used) used=true;
			}
			
			if (main) {
				area=null;
				active=2;
				teleOn=true;
				gate.goToLabel('open', false);
				loc.land.currentCP=this;
				inter.actFun=teleport;
				inter.userAction='returnm';
				inter.t_action=30;
				inter.update();
				glow.goTo(glow.frameCount - 1, false);
			}

			if (hide) {
				nazv='';
				inter.active=false;
			}
		}
		
		// One of its parts, drawn at its place
		private function createPart(name:String):Flipbook {
			var part:Flipbook = new Flipbook(GameContainer.reference.grafon.flipbooks.viewDefinition(name));

			part.x = coordinates.X;
			part.y = coordinates.Y;

			return part;
		}

		public override function addVisual():void {
			if (!hide) {
				GameContainer.reference.grafon.objectLayers.add(gate, layer);
				GameContainer.reference.grafon.objectLayers.add(lock, layer);
				GameContainer.reference.grafon.objectLayers.add(glow, layer);

				if (cTransform) {
					setTint(cTransform);
				}
			}
		}

		public override function remVisual():void {
			super.remVisual();
			gate.removeFromParent();
			lock.removeFromParent();
			glow.removeFromParent();
		}

		public override function setTint(tint:ColorTransform):void {
			gate.setTint(tint);
			lock.setTint(tint);
			glow.setTint(tint);
		}
		
		public override function save():Object {
			if (active==0) return null;
		
			var obj:Object=new Object();
			inter.save(obj);
			obj.act=active;
		
			if (used) obj.used=1;
		
			return obj;
		}
		
		public override function command(com:String, val:String=null):void {
			activate();
		}
		
		//активировать контрольную точку. если параметр true - не добавлять скилл-поинт
		public function activate(first:Boolean=false):void {
			if (inter.lock>0 || inter.mine>0) return;
		
			if (active==2) {
				return;
			}
		
			if (active==0 && first==false) {
				if (GameContainer.reference.pers.manaCPres) GameContainer.reference.pers.heal(GameContainer.reference.pers.manaCPres,6);
		
				if (GameContainer.reference.pers.xpCPadd) GameContainer.reference.pers.expa(loc.unXp*3);
			}
	
			active=2;
			GameContainer.reference.pers.currentCP=this;
			GameContainer.reference.pers.currentCPCode=code;
	
			if (code) {
				GameContainer.reference.pers.prevCPCode=code;
				loc.land.act.lastCpCode=code;
			}
	
			loc.land.currentCP=this;
	
			if (first) {
				gate.goToLabel('open', false);
				if (GameContainer.reference.game.mReturn && teleOn && !used) glow.goTo(glow.frameCount - 1, false);
			}
			else {
				gate.isPlaying = true;

				if (GameContainer.reference.game.mReturn && teleOn && !used) glow.goTo(0, true);
			}

			if (used) glow.goTo(0, false);
		
			if (GameContainer.reference.game.mReturn && teleOn && !used) {
				inter.actFun=teleport;
				inter.userAction='returnb';
				inter.t_action=30;
				inter.update();
			}
			else {
				inter.active=false;
				inter.actionText='';
			}
			
			GUIManager.reference.gui.infoText('checkPoint');
			SaveManager.reference.saveGame();
		}
		
		public function teleport():void {
			if (main) {
				if (GameContainer.reference.game.missionId != 'rbl') {
					GameContainer.reference.game.gotoLevel(GameContainer.reference.game.missionId);
				}
			}
			else {
				GameContainer.reference.game.gotoLevel(GameContainer.reference.game.baseId);
				
				if (GameContainer.reference.hardInv && World.w.land.rnd) {
					used = true;
					inter.active = false;
					inter.actionText = '';
					glow.goTo(0, false);
				}
			}
		}
		
		public function areaActivate():void {
			if (active == 0) {
				activate();
			}
		}
		
		public function deactivate():void {
			if (main) {
				return;
			}

			inter.active=!hide;
			active=1;
			gate.goToLabel('reopen', false);
			glow.goTo(0, false);
			inter.actFun=activate;
			inter.userAction='activate';
			inter.t_action=0;
			inter.update();
		}
		
		public override function step():void {
			onCursor=(boundingBox.left < GameContainer.reference.celX && boundingBox.right > GameContainer.reference.celX && boundingBox.top < GameContainer.reference.celY && boundingBox.bottom > GameContainer.reference.celY)?prior:0;
			
			if (inter) {
				inter.step();
			}
			
			if (main) {
				if (GameContainer.reference.game.missionId && GameContainer.reference.game.lands[GameContainer.reference.game.missionId] && GameContainer.reference.game.lands[GameContainer.reference.game.missionId].tip !='base') {
					inter.active = true;
				}
				else {
					inter.active = false;
				}
				
				return;
			}
			
			if (locked && inter.lock==0 && inter.mine==0) {
				locked=false;
				lock.visible=false;
			}
			
			if (area) {
				area.step();
			}
			
			if (active == 2 && GameContainer.reference.pers.currentCP != this) {
				deactivate();
			}
		}
	}
}
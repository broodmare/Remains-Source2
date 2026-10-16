package fe.game.domain.units {

	import fe.game.ui.GUIManager;
	import fe.game.GameContainer;
	import fe.game.domain.projectile.Bullet;
	import fe.game.enums.E_Direction;
	
	public class UnitPhoenix extends Unit {
		
		private var t_fall:int=0;
		private static var questOk:Boolean=false;
		
		public function UnitPhoenix(cid:String=null, ndif:Number=100, xml:XML=null, loadObj:Object=null) {
			id="phoenix";
			getXmlParam();
			initBlit();
			animState="stay";
			activateTrap=0;
			showNumbs=false;
			doop=true;
			levitPoss=false;
			stay=true;
			inter.active=true;
			inter.action=100;
			inter.cont=null;
			inter.userAction="tame";
			inter.update();
			inter.t_action=30;
			inter.actFun=tame;
		}
		
		public override function damage(dam:Number, tip:String, bul:Bullet=null, tt:Boolean=false):Number {
			die();
			return 1;
		}
		
		public override function die(sposob:int=0):void {
			if (hpbar) hpbar.visible=false;
			expl();
			exterminate();
			runScript();
			if (GameContainer.reference.game) {
				GameContainer.reference.game.triggers["frag_"+id]=0;
			}
		}
		
		public override function expl():void {
			newPart("green_spark",25);
		}

		public override function animate():void {
			if (aiState==0) animState="stay";
			else animState="fly";
			if (animState!=animState2) {
				anims[animState].restart();
				animState2=animState;
			}
			if (!anims[animState].st) {
				blit(animState, Math.floor(anims[animState].f));
			}
			anims[animState].step();
		}
		
		public override function command(com:String, val:String=null):void {
			if (com=="tame") {
				die();
				var pet:UnitPet=GameContainer.reference.gg.pets["phoenix"];
				GameContainer.reference.gg.callPet("phoenix");
				pet.detectionDelay = 0;
				pet.setPos(coordinates.X, coordinates.Y);
			}
		}
		
		public override function setNull(f:Boolean=false):void {
			if (GameContainer.reference.game.triggers["tame"]>=5) die();
		}
		
		private function tame():void {
			if (!questOk) {
				GameContainer.reference.game.addQuest("tamePhoenix");
			}
			
			storona = (coordinates.X > GameContainer.reference.gg.coordinates.X) ? E_Direction.LEFT : E_Direction.RIGHT;
			
			if (GameContainer.reference.invent.hasItem("radcookie")) {
				GameContainer.reference.game.incQuests("tame_ph");
				GameContainer.reference.gg.itemInteraction.minusItem("radcookie");
				
				if (GameContainer.reference.game.triggers["tame"]) {
					GameContainer.reference.game.triggers["tame"]++;
				}
				else {
					GameContainer.reference.game.triggers["tame"] = 1;
				}
				
				if (GameContainer.reference.game.triggers["tame"] >= 5 && !GameContainer.reference.game.triggers["pet_phoenix"]) {	//приручить
					if (GameContainer.reference.game.runScript("tamePhoenix", this)) {
						GameContainer.reference.game.triggers["pet_phoenix"] = 1;
					}
				}
				else {
					die();
					GUIManager.reference.gui.messText("phoenixFeed2", "", coordinates.Y < 300);
				}
			}
			else {
				GUIManager.reference.gui.messText("phoenixFeed1", "", coordinates.Y < 300);
			}
			
			if (GameContainer.reference.game) {
				GameContainer.reference.game.triggers["frag_" + id] = 0;
			}
		}
		
		override protected function control():void {
			if (!stay) {
				t_fall++;
			}
			
			if (t_fall >= 3 || velocity.X > 1 || velocity.X < -1) {
				die();
			}
			
			if (!questOk && loc.celObj == this) {
				GameContainer.reference.game.triggers["frag_" + id] = 0;
				GameContainer.reference.game.addQuest("tamePhoenix");
				questOk = true;
			}
		}
	}
}
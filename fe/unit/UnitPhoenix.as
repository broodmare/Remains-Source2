package fe.unit {
	import fe.*;
	import fe.weapon.Bullet;
	//import fe.serv.Script;
	
	public class UnitPhoenix extends Unit {
		
		var t_fall:int=0;
		//var tameScr:Script;
		static var questOk:Boolean=false;
		
		public function UnitPhoenix(cid:String=null, ndif:Number=100, xml:XML=null, loadObj:Object=null) {
			id='phoenix';
			getXmlParam();
			initBlit();
			animState='stay';
			activateTrap=0;
			showNumbs=false;
			doop=true;
			levitPoss=false;
			stay=true;
			inter.active=true;
			inter.action=100;
			inter.cont=null;
			inter.userAction='tame';
			inter.update();
			inter.t_action=30;
			inter.actFun=tame;
		}
		
		public override function damage(dam:Number, tip:int, bul:Bullet=null, tt:Boolean=false):Number {
			die();
			return 1;
		}
		
		public override function die(sposob:int=0) {
			if (hpbar) hpbar.visible=false;
			expl();
			exterminate();
			runScript();
			if (World.w.game) {
				World.w.game.triggers['frag_'+id]=0;
			}
		}
		
		public override function expl()	{
			newPart('green_spark',25);
		}

		public override function animate() {
			if (aiState==0) animState='stay';
			else animState='fly';
			if (animState!=animState2) {
				anims[animState].restart();
				animState2=animState;
			}
			if (!anims[animState].st) {
				blit(anims[animState].id,Math.floor(anims[animState].f));
			}
			anims[animState].step();
		}
		
		public override function command(com:String, val:String=null) {
			if (com=='tame') {
				die();
				var pet:UnitPet=World.w.gg.pets['phoenix'];
				World.w.gg.callPet('phoenix');
				pet.oduplenie=0;
				pet.setPos(X,Y);
			}
		}
		
		public override function setNull(f:Boolean=false) {
			if (World.w.game.triggers['tame']>=5) die();
		}
		
		function tame() {
			if (!questOk) World.w.game.addQuest('tamePhoenix');
			storona=(X>World.w.gg.X)?-1:1;
			if (World.w.invent.items['radcookie'].kol>0) {
				World.w.game.incQuests('tame_ph');
				World.w.invent.minusItem('radcookie');
				if (World.w.game.triggers['tame']) World.w.game.triggers['tame']++;
				else World.w.game.triggers['tame']=1;
				if (World.w.game.triggers['tame']>=5 && !World.w.game.triggers['pet_phoenix']) {	//приручить
					if (World.w.game.runScript('tamePhoenix',this)) World.w.game.triggers['pet_phoenix']=1;
					/*var xml1=GameData.d.script.(@id==)
					if (xml1.length()) {
						xml1=xml1[0];
						tameScr=new Script(xml1,loc.land,this);
						tameScr.start();
						World.w.game.triggers['pet_phoenix']=1;
					}*/
				} else {
					die();
					World.w.gui.messText('phoenixFeed2','',Y<300);
				}
			} else {
				World.w.gui.messText('phoenixFeed1','',Y<300);
			}
			if (World.w.game) {
				World.w.game.triggers['frag_'+id]=0;
			}
		}
		
		public override function control() {
			if (!stay) t_fall++;
			if (t_fall>=3 || dx>1 || dx<-1) die();
			if (!questOk && loc.celObj==this) {
				World.w.game.triggers['frag_'+id]=0;
				World.w.game.addQuest('tamePhoenix');
				questOk=true;
			}
		}

	}
	
}

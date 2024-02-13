package fe.unit.unitTypes
{
	import fe.*;
	import fe.unit.Unit;
	import fe.projectile.Bullet;

	public class UnitPhoenix extends Unit
	{
		var t_fall:int=0;
		static var questOk:Boolean=false;
		
		public function UnitPhoenix(cid:String=null, ndif:Number=100, xml:XML=null, loadObj:Object=null)
		{
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
		
		public override function damage(dam:Number, tip:int, bul:Bullet=null, tt:Boolean=false):Number
		{
			die();
			return 1;
		}
		
		public override function die(sposob:int=0)
		{
			if (hpbar) hpbar.visible=false;
			expl();
			exterminate();
			runScript();
			if (World.w.game) {
				World.w.game.triggers['frag_'+id]=0;
			}
		}
		
		public override function expl():void
		{
			newPart('green_spark',25);
		}

		public override function animate()
		{
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
		
		public override function command(com:String, val:String=null)
		{
			if (com=='tame') {
				die();
				var pet:UnitPet=World.w.gg.pets['phoenix'];
				World.w.gg.callPet('phoenix');
				pet.oduplenie=0;
				pet.setPos(coordinates.X, coordinates.Y);
			}
		}
		
		public override function setNull(f:Boolean=false)
		{
			if (World.w.game.triggers['tame']>=5) die();
		}
		
		private function tame():void
		{
			if (!questOk) World.w.game.addQuest('tamePhoenix');
			storona=(coordinates.X > World.w.gg.coordinates.X)? -1:1;
			if (World.w.invent.items['radcookie'].kol>0) {
				World.w.game.incQuests('tame_ph');
				World.w.invent.minusItem('radcookie');
				if (World.w.game.triggers['tame']) World.w.game.triggers['tame']++;
				else World.w.game.triggers['tame']=1;
				if (World.w.game.triggers['tame']>=5 && !World.w.game.triggers['pet_phoenix']) {	//приручить
					if (World.w.game.runScript('tamePhoenix',this)) World.w.game.triggers['pet_phoenix']=1;
				}
				else
				{
					die();
					World.w.gui.messText('phoenixFeed2', '', coordinates.Y < 300);
				}
			}
			else
			{
				World.w.gui.messText('phoenixFeed1', '', coordinates.Y < 300);
			}
			if (World.w.game)
			{
				World.w.game.triggers['frag_'+id]=0;
			}
		}
		
		override protected function control():void
		{
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
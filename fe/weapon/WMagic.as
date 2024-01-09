package fe.weapon {
	
	import fe.*;
	import fe.unit.Unit;
	import fe.unit.UnitPlayer;
	import fe.unit.Pers;
	
	public class WMagic extends Weapon {
		
		public function WMagic(own:Unit, nid:String, nvar:int=0) {
			super(own,nid,nvar);
			if (prep) animated=false;
		}

		public override function attack(waitReady:Boolean=false):Boolean {
			//trace('atk');
			if (!waitReady && !World.w.alicorn && !auto && t_auto>0) {
				t_auto=3;
				return false;
			}
			skillConf=1;
			if (t_rel>0) return false;
			if (owner.player && (World.w.pers.spellsPoss==0 || alicorn && !World.w.alicorn)) {
				World.w.gui.infoText('noSpells');
				World.w.gui.bulb(X,Y);
				Snd.ps('nomagic');
				return false;
			}
			if (owner.player && respect==1) {
				World.w.gui.infoText('disSpell',null,null,false);
				Snd.ps('nomagic');
				return false;
			}
			if (owner.player) {
				if (!checkAvail()) return false;
			}
			is_attack=true;
			if (t_prep<prep+10) t_prep+=2;
			if (t_prep>=prep && t_attack<=0) {
				if (owner.player && dmana>World.w.pers.manaHP) {
					t_rel=t_prep*3;
					World.w.gui.infoText('noMana');
					World.w.gui.bulb(X,Y);
					Snd.ps('nomagic');
				} else if (dmagic<=owner.mana || owner.mana>=owner.maxmana*0.99) {
					if (dkol<=0) t_attack=rapid;
					else t_attack=rapid*(dkol+1);
				} else {
					t_rel=t_prep*3;
					if (owner.player) {
						World.w.gui.infoText('noMana');
						World.w.gui.bulb(X,Y);
						Snd.ps('nomagic');
					}
				}
			}
			return true;
		}
		
		public override function setPers(gg:UnitPlayer, pers:Pers) {
			super.setPers(gg,pers);
			dmana=mana*pers.allDManaMult*pers.warlockDManaMult;
			dmagic=magic*pers.allDManaMult*pers.warlockDManaMult;
			damMult*=pers.spellsDamMult;
		}
		
		//результирующий урон
		public override function resultDamage(dam0:Number, sk:Number=1):Number {
			return (dam0+damAdd)*damMult*sk;
		}
		//результирующая дальность
		public override function resultPrec(pm:Number=1, sk:Number=1):Number {
			return precision*precMult*pm;
		}
		protected override function shoot():Bullet {
			if (super.shoot()) {
				owner.mana-=dmagic;
				owner.dmana=0;
				if (owner.player) {
					World.w.pers.manaDamage(dmana);
				}
			}
			return b;
		}
		
		public override function animate() {
			
			if (!vis) return;
			vis.x=X;
			vis.y=Y;
			if (prep) {
				if (t_prep>1) vis.gotoAndStop(t_prep);
				else vis.gotoAndStop(1);
			}
		}
		
	}
	
}

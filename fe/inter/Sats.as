package fe.inter {

	import flash.display.MovieClip;
	import flash.filters.GlowFilter;
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	import flash.geom.Rectangle;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.events.MouseEvent;

	import fe.*;
	import fe.unit.Unit;
	import fe.weapon.Weapon;
	import fe.unit.UnitPlayer;
	
	public class Sats {

		public var vis:MovieClip;		
		public var trasser:MovieClip;	// Line drawn to mouse cursor.
		public var radius:MovieClip;	// Green circular highlight indicating melee range or explosive damage range.
		public var active:Boolean = false;
		public var que:Array;
		public var weapon:Weapon;
		public var gg:UnitPlayer;
		public var skillConf:Number=1;			//[modifier, depends on the level of the skill, 1 is normal, 0.75 is a skill 1 level lower, 0.5 is a skill 2 levels lower]
		public var units:Array;
		public var ct:ColorTransform = new ColorTransform(1, 1, 1, 1, 0, 100, 0, 0);
		private var fGlow:GlowFilter = new GlowFilter(0xFF0000, 1, 3, 3, 4, 1);
		private var fShad:GlowFilter = new GlowFilter(0x000000, 1, 3, 3, 3, 1);
		
		public var od:Number = 80;	// [Real ods]
		public var odv:Number = 80;	// [Virtual ods]
		public var odd:Number = 0.1;
		public var limOd:Number = 200;
		
		public function Sats(nvis:MovieClip) {
			vis=nvis;
			vis.visible = false;
			trasser = new MovieClip();
			radius = new satsRadius();	// SWF Dependency
			vis.addChild(trasser);
			vis.addChild(radius);
			que = [];
			units = [];
		}

		//Показать/скрыть
		public function onoff(turn:int=0):void {
			if (turn == 0) active =! active;
			else if (turn > 0) active = true;
			else active=false;
			
			if (active) {
				if (World.w.loc.base || World.w.alicorn) {
					active = false;
					return;
				}

				gg = World.w.gg;
				weapon = gg.currentWeapon;
				if (weapon == null) {
					World.w.gui.infoText('noSats');
					active=false;
				}
				else {
					if (weapon.noSats) {
						World.w.gui.infoText('noSats');
						active=false;
					}
					else {
						var st:int = weapon.status();
						// Out of ammo
						if (st == 4) {
							World.w.gui.infoText('noAmmo', '');
							active = false;
						}
						// Weapon broken
						if (st == 5) {
							World.w.gui.infoText('brokenWeapon', '');
							active = false;
						}
						// Not enough magic
						if (st == 6) {
							World.w.gui.infoText('noMana', '');
							active = false;
						}
					}
				}
			}
			if (active) {
				if (weapon.tip > 1) {
					trasser.visible = true;
					trass();
				}
				else {
					trasser.visible=false;
					radius.visible=true;
					radius.x = gg.coordinates.X + gg.pers.meleeS*gg.storona;
					radius.y = gg.coordinates.Y - gg.boundingBox.halfHeight;
					radius.scaleX=radius.scaleY=gg.pers.meleeR/100;
				}

				skillConf = 1;
				
				if (World.w.weaponsLevelsOff) {
					var razn:int = weapon.lvl - gg.pers.getWeapLevel(weapon.skill);
					if (razn == 1) skillConf = 0.8;
					else if (razn == 2) skillConf = 0.6;
					else if (razn > 2) {
						skillConf = 0;
						World.w.gui.infoText('weaponSkillLevel');
						active = false;
						return;
					}
				}
				
				if (que.length > 0) {
					clearAll();
				}
				
				World.w.grafon.drawSats();
				World.w.grafon.onSats(true);
				getUnits();
				World.w.gui.offCelObj();
				odv = od;
				World.w.gui.setOd();
				World.w.swfStage.addEventListener(MouseEvent.MOUSE_MOVE, mMove);
				World.w.gui.setTopText('infosats');
			}
			else
			{
				World.w.grafon.onSats(false);
				offUnits();
				World.w.swfStage.removeEventListener(MouseEvent.MOUSE_MOVE, mMove);
				World.w.ctr.clearAll();
				World.w.gui.setTopText('');
			}
			
			vis.visible = active;
			World.w.gui.setSats(active);
		}
		
		// [when on pause]
		public function step():void {
			if (active) {
				if (World.w.ctr.keyAttack) {
					setCel();
					World.w.ctr.keyAttack = false;
				}
				if (World.w.ctr.keyTele) {
					unsetCel();
					World.w.ctr.keyTele = false;
				}
				if (World.w.ctr.keyAction) {
					onoff(-1);
					World.w.ctr.keyAction = false;
				}
			}
		}
		
		// [When not on pause]
		public function step2():void {
			if (que.length > 0 && World.w.ctr.keyAttack) {
				clearAll();
			}
			
			// Not enough action points
			if (que.length > 0 && weapon.satsCons * weapon.consMult * weapon.consMult / skillConf * gg.pers.satsMult / weapon.satsQue > od) {
				World.w.gui.infoText('noOd');
				clearAll();
			}

			// Queue is finished
			if (que.length == 0 && od < gg.pers.maxOd) {
				od += odd;
				odv = od;
				World.w.gui.setOd();
			}
		}
		
		public function clearAll():void {
			var n:int = que.length;
			for (var i:int = 0; i < n; i++) {
				var cel:SatsCel = que.shift();
				cel.remove();
			}
			odv = od;
			World.w.gui.setOd();
		}
		
		public function setCel():void {
			// Not enough action points
			if (weapon.satsCons * weapon.consMult / skillConf * gg.pers.satsMult > odv) {
				World.w.gui.infoText('noOd');
				return;
			}
			
			var cel:SatsCel;
			
			if (units.length) {
				for each (var obj in units) {
					if (obj.du.filters.length>0) {
						cel = new SatsCel(obj,0,0,weapon.satsCons*weapon.consMult/skillConf*gg.pers.satsMult,weapon.satsQue);
						break;
					}
				}
			}
			
			if (cel == null) {
				cel = new SatsCel(null, World.w.celX, World.w.celY, weapon.satsCons * weapon.consMult / skillConf * gg.pers.satsMult, weapon.satsQue);
			}
			
			weapon.ready = false;
			odv -= weapon.satsCons * weapon.consMult / skillConf * gg.pers.satsMult;
			World.w.gui.setOd();
			que.push(cel);
		}

		public function unsetCel(q:Boolean=false):void {
			if (que.length == 0) {
				onoff(-1);
				return;
			}
			
			var cel:SatsCel;
			
			if (q) cel = que.shift();
			else cel = que.pop();
			
			if (cel.un) {
				cel.un.n--;
			}
			
			cel.remove();
			odv += weapon.satsCons * weapon.consMult / skillConf * gg.pers.satsMult;
			
			if (que.length==0) {
				onoff(-1);
				odv = od;
			}
			
			World.w.gui.setOd();
		}
		
		public function getReady():Boolean {
			if (que.length > 0 && (que[0].un == null || que[0].begined || que[0].un.u.sost < 3)) return true;
			else return false;
		}
		
		// [Action completed]
		public function act():void {
			od -= que[0].cons;
			World.w.gui.setOd();
			if (que[0].kol > 1 && weapon.status() <= 1) {
				que[0].kol--;
				que[0].begined = true;
			}
			else {
				var cel:SatsCel = que.shift();
				cel.remove();
			}
		}
		
		// This function calculates hit percentages in SATS. The use of this percentage is currently unknown.
		// It does not correct gun dispersion or a unit's (dodge chance?) so projectiles will still miss at 100%
		private function getPrec(un:Unit):Number {
			var prec:Number = 1;
			var sk:int = gg.pers.weaponSkills[weapon.skill];
			var dx:Number = weapon.coordinates.X - un.coordinates.X;
			var dy:Number = weapon.coordinates.Y - un.coordinates.Y;
			var rasst:Number = Math.sqrt(dx * dx + dy * dy);
			
			if (weapon.precision > 0) {
				prec = weapon.resultPrec(1, sk) / rasst / (un.dexter + 0.1) * skillConf;
			}
			
			if (weapon.antiprec > 0 && rasst < weapon.antiprec) {
				prec = (rasst / weapon.antiprec * 0.75 + 0.25) / (un.dexter + 0.1) * skillConf;
			}
			
			if (weapon.deviation > 0 || gg.mazil > 0) {
				var ug1:Number = Math.atan2(un.boundingBox.height, rasst) * 180 / Math.PI;
				var ug2:Number = (weapon.deviation / (sk + 0.01) + gg.mazil);
				if (ug2 > ug1) prec = prec * ug1 / ug2;
			}
			
			if (prec > 0.95) {
				prec = 0.95;
			}
			
			if (prec > skillConf) {
				prec = skillConf;
			}

			return prec;
		}
		
		public function drawUnit(un:Unit):MovieClip {
			var satsBmp:BitmapData = new BitmapData(un.vis.width, un.vis.height, true, 0);
			var m:Matrix = new Matrix();
			var rect:Rectangle = un.vis.getBounds(un.vis);
			m.tx = -rect.left;
			m.ty = -rect.top;

			var hpoff:Boolean = false;
			
			if (un.hpbar && un.hpbar.visible) {
				hpoff = true;
			}
			
			if (hpoff) {
				un.hpbar.visible = false;
			}
			
			satsBmp.draw(un.vis, m, ct);
			
			if (hpoff) {
				un.hpbar.visible = true;
			}
			
			var mc:MovieClip = new MovieClip();
			mc.scaleX = un.vis.scaleX;
			mc.scaleY = un.vis.scaleY;
			mc.rotation = un.vis.rotation;
			var bm:Bitmap = new Bitmap(satsBmp);
			mc.addChild(bm);
			bm.x = rect.left;
			bm.y = rect.top;
			
			mc.addEventListener(MouseEvent.MOUSE_OVER,mOver);
			mc.addEventListener(MouseEvent.MOUSE_OUT,mOut);
			
			return mc;
		}
		
		// Mouse-over
		public function mOver(event:MouseEvent):void {	
			// Apply a red highlight to the unit (If the player is not using grenades.)
			if (active && !weapon.noPerc) {
				(event.currentTarget as MovieClip).filters = [fGlow];
			}
			
			try {
				var su:TextField = (event.currentTarget.parent as MovieClip).getChildAt(1)['info'];
				su.visible = true;
			}
			catch(err) {
				trace('ERROR: (00:44)');
			}
		}

		// Stop Mouse-over
		public function mOut(event:MouseEvent):void {	
			// Remove red highlight by resetting the filters array.
			if (active && !weapon.noPerc) {
				(event.currentTarget as MovieClip).filters = [];
			}
			
			try {
				var su:TextField = (event.currentTarget.parent as MovieClip).getChildAt(1)['info'];
				su.visible = false;
			}
			catch(err) {
				trace('ERROR: (00:45)');
			}
		}
		
		public function offUnits():void {
			if (units && units.length) {
				for each (var obj in units) {
					try {
						vis.removeChild(obj.v);
						obj.v.removeEventListener(MouseEvent.MOUSE_OVER, mOver);
						obj.v.removeEventListener(MouseEvent.MOUSE_OUT, mOut);
					}
					catch (err) {
						trace('ERROR: (00:46)');
					}
				}
			}
			
			units = [];
			
			for each (obj in que) {
				obj.vis.visible = false;
			}
		}
		
		public function getUnits():void {
			for each (var un:Unit in World.w.loc.units) {
				if (!gg.isMeet(un) || !un.isSats || un.sost>=3 || un.invis) {
					continue;
				}
				
				if (weapon.satsMelee) {
					if (gg.look(un,false, 0, gg.pers.meleeR * 1.2 + 100) <= 0) {
						continue;
					}
				}
				else if (gg.look(un) <= 0 || !un.getTileVisi()) {
					continue;
				}

				var mc:MovieClip = new MovieClip();
				mc.x = un.vis.x;
				mc.y = un.vis.y;
				vis.addChild(mc);
				var du:MovieClip = drawUnit(un);
				var su:MovieClip = new satsUnit(); // SWF Dependency
				su.filters = [fShad];
				su.scaleX = 1 / World.w.cam.scaleV;
				su.scaleY = 1 / World.w.cam.scaleV;
				var txt:TextField = su.txt;
				var info:TextField = su.info;
				txt.y = 3;
				txt.autoSize=TextFieldAutoSize.CENTER;
				if (!weapon.noPerc) var prec:Number = getPrec(un);
				txt.text = un.nazv;
				txt.selectable = false;
				if (!weapon.noPerc) txt.text += '\n' + Math.round(prec * 100) + '%';
				
				info.autoSize=TextFieldAutoSize.CENTER;
				info.selectable=false;				
				info.visible=false;
				info.text='';
				
				//[Extended information about the enemy]
				if (World.w.pers && World.w.pers.modAnalis) {
					info.text += '\n' + Res.pipText('level') + ': ' + (un.level + 1);
					info.text += '\n' + Res.pipText('hp') + ': ' + Math.ceil(un.hp) + '/' + Math.ceil(un.maxhp);
					if (un.skin > 0) info.text += '\n' + Res.pipText('skin') + ': ' + Math.ceil(un.skin);
					if (un.armor_qual > 0 && un.armor > 0) info.text += '\n' + Res.pipText('armor') + ': ' + Math.ceil(un.armor + un.skin) + ' (' + Math.round(un.armor_qual * 100) + '%)';
					if (un.armor_qual > 0 && un.marmor > 0) info.text += '\n' + Res.pipText('marmor') + ': ' + Math.ceil(un.marmor + un.skin) + ' (' + Math.round(un.armor_qual * 100) + '%)';
					
					if (mc.y < 150) {
						info.y = 50;
					}
					else {
						info.y = -un.boundingBox.height - info.textHeight - 20;
					}
				}
				
				su.name = 'su';
				mc.addChild(du);
				mc.addChild(su);
				units.push({u:un, v:mc, du:du, p:prec, n:0});
			}
		}
		
		public function mMove(event:MouseEvent):void {
			trass();
		}
		
		public function trass():void {
			if (weapon.noTrass) {
				return;
			}
			
			weapon.setTrass(trasser.graphics);
			
			if (weapon.explRadius) {
				radius.visible = true;
				radius.scaleX = weapon.explRadius / 100;
				radius.scaleY = weapon.explRadius / 100;
				radius.cacheAsBitmap = true;
				radius.x = weapon.trasser.X;
				radius.y = weapon.trasser.Y;
			}
			else {
				radius.visible = false;
			}
		}
	}
}
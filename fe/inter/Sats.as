package fe.inter {
	import flash.display.MovieClip;
	import flash.filters.GlowFilter;
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.display.DisplayObject;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.events.MouseEvent;

	//import flash.text.TextFormat;

	//import flash.events.MouseEvent;
	
	import fe.*;
	import fe.unit.Unit;
	import fe.weapon.Weapon;
	import fe.unit.UnitPlayer;
	
	public class Sats {
		
		public var vis:MovieClip;
		//public var allvis:Bitmap;
		//public var bmp:BitmapData;
		public var trasser:MovieClip;
		public var radius:MovieClip;
		public var active:Boolean=false;
		public var que:Array;
		public var weapon:Weapon;
		public var gg:UnitPlayer;
		public var skillConf:Number=1;			//модификатор, зависит от соответствия уровня скилла, 1 - норм, 0.75 - скилл на 1 уровень ниже, 0.5 - скилл на 2 уровня ниже
		public var units:Array;
		public var ct:ColorTransform= new ColorTransform(1,1,1,1,0,100,0,0);
		var fGlow:GlowFilter=new GlowFilter(0xFF0000,1,3,3,4,1);
		var fShad:GlowFilter=new GlowFilter(0x000000,1,3,3,3,1);
		
		public var od:Number=80;	//реальные од
		public var odv:Number=80;	//виртуальные од
		public var odd:Number=0.1;
		public var limOd:Number=200;
		//var format1:TextFormat;
		
		public function Sats(nvis:MovieClip) {
			vis=nvis;
			vis.visible=false;
			trasser=new MovieClip();
			//bmp=new BitmapData(1920,1080);
			//allvis=new Bitmap(bmp);
			radius=new satsRadius();
			//vis.addChild(allvis);
			vis.addChild(trasser);
			vis.addChild(radius);
			que=new Array();
			units=new Array();
		}

		//Показать/скрыть
		public function onoff(turn:int=0) {
			if (turn==0) active=!active;
			else if (turn>0) active=true;
			else active=false;
			if (active) {
				if (World.w.loc.base || World.w.alicorn) {
					active=false;
					return;
				}
				gg=World.w.gg;
				weapon=gg.currentWeapon;
				if (weapon==null) {
					World.w.gui.infoText('noSats');
					active=false;
				} else {
					if (weapon.noSats) {
						World.w.gui.infoText('noSats');
						active=false;
					} else {
						var st=weapon.status();
						if (st==4) {
							World.w.gui.infoText('noAmmo','');
							active=false;
						}
						if (st==5) {
							World.w.gui.infoText('brokenWeapon','');
							active=false;
						}
						if (st==6) {
							World.w.gui.infoText('noMana','');
							active=false;
						}
					}
				}
			}
			if (active) {
				if (weapon.tip>1) {
					trasser.visible=true;
					trass();
				} else {
					trasser.visible=false;
					radius.visible=true;
					radius.x=gg.X+gg.pers.meleeS*gg.storona;
					radius.y=gg.Y-gg.scY/2;
					radius.scaleX=radius.scaleY=gg.pers.meleeR/100;
				}
				skillConf=1;
				if (World.w.weaponsLevelsOff) {
					var razn=weapon.lvl-gg.pers.getWeapLevel(weapon.skill);
					if (razn==1) skillConf=0.8;
					else if (razn==2) skillConf=0.6;
					else if (razn>2) {
						skillConf=0;
						World.w.gui.infoText('weaponSkillLevel');
						active=false;
						return;
					}
				}
				if (que.length>0) clearAll();
				World.w.grafon.drawSats();
				World.w.grafon.onSats(true);
				//World.w.grafon.visSats.x=10;
				getUnits();
				World.w.gui.offCelObj();
				odv=od;
				World.w.gui.setOd();
				World.w.swfStage.addEventListener(MouseEvent.MOUSE_MOVE,mMove);
				World.w.gui.setTopText('infosats');
			} else {
				World.w.grafon.onSats(false);
				offUnits();
				World.w.swfStage.removeEventListener(MouseEvent.MOUSE_MOVE,mMove);
				World.w.ctr.clearAll();
				World.w.gui.setTopText('');
			}
			vis.visible=active; //World.w.grafon.visObjs[5].visible=
			World.w.gui.setSats(active);
		}
		
		//когда на паузе
		public function step() {
			if (active) {
				if (World.w.ctr.keyAttack) {
					setCel();
					World.w.ctr.keyAttack=false;
				}
				if (World.w.ctr.keyTele) {
					unsetCel();
					World.w.ctr.keyTele=false;
				}
				if (World.w.ctr.keyAction) {
					onoff(-1);
					World.w.ctr.keyAction=false;
				}
			}
		}
		
		//когда не на паузе
		public function step2() {
			if (que.length>0 && World.w.ctr.keyAttack) clearAll();
			if (que.length>0 && weapon.satsCons*weapon.consMult*weapon.consMult/skillConf*gg.pers.satsMult/weapon.satsQue>od) {
				World.w.gui.infoText('noOd');
				clearAll();
			}
			if (que.length==0 && od<gg.pers.maxOd) {
				od+=odd;
				odv=od;
				World.w.gui.setOd();
			}
		}
		
		public function clearAll() {
			var n=que.length;
			for (var i=0; i<n; i++) {
				var cel:SatsCel=que.shift();
				cel.remove();
			}
			odv=od;
			World.w.gui.setOd();
			//trace('cl all');
		}
		
		public function setCel() {
			if (weapon.satsCons*weapon.consMult/skillConf*gg.pers.satsMult>odv) {
				World.w.gui.infoText('noOd');
				return;
			}
			var cel:SatsCel;
			if (units.length) {
				for each (var obj in units) {
					//trace (obj.du.filters);
					if (obj.du.filters.length>0) {
						cel=new SatsCel(obj,0,0,weapon.satsCons*weapon.consMult/skillConf*gg.pers.satsMult,weapon.satsQue);
						break;
					}
				}
			}
			if (cel==null) cel=new SatsCel(null, World.w.celX,World.w.celY,weapon.satsCons*weapon.consMult/skillConf*gg.pers.satsMult,weapon.satsQue);
			//if (cel.un!=null) trace ('set '+cel.un.u);
			//else trace ('set *');
			weapon.ready=false;
			odv-=weapon.satsCons*weapon.consMult/skillConf*gg.pers.satsMult;
			World.w.gui.setOd();
			que.push(cel);
		}
		public function unsetCel(q:Boolean=false) {
			if (que.length==0) {
				onoff(-1);
				return;
			}
			var cel:SatsCel;
			if (q) cel=que.shift();
			else cel=que.pop();
			if (cel.un) cel.un.n--;
			cel.remove();
			//if (cel.un!=null) trace ('unset '+cel.un.u);
			//else trace ('unset *');
			odv+=weapon.satsCons*weapon.consMult/skillConf*gg.pers.satsMult;
			if (que.length==0) {
				onoff(-1);
				odv=od;
			}
			World.w.gui.setOd();
		}
		
		public function getReady():Boolean {
			if (que.length>0 && (que[0].un==null || que[0].begined || que[0].un.u.sost<3)) return true;
			else return false;
		}
		
		//действие выполнено
		public function act() {
			od-=que[0].cons;
			World.w.gui.setOd();
			if (que[0].kol>1 && weapon.status()<=1) {
				que[0].kol--;
				que[0].begined=true;
			} else {
				var cel:SatsCel=que.shift();
				cel.remove();
			}
		}
		
		public function getPrec(un:Unit):Number {
			var prec:Number=1;
			var sk=gg.pers.weaponSkills[weapon.skill];
			var dx=weapon.X-un.X;
			var dy=weapon.Y-un.Y;
			var rasst=Math.sqrt(dx*dx+dy*dy);
			if (weapon.precision>0) {
				prec=weapon.resultPrec(1,sk)/rasst/(un.dexter+0.1)*skillConf;
			}
			if (weapon.antiprec>0 && rasst<weapon.antiprec) {
				prec=(rasst/weapon.antiprec*0.75+0.25)/(un.dexter+0.1)*skillConf;
			}
			if (weapon.deviation>0 || gg.mazil>0) {
				var ug1=Math.atan2(un.scY,rasst)*180/Math.PI;
				var ug2=(weapon.deviation/(sk+0.01)+gg.mazil);
				if (ug2>ug1) prec=prec*ug1/ug2;
				//trace (ug1,ug2);
			}
			if (prec>0.95) prec=0.95;
			if (prec>skillConf) prec=skillConf;
			return prec;
		}
		
		public function drawUnit(un:Unit):MovieClip {
			var satsBmp:BitmapData=new BitmapData(un.vis.width,un.vis.height,true,0);
			var m:Matrix=new Matrix();
			var rect:Rectangle=un.vis.getBounds(un.vis);
			m.tx=-rect.left, m.ty=-rect.top;
			var hpoff:Boolean=false;
			if (un.hpbar && un.hpbar.visible) hpoff=true;
			if (hpoff) un.hpbar.visible=false;
			satsBmp.draw(un.vis,m,ct);
			if (hpoff) un.hpbar.visible=true;
			
			var mc:MovieClip=new MovieClip();
			mc.scaleX=un.vis.scaleX, mc.scaleY=un.vis.scaleY, mc.rotation=un.vis.rotation;
			var bm:Bitmap=new Bitmap(satsBmp);
			mc.addChild(bm);
			bm.x=rect.left, bm.y=rect.top;
			
			mc.addEventListener(MouseEvent.MOUSE_OVER,mOver);
			mc.addEventListener(MouseEvent.MOUSE_OUT,mOut);
			return mc;
		}
		
		public function mOver(event:MouseEvent):void {
			if (active && !weapon.noPerc) (event.currentTarget as MovieClip).filters=[fGlow];
			try {
				var su:TextField=(event.currentTarget.parent as MovieClip).getChildAt(1)['info'];
				su.visible=true;
			} catch(err){}
		}
		public function mOut(event:MouseEvent):void {
			if (active && !weapon.noPerc) (event.currentTarget as MovieClip).filters=[];
			try {
				var su:TextField=(event.currentTarget.parent as MovieClip).getChildAt(1)['info'];
				su.visible=false;
			} catch(err){}
		}
		
		public function offUnits() {
			if (units && units.length) {
				for each (var obj in units) {
					try {
						vis.removeChild(obj.v);
						obj.v.removeEventListener(MouseEvent.MOUSE_OVER,mOver);
						obj.v.removeEventListener(MouseEvent.MOUSE_OUT,mOut);
					} catch (err) {
						
					}
				}
			}
			units=new Array();
			for each (obj in que) {
				obj.vis.visible=false;
			}
		}
		
		public function getUnits() {
			for each (var un:Unit in World.w.loc.units) {
				if (!gg.isMeet(un) || !un.isSats || un.sost>=3 || un.invis) continue;
				if (weapon.satsMelee) {
					if (gg.look(un,false,0,gg.pers.meleeR*1.2+100)<=0) continue;
				} else 
				if (gg.look(un)<=0 || !un.getTileVisi()) continue;
				var mc:MovieClip=new MovieClip();
				mc.x=un.vis.x, mc.y=un.vis.y;
				vis.addChild(mc);
				var du:MovieClip=drawUnit(un);
				var su:MovieClip=new satsUnit();
				su.filters=[fShad];
				su.scaleX=su.scaleY=1/World.w.cam.scaleV;
				var txt:TextField=su.txt;
				var info:TextField=su.info;
				txt.y=3;
				txt.autoSize=TextFieldAutoSize.CENTER;;
				if (!weapon.noPerc) var prec:Number=getPrec(un);
				txt.text=un.nazv;
				txt.selectable=false;
				if (!weapon.noPerc) txt.text+='\n'+Math.round(prec*100)+'%';
				
				info.autoSize=TextFieldAutoSize.CENTER;
				info.selectable=false;				
				info.visible=false;
				info.text='';
				
				//расширенная информация о враге
				if (World.w.pers && World.w.pers.modAnalis) {
					info.text+='\n'+Res.pipText('level')+': '+(un.level+1);
					info.text+='\n'+Res.pipText('hp')+': '+Math.ceil(un.hp)+'/'+Math.ceil(un.maxhp);
					if (un.skin>0) info.text+='\n'+Res.pipText('skin')+': '+Math.ceil(un.skin);
					if (un.armor_qual>0 && un.armor>0) info.text+='\n'+Res.pipText('armor')+': '+Math.ceil(un.armor+un.skin)+' ('+Math.round(un.armor_qual*100)+'%)';
					if (un.armor_qual>0 && un.marmor>0) info.text+='\n'+Res.pipText('marmor')+': '+Math.ceil(un.marmor+un.skin)+' ('+Math.round(un.armor_qual*100)+'%)';
					if (mc.y<150) info.y=50;
					else info.y=-un.scY-info.textHeight-20;
				}
				su.name='su';
				mc.addChild(du);
				mc.addChild(su);
				units.push({u:un, v:mc, du:du, p:prec, n:0});
			}
		}
		
		public function mMove(event:MouseEvent):void {
			//trace(World.w.celX, World.w.celY);
			trass();
		}
		
		public function trass() {
			if (weapon.noTrass) return;
			weapon.setTrass(trasser.graphics);
			if (weapon.explRadius) {
				radius.visible=true;
				radius.scaleX=radius.scaleY=weapon.explRadius/100;
				radius.cacheAsBitmap=true;
				radius.x=weapon.trasser.X;
				radius.y=weapon.trasser.Y;
			} else {
				radius.visible=false;
			}
		}
	}
	
}

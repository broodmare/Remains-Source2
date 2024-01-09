package fe.unit {
	import flash.filters.GlowFilter;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.geom.ColorTransform;
	
	import fe.weapon.*;
	import fe.*;
	import fe.loc.Location;
	import fe.serv.LootGen;
	import fe.graph.Emitter;
	
	public class UnitThunderHead extends Unit{
		
		public var controlOn:Boolean=true;
		var spd:Object;
		var dopWeapon:Weapon;
		var thWeapon:Weapon;
		var shitMaxHp:Number=500;
		var visshit:MovieClip;
		
		var emit_t:int=120;
		
		var moveX:Number=0, moveY:Number=0;
		var t_atk:int=100;
		var t_shit:int=300;
		var kolth:int=0;
		var speedBonus:Number=1;
		var t_doptest=20;
		
		var limX:int=1920*3;
		var limY:int=3000;
		
		var moln1_x=500;
		var moln2_x=1700;
		var moln_y=666;
		var t_moln:int=100;
		var moln1:MovieClip, moln2:MovieClip;
		
		var turrets:Array;
		public var attTur:int=0;
		public var reloadDiv:Number=1;
		var isAtt:Boolean=false;
		
		var kol_emit:int=5, max_emit:int=15;
		
		var p=new Object();
		var vsosOn=false;
		var t_die:int=0;
		var t_vsos:int=800, vsos_max:int=450, vsos_porog:int=120, vsos_force:Number=3;
		var dieTransform:ColorTransform = new ColorTransform();

		public function UnitThunderHead(cid:String=null, ndif:Number=100, xml:XML=null, loadObj:Object=null) {
			super(cid, ndif, xml, loadObj);
			id='thunderhead';
			
			//взять параметры из xml
			blitData=World.w.grafon.getSpriteList('sprThunderHead');
			vis=new MovieClip();
			var osn:Sprite=new Sprite();
			visBmp=new Bitmap(blitData);
			vis.addChild(osn);
			osn.addChild(visBmp);
			osn.scaleX=osn.scaleY=3;
			osn.x=-osn.width/2;
			osn.y=-osn.height/2;
			
			//500, 666, 1700;
			
			moln1=new ThunderHeadMoln();
			moln2=new ThunderHeadMoln();
			
			moln1.blendMode=moln2.blendMode='screen';
			moln1.alpha=moln2.alpha=0;
			moln1.x=moln1_x;
			moln2.x=moln2_x;
			moln1.y=moln2.y=moln_y;
			moln2.stop();
			moln1.stop();
			osn.addChild(moln1);
			osn.addChild(moln2);
			
			
			getXmlParam();
			accel=3;
			walkSpeed=maxSpeed;
			boss=true;
			isFly=true;
			noDestr=true;
			undodge=1;
			dexter=0;
			mat=10;
			vulner[D_BALE]=0.7;
			vulner[D_NECRO]=0.8;
			vulner[D_ASTRO]=0.8;
			vulner[D_FRIEND]=0.8;
			
			mater=false;
			collisionTip=0;
			dopTestOn=true;
			friendlyExpl=0;
			
			turrets=new Array();
			
			spd=new Object();
			
			aiTCh=150;
			aiState=0;
			sloy=1;
		}
		
		
		public override function putLoc(nloc:Location, nx:Number, ny:Number) {
			super.putLoc(nloc,nx,ny);
			createTurret(1,-850,-340,0);
			createTurret(1,-770,-340,0);
			createTurret(1,-690,-340,0);
			createTurret(2,-610,-340,0, true);
			createTurret(2,-530,-340,0);
			
			createTurret(3,370,-336,0);
			createTurret(3,420,-336,0);
			createTurret(3,470,-336,0);
			createTurret(3,520,-336,0);
			
			createTurret(4,750,-173,0);
			createTurret(4,820,-173,0);
			createTurret(4,890,-173,0, true);
			
			createTurret(5,585,-17,0);
			createTurret(5,-585,-17,0, true);

			createTurret(6,710,-17,0);
			createTurret(6,770,-17,0, true);
			
			createTurret(1,420,402,2);
			createTurret(1,500,402,2);
			createTurret(2,580,402,2);
			createTurret(2,660,402,2);
			createTurret(2,740,402,2);
			
			createTurret(3,-110,304,2, true);
			createTurret(3,-60,304,2);
			createTurret(4,-10,304,2);
			createTurret(4,40,304,2);
			createTurret(5,90,304,2);
			
			createTurret(5,-470,470,2);
			createTurret(6,-420,470,2);
			createTurret(6,-370,470,2);
			
			setUgolPos();
		}
		
		public override function setNull(f:Boolean=false) {
			if (sost==1) {
				if (dopWeapon) dopWeapon.setNull();
			}
			super.setNull(f);
		}

		function createTurret(n:int,bindX:Number, bindY:Number, rot:int=0, mega:Boolean=false) {
			var un:Unit=loc.createUnit('ttur',0,0,true,null,n.toString());
			(un as UnitThunderTurret).head=this;
			(un as UnitThunderTurret).bindX=bindX*3;
			(un as UnitThunderTurret).bindY=bindY*3;
			un.fraction=fraction;
			un.vis.osn.korp.rotation=rot*90;
			if (mega) (un as UnitThunderTurret).mega();
			turrets.push(un);
		}
		
		public function dieTurret() {
			reloadDiv+=0.1;
		}
		
		public override function setVisPos() {
			if (vis) {
				vis.x=X,vis.y=Y;
			}
		}
		
		public override function run(div:int=1) {
			/*X+=dx/div;
			Y+=dy/div;*/
			X1=X-scX/2+300*3, X2=X1+1370*3;
			Y1=Y-scY/2+170*3, Y2=Y1+580*3;
		}
		
		/*public override function forces() {
			if (dx>maxSpeed) dx=maxSpeed;
			if (dx<-maxSpeed) dx=-maxSpeed;
			if (dy>maxSpeed) dy=maxSpeed;
			if (dy<-maxSpeed) dy=-maxSpeed;
		}*/
		
		function setUgolPos() {
			var def:Number=Math.sin(ugol/45*Math.PI);
			var dif:Number=Math.sin(ugol/90*Math.PI);
			var ugol2:Number=-def*12+ugol;
			var distanc2:Number=distanc+dif*dif*dif*dif*1000;
			X=limX/2+Math.sin(ugol2/180*Math.PI)*distanc2;
			Y=limY/2+Math.cos(ugol2/180*Math.PI)*distanc2/1.6;
			for each (var un:Unit in turrets) {
				un.run();
			}
		}
		
		public override function setLevel(nlevel:int=0) {
			if (World.w.game.globalDif==3) {
				kol_emit=3;
				max_emit=18;
				hp=maxhp=hp*1.1;
			}
			if (World.w.game.globalDif==4) {
				kol_emit=1;
				max_emit=21;
				hp=maxhp=hp*1.2;
			}
		}
		
		public override function dopTest(bul:Bullet):Boolean {
			if (bul.targetObj==this) return true;
			t_doptest--;
			if (t_doptest>0) return false;
			t_doptest=Math.floor(Math.random()*30+10);
			return true;
		}

		
		//aiState
		//0 - стоит на месте
		//1 - движется
		//2 - в фазе атаки
		
		var movePoints=[{x:6000, y:1500}, {x:3000, y:0},{x:0, y:1500},{x:3000, y:3000}];
		var mp=0;
		
		var moveTime=180;
		
		var ugol:Number=90;
		var distanc:Number=6000;
		
		
		public override function control() {
			if (vsosOn) vsos();
			if (sost==3) return;
			if (sost>1) {
				dx=0;
				dy=0;
				isAtt=false;
				return;
			}
			
			if (aiTCh>0) aiTCh--;
			else {
				aiState++;
				if (aiState>3) {
					aiState=1;
				}
				if (aiState==1) {	//выбор точки перемещения
					aiTCh=moveTime;
				} else if (aiState==2) {
					aiTCh=30;
				} else if (aiState==3) {
					aiTCh=100;
				}
			}
			if (aiTCh%10==1) {
				setCel(loc.gg);
			}
			attTur--;
			celDX=celX-X;
			celDY=celY-Y;
			var dist2:Number=celDX*celDX+celDY*celDY;
			var dist:Number=(moveX-X)*(moveX-X)+(moveY-Y)*(moveY-Y);
			//поведение при различных состояниях
			if (aiState==0) {
				if (aiTCh>20) distanc-=20;
				else distanc-=aiTCh;
				isAtt=false;
			} else if (aiState==1) {
				ugol+=90/moveTime;
				if (ugol>=360) ugol-=360;
				isAtt=true;
			} else if (aiState>=2) {
				dx*=0.7, dy*=0.7;
				if (dx<5 && dx>-5) dx=0;
				if (dy<5 && dy>-5) dy=0;
				isAtt=true;
			}
			//всос
			t_vsos--;
			if (t_vsos<vsos_porog)	{
				vsos (vsos_force, true);
			} else if (hp<maxhp/5) {
				vsos(1);
			} else if (hp<maxhp/2) {
				vsos(0.5);
			}
			if (t_vsos<0) t_vsos=vsos_max;
			//миньоны
			if ((maxhp-hp)/maxhp*max_emit>kol_emit) emit();
			setUgolPos();
			//attack();
		}
		
		
		public override function animate() {
			if (sost>1 && t_die<150) {
				t_die++;
				vzdrzhne(t_die)
			}
			t_moln--;
			if (t_moln<=0) {
				t_moln=Math.floor(Math.random()*20+10);
				if (Math.random()<0.5) {
					moln1.alpha=1;
					moln1.x=moln1_x+Math.random()*300-150;
					moln1.y=moln_y+Math.random()*30-15;
					moln1.rotation=Math.random()*360;
					moln1.scaleX=moln1.scaleY=Math.random()*0.3+0.7;
					moln1.gotoAndStop(Math.floor(Math.random()*3+1));
				} else {
					moln2.alpha=1;
					moln2.x=moln2_x+Math.random()*300-150;
					moln2.y=moln_y+Math.random()*30-15;
					moln2.rotation=Math.random()*360;
					moln2.scaleX=moln2.scaleY=Math.random()*0.3+0.7;
					moln2.gotoAndStop(Math.floor(Math.random()*3+1));
				}
			}
			if (moln1.alpha>0) {
				moln1.alpha-=Math.random()*0.2-0.03;
			}
			if (moln2.alpha>0) {
				moln2.alpha-=Math.random()*0.2-0.03;
			}
		}
		
		public override function makeNoise(n:int, hlup:Boolean=false) {}
		
		public override function command(com:String, val:String=null) {
			if (com=='off') {
				walk=0;
				controlOn=false;
			} else if (com=='on') {
				controlOn=true;
			}
			if (com=='vsos') {
				vsosOn=true;
			}
		}
		
		function emit() {
			var nx:Number=X;
			var ny:Number=Y;
			if (nx<200) nx=200;
			if (nx>loc.limX-200) nx=loc.limX-200;
			if (ny<200) ny=200;
			if (ny>loc.limY-200) ny=loc.limY-200;
			var un:Unit=loc.createUnit('dron',nx,ny,true,null,'100');
			un.fraction=fraction;
			un.inter.cont='';
			un.mother=this;
			un.sndMusic=null;
			un.oduplenie=0;
			kol_emit++;
		}
		
		public function vzdrzhne(n:Number=0) {
			if (n>10) n=10-n/10;
			dieTransform.redMultiplier=1+n/15;
			dieTransform.greenOffset=1+n/10;
			dieTransform.blueOffset=1+n/5;
			vis.transform.colorTransform=dieTransform;
		}
		
		public function vsos(n:Number=0, klob:Boolean=false) {
			if (!loc.active) return;
			p.x=X-World.w.gg.X;
			p.y=Y-World.w.gg.Y;
			if (n==0) {
				norma(p,5);
				World.w.gg.storona=(World.w.gg.dx>0)?1:-1;
			} else {
				norma(p,n);
			}
			if (klob && t_vsos%3==0) Emitter.emit('vsos',loc,World.w.gg.X,World.w.gg.Y-40,{dx:(p.x*12+Math.random()*4-2), dy:(p.y*12+Math.random()*4-2), scale:6});
			World.w.gg.dx+=p.x;
			World.w.gg.dy+=p.y;
		}
		
	}
}

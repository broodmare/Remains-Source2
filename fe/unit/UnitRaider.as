package fe.unit {
	import flash.filters.GlowFilter;
	import flash.display.MovieClip;
	
	import fe.weapon.*;
	import fe.*;
	import fe.loc.Tile;
	import fe.serv.BlitAnim;
	import fe.serv.LootGen;
	
	public class UnitRaider extends UnitPon{
		
		protected var animFrame:int=0;
		public var parentId:String;
		public var kolTrs:int=0;		//количество разновидностей
		public var tr:int=1;
		var weap:String;
		private	var headArr:Array;
		public var walker:Boolean=false;	//имеет анимацию ходьбы
		public var mostLaz:Boolean=true;	//залезает по лестницам
		public var flyer:Boolean;		//летает
		public var sniper:Boolean;		//стреляет только если видит цель
		public var fearGrenade:Boolean=true;//убегает от гранат
		public var stroll:Boolean=true;		//патрулирует в спокойном состоянии
		public var moving:Boolean=true;		//двигается
		public var quiet:Boolean=false;		//молчит
		public var allLink:Boolean=false;	//одупляются все разом
		public var kol_emit:int=0;
		public var grenader:int=0;			//имеет гранаты
		public var isDropArm:Boolean=true;	//роняет оружие
		public var enclWeap:Boolean=false;	//имеет оружие анклава
		public var wPos:Array;
		public var tupizna:int=40;		//сколько времени тупит
		public var durak:Boolean=true;	//бегает как идиот
		public var dash:Boolean=false;	//выполняет атаку рывком
		public var scrAlarmOn:Boolean=true;
		public var controlOn:Boolean=true;
		var visionMult:Number=1;
		var baseDexter:Number=1;
		
		public var dropW:String;
		public var dropWeapon:Weapon;

		var spd:Object;
		var floatX:Number=1, floatY:Number=0;
		
		
		public function UnitRaider(cid:String=null, ndif:Number=100, xml:XML=null, loadObj:Object=null) {
			super(cid, ndif, xml, loadObj);
			//определить разновидность tr
			if (parentId==null) parentId='raider';
			if (kolTrs==0) kolTrs=9;
			if (cid) {						//из заданного идентификатора cid
				tr=int(cid);
			} else {									//случайно по параметру ndif
				tr=Math.floor(Math.random()*kolTrs+1);
			}
			if (loadObj && loadObj.tr) {			//из загружаемого объекта
				tr=loadObj.tr;
				//if (tr>kolTrs) tr=1;
			} else if (xml && xml.@tr.length()) {	//из настроек карты
				tr=xml.@tr;
			} 
			if (!(tr>0)) tr=1;
			//if (tr<20) id='raider'+tr;
			//else id='slaver'+(tr-20);
			id=parentId+tr;
			
			//взять параметры из xml
			getXmlParam();
			walkSpeed=maxSpeed;
			if (walker) walkSpeed=2.5;
			plavSpeed=maxSpeed;
			sitSpeed=maxSpeed*0.5;
			lazSpeed=maxSpeed*1.1;
			runSpeed=maxSpeed*2;
			plavdy=accel;
			baseDexter=dexter;
			
			//дать оружие
			if (loadObj && loadObj.weap) {
				if (loadObj.weap!='') currentWeapon=Weapon.create(this,loadObj.weap);
			} else if (xml && xml.@weap.length()) {
				if (xml.@weap!='') currentWeapon=Weapon.create(this,xml.@weap);
			} else currentWeapon=getXmlWeapon(ndif);
			if (currentWeapon) {
				weap=currentWeapon.id;
				if (currentWeapon.variant>0) weap+='^'+currentWeapon.variant;
			} else weap='';
			if (currentWeapon) {
				childObjs=new Array(currentWeapon);
				currentWeapon.hold=currentWeapon.holder;
				if (currentWeapon.antiprec>0) currentWeapon.damage*=0.8;
			}
			
			if (xml && xml.@emit.length()) {
				kol_emit=xml.@emit;
			}
			if (xml && xml.@nodrop.length()) {
				isDropArm=false;
			}
			if (dropW!=null) {
				dropWeapon=Weapon.create(this,dropW);
				dropWeapon.vis.visible=false;
				dropWeapon.vis.alpha=0;
				childObjs.push(dropWeapon);
			}
			
			if (currentWeapon && currentWeapon.holder>10 && aiAttackOch==0) aiAttackOch=Math.round(currentWeapon.holder/2);
			
			initBlit();
			animState='stay';
			if (teleColor) teleFilter=new GlowFilter(teleColor,1,6,6,1,3);
			
			if (aiTip=='stay') stroll=false;
			if (aiTip=='quiet') {
				stroll=false;
				quiet=true;
			}
			if (aiTip=='sniper') {
				stroll=false;
				moving=false;
				weaponSkill=2;
			}
			if (xml && xml.@fraction.length()) {
				fraction=xml.@fraction;
				if (fraction==F_PLAYER) warn=0;
			}

			weaponLevit();
			headArr=[{x:100,y:100,r:10}];
			aiNapr=storona;
			
			if (!currentWeapon || currentWeapon.tip<=1 && weaponKrep==1) attackerType=0;		//атака корпусом
			else if (currentWeapon.tip==1 && weaponKrep==0) attackerType=1;						//атака холодным оружием 
			else if (currentWeapon.tip==4) attackerType=3;										//гранаты
			else attackerType=2;//пальба
			
			if (attackerType<=0) stalkDist=0;
			
			//sndMusic='combat_1';
			//sndMusicPrior=1;
			acidDey=0.5;
			spd=new Object();
			tstor=storona;

			if (msex) wPos=BlitAnim.wPosRaider1;
			else wPos=BlitAnim.wPosRaider2;
			
			if (!msex) id_name+='_f';
			
			if (sndDie=='rm' && !msex) sndDie='rw';
		}
		
		public override function getXmlParam(mid:String=null) {
			super.getXmlParam(parentId);
			super.getXmlParam();
			var node0:XML=AllData.d.unit.(@id==id)[0];
			if (node0.vis.length()) {
				if (node0.vis.@telecolor.length()) teleColor=node0.vis.@telecolor;
			}

			if (node0.un.length()) {
				if (node0.un.@flyer.length()) {
					flyer=true;
					mostLaz=false;
				}
				if (node0.un.@och.length()) aiAttackOch=node0.un.@och;		//стрельба очередью
				if (node0.un.@dist.length()) aiDist=node0.un.@dist;		//минимальная дистанция
				if (node0.un.@stalk.length()) stalkDist=node0.un.@stalk;		//дистанция преследования в полёте
				if (node0.un.@walker.length()) walker=true;
				if (node0.un.@sniper.length()) sniper=true;
				if (node0.un.@gren.length()) fearGrenade=false;
				if (node0.un.@grenader.length()) grenader=node0.un.@grenader;
				if (node0.un.@drop.length()) dropW=node0.un.@drop;
				if (node0.un.@stay.length()) stroll=false;
				if (node0.un.@enclweap.length()) enclWeap=true;
			}
		}
		
		//сделать героем
		public override function setHero(nhero:int=1) {
			super.setHero(nhero);
			if (hero==1) {
				if (currentWeapon && currentWeapon.uniq>0 && isrnd(currentWeapon.uniq/2)) {
					currentWeapon.updVariant(1);
					//currentWeapon.damage*=1.2;
				}
			}
		}

		public override function save():Object {
			var obj:Object=super.save();
			if (obj==null) obj=new Object();
			obj.tr=tr;
			obj.weap=weap;
			return obj;
		}	
		
		public override function setWeaponPos(tip:int=0) {
			super.setWeaponPos(tip);
			if (!enclWeap && (tip==1 || tip==2 || tip==4)) {
				var obj:Object=wPos[anims[animState].id][Math.floor(anims[animState].f)];
				weaponX=X+(obj.x+visBmp.x)*storona;
				weaponY=Y+obj.y+visBmp.y;
				weaponR=obj.r;
			}
		}
		
		/*public override function setVisPos() {
			super.setVisPos();
			if (currentWeapon) currentWeapon.
		}*/

		
		public override function animate() {
			var cframe:int;
			//поворот
			if (sost==2 || sost==3) { //сдох
				if (stay) {
					if (animState=='fall') {
					} else if (animState=='death') animState='fall';
					else animState='die';
				} else animState='death';
			} else {
				if (stay) {
					if  (dx==0 || aiState==7) {
						animState='stay';
					//} else if (flyer) {
						//animState='walk';
						//sndStep(anims[animState].f,1);
					} else if (attackerType==0 && aiAttack || aiState==8) {
						animState='run';
						sndStep(anims[animState].f,2);
					} else if (walker && (aiState<=1 || aiState==4)) {
						animState='walk';
						sndStep(anims[animState].f,1);
					} else {
						animState='trot';
						sndStep(anims[animState].f,1);
					}
				} else if (flyer) {
					if  (isFly) animState='derg';
					else animState='stay';
				} else if (levit) {
					animState='derg';
				} else if (isLaz && mostLaz) {
					animState='laz';
					sndStep(anims[animState].f,3);
				} else if (aiPlav) {
					animState='plav';
				} else {
					animState='jump';
					anims[animState].setStab((dy*0.6+8)/16);
				}
			}
			if (animState!=animState2) {
				anims[animState].restart();
				animState2=animState;
			}
			if (!anims[animState].st) {
				blit(anims[animState].id,anims[animState].f);
			}
			anims[animState].step();
		}
		
		
		public override function alarma(nx:Number=-1,ny:Number=-1) {
			if (sost==1 && aiState<=1) {
				super.alarma(nx,ny);
				aiSpok=maxSpok+10;
				aiState=3;
				shok=Math.floor(Math.random()*15+5);
				areaTestTip='raider';
				if (!plusObservOk) {
					observ+=plusObserv;
					plusObservOk=true;
					//trace('observ ', observ)
				}
			}
		}
		
		public override function dropLoot() {
			super.dropLoot();
			if (currentWeapon) {
				if (currentWeapon.vis) currentWeapon.vis.visible=false;
				if (isDropArm) {
					var cid:String=currentWeapon.id;
					if (currentWeapon.variant>0) cid+='^'+currentWeapon.variant;
					LootGen.lootId(loc,currentWeapon.X,currentWeapon.Y,cid,0);
				}
			}
			if (attackerType==3) {
				for (var i=0; i<3; i++) {
					setCel(null,X+Math.random()*30-15,Y-Math.random()*15);
					currentWeapon.attack();
				}
			}
			if (dropWeapon) {
				setCel(null,X+Math.random()*30-15,Y-Math.random()*15);
				dropWeapon.attack();
			}
			//if (hero>0 && Math.random()<0.95) LootGen.lootId(loc,currentWeapon.X,currentWeapon.Y,'s_rollup',0);
		}

		function emit() {
			var un:Unit=loc.createUnit('vortex',X,Y-scY/2,true);
			un.fraction=fraction;
			un.oduplenie=0;
			emit_t=300;
			kol_emit--;
		}
		
		public override function actions() {
			super.actions();
			if (aiPlav>0) aiPlav--;
			if (isPlav) aiPlav=10;
			rasst=Math.sqrt(rasst2);
			volMinus=rasst/8000;
		}
		
		public override function setNull(f:Boolean=false) {
			super.setNull(f);
			if (f) aiState=aiSpok=0;
		}
		
		public function jump(v:Number=1) {
			aiJump=Math.floor(30+Math.random()*50);
			if (stay || isLaz) {		//прыжок
				dy=-jumpdy*v;
				isLaz=0;
			}
			if (stay) {
				if (aiNapr==-1) dx*=0.8;
				else dx+=storona*accel*2;
			}
			if (!isPlav&&aiPlav) dy=-jumpdy*0.6;	//выпрыгивание из воды
			if (isPlav) {
				dy-=plavdy;
			}
		}
		
		//проверка возможности прыжка
		function checkJump():Boolean {
			if (loc.getAbsTile(X,Y-85).phis!=0) return false;
			if (loc.getAbsTile(X,Y-125).phis!=0) return false;
			if (loc.getAbsTile(X+40*storona,Y-85).phis!=0) return false;
			if (loc.getAbsTile(X+40*storona,Y-125).phis!=0) return false;
			return true;
		}
		
		var aiLaz:int=0, aiJump:int=0;	
		var aiAttack:int=0, attackerType:int=0;	//0-без оружия, 1-хол.оруж., 2-пальба
		var aiAttackT:int=0, aiAttackOch:int=0;	//стрельба очередью
		var aiDist:int=1000; //минимальная дистанция
		var stalkDist:int=500;	//дистанция преследования в полёте
		var aiVKurse:Boolean=false;
		var celUnit2:Unit, t_chCel:int=0;
		var emit_t:int=0;
		var t_laz:int=0;	//прошло времени с начала лазения
		var r_laz:int=0;	//изменений направления лазения
		var t_landing:int=0, t_float:Number=Math.random(), t_fall:int=0, t_turn:int=0;
		var tstor:int=1;
		var plusObservOk:Boolean=false;
		var plusObserv:int=0;
		
		//aiState
		//0 - стоит на месте
		//1 - ходит туда-сюда
		//2 - не видит цели, бегает и ищет цель
		//3 - видит цель, бегает, атакует
		//4 - стоит на месте и стреляет
		//5 - увидел цель, тупит какое-то время
		//6 - сматывается
		//7 - готовится атаковать рывком
		//8 - атакует быстрым рывком
		
		public override function control() {
			//trace(hpbar);
			//if (hpbar) trace(hpbar.visible, hpbar.x, hpbar.y);
		
			var t:Tile;
			//World.w.gui.vis.vfc.text=(celUnit==null)?'no':(celUnit.nazv+celDY);
			//если сдох, то не двигаться
			if (sost==3) return;
			if (levit) {
				if (aiState<=1) {
					shok=45;
					aiState=3;
					budilo();
				}
				replic('levit');
			}
			if (stun) {
				aiState=0; aiTCh=3; walk=0;
			}
			
			t_replic--;
			if (emit_t>0) emit_t--;
			var jmp:Number=0;
			//return;
			
			//разворот
			if (storona!=tstor && t_turn<=0) {
				storona=tstor;
				if (stay) t_turn=5;
				else t_turn=30;
				if (currentWeapon && currentWeapon.drot>0) {
					currentWeapon.rot=Math.atan2(celY-currentWeapon.Y, Math.abs(celX-currentWeapon.X)*storona);
				}
			}
			if (t_turn>0) t_turn--;
			dexter=isFly?baseDexter*1.5:baseDexter
			
			if (!controlOn) return;
			if (World.w.enemyAct<=0) {
				celY=Y-scY;
				celX=X+scX*storona*2;
				return;
			}
			
			if (aiLaz>0) aiLaz--;
			if (aiJump>0) aiJump--;
			//таймер смены состояний
			if (aiTCh>0) aiTCh--;
			else if (aiState==5) {
				if (celUnit) {
					replic('attack');
					aiSpok=maxSpok+10;
					if (kol_emit>0 && emit_t<=0) emit();
					aiState=3;
					areaTestTip='raider';
				} else {
					aiState=1;
				}
			} else if (aiState==7) {
				aiState=8;
				aiTCh=35;
			} else {
				if (aiSpok==0) {
					if (aiVKurse && aiState>1) replic('vse');
					if (stroll)	aiState=Math.floor(Math.random()*2);
					else aiState=0;
					areaTestTip='';
				}
				if (aiSpok>0) aiState=2;
				if (aiSpok>=maxSpok) {
					if (aiState!=3 && aiState!=4) {
						if (allLink) budilo(2000);
						else budilo();
					}
					if (attackerType==2 && aiSpok>=maxSpok+8 && (celDX*celDX+celDY*celDY<aiDist*aiDist)) aiState=isrnd(0.3)?3:4;
					else aiState=3;
					//рывок с атакой
					//if (attackerType==0 && celUnit && celDY<40 && celDY>-10) {
					if (dash && isrnd(0.3) && celUnit) {
						aiState=7;
					}
					if (!moving) aiState=4;
					if (aiState==4) isLaz=0;
				}
				if (aiState<=1) aiTCh=Math.floor(Math.random()*50)+40;
				else if (attackerType==1 && aiState==4) aiTCh=Math.floor(Math.random()*10)+10;
				else if (aiState==7) aiTCh=20;
				else aiTCh=Math.floor(Math.random()*100)+100;
			}
			//поиск цели
			//trace(aiState)
			if (World.w.enemyAct>1 && aiTCh%10==1 && aiState!=6) {
				if (findCel()) {
					//увидели
					if (celUnit) {
						celUnit2=celUnit;
						t_chCel=6;
						if (scrAlarmOn && scrAlarm) {
							scrAlarm.start();
							scrAlarmOn=false;
							return;
						}
						if (aiState<=1) {	//увидел, удивился, тупит
							aiState=5;
							if (attackerType>=2) aiTCh=Math.floor(Math.random()*20+tupizna);
							else aiTCh=Math.floor(Math.random()*20+tupizna/4);
						} else {
							replic('attack');
							aiSpok=maxSpok+10;
							if (kol_emit>0 && emit_t<=0) emit();
						}
					
					//услышали
					} else {
						replic('ear');
						aiSpok=maxSpok-1;
					}
					if (celUnit==World.w.gg) {
						aiVKurse=true;
					}
				} else if (t_chCel>0) {
					t_chCel--;
					setCel(celUnit2);
				} else {
					if (aiSpok%5==1) setCel(null, celX+Math.random()*80-40, celY+Math.random()*80-40);
					if (aiSpok>0) {
						aiSpok--;
					}
					if (aiVKurse && aiSpok<maxSpok && aiSpok>0) {
						replic('find');
					} else if (aiSpok<15 && aiSpok>0) {
						aiSpok=0;
						if (isrnd()) replic((hp>=maxhp)?'nope':'dont');
					}
				}
			}
			//гранаты
			if (loc.warning>0 && aiTCh%10==1 && fearGrenade && isrnd(0.2)) {
				if (findGrenades()) {
					t_replic-=20;
					replic('grenade');
					aiState=6;
					aiSpok=maxSpok+10;
					aiTCh=Math.floor(Math.random()*65)+20;
					if (acelX-X>30) aiNapr=tstor=-1;
					if (acelX-X<-30) aiNapr=tstor=1;
				}
			}
			
			//поиск левитируемой мины
			if (aiTCh%30==1 && !levit && findLevit() && celUnit!=loc.gg) {
				if (loc.gg.teleObj && (loc.gg.teleObj is Mine)) {
					var gx:Number=loc.gg.teleObj.X-X;
					var gy:Number=loc.gg.teleObj.Y-Y+scY/2;
					alarma();
					if (gx*gx+gy*gy<400*400) {
						aiState=6;
						if (gx>30) aiNapr=tstor=-1;
						if (gx<-30) aiNapr=tstor=1;
					} else if (attackerType==2) {
						setCel(loc.gg.teleObj as Mine);
						aiState=4;
					} 
					aiSpok=maxSpok+10;
					aiTCh=Math.floor(Math.random()*65)+20;
				} else {
					aiSpok=8;
				}
				replic('tele');
			}
			
			//направление
			celDX=celX-X;
			if (stay) celDY=celY-Y+scY;
			if (celDY>40) {aiVNapr=1;		//вниз
			} else if(celDY<-40) {aiVNapr=-1;	//прыжок
			} else aiVNapr=0;
			if (flyer && celDY<-80) isFly=true;
			
			porog=10;
			if (moving) throu=(celDY>80);
			if (celDY>70) porog=0;
			if (isLaz==0) tstor=aiNapr;
			
			//начать полёт при падении
			if (flyer) {
				if (stay) t_fall=0;
				else {
					t_fall++;
					if (t_fall>6) isFly=true;
				}
				if (isPlav) {
					isFly=true;
				}
			}
			if (isFly) {
				t_float+=0.0512;
				floatX=Math.sin(t_float);
				floatY=Math.cos(t_float)*2;
			}
			if (isFly && aiState>1) elast=0.5;
			else elast=0;


			if (attackerType==1) {	//битьё на месте
				if (aiState==3 && celUnit && celDY<80 && celDY>-80 && Math.abs(celX-X)<(100) && Math.abs(celX-X)>(50)) aiState=4;
				if (aiState==4 && !(Math.abs(celX-X)<(100) && Math.abs(celX-X)>(50))) aiState=3;
			} 
			//в возбуждённом состоянии наблюдательность увеличивается
			if (aiSpok==0) {
				vision=1*visionMult;
				celY=Y-scY;
				celX=X+scX*storona*2;
			} else {
				vision=1.5*visionMult;
			}
			
			//поведение в воде
			if (isPlav && aiState==0) aiState=1;
			//if (isPlav && aiState==4) aiState=3;
			
			//скорость
			maxSpeed=walkSpeed;
			if (!flyer && (durak || (attackerType==0 && aiSpok>=maxSpok)) && (aiState==2 || aiState==3)) {
				maxSpeed=runSpeed;
				if (attackerType==0 && aiAttack) maxSpeed=runSpeed*1.5;
			}
			if (aiState==6) maxSpeed=runSpeed*1.5;
			if (aiState==7) maxSpeed=0;
			if (aiState==8) maxSpeed=runSpeed*2.5;
			if (dx*diagon>0) maxSpeed*=0.5;
			
			//если землепони с огн.оружием, то можно бежать задом
			if (aiState==3 && weaponKrep==1 && attackerType==2) {	
				tstor=(celDX>0)?1:-1;
				if (storona*aiNapr<0) maxSpeed=walkSpeed;
			}
			
			//поведение при различных состояниях
			if (aiState==0) {
				if (stay && shX1>0.25 && aiNapr<0) turnX=1;
				if (stay && shX2>0.25 && aiNapr>0) turnX=-1;
				if (isPlav) jump();
				if (!quiet && isrnd(0.001)) replic('neutral');
				if (dx>0.5) tstor=1; 
				if (dx<-0.5) tstor=-1;
				walk=0;
				isLaz=0;
				overLook=false;
			} if (aiState==1) {
				overLook=false;
				if (!quiet && isrnd(0.001)) replic('neutral');
				//бегаем туда-сюда
				isLaz=0;
				if (isFly) {
					//приземлиться
					if (dy<10) dy++;
					dx*=0.85;
					if (turnY<0) {
						isFly=false;
						turnY=0;
					}
				} else {
					if (moving) {
						if (aiNapr==-1) {
							if (dx>-maxSpeed) dx-=accel/3;
							walk=-1;
						} else if (aiNapr==1) {
							if (dx<maxSpeed) dx+=accel/3;
							walk=1;
						}
					}
					//поворачиваем, если впереди некуда бежать
					if (stay && shX1>0.25 && aiNapr<0) {
						if (isrnd(0.1)) {
							t=loc.getAbsTile(X+storona*80,Y+10);
							if (t.phis==1 || t.shelf) {
								jump(0.5);
							} else turnX=1;
						} else turnX=1;
					}
					if (stay && shX2>0.25 && aiNapr>0) {
						if (isrnd(0.1)) {
							t=loc.getAbsTile(X+storona*80,Y+10);
							if (t.phis==1 || t.shelf) {
								jump(0.5);
							} else turnX=-1;
						} else turnX=-1;
					}
					//если повернули, то можем остановиться
					if (stay && turnX!=0) {
						if (isrnd(0.1)) aiState=0;
						aiNapr=tstor=turnX;
						turnX=0;
					}
					//в воде всплываем
					if (isPlav) {
						jump();
						if (turnX!=0) {
							aiNapr=tstor=turnX;
							turnX=0;
						}
					}
				}
				//в возбуждённом или атакующем состоянии
			} else if (aiState==2 || aiState==3 || aiState==6 || aiState==8) {
				overLook=true;
				//определить, куда двигаться
				if (aiVNapr<0 && aiJump<=0 && aiTCh%2==1 && checkJump()) jmp=1;	
				if (aiTCh%15==1 && aiState!=6) {
					if (isrnd(durak?0.5:0.9)) {
						if (celDX>100) aiNapr=tstor=1;
						if (celDX<-100) aiNapr=tstor=-1;
					}
				}
				if (isPlav && isrnd(0.7)&& celDY<0) {
					jmp=1;
				}
				if (mostLaz && aiState<6) {
					if (isLaz==0 && aiVNapr==-1 && aiLaz<=0 && t_laz<-30) {		//пытаться карабкаться вверх
						checkStairs();
						if (isLaz && isLaz!=0) aiLaz=30;
					}
					if (isLaz==0 && aiVNapr==1 && aiLaz<=0 && t_laz<-30) {		//пытаться карабкаться вниз
						checkStairs(2);
						if (isLaz && isLaz!=0) aiLaz=30;
					}
				}
				if (isLaz) {
					if (t_laz<0) t_laz=0;
					t_laz++;
					if (celY<Y && r_laz<=0) {
						r_laz=-1;
						if (dy>-lazSpeed) dy-=lazSpeed/3;
						else (dy=-lazSpeed);
						checkStairs();
					} else if (aiVNapr==1 && r_laz>=0) {
						r_laz=1;
						if (dy<lazSpeed) dy+=lazSpeed/3;
						else (dy=lazSpeed);
						checkStairs();
					} else {
						isLaz=0;
						if (t_laz>20 && isrnd(0.7)) jmp=0.8;
					}
					if (turnY!=0) {
						isLaz=0;
						turnY=0;
					}
				} else {
					if (t_laz>0) t_laz=0;
					t_laz--;
					r_laz=0;
				}

				if (levit) {
					if (aiNapr==-1) {
						if (dx>-maxSpeed) dx-=levitaccel;
					} else {
						if (dx<maxSpeed) dx+=levitaccel;
					}
				} else if (isFly) {
					if (celUnit && rasst2<stalkDist*stalkDist) {
						dx*=0.85;
						dy*=0.85;
						dx+=floatX;
						dy+=floatY;
					} else {
						spd.x=celX-X;
						spd.y=celY-(Y-scY/2);
						//дематериализоваться
						if (turnX!=0) {
							spd.x=0;
							//dx=Math.abs(dx)*turnX;
							tstor=turnX;
							if (celUnit==null) setCel(null,X+(Math.random()*100+50)*turnX, celY);
							turnX=0;
						}
						if (turnY!=0) {
							spd.y=0;
							//if (turnY==1) dy=Math.abs(dy);
							//turnY=0;
						}
						norma(spd,Math.min(accel,accel*(celDX*celDX+celDY*celDY)/10000));
						dx+=spd.x+floatX;
						dy+=spd.y+floatY;
					}
					//приземлиться
					if (turnY<0) {
						if (t_landing>20) {
							t_landing=0;
							isFly=false;
							turnY=0;
						} else t_landing++;
					}
					turnX=turnY=t_fall=0;
				} else if (stay || isPlav) {
					if (moving || Math.abs(X-begX)>20 || Math.abs(Y-begY)>20) {
						if (aiNapr==-1) {
							if (dx>-maxSpeed) dx-=accel;
							walk=-1;
						} else {
							if (dx<maxSpeed) dx+=accel;
							walk=1;
						}
					}
				} else {
					if (aiNapr==-1) {
						if (dx>-maxSpeed) dx-=accel/4;
					} else  if (aiNapr==1){
						if (dx<maxSpeed) dx+=accel/4;
					}
				}
				if (stay && isrnd(0.5) && aiVNapr<=0 && (shX1>0.5 && aiNapr<0 || shX2>0.5 && aiNapr>0)) jmp=0.5;
				if (turnX!=0) {
					if (pumpObj && pumpObj.door) {		//наткнулся на дверь, открыть
						if (pumpObj.lock<=0 && pumpObj.active && pumpObj.action==1 && pumpObj.lockTip!=4) {//&& Math.abs(pumpObj.X-X)<150 && Math.abs(pumpObj.Y-Y)<100
							pumpObj.open=true;
							pumpObj.setDoor();
						}
					}
					if (celDX*aiNapr<0) {				//повернуться, если цель сзади
						aiNapr=tstor=turnX;
						aiTTurn=Math.floor(Math.random()*20)+5;
					} else {							//попытаться перепрыгнуть, если цель спереди
						aiTTurn--;
						if (isrnd(0.1) || turnY>0 || celDY>100 || !checkJump()) aiTTurn-=10;
						else jmp=1;
						if (aiTTurn<0 && stay) {
							aiNapr=tstor=turnX;
							aiTTurn=Math.floor(Math.random()*20)+5;
						}
					}
					turnX=turnY=0;
				}
				if (jmp>0) {
					tstor=aiNapr;
					jump(jmp);
					jmp=0;
				}
			} else if (aiState==4) {
				walk=0;
				aiNapr=tstor=(celX>X)?1:-1;
				if (attackerType==2 && (celDX*celDX+celDY*celDY<200*200)) {
					if (isrnd(0.6)) {
						dx=runSpeed*(celDX>0?-1:1)*2;
						jump(0.4);
					}
					aiState=3;
				}
			} else if (aiState==7) {
				walk=0;
				aiNapr=tstor=(celX>X)?1:-1;
			}
			pumpObj=null;
			
			if (Y>loc.spaceY*Tile.tileY-80) throu=false;
			
			if (aiState==3 || aiState==4 || aiState==6 || aiState==8) aiAttack=1;
			else aiAttack=0;
			
			if (aiAttack && World.w.enemyAct>=3) {
				attack();
			}

		}
		
		public override function damage(dam:Number, tip:int, bul:Bullet=null, tt:Boolean=false):Number {
			scrAlarmOn=false;
			if (sost==1) {
				if (aiState<=1) budilo();
			}
			return super.damage(dam, tip, bul,tt);
		}
		
		public override function replic(s:String) {
			if (t_replic<=0 && s=='attack') {
				if (tr==8 && isrnd(0.3)) s='fire';
				if (tr==9 && isrnd(0.3)) s='expl';
			}
			super.replic(s);
		}
		
		public function attack() {
			if ((attackerType==0 || aiState==8) && celUnit && shok<=0) {	//атака холодным оружием без левитации или корпусом
				if (attKorp(celUnit,(Math.abs(dx)>8)?1:0.5)) {
					if (aiState==8) aiTCh=5;
				}
			} else if (attackerType==1) {		//атака холодным оружием с левитацией
				if (Math.abs(celDX)<120 && Math.abs(celDY)<currentWeapon.rapid*8 && shok<=0 && isrnd(0.3)) currentWeapon.attack();
				if (isrnd(0.1)) attKorp(celUnit,0.5);
			} else if (attackerType==2 && isLaz==0) {							//пальба
				if (!sniper) mazil=(aiState==4)?5:16;		//стоя на месте стрельба точнее
				if (levit>0) mazil=25;
				if (levit>0 && levitAttack<1 && (levitAttack==0 || Math.random()>levitAttack)) return;	//не стрелять при левитации
				if (aiAttackOch==0 && shok<=0 && (celUnit!=null && isrnd(0.1) || celUnit==null && isrnd(0.03))) currentWeapon.attack();	//стрельба одиночными
				if (aiAttackOch>0 && (!sniper || celUnit)) {										//стрельба очередями
					if (aiAttackT<=0) aiAttackT=Math.round((Math.random()*0.4+0.8)*aiAttackOch);
					if (aiAttackT>aiAttackOch*0.25) currentWeapon.attack();
					aiAttackT--;
				}
				if ((celDX*celDX+celDY*celDY<100*100) && isrnd(0.1)) attKorp(celUnit,0.5);
			} else if (attackerType==3) {		//гранаты
				if (celUnit && isrnd(0.02)) {
					currentWeapon.attack();
					if (currentWeapon is WThrow && (currentWeapon as WThrow).kolAmmo<=0) attackerType=0;
				}
				if ((celDX*celDX+celDY*celDY<100*100) && isrnd(0.1)) attKorp(celUnit,(Math.abs(dx)>8)?1:0.5);
			}
		}
		
		public override function command(com:String, val:String=null) {
			super.command(com,val);
			if (com=='turn') {
				if (val=='0') storona=-storona;
				else if (val=='-1') storona=-1;
				else storona=1;
				tstor=storona;
				setVisPos();
			}
			if (com=='off') {
				walk=0;
				controlOn=false;
			} else if (com=='on') {
				controlOn=true;
			}
		}
		
	}
}

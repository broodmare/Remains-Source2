package fe.unit {
	import flash.filters.GlowFilter;
	import flash.display.MovieClip;
	
//	import fe.inter.Vendor;
	import fe.serv.Interact;
	import fe.*;
	import fe.serv.Script;
	import fe.serv.Item;
	import fe.serv.NPC;
	import fe.weapon.Weapon;
	
	public class UnitNPC extends UnitPon{
		
		public var targNPC:NPC;
		public var npcId:String='';
		public var npcXML:XML;
		
		public var visClass:Class;
		public var ico:MovieClip;
		public var icoFrame:int=1;
		public var noTurn:Boolean=false;	//не поворачиваться при разговоре
		public var silent:Boolean=false;	//не трындеть в обычном состоянии
		public var showSign:Boolean=false;	//показывать мигающий указатель
		
		public var animFly:Boolean=false;
		public var weap:String='';
		public var weap2:String='';
		var dopWeapon:Weapon;
		
		public var zanyato:Boolean=false;	//npc занят боем, не взаимодействует
		var t_ref:int=0;		//не дать говорить несколько раз подряд
		
		var t_anim:int=100;
		var t_float:Number=0;
		var floatX:Number=0, floatY:Number=0;
		
		var que:Array=new Array();
		var wait:int=0;
		var dey:String='';
		var cx:Number=-1, cy:Number=-1;
		var dvig:Object=new Object;
		
		public function UnitNPC(cid:String=null, ndif:Number=100, xml:XML=null, loadObj:Object=null) {
			super(cid, ndif, xml, loadObj);
			if (cid!='' && cid!=null) {
				id=cid;
			} else {
				id='npc';
			}
			getXmlParam();
			
			//взять данные об npc
			if (xml && xml.@npc.length()) {
				targNPC=World.w.game.npcs[xml.@npc];
			}
			if (targNPC) {
				if (loadObj && loadObj.rep!=null) targNPC.rep=loadObj.rep;	//старый формат сохранения
				npcId=targNPC.id;
				npcXML=targNPC.xml;
			} else {
				npcId=id;
				targNPC = new NPC(null,null,id,ndif);
			}
			//sost=1, disabled=false;
			targNPC.inter=inter;
			targNPC.owner=this;
			//если есть настройки npc
			if (npcXML) {
				if (npcXML.@vis.length()) {
					visClass=Res.getClass('visual'+npcXML.@vis, npcXML.@vis, visualVendor);
				} else visClass=visualVendor;
				if (npcXML.@noturn.length()) noTurn=true;
				if (npcXML.@ico.length()) icoFrame=npcXML.@ico;
				if (Res.istxt('u',npcId)) nazv=Res.txt('u',npcId);
				if (npcXML.@name.length()) nazv=Res.txt('u',npcXML.@name);
				if (npcXML.@replic.length()) id_replic=npcXML.@replic;
				if (npcXML.@silent.length()) silent=true;
				if (npcXML.@weap.length()) weap=npcXML.@weap;
				if (npcXML.@weap2.length()) weap2=npcXML.@weap2;
				if (npcXML.@sloy.length()) sloy=npcXML.@sloy;
			} else {	//и если нет
				if (id=='doctor') {
					visClass=visualDoctor;
					icoFrame=3;
				} else {
					visClass=visualVendor;
					icoFrame=2;
				}
			}
			
			//внешний вид
			vis=new visClass();
			ico=new visNPCIco();
			ico.y=-140;
			vis.addChild(ico);
			if (vis==null) vis=new visualVendor();
			if (vis.osn) {
				try {
					vis.osn.gotoAndStop('stay');
				} catch(err) {
					vis.osn.gotoAndStop(1);
				}
			}
			//оружие
			if (weap!='') {
				currentWeapon=Weapon.create(this,weap);
				currentWeapon.hold=currentWeapon.holder;
				setCel(null,100,-30);
				childObjs=[currentWeapon];
				if (npcXML && npcXML.@dammult.length()) currentWeapon.damage*=npcXML.@dammult;
			}
			if (weap2!='') {
				dopWeapon=Weapon.create(this,weap2);
				dopWeapon.hold=dopWeapon.holder;
				childObjs.push(dopWeapon);
			}
			
			//настройки из XML карты
			if (xml) {
				if (xml.@fly.length()) {
					animFly=true;
					//if (rep==0) 
					aiTip='fly';
					isFly=true;
				}
				if (xml.@hide.length()) hide();
				if (xml.@ai.length()) aiTip=xml.@ai;
			}
			targNPC.init();
			setInter();
		}
		

		public override function addVisual() {
			super.addVisual();
			if (targNPC) {
				targNPC.refresh();
				targNPC.check();
				isVis=!targNPC.hidden;
				//trace(nazv,targNPC.rep, targNPC.hidden);
			}
			vis.visible=isVis;
			if (currentWeapon) currentWeapon.vis.visible=isVis;
			inter.active=isVis;
		}
		
		public function setInter() {
			inter.action=100;
			inter.active=true;
			inter.cont=null;
			inter.actFun=npcFun;
			if (targNPC) targNPC.setInter();
			inter.update();
		}
		
		public override function animate() {
			if (t_anim>0) t_anim--;
			else {
				t_anim=Math.random()*200+150;
				var br:int=Math.floor(Math.random()*2+1);
				try {
					vis.osn.gotoAndPlay('move'+br);
				} catch (err) {
					
				}
			}
			if (animFly) {
				try {
					if (isFly && animState!='fly') {
						vis.osn.gotoAndStop('fly');
						animState='fly';
					}
					if (!isFly && animState!='stay') {
						vis.osn.gotoAndStop('stay');
						animState='stay';
					}
				} catch(err) {
					
				}
			}
		}
		
		
		function hide() {
			inter.active=false;
			isVis=false;
			if (vis) vis.visible=false;
			if (currentWeapon) currentWeapon.vis.visible=false;
		}
		
		
		public function npcFun() {
			if (zanyato || t_ref>0) return;
			t_ref=16;
			if (!noTurn) {
				if (X>World.w.gg.X) storona=-1;
				else storona=1;
			}
			if (targNPC) targNPC.activate();
		}
		
		
		
		public override function command(com:String, val:String=null) {
			super.command(com,val);
			//скрыть
			if (com=='hide') {
				hide();
			//проявиться
			} else if (com=='show') {
				isVis=true;
				vis.visible=true;
				vis.alpha=0;
				if (currentWeapon) {
					currentWeapon.vis.visible=true;
					currentWeapon.vis.alpha=0;
				}
				targNPC.hidden=false;
			//открыть глаза
			} else if (com=='openEyes') {
				try {
					vis.osn.gotoAndStop(2);
				} catch (err) {}
			//проверить, нужна ли мигающая подсказка
			} else if (com=='sign') {
				if (ico.sign) {
					if (aiTip=='fly') ico.sign.visible=false;
					else ico.sign.visible=World.w.helpMess;
				}
			//попрощаться
			} else if (com=='replicVse') {
				t_replic=0;
				replic('vse');
			} else if (com=='rep') {
				targNPC.rep=int(val);
			} else {
				var q:Object=new Object;
				q.com=com;
				q.val=val;
				que.push(q);
			}
		}
		
		//команды, выполняющиеся в очереди
		function analiz(q) {
			//реплика
			if (q.com=='tell') {
				t_replic=0;
				replic(q.val);
			//проверка статуса
			} else if (q.com=='check') {
				if (targNPC) targNPC.check();
			//сменить тип поведения
			} else if (q.com=='ai') {
				aiTip=q.val;
			//лететь в точку
			} else if (q.com=='fly') {
				var celF:Array=q.val.split(":");
				cx=(int(celF[0])+1)*World.tileX;
				cy=(int(celF[1]))*World.tileY;
				trace(cx,cy);
				dey='fly';
				wait=1000;
			//скрыть
			} else if (q.com=='rem') {
				hide();
			//повернуться
			} else if (q.com=='turn') {
				if (q.val=='0') storona=-storona;
				else if (q.val=='-1') storona=-1;
				else storona=1;
				setVisPos();
			} else if (q.com=='mater') {
				if (q.val=='0') mater=false;
				else mater=true;
			}
		}
		
		public override function findCel(over:Boolean=false):Boolean {
			for each (var un:Unit in loc.units) {
				if (un.disabled || un.sost>1 || un.fraction==fraction || un.doop || un.invis) continue;
				if (look(un,true)) {
					setCel(un);
					return true;
				}
			}
			celUnit=priorUnit=null;
			return false;
		}
		
		
		
		public override function control() {
			if (t_ref>0) t_ref--;
			if (World.w.gui.dialScript.running) {
			} else {
				t_replic--;
				if (t_replic<=0) {
					if (!silent) replic('neutral');
					t_replic=Math.random()*500+200;
				}
				if (targNPC && targNPC.zzzGen && t_replic%120==2) {
					newPart('zzz',3);
					try {
						vis.osn.gotoAndStop(1);
					} catch (err) {}
				}
			}
			if (wait>0) wait--;
			if (wait==1) dey='';
			if (que.length && wait<=0) {
				var q=que.shift();
				analiz(q);
			}
			if (vis.alpha<1) vis.alpha+=0.05;
			if (currentWeapon && currentWeapon.vis.alpha<1) currentWeapon.vis.alpha+=0.05;
			if (aiTip=='fly') {
				if (!stay) isFly=true;
			}
			if (isFly) {
				t_float+=0.243;
				floatY=Math.cos(t_float)*0.5;
				dx+=floatX;
				dy+=floatY;
			}
			if (celUnit==null) {
				celX=X+storona*100;
				celY=Y-10;
			}
			if (dey=='fly') {
				dvig.x=cx-X;
				dvig.y=cy-Y;
				var dst2=dvig.x*dvig.x+dvig.y*dvig.y;
				if (dst2<40*40) {
					dx*=0.85;
					dy*=0.85;
					if (dst2<5*5) {
						dey='';
						dx=0; dy=0;
						wait=0;
					}
				} else {
					norma(dvig,accel);
					dx+=dvig.x;
					dy+=dvig.y;
				}
			}
			if (aiTip=='agro') {
				if (celUnit && celUnit.sost==1 && celUnit.hp>0) {
					setCel(celUnit);
					if (celDX>0 && storona==-1) storona=1;
					if (celDX<0 && storona==1) storona=-1;
					if (currentWeapon) currentWeapon.attack();
					if (dopWeapon) dopWeapon.attack();
					ico.visible=false;
					zanyato=true;
				} else if (loc.active && findCel()) {
					ico.visible=false;
					zanyato=true;
				} else {
					ico.visible=true;
					zanyato=false;
					celUnit=null;
					if (isFly && dy<5) dy+=1;
				}
				if (turnY<0) {
					isFly=false;
					turnY=0;
					aiTip='';
					targNPC.landing();
					inter.active=true;
					if (ico.sign) {
						ico.sign.visible=World.w.helpMess;
					}
				}
			}
		}
		
	
	}
}

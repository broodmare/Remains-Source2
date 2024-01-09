package fe.inter {
	
	//Стенд для оружия, коллекционных вещей и ачивок
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.text.StyleSheet;
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	import flash.geom.Matrix;
	import fe.*;
	import fe.unit.Invent;
	import fe.unit.Armor;
	import fe.weapon.Weapon;
	import fe.serv.Item;
	
	public class Stand {

		public var active:Boolean=false;
		
		var vis:MovieClip;
		var visX=1200, visY=800;
		var pages:Array;
		var buttons:Array;
		var weapons:Array;
		var arts:Array;
		var armors:Array;
		public var inv:Invent;
		
		var kolPages:int=9;
		var kolLevels:int=6;
		var page:int=0;
		
		var ls=['stat_aj','stat_tw','stat_fl','stat_rr','stat_rd','stat_pp'];
		
		var itemFilter:GlowFilter=new GlowFilter(0x00FF99,1,3,3,4,1,false,false);
		var clearFilter:GlowFilter=new GlowFilter(0x00FF99,1,3,3,1,1,false,true);
		var glowFilter:GlowFilter=new GlowFilter(0x00FF99,1,10,6,2,3);
		
		var info:MovieClip;
		
		public function Stand(vstand:MovieClip, ninv:Invent) {
			vis=vstand;
			inv=ninv;
			pages=new Array();
			buttons=new Array();
			weapons=new Array();
			armors=new Array();
			arts=new Array();
			for (var i=0; i<kolPages; i++) {
				var page:MovieClip=new MovieClip();
				page.x=200;
				page.visible=false;
				vis.addChild(page);
				pages[i]=page;
				
				var but:MovieClip=new butStand();
				but.id.text=i;
				but.id.visible=false;
				but.ico.gotoAndStop(i+2);
				but.text.text=Res.guiText('stand'+i);
				but.y=25+75*i;
				but.x=20;
				but.stop();
				vis.addChild(but);
				buttons[i]=but;
				but.addEventListener(MouseEvent.CLICK,standBut);
			}
			vis.butclose.addEventListener(MouseEvent.CLICK,standClose);
			vis.butclose.id.visible=false;
			vis.butclose.text.text=Res.guiText('close');
			resizeScreen(1200,800);
			createWeaponLists(0);
			createWeaponLists(1);
			createWeaponLists(2);
			createWeaponLists(3);
			createWeaponLists(4);
			createWeaponLists(5);
			createArmorList(6);
			createArmorList(7);
			createArtList(8);
			showWeaponList(0);
			info = new visualStandInfo();
			vis.addChild(info);
			info.visible=false;
			PipPage.setStyle(info.info);
			info.info.autoSize='left';
			vis.toptext.visible=false;
			PipPage.setStyle(vis.bottext);
			PipPage.setStyle(vis.toptext.txt);
			vis.bottext.htmlText='';
		}
		
		public function standClose(event:MouseEvent) {
			onoff(-1);
		}
		
		public function standBut(event:MouseEvent) {
			page=event.currentTarget.id.text;
			setButtons();
			showWeaponList(page);
		}
		
		function createWeaponLists(n:int) {
			var levels:Array=[0,0,0,0,0,0,0];
			var stolb:int=-1;
			for each (var weap in AllData.d.weapon.(@tip>0)) {
				if (weap.@nostand>0) continue;
				if ((n==0 && weap.@skill==1) || (n==1 && weap.@skill==2) || (n==2 && weap.@skill==4) || (n==3 && weap.@skill==5) || (n==4 && weap.@skill==3) || (n==5 && weap.@skill>=6)) {
					//if (weap.@lvl.length()==0 || weap.@lvl>=kolLevels) continue;
					var item=new itemStand();
					if (weap.@tip==5) {
						stolb++;
						if (stolb>=kolLevels) stolb=0;
					} else {
						stolb=weap.@lvl;
					}
					//else stolb=weap.@osob;
					levels[stolb]++;
					item.x=80+stolb*160;
					item.y=40+levels[stolb]*100;
					item.id.text=weap.@id;
					item.id.visible=false;
					item.dop.visible=false;
					item.goldstar.stop();
					item.nazv.text=Res.txt('w',weap.@id);
					//изображение
					var infIco:MovieClip;
					var r:Number=1;
					if (weap.@tip==5) {	//заклинание
						infIco=new itemIco();
						try {
							infIco.gotoAndStop(weap.@id);
						} catch(err){
							infIco.stop();
						}
						item.goldstar.y=-85;
						item.zad.scaleY=1.35;
						item.y=40+levels[stolb]*140;
						if (weap.@spell>0) item.nazv.text=Res.txt('i',weap.@id);
					} else {
						var vWeapon:Class=null;
						if (weap.vis.length() && weap.vis[0].@vico.length()) vWeapon=Res.getClass(weap.vis[0].@vico, null);
						if (vWeapon==null) {
							vWeapon=Res.getClass('vis'+weap.@id, null);
						}
						if (vWeapon!=null) {
							infIco=new vWeapon();
						}
					}
					if (weap.vis.length() && weap.vis.@icomult.length()) {
						r=infIco.scaleX=infIco.scaleY=weap.vis.@icomult;
					}
					infIco.x=-infIco.getRect(infIco).left*r-infIco.width/2;
					infIco.y=-infIco.height-infIco.getRect(infIco).top;
					infIco.stop();
					if (infIco.lez) infIco.lez.stop();
					item.weapon.addChild(infIco);
					if (weap.char.length()>1) {
						if (Res.istxt('w',weap.@id+'^1')) item.nazv2.text=Res.txt('w',weap.@id+'^1');
						else item.nazv2.text=Res.txt('w',weap.@id)+Weapon.variant2;
						
						item.dop.text='1';	//есть уникальный вариант
						item.goldstar.gotoAndStop(2);
						vWeapon=Res.getClass('vis'+weap.@id+'_1', null);
						if (vWeapon!=null) {
							infIco=new vWeapon();
							infIco.x=-infIco.getRect(infIco).left*r-infIco.width/2;
							infIco.y=-infIco.height-infIco.getRect(infIco).top;
							infIco.stop();
							if (infIco.lez) infIco.lez.stop();
							item.weapon2.addChild(infIco);
							item.dop.text='2'; //есть уникальный вариант со своей картинкой
						}
					} else {
						//item.nazv2.visible=false;
					}
					pages[n].addChild(item);
					weapons[weap.@id]=item;
				}
			}
		}
		
		function createArtList(n:int) {
			for (var stolb=0; stolb<6; stolb++) {
				var item=new itemArt();
				item.x=80+stolb*160;
				item.y=40;
				item.art.gotoAndStop(ls[stolb]);
				item.nazv.text=Res.txt('i',ls[stolb]);
				item.id.text=ls[stolb];
				item.id.visible=false;
				pages[n].addChild(item);
				arts[stolb]=item;
			}
		}
		
		function createArmorList(n:int) {
			var stolb:int=0;
			var str:int=0;
			var dvis:MovieClip=new visBodyStay();
			var sc:Number=1.5;
			var aid=Appear.ggArmorId;
			Appear.transp=true;
			for each(var arm in AllData.d.armor) {
				if (n==6 && arm.@tip>1 || n==7 && arm.@tip!=3) continue;
				var item=new itemArt();
				item.x=80+stolb*160;
				item.y=str*180;
				stolb++;
				if (stolb>=6) {
					stolb=0, str++;
				}
				item.id.text=arm.@id;
				item.id.visible=false;
				item.nazv.text=Res.txt('a',arm.@id);
				pages[n].addChild(item);
				armors[arm.@id]=item;
				if (n==6) {
					World.w.armorWork=arm.@id;
					dvis.gotoAndStop(2);
					dvis.gotoAndStop(1);
					var sprX:int=dvis.width*sc+2;
					var sprY:int=dvis.height*sc+2;
					var m:Matrix=new Matrix();
					m.tx=-dvis.getRect(dvis).left+1;
					m.ty=-dvis.getRect(dvis).top+1;
					m.scale(sc,sc);
					try {
						dvis.pip1.visible=dvis.sleg1.mark.visible=dvis.sleg2.mark.visible=dvis.head.morda.magic.visible=dvis.head.morda.eye.visible=false;
					} catch (err) {}
					var bmpd:BitmapData=new BitmapData(sprX,sprY,true,0x00000000);
					bmpd.draw(dvis,m);
					var bmp:Bitmap=new Bitmap(bmpd);
					item.art.addChild(bmp);
					bmp.x=-bmp.width/2-10;
					bmp.y=100;
				} else if (n==7) {
					item.art.gotoAndStop(arm.@id);
					item.art.y=100;
				}
			}
			Appear.transp=false;
			World.w.armorWork='';
		}
		
		function showMass() {
			vis.bottext.htmlText='';
			try {
				if (page<=4) vis.bottext.htmlText=inv.retMass(4);
				if (page==5) vis.bottext.htmlText=inv.retMass(5);
			} catch (err) {
			}
		}
		
		function showWeaponList(n:int) {
			for (var i=0; i<kolPages; i++) {
				pages[i].visible=false;
			}
			if (World.w.hardInv) showMass();
			pages[n].visible=true;
			if (n<5) vis.toptext.txt.htmlText=Res.txt('p','infostand',0,true);
			if (n==5) vis.toptext.txt.htmlText=Res.txt('p','infostand',0,true);
			vis.toptext.visible=(n<=5);
			for each (var weap in AllData.d.weapon.(@tip>0)) {
				if ((n==0 && weap.@skill==1) || (n==1 && weap.@skill==2) || (n==2 && weap.@skill==4) || (n==3 && weap.@skill==5) || (n==4 && weap.@skill==3) || (n==5 && weap.@skill>=6)) {
					//trace(weap.@id,weapons[weap.@id].spell,inv.items[weap.@id].kol)
					if (weapons[weap.@id]==null) continue;
					if (weap.@spell>0 && (inv.items[weap.@id]==null || inv.items[weap.@id].kol<=0)) {
						showWeapon(weapons[weap.@id],0,0);
					} else if (inv.weapons[weap.@id]==null || inv.weapons[weap.@id].respect==3) showWeapon(weapons[weap.@id],0,0)
					else showWeapon(weapons[weap.@id],inv.weapons[weap.@id].variant+1,inv.weapons[weap.@id].respect);
				}
			}
			for each(var arm in AllData.d.armor) {
				if (armors[arm.@id]) {
					if (inv.armors[arm.@id] && inv.armors[arm.@id].lvl>=0) {
						armors[arm.@id].nazv.visible=true;
						armors[arm.@id].art.filters=[itemFilter, glowFilter];
					} else {
						armors[arm.@id].nazv.visible=false;
						armors[arm.@id].art.filters=[clearFilter];
					}
				}
			}
			for (var i in ls) {
				if (inv.items[ls[i]].kol) {
					arts[i].nazv.visible=true;
					arts[i].art.filters=[itemFilter, glowFilter];
				} else {
					arts[i].nazv.visible=false;
					arts[i].art.filters=[clearFilter];
				}
			}
		}
		
		//n - 0-нет, 1-обычное, 2-уникальное
		//respect - 0-новое, 1-скрытое, 2-используемое, 3-схема
		function showWeapon(item:MovieClip, n:int, respect:int) {
			if (n==0) {
				item.weapon.filters=[clearFilter, glowFilter];
				item.weapon2.filters=[clearFilter, glowFilter];
				item.nazv.visible=item.nazv2.visible=false;
				item.weapon.visible=true;
				item.weapon2.visible=false;
				item.goldstar.visible=false;
			} else if (n==1) {
				item.nazv.visible=true;
				item.nazv2.visible=false;
				item.weapon.visible=true;
				item.weapon2.visible=false;
				item.goldstar.visible=true;
			} else if (n==2) {
				item.nazv.visible=false;
				item.nazv2.visible=true;
				if (item.dop.text=='2') {
					item.weapon.visible=false;
					item.weapon2.visible=true;
				} else {
					item.weapon.visible=true;
					item.weapon2.visible=false;
				}
				item.goldstar.gotoAndStop(3);
				item.goldstar.visible=true;
			}
			if (item.nazv.visible || item.nazv2.visible) {
				if (respect==1) {
					item.weapon.alpha=0.5;
					item.weapon.filters=[itemFilter]
					item.weapon2.filters=[itemFilter];
					item.nazv.alpha=0.35;
					item.nazv2.alpha=0.35;
				} else {
					item.weapon.filters=[itemFilter, glowFilter];
					item.weapon2.filters=[itemFilter, glowFilter];
					item.nazv.alpha=1;
					item.nazv2.alpha=1;
					item.weapon.alpha=1;
				}
			}
		}
		
		function setButtons() {
			for (var i=0; i<kolPages; i++) {
				var item:MovieClip=buttons[i];
				if (page==i) item.gotoAndStop(2);
				else item.gotoAndStop(1);
			}
		}
		
		public function itemClick(event:MouseEvent) {
			var id=event.currentTarget.id.text;
			if (inv.weapons[id]==null || inv.weapons[id].respect==3) return;
			var resp=inv.respectWeapon(id);
			showWeapon(event.currentTarget as MovieClip,-1,resp);
			if (World.w.hardInv) showMass();
		}
		public function itemOver(event:MouseEvent) {
			if (inv.weapons[event.currentTarget.id.text]==null) {
				return;
			}
			if (!event.currentTarget.nazv.visible && !event.currentTarget.nazv2.visible) return;
			info.nazv.text=event.currentTarget.nazv.visible?event.currentTarget.nazv.text:event.currentTarget.nazv2.text;
			if (event.currentTarget.nazv2.visible) info.info.htmlText=PipPage.infoStr(Item.L_WEAPON,event.currentTarget.id.text+'^'+inv.weapons[event.currentTarget.id.text].variant);
			else info.info.htmlText=PipPage.infoStr(Item.L_WEAPON,event.currentTarget.id.text);
			info.visible=true;
			info.fon.height=info.info.height+info.info.y+8;
			var nx=event.currentTarget.x+event.currentTarget.parent.x+80;
			var ny=event.currentTarget.y+event.currentTarget.parent.y-50;
			if (ny+vis.y+info.height>World.w.cam.screenY-10) ny=World.w.cam.screenY-vis.y-info.height-10;
			if (nx+vis.x+info.width>World.w.cam.screenX-10) nx=event.currentTarget.x+event.currentTarget.parent.x-80-info.width;
			info.x=nx;
			info.y=ny;
		}
		public function itemOver2(event:MouseEvent) {
			if (!event.currentTarget.nazv.visible) return;
			info.nazv.text=event.currentTarget.nazv.text;
			info.info.htmlText=PipPage.infoStr(Item.L_ARMOR,event.currentTarget.id.text);
			info.visible=true;
			info.fon.height=info.info.height+info.info.y+8;
			var nx=event.currentTarget.x+event.currentTarget.parent.x+80;
			var ny=event.currentTarget.y+event.currentTarget.parent.y+20;
			if (ny+vis.y+info.height>World.w.cam.screenY-10) ny=World.w.cam.screenY-vis.y-info.height-10;
			if (nx+vis.x+info.width>World.w.cam.screenX-10) nx=event.currentTarget.x+event.currentTarget.parent.x-80-info.width;
			info.x=nx;
			info.y=ny;
		}
		public function itemOut(event:MouseEvent) {
			info.visible=false;
		}
		
		public function onoff(turn:int=0) {
			if (turn==0) {
				active=!active;
			} else if (turn>0) {
				active=true;
				World.w.pip.onoff(-1);
				World.w.ctr.clearAll();
			} else {
				active=false;
			}
			vis.visible=active;
			if (active) {
				World.w.cur();
				setButtons();
				showWeaponList(page);
				for each (var item in weapons) {
					if (!item.hasEventListener(MouseEvent.CLICK)) {
						item.addEventListener(MouseEvent.CLICK,itemClick);
						item.addEventListener(MouseEvent.MOUSE_OVER,itemOver);
						item.addEventListener(MouseEvent.MOUSE_OUT,itemOut);
					}
				}
				for each (var item in armors) {
					item.addEventListener(MouseEvent.MOUSE_OVER,itemOver2);
					item.addEventListener(MouseEvent.MOUSE_OUT,itemOut);
				}
				for each (var item in arts) {
					item.addEventListener(MouseEvent.MOUSE_OVER,itemOver2);
					item.addEventListener(MouseEvent.MOUSE_OUT,itemOut);
				}
			} else {
				for each (var item in weapons) {
					if (item.hasEventListener(MouseEvent.CLICK)) {
						item.removeEventListener(MouseEvent.CLICK,itemClick);
						item.removeEventListener(MouseEvent.MOUSE_OVER,itemOver);
						item.removeEventListener(MouseEvent.MOUSE_OUT,itemOut);
					}
				}
				for each (var item in armors) {
					item.removeEventListener(MouseEvent.MOUSE_OVER,itemOver2);
					item.removeEventListener(MouseEvent.MOUSE_OUT,itemOut);
				}
				for each (var item in arts) {
					item.removeEventListener(MouseEvent.MOUSE_OVER,itemOver2);
					item.removeEventListener(MouseEvent.MOUSE_OUT,itemOut);
				}
			}
		}

		//коррекция размеров
		public function resizeScreen(nx:int, ny:int) {
			if (nx>=1200 && ny>=800) {
				vis.x=(nx-visX)/2;
				vis.y=(ny-visY)/2;
				vis.scaleX=vis.scaleY=1;
			} else {
				vis.x=vis.y=0;
				if (nx/1200<ny/800) {
					vis.scaleX=vis.scaleY=nx/1200;
				} else {
					vis.scaleX=vis.scaleY=ny/800;
				}
			}
		}
	}
	
}

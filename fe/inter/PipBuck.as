package fe.inter 
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	import fe.*;
	import fe.unit.Invent;
	import fe.unit.Unit;
	import fe.unit.Armor;
	import fe.unit.UnitPlayer;
	import fe.weapon.Weapon;
	import fe.serv.Vendor;
	import fe.unit.Pers;

	import fe.stubs.visPipHelp;
	import fe.stubs.visSetKey;
	import fe.stubs.visPipRItem;
	
	public class PipBuck
	{
		public var light:Boolean=false;		//простая версия
		public var vis:MovieClip; 		//property to store the page's GUI (MovieClip).
		public var vissetkey:MovieClip;
		public var vishelp:MovieClip;
		public var active:Boolean=false;
		public var noAct:Boolean=false;
		private var noAct2:Boolean=false;
		public var armorID:String;
		public var hideMane:int=0;
		private var page:int=1;

		private var pages:Array;
		public var currentPage:PipPage;
		
		public var inv:Invent;
		public var gg:UnitPlayer;
		public var money:int=0;
		
		public var helpText:String='';
		public var massText:String='';
		
		public  var showHidden:Boolean=false;
		public var reqKey:Boolean=false;		//запрос на назначение клавиши
		
		public var arrWeapon:Array;
		public var arrArmor:Array;
		
		//переменные, устанавливаемые в зависимости от того, какой объект или нпс вызвал интерфейс
		public var vendor:Vendor;			//связанный торговец
		public var npcInter:String='';		//тип взаимодействия связанного нпс-а
		public var npcId:String='';			//id связанного нпс-а
		public var workTip:String='work';	//тип связанной крафт-станции
		public var travel:Boolean=false;	//можно использовать переход между локациями
		
		public var isSaveConf:Boolean=false;
		
		public var pipVol:Number=0.25;
		public var ritems:Array;
		private var ritemsNazv:Array = ['hp','head','tors','legs','blood','mana','pet','inv1','inv1','caps']

		public function PipBuck(vpip:MovieClip) {
			light=true;
			vis=vpip;
			vis.visible=false;
			if (light)
			{
				vis.skin.visible=false;
				vis.fon.visible=false;
			}
			//кнопки
			var kolPages:int = 5;
			for (var i:int = 0; i <= kolPages; i++)
			{
				var item:MovieClip=vis.getChildByName('but'+i) as MovieClip;
				item.id.visible=false;
				item.visible=false;
				item.mouseChildren=false;
			}
			vis.but0.visible=true;
			vis.but0.addEventListener(MouseEvent.CLICK,pipClose);
			vis.but0.text.text=Res.pipText('mainclose');
			pages =
					[
						null,
						new PipPageStat(this,'stat'),
						new PipPageInv(this,'inv'),
						new PipPageInfo(this,'info'),
						new PipPageVend(this,'vend'),
						new PipPageOpt(this,'opt'),
						new PipPageMed(this,'med'),
						new PipPageWork(this,'work'),
						new PipPageApp(this,'app'),
						new PipPageVault(this,'vault')
					];
			page=kolPages;
			currentPage=pages[page];
			vishelp=new visPipHelp();
			vishelp.x=168;
			vishelp.y=138;
			vis.addChild(vishelp);
			vissetkey=new visSetKey();
			vissetkey.visible=false;
			vissetkey.x=600;
			vissetkey.y=400;
			vis.addChild(vissetkey);
			vishelp.visible=false;
			PipPage.setStyle(vishelp.txt);
			vis.butHelp.addEventListener(MouseEvent.MOUSE_OVER,helpShow);
			vis.butHelp.addEventListener(MouseEvent.MOUSE_OUT,helpUnshow);
			vis.butMass.addEventListener(MouseEvent.MOUSE_OVER,massShow);
			vis.butMass.addEventListener(MouseEvent.MOUSE_OUT,massUnshow);
			PipPage.setStyle(vis.toptext.txt);

			vis.pr.visible=false;
			ritems=[];
			var kolRItems:int = 15;
			for (var j:int = 0; j < kolRItems; j++)
			{
				item=new visPipRItem();
				ritems[j]=item;
				vis.pr.addChild(item);
				item.x=5;
				item.y=40+j*30;
				PipPage.setStyle(item.txt);
				item.trol.gotoAndStop(j+1);
				item.nazv.visible=false;
			}
		}
		
		public function updateLang():void
		{
			vis.but0.text.text = Res.pipText('mainclose');
			for each(var p in pages) if (p is PipPage) p.updateLang();
			currentPage.setStatus();
		}
		
		public function toNormalMode():void {
			light=false;
			vis.skin.visible=true;
			vis.fon.visible=true;
			var kolPages:int = 5;
			for (var i:int = 1; i <= kolPages; i++)
			{
				var item:MovieClip=vis.getChildByName('but'+i) as MovieClip;
				item.addEventListener(MouseEvent.CLICK,pageClick);
				item.text.text=Res.pipText('main'+i);
				item.id.text=i;
				item.visible=true;
			}
			vis.but0.text.text=Res.pipText('main0');
			page=1;
			allItems();
		}

		public function pageClick(event:MouseEvent):void
		{
			if (World.w.ctr.setkeyOn) return;
			if (World.w.gg && World.w.gg.pipOff) return;
			page=int(event.currentTarget.id.text);
			setPage();
			setButtons();
			snd(2);
		}

		public function pipClose(event:MouseEvent):void
		{
			if (World.w.ctr.setkeyOn) return;
			onoff(-1);
		}

		private function setButtons():void {
			var kolPages:int = 5;
			for (var i:int = 0; i <= kolPages; i++)
			{
				var item:MovieClip=vis.getChildByName('but'+i) as MovieClip;
				if (page==i) item.gotoAndStop(2);
				else item.gotoAndStop(1);
				if (i==4 && (page==6 || page==7 || page==8 || page==9)) item.gotoAndStop(2);
			}
		}

		public function snd(n:int):void
		{
			Snd.ps('pip'+n,-1000,-1000,0,pipVol);
		}
		
		//0 - сменить вкл на выкл
		//11 - принудительно включить
		//Показать/скрыть
		public function onoff(turn:int=0, p2:int=0):void
		{
			reqKey=false;
			if (active && turn==11) {
				return;
			} else if (turn==0) {
				active=!active;
				if (page>=4 && !light) page=1;
				snd(3);
			} else if (turn>0) {
				if (turn<10) page=turn;
				else if (page>=4) page=1;
				active=true;
			} else {
				if (active) snd(3);
				active=false;
			}
			if (!light && World.w.loc && World.w.loc.base) travel=true;
			vis.but4.visible=false;
			if (turn==4 || (turn>=6 && turn<=9)) {
				vis.but4.id.text=turn;
				vis.but4.text.text=Res.pipText('main'+turn);
				vis.but4.visible=true;
			}
			vis.visible=active;
			if (active) {
				World.w.cur();
				showHidden=false;
				if (vendor) vendor.reset();
				World.w.ctr.clearAll();
				if (World.w.stand) World.w.stand.onoff(-1);
				setPage(p2);
				if (!light) {
					World.w.gui.offCelObj();
					if (World.w.gui.t_mess>30) World.w.gui.t_mess=30;
				}
				if (World.w.gui) {
					World.w.gui.dial.alpha=World.w.gui.inform.alpha=0;
				}
				if (World.w.gg && World.w.gg.rat>0 || World.w.catPause) {
					noAct2=noAct;
					noAct=true;
				}
				World.w.gc();
			} else {
				if (isSaveConf) {
					World.w.saveConfig();
					isSaveConf=false;
				}
				vendor=null;
				npcId='';
				World.w.ctr.clearAll();
				World.w.app.detach();
				if (World.w.gui) {
					World.w.gui.dial.alpha=World.w.gui.inform.alpha=1;
				}
				if (World.w.gg && World.w.gg.rat>0) {
					noAct=noAct2;
				}
			}
			if (!light) {
				World.w.gui.setEffects();
				vis.pr.visible=true;
			}
			setButtons();
			if (!light && World.w.loc && !World.w.loc.base) travel=false;
			if (World.w && World.w.gg && World.w.gg.pipOff) supply(-1);
			else supply(1);
			World.w.ctr.keyPressed=false;
		}
		
		//коррекция размеров
		public function resizeScreen(nx:int, ny:int):void
		{
			if (nx>=1200 && ny>=800) {
				if (nx>1320) {
					var visX = 1200;
					vis.x=(nx-visX)/2-60;
					var visY = 800;
					vis.y=(ny-visY)/2;
				} else {
					vis.x=vis.y=0;
				}
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
		
		//питание
		public function supply(turn:int=-1):void
		{
			if (turn<0) {
				currentPage.vis.visible=false;
				vis.toptext.visible=false;
				vis.pipError.visible=true;
				vis.pipError.nazv.text=Res.pipText('piperror');
				var s:String=Res.txt('p','piperror',1);
				vis.pipError.info.text=s.replace(/[\b\r\t]/g,'');
			} else {
				vis.pipError.visible=false;
			}
		}
		
		//режим показа
		public function setPage(p2:int=0):void
		{
			if (!light) {
				gg=World.w.gg;
				inv=World.w.invent;
				money=inv.money.kol;
				if (vendor) {
					vendor.multPrice=World.w.pers.barterMult;
				}
			}
			for (var p in pages)
			{
				if (pages[p] is PipPage) pages[p].vis.visible=false;
			}
			currentPage=pages[page];
			if (currentPage is PipPage)
			{
				if (p2>0) currentPage.page2=p2;
				currentPage.setStatus();
			}
			if (!light) setRPanel();
			vishelp.visible=false;
		}
		
		public function assignKey(num:int):void
		{
			if (!active) return;
			if (currentPage is PipPageInv) (currentPage as PipPageInv).assignKey(num);
		}
		
		public function helpShow(event:MouseEvent):void
		{
			vishelp.txt.htmlText=helpText;
			vishelp.visible=true;
		}

		public function helpUnshow(event:MouseEvent):void
		{
			vishelp.visible=false;
		}

		public function massShow(event:MouseEvent):void
		{
			vishelp.txt.htmlText=massText;
			vishelp.visible=true;
		}

		public function massUnshow(event:MouseEvent):void
		{
			vishelp.visible=false;
		}
		
		public function allItems():void
		{
			arrWeapon = [];
			arrArmor  = [];
			var owner:Unit = new Unit();
			var w:Weapon;
			var a:Armor;

			for each (var weap:XML in Weapon.cachedWeaponList.(@tip > 0))
			{
				w = Weapon.create(owner, weap.@id, 0);
				arrWeapon[weap.@id] = w;
				if (weap.char.length() > 1)
				{
					w = Weapon.create(owner, weap.@id, 1);
					arrWeapon[weap.@id+'^'+1]=w;
				}
			}

			for each (var armor:XML in Armor.cachedArmorList)
			{
				a = new Armor(armor.@id);
				arrArmor[armor.@id] = a;
			}
		}
		
		public function setRPanel():void
		{
			if (light || !active) return;
			var gg:UnitPlayer=World.w.gg;
			var pers:Pers=World.w.pers;
			ritem1(0,gg.hp,gg.maxhp);
			ritem1(1,pers.headHP,pers.inMaxHP,!World.w.game.triggers['nomed']);
			ritem1(2,pers.torsHP,pers.inMaxHP,!World.w.game.triggers['nomed']);
			ritem1(3,pers.legsHP,pers.inMaxHP,!World.w.game.triggers['nomed']);
			ritem1(4,pers.bloodHP,pers.inMaxHP,!World.w.game.triggers['nomed']);
			ritem1(5,pers.manaHP,pers.inMaxMana,!World.w.game.triggers['nomed']);
			if (gg.pet) ritem1(6,gg.pet.hp,gg.pet.maxhp); else ritem1(6,0,0,false);
			if (gg.currentWeapon && gg.currentWeapon.tip<=3) ritem2(7,gg.currentWeapon.hp,gg.currentWeapon.maxhp); else ritem1(7,0,0,false);
			if (gg.currentArmor) ritem2(8,gg.currentArmor.hp,gg.currentArmor.maxhp); else ritem1(8,0,0,false);
			ritems[9].txt.htmlText="<span class = 'yellow'>"+gg.invent.money.kol+"</span>"
			ritem3(10,inv.massW,pers.maxmW,World.w.hardInv);
			ritem3(11,inv.massM,pers.maxmM,World.w.hardInv);
			ritem3(12,inv.mass[1],pers.maxm1,World.w.hardInv);
			ritem3(13,inv.mass[2],pers.maxm2,World.w.hardInv);
			ritem3(14,inv.mass[3],pers.maxm3,World.w.hardInv);
		}
		
		private function ritem1(n:int, hp:Number, maxhp:Number, usl=true):void
		{
			ritems[n].visible=usl;
			if (usl) {
				ritems[n].txt.htmlText="<span class = '"+med(hp,maxhp)+"'>"+Math.round(hp)+"</span>"+' / '+Math.round(maxhp);
			} else {
				ritems[n].txt.htmlText='';
			}
		}

		private function ritem2(n:int, hp:Number, maxhp:Number, usl=true):void
		{
			ritems[n].visible=usl;
			if (usl) {
				ritems[n].txt.htmlText="<span class = '"+med(hp,maxhp)+"'>"+Math.round(hp/maxhp*100)+"%</span>";
			} else {
				ritems[n].txt.htmlText='';
			}
		}

		private function ritem3(n:int, hp:Number, maxhp:Number, usl=true):void
		{
			ritems[n].visible = usl;

			if (usl) ritems[n].txt.htmlText="<span class='mass'><span class = '"+((hp>maxhp)?'red':'')+"'>"+Math.round(hp)+"</span>"+' / '+Math.round(maxhp)+"</span>";
			else ritems[n].txt.htmlText='';
		}
		
		private function med(hp:Number, maxhp:Number):String
		{
			if (hp<maxhp*0.25) return 'red';
			else if (hp<maxhp*0.5) return 'orange';
			return '';
		}
		
		public function setArmor(id:String):void {
			armorID = id;
			var node:XML = Armor.getArmorInfo(id);
			// Hacky failsafe to avoid crashing if no information is found.
			if (node == "" || node == null) {
				hideMane = 0;
				return;
			}
			hideMane = node.@hide;
		}
		
		public function step():void
		{
			if (currentPage) currentPage.step();
		}
	}	
}
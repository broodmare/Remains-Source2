package fe.inter {
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import fe.*;
	import fe.unit.Unit;
	
	public class Consol {
		public var vis:MovieClip;
		public var ist:Array;
		public var istN:int=0;
		
		private var help:XML=<chit>
			<a>all - добавить всё</a>
			<a>all weapon - добавить всё оружие</a>
			<a>all armor - добавить всю броню</a>
			<a>all item - 1000 каждого предмета</a>
			<a>all ammo - 10000 каждого патрона</a>
			<a>min - добавить необходимый минимум</a>
			<a>god - неуязвимость вкл/выкл</a>
			<a>jump - поменять режим прыжка</a>
			<a>xp X - добавить X опыта</a>
			<a>lvl X - установить уровень перса в X</a>
			<a>sp X - добавить Х скилл-поинтов</a>
			<a>pp X - добавить Х перк-поинтов</a>
			<a>money X - установить количество крышек Х</a>
			<a>weapon ID - получить оружие ID</a>
			<a>armor ID - получить броню ID</a>
			<a>item ID X - установить количество вещей ID в Х</a>
			<a>ammo ID X - установить количество патронов ID в Х</a>
			<a>skill ID n - установить скилл ID на величину n (0-20)</a>
			<a>perk ID - получить перк ID</a>
			<a>eff ID - получить эффект ID</a>
			<a>res - сброс всех эффектов</a>
			<a>testeff - все эффекты будут в 10 раз короче</a>
			<a>testdam - отменяет разброс урона</a>
			<a>hardinv - вкл/выкл ограниченный инвентарь</a>
			<a>repair - отремонтировать оружие</a>
			<a>crack X - повредить оружие на X%</a>
			<a>break X - повредить броню на X%</a>
			<a>lim X - установить лимит особого лута в X%</a>
			<a>heal - полное исцеление</a>
			<a>mana X - установить ману</a>
			<a>die - умереть</a>
			<a>check - вернуться на контрольную точку</a>
			<a>goto X Y - переместиться в локацию с координатами X Y</a>
			<a>clear - сброс некоторых переменных</a>
			<a>map - показать всю карту</a>
			<a>black - скрыть/показать туман войны</a>
			<a>enemy - вкл/выкл ИИ</a>
			<a>fly - можно включать полёт клавишей ~</a>
			<a>port - телепорт клавишей ~</a>
			<a>emit X - вызов частицы X клавишей ~</a>
			<a>refill - пополнить товары у торговцев</a>
			<a>getroom - зачистить комнату</a>
			<a>getloc - зачистить локацию</a>
			<a>dif X - изменить сложность (0-4)</a>
			<a>st X Y - установить триггер X в значение Y</a>
			<a>trigger X - получить значение триггера X</a>
			<a>triggers - получить значение триггеров</a>
		</chit>;

		public function Consol(vcons:MovieClip, prev:String=null) {
			vis=vcons;
			ist=new Array();
			if (prev!=null) ist.push(prev);
			vis.visible=false;
			vis.input.addEventListener(KeyboardEvent.KEY_DOWN,onKeyboardDownEvent);
			vis.butEnter.addEventListener(MouseEvent.CLICK,onButEnter);
			vis.butClose.addEventListener(MouseEvent.CLICK,onButClose);
			for each(var i in help.a) vis.help.text+=i+'\n';
			// TODO: Stop searching Res on your own.
			for each(i in Res.currentLanguageData.weapon) vis.list1.text+=i.@id+' \t'+i.n[0]+'\n';
			for each(i in Res.currentLanguageData.item) vis.list2.text+=i.@id+' \t'+i.n[0]+'\n';
			for each(i in Res.currentLanguageData.ammo) vis.list2.text+=i.@id+' \t'+i.n[0]+'\n';
			vis.help.visible=vis.list1.visible=vis.list2.visible=false;
		}
		
		public function onKeyboardDownEvent(event:KeyboardEvent):void {
			if (event.keyCode==Keyboard.ENTER) {
				analis();
			}
			if (event.keyCode==Keyboard.END || event.keyCode==Keyboard.ESCAPE) {
				World.w.consolOnOff();
			}
			if (event.keyCode==Keyboard.UP) {
				if (istN>0) istN--;
				if (istN<ist.length) vis.input.text=ist[istN];
			}
			if (event.keyCode==Keyboard.DOWN) {
				if (istN<ist.length) istN++;
				if (istN<ist.length) vis.input.text=ist[istN];
			}
			event.stopPropagation();
		}
		
		public function onButEnter(event:MouseEvent):void {
			analis();
			event.stopPropagation();
		}
		public function onButClose(event:MouseEvent):void {
			World.w.consolOnOff();
			event.stopPropagation();
		}
		
		public var visoff=false;
		
		function off() {
			visoff=true;
		}
		
		private function analis():void
		{
			var str:String=vis.input.text;
			ist.push(str);
			World.w.lastCom=str;
			World.w.saveConfig();
			istN=ist.length;
			vis.input.text='';
			var s:Array=str.split(' ');
			switch (s[0]) 
			{
				case 'clear':
					World.w.cam.dblack=0;
					World.w.gg.controlOn();
					World.w.gg.vis.visible=true;
					World.w.vblack.alpha=0;
					World.w.vblack.visible=false;
					World.w.t_exit=World.w.t_die=0;
					World.w.vgui.visible=World.w.vfon.visible=World.w.visual.visible=true;
					Snd.off=false;
					World.w.pip.noAct=false;
					break;
				case 'redraw':
					World.w.redrawLoc();
					break;
				case 'hud':
					World.w.gui.vis.visible=!World.w.gui.vis.visible;
					break;
				case 'die':
					World.w.gg.damage(10000,Unit.D_INSIDE);
					break;
				case 'hardreset':
					if (World.w.pers.dead)
					{
						World.w.pers.dead=false;
						World.w.t_die=210;
						World.w.gg.anim('die',true);
						off();
					}
					break;
				case 'hardinv':
					World.w.hardInv=!World.w.hardInv;
					break;
				case 'res_watcher':
					World.w.game.triggers['observer']=1;
					break;
				case 'mqt':
					World.w.chitOn=!World.w.chitOn;
					World.w.saveConfig();
					break;
				case '?':
					vis.help.visible=vis.list1.visible=vis.list2.visible=!vis.help.visible;
					break;
				//TODO: Re-implement check that chitOn == true for commands below this point.
				case 'hardcore':
					World.w.pers.hardcore=!World.w.pers.hardcore;
					break;
				case 'testmode':
					World.w.testMode=!World.w.testMode;
					break;
				case 'dif':
					World.w.game.globalDif=s[1];
					if (World.w.game.globalDif<0) World.w.game.globalDif=0;
					if (World.w.game.globalDif>4) World.w.game.globalDif=4;
					World.w.pers.setGlobalDif(World.w.game.globalDif);
					World.w.pers.setParameters();
					break;
				case 'all':
					if (s.length==1)
					{
						World.w.invent.addAll();
						World.w.pers.addSkillPoint(10);
					}
					else if (s[1]=='weapon') World.w.invent.addAllWeapon();
					else if (s[1]=='ammo') World.w.invent.addAllAmmo();
					else if (s[1]=='item') World.w.invent.addAllItem();
					else if (s[1]=='armor') World.w.invent.addAllArmor();
					off();
					break;
				case 'min':
					World.w.invent.addMin();
					off();
					break;
				case 'god':
					World.w.godMode=!World.w.godMode;
					break;
				case 'lvl':
				case 'level':
					World.w.pers.setForcLevel(s[1]);
					break;
				case 'xp':
					World.w.pers.expa(s[1]);
					break;
				case 'sp':
					if (s.length==1) World.w.pers.addSkillPoint();
					else World.w.pers.addSkillPoint(int(s[1]));
					break;
				case 'pp':
					if (s.length==1) World.w.pers.perkPoint++;
					else  World.w.pers.perkPoint+=int(s[1]);
					break;
				case 'weapon':
					if (s.length==2) World.w.invent.addWeapon(s[1]);
					else if (s.length>2) World.w.invent.updWeapon(s[1],1)
					break;
				case 'remw':
					if (s.length==2) World.w.invent.remWeapon(s[1]);
					break;
				case 'armor':
					if (s.length==2) World.w.invent.addArmor(s[1]);
					break;
				case 'money':
					if (s.length==2) World.w.invent.items['money'].kol=int(s[1]);
					break;
				case 'item':
					if (World.w.invent.items[s[1]]==null) return;
					if (s.length==3) World.w.invent.items[s[1]].kol=int(s[2]);
					else if (s.length==2) World.w.invent.items[s[1]].kol++;
					World.w.game.checkQuests(s[1]);
					World.w.pers.setParameters();
					break;
				case 'ammo':
					if (s.length==3) World.w.invent.items[s[1]].kol=int(s[2]);
					break;
				case 'perk':
					if (s.length==2) World.w.pers.addPerk(s[1]);
					break;
				case 'skill':
					if (s.length==3) World.w.pers.setSkill(s[1], s[2]);
					break;
				case 'eff':
					if (s.length==2) World.w.gg.addEffect(s[1]);
					break;
				case 'res':
					if (World.w.gg.effects.length>0) {
						for each (var eff in World.w.gg.effects) eff.unsetEff();
					}
					break;
				case 'repair':
					World.w.gg.currentWeapon.repair(1000000);
					break;
				case 'refill':
					World.w.game.refillVendors();
					break;
				case 'rep':
					if (s.length==2) World.w.pers.rep=int(s[1]);
					break;
				case 'crack':
					if (s.length==2 && World.w.gg.currentWeapon) World.w.gg.currentWeapon.hp=Math.round(World.w.gg.currentWeapon.maxhp*Number(s[1])/100);
					break;
				case 'break':
					if (s.length==2 && World.w.gg.currentArmor) World.w.gg.currentArmor.hp=Math.round(World.w.gg.currentArmor.maxhp*Number(s[1])/100);
					break;
				case 'heal':
					World.w.gg.heal(10000);
					break;
				case 'rad':
					World.w.gg.rad=s[1];
					World.w.gui.setAll();
					break;
				case 'mana':
					World.w.pers.manaHP=int(s[1]);
					World.w.pers.setParameters();
					break;
				case 'check':
					World.w.land.gotoCheckPoint();
					break;
				case 'goto':
					if (s.length==3) World.w.land.gotoXY(s[1],s[2]);
					break;
				case 'map':
					World.w.drawAllMap=!World.w.drawAllMap;
					break;
				case 'black':
					World.w.black=!World.w.black;
					World.w.grafon.visLight.visible=World.w.black && World.w.loc.black;
					break;
				case 'battle':
					World.w.testBattle=!World.w.testBattle;
					break;
				case 'testeff':
					World.w.testEff=!World.w.testEff;
					break;
				case 'testdam':
					World.w.testDam=!World.w.testDam;
					break;
				case 'enemy':
					if (World.w.enemyAct==3) World.w.enemyAct=0;
					else World.w.enemyAct=3;
					break;
				case 'lim':
					if (s.length==2) World.w.land.lootLimit=Number(s[1]);
					break;
				case 'fly':
				case 'port':
				case 'emit':
					World.w.chit=s[0];
					World.w.chitX=s[1];
					break;
				case 'getroom':
					World.w.testLoot=true;
					trace('получено опыта', World.w.loc.getAll());
					World.w.testLoot=false;
					break;
				case 'err':
					World.w.landError=!World.w.landError;
					break;
				case 'getloc':
					World.w.testLoot=true;
					trace('получено опыта', World.w.land.getAll());
					World.w.testLoot=false;	
					break;
				case 'alicorn':
					if (World.w.alicorn) World.w.gg.alicornOff();
					else World.w.gg.alicornOn();
					break;
				case 'st':
					if (s.length==3) World.w.game.triggers[s[1]]=s[2];
					break;
				case 'trigger':
					if (s.length==2) World.w.gui.infoText('trigger',s[1],World.w.game.triggers[s[1]]);
					break;
				case 'triggers':
					if (s.length>1) World.w.gui.infoText('trigger',s[1],World.w.game.triggers[s[1]]);
					else {
						for (var i in World.w.game.triggers)  World.w.gui.infoText('trigger',i,World.w.game.triggers[i]);
					}
					break;
				default:
					off();
					break;
			}

			World.w.gui.setAll();
		}
	}
}

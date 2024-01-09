package fe.loc {
	
	import fe.*;
	import fe.loc.Box;
	import fe.unit.Unit;
	import fe.serv.Script;
	
	//Класс представляет собой набор условий для испытания
	
	public class Probation {
		
		public var xml:XML;
		public var loc:Location;
		public var id:String;
		public var roomId:String;
		public var tip:int=0;
		
		public var nazv:String;
		public var info:String='';
		public var help:String='';
		
		//опции
		public var prizeActive:Boolean=false;	//призовые контейнеры открыты изначально
		
		public var closed:Boolean=false;
		public var active:Boolean=false;
		public var isClose:Boolean=false;
		
		public var onWave:Boolean=false;
		public var nwave:int=0;		//текущий номер волны
		public var maxwave:int=0;	//максимальный номер волны
		public var t_wave:int=0;	//таймер волны
		
		public var nspawn:int=0;	//номер точки спавна
		public var kolEn:int=0;		//всего врагов в волне
		public var killEn:int=0;	//убито врагов в волне

		public var dopOver:Function;
		public var dopOut:Function;
		
		public var alarmScript:Script;
		public var inScript:Script;
		public var outScript:Script;
		public var closeScript:Script;
		
		var beg_t:int=90;
		var next_t:int=300;

		public function Probation(nxml:XML, nloc:Location) {
			xml=nxml;
			loc=nloc;
			id=xml.@id;
			nazv=Res.txt('m',id);
			info='<b>'+nazv+'</b><br><br>'+Res.txt('m',id,1)+'<br>';
			if (Res.txt('m',id,3)!='') help="<span class = 'r3'>"+Res.txt('m',id,3)+"</span>";
			if (!loc.levitOn) info+='<br>'+Res.guiText('restr_levit');
			if (!loc.portOn) info+='<br>'+Res.guiText('restr_port');
			if (!loc.destroyOn) info+='<br>'+Res.guiText('restr_des');
			if (xml.@prize.length()) prizeActive=true;
			if (xml.@tip.length()) tip=xml.@tip;
			if (xml.@close.length()) isClose=true;
			if (tip!=2) loc.petOn=false;
			if (xml.scr.length()) {
				for each(var xl in xml.scr) {
					if (xl.@eve=='alarm') alarmScript=new Script(xl,loc.land);
					if (xl.@eve=='out') outScript=new Script(xl,loc.land);
					if (xl.@eve=='in') inScript=new Script(xl,loc.land);
					if (xl.@eve=='close') closeScript=new Script(xl,loc.land);
				}
			}			
			if (xml.wave.length()) maxwave=xml.wave.length();
		}
		
		//начальная подготовка (один раз)
		public function prepare() {
			for each (var b:Box in loc.objs) {
				if (b.inter && (b.inter.prize && prizeActive)) {
					b.inter.setAct('lock',0);
					b.inter.update();
				}
			}
		}
		
		//вызвать при открывании контейнеров и убийстве мобов
		//если условия выполнены, то закрыть испытание
		public function check() {
			if (closed) return;
			if (checkAllCon()) {
				closeProb();
			}
		}
		
		//проверить все условия закрытия
		function checkAllCon():Boolean {
			for each (var node in xml.con) {
				if ((node.@tip=='box' || node.@tip.length()==0) && node.@uid.length()) { //проверка боксов на открытость
					for each (var b:Box in loc.objs) {
						if (b.uid==node.@uid && b.inter && (!b.inter.open && b.inter.cont!='empty')) return false;
					}
				} else if (node.@tip=='unit') {//проверка юнитов на смерть
					for each (var un:Unit in loc.units) {
						if ((node.@uid.length() && un.uid==node.@uid || node.@qid.length() && un.questId==node.@qid) && un.sost<3) return false;
					}
				} else if (node.@tip=='wave') {//проверка волны
					if (nwave<maxwave || killEn<kolEn) return false;
				}
			}
			return true;
		}
		
		//испытание пройдено
		public function closeProb() {
			closed=true;
			active=false;
			if (World.w.game.triggers['prob_'+id]==null) World.w.game.triggers['prob_'+id]=1;
			else World.w.game.triggers['prob_'+id]++;
			World.w.gui.infoText('closeProb',nazv);
			Snd.ps('quest_ok');
			doorsOnOff(1);
			//окрыть коробки с призами
			if (!prizeActive) {
				for each (var b:Box in loc.objs) {
					if (b.inter && b.inter.prize) {
						b.inter.command('unlock');
					}
				}
			}
			if (closeScript) {
				closeScript.start();
			}
		}
		
		//войти в комнату
		public function over() {
			World.w.gui.messText('', nazv, World.w.gg.Y<300);
			if (!closed) defaultProb();
			if (inScript) {
				inScript.start();
			}
			if (isClose) activateProb();
			loc.broom=false;
		}
		//выйти из комнаты
		public function out() {
			if (closed) {
				loc.openAllPrize();
				loc.broom=true;
			} else {
				if (outScript) outScript.start();
				if (onWave) resetWave();
			}
		}
		
		public function showHelp() {
			var isHelp=(help!='');
			World.w.gui.informText(info+(isHelp?('<br><br>'+Res.guiText('need_help')):''),isHelp);
		}
		
		//активировать испытание
		public function activateProb() {
			if (closed || active || !loc.active) return;
			active=true;
			doorsOnOff(-1);
		}
		
		//вернуть испытание в исходное состояние
		public function defaultProb() {
			active=false;
			doorsOnOff(0);
			/*for each (var un:Unit in loc.units) {
				un.sost=1;
				un.setNull(true);
			}*/
		}

		//-1 - отключить все выходы, 0 - отключить все выходы, кроме основного, 1-включить все выходы
		function doorsOnOff(turn:int) {
			for each (var b:Box in loc.objs) {
				if (b.id=='doorout') {
					if (!b.vis.visible && turn==1 || b.vis.visible && turn==-1) {
						b.inter.shine();
					}
					if (turn==-1 || turn==0 && b.uid!='begin') {
						b.vis.visible=b.shad.visible=false;
						b.inter.active=false;
					}
					if (turn==1 || turn==0 && b.uid=='begin') {
						b.vis.visible=b.shad.visible=true;
						b.inter.active=true;
					}
				}
			}
		}
		
		public function beginWave() {
			if (onWave) return;
			doorsOnOff(-1);
			onWave=true;
			kolEn=killEn=0;
			nwave=0;
			t_wave=beg_t;
		}
		
		function createWave() {
			nspawn=0;
			var w:XML=xml.wave[nwave];
			if (w==null) return;
			for each (var un in w.obj) {
				loc.waveSpawn(un,nspawn);
				kolEn++;
				nspawn++;
			}
			if (w.@t.length()) t_wave=int(w.@t)*World.fps;
			nwave++;
		}
		
		//проверка выполняется при убийстве врага
		public function checkWave(inc:Boolean=false) {
			if (inc) killEn++;
			if (killEn>=kolEn) {
				checkAllCon();
				if (nwave<maxwave) t_wave=next_t;
				else t_wave=0;
			}
		}
		
		function resetWave() {
			onWave=false;
			for each (var un:Unit in loc.units) {
				if (un.wave) {
					un.sost=4;
					un.disabled=true;
				}
			}
			
		}
		
		public function step() {
			if (onWave) {
				if (t_wave>0) t_wave--;
				if (t_wave==1 && nwave<maxwave) createWave();
				if (t_wave%30==1) World.w.gui.messText('',Math.floor(t_wave/30).toString());
			}
		}
		
	}
	
}

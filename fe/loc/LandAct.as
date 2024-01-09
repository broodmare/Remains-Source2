package fe.loc {
	
	//Класс, описывающий местность и активность игрока по отношению к местности
	//Содержится в объекте game
	import fe.*;
	import fe.serv.Script;
	
	public class LandAct {

		public var id:String;
		public var tip:String='';
		public var land:Land;
		public var loaded:Boolean=false;
		
		public var xmlland:XML;
		public var allroom:XML;
		public var begLocX:int=0;	//начальная локация
		public var begLocY:int=0;
		public var mLocX:int=1;		//размер местности
		public var mLocY:int=1;
		
		public var dif:Number=0;	//уровень сложности
		public var biom:int=0;		//встречающиеся типы врагов и других вещей
		public var conf:int=0;		//конфигурация комнат
		public var gameStage:int=0;	//этап сюжета игры, влияет на выпадение лута
		public var lootLimit:Number=0;				//лимит выпадения особых предметов
		public var list:int=0;		//номер в списке
		public var rnd:Boolean=false;
		public var autoLevel:Boolean=false;
		public var test:Boolean=false;
		public var fin:int=-1;
		public var prob:int=0;
		public var exitProb:String;
		public var loadScr:int=-1;
		
		public var 	kolAllProb:int=0;
		public var 	kolClosedProb:int=0;
		
		//настройки
		public var xp:int=100;		//опыт за сбор вещей
		public var rad:Number=0, wrad:Number=1;	//радиоактивность воздуха и воды
		public var wdam:Number=0, wtipdam:int=7;	//урон от воды
		public var tipWater:int=0;				//внешний вид воды
		public var color:String;
		public var sndMusic:String;
		public var postMusic:Boolean=false;		//музыка не пеключается на боевую
		public var fon:String;				//фон неподвижного задника
		public var backwall:String;			//фон задней стены
		public var border:String='A';			//материал бордюра
		public var visMult:Number=1;		//видимость
		public var opacWater:Number=0;		//непрозрачность воды
		public var darkness:int=0;			//затемнение
		
		public var artFire:String;			//триггер арт обстрела
		
		//переменные, подлежащие сохранению
		public var lastCpCode:String;
		public var upStage:Boolean=false;		//увеличить уровень
		public var landStage:int=0;				//максимальный достигнутый уровень местности
		public var access:Boolean=false;
		public var visited:Boolean=false;
		public var passed:Boolean=false;

		
		public function LandAct(land:XML) {
			xmlland=land;
			id=land.@id;
			//nazv=Res.mapText(id);
			//info=Res.mapInfo(id);
			if (land.@tip.length()) tip=land.@tip;
			if (land.@dif.length()) dif=land.@dif;
			if (land.@biom.length()) biom=land.@biom;
			if (land.@conf.length()) conf=land.@conf;
			if (land.@stage.length()) gameStage=land.@stage;
			if (land.@limit.length()) lootLimit=land.@limit;
			if (land.@rnd.length()) rnd=true;
			if (land.@test.length()) test=true;
			if (land.@fin.length()) fin=land.@fin;
			if (land.@autolevel.length()) autoLevel=true;
			if (land.@prob.length()) prob=land.@prob;
			if (land.@list.length()) list=land.@list;
			if (land.@locx.length()) begLocX=land.@locx;
			if (land.@locy.length()) begLocY=land.@locy;
			if (land.@mx.length()) mLocX=land.@mx;
			if (land.@my.length()) mLocY=land.@my;
			if (land.@acc.length()) access=true;
			if (land.@exit.length()) exitProb=land.@exit;
			if (land.@loadscr.length()) loadScr=land.@loadscr;
			if (land.options.length()) {
				if (land.options.@xp.length()) xp=land.options.@xp;
				if (land.options.@color.length()) color=land.options.@color;
				if (land.options.@backwall.length()) backwall=land.options.@backwall;
				if (land.options.@border.length()) border=land.options.@border;
				if (land.options.@fon.length()) fon=land.options.@fon;
				if (land.options.@music.length()) sndMusic=land.options.@music;
				if (land.options.@postmusic.length()) postMusic=true;
				if (land.options.@rad.length()) rad=land.options.@rad;
				if (land.options.@wrad.length()) wrad=land.options.@wrad;
				if (land.options.@wtip.length()) tipWater=land.options.@wtip;
				if (land.options.@wopac.length()) opacWater=land.options.@wopac;
				if (land.options.@wdam.length()) wdam=land.options.@wdam;
				if (land.options.@wtipdam.length()) wtipdam=land.options.@wtipdam;
				if (land.options.@vis.length()) visMult=land.options.@vis;
				if (land.options.@darkness.length()) darkness=land.options.@darkness;
				if (land.options.@art.length()) artFire=land.options.@art;
			}
		}

		//посчитать, сколько испытаний завершено
		public function calcProbs() {
			kolAllProb=0;
			kolClosedProb=0;
			for each(var xml in xmlland.prob) {
				kolAllProb++;
				if (World.w.game.triggers['prob_'+xml.@id]!=null) kolClosedProb++
			}
		}
		
		public function save():Object {
			var obj:Object=new Object();
			obj.cp=lastCpCode;
			obj.st=landStage;
			obj.access=access;
			obj.visited=visited;
			obj.passed=passed;
			return obj;
		}
		public function load(obj:Object) {
			if (obj.cp!=null) lastCpCode=obj.cp;
			if (obj.st!=null) landStage=obj.st;
			if (obj.access!=null && !access) access=obj.access;
			if (obj.visited!=null) visited=obj.visited;
			if (obj.passed!=null) passed=obj.passed;
			return obj;
		}
	}
	
}

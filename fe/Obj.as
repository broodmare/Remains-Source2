package  fe{
	
	//Базовый класс для объектов, взаимодействующих с игроком или миром
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	
	import fe.graph.Emitter;
	import fe.graph.Part;
	import fe.loc.Location;
	import fe.serv.Interact;
	import fe.weapon.Bullet;
	import fe.unit.UnitPlayer;
	import fe.inter.Appear;
	
	public class Obj extends Pt{
		public var code:String;		//идивидуальный код
		public var uid:String;		//уникальный идентификатор, служащий для доступа скрипта к объекту
		
		public var prior:Number=1;
		public var scX:Number=10, scY:Number=10, storona:int=1;	//размеры
		public var rasst2:Number=0;	//расстояние до ГГ в квадрате
		public var massa:Number=1;
		public var levit:int=0;
		public var levitPoss:Boolean=true;	//возможность перемещать с помощью левитации
		public var fracLevit:int=0; //был левитирован
		public var radioactiv:Number=0;	//радиоактивность
		public var radrad:Number=250;	//радиус радиоактивности
		public var radtip:int=0;		//0 - радиация, 1 - яд, 2 - розовое облако, 3 - смерть
		public var warn:int=0;			//цвет вспл. подсказки
		public var nazv:String='';
		
		public var inter:Interact;
		public var dist2:Number=0;	//расстояние до ГГ в квадрате
		public var X1:Number, X2:Number, Y1:Number, Y2:Number;
		
		public var onCursor:Number=0;
		//цветовой фильтр
		
		public static var nullTransfom:ColorTransform=new ColorTransform();
		public var cTransform:ColorTransform=nullTransfom;
		
		public function Obj() {
			// constructor code
		}
		
		public override function remVisual() {
			super.remVisual(); 
			onCursor=0;
		}
		public function setVisState(s:String) {
		}
		
		public function die(sposob:int=0) {
		}
		
		public function checkStay() {
		}
		
		public function getRasst2(obj:Obj=null):Number {
			if (obj==null) obj=World.w.gg;
			var nx=obj.X-X;
			var ny=obj.Y-obj.scY/2-Y+scY/2;
			if (obj==World.w.gg) ny=obj.Y-obj.scY*0.75-Y+scY/2;
			rasst2=nx*nx+ny*ny;
			if (isNaN(rasst2)) rasst2=-1;
			return rasst2;
		}
		
		public function save():Object {
			return null;
		}
		
		//команда скрипта
		public function command(com:String, val:String=null) {
			if (com=='show') {
				World.w.cam.showOn=true;
				World.w.cam.showX=X;
				World.w.cam.showY=Y;
			}
		}
		
		//воздействие на гг
		public function ggModum() {
			if (loc==World.w.gg.loc && radioactiv && rasst2>=0 && rasst2<radrad*radrad) {
				World.w.gg.raddamage((radrad-Math.sqrt(rasst2))/radrad,radioactiv,radtip);
			}
		}
		
		public override function err():String {
			if (loc) loc.remObj(this);
			return 'Error obj '+nazv;
		}
		
		public function norma(p:Object,mr:Number) {
			if (p.x*p.x+p.y*p.y>mr*mr) {
				var nr=Math.sqrt(p.x*p.x+p.y*p.y);
				p.x*=mr/nr;
				p.y*=mr/nr;
				//trace(p.x,p.y);
			}
		}
		
		//принудительное движение
		public function bindMove(nx:Number, ny:Number, ox:Number=-1, oy:Number=-1) {
			X=nx, Y=ny;
			X1=X-scX/2, X2=X+scX/2, Y1=Y-scY, Y2=Y;
		}
		
		//копирование состояния в другой объект
		public function copy(un:Obj) {
			un.X=X, un.Y=Y, un.scX=scX, un.scY=scY;
			un.Y1=Y1, un.Y2=Y2, un.X1=X1, un.X2=X2;
			un.storona=storona;
		}
		
		//проверка на попадание пули, наносится урон, если пуля попала, возвращает -1 если не попала
		public function udarBullet(bul:Bullet, sposob:int=0):int {
			return -1;
		}
		
		//проверка пересечения с другим объектом
		public function areaTest(obj:Obj):Boolean {
			if (obj==null || obj.X1>=X2 || obj.X2<=X1 || obj.Y1>=Y2 || obj.Y2<=Y1) return false;
			else return true;
		}
		
		public function locout() {
		}
		
		public static function setArmor(m:MovieClip) {
			var aid:String='';
			if (World.w) {
				if (World.w.pip && World.w.pip.active || World.w.mmArmor && World.w.allStat==0) aid=World.w.pip.ArmorId;
				else if (World.w.armorWork!='') aid=World.w.armorWork;
				else if (World.w.alicorn) aid='ali';
				else aid=Appear.ggArmorId;
			}
			if (aid=='') {
				m.gotoAndStop(1);
				return;
			}
			try {
				m.gotoAndStop(aid);
			} catch (err) {
				m.gotoAndStop(1);
			}
		}
		
		public static function setMorda(m:MovieClip, c:int) {
			if (World.w && World.w.gg) m.gotoAndStop(World.w.gg.mordaN);
			else m.gotoAndStop(1);
		}
		
		public static function setColor(m:MovieClip, c:int) {
			if (Appear.transp) {
				m.visible=false;
				//m.transform.colorTransform=Appear.trBlack;
				return;
			}
			if (c==0) m.transform.colorTransform=Appear.trFur;
			if (c==1) m.transform.colorTransform=Appear.trHair;
			if (c==2) {
				if (Appear.visHair1) {
					m.visible=true;
					m.transform.colorTransform=Appear.trHair1;
				} else m.visible=false;
			}
			if (c==3) m.transform.colorTransform=Appear.trEye;
			if (c==4) m.transform.colorTransform=Appear.trMagic;
		}
		
		public static function setVisible(m:MovieClip) {
			var h:int=0;
			if (World.w && World.w.pip && World.w.pip.active) h=World.w.pip.hideMane;
			else h=Appear.hideMane;
			m.visible=(h==0);
		}
		
		public static function setEye(m:MovieClip) {
			m.gotoAndStop(Appear.fEye);
		}
		public static function setHair(m:MovieClip) {
			m.gotoAndStop(Appear.fHair);
		}

	}
	
}

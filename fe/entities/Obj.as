package  fe.entities
{
	//Базовый класс для объектов, взаимодействующих с игроком или миром
	import flash.display.MovieClip;
	import flash.geom.ColorTransform;
	
	import fe.World;
	import fe.serv.Interact;
	import fe.projectile.Bullet;
	import fe.inter.Appear;
	
	public class Obj extends Entity {
		public var code:String;		// [Individual code]
		public var uid:String;		// [Unique identifier used for script access to the object]
		
		public var prior:Number = 1;

		public var objectWidth:Number = 10;		// Sprite Width
		public var objectHeight:Number = 10;	// Sprite Height
		public var storona:int = 1;				// Sprite Facing (Left/Right)

		public var rasst2:Number=0;				// Distance to player squared
		public var massa:Number=1;
		public var levit:int=0;
		public var levitPoss:Boolean=true;		//возможность перемещать с помощью левитации
		public var fracLevit:int=0;				//был левитирован
		public var radioactiv:Number=0;			//радиоактивность
		public var radrad:Number=250;			//радиус радиоактивности
		public var radtip:int=0;				//0 - радиация, 1 - яд, 2 - розовое облако, 3 - смерть
		public var warn:int=0;					//цвет вспл. подсказки
		
		public var nazv:String = '';			// Name
		
		public var inter:Interact;
		
		// Boundaries of an object
		public var topBound:Number;
		public var bottomBound:Number;
		public var leftBound:Number;
		public var rightBound:Number;

		
		public var onCursor:Number=0;
		//цветовой фильтр
		
		public static var nullTransfom:ColorTransform=new ColorTransform();
		public var cTransform:ColorTransform=nullTransfom;
		
		// Constructor
		public function Obj() {
			
		}


		public function centerObj():void {
			topBound	= coordinates.Y - objectHeight;
            bottomBound	= coordinates.Y;
            leftBound	= coordinates.X - objectWidth / 2;
            rightBound	= coordinates.X + objectWidth / 2;
        }

		public function centerObjHorizontally():void {
			leftBound = coordinates.X - objectWidth / 2;
			rightBound = coordinates.X + objectWidth / 2;
		}

		public function flattenObj():void {
			topBound = coordinates.Y - objectHeight;
			bottomBound = coordinates.Y;
		}

		public function get leftBoundToCenter():Number {
			return coordinates.X + objectWidth / 2;
		}
		public function get rightBoundToCenter():Number {
			return coordinates.X - objectWidth / 2;
		}
		public function get topBoundToCenter():Number {
			return coordinates.Y - this.halfHeight;
		}
		public function get bottomBoundToCenter():Number {
			return coordinates.Y + this.halfHeight;
		}
		public function get halfHeight():Number {
			return objectHeight / 2;
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
			if (obj == null) obj = World.w.gg;
			var nx = obj.coordinates.X - coordinates.X;
			var ny = obj.coordinates.Y - obj.objectHeight / 2 - coordinates.Y + objectHeight / 2;
			if (obj == World.w.gg) ny = obj.coordinates.Y - obj.objectHeight * 0.75 - coordinates.Y + objectHeight / 2;
			rasst2 = nx * nx + ny * ny;
			if (isNaN(rasst2)) rasst2 = -1;
			return rasst2;
		}
		
		public function save():Object {
			return null;
		}
		
		//команда скрипта
		public function command(com:String, val:String=null) {
			if (com == 'show')
			{
				World.w.cam.showOn	= true;
				World.w.cam.showX	= coordinates.X;
				World.w.cam.showY	= coordinates.Y;
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
				p.x *= mr / nr;
				p.y *= mr / nr;
			}
		}
		
		//принудительное движение
		public function bindMove(nx:Number, ny:Number, ox:Number=-1, oy:Number=-1) {
			coordinates.X = nx;
			coordinates.Y = ny;
			centerObj();
		}
		
		//копирование состояния в другой объект
		public function copy(un:Obj) {
			un.coordinates = coordinates;
			un.objectWidth = objectWidth; 
			un.objectHeight = objectHeight;
			un.topBound = topBound;
			un.bottomBound = bottomBound;
			un.leftBound = leftBound;
			un.rightBound = rightBound;
			un.storona = storona;
		}
		
		//проверка на попадание пули, наносится урон, если пуля попала, возвращает -1 если не попала
		public function udarBullet(bul:Bullet, sposob:int=0):int {
			return -1;
		}
		
		//проверка пересечения с другим объектом
		public function areaTest(obj:Obj):Boolean {
			if (obj == null || obj.leftBound >= rightBound || obj.rightBound <= leftBound || obj.topBound >= bottomBound || obj.bottomBound <= topBound) return false;
			else return true;
		}
		
		public function locout() {

		}
		
		public static function setArmor(m:MovieClip)
		{
			var aid:String = '';
			if (World.w) {
				if (World.w.pip && World.w.pip.active || World.w.mmArmor && World.w.allStat == 0) aid = World.w.pip.armorID;
				else if (World.w.armorWork != '') aid = World.w.armorWork;
				else if (World.w.alicorn) aid = 'ali';
				else aid = Appear.ggArmorId;
			}
			if (aid == '') {
				m.gotoAndStop(1);
				return;
			}
			
			try {
				m.gotoAndStop(aid);
			}
			catch (err) {
				//trace('ERROR: (00:51) - Could not apply armor: "' + aid + '"!');
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
				return;
			}
			if (c == 0) m.transform.colorTransform=Appear.trFur;
			if (c == 1) m.transform.colorTransform=Appear.trHair;
			if (c == 2) {
				if (Appear.visHair1) {
					m.visible=true;
					m.transform.colorTransform=Appear.trHair1;
				} else m.visible=false;
			}
			if (c==3) m.transform.colorTransform=Appear.trEye;
			if (c==4) m.transform.colorTransform=Appear.trMagic;
		}
		
		public static function setVisible(m:MovieClip) {
			var h:int;
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
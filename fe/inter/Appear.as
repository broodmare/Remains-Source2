package fe.inter {
	
	import fl.controls.ColorPicker;
	import fl.events.ColorPickerEvent;
	import fl.events.SliderEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import fl.motion.Color;
	import flash.display.MovieClip;
	import fe.*;
	import flash.display.DisplayObject;
	
	//Настройки внешнего вида персонажа
	
	public class Appear {
		
		public var vis:MovieClip;
		var col:Color=new Color;
		
		public var funOk:Function;
		public var funCancel:Function;
		
		public var cFur:uint=0xA3A3A3;
		public var cHair:uint=0x854609;
		public var cHair1:uint=0xFFFFFF;
		public var cEye:uint=0x16F343;
		public var cMagic:uint=0x00FF00;
		var tFur:uint, tHair:uint, tHair1:uint, tEye:uint, tMagic:uint;

		public static var trFur:ColorTransform = new ColorTransform(0.8,0.8,0.8);
		public static var trHair:ColorTransform = new ColorTransform(0xA3/0xFF,0x56/0xFF,0x0B/0xFF);
		public static var trHair1:ColorTransform = new ColorTransform(1,1,1);
		public static var trEye:ColorTransform = new ColorTransform(0,0.9,0);
		public static var trMagic:ColorTransform = new ColorTransform(0,1,0);
		
		public static var trBlack:ColorTransform = new ColorTransform(0,0,0,0.2,0,255,100);
		
		public static var visHair1:Boolean=false;
		public static var fEye:int=1, maxEye:int=6;
		public static var fHair:int=1, maxHair:int=5;

		public static var ggArmorId:String='';	//надетая броня
		public static var hideMane:int=0;	//скрыть волосы
		public static var transp:Boolean=false;

		var clist:Array=['Fur','Hair','Hair1','Eye','Magic'];
		
		var tek:String='Fur';
		
		var temp:Object;
		var def:Object;
		public var loadObj:Object;
		
		
		public var saved:Object;

		public function Appear() {
			vis=new dialVid();
			for each(var l in clist) this['t'+l]=this['c'+l];
			def=save();
			setColors();
			setTransforms();
			setColor('Fur',cFur);
		}
		
		//надписи
		public function setLang() {
			vis.butOk.text.text='OK';
			vis.butCancel.text.text=Res.guiText('cancel');
			vis.butDef.text.text=Res.pipText('default');
			vis.title.text=Res.guiText('butvid');
			vis.tFur.text=Res.guiText('vidfur');
			vis.tHair.text=Res.guiText('vidhair');
			vis.tHair1.text=Res.guiText('vidhair1');
			vis.tEye.text=Res.guiText('videye');
			vis.tMagic.text=Res.guiText('vidmagic');
		}
		
		//присоединить диалоговое окно
		public function attach(mm:MovieClip, fo:Function, fc:Function) {
			mm.addChild(vis);
			vis.fon.visible=true;
			temp=save();
			funcOn();
			funOk=fo;
			funCancel=fc;
			setColors();
			vis.pers.gotoAndStop(2);
			vis.pers.gotoAndStop(1);
		}
		//отсоединить диалоговое окно
		public function detach() {
			if (vis.parent) vis.parent.removeChild(vis);
			funcOff();
			funOk=null;
			funCancel=null;
			if (saved!=null) {
				load(saved);
				saved=null;
			}
		}
		
		public function funcOn() {
			vis.butOk.addEventListener(MouseEvent.CLICK, buttonOk);
			vis.butCancel.addEventListener(MouseEvent.CLICK, buttonCancel);
			vis.butDef.addEventListener(MouseEvent.CLICK, buttonDef);
			for each(var l in clist) {
				vis['color'+l].addEventListener(ColorPickerEvent.CHANGE, changeHandler);
				vis['color'+l].addEventListener(Event.OPEN, openHandler);
			}
			vis.slRed.addEventListener(SliderEvent.THUMB_DRAG, chColor);
			vis.slGreen.addEventListener(SliderEvent.THUMB_DRAG, chColor);
			vis.slBlue.addEventListener(SliderEvent.THUMB_DRAG, chColor);
			vis.checkHair1.addEventListener(ColorPickerEvent.CHANGE, changeHair1);
			vis.b1Eye.addEventListener(MouseEvent.CLICK, chBut);
			vis.b2Eye.addEventListener(MouseEvent.CLICK, chBut);
			vis.b1Hair.addEventListener(MouseEvent.CLICK, chBut);
			vis.b2Hair.addEventListener(MouseEvent.CLICK, chBut);
		}
		public function funcOff() {
			if (!vis.butOk.hasEventListener(MouseEvent.CLICK)) return;
			vis.butOk.removeEventListener(MouseEvent.CLICK, buttonOk);
			vis.butCancel.removeEventListener(MouseEvent.CLICK, buttonCancel);
			vis.butDef.removeEventListener(MouseEvent.CLICK, buttonDef);
			for each(var l in clist) {
				vis['color'+l].removeEventListener(ColorPickerEvent.CHANGE, changeHandler);
				vis['color'+l].removeEventListener(Event.OPEN, openHandler);
			}
			vis.slRed.removeEventListener(SliderEvent.THUMB_DRAG, chColor);
			vis.slGreen.removeEventListener(SliderEvent.THUMB_DRAG, chColor);
			vis.slBlue.removeEventListener(SliderEvent.THUMB_DRAG, chColor);
			vis.checkHair1.removeEventListener(ColorPickerEvent.CHANGE, changeHair1);
			vis.b1Eye.removeEventListener(MouseEvent.CLICK, chBut);
			vis.b2Eye.removeEventListener(MouseEvent.CLICK, chBut);
			vis.b1Hair.removeEventListener(MouseEvent.CLICK, chBut);
			vis.b2Hair.removeEventListener(MouseEvent.CLICK, chBut);
		}
		
		//нажать кнопку ОК
		public function buttonOk(event:MouseEvent) {
			if (funOk) funOk();
			World.w.saveConfig();
		}
		//нажать кнопку отмена
		public function buttonCancel(event:MouseEvent) {
			load(temp);
			setTransforms();
			setColors();
			vis.pers.gotoAndStop(2);
			vis.pers.gotoAndStop(1);
			if (funCancel) funCancel();
		}
		//нажать кнопку def
		public function buttonDef(event:MouseEvent) {
			load(def);
			setTransforms();
			setColors();
			vis.pers.gotoAndStop(2);
			vis.pers.gotoAndStop(1);
		}
		
		//установить все колорпикеры в соответствие с цветами
		function setColors() {
			for each(var l in clist) vis['color'+l].selectedColor=this['c'+l];
			vis.checkHair1.selected=visHair1;
		}
		//преобразовать все цвета в трансформы
		public function setTransforms() {
			for each(var l in clist) colorToTransform(this['c'+l],Appear['tr'+l]);
		}
		
		
		public function save():Object {
			if (saved!=null) {
				load(saved);
			}
			var obj:Object=new Object;
			for each(var l in clist) {
				obj['c'+l]=this['c'+l];
			}
			obj.visHair1=visHair1;
			obj.fEye=fEye;
			obj.fHair=fHair;
			return obj;
		}
		
		//сохранить при вызове страницы сохранения или загрузки
		public function saveOst() {
			if (saved==null) saved=save();
		}
		
		public function load(obj:Object) {
			if (obj==null) {
				for each(var l in clist) this['c'+l]=this['t'+l];
				visHair1=false;
				fEye=1;
				fHair=1;
			} else {
				for each(var l in clist) this['c'+l]=obj['c'+l];
				visHair1=obj.visHair1;
				fEye=obj.fEye;
				fHair=obj.fHair;
			}
			setTransforms();
		}
		
		//преобразовать цвет в трансформ
		function colorToTransform(c:uint, ct:ColorTransform) {
			var colMax:int=290, colSd:Number=(290-255)/255;
			col.tintMultiplier=1;
			col.tintColor=c;
			ct.redMultiplier=col.redOffset/colMax+colSd;
			ct.greenMultiplier=col.greenOffset/colMax+colSd;
			ct.blueMultiplier=col.blueOffset/colMax+colSd;
			vis.slRed.value=col.redOffset;
			vis.slGreen.value=col.greenOffset;
			vis.slBlue.value=col.blueOffset;
			setRGB();
		}
		
		//надписи
		function setRGB() {
			vis.nRed.text='R:'+col.redOffset;
			vis.nGreen.text='G:'+col.greenOffset;
			vis.nBlue.text='B:'+col.blueOffset;
		}
		
		//событие ползунков
		function chColor(event:SliderEvent):void {
			col.redOffset=vis.slRed.value;
			col.greenOffset=vis.slGreen.value;
			col.blueOffset=vis.slBlue.value;
			setRGB();
			setColor(tek,col.color);
		}
		
		//события колорпикеров
		function changeHandler(event:ColorPickerEvent):void {
			var myCP:ColorPicker = event.currentTarget as ColorPicker;
			var myCT:ColorTransform;
			var nam=myCP.name.substr(5);
			tek=nam;
			setColor(nam,myCP.selectedColor);
		}
		function openHandler(event:Event):void {
			var myCP:ColorPicker = event.currentTarget as ColorPicker;
			var nam=myCP.name.substr(5);
			tek=nam;
			setColor(nam,myCP.selectedColor);
		}
		
		//вкл/выкл второй цвет
		function changeHair1(e:Event):void {
			visHair1=vis.checkHair1.selected;
			vis.pers.gotoAndStop(2);
			vis.pers.gotoAndStop(1);
		}
		//кнопки выбора вариантов
		public function chBut(event:MouseEvent) {
			var nam:String=(event.currentTarget as flash.display.DisplayObject).name;
			if (nam=='b1Eye') {
				fEye--;
				if (fEye<=0) fEye=maxEye;
			}
			if (nam=='b2Eye') {
				fEye++;
				if (fEye>maxEye) fEye=1;
			}
			if (nam=='b1Hair') {
				fHair--;
				if (fHair<=0) fHair=maxHair;
			}
			if (nam=='b2Hair') {
				fHair++;
				if (fHair>maxHair) fHair=1;
			}
			vis.pers.gotoAndStop(2);
			vis.pers.gotoAndStop(1);
		}
		
		//установить цвет модельки
		function setColor(nam:String, c:uint) {
			this['c'+nam]=c;
			colorToTransform(this['c'+nam],Appear['tr'+nam]);
			vis['color'+nam].selectedColor=c;
			vis.pers.gotoAndStop(2);
			vis.pers.gotoAndStop(1);
		}
		
		/*function encode():String {
			return cFur+'|'+cHair+'|'+cHair1+'|'+cEye+'|'+cMagic+'|'+fEye+'|'+(visHair1?1:0);
		}
		function decode(s:String) {
			return cFur+'|'+cHair+'|'+cHair1+'|'+cEye+'|'+cMagic+'|'+fEye+'|'+(visHair1?1:0);
		}*/
		
	}
	
}

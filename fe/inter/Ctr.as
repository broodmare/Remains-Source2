package fe.inter {
	
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.display.StageDisplayState;
	
	import fe.World;
	import fe.Res;
	
	public class Ctr {
		
/*		public var keyIds:Array=['keyLeft','keyRight','keyBeUp','keySit','keyJump','keyRun',
			'keyAttack','keyPunch','keyReload','keyGrenad','keyScrDown','keyScrUp',
			'keyAction','keyCrack','keyTele','keyPip','keySats','keyItem','keyPotion','keyItemPrev','keyItemNext',
			'keyLook','keyZoom','keyFull'];*/
		public var keyXML:XML=<keys>
			<key id='keyLeft' def={Keyboard.A}/>
			<key id='keyRight' def={Keyboard.D}/>
			<key id='keyBeUp' def={Keyboard.W}/>
			<key id='keySit' def={Keyboard.S}/>
			<key id='keyJump' def={Keyboard.SPACE}/>
			<key id='keyRun' def={Keyboard.SHIFT}/>
			<key id='keyDash'/>
			
			<key id='keyAttack' def='lmb'/>
			<key id='keyPunch' def={Keyboard.F}/>
			<key id='keyReload' def={Keyboard.R}/>
			<key id='keyGrenad' def={Keyboard.G}/>
			<key id='keyMagic' def={Keyboard.T}/>
			<key id='keyDef' def={Keyboard.C}/>
			<key id='keyPet' def={Keyboard.U}/>
			<key id='keyAction' def={Keyboard.E}/>
			<key id='keyCrack' def={Keyboard.Y}/>
			<key id='keyTele' def={Keyboard.Q} alt='rmb'/>
			<key id='keyPip' def={Keyboard.TAB}/>
			<key id='keyArmor' def={Keyboard.N}/>
			<key id='keySats' def={Keyboard.V} alt='mmb'/>

			<key id='keyInvent' def={Keyboard.I}/>
			<key id='keyStatus' def={Keyboard.O}/>
			<key id='keySkills' def={Keyboard.K}/>
			<key id='keyMed' def={Keyboard.L}/>
			<key id='keyMap' def={Keyboard.M}/>
			<key id='keyQuest' def={Keyboard.J}/>
			<key id='keyItem' def={Keyboard.P}/>
			<key id='keyPot' def={Keyboard.H}/>
			<key id='keyMana' def={Keyboard.B}/>
			<key id='keyItemNext' def={Keyboard.RIGHTBRACKET}/>
			<key id='keyItemPrev' def={Keyboard.LEFTBRACKET}/>
			<key id='keyScrDown' def='scrd'/>
			<key id='keyScrUp' def='scru'/>
			<key id='keyWeapon1' def={Keyboard.NUMBER_1}/>
			<key id='keyWeapon2' def={Keyboard.NUMBER_2}/>
			<key id='keyWeapon3' def={Keyboard.NUMBER_3}/>
			<key id='keyWeapon4' def={Keyboard.NUMBER_4}/>
			<key id='keyWeapon5' def={Keyboard.NUMBER_5}/>
			<key id='keyWeapon6' def={Keyboard.NUMBER_6}/>
			<key id='keyWeapon7' def={Keyboard.NUMBER_7}/>
			<key id='keyWeapon8' def={Keyboard.NUMBER_8}/>
			<key id='keyWeapon9' def={Keyboard.NUMBER_9}/>
			<key id='keyWeapon10' def={Keyboard.NUMBER_0}/>
			<key id='keyWeapon11' def={Keyboard.MINUS}/>
			<key id='keyWeapon12' def={Keyboard.EQUAL}/>
			<key id='keySpell1' def={Keyboard.Z}/>
			<key id='keySpell2' def={Keyboard.X}/>
			<key id='keySpell3'/>
			<key id='keySpell4'/>
			
			<key id='keyLook' def={Keyboard.SEMICOLON}/>
			<key id='keyZoom' def={Keyboard.QUOTE}/>
			<key id='keyFull' def={Keyboard.ENTER}/>
		</keys>;
		
		var keyDowns:Vector.<Boolean>;	//нажатость
		var keyNames:Vector.<String>;	//названия клавиш по кодам
		var mbNames:Array;	//названия кнопок мыши
		var keys:Array;		//объекты по кодам клавиш
		var keyObj:Array;	//объекты по порядку
		var keyIds:Array;	//объекты по ид действия

		public var keyLeft:Boolean=false;
		public var keyRight:Boolean=false;
		public var keyDubLeft:Boolean=false;
		public var keyDubRight:Boolean=false;
		public var keyJump:Boolean=false;
		public var keySit:Boolean=false;
		public var keyDubSit:Boolean=false;
		public var keyBeUp:Boolean=false;
		public var keyRun:Boolean=false;
		
		public var keyAttack:Boolean=false;
		public var keyPunch:Boolean=false;
		public var keyReload:Boolean=false;
		public var keyGrenad:Boolean=false;
		public var keyMagic:Boolean=false;
		public var keyDef:Boolean=false;
		public var keyPet:Boolean=false;
		public var keyAction:Boolean=false;
		public var keyCrack:Boolean=false;
		public var keyTele:Boolean=false;
		public var keyPip:Boolean=false;
		public var keySats:Boolean=false;
		
		
		public var keyFly:Boolean=false;
		
		public var keyLook:Boolean=false;
		public var keyZoom:Boolean=false;
		public var keyFull:Boolean=false;
		
		public var keyItem:Boolean=false,keyPot:Boolean=false,keyMana:Boolean=false,keyItemPrev:Boolean=false,keyItemNext:Boolean=false;
		public var keyInvent:Boolean=false, keyStatus:Boolean=false, keySkills:Boolean=false, keyMed:Boolean=false, keyMap:Boolean=false, keyQuest:Boolean=false;
		public var keyWeapon1:Boolean=false;
		public var keyWeapon2:Boolean=false;
		public var keyWeapon3:Boolean=false;
		public var keyWeapon4:Boolean=false;
		public var keyWeapon5:Boolean=false;
		public var keyWeapon6:Boolean=false;
		public var keyWeapon7:Boolean=false;
		public var keyWeapon8:Boolean=false;
		public var keyWeapon9:Boolean=false;
		public var keyWeapon10:Boolean=false;
		public var keyWeapon11:Boolean=false;
		public var keyWeapon12:Boolean=false;
		public var keyScrDown:Boolean=false, keyScrUp:Boolean=false;
		public var rbmDbl:Boolean=false;
		
		public var keyDash:Boolean=false, keyArmor:Boolean=false;
		public var keySpell1:Boolean=false, keySpell2:Boolean=false, keySpell3:Boolean=false, keySpell4:Boolean=false;
		
		public var keyTest1:Boolean=false;
		public var keyTest2:Boolean=false;
		
		public var keyboardMode:int=0;
		
		const dubleT=5;		
		private var kR_t:int=10, kL_t:int=10, kD_t:int=10, scr_t:int=0;
		
		public var active:Boolean=true;
		
		var KeyboardA=Keyboard.A, KeyboardZ=Keyboard.Z, KeyboardW=Keyboard.W, KeyboardQ=Keyboard.Q;
		
		
		public var setkeyOn:Boolean=false;
		public var setkeyRequest=null;
		var setkeyFun:Function;
		
		public var keyPressed:Boolean=false;
		public var keyPressed2:Boolean=false;
		
		public function clearAll() {
			keyLeft=keyRight=keyJump=keyAttack=keySit=keyBeUp=keyPunch=keyDash=keyAttack=keyPot=keyMana=keyGrenad=keyMagic=keyDef=keyPet=keyReload=keyTele=keyScrDown=keyScrUp=keyArmor=false;
			keyInvent=keyStatus=keySkills=keyMed=keyMap=keyQuest=false;
		}
		
		public function setKeyboard() {
			if (keyboardMode==0) {
				KeyboardA=Keyboard.A, KeyboardZ=Keyboard.Z, KeyboardW=Keyboard.W, KeyboardQ=Keyboard.Q;
			}
			if (keyboardMode==1) {
				KeyboardA=Keyboard.Q, KeyboardZ=Keyboard.W, KeyboardW=Keyboard.Z, KeyboardQ=Keyboard.A;
			}
		}
		
		public function Ctr(loadObj=null) {
			keyNames=new Vector.<String>(256);
			keyDowns=new Vector.<Boolean>(256);
			mbNames=new Array();
			for (var i=Keyboard.A; i<=Keyboard.Z; i++) {
				keyNames[i]=String.fromCharCode(65+i-Keyboard.A);
			}
			for (i=Keyboard.NUMBER_0; i<=Keyboard.NUMBER_9; i++) {
				keyNames[i]=(i-Keyboard.NUMBER_0).toString();
			}
			for (i=Keyboard.NUMPAD_0; i<=Keyboard.NUMPAD_9; i++) {
				keyNames[i]='Numpad '+(i-Keyboard.NUMPAD_0);
			}
			for (i=Keyboard.F1; i<=Keyboard.F12; i++) {
				keyNames[i]='F'+(i-Keyboard.F1+1);
			}
			keyNames[Keyboard.UP]='up';
			keyNames[Keyboard.DOWN]='down';
			keyNames[Keyboard.LEFT]='left';
			keyNames[Keyboard.RIGHT]='right';
			keyNames[Keyboard.SPACE]="Spacebar";
			
			keyNames[Keyboard.END]='End';
			keyNames[Keyboard.INSERT]='Insert';
			keyNames[Keyboard.HOME]='Home';
			keyNames[Keyboard.DELETE]='Delete';
			keyNames[Keyboard.PAGE_DOWN]='Page Down';
			keyNames[Keyboard.PAGE_UP]='Page Up';
			
			keyNames[Keyboard.ENTER]='Enter';
			keyNames[Keyboard.ESCAPE]='Esc';
			keyNames[Keyboard.BACKSPACE]='Backspace';
			keyNames[Keyboard.CAPS_LOCK]='Caps Lock';
			keyNames[Keyboard.CONTROL]='Ctrl';
			keyNames[Keyboard.SHIFT]="Shift";
			keyNames[Keyboard.ALTERNATE]='Alt';
			keyNames[Keyboard.TAB]="Tab";
			
			keyNames[Keyboard.COMMA]=',';
			keyNames[Keyboard.MINUS]='-';
			keyNames[Keyboard.EQUAL]='=';
			keyNames[Keyboard.SLASH]='/';
			keyNames[Keyboard.QUOTE]="'";
			keyNames[Keyboard.SEMICOLON]=";";
			keyNames[Keyboard.PERIOD]=".";
			keyNames[Keyboard.BACKQUOTE]='`';
			keyNames[Keyboard.BACKSLASH]='\\';
			keyNames[Keyboard.LEFTBRACKET]="{";
			keyNames[Keyboard.RIGHTBRACKET]="}";
			
			keyNames[Keyboard.NUMPAD_ADD]="Numpad +";
			keyNames[Keyboard.NUMPAD_DECIMAL]="Numpad .";
			keyNames[Keyboard.NUMPAD_DIVIDE]="Numpad /";
			keyNames[Keyboard.NUMPAD_MULTIPLY]="Numpad *";
			keyNames[Keyboard.NUMPAD_SUBTRACT]="Numpad -";
			keyNames[Keyboard.NUMPAD_ENTER]="Numpad Enter";
			
			mbNames['lmb']=Res.txt('k','lmb');
			mbNames['rmb']=Res.txt('k','rmb');
			mbNames['mmb']=Res.txt('k','mmb');
			mbNames['scrd']=Res.txt('k','scrd');
			mbNames['scru']=Res.txt('k','scru');
			
			gotoDef();
			if (loadObj) load(loadObj);
			updateKeys();
			
			
			World.w.swfStage.addEventListener(MouseEvent.MIDDLE_MOUSE_DOWN,onMiddleMouseDown1);
			World.w.swfStage.addEventListener(MouseEvent.MIDDLE_MOUSE_UP,onMiddleMouseUp1);
			World.w.swfStage.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN,onRightMouseDown1);
			World.w.swfStage.addEventListener(MouseEvent.RIGHT_MOUSE_UP,onRightMouseUp1);
			World.w.swfStage.addEventListener(MouseEvent.RIGHT_CLICK, onRightMouse);
			World.w.swfStage.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown1);
			World.w.swfStage.addEventListener(MouseEvent.MOUSE_UP,onMouseUp1);
			World.w.swfStage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove1);
			World.w.swfStage.addEventListener(MouseEvent.MOUSE_WHEEL,onMouseWheel1);
			World.w.swfStage.addEventListener(KeyboardEvent.KEY_DOWN,onKeyboardDownEvent);
			World.w.swfStage.addEventListener(KeyboardEvent.KEY_UP,onKeyboardUpEvent);
		}
		
		public function step() {
			if (kR_t<100) kR_t++;
			if (kL_t<100) kL_t++;
			if (kD_t<100) kD_t++;
			if (scr_t>0) {
				scr_t--;
				if (scr_t==0) {
					if (keys['scrd']) this[keys['scrd'].id]=false;
					if (keys['scru']) this[keys['scru'].id]=false;
				}
			}
		}
		
		//создать ассоциации между объектами действий и клавиш
		public function updateKeys() {
			keys=new Array();
			for each(var obj in keyObj) {
				if (obj.a1) keys[obj.a1]=obj;
				if (obj.a2) keys[obj.a2]=obj;
			}
		}
		
		//настройки по умолчанию
		public function gotoDef() {
			keyObj=new Array();
			keyIds=new Array();
			for (var i in keyXML.key) {
				var obj:Object={id:keyXML.key[i].@id};
				if (keyXML.key[i].@def.length()) obj.a1=keyXML.key[i].@def.toString();
				if (keyXML.key[i].@alt.length()) obj.a2=keyXML.key[i].@alt.toString();
				keyObj.push(obj);
				keyIds[keyXML.key[i].@id]=obj;
			}
		}
		
		public function save():* {
			var arr:Array=new Array();
			for (var i in keyIds) {
				arr[i]={a1:keyIds[i].a1, a2:keyIds[i].a2};
			}
			return arr;
		}
		
		public function load(arr) {
			for (var i in arr) {
				if (keyIds[i]) {
					checkKey(arr[i].a1);
					checkKey(arr[i].a2);
					if (keyIds[i].a1!=Keyboard.TAB) keyIds[i].a1=arr[i].a1;
					keyIds[i].a2=arr[i].a2;
				}
			}
		}
		
		public function checkKey(a:String) {
			if (a==null) return;
			for (var k in keyIds) {
				if (keyIds[k]) {
					if (keyIds[k].a1==a) keyIds[k].a1=null;
					if (keyIds[k].a2==a) keyIds[k].a2=null;
				}
			}
		}
		
		//Вернуть видимое название клавиши по коду действия
		public function retKey(id):String {
			if (keyIds[id]==null) return '?'
			var key=keyIds[id].a1;
			if (key==null) key=keyIds[id].a2;
			if (key==null) return '???';
			if (key>0 && key<256) return "["+keyNames[key]+"]";
			else return "["+mbNames[key]+"]";
			//return "<img src='mouse_"+key+"' hspace='0' vspace='0'>";//width='16' height='16' 
		}
		
		public function permissKey(key:uint):Boolean {
			if (key==Keyboard.CONTROL || key==Keyboard.ESCAPE || key==Keyboard.TAB || key==Keyboard.CAPS_LOCK || key==Keyboard.DELETE ||  key==Keyboard.END ||  key==Keyboard.HOME ||  key==Keyboard.INSERT) return false;
			return true;
		}
		
		//отправить запрос на смену клавиши, по завершении выполнить функцию fun
		public function requestKey(fun:Function=null) {
			setkeyOn=true;
			setkeyRequest=null;
			setkeyFun=fun;
		}
		
		//запрос выполнен
		function requestOk(nkey) {
			setkeyOn=false;
			setkeyRequest=nkey;
			if (setkeyFun) setkeyFun();
		}

		public function onMouseMove1(event:MouseEvent):void {
			World.w.cam.celX=event.stageX;
			World.w.cam.celY=event.stageY;
			if (World.w.gui) {
				if (event.stageY<100 && event.stageX>World.w.swfStage.stageWidth-400) World.w.gui.infoAlpha=0.2;
				else World.w.gui.infoAlpha=1;
				World.w.gui.showDop=World.w.showFavs && (event.stageY>World.w.swfStage.stageHeight-15);
			}
		}
		public function onMouseDown1(event:MouseEvent):void {
			if (World.w.onConsol) return;
			if (World.w.clickReq==1) {
				World.w.clickReq=2;
				return;
			}
			keyPressed=true;
			if (setkeyOn) {
				requestOk('lmb');
				event.stopPropagation();
				return;
			}
			if (!active) {
				active=true;
			} else {
				if (keys['lmb']) this[keys['lmb'].id]=true;
			}
		}
		public function onMouseUp1(event:MouseEvent):void {
			if (keys['lmb']) this[keys['lmb'].id]=false;
		}
		private function onRightMouse(event:MouseEvent):void {
            //отключение меню
        }
		public function onRightMouseDown1(event:MouseEvent):void {
			if (World.w.onConsol) return;
			keyPressed=true;
			keyPressed2=true;
			if (setkeyOn) {
				requestOk('rmb');
				return;
			}
			//if (event.clickCount>1) rbmDbl=true;
			if (keys['rmb']) this[keys['rmb'].id]=true;
		}
		public function onRightMouseUp1(event:MouseEvent):void {
			if (keys['rmb']) this[keys['rmb'].id]=false;
		}
		public function onMiddleMouseDown1(event:MouseEvent):void {
			if (World.w.onConsol) return;
			if (setkeyOn) {
				requestOk('mmb');
				return;
			}
			if (keys['mmb']) this[keys['mmb'].id]=true;
		}
		public function onMiddleMouseUp1(event:MouseEvent):void {
			if (keys['mmb']) this[keys['mmb'].id]=false;
		}
		public function onMouseWheel1(event:MouseEvent):void {
			if (World.w.onConsol) return;
			if (setkeyOn) {
				if (event.delta<0) requestOk('scrd');
				if (event.delta>0) requestOk('scru');
				return;
			}
			try {
				if (World.w.gui.inform.visible && World.w.gui.inform.scText.visible) {
					World.w.gui.inform.txt.scrollV-=event.delta;
					event.stopPropagation();
					return;
				}
			} catch(err) {}
			if (event.delta<0 && keys['scrd']) this[keys['scrd'].id]=true;
			if (event.delta>0 && keys['scru']) this[keys['scru'].id]=true;
			scr_t=3;
			event.stopPropagation();
		}
		
		public function onKeyboardDownEvent(event:KeyboardEvent):void {
			if (setkeyOn) {
				if (permissKey(event.keyCode)) requestOk(event.keyCode);
				else if (event.keyCode==Keyboard.DELETE) requestOk(null);
				else if (event.keyCode==Keyboard.TAB || event.keyCode==Keyboard.ESCAPE) requestOk(-1);
				return;
			}
			if (!World.w.onConsol) {
				if (event.keyCode<256 && !keyDowns[event.keyCode]) {
					if (keys[event.keyCode]) {
						this[keys[event.keyCode].id]=true;
						if (keys[event.keyCode].id=='keyLeft' && kL_t<dubleT) keyDubLeft=true;
						if (keys[event.keyCode].id=='keyRight' && kR_t<dubleT) keyDubRight=true;
						if (keys[event.keyCode].id=='keySit' && kD_t<dubleT) keyDubSit=true;
					}
				}
				if (event.keyCode<256) keyDowns[event.keyCode]=true;
				if (World.w.pip && World.w.pip.reqKey) {
					for (var i=1; i<=12; i++) {
						if (this['keyWeapon'+i]) {
							this['keyWeapon'+i]=false;
							World.w.pip.assignKey(i+(keyRun?12:0));
						}
					}
					for (var i=1; i<=4; i++) {
						if (this['keySpell'+i]) {
							this['keySpell'+i]=false;
							World.w.pip.assignKey(24+i);
						}
					}
					if (keyGrenad) {
						keyGrenad=false;
						World.w.pip.assignKey(29);
					}
					if (keyMagic) {
						keyMagic=false;
						World.w.pip.assignKey(30);
					}
				}
			}
			if (event.keyCode==Keyboard.END) {
				World.w.consolOnOff()
			}
			if (World.w.chitOn && event.keyCode==Keyboard.HOME) {
				keyTest1=true;
			}
			if (event.keyCode==Keyboard.DELETE && World.w.testMode) {
				World.w.onPause=!World.w.onPause;
			}
			if (event.keyCode==Keyboard.INSERT) {
				World.w.redrawLoc();
			}
			if (event.keyCode==Keyboard.BACKQUOTE) keyFly=true;
			if (World.w.chitOn) {
				if (event.keyCode==Keyboard.INSERT) keyTest2=true;
			}
			if (keyFull) {//работает только в обработчике события
				if (!World.w.onConsol) World.w.swfStage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
				keyFull=false;
			}
		}
		
		public function onKeyboardUpEvent(event:KeyboardEvent):void {
			if (event.keyCode<256) keyDowns[event.keyCode]=false;
			if (keys[event.keyCode]) {
				this[keys[event.keyCode].id]=false;
				if (keys[event.keyCode].id=='keyLeft') kL_t=0;
				if (keys[event.keyCode].id=='keyRight') kR_t=0;
				if (keys[event.keyCode].id=='keySit') kD_t=0;
			}
		}
	}
	
}

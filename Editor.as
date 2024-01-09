package {
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Loader;
	import flash.text.TextField;
	import flash.events.*;
	import flash.net.FileReference;
	import flash.net.URLLoader; 
	import flash.net.URLRequest; 
	import fl.data.DataProvider;
	import fl.controls.List;
	import flash.text.TextFieldAutoSize;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.net.SharedObject;
	
	import fe.AllData;

	public class Editor {
		
		var allroom:XML;			//XML со всеми комнатами, загружаемый из файла или запсываемый в файл
		var arrroom:Array;			//массив всех комнат в XML
		var curroom:XML;			//текущая комната
		var room0:XML=<all></all>;	//нулевой XML
		var landXML:XML;
		
		var loader:URLLoader = new URLLoader();
		var loaded:Boolean=false;
		var filePath="";
		var request:URLRequest;
		var configObj:SharedObject;
		var chars:Array;
		
		public var ed:MovieClip;	//визуальный объект всего редактора
		
		//Константы и настройки
		var rndMode:Boolean=false;			//режим редактора - для случайной или заданной местности
		var raz:int=20;						//размер блока
		var spacex:int=48, spacey:int=25;	//размеры комнаты
		
		//пространство блоков
		var space:Array=new Array();
		//используется для подсчёта того, сколько имеется материалов какого типа
		var frames:Array=[0,0,0,0,0,0];
		//массив основных материалов, возвращающий по id параметры:
		//tip - тип материала
		//frame - номер кадра
		//list - номер списка
		//n - номер в списке
		var fronts:Array=new Array();
		//массив дополнительных материалов
		var backs:Array=new Array();
		//массив всех объектов
		var objs:Array=new Array();
		var optObj:Object=new Object;
		var options:String='';
		
		//карта
		var zLay:int=0;
		var minX=0, maxX=0, minY=0, maxY=0;		//минимальные и максимальные координаты на карте
		var cmapX=0, cmapY=0, cmapZ=0;					// текущие координаты комнаты
		var roomsc:Number=1;
		var mapBitmap:Bitmap;
		var mapRamka:MovieClip;
		var mapBmp:BitmapData;
		var mapArr:Array;
		var backVis:MovieClip;
		
		
		//рабочая область
		var dey:String='mat';
		var actobj:Object;							//объект, который устанавливаешь
		var selobj:Object;							//выбранный объект
		var brush:edTile;							//блок, которым рисуешь
		var brushPip:edTile=new edTile();			//блок-пипетка
		var zForm:int=-1;
		
		var v_front:Boolean=true;
		var v_back:Boolean=true;
		var v_obj:Boolean=true;
		var v_backobj:Boolean=true;
		var v_ids:Boolean=true;
		var v_vid:Boolean=true;
		var onx:int=0, ony:int=0;
		
		var begx:int, begy:int, endx:int, endy:int;	//начало и конец рамки
		var isDraw:Boolean=false;
		var mActive:Boolean=false;					//ставится в false при переключении комнат и в true если было действие
		
		//Загрузка текстов
		public var textLoaded:Boolean=false;
		var loader_text:URLLoader; 
		var request_text:URLRequest;
		var textXML:XML;
		//загрузка графики
		public var resGraf:Loader;
		public var resTex:*;		//содержимое загруженного файла
		var grafLoaded:Boolean=false;
		var inited:Boolean=false;
		
		public function Editor(ned:MovieClip) {
			allroom=new XML();
			ed=ned;
			//подготовка рабочей области
			ed.ramka.visible=false;
			ed.objInfo.multiline=true;
			ed.objInfo.autoSize='left';
			ed.objInfo.visible=false;
			for (var i=0; i<spacex; i++) {
				space[i]=new Array();
				for (var j=0; j<spacey; j++) {
					var t:edTile=new edTile();
					var tb:MovieClip=new edTileBack();
					t.vis2=tb;
					space[i][j]=t;
					t.x=tb.x=i*raz;
					t.y=tb.y=j*raz;
					tb.stop();
					tb.alpha=0.5;
					ed.world.addChild(t);
					ed.bworld.addChild(tb);
				}
			}
			
			loader_text = new URLLoader(); 
			//request_text = new URLRequest("http://foe.ucoz.org/text.xml"); 
			//request_text = new URLRequest("D:/Dropbox/foe/text.xml"); 
			request_text = new URLRequest("text_ru.xml"); 
			loader_text.load(request_text); 
			loader_text.addEventListener(Event.COMPLETE, onCompleteLoadText);
			
			//загрузка фоновых объектов
			resGraf = new Loader();
			var urlReq:URLRequest = new URLRequest('texture1.swf');
			resGraf.load(urlReq);
			resGraf.contentLoaderInfo.addEventListener(Event.COMPLETE, resLoaded);  
			
			
			configObj=SharedObject.getLocal('EditorConf');
			if (configObj.data.fileName) ed.FileName.text=configObj.data.fileName;
			request = new URLRequest(filePath+ed.FileName.text+'.xml'); 
			loader.load(request); 
			loader.addEventListener(Event.COMPLETE, onComplete);
			loader.addEventListener(IOErrorEvent.IO_ERROR, onError);
			
			chars=new Array();
			for (i=48; i<58; i++) chars.push(String.fromCharCode(i));
			for (i=65; i<65+26; i++) chars.push(String.fromCharCode(i));
			for (i=97; i<97+26; i++) chars.push(String.fromCharCode(i));
			
			//ed.SelObj
		}
		
		function code():String {
			var s='';
			for (var i=0; i<15; i++) {
				if (i==0) s+=chars[Math.floor(Math.random()*52)+10];
				s+=chars[Math.floor(Math.random()*62)];
			}
			return s;
		}
		
		function init() {
			if (!grafLoaded || !textLoaded || inited) return;
			//создание списков материалов
			//первый список
			var xmll:XMLList=AllData.d.mat.(@ed=='1');
			addMaterial(0,<mat ed='1' id='' n='[пусто]'/>);
			var j=1;
			for (var i in xmll) {
				addMaterial(j,xmll[i]);
				j++;
			}
			//второй список
			xmll=AllData.d.mat.(@ed=='2');
			addMaterial(0,<mat ed='2' id='' n='[пусто]'/>);
			j=1;
			for (i in xmll) {
				addMaterial(j,xmll[i]);
				j++;
			}
			//третий список
			xmll=AllData.d.mat.(@ed=='3' || @ed=='4');
			addMaterial(0,<mat ed='1' id='' n='[пусто]'/>);
			j=1;
			for (i in xmll) {
				addMaterial(j,xmll[i]);
				j++;
			}
			addMaterial(j,<mat ed='5' id='*' n='Вода'/>);
			update();
			
			//создание списков объектов
			var dp:Array=new Array();
			dp[1] = new DataProvider();	
			for (i=2; i<=10; i++) {
				dp[i] = dp[1];
			}
			dp[11] = new DataProvider();	
			for (i=12; i<=20; i++) {
				dp[i] = dp[11];
			}
			dp[21] = new DataProvider();	//фоновые объекты
			ed.objList0.dataProvider = dp[1];
			ed.objList1.dataProvider = dp[11];
			ed.objList2.dataProvider = dp[21];
			xmll=AllData.d.obj.(@ed>0);
			for (i in xmll) {
				var id:String=xmll[i].@id;
				var lab:String='['+id+']';
				if (textXML.obj.(@id==id).length() && textXML.obj.(@id==id).n[0].length()) lab=textXML.obj.(@id==id).n[0];
				if (xmll[i].@n.length()) lab=xmll[i].@n;
				dp[xmll[i].@ed].addItem({label:lab, id:id, ed:xmll[i].@ed, icon:'ico_'+xmll[i].@ico, size:xmll[i].@size, wid:xmll[i].@wid});
			}
			xmll=AllData.d.back;
			for (i in xmll) {
				if (xmll[i].@nope!='1')	dp[21].addItem({label:((xmll[i].@id=='')?('-------  '+xmll[i].@n+'  ------------'):xmll[i].@n), icon:((xmll[i].@id=='')?'':'iconBack'), id:xmll[i].@id, ed:21, x1:xmll[i].@x1, x2:xmll[i].@x2, y1:xmll[i].@y1, y2:xmll[i].@y2});
			}
			ed.objList0.addEventListener(Event.CHANGE, changeObj);
			ed.objList1.addEventListener(Event.CHANGE, changeObj);
			ed.objList2.addEventListener(Event.CHANGE, changeObj);
			ed.butObjSelect.addEventListener(MouseEvent.CLICK, changeSel);
			ed.butCheck.addEventListener(MouseEvent.CLICK, checkXML);
			ed.butOptRoom.addEventListener(MouseEvent.CLICK, changeOpt);
			ed.butToList.addEventListener(MouseEvent.CLICK, tolistClick);
			ed.butZLay.addEventListener(MouseEvent.CLICK, zlayClick);
			ed.butDelRoom.addEventListener(MouseEvent.CLICK, deleteClick);
			
			ed.panelBack.visible=ed.panelDet.visible=false;
			ed.panelDetails.addEventListener(MouseEvent.CLICK, detailsClick);
			ed.butSave.addEventListener(MouseEvent.CLICK, saveClick);
			ed.butLoad.addEventListener(MouseEvent.CLICK, loadClick);
			
			ed.roomsList.addEventListener(Event.CHANGE, changeHandler);
			ed.but_vfront.addEventListener(MouseEvent.CLICK, swapFB);
			ed.but_vback.addEventListener(MouseEvent.CLICK, swapFB);
			ed.but_vdet.addEventListener(MouseEvent.CLICK, swapFB);
			ed.actObl.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown2);
			ed.actObl.addEventListener(MouseEvent.MOUSE_UP,onMouseUp2);
			ed.actObl.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove2);
			ed.map.addEventListener(MouseEvent.MOUSE_DOWN,onMapClick);
			ed.map.addEventListener(MouseEvent.MOUSE_MOVE,onMapMove);
			
			ed.butObjErase.addEventListener(MouseEvent.CLICK, changeNull);
			ed.butBackObjErase.addEventListener(MouseEvent.CLICK, changeBackNull);
			ed.butFrontErase.addEventListener(MouseEvent.CLICK, selEraseFront);
			ed.butBackErase.addEventListener(MouseEvent.CLICK, selEraseBack);
			ed.butDetailsErase.addEventListener(MouseEvent.CLICK, selEraseDetails);
			ed.viewFront.addEventListener(MouseEvent.CLICK, viewFrontClick);
			ed.viewBack.addEventListener(MouseEvent.CLICK, viewBackClick);
			ed.viewObj.addEventListener(MouseEvent.CLICK, viewObjClick);
			ed.viewBackObj.addEventListener(MouseEvent.CLICK, viewBackObjClick);
			ed.viewIds.addEventListener(MouseEvent.CLICK, viewIdsClick);
			ed.viewVid.addEventListener(MouseEvent.CLICK, viewVidClick);
			
			mapBmp=new BitmapData(spacex*14, spacey*10);
			mapBitmap=new Bitmap(mapBmp);
			ed.map.addChild(mapBitmap);
			mapRamka=new map_ramka();
			ed.map.addChild(mapRamka);
			
			inited=true;
			if (loaded)	decodeAll();
		}
		
//==========================================================================================================
//					Работа с файлами, картой и списком комнат
//==========================================================================================================
		//Сохранить файл
		public function saveClick(event:MouseEvent):void {
			//ed.out.text='save';
			configObj.data.fileName=ed.FileName.text;
			//ed.out.text+='\nsave1';
			var file:FileReference = new FileReference();
			//ed.out.text+='\nsave2';
			updSelObj();
			//ed.out.text+='\nsave3';
			encodeCurrent();
			//ed.out.text+='\nsave4';
			encodeAll();
			//ed.out.text+='\nsave5';
			var spl:Array=ed.FileName.text.split('/');
			//ed.out.text+='\nsave6';
			file.save(allroom,spl[spl.length-1]+'.xml');
			//ed.out.text+='\nsave7';
		}
		//Загрузить файл
		public function loadClick(event:MouseEvent):void {
			loaded=false;
			configObj.data.fileName=ed.FileName.text;
			request = new URLRequest(filePath+ed.FileName.text+'.xml'); 
			if (event.ctrlKey) loader.load(request); 
			//decode(aaa);
		}
		//Загрузка завершена, декодировать
		function onComplete(event:Event):void  { 
			var loader:URLLoader = event.target as URLLoader; 
			if (loader != null) { 
				allroom = new XML(loader.data);
				loaded=true;
				if (inited)	decodeAll();
			} else { 
				trace("loader is not a URLLoader!"); 
			} 
		}
		function onError(event:IOErrorEvent):void  { 
		
		}
		function resLoaded(event:Event):void {
			resTex = event.target.content;
			grafLoaded=true;
			init();
		}
		function onCompleteLoadText(event:Event):void  {
			textXML = new XML(loader_text.data);
			textLoaded=true;
			init();
		}
		
		//выбрать комнату из списка
		function changeHandler(event:Event):void  {
			ed.objInfo.visible=false;
			showSelect(false);
			encodeCurrent();
			ed.RoomName.text=ed.roomsList.selectedItem.id;
			curroom=arrroom[ed.RoomName.text];
			cmapX=curroom.@x;
			cmapY=curroom.@y;
			if (curroom.@z.length()) cmapZ=curroom.@z;
			else cmapZ=0;
			zLay=cmapZ;
			decode(curroom);
			drawMap();
		}
		
		//Актуализировать список
		public function tolistClick(event:MouseEvent):void {
			mActive=true;
			encodeCurrent();
			ed.roomsList.dataProvider.sortOn(['tip','level','id']);
		}
		
		//Удалить комнату
		public function deleteClick(event:MouseEvent):void {
			if (ed.roomsList.selectedItem && event.ctrlKey) {
				ed.RoomName.text=ed.roomsList.selectedItem.id;
				delete arrroom[ed.RoomName.text];
				ed.roomsList.dataProvider.removeItem(ed.roomsList.selectedItem);
			}
			drawMap();
		}
		
		//выбрать комнату на карте
		public function onMapMove(event:MouseEvent):void {
			var nx=Math.floor(event.localX/(spacex*roomsc))+minX-1;
			var ny=Math.floor(event.localY/(spacey*roomsc))+minY-1;
			var cr:String='room_'+nx+'_'+ny;
			if (zLay>0) cr+='_'+zLay;
			if (mapArr && mapArr[nx] && mapArr[nx][ny]) cr=mapArr[nx][ny].id;
			ed.mapInfo.text=nx+':'+ny+':'+zLay+'  '+cr;
		}
		public function onMapClick(event:MouseEvent):void {
			encodeCurrent();
			var nx=Math.floor(event.localX/(spacex*roomsc))+minX-1;
			var ny=Math.floor(event.localY/(spacey*roomsc))+minY-1;
			cmapX=nx, cmapY=ny;
			cmapZ=zLay;
			var cr:String='room_'+nx+'_'+ny;
			if (zLay>0) cr+='_'+zLay;
			if (mapArr[nx] && mapArr[nx][ny]) {
				cr=mapArr[nx][ny].id;
				curroom=arrroom[cr];
			} else {
				curroom=null;
			}
			ed.RoomName.text=cr;
			decode(curroom);
			setListIndex();
			drawMap();
		}
		public function zlayClick(event:MouseEvent) {
			encodeCurrent();
			zLay=1-zLay;
			drawMap();
			var nx=cmapX, ny=cmapY;
			cmapZ=zLay;
			var cr:String='room_'+nx+'_'+ny;
			if (zLay>0) cr+='_'+zLay;
			if (mapArr[nx] && mapArr[nx][ny]) {
				cr=mapArr[nx][ny].id;
				curroom=arrroom[cr];
			} else {
				curroom=null;
			}
			ed.RoomName.text=cr;
			decode(curroom);
			setListIndex();
		}
		//установить правильный индекс списка комнат при выборе с помощью карты
		function setListIndex() {
			for (var i=0; i<ed.roomsList.length; i++) {
				if (ed.roomsList.getItemAt(i).id==ed.RoomName.text) {
					ed.roomsList.selectedIndex=i;
					break;
				}
			}
		}
		

		//кодировать все комнаты в новый XML
		public function encodeAll() {
			var r:XML=<all></all>;
			if (landXML) r.appendChild(landXML);
			for (var i in arrroom) {
				r.appendChild(arrroom[i]);
			}
			allroom=r;
		}
		
		//кодировать одну комнату в текущий XML всех комнат
		public function encodeCurrent() {
			var s=ed.RoomName.text;
			if (!mActive) return;
			if (!arrroom[s]) {
				ed.roomsList.dataProvider.addItem({id:s, label:s, tip:'', level:0});
			}
			arrroom[s]=encode();
		}
		
		//кодировать текущую комнату, вернуть получившийся XML одной комнаты
		public function encode():XML {
			var r:XML;
			if (rndMode) r=<room name={ed.RoomName.text}></room>;
			else {
				if (cmapZ>0) r=<room name={ed.RoomName.text} x={cmapX} y={cmapY} z={cmapZ}></room>;
				else r=<room name={ed.RoomName.text} x={cmapX} y={cmapY}></room>;
			}
			var s:String;
			for (var j=0; j<spacey; j++) {
				s='';
				for (var i=0; i<spacex; i++) {
					var t:edTile=space[i][j];
					if (i>0) s+='.';
					s+=t.enc();
				}
				r.appendChild(<a>{s}</a>);
			}
			objs.sort(sortObjs);
			for (i in objs) {
				r.appendChild(objs[i].xml);
				//if (objs[i].isback)  r.appendChild(<back id={objs[i].id} x={objs[i].X} y={objs[i].Y}/>);
				//else r.appendChild(<obj id={objs[i].id} x={objs[i].X} y={objs[i].Y}/>);
			}
			if (rndMode) {	//в режиме случайных комнат добавить информацию о проходах
				s='';
				for (i=0; i<22; i++) {
					if (i>0) s+='.';
					s+=getDoors(i);
				}
				r.appendChild(<doors>{s}</doors>);
			}
			try {
				r.appendChild(optObj.xml);
			} catch (err) {
				trace('Ошибка в настройках комнаты');
			}
			return r;
		}
		
		//сортировка объектов по размеру
		private function sortObjs(a, b):int { 
			if (a.wid > b.wid)  return -1; 
			else if (a.wid < b.wid)  return 1; 
			else if (a.size > b.size)  return -1; 
			else if (a.size < b.size) return 1; 
			else return 0; 
		}
		
		//рассчёт проходов для шаблонов случайных комнат
		//вычисляется проход по конкретному номеру, возвращает 0, если прохода нет, или его размер, если есть
		private function getDoors(n:int):int {
			var q:int;
			if (n>21) return 0;
			else if (n>=17) {
				q=(n-17)*9+4;
				if (!space[q+1][0].isPhis() && !space[q+2][0].isPhis() && !space[q+1][1].isPhis() && !space[q+2][1].isPhis()) {
					if (!space[q][0].isPhis() && !space[q+3][0].isPhis() && !space[q][1].isPhis() && !space[q+3][1].isPhis()) return 4;
					else return 2;
				} else return 0;
			} else if (n>=11) {
				q=(n-11)*4+3;
				if (!space[0][q].isPhis() && !space[0][q-1].isPhis() && !space[1][q].isPhis() && !space[1][q-1].isPhis()) {
					if (!space[0][q-2].isPhis() && !space[1][q-2].isPhis()) return 3;
					else return 2;
				} else return 0;
			} else if (n>=6) {
				q=(n-6)*9+4;
				if (!space[q+1][spacey-2].isPhis() && !space[q+2][spacey-2].isPhis() && !space[q+1][spacey-1].isPhis() && !space[q+2][spacey-1].isPhis()) {
					if (!space[q][spacey-2].isPhis() && !space[q+3][spacey-2].isPhis() && !space[q][spacey-1].isPhis() && !space[q+3][spacey-1].isPhis()) return 4;
					else return 2;
				} else return 0;
			} else if (n>=0) {
				q=(n)*4+3;
				if (!space[spacex-2][q].isPhis() && !space[spacex-2][q-1].isPhis() && !space[spacex-1][q].isPhis() && !space[spacex-1][q-1].isPhis()) {
					if (!space[spacex-2][q-2].isPhis() && !space[spacex-1][q-2].isPhis()) return 3;
					else return 2;
				} else return 0;
			} else return 0;
		}
		
		//Перегнать весь XML allroom в массив XML arrroom, декодировать текущую комнату
		public function decodeAll() {
			landXML=allroom.land[0];
			if (landXML && landXML.@serial==1) rndMode=false;
			else  rndMode=true;
			var dp:DataProvider = new DataProvider();
			ed.roomsList.dataProvider = dp;
			arrroom=new Array();
			cmapX=cmapY=0;
			ed.RoomName.text='';
			var lastS='';
			for each(var r in allroom.room) {
				var n:Object={label:r.@name, id:r.@name, level:0, tip:''};
				if (r.options.length() && r.options[0].@level>0) {
					n.label+=' ('+r.options[0].@level+')';
					n.level=r.options[0].@level;
				}
				if (r.options.length() && r.options[0].@tip=='back') {
					n.label+=' ['+r.options[0].@tip+']';
					n.tip=r.options[0].@tip;
				}
				dp.addItem(n);
				arrroom[r.@name]=r;
				if (r.@x==cmapX && r.@y==cmapY && (r.@z==cmapZ || r.@z.length()==0)) ed.RoomName.text=r.@name;
				else lastS=r.@name;
			}
			if (ed.RoomName.text=='') ed.RoomName.text=lastS;
			decode(arrroom[ed.RoomName.text]);
			setListIndex();
			mapBitmap.visible=!rndMode;
			drawMap();
			//ed.roomsList.sortItemsOn();
			ed.roomsList.dataProvider.sortOn(['tip','level','id'])
		}
		
		//Декодировать один XML в текущую комнату
		public function decode(s:XML) {
			for (var j=0; j<spacey; j++) {
				var js:String='';
				if (s!=null) js=s.a[j];
				var arri:Array=js.split('.');
				for (var i=0; i<spacex; i++) {
					var jis:String='';
					if (i<arri.length) jis=arri[i];
					space[i][j].dec(jis,fronts,backs);
					space[i][j].upd();
				}
			}
			for each(var obj in objs) {
				if (ed.worldobj.contains(obj.vis)) ed.worldobj.removeChild(obj.vis);
				if (ed.worldback.contains(obj.vis)) ed.worldback.removeChild(obj.vis);
			}
			objs=new Array();
			if (s!=null) {
				for each(obj in s.obj) {
					addObj(obj.@x, obj.@y, obj.@id, obj);
				}
				for each(obj in s.back) {
					addObj(obj.@x, obj.@y, obj.@id, obj);
				}
				if (s.options.length()) {
					optObj.xml=s.options[0];
				} else {
					optObj.xml=<options/>;
				}
				options=optObj.xml.toXMLString();
			} else {
				try {
					optObj.xml=new XML(options);
				} catch (err) {
					trace('Ошибка в настройках комнаты');
				}
			}
			mActive=false;
		}
		
		//рисовать всю карту
		public function drawMap() {
			if (rndMode) return;
			mapBmp.fillRect(mapBmp.rect,0xFF000000);
			minX=0, maxX=0, minY=0, maxY=0;
			mapArr=new Array();
			for each(var r in arrroom) {
				var nx:int=r.@x;
				var ny:int=r.@y;
				var nz:int=0;
				if (r.@z.length()) nz=r.@z;
				if (nx<minX) minX=nx;
				if (nx>maxX) maxX=nx;
				if (ny<minY) minY=ny;
				if (ny>maxY) maxY=ny;
				if (mapArr[nx]==null) mapArr[nx]=new Array();
				if (mapArr[nx][ny]!=null) {
					if (nz==zLay) mapArr[nx][ny].n++;
				} else {
					if (nz==zLay) mapArr[nx][ny]={id:r.@name, n:1};
				}
			}
			var rc:MovieClip=new vis_rc();
			var est:Boolean=false;
			for each(r in arrroom) {
				nx=r.@x;
				ny=r.@y;
				nz=0;
				if (r.@z.length()) nz=r.@z;
				if (nx==cmapX && ny==cmapY && nz==cmapZ) est=true;
				if (nz!=zLay) continue;
				//if (mapArr[nx][ny].n>1) rc.gotoAndStop(3);	//две комнаты в одном месте, непорядок
				var m:Matrix=new Matrix();
				m.translate((nx-minX+1)*spacex*roomsc, (ny-minY+1)*spacey*roomsc);
				mapBmp.draw(rc,m);
				drawToMap(r);
			}
			mapRamka.x=(cmapX-minX+1)*spacex*roomsc;
			mapRamka.y=(cmapY-minY+1)*spacey*roomsc;
			if (!est) {
				
			}
		}
		//Рисовать карту одной комнаты
		public function drawToMap(s:XML) {
			if (s.@x.length()==0 || s.@y.length()==0) return;
			var t:edTile=new edTile();
			var nx=(s.@x-minX+1)*spacex*roomsc, ny=(s.@y-minY+1)*spacey*roomsc;
			for (var j=0; j<spacey; j++) {
				var js:String='';
				if (s!=null) js=s.a[j];
				var arri:Array=js.split('.');
				for (var i=0; i<spacex; i++) {
					var jis:String='';
					if (i<arri.length) jis=arri[i];
					t.dec(jis,fronts,backs);
					if (t.ids[5]!='') mapBmp.setPixel(nx+i,ny+j,0x6699FF);
					if (t.ids[1]!='') mapBmp.setPixel(nx+i,ny+j,0xFFFFFF);
				}
			}
		}
		
		
//==========================================================================================================
//					Работа с материалами и списками объектов
//==========================================================================================================
		
		//Добавить материал из AllData
		//tip - тип материала
		//list - номер списка
		//n - номер в списке

		public function addMaterial(nnum:int,xml:XML) {
			var t:edTile=new edTile();
			t.useHandCursor=true;
			var txt:TextField=new TextField();
			txt.selectable=false;
			t.y=txt.y=nnum*25+20;
			t.x=10,	txt.x=40;
			
			var tip:int=xml.@ed;	//тип материала
			var id=xml.@id;			//id материала (буква)
			var ntext=xml.@n;		//название
			frames[tip]++;			//количество материалов этого типа
			var nlist:int=1;
			var pp:MovieClip=ed.panelFront;	//в какой список добавлять
			if (tip==2) {
				pp=ed.panelBack;
				nlist=2;
			}
			if (tip>2) {
				pp=ed.panelDet;
				nlist=3;
			}
			if (xml.@diagon<0 || xml.@diagon>0) t.vis4.y-=7;
			t.tip=tip;
			t.ids[tip]=id;
			t.frames[tip]=frames[tip];
			t.id=id;
			var obj:Object={tip:tip, frame:frames[tip], list:nlist, n:nnum};
			if (tip==1) {
				fronts[id]=obj;
			} else {
				backs[id]=obj;
			}
			t.addEventListener(MouseEvent.CLICK, frontClick);
			t.upd();
			txt.text=ntext;
			pp.addChild(t);
			pp.addChild(txt);
		}
		
		//Поменять вкладки переднего и заднего планов
		public function swapFB(event:MouseEvent):void {
			//trace(event.target.name);
			ed.panelFront.visible=ed.panelBack.visible=ed.panelDet.visible=false;
			if (event.currentTarget==ed.but_vfront)	ed.panelFront.visible=true;
			if (event.currentTarget==ed.but_vback)	ed.panelBack.visible=true;
			if (event.currentTarget==ed.but_vdet)	ed.panelDet.visible=true;
			//ed.butFB.label=ed.panelFront.visible?'Передний план':'Задний план';
			update();
		}
		//Выбор материала
		public function frontClick(event:MouseEvent):void {
			ed.objInfo.visible=false;
			dey='mat';
			var t:edTile=(event.currentTarget as edTile);
			brush=t;
			actobj=null;
			update();
		}
		
		//Выбор дополнительных опций, таких как форма
		public function detailsClick(event:MouseEvent):void {
			var px:int=Math.floor(event.localX/raz);
			var py:int=Math.floor(event.localY/raz);
			if (py==0) {
				if (px>=0 && px<=4) zForm=px-1;
			}
			actobj=null;
			update();
		}
		
		//Стирать объекты
		function changeNull(event:MouseEvent):void  {
			dey='erase';
			brush=null;
			actobj=null;
			zForm=-1;
			update();
		}
		//Стирать задние объекты
		function changeBackNull(event:MouseEvent):void  {
			dey='eraseb';
			brush=null;
			actobj=null;
			zForm=-1;
			update();
		}
		//Выбрать объект из списка
		function changeObj(event:Event):void  {
			dey='obj';
			actobj=event.currentTarget.selectedItem;
			brush=null;
			zForm=-1;
			update();
		}
		//Выбрать объект в рабочей области
		function changeSel(event:Event):void  {
			dey='select';
			brush=null;
			actobj=null;
			zForm=-1;
			update();
		}
		//Выбрать свойства комнаты
		function changeOpt(event:Event):void  {
			mActive=true;
			dey='select';
			brush=null;
			actobj=null;
			zForm=-1;
			update();
			selobj=optObj;
			showSelect();
		}
		
		function viewFrontClick(event:MouseEvent):void  {
			v_front=!v_front;
			viewUpdate();
		}
		function viewBackClick(event:MouseEvent):void  {
			v_back=!v_back;
			viewUpdate();
		}
		function viewObjClick(event:MouseEvent):void  {
			v_obj=!v_obj;
			viewUpdate();
		}
		function viewBackObjClick(event:MouseEvent):void  {
			v_backobj=!v_backobj;
			viewUpdate();
		}
		function viewIdsClick(event:MouseEvent):void  {
			v_ids=!v_ids;
			showIds();
			viewUpdate();
		}
		function viewVidClick(event:MouseEvent):void  {
			v_vid=!v_vid;
			showIds();
			viewUpdate();
		}
			
		public function viewUpdate() {
			ed.world.visible=v_front;
			ed.bworld.visible=v_back;
			ed.worldback.visible=v_backobj;
			ed.worldobj.visible=v_obj;
			ed.viewFront.gotoAndStop(v_front?1:2);
			ed.viewBack.gotoAndStop(v_back?1:2);
			ed.viewBackObj.gotoAndStop(v_backobj?1:2);
			ed.viewObj.gotoAndStop(v_obj?1:2);
			ed.viewIds.gotoAndStop(v_ids?1:2);
			ed.viewVid.gotoAndStop(v_vid?1:2);
		}
		
		//Актуализировать списки объектов и материалов
		public function update() {
			ed.objInfo.visible=false;
			//установить нужный пункт в списке материалов
			ed.panelFront.ramka.y=ed.panelBack.ramka.y=ed.panelDet.ramka.y=18;
			if (brush) {
				var obj:Object;
				for (var i=1; i<brush.ids.length; i++) {
					if (brush.ids[i]!='' && brush.ids[i]!='_') {
						if (i==1) obj=fronts[brush.ids[i]];
						else obj=backs[brush.ids[i]];
						if (obj.list==1) ed.panelFront.ramka.y=(obj.n)*25+18;
						else if (obj.list==2) ed.panelBack.ramka.y=(obj.n)*25+18;
						else ed.panelDet.ramka.y=(obj.n)*25+18;
					}
				}
			} 
			
			//установить правильный объкт, перемещающийся за курсором
			if (actobj) {
				ed.vobj.visible=true;
				ed.vobj.tid.text=actobj.id?actobj.id:'';
				ed.vobj.tid.autoSize=TextFieldAutoSize.LEFT;
				var kv:int=actobj.ed;
				if (kv<=0) kv=1;
				if (kv<21)	{
					ed.vobj.kvad.x=0;
					ed.vobj.kvad.y=raz;
					if (actobj.size) ed.vobj.kvad.scaleX=actobj.size;
					else ed.vobj.kvad.scaleX=1;
					if (actobj.wid) ed.vobj.kvad.scaleY=actobj.wid;
					else ed.vobj.kvad.scaleY=1;
					ed.vobj.kvad.visible=true;
					ed.vobj.bv.visible=false;
				} else {
					if (backVis!=null && ed.vobj.bv.contains(backVis)) ed.vobj.bv.removeChild(backVis);
					backVis=resTex.getObj('back_'+ actobj.id +'_t');
					if (backVis==null) backVis=resTex.getObj('back_'+ actobj.id +'_l');
					if (backVis) {
						ed.vobj.bv.addChild(backVis);
						backVis.gotoAndStop(1);
						backVis.scaleX=backVis.scaleY=0.5;
						backVis.x=actobj.x1*raz;
						backVis.y=actobj.y1*raz;
						ed.vobj.kvad.visible=false;
						ed.vobj.bv.visible=true;
					} else {
						ed.vobj.kvad.visible=true;
						ed.vobj.bv.visible=false;
					}
					if (actobj.x1=='') actobj.x1=0;
					if (actobj.y1=='') actobj.y1=0;
					if (actobj.x2=='') actobj.x2=1;
					if (actobj.y2=='') actobj.y2=1;
					ed.vobj.kvad.x=actobj.x1*raz;
					ed.vobj.kvad.y=actobj.y1*raz;
					ed.vobj.kvad.scaleX=actobj.x2-actobj.x1;
					ed.vobj.kvad.scaleY=actobj.y2-actobj.y1;
				}
				ed.vobj.kvad.gotoAndStop(kv);
			} else {
				ed.vobj.visible=false;
				ed.objList0.selectedIndex=-1;
				ed.objList1.selectedIndex=-1;
				ed.objList2.selectedIndex=-1;
			}
			
			showSelect(false);
			
		}
		
		//Стирать
		function selEraseFront(event:MouseEvent):void  {
			dey='mat';
			brushPip.ids=['','_','','','',''];
			brushPip.frames=[0,0,0,0,0,0];
			brush=brushPip;
			actobj=null;
			zForm=-1;
			update();
		}
		//Стирать
		function selEraseBack(event:MouseEvent):void  {
			dey='mat';
			brushPip.ids=['','','_','','',''];
			brushPip.frames=[0,0,0,0,0,0];
			brush=brushPip;
			actobj=null;
			zForm=-1;
			update();
		}
		//Стирать
		function selEraseDetails(event:MouseEvent):void  {
			dey='mat';
			brushPip.ids=['','','','_','_','_'];
			brushPip.frames=[0,0,0,0,0,0];
			brush=brushPip;
			actobj=null;
			zForm=-1;
			update();
		}
		
//==========================================================================================================
//					Рабочая область
//==========================================================================================================
		//курсор в рабочей области
		public function onMouseDown2(event:MouseEvent):void {
			mdown(event.stageX,event.stageY,event.altKey);
		}
		public function onMouseUp2(event:MouseEvent):void {
			mup(event.ctrlKey,event.shiftKey);
		}
		public function onMouseMove2(event:MouseEvent):void {
			if (loaded) mmove(event.stageX,event.stageY);
		}
		
		
		//Актуализировать рамку в рабочей области
		public function setRamka() {
			if (endx-begx>=0) {
				ed.ramka.x=ed.setka.x+begx*raz;
				ed.ramka.scaleX=(endx-begx+1)*raz/100;
			} else {
				ed.ramka.x=ed.setka.x+endx*raz;
				ed.ramka.scaleX=(begx-endx+1)*raz/100;
			}
			if (endy-begy>=0) {
				ed.ramka.y=ed.setka.y+begy*raz;
				ed.ramka.scaleY=(endy-begy+1)*raz/100;
			} else {
				ed.ramka.y=ed.setka.y+endy*raz;
				ed.ramka.scaleY=(begy-endy+1)*raz/100;
			}
			
		}
		
		//Кнопка мыши вниз
		public function mdown(mx:int, my:int, pipetka:Boolean=false) {
			begx=endx=Math.floor((mx-ed.setka.x)/raz);
			begy=endy=Math.floor((my-ed.setka.y)/raz);
			if (begx>=0 && begx<spacex && begy>=0 && begy<spacey) {
				mActive=true;
				if (pipetka) {
					space[begx][begy].pipetka(brushPip);
					brush=brushPip;
					update();
				} else if (dey=='select') {
					selectObj(begx, begy);
				} else if (dey=='mat' || dey=='erase' || dey=='eraseb'){
					isDraw=true;
					ed.ramka.visible=true;
					setRamka();
				}
			}
		}
		//Курсор движется в рабочей области
		public function mmove(mx:int, my:int) {
			endx=Math.floor((mx-ed.setka.x)/raz);
			endy=Math.floor((my-ed.setka.y)/raz);
			if (isDraw) {
				setRamka();
			}
			if (ed.vobj && endx>=0 && endx<spacex && endy>=0 && endy<spacey) ed.vobj.alpha=1;
			else ed.vobj.alpha=0;
			if (ed.vobj && ed.vobj.visible) {
				ed.vobj.x=endx*raz+ed.setka.x;
				ed.vobj.y=endy*raz+ed.setka.y;
			}
			if (dey=='select') overObj(endx, endy);
		}
		//Кнопка мыши вверх
		public function mup(erase:Boolean, frame:Boolean=false) {
			if (isDraw) {
				drawRect(erase,frame);
			} else if (dey=='obj') {
				selobj=addObj(endx,endy,actobj.id);
				showSelect();
			}
			isDraw=false;
			ed.ramka.visible=false;
		}
		
		//Добавить объект
		public function addObj(nx:int, ny:int, nid:String, stat:XML=null):Object {
			if (nx<0 || nx>=spacex-1 || ny<0 || ny>spacey-1 || nid==null || nid=='') return null;
			updSelObj();
			var obj=new Object();
			var vobj=new visedobj();
			obj.vis=vobj;
			
			obj.X=nx;
			obj.Y=ny;
			obj.id=nid;
			vobj.x=nx*raz;
			vobj.y=ny*raz;
			vobj.tid.text=nid;
			obj.vis.selPoint.visible=obj.vis.tid.visible=v_ids;
			
			var isback=false;
			var xmll:XML=AllData.d.obj.(@ed>0 && @id==nid)[0];
			if (xmll==null) {
				xmll=AllData.d.back.(@id==nid)[0];
				if (xmll) isback=true;
				else return null;
			}
			vobj.tid.autoSize=TextFieldAutoSize.LEFT;
			var bvis:MovieClip;
			if (isback) {
				vobj.kvad.x=0;
				var x1:int=0, y1:int=0, x2:int=1, y2:int=1;
				if (xmll.@x1.length()) x1=xmll.@x1;
				if (xmll.@y1.length()) y1=xmll.@y1;
				if (xmll.@x2.length()) x2=xmll.@x2;
				if (xmll.@y2.length()) y2=xmll.@y2;
				bvis=resTex.getObj('back_'+ (xmll.@tid.length()?xmll.@tid:nid) +'_t');
				if (bvis==null) bvis=resTex.getObj('back_'+ (xmll.@tid.length()?xmll.@tid:nid) +'_l');
				if (bvis) {
					bvis.stop();
					var frame:int=1;
					if (xmll.@fr.length()) frame=xmll.@fr;
					else frame=Math.floor(Math.random()*bvis.totalFrames+1);
					vobj.bv.addChild(bvis);
					bvis.gotoAndStop(frame);
					vobj.bv.scaleX=vobj.bv.scaleY=0.5;
					bvis.alpha=0.75;
					bvis.x=x1*raz;
					bvis.y=y1*raz;
					vobj.kvad.visible=false;
				} else {
					vobj.kvad.x=x1*raz;
					vobj.kvad.y=y1*raz;
					vobj.kvad.scaleX=x2-x1;
					vobj.kvad.scaleY=y2-y1;
					vobj.kvad.gotoAndStop(20);
				}
				obj.isback=true;
				if (stat==null) obj.xml=<back id={nid} x={nx} y={ny}/>
				else obj.xml=stat;
				if (bvis) {
					if (obj.xml.@w.length()) vobj.bv.scaleX=0.5*obj.xml.@w;
					if (obj.xml.@h.length()) vobj.bv.scaleY=0.5*obj.xml.@h;
				}
				ed.worldback.addChild(vobj);
			} else {
				bvis=resTex.getObj('vis'+nid);
				//bvis=null;
				var scx=(xmll.@size>0)?xmll.@size:1;
				var scy=(xmll.@wid>0)?xmll.@wid:1
				vobj.kvad.scaleX=scx;
				vobj.kvad.scaleY=scy;
				vobj.kvad.gotoAndStop((xmll.@ed>0)?xmll.@ed:1);
				if (stat==null) obj.xml=<obj id={nid} code={code()} x={nx} y={ny}/>
				else {
					obj.xml=stat;
					if (obj.xml.@code.length()==0) obj.xml.@code=code();
				}
				if (obj.xml.@w.length()) obj.vis.kvad.scaleX=obj.xml.@w;
				if (obj.xml.@h.length()) obj.vis.kvad.scaleY=obj.xml.@h;
				if (bvis) {
					bvis.stop();
					vobj.bv.addChild(bvis);
					bvis.scaleX=bvis.scaleY=0.5;
					bvis.x=scx*raz/2;
					bvis.y=raz;
					obj.vis.kvad.visible=!v_vid;
					obj.vis.bv.visible=v_vid;
					obj.isTex=true;
				}
				obj.isback=false;
				ed.worldobj.addChild(vobj);
			}
			vobj.cacheAsBitmap=true;
			objs.push(obj);
			if (isback) return null;
			else return obj;
		}
		
		//выбрать объект
		public function selectObj(nx:int, ny:int) {
			if (!updSelObj()) return;
			var prevselobj=selobj;
			showSelect(false);
			for each (var obj in objs) {
				if (obj.X==nx && obj.Y==ny) {
					if (obj.isback && !v_backobj) {
						continue;
					}
					if (!obj.isback && !v_obj) {
						continue;
					}
					selobj=obj;
					showSelect();
					if (prevselobj!=selobj) return;
				}
			}
		}
		
		public function overObj(nx:int, ny:int) {
			if (onx==nx && ony==ny) return;
			ed.objInfo.visible=false;
			for each (var obj in objs) {
				if (obj.X==nx && obj.Y==ny) {
					if (obj.isback && !v_backobj) {
						return;
					}
					if (!obj.isback && !v_obj) {
						return;
					}
					var lab:String='';
					if (textXML.obj.(@id==obj.id).length() && textXML.obj.(@id==obj.id).n[0].length()) lab=textXML.obj.(@id==obj.id).n[0];
					var xmll=AllData.d.obj.(@id==obj.id);
					if (xmll.length() && xmll[0].@n.length()) lab=xmll[0].@n;
					else {
						xmll=AllData.d.back.(@id==obj.id);
						if (xmll.length() && xmll[0].@n.length()) lab=xmll[0].@n;
					}
					ed.objInfo.visible=true;
					ed.objInfo.text=lab+'\n['+obj.id+']';
					if (obj.xml) {
						if (obj.xml.item.length()) ed.objInfo.text+=' i '+obj.xml.item.length();
						if (obj.xml.scr.length()) ed.objInfo.text+=' scr';
						if (obj.xml.@uid.length()) ed.objInfo.text+='\n uid='+obj.xml.@uid;
						if (obj.xml.@allid.length()) ed.objInfo.text+='\n allid='+obj.xml.@allid;
						if (obj.xml.@allact.length()) ed.objInfo.text+='\n allact='+obj.xml.@allact;
						if (obj.xml.@tr.length()) ed.objInfo.text+='\n tr='+obj.xml.@tr;
						if (obj.xml.@ai.length()) ed.objInfo.text+='\n ai='+obj.xml.@ai;
					}
					ed.objInfo.x=nx*raz+50;
					ed.objInfo.y=ny*raz+80;
					break;
				}
			}
			onx=nx, ony=ny;
		}
		
		public function showIds() {
			for each (var obj in objs) {
				obj.vis.selPoint.visible=obj.vis.tid.visible=v_ids;
				if (obj.isTex) {
					obj.vis.kvad.visible=!v_vid;
					obj.vis.bv.visible=v_vid;
				}
			}
		}
		
		function checkXML(event:MouseEvent):void {
			if (updSelObj()) showSelect();
		}
		
		//отобразить или скрыть XML объекта
		public function showSelect(aps:Boolean=true) {
			if (!aps) {
				updSelObj();
				selobj=null;
			}
			if (selobj==null) {
				ed.SelObj.visible=false;
				ed.SelObj.text='';
			} else {
				ed.SelObj.visible=true;
				ed.SelObj.text=selobj.xml.toXMLString();
			}
		}
		public function updSelObj():Boolean {
			if (selobj) {
				try {
					var n:XML=new XML(ed.SelObj.text);
					selobj.xml=n;
					if (selobj!=optObj) decodeObj(selobj);
				} catch (err) {
					trace('Ошибка в XML')
					return false;
				}
			}
			return true;
		}
		
		public function decodeObj(obj:Object) {
			if (obj.xml is XML) {
				if (obj.xml.@x.length()) obj.X=obj.xml.@x;
				if (obj.xml.@y.length()) obj.Y=obj.xml.@y;
				if (obj.xml.@id.length()) obj.id=obj.xml.@id;
				if (obj.isback) {
					if (obj.xml.@w.length()) {
						obj.vis.kvad.scaleX=obj.xml.@w;
						obj.vis.bv.scaleX=0.5*obj.xml.@w;
					} else {
						obj.vis.bv.scaleX=0.5;
					}
					if (obj.xml.@h.length()) {
						obj.vis.kvad.scaleY=obj.xml.@h;
						obj.vis.bv.scaleY=0.5*obj.xml.@h;
					} else {
						obj.vis.bv.scaleY=0.5;
					}
				} else {
					if (obj.xml.@w.length()) {
						obj.vis.kvad.scaleX=obj.xml.@w;
					}
					if (obj.xml.@h.length()) {
						obj.vis.kvad.scaleY=obj.xml.@h;
					}
				}
				obj.vis.x=obj.X*raz;
				obj.vis.y=obj.Y*raz;
				obj.vis.tid.text=obj.id;
			}
		}
		
		//Рисовать или стирать один блок
		public function drawTile(t:edTile,erase:Boolean=false) {
			if (brush) {
				for (var i=1; i<t.ids.length; i++) {
					if (brush.ids[i]=='_') {
						t.ids[i]='';
						t.frames[i]=0;
					} else if (brush.ids[i]!='') {
						t.ids[i]=brush.ids[i];
						t.frames[i]=brush.frames[i];
					}
				}
			}
			if (zForm>=0) t.zForm=zForm;
			if (erase) {
				for (var i=1; i<t.ids.length; i++) {
					t.ids[i]='';
					t.frames[i]=0;
				}
				t.zForm=0;
			}
			t.upd();
		}
		//Рисовать блоки или стирать объекты и блоки в пределах рамки
		public function drawRect(erase:Boolean=false, frame:Boolean=false) {
			if (begx>endx) {
				var tx=begx;
				begx=endx, endx=tx;
			}
			if (begy>endy) {
				var ty=begy;
				begy=endy, endy=ty;
			}
			var t:edTile;
			if (frame) {
				for (var i=begx; i<=endx; i++) {
					drawTile(space[i][begy],erase);
					drawTile(space[i][endy],erase);
				}
				for (var j=begy; j<=endy; j++) {
					drawTile(space[begx][j],erase);
					drawTile(space[endx][j],erase);
				}
			} else {
				for (i=begx; i<=endx; i++) {
					for (j=begy; j<=endy; j++) {
						drawTile(space[i][j],erase);
					}
				}
			}
			if (erase || dey=='erase') eraseObj();
			if (erase || dey=='eraseb') eraseBackObj();
		}
		//Стереть объекты, попавшие в рамку
		public function eraseObj() {
			objs=objs.filter(isErase);
		}
		public function eraseBackObj() {
			objs=objs.filter(isBackErase);
		}
	    private function isErase(element:*, index:int, arr:Array):Boolean {
			var er:Boolean=!element.isback && element.X>=begx && element.X<=endx && element.Y>=begy && element.Y<=endy;
			if (er) element.vis.parent.removeChild(element.vis);
            return !er;
        }
	    private function isBackErase(element:*, index:int, arr:Array):Boolean {
			var er:Boolean=element.isback && element.X>=begx && element.X<=endx && element.Y>=begy && element.Y<=endy;
			if (er) element.vis.parent.removeChild(element.vis);
            return !er;
        }
		

	}
	
}

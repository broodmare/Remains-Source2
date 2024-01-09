package fe 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	import flash.text.StyleSheet;
	import flash.net.FileReference;
	import flash.net.FileFilter;
	import flash.utils.Timer;

	import fe.inter.PipBuck;
	import fe.inter.PipPageOpt;
	import fe.graph.Displ;

	import fe.stubs.visMainMenu;
	import fe.stubs.butLang;

	public class MainMenu 
	{
		public var version:String='1.0.2';
		private var mm:MovieClip;
		public var main:Sprite;
		private var world:World;
		public var active:Boolean=true;
		public var loaded:Boolean=false;
		private var newGameMode:int=2;
		private var newGameDif:int=2;
		private var loadCell:int=-1;
		private var loadReg:int=0;	//режим окна загрузки, 0 - загрузка, 1 - выбор слота для автосейва
		private var command:int=0;
		private var com:String='';
		private var mmp:MovieClip;//для пипбака
		private var pip:PipBuck;
		private var displ:Displ;
		private var animOn:Boolean=true;
		private var langReload:Boolean=false;
		
		private var kolDifs:int=5;
		private var kolOpts:int=6;
		
		private var butsLang:Array;
		
		private var stn:int=0;
		
		public var style:StyleSheet = new StyleSheet(); 
		private var styleObj:Object = new Object(); 
		
		private var format:TextFormat = new TextFormat();
		
		private var file:FileReference = new FileReference();
		private var ffil:Array;
		private var arr:Array=new Array();
		
		private var mainTimer:Timer;
			
		public function MainMenu(nmain:Sprite) 
		{
			main=nmain;
			mm=new visMainMenu();
			mm.dialLoad.visible=false;
			mm.dialNew.visible=false;
			mm.dialAbout.visible=false;
			main.stage.addEventListener(Event.RESIZE, resizeDisplay); 
			main.stage.addEventListener(Event.ENTER_FRAME, mainStep);
			
			showButtons(false);
			mainMenuOn();
			
			var paramObj:Object = LoaderInfo(main.root.loaderInfo).parameters;
			world=new World(main, paramObj);
			world.mm=this;
			
			mm.testtest.visible=world.testMode;
			mm.info.visible=false;
			Snd.initSnd();
			setMenuSize();
			displ=new Displ(mm.pipka, mm.groza);
			mm.groza.visible=false;
			format.font = "_sans";
            format.color = 0xFFFFFF;
            format.size = 28;
			
			styleObj.fontWeight = "bold"; 
			styleObj.color = "#FFFF00"; 
			style.setStyle(".yel", styleObj); 	//выделение важного
			
			styleObj.fontWeight = "normal"; 
			styleObj.color = "#00FF99";
			styleObj.fontSize= "12";
			style.setStyle(".music", styleObj); 	//мелкий шрифт
			
			styleObj.fontWeight = "normal"; 
			styleObj.color = "#66FF66";
			styleObj.fontSize=undefined;
			style.setStyle("a", styleObj); 	//ссыль
			styleObj.textDecoration= "underline";
			style.setStyle("a:hover", styleObj);
			
			mm.info.txt.styleSheet=style;
			mm.link.l1.styleSheet=style;
			mm.link.l2.styleSheet=style;
		}

		private function mainMenuOn():void
		{
			active=true;
			mm.butNewGame.addEventListener(MouseEvent.MOUSE_OVER, funOver);
			mm.butNewGame.addEventListener(MouseEvent.MOUSE_OUT, funOut);
			mm.butLoadGame.addEventListener(MouseEvent.MOUSE_OVER, funOver);
			mm.butLoadGame.addEventListener(MouseEvent.MOUSE_OUT, funOut);
			mm.butContGame.addEventListener(MouseEvent.MOUSE_OVER, funOver);
			mm.butContGame.addEventListener(MouseEvent.MOUSE_OUT, funOut);
			mm.butOpt.addEventListener(MouseEvent.MOUSE_OVER, funOver);
			mm.butOpt.addEventListener(MouseEvent.MOUSE_OUT, funOut);
			mm.butAbout.addEventListener(MouseEvent.MOUSE_OVER, funOver);
			mm.butAbout.addEventListener(MouseEvent.MOUSE_OUT, funOut);
			mm.butOpt.addEventListener(MouseEvent.CLICK, funOpt);
			mm.butNewGame.addEventListener(MouseEvent.CLICK, funNewGame);
			mm.butLoadGame.addEventListener(MouseEvent.CLICK, funLoadGame);
			mm.butContGame.addEventListener(MouseEvent.CLICK, funContGame);
			mm.butAbout.addEventListener(MouseEvent.CLICK, funAbout);
			mm.adv.addEventListener(MouseEvent.CLICK, funAdv);
			mm.adv.addEventListener(MouseEvent.RIGHT_CLICK, funAdvR);
			if (!main.contains(mm)) main.addChild(mm);
			file.addEventListener(Event.SELECT, selectHandler);
			file.addEventListener(Event.COMPLETE, completeHandler);
		}

		private function mainMenuOff():void
		{
			active=false;
			mm.butNewGame.removeEventListener(MouseEvent.MOUSE_OVER, funOver);
			mm.butNewGame.removeEventListener(MouseEvent.MOUSE_OUT, funOut);
			mm.butLoadGame.removeEventListener(MouseEvent.MOUSE_OVER, funOver);
			mm.butLoadGame.removeEventListener(MouseEvent.MOUSE_OUT, funOut);
			mm.butContGame.removeEventListener(MouseEvent.MOUSE_OVER, funOver);
			mm.butContGame.removeEventListener(MouseEvent.MOUSE_OUT, funOut);
			mm.butOpt.removeEventListener(MouseEvent.MOUSE_OVER, funOver);
			mm.butOpt.removeEventListener(MouseEvent.MOUSE_OUT, funOut);
			mm.butAbout.removeEventListener(MouseEvent.MOUSE_OVER, funOver);
			mm.butAbout.removeEventListener(MouseEvent.MOUSE_OUT, funOut);
			mm.butOpt.removeEventListener(MouseEvent.CLICK, funOpt);
			mm.butNewGame.removeEventListener(MouseEvent.CLICK, funNewGame);
			mm.butLoadGame.removeEventListener(MouseEvent.CLICK, funLoadGame);
			mm.butContGame.removeEventListener(MouseEvent.CLICK, funContGame);
			mm.butAbout.removeEventListener(MouseEvent.CLICK, funAbout);
			mm.adv.removeEventListener(MouseEvent.CLICK, funAdv);
			mm.adv.removeEventListener(MouseEvent.RIGHT_CLICK, funAdvR);
			file.removeEventListener(Event.SELECT, selectHandler);
			file.removeEventListener(Event.COMPLETE, completeHandler);
			for each(var m:MovieClip in butsLang) 
			{
				if (m) m.removeEventListener(MouseEvent.CLICK, funLang);
			}
			if (main.contains(mm)) main.removeChild(mm);
			world.vwait.visible=true;
			world.vwait.progres.text=Res.guiText('loading');
		}

		private function funNewGame(event:MouseEvent):void
		{
			world.mmArmor=false;
			mainLoadOff();
			mainNewOn();
		}

		private function funLoadGame(event:MouseEvent):void
		{
			world.mmArmor=true;
			mainNewOff();
			loadReg=0;
			mainLoadOn();
		}

		//продолжить игру
		private function funContGame(event:MouseEvent):void
		{
			var n:int=0;
			var maxDate:Number=0;
			for (var i:int = 0; i<=world.saveKol; i++) 
			{
				var save:Object=World.w.getSave(i);
				if (save && save.est && save.date>maxDate) 
				{
					n=i;
					maxDate=save.date;
				}
			}

			save=World.w.getSave(n);

			if (save && save.est) 
			{
				mainMenuOff();
				loadCell=n;
				command=3;
			} 
			else 
			{
				mainNewOn();
				mainLoadOff();
			}
		}

		private function funOver(event:MouseEvent):void
		{
			(event.currentTarget as MovieClip).fon.scaleX=1;
			(event.currentTarget as MovieClip).fon.alpha=1.5;
		}

		private function funOut(event:MouseEvent):void
		{
			(event.currentTarget as MovieClip).fon.scaleX=0.7;
			(event.currentTarget as MovieClip).fon.alpha=1;
		}
		
		private function setLangButtons():void
		{
			butsLang=new Array();
			if (world.kolLangs>1) 
			{
				var i:int = world.kolLangs;
				for each(var l:XML in world.langsXML.lang) 
				{
					i--;
					var m:MovieClip=new butLang();
					butsLang[i]=m;
					m.lang.text=l[0];
					m.y=-i*40;
					m.n.text=l.@id;
					m.n.visible=false;
					m.addEventListener(MouseEvent.CLICK, funLang);
					mm.lang.addChild(m);
				}
			}
		}
		
		//надписи
		private function setMainLang():void
		{
			setMainButton(mm.butContGame,Res.guiText('contgame'));
			setMainButton(mm.butNewGame,Res.guiText('newgame'));
			setMainButton(mm.butLoadGame,Res.guiText('loadgame'));
			setMainButton(mm.butOpt,Res.guiText('options'));
			setMainButton(mm.butAbout,Res.guiText('about'));
			mm.dialNew.title.text=Res.guiText('newgame');
			mm.dialLoad.title.text=Res.guiText('loadgame');
			mm.dialLoad.title2.text=Res.guiText('select_slot');
			mm.version.htmlText='<b>'+Res.guiText('version')+' '+version+'</b>';
			mm.dialLoad.butCancel.text.text=mm.dialNew.butCancel.text.text=Res.guiText('cancel');
			mm.dialLoad.butFile.text.text=Res.pipText('loadfile');
			mm.dialLoad.warn.text=mm.dialNew.warn.text=Res.guiText('loadwarn');
			mm.dialNew.infoName.text=Res.guiText('inputname');
			mm.dialNew.hardOpt.text=Res.guiText('hardopt');
			mm.dialNew.butOk.text.text='OK';
			mm.dialNew.inputName.text=Res.txt('u','littlepip');
			mm.dialNew.maxChars=32;
			for (var i:int = 0; i<kolDifs; i++) 
			{
				mm.dialNew['dif'+i].mode.text=Res.guiText('dif'+i);
				mm.dialNew['dif'+i].modeinfo.text=Res.formatText(Res.txt('g','dif'+i,1));
			}
			for (var j:int = 1; i<=kolOpts; i++) //Changed i to j
			{
				mm.dialNew['infoOpt'+i].text=Res.guiText('opt'+i);
			}
			mm.dialNew.butVid.mode.text=Res.guiText('butvid');
			if (world.app) world.app.setLang();
			mm.adv.text=Res.advText(world.nadv);
			mm.adv.y=main.stage.stageHeight-mm.adv.textHeight-40;
			mm.info.txt.htmlText=Res.txt('g','inform')+'<br>'+Res.txt('g','inform',1);
			mm.info.visible=(mm.info.txt.text.length>0);
			setScrollInfo();
		}
		
		private function setMainButton(but:MovieClip, txt:String):void
		{
			but.txt.text=txt;
			but.glow.text=txt;
			but.txt.visible=(but.glow.textWidth<1)
		}
		
		private function setMenuSize():void
		{
			mm.adv.y=main.stage.stageHeight-mm.adv.textHeight-40;
			mm.version.y=main.stage.stageHeight-58;
			mm.link.y=main.stage.stageHeight-125;
			var ny:int = main.stage.stageHeight-400;
			if (ny<280) ny=280;
			mm.dialLoad.x=mm.dialNew.x=world.app.vis.x=main.stage.stageWidth/2;
			mm.dialLoad.y=mm.dialNew.y=world.app.vis.y=ny;
			mm.lang.x=main.stage.stageWidth-30;
			mm.lang.y=main.stage.stageHeight-50;
			mm.info.txt.height=mm.info.scroll.height=mm.link.y-mm.info.y-20;
			setScrollInfo();
		}
		
		private function setScrollInfo():void
		{
			if (mm.info.txt.height<mm.info.txt.textHeight) 
			{
				mm.info.scroll.maxScrollPosition=mm.info.txt.maxScrollV;
				mm.info.scroll.visible=true;
			} 
			else mm.info.scroll.visible=false;
		}
		
		private function resizeDisplay(event:Event):void
		{
			world.resizeScreen();
			if (active) setMenuSize();
		}

		//загрузка игры
		private function mainLoadOn():void
		{
			mm.dialLoad.visible=true;
			mm.dialLoad.title2.visible=(loadReg==1);
			mm.dialLoad.title.visible=(loadReg==0);
			mm.dialLoad.slot0.visible=(loadReg==0);
			mm.dialLoad.info.text='';
			mm.dialLoad.nazv.text='';
			mm.dialLoad.pers.visible=false;
			arr=new Array();
			for (var i:int = 0; i<=world.saveKol; i++) 
			{
				var slot:MovieClip=mm.dialLoad['slot'+i];
				var save:Object=World.w.getSave(i);
				var obj:Object=fe.inter.PipPageOpt.saveObj(save,i);
				arr.push(obj);
				slot.id.text=i;
				slot.id.visible=false;
				if (save!=null && save.est!=null) {
					slot.nazv.text=(i==0)?Res.pipText('autoslot'):(Res.pipText('saveslot')+' '+i);
					slot.ggName.text=(save.pers.persName==null)?'-------':save.pers.persName;
					if (save.pers.level!=null) slot.ggName.text+=' ('+save.pers.level+')';
					if (save.pers.dead) slot.nazv.text+=' [†]';
					else if (save.pers.hardcore) slot.nazv.text+=' {!}';
					slot.date.text=(save.date==null)?'-------':Res.getDate(save.date);
					slot.land.text=(save.date==null)?'':Res.txt('m',save.game.land).substr(0,18);
				} 
				else 
				{
					slot.nazv.text=Res.pipText('freeslot');
					slot.ggName.text=slot.land.text=slot.date.text='';
				}
				slot.addEventListener(MouseEvent.CLICK, funLoadSlot);
				slot.addEventListener(MouseEvent.MOUSE_OVER, funOverSlot);
			}
			mm.dialLoad.butCancel.addEventListener(MouseEvent.CLICK, funLoadCancel);
			mm.dialLoad.butFile.addEventListener(MouseEvent.CLICK, funLoadFile);
			animOn=false;
		}
		
		private function mainLoadOff():void
		{
			mm.dialLoad.visible=false;
			if (mm.dialLoad.butCancel.hasEventListener(MouseEvent.CLICK)) 
			{
				mm.dialLoad.butCancel.removeEventListener(MouseEvent.CLICK, funLoadCancel);
				mm.dialLoad.butFile.removeEventListener(MouseEvent.CLICK, funLoadFile);
			}
			for (var i:int = 0; i<=world.saveKol; i++)
			{
				var slot:MovieClip=mm.dialLoad['slot'+i];
				if (slot.hasEventListener(MouseEvent.CLICK)) 
				{
					slot.removeEventListener(MouseEvent.CLICK, funLoadSlot);
					slot.removeEventListener(MouseEvent.MOUSE_OVER, funOverSlot);
				}
			}
			animOn=true;
		}
		
		private function funLoadCancel(event:MouseEvent):void
		{
			mainLoadOff();
		}

		//выбрать слот
		private function funLoadSlot(event:MouseEvent):void
		{
			loadCell=event.currentTarget.id.text;
			if (loadReg==1 && loadCell==0) return;
			if (loadReg==0 && event.currentTarget.ggName.text=='') return;
			mainLoadOff();
			mainMenuOff();
			command=3;
			if (loadReg==1) com='new';
			else com='load';
		}

		private function funOverSlot(event:MouseEvent):void
		{
			fe.inter.PipPageOpt.showSaveInfo(arr[event.currentTarget.id.text],mm.dialLoad);
		}
		
		private function funLoadFile(event:MouseEvent):void
		{
			ffil=[new FileFilter(Res.pipText('gamesaves')+" (*.sav)", "*.sav")];
			file.browse(ffil);
		}
		
		private function selectHandler(event:Event):void 
		{
            file.load();
        }

		private function completeHandler(event:Event):void 
		{
			try 
			{
				var obj:Object=file.data.readObject();
				if (obj && obj.est==1){
					loadCell=99;
					world.loaddata=obj;
					mainLoadOff();
					mainMenuOff();
					command=3;
					com='load';
					return;
				}
			} 
			catch(err) {}
			trace('Error load');
       }		
		
		//новая игры
		private function mainNewOn():void
		{
			mm.dialNew.visible=true;
			mm.dialNew.butCancel.addEventListener(MouseEvent.CLICK, funNewCancel);
			mm.dialNew.butOk.addEventListener(MouseEvent.CLICK, funNewOk);
			mm.dialNew.butVid.addEventListener(MouseEvent.CLICK, funNewVid);
			for (var i:int = 0; i<kolDifs; i++) 
			{
				mm.dialNew['dif'+i].addEventListener(MouseEvent.CLICK, funNewDif);
				mm.dialNew['dif'+i].addEventListener(MouseEvent.MOUSE_OVER, infoMode);
			}
			for (var j:int = 1; i<=kolOpts; i++) //Changed i to j
			{
				mm.dialNew['infoOpt'+i].addEventListener(MouseEvent.MOUSE_OVER, infoOpt);
				mm.dialNew['checkOpt'+i].addEventListener(MouseEvent.MOUSE_OVER, infoOpt);
			}
			updNewMode();
			mm.dialNew.pers.gotoAndStop(2);
			mm.dialNew.pers.gotoAndStop(1);
			animOn=false;
		}

		private function mainNewOff():void
		{
			mm.dialNew.visible=false;
			if (mm.dialNew.butCancel.hasEventListener(MouseEvent.CLICK)) mm.dialNew.butCancel.removeEventListener(MouseEvent.CLICK, funNewCancel);
			if (mm.dialNew.butOk.hasEventListener(MouseEvent.CLICK)) mm.dialNew.butOk.removeEventListener(MouseEvent.CLICK, funNewOk);
			if (mm.dialNew.butOk.hasEventListener(MouseEvent.CLICK)) 
			{
				mm.dialNew.butVid.removeEventListener(MouseEvent.CLICK, funNewVid);
				for (var i:int = 0; i<kolDifs; i++) 
				{
					mm.dialNew['dif'+i].removeEventListener(MouseEvent.CLICK, funNewDif);
					mm.dialNew['dif'+i].removeEventListener(MouseEvent.MOUSE_OVER, infoMode);
				}
			}
			animOn=true;
		}

		private function funAdv(event:MouseEvent):void
		{
			world.nadv++;
			if (world.nadv>=world.koladv) world.nadv=0;
			mm.adv.text=Res.advText(world.nadv);
			mm.adv.y=main.stage.stageHeight-mm.adv.textHeight-40;
		}

		private function funAdvR(event:MouseEvent):void
		{
			world.nadv--;
			if (world.nadv<0) world.nadv=world.koladv-1;
			mm.adv.text=Res.advText(world.nadv);
			mm.adv.y=main.stage.stageHeight-mm.adv.textHeight-40;
		}

		private function funNewCancel(event:MouseEvent):void
		{
			mainNewOff();
		}
		//нажать ОК в окне новой игры
		private function funNewOk(event:MouseEvent):void
		{
			mainNewOff();
			if (mm.dialNew.checkOpt2.selected) //показать окно выбора слота
			{
				loadReg=1;
				mainLoadOn();
			} 
			else 
			{
				mainMenuOff();
				loadCell=-1;
				command=3;
				com='new';
			}
		}

		//включить настройки внешности
		private function funNewVid(event:MouseEvent):void
		{
			setMenuSize();
			mm.dialNew.visible=false;
			world.app.attach(mm,funVidOk,funVidOk);
		}

		//принять настройки внешности
		private function funVidOk():void
		{
			mm.dialNew.visible=true;
			world.app.detach();
			mm.dialNew.pers.gotoAndStop(2);
			mm.dialNew.pers.gotoAndStop(1);
		}

		private function funNewDif(event:MouseEvent):void
		{
			if (event.currentTarget==mm.dialNew.dif0) newGameDif=0;
			if (event.currentTarget==mm.dialNew.dif1) newGameDif=1;
			if (event.currentTarget==mm.dialNew.dif2) newGameDif=2;
			if (event.currentTarget==mm.dialNew.dif3) newGameDif=3;
			if (event.currentTarget==mm.dialNew.dif4) newGameDif=4;
			updNewMode();
		}

		private function updNewMode():void
		{
			mm.dialNew.dif0.fon.gotoAndStop(1);
			mm.dialNew.dif1.fon.gotoAndStop(1);
			mm.dialNew.dif2.fon.gotoAndStop(1);
			mm.dialNew.dif3.fon.gotoAndStop(1);
			mm.dialNew.dif4.fon.gotoAndStop(1);
			if (newGameDif==0) mm.dialNew.dif0.fon.gotoAndStop(2);
			if (newGameDif==1) mm.dialNew.dif1.fon.gotoAndStop(2);
			if (newGameDif==2) mm.dialNew.dif2.fon.gotoAndStop(2);
			if (newGameDif==3) mm.dialNew.dif3.fon.gotoAndStop(2);
			if (newGameDif==4) mm.dialNew.dif4.fon.gotoAndStop(2);
		}

		private function infoMode(event:MouseEvent):void
		{
			mm.dialNew.modeinfo.htmlText=event.currentTarget.modeinfo.text;
		}

		private function infoOpt(event:MouseEvent):void
		{
			var n:int = int(event.currentTarget.name.substr(event.currentTarget.name.length-1));
			mm.dialNew.modeinfo.htmlText=Res.formatText(Res.txt('g','opt'+n,1));
		}
		
		private function funOpt(event:MouseEvent):void
		{
			mainNewOff();
			mainLoadOff();
			world.pip.onoff();
		}

		private function funLang(event:MouseEvent):void
		{
			mm.loading.text='';
			var nid:String = event.currentTarget.n.text;
			if (nid==world.lang) return;
			world.defuxLang(nid);
			if (nid==world.langDef) 
			{
				setMainLang();
			} 
			else 
			{
				langReload=true;
				showButtons(false);
				mm.loading.text='Loading';
			}
		}
		
		private function showButtons(n:Boolean):void
		{
			mm.lang.visible=mm.butNewGame.visible=mm.butLoadGame.visible=mm.butContGame.visible=mm.butOpt.visible=mm.butAbout.visible=n;
		}
		
		//создатели
		private function funAbout(event:MouseEvent):void
		{
			mm.dialAbout.title.text=Res.guiText('about');
			var s:String=Res.formatText(Res.txt('g','about',1));
			s+='<br><br>'+Res.guiText('usedmusic')+'<br>';
			s+="<br><span class='music'>"+Res.formatText(Res.d.gui.(@id=='usedmusic').info[0])+"</span>"
			s+="<br><br><a href='https://creativecommons.org/licenses/by-nc/4.0/legalcode'>Music CC-BY License</a>";
			mm.dialAbout.txt.styleSheet=style;
			mm.dialAbout.txt.htmlText=s;
			mm.dialAbout.visible=true;
			mm.dialAbout.butCancel.addEventListener(MouseEvent.CLICK, funAboutOk);
			mm.dialAbout.scroll.maxScrollPosition=mm.dialAbout.txt.maxScrollV;
		}

		private function funAboutOk(event:MouseEvent):void
		{
			mm.dialAbout.visible=false;
			mm.dialAbout.butCancel.removeEventListener(MouseEvent.CLICK, funAboutOk);
		}
		
		private function step():void
		{
			if (langReload) 
			{
				if (world.textLoaded) 
				{
					langReload=false;
					showButtons(true);
					if (world.textLoadErr) mm.loading.text='Language loading error';
					else mm.loading.text='';
					world.pip.updateLang();
					setMainLang();
				}
				return;
			}
			if (loaded) 
			{
				if (animOn && !world.pip.active) displ.anim();
				if (world.allLandsLoaded && world.textLoaded) 
				{
					if (world.musicKol>world.musicLoaded) mm.loading.text='Music loading '+world.musicLoaded+'/'+world.musicKol;
					else mm.loading.text='';
				}
				return;
			}
			if (world.grafon.resIsLoad) 
			{
				stn++;
				mm.loading.text='Loading '+(Math.floor(stn/30))+'\n';
				if (world.textLoaded) world.init2();
				if (world.allLandsLoaded && world.textLoaded) 
				{
					setLangButtons();
					setMainLang();
					loaded=true;
					showButtons(true);
					return;
				}
				mm.loading.text+=world.load_log;
			} 
			else 
			{
				mm.loading.text='Loading '+Math.round(world.grafon.progressLoad*100)+'%';
			}
		}
		
		public function log(s:String):void
		{
			mm.loading.text+=s+'; ';
		}

		private function mainStep(event:Event):void 
		{
			if (active) step();
			else if (command>0)
			{
				command--;
				if (command==1 && !mm.dialNew.checkOpt1.selected && com=='new') 
				{
					world.setLoadScreen(0);
				}
				
				if (command==0) //начать игру !!!!
				{
					var opt:Object;
					if (com=='new')
					{
						//propusk - опция 1 - пропуск обучения
						//hardcore - опция 2
						//fastxp - опция 3, опыта нужно на 40% меньше
						//rndpump - опция 4, случайная прокачка
						//hardskills - давать по 3 sp за уровень
						//autoSaveN - ячейка автосейва
						opt={dif:newGameDif,
							propusk:mm.dialNew.checkOpt1.selected,
							hardcore:mm.dialNew.checkOpt2.selected,
							fastxp:mm.dialNew.checkOpt3.selected,
							rndpump:mm.dialNew.checkOpt4.selected,
							hardskills:mm.dialNew.checkOpt5.selected,
							hardinv:mm.dialNew.checkOpt6.selected};
						if (opt.hardcore) opt.autoSaveN=loadCell;
						loadCell=-1;
					}
					world.newGame(loadCell,mm.dialNew.inputName.text,opt);
				}
			} 
			else world.step();
		}			
	}	
}
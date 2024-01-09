package fe.inter {
	
	import fe.*;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import fl.controls.ScrollBar;
	import fl.events.ScrollEvent;
	import flash.display.StageDisplayState;
	import fl.controls.CheckBox;
	import flash.net.FileReference;
	import flash.net.FileFilter;
	import flash.net.URLLoader; 
	import flash.net.URLRequest; 
	import flash.utils.ByteArray;
	
	public class PipPageOpt extends PipPage{
		
		var setkeyAction:String;
		var setkeyCell:int=1;
		var setkeyKey;
		var nSave:int=-1;
		var info:TextField;
		var hit1:Boolean, hit2:Boolean;
		
		var file:FileReference = new FileReference();
		var ffil:Array;
		
		public function PipPageOpt(npip:PipBuck, npp:String) {
			isLC=true;
			itemClass=visPipOptItem;
			super(npip,npp);
			vis.butOk.addEventListener(MouseEvent.CLICK,transOk);
			vis.butDef.addEventListener(MouseEvent.CLICK,gotoDef);
			file.addEventListener(Event.SELECT, selectHandler);
			file.addEventListener(Event.COMPLETE, completeHandler);
			pip.vis.butHelp.visible=false;
			var log=new logText();
			info=log.text;
			log.x=20;
			log.y=85;
			vis.addChild(log);
			// constructor code
		}

		//подготовка страниц
		override function setSubPages() {
			info.visible=false;
			statHead.visible=false;
			vis.butOk.visible=vis.butDef.visible=false;
			vis.pers.visible=false;
			vis.info.y=160;
			nSave=-1;
			if (page2==3) {
				statHead.nazv.text=statHead.numb.text='';
				arr.push({id:'fullscreen'});
				arr.push({id:'zoom100', check:World.w.zoom100});
				arr.push({id:'quake', check:World.w.quakeCam});
				arr.push({id:'opt1_1', numb:Math.round(Snd.globalVol*100)});
				arr.push({id:'opt1_2', numb:Math.round(Snd.musicVol*100)});
				arr.push({id:'opt1_3', numb:Math.round(Snd.stepVol*100)});
				arr.push({id:'help_mess', check:World.w.helpMess});
				arr.push({id:'dial_on', check:World.w.dialOn});
				arr.push({id:'show_hit1', check:World.w.showHit>0});
				arr.push({id:'show_hit2', check:World.w.showHit==2});
				arr.push({id:'hint_tele', check:World.w.hintTele});
				arr.push({id:'sys_cur', check:World.w.sysCur});
				arr.push({id:'show_favs', check:World.w.showFavs});
				arr.push({id:'mat_filter', check:World.w.matFilter});
				arr.push({id:'err_show', check:World.w.errorShowOpt});
				arr.push({id:'autotake'});
			}
			if (page2==6) {
				arr.push({id:'vsWeaponNew', check:World.w.vsWeaponNew});
				arr.push({id:'vsWeaponRep', check:World.w.vsWeaponRep});
				arr.push({id:'vsAmmoAll', check:World.w.vsAmmoAll});
				arr.push({id:'vsAmmoTek', check:World.w.vsAmmoTek});
				arr.push({id:'vsExplAll', check:World.w.vsExplAll});
				arr.push({id:'vsMedAll', check:World.w.vsMedAll});
				arr.push({id:'vsHimAll', check:World.w.vsHimAll});
				arr.push({id:'vsEqipAll', check:World.w.vsEqipAll});
				arr.push({id:'vsStuffAll', check:World.w.vsStuffAll});
				arr.push({id:'vsVal', check:World.w.vsVal});
				arr.push({id:'vsBook', check:World.w.vsBook});
				arr.push({id:'vsFood', check:World.w.vsFood});
				arr.push({id:'vsComp', check:World.w.vsComp});
				arr.push({id:'vsIngr', check:World.w.vsIngr});
			}
			if (page2==4) {
				setTopText('infokeys');
				for (i in World.w.ctr.keyObj) {
					var key:Object=World.w.ctr.keyObj[i];
					obj={id:key.id, nazv:Res.txt('k',key.id), a1:key.a1, a2:key.a2};
					arr.push(obj);
				}
				vis.butOk.text.text=Res.pipText('accept');
				vis.butDef.visible=true;
				vis.butDef.text.text=Res.pipText('default');
			}
			if (page2==5) {
				if (pip.light) return;
				info.visible=true;
				info.styleSheet=World.w.gui.style;
				info.htmlText=World.w.log;
				info.scrollV=info.maxScrollV;
			}
			if (page2==1 || page2==2) {
				if (pip.light) return;
				vis.butDef.visible=true;
				World.w.app.saveOst();
				if (page2==1) {
					setTopText('infoload');
					vis.butOk.text.text=Res.pipText('opt1');
					vis.butDef.text.text=Res.pipText('loadfile');
				} else {
					setTopText('infosave');
					if (World.w.pers.hardcore) {
						nSave=World.w.autoSaveN;
						vis.butOk.visible=true;
					}
					vis.butOk.text.text=Res.pipText('opt2');
					if (gg.pers.hardcore) vis.butDef.visible=false;
					vis.butDef.text.text=Res.pipText('savefile');
				}
				for (var i=0; i<=World.w.saveKol; i++) {
					var save:Object=World.w.getSave(i);
					var obj:Object=saveObj(save,i);
					arr.push(obj);
				}
				if (page2==2 && World.w.pers.hardcore) {
					showSaveInfo(arr[nSave],vis);
				}
				pip.vis.butHelp.visible=true;
				pip.helpText=Res.txt('p','helpSave',0,true);
			}
		}
		
		public static function saveObj(save:Object, n):Object {
			var obj:Object={id:n};
			if (save==null || save.est==null) {
				obj.nazv=Res.pipText('freeslot');
				obj.gg='';
				obj.date='';
			} else {
				obj.nazv=(n==0)?Res.pipText('autoslot'):(Res.pipText('saveslot')+' '+n);
				obj.gg=(save.pers.persName==null)?'-------':save.pers.persName;
				obj.land=Res.txt('m',save.game.land);
				obj.level=(save.pers.level==null)?'':save.pers.level;
				obj.date=(save.date==null)?'-------':Res.getDate(save.date);
				obj.dif=Res.guiText('dif'+save.game.dif);
				obj.app=save.app;
				obj.armor=save.invent.cArmorId;
				if (save.pers.dead) obj.hard=2;
				else if (save.pers.hardcore) obj.hard=1;
				if (save.hardInv) obj.hardInv=1;
				if (save.pers.rndpump) obj.rndpump=1;
				obj.time=Res.gameTime(save.game.t_save);
				obj.ver=save.ver;
			}
			return obj;
		}		
		
		//показ одного элемента
		override function setStatItem(item:MovieClip, obj:Object) {
			if (obj.id!=null) item.id.text=obj.id;
			else item.id.text='';
			item.id.visible=false;
			item.scr.visible=false;
			item.check.visible=false;
			item.key1.visible=item.key2.visible=false;
			item.ramka.visible=false;
			item.land.text='';
			if (page2==3 || page2==6) {
				item.nazv.text=Res.pipText(obj.id);
				item.ggName.text='';
				if (obj.numb!=null) {
					item.numb.text=obj.numb;
					var scr:ScrollBar=item.scr;
					scr.visible=true;
					scr.minScrollPosition=0;
					scr.maxScrollPosition=100;
					scr.scrollPosition=obj.numb;
					if (!scr.hasEventListener(ScrollEvent.SCROLL)) scr.addEventListener(ScrollEvent.SCROLL,optScroll);
				} else {
					item.numb.text='';
				}
				if (obj.check!=null) {
					item.check.visible=true;
					var ch:CheckBox=item.check;
					ch.selected=obj.check;
					if (!ch.hasEventListener(Event.CHANGE)) ch.addEventListener(Event.CHANGE,optCheck);
				}
			}
			if (page2==4) {
				item.key1.visible=item.key2.visible=true;
				item.numb.text=item.ggName.text='';
				item.nazv.text=obj.nazv;
				setVisKey(obj.a1,item.key1);
				setVisKey(obj.a2,item.key2);
			}
			if (page2==1 || page2==2) {
				item.nazv.text=obj.nazv;
				item.numb.text=obj.date;
				item.ggName.text=obj.gg;
				if (obj.level) item.ggName.text+=((obj.level!='')?(' ('+obj.level+')'):'');
				if (obj.land) item.land.text=obj.land.substr(0,18);
				if (obj.hard==1) item.nazv.text+=' {!}';
				if (obj.hard==2) item.nazv.text+=' [†]';
				if (nSave==obj.id) item.ramka.visible=true;
			}
		}
		
		//установить визуальное отображение клавиши
		function setVisKey(n,vis) {
			vis.txt.text='';
			vis.gotoAndStop(1);
			if (n==null) return;
			try {
				vis.txt.text=World.w.ctr.keyNames[n];
			} catch(err) {
				vis.gotoAndStop(n);
			}

		}
		
		//показать окно назначения клавиши
		function showSetKey() {
			pip.vissetkey.visible=true;
			pip.vissetkey.txt.htmlText=Res.guiText('setkeyinfo')+'\n\n<b>'+Res.txt('k',setkeyAction)+'</b>\n'+setkeyCell;
			World.w.ctr.requestKey(unshowSetKey);
		}
		
		function unshowSetKey() {
			var newkey=World.w.ctr.setkeyRequest;
			pip.vissetkey.visible=false;
			if (newkey!=-1) {
				for (var i in arr) {
					if (newkey!=null) {
						if (arr[i].a1==newkey) arr[i].a1=null;
						if (arr[i].a2==newkey) arr[i].a2=null;
					}
					if (arr[i].id==setkeyAction) {
						if (setkeyCell==1) arr[i].a1=newkey;
						if (setkeyCell==2) arr[i].a2=newkey;
					}
				}
				setStatItems();
				vis.butOk.visible=true;
			}
		}
		
		public override function setStatus(flop:Boolean=true) {
			if (pip.light) {
				vis.but5.visible=vis.but1.visible=vis.but2.visible=false;
				if (page2==1 || page2==2) page2=3;
			} else {
				vis.but5.visible=vis.but1.visible=vis.but2.visible=true;
			}
			super.setStatus(flop);
		}
		public override function updateLang() {
			vis.butOk.text.text=Res.pipText('accept');
			vis.butDef.text.text=Res.pipText('default');
			super.updateLang();
		}
		
		public function optScroll(event:ScrollEvent) {
			event.currentTarget.parent.numb.text=Math.round(event.position);
			var id=event.currentTarget.parent.id.text;
			if (id=='opt1_1') {
				Snd.globalVol=(event.position/100).toFixed(2);
				Snd.onSnd=Snd.globalVol>0;
				Snd.ps('mine_bip',1000,0);
			}
			if (id=='opt1_2') {
				Snd.musicVol=(event.position/100).toFixed(2);
				Snd.onMusic=Snd.musicVol>0;
				Snd.updateMusicVol();
			}
			if (id=='opt1_3') {
				Snd.stepVol=(event.position/100).toFixed(2);
			}
			pip.isSaveConf=true;
		}

		public function optCheck(event:Event) {
			var id=event.currentTarget.parent.id.text;
			var sel:Boolean=(event.target as CheckBox).selected;
			if (id=='dial_on') World.w.dialOn=sel;
			if (id=='mat_filter') World.w.matFilter=sel;
			if (id=='help_mess') World.w.helpMess=sel;
			hit1=World.w.showHit>0;
			hit2=World.w.showHit==2;
			if (id=='show_hit1') hit1=sel;
			if (id=='show_hit2') hit2=sel;
			World.w.showHit=hit1?(hit2?2:1):0;
			if (id=='sys_cur') World.w.sysCur=sel
			if (id=='hint_tele') World.w.hintTele=sel;
			if (id=='show_favs') World.w.showFavs=sel;
			if (id=='quake') World.w.quakeCam=sel;
			if (id=='err_show') World.w.errorShowOpt=sel;
			if (id=='zoom100') {
				World.w.zoom100=sel;
				if (!pip.light) {
					if (sel) World.w.cam.setZoom(0);
					else World.w.cam.setZoom(2);
				} else {
					if (sel) World.w.cam.isZoom=0;
					else World.w.cam.isZoom=2;
				}
			}
			if (page2==6) {
				World.w[id]=sel;
				World.w.checkLoot=true;
			}
			pip.isSaveConf=true;
		}
		
		
		override function itemClick(event:MouseEvent) {
			if (World.w.ctr.setkeyOn) return;
			if (page2==3) {
				if (event.currentTarget.id.text=='fullscreen') {
					World.w.swfStage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
				}
				if (event.currentTarget.id.text=='autotake') {
					page2=6;
					setStatus();
				}
			} else if (page2==4) {
				if (event.target.parent.name=='key1' || event.target.name=='key1') setkeyCell=1;
				else if (event.target.parent.name=='key2' || event.target.name=='key2') setkeyCell=2;
				else return;
				if (setkeyCell==1 && event.currentTarget.key1.txt.text=='TAB') return;
				setkeyAction=event.currentTarget.id.text;
				showSetKey();
			} else if (page2==1 || page2==2) {
				if (pip.noAct && page2==2) {
					World.w.gui.infoText('noAct');
					return;
				}
				if (page2==2 && gg.pers.hardcore) return;
				var numb:int=event.currentTarget.id.text;
				if (page2==1 && event.currentTarget.numb.text=='') return;
				nSave=numb;
				setStatItems();
				showSaveInfo(arr[numb],vis);
				vis.butOk.visible=true;
			}
		}
		
		//применить настройки
		function transOk(event:MouseEvent) {
			if (page2==4) {
				for (var i in arr) {
					var obj=World.w.ctr.keyIds[arr[i].id];
					obj.a1=arr[i].a1;
					obj.a2=arr[i].a2;
				}
				vis.butOk.visible=false;
				World.w.ctr.updateKeys();
				World.w.saveConfig();
			} else if (page2==1) {
				World.w.comLoad=nSave;
			} else if (page2==2) {
				if (pip.noAct) {
					World.w.gui.infoText('noAct');
					return;
				}
					try {
						World.w.saveGame(nSave);
						World.w.gui.infoText('SaveGame');
						nSave=-1;
						vis.butOk.visible=false;
						setStatus();
					} catch (err) {
						World.w.gui.infoText('noSaveGame');
					}
			}
		}
		
		private function selectHandler(event:Event):void {
            file.load();
        }		
		private function completeHandler(event:Event):void {
			try {
				var obj:Object=file.data.readObject();
				if (obj && obj.est==1) {
					World.w.comLoad=99;
					World.w.loaddata=obj;
					return;
				}
			} catch(err) {}
			World.w.gui.infoText('noLoadGame');
			trace('Error load');
       }		
		
		function gotoDef(event:MouseEvent) {
			if (page2==4) {
				World.w.ctr.gotoDef();
				World.w.ctr.updateKeys();
				World.w.saveConfig();
				setStatus();
			} else if (page2==1) {
				ffil=[new FileFilter(Res.pipText('gamesaves')+" (*.sav)", "*.sav")];
				file.browse(ffil);
			} else if (page2==2) {
				if (pip.noAct) {
					World.w.gui.infoText('noAct');
					return;
				}
				//сохранить в файл
				var obj:Object=new Object();
				World.w.saveToObj(obj);
				var ba:ByteArray=new ByteArray();
				ba.writeObject(obj);
				var sfile = new FileReference();
				try {
					sfile.save(ba,gg.pers.persName+'('+gg.pers.level+').sav');
				} catch(err) {
					sfile.save(ba,'Name('+gg.pers.level+').sav');
				}
				//World.w.gui.infoText('SaveGame');
			}
		}
		
		
		public static function showSaveInfo(obj:Object, vis:MovieClip) {
			vis.info.htmlText='';
			if (obj && obj.gg!='') {
				vis.nazv.text=obj.gg;
				World.w.app.load(obj.app);
				World.w.pip.setArmor(obj.armor);
				vis.pers.gotoAndStop(2);
				vis.pers.gotoAndStop(1);
				vis.pers.head.morda.magic.visible=false;
				vis.pers.visible=true;
				vis.info.y=vis.pers.y+25;
				vis.info.htmlText+=Res.pipText('level')+': '+yel(obj.level)+'\n';
				vis.info.htmlText+=obj.land+'\n';
				vis.info.htmlText+='\n';
				vis.info.htmlText+=Res.pipText('diff')+': '+yel(obj.dif)+'\n';
				if (obj.hard==1) vis.info.htmlText+=Res.guiText('opt2')+'\n';
				if (obj.hard==2) vis.info.htmlText+=red(Res.pipText('dead'))+'\n';
				if (obj.hardInv==1) vis.info.htmlText+=Res.guiText('opt6')+'\n';
				if (obj.rndpump==1) vis.info.htmlText+=Res.guiText('opt4')+'\n';
				if (obj.ver) vis.info.htmlText+=Res.guiText('version')+': '+yel(obj.ver)+'\n';
				vis.info.htmlText+=Res.pipText('tgame')+': '+yel(obj.time)+'\n';
				vis.info.htmlText+=Res.pipText('saved')+': '+yel(obj.date)+'\n';
			} else {
				vis.nazv.text='';
				vis.pers.visible=false;
			}
		}
		
		//информация об элементе
		override function statInfo(event:MouseEvent) {
			if (page2==3 || page2==6) {
				vis.info.htmlText=Res.txt('p',event.currentTarget.id.text,1);
			} else if (page2==1 || page2==2) {
				if (nSave<0) showSaveInfo(arr[event.currentTarget.id.text],vis);
			} else 	vis.info.text='';
		}
	}
	
}

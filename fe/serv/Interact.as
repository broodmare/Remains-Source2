package fe.serv {
	
	import fe.*;
	import fe.loc.*;
	import fe.unit.Unit;
	import fe.weapon.Bullet;
	import fe.unit.UnitPlayer;
	import fe.graph.Emitter;
	import flash.media.SoundChannel;
	import flash.sampler.StackFrame;
	
	public class Interact {
		
		//public var id:String;
		
		var inited:Boolean=false;
		public var owner:Obj;
		public var loc:Location;
		public var X:Number, Y:Number;
		
		public var active:Boolean=true;	//объект активен
		//действие, отображаемое в GUI
		public var action:int=0;		//можно выполнить по отношению к нему действие //1 - открыть	2 - использовать	3 - разминировать
		public var userAction:String;	//заданное действие (id)
		
		public var xml:XML;				//индивидуальный параметр, взятый из карты
			
		public var cont:String;			//Контейнер для лута
		public var door:int=0;			//дверь
		public var knop:int=0;			//кнопка
		public var expl:int=0;			//бомба
		
		public var lock:int=0;			//заперто (сложность замка)
		public var lockTip:int=1;		//тип замка 1 - обычный (взлом), 2 - электронный (хакер), 3 - заминировано, 4 - отключить (ремонт), 5 - починить (ремонт), 0 - нельзя взломать
		public var lockLevel:int=0;		//уровень замка (требования к уровню скилла)
		public var lockAtt:int=-100;	//попытки
		public var lockHP:Number=10;	//ХП замка
		public var noRuna:Boolean=false;//нельзя использовать руну или отмычку
		public var low:Number=0;		//вероятность понижения сложности замка в 2 раза
		public var mine:int=0;			//заминировано
		public var mineTip:int=3;		//3 - бомба, 6 - сигнализация
		public var damage:Number=0;		//урон от взрыва
		public var destroy:Number=0;	//разрушение от взрыва
		public var explRadius:Number=260;	//радиус от взрыва
		public var damdis:Number=50;		//удар током
		public var at_once:int=0;		//1-применить основное действие сразу же после взлома или разминирования, 2-после этого сделать неактивным
		public var lockKey:String;		//ключ к замку
		public var cons:String;			//уменьшить количество ключей после успешного применения: 0 - не уменьшать, 1 - использовать ключ сразу, 2 - использовать только если замок нельзя открыть другим способом
		public var allDif:Number=-1;		//общая сложность замка и бомбы
		public var xp:int=0;			//опыт за вскрытие
		
		public var allact:String;		//заданное действие на всю комнату
		public var allid:String;		//ид для заданного действия
		public var needSkill:String;
		public var needSkillLvl:int=0;
		public var is_hack:Boolean=false;	//управляется терминалом доступа
		public var open:Boolean=false;	//открыто
		public var prob:String=null;		//переход к испытанию
		public var noBase:Boolean=false;	//правила базы здесь не работают
		public var prize:Boolean=false;	//призовой контейнер испытания
		
		public var is_act:Boolean=false, is_ready:Boolean=true
		public var t_action:int=0;
		public var unlock:int=0;		//способность к взлому
		public var master:int=0;		//мастерство взлома
		
		public var stateText='';
		public var actionText='';
		public var sndAct='';
		
		public var successUnlock:Function, fiascoUnlock:Function;
		public var successRemine:Function, fiascoRemine:Function;
		public var actFun:Function;
		
		public var area:Area;	//прикреплённая область
		
		public var sign:int=0;	//указатель
		var t_sign:int=0;
		
		public var isMove:Boolean=false;		//есть движение
		var begX:Number=0, begY:Number=0, endX:Number=0, endY:Number=0, endX2:Number=0;	//координаты начальной и конечной точки
		var t_move:Number=0, dt_move:Number=1;		//таймер
		public var tStay:int=10, tMove:int=100;		//время стоять и время двигаться
		public var moveSt:int=0;					//режим движения 0-стоять, 1-из начала в конец, 2-из конца в начало, 3-из одного конца в другой, 4-непрерывно
		var moveP:Boolean=false;					//если true, то в этот момент есть движение, если false, то стои
		public var moveCh:SoundChannel;
		
		var lootBroken:Boolean=false;
		
		public var autoClose:int=0;
		var t_autoClose:int=0;
		var t_budilo:int=0;
		
		public var scrAct:Script, scrOpen:Script, scrClose:Script, scrTouch:Script;
		
		//изменения состояний, которые сохраняются
		var saveMine:int=0;		//101 - мина обезврежена или бахнула
		var saveLock:int=0;		//101 - открыто, 102 - заклинило
		public var saveLoot:int=0;		//1 - лут получен, 2 - лут получен, есть критичный лут
		var saveOpen:int=0;		//1 - открыто
		var saveExpl:int=0;
		//var saveTerm:int=0;		//1 - активировано
		
		public const maxLockLvl=24;
		public const maxMechLvl=7;
		
		public static var chanceUnlock:Array=[0.9, 0.75, 0.5, 0.3, 0.15, 0.05, 0.01];
		public static var chanceUnlock2:Array=[0.95, 0.8, 0.55, 0.35, 0.2, 0.08, 0.03];
		
		//node - шаблон, xml - индивидуальный параметр, взятый из карты
		public function Interact(own:Obj, node:XML=null, nxml:XML=null, loadObj:Object=null) {
			owner=own;
			loc=owner.loc;
			X=own.X, Y=own.Y;
			xml=nxml;
			//var rnd:Boolean=false;
			//if (loc && loc.land.rnd) 
			var rnd=true;
			if (xml && xml.@set.length()) rnd=false;	//если задано свойство set='1', не будет случайных параметров
			//тип замка
			if (node && node.@locktip.length()) lockTip=node.@locktip;
			if (xml && xml.@locktip.length()) lockTip=xml.@locktip;
			if (node) {
				//содержимое
				if (node.@cont.length()) cont=node.@cont;
				//замок
				if (node.@lock.length()) {
					var lk:Number=Number(node.@lock);
					if (rnd) {		//случайный замок
						if (node.@lockch.length()==0 || Math.random()<Number(node.@lockch)) {
							if (lockTip==1 || lockTip==2) {
								lock=Math.floor(lk+(0.3+Math.random())*loc.locksLevel);
							} else {
								lock=Math.floor(lk+Math.random()*loc.mechLevel);
							}
						}
						if (Math.random()<lk-Math.floor(lk)) lock+=1;
					} else {		//заданный замок
						lock=Math.floor(lk);
					}
				}
				if (node.@low.length()) low=node.@low;
				saveLock=lock;
				//hp замка
				if (node.@lockhp.length()) lockHP=node.@lockhp;
				//заминировано
				if (node.@mine.length()) {
					if (rnd) {
						if (node.@minech.length()) {
							if (Math.random()<Number(node.@minech))	mine=Math.floor(Math.random()*(Number(node.@mine)+Math.random()*loc.mechLevel+1));
						} else mine=Math.floor(Number(node.@mine)+Math.random()*loc.mechLevel);
						if (mine>=2 && Math.random()<0.25) mine--;
					} else {
						mine=node.@mine;
					}
					if (node.@minetip.length()) mineTip=node.@minetip;
					else if (node.@inter!='3' && Math.random()<0.4) mineTip=6;
				}
				saveMine=mine;
				//можно хакнуть
				if (node.@hack>0) is_hack=true;
				//общее действие
				if (node.@allact.length()) allact=node.@allact;
				//действие
				action=node.@inter;
				if (node.@xp.length()) xp=node.@xp;
				if (node.@once.length()) at_once=node.@once;
				if (node.@door.length()) door=node.@door;
				if (node.@knop.length()) knop=node.@knop;
				if (node.@time.length()) t_action=node.@time;
				if (node.@expl.length()) expl=node.@expl;
				if (node.@autoclose.length()) autoClose=node.@autoclose;
			}
			if (xml) {
				if (xml.@off.length()) active=false;
				if (xml.@open.length()) {
					setAct('open',1);
					update();
				}
				if (xml.@cont.length()) cont=xml.@cont;
				if (xml.@lock.length()) {
					lock=xml.@lock;
					saveLock=lock;
					low=0;
					if (xml.@lock=='0') mine=saveMine=0;
				}
				if (xml.@locklevel.length()) lockLevel=xml.@locklevel;
				if (xml.@key.length()) lockKey=xml.@key;
				if (xml.@cons.length()) cons=xml.@cons;
				if (xml.@lockhp.length()) lockHP=xml.@lockhp;
				if (xml.@lockatt.length()) lockAtt=xml.@lockatt;
				if (xml.@mine.length()) {
					mine=xml.@mine;
					saveMine=mine;
				}
				if (xml.@minetip.length()) mineTip=xml.@minetip;
				if (xml.@autoclose.length()) autoClose=xml.@autoclose;
				if (xml.@hack.length()) is_hack=xml.@hack>0;
				if (xml.@allact.length()) allact=xml.@allact;
				if (xml.@allid.length()) allid=xml.@allid;
				if (xml.@prob.length()) prob=xml.@prob;
				if (xml.@inter.length()) action=xml.@inter;
				if (xml.@time.length()) t_action=xml.@time;
				if (xml.@knop.length()) knop=xml.@knop;
				if (xml.@damage.length()) damage=xml.@damage;
				if (xml.@prize.length()) prize=true;
				if (xml.@nobase.length()) noBase=true;
				if (xml.@noruna.length()) noRuna=true;
				if (xml.@sign.length()) sign=xml.@sign;
				
				if (xml.move.length()) {
					isMove=true;
					begX=X, begY=Y;
					if (xml.move.@dx.length()) {
						if (loc && loc.mirror) endX=X-xml.move.@dx*World.tileX;
						else endX=X+xml.move.@dx*World.tileX;
					} else endX=endX2=X;
					if (xml.move.@dy.length()) endY=Y+xml.move.@dy*World.tileY;
					else endY=Y;
					if (xml.move.@tstay.length()) tStay=xml.move.@tstay;
					if (xml.move.@tmove.length()) tMove=xml.move.@tmove;
					if (xml.move.@on.length()) moveSt=4;
				}
			}
			if (loc && loc.base && cont!=null && !noBase) {
				cont=null;
				lock=mine=saveMine=saveLock=0;
				action=0;
				active=false;
			}
			if (loc && (loc.homeStable) && !noBase) {
				lock=mine=saveMine=saveLock=0;
			}
			if (loc && (loc.homeAtk) && !noBase) {
				lock=mine=saveMine=saveLock=0;
				if (cont && own is Box) {
					setAct('loot',1);
				}
			}
			if (loadObj) load(loadObj);
			var difSet:Boolean=(allDif>=0);
			if (lock<100) {
				if (lockTip==1 || lockTip==2) {
					if (low>0 && Math.random()<low) lock=Math.ceil(lock*0.5);
					if (lock>maxLockLvl) lock=maxLockLvl;
					if (lock>0 && low<=0 && own && own.loc && own.loc.land.rnd && own.loc.prob==null && Math.random()<0.2) lock+=Math.floor(Math.random()*2)+2;
					//определить уровень замка
					if (lock>2 && lockLevel==0) {
						lockLevel=Math.round(Math.random()*(lock-2)/3.2);
						if (lockLevel>5) lockLevel=5;
					}
					if (!difSet) allDif=lock+lockLevel*2;
				} else {
					if (lock>maxMechLvl) lock=maxMechLvl;
					if (!difSet) allDif=lock*3;
				}
			}
			if (mine>maxMechLvl) mine=maxMechLvl;
			if (mine>0) {
				if (mineTip==6) {
					fiascoRemine=alarm;
				} else {
					damage=mine*50*(0.8+Math.random()*0.4)*(1+loc.locDifLevel*0.1);
					fiascoRemine=explosion;
				}
				if (!difSet) allDif+=mine*2;
			}
			if (loc) {
				damdis=30+loc.mechLevel*20;
			}
			if (expl>0) {
				if (node.@damage.length()) damage=node.@damage;
				if (node.@destroy.length()) destroy=node.@destroy;
				if (node.@radius.length()) explRadius=node.@radius;
			}
			if (allact=='robocell') {
				fiascoUnlock=robocellFail;
			}
			if (allact=='alarm') {
				fiascoRemine=alarm2;
				if (owner) {
					area=new Area(loc);
					owner.copy(area);
					area.tip='raider';
					area.over=alarm2;
				}
			}
			if (prize) {
				mine=0;
				lockTip=0;
				lock=1;
			}
			//if (lockTip==0 && lock>0) active=false;
			update();
			owner.prior+=1;
			inited=true;
		}
		
		public function save(obj:Object) {
			obj.lock=saveLock;
			obj.lockLevel=lockLevel;
			obj.mine=saveMine;
			obj.loot=saveLoot;
			obj.open=saveOpen;
			obj.expl=saveExpl;
			obj.dif=allDif;
			obj.sign=sign;
		}
		
		public function step() {
			if (is_act) act();
			else is_ready=true;
			is_act=false;
			if (isMove) move();
			if (area) area.step();
			if (t_autoClose>0) {
				t_autoClose--;
				if (t_autoClose==1) command('close');
			}
			if (t_budilo>0) {
				if (t_budilo%30==0) {
					loc.budilo(owner.X,owner.Y,1500);
					Emitter.emit('laser2',loc,owner.X,owner.Y-owner.scY+20);
					Snd.ps('alarm',X,Y);
				}
				t_budilo--;
			}
			if (sign>0) {
				if (t_sign<=0) {
					t_sign=30;
					if (World.w.helpMess) Emitter.emit('sign'+sign,loc,owner.X,owner.Y-owner.scY/2);
				}
				t_sign--;
			}
		}
		
		public function update() {
			if (userAction && userAction!='') {
				 actionText=Res.guiText(userAction);
			} else {
				if (active && action>0) {
					if (action==1) actionText=Res.guiText(!open?'open':'close');
					if (action==2) actionText=Res.guiText('use'); 
					if (action==3) actionText=Res.guiText('remine'); 
					if (action==4) actionText=Res.guiText('press'); 
					if (action==5) actionText=Res.guiText('shutoff'); 
					if (action==8) actionText=Res.guiText('comein'); 
					if (action==9) actionText=Res.guiText('exit'); 
					if (action==10) actionText=Res.guiText('beginm'); 
					if (action==11) actionText=Res.guiText('return'); 
					if (action==12) actionText=Res.guiText('see'); 
				} else actionText='';
			}
			
			if (mine>0) {
				if (mineTip==6) {
					stateText="<span class = 'r2'>"+Res.guiText('signal')+"</span>";
					actionText=Res.guiText('shutoff');
				} else {
					if (owner is Box) stateText="<span class = 'warn'>"+Res.guiText('mined')+"</span>";
					actionText=Res.guiText('remine');
				}
				sndAct='rem_act';
			} else if (lock>0) {
				if (lockTip==0)	{
					stateText="<span class = 'r2'>"+Res.guiText('lock')+"</span>";
					actionText='';
					sndAct='lock_act';
				}
				if (lockTip==1)	{
					if (lock>=100) stateText="<span class = 'r3'>"+Res.guiText('zhopa')+"</span>";
					else stateText="<span class = 'r2'>"+Res.guiText('lock')+"</span>";
					actionText=Res.guiText('unlock');
					sndAct='lock_act';
				}
				if (lockTip==2)	{
					if (lock>=100)stateText="<span class = 'r3'>"+Res.guiText('block')+"</span>";
					else stateText="<span class = 'r2'>"+Res.guiText('termlock')+"</span>";
					actionText=Res.guiText('termunlock'); 
					sndAct='term_act';
				}
				if (lockTip==4)	{
					actionText=Res.guiText('shutoff');
					sndAct='rem_act';
				}
				if (lockTip==5)	{
					actionText=Res.guiText('fixup');
					sndAct='rem_act';
				}
			} else if (cont=='empty') {
				stateText="<span class = 'r0'>"+Res.guiText('empty')+"</span>";
			} else {
				stateText='';
			}
		}
		
		//установить состояние
		public function setAct(a:String, n:int=0) {
			if (a=='mine') {
				if (n<100) {
					mine=n;
					saveMine=mine;
				}
				if (n==101) {
					mine=0;
					saveMine=101;
					owner.warn=0;
				}
			}
			if (a=='lock') {
				if (n<100) {
					lock=n;
					saveLock=lock;
				}
				if (n==101) {
					saveLock=101;
					lock=0;
					stateText='';
				}
				if (n==102) {
					saveLock=102;
					//active=false;
					lock=100;
					if (lockTip==1) stateText="<span class = 'r3'>"+Res.guiText('zhopa')+"</span>";
					if (lockTip==2) stateText="<span class = 'r3'>"+Res.guiText('block')+"</span>";
					if (lockTip==5) stateText="<span class = 'r3'>"+Res.guiText('broken')+"</span>";
				}
			}
			if (a=='loot') {
				if (n>0) {
					saveLoot=n;
					active=false;
					cont='empty';
					actionText='';
					owner.setVisState('open');
				}
			}
			if (a=='open') {
				if (autoClose==0) saveOpen=n;
				open=(n==1);
				if (door) setDoor();
				if (knop) {
					if (open) owner.setVisState('open');
					else owner.setVisState('close');
				}
				if (open) {
					lock=mine=0;
					update();
				}
				if (open && (allact=='robocell' || allact=='alarm')) {
					allact='';
					active=false;
					owner.setVisState('open');
				}
				if (loc && loc.prob && loc.active) loc.prob.check();
			}
			if (a=='expl') {
				saveExpl=n;
			}
		}
		
		//произвести действие
		public function act() {
			var verZhopa=0, verFail=0;
			if (action==0) return;
			if (scrTouch) {
				scrTouch.start();
				scrTouch=null;
				return;
			}
			if (needSkill && needSkillLvl>unlock) {
				World.w.gui.infoText('needSkill', Res.txt('e',needSkill), needSkillLvl,false);	//требуется навык
			} else if (mine>0) {
					verZhopa=0, verFail=0;
					if (mine>unlock) verZhopa=(mine-unlock+1)*0.15;
					verFail=(mine-unlock+2)*0.2;
					if (Math.random()<verZhopa) {	//критическая неудача
						setAct('mine',101);
						if (mineTip==6) World.w.gui.infoText('signalZhopa');	//сигнализация сработала
						else World.w.gui.infoText('remineZhopa');	//бомба сработала
						if (fiascoRemine!=null) fiascoRemine();
						if (at_once>0) {
							actOsn();
						}
						replic('zhopa');
						update();
					} else if (Math.random()<verFail) { //неудача	
						if (mineTip==6) World.w.gui.infoText('signalFail',null,null,false);	//сигнализация не обезврежена
						else World.w.gui.infoText('remineFail',null,null,false);	//бомба не обезврежена
						replic('fail');
					} else {						//успех	
						setAct('mine',101);
						if (mineTip==6) World.w.gui.infoText('signalOff');	//сигнализация обезврежена
						else  World.w.gui.infoText('remine');	//бомба обезврежена
						if (successRemine!=null) successRemine();
						if (at_once>0) {
							actOsn();
						}
						replic('success');
						update();
					}
					World.w.gui.bulb(X,Y);
					//trace('разминировать',unlock,' неудача',verFail,'жопа',verZhopa);
				unlock=0;
				is_ready=false;
			} else if (lock>0 && lockKey && World.w.invent.items[lockKey].kol>0) {
				setAct('lock',101);
				if (lockTip==1) World.w.gui.infoText('unLockKey');
				if (lockTip==2) World.w.gui.infoText('unTermLock');
				if (lockTip==4) World.w.gui.infoText('unRepLock');
				if (lockTip==5) World.w.gui.infoText('unFixPart');
				update();
				if (successUnlock!=null) successUnlock();
				//if (lockKeyMinus) 
			} else if (lock>=100) {
			} else if (lock>0) {
				if (unlock>-99) {
					var lockDam1:Number=0, lockDam2:Number=2;
					verFail=0;
					if (lockTip==1 || lockTip==5) {
						/*if (lock-unlock<0) verFail=0.2;
						else if (lock-unlock==0) verFail=0.4;
						else if (lock-unlock==1) verFail=0.6;
						else if (lock-unlock==2) verFail=0.8;
						else verFail=1;*/
						verFail=1-this.getChance(lock-unlock);
						if (master<lockLevel) verFail=1;
						if (lock-unlock==1) {
							lockDam1=1;
							lockDam2=3;
						} else if (lock-unlock>1){
							lockDam1=2;
							lockDam2=4;
						}
					} else if (lockTip==2) {
						/*if (lock-unlock<0) verFail=0.2;
						else if (lock-unlock==0) verFail=0.5;
						else if (lock-unlock==1) verFail=0.75;
						else if (lock-unlock==2) verFail=0.85;
						else verFail=1;*/
						verFail=1-this.getChance(lock-unlock);
						if (master<lockLevel) verFail=1;
					} else if (lockTip==4) {
						if (lock-unlock<0) verFail=0.1;
						else if (lock-unlock==0) verFail=0.25;
						else if (lock-unlock==1) verFail=0.6;
						else if (lock-unlock==2) verFail=0.85;
						else verFail=1;
						lockDam1=2;
						lockDam2=4;
					}
					//trace(lock,unlock,lockDam1,lockDam2);
					//trace(lock,unlock,verFail);
					var lockDam:Number=lockDam1;
					if (Math.random()<verFail) { //неудача	
						if (lockTip==1) {
							var pinCrack:Boolean=false;
							if (World.w.invent.pin.kol>0) {
								if (World.w.pers.pinBreak>=1 || Math.random()<World.w.pers.pinBreak) {
									World.w.invent.minusItem('pin');
									pinCrack=true;
								}
							} else lockDam1+=2;
							lockDam=(lockDam1+Math.random()*lockDam2)*World.w.pers.lockAtt;
							lockHP-=lockDam;
							//trace(lockDam,lockHP);
							if (lockHP<=0) {		//Замок заклинило
								setAct('lock',102);
								World.w.gui.infoText('unLockZhopa');
								if (fiascoUnlock!=null) fiascoUnlock();
								replic('zhopa');
							} else if (pinCrack) {
								World.w.gui.infoText('unLockFailP', null,null,false);	//замок не открыт, заколка сломана
								replic('fail');
							} else if (lockHP>100) {
								World.w.gui.infoText('unLockFailA', null,null,false);	//замок не открыт, попробуйте ещё
							} else {
								World.w.gui.infoText('unLockFail',null,null,false);	//замок не открыт
								replic('fail');
							}
						} else if (lockTip==2) {
							if (lockAtt==-100) lockAtt=World.w.pers.hackAtt;
							lockAtt--;
							if (lockAtt>10) World.w.gui.infoText('unTermLockFail2',null,null,false);	//терминал не взломан
							else if (lockAtt>1) {
								World.w.gui.infoText('unTermLockFail',lockAtt,null,false);	//терминал не взломан
								replic('fail');
							} else if (lockAtt==1) {
								World.w.gui.infoText('unTermLockFail1',null,null,false);	//терминал не взломан
								replic('fail');
							} else {					//терминал блокирован
								setAct('lock',102);
								replic('zhopa');
								World.w.gui.infoText('unLockBlock');
								if (fiascoUnlock!=null) fiascoUnlock();
							}
						} else if (lockTip==4) {		//отключение с помощью навыка ремонт
							var lockDam=(lockDam1+Math.random()*lockDam2);
							lockHP-=lockDam;
							//trace(lockDam,lockHP);
							if (lockHP<=0) {		//Удар током
								//setAct('lock',102);
								discharge();
								World.w.gui.infoText('unRepZhopa',null,null,false);
								replic('zhopa');
								if (fiascoUnlock!=null) fiascoUnlock();
							} else {
								World.w.gui.infoText('unRepFail',null,null,false);	//замок не открыт
								replic('fail');
							}
						} else if (lockTip==5) {		//ремонт механизма
							lockDam=(lockDam1+Math.random()*lockDam2);
							lockHP-=lockDam;
							//trace(lockDam,lockHP);
							if (lockHP<=0) {		//Замок заклинило
								setAct('lock',102);
								World.w.gui.infoText('unFixZhopa');
								replic('zhopa');
								if (fiascoUnlock!=null) fiascoUnlock();
							} else {
								World.w.gui.infoText('unFixFail',null,null,false);	//замок не открыт
								replic('fail');
							}
						}
					} else {						//успех	//замок открыт
						setAct('lock',101);
						if (lockTip==1) {
							World.w.gui.infoText('unLock');
							if (Math.random()<0.8) replic('success');
							else replic('unlock');
						}
						if (lockTip==2) {
							World.w.gui.infoText('unTermLock');
							if (Math.random()<0.8) replic('success');
							else replic('hack');
						}
						if (lockTip==4) {
							World.w.gui.infoText('unRepLock');
							replic('success');
						}
						if (lockTip==5) {
							World.w.gui.infoText('unFixLock');
							replic('success');
						}
						if (successUnlock!=null) successUnlock();
						if (at_once>0) {
							actOsn();
						}
						update();
					}
					World.w.gui.bulb(owner.X,owner.Y);
				} else {
					World.w.gui.infoText('noPoss',null,null,false);
					World.w.gui.bulb(owner.X,owner.Y);
				}
				unlock=0;
				is_ready=false;
			} else if (is_ready) {
				actOsn();
			}
			is_ready=false;
		}
		
		public function getChance(dif:int):Number {
			if (dif<-2) return 1;
			if (dif>4) return 0;
			if (World.w.pers.upChance>0) return chanceUnlock2[dif+2];
			return chanceUnlock[dif+2]
		}
		
		//произвести основное действие
		public function actOsn() {
			if (cons) {
				if (World.w.invent.items[cons] && World.w.invent.items[cons].kol>0)	{
					World.w.invent.minusItem(cons);
					World.w.gui.infoText('usedCons', Res.txt('i',cons));
					if (cons=='empbomb') Emitter.emit('impexpl',loc,owner.X, owner.Y-owner.scY/2);
				} else {
					World.w.gui.infoText('needCons', Res.txt('i',cons),null,false);
					return;
				}
			}
			if (actFun) {
				actFun();
			}
			if (cont!=null) {
				loot();
			}
			sign=0;
			if (expl) owner.die();
			if ((door>0 || knop>0)&& action>0) {
				open=!open;
				setAct('open',(open?1:0));
				if (open && scrOpen) scrOpen.start();
				if (!open && scrClose) scrClose.start();
				if (open) t_autoClose=autoClose;
				if (door>0 && World.w.pers.noiseDoorOpen) World.w.gg.makeNoise(World.w.pers.noiseDoorOpen, true);
			}
			if (allact || prob!=null) {
				allAct();
			}
			
			if (loc && loc.prob) loc.prob.check();
			if (scrAct) scrAct.start();
			update();
		}
		
		//сломать контейнер
		public function dieCont() {
			lootBroken=true;
			if (cont!=null) {
				loot();
			}
			if (mine) {
				setAct('mine',101);
				World.w.gui.infoText('remineZhopa');	//бомба сработала
				if (fiascoRemine!=null) fiascoRemine();
			}
			open=true;
			setAct('open',1);
			if (scrOpen) scrOpen.start();
			update();
		}
		
		public function load(obj:Object) {
			if (obj==null) return;
			if (obj.lock!=null) {
				setAct('lock',obj.lock);
			}
			if (obj.lockLevel!=null) {
				lockLevel=obj.lockLevel;
			}
			if (obj.dif!=null) {
				allDif=obj.dif;
			}
			if (obj.mine!=null) {
				setAct('mine',obj.mine);
			}
			if (obj.loot!=null) {
				if (obj.loot==2) {
					loot(true);	//если состояние 2, сгенерировать критичный лут
				}
				setAct('loot',obj.loot);
			}
			if (obj.open!=null) {
				setAct('open',obj.open);
			}
			if (obj.expl!=null) {
				setAct('expl',obj.expl);
			}
			if (obj.sign!=null) {
				sign=obj.sign;
			}
		}

		public function setDoor() {
			if (inited && !open && (owner as Box).attDoor()) {
				open=true;
				if (t_autoClose<=0) World.w.gui.infoText('noClose',null,null,false);
				return;
			}
			(owner as Box).setDoor(open);
		}
		
		//неудачная попытка разминирования - взрыв
		public function explosion() {
			if (saveExpl) return;
			var un:Unit=new Unit();
			un.loc=loc;
			var bul:Bullet=new Bullet(un,owner.X,owner.Y,null,false);
			bul.iExpl(damage,destroy,explRadius);
			setAct('expl',1);
			if (expl) {
				owner.die();
			}
		}
		
		//неудачная попытка взлома силового поля - удар током
		public function discharge() {
			World.w.gg.electroDamage(damdis*(Math.random()*0.4+0.8),owner.X,owner.Y-owner.scY/2);
			//damage(,Unit.D_SPARK);
			//Emitter.emit('moln',loc,owner.X,owner.Y-owner.scY/2,{celx:World.w.gg.X, cely:(World.w.gg.Y-World.w.gg.scY/2)});
			//Snd.ps('electro',X,Y);
			damdis+=50;
			if (damdis>500) damdis=500;
		}
		
		//неудачная отключить сигнализацию - тревога
		public function alarm() {
			if (saveExpl) return;
			t_budilo=240;
			setAct('expl',1);
			loc.signal();
			loc.robocellActivate();
		}
		
		//неудачная попытка отключить кнопку тревоги
		public function alarm2() {
			if (allact!='alarm') return;
			t_budilo=240;
			loc.signal();
			area=null;
			active=false;
			allact='';
			update();
			owner.setVisState('active');
		}
		
		//неудачная попытка взлома ячейки робота - тревога
		public function robocellFail() {
			loc.robocellActivate();
		}
		
		//создать робота
		public function genRobot() {
			if (allact!='robocell') return;
			loc.createUnit('robot',X,Y,true,null,null,30);
			allact='';
			update();
			owner.setVisState('active');
		}
		
		public function needRuna(gg:UnitPlayer):int {
			if (mineTip==6 && mine>0) return 1;
			if (noRuna || lock==0) return 0;
			if (gg.invent==null || mine>0) return 0;
			var pick=gg.pers.getLockTip(lockTip);
			var master=gg.pers.getLockMaster(lockTip)
			if (lockTip==1 && gg.invent.items['runa'].kol>0 && (lock-pick>1 || lockLevel>master)) return 1;
			if (lockTip==2 && gg.invent.items['reboot'].kol>0 && (lock-pick>1 || lockLevel>master)) return 1;
			return 0;
		}
		public function useRuna(gg:UnitPlayer) {
			if (mineTip==6 && mine>0) {
				if (fiascoRemine!=null) fiascoRemine();
				setAct('mine',101);
				if (at_once>0) {
					actOsn();
				}
				update();
				return;
			}
			if (gg.invent==null) return;
			if (lockTip==1 && lock>0 && gg.invent.items['runa'].kol>0) {
				command('unlock');
				gg.invent.minusItem('runa');
				World.w.gui.infoText('useRuna');
				World.w.gui.bulb(owner.X,owner.Y);
			}
			if (lockTip==2 && lock>0 && gg.invent.items['reboot'].kol>0) {
				command('unlock');
				gg.invent.minusItem('reboot');
				World.w.gui.infoText('useReboot');
				World.w.gui.bulb(owner.X,owner.Y);
			}
		}
		
		public function off() {
				stateText='';
				active=false;
				lock=0;
		}
		
		public function allAct() {
			if (prob!=null) {
				if (World.w.possiblyOut()==2) {
					World.w.gui.infoText('noOutLoc',null,null,false);
					return;
				}
				loc.land.gotoProb(prob, owner.X, owner.Y);
			} else if (allact=='probreturn') {
				if (loc.landProb!='') {
					if (World.w.possiblyOut()==2) {
						World.w.gui.infoText('noOutLoc',null,null,false);
						return;
					}
					loc.land.gotoProb('', owner.X, owner.Y);
				}
			} else if (allact=='hack_robot') {
				World.w.gui.infoText('term1Act');
				World.w.gui.bulb(X,Y);
				for each (var un:Unit in owner.loc.units) un.hack(World.w.pers.security);				
			} else if (allact=='hack_lock') {
				World.w.gui.infoText('term2Act');
				World.w.gui.bulb(X,Y);
				for each (var obj:Obj in owner.loc.objs) {
					if (obj.inter) obj.inter.command('hack');
				}
			} else if (allact=='prob_help') {
				if (loc.prob) loc.prob.showHelp();
			} else if (allact=='electro_check') {
				loc.electroCheck();
				if (loc.electroDam<=0) World.w.gui.infoText('electroOff',null,null,true);
				else World.w.gui.infoText('electroOn',null,null,true);
			} else if (allact=='comein') {
				World.w.gg.outLoc(5,X,Y);
			} else if (allact=='bind') {
				World.w.gg.bindChain(X,Y-20);
			} else if (allact=='work' || allact=='lab' || allact=='stove') {
				World.w.pip.workTip=allact;
				World.w.pip.onoff(7);
			} else if (allact=='app') {
				World.w.pip.onoff(8);
			} else if (allact=='map') {
				World.w.pip.travel=true;
				World.w.pip.onoff(3,3);
				World.w.pip.travel=true;
			} else if (allact=='stand') {
				World.w.stand.onoff(1);
			} else if (allact=='exit') {
				World.w.game.gotoNextLevel();
			} else if (allact=='robocell') {
				World.w.gui.infoText('robocellOff');
				setAct('open',1);
			} else if (allact=='alarm') {
				World.w.gui.infoText('alarmOff');
				setAct('open',1);
			} else if (allact=='vault') {
				World.w.pip.onoff(9);
			} else owner.loc.allAct(owner,allact,allid);
			/*{
				for each (var obj:Obj in owner.loc.objs) {
					if (obj.inter && obj.inter!=this && obj.inter.allid==allid) obj.inter.command(allact);
				}
			}*/
		}
		
		//начало продолжительного действия над объектом
		public function beginAct() {
			if (allact=='comein') {
				owner.setVisState('comein');
			}
		}
		
		public function shine() {
			Emitter.emit('unlock',loc,owner.X,owner.Y-owner.scY/2,{kol:10, rx:owner.scX, ry:owner.scY, dframe:6});
		}
		
		public function signal(n:String) {
			Emitter.emit(n,loc,owner.X,owner.Y-owner.scY/2,{kol:6, rx:owner.scX/2, ry:owner.scY*0.8});
		}
		
		
		public function command(com:String, val:String=null) {
			if (com=='hack' && is_hack) {
				active=true;
				setAct('mine',101);
				setAct('lock',101);
				if (at_once>0) actOsn();
				update();
				shine();
			}
			if (com=='unlock') {
				active=true;
				setAct('mine',101);
				setAct('lock',101);
				update();
				shine();
			}
			if (com=='open') {
				open=true;
				setAct('open',1);
				t_autoClose=autoClose;
				if (allact && val!='13')	allAct();
			}
			if (com=='close') {
				open=false;
				setAct('open',0);
				if (open) t_autoClose=150;
				if (allact && val!='13')	allAct();
			}
			if (com=='dam') {
				if (expl) explosion();
				else if (knop && action==0) {
					setAct('open',1);
					if (loc.prob) loc.prob.check();
				} else actOsn();
			}
			if (com=='swap') {
				open=!open;
				setAct('open',(open?1:0));
			}
			if (com=='sign') {
				sign=int(val);
			}
			if (com=='off') {
				active=false;
			}
			if (isMove) {
				if (com=='stop') {
					moveSt=0;
				}
				if (com=='move') {
					moveSt=4;
				}
				if (com=='pop') {
					if (moveSt==0) moveSt=4;
					else moveSt=0;
				}
				if (com=='move1') {	//ехать из начала в конец
					moveTo(1);
				}
				if (com=='move2') {	//ехать из конца в начало
					moveTo(2);
				}
				if (com=='move3') {	//ехать из одного конца в другой
					moveTo(3);
				}
			}
			if (com=='red') {
				signal('red');
			}
			if (com=='green') {
				signal('green');
			}
		}
		
		public function move() {
			if (isMove && moveSt>0) {
				var f:Number=0;
				var pp=moveP;
				if (dt_move<1) dt_move+=0.1;
				if (t_move>=0 && t_move<tStay) {	//стоим в начале
					moveP=false;
					f=0;
					if (moveSt==2 || moveSt==3) moveSt=0;
				} if (t_move>=tStay && t_move<tStay+tMove) { //движемся от начала к концу
					moveP=true;
					f=(t_move-tStay)/tMove;
				} else if (t_move>=tStay+tMove && t_move<tStay+tMove+tStay) { //стоим в конце
					moveP=false;
					f=1;
					if (moveSt==1 || moveSt==3) moveSt=0;
				} else if (t_move>=tStay+tMove+tStay && t_move<(tStay+tMove)*2) { //движемся от конца к началу
					moveP=true;
					f=((tStay+tMove)*2-t_move)/tMove;
				} else {
					moveP=false;
					f=0;
				}
				if (pp!=moveP) {
					if (moveP) sound('move');
					else sound('stop');
				}
				var nx:Number=begX+(endX-begX)*f;
				var ny:Number=begY+(endY-begY)*f;
				owner.bindMove(nx,ny);
				X=nx, Y=ny;
				t_move+=dt_move;
				if (t_move>=(tStay+tMove)*2) t_move=0;
			}
		}
		
		public function moveTo(n:int) {
			moveSt=n;
			if (n==1) {
				if (t_move>=0 && t_move<tStay) { //стоим в начале
					t_move=tStay;
				}
				if (t_move>=tStay+tMove && t_move<tStay+tMove+tStay) { //стоим в конце
					moveSt=0;
				}
			}
			if (n==2) {
				if (t_move>=0 && t_move<tStay) { //стоим в начале
					moveSt=0;
				}
				if (t_move>=tStay+tMove && t_move<tStay+tMove+tStay) { //стоим в конце
					t_move=tStay+tMove+tStay;
				}
			}
			if (n==3) {
				if (t_move>=0 && t_move<tStay) { //стоим в начале
					t_move=tStay;
				}
				if (t_move>=tStay+tMove && t_move<tStay+tMove+tStay) { //стоим в конце
					t_move=tStay+tMove+tStay;
				}
			}
		}
		
		public function sound(s:String=null) {
			if (s=='move') {
				moveCh=Snd.ps('move',X,Y,0);
			} else if (s=='stop') {
				if (moveCh) moveCh.stop();
				moveCh=Snd.ps('move',X,Y,5500);
			} else if (sndAct!='') Snd.actionCh=Snd.ps(sndAct,X,Y);
			
		}
		
		function replic(s:String) {
			if (Math.random()<0.25) World.w.gg.replic(s);
		}	
		
		//подтвердить получение критичного предмета
		public function receipt() {
			saveLoot=1;
		}
		
		public function loot(impOnly:Boolean=false) {
			if (loc==null || cont=='empty') return;
			X=owner.X, Y=owner.Y-owner.scY/2;
			var kol:int, imp:int;
			var is_loot=false;
			var imp_loot=1;
			if (xml && xml.item.length()) {
				for each(var item:XML in xml.item) {
					if (impOnly && item.@imp.length()==0) continue;
					if (item.@kol.length()) kol=item.@kol;
					else kol=1;
					if (item.@imp.length()) {
						imp=2;
						imp_loot=2;
					} else imp=1;
					LootGen.lootId(loc,X,Y,item.@id,kol,imp,this,lootBroken);
					is_loot=true;
				}
			}
			if (impOnly) return;
			if (cont!='' && cont!='empty') {
				if (owner is Unit) {
					is_loot=LootGen.lootDrop(loc,X,Y,cont,(owner as Unit).hero) || is_loot;
				} else {
					is_loot=LootGen.lootCont(loc,X,Y,cont,lootBroken,prize?allDif:50) || is_loot;
					//дать опыт
					if (!lootBroken && allDif>0 && xp>0) {
						loc.takeXP(Math.round(xp*(allDif+1)),X,Y);
					}
				}
			}
			if (!is_loot && (owner is Box) && !World.w.testLoot) World.w.gui.infoText('itsEmpty');
			setAct('loot',imp_loot);
		}
	}
	
}

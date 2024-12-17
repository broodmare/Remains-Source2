package fe.serv
{
	import fe.*;
	import fe.entities.Obj;
	import fe.loc.Land;

	import fe.unit.Unit;
	
	public class Script
	{
		var land:Land;
		public var owner:Obj;
		
		public var eve:String;	//событие, которое приводит к запуску скрипта
		public var acts:Array;
		var actObj:Object;
		
		public var onTimer:Boolean=false;	//есть ли команды с задержкой времени
		public var running:Boolean=false;	//скрипт со временем выполнения запущен
		var wait:Boolean=false;	//ожидание нажатия кнопки
		var ncom:int;
		var tcom:int=0;
		var dial_n:int=-1;

		public function Script(xml:XML, nland:Land=null, nowner:Obj=null, tt:Boolean=false) {
			land=nland;
			owner=nowner;
			acts=[];
			if (xml.@eve.length()) eve=xml.@eve;
			if (xml.@act.length()) analiz(xml);
			if (xml.s.length()) {
				for each(var s:XML in xml.s) analiz(s);
			}
			if (tt) onTimer=true;
			if (land && onTimer) land.scripts.push(this);
		}
		
		function analiz(xml:XML) {
			var act:String, targ:String, val:String, t:int=0, n:String='-1', opt1:int=0, opt2:int=0;
			if (xml.@act.length()) {		//команда
				act=xml.@act;
				if (act=='dial' || act=='dialog' || act=='inform' || act=='landlevel') onTimer=true;
			}
			if (xml.@targ.length()) targ=xml.@targ;		//цель 
			if (xml.@val.length()) val=xml.@val;		//значение
			if (xml.@t.length()) {						//задержка в сек.
				t=Math.round(xml.@t*World.fps);
				if (t>0) onTimer=true;
			}
			if (xml.@n.length()) n=xml.@n;		//опция
			if (xml.@opt1.length()) opt1=xml.@opt1;		//опция
			if (xml.@opt2.length()) opt2=xml.@opt2;		//опция
			if (act) acts.push({act:act, targ:targ, val:val, t:t, n:n, opt1:opt1, opt2:opt2});
		}
		
		//запуск скрипта
		public function start() {
			//trace("Script.as/start() - Starting script!");
			if (acts.length <= 0) return;
			if (onTimer) {
                ncom = 0;
                com(acts[ncom]);
                tcom = acts[ncom].t;
                running = true;
            }
			else {	//всё выполнить сразу
                for each(var obj:Object in acts) com(obj);
            }
		}
		
		public function step() {
			if (tcom>0) tcom--;
			if (tcom<=0) {
				if (wait) {
					if (World.w.ctr.keyPressed2) {
						dial_n=10000;
					}
					else if (!World.w.ctr.keyPressed) return;
					if (dial_n<0) {
						World.w.gui.dialText();
						wait=false;
					}
					else {
						dial_n++;
						if (World.w.gui.dialText(actObj.val,dial_n,actObj.opt1>0,true)) {
							World.w.ctr.active=false;
							World.w.ctr.keyPressed=false;
							World.w.gg.levit=0;
							return;
						}
						else {
							World.w.gui.dialText();
							World.w.gg.controlOn();
							wait=false;
						}
					}
					World.w.ctr.keyPressed=World.w.ctr.keyPressed2=false;
				}
				ncom++;
				if (ncom>=acts.length) {
					running=false;
					World.w.gui.dialText();
				}
				else {
					com(acts[ncom]);
					tcom=acts[ncom].t;
				}
			}
		}
		
		// [Command execution]
		private function com(obj:Object):void {
			if (obj == null) {
				return;
			}

			actObj = obj;
			if (World.w.gui.vis.dial.visible) World.w.gui.dialText();
			World.w.ctr.keyPressed = false;
			World.w.ctr.keyPressed2 = false;
			wait = false;
			dial_n = -1;

			if (obj.targ) {
				var target:Obj;
				if (obj.targ == 'this') target = owner;
				else if (land) target = land.uidObjs[obj.targ];
				else target = World.w.land.uidObjs[obj.targ];
				if (target) target.command(obj.act, obj.val);
			}
			else {
				switch (obj.act) {

					case 'control off':
						World.w.gg.controlOff();
					break;
					
					case 'control on':
						World.w.gg.controlOn();
					break;

					case 'mess':
						World.w.gui.messText(obj.val, '', obj.opt1 > 0, obj.opt2 > 0);
					break;

					case 'dial':
						if (!(obj.t > 0)) wait = true;
						World.w.ctr.active = false;
						World.w.gui.dialText(obj.val, obj.n, obj.opt1 > 0, wait);
					break;

					case 'dialog':
						if (World.w.dialOn)
						{
							World.w.gg.controlOff();
							wait=true;
							dial_n=0;
							World.w.ctr.active=false;
							World.w.gui.dialText(actObj.val,dial_n,actObj.opt1>0,true);
							World.w.ctr.keyJump=false;
							World.w.gg.levit=0;
						}
					break;

					case 'inform':
						World.w.gg.controlOff();
						wait = true;
						dial_n = 0;
						World.w.ctr.active = false;
						World.w.gui.dialText(<r mod={actObj.opt2} push={(actObj.opt1>0)?'1':'0'}>{actObj.val}</r>,0,false,true);
					break;

					case 'landlevel':
						if (World.w.dialOn && World.w.game.lands[actObj.val])
						{
							World.w.gg.controlOff();
							wait=true;
							World.w.ctr.active=false;
							var str = Res.txt('m',actObj.val) + "\n" + Res.pipText('recLevel') + ': [' + World.w.game.lands[actObj.val].dif + "]\n" + Res.pipText('isperslvl') + ': [' + World.w.pers.level + ']';
							if (World.w.game.lands[actObj.val].dif>World.w.pers.level) str += '\n\n' + Res.pipText('wrLevel');
							World.w.gui.dialText(<r mod='1'>{str}</r>,0,false,true);
						}
					break;

					case 'allact':
						World.w.loc.allAct(null, obj.val, obj.n);
					break;

					case 'take':
						trace("Script.as/com() - A script is calling the take function");
						if (obj.n < 0 && World.w.invent.items[obj.val]) {
							World.w.gui.infoText('withdraw', World.w.invent.items[obj.val].nazv, -obj.n);
							World.w.invent.minusItem(obj.val, -obj.n);
							World.w.pers.setParameters();
						}
						else {
							var item:Item = new Item(null, obj.val, obj.n);
							World.w.invent.take(item);
						}
					break;

					case 'armor':
						World.w.gg.changeArmor(obj.val, true);
					break;

					case 'xp':
						World.w.pers.expa(obj.val, World.w.gg.coordinates.X, World.w.gg.coordinates.Y);
					break;

					case 'perk':
						World.w.pers.addPerk(obj.val);
					break;

					case 'eff':
						World.w.gg.addEffect(obj.val,obj.opt1,obj.opt2);
					break;

					case 'remeff': 
						World.w.gg.remEffect(obj.val);
					break;

					case 'music':
						if (obj.n>0) Snd.playMusic(obj.val, obj.n);
						else Snd.playMusic(obj.val);
					break;

					case 'music_rep':
						if (World.w.pers.rep>=World.w.pers.repGood) Snd.playMusic(obj.val);
					break;

					case 'anim':
						World.w.gg.anim(obj.val,actObj.opt1>0);
					break;

					case 'turn':
						if (obj.val>0) World.w.gg.storona=1;
						else World.w.gg.storona=-1;
						World.w.gg.dx+=World.w.gg.storona*3;
					break;

					case 'black':
						World.w.cam.dblack = 0;
						if (obj.val > 0)World.w.vblack.visible = true;
						World.w.vblack.alpha = obj.val;
					break;

					case 'dblack':
						World.w.cam.dblack = obj.val;
					break;

					case 'gui off':
						World.w.gui.hpBarOnOff(false);
					break;

					case 'gui on':
						World.w.gui.hpBarOnOff(true);
					break;

					case 'refill':
						World.w.land.refill();
					break;

					case 'upland':
						World.w.game.upLandLevel();
					break;

					case 'locon':
						World.w.loc.allon();
					break;

					case 'locoff':
						World.w.loc.alloff();
					break;

					case 'quest':
						World.w.game.addQuest(obj.val);
					break;

					case 'showstage':
						World.w.game.showQuest(obj.val, obj.n);
					break;

					case 'show':
						World.w.cam.showOn=false;
					break;

					case 'stage':
						World.w.game.closeQuest(obj.val, obj.n);
					break;

					case 'trigger':
						if (obj.n == null) {
                            World.w.game.setTrigger(obj.val);
                        }
						else World.w.game.setTrigger(obj.val, obj.n);
					break;

					case 'goto':		//перейти в комнату
						var distr:Array=obj.val.split(' ');
						if (distr.length==2) land.gotoXY(distr[0],distr[1]);
					break;

					case 'gotoland':	//перейти в местность
						if (obj.n==2) World.w.game.gotoLand(obj.val,null,true);
						else if (obj.n==1) World.w.game.gotoLand(obj.val, obj.opt1+':'+obj.opt2);
						else World.w.game.gotoLand(obj.val);
					break;

					case 'openland':	//открыть местность на карте
						World.w.game.lands[obj.val].access = true;
					break;

					case 'passed':		//местность пройдена
						World.w.land.act.passed = true;
					break;

					case 'actprob':
						if (World.w.loc.prob) World.w.loc.prob.activateProb();
					break;

					case 'alarm':
						World.w.loc.signal();
					break;

					case 'trus':
						if (owner && owner.loc) owner.loc.trus=Number(obj.val);
						else World.w.loc.trus=Number(obj.val);
					break;

					case 'checkall':
						for each (var un:Unit in World.w.loc.units) {
							un.command('check');
						}
					break;

					case 'robots':
						World.w.loc.robocellActivate();
					break;

					case 'weapch':
						World.w.gg.changeWeapon(obj.val);
					break;

					case 'alicorn':
						if (obj.val <= 0) World.w.gg.alicornOff();
						else World.w.gg.alicornOn();
					break;

					case 'wave':
						if (World.w.loc.prob) World.w.loc.prob.beginWave();
					break;

					case 'pip':
						World.w.pip.onoff(obj.val, obj.n);
					break;

					case 'speceffect':
						World.w.grafon.specEffect(obj.n);
					break;

					case 'scene':
						if (obj.val) World.w.showScene(obj.val, obj.n);
						else World.w.unshowScene();
					break;

					case 'endgame':
						World.w.endgame();
					break;

					case 'gameover':
						World.w.endgame(1);
					break;

					case 'wait':
						wait=true;
						dial_n=0;
						World.w.ctr.active=false;
					break;

					default:
						trace('ERROR: Script: "' + obj.act + '" not found!');
					break;
				}
			}
		}
	}
}
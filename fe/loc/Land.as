package fe.loc {
	
	import fe.*;
	import fe.unit.UnitPlayer;
	import fe.unit.Pers;
	import flash.display.BitmapData;
	import fe.serv.Script;
	
	public class Land {
		
		public var act:LandAct;					//шаблон, по которому была создана местность
		
		public var rnd:Boolean=false;			//true если местность с рандомной генерацией
		public var loc:Location;				//текущая локация
		private var prevloc:Location;			//предыдущая посещённая локация
		//private var prevCreated:Location;		//предыдущая созданная локация, для предотвращения
		public var locs:Array;					//трёхмераня карта всех локаций
		public var probs:Array;					//локации испытаний
		public var listLocs:Array;				//линейный массив локаций
		public var locX:int, locY:int, locZ:int=0;	//координаты активной локации
		public var retLocX:int=0, retLocY:int=0, retLocZ:int=0, retX:Number=0, retY:Number=0;	//координаты возврата в основной слой
		public var prob:String='';				//слой испытания, ''-основной слой
		public var minLocX:int=0, minLocY:int=0, minLocZ:int=0;	//размер местности
		public var maxLocX:int=4, maxLocY:int=6, maxLocZ:int=2;	//размер местности
		
		public var loc_t:int=0;					//таймер
		static var locN:int=0;					//счётчик переходов
		
		public var gg:UnitPlayer;
		public var ggX:Number=0, ggY:Number=0;	//координаты гг в местности
		public var currentCP:CheckPoint;
		public var art_t:int=200;
		
		public var map:BitmapData;				//карта местности
		
		public var landDifLevel:Number=0;		//общая сложность, зависит от левела гг или настроек карты
		public var gameStage:int=0;				//этап сюжета игры, влияет на выпадение лута, если 0, то без ограничений
		public var lootLimit:Number=0;			//лимит выпадения особых предметов
		public var allXp:int=0;
		public var summXp:int=0;
		public var isRefill:Boolean=false;		//было восполнение товаров
		
		var allRoom:Array;		//массив всех комнат, взятый из xml
		var rndRoom:Array;		//массив, использующийся для рандомной генерации
		public var kolAll:Array;		//количество каждого вида объекта
		
		public var uidObjs:Array;		//все объекты, имеющие uid
		public var scripts:Array;		//массив скриптов, имеющих время выполнения
		public var itemScripts:Array;	//массив скриптов, привязанных к взятию объектов
		
		public var kol_phoenix:int=0;
		public var aliAlarm:Boolean=false;	//тревога среди аликорнов
		
		public var probIds:Array;		//имеющиеся комнаты испытаний
		var impProb:int=-1;				//важная комната испытаний


		//lvl - уровень перса-1
		public function Land(ngg:UnitPlayer, nact:LandAct, lvl:int) {
			gg=ngg;
			act=nact;
			rnd=act.rnd;
			uidObjs=new Array();
			scripts=new Array();
			kolAll=new Array();
			listLocs=new Array();
			probIds=new Array();
			probs=new Array();
			prepareRooms();
			if (rnd) {
				landDifLevel=lvl;	//сложность определяется заданным параметром
				if (landDifLevel<act.dif) landDifLevel=act.dif;	//если сложность меньше минимальной, установить минимальную
				maxLocX=act.mLocX;	//размеры берутся из настроек act
				maxLocY=act.mLocY;
				buildRandomLand();
			} else {
				landDifLevel=act.dif;	//сложность берётся из настроек act
				if (act.autoLevel) landDifLevel=lvl;
				maxLocX=maxLocY=1;	//размеры определяются в соотвествии с картой
				buildSpecifLand();
			}
			lootLimit=lvl+3;
			gameStage=act.gameStage;	//этап сюжета берётся из настроек
			//прикреплённые скрипты
			itemScripts=new Array();
			for each(var xl in act.xmlland.scr) {
				if (xl.@eve=='take' && xl.@item.length()) {
					var scr:Script=new Script(xl,this);
					itemScripts[xl.@item]=scr;
				}
			}
			createMap();
		}
		
//==============================================================================================================================		
//				*** Создание ***
//==============================================================================================================================		
		
		//перегнать из xml в массив
		public function prepareRooms() {
			allRoom=new Array();
			for each(var xml in act.allroom.room) {
				allRoom.push(new Room(xml));
			}
		}
		
		
		public function buildRandomLand() {
			if (World.w.landError) {
				locs=null;
				locs[0];
			}
			locs=new Array();
			if (act.conf==0 && act.landStage<=0) maxLocY=3;
			var loc1:Location, loc2:Location;
			var opt:Object=new Object();
			for (var i=minLocX; i<maxLocX; i++) {
				locs[i]=new Array();
				for (var j=minLocY; j<maxLocY; j++) {
					opt.mirror=(Math.random()<0.5);
					opt.water=null;
					opt.ramka=null;
					opt.backform=0;
					opt.transpFon=false;
					//Затопленные комнаты
					if (act.conf==2) {
						if (j==1) opt.water=17;
						if (j>1) opt.water=0;
					}
					if (act.conf==5) {
						if (j==2) opt.water=21;
						if (j>2) opt.water=0;
					}
					//здания
					if (act.conf==3) {
						
					}
					locs[i][j]=new Array();
					if (act.conf==0 && j==0 && !act.visited) { //начальные комнаты
						opt.mirror=false;
						loc1=newTipLoc('beg'+i,i,j,opt);	
					} else if ((act.conf==2 || act.conf==1 || act.conf==5) && j==0 && i==0 && !act.visited) { //начальные комнаты
						opt.mirror=false;
						if (act.conf==5) {
							opt.ramka=3;
							opt.backform=3;
							opt.transpFon=true;
						}
						loc1=newTipLoc('beg0',i,j,opt);	
					} else if (act.conf==3) { //мейнхеттен
						opt.transpFon=true;
						if (i==2) {
							if (j==0) {
								opt.ramka=7;
								loc1=newTipLoc('passroof',i,j,opt);
							} else {
								opt.ramka=5;
								loc1=newRandomLoc(act.landStage,i,j,opt,'pass');
							}
							loc1.bezdna=true;
						} else if (j==0) {
							opt.ramka=6;
							loc1=newRandomLoc(act.landStage,i,j,opt,'roof');
						} else {
							loc1=newRandomLoc(act.landStage,i,j,opt);
							if (i>2 && loc1.backwall=='tWindows') loc1.backwall='tWindows2';
						}
					} else if (act.conf==4) { //военная база
						if (i==0) {
							if (j==0) {
								if (!(World.w.game.triggers['mbase_visited']>0)) {
									opt.mirror=false;
									opt.ramka=8;
									loc1=newTipLoc('beg0',i,j,opt);
								} else {
									loc1=newRandomLoc(0,i,j,opt);
								}
							} else loc1=newRandomLoc(0,i,j,opt,'vert');
						} else if (i==maxLocX-1) {
							if (j==maxLocY-1) {
								opt.mirror=false;
								loc1=newTipLoc('end',i,j,opt);
							} else loc1=newRandomLoc(0,i,j,opt,'vert');
						} else loc1=newRandomLoc(0,i,j,opt);
					} else if (act.conf==7) { //бункер
						if (i==0) {
							if (j==0) {
								opt.mirror=false;
								loc1=newTipLoc('beg1',i,j,opt);
							} else loc1=newRandomLoc(1,i,j,opt,'vert');
						} else if (i==maxLocX-1) {
							if (j==maxLocY-1) {
								opt.mirror=false;
								loc1=newTipLoc('end1',i,j,opt);
							} else loc1=newRandomLoc(1,i,j,opt,'vert');
						} else loc1=newRandomLoc(1,i,j,opt);
					} else if (act.conf==5) { //кантерлот
						if (j==0) {
							opt.ramka=3;
							opt.backform=3;
							opt.transpFon=true;
							loc1=newRandomLoc(act.landStage,i,j,opt,'surf');
							loc1.visMult=2;
							//loc1.backwall='sky';
						} else {
							loc1=newRandomLoc(act.landStage,i,j,opt);
						}
						loc1.gas=1;
					} else if (act.conf==10) { //стойло пи
						opt.home=true;
						if (i==act.begLocX && j==act.begLocY) {
							opt.mirror=false;
							loc1=newTipLoc('beg0',i,j,opt);
						} else if (i==1 && j==1) {
							opt.mirror=false;
							loc1=newTipLoc('roof',i,j,opt);
						} else {
							loc1=newRandomLoc(10,i,j,opt);
						}
					} else if (act.conf==11) { //стойло пи атакованное
						opt.atk=true;
						if (i==5 && j==0) {
							opt.mirror=false;
							loc1=newTipLoc('pass',i,j,opt);
						} else {
							loc1=newRandomLoc(act.landStage,i,j,opt);
						}
					} else {
						loc1=newRandomLoc(act.landStage,i,j,opt);
					}
					//добавить комнату второго слоя
					locs[i][j][0]=loc1;
					if (loc1.room.back!=null) {	
						loc2=null;
						for each(var room:Room in allRoom) {
							if (room.id==loc1.room.back) {
								loc2=newLoc(room,i,j,1,opt);
								loc2.tipEnemy=loc1.tipEnemy;
								locs[i][j][1]=loc2;
								loc2.noMap=true;
								break;
							}
						}
					}
				}
			}
			//определяем возможные проходы
			for (i=minLocX; i<maxLocX; i++) {
				for (j=minLocY; j<maxLocY; j++) {
					loc1=locs[i][j][0];
					loc1.pass_r=new Array();
					loc1.pass_d=new Array();
					if (i<maxLocX-1) {
						loc2=locs[i+1][j][0];
						for (var e=0; e<=5; e++) {
							var hole:int=Math.min(loc1.doors[e],loc2.doors[e+11]);
							if (hole>=2) {
								loc1.pass_r.push({n:e, fak:hole});
							}
						}
					}
					if (j<maxLocY-1) {
						loc2=locs[i][j+1][0];
						for (e=6; e<=11; e++) {
							hole=Math.min(loc1.doors[e],loc2.doors[e+11]);
							if (hole>=2) {
								loc1.pass_d.push({n:e, fak:hole});
							}
						}
					}
				}
			}
			//проделываем проходы, выбирая случайный из возможных
			for (i=minLocX; i<maxLocX; i++) {
				for (j=minLocY; j<maxLocY; j++) {
					loc1=locs[i][j][0];
					if (i<maxLocX-1) {
						if (loc1.pass_r.length) {
							loc2=locs[i+1][j][0];
							for (e=0; e<=2; e++) {
								var n=Math.floor(Math.random()*loc1.pass_r.length);
								loc1.setDoor(loc1.pass_r[n].n,loc1.pass_r[n].fak);
								loc2.setDoor(loc1.pass_r[n].n+11,loc1.pass_r[n].fak);
							}
						}
					}
					if (j<maxLocY-1) {
						if (loc1.pass_d.length) {
							loc2=locs[i][j+1][0];
							n=Math.floor(Math.random()*loc1.pass_d.length);
							loc1.setDoor(loc1.pass_d[n].n,loc1.pass_d[n].fak);
							loc2.setDoor(loc1.pass_d[n].n+11,loc1.pass_d[n].fak);
						}
					}
					loc1.mainFrame();
				}
			}
			//лагерь в канализации
			if (act.conf==2) newRandomProb(locs[3][0][0], act.landStage, true);
			//лагерь в мейнхеттене
			if (act.conf==3 && act.landStage>=1) newRandomProb(locs[1][4][0], act.landStage, true);
			//расставить объекты
			for (j=maxLocY-1; j>=minLocY; j--) {
				for (i=minLocX; i<maxLocX; i++) {
					var isBonuses=true;
					locs[i][j][0].setObjects();
					//Создание контрольных точек
					//if ((i+j)%2==0 && !(act.conf==2 && j>=2) && !(act.conf==3 && (j==0 || i==2))) locs[i][j][0].createCheck(i==act.begLocX && j==act.begLocY);
					//Создание точек выхода
					//конфигурация завода и стойла
					if (act.conf==0 || act.conf==1) {	
						if ((i+j)%2==0) {
							if (j==maxLocY-1) {
								if (act.conf==0 && act.landStage>=2 || act.conf==1 && act.landStage>=1) {
									locs[i][j][0].createExit('1');						//Точки выхода на нижнем уровне
								} else {
									locs[i][j][0].createExit();						//Точки выхода на нижнем уровне
								}
							} else locs[i][j][0].createCheck(i==act.begLocX && j==act.begLocY);	//контрольные точки 
						} else {
							if (j==maxLocY-1) newRandomProb(locs[i][j][0], act.landStage, true);
							else if (Math.random()<0.3) newRandomProb(locs[i][j][0], act.landStage, false);
						}
					}
					//конфигурация канализации и кантерлота
					if (act.conf==2 || act.conf==5) {	//Точки выхода крайние справа
						if (i!=0 || j!=0) locs[i][j][0].createClouds(j);
						if (act.conf==2 && i==maxLocX-1) locs[i][j][0].createExit();
						if (act.conf==5 && i==maxLocX-1 && j==0) {
							if (act.landStage>=1) locs[i][j][0].createExit('1');
							else locs[i][j][0].createExit();
						} else if ((i+j)%2==0) {
							if (act.conf==2 && j<2 && i<maxLocX-1 || act.conf==5 && (i==0 || j>0)) locs[i][j][0].createCheck(i==act.begLocX && j==act.begLocY);
						}
						if (act.conf==2 && j>1) locs[i][j][0].petOn=false;
						if ((j>1 && i<maxLocX-1) || (act.conf==2 && i<maxLocX-1 && Math.random()<0.25)) {
							if ((i+j)%2==1) newRandomProb(locs[i][j][0], act.landStage, false);
						}
					}
					//конфигурация мейнхеттена
					if (act.conf==3 && i!=2) {	//Точки выхода на верхнем уровне
						if ((i+j)%2==0) {
							if (j==0) {
								if (act.landStage>=1) locs[i][j][0].createExit('1');
								else locs[i][j][0].createExit();
							} else locs[i][j][0].createCheck(i==act.begLocX && j==act.begLocY); 
						} else {
							if (j==0) newRandomProb(locs[i][j][0], act.landStage, true);
							else if (j!=4 && Math.random()<0.25) newRandomProb(locs[i][j][0], act.landStage, false);
						}	
					}
					//конфигурация военной базы
					if (act.conf==4) {
						if (i==act.begLocX && j==act.begLocY || i==3) {
							locs[i][j][0].createCheck(i==act.begLocX && j==act.begLocY);
							if (i==act.begLocX && j==act.begLocY) isBonuses=false;
						}
					}
					//конфигурация бункера
					if (act.conf==7) {
						if (i==act.begLocX && j==act.begLocY) {
							locs[i][j][0].createCheck(true);
							isBonuses=false;
						}
					}
					//конфигурация базы анклава
					if (act.conf==6) {
						opt.transpFon=true;
						if (j==0) {
							if (i==0 || i==2) {
								if (act.landStage>=1) locs[i][j][0].createExit('1');
								else locs[i][j][0].createExit();
							}
							if (i==1) newRandomProb(locs[i][j][0], act.landStage, true);
						} else if (i==act.begLocX && j==act.begLocY || i==((7-j)%3)) {
							locs[i][j][0].createCheck(i==act.begLocX && j==act.begLocY);
						} else if (Math.random()<0.25) newRandomProb(locs[i][j][0], act.landStage, false);
					}
					
					//конфигурация стойла пи
					if (act.conf==10 || act.conf==11) {
						if (i==act.begLocX && j==act.begLocY) {
							locs[i][j][0].createCheck(true);
						}
					}
					locs[i][j][0].preStep();
					if (locs[i][j][1]) {
						locs[i][j][1].mainFrame();
						locs[i][j][1].setObjects();
						locs[i][j][1].preStep();
					}
					if (isBonuses) locs[i][j][0].createXpBonuses(5);
					allXp+=locs[i][j][0].summXp;
				}
			}
			buildProbs();
			//Количество объектов
			//trace('safe', kolAll['safe']+kolAll['wallsafe']);
			//trace('bookcase', kolAll['bookcase']);
			//trace('table2', kolAll['chest']);
			//trace('table', kolAll['table']);
			//trace('Сложность местности ',landDifLevel)
		}
		
		public function buildSpecifLand() {
			var i,j,e;
			var loc1:Location, loc2:Location;
			//определяем фактические размеры
			for each(var room:Room in allRoom) {
				if (room.rx<minLocX) minLocX=room.rx;
				if (room.ry<minLocY) minLocY=room.ry;
				if (room.rx+1>maxLocX) maxLocX=room.rx+1;
				if (room.ry+1>maxLocY) maxLocY=room.ry+1;
			}
			//создаём массив
			locs=new Array();
			for (i=minLocX; i<maxLocX; i++) {
				locs[i]=new Array();
				for (j=minLocY; j<maxLocY; j++) locs[i][j]=new Array();
			}
			//заполняем массив
			for each(room in allRoom) {
				loc1=newLoc(room,room.rx,room.ry,room.rz);
				locs[room.rx][room.ry][room.rz]=loc1;
			}
			//расставить объекты
			for (i=minLocX; i<maxLocX; i++) {
				for (j=minLocY; j<maxLocY; j++) {
					for (e=minLocZ; e<maxLocZ; e++) {
						if (locs[i][j][e]==null) continue;
						locs[i][j][e].setObjects();
						locs[i][j][e].preStep();
					}
				}
			}
			buildProbs();
		}
		
		//добавить комнаты испытаний, id которых использовался в местности (были задействованы двери с prob={id})
		//обработать все добавленные
		public function buildProbs() {
			for each (var s in probIds)	buildProb(s);
			for each (var loc in listLocs) {
				loc.setObjects();
				loc.preStep();
				if (loc.prob) loc.prob.prepare();
			}
		}
		
		//создать слой испытаний, вернуть false если слой уже есть
		public function buildProb(nprob:String):Boolean {
			if (probs[nprob]!=null) return false;
			//создать одиночную комнату
			var arrr:XML=World.w.game.probs['prob'].allroom;
			for each(var xml in arrr.room) {
				if (xml.@name==nprob) {
					var room:Room=new Room(xml);
					var loc:Location=newLoc(room,0,0,0,{prob:nprob});
					loc.landProb=nprob;
					loc.noMap=true;
					var xmll=GameData.d.land.prob.(@id==nprob);
					if (xmll.length()) loc.prob=new Probation(xmll[0],loc);
					//добавить дверь для выхода
					if (loc.spawnPoints.length) {
						loc.createObj('doorout','box',loc.spawnPoints[0].x,loc.spawnPoints[0].y,<obj prob='' uid='begin'/>);
					}
					probs[nprob]=[[[loc]]];
					listLocs.push(loc);
					break;
				}
			}
			return true;
		}
		
		//Создать дверь и случайную комнату испытаний за ней, вернуть false если подходящих не нашлось
		public function newRandomProb(nloc:Location, maxlevel:int=100, imp:Boolean=false):Boolean {
			rndRoom=new Array();
			var impProb;
			for each(var xml in act.xmlland.prob) {
				if (probs[xml.@id]==null && World.w.game.triggers['prob_'+xml.@id]==null && (xml.@level.length==0 || xml.@level<=maxlevel)) {
					rndRoom.push(xml.@id);
					if (xml.@imp.length()) impProb=xml.@id;
				}
			}
			if (rndRoom.length==0) return false;
			var pid:String, did:String='doorprob';
			if (imp && impProb) pid=impProb;
			else if (rndRoom.length==1) pid=rndRoom[0];
			else pid=rndRoom[Math.floor(Math.random()*rndRoom.length)];
			try {
				if (act.xmlland.prob.(@id==pid).@tip=='2') did='doorboss';
			} catch (err) {};
			if (!nloc.createDoorProb(did,pid)) return false;
			buildProb(pid);
			//trace(pid);
			return true;
		}
		
		
		//создать новую локацию нужного типа, в заданных координатах
		public function newTipLoc(ntip:String, nx:int, ny:int, opt:Object=null):Location {
			rndRoom=new Array();
			for each(var room in allRoom) {
				if (room.tip==ntip) rndRoom.push(room); 
			}
			if (rndRoom.length>0) {
				room=rndRoom[Math.floor(Math.random()*rndRoom.length)];
			} else {
				room=allRoom[Math.floor(Math.random()*allRoom.length)];
				trace('нет локации '+ntip);
			}
			room.kol--;
			return newLoc(room, nx, ny, 0, opt);
		}
		
		//создать новую случайную локацию, в заданных координатах
		public function newRandomLoc(maxlevel:int, nx:int, ny:int, opt:Object=null, ntip:String=null):Location {
			rndRoom=new Array();
			var r1:Room, r2:Room;
			if (nx>minLocX) r1=locs[nx-1][ny][0].room;
			if (ny>minLocY) r2=locs[nx][ny-1][0].room;
			//массив всех комнат, удовлетворяющих условиям
			for each(var room in allRoom) {
				if (room.lvl<=maxlevel && room.kol>0 && room!=r1 && room!=r2 && (ntip==null && room.rnd || room.tip==ntip)) {
					var rndKol=room.kol*room.kol;
					if (rndKol==4 && room.lvl==0 && maxlevel>1) {
						rndKol=2;
						//if (maxlevel==1 || maxlevel==2) rndKol=2;
						//if (maxlevel>2) rndKol=1;
					}
					for (var i=0; i<rndKol; i++) {
						rndRoom.push(room);
					}
				}
			}
			if (rndRoom.length>0) {
				room=rndRoom[Math.floor(Math.random()*rndRoom.length)];
			} else {
				//массив всех комнат, подходящих для рандома
				for each(room in allRoom) {
					if (room.rnd) {
						rndRoom.push(room);
					}
				}
				room=rndRoom[Math.floor(Math.random()*rndRoom.length)];
			}
			room.kol--;
			if (act.conf==4) room.kol=0;	//на военной базе комнаты используются один раз
			return newLoc(room, nx, ny, 0, opt);
		}
		
		
		//создать новую локацию по заданному Room-шаблону, в заданных координатах
		public function newLoc(room:Room, nx:int, ny:int, nz:int=0, opt:Object=null):Location {
			var loc:Location=new Location(this, room.xml, rnd, opt);
			loc.biom=act.biom;
			loc.room=room;
			loc.landX=nx;
			loc.landY=ny;
			loc.landZ=nz;
			loc.id='loc'+nx+'_'+ny;
			if (nz>0) loc.id+='_'+nz;
			loc.unXp=act.xp;
			
			//Задать градиент сложности
			var deep:Number=0;
			if (rnd) {
				if (act.conf==0) deep=ny/2;	
				if (act.conf==1) deep=ny;
				if (act.conf==2) deep=ny*2.5;
			}
			setLocDif(loc,deep);
			
			loc.addPlayer(gg);
			return loc;
		}
		
		//установка сложности локации, в зависимости от уровня персонажа и градиена сложности
		function setLocDif(loc:Location, deep:Number) {
			var ml:Number=landDifLevel+deep;
			loc.locDifLevel=ml;
			loc.locksLevel=ml*0.7;	//уровень замков
			//loc.locksDif=ml*0.9;	//качество замков
			loc.mechLevel=ml/4;		//уровень мин и механизмов
			loc.weaponLevel=1+ml/4;	//уровень попадающегося оружия
			loc.enemyLevel=ml;		//уровень врагов
			//if (ml<4) loc.earMult=ml/4;
			//влияние настроек сложности
			if (World.w.game.globalDif<2) loc.earMult*=0.5;
			if (World.w.game.globalDif>2) loc.enemyLevel+=(World.w.game.globalDif-2)*2;	//уровень врагов в зависимости от сложности
			//тип врагов
			if (act.biom==0 && Math.random()<0.25) loc.tipEnemy=1;
			if (loc.tipEnemy<0) loc.tipEnemy=Math.floor(Math.random()*3);
			if (act.biom==1) loc.tipEnemy=0;
			if (act.biom==2 && loc.tipEnemy==1 && Math.random()<ml/20) loc.tipEnemy=3;	//работорговцы
			if (act.biom==3) {
				loc.tipEnemy=Math.floor(Math.random()*3)+3;			//4-наёмники, 5-аликорны
			}
			if (ml>12 && (act.biom==0 || act.biom==2 || act.biom==3) && Math.random()<0.1) loc.tipEnemy=6;	//зебры
			//loc.tipEnemy=6;
			if (act.biom==4) loc.tipEnemy=7;	//стальные+роботы
			if (act.biom==5) {
				if (Math.random()<0.3) loc.tipEnemy=5;
				//else if (loc.landY==0 && Math.random()<0.05) loc.tipEnemy=4;
				else loc.tipEnemy=8;	//розовые
			}
			if (act.biom==6) {// || act.biom==11
				if (Math.random()>0.3) loc.tipEnemy=9;	//анклав
				else loc.tipEnemy=10;//гончие
			}
			if (act.biom==11) loc.tipEnemy=11; //анклав и гончие
			//loc.tipEnemy=4;
			//количество врагов
			//тип, мин, макс, случайное увеличение
			if (ml<4) {
				loc.setKolEn(1,3,5,2);
				loc.setKolEn(2,2,4,0);
				loc.setKolEn(3,3,4,2);
				loc.setKolEn(4,1,2,0);
				loc.setKolEn(5,1,4,2);
				if (loc.tipEnemy==6) loc.setKolEn(2,1,3,0);
				if (loc.kolEnSpawn==0) {
					if (loc.tipEnemy!=5) loc.setKolEn(-1,1,2);
				}
				loc.kolEnHid=0;
			} else if (ml<10) {
				loc.setKolEn(1,3,6,2);
				if (Math.random()<0.15) loc.setKolEn(2,1,1,0);
				else if (loc.tipEnemy==6) loc.setKolEn(2,2,3,0);
				else loc.setKolEn(2,2,5,0);
				loc.setKolEn(3,3,5,2);
				loc.setKolEn(4,2,3,1);
				loc.setKolEn(5,2,4,2);
				if (loc.kolEnSpawn==0) {
					if (loc.tipEnemy!=5) loc.setKolEn(-1,2,3);
				}
				loc.kolEnHid=Math.floor(Math.random()*3);
			} else {
				loc.setKolEn(1,4,6,2);
				if (Math.random()<0.15) loc.setKolEn(2,1,2,0);
				else if (loc.tipEnemy==6) loc.setKolEn(2,3,4,0);
				else loc.setKolEn(2,3,6,0);
				loc.setKolEn(3,4,7,2);
				loc.setKolEn(4,2,4,1);
				loc.setKolEn(5,3,6,2);
				if (loc.kolEnSpawn==0) {
					if (loc.tipEnemy!=5) loc.setKolEn(-1,2,4);
					else if (Math.random()>0.4) loc.setKolEn(-1,1,3);
				}
				loc.kolEnHid=Math.floor(Math.random()*4);
			}
			if (loc.tipEnemy==5 || loc.tipEnemy==10) {
				loc.setKolEn(2,1,3,1);
			}
			if (act.biom==11) {
				//if (loc.tipEnemy==10) loc.setKolEn(2,4,5,0);
				//else 
					loc.setKolEn(2,5,8,0);
			}
			//loc.kolEnHid=2;
		}
		
		public function createMap() {
			map=new BitmapData(World.cellsX*(maxLocX-minLocX), World.cellsY*(maxLocY-minLocY),true,0);
		}
		
//==============================================================================================================================		
//				*** Использование ***
//==============================================================================================================================		
		
		//войти в местность
		public function enterLand(first:Boolean=false, coord:String=null) {
			act.visited=true;
			loc=null;
			if (coord!=null) {
				var narr:Array=coord.split(':');
				if (narr.length>=1) locX=narr[0]; else locX=0;
				if (narr.length>=2) locY=narr[1]; else locY=0;
				locZ=0;
				prob='';
				ativateLoc();
				setGGToSpawnPoint();
			} else if (currentCP && !first) {
				World.w.pers.currentCP=currentCP;
				//trace('currentCP', currentCP);
				gotoCheckPoint();
				currentCP.activate();
			} else {
				locX=act.begLocX;
				locY=act.begLocY;
				locZ=0;
				prob='';
				ativateLoc();
				setGGToSpawnPoint();
			}
		}
		
		public function saveObjs(arr:Array) {
			if (rnd) return;
			for (var i=minLocX; i<maxLocX; i++) {
				for (var j=minLocY; j<maxLocY; j++) {
					for (var e=minLocZ; e<maxLocZ; e++) {
						if (locs[i][j][e]==null) continue;
						locs[i][j][e].saveObjs(arr);
					}
				}
			}
		}
		
		//переместить гг в точку спавна
		public function setGGToSpawnPoint() {
			var nx:int=3, ny:int=3;
			if (loc.spawnPoints.length>0) {
				var n=Math.floor(Math.random()*loc.spawnPoints.length);
				nx=loc.spawnPoints[n].x;
				ny=loc.spawnPoints[n].y;
			}
			gg.setLocPos((nx+1)*Tile.tileX, (ny+1)*Tile.tileY-1);
			gg.dx=3;
			loc.lighting(gg.X, gg.Y-75);
			//World.w.cam.calc(gg);
		}
		
		//сделать активной локацию с текущими координатами
		public function ativateLoc():Boolean {
			var nloc:Location;
			if (prob!='' && probs[prob]==null)  return false;
			try {
				if (prob!='') nloc=probs[prob][locX][locY][locZ];	
				else nloc=locs[locX][locY][locZ];
			} catch (err) {
				trace('локация не найдена',act.id,locX,locY,locZ)
				nloc=locs[0][0][0];
			}
			
			if (loc==nloc) return false;
			//if (loc) loc.out(); 
			locN++;
			prevloc=loc;
			loc=nloc;
			gg.inLoc(loc);
			loc.reactivate(locN);
			World.w.ativateLoc(loc);
			if (loc.sky) {
				gg.isFly=true;
				gg.stay=false;
				World.w.cam.setZoom(2);
			}
			loc.lightAll();
			return true;
		}
		
		//перейти в локацию x,y
		public function gotoXY(nx:int,ny:int) {
			if (nx<minLocX) nx=minLocX;
			if (nx>=maxLocX) nx=maxLocX-1;
			if (ny<minLocY) ny=minLocY;
			if (ny>=maxLocY) ny=maxLocY-1;
			locX=nx;
			locY=ny;
			locZ=0;
			ativateLoc();
			setGGToSpawnPoint();
		}
		
		
		//переход между локациями
		public function gotoLoc(napr:int, portX:Number=-1, portY:Number=-1):Object {
			var X:Number=gg.X, Y:Number=gg.Y, scX:Number=gg.scX, scY:Number=gg.scY;
			var newX:int=locX, newY:int=locY, newZ:int=locZ;
			if (napr==1) newX--;
			else if (napr==2) newX++;
			else if (napr==3) newY++;
			else if (napr==4) newY--;
			else if (napr==5) newZ=1-newZ;
			else return null;
			if (prob=='' && (locs[newX]==null || locs[newX][newY]==null || locs[newX][newY][newZ]==null)) {
				if (napr==3) return {die:true};
				return null;
			}
			if (prob!='' && (probs[prob][newX]==null || probs[prob][newX][newY]==null || probs[prob][newX][newY][newZ]==null)) {
				if (napr==3) return {die:true};
				return null;
			}
			var newLoc:Location=locs[newX][newY][newZ];
			var outP:Object=new Object();
			if (napr==1) {
				outP.x=newLoc.limX-scX/2-9;
				outP.y=Y-1;
			} else if (napr==2) {
				outP.x=0+scX/2+9;
				outP.y=Y-1;
			} else if (napr==3) {
				outP.x=X;
				outP.y=0+scY+10;
			} else if (napr==4) {
				outP.x=X;
				outP.y=newLoc.limY-10;
			} else if (napr==5) {
				outP.x=portX;
				outP.y=portY;
			}
			if (newLoc.collisionUnit(outP.x,outP.y,scX-4,scY)) return null;
			loc_t=150;
			locX=newX, locY=newY, locZ=newZ;
			ativateLoc();
			gg.setLocPos(outP.x,outP.y);
			return outP;
		}
		
		//перейти на слой испытаний nprob, или вернуться на основной слой, если параметр не задан
		public function gotoProb(nprob:String='', nretX:Number=-1, nretY:Number=-1) {
			if (nprob=='') {
				prob='';
				locX=retLocX;
				locY=retLocY;
				locZ=retLocZ;
				ativateLoc();
				if (retX==0 && retY==0) setGGToSpawnPoint();
				else gg.setLocPos(retX,retY);
			} else {
				retLocX=locX, retLocY=locY, retLocZ=locZ;
				if (nretX<0 || nretY<0) {
					retX=gg.X, retY=gg.Y;
				} else {
					retX=nretX, retY=nretY;
				}
				prob=nprob;
				locX=locY=locZ=0;
				if (ativateLoc()) {
					setGGToSpawnPoint();
				} else {
					prob='';
					locX=retLocX;
					locY=retLocY;
					locZ=retLocZ;
				}
			}
		}
		
		public function gotoCheckPoint() {
			var cp:CheckPoint=World.w.pers.currentCP;
			if (cp==null) {
				gg.setNull();
				return;
			}
			if (cp.loc.land!=this && currentCP)	{
				cp=currentCP;
				World.w.pers.currentCP=currentCP;
				currentCP.activate();
			}
			if (cp.loc.land!=this) {
				locX=act.begLocX;
				locY=act.begLocY;
				locZ=0;
				prob='';
				if (!ativateLoc()) loc.reactivate();
				setGGToSpawnPoint();
			} else {
				locX=cp.loc.landX;
				locY=cp.loc.landY;
				locZ=cp.loc.landZ;
				prob=cp.loc.landProb;
				if (!ativateLoc()) loc.reactivate();
				gg.setLocPos(cp.X,cp.Y);
			}
			gg.dx=3;
		}
		
		public function refill() {
			if (isRefill) return;
			if (summXp*10>allXp || !rnd) {
				World.w.game.refillVendors();
				isRefill=true;
			} else {
				trace('опыта получено: ',summXp,allXp);
			}
		}
		
		public function artBabah() {
			Snd.ps('artfire');
			World.w.quake(10,3);
		}
		
		public function artStep() {
			art_t--;
			if (art_t<=0) {
				art_t=Math.floor(Math.random()*1000+20);
				if (act.artFire!=null && World.w.game.triggers[act.artFire]!=1) {
					artBabah();
				}
			}
		}
		
		public function drawMap():BitmapData {
			map.fillRect(map.rect,0x00000000);
			for (var i=minLocX; i<maxLocX; i++) {
				for (var j=minLocY; j<maxLocY; j++) {
					if (locs[i][j][0]!=null && (World.w.drawAllMap || locs[i][j][0].visited)) locs[i][j][0].drawMap(map);
				}
			}
			ggX=(loc.landX-minLocX)*World.cellsX*World.tileX+gg.X;
			ggY=(loc.landY-minLocY)*World.cellsY*World.tileY+gg.Y-gg.scY/2;
			return map;
		}
		
		//убить всех врагов и открыть все контейнеры
		public function getAll():int {
			var summ:int=0;
			for (var i=minLocX; i<maxLocX; i++) {
				for (var j=minLocY; j<maxLocY; j++) {
					for (var e=minLocZ; e<maxLocZ; e++) {
						if (locs[i][j][e]==null) continue;
						summ+=locs[i][j][e].getAll();
					}
				}
			}
			return summ;
		}
		
		public function step() {
			if (!World.w.catPause) {
				loc.step();
				if (loc_t>0) {
					loc_t--;
					if (prevloc && loc!=prevloc) prevloc.stepInvis();
				}
				artStep();
			}
			if (scripts.length) {
				for each (var scr:Script in scripts) {
					if (scr.running) scr.step();
				}
			}
		}
		

	}
	
}

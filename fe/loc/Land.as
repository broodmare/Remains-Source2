package fe.loc {

	import fe.*;
	import fe.util.Vector2;
	import fe.unit.UnitPlayer;
	import flash.display.BitmapData;
	import fe.serv.Script;

	public class Land {
		
		public var act:LandAct;					//шаблон, по которому была создана местность
		
		public var rnd:Boolean = false;			//true если местность с рандомной генерацией
		public var loc:Location;				//текущая локация
		private var prevloc:Location;			//предыдущая посещённая локация
		public var locs:Array;					//трёхмераня карта всех локаций
		public var probs:Array;					//локации испытаний
		public var listLocs:Array;				//линейный массив локаций

		public var locX:int;
		public var locY:int;
		public var locZ:int = 0;				//координаты активной локации

		public var retLocX:int = 0;
		public var retLocY:int = 0;
		public var retLocZ:int = 0;
		public var retX:Number = 0;
		public var retY:Number = 0;				//координаты возврата в основной слой
		public var prob:String = '';			//слой испытания, ''-основной слой

		public var minLocX:int = 0;
		public var minLocY:int = 0;
		public var minLocZ:int = 0;				//размер местности

		public var maxLocX:int = 4;
		public var maxLocY:int = 6;
		public var maxLocZ:int = 2;				//размер местности
		
		public var loc_t:int=0;					//таймер
		public static var locN:int = 0;			//счётчик переходов
		
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
		
		private var allRoom:Array;				//массив всех комнат, взятый из xml
		private var rndRoom:Array;				//массив, использующийся для рандомной генерации
		public var kolAll:Array;				//количество каждого вида объекта
		
		public var uidObjs:Array;				//все объекты, имеющие uid
		public var scripts:Array;				//массив скриптов, имеющих время выполнения
		public var itemScripts:Array;			//массив скриптов, привязанных к взятию объектов
		
		public var kol_phoenix:int=0;
		public var aliAlarm:Boolean=false;		//тревога среди аликорнов
		
		public var probIds:Array;				//имеющиеся комнаты испытаний
		private var impProb:int=-1;				//важная комната испытаний

		private var tileX:int = Tile.tileX;
		private var tileY:int = Tile.tileY;

		//lvl - уровень перса-1
		public function Land(ngg:UnitPlayer, nact:LandAct, lvl:int) {
			gg=ngg;
			act=nact;
			rnd=act.rnd;
			uidObjs		= [];
			scripts		= [];
			kolAll		= [];
			listLocs	= [];
			probIds		= [];
			probs		= [];
			prepareRooms();

			if (rnd) {
				landDifLevel=lvl;	//сложность определяется заданным параметром
				if (landDifLevel<act.dif) landDifLevel=act.dif;	//если сложность меньше минимальной, установить минимальную
				maxLocX=act.mLocX;	//размеры берутся из настроек act
				maxLocY=act.mLocY;
				buildRandomLand();
			}
			else {
				landDifLevel=act.dif;	//сложность берётся из настроек act
				if (act.autoLevel) landDifLevel=lvl;
				maxLocX=maxLocY=1;	//размеры определяются в соотвествии с картой
				buildSpecifLand();
			}

			lootLimit = lvl + 3;
			gameStage=act.gameStage;	//этап сюжета берётся из настроек
			//прикреплённые скрипты
			itemScripts = [];

			for each(var xl in act.xmlland.scr) {
				if (xl.@eve == 'take' && xl.@item.length()) {
					var scr:Script = new Script(xl, this);
					itemScripts[xl.@item] = scr;
				}
			}
			
			createMap();
		}
		
//==============================================================================================================================		
//				*** Создание ***
//==============================================================================================================================		
		
		//перегнать из xml в массив
		public function prepareRooms():void {
			allRoom = [];
			for each(var xml in act.allroom.room) {
				allRoom.push(new Room(xml));
			}
		}
		
		public function buildRandomLand():void {
			if (World.w.landError) {
				locs = null;
				locs[0]; // Intentionally trigger an error??
			}

			locs = [];

			if (act.conf == 0 && act.landStage <= 0) {
				maxLocY = 3;
			}

			var loc1:Location;
			var loc2:Location;
			var opt:Object = {};

			// Helper function to configure water based on conf and j
			function configureWater(conf:int, j:int):void {
				switch(conf) {
					case 2:
						opt.water = (j == 1) ? 17 : (j > 1 ? 0 : null);
						break;
					case 5:
						opt.water = (j == 2) ? 21 : (j > 2 ? 0 : null);
						break;
					default:
						opt.water = null;
				}
			}

			// Initialize locations
			for (var i:int = minLocX; i < maxLocX; i++) {
				locs[i] = [];
				for (var j:int = minLocY; j < maxLocY; j++) {
					// Reset options
					opt.mirror = (Math.random() < 0.5);
					opt.water = null;
					opt.ramka = null;
					opt.backform = 0;
					opt.transpFon = false;

					configureWater(act.conf, j);

					// Additional configuration based on conf
					switch(act.conf) {
						case 0:	// Basically one big OR statement for all of these
						case 1:
						case 2:
						case 3:
						case 4:
						case 5:
						case 7:
						case 10:
						case 11:
							// Handled in the location creation below
							break;
						default:
							// Default case if needed
							break;
					}

					locs[i][j] = [];

					// Determine initial rooms
					if ((act.conf == 0 && j == 0 && !act.visited) ||
						((act.conf == 1 || act.conf == 2 || act.conf == 5) && j == 0 && i == 0 && !act.visited)) {
						opt.mirror = false;
						if (act.conf == 5) {
							opt.ramka = 3;
							opt.backform = 3;
							opt.transpFon = true;
						}
						loc1 = newTipLoc('beg' + ((act.conf == 0) ? i : '0'), i, j, opt);
					}
					else {
						switch(act.conf) {
							case 3: // Manehattan
								opt.transpFon = true;
								if (i == 2) {
									if (j == 0) {
										opt.ramka = 7;
										loc1 = newTipLoc('passroof', i, j, opt);
									}
									else {
										opt.ramka = 5;
										loc1 = newRandomLoc(act.landStage, i, j, opt, 'pass');
									}
									loc1.bezdna = true;
								}
								else if (j == 0) {
									opt.ramka = 6;
									loc1 = newRandomLoc(act.landStage, i, j, opt, 'roof');
								}
								else {
									loc1 = newRandomLoc(act.landStage, i, j, opt);
									if (i > 2 && loc1.backwall == 'tWindows') {
										loc1.backwall = 'tWindows2';
									}
								}
								break;
							case 4: // Military Base
								if (i == 0) {
									if (j == 0) {
										if (World.w.game.triggers['mbase_visited'] > 0) {
											loc1 = newRandomLoc(0, i, j, opt);
										}
										else {
											opt.mirror = false;
											opt.ramka = 8;
											loc1 = newTipLoc('beg0', i, j, opt);
										}
									}
									else {
										loc1 = newRandomLoc(0, i, j, opt, 'vert');
									}
								}
								else if (i == maxLocX - 1) {
									if (j == maxLocY - 1) {
										opt.mirror = false;
										loc1 = newTipLoc('end', i, j, opt);
									}
									else {
										loc1 = newRandomLoc(0, i, j, opt, 'vert');
									}
								}
								else {
									loc1 = newRandomLoc(0, i, j, opt);
								}
								break;
							case 5: // Canterlot
								if (j == 0) {
									opt.ramka = 3;
									opt.backform = 3;
									opt.transpFon = true;
									loc1 = newRandomLoc(act.landStage, i, j, opt, 'surf');
									loc1.visMult = 2;
								}
								else {
									loc1 = newRandomLoc(act.landStage, i, j, opt);
								}
								loc1.gas = 1;
								break;
							case 7: // Bunker
								if (i == 0) {
									if (j == 0) {
										opt.mirror = false;
										loc1 = newTipLoc('beg1', i, j, opt);
									}
									else {
										loc1 = newRandomLoc(1, i, j, opt, 'vert');
									}
								}
								else if (i == maxLocX - 1) {
									if (j == maxLocY - 1) {
										opt.mirror = false;
										loc1 = newTipLoc('end1', i, j, opt);
									}
									else {
										loc1 = newRandomLoc(1, i, j, opt, 'vert');
									}
								}
								else {
									loc1 = newRandomLoc(1, i, j, opt);
								}
								break;
							case 10: // Pi Stable
								opt.home = true;
								if (i == act.begLocX && j == act.begLocY) {
									opt.mirror = false;
									loc1 = newTipLoc('beg0', i, j, opt);
								}
								else if (i == 1 && j == 1) {
									opt.mirror = false;
									loc1 = newTipLoc('roof', i, j, opt);
								}
								else {
									loc1 = newRandomLoc(10, i, j, opt);
								}
								break;
							case 11: // Attacked Pi Stable
								opt.atk = true;
								if (i == 5 && j == 0) {
									opt.mirror = false;
									loc1 = newTipLoc('pass', i, j, opt);
								}
								else {
									loc1 = newRandomLoc(act.landStage, i, j, opt);
								}
								break;
							default: // Default case
								loc1 = newRandomLoc(act.landStage, i, j, opt);
								break;
						}
					}

					locs[i][j][0] = loc1;

					// Add second layer if applicable
					if (loc1.room.back != null) {	
						loc2 = null;
						for each(var room:Room in allRoom) {
							if (room.id == loc1.room.back) {
								loc2 = newLoc(room, i, j, 1, opt);
								loc2.tipEnemy = loc1.tipEnemy;
								locs[i][j][1] = loc2;
								loc2.noMap = true;
								break;
							}
						}
					}
				}
			}

			// Determine possible passages
			for (i = minLocX; i < maxLocX; i++) {
				for (j = minLocY; j < maxLocY; j++) {
					loc1 = locs[i][j][0];
					loc1.pass_r = [];
					loc1.pass_d = [];

					// Right passages
					if (i < maxLocX - 1) {
						loc2 = locs[i + 1][j][0];
						for (var e:int = 0; e <= 5; e++) {
							var hole:int = Math.min(loc1.doors[e], loc2.doors[e + 11]);
							if (hole >= 2) {
								loc1.pass_r.push({n: e, fak: hole});
							}
						}
					}

					// Down passages
					if (j < maxLocY - 1) {
						loc2 = locs[i][j + 1][0];
						for (var f:int = 6; f <= 11; f++) {
							hole = Math.min(loc1.doors[f], loc2.doors[f + 11]);
							if (hole >= 2) {
								loc1.pass_d.push({n: f, fak: hole});
							}
						}
					}
				}
			}

			// Create passages by selecting randomly from possible options
			for (i = minLocX; i < maxLocX; i++) {
				for (j = minLocY; j < maxLocY; j++) {
					loc1 = locs[i][j][0];

					// Right passage
					if (i < maxLocX - 1 && loc1.pass_r.length > 0) {
						loc2 = locs[i + 1][j][0];
						for (e = 0; e <= 2; e++) {
							var n:int = int(Math.random() * loc1.pass_r.length);
							var selectedPass:Object = loc1.pass_r[n];
							loc1.setDoor(selectedPass.n, selectedPass.fak);
							loc2.setDoor(selectedPass.n + 11, selectedPass.fak);
						}
					}

					// Down passage
					if (j < maxLocY - 1 && loc1.pass_d.length > 0) {
						loc2 = locs[i][j + 1][0];
						n = int(Math.random() * loc1.pass_d.length);
						selectedPass = loc1.pass_d[n];
						loc1.setDoor(selectedPass.n, selectedPass.fak);
						loc2.setDoor(selectedPass.n + 11, selectedPass.fak);
					}

					loc1.mainFrame();
				}
			}

			// Special camp placements
			if (act.conf == 2) {
				newRandomProb(locs[3][0][0], act.landStage, true);
			}
			if (act.conf == 3 && act.landStage >= 1) {
				newRandomProb(locs[1][4][0], act.landStage, true);
			}

			// Place objects and bonuses
			for (j = maxLocY - 1; j >= minLocY; j--) {
				for (i = minLocX; i < maxLocX; i++) {
					var isBonuses:Boolean = true;
					loc1 = locs[i][j][0];
					loc1.setObjects();

					// Configuration based on act.conf
					switch(act.conf) {
						case 0:
						case 1:
							if ((i + j) % 2 == 0) {
								if (j == maxLocY - 1) {
									if ((act.conf == 0 && act.landStage >= 2) || (act.conf == 1 && act.landStage >= 1)) {
										loc1.createExit('1'); // Exit points on lower level
									}
									else {
										loc1.createExit(); // Default exit points
									}
								}
								else { // Checkpoints
									loc1.createCheck(i == act.begLocX && j == act.begLocY);
								}
							}
							else {
								if (j == maxLocY - 1) {
									newRandomProb(loc1, act.landStage, true);
								}
								else if (Math.random() < 0.3) {
									newRandomProb(loc1, act.landStage, false);
								}
							}
							break;

						case 2:
						case 5:
							// Exit points on the far right
							if (i != 0 || j != 0) {
								loc1.createClouds(j);
							}

							if (act.conf == 2 && i == maxLocX - 1) {
								loc1.createExit();
							}

							if (act.conf == 5 && i == maxLocX - 1 && j == 0) {
								loc1.createExit((act.landStage >= 1) ? '1' : undefined);
							}
							else if ((i + j) % 2 == 0) {
								if ((act.conf == 2 && j < 2 && i < maxLocX - 1) || 
									(act.conf == 5 && (i == 0 || j > 0))) {
									loc1.createCheck(i == act.begLocX && j == act.begLocY);
								}
							}

							if (act.conf == 2 && j > 1) {
								loc1.petOn = false;
							}

							if (((j > 1 && i < maxLocX - 1) || 
								(act.conf == 2 && i < maxLocX - 1 && Math.random() < 0.25)) && 
								(i + j) % 2 == 1) {
								newRandomProb(loc1, act.landStage, false);
							}
							break;

						case 3: // Mainhattan
							if (i != 2) {
								if ((i + j) % 2 == 0) {
									if (j == 0) {
										loc1.createExit((act.landStage >= 1) ? '1' : undefined);
									}
									else {
										loc1.createCheck(i == act.begLocX && j == act.begLocY);
									}
								}
								else {
									if (j == 0) {
										newRandomProb(loc1, act.landStage, true);
									}
									else if (j != 4 && Math.random() < 0.25) {
										newRandomProb(loc1, act.landStage, false);
									}
								}
							}
							break;

						case 4: // Military Base
							if ((i == act.begLocX && j == act.begLocY) || i == 3) {
								loc1.createCheck(i == act.begLocX && j == act.begLocY);
								if (i == act.begLocX && j == act.begLocY) {
									isBonuses = false;
								}
							}
							break;

						case 6: // Enclave Base
							opt.transpFon = true;
							if (j == 0) {
								if (i == 0 || i == 2) {
									loc1.createExit((act.landStage >= 1) ? '1' : undefined);
								}
								if (i == 1) {
									newRandomProb(loc1, act.landStage, true);
								}
							}
							else if (i == act.begLocX && j == act.begLocY || i == ((7 - j) % 3)) {
								loc1.createCheck(i == act.begLocX && j == act.begLocY);
							}
							else if (Math.random() < 0.25) {
								newRandomProb(loc1, act.landStage, false);
							}
							break;

						case 7: // Bunker
							if (i == act.begLocX && j == act.begLocY) {
								loc1.createCheck(true);
								isBonuses = false;
							}
							break;

						case 10:
						case 11: // Pi Stall and Attacked Pi Stall
							if (i == act.begLocX && j == act.begLocY) {
								loc1.createCheck(true);
							}
							break;

						default:
							// Handle other configurations if necessary
							break;
					}

					loc1.preStep();

					// Handle second layer location
					if (locs[i][j][1]) {
						var loc2Layer:Location = locs[i][j][1];
						loc2Layer.mainFrame();
						loc2Layer.setObjects();
						loc2Layer.preStep();
					}

					if (isBonuses) {
						loc1.createXpBonuses(5);
					}

					allXp += loc1.summXp;
				}
			}

			buildProbs();
		}
		
		public function buildSpecifLand() {
			var i;
			var j;
			var e;
			var loc1:Location;
			var loc2:Location;

			//определяем фактические размеры
			for each(var room:Room in allRoom) {
				if (room.rx<minLocX) minLocX=room.rx;
				if (room.ry<minLocY) minLocY=room.ry;
				if (room.rx+1>maxLocX) maxLocX=room.rx+1;
				if (room.ry+1>maxLocY) maxLocY=room.ry+1;
			}
			
			//создаём массив
			locs=[];
			
			for (i=minLocX; i<maxLocX; i++) {
				locs[i]=[];
				for (j=minLocY; j<maxLocY; j++) locs[i][j]=[];
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
				if (xml.@name == nprob)
				{
					var room:Room = new Room(xml);
					var loc:Location = newLoc(room,0,0,0,{prob:nprob});
					loc.landProb = nprob;
					loc.noMap = true;
					
					var xmll:XML = XMLDataGrabber.getNodeByNameWithAttributeThatMatches("core", "GameData", "Lands", "prob", "id", nprob);
					
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
			rndRoom=[];
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
			
			if (act.xmlland.prob.(@id==pid).@tip=='2') did='doorboss';
			
			if (!nloc.createDoorProb(did,pid)) return false;
			
			buildProb(pid);
			
			return true;
		}
		
		
		//создать новую локацию нужного типа, в заданных координатах
		public function newTipLoc(ntip:String, nx:int, ny:int, opt:Object=null):Location {
			rndRoom=[];
			
			for each(var room in allRoom) {
				if (room.tip==ntip) rndRoom.push(room); 
			}
			
			if (rndRoom.length>0) {
				room=rndRoom[Math.floor(Math.random()*rndRoom.length)];
			}
			else {
				room=allRoom[Math.floor(Math.random()*allRoom.length)];
				trace('нет локации '+ntip);
			}
			
			room.kol--;
			
			return newLoc(room, nx, ny, 0, opt);
		}
		
		//создать новую случайную локацию, в заданных координатах
		public function newRandomLoc(maxlevel:int, nx:int, ny:int, opt:Object=null, ntip:String=null):Location {
			rndRoom=[];
			var r1:Room, r2:Room;
			if (nx>minLocX) r1=locs[nx-1][ny][0].room;
			if (ny>minLocY) r2=locs[nx][ny-1][0].room;
			//массив всех комнат, удовлетворяющих условиям
			for each(var room in allRoom) {
				if (room.lvl<=maxlevel && room.kol>0 && room!=r1 && room!=r2 && (ntip==null && room.rnd || room.tip==ntip)) {
					var rndKol=room.kol*room.kol;
					if (rndKol==4 && room.lvl==0 && maxlevel>1) {
						rndKol=2;
					}
					for (var i=0; i<rndKol; i++) {
						rndRoom.push(room);
					}
				}
			}
			if (rndRoom.length>0) {
				room=rndRoom[Math.floor(Math.random()*rndRoom.length)];
			}
			else {
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
			
			if (nz >0 ) loc.id += '_'+nz;
			
			loc.unXp=act.xp;
			
			//Задать градиент сложности
			var deep:Number=0;
			
			if (rnd) {
				if (act.conf==0) deep=ny/2;	
				if (act.conf==1) deep=ny;
				if (act.conf==2) deep=ny*2.5;
			}
			
			setLocDif(loc, deep);
			loc.addPlayer(gg);
			
			return loc;
		}
		
		//установка сложности локации, в зависимости от уровня персонажа и градиена сложности
		private function setLocDif(loc:Location, deep:Number):void {
			var ml:Number=landDifLevel+deep;
			loc.locDifLevel=ml;
			loc.locksLevel=ml*0.7;	//уровень замков
			loc.mechLevel=ml/4;		//уровень мин и механизмов
			loc.weaponLevel=1+ml/4;	//уровень попадающегося оружия
			loc.enemyLevel=ml;		//уровень врагов
			
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
			
			if (act.biom==4) loc.tipEnemy=7;	//стальные+роботы
			
			if (act.biom==5) {
				if (Math.random()<0.3) loc.tipEnemy=5;
				else loc.tipEnemy=8;	//розовые
			}
			
			if (act.biom==6) {
				if (Math.random()>0.3) loc.tipEnemy=9;	//анклав
				else loc.tipEnemy=10;//гончие
			}
			
			if (act.biom==11) loc.tipEnemy=11; //анклав и гончие
			
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
			}
			else if (ml<10) {
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
			}
			else {
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
				loc.setKolEn(2,5,8,0);
			}
		}
		
		public function createMap():void {
			map = new BitmapData(World.cellsX * (maxLocX - minLocX), World.cellsY * (maxLocY - minLocY), true, 0);
		}
		
//==============================================================================================================================		
//				*** [Usage] ***
//==============================================================================================================================		
		
		// [Enter the area]
		public function enterLand(first:Boolean=false, coord:String=null):void {
			act.visited=true;
			loc = null;
			if (coord != null) {
				var narr:Array=coord.split(':');

				if (narr.length>=1) locX=narr[0];
				else locX=0;

				if (narr.length>=2) locY=narr[1];
				else locY=0;

				locZ = 0;
				prob = '';
				ativateLoc();
				setGGToSpawnPoint();
			}
			else if (currentCP && !first) {
				World.w.pers.currentCP=currentCP;
				gotoCheckPoint();
				currentCP.activate();
			}
			else {
				locX = act.begLocX;
				locY = act.begLocY;
				locZ = 0;
				prob = '';
				ativateLoc();
				setGGToSpawnPoint();
			}
		}
		
		public function saveObjs(arr:Array):void {
			if (rnd) return;
			for (var i:int = minLocX; i < maxLocX; i++) {
				for (var j:int = minLocY; j<maxLocY; j++) {
					for (var e:int = minLocZ; e < maxLocZ; e++) {
						if (locs[i][j][e]==null) continue;
						locs[i][j][e].saveObjs(arr);
					}
				}
			}
		}
		
		// [Move gg to spawn point]
		public function setGGToSpawnPoint():void {
			var nx:int=3, ny:int=3;
			
			if (loc.spawnPoints.length>0) {
				var n:int = Math.floor(Math.random()*loc.spawnPoints.length);
				nx = loc.spawnPoints[n].x;
				ny = loc.spawnPoints[n].y;
			}
			
			gg.setLocPos((nx+1) * tileX, (ny+1) * tileY - 1);
			gg.velocity.X = 3;
			loc.lighting(gg.coordinates.X, gg.coordinates.Y - 75);
		}
		
		// [Make the location with current coordinates active]
		public function ativateLoc():Boolean {
			var nloc:Location;
			
			if (prob!='' && probs[prob]==null)  return false;

			if (prob == '') {
				nloc = locs[locX][locY][locZ];
			}
			else {
				nloc = probs[prob][locX][locY][locZ];
			}
			
			if (loc==nloc) {
				return false;
			}
			
			locN++;
			prevloc=loc;
			loc=nloc;
			gg.inLoc(loc);
			loc.reactivate(locN);
			World.w.ativateLoc(loc);
			
			if (loc.sky) {
				gg.isFly = true;
				gg.stay = false;
				World.w.cam.setZoom(2);
			}
			
			loc.lightAll();
			
			return true;
		}
		
		// [Go to location x,y]
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
		
		// [Transition between locations]
		public function gotoLoc(napr:int, portX:Number=-1, portY:Number=-1):Object {
			var X:Number=gg.coordinates.X, Y:Number=gg.coordinates.Y, objectWidth:Number=gg.boundingBox.width, objectHeight:Number=gg.boundingBox.height;
			var newX:int=locX, newY:int=locY, newZ:int=locZ;

			switch (napr) {
				case 1:
					newX--;
				break;
				case 2:
					newX++;
				break;
				case 3:
					newY++;
				break;
				case 4:
					newY--;
				break;
				case 5:
					newZ = 1 - newZ;
				break;
				default:
					return null;
				break;
			}

			if (prob=='' && (locs[newX]==null || locs[newX][newY]==null || locs[newX][newY][newZ]==null)) {
				if (napr==3) return {die:true};
				return null;
			}
			
			if (prob!='' && (probs[prob][newX]==null || probs[prob][newX][newY]==null || probs[prob][newX][newY][newZ]==null)) {
				if (napr==3) return {die:true};
				return null;
			}
			
			var newLoc:Location=locs[newX][newY][newZ];
			var outP:Object = new Object();

			switch (napr) {
				case 1:
					outP.x = newLoc.maxX - objectWidth / 2 - 9;
					outP.y = Y - 1;
				break;
				case 2:
					outP.x = objectWidth / 2 + 9;
					outP.y = Y - 1;
				break;
				case 3:
					outP.x = X;
					outP.y = objectHeight + 10;
				break;
				case 4:
					outP.x = X;
					outP.y = newLoc.maxY - 10;
				break;
				case 5:
					outP.x = portX;
					outP.y = portY;
				break;
			}

			if (newLoc.collisionUnit(outP.x, outP.y, objectWidth - 4, objectHeight)) {
				return null;
			}
			
			loc_t = 150;
			
			locX = newX;
			locY = newY;
			locZ = newZ;

			ativateLoc();
			gg.setLocPos(outP.x, outP.y);
			
			return outP;
		}
		
		// [Go to the nprob test layer, or return to the main layer if the parameter is not specified]
		public function gotoProb(nprob:String='', nretX:Number=-1, nretY:Number=-1):void {
			if (nprob == "") {
				prob = "";
				locX = retLocX;
				locY = retLocY;
				locZ = retLocZ;
				
				ativateLoc();
				
				if (retX==0 && retY==0) setGGToSpawnPoint();
				else gg.setLocPos(retX,retY);
			}
			else {
				retLocX = locX;
				retLocY = locY;
				retLocZ = locZ;
				
				if (nretX<0 || nretY<0) {
					retX=gg.coordinates.X;
					retY=gg.coordinates.Y;
				}
				else {
					retX=nretX;
					retY=nretY;
				}
				
				prob = nprob;
				locX = 0;
				locY = 0;
				locZ = 0;
				
				if (ativateLoc()) {
					setGGToSpawnPoint();
				}
				else {
					prob = '';
					locX = retLocX;
					locY = retLocY;
					locZ = retLocZ;
				}
			}
		}
		
		public function gotoCheckPoint():void {
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
			
			if (cp.loc.land == this) {
				locX = cp.loc.landX;
				locY = cp.loc.landY;
				locZ = cp.loc.landZ;
				prob = cp.loc.landProb;
				if (!ativateLoc()) loc.reactivate();
				gg.setLocPos(cp.coordinates.X, cp.coordinates.Y);
			}
			else {
				locX = act.begLocX;
				locY = act.begLocY;
				locZ = 0;
				prob = '';
				if (!ativateLoc()) loc.reactivate();
				setGGToSpawnPoint();
			}
			
			gg.velocity.X = 3;
		}
		
		public function refill():void {
			if (isRefill) {
				return;
			}

			if (summXp * 10 > allXp || !rnd) {
				World.w.game.vendorManager.refillAllVendors();
				isRefill = true;
			}
			else {
				trace('опыта получено: ', summXp, allXp);
			}
		}
		
		public function artBabah():void {
			Snd.ps('artfire');
			World.w.quake(10,3);
		}
		
		public function artStep():void {
			art_t--;
			if (art_t<=0) {
				art_t=int(Math.random()*1000+20);
				if (act.artFire!=null && World.w.game.triggers[act.artFire]!=1) {
					artBabah();
				}
			}
		}
		
		public function drawMap():BitmapData {
			map.fillRect(map.rect,0x00000000);
			for (var i:int = minLocX; i < maxLocX; i++) {
				for (var j:int = minLocY; j < maxLocY; j++) {
					if (locs[i][j][0]!=null && (World.w.drawAllMap || locs[i][j][0].visited)) locs[i][j][0].drawMap(map);
				}
			}
			ggX = (loc.landX - minLocX) * World.cellsX * tileX + gg.coordinates.X;
			ggY = (loc.landY - minLocY) * World.cellsY * tileY + gg.boundingBox.bottom;
			return map;
		}
		
		// [Kill all enemies and open all containers]
		public function getAll():int {
			var summ:int=0;
			for (var i:int = minLocX; i < maxLocX; i++) {
				for (var j:int = minLocY; j < maxLocY; j++) {
					for (var e:int = minLocZ; e < maxLocZ; e++) {
						if (locs[i][j][e] == null) continue;
						summ += locs[i][j][e].getAll();
					}
				}
			}
			return summ;
		}
		
		public function step():void {
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
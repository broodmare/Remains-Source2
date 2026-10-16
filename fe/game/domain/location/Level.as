package fe.game.domain.location {

	import fe.game.World;
	import fe.game.GameContainer;
	import fe.engine.audio.Sound;
	import fe.engine.text.XMLDataGrabber
	import fe.game.domain.location.factories.LocationFactory;
	import fe.game.domain.units.UnitPlayer;
	import fe.game.domain.serv.Script;
	import fe.game.domain.location.tile.Tile;
	import fe.game.enums.E_Direction;
	import fe.engine.utils.Vec2;
	import fe.game.domain.objects.CheckPoint;
	import fe.game.ui.Minimap;

	public class Level {
		
		public var act:LevelSettings;				//шаблон, по которому была создана местность
		
		public var rnd:Boolean = false;				//true если местность с рандомной генерацией
		public var loc:Location;					//текущая локация
		private var prevloc:Location;				//предыдущая посещённая локация
		public var locs:Array;						//трёхмераня карта всех локаций
		public var challenges:Array;				//локации испытаний
		public var listLocs:Array;					//линейный массив локаций

		public var locX:int;
		public var locY:int;
		public var locZ:int = 0;					//координаты активной локации

		public var retLocX:int = 0;
		public var retLocY:int = 0;
		public var retLocZ:int = 0;
		public var retX:Number = 0;
		public var retY:Number = 0;					//координаты возврата в основной слой
		public var activeChallengeId:String = '';	//слой испытания, ''-основной слой

		public var minLocX:int = 0;
		public var minLocY:int = 0;
		public var minLocZ:int = 0;					//размер местности

		public var maxLocX:int = 4;
		public var maxLocY:int = 6;
		public var maxLocZ:int = 2;					//размер местности
		
		public var loc_t:int=0;						//таймер
		public static var locN:int = 0;				//счётчик переходов
		
		public var gg:UnitPlayer;
		public var currentCP:CheckPoint;
		public var art_t:int=200;
		
		public var minimap:Minimap;					// Pip-Buck map of the whole level
		
		public var landDifLevel:Number=0;			//общая сложность, зависит от левела гг или настроек карты
		public var gameStage:int=0;					//этап сюжета игры, влияет на выпадение лута, если 0, то без ограничений
		public var lootLimit:Number=0;				//лимит выпадения особых предметов
		public var allXp:int=0;
		public var summXp:int=0;
		public var isRefill:Boolean=false;			//было восполнение товаров
		
		public var allRoom:Array;					//массив всех комнат, взятый из xml
		public var kolAll:Array;					//количество каждого вида объекта
		
		public var uidObjs:Array;					//все объекты, имеющие uid
		public var scripts:Array;					//массив скриптов, имеющих время выполнения
		public var itemScripts:Array;				//массив скриптов, привязанных к взятию объектов
		
		public var kol_phoenix:int=0;
		public var aliAlarm:Boolean=false;			//тревога среди аликорнов
		
		public var challengeIds:Array;				//имеющиеся комнаты испытаний
		private var impChallenge:int=-1;			//важная комната испытаний

		private var tileX:int = Tile.tileX;
		private var tileY:int = Tile.tileY;

		//lvl - уровень перса-1
		public function Level(ngg:UnitPlayer, nact:LevelSettings, lvl:int) {
			gg = ngg;
			act = nact;
			rnd=act.rnd;
			uidObjs			= [];
			scripts			= [];
			kolAll			= [];
			listLocs		= [];
			challengeIds	= [];
			challenges		= [];
			prepareRooms();

			if (rnd) {
				landDifLevel=lvl;	//сложность определяется заданным параметром
				if (landDifLevel<act.dif) landDifLevel=act.dif;	//если сложность меньше минимальной, установить минимальную
				maxLocX=act.mLocX;	//размеры берутся из настроек act
				maxLocY=act.mLocY;
				buildRandomLevel();
			}
			else {
				landDifLevel=act.dif;	//сложность берётся из настроек act
				if (act.autoLevel) landDifLevel=lvl;
				maxLocX=maxLocY=1;	//размеры определяются в соотвествии с картой
				buildSpecifLevel();
			}

			lootLimit = lvl + 3;
			gameStage=act.gameStage;	//этап сюжета берётся из настроек
			//прикреплённые скрипты
			itemScripts = [];

			for each(var xl:XML in act.xmlland.scr) {
				if (xl.@eve == 'take' && xl.@item.length()) {
					var scr:Script = new Script(xl, this);
					itemScripts[xl.@item] = scr;
				}
			}
			
			minimap = new Minimap(this);
		}
		
//==============================================================================================================================		
//				*** Создание ***
//==============================================================================================================================		
		
		//перегнать из xml в массив
		public function prepareRooms():void {
			allRoom = [];
			for each(var xml:XML in act.allroom.room) {
				allRoom.push(new Room_Definition(xml));
			}
		}
		
		public function buildRandomLevel():void {
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
					opt.backWallShape = 0;
					opt.transparentBack = false;

					configureWater(act.conf, j);

					locs[i][j] = [];

					// Determine initial rooms
					if ((act.conf == 0 && j == 0 && !act.visited) ||
						((act.conf == 1 || act.conf == 2 || act.conf == 5) && j == 0 && i == 0 && !act.visited)) {
						opt.mirror = false;
						if (act.conf == 5) {
							opt.ramka = 3;
							opt.backWallShape = 3;
							opt.transparentBack = true;
						}
						loc1 = LocationFactory.newTipLoc(this, 'beg' + ((act.conf == 0) ? i : '0'), i, j, opt);
					}
					else {
						switch(act.conf) {
							case 3: // Manehattan
								opt.transparentBack = true;
								if (i == 2) {
									if (j == 0) {
										opt.ramka = 7;
										loc1 = LocationFactory.newTipLoc(this, 'passroof', i, j, opt);
									}
									else {
										opt.ramka = 5;
										loc1 = LocationFactory.newRandomLoc(this, act.landStage, i, j, opt, 'pass');
									}
									loc1.bezdna = true;
								}
								else if (j == 0) {
									opt.ramka = 6;
									loc1 = LocationFactory.newRandomLoc(this, act.landStage, i, j, opt, 'roof');
								}
								else {
									loc1 = LocationFactory.newRandomLoc(this, act.landStage, i, j, opt);
									if (i > 2 && loc1.backwall == 'tWindows') {
										loc1.backwall = 'tWindows2';
									}
								}
								break;
							case 4: // Military Base
								if (i == 0) {
									if (j == 0) {
										if (GameContainer.reference.game.triggers['mbase_visited'] > 0) {
											loc1 = LocationFactory.newRandomLoc(this, 0, i, j, opt);
										}
										else {
											opt.mirror = false;
											opt.ramka = 8;
											loc1 = LocationFactory.newTipLoc(this, 'beg0', i, j, opt);
										}
									}
									else {
										loc1 = LocationFactory.newRandomLoc(this, 0, i, j, opt, 'vert');
									}
								}
								else if (i == maxLocX - 1) {
									if (j == maxLocY - 1) {
										opt.mirror = false;
										loc1 = LocationFactory.newTipLoc(this, 'end', i, j, opt);
									}
									else {
										loc1 = LocationFactory.newRandomLoc(this, 0, i, j, opt, 'vert');
									}
								}
								else {
									loc1 = LocationFactory.newRandomLoc(this, 0, i, j, opt);
								}
								break;
							case 5: // Canterlot
								if (j == 0) {
									opt.ramka = 3;
									opt.backWallShape = 3;
									opt.transparentBack = true;
									loc1 = LocationFactory.newRandomLoc(this, act.landStage, i, j, opt, 'surf');
									loc1.visMult = 2;
								}
								else {
									loc1 = LocationFactory.newRandomLoc(this, act.landStage, i, j, opt);
								}
								loc1.gas = 1;
								break;
							case 7: // Bunker
								if (i == 0) {
									if (j == 0) {
										opt.mirror = false;
										loc1 = LocationFactory.newTipLoc(this, 'beg1', i, j, opt);
									}
									else {
										loc1 = LocationFactory.newRandomLoc(this, 1, i, j, opt, 'vert');
									}
								}
								else if (i == maxLocX - 1) {
									if (j == maxLocY - 1) {
										opt.mirror = false;
										loc1 = LocationFactory.newTipLoc(this, 'end1', i, j, opt);
									}
									else {
										loc1 = LocationFactory.newRandomLoc(this, 1, i, j, opt, 'vert');
									}
								}
								else {
									loc1 = LocationFactory.newRandomLoc(this, 1, i, j, opt);
								}
								break;
							case 10: // Pi Stable
								opt.home = true;
								if (i == act.begLocX && j == act.begLocY) {
									opt.mirror = false;
									loc1 = LocationFactory.newTipLoc(this, 'beg0', i, j, opt);
								}
								else if (i == 1 && j == 1) {
									opt.mirror = false;
									loc1 = LocationFactory.newTipLoc(this, 'roof', i, j, opt);
								}
								else {
									loc1 = LocationFactory.newRandomLoc(this, 10, i, j, opt);
								}
								break;
							case 11: // Attacked Pi Stable
								opt.atk = true;
								if (i == 5 && j == 0) {
									opt.mirror = false;
									loc1 = LocationFactory.newTipLoc(this, 'pass', i, j, opt);
								}
								else {
									loc1 = LocationFactory.newRandomLoc(this, act.landStage, i, j, opt);
								}
								break;
							default: // Default case
								loc1 = LocationFactory.newRandomLoc(this, act.landStage, i, j, opt);
								break;
						}
					}

					locs[i][j][0] = loc1;

					// Add second layer if applicable
					if (loc1.room.back != null) {	
						loc2 = null;
						for each(var room:Room_Definition in allRoom) {
							if (room.id == loc1.room.back) {
								loc2 = LocationFactory.newLoc(this, room, i, j, 1, opt);
								loc2.tipEnemy = loc1.tipEnemy;
								locs[i][j][1] = loc2;
								loc2.noMap = true;
								break;
							}
						}
					}
				}
			}

			// Open passages between neighbouring rooms, picked at random from the slots both rooms allow
			for (i = minLocX; i < maxLocX; i++) {
				for (j = minLocY; j < maxLocY; j++) {
					loc1 = locs[i][j][0];

					// Right passage: 3 picks with replacement, so 1-3 distinct doors get opened
					if (i < maxLocX - 1) {
						LocationFactory.connect(loc1, E_Direction.RIGHT, locs[i + 1][j][0], 3);
					}

					// Down passage
					if (j < maxLocY - 1) {
						LocationFactory.connect(loc1, E_Direction.DOWN, locs[i][j + 1][0], 1);
					}

					loc1.mainFrame();
				}
			}

			// Special camp placements
			if (act.conf == 2) {
				newRandomChallenge(locs[3][0][0], act.landStage, true);
			}
			if (act.conf == 3 && act.landStage >= 1) {
				newRandomChallenge(locs[1][4][0], act.landStage, true);
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
									newRandomChallenge(loc1, act.landStage, true);
								}
								else if (Math.random() < 0.3) {
									newRandomChallenge(loc1, act.landStage, false);
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
								newRandomChallenge(loc1, act.landStage, false);
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
										newRandomChallenge(loc1, act.landStage, true);
									}
									else if (j != 4 && Math.random() < 0.25) {
										newRandomChallenge(loc1, act.landStage, false);
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
							opt.transparentBack = true;
							if (j == 0) {
								if (i == 0 || i == 2) {
									loc1.createExit((act.landStage >= 1) ? '1' : undefined);
								}
								if (i == 1) {
									newRandomChallenge(loc1, act.landStage, true);
								}
							}
							else if (i == act.begLocX && j == act.begLocY || i == ((7 - j) % 3)) {
								loc1.createCheck(i == act.begLocX && j == act.begLocY);
							}
							else if (Math.random() < 0.25) {
								newRandomChallenge(loc1, act.landStage, false);
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

			buildChallenges();
		}
		
		public function buildSpecifLevel():void {
			var i:int;
			var j:int;
			var e:int;
			var loc1:Location;
			var loc2:Location;

			//определяем фактические размеры
			for each(var room:Room_Definition in allRoom) {
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
				loc1=LocationFactory.newLoc(this, room,room.rx,room.ry,room.rz);
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
			
			buildChallenges();
		}
		
		//добавить комнаты испытаний, id которых использовался в местности (были задействованы двери с challenge={id})
		//обработать все добавленные
		public function buildChallenges():void {
			for each (var s:String in challengeIds)	buildChallenge(s);
			for each (var loc:Location in listLocs) {
				loc.setObjects();
				loc.preStep();
				if (loc.challenge) loc.challenge.prepare();
			}
		}
		
		//создать слой испытаний, вернуть false если слой уже есть
		public function buildChallenge(challengeId:String):Boolean {
			if (challenges[challengeId]!=null) return false;
			
			//создать одиночную комнату
			var arrr:XML=GameContainer.reference.game.challengeSettings['challenge'].allroom;
			
			for each(var xml:XML in arrr.room) {
				if (xml.@name == challengeId)
				{
					var room:Room_Definition = new Room_Definition(xml);
					var loc:Location = LocationFactory.newLoc(this, room,0,0,0,{challenge:challengeId});
					loc.challengeId = challengeId;
					loc.noMap = true;
					
					// Only real trials have a setup; the level-exit rooms built here don't
					var xmll:XML = XMLDataGrabber.getNodeByNameWithAttributeThatMatches("core", "GameData", "Levels", "challenge", "id", challengeId);
					
					if (xmll) {
						loc.challenge = new Room_Challenge(xmll, loc);
					}
					
					//добавить дверь для выхода
					if (loc.spawnPoints.length) {
						loc.createObj('doorout','box',loc.spawnPoints[0].X,loc.spawnPoints[0].Y,<obj challenge='' uid='begin'/>);
					}
					
					challenges[challengeId]=[[[loc]]];
					listLocs.push(loc);
					break;
				}
			}

			if (challenges[challengeId] == null) {
				trace("Level.as/buildChallenge() - Error: No <room> named \"" + challengeId + "\" among the trial rooms; doors leading to it will do nothing");
			}

			return true;
		}
		
		//Создать дверь и случайную комнату испытаний за ней, вернуть false если подходящих не нашлось
		public function newRandomChallenge(nloc:Location, maxlevel:int=100, imp:Boolean=false):Boolean {
			var rndRoom:Array = [];
			var impChallenge:String;
			
			for each(var xml:XML in act.xmlland.challenge) {
				if (challenges[xml.@id]==null && GameContainer.reference.game.triggers['challenge_'+xml.@id]==null && (xml.@level.length==0 || xml.@level<=maxlevel)) {
					rndRoom.push(xml.@id);
					if (xml.@imp.length()) impChallenge=xml.@id;
				}
			}
			
			if (rndRoom.length==0) return false;
			
			var challengeId:String, doorId:String='doorchallenge';
			
			if (imp && impChallenge) challengeId=impChallenge;
			else if (rndRoom.length==1) challengeId=rndRoom[0];
			else challengeId=rndRoom[Math.floor(Math.random()*rndRoom.length)];
			
			if (act.xmlland.challenge.(@id==challengeId).@tip=='2') doorId='doorboss';
			
			if (!nloc.createDoorChallenge(doorId,challengeId)) return false;
			
			buildChallenge(challengeId);
			
			return true;
		}
		
//==============================================================================================================================		
//				*** [Usage] ***
//==============================================================================================================================		
		
		// [Enter the area]
		public function enterLevel(first:Boolean=false, coord:String=null):void {
			act.visited=true;
			loc = null;
			if (coord != null) {
				var narr:Array=coord.split(':');

				if (narr.length>=1) locX=narr[0];
				else locX=0;

				if (narr.length>=2) locY=narr[1];
				else locY=0;

				locZ = 0;
				activeChallengeId = '';
				ativateLoc();
				setGGToSpawnPoint();
			}
			else if (currentCP && !first) {
				GameContainer.reference.pers.currentCP=currentCP;
				gotoCheckPoint();
				currentCP.activate();
			}
			else {
				locX = act.begLocX;
				locY = act.begLocY;
				locZ = 0;
				activeChallengeId = '';
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
				nx = loc.spawnPoints[n].X;
				ny = loc.spawnPoints[n].Y;
			}
			
			gg.setLocPos((nx+1) * tileX, (ny+1) * tileY - 1);
			gg.velocity.X = 3;
			loc.lighting(gg.coordinates.X, gg.coordinates.Y - 75);
		}
		
		// [Make the location with current coordinates active]
		public function ativateLoc():Boolean {
			var nloc:Location;
			
			if (activeChallengeId!='' && challenges[activeChallengeId]==null)  return false;

			if (activeChallengeId == '') {
				nloc = locs[locX][locY][locZ];
			}
			else {
				nloc = challenges[activeChallengeId][locX][locY][locZ];
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
				GameContainer.reference.cam.setZoom(2);
			}
			
			loc.lightAll();
			
			return true;
		}
		
		// [Go to location x,y]
		public function gotoXY(nx:int, ny:int) : void {
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
		
		// The room at these coordinates in the active layer, main or test, or null if there is none
		// Differs from vanilla, which checked the test layer for the room but then took it from the main map
		private function findLoc(roomX:int, roomY:int, roomZ:int):Location {
			var rooms:Array = (activeChallengeId == '') ? locs : challenges[activeChallengeId];

			if (rooms[roomX] == null || rooms[roomX][roomY] == null) {
				return null;
			}

			return rooms[roomX][roomY][roomZ];
		}

		// Moves the player into newLoc, which sits at these coordinates, placed at outP; null if they wouldn't fit there
		private function enterLoc(newLoc:Location, newX:int, newY:int, newZ:int, outP:Object):Object {
			if (newLoc.collisionUnit(outP.x, outP.y, gg.boundingBox.width - 4, gg.boundingBox.height)) {
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

		// [Transition between locations] across the edge of the room in the given direction
		public function gotoLoc(direction:Vec2):Object {
			var X:Number=gg.coordinates.X, Y:Number=gg.coordinates.Y, objectWidth:Number=gg.boundingBox.width, objectHeight:Number=gg.boundingBox.height;
			var newX:int = locX + direction.X;
			var newY:int = locY + direction.Y;
			var newLoc:Location;	// The room being entered, assigned once the new coordinates are known and checked
			var outP:Object = {};

			newLoc = findLoc(newX, newY, locZ);
			if (!newLoc) {
				if (direction == E_Direction.DOWN) { return {die:true}; }

				return null;
			}

			switch (direction) {
				case E_Direction.LEFT: {
					outP.x = newLoc.maxX - objectWidth / 2 - 9;
					outP.y = Y - 1;
					break;
				}
				case E_Direction.RIGHT: {
					outP.x = objectWidth / 2 + 9;
					outP.y = Y - 1;
					break;
				}
				case E_Direction.DOWN: {
					outP.x = X;
					outP.y = objectHeight + 10;
					break;
				}
				case E_Direction.UP: {
					outP.x = X;
					outP.y = newLoc.maxY - 10;
					break;
				}
				default: {
					trace("Level.as/gotoLoc() - Warning: a room can't be left in a neutral direction");
					return null;
				}
			}

			return enterLoc(newLoc, newX, newY, locZ, outP);
		}

		// Goes through a door between a room and the room behind it, arriving at (arriveX, arriveY)
		public function gotoOtherLayer(arriveX:Number, arriveY:Number):Object {
			var newZ:int = 1 - locZ;
			var newLoc:Location = findLoc(locX, locY, newZ);

			if (!newLoc) {
				return null;
			}

			return enterLoc(newLoc, locX, locY, newZ, {x:arriveX, y:arriveY});
		}
		
		// [Go to the named challenge layer, or return to the main layer if no ID is specified]
		public function gotoChallenge(challengeId:String='', nretX:Number=-1, nretY:Number=-1) : void {
			if (challengeId == "") {
				activeChallengeId = '';
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
				
				activeChallengeId = challengeId;
				locX = 0;
				locY = 0;
				locZ = 0;
				
				if (ativateLoc()) {
					setGGToSpawnPoint();
				}
				else {
					activeChallengeId = '';
					locX = retLocX;
					locY = retLocY;
					locZ = retLocZ;
				}
			}
		}
		
		public function gotoCheckPoint():void {
			var cp:CheckPoint=GameContainer.reference.pers.currentCP;
			
			if (cp==null) {
				gg.setNull();
				return;
			}
			
			if (cp.loc.land!=this && currentCP)	{
				cp=currentCP;
				GameContainer.reference.pers.currentCP=currentCP;
				currentCP.activate();
			}
			
			if (cp.loc.land == this) {
				locX = cp.loc.landX;
				locY = cp.loc.landY;
				locZ = cp.loc.landZ;
				activeChallengeId = cp.loc.challengeId;
				if (!ativateLoc()) loc.reactivate();
				gg.setLocPos(cp.coordinates.X, cp.coordinates.Y);
			}
			else {
				locX = act.begLocX;
				locY = act.begLocY;
				locZ = 0;
				activeChallengeId = '';
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
				GameContainer.reference.game.refillAllVendors();
				isRefill = true;
			}
			else {
				trace('опыта получено: ', summXp, allXp);
			}
		}
		
		public function artBabah():void {
			Sound.ps('artfire');
			World.w.quake(10,3);
		}
		
		public function artStep():void {
			art_t--;
			if (art_t<=0) {
				art_t=int(Math.random()*1000+20);
				if (act.artFire!=null && GameContainer.reference.game.triggers[act.artFire]!=1) {
					artBabah();
				}
			}
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
			if (!GameContainer.reference.catPause) {
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

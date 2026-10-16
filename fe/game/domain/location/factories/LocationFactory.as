package fe.game.domain.location.factories {

	import fe.engine.utils.Vec2;
	import fe.game.GameContainer;
	import fe.game.domain.location.Land;
	import fe.game.domain.location.Location;
	import fe.game.domain.location.Room;
	import fe.game.domain.location.tile.Tile;
	import fe.game.enums.E_Direction;

	// Builds a land's locations from its room templates. The land puts what comes back on its map
	public class LocationFactory {

		// Two tiles tall up from the outlet's bottom row, three when wide, through the wall and the column inside it
		private static function openSideConnection(loc:Location, isRight:Boolean, slot:int, isWide:Boolean):void {
			var row:int				= 3 + slot * 4;		// Bottom row of the opening; side outlets sit 4 rows apart
			var wallX:int			= isRight ? loc.spaceX - 1 : 0;
			var innerX:int			= isRight ? loc.spaceX - 2 : 1;
			var inward:int			= isRight ? -5 : 5;		// How far in from the wall boxes stay out of the opening
			var brokeWall:Boolean	= false;

			brokeWall = loc.getTile(wallX, row).hole() || brokeWall;
			brokeWall = loc.getTile(wallX, row - 1).hole() || brokeWall;
			loc.getTile(innerX, row).hole();
			loc.getTile(innerX, row - 1).hole();
			loc.setNoObj(wallX, row, inward, 0);
			loc.setNoObj(wallX, row - 1, inward, 0);

			if (isWide) {
				brokeWall = loc.getTile(wallX, row - 2).hole() || brokeWall;
				loc.getTile(innerX, row - 2).hole();
			}

			if (brokeWall) {
				loc.addSignPost(isRight ? loc.spaceX : 0, row, isRight ? 0 : 180);
			}

			loc.addEnSpawn((isRight ? loc.spaceX - 1 : 1) * Tile.tileX, (row + 1) * Tile.tileY - 1);
		}

		// The two columns right of the outlet's left column, or four from it when wide, through the ceiling or floor and the row inside it
		private static function openEdgeConnection(loc:Location, isBottom:Boolean, slot:int, isWide:Boolean):void {
			var column:int			= 4 + slot * 9;		// Left column of a wide opening; floor and ceiling outlets sit 9 columns apart
			var wallY:int			= isBottom ? loc.spaceY - 1 : 0;
			var innerY:int			= isBottom ? loc.spaceY - 2 : 1;
			var inward:int			= isBottom ? -2 : 2;	// How far in from the wall boxes stay out of the opening
			var brokeWall:Boolean	= false;

			brokeWall = loc.getTile(column + 1, wallY).hole() || brokeWall;
			brokeWall = loc.getTile(column + 2, wallY).hole() || brokeWall;
			loc.getTile(column + 1, innerY).hole();
			loc.getTile(column + 2, innerY).hole();
			loc.setNoObj(column + 1, wallY, 0, inward);
			loc.setNoObj(column + 2, wallY, 0, inward);

			if (isWide) {
				brokeWall = loc.getTile(column, wallY).hole() || brokeWall;
				brokeWall = loc.getTile(column + 3, wallY).hole() || brokeWall;
				loc.getTile(column, innerY).hole();
				loc.getTile(column + 3, innerY).hole();
				loc.setNoObj(column, wallY, 0, inward);
				loc.setNoObj(column + 3, wallY, 0, inward);
			}

			if (brokeWall) {
				loc.addSignPost(column + 2, isBottom ? loc.spaceY : 0, isBottom ? 90 : -90);
			}
		}

		//создать новую локацию нужного типа, в заданных координатах
		public static function newTipLoc(land:Land, ntip:String, nx:int, ny:int, opt:Object=null):Location {
			var rndRoom:Array = [];
			var room:Room;

			for each(room in land.allRoom) {
				if (room.tip==ntip) rndRoom.push(room);
			}

			if (rndRoom.length>0) {
				room=rndRoom[Math.floor(Math.random()*rndRoom.length)];
			}
			else {
				room=land.allRoom[Math.floor(Math.random()*land.allRoom.length)];
				trace('нет локации '+ntip);
			}

			room.kol--;

			return newLoc(land, room, nx, ny, 0, opt);
		}

		//создать новую случайную локацию, в заданных координатах
		public static function newRandomLoc(land:Land, maxlevel:int, nx:int, ny:int, opt:Object=null, ntip:String=null):Location {
			var rndRoom:Array = [];
			var r1:Room, r2:Room;
			var room:Room;
			var rndKol:int;
			var i:int;

			if (nx>land.minLocX) r1=land.locs[nx-1][ny][0].room;
			if (ny>land.minLocY) r2=land.locs[nx][ny-1][0].room;
			//массив всех комнат, удовлетворяющих условиям
			for each(room in land.allRoom) {
				if (room.lvl<=maxlevel && room.kol>0 && room!=r1 && room!=r2 && (ntip==null && room.rnd || room.tip==ntip)) {
					rndKol=room.kol*room.kol;
					if (rndKol==4 && room.lvl==0 && maxlevel>1) {
						rndKol=2;
					}
					for (i=0; i<rndKol; i++) {
						rndRoom.push(room);
					}
				}
			}
			if (rndRoom.length>0) {
				room=rndRoom[Math.floor(Math.random()*rndRoom.length)];
			}
			else {
				//массив всех комнат, подходящих для рандома
				for each(room in land.allRoom) {
					if (room.rnd) {
						rndRoom.push(room);
					}
				}
				room=rndRoom[Math.floor(Math.random()*rndRoom.length)];
			}
			room.kol--;
			if (land.act.conf==4) room.kol=0;	//на военной базе комнаты используются один раз
			return newLoc(land, room, nx, ny, 0, opt);
		}

		// [Create a new location according to a given Room template, in given coordinates]
		public static function newLoc(land:Land, room:Room, nx:int, ny:int, nz:int = 0, opt:Object = null):Location {
			var loc:Location = new Location(land, room.xml, land.rnd, opt);
			var deep:Number = 0;

			loc.biom = land.act.biom;
			loc.room = room;
			loc.landX = nx;
			loc.landY = ny;
			loc.landZ = nz;
			loc.id = "loc" + nx + "_" + ny;

			if (nz > 0) {
				loc.id += "_" + nz;
			}

			loc.unXp = land.act.xp;

			// [Set difficulty gradient]
			if (land.rnd) {
				if (land.act.conf == 0) deep = ny / 2;
				if (land.act.conf == 1) deep = ny;
				if (land.act.conf == 2) deep = ny * 2.5;
			}

			setLocDif(land, loc, deep);
			loc.addPlayer(land.gg);

			return loc;
		}

		// The openings here and there both allow across here's edge, each at the smaller of their sizes
		public static function sharedConnections(here:Location, edge:Vec2, there:Location):Vector.<RoomConnection> {
			var shared:Vector.<RoomConnection> = new Vector.<RoomConnection>();
			var isSide:Boolean = edge == E_Direction.LEFT || edge == E_Direction.RIGHT;
			var outlets:int = isSide ? RoomOutlets.HORIZONTAL_OUTLETS : RoomOutlets.VERTICAL_OUTLETS;
			var opposite:Vec2 = E_Direction.opposite(edge);
			var size:int;
			var slot:int;

			for (slot = 0; slot < outlets; slot++) {
				size = here.room.outlets.openingSize(edge, slot, here.mirror);
				size = Math.min(size, there.room.outlets.openingSize(opposite, slot, there.mirror));
				if (size >= RoomOutlets.MIN_OPENING_SIZE) {
					shared.push(new RoomConnection(slot, size));
				}
			}

			return shared;
		}

		// Cuts connection through loc's wall on edge; sizes below MIN_OPENING_SIZE leave the wall shut.
		// It gets a signpost if it broke through solid wall, and an opening in a side wall becomes an enemy spawn point
		public static function openConnection(loc:Location, edge:Vec2, connection:RoomConnection):void {
			var isWide:Boolean = connection.openingSize > RoomOutlets.MIN_OPENING_SIZE;

			if (connection.openingSize < RoomOutlets.MIN_OPENING_SIZE) {
				return;
			}

			if (edge == E_Direction.LEFT || edge == E_Direction.RIGHT) {
				openSideConnection(loc, edge == E_Direction.RIGHT, connection.slot, isWide);
			}
			else {
				openEdgeConnection(loc, edge == E_Direction.DOWN, connection.slot, isWide);
			}
		}

		//установка сложности локации, в зависимости от уровня персонажа и градиена сложности
		private static function setLocDif(land:Land, loc:Location, deep:Number):void {
			var ml:Number = land.landDifLevel + deep;

			loc.locDifLevel = ml;
			loc.locksLevel = ml * 0.7;		//уровень замков
			loc.mechLevel = ml / 4;			//уровень мин и механизмов
			loc.weaponLevel = 1 + ml / 4;	//уровень попадающегося оружия
			loc.enemyLevel = ml;			//уровень врагов

			//влияние настроек сложности
			if (GameContainer.reference.game.globalDif<2) loc.earMult*=0.5;

			if (GameContainer.reference.game.globalDif>2) loc.enemyLevel+=(GameContainer.reference.game.globalDif-2)*2;	//уровень врагов в зависимости от сложности

			//тип врагов
			if (land.act.biom==0 && Math.random()<0.25) loc.tipEnemy=1;

			if (loc.tipEnemy<0) loc.tipEnemy=Math.floor(Math.random()*3);

			if (land.act.biom==1) loc.tipEnemy=0;

			if (land.act.biom==2 && loc.tipEnemy==1 && Math.random()<ml/20) loc.tipEnemy=3;	//работорговцы

			if (land.act.biom==3) {
				loc.tipEnemy=Math.floor(Math.random()*3)+3;			//4-наёмники, 5-аликорны
			}

			if (ml>12 && (land.act.biom==0 || land.act.biom==2 || land.act.biom==3) && Math.random()<0.1) loc.tipEnemy=6;	//зебры

			if (land.act.biom==4) loc.tipEnemy=7;	//стальные+роботы

			if (land.act.biom==5) {
				if (Math.random()<0.3) loc.tipEnemy=5;
				else loc.tipEnemy=8;	//розовые
			}

			if (land.act.biom==6) {
				if (Math.random()>0.3) loc.tipEnemy=9;	//анклав
				else loc.tipEnemy=10;//гончие
			}

			if (land.act.biom==11) loc.tipEnemy=11; //анклав и гончие

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

			if (land.act.biom==11) {
				loc.setKolEn(2,5,8,0);
			}
		}
	}
}

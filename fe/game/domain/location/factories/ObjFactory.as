package fe.game.domain.location.factories {

	import fe.engine.text.TextParser;
	import fe.engine.text.XMLDataGrabber;
	import fe.engine.utils.Vec2;
	import fe.game.GameContainer;
	import fe.game.domain.entities.Obj;
	import fe.game.domain.location.Area;
	import fe.game.domain.location.Location;
	import fe.game.domain.location.tile.Tile;
	import fe.game.domain.objects.Bonus;
	import fe.game.domain.objects.Box;
	import fe.game.domain.objects.CheckPoint;
	import fe.game.domain.objects.Loot;
	import fe.game.domain.objects.Trap;
	import fe.game.domain.serv.Item;

	// Builds a location's objects without adding them to it. The location registers what comes back
	public class ObjFactory {

		//создать активный объект, nx,ny-координаты в блоках
		public static function createObj(loc:Location, id:String, tip:String, nx:int, ny:int, xml:XML=null):Obj {
			var obj:Obj;
			var size:int = XMLDataGrabber.getNodeWithAttributeThatMatches("core", "AllData", "objs", "id", id).@size;
			var loadObj:Object=null;

			if (size<=0) size=1;
			if (xml && xml.@code.length() && GameContainer.reference.game.objs.hasOwnProperty(xml.@code)) loadObj=GameContainer.reference.game.objs[xml.@code];
			if (tip=='box' || tip=='door') {
				obj=new Box(loc, id, (nx+0.5*size)*Tile.tileX, (ny+1)*Tile.tileY-1, xml, loadObj);
			}
			else if (tip=='trap') {
				obj=new Trap(loc, id,(nx+0.5*size)*Tile.tileX, (ny+1)*Tile.tileY-1);
			}
			else if (tip=='checkpoint') {
				obj=new CheckPoint(loc, id,(nx+0.5*size)*Tile.tileX, (ny+1)*Tile.tileY-1, xml, loadObj);
				//установить на контрольных точках телепорты на базу
				if (GameContainer.reference.game.globalDif<=1 || loc.land.rnd && GameContainer.reference.game.globalDif==2 && Math.random()<0.33) (obj as CheckPoint).teleOn=true;
			}
			else if (tip=='area') {
				obj=new Area(loc, xml, loadObj, loc.mirror);
			}
			else if (tip=='bonus') {
				obj=new Bonus(loc, id,(nx+0.5)*Tile.tileX, (ny+0.5)*Tile.tileY, xml, loadObj);
			}
			if (xml && xml.@code.length()) obj.code=xml.@code;
			if (xml && xml.@uid.length()) obj.uid=xml.@uid;
			if (xml && xml.@nazv.length()) obj.nazv=xml.@nazv;
			return obj;
		}

		// [Create an item standing on a box]. Loot adds itself to the location, so this returns it already registered, or null
		public static function createSur(loc:Location, box:Box, itemID:String = null):Loot {
			var item:Item;
			var l:Loot;

			// If it's not specified what item to put on a box, generate one
			if (itemID == null) {
				if (Math.random() > 0.25) {
					return null;
				}

				if (loc.biom == 0) {
					itemID = 'fan';
				}
				else if (loc.biom == 2) {
					itemID = 'lamp';
				}
				else if (loc.biom == 3) {
					itemID = 'kofe';
				}
				else {
					return null;
				}
			}

			// Create the item
			item = new Item(itemID, 1);
			// Use the item to create a visible loot item
			l = new Loot(loc, item, box.coordinates.X, box.coordinates.Y - box.boundingBox.height - 3, false, false, false);

			// If we're at the base, don't let the player interact with them
			if (loc.base) {
				l.inter.active = false;
				l.levitPoss = false;
			}

			return l;
		}

		// A healing pickup at nx, ny in pixels, or null when the player has no healing bonus
		public static function createHealBonus(loc:Location, nx:Number, ny:Number):Bonus {
			var obj:Bonus;

			if (GameContainer.reference.pers.bonusHeal <= 0) {
				return null;
			}

			obj = new Bonus(loc, 'heal', nx, ny);
			obj.liv = 300;
			obj.val = GameContainer.reference.pers.bonusHeal * GameContainer.reference.pers.bonusHealMult;

			return obj;
		}

		// [Creating a checkpoint at a random spawn point], or null when the location has none
		public static function createCheck(loc:Location, act:Boolean=false):CheckPoint {
			var sp:Vec2;
			var id:String = 'checkpoint';
			var checkPoint:CheckPoint;

			if (loc.spawnPoints.length == 0) return null;

			sp = loc.spawnPoints[int(Math.random()*loc.spawnPoints.length)];
			if (!act && loc.land.rnd && Math.random()<0.5) {
				id += int(Math.random()*5+1);
			}
			checkPoint = createObj(loc, id,'checkpoint',sp.X,sp.Y) as CheckPoint;
			if (loc.land.act.landStage==0 && act) checkPoint.teleOn=true;
			return checkPoint;
		}

		// [Creating an exit at a random spawn point], or null when the location has none
		public static function createExit(loc:Location, s:String = ''):Box {
			var sp:Vec2;

			if (loc.spawnPoints.length == 0) return null;

			sp = loc.spawnPoints[int(Math.random() * loc.spawnPoints.length)];
			return createObj(loc, 'exit', 'box', sp.X, sp.Y, <obj name = 'exit' prob = {loc.land.act.exitProb + s} time = '20' inter = '8' sign = '1'/>) as Box;
		}

		//создание двери испытаний в случайной точке появления, or null when the location has no spawn points
		public static function createDoorProb(loc:Location, nid:String, nprob:String):Box {
			var sp:Vec2;

			if (loc.spawnPoints.length == 0) return null;

			sp = loc.spawnPoints[int(Math.random()*loc.spawnPoints.length)];
			return createObj(loc, nid,'box', sp.X, sp.Y, <obj prob = {nprob} nazv = {TextParser.txt('m', nprob)} time = '20' inter = '8'/>) as Box;
		}

		// Up to kol XP pickups on empty tiles, spread from the top-left quarter of the room outwards
		public static function createXpBonuses(loc:Location, kol:int=5):Vector.<Bonus> {
			var bonuses:Vector.<Bonus> = new Vector.<Bonus>();
			var nx:int, ny:int, x1:int, x2:int, y1:int, y2:int;
			var mesto:int=4;
			var n:int=5;
			var i:int;

			for (i = 1; i<=100; i++) {
				x1 = 2;
				y1 = 2;
				x2 = loc.spaceX - 2;
				y2 = loc.spaceY - 2;

				switch (mesto) {
					case 4:
						x2 = loc.halfSpaceX;
						y2 = loc.halfSpaceY;
					break;
					case 3:
						x1 = loc.halfSpaceX;
						y2 = loc.halfSpaceY;
					break;
					case 2:
						x2 = loc.halfSpaceX;
						y1 = loc.halfSpaceY;
					break;
					case 1:
						x1 = loc.halfSpaceX;
						y1 = loc.halfSpaceY;
					break;
				}

				nx = int(x1 + Math.random() * (x2 - x1));
				ny = int(y1 + Math.random() * (y2 - y1));
				if (loc.getTile(nx, ny).collision == 0 && (loc.getTile(nx - 1, ny).collision == 0 || loc.getTile(nx + 1, ny).collision == 0)) { // Check that the tile is empty.
					bonuses.push(createObj(loc, 'xp','bonus',nx,ny) as Bonus);
					if (mesto>0) mesto--;
					if (bonuses.length>=kol) return bonuses;
				}
				else {
					n--;
					if (n <= 0) {
						n = 5;
						if (mesto > 0) {
							mesto--;
						}
					}
				}
			}

			return bonuses;
		}

		//облака газа
		public static function createClouds(loc:Location, lvl:int, ncloud:String=null):Vector.<Box> {
			var clouds:Vector.<Box> = new Vector.<Box>();
			var kol:int = 1;
			var i:int;
			var nx:int;
			var ny:int;
			var dnx:int;
			var dny:int;

			if (ncloud == null) {
				if (loc.biom == 1) {
					ncloud='tcloud1';
					if (lvl>=2) return clouds;
				}

				if (loc.biom == 5) {
					ncloud = 'pcloud1';
				}
			}
			if (ncloud != null) {
				if (loc.biom == 1) kol = Math.random() * 5;

				if (loc.biom == 5) {
					if (lvl == 0) kol = Math.random() * 2;
					else kol = Math.random()*3;
				}

				for (i = 0; i<kol; i++) {
					nx = int(Math.random() * (loc.spaceX - 4) + 2);
					ny = int(Math.random() * (loc.spaceY - 4) + 2);

					if (loc.cp) {
						dnx = loc.cp.coordinates.X - (nx * Tile.tileX + 20);
						dny = loc.cp.coordinates.Y - (ny * Tile.tileY + 40);
						if (dnx * dnx + dny * dny < 80 * 80) continue;
					}

					if (loc.biom==1 && lvl==1 && ny>15) ny=15;

					if (loc.biom==5 && lvl==0) ny = int(Math.random()*15+9);

					clouds.push(createObj(loc, ncloud,'box',nx,ny) as Box);
				}
			}

			return clouds;
		}

		//создать скрытый юнит или дополнительный объект: a unit or a box, or null when this location hides nothing
		public static function createHidden(loc:Location, nx:int, ny:int):Obj {
			if (loc.biom==10 || loc.biom==11) {
				return null;
			}

			if (loc.tipEnemy==0) return UnitFactory.createUnit(loc, 'zombie',nx,ny, false, <unit dig='2'/>);
			else if (loc.tipEnemy==2) return createObj(loc, 'robocell','box',nx,ny);
			else if (loc.tipEnemy==1 || loc.tipEnemy==3) return createObj(loc, 'alarm','box',nx,ny);
			else if (loc.tipEnemy==6) return UnitFactory.createUnit(loc, 'lov',nx,ny);
			return null;
		}
	}
}

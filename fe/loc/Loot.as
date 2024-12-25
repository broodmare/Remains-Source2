package fe.loc {

	import flash.display.MovieClip;
	
	import fe.*;
	import fe.util.Vector2;
	import fe.graph.Emitter;
	import fe.serv.Item;
	import fe.serv.Interact;
	import fe.entities.Obj;
	
	// This is the object you see in-game when an item is dropped
	public class Loot extends Obj {
		
		public var item:Item;

		private const osnRad = 50;
		private const actRad = 250;

		public var vClass:Class;
		public var osnova:Box = null;
		public var vsos:Boolean = false;
		public var isPlav:Boolean = false;
		public var takeR:int = osnRad;			// [take radius] | радиус взятия
		
		private var isTake:Boolean = false;		// [taken] | взят
		var actTake:Boolean = false;			// ['E' was pressed] | была нажата E
		public var auto:Boolean = false;		// [берётся автоматически] | берётся автоматически
		public var auto2:Boolean = false;		// [is taken automatically in accordance with the auto-pickup settings] | берётся автоматически в соответствии с настройками автовзятия
		public var krit:Boolean = false;		// [Critical item] | критически важный
		private var dery:int = 0;
		private var ttake:int = 30;
		private var tvsos:int = 0;
		public var sndFall:String = 'fall_item';
		
		// Cached tile sizes
		private static var tileX:int = Tile.tileX;
		private static var tileY:int = Tile.tileY;

		// Constructor
		public function Loot(nloc:Location, nitem:Item, nx:Number, ny:Number, jump:Boolean = false, nkrit:Boolean = false, nauto:Boolean = true)
		{
			//trace("Loot.as/Loot() - Creating new loot with item ID: " + nitem.id + ", kol: " + nitem.kol);
			loc = nloc;
			item = nitem;
			if (loc.cTransform) cTransform = loc.cTransform;
			sloy = 2;
			prior = 3;
			coordinates.X = nx;
			coordinates.Y = ny;
			krit = nkrit;
			if (nx < tileX) nx = tileX;
			if (nx > (loc.spaceX - 1) * tileX) nx = (loc.spaceX - 1) * tileX;
			if (ny > (loc.spaceY - 1) * tileY) ny = (loc.spaceY - 1) * tileY;
			massa = 0.1;
			nazv = item.nazv;
			objectWidth = 30;
			objectHeight = 20;
			// Determine the appropriate sprite for the item
			if (item.tip == Item.L_WEAPON) {
				if (item.xml.vis.length() && item.xml.vis.@loot.length()) {
					vis = new visualItem();
					try {
						vis.gotoAndStop(item.xml.vis.@loot);
					}
					catch (err) {
						trace('ERROR: (00:25)');
					}
				}
				else {
					if (item.variant > 0) vClass = Res.getClass('vis' + item.id + '_' + item.variant, 'vis' + item.id, visp10mm);
					else vClass = Res.getClass('vis' + item.id, null, visp10mm);

					var infIco=new vClass();
					infIco.stop();
					infIco.x=-infIco.getRect(infIco).left-infIco.width/2;
					infIco.y=-infIco.height-infIco.getRect(infIco).top+10;
					vis=new MovieClip();
					vis.addChild(infIco);
					dery=10;
				}
				if (item.variant > 0) shine();
				if (item.xml.snd.@fall.length()) sndFall = item.xml.snd.@fall;
			}
			else if (item.tip == Item.L_EXPL) {
				vClass=Res.getClass('vis'+item.id,null,visualAmmo);
				var infIco=new vClass();
				infIco.stop();
				infIco.x=-infIco.getRect(infIco).left-infIco.width/2;
				infIco.y=-infIco.height-infIco.getRect(infIco).top;
				vis=new MovieClip();
				vis.addChild(infIco);
				if (item.xml.@fall.length()) sndFall=item.xml.@fall;
			}
			else if (item.tip == Item.L_AMMO) {
				vClass = visualAmmo;
				vis = new vClass();
				try {
					if (item.xml.@base.length()) vis.gotoAndStop(item.xml.@base);
					else vis.gotoAndStop(item.id);
				}
				catch(err) {
					trace('ERROR: (00:26)');
					vis.gotoAndStop(1);
				}
				if (item.xml.@fall.length()) sndFall = item.xml.@fall;
			}
			else {
				vClass = visualItem;
				vis = new vClass();
				try {
					vis.gotoAndStop(item.id);
				}
				catch(err) {
					if (item.tip==Item.L_COMPA) vis.gotoAndStop('compa');
					else if (item.tip==Item.L_COMPW) vis.gotoAndStop('compw');
					else if (item.tip==Item.L_COMPE) vis.gotoAndStop('compe');
					else if (item.tip==Item.L_COMPP) vis.gotoAndStop('compp');
					else if (item.tip==Item.L_KEY) vis.gotoAndStop('key');
					else if (item.tip==Item.L_PAINT) vis.gotoAndStop('paint');
					else if (item.tip==Item.L_FOOD) vis.gotoAndStop('food');
					else  {
						trace('ERROR: (00:53) - ERROR: Could not load sprite for item: "' + item.id +'", using generic!');
						vis.gotoAndStop(1);
					}
				}
				if (item.tip==Item.L_SCHEME) {
					sndFall='fall_paper';
					vis.gotoAndStop('scheme');
				}
				if (item.tip==Item.L_BOOK) {
					nazv='"'+nazv+'"';
					sndFall='fall_paper';
				}
				if (item.xml.@fall.length()) sndFall=item.xml.@fall;
			} 
			// If a sprite was found, set up it's size and position
			if (vClass) {
				vis.x = coordinates.X;
				vis.y = coordinates.Y;
				vis.cacheAsBitmap=true;
				objectWidth=vis.width;
				objectHeight=vis.height;
			}

			if (jump) {
				velocity.X = Math.random() * 10 - 5;
				velocity.Y = Math.random() * 5 - 10;
			}
			
			// If the location is not active, don't play a sound
			if (!loc.active) sndFall = '';
			
			// Configure item magnetization and the take script for it
			auto = nauto;
			inter = new Interact(this);
			inter.active = true;
			inter.action = 100;
			inter.userAction = 'take';
			inter.actFun = toTake;
			inter.update();
			levitPoss = true;
			loc.addObj(this);
			auto2 = item.checkAuto();
		}
		
		public override function addVisual():void {
			super.addVisual();
			if (vis && cTransform) {
				if (item.tip!='art') vis.transform.colorTransform=cTransform;
			}
		}
		
		function shine() {
			if (vis) {
				var sh:MovieClip=new lootShine();
				sh.blendMode='hardlight';
				vis.addChild(sh);
			}
		}

		// What to do when the player presses 'E' on the item
		public function toTake() {
			item.checkAuto(true);
			actTake = true;
			ttake = 0;
			takeR = actRad;
		}

		// [try to take] | попробовать взять
		public function take(prinud:Boolean = false) {
			if ((ttake>0 || World.w.gg.loc!=loc || World.w.gg.rat>0) && !prinud) return;
			var rx = World.w.gg.coordinates.X - coordinates.X;
			var ry = World.w.gg.coordinates.Y - World.w.gg.objectHeight / 2 - coordinates.Y;
			// [take] | взять
			if (prinud || (World.w.gg.isTake >= 1 || actTake) && rx < 20 && rx > -20 && ry < 20 &&ry > -20) {
				if (World.w.hardInv && !actTake) {
					auto2 = item.checkAuto();
					if (!auto2) {
						vsos = false;
						actTake = false;
						tvsos = 0;
						levitPoss = true;
						takeR = osnRad;
						return;
					}
				}
				levitPoss = false;
				// Remove the object from the worldspace
				loc.remObj(this);
				// If the item is not already marked as taken, take it and mark it as taken.
				if (!isTake) {
					// Call inventory to add the item to the player inventory
					//trace("Loot.as/take() - is calling the Invent.as()/take function. Item ID: " + item.id + ", kol: " + item.kol);
					World.w.invent.take(item);
				}
				isTake = true;
				onCursor = 0;
				return;
			}
			// [attraction] | притяжение
			if ((World.w.gg.isTake>=20 || actTake) && rx < takeR && rx > -takeR && ry < takeR &&ry > -takeR && tvsos < 45) {
				levitPoss = false;
				stay = false;
				vsos = true;
				velocity.X = rx / 5;
				velocity.Y = ry / 5;
				tvsos++;
			}
			else {
				vsos = false;
				actTake = false;
				tvsos = 0;
				levitPoss = true;
				takeR = osnRad;
			}
		}
		
		public override function step():void {
			if (loc.broom && (auto2 || krit)) {
				take(true);
				return;
			}
			if (ttake>0) ttake--;
			if (stay && osnova && !osnova.stay) {
				stay=false;
				osnova=null;
			}
			if (!stay) {
				if (!levit && !vsos && velocity.Y < World.maxdy) velocity.Y += World.ddy;
				else if (levit && !isPlav) {
					velocity.multiply(0.80);
				}
				if (isPlav) {
					velocity.multiply(0.70);
				}
				if (Math.abs(velocity.X) < World.maxdelta && Math.abs(velocity.Y) < World.maxdelta)	run();
				else {
					var div = int(Math.max(Math.abs(velocity.X),Math.abs(velocity.Y)) / World.maxdelta) + 1;
					for (var i:int = 0; (i<div && !stay && !isTake); i++) run(div);
				}
				checkWater();
				if (vis) {
					vis.x = coordinates.X;
					vis.y = coordinates.Y - dery;
				}
			}
			if (inter) inter.step();
			onCursor=(coordinates.X - objectWidth / 2 < World.w.celX && coordinates.X + objectWidth / 2 > World.w.celX && coordinates.Y - objectHeight<World.w.celY && coordinates.Y > World.w.celY)? prior:0;
			if (World.w.checkLoot) auto2=item.checkAuto();
			if (auto && auto2 || actTake) take();
		}
		
		public function run(div:int=1) {
			//движение
			var t:Tile;var i:int;
			
			
			//ГОРИЗОНТАЛЬ
				coordinates.X += velocity.X / div;
				if (coordinates.X - objectWidth / 2 < 0) {
					coordinates.X = objectWidth / 2;
					velocity.X = Math.abs(velocity.X);
				}

				if (coordinates.X + objectWidth / 2 >= loc.spaceX * tileX) {
					coordinates.X = loc.spaceX * tileX - 1 - objectWidth / 2;
					velocity.X = -Math.abs(velocity.X);
				}

				//движение влево
				if (velocity.X < 0) {
					t = loc.getAbsTile(coordinates.X, coordinates.Y);
					if (t.phis==1 && coordinates.X <= t.phX2 && coordinates.X >= t.phX1 && coordinates.Y >= t.phY1 && coordinates.Y <= t.phY2) {
						coordinates.X = t.phX2 + 1;
						velocity.X = Math.abs(velocity.X);
					}
				}

				//движение вправо
				if (velocity.X > 0) {
					t = loc.getAbsTile(coordinates.X, coordinates.Y);
					if (t.phis==1 && coordinates.X >= t.phX1 && coordinates.X <= t.phX2 && coordinates.Y >= t.phY1 && coordinates.Y <= t.phY2) {
						coordinates.X = t.phX1 - 1;
						velocity.X = -Math.abs(velocity.X);
					}
				}
			
			
			//ВЕРТИКАЛЬ
			//движение вверх
			if (velocity.Y < 0) {
				stay=false;
				coordinates.Y += velocity.Y / div;
				if (coordinates.Y - objectHeight < 0) coordinates.Y = objectHeight;
				t = loc.getAbsTile(coordinates.X, coordinates.Y);
				if (t.phis==1 && coordinates.Y <= t.phY2 && coordinates.Y >= t.phY1 && coordinates.X >= t.phX1 && coordinates.X <= t.phX2) {
					coordinates.Y = t.phY2 + 1;
					velocity.Y = 0;
				}
			}

			//движение вниз
			var newmy:Number=0;
			if (velocity.Y > 0) {
				stay = false;
				if (coordinates.Y + velocity.Y / div >= loc.spaceY * tileY) {
					if (auto2) take(true);
					velocity.X = 0;
					return;
				}
				t = loc.getAbsTile(coordinates.X, coordinates.Y + velocity.Y / div);
				if (t.phis==1 && coordinates.Y + velocity.Y / div >= t.phY1 && coordinates.Y <= t.phY2 && coordinates.X >= t.phX1 && coordinates.X <= t.phX2 || t.shelf && !levit && !vsos && coordinates.Y + velocity.Y / div >= t.phY1 && coordinates.Y <= t.phY1 && coordinates.X >= t.phX1 && coordinates.X <= t.phX2) {
					newmy = t.phY1;
				}
				if (newmy == 0 && !levit && !vsos) newmy = checkShelf(velocity.Y / div);
				if (!loc.active && coordinates.Y >= (loc.spaceY - 1) * tileY) newmy = (loc.spaceY - 1) * tileY;
				if (newmy) {
					coordinates.Y = newmy - 1;
					if (!levit) {
						if (velocity.Y > 5 && sndFall) Snd.ps(sndFall, coordinates.X, coordinates.Y, 0, velocity.Y / 15);
						stay = true;
						velocity.Y = 0;
						velocity.X = 0;
					}
				}
				else {
					coordinates.Y += velocity.Y / div;
				}
			}
		}

		public override function checkStay():Boolean {
			if (osnova) return true;
			var t:Tile = loc.getAbsTile(coordinates.X, coordinates.Y + 1);
			if ((t.phis==1 || t.shelf) && coordinates.Y + 1 > t.phY1) {
				return true;
			}
			else {
				stay = false;
				return false;
			}
		}

		public function checkShelf(velocityDown:Number):Number {
			for (var i in loc.objs) {
				var b:Box = loc.objs[i] as Box;
				if (!b.invis && b.stay && b.shelf && b.wall == 0 && !(coordinates.X < b.leftBound || coordinates.X > b.rightBound) && coordinates.Y <= b.topBound && coordinates.Y + velocityDown > b.topBound) {
					osnova = b;
					return b.topBound;
				}
			}
			return 0;
		}
		
		//поиск жидкости
		public function checkWater():Boolean {
			var pla = isPlav;
			isPlav = false;
			try {
				if (loc.getTile(int(coordinates.X/tileX) , int(coordinates.Y/tileY)).water > 0) {
					isPlav = true;
				}
			}
			catch (err) {
				trace('ERROR: (00:28)');
			}

			if (pla != isPlav && velocity.Y > 5) {
				Emitter.emit('kap', loc, coordinates.X, coordinates.Y, {dy:-Math.abs(velocity.Y) * (Math.random() * 0.3 + 0.3), kol:5});
				Snd.ps('fall_item_water', coordinates.X, coordinates.Y, 0, velocity.Y / 10);
			}
			return isPlav;
		}
	}
}
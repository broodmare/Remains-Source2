package fe.loc {

	import flash.display.MovieClip;
	
	import fe.*;
	import fe.SymbolFactory;
	import fe.util.Vector2;
	import fe.graph.Emitter;
	import fe.serv.Item;
	import fe.serv.Interact;
	import fe.entities.BoundingBox;
	import fe.entities.Obj;
	import fe.unit.InventoryItem;
	
	// This is the object you see in-game when an item is dropped
	public class Loot extends Obj {
		
		public var item:InventoryItem;

		private const osnRad:int = 50;
		private const actRad:int = 250;

		public var vClass:Class;
		public var osnova:Box			= null;
		public var vsos:Boolean			= false;
		public var isPlav:Boolean		= false;
		public var takeR:int			= osnRad;		// [take radius] | радиус взятия
		
		private var isTake:Boolean		= false;		// [taken] | взят
		private var actTake:Boolean		= false;		// ['E' was pressed] | была нажата E
		public var auto:Boolean			= false;		// [берётся автоматически] | берётся автоматически
		public var auto2:Boolean		= false;		// [is taken automatically in accordance with the auto-pickup settings] | берётся автоматически в соответствии с настройками автовзятия
		public var krit:Boolean			= false;		// [Critical item] | критически важный
		private var dery:int			=  0;
		private var ttake:int			= 30;
		private var tvsos:int			=  0;
		public var sndFall:String		= "fall_item";
		
		// Cached tile sizes
		private static var tileX:int = Tile.tileX;
		private static var tileY:int = Tile.tileY;

		// Constructor
		public function Loot(nloc:Location, nitem:InventoryItem, nx:Number, ny:Number, jump:Boolean = false, nkrit:Boolean = false, nauto:Boolean = true) {
			
			trace("Loot.as/Loot() - Creating new loot with item ID: " + nitem.id + ", kol: " + nitem.quantity);
			loc = nloc;
			item = nitem;
			
			if (loc.cTransform) {
				cTransform = loc.cTransform;
			}
			
			sloy = 2;
			prior = 3;
			coordinates.X = nx;
			coordinates.Y = ny;
			krit = nkrit;
			
			if (nx < tileX) {
				nx = tileX;
			}
			
			if (nx > (loc.spaceX - 1) * tileX) {
				nx = (loc.spaceX - 1) * tileX;
			}
			
			if (ny > (loc.spaceY - 1) * tileY) {
				ny = (loc.spaceY - 1) * tileY;
			}
			
			var data:Object = ItemManager.reference.getItem(item.id)

			massa = 0.10;
			nazv = data.nazv;
			boundingBox.width = 30;
			boundingBox.height = 20;

			
			
			// Determine the appropriate sprite for the item
			if (data.tip == Item.L_WEAPON) {
				if ("vis" in data && "loot" in data) {
					vis = SymbolFactory.createInstance("visualItem") as MovieClip;
					if ("vis_loot" in data) {
						try {
							vis.gotoAndStop(data.vis_loot);
						}
						catch (err) {
							trace("ERROR: (00:25)");
						}
					}
				}
				else {
					if (data.variant) {
						vClass = Res.getClass("vis" + item.id + "_" + data.variant, "vis" + item.id, visp10mm);	// .SWF Dependency
					}
					else {
						vClass = Res.getClass("vis" + item.id, null, visp10mm);	// .SWF Dependency
					}

					var infIco1:MovieClip = new vClass();
					infIco1.stop();
					infIco1.x = -infIco1.getRect(infIco1).left - infIco1.width * 0.50;
					infIco1.y = -infIco1.height - infIco1.getRect(infIco1).top + 10;
					vis = new MovieClip();
					vis.addChild(infIco1);
					dery = 10;
				}
				
				if (data.variant) {
					shine();
				}
				
				if ("fall" in data) {
					sndFall = data.fall;
				}
			}
			else if (data.tip == Item.L_EXPL) {
				vClass = Res.getClass("vis" + item.id, null, visualAmmo);	// .SWF Dependency
				var infIco2:MovieClip = new vClass();
				infIco2.stop();
				infIco2.x = -infIco2.getRect(infIco2).left - infIco2.width * 0.50;
				infIco2.y = -infIco2.height - infIco2.getRect(infIco2).top;
				vis = new MovieClip();
				vis.addChild(infIco2);
				if ("fall" in data) {
					sndFall = data.fall;
				}
			}
			else if (data.tip == Item.L_AMMO) {
				vClass = visualAmmo;	// .SWF Dependency
				vis = new vClass();
				try {
					if ("base" in data) {
						vis.gotoAndStop(data.base);
					}
					else {
						vis.gotoAndStop(item.id);
					}
				}
				catch(err) {
					trace("ERROR: (00:26)");
					vis.gotoAndStop(1);
				}
				if ("fall" in data) {
					sndFall = data.fall;
				}
			}
			else {
				vClass = visualItem;	// .SWF Dependency
				vis = new vClass();
				
				try {
					vis.gotoAndStop(item.id);
				}
				catch(err) {
					if (data.tip == Item.L_COMPA) vis.gotoAndStop("compa");
					else if (data.tip == Item.L_COMPW) vis.gotoAndStop("compw");
					else if (data.tip == Item.L_COMPE) vis.gotoAndStop("compe");
					else if (data.tip == Item.L_COMPP) vis.gotoAndStop("compp");
					else if (data.tip == Item.L_KEY) vis.gotoAndStop("key");
					else if (data.tip == Item.L_PAINT) vis.gotoAndStop("paint");
					else if (data.tip == Item.L_FOOD) vis.gotoAndStop("food");
					else  {
						trace("ERROR: (00:53) - ERROR: Could not load sprite for item: \"" + item.id + "\", using generic!");
						vis.gotoAndStop(1);
					}
				}
				
				if (data.tip == Item.L_SCHEME) {
					sndFall = "fall_paper";
					vis.gotoAndStop("scheme");
				}
				
				if (data.tip == Item.L_BOOK) {
					nazv = "\"" + nazv + "\"";
					sndFall = "fall_paper";
				}
				
				if ("fall" in data) {
					sndFall = data.fall;
				}
			} 
			// If a sprite was found, set up it's size and position
			if (vClass) {
				vis.x = coordinates.X;
				vis.y = coordinates.Y;
				vis.cacheAsBitmap = true;
				boundingBox.width = vis.width;
				boundingBox.height = vis.height;
			}

			if (jump) {
				velocity.X = Math.random() * 10 - 5;
				velocity.Y = Math.random() * 5 - 10;
			}
			
			// If the location is not active, don't play a sound
			if (!loc.active) {
				sndFall = "";
			}
			
			// Configure item magnetization and the take script for it
			auto = nauto;
			inter = new Interact(this);
			inter.active = true;
			inter.action = 100;
			inter.userAction = "take";
			inter.actFun = toTake;
			inter.update();
			levitPoss = true;
			loc.addObj(this);
			// auto2 = item.checkAuto(); FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME 
		}
		
		public override function addVisual():void {
			super.addVisual();
			if (vis && cTransform) {
				if (ItemManager.reference.getItem(item.id).tip != "art") {
					vis.transform.colorTransform=cTransform;
				}
			}
		}
		
		private function shine():void {
			if (vis) {
				var sh:MovieClip = SymbolFactory.createInstance("lootShine") as MovieClip;
				sh.blendMode = "hardlight";
				vis.addChild(sh);
			}
		}

		// What to do when the player presses 'E' on the item
		public function toTake():void {
			//item.checkAuto(true);		// FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME 
			actTake = true;
			ttake = 0;
			takeR = actRad;
		}

		// [Try to take]
		public function take(prinud:Boolean = false):void {
			if ((ttake > 0 || World.w.gg.loc != loc || World.w.gg.rat > 0) && !prinud) {
				return;
			}
			
			var rx:Number = World.w.gg.coordinates.X - coordinates.X;
			var ry:Number = World.w.gg.coordinates.Y - World.w.gg.boundingBox.halfHeight - coordinates.Y;
			
			// [Take]
			if (prinud || (World.w.gg.isTake >= 1 || actTake) && rx < 20 && rx > -20 && ry < 20 &&ry > -20) {
				if (World.w.hardInv && !actTake) {
					/*
					auto2 = item.checkAuto();
					if (!auto2) {
						vsos = false;
						actTake = false;
						tvsos = 0;
						levitPoss = true;
						takeR = osnRad;
						return;
					}
					*/ // FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME 
				}
				
				levitPoss = false;
				
				// Remove the object from the worldspace
				loc.remObj(this);
				
				// If the item is not already marked as taken, take it and mark it as taken.
				if (!isTake) {
					// Call inventory to add the item to the player inventory
					trace("Loot.as/take() - is calling the Invent.as()/take function. Item ID: " + item.id + ", kol: " + item.quantity);
					// World.w.invent.take(item); FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME 
				}
				
				isTake = true;
				onCursor = 0;
				
				return;
			}
			
			// [attraction] | притяжение
			if ((World.w.gg.isTake >= 20 || actTake) && rx < takeR && rx > -takeR && ry < takeR &&ry > -takeR && tvsos < 45) {
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
			
			if (ttake > 0) {
				ttake--;
			}
			
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
				
				if (Math.abs(velocity.X) < World.maxdelta && Math.abs(velocity.Y) < World.maxdelta)	{
					run();
				}
				else {
					var div:int = int(Math.max(Math.abs(velocity.X),Math.abs(velocity.Y)) / World.maxdelta) + 1;
					for (var i:int = 0; (i<div && !stay && !isTake); i++) run(div);
				}
				
				checkWater();
				
				if (vis) {
					vis.x = coordinates.X;
					vis.y = coordinates.Y - dery;
				}
			}
			
			if (inter) {
				inter.step();
			}
			
			// AABB collision
			onCursor = (coordinates.X - boundingBox.halfWidth < World.w.celX && coordinates.X + boundingBox.halfWidth > World.w.celX && coordinates.Y - boundingBox.height < World.w.celY && coordinates.Y > World.w.celY)? prior:0;
			
			if (World.w.checkLoot) {
				// auto2 = item.checkAuto(); FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME FIX ME 
			}
			
			if (auto && auto2 || actTake) {
				take();
			}
		}
		
		public function run(div:int = 1):void {
			//движение
			var t:Tile;
			var i:int;
			
			//ГОРИЗОНТАЛЬ
				coordinates.X += velocity.X / div;
				if (coordinates.X - boundingBox.halfWidth < 0) {
					coordinates.X = boundingBox.halfWidth;
					velocity.X = Math.abs(velocity.X);
				}

				if (coordinates.X + boundingBox.halfWidth >= loc.spaceX * tileX) {
					coordinates.X = loc.spaceX * tileX - 1 - boundingBox.halfWidth;
					velocity.X = -Math.abs(velocity.X);
				}

				//движение влево
				if (velocity.X < 0) {
					t = loc.getAbsTile(coordinates.X, coordinates.Y);
					if (t.phis==1 && coordinates.X <= t.boundingBox.right && coordinates.X >= t.boundingBox.left && coordinates.Y >= t.boundingBox.top && coordinates.Y <= t.boundingBox.bottom) {
						coordinates.X = t.boundingBox.right + 1;
						velocity.X = Math.abs(velocity.X);
					}
				}

				//движение вправо
				if (velocity.X > 0) {
					t = loc.getAbsTile(coordinates.X, coordinates.Y);
					if (t.phis==1 && coordinates.X >= t.boundingBox.left && coordinates.X <= t.boundingBox.right && coordinates.Y >= t.boundingBox.top && coordinates.Y <= t.boundingBox.bottom) {
						coordinates.X = t.boundingBox.left - 1;
						velocity.X = -Math.abs(velocity.X);
					}
				}
			
			
			//ВЕРТИКАЛЬ
			//движение вверх
			if (velocity.Y < 0) {
				stay=false;
				coordinates.Y += velocity.Y / div;
				if (coordinates.Y - boundingBox.height < 0) coordinates.Y = boundingBox.height;
				t = loc.getAbsTile(coordinates.X, coordinates.Y);
				if (t.phis==1 && coordinates.Y <= t.boundingBox.bottom && coordinates.Y >= t.boundingBox.top && coordinates.X >= t.boundingBox.left && coordinates.X <= t.boundingBox.right) {
					coordinates.Y = t.boundingBox.bottom + 1;
					velocity.Y = 0;
				}
			}

			//движение вниз
			var newmy:Number=0;
			if (velocity.Y > 0) {
				stay = false;
				
				if (coordinates.Y + velocity.Y / div >= loc.spaceY * tileY) {
					if (auto2) {
						take(true);
					}
					
					velocity.X = 0;
					return;
				}
				
				t = loc.getAbsTile(coordinates.X, coordinates.Y + velocity.Y / div);
				
				if (t.phis==1 && coordinates.Y + velocity.Y / div >= t.boundingBox.top && coordinates.Y <= t.boundingBox.bottom && coordinates.X >= t.boundingBox.left && coordinates.X <= t.boundingBox.right || t.shelf && !levit && !vsos && coordinates.Y + velocity.Y / div >= t.boundingBox.top && coordinates.Y <= t.boundingBox.top && coordinates.X >= t.boundingBox.left && coordinates.X <= t.boundingBox.right) {
					newmy = t.boundingBox.top;
				}
				
				if (newmy == 0 && !levit && !vsos) {
					newmy = checkShelf(velocity.Y / div);
				}
				
				if (!loc.active && coordinates.Y >= (loc.spaceY - 1) * tileY) {
					newmy = (loc.spaceY - 1) * tileY;
				}
				
				if (newmy) {
					coordinates.Y = newmy - 1;
					if (!levit) {
						if (velocity.Y > 5 && sndFall) {
							Snd.ps(sndFall, coordinates.X, coordinates.Y, 0, velocity.Y / 15);
						}

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
			if (osnova) {
				return true;
			}
			
			var t:Tile = loc.getAbsTile(coordinates.X, coordinates.Y + 1);
			
			if ((t.phis==1 || t.shelf) && coordinates.Y + 1 > t.boundingBox.top) {
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
				
				if (!b.invis && b.stay && b.shelf && b.wall == 0 && !(coordinates.X < b.boundingBox.left || coordinates.X > b.boundingBox.right) && coordinates.Y <= b.boundingBox.top && coordinates.Y + velocityDown > b.boundingBox.top) {
					osnova = b;
					return b.boundingBox.top;
				}
			}
			
			return 0;
		}
		
		// [Liquid search]
		public function checkWater():Boolean {
			var pla:Boolean = isPlav;
			isPlav = false;
			
			try {
				if (loc.getTile(int(coordinates.X/tileX) , int(coordinates.Y/tileY)).water > 0) {
					isPlav = true;
				}
			}
			catch (err) {
				trace("ERROR: (00:28)");
			}

			if (pla != isPlav && velocity.Y > 5) {
				Emitter.emit("kap", loc, coordinates.X, coordinates.Y, {dy:-Math.abs(velocity.Y) * (Math.random() * 0.3 + 0.3), kol:5});
				Snd.ps("fall_item_water", coordinates.X, coordinates.Y, 0, velocity.Y / 10);
			}
			
			return isPlav;
		}
	}
}
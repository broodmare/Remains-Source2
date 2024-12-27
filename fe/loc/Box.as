package fe.loc {

	import flash.filters.DropShadowFilter;
	import flash.display.MovieClip;

	import fe.*;
	import fe.util.Vector2;
	import fe.entities.BoundingBox;
	import fe.entities.Obj;
	import fe.serv.Interact;
	import fe.unit.Unit;
	import fe.unit.VirtualUnit;
	import fe.graph.Emitter;
	import fe.graph.Grafon;
	import fe.serv.Script;
	import fe.projectile.Bullet;
	import fe.unit.Mine;

	public class Box extends Obj {

		public var osnova:Box=null;		//на чём стоит
		public var shelf:Boolean=true;	//на этом можно стоять
		public var isPlav:Boolean=false, isPlav2:Boolean=false, fixPlav:Boolean=false;
		public var id:String;
		public var door:int = 0;
		public var begX:Number=-1, begY:Number=-1; 		//исходная точка
		public var stX:Number=0, stY:Number=0;	//положение на начало такта
		public var cdx:Number=0, cdy:Number=0;	//движение того, кто стоит на ящике	
		public var vel2:Number=0; //скорость в квадрате
		
		public var mat:int=0;		//материал	//0 - хз что //1 - металл //2 - камень //3 - дерево
		public var wall:int=0;		//крепится на стену
		public var phis:int=1;
		public var sur:int=0;		//предме на ящике
		public var hp:Number=100;
		public var thre:Number=0;
		public var montdam:int=5;		//насколько будет ломаться монтировка
		public var electroDam:Number=0;	//если больше 0 - является генератором электрозащиты
		public var tiles:Array;			//задействованные блоки
		public var dead:Boolean	= false;
		public var invis:Boolean = false;
		public var light:Boolean = false;	//убрать туман войны в этой точке
		public var door_opac:Number=1;
		private var massaMult:Number=1;
		
		public var molnDam:Number=0;	//удар разрядом
		public var molnPeriod:int=60;
		public var moln_t:int=0;

		public var bulPlayer:Boolean=false;	//ловить пули игрока
		public var explcrack:Boolean=false;	//открывается взрывом
		public var bulTele:Boolean=false;	//ловить пули врагов при левитации
		public var bulChance:Number=0;
		public var lurk:int=0;				//возможность прятаться
		public var isThrow:Boolean=false;	//был брошен телекинезом
		public var t_throw:int=0;
		
		public var noiseDie:Number=800;

		public var scrDie:Script;
		
		public var sndOn:Boolean=false;
		public var sndFall:String='';
		public var sndOpen:String='';
		public var sndClose:String='';
		public var sndDie:String='';
		
		private var dsf:DropShadowFilter=new DropShadowFilter(0,90,0,0.8,8,8,1,3,false,false,true);
		public var shad:MovieClip;
		
		public var ddyPlav:Number=1; //выталкивающая сила, 1 если нет, <0 если предмет всплывает
		
		public var un:VirtualUnit;	//виртуальный юнит для взаимодействия с пулями;
		
		private static var cachedObjs:Object = {}; // Save all objects that have been used before to avoid parsing XML for lots of objects.
		
		private static var tileX:int = Tile.tileX;
		private static var tileY:int = Tile.tileY;

		// Constructor
		public function Box(nloc:Location, nid:String, nx:int=0, ny:int=0, xml:XML=null, loadObj:Object=null) {
			loc=nloc;
			id=nid;
			if (loc.land.kolAll) {
				if (loc.land.kolAll[id]>0) loc.land.kolAll[id]++;
				else loc.land.kolAll[id]=1;
			}
			prior=1;
			vis=World.w.grafon.getObj('vis'+id, Grafon.numbObj);
			shad=World.w.grafon.getObj('vis'+id, Grafon.numbObj);
			if (vis == null) {
				vis = new visbox0();	// SWF Dependency
				shad = new visbox0();	// SWF Dependency
			}
			vis.stop();
			shad.gotoAndStop(vis.currentFrame);
			shad.filters = [dsf];
			
			var node:XML = getObjInfo(id);
			
			coordinates.X = begX = nx; 
			coordinates.Y = begY = ny;
			this.boundingBox.width = vis.width;
			this.boundingBox.height = vis.height;
			if (node.@scx.length()) this.boundingBox.width = node.@scx;
			if (node.@scy.length()) this.boundingBox.height = node.@scy;
			this.boundingBox.center(coordinates);
			
			
			if (node.@mat.length()) mat=node.@mat;
			if (node.@hp.length()) hp=node.@hp;
			if (node.@thre.length()) thre=node.@thre;
			if (node.@shield.length()) bulChance=node.@shield;
			if (node.@lurk.length()) lurk=node.@lurk;
			if (node.@sur.length()) sur=node.@sur;
			if (node.@montdam.length()) montdam=node.@montdam;
			if (node.@electro.length()) electroDam=node.@electro;
			if (node.@moln.length()) molnDam=node.@moln;
			if (node.@period.length()) molnPeriod=node.@period;
			if (node.@rad.length()) radioactiv=node.@rad;
			if (node.@radrad.length()) radrad=node.@radrad;
			if (node.@radtip.length()) radtip=node.@radtip;
			if (node.@wall.length()) wall=node.@wall;
			if (wall>1) shad.alpha=0;
			if (node.@phis.length()) phis=node.@phis;
			if (node.@fall.length()) sndFall=node.@fall;
			if (node.@open.length()) sndOpen=node.@open;
			if (node.@close.length()) sndClose=node.@close;
			if (node.@die.length()) sndDie=node.@die;
			if (node.@plav.length()) ddyPlav=node.@plav;
			if (node.@nazv.length()) nazv=Res.txt('o',node.@nazv);
			else nazv=Res.txt('o',id);
			if (node.@explcrack.length()) explcrack=true;
			if (this.boundingBox.width < 40 || wall > 0) shelf=false;
			if (node.@shelf.length()) shelf=true;
			if (node.@massaMult.length()) massaMult=node.@massaMult;
			massa = this.boundingBox.width * this.boundingBox.height * this.boundingBox.height / 250000 * massaMult;
			if (node.@massa.length()) massa=node.@massa/50;
			
			if (xml && xml.@indestruct.length()) {
				hp = 10000;
				thre = 10000;
			}

			// Door
			if (node.@door.length()) {
				door = node.@door;
				if (node.@opac.length()) door_opac = node.@opac;
				initDoor();
			}
			// [Interactivity]
			if (node.@inter.length() || (xml && (xml.@inter.length() || xml.scr.length() || xml.@scr.length()))) inter=new Interact(this,node,xml,loadObj);
			if (inter && inter.cont!='' && inter.cont!='empty' && inter.lock && inter.lockTip<=1) bulPlayer=true;
			
			// [Individual parameters from xml card]
			if (xml) {
				if (xml.@name.length()) nazv=Res.txt('o',xml.@name);	//название
				//прикреплённые скрипты
				if (xml.scr.length()) {
					for each (var xscr in xml.scr) {
						var scr:Script = new Script(xscr,loc.land);
						if (inter && scr.eve == null) inter.scrAct=scr;
						if (inter && scr.eve == 'open') inter.scrOpen=scr;
						if (inter && scr.eve == 'close') inter.scrClose=scr;
						if (inter && scr.eve == 'touch') inter.scrTouch=scr;
						if (scr.eve=='die') scrDie = scr;
						scr.owner = this;
					}
				}
				if (xml.@scr.length()) inter.scrAct=World.w.game.getScript(xml.@scr,this);
				if (xml.@scropen.length()) inter.scrOpen=World.w.game.getScript(xml.@scropen,this);
				if (xml.@scrclose.length()) inter.scrClose=World.w.game.getScript(xml.@scrclose,this);
				if (xml.@scrtouch.length()) inter.scrTouch=World.w.game.getScript(xml.@scrtouch,this);
				if (xml.@scrdie.length()) scrDie=World.w.game.getScript(xml.@scrdie,this);
				if (xml.@moln.length()) molnDam=xml.@moln;
				if (xml.@period.length()) molnPeriod=xml.@period;
				if (xml.@phase.length()) moln_t=xml.@phase;
				
				if (xml.@prob.length() && id!='exit') {
					nazv=Res.txt('m',xml.@prob);
				}
				if (xml.@light.length()) light=true;
				if (xml.@fun.length()) {
					initFun(xml.@fun);
				}
				if (xml.@radrad.length()) radrad=xml.@radrad;
			}
			
			if (wall > 0) {
				levitPoss = false;
				stay = true;
				sloy = 0;
			}
			else sloy = 1;
			
			if (node.@sloy.length()) sloy = node.@sloy;
			
			cTransform=loc.cTransform;
			
			vis.cacheAsBitmap=true;
			vis.x = shad.x = coordinates.X;
			vis.y = coordinates.Y;
			shad.y = coordinates.Y + (wall?2:6);
			prior +=1 / (this.boundingBox.width * this.boundingBox.height);
			if (node.@actdam.length()) {
				if (xml && xml.@tipdam.length())  bindUnit(xml.@tipdam);
				else bindUnit();
			}
			if (xml && xml.@pokr.length()) {
				sloy=1;
				prior=3;
			}
			
			if (loadObj && loadObj.dead) {	// [If the object was destroyed]
				die(-1);
			}
			

			function getObjInfo(id:String):XML {
				// Check if the node is already cached
				var node:XML;
				if (cachedObjs[id] == undefined) {
					node = XMLDataGrabber.getNodeWithAttributeThatMatches("core", "AllData", "objs", "id", id);
					cachedObjs[id] = node;
				}
				else node = cachedObjs[id];
				return node;
			}
		}
		
		public override function save():Object {
			var obj:Object=new Object();
			if (dead) obj.dead=true;
			if (inter) inter.save(obj);
			return obj;
		}
		
		public override function command(com:String, val:String=null) {
			super.command(com,val);
			if (com == 'die') {
				hp = 0;
				die();
			}
			if (inter) inter.command(com,val);
		}
		
		public override function addVisual():void {
			if (invis) return;
			if (vis && loc && loc.active) {
				if (shad) World.w.grafon.visObjs[0].addChild(shad);
				World.w.grafon.visObjs[sloy].addChild(vis);
				if (cTransform) {
					vis.transform.colorTransform=cTransform;
				}
			}
		}

		public override function setNull(f:Boolean=false):void {
			super.setNull(f);
			if (!dead && invis && f) {
				invis = false;
				
				coordinates.X = begX;
				coordinates.Y = begY;
				velocity.set(0, 0);

				
				var l:Number;
				var r:Number;
				var t:Number;
				var b:Number;

				t = coordinates.Y - this.boundingBox.height;
				b = coordinates.Y;

				l = coordinates.X - this.boundingBox.halfWidth;
				b = coordinates.X + this.boundingBox.halfWidth;

				boundingBox.setBounds(l, r, t, b);
			}
		}
		
		public override function remVisual():void {
			if (vis && vis.parent) vis.parent.removeChild(vis);
			if (shad && shad.parent) shad.parent.removeChild(shad);
		}
		
		public override function setVisState(s:String) {
			if ((s == 'open' || s == 'comein') && sndOpen != '' && !World.w.testLoot) Snd.ps(sndOpen, coordinates.X, coordinates.Y);
			if (s == 'close' && sndClose!='') Snd.ps(sndClose, coordinates.X, coordinates.Y);
			try {
				if (s == 'comein') vis.gotoAndPlay(s);
				else vis.gotoAndStop(s);
			}
			catch (err) {
				trace('ERROR: (00:2B) - Could not set vis state: "' + s + '"!');
			}
		}
		
		public override function step():void {
			if (dead && invis) {
				onCursor=0;
				return;
			}
			stX = coordinates.X;
			stY = coordinates.Y;
			if (inter) inter.step();
			if (radioactiv) {
				getRasst2()
				ggModum();
			}
			if (molnDam>0) {
				moln_t++;
				if (moln_t>=molnPeriod) {
					moln_t=0;
					attMoln();
					vis.gotoAndPlay('moln');
				}
			}
			if (levit) {
				stay=fixPlav=false;
				osnova=null;
			}
			if (wall==0 && stay && osnova) {
				if (!osnova.stay || osnova.levit) {
					stay=false;
					osnova=null;
				}
				if (osnova &&  (osnova.cdx!=0 || osnova.cdy!=0)) {
					if (collisionAll(osnova.cdx,osnova.cdy)) {
						stay=false;
						osnova=null;
					}
					else
					{
						coordinates.X += osnova.cdx;
						coordinates.Y += osnova.cdy;
						boundingBox.center(coordinates);
						if (vis) runVis()
					}
				}
			}
			if (wall==0 && !(stay && velocity.X == 0) && !fixPlav) {
				if (wall==0) forces();		//внешние силы, влияющие на ускорение
				if (Math.abs(velocity.X)<World.maxdelta && Math.abs(velocity.Y)<World.maxdelta)	run();
				else {
					var div = int(Math.max(Math.abs(velocity.X), Math.abs(velocity.Y))/World.maxdelta)+1;
					for (var i = 0; i < div; i++) run(div);
				}
				checkWater();
				if (!fixPlav && !levit && isPlav&&!isPlav2 && velocity.Y < 2 && velocity.Y > -2 && ddyPlav<0) {
					velocity.set(0, 0);
					fixPlav=true;
				}
				if (!levit && (velocity.Y > 5 || velocity.Y < -5 || velocity.X > 5 || velocity.X < -5)) attDrop();
				if (vis) runVis();
				if (inter) {inter.coordinates.X = coordinates.X; inter.coordinates.Y = coordinates.Y;}
			}
			cdx = coordinates.X - stX;
			cdy = coordinates.Y - stY;
			if (t_throw>0) t_throw--;
			onCursor = (this.boundingBox.left < World.w.celX && this.boundingBox.right > World.w.celX && this.boundingBox.top < World.w.celY && this.boundingBox.bottom > World.w.celY) ? prior : 0;
		}
		
		public function initDoor() {
			tiles = [];
			for (var i:int = int(this.boundingBox.left / tileX + 0.5); i <= int(this.boundingBox.right / tileX - 0.5); i++) {
				for (var j:int = int(this.boundingBox.top / tileY + 0.5); j <= int(this.boundingBox.bottom / tileY - 0.5); j++) {
					var t:Tile = loc.getTile(i, j);
					t.front = '';
					t.phis = phis;
					t.opac = door_opac;
					t.door = this;
					t.mat = mat;
					t.hp = hp;
					t.thre = thre;
					tiles.push(t);
				}
			}
		}

		// This is for opening and closing doors inside of rooms, NOT for traveling to new rooms.
		public function setDoor(state:Boolean) {
			for (var i in tiles) {
				(tiles[i] as Tile).phis = (state? 0 : phis);
				(tiles[i] as Tile).opac = (state? 0 : door_opac);
			}

			setVisState(state? 'open':'close');
			
			if (state && World.w.loc) {
				World.w.loc.isRelight = true;
				World.w.loc.isRebuild = true;
			}
		}

		// Check if doorway is clear
		public function attDoor():Boolean {
			// First check units
			for each (var cel in loc.units) {
				if (!cel || (cel as Unit).sost == 4) continue;  // Skip nulls or "dead" units
				if (cel is fe.unit.UnitMWall) continue;         // Skip walls

				// If the unit has its own boundingBox, use intersects:
				if (cel.boundingBox && cel.boundingBox.intersects(this.boundingBox)) {
					// Special logic for Mine
					if (cel is fe.unit.Mine) {
						cel.fixed = true;
						trace("Mine activated by door!");
						(cel as fe.unit.Mine).activate();
						continue; 
					}
					// Otherwise it's a blocking unit
					trace("Door blocked by unit!");
					return true;
				}
			}

			// Now check objects (boxes) that may not have a built-in bounding box
			for each (var obj in loc.objs) {
				// If it's actually a Box with a "wall" property
				if ((obj as Box).wall > 0) continue;  // skip “wall” boxes

				// If it has no boundingBox, create one on the fly
				var boxBB:BoundingBox = new BoundingBox(new Vector2(obj.coordinates.X, obj.coordinates.Y - obj.boundingBox.halfHeight));
				boxBB.width = obj.boundingBox.width;
				boxBB.height = obj.boundingBox.height;

				if (boxBB.intersects(this.boundingBox)) {
					trace("Door blocked by box!");
					return true;
				}
			}

			// If we get here, door is not blocked
			return false;
		}
		
		public function attMoln():void {
			for each (var cel in loc.units) {
				if (!cel || (cel as Unit).sost == 4) continue; // Skip null or "dead"

				if (cel.boundingBox && cel.boundingBox.intersects(this.boundingBox)) {
					// If there is a collision, call "udarBox"
					cel.udarBox(this);
				}
			}
		}
		
		//проверка на попадание пули, наносится урон, если пуля попала, возвращает -1 если не попала
		public override function udarBullet(bul:Bullet, sposob:int=0):int {
			if (sposob==1) {
				if (!bulPlayer) return -1;
				damage(bul.destroy);
				return mat;
			}
			if (sposob == 0 && bulChance > 0) {
				if (Math.random() < bulChance) {
					var sila:Number = Math.random()*0.4+0.8;
					sila /= massa;
					if (sila > 3) sila = 3;

					var n:Number = bul.knockx * bul.otbros * sila;
					velocity.sum(n);

					World.w.gg.otbrosTele(bul.otbros * sila);
					return mat;
				}
			}
			return -1;
		}
		
		public function damage(dam:Number) {
			dam-=thre;
			if (dam > 0) hp -= dam;
			if (hp <= 0) die();
		}
		
		public override function die(sposob:int=0):void {
			if (dead) return;
			if (inter && inter.prize) return;
			dead = true;
			if (door > 0) {
				for (var i in tiles) {
					(tiles[i] as Tile).opac=0;
					(tiles[i] as Tile).phis=0;
					(tiles[i] as Tile).hp=0;
				}
				setVisState('die');
				if (inter) {
					if (inter.mine>0) {
						if (inter.fiascoRemine != null) inter.fiascoRemine();
					}
					inter.off();
				}
				if (sposob>=0 && sposob<10) {
					var kus='iskr';
					if (mat==1) kus='metal';
					if (mat==2) kus='kusok';
					if (mat==3) kus='schep';
					if (mat==5) kus='steklo';
					if (mat==7) kus='pole';
					Emitter.emit(kus, loc, coordinates.X, coordinates.Y-this.boundingBox.halfHeight, {kol:12,rx: this.boundingBox.width, ry:this.boundingBox.height});
					if (sndDie!='') Snd.ps(sndDie, coordinates.X, coordinates.Y);
				}
				if (noiseDie) loc.budilo(coordinates.X, coordinates.Y - this.boundingBox.halfHeight, noiseDie);
				if (inter) inter.sign=0;
			}
			else if (un) {
				invis=true;
				un.disabled=true;
				un.sost=4;
				if (vis) remVisual();
			}
			else {
				if (inter && inter.cont) {
					inter.dieCont();
				}
				bulPlayer=false;
				bulChance*=0.25;
			}
			if (scrDie && sposob>=0) scrDie.start();
		}
		
		
		public function forces():void {
			if (!levit) {
				if (!isPlav && velocity.Y < World.maxdy) velocity.Y += World.ddy;
				if (isPlav && isPlav2) velocity.Y += World.ddy * ddyPlav;
			}
			
			if (isPlav) {
				velocity.multiply(0.65);
			}
			else if (levit) {
				velocity.multiply(0.8);
			}
		}
		
		// [Fall impact]
		public function attDrop():void {
			// Compute the squared velocity
			var vel2:Number = velocity.X * velocity.X + velocity.Y * velocity.Y;
			if (vel2 < 50) return;

			// Loop over all units
			for each (var cel:Unit in loc.units) {
				// Skip null
				if (!cel) continue;

				// Skip if it’s in the same faction when fracLevit > 0
				if (fracLevit > 0 && cel.fraction == fracLevit) continue;

				// Skip if dead (sost == 4), can’t be attacked (neujaz > 0), or not in the same location
				if (cel.sost == 4 || cel.neujaz > 0 || cel.loc != loc) continue;

				// Use the built-in intersection check
				if (cel.boundingBox && cel.boundingBox.intersects(this.boundingBox)) {
					// If thrown recently (t_throw > 0), set neujaz & skip
					if (t_throw > 0) {
						cel.neujaz = 12;
						continue;
					}

					// Otherwise, deal damage
					cel.udarBox(this);
					isThrow = false;
				}
			}
		}
		
		// Check if standing on ground
		public override function checkStay():Boolean {
			if (osnova || wall > 0) return true;
			fixPlav = false;
			checkWater();
			if (isPlav&&!isPlav2 && velocity.Y < 2 && velocity.Y > -2) {
				fixPlav = true;
			}
			for (var i:int = int(this.boundingBox.left / tileX); i<=int(this.boundingBox.right / tileX); i++) {
				var t:Tile = loc.getTile(i, int((this.boundingBox.bottom + 1) / tileY));
				if (collisionTile(t, 0, 1)) {
					return true;
				}
			}
			stay = false;
			return false;
		}
		
		public function run(div:int=1) {
			//движение
			var t:Tile;
			var i:int;

			//HORIZONTAL
				coordinates.X += velocity.X / div;
				if (coordinates.X - this.boundingBox.halfWidth < 0) {
					coordinates.X = this.boundingBox.halfWidth;
					velocity.X = Math.abs(velocity.X);
				}
				if (coordinates.X + this.boundingBox.halfWidth >= loc.spaceX * tileX) {
					coordinates.X = loc.spaceX * tileX - 1 - this.boundingBox.halfWidth;
					velocity.X = -Math.abs(velocity.X);
				}
				this.boundingBox.left = coordinates.X - this.boundingBox.halfWidth;
				this.boundingBox.right = coordinates.X + this.boundingBox.halfWidth;
				//движение влево
				if (velocity.X < 0) {
					for (i = int(this.boundingBox.top / tileY); i <= int(this.boundingBox.bottom / tileY); i++) {
						t = loc.getTile(int(this.boundingBox.left / tileX), i);
						if (collisionTile(t)) {
								coordinates.X = t.boundingBox.right + this.boundingBox.halfWidth;
								if (velocity.X < -10) velocity.X = -velocity.X * 0.2;
								else velocity.X = 0;
								this.boundingBox.left = coordinates.X - this.boundingBox.halfWidth;
								this.boundingBox.right = coordinates.X + this.boundingBox.halfWidth;
							isThrow=false;
						}
					}
				}
				//движение вправо
				if (velocity.X > 0) {
					for (i=int(this.boundingBox.top/tileY); i<=int(this.boundingBox.bottom/tileY); i++) {
						t = loc.getTile(int(this.boundingBox.right/tileX), i);
						if (collisionTile(t)) {
								coordinates.X = t.boundingBox.left - this.boundingBox.halfWidth;
								if (velocity.X > 10) velocity.X = -velocity.X * 0.2;
								else velocity.X = 0;
								this.boundingBox.left = coordinates.X - this.boundingBox.halfWidth;
								this.boundingBox.right = coordinates.X + this.boundingBox.halfWidth;
							isThrow=false;
						}
					}
				}
			
			
			//VERTICAL
			//движение вниз
			var newmy:Number = 0;
			if (velocity.Y > 0) {
				stay = false;
				for (i = int(this.boundingBox.left / tileX); i <= int(this.boundingBox.right / tileX); i++) {
					t = loc.getTile(i, int((this.boundingBox.bottom + velocity.Y / div) / tileY));
					if (collisionTile(t, 0, velocity.Y / div)) {
						newmy = t.boundingBox.top;
						break;
					}
				}
				if (newmy == 0 && !levit && !isThrow) newmy = checkShelf(velocity.Y / div);
				if (coordinates.Y >= (loc.spaceY - 1) * tileY && !loc.bezdna) newmy = (loc.spaceY - 1) * tileY;
				if (coordinates.Y >= loc.spaceY * tileY - 1 && loc.bezdna) {
					invis = true;
					if (vis) remVisual();
				}
				if (newmy)
				{
					coordinates.Y = newmy;
					this.boundingBox.top = coordinates.Y - this.boundingBox.height;
					this.boundingBox.bottom = coordinates.Y;
					if (loc.active && velocity.Y > 4 && velocity.Y * massa > 5) World.w.quake(0, velocity.Y * Math.sqrt(massa) / 2);
					if (velocity.Y > 5 && sndFall && sndOn) Snd.ps(sndFall, coordinates.X, coordinates.Y, 0, velocity.Y / 15);
					if (velocity.Y > 5)
					{
						loc.budilo(coordinates.X, coordinates.Y, velocity.Y * velocity.Y * massa);
					}

					if (velocity.Y < 5 || massa > 1) velocity.Y=0;
					else velocity.Y *= -0.2;

					if (velocity.X > -5 && velocity.X < 5) velocity.X = 0;
					else {
						velocity.X *= 0.92;
						if (mat==1)	Emitter.emit('iskr_wall', loc, coordinates.X + (Math.random()-0.5)*this.boundingBox.width, coordinates.Y);
					}

					if (!levit && (!isPlav || ddyPlav>0)) {
						stay=true;
						isThrow=false;
						fracLevit=0;
					}

					sndOn=true;
				}
				else {
					coordinates.Y += velocity.Y / div;
					this.boundingBox.top = coordinates.Y - this.boundingBox.height;
					this.boundingBox.bottom = coordinates.Y;
				}
			}
			//движение вверх
			if (velocity.Y < 0) {
				stay = false;
				coordinates.Y += velocity.Y / div;
				this.boundingBox.top = coordinates.Y - this.boundingBox.height;
				this.boundingBox.bottom = coordinates.Y;
				if (coordinates.Y - this.boundingBox.height < 0) coordinates.Y = this.boundingBox.height;
				for (i = int(this.boundingBox.left/tileX); i <= int(this.boundingBox.right/tileX); i++) {
					t = loc.getTile(i, int(this.boundingBox.top/tileY));
					if (collisionTile(t)) {
						coordinates.Y = t.boundingBox.bottom + this.boundingBox.height;
						this.boundingBox.top = coordinates.Y - this.boundingBox.height;
						this.boundingBox.bottom = coordinates.Y;
						velocity.Y = 0;
						isThrow=false;
					}
				}
			}
		}

		//поиск жидкости
		public function checkWater():Boolean {
			var pla:Boolean = isPlav;
			isPlav = false;
			isPlav2 = false;

			var x:int = int(coordinates.X/tileX);
			if (loc.getTile(x , int((coordinates.Y - this.boundingBox.height * 0.45) / tileY)).water > 0) {
				isPlav = true;
			}
			if (loc.getTile(x , int((coordinates.Y - this.boundingBox.height * 0.55) / tileY)).water > 0) {
				isPlav2 = true;
			}


			if (pla!=isPlav && (velocity.Y > 8 || velocity.Y < -8)) Emitter.emit('kap', loc, coordinates.X, coordinates.Y - this.boundingBox.height * 0.25 + velocity.Y, {dy:-Math.abs(velocity.Y)*(Math.random()*0.3+0.3), kol:Math.floor(Math.abs(velocity.Y*massa*2)-5)});
			if (pla!=isPlav && velocity.Y > 5) {
				if (massa>2) sound('fall_water0', 0, velocity.Y / 10);
				else if (massa>0.4) sound('fall_water1', 0, velocity.Y / 10);
				else if (massa>0.2) sound('fall_water2', 0, velocity.Y / 10);
				else sound('fall_item_water', 0, velocity.Y / 10);
			}

			return isPlav;
		}

		public function checkShelf(velocityDown:Number):Number {
			// Use this entity's bounding box
			for (var i in loc.objs) {
				var b:Box = loc.objs[i] as Box;
				if (!b.invis && b.stay && b.shelf) {
					// Check X range by comparing our centerX to b's boundingBox.left/right
					if ( !( coordinates.X < b.boundingBox.left ||
							coordinates.X > b.boundingBox.right ) &&
							// Check Y range by comparing bottom to b's top
							this.boundingBox.bottom <= b.boundingBox.top &&
							(this.boundingBox.bottom + velocityDown) > b.boundingBox.top )
						{
						osnova = b;
						return b.boundingBox.top;
					}
				}
			}
			return 0;
		}

		public function collisionAll(gx:Number = 0, gy:Number = 0):Boolean {
			// Use boundingBox properties for iteration
			var leftIndex:int   = int((this.boundingBox.left   + gx) / tileX);
			var rightIndex:int  = int((this.boundingBox.right  + gx) / tileX);
			var topIndex:int    = int((this.boundingBox.top    + gy) / tileY);
			var bottomIndex:int = int((this.boundingBox.bottom + gy) / tileY);

			for (var i:int = leftIndex; i <= rightIndex; i++) {
				for (var j:int = topIndex; j <= bottomIndex; j++) {
					if (collisionTile(loc.getTile(i, j), gx, gy)) {
						return true;
					}
				}
			}
			return false;
		}
		
		public function bindUnit(n:String='-1'):void {
			un = new VirtualUnit(n);
			copy(un);
			un.owner = this;
			un.loc = loc;
		}
		
		//принудительное движение
		public override function bindMove(v:Vector2, ox:Number = -1, oy:Number = -1) {
			super.bindMove(v);
			
			if (this.un) {
				un.bindMove(v);
			}
			
			if (vis) {
				runVis();
			}
		}
		
		public function runVis():void {
			vis.x = shad.x = coordinates.X;
			vis.y = coordinates.Y;
			shad.y = coordinates.Y + (wall? 2:6);
		}
		
		public function sound(sid:String, msec:Number=0, vol:Number=1):* {
			return Snd.ps(sid, coordinates.X, coordinates.Y, msec, vol);
		}
		
		public function collisionTile(t:Tile, gx:Number = 0, gy:Number = 0):int {
			// If the tile is non-existent or effectively “empty,” just return 0.
			if (!t || ((t.phis == 0 || t.phis == 3) && !t.shelf)) {
				return 0;
			}

			// Cache shifted bounding box edges (for clarity/efficiency).
			// These represent where our bounding box will be after applying (gx, gy).
			var newLeft:Number   = this.boundingBox.left   + gx;
			var newRight:Number  = this.boundingBox.right  + gx;
			var newTop:Number    = this.boundingBox.top    + gy;
			var newBottom:Number = this.boundingBox.bottom + gy;

			// Compare against the tile’s “physical” boundaries.
			// If we are completely to the left, right, above, or below the tile, no collision.
			if (newRight   <= t.boundingBox.left ||
				newLeft    >= t.boundingBox.right || 
				newBottom  <= t.boundingBox.top ||
				newTop     >= t.boundingBox.bottom) 
			{
				return 0;
			}

			// If it's a shelf-type tile (phis == 0 or 3), and our bottom is already below the tile’s top edge
			// (or if we’re levitating or being thrown), then we also skip collision.
			if ((t.phis == 0 || t.phis == 3) && t.shelf &&
				(this.boundingBox.bottom > t.boundingBox.top || levit || isThrow)) 
			{
				return 0;
			}

			// Otherwise, collision is valid.
			return 1;
		}
		
		//особые функции
		
		private function initFun(fun:String):void {
			if (fun == 'generator') {
				if (inter == null) inter = new Interact(this);
				inter.action = 100;
				inter.active = true;
				inter.cont = null;
				inter.knop = 1;
				inter.t_action = 45;
				inter.needSkill = 'repair';
				inter.needSkillLvl = 4;
				inter.userAction = 'repair'; 
				inter.actFun = funGenerator;
				inter.update();
			}
		}
		
		public function funGenerator():void {
			inter.active = false;
			World.w.gui.infoText('unFixLock');
			World.w.game.runScript('fixGenerator', this);
		}
	}
}
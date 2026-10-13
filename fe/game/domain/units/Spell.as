package fe.game.domain.units {

	import fe.engine.audio.Sound;
	import fe.engine.text.TextParser;
	import fe.engine.text.XMLDataGrabber;
	import fe.game.World;
	import fe.game.ui.GUIManager;
	import fe.game.GameContainer;
	import fe.engine.utils.Vec2;
	import fe.game.domain.location.Location;
	import fe.game.domain.location.tile.Tile;
	import fe.game.rendering.Emitter;
	import fe.game.domain.weapon.Weapon;
	import fe.game.enums.E_Material;
	import fe.game.domain.units.enums.E_Resistances;
	import fe.game.enums.E_Direction;
	import fe.engine.Engine;

	public class Spell {

		public var owner:Unit;									// A reference to the owner of this spell
		public var gg:UnitPlayer;								// A reference to the player unit
		public var loc:Location;								// A reference to the room the spell was cast in

		public var id:String;									// Internal ID
		public var nazv:String;									// Localized name

		public var xml:XML;
		public var player:Boolean				= false;		// [the spell belongs to player]
		
		// [source position]
		public var X:Number						= 0.00;
		public var Y:Number						= 0.00;
		
		// [target position]
		public var cx:Number					= 0.00;
		public var cy:Number					= 0.00;
		
		public var power:Number					= 1.00;			// [spell power multiplier]
		public var prod:Boolean					= false;		// [long lasting]
		public var atk:Boolean					= false;		// [prohibited when attack is prohibited]
		public var active:Boolean				= false;
		public var teleSpell:Boolean			= false;		// [telekinesis spell]
		private var est:int						= 1;			// [cast result]
		
		public var magic:Number					= 0.00;			// [how much mana does it require]
		public var dmagic:Number				= 0.00;	
		public var mana:Number					= 0.00;			// [how much mana does it require]
		public var dmana:Number					= 0.00;	

		// Cooldown
		public var culd:int						= 0;					
		public var t_culd:int					= 0;
		
		public var hp:Number					= 300.00;		// [Spell HP]
		public var dist:Number					= 0.00;			// [Maximum spell distance]
		public var rad:Number					= 0.00;			// [Spell radius]
		public var dam:Number					= 0.00;			// [Apell action]
		public var line:int						= 0;			// [Target visibility requirement]
		
		public var cf:Function;									// What hard-coded function the spell uses
		public var snd:String					= "";			// Sound when casting

		private static var cachedItems:Object	= {};

		public function Spell(own:Unit, nid:String) {

			id = nid;
			owner = own;

			if (owner && owner.player) {
				player = true;
				gg = owner as UnitPlayer;
			}
			
			var xml:XML = getItemInfo(id);

			if (xml.@hp.length())		hp		= xml.@hp;
			if (xml.@mana.length())		mana	= xml.@mana;
			if (xml.@magic.length())	magic	= xml.@magic;
			if (xml.@culd.length())		culd	= xml.@culd*Engine.TPS;
			if (xml.@dist.length())		dist	= xml.@dist;
			if (xml.@line.length()) 	line	= xml.@line;
			if (xml.@rad.length())		rad		= xml.@rad;
			if (xml.@dam.length())		dam		= xml.@dam;
			if (xml.@prod.length())		prod	= true;
			if (xml.@atk.length())		atk		= true;
			if (xml.@tele.length())		teleSpell = true;
			if (xml.@snd.length())		snd = xml.@snd;

			nazv = TextParser.txt("i", id);

			// What hard-coded function does this spell use
			if (id == "sp_mwall")		cf = cast_mwall;
			if (id == "sp_mshit")		cf = cast_mshit;
			if (id == "sp_blast")		cf = cast_blast;
			if (id == "sp_kdash")		cf = cast_kdash;
			if (id == "sp_slow")		cf = cast_slow;
			if (id == "sp_cryst")		cf = cast_cryst;
			if (id == "sp_moon")		cf = cast_moon;
			if (id == "sp_gwall")		cf = cast_gwall;
			if (id == "sp_invulner")	cf = cast_invulner;
		}

		public static function getItemInfo(id:String):XML {
			if (cachedItems[id] != undefined) {
				return cachedItems[id];
			}

			var node:XML = XMLDataGrabber.getNodeWithAttributeThatMatches("core", "AllData", "items", "id", id);
			if (node) {
				cachedItems[id] = node;
			}

			return node;
		}
		
		public function step():void {
			if (t_culd > 0) {
				t_culd--;
			}
		}
		
		public function cast(nx:Number = 0, ny:Number = 0):Boolean {
			// [checking the possibility of magic and the presence of mana]
			if (cf == null) {
				return false;
			}
			
			if (player) {
				if (GameContainer.reference.alicorn && id!="sp_mshit") {
					return false;
				}
				
				if (gg.rat) {
					return false;
				}
				
				if (gg.invent.equipment.hasWeapon(id) && gg.invent.equipment.getWeapon(id).respect == Weapon.WEP_LOCKED) {
					GUIManager.reference.gui.infoText("disSpell",null,null,false);
					Sound.ps("nomagic");
					
					return false;
				}
				
				if (GameContainer.reference.pers.spellsPoss==0 || atk && !gg.atkPoss) {
					GUIManager.reference.gui.infoText("noSpells",null,null,false);
					Sound.ps("nomagic");
					GUIManager.reference.gui.bulb(owner.coordinates.X, owner.coordinates.Y);
					
					return false;
				}
				
				if (t_culd > 0) {
					if (!active) {
						if (culd >= 100) {
							GUIManager.reference.gui.infoText("spellCuld", Math.ceil(t_culd / Engine.TPS), null, false);
							GUIManager.reference.gui.bulb(owner.coordinates.X, owner.coordinates.Y - 20);
						}
						
						Sound.ps("nomagic");
					}
					
					return false;
				}
				
				dmagic	= magic * GameContainer.reference.pers.allDManaMult;
				dmana	= mana  * GameContainer.reference.pers.allDManaMult;
				
				if (dmagic > 999) {
					dmagic = 999;
				}
				
				if (owner.mana<dmagic) {
					GUIManager.reference.gui.infoText("overMana",null,null,false);
					Sound.ps("nomagic");
					GUIManager.reference.gui.bulb(owner.coordinates.X, owner.coordinates.Y-20);
					
					return false;
				}
				
				if (dmana>GameContainer.reference.pers.manaHP) {
					GUIManager.reference.gui.infoText("noMana",null,null,false);
					Sound.ps("nomagic");
					
					return false;
				}
			}

			// [source coordinates]
			if (owner) {
				X = owner.magicX;
				Y = owner.magicY;
				loc = owner.loc;
				power = owner.spellPower;
				
				if (player && teleSpell) {
					power = gg.pers.telePower;
				}
			}
			else {
				loc = World.w.loc;
			}

			// [target coordinates]
			cx = nx;
			cy = ny;

			// [checking the visibility of the target point, if necessary]
			if (line == 1 && owner && !owner.loc.isLine(X, Y, cx, cy)) {
				if (player) {
					GUIManager.reference.gui.infoText("noVisible", null, null, false);
				}
				
				return false;
			}
			
			// [checking and correcting distance]
			if (dist > 0) {
				var rasst2:Number = (X - cx) * (X - cx) + (Y - cy) * (Y - cy);
				
				if (rasst2 > dist * dist) {
					var rasst:Number = Math.sqrt(rasst2);
					cx = X - (X - cx) * dist / rasst;
					cy = Y - (Y - cy) * dist / rasst;
				}
			}
			
			// [remove mana]
			// [call the required function]
			cf();

			if (est == 1) {
				if (player) {	
					var dmag:Number = magic * gg.pers.warlockDManaMult;
					var dm:Number = mana * gg.pers.warlockDManaMult;
					
					gg.manaSpell(dmag, dm);
					t_culd = Math.round(culd * gg.pers.spellDown);
				}
				
				if (snd) {
					Sound.ps(snd, X, Y);
				}
			}
			else if (est == 0) {
				Sound.ps("nomagic");
				
				return false;
			}
			
			return true;
		}
		
		// [create a magic wall]
		private function cast_mwall():void {
			var un:Unit=loc.createUnit("mwall",cx,cy+60,true);
			
			if (owner) {
				un.fraction=owner.fraction;
			}
			
			un.maxhp = hp * power;
			un.hp = un.maxhp;
		}
		
		// [magic shield]
		private function cast_mshit():void {
			if (owner.player && GameContainer.reference.alicorn) {
				owner.shithp = GameContainer.reference.pers.alicornShitHP;
			}
			else {
				owner.shithp = hp * power;
			}
		}

		// [magic shield]
		private function cast_cryst():void {
			est = 1;
			
			if (player) {
				if (gg.t_cryst > 0) {
					est = 2;
				}

				gg.t_cryst = 5;
			}
		}
		
		// [kinetic dash]
		private function cast_kdash():void {
			if (!owner.loc.levitOn) {
				return;
			}
			
			var v:Vec2 = new Vec2(cx - owner.coordinates.X, cy - owner.coordinates.Y + owner.boundingBox.height);

			var rasst:Number = v.magnitude();
			
			var d:Object = {x:v.X, y:v.Y};
			var spd:Number = dam * (1 + (power - 1) * 0.5);
			var prod:int = 15;
			
			if (spd > rasst / prod) {
				prod = Math.round(rasst / spd) + 1;
			}
			
			if (prod < 7) {
				prod = 7;
			}
			
			owner.norma(d, spd);
			owner.isLaz = E_Direction.NEUTRAL;
			owner.levit = 0;
			
			// Push the caster toward the target point, by at most spd (d, not the full distance v)
			owner.velocity.X += d.x;
			owner.velocity.Y += d.y;

			if (player) {
				gg.kdash_t = prod;
				gg.t_levitfilter = 20;
			}
		}
		
		// [kinetic explosion]
		private function cast_blast():void {
			if (loc == null) {
				return;
			}
			
			X = owner.coordinates.X;
			Y = owner.coordinates.Y;
			
			for each(var un:Unit in loc.units) {
				if (un.fixed || un.fraction == owner.fraction || !owner.isMeet(un)) {
					continue;
				}
				
				var v:Vec2 = new Vec2();
				
				v.X = un.coordinates.X - X;
				v.Y = un.coordinates.Y - un.boundingBox.halfHeight - Y;
				var rad2:Number=(v.X * v.X + v.Y * v.Y);
				
				if (rad2 > rad * rad) {
					continue;
				}

				rad2 = Math.sqrt(rad2);
				var sila:Number = dam * power * (1 - rad2 / rad) * (Math.random() * 0.40 + 0.80) * un.knocked / un.massa;
				
				if (sila > dam * power) {
					sila = dam * power;
				}
				
				v.divide(rad2);
				v.multiply(sila);
				un.velocity.setVector(v);
				
				un.stun += int(Math.random() * power * dam);
				un.t_throw = 30;
			}
			
			if (owner.player) {
				loc.budilo(X, Y, 500);
			}
			
			if (loc.active) {
				Emitter.emit("blast", loc, X, Y);
			}
			
			if (loc.active) {
				World.w.quake(Math.random() * 30 - 10, Math.random() * 10 - 5);
			}
		}
		
		// [slowing field]
		private function cast_slow():void {
			if (owner) {
				owner.addEffect("inhibitor", rad * power);
			}
		}
		
		// [moon blade]
		private function cast_moon():void {
			if (gg.currentPet != "moon") {
				gg.pets["moon"].hp = gg.pets["moon"].maxhp;
				gg.callPet("moon", true);
			}
			else if (gg.pet) {
				gg.pet.heal(gg.pet.maxhp);
			}
		}
		
		// [ghost wall]
		public function gwall(nx:Number, ny:Number):void {
			var t:Tile = loc.getAbsTile(nx, ny);
			
			if (loc.testTile(t)) {
				t.collision = 3;
				t.hp = Math.round(hp * power);
				t.material = E_Material.FORCE_FIELD;
				t.ghostTimer = Math.round(dam * power);
				GameContainer.reference.grafon.gwall(t.coords.X, t.coords.Y);
				est = 1;
			
			}
			
			Emitter.emit("gwall", loc,(t.coords.X + 0.5) * Tile.tileX, (t.coords.Y + 0.5) * Tile.tileY);
		}
		
		// [ghost wall]
		private function cast_gwall():void {
			est = 0;
			gwall(cx, cy - 40);				
			gwall(cx, cy);				
			gwall(cx, cy + 40);				
			
			if (est > 0) {
				loc.t_gwall = Engine.TPS;
			}
		}
		
		// (Blood shield?)
		private function cast_invulner():void {
			if (owner && player) {
				if (gg.pers.bloodHP <= dam * 3) {
					est = 0;
				}
				else {
					owner.addEffect("bloodinv");
					gg.pers.bloodDamage(dam, E_Resistances.DAM_BLEED);
					est = 1;
				}
			}
		}
	}
}
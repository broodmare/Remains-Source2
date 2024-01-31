package fe.unit
{
	import fe.*;
	import fe.util.Vector2;
	import fe.loc.Location;
	import fe.loc.Tile;
	import fe.graph.Emitter;

	public class Spell
	{	
		public var owner:Unit;
		public var gg:UnitPlayer;
		public var loc:Location;
		public var id:String;
		public var nazv:String;
		public var xml:XML;
		public var player:Boolean=false;		//заклинание относится к гг
		//положение источника
		public var X:Number=0;
		public var Y:Number=0;		
		public var cx:Number=0, cy:Number=0;	//положение цели
		public var power:Number=1;				//множитель силы заклинания
		public var prod:Boolean=false;			//продолжительное
		public var atk:Boolean=false;			//запрещено, когда запрещена атака
		public var active:Boolean=false;
		public var teleSpell:Boolean=false;		//заклинание телекинеза
		var est:int=1;							//результат каста
		
		public var magic:Number=0, dmagic:Number=0;	// [how much mana does it require]
		public var mana:Number=0, dmana:Number=0;	// [how much mana does it require]

		// Cooldown
		public var culd:int=0;					
		public var t_culd:int=0;
		
		public var hp:Number=300;		// [Spell HP]
		public var dist:Number=0;		// [Maximum spell distance]
		public var rad:Number=0;		// [Spell radius]
		public var dam:Number=0;		// [Apell action]
		public var line:int=0;			// [Target visibility requirement]
		
		public var cf:Function;
		
		public var snd:String;

		private static var cachedItems:Object = {};

		public function Spell(own:Unit, nid:String)
		{
			id = nid;
			owner = own;

			if (owner && owner.player)
			{
				player = true;
				gg = owner as UnitPlayer;
			}
			var xml:XML = getItemInfo(id);

			if (xml.@hp.length())		hp		= xml.@hp;
			if (xml.@mana.length())		mana	= xml.@mana;
			if (xml.@magic.length())	magic	= xml.@magic;
			if (xml.@culd.length())		culd	= xml.@culd*World.fps;
			if (xml.@dist.length())		dist	= xml.@dist;
			if (xml.@line.length()) 	line	= xml.@line;
			if (xml.@rad.length())		rad		= xml.@rad;
			if (xml.@dam.length())		dam		= xml.@dam;
			if (xml.@prod.length())		prod	= true;
			if (xml.@atk.length())		atk		= true;
			if (xml.@tele.length())		teleSpell = true;
			if (xml.@snd.length())		snd = xml.@snd;

			nazv = Res.txt('i', id);

			if (id == 'sp_mwall')		cf = cast_mwall;
			if (id == 'sp_mshit')		cf = cast_mshit;
			if (id == 'sp_blast')		cf = cast_blast;
			if (id == 'sp_kdash')		cf = cast_kdash;
			if (id == 'sp_slow')		cf = cast_slow;
			if (id == 'sp_cryst')		cf = cast_cryst;
			if (id == 'sp_moon')		cf = cast_moon;
			if (id == 'sp_gwall')		cf = cast_gwall;
			if (id == 'sp_invulner')	cf = cast_invulner;
		}

		public static function getItemInfo(id:String):XML
		{
			if (cachedItems[id] != undefined) return cachedItems[id];

			var node:XML = XMLDataGrabber.getNodeWithAttributeThatMatches("core", "AllData", "items", "id", id);
			if (node) cachedItems[id] = node;

			return node;
		}
		
		public function step():void
		{
			if (t_culd > 0) t_culd--;
		}
		
		public function cast(nx:Number=0, ny:Number=0):Boolean
		{
			// [checking the possibility of magic and the presence of mana]
			if (cf==null) return false;
			
			if (player)
			{
				if (World.w.alicorn && id!='sp_mshit') return false;
				if (gg.rat>0) return false;
				if (gg.invent.weapons[id] && gg.invent.weapons[id].respect==1) {
					World.w.gui.infoText('disSpell',null,null,false);
					Snd.ps('nomagic');
					return false;
				}
				if (World.w.pers.spellsPoss==0 || atk && !gg.atkPoss) {
					World.w.gui.infoText('noSpells',null,null,false);
					Snd.ps('nomagic');
					World.w.gui.bulb(owner.coordinates.X, owner.coordinates.Y);
					return false;
				}
				if (t_culd > 0)
				{
					if (!active)
					{
						if (culd >= 100)
						{
							World.w.gui.infoText('spellCuld', Math.ceil(t_culd / World.fps), null, false);
							World.w.gui.bulb(owner.coordinates.X, owner.coordinates.Y - 20);
						}
						Snd.ps('nomagic');
					}
					return false;
				}
				dmagic=magic*World.w.pers.allDManaMult;
				dmana=mana*World.w.pers.allDManaMult;
				if (dmagic>999) dmagic=999;
				if (owner.mana<dmagic) {
					World.w.gui.infoText('overMana',null,null,false);
					Snd.ps('nomagic');
					World.w.gui.bulb(owner.coordinates.X, owner.coordinates.Y-20);
					return false;
				}
				if (dmana>World.w.pers.manaHP) {
					World.w.gui.infoText('noMana',null,null,false);
					Snd.ps('nomagic');
					return false;
				}
			}

			// [source coordinates]
			if (owner)
			{
				X = owner.magicX;
				Y = owner.magicY;
				loc = owner.loc;
				power = owner.spellPower;
				if (player && teleSpell) power = gg.pers.telePower;
			}
			else loc = World.w.loc;

			// [target coordinates]
			cx = nx;
			cy = ny;

			// [checking the visibility of the target point, if necessary]
			if (line==1 && owner && !owner.loc.isLine(X,Y, cx, cy))
			{
				if (player) World.w.gui.infoText('noVisible', null, null, false);
				return false;
			}
			// [checking and correcting distance]
			if (dist>0) {
				var rasst2=(X-cx)*(X-cx)+(Y-cy)*(Y-cy);
				if (rasst2>dist*dist) {
					var rasst=Math.sqrt(rasst2);
					cx=X-(X-cx)*dist/rasst;
					cy=Y-(Y-cy)*dist/rasst;
				}
			}
			// [remove mana]
			// [call the required function]
			cf();

			if (est == 1)
			{
				if (player)
				{	
					var dmag:Number = magic * gg.pers.warlockDManaMult;
					var dm:Number = mana * gg.pers.warlockDManaMult;
					
					gg.manaSpell(dmag, dm);
					t_culd = Math.round(culd * gg.pers.spellDown);
				}
				if (snd) Snd.ps(snd, X, Y);
			}
			else if (est == 0)
			{
				Snd.ps('nomagic');
				return false;
			}
			return true;
		}
		
		//создать магическую стену
		private function cast_mwall():void {
			var un:Unit=loc.createUnit('mwall',cx,cy+60,true);
			if (owner) un.fraction=owner.fraction;
			un.maxhp=hp*power;
			un.hp=un.maxhp;
		}
		
		//магический щит
		private function cast_mshit():void {
			if (owner.player && World.w.alicorn) owner.shithp=World.w.pers.alicornShitHP;
			else owner.shithp=hp*power;
		}
		//магический щит
		private function cast_cryst():void {
			est=1;
			if (player) {
				if (gg.t_cryst>0) est=2;
				gg.t_cryst=5;
			}
		}
		
		//кинетический рывок
		private function cast_kdash():void
		{
			if (!owner.loc.levitOn) return;
			var dx:Number=(cx - owner.coordinates.X);
			var dy:Number=(cy - owner.coordinates.Y + owner.objectHeight);
			var rasst:Number = Math.sqrt(dx * dx + dy * dy);
			var d:Object={x:dx, y:dy};
			var spd:Number=dam*(1+(power-1)*0.5);
			var prod:int=15;
			if (spd>rasst/prod) prod=Math.round(rasst/spd)+1;
			if (prod<7) prod=7;
			owner.norma(d,spd);
			owner.isLaz=0;
			owner.levit=0;
			owner.dx+=d.x;
			owner.dy+=d.y;
			if (player) {
				gg.kdash_t=prod;
				gg.t_levitfilter=20;
			}
		}
		
		//кинетический взрыв
		private function cast_blast():void {
			if (loc==null) return;
			X = owner.coordinates.X;
			Y = owner.coordinates.Y;
			for each(var un:Unit in loc.units)
			{
				if (un.fixed || un.fraction==owner.fraction || !owner.isMeet(un)) continue;
				var dx:Number = un.coordinates.X - X;
				var dy:Number = un.coordinates.Y - un.objectHeight / 2 - Y;
				var rad2:Number=(dx*dx+dy*dy);
				if (rad2>rad*rad) continue;
				rad2=Math.sqrt(rad2);
				var sila:Number=dam*power*(1-rad2/rad)*(Math.random()*0.4+0.8)*un.knocked/un.massa;
				if (sila>dam*power) sila=dam*power;
				un.dx = dx / rad2 * sila;
				un.dy = dy / rad2 * sila;
				un.stun+=int(Math.random()*power*dam);
				un.t_throw=30;
			}
			if (owner.player) loc.budilo(X,Y,500);
			if (loc.active) Emitter.emit('blast',loc,X,Y);
			
			if (loc.active) World.w.quake(Math.random()*30-10,Math.random()*10-5);
		}
		
		//замедляющее поле
		private function cast_slow():void {
			if (owner) owner.addEffect('inhibitor', rad * power);
		}
		
		//лунный клинок
		private function cast_moon():void
		{
			if (gg.currentPet != 'moon')
			{
				gg.pets['moon'].hp = gg.pets['moon'].maxhp;
				gg.callPet('moon', true);
			}
			else if (gg.pet) gg.pet.heal(gg.pet.maxhp);
		}
		
		public function gwall(nx, ny):void
		{
			var t:Tile = loc.getAbsTile(nx, ny);
			if (loc.testTile(t))
			{
				t.phis = 3;
				t.hp = Math.round(hp * power);
				t.mat = 7;
				t.t_ghost = Math.round(dam * power);
				World.w.grafon.gwall(t.X, t.Y);
				est=1;
			}
			Emitter.emit('gwall',loc,(t.X+0.5)*Tile.tileX,(t.Y+0.5)*Tile.tileY);
					}
		
		private function cast_gwall():void {
			est=0;
			gwall(cx,cy-40);				
			gwall(cx,cy);				
			gwall(cx,cy+40);				
			if (est>0) loc.t_gwall=World.fps;
		}
		
		//замедляющее поле
		private function cast_invulner():void {
			if (owner && player) {
				if (gg.pers.bloodHP<=dam*3) {
					est=0;
				} else {
					owner.addEffect('bloodinv');
					gg.pers.bloodDamage(dam,Unit.D_BLEED);
					est=1;
				}
			}
		}
	}
}
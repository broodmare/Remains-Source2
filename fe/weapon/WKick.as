package fe.weapon  {

	import fe.SymbolFactory;
	import fe.util.Vec2;
	import fe.World;
	import fe.Snd;
	import fe.unit.Unit;
	import fe.loc.tile.Tile;
	import fe.projectile.Bullet;
	import fe.enums.E_Direction;
	
	public class WKick extends Weapon {

		public var kick:Boolean = true;
		
		// Use WeaponManager.cloneWeapon() to create weapons
		public function WKick() {
			super();
		}
		
		public override function init(data:Object):void {
			vBullet = SymbolFactory.fetchSymbolClass("visualPunch");
			dopCh = 0;
			dopEffect = 'stun';
		}
		
		// The weapon's bullet needs to know its owner, so it's created once the owner is set
		public override function setOwner(own:Unit):void {
			if (own == null || own == owner) {
				super.setOwner(own);
				return;
			}
			
			super.setOwner(own);
			
			var v:Vec2 = new Vec2((coordinates.X - (dlina * 0.50) * storona.X), (coordinates.Y - dlina));
			b = new Bullet(owner, v, null, false);
			b.weap = this;
			setBullet(b);
		}
		
		public override function actions():void {
			var reachX:Number;
			var startX:Number;
			var i:int;

			coordinates.setVector(owner.coordinates);
			storona = owner.storona;
			
			if (t_attack > 0) {
				t_attack--;
			}
			
			if (t_attack == rapid - 8) {
				b.retDam = true;
				b.off = false;
				b.tilehit = false;
				b.loc = owner.loc;
				b.knocky = -0.10;
				b.knockx = storona.X;
				b.parrDict = null;
				b.dist = 0;
				b.damage = damage * World.w.pers.punchDamMult;
				b.otbros = otbros * World.w.pers.punchDamMult;
				b.destroy = destroy;
				b.probiv = 1;
				var vverh:Boolean = false;
				
				if (World.w.pers.punchDamMult > 1) {
					dopCh = World.w.pers.punchDamMult - 1;
					dopDamage = 30;
				}
				
				if (kick) {
					storona = E_Direction.opposite(owner.storona);
					var t1:Tile = owner.loc.getAbsTile(coordinates.X + storona.X * 60, coordinates.Y - 30);
					var t2:Tile = owner.loc.getAbsTile(coordinates.X + storona.X * 60, coordinates.Y - 50);
					
					if (t1 && t2 && t2.damageThreshold<t1.damageThreshold) {
						vverh = true;
					}
					
					b.knockx = storona.X;
					b.damage *= 2;
					b.otbros *= 1.50;
					b.destroy = World.w.pers.kickDestroy;
					dopDamage = 60;
					
					reachX = coordinates.X + storona.X * 70;
					startX = coordinates.X + storona.X * 20;

					if (vverh) {
						b.bindMoveTo(reachX, coordinates.Y - 50, startX, coordinates.Y - 50);
						b.bindMoveTo(reachX, coordinates.Y - 30, startX, coordinates.Y - 30);
					}
					else {
						b.bindMoveTo(reachX, coordinates.Y - 30, startX, coordinates.Y - 30);
						b.bindMoveTo(reachX, coordinates.Y - 50, startX, coordinates.Y - 50);
					}
					
					Snd.ps('m_big', coordinates.X, coordinates.Y, 0, Math.random() * 0.2 + 0.1);
				}
				else {
					var t3:Tile = owner.loc.getAbsTile(coordinates.X + storona.X * 60, coordinates.Y - 30);
					var t4:Tile = owner.loc.getAbsTile(coordinates.X + storona.X * 60, coordinates.Y - 50);
					
					if (t3 && t4 && t4.damageThreshold < t3.damageThreshold) {
						vverh = true;
					}
					
					reachX = coordinates.X + storona.X * 60;
					startX = coordinates.X + storona.X * 20;

					if (vverh) {
						b.bindMoveTo(reachX, coordinates.Y - 50, startX, coordinates.Y - 50);
					}

					b.bindMoveTo(reachX, coordinates.Y - 30, startX, coordinates.Y - 30);

					for (i = 1; i <= 5; i++) {
						if (i != 3 && !(vverh && i == 5)) {
							b.bindMoveTo(reachX, coordinates.Y - i * 10, startX, coordinates.Y - i * 10);
						}
					}
					
					Snd.ps('m_med', coordinates.X, coordinates.Y, 0, Math.random() * 0.2 + 0.1);
				}
			}
		}

		public override function attack(waitReady:Boolean = false):Boolean {
			if (t_attack <= 0) {
				t_attack = rapid;
			}
			
			return true;
		}
		
		public override function animate():void {

		}
	}	
}
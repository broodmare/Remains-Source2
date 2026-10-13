package fe.game.domain.units {

	import flash.display.MovieClip;

	import fe.engine.utils.SymbolFactory;
	import fe.GameContainer;
	import fe.game.WeaponManager;
	import fe.game.enums.E_Material;
	import fe.game.enums.E_Direction;
	
	public class UnitThunderTurret extends Unit {

		public var head:UnitThunderHead;
		public var bindX:Number				= 0.00;
		public var bindY:Number				= 0.00;
		public var tr:int;
		
		private var attTurN:int				= 15;
		private var t_wait:int				= 0;

		public function UnitThunderTurret(cid:String = null, ndif:Number = 100.00, xml:XML = null, loadObj:Object = null) {
			super(cid, ndif, xml, loadObj);
			
			id = "ttur";
			tr = int(cid);
			
			getXmlParam();
			
			vis = SymbolFactory.createInstance("visualTTurret") as MovieClip;
			vis.osn.scaleX = 3;
			vis.osn.scaleY = 3;
			vis.osn.pole.visible = false;
			
			mater = false;
			mat = E_Material.METAL;
			fixed = true;
			nazv = "";
			friendlyExpl = 0;
			currentWeapon = WeaponManager.reference.cloneWeapon("ttweap" + tr, this);
			childObjs = new Array(currentWeapon);
			t_wait = Math.round(Math.random() * 100);
		}
		
		public function mega():void {
			vis.osn.pole.visible = true;
			invulner = true;
			hp = maxhp = maxhp * 10;
		}
		
		public override function run(div:int=1):void {
			if (head) {
				coordinates.X = head.coordinates.X + bindX;
				coordinates.Y = head.coordinates.Y + bindY;
			}
			
			boundingBox.center(coordinates);
			setVisPos();
		}
		
		override protected function control():void {
			if (head == null || loc == null) {
				return;
			}
			
			if (sost > 1 || head.sost > 1) {
				return;
			}
			
			if (head.isAtt && coordinates.X > 200 && coordinates.Y > 200 && coordinates.X < loc.maxX - 200 && coordinates.Y < loc.maxY - 200) {
				if (t_wait>0) {
					t_wait--;
					return;
				}
				
				currentWeapon.reloadMult = 1 / head.reloadDiv;
				setCel(GameContainer.reference.gg);
				storona = (celDX > 0) ? E_Direction.RIGHT : E_Direction.LEFT;
				currentWeapon.attack();
				
				if (isShoot) {
					head.attTur = attTurN;
					isShoot = false;
				}
			}
		}
		
		public override function setLevel(nlevel:int=0):void {
			if (GameContainer.reference.game.globalDif == 3) {
				hp = maxhp = hp * 1.5;
			}
			else if (GameContainer.reference.game.globalDif == 4) {
				hp = maxhp = hp * 2;
			}
		}
		
		public override function expl():void {
			head.dieTurret();
			newPart("metal", 4);
			newPart("expl");
		}
		
		public override function animate():void {
			if (sost > 1) {
				return;
			}
		}

		public override function setVisPos():void {
			if (vis) {
				vis.x = coordinates.X;
				vis.y = coordinates.Y;
				currentWeapon.vis.x = coordinates.X;
				currentWeapon.vis.y = coordinates.Y - boundingBox.halfHeight;
			}
		}

		public override function makeNoise(n:int, hlup:Boolean=false):void {
			
		}

		public override function setHpbarPos():void {
			hpbar.y = coordinates.Y - 140;
			hpbar.x = coordinates.X;
			
			if (loc && loc.zoom!=1) {
				hpbar.scaleX=hpbar.scaleY=loc.zoom;
			}
		}
	}
}
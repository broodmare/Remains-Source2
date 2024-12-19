package fe.projectile
{
	import flash.utils.Dictionary;

	import fe.*;
	import fe.util.Calc;
	import fe.util.Vector2;
	import fe.unit.Unit;
	import fe.loc.*;
	import fe.entities.Obj;
	import fe.graph.Emitter;
	import fe.unit.UnitMsp;
	import fe.weapon.Weapon;
	
	public class Bullet extends Obj {	
		//типы реакции на попадание
		//-1 - промах, пуля летит дальше
		//0 - попал, пуля исчезла
		//1 - попал в твёрдую поверхность (металл или камень)
		//2 - попал в мясо
		//3 - ?
		
		protected var vse:Boolean=false;
		
		public var owner:Unit;
		public var weap:Weapon;
		public var weapId:String;
		public var tipBullet:int=0;	//тип пули. 0-обычная, 1-холодное оружие
		public var rot:Number=0, vel:Number=15, liv:int=100, begx:Number, begy:Number, knockx:Number, knocky:Number;
		public var ddy:Number=0, ddx:Number=0, accel:Number=0, brakeR:Number=0, vRot:Boolean=false;
		public var celX:Number = -100000;
		public var celY:Number = -100000;
		public var inWater:int = -1;
		public var isExpl:Boolean = false;
		
		public var partEmit:Boolean=true;	
		public var spring:int=1;
		public var flame:int=0;
		public var flare:String;
		public var outspace:Boolean=false;
		
		public var otbros=0;
		public var probiv:Number = 0;
		public var parrDict:Dictionary;	// List of objects the bullet has already interacted with.
		
		public var babah:Boolean=false, tilehit:Boolean=false;
		public var off:Boolean=false;	//отключить урон по юнитам
		public var checkLine:Boolean=false;	
		public var dist:Number=0;
		
		public var destroy:Number = 0;	//урон блокам
		public var crack:int = 0;			//взлом контейнеров
		var box:Box;
		public var tileX:int = -1;
		public var tileY:int = -1;	//урон блокам для холодного оружия (координаты, на которые указывает курсор)
		public var damage:Number = 0;
		public var pier:Number = 0;		//бронебойность
		public var armorMult:Number = 1;	//модификатор действия брони
		public var tipDamage:int = 0;
		public var tipDecal:int = 0;
		public var precision:Number = 0;	// [accuracy, shows the distance at which the hit will be 100%, 0 if the hit is always]
		public var antiprec:Number = 0;		// [for sniper rifles, shows the distance at which accuracy will begin to decrease]
		public var miss:Number=0;			// [absolute miss probability]
		public var desintegr:Number=0;		// [probability of disintegration]
		
		public var critCh:Number=0;	//шанс крита
		public var critInvis:Number=0;	//шанс крита для мобов, у которых не установлена цель
		public var critDamMult:Number=1;	//множитель критического урона
		public var critM:Number=0;	//дополнительный крит
		
		public var explTip:int=1;		//тип взрыва, 1-обычный, 2-облако газа, 3-забрызгивание
		public var explKol:int=0;		//количество взрывов, интервал 1с, 0 - мгновенный взрыв
		public var explPeriod:int=10;
		public var damageExpl:Number=0;	//урон по площади
		public var explRadius:Number=0;	//радиус взрыва, если 0, то взрыва нет
		public var targetObj:Obj;		//объект назначения
		public var inWall:Boolean=false;
		var expl_t:int=0;
		
		public var retDam:Boolean=false;	//возврат урона

		private static var constTileX:int = Tile.tileX;
		private static var constTileY:int = Tile.tileY;

		public function Bullet(own:Unit, nx:Number, ny:Number, visClass:Class=null, addobj:Boolean=true)
		{
			if (own==null)
			{
				owner=new Unit();
				loc=World.w.loc;
			}
			else
			{
				owner=own;
				loc=own.loc;
			}
			coordinates.X = begx = nx;
			coordinates.Y = begy = ny;
			sloy=2;
			levitPoss=false;
			if (visClass) {
				if (World.w.alicorn && own.player && visClass == visualBullet) visClass=visualRainbow;
				vis=new visClass();
				vis.stop();
				vis.x = coordinates.X;
				vis.y = coordinates.Y;
				vis.visible=false;
			}
			if (addobj) loc.addObj(this);
		}
		
		public override function step() {
			
			if (!babah) {
				velocity.X += ddy;
				velocity.Y += ddx;
				if (vRot) rot=Math.atan2(velocity.Y, velocity.X);
				if (brakeR && dist>brakeR) {
					vRot=true;
					velocity.multiply(0.9);
					vel *= 0.9;
				}
				if (vRot) rot = Math.atan2(velocity.Y, velocity.X);
				if (Math.abs(velocity.X)<World.maxdelta && Math.abs(velocity.Y)<World.maxdelta)	run();
				else {
					var div = int(Math.max(Math.abs(velocity.X), Math.abs(velocity.Y)) / World.maxdelta) + 1;
					for (var i:int = 0; (i < div && !babah); i++) {
						run(div);
					}
				}
			}

			if (vis) {
				vis.x = coordinates.X;
				vis.y = coordinates.Y;
				vis.rotation=rot*180/Math.PI;
				if (vis.laser && (spring>=2)) {
					vis.laser.scaleX=Math.sqrt((coordinates.X - begx) * (coordinates.X - begx) + (coordinates.Y - begy) * (coordinates.Y - begy))/100;
				}
				else if (spring==1 && vel>100) {
					if (!babah) {
						vis.scaleX=vel/100;
					}
				}
				else {
					vis.scaleX=1;
				}
				vis.visible=true;
				if (liv<4 && vis.laser) {
					vis.alpha=liv/4;
					if (weap) {
						weap.getBulXY();
						vis.x = coordinates.X + weap.bulX - begx;
						vis.y = coordinates.Y + weap.bulY - begy;
					}
				}
			}

			if (expl_t>0) {
				expl_t--;
			}
			else {
				liv--;
			}

			if (expl_t>0 && expl_t%explPeriod==1) {
				explRun();
			}

			if (liv<=0 && !vse && explRadius>0) {
				explosion();
			}

			if (liv<=0 || loc!=owner.loc) {
				vse=true;
			}

			if (vse) {
				loc.remObj(this);
			}
		}
		
		public override function setNull(f:Boolean=false) {
			loc.remObj(this);
		}
		
		public override function err():String {
			if (loc) loc.remObj(this);
			return 'Error bullet '+(owner?owner.nazv:'???')+' '+(weap?weap.nazv:'???');
		}
		
		public override function bindMove(nx:Number,ny:Number, ox:Number=-1, oy:Number=-1) {
			if (ox >= 0) coordinates.X = ox;
			if (oy >= 0) coordinates.Y = oy;
			velocity.subtractVectors(coordinates.getVector2());
			vel = Math.sqrt(velocity.X * velocity.X + velocity.Y * velocity.Y);
			if (Math.abs(velocity.X)<World.maxdelta && Math.abs(velocity.Y)<World.maxdelta)	run();
			else {
				var div = int(Math.max(Math.abs(velocity.X),Math.abs(velocity.Y))/World.maxdelta)+1;
				for (var i:int = 0; i < div; i++) {
					run(div);
				}
			}
		}
		
		//[Returns the bullet's own probability of hitting, depending on the distance traveled and accuracy]
		public function accuracy():Number {
			if (precision == 0) return 1;	// If the bullet should always hit, return '1'
			if (antiprec > 0 && dist < antiprec) return dist / antiprec * 0.75 + 0.25;
			return precision / dist;
		}
		
		//[the bullet hit the target]
		//[target.udarBullet returns res result]
		//-1 - [miss]
		public function popadalo(res:int=0) {
			if (res < 0) return;			//[missed]
			
			if (explRadius) {
				explosion();
				if (vis) vis.visible=false;
			}
			else if (tipDecal>0 && tipDecal<=6) {				//[bullet or blow] (Melee impact?)
				if (res==1 || res==2 || res==5 || res==7) {		// [hitting metal or concrete]
					if (vis) vis.gotoAndPlay(2);
					var koliskr:int = Calc.intBetween(0, 5) + int(damage / 5);
					if (World.w.alicorn) koliskr *= 0.2;
					if (koliskr > 20) koliskr = 20;
					Emitter.emit('iskr_bul', loc, coordinates.X, coordinates.Y, {dx:-velocity.X / vel * 10, dy:-velocity.Y / vel * 10, kol:koliskr});
					if (flare!=null && flare!='') Emitter.emit(flare, loc, coordinates.X, coordinates.Y);
				}
				else if (res == 3 || res == 4) {	//[hitting meat or wood]
					if (vis && dist < vel) {
						vis.scaleX = dist / 100;
					}
				}
				else {
					if (vis && dist<vel) vis.visible = false;
				}
			}
			else if ((flare != null && flare != '') && res > 0) {
				Emitter.emit(flare, loc, coordinates.X, coordinates.Y);
			}

			if (liv > 4) {
				liv = 4;
			}

			babah = true;
		}
		
		// [returns false if the object is already in the list of objects with which the bullet has already interacted]
		// [if not, then adds it to the list and returns true]
		// I changed this to a dictionary for O1 searches on bullet hits, but I'm not sure if there'd ever be enough targets in the list
		// To justify the overhead of creating a new dictionary for every bullet?
		public function udar(un):Boolean {
			if (parrDict == null) parrDict = new Dictionary();
			if (parrDict[un] === true) {
				return false;
			}
			else {
				parrDict[un] = true;
				return true;
			}
		}
		

		public function run(div:int=1):void {
			dist += vel / div;
			var v:Vector2 = new Vector2(velocity.X, velocity.Y);
			v.divide(div);
			coordinates.sumVector(v.getVector2());
			
			if (loc.sky && (coordinates.X < 0 || coordinates.X >= loc.maxX || coordinates.Y < 0 || coordinates.Y >= loc.maxY)) {
				popadalo(0);
			}
			else {
				if (!outspace && coordinates.X < 0 || coordinates.X >= loc.spaceX * constTileX || coordinates.Y < 0 || coordinates.Y >= loc.spaceY * constTileY) popadalo(0);

				var t:Tile = loc.getAbsTile(coordinates.X, coordinates.Y);
				if (t.water > 0) {
					if (inWater == 0) {
						if (partEmit && (tipDamage==Unit.D_BUL || tipDamage==Unit.D_PHIS || tipDamage==Unit.D_BLADE)) {
							Emitter.emit('kap', loc, coordinates.X, coordinates.Y,{
								dx: -velocity.X / vel * 10,
								dy: -velocity.Y / vel * 10,
								kol: Math.floor(Calc.intBetween(0, 4) + damage / 5)
							});
							sound(11);
							partEmit=false;
						}
					}
					if (tipDamage==Unit.D_FIRE || tipDamage==Unit.D_LASER || tipDamage==Unit.D_PLASMA || tipDamage==Unit.D_SPARK || tipDamage==Unit.D_ACID) {
						if (partEmit) {
							Emitter.emit('steam', loc, coordinates.X, coordinates.Y);
							partEmit=false;
						}
						popadalo(0);
					}
					inWater = 1;
				}
				else {
					if (inWater == 1) {
						if (partEmit && (tipDamage == Unit.D_BUL || tipDamage == Unit.D_PHIS || tipDamage == Unit.D_BLADE)) {
							Emitter.emit('kap', loc, coordinates.X, coordinates.Y, {
								dx: velocity.X / vel * 10,
								dy: velocity.Y / vel * 10,
								kol: Calc.intBetween(0, 4) + int(damage / 5)
							});
							sound(11);
							partEmit = false;
						}
					}
					inWater = 0;
				}
				if (!tilehit && (tileX < 0 || int(coordinates.X / constTileX) == tileX && int(coordinates.Y / constTileY) == tileY) && (t.phis == 1 || t.phis == 2 && int(coordinates.X / constTileX) == tileX && int(coordinates.Y / constTileY) == tileY) && coordinates.X >= t.phX1 && coordinates.X <= t.phX2 && coordinates.Y >= t.phY1 && coordinates.Y <= t.phY2) {
					if (!inWall) {
						popadalo(t.mat);
						sound(t.mat);
						if (weap) weap.crash();
						owner.crash(this);
						if (explRadius == 0) loc.hitTile(t, destroy, coordinates.X, coordinates.Y, tipDecal);
						tilehit = true;
					}
				}
				else inWall = false;
			}

			if (off) {
				return;
			}

			for each(var un:Unit in loc.units) {
				if (targetObj) {
					if (targetObj is Unit) un = targetObj as Unit;
					else break;
				}

				if (un.sost == 4 || un.disabled || un.trigDis || un.loc != loc) continue;
				
				if ((targetObj || un.fraction != owner.fraction) && coordinates.X >= un.leftBound && coordinates.X <= un.rightBound && coordinates.Y >= un.topBound && coordinates.Y <= un.bottomBound) {
					if (checkLine && weap && !weap.isLine(coordinates.X, coordinates.Y)) {	//проверить досягаемость до объекта
						off = true;
						return;
					}

					if (un.dopTestOn && !un.dopTest(this)) continue;

					if (udar(un)) {	//если эта пуля ещё не взаимодействовала с этим объектом
						var res = un.udarBullet(this); //попасть по объекту, проверить, не уклонился ли объект
						sound(res);
						if (!(probiv > 0 && damage > 0) && res >= 0) {	//[If the bullet penetrates, let it keep going. Otherwise, destroy the bullet]
							popadalo(res);
							if (weap) {
								if ((un is fe.unit.Mine || un is fe.unit.UnitMsp) && un.sost > 2) weap.crash(15);
								else if (un.tipDamage == Unit.D_ACID) weap.crash(3);
								else weap.crash();
							}
							break;
						}
					}
				}
				if (targetObj) break;
			}
			
			if (loc.celObj && (loc.celObj is Box) && crack && owner && owner.player) {//взлом контейнера
				box = loc.celObj as Box;
				if (coordinates.X >= box.leftBound && coordinates.X <= box.rightBound && coordinates.Y >= box.topBound && coordinates.Y <= box.bottomBound && udar(box)) {
					res = box.udarBullet(this, 1);
					sound(res);
					if (res>=0) {
						popadalo(res);
						if (weap) weap.crash();
					}
					if (box.dead && weap) weap.crash(box.montdam);
				}
			}
			
			if (World.w.gg.loc==loc && World.w.gg.teleObj && (World.w.gg.teleObj is Box) && owner!=World.w.gg) {
				box=World.w.gg.teleObj as Box;
				if (coordinates.X >= box.leftBound && coordinates.X <= box.rightBound && coordinates.Y >= box.topBound && coordinates.Y <= box.bottomBound && udar(box)) {
					res = box.udarBullet(this,0);
					sound(res);

					if (res >= 0) {
						popadalo(res);
					}
				}
			}

			if (celX >- 10000 && celY >- 10000 && explRadius > 0) {
				if (Math.abs(celX - coordinates.X) < 50 && Math.abs(celY - coordinates.Y) < 200 && Math.random() < 0.3) popadalo(100);
			}
			
		}
		
		private function sound(res:int):void {
			if (weap && weap.sndHit != '') {
				Snd.ps(weap.sndHit, coordinates.X, coordinates.Y);
			}
			if (tipDecal <= 0 || tipDecal > 6) {
				return;
			}
			if (Snd.hitTimer <= 0) {
				if (res==1) Snd.ps('hit_metal', coordinates.X, coordinates.Y, 0, 0.4);
				if (res==2 || res==4 || res==6) Snd.ps('hit_concrete', coordinates.X, coordinates.Y, 0, 0.5);
				if (res==3) Snd.ps('hit_wood', coordinates.X, coordinates.Y, 0, 0.5);
				if (res==5) Snd.ps('hit_glass', coordinates.X, coordinates.Y, 0, 0.5);
				if (res==7) Snd.ps('hit_pole', coordinates.X, coordinates.Y, 0, 0.5);
				if (res==10)
				{
					if (tipDamage == Unit.D_BUL) Snd.ps('hit_bullet', coordinates.X, coordinates.Y, 0, 0.8);
					else if (tipDamage==Unit.D_BLADE) Snd.ps('hit_blade', coordinates.X, coordinates.Y, 0, 0.8);
					else Snd.ps('hit_flesh', coordinates.X, coordinates.Y, 0, 0.5);		//удары по мясу
				}
				if (res==11) Snd.ps('hit_water', coordinates.X, coordinates.Y, 0, 0.5);
				if (res==12) Snd.ps('hit_slime', coordinates.X, coordinates.Y, 0, 0.5);		//удары по слизи
				Snd.hitTimer = Calc.intBetween(3, 6);
			}
		}
		
		//запустить процесс взрыва
		public function explosion():void {
			if (isExpl) return;

			var t:Tile = loc.getAbsTile(coordinates.X, coordinates.Y);
			inWall = false;
			isExpl = true;
			levitPoss=false;
			if (t && t.phis && coordinates.X >= t.phX1 && coordinates.X <= t.phX2 && coordinates.Y >= t.phY1 && coordinates.Y <= t.phY2) inWall = true;
			if (targetObj && destroy > 0 && (targetObj is Box)) (targetObj as Box).damage(destroy);

			if (explKol<=0) explRun();
			else {
				explRun();
				expl_t=(explKol-1)*explPeriod;
			}
		}
		
		//выполнить искусственный взрыв
		public function iExpl(ndamage:Number, ndestroy:Number, nradius:Number):void {
			loc=owner.loc;
			tipDamage=Unit.D_EXPL;
			otbros=10;
			damageExpl=ndamage;
			destroy=ndestroy;
			explRadius=nradius;
			explosion();
		}
		
		//выполнять процесс взрыва
		public function explRun():void {
			if (destroy > 0) explDestroy();
			if (explTip == 1 || explTip == 3 && expl_t == 0) explBlast();	
			if (explTip == 2 || explTip == 3 && expl_t >  0) explGas();
			explVis();
		}
		
		
		//поражение всех стен в радиусе
		private function explDestroy():void {
			for (var i:int = int((coordinates.X - explRadius) / constTileX); i<= int((coordinates.X + explRadius) / constTileX); i++) {
				for (var j:int = int((coordinates.Y - explRadius) / constTileY); j<= int((coordinates.Y + explRadius) / constTileY); j++) {
					var tx = coordinates.X - (i + 0.5) * constTileX;
					var ty = coordinates.Y - (j + 0.5) * constTileY;
					var ter = tx * tx + ty * ty;
					if (ter < explRadius * explRadius) loc.hitTile(loc.getTile(i, j), destroy,(i + 0.5) * constTileX, (j + 0.5) * constTileY, tipDecal);
				}
			}
		}
		
		//поражение всех юнитов, попавших в радиус, без отбрасывания и учёта стен
		private function explGas():void {
			for each(var un:Unit in loc.units) {
				if (un.sost==4 || un.invulner || un.disabled || un.trigDis || un.loc!=loc) continue;// || (un is VirtualUnit)
				if (explTip==3 && !un.stay) continue; 
				var tx = un.coordinates.X - coordinates.X;
				var ty = un.coordinates.Y - un.objectHeight / 2 - coordinates.Y;
				var rasst = Math.sqrt(tx*tx+ty*ty);
				var dam = damageExpl * Calc.floatBetween(0.7, 1.3);
				//дружественный огонь врагов
				if (weap && weap.owner.fraction==un.fraction && un.fraction!=Unit.F_PLAYER) {
					dam*=0.25;
				}
				if (rasst<explRadius) {
					if (rasst>explRadius*0.5) dam*=(2-rasst*2/explRadius);
					if (weap!=null) un.dieWeap=weap.id;
					if (weapId!=null) un.dieWeap=weapId;
					if (weap && weap.owner.fraction==Unit.F_PLAYER && un.player)  un.damage(dam*World.w.pers.autoExpl,tipDamage);
					else un.damage(dam,tipDamage);
				}
			}
		}
		
		//поражение всех юнитов виртуальными осколками, с учётом защиты от стен
		private function explBlast():void {
			var tx;
			var ty;
			if (loc != owner.loc) return;
			for each(var un:Unit in loc.units) {
				if (un.sost==4 || un.invulner || un.disabled || un.trigDis || un.loc!=loc) continue;
				var tx = un.coordinates.X - coordinates.X;
				var ty = un.coordinates.Y - un.objectHeight / 2 - coordinates.Y;
				var b:Bullet=explBullet(tx, ty, explRadius + un.objectWidth);
				if (b) {
					b.targetObj=un;
					//дружественный огонь врагов
					if (weap && weap.owner.fraction==un.fraction && un.fraction!=Unit.F_PLAYER) {
						b.damage*=un.friendlyExpl;
					}
					//огонь по себе
					if (un.player) {
						if (weap && weap.owner.fraction==Unit.F_PLAYER) b.damage*=World.w.pers.autoExpl;
						var p={x:b.knockx, y:b.knocky};
						norma(p, 10);
						b.knockx = p.x;
						b.knocky = p.y;
					}
				}
			}
		}
		
		//создать осколок
		private function explBullet(tx:Number, ty:Number, er:Number):Bullet {
			var rasst = Math.sqrt(tx*tx+ty*ty);
			var b:Bullet;
			if (rasst < er) {
				b = new Bullet(owner, coordinates.X, coordinates.Y, null);
				b.inWall = inWall;
				b.vel=er*(1+rasst/er*4)/3;
				b.velocity.X = tx / rasst * er / 3;
				b.velocity.Y = ty / rasst * er / 3;
				b.knockx = b.velocity.X / b.vel;
				b.knocky = b.velocity.Y / b.vel;
				if (!loc.levitOn) {
					b.knockx = 0;
					b.knocky = 0;
				}
				b.damage=damageExpl;
				if (rasst>er*0.5) b.damage*=(2-rasst*2/er);
				b.otbros=otbros;
				b.pier=pier;
				b.weapId=weapId;
				b.tipDamage=tipDamage;
				b.precision=0;
				b.liv=3;
				b.weap=weap;
				b.critCh=critCh;
				b.critDamMult=critDamMult;
				b.critInvis=critInvis;
			}
			return b;
		}
		
		//визуальный и звуковой эффект от взрыва
		private function explVis():void {
			if (weap) {
				if (weap.visexpl) {
					if (weap.visexpl == 'sparkle') {
						if (inWater > 0) {
							loc.budilo(coordinates.X, coordinates.Y, 700);
							Emitter.emit('explw', loc, coordinates.X, coordinates.Y);
							Emitter.emit('bubble', loc, coordinates.X, coordinates.Y, {
								kol: 30,
								rx: 100,
								ry: 100,
								rdx: 10,
								rdy: 10
							});
							Snd.ps('expl_uw', coordinates.X, coordinates.Y);
						}
						else {
							loc.budilo(coordinates.X, coordinates.Y, 1500);
							Emitter.emit('expl', loc, coordinates.X, coordinates.Y);
							Emitter.emit('sparkleexpl', loc, coordinates.X, coordinates.Y);
							Emitter.emit('iskr', loc, coordinates.X, coordinates.Y, {kol: 16});
							Snd.ps('bale_e', coordinates.X, coordinates.Y);
						}
					}
					else {
						loc.budilo(coordinates.X, coordinates.Y, 500);
						Emitter.emit(weap.visexpl, loc, coordinates.X, coordinates.Y);
					}
				}
				else if (tipDamage == Unit.D_EMP) {
					loc.budilo(coordinates.X, coordinates.Y, 500);
					Emitter.emit('impexpl', loc, coordinates.X, coordinates.Y);
					Snd.ps('emp_e', coordinates.X, coordinates.Y);
				}
				else if (tipDamage == Unit.D_CRIO) {
					loc.budilo(coordinates.X, coordinates.Y, 500);
					Emitter.emit('iceexpl', loc, coordinates.X, coordinates.Y);
					Emitter.emit('snow', loc, coordinates.X, coordinates.Y, {kol: 16});
					Snd.ps('cryo_e', coordinates.X, coordinates.Y);
				}
				else if (tipDamage == Unit.D_PLASMA) {
					loc.budilo(coordinates.X, coordinates.Y, 500);
					Emitter.emit('plaexpl', loc, coordinates.X, coordinates.Y);
					Snd.ps('exppla_e', coordinates.X, coordinates.Y);
				}
				else if (tipDamage == Unit.D_VENOM) {
					Emitter.emit('gas', loc, coordinates.X, coordinates.Y);
					if (expl_t == 0) Snd.ps('gas_e', coordinates.X, coordinates.Y);
				}
				else if (tipDamage == Unit.D_PINK) {
					Emitter.emit('pinkgas', loc, coordinates.X, coordinates.Y);
					if (expl_t == 0) Snd.ps('gas_e', coordinates.X, coordinates.Y);
				}
				else if (tipDamage == Unit.D_ACID) {
					if (expl_t == 0) {
						Emitter.emit('acidexpl', loc, coordinates.X, coordinates.Y);
						Emitter.emit('acidkap', loc, coordinates.X, coordinates.Y, {
							kol: Calc.intBetween(30, 34)
						});
						Snd.ps('acid_e', coordinates.X, coordinates.Y);
						explLiquid('acid');
					}
				}
				else if (tipDamage == Unit.D_BALE) {
					loc.budilo(coordinates.X, coordinates.Y, 3000);
					Emitter.emit('balefire', loc, coordinates.X, coordinates.Y - 60);
					Emitter.emit('baleblast', loc, coordinates.X, coordinates.Y);
					Snd.ps('bale_e', coordinates.X, coordinates.Y);
				}
				else if (tipDamage == Unit.D_EXPL) {
					if (inWater > 0) {
						loc.budilo(coordinates.X, coordinates.Y, 700);
						Emitter.emit('explw', loc, coordinates.X, coordinates.Y);
						Emitter.emit('bubble', loc, coordinates.X, coordinates.Y, {
							kol: 30,
							rx: 100,
							ry: 100,
							rdx: 10,
							rdy: 10
						});
						Snd.ps('expl_uw', coordinates.X, coordinates.Y);
					}
					else {
						loc.budilo(coordinates.X, coordinates.Y, 1500);
						Emitter.emit('expl', loc, coordinates.X, coordinates.Y);
						Emitter.emit('flare', loc, coordinates.X, coordinates.Y);
						Emitter.emit('iskr', loc, coordinates.X, coordinates.Y, {kol: 16});
						Snd.ps('expl_e', coordinates.X, coordinates.Y);
					}
				}
				else if (tipDamage == Unit.D_FIRE) {
					if (!(inWater > 0) && expl_t == 0) {
						loc.budilo(coordinates.X, coordinates.Y, 500);
						Emitter.emit('fireexpl', loc, coordinates.X, coordinates.Y);
						Emitter.emit('flare', loc, coordinates.X, coordinates.Y);
						Emitter.emit('iskr', loc, coordinates.X, coordinates.Y, {kol: 16});
						Snd.ps('fire_e', coordinates.X, coordinates.Y);
						explLiquid('fire', -33);
					}
				}
			}
			else if (tipDamage == Unit.D_EMP) {
				loc.budilo(coordinates.X, coordinates.Y, 500);
				Emitter.emit('impexpl', loc, coordinates.X, coordinates.Y);
				Snd.ps('emp_e', coordinates.X, coordinates.Y);
			}
			else if (tipDamage == Unit.D_CRIO) {
				loc.budilo(coordinates.X, coordinates.Y, 500);
				Emitter.emit('iceexpl', loc, coordinates.X, coordinates.Y);
				Emitter.emit('snow', loc, coordinates.X, coordinates.Y, {kol: 16});
				Snd.ps('cryo_e', coordinates.X, coordinates.Y);
			}
			else if (tipDamage == Unit.D_PLASMA) {
				loc.budilo(coordinates.X, coordinates.Y, 500);
				Emitter.emit('plaexpl', loc, coordinates.X, coordinates.Y);
				Snd.ps('exppla_e', coordinates.X, coordinates.Y);
			}
			else if (tipDamage == Unit.D_VENOM) {
				Emitter.emit('gas', loc, coordinates.X, coordinates.Y);
				if (expl_t == 0) Snd.ps('gas_e', coordinates.X, coordinates.Y);
			}
			else if (tipDamage == Unit.D_PINK) {
				Emitter.emit('pinkgas', loc, coordinates.X, coordinates.Y);
				if (expl_t == 0) Snd.ps('gas_e', coordinates.X, coordinates.Y);
			}
			else if (tipDamage == Unit.D_ACID) {
				if (expl_t == 0) {
					Emitter.emit('acidexpl', loc, coordinates.X, coordinates.Y);
					Emitter.emit('acidkap', loc, coordinates.X, coordinates.Y, {
						kol: Calc.intBetween(30, 34)
					});
					Snd.ps('acid_e', coordinates.X, coordinates.Y);
					explLiquid('acid');
				}
			}
			else if (tipDamage == Unit.D_BALE) {
				loc.budilo(coordinates.X, coordinates.Y, 3000);
				Emitter.emit('balefire', loc, coordinates.X, coordinates.Y - 60);
				Emitter.emit('baleblast', loc, coordinates.X, coordinates.Y);
				Snd.ps('bale_e', coordinates.X, coordinates.Y);
			}
			else if (tipDamage == Unit.D_EXPL) {
				if (inWater > 0) {
					loc.budilo(coordinates.X, coordinates.Y, 700);
					Emitter.emit('explw', loc, coordinates.X, coordinates.Y);
					Emitter.emit('bubble', loc, coordinates.X, coordinates.Y, {
						kol: 30,
						rx: 100,
						ry: 100,
						rdx: 10,
						rdy: 10
					});
					Snd.ps('expl_uw', coordinates.X, coordinates.Y);
				} else {
					loc.budilo(coordinates.X, coordinates.Y, 1500);
					Emitter.emit('expl', loc, coordinates.X, coordinates.Y);
					Emitter.emit('flare', loc, coordinates.X, coordinates.Y);
					Emitter.emit('iskr', loc, coordinates.X, coordinates.Y, {kol: 16});
					Snd.ps('expl_e', coordinates.X, coordinates.Y);
				}
			}
			else if (tipDamage == Unit.D_FIRE) {
				if (!(inWater > 0) && expl_t == 0) {
					loc.budilo(coordinates.X, coordinates.Y, 500);
					Emitter.emit('fireexpl', loc, coordinates.X, coordinates.Y);
					Emitter.emit('flare', loc, coordinates.X, coordinates.Y);
					Emitter.emit('iskr', loc, coordinates.X, coordinates.Y, {kol: 16});
					Snd.ps('fire_e', coordinates.X, coordinates.Y);
					explLiquid('fire', -33);
				}
			}
			if (otbros > 0)	{
				World.w.quake(Calc.floatBetween(-4, 4) * otbros, otbros * 0.8);
			}
		}

		private function explLiquid(liq:String, ndy:int=0) {
			for (var i:int = int((coordinates.X - explRadius) / constTileX); i <= int((coordinates.X + explRadius) / constTileX); i++) {
				for (var j:int = int((coordinates.Y - explRadius) / constTileY); j <= int((coordinates.Y + explRadius) / constTileY); j++) {
					var tx = coordinates.X - (i + 0.5) * constTileX;
					var ty = coordinates.Y - (j + 0.5) * constTileY;
					var ter = tx * tx + ty * ty;
					if (ter < explRadius * explRadius) {
						var t:Tile = loc.getTile(i, j);
						if (j > 1 && (t.phis || t.shelf) && (t.zForm || loc.getTile(i, j - 1).phis == 0)) {
							Emitter.emit(
								liq,
								loc,
								(i + 0.5) * constTileX + Calc.floatBetween(-2, 2),
								t.phY1 + ndy
							);
						}
					}
				}
			}
		}
	}
}
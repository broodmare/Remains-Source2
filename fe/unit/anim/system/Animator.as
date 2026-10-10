package fe.unit.anim.system {

	import fe.serv.BlitAnim;
	import fe.unit.Unit;
	import fe.unit.anim.model.Animator_Definition;

	// Plays a unit's sprite-sheet animations, picking one each tick from what the unit is doing
	public class Animator {

		private var owner:Unit;
		private var definition:Animator_Definition;
		private var hasWarned:Boolean = false;		// A missing animation is reported once per unit

		private function pick():String {
			var speed:Number = Math.abs(owner.velocity.X);

			if (owner.sost == 2 || owner.sost == 3) {
				return pickDead();
			}

			if (owner.stay) {
				if (owner.isSit && definition.sit != "") {
					return (speed > definition.walkFrom) ? definition.crawl : definition.sit;
				}

				if (definition.run != "" && speed > definition.runFrom) { return definition.run; }
				if (definition.trot != "" && speed > definition.trotFrom) { return definition.trot; }
				if (speed > definition.walkFrom) { return definition.walk; }

				return definition.stand;
			}

			if (owner.isLaz != 0 && definition.climb != "") {
				return (Math.abs(owner.velocity.Y) > 1.0) ? definition.climb : definition.climbStill;
			}

			if (owner.levit != 0 && definition.levitate != "") { return definition.levitate; }
			if (owner.aiPlav > 0 && definition.swim != "") { return definition.swim; }

			return definition.jump;
		}

		private function pickDead():String {
			if (!owner.stay) {
				return definition.death;
			}

			if (owner.animState == definition.death || owner.animState == definition.fall) {
				return (definition.fall != "") ? definition.fall : definition.death;
			}

			return definition.die;
		}

		private function stepFor(name:String):int {
			switch (name) {
				case definition.walk: {
					return definition.walkStep;
				}
				case definition.trot: {
					return definition.trotStep;
				}
				case definition.run: {
					return definition.runStep;
				}
				case definition.crawl: {
					return definition.crawlStep;
				}
				case definition.climb: {
					return definition.climbStep;
				}
				default: {
					return 0;
				}
			}
		}

		public function Animator(owner_:Unit, definition_:Animator_Definition) {
			owner = owner_;
			definition = definition_;
		}

		public function play():void {
			var name:String = owner.animOverride();
			var anim:BlitAnim;
			var step:int;

			if (name == "") {
				name = pick();
			}

			anim = owner.anims[name] as BlitAnim;
			if (!anim) {
				if (!hasWarned) {
					trace("Animator.as/play() - Warning: unit \"" + owner.id + "\" has no animation \"" + name + "\"");
					hasWarned = true;
				}

				return;
			}

			if (name != owner.animState2) {
				anim.restart();
				owner.animState2 = name;
			}

			owner.animState = name;
			step = stepFor(name);
			if (step != 0) {
				owner.sndStep(int(anim.f), step);
			}

			if (!anim.st) {
				owner.blit(anim.id, int(anim.f));
			}

			anim.step();
		}
	}
}
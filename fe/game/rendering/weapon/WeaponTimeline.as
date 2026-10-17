package fe.game.rendering.weapon {

	// Selects the weapon's outer frame while nested barrel clips keep their own clocks.
	public class WeaponTimeline {

		private var data:Object;
		private var active:Object = {};
		private var selected:int;

		public function WeaponTimeline(data_:Object) {
			data = data_;
			selectFrame(1);
		}

		public function get frame():int { return selected; }

		public function selectFrame(frame_:int):void {
			var next:Object = {};
			var layer:Object;
			var state:Object;

			if (frame_ < 1 || frame_ > data.meta.frameCount) { throw new ArgumentError("Weapon frame is outside its timeline"); }
			selected = frame_;
			for each (layer in data.meta.timeline[selected - 1].layers) {
				if (!layer.animation) { continue; }
				state = active[layer.source];
				next[layer.source] = state && state.animation == layer.animation
					? state : {animation: layer.animation, seconds: 0.0};
			}
			active = next;
		}

		public function selectLabel(label:String):void {
			if (data.meta.labels[label] === undefined) { throw new ArgumentError("Unknown weapon label: " + label); }
			selectFrame(data.meta.labels[label]);
		}

		// Call once per simulation tick, including ticks where the selected parent frame stays unchanged.
		public function advance(seconds:Number = 1.0 / 30.0):void {
			var state:Object;

			if (!isFinite(seconds) || seconds < 0.0) { throw new ArgumentError("Invalid weapon animation time"); }
			for each (state in active) { state.seconds += seconds; }
		}

		// Resolved raster/effect layers for WeaponArt. Each animation's pivot is supplied by its selected sprite.
		public function get layers():Array {
			var result:Array = [];
			var original:Object;
			var layer:Object;
			var name:String;
			var animation:Object;
			var index:int;

			for each (original in data.meta.timeline[selected - 1].layers) {
				layer = {};
				for (name in original) { layer[name] = original[name]; }
				if (original.animation) {
					animation = data.meta.animations[original.animation];
					index = int(Math.floor(active[original.source].seconds * animation.frameRate + 0.0000001));
					index = animation.loop ? index % animation.frames.length : Math.min(index, animation.frames.length - 1);
					layer.sprite = animation.frames[index];
					delete layer.animation;
				}
				result.push(layer);
			}
			return result;
		}
	}
}
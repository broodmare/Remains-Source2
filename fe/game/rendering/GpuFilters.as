package fe.game.rendering {

	import flash.filters.BevelFilter;
	import flash.filters.BitmapFilter;
	import flash.filters.BlurFilter;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;

	import starling.filters.BlurFilter;
	import starling.filters.CompositeFilter;
	import starling.filters.DropShadowFilter;
	import starling.filters.FilterChain;
	import starling.filters.FragmentFilter;
	import starling.filters.GlowFilter;

	import fe.engine.utils.Numbers;

	// Starling stand-ins for Flash's bitmap filters: close in look, not pixel for pixel
	public class GpuFilters {

		private static function glow(filter:flash.filters.GlowFilter):FragmentFilter {
			return new starling.filters.GlowFilter(filter.color, strength(filter.alpha, filter.strength), blur(average(filter.blurX, filter.blurY), filter.quality), 1.0, filter.inner, filter.knockout);
		}

		private static function shadow(filter:flash.filters.DropShadowFilter):FragmentFilter {
			return new starling.filters.DropShadowFilter(filter.distance, filter.angle * Numbers.DEG_TO_RAD, filter.color, strength(filter.alpha, filter.strength), blur(average(filter.blurX, filter.blurY), filter.quality), 1.0, filter.inner, filter.knockout);
		}

		private static function blurred(filter:flash.filters.BlurFilter):FragmentFilter {
			return new starling.filters.BlurFilter(blur(filter.blurX, filter.quality), blur(filter.blurY, filter.quality));
		}

		// A drop shadow that hides its object: the object's silhouette blurred, recoloured and moved, with nothing over it
		private static function shadowAlone(filter:flash.filters.DropShadowFilter, chain:FilterChain):void {
			var silhouette:CompositeFilter = new CompositeFilter();
			var offsetX:Number = Math.cos(filter.angle * Numbers.DEG_TO_RAD) * filter.distance;
			var offsetY:Number = Math.sin(filter.angle * Numbers.DEG_TO_RAD) * filter.distance;

			if (filter.inner || filter.knockout) {
				trace("GpuFilters.as/shadowAlone() - Warning: an inner or knockout shadow that hides its object is drawn as a plain one");
			}
			silhouette.setColorAt(0, filter.color, true);
			silhouette.setAlphaAt(0, strength(filter.alpha, filter.strength));
			silhouette.setOffsetAt(0, offsetX, offsetY);
			silhouette.padding.setTo(Math.max(0.0, -offsetX), Math.max(0.0, offsetX), Math.max(0.0, -offsetY), Math.max(0.0, offsetY));
			chain.addFilter(new starling.filters.BlurFilter(blur(filter.blurX, filter.quality), blur(filter.blurY, filter.quality)));
			chain.addFilter(silhouette);
		}

		// A bevel is two inner shadows: the highlight on the edges facing away from its angle, the shadow on those facing it
		private static function bevel(filter:BevelFilter, chain:FilterChain):void {
			var size:Number = blur(average(filter.blurX, filter.blurY), filter.quality);

			if (filter.type != "inner") {
				trace("GpuFilters.as/bevel() - Warning: only inner bevels are converted, this one is \"" + filter.type + "\"");
			}
			chain.addFilter(new starling.filters.DropShadowFilter(filter.distance, filter.angle * Numbers.DEG_TO_RAD, filter.highlightColor, strength(filter.highlightAlpha, filter.strength), size, 1.0, true));
			chain.addFilter(new starling.filters.DropShadowFilter(filter.distance, (filter.angle + 180.0) * Numbers.DEG_TO_RAD, filter.shadowColor, strength(filter.shadowAlpha, filter.strength), size, 1.0, true));
		}

		// Starling has no strength, but clamps its alpha after multiplying, so alpha times strength does the same
		private static function strength(alpha:Number, strength_:Number):Number {
			return Math.min(alpha, 1.0) * strength_;
		}

		private static function average(a:Number, b:Number):Number {
			return (a + b) * 0.5;
		}

		// Starling's blur for a Flash one: Flash runs `quality` box blurs of width `flashBlur`, Starling spreads 2 sigma per unit, or about 1.65 once it needs more than one pass
		public static function blur(flashBlur:Number, quality:int):Number {
			var sigma:Number = Math.sqrt(Math.max(0.0, quality * (flashBlur * flashBlur - 1.0) / 12.0));

			return sigma / (sigma > 2.0 ? 1.65 : 2.0);
		}

		// One Starling filter doing what the Flash filters do in order, rendered at resolution, or null when there are none
		public static function fromFlash(filters:Array, resolution:Number):FragmentFilter {
			var chain:FilterChain = new FilterChain();
			var filter:BitmapFilter;
			var i:int;

			for each (filter in filters) {
				if (filter is flash.filters.GlowFilter) {
					chain.addFilter(glow(flash.filters.GlowFilter(filter)));
				}
				else if (filter is flash.filters.DropShadowFilter && flash.filters.DropShadowFilter(filter).hideObject) {
					shadowAlone(flash.filters.DropShadowFilter(filter), chain);
				}
				else if (filter is flash.filters.DropShadowFilter) {
					chain.addFilter(shadow(flash.filters.DropShadowFilter(filter)));
				}
				else if (filter is BevelFilter) {
					bevel(BevelFilter(filter), chain);
				}
				else if (filter is flash.filters.BlurFilter) {
					chain.addFilter(blurred(flash.filters.BlurFilter(filter)));
				}
				else {
					trace("GpuFilters.as/fromFlash() - Warning: no Starling version of " + filter + ", so it is left out");
				}
			}

			if (chain.numFilters == 0) {
				chain.dispose();
				return null;
			}

			for (i = 0; i < chain.numFilters; i++) {
				chain.getFilterAt(i).resolution = resolution;
			}
			chain.resolution = resolution;

			return chain;
		}
	}
}
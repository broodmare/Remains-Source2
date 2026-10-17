package fe.game.rendering.rig {

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.geom.Matrix;
	import flash.utils.Dictionary;

	import starling.textures.Texture;

	import fe.game.rendering.AtlasClip;
	import fe.game.rendering.ClipAtlas;

	// Every image one look wears, packed into a single mipmapped atlas page so the whole rig draws in one call: the style picked for each drawing (every frame of its loop) and the armour's images
	public class RigArt {

		private static const PAGE_SIZES:Array	= [1024, 2048, 4096];
		private static const PADDING:int		= 8;		// ClipAtlas's border around each image on a mipmapped page
		private static const PACKING:Number		= 0.8;		// The share of a page that row packing reliably fills

		private var atlas:ClipAtlas;

		public var clips:Dictionary		= new Dictionary();		// AtlasClip by image key, pivoted on the image's origin, in game pixels
		public var page:Texture;								// The atlas page every image is on
		public var solid:AtlasClip;								// An opaque cell, the mask for drawings that have none
		public var key:String			= "";					// The look's key, as RigAssets keeps it
		public var users:int			= 0;					// Rigs wearing it, counted by RigAssets

		// The image keys look wears
		private static function keysFor(assets:RigAssets, look:RigLook):Vector.<String> {
			var keys:Vector.<String> = new Vector.<String>();
			var seen:Dictionary = new Dictionary();
			var drawing:RigDrawing_Definition;
			var style:int;
			var key:String;
			var armor:RigArmor_Definition = look.armor != "" ? assets.art.armor[look.armor] : null;

			for each (drawing in assets.art.drawings) {
				if (drawing.images.length == 0) { continue; }
				style = Math.min(look.styleOf(drawing.style), drawing.images.length) - 1;
				for each (key in drawing.images[style]) {
					if (!seen[key]) {
						seen[key] = true;
						keys.push(key);
					}
				}
			}
			if (armor) {
				for each (key in armor.images) {
					if (!seen[key]) {
						seen[key] = true;
						keys.push(key);
					}
				}
			}

			return keys;
		}

		public function RigArt(assets:RigAssets, look:RigLook) {
			var keys:Vector.<String> = keysFor(assets, look);
			var bitmaps:Dictionary = assets.bitmaps;
			var density:Number = assets.art.density;
			var area:Number = 0.0;
			var pageSize:int = PAGE_SIZES[PAGE_SIZES.length - 1];
			var size:int;
			var key:String;
			var bitmap:BitmapData;
			var pivot:Array;
			var clip:AtlasClip;
			var solidShape:Shape = new Shape();

			// Missing images are reported when the rig is dressed; tallest first packs rows tighter
			keys = keys.filter(function(k:String, i:int, all:Vector.<String>):Boolean { return bitmaps[k] != null; });
			keys.sort(function(a:String, b:String):Number { return BitmapData(bitmaps[b]).height - BitmapData(bitmaps[a]).height; });
			for each (key in keys) {
				area += (BitmapData(bitmaps[key]).width + PADDING * 2) * (BitmapData(bitmaps[key]).height + PADDING * 2);
			}
			for each (size in PAGE_SIZES) {
				if (area <= size * size * PACKING) {
					pageSize = size;
					break;
				}
			}

			atlas = new ClipAtlas(pageSize, density, true);
			solidShape.graphics.beginFill(0xFFFFFF);
			solidShape.graphics.drawRect(0.0, 0.0, 4.0, 4.0);
			solid = atlas.add("", solidShape, new Matrix());
			for each (key in keys) {
				bitmap = bitmaps[key];
				pivot = assets.art.pivots[key];
				clip = atlas.add(key, new Bitmap(bitmap, "auto", true),
					new Matrix(1.0 / density, 0.0, 0.0, 1.0 / density, -pivot[0] / density, -pivot[1] / density));
				if (!clip) { continue; }
				if (clip.texture.root != solid.texture.root) {
					trace("RigArt.as/RigArt() - Error: \"" + key + "\" spilled onto a second atlas page, so it draws with the wrong texture");
				}
				clips[key] = clip;
			}
			atlas.upload();
			page = solid.texture.root;
		}

		public function dispose():void {
			atlas.dispose();
		}
	}
}

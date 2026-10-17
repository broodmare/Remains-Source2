package fe.game.rendering.passes {

	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display3D.Context3DBlendFactor;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;

	import starling.core.Starling;
	import starling.display.BlendMode;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.filters.ColorMatrixFilter;
	import starling.filters.FilterChain;
	import starling.filters.FragmentFilter;
	import starling.textures.RenderTexture;
	import starling.textures.Texture;
	import starling.textures.TextureSmoothing;

	import fe.engine.utils.SymbolFactory;
	import fe.game.rendering.BackObj;
	import fe.game.rendering.AtlasClip;
	import fe.game.rendering.ClipAtlas;
	import fe.game.rendering.GpuFilters;
	import fe.game.rendering.RepeatingTexture;
	import fe.game.rendering.Renderer;
	import fe.game.rendering.TilePieceTextures;
	import fe.game.rendering.WallLightStyle;
	import fe.game.domain.location.Location;
	import fe.game.domain.location.tile.Tile;
	import fe.game.domain.location.tile.TilePiece_Definition;
	import fe.game.domain.location.tile.enums.E_TileBehaviour;
	import fe.game.domain.location.tile.enums.E_TileLayer;

	// The room's layers behind its units, drawn by Starling: the back wall, lit and shaded by the room's shadow, and the background in front of it.
	// Each is built into a room-sized texture when the room is drawn, so a frame only draws two images.
	public class BackWall {

		private static const INSIDE:String			= "inside";		// Blend that draws only over what is already there, keeping its alpha
		private static const OVERLAY:String			= "overlay";	// Blend standing in for Flash's overlay: doubles the colour under it by the image's, with mid grey changing nothing
		private static const OVERLAY_GREY:uint		= 0xFF808080;	// What overlay images are rasterized over, so their empty parts leave the wall unchanged
		private static const WHITE:ColorTransform	= new ColorTransform(0.0, 0.0, 0.0, 1.0, 255.0, 255.0, 255.0, 0.0);	// Turns a clip white, keeping its alpha
		private static const TILE_PAGE_SIZE:int		= 1024;
		private static const OBJECT_PAGE_SIZE:int	= 2048;
		private static const BRUSH_PAGE_SIZE:int	= 256;
		private static const GAS_Y:Number			= 520.0;		// Top of the pink gas cloud
		private static const GAS_ALPHA:Number		= 0.3;
		private static const BRUSH_STEP:Number		= 3.0;			// A paint stroke stamps its brush this often, in pixels

		private var renderer:Renderer;
		private var parent:Sprite;					// Starling's view of the room, which these layers sit at the bottom of
		private var shadows:ObjectShadow;				// Casts the shadow the wall is shaded by
		private var scale:Number = 1.0;				// Texture pixels per room pixel
		private var loc:Location;
		private var tileTextures:Vector.<TilePieceTextures>;
		private var materials:Object = {};			// RepeatingTextures by name, kept between rooms
		private var maskClips:Dictionary = new Dictionary();	// One instance of each mask class, set to each tile's corners in turn
		private var spriteClip:MovieClip;			// One tile sprite clip, set to each frame in turn
		private var tileAtlas:ClipAtlas;			// Tile masks and sprites, kept while the room shows so the shadow can be recast
		private var solid:AtlasClip;				// A fully opaque cell of the tile atlas, for fills without a mask
		private var brushes:ClipAtlas;				// Paint brushes, drawn white so they take any colour
		private var brush:AtlasClip;
		private var airbrush:AtlasClip;
		private var wallTexture:RenderTexture;		// The back wall as built, before tint, light and shadow
		private var lightTexture:RenderTexture;		// The room's darkness, with the back objects' light shapes over it
		private var backgroundTexture:RenderTexture;
		private var wallStyle:WallLightStyle;
		private var wallImage:Image;
		private var backgroundImage:Image;
		private var brushImage:Image;				// Stamped along paint strokes
		private var strokeX:Number;					// The paint stroke being stamped
		private var strokeY:Number;
		private var strokeStepX:Number;
		private var strokeStepY:Number;
		private var strokeSteps:int;
		private var redraw:Boolean;					// The GPU lost the room's textures, so it is drawn again before the next frame

		public var shadowChanged:Boolean;			// Tiles that cast the shadow broke, so their shapes are redrawn before the next frame

		// The texture loaded under name, laid out to repeat at the size the manifest gives it. Kept for the session.
		private function viewMaterial(name:String):RepeatingTexture {
			var bitmap:BitmapData;
			var drawSize:Point;
			var material:RepeatingTexture;

			if (materials[name] !== undefined) { return materials[name]; }

			bitmap = renderer.getObj(name, Renderer.numbMat) as BitmapData;
			if (!bitmap) {
				trace("BackWall.as/viewMaterial() - Warning: no texture \"" + name + "\", so it draws grey");
				bitmap = new BitmapData(2, 2, false, 0x666666);
			}

			// Textures the manifest gives no size were reported when it loaded, and draw at their pixel size
			drawSize = renderer.viewDrawSize(name) || new Point(bitmap.width, bitmap.height);
			material = new RepeatingTexture(bitmap, drawSize);
			materials[name] = material;

			return material;
		}

		// The textures sit at the room's size, made once and kept
		private function createTextures(width:int, height:int):void {
			wallTexture			= new RenderTexture(width, height, true, scale);
			lightTexture		= new RenderTexture(width, height, true, scale);
			backgroundTexture	= new RenderTexture(width, height, true, scale);

			wallStyle			= new WallLightStyle();
			wallStyle.light		= lightTexture;
			wallImage			= new Image(wallTexture);
			wallImage.style		= wallStyle;
			backgroundImage		= new Image(backgroundTexture);

			// Room pixels map one to one onto the screen until the camera zooms
			wallImage.textureSmoothing			= TextureSmoothing.NONE;
			backgroundImage.textureSmoothing	= TextureSmoothing.NONE;
			wallImage.touchable					= false;
			backgroundImage.touchable			= false;

			parent.addChildAt(backgroundImage, 0);
			parent.addChildAt(wallImage, 0);
		}

		// The mask clip of class maskClass, set to the tile's corners and squashed to scaleY, rasterized into the tile atlas
		private function maskClip(maskClass:Class, t:Tile, toFront:Boolean, scaleY:Number):AtlasClip {
			var clip:MovieClip = maskClips[maskClass];
			var key:String = "mask " + maskClass + " " + scaleY;
			var corners:Array;

			if (!clip) {
				clip = new maskClass();
				maskClips[maskClass] = clip;
			}

			if (clip.c1) {
				corners = toFront ? [t.mainOutline1, t.mainOutline2, t.mainOutline3, t.mainOutline4] : [t.backOutline1, t.backOutline2, t.backOutline3, t.backOutline4];
				key += " " + corners.join(",");
				clip.c1.gotoAndStop(corners[0] + 1);
				clip.c2.gotoAndStop(corners[1] + 1);
				clip.c3.gotoAndStop(corners[2] + 1);
				clip.c4.gotoAndStop(corners[3] + 1);
			}

			return tileAtlas.add(key, clip, new Matrix(1.0, 0.0, 0.0, scaleY));
		}

		// The top surface mask, which only follows the main layer's top corners
		private function topClip(maskClass:Class, t:Tile):AtlasClip {
			var clip:MovieClip = maskClips[maskClass];
			var key:String = "top " + maskClass;

			if (!clip) {
				clip = new maskClass();
				maskClips[maskClass] = clip;
			}

			if (clip.c1) {
				key += " " + t.mainOutline1 + "," + t.mainOutline2;
				clip.c1.gotoAndStop(t.mainOutline1 + 1);
				clip.c2.gotoAndStop(t.mainOutline2 + 1);
			}

			return tileAtlas.add(key, clip, new Matrix());
		}

		// The tile sprite frame, rasterized into the tile atlas
		private function spriteFrameClip(frame:int):AtlasClip {
			if (!spriteClip) {
				spriteClip = SymbolFactory.createInstance("tileFront");
			}
			spriteClip.gotoAndStop(frame);

			return tileAtlas.add("sprite " + frame, spriteClip, new Matrix());
		}

		// The sprite frame a tile shows for one of its pieces: ladders show a top frame where they end
		private static function spriteFrame(t:Tile, piece:TilePiece_Definition):int {
			return piece.spriteFrame + ((t.ladderTop && piece.behaviour == E_TileBehaviour.LADDER) ? 1 : 0);
		}

		// Every tile in the room showing a textured piece: its texture cut by its mask, then its edge and top textures cut by theirs
		private function pieceShape(textures:TilePieceTextures, color:uint):Sprite {
			var piece:TilePiece_Definition = textures.piece;
			var toFront:Boolean = piece.layer >= E_TileLayer.MAIN;
			var shape:Sprite = new Sprite();
			var textureName:String = (loc.homeStable && piece.stableTexture != "") ? piece.stableTexture : piece.texture;
			var base:QuadBatch = new QuadBatch(shape, viewMaterial(textureName), color);
			var edge:QuadBatch;
			var top:QuadBatch;
			var t:Tile;
			var shows:Boolean;
			var lowered:int;
			var scaleY:Number;
			var centerY:Number;
			var i:int;
			var j:int;

			if (piece.edgeTexture != "" && textures.edgeMask) {
				edge = new QuadBatch(shape, viewMaterial(piece.edgeTexture), color);
			}
			if (piece.topTexture != "" && textures.topMask) {
				top = new QuadBatch(shape, viewMaterial(piece.topTexture), color);
			}

			for (i = 0; i < loc.spaceX; i++) {
				for (j = 0; j < loc.spaceY; j++) {
					t = loc.getTile(i, j);
					if (piece.layer == E_TileLayer.BACK_WALL) {
						shows = (t.definition.wall == piece);
					}
					else {
						shows = t.showsPiece(piece) && t.definition.pieces.indexOf(piece) >= 0;
					}
					if (!shows) { continue; }

					// Steps and other low blocks squash their masks to the height they stand
					lowered = 4 - t.definition.height;
					scaleY	= 1.0;
					centerY	= (j + 0.5) * Tile.tileY;
					if (lowered > 0 && toFront) {
						scaleY	= (t.boundingBox.bottom - t.boundingBox.top) / Tile.tileY;
						centerY	= (t.boundingBox.bottom + t.boundingBox.top) / 2.0;
					}

					base.addClip(maskClip(textures.textureMask, t, toFront, scaleY), (i + 0.5) * Tile.tileX, centerY);
					if (edge) {
						edge.addClip(maskClip(textures.edgeMask, t, toFront, scaleY), (i + 0.5) * Tile.tileX, centerY);
					}
					if (top) {
						top.addClip(topClip(textures.topMask, t), (i + 0.5) * Tile.tileX, (j + 0.5 + lowered / 4.0) * Tile.tileY);
					}
				}
			}

			base.finish();
			if (edge) {
				edge.finish();
			}
			if (top) {
				top.finish();
			}

			return shape;
		}

		// The sprite pieces of the given layers, one image per tile, tinted color
		private function spritePieces(minLayer:int, maxLayer:int, color:uint):Sprite {
			var sprites:Sprite = new Sprite();
			var t:Tile;
			var piece:TilePiece_Definition;
			var clip:AtlasClip;
			var image:Image;
			var i:int;
			var j:int;

			for (i = 0; i < loc.spaceX; i++) {
				for (j = 0; j < loc.spaceY; j++) {
					t = loc.getTile(i, j);
					for each (piece in t.definition.pieces) {
						if (piece.spriteFrame == 0 || piece.layer < minLayer || piece.layer > maxLayer || !t.showsPiece(piece)) { continue; }

						clip = spriteFrameClip(spriteFrame(t, piece));
						if (!clip) { continue; }

						image = new Image(clip.texture);
						image.x		= i * Tile.tileX + clip.offsetX;
						image.y		= j * Tile.tileY + clip.offsetY;
						image.color	= color;
						sprites.addChild(image);
					}
				}
			}

			return sprites;
		}

		// The room's back wall texture, filled to the room's back wall shape. The sky shows instead in sky rooms.
		private function wallFill(wall:Sprite):void {
			var name:String = loc.backwall;
			var fill:QuadBatch;
			var width:Number = loc.spaceX * Tile.tileX;
			var height:Number = loc.spaceY * Tile.tileY;
			var split:Number;

			if (name == "sky") { return; }

			if (!(renderer.getObj(name, Renderer.numbMat) is BitmapData)) {
				if (name != "") {
					trace("BackWall.as/wallFill() - Warning: no back wall texture \"" + name + "\", so the default shows");
				}
				name = "tBackWall";
			}

			fill = new QuadBatch(wall, viewMaterial(name), 0xFFFFFF);

			switch (loc.backWallShape) {
				case 1: {
					// The sides, leaving the middle open
					split = 37 * Tile.tileX + 10.0;
					fill.addFill(solid, 0.0, 0.0, 11 * Tile.tileX - 10.0, height);
					fill.addFill(solid, split, 0.0, width - split, height);
					break;
				}
				case 2: {
					split = 16 * Tile.tileY + 10.0;
					fill.addFill(solid, 0.0, split, width, height - split);
					break;
				}
				case 3: {
					split = 24 * Tile.tileY + 10.0;
					fill.addFill(solid, 0.0, split, width, height - split);
					break;
				}
				default: {
					fill.addFill(solid, 0.0, 0.0, width, height);
					break;
				}
			}

			fill.finish();
		}

		// Every textured piece of a layer, each cut by its masks and given its filters, then tint
		private function pieceLayer(layer:int, target:Sprite, tint:ColorTransform):void {
			var textures:TilePieceTextures;
			var shape:Sprite;
			var filter:FragmentFilter;

			for each (textures in tileTextures) {
				if (!textures.used || textures.piece.layer != layer) { continue; }

				shape = pieceShape(textures, 0xFFFFFF);
				filter = GpuFilters.fromFlash(textures.filters, scale);
				if (tint) {
					filter = filter ? new FilterChain(filter, tintFilter(tint)) : tintFilter(tint);
				}
				shape.filter = filter;
				target.addChild(shape);
			}
		}

		private function tintFilter(tint:ColorTransform):ColorMatrixFilter {
			var filter:ColorMatrixFilter = new ColorMatrixFilter(new <Number>[
				tint.redMultiplier, 0.0, 0.0, 0.0, tint.redOffset,
				0.0, tint.greenMultiplier, 0.0, 0.0, tint.greenOffset,
				0.0, 0.0, tint.blueMultiplier, 0.0, tint.blueOffset,
				0.0, 0.0, 0.0, tint.alphaMultiplier, tint.alphaOffset
			]);

			filter.resolution = scale;
			return filter;
		}

		// A back object part placed as the object places it, cut to the room
		private function objectPart(atlas:ClipAtlas, name:String, part:MovieClip, obj:BackObj, background:uint):Image {
			var matrix:Matrix = new Matrix(obj.objectWidth, 0.0, 0.0, obj.objectHeight, obj.x, obj.y);
			var room:Rectangle = new Rectangle(0.0, 0.0, loc.spaceX * Tile.tileX, loc.spaceY * Tile.tileY);
			var key:String = name + " " + obj.id + " " + part.currentFrame + " " + matrix.toString();
			var clip:AtlasClip = atlas.add(key, part, matrix, null, room, background);
			var image:Image;

			if (!clip) { return null; }

			image = new Image(clip.texture);
			image.x		= clip.offsetX;
			image.y		= clip.offsetY;
			image.alpha	= obj.alpha;

			return image;
		}

		// The Starling blend for a back object's blend mode. Openings in the wall draw only over the wall.
		private static function objectBlend(blend:String, opening:Boolean):String {
			switch (blend) {
				case "normal": {
					return opening ? INSIDE : BlendMode.NORMAL;
				}
				case "multiply": {
					return BlendMode.MULTIPLY;
				}
				case "overlay": {
					return OVERLAY;
				}
				default: {
					trace("BackWall.as/objectBlend() - Warning: back objects can't blend with \"" + blend + "\", so it draws normally");
					return opening ? INSIDE : BlendMode.NORMAL;
				}
			}
		}

		// The back objects, in their layers from the back: openings cut into the wall, then objects on the wall, then objects behind units.
		// Their light shapes light the wall.
		private function objects(atlas:ClipAtlas, wall:Sprite, light:Sprite, background:Sprite, darkness:int):void {
			var shade:Number = 1.0 - (255 - darkness) / 150.0;						// How much light reaches objects behind units
			var boost:Number = Math.max(1.0, 1.0 + (170 - darkness) / 33.0);		// Brightens objects behind units in bright rooms
			var backTint:ColorTransform = new ColorTransform(loc.cTransform.redMultiplier * boost, loc.cTransform.greenMultiplier * boost, loc.cTransform.blueMultiplier * boost);
			var behindUnits:Sprite = new Sprite();
			var cuts:Sprite = new Sprite();
			var obj:BackObj;
			var opening:Boolean;
			var image:Image;
			var brightness:Number;
			var layer:int;

			for (layer = -2; layer <= 3; layer++) {
				for each (obj in loc.backobjs) {
					opening = obj.isOpening;
					if (!(layer == -2 && opening || obj.layer == layer && !opening)) { continue; }

					if (obj.vis) {
						image = objectPart(atlas, "art", obj.vis, obj, obj.blend == "overlay" ? OVERLAY_GREY : 0);
						if (image && layer <= 0) {
							image.blendMode = objectBlend(obj.blend, layer == -2);
							wall.addChild(image);
						}
						else if (image) {
							brightness = obj.light ? (shade >= 0.43 ? 1.0 : 0.55 + shade) : shade;
							image.color = uint(Math.max(0.0, brightness) * 255.0) * 0x010101;
							image.blendMode = objectBlend(obj.blend, false);
							behindUnits.addChild(image);
						}
					}

					// Only openings cut the wall
					if (obj.erase && layer == -2) {
						image = objectPart(atlas, "cut", obj.erase, obj, 0);
						if (image) {
							image.blendMode = BlendMode.ERASE;
							cuts.addChild(image);
						}
					}

					if (obj.light) {
						image = objectPart(atlas, "light", obj.light, obj, 0);
						if (image) {
							light.addChild(image);
						}
					}
				}

				if (layer == -2) {
					wall.addChild(cuts);
				}
			}

			behindUnits.filter = tintFilter(backTint);
			background.addChild(behindUnits);
		}

		// The pink gas cloud that hangs over gassed rooms
		private function gas(atlas:ClipAtlas, background:Sprite):void {
			var cloud:MovieClip;
			var clip:AtlasClip;
			var image:Image;

			if (loc.gas <= 0) { return; }

			cloud = renderer.getObj("back_pink_t", Renderer.numbBack) as MovieClip;
			if (!cloud) {
				trace("BackWall.as/gas() - Warning: no gas cloud clip \"back_pink_t\"");
				return;
			}

			clip = atlas.add("gas", cloud, new Matrix(1.0, 0.0, 0.0, 1.0, 0.0, GAS_Y));
			if (!clip) { return; }

			image = new Image(clip.texture);
			image.x		= clip.offsetX;
			image.y		= clip.offsetY;
			image.alpha	= GAS_ALPHA;
			background.addChild(image);
		}

		// The shapes of the main and foreground tiles, which cast the room's shadow
		private function drawShadow():void {
			var casters:Sprite = new Sprite();
			var textures:TilePieceTextures;

			for each (textures in tileTextures) {
				if (textures.used && textures.piece.layer >= E_TileLayer.MAIN) {
					casters.addChild(pieceShape(textures, 0x000000));
				}
			}
			casters.addChild(spritePieces(E_TileLayer.MAIN, E_TileLayer.FOREGROUND, 0x000000));

			tileAtlas.upload();
			shadows.drawTiles(casters);
			casters.dispose();
		}

		// Stamps the paint stroke's brush along its length
		private function stampStroke():void {
			var i:int;

			for (i = 1; i <= strokeSteps; i++) {
				brushImage.x = strokeX + strokeStepX * i;
				brushImage.y = strokeY + strokeStepY * i;
				wallTexture.draw(brushImage);
			}
		}

		private function onContextCreated(event:Event):void {
			if (loc) {
				redraw = true;
			}
		}

		public function BackWall(renderer_:Renderer, parent_:Sprite, shadows_:ObjectShadow) {
			renderer	= renderer_;
			parent	= parent_;
			shadows	= shadows_;

			BlendMode.register(INSIDE, Context3DBlendFactor.DESTINATION_ALPHA, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA);
			BlendMode.register(OVERLAY, Context3DBlendFactor.DESTINATION_COLOR, Context3DBlendFactor.SOURCE_COLOR);
			Starling.current.addEventListener(Event.CONTEXT3D_CREATE, onContextCreated);
		}

		// Builds the room's layers. Run after Renderer has worked out each tile's outline and which pieces the room uses.
		public function draw(loc_:Location, tileTextures_:Vector.<TilePieceTextures>):void {
			var width:int;
			var height:int;
			var darkness:int;
			var objectAtlas:ClipAtlas;
			var solidShape:Shape = new Shape();
			var wall:Sprite = new Sprite();
			var light:Sprite = new Sprite();
			var background:Sprite = new Sprite();
			var backgroundSprites:Sprite;

			loc				= loc_;
			tileTextures	= tileTextures_;
			width			= loc.spaceX * Tile.tileX;
			height			= loc.spaceY * Tile.tileY;
			darkness		= Math.min(Math.max(0xAA + loc.darkness, 0), 0xFF);	// The alpha of the black over the wall
			redraw			= false;
			shadowChanged	= false;

			if (!wallTexture) {
				createTextures(width, height);
			}
			else if (wallTexture.width != width || wallTexture.height != height) {
				trace("BackWall.as/draw() - Error: rooms are " + wallTexture.width + "x" + wallTexture.height + " pixels, but this one is " + width + "x" + height);
			}

			if (tileAtlas) {
				tileAtlas.dispose();
			}
			tileAtlas	= new ClipAtlas(TILE_PAGE_SIZE, scale);
			objectAtlas	= new ClipAtlas(OBJECT_PAGE_SIZE, scale);
			solidShape.graphics.beginFill(0xFFFFFF);
			solidShape.graphics.drawRect(0.0, 0.0, 4.0, 4.0);
			solid = tileAtlas.add("solid", solidShape, new Matrix());

			// The wall: its fill and patches, the openings cut into it, then the objects on it
			wallFill(wall);
			pieceLayer(E_TileLayer.BACK_WALL, wall, null);
			objects(objectAtlas, wall, light, background, darkness);

			// The background over the objects behind units: gas, the background pieces, then their sprites
			gas(objectAtlas, background);
			pieceLayer(E_TileLayer.BACKGROUND, background, loc.cTransform);
			backgroundSprites = spritePieces(E_TileLayer.BACKGROUND, E_TileLayer.BACKGROUND, 0xFFFFFF);
			backgroundSprites.filter = tintFilter(loc.cTransform);
			background.addChild(backgroundSprites);

			tileAtlas.upload();
			objectAtlas.upload();

			wallTexture.clear();
			wallTexture.draw(wall);
			lightTexture.clear(0x000000, darkness / 255.0);
			lightTexture.draw(light);
			backgroundTexture.clear();
			backgroundTexture.draw(background);
			drawShadow();

			wall.dispose();
			light.dispose();
			background.dispose();
			objectAtlas.dispose();

			wallStyle.shadow			= shadows.texture;
			wallStyle.tint				= loc.cTransform;
			wallStyle.transparentBack	= loc.transparentBack || loc.backwall == "sky";
			wallImage.setRequiresRedraw();
		}

		// Redraws the room or the tiles' shapes in the shadow if needed, just before Starling draws a frame
		public function prepareFrame():void {
			if (redraw) {
				draw(loc, tileTextures);
			}
			else if (shadowChanged) {
				shadowChanged = false;
				drawShadow();
			}
		}

		// Paints a stroke from x1, y1 to x2, y2 onto the back wall
		public function paint(x1:Number, y1:Number, x2:Number, y2:Number, useAirbrush:Boolean, color:uint):void {
			var stroke:AtlasClip;
			var distance:Number = Math.sqrt((x2 - x1) * (x2 - x1) + (y2 - y1) * (y2 - y1));

			if (!wallTexture) { return; }

			if (!brushes) {
				brushes		= new ClipAtlas(BRUSH_PAGE_SIZE, scale);
				airbrush	= brushes.add("airbrush", SymbolFactory.createInstance("paintaero"), new Matrix(), WHITE);
				brush		= brushes.add("brush", SymbolFactory.createInstance("paintbrush"), new Matrix(), WHITE);
				brushes.upload();
				brushImage	= new Image(brush.texture);
				brushImage.blendMode = INSIDE;
			}
			stroke = useAirbrush ? airbrush : brush;

			brushImage.texture = stroke.texture;
			brushImage.readjustSize();
			brushImage.color = color;

			strokeSteps	= Math.ceil(distance / BRUSH_STEP);
			strokeStepX	= (x2 - x1) / strokeSteps;
			strokeStepY	= (y2 - y1) / strokeSteps;
			strokeX		= x1 + stroke.offsetX;
			strokeY		= y1 + stroke.offsetY;
			wallTexture.drawBundled(stampStroke);
		}
	}
}

import flash.geom.Rectangle;
import flash.utils.ByteArray;

import starling.display.Mesh;
import starling.display.Sprite;
import starling.rendering.IndexData;
import starling.rendering.VertexData;
import starling.textures.Texture;

import fe.game.rendering.AtlasClip;
import fe.game.rendering.RepeatingTexture;
import fe.game.rendering.TilePieceStyle;

// Collects quads of one material into meshes, one per atlas page their masks come from.
// Quads split where copies of the material meet, so each piece samples within one copy.
class QuadBatch {

	private static const SLIVER:Number = 0.001;	// Pieces thinner than this, left by rounding at a copy's edge, are dropped
	private static const WHOLE_CLIP:Rectangle	= new Rectangle(0.0, 0.0, 1.0, 1.0);	// Mask coordinates covering a whole clip
	private static const CLIP_MIDDLE:Rectangle	= new Rectangle(0.5, 0.5, 0.0, 0.0);	// Mask coordinates that only sample a clip's middle
	private static const FLOATS_PER_CORNER:int	= 6;	// Position, mask and material coordinates

	private var target:Sprite;
	private var material:RepeatingTexture;
	private var color:uint;
	private var page:Texture;							// The atlas page the quads so far sample
	private var corners:Vector.<Number> = new Vector.<Number>();	// The quads so far, FLOATS_PER_CORNER per corner

	// A piece of a quad inside one copy of the material, from x0, y0 to x1, y1, with the mask's page coordinates at its corners
	private function addPiece(clip:AtlasClip, x0:Number, y0:Number, x1:Number, y1:Number, mask:Rectangle):void {
		var copyX:int = Math.floor((x0 + x1) / 2.0 / material.drawWidth);
		var copyY:int = Math.floor((y0 + y1) / 2.0 / material.drawHeight);
		var i:int;
		var x:Number;
		var y:Number;

		if (page != clip.texture.root) {
			finish();
			page = clip.texture.root;
		}

		for (i = 0; i < 4; i++) {
			x = (i & 1) != 0 ? x1 : x0;
			y = (i & 2) != 0 ? y1 : y0;
			corners.push(x, y,
				(i & 1) != 0 ? mask.right : mask.left, (i & 2) != 0 ? mask.bottom : mask.top,
				material.left + material.width * (x / material.drawWidth - copyX), material.top + material.height * (y / material.drawHeight - copyY));
		}
	}

	// The quad, cut where copies of the material meet. Mask coordinates in maskArea, from 0 to 1 over the clip, run across the whole quad.
	private function addQuad(clip:AtlasClip, quad:Rectangle, maskArea:Rectangle):void {
		var firstX:int = Math.floor(quad.left / material.drawWidth);
		var lastX:int = Math.ceil(quad.right / material.drawWidth) - 1;
		var firstY:int = Math.floor(quad.top / material.drawHeight);
		var lastY:int = Math.ceil(quad.bottom / material.drawHeight) - 1;
		var pageWidth:Number = clip.pageRight - clip.pageLeft;
		var pageHeight:Number = clip.pageBottom - clip.pageTop;
		var mask:Rectangle = new Rectangle();
		var copyX:int;
		var copyY:int;
		var x0:Number;
		var x1:Number;
		var y0:Number;
		var y1:Number;

		for (copyX = firstX; copyX <= lastX; copyX++) {
			x0 = Math.max(quad.left, copyX * material.drawWidth);
			x1 = Math.min(quad.right, (copyX + 1) * material.drawWidth);
			if (x1 - x0 < SLIVER) { continue; }

			for (copyY = firstY; copyY <= lastY; copyY++) {
				y0 = Math.max(quad.top, copyY * material.drawHeight);
				y1 = Math.min(quad.bottom, (copyY + 1) * material.drawHeight);
				if (y1 - y0 < SLIVER) { continue; }

				mask.left	= clip.pageLeft + pageWidth * (maskArea.left + maskArea.width * (x0 - quad.left) / quad.width);
				mask.right	= clip.pageLeft + pageWidth * (maskArea.left + maskArea.width * (x1 - quad.left) / quad.width);
				mask.top	= clip.pageTop + pageHeight * (maskArea.top + maskArea.height * (y0 - quad.top) / quad.height);
				mask.bottom	= clip.pageTop + pageHeight * (maskArea.top + maskArea.height * (y1 - quad.top) / quad.height);
				addPiece(clip, x0, y0, x1, y1, mask);
			}
		}
	}

	public function QuadBatch(parent:Sprite, material_:RepeatingTexture, color_:uint) {
		target		= new Sprite();
		material	= material_;
		color		= color_;
		parent.addChild(target);
	}

	// The whole clip, its origin at x, y
	public function addClip(clip:AtlasClip, x:Number, y:Number):void {
		if (clip) {
			addQuad(clip, new Rectangle(x + clip.offsetX, y + clip.offsetY, clip.width, clip.height), WHOLE_CLIP);
		}
	}

	// A rectangle sampling only the middle of clip, which should be a solid colour
	public function addFill(clip:AtlasClip, left:Number, top:Number, width:Number, height:Number):void {
		addQuad(clip, new Rectangle(left, top, width, height), CLIP_MIDDLE);
	}

	// Puts the quads collected so far into a mesh
	public function finish():void {
		var numCorners:int = corners.length / FLOATS_PER_CORNER;
		var vertexData:VertexData;
		var indexData:IndexData;
		var raw:ByteArray;
		var size:int;
		var position:int;
		var mask:int;
		var materialCoords:int;
		var style:TilePieceStyle;
		var mesh:Mesh;
		var i:int;
		var j:int;

		if (numCorners == 0) { return; }

		vertexData = new VertexData(TilePieceStyle.VERTEX_FORMAT, numCorners);
		vertexData.numVertices = numCorners;
		raw				= vertexData.rawData;
		size			= vertexData.vertexSize;
		position		= vertexData.getOffset("position");
		mask			= vertexData.getOffset("texCoords");
		materialCoords	= vertexData.getOffset("materialTexCoords");
		for (i = 0; i < numCorners; i++) {
			j = i * FLOATS_PER_CORNER;
			raw.position = i * size + position;
			raw.writeFloat(corners[j]);
			raw.writeFloat(corners[j + 1]);
			raw.position = i * size + mask;
			raw.writeFloat(corners[j + 2]);
			raw.writeFloat(corners[j + 3]);
			raw.position = i * size + materialCoords;
			raw.writeFloat(corners[j + 4]);
			raw.writeFloat(corners[j + 5]);
		}
		vertexData.colorize("color", color, 1.0);

		indexData = new IndexData(numCorners / 4 * 6);
		for (i = 0; i < numCorners; i += 4) {
			indexData.addQuad(i, i + 1, i + 2, i + 3);
		}

		// The style takes its mask page before the mesh exists, so Starling has no coordinates to convert
		style = new TilePieceStyle(material.texture);
		style.texture = page;
		mesh = new Mesh(vertexData, indexData, style);
		mesh.touchable = false;
		target.addChild(mesh);
		corners.length = 0;
	}
}

package fe.game.rendering.rig {

	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	import starling.display.Mesh;
	import starling.rendering.IndexData;
	import starling.rendering.VertexData;
	import starling.textures.TextureSmoothing;

	import fe.game.rendering.AtlasClip;
	import fe.game.rendering.TilePieceStyle;

	// One rigged character. It plays an animation like a Flash timeline (a playhead moved on by advance(), stopping and jumping where the animation's scripts did), wears a look, and draws as a single mesh.
	public class Rig {

		private static const POSE_FLOATS:int	= 6;		// Per node: x, y, depth, angle, scaleX, scaleY
		private static const WORLD_FLOATS:int	= 7;		// Per node: a, b, c, d, tx, ty, depth
		private static const MAX_QUADS:int		= 256;
		private static const MIP_BIAS:Number	= -0.5;		// Samples a little sharper than the screen size asks for: closest to Flash drawing the vectors directly
		private static const VERTEX_SIZE:int	= 28;		// Bytes per vertex: position, mask coordinates, colour, material coordinates, packed in that order

		private var definition:Rig_Definition;
		private var assets:RigAssets;
		private var art:RigArt;
		private var animation:RigAnimation_Definition;
		private var pose:Vector.<Number>;					// The rest pose with the animation applied
		private var world:Vector.<Number>;					// Each node's transform onto the screen
		private var nodeColors:Vector.<Number>;				// Per node, the red, green, blue and alpha multipliers the animation gives its drawings
		private var turns:Vector.<Number>;					// Per node, an angle the game turns it by on top of the animation's
		private var shifts:Vector.<Number>;					// Per node, x and y the game moves it by
		private var shown:Vector.<Boolean>;					// Per node, whether the switches and armour let its drawing show
		private var alphas:Vector.<Number>;					// Per node, how opaque the game makes its drawing
		private var loopStarts:Vector.<int>;				// Per node, the tick its drawing's loop of frames started
		private var maskNodes:Vector.<int>;					// Per node, the node whose mask clips its drawing, or -1
		private var maskClips:Vector.<AtlasClip>;			// Per node, that mask
		private var isMaskNode:Vector.<Boolean>;			// Per node, whether it masks another node's drawing
		private var firstLayers:Vector.<int>;				// Per node, its first layer
		private var layerCounts:Vector.<int>;				// Per node, how many layers it draws, back to front
		private var layerFrames:Vector.<Vector.<AtlasClip>>;	// Per layer, its image, or every frame of its loop
		private var layerTints:Vector.<String>;				// Per layer, the colour it is multiplied by, by name
		private var layerRgbs:Vector.<uint>;				// Per layer, that colour
		private var layerPlacements:Vector.<Vector.<Number>>;	// Per layer, a matrix placing the image on its node, or null
		private var layerLoopFroms:Vector.<int>;			// Per layer, where its loop goes back to
		private var slotLayers:Vector.<int>;				// Per quad in the mesh, the layer last written there, or -1
		private var slotClips:Vector.<AtlasClip>;			// Per quad, the image last written
		private var slotColors:Vector.<uint>;				// Per quad, the colour last written
		private var switchStates:Dictionary = new Dictionary();		// State by switch name
		private var drawn:Vector.<int> = new Vector.<int>();		// Nodes with something to draw, back to front
		private var vertexData:VertexData;
		private var indexData:IndexData;
		private var style:TilePieceStyle;
		private var ticks:int = 0;							// advance() calls so far: the clock of the drawings' own loops
		private var maskA:Number;							// The quad being written's mask: the inverse of its node's transform,
		private var maskB:Number;
		private var maskC:Number;
		private var maskD:Number;
		private var maskX:Number;							// that node's position,
		private var maskY:Number;
		private var maskLeft:Number;						// and the step from the node's space into the mask image
		private var maskTop:Number;
		private var maskStepU:Number;
		private var maskStepV:Number;
		private var maskOffsetX:Number;
		private var maskOffsetY:Number;
		private var solidU:Number;							// The opaque cell's middle, the mask coordinates of unmasked quads
		private var solidV:Number;

		public var mesh:Mesh;
		public var x:Number			= 0.0;
		public var y:Number			= 0.0;
		public var facing:Number	= 1.0;					// 1 faces right, -1 left
		public var look:RigLook		= new RigLook();		// Change it, then call dress()
		public var colors:Dictionary = new Dictionary();	// Tint colour by name, as the drawings name them; call recolor() after changing
		public var frame:int		= 0;					// The playhead, counted from 0. Read it; move it with goTo().
		public var isPlaying:Boolean = false;				// Whether advance() moves the playhead on

		// Each node's pose and colour fraction of the way from one frame to another
		private function sample(from:int, to:int, fraction:Number):void {
			var nodes:Vector.<int> = animation.nodes;
			var poses:Vector.<Number> = animation.poses;
			var held:Vector.<Boolean> = animation.heldScales;
			var colorNodes:Vector.<int> = animation.colorNodes;
			var colors:Vector.<Number> = animation.colors;
			var a:int = from * nodes.length * POSE_FLOATS;
			var b:int = to * nodes.length * POSE_FLOATS;
			var at:int;
			var i:int;
			var k:int;

			for (i = 0; i < nodes.length; i++) {
				at = nodes[i] * POSE_FLOATS;
				pose[at]		= poses[a] + (poses[b] - poses[a]) * fraction;
				pose[at + 1]	= poses[a + 1] + (poses[b + 1] - poses[a + 1]) * fraction;
				pose[at + 2]	= poses[a + 2];
				pose[at + 3]	= poses[a + 3] + (poses[b + 3] - poses[a + 3]) * fraction;
				if (held[i]) {
					pose[at + 4] = poses[a + 4];
					pose[at + 5] = poses[a + 5];
				}
				else {
					pose[at + 4] = poses[a + 4] + (poses[b + 4] - poses[a + 4]) * fraction;
					pose[at + 5] = poses[a + 5] + (poses[b + 5] - poses[a + 5]) * fraction;
				}
				a += POSE_FLOATS;
				b += POSE_FLOATS;
			}

			a = from * colorNodes.length * 4;
			b = to * colorNodes.length * 4;
			for (i = 0; i < colorNodes.length; i++) {
				at = colorNodes[i] * 4;
				for (k = 0; k < 4; k++) {
					nodeColors[at + k] = colors[a + k] + (colors[b + k] - colors[a + k]) * fraction;
				}
				a += 4;
				b += 4;
			}
		}

		// Each node's transform onto the screen: its parent's, then its own position, rotation and scale
		private function place():void {
			var order:Vector.<int> = definition.order;
			var parents:Vector.<int> = definition.parents;
			var count:int = order.length;
			var k:int;
			var n:int;
			var p:int;
			var i:int;
			var w:int;
			var pa:Number;
			var pb:Number;
			var pc:Number;
			var pd:Number;
			var ptx:Number;
			var pty:Number;
			var pz:Number;
			var angle:Number;
			var cos:Number;
			var sin:Number;
			var la:Number;
			var lb:Number;
			var lc:Number;
			var ld:Number;
			var lx:Number;
			var ly:Number;

			for (k = 0; k < count; k++) {
				n = order[k];
				// A drawing nothing shows needs no transform, unless it masks others
				if (layerCounts[n] == 0 ? definition.drawings[n] != null && !isMaskNode[n] : !shown[n]) { continue; }
				p = parents[n];
				if (p < 0) {
					pa = facing;
					pb = 0.0;
					pc = 0.0;
					pd = 1.0;
					ptx = x;
					pty = y;
					pz = 0.0;
				}
				else {
					w = p * WORLD_FLOATS;
					pa = world[w];
					pb = world[w + 1];
					pc = world[w + 2];
					pd = world[w + 3];
					ptx = world[w + 4];
					pty = world[w + 5];
					pz = world[w + 6];
				}
				i = n * POSE_FLOATS;
				angle = pose[i + 3] + turns[n];
				// Most drawing nodes carry no turn of their own
				if (angle == 0.0) {
					la = pose[i + 4];
					lb = 0.0;
					lc = 0.0;
					ld = pose[i + 5];
				}
				else {
					cos = Math.cos(angle);
					sin = Math.sin(angle);
					la = pose[i + 4] * cos;
					lb = pose[i + 4] * sin;
					lc = -pose[i + 5] * sin;
					ld = pose[i + 5] * cos;
				}
				lx = pose[i] + shifts[n * 2];
				ly = pose[i + 1] + shifts[n * 2 + 1];
				w = n * WORLD_FLOATS;
				world[w]		= pa * la + pc * lb;
				world[w + 1]	= pb * la + pd * lb;
				world[w + 2]	= pa * lc + pc * ld;
				world[w + 3]	= pb * lc + pd * ld;
				world[w + 4]	= pa * lx + pc * ly + ptx;
				world[w + 5]	= pb * lx + pd * ly + pty;
				world[w + 6]	= pz + pose[i + 2];
			}
		}

		// The frame of a loop of count frames, steps after it started, that goes back to loopFrom after the last
		private static function loopFrame(steps:int, count:int, loopFrom:int):int {
			if (steps < count) { return steps; }

			return loopFrom + (steps - loopFrom) % (count - loopFrom);
		}

		// Sorts the visible drawings back to front and writes every layer they wear into the mesh. Positions are written
		// every frame; a quad's texture coordinates and colour only when its image or colour changed.
		private function draw():void {
			var raw:ByteArray = vertexData.rawData;
			var parents:Vector.<int> = definition.parents;
			var nodeCount:int = definition.names.length;
			var quads:int = 0;
			var n:int;
			var i:int;
			var j:int;
			var held:int;
			var layer:int;
			var lastLayer:int;
			var frames:Vector.<AtlasClip>;
			var clip:AtlasClip;
			var placement:Vector.<Number>;
			var w:int;
			var vertex:int;
			var color:uint;
			var rgb:uint;
			var c:int;
			var isChanged:Boolean;
			var a:Number;
			var b:Number;
			var cc:Number;
			var d:Number;
			var tx:Number;
			var ty:Number;
			var lx:Number;
			var ly:Number;
			var x0:Number;
			var y0:Number;
			var ux:Number;
			var uy:Number;
			var vx:Number;
			var vy:Number;
			var mask:AtlasClip;
			var m:int;
			var det:Number;

			drawn.length = 0;
			for (n = 0; n < nodeCount; n++) {
				if (layerCounts[n] > 0 && shown[n] && pose[n * POSE_FLOATS + 4] != 0.0 && pose[n * POSE_FLOATS + 5] != 0.0) {
					drawn.push(n);
					quads += layerCounts[n];
				}
			}
			// Insertion sort by depth: the order barely changes from frame to frame
			for (i = 1; i < drawn.length; i++) {
				held = drawn[i];
				j = i - 1;
				while (j >= 0 && world[drawn[j] * WORLD_FLOATS + 6] > world[held * WORLD_FLOATS + 6]) {
					drawn[j + 1] = drawn[j];
					j--;
				}
				drawn[j + 1] = held;
			}

			// The counts change before anything is written: growing them clears the vertices past the old count
			quads = Math.min(quads, MAX_QUADS);
			if (vertexData.numVertices != quads * 4) {
				vertexData.numVertices = quads * 4;
				indexData.numIndices = quads * 6;
				mesh.setIndexDataChanged();
				forgetSlots();
			}
			quads = 0;
			solidU = (art.solid.pageLeft + art.solid.pageRight) / 2.0;
			solidV = (art.solid.pageTop + art.solid.pageBottom) / 2.0;

			for each (n in drawn) {
				w = n * WORLD_FLOATS;
				c = (parents[n] >= 0 ? parents[n] : n) * 4;
				mask = maskClips[n];
				if (mask) {
					// The inverse of the mask node's transform, then the step from its space into the mask image
					m = maskNodes[n] * WORLD_FLOATS;
					det = world[m] * world[m + 3] - world[m + 1] * world[m + 2];
					maskA		= world[m + 3] / det;
					maskB		= -world[m + 1] / det;
					maskC		= -world[m + 2] / det;
					maskD		= world[m] / det;
					maskX		= world[m + 4];
					maskY		= world[m + 5];
					maskLeft	= mask.pageLeft;
					maskTop		= mask.pageTop;
					maskStepU	= (mask.pageRight - mask.pageLeft) / mask.width;
					maskStepV	= (mask.pageBottom - mask.pageTop) / mask.height;
					maskOffsetX	= mask.offsetX;
					maskOffsetY	= mask.offsetY;
				}
				lastLayer = firstLayers[n] + layerCounts[n];
				for (layer = firstLayers[n]; layer < lastLayer && quads < MAX_QUADS; layer++) {
					frames = layerFrames[layer];
					clip = frames.length == 1 ? frames[0] : frames[loopFrame(ticks - loopStarts[n], frames.length, layerLoopFroms[layer])];
					rgb = layerRgbs[layer];
					color = packColor(uint(((rgb >> 16) & 0xFF) * nodeColors[c]), uint(((rgb >> 8) & 0xFF) * nodeColors[c + 1]),
						uint((rgb & 0xFF) * nodeColors[c + 2]), alphas[n] * nodeColors[c + 3]);
					isChanged = slotLayers[quads] != layer || slotClips[quads] != clip || slotColors[quads] != color;
					if (isChanged) {
						slotLayers[quads] = layer;
						slotClips[quads] = clip;
						slotColors[quads] = color;
					}

					a = world[w];
					b = world[w + 1];
					cc = world[w + 2];
					d = world[w + 3];
					tx = world[w + 4];
					ty = world[w + 5];
					placement = layerPlacements[layer];
					if (placement) {
						tx = a * placement[4] + cc * placement[5] + tx;
						ty = b * placement[4] + d * placement[5] + ty;
						lx = a * placement[0] + cc * placement[1];
						ly = b * placement[0] + d * placement[1];
						cc = a * placement[2] + cc * placement[3];
						d = b * placement[2] + d * placement[3];
						a = lx;
						b = ly;
					}
					// The quad's top left corner, and its edges along the image's width and height
					x0 = a * clip.offsetX + cc * clip.offsetY + tx;
					y0 = b * clip.offsetX + d * clip.offsetY + ty;
					ux = a * clip.width;
					uy = b * clip.width;
					vx = cc * clip.height;
					vy = d * clip.height;

					vertex = quads * 4 * VERTEX_SIZE;
					writeCorner(raw, vertex, x0, y0, mask != null, isChanged, color, clip.pageLeft, clip.pageTop);
					writeCorner(raw, vertex + VERTEX_SIZE, x0 + ux, y0 + uy, mask != null, isChanged, color, clip.pageRight, clip.pageTop);
					writeCorner(raw, vertex + VERTEX_SIZE * 2, x0 + vx, y0 + vy, mask != null, isChanged, color, clip.pageLeft, clip.pageBottom);
					writeCorner(raw, vertex + VERTEX_SIZE * 3, x0 + ux + vx, y0 + uy + vy, mask != null, isChanged, color, clip.pageRight, clip.pageBottom);
					quads++;
				}
			}

			mesh.setVertexDataChanged();
		}

		// Writes one corner of a quad: always its position, and its mask coordinates when masked; its texture coordinates (u, v)
		// and colour only when the quad changed. Kept apart from draw(): inside that long method the same code ran several
		// times slower.
		private function writeCorner(raw:ByteArray, vertex:int, x:Number, y:Number, isMasked:Boolean, isChanged:Boolean, color:uint, u:Number, v:Number):void {
			var maskSpaceX:Number;
			var maskSpaceY:Number;

			raw.position = vertex;
			raw.writeFloat(x);
			raw.writeFloat(y);
			if (isMasked) {
				maskSpaceX = maskA * (x - maskX) + maskC * (y - maskY);
				maskSpaceY = maskB * (x - maskX) + maskD * (y - maskY);
				raw.writeFloat(maskLeft + (maskSpaceX - maskOffsetX) * maskStepU);
				raw.writeFloat(maskTop + (maskSpaceY - maskOffsetY) * maskStepV);
			}
			else if (isChanged) {
				raw.writeFloat(solidU);
				raw.writeFloat(solidV);
			}
			if (isChanged) {
				raw.position = vertex + 16;
				raw.writeUnsignedInt(color);
				raw.writeFloat(u);
				raw.writeFloat(v);
			}
		}

		// A colour and alpha, premultiplied and packed as the vertex buffer stores it: red, green, blue, alpha bytes in order
		private static function packColor(r:uint, g:uint, b:uint, alpha:Number):uint {
			return (uint(alpha * 255.0 + 0.5) << 24) | (uint(b * alpha + 0.5) << 16) | (uint(g * alpha + 0.5) << 8) | uint(r * alpha + 0.5);
		}

		// Makes the next draw() write every quad in full
		private function forgetSlots():void {
			var i:int;

			for (i = 0; i < MAX_QUADS; i++) {
				slotLayers[i] = -1;
				slotClips[i] = null;
			}
		}

		// Recomputes which drawings the switches and armour let show
		private function applySwitches():void {
			var n:int;
			var drawing:String;
			var rigSwitch:RigSwitch_Definition;
			var state:String;
			var listed:Vector.<String>;
			var armor:RigArmor_Definition = look.armor != "" ? assets.art.armor[look.armor] : null;
			var isInSwitch:Boolean;
			var isInState:Boolean;

			for (n = 0; n < shown.length; n++) {
				drawing = definition.drawings[n];
				shown[n] = drawing != null && !(armor && armor.hides.indexOf(drawing) >= 0);
				if (!shown[n]) { continue; }
				for each (rigSwitch in assets.art.switches) {
					isInSwitch = false;
					isInState = false;
					for (state in rigSwitch.states) {
						listed = rigSwitch.states[state];
						if (listed.indexOf(drawing) >= 0) {
							isInSwitch = true;
							isInState = isInState || state == switchStates[rigSwitch.name];
						}
					}
					if (isInSwitch && !isInState) {
						shown[n] = false;
						break;
					}
				}
			}
		}

		private function setSwitchState(name:String, state:String):void {
			var rigSwitch:RigSwitch_Definition;
			var n:int;
			var drawings:Vector.<String>;

			if (switchStates[name] == state) { return; }

			for each (rigSwitch in assets.art.switches) {
				if (rigSwitch.name != name) { continue; }
				drawings = rigSwitch.states[state];
				if (!drawings) {
					trace("Rig.as/setSwitchState() - Warning: switch \"" + name + "\" has no state \"" + state + "\"");
					return;
				}
				// A loop shown by the change starts from its first frame
				for (n = 0; n < definition.drawings.length; n++) {
					if (drawings.indexOf(definition.drawings[n]) >= 0) {
						loopStarts[n] = ticks;
					}
				}
			}
			switchStates[name] = state;
			applySwitches();
		}

		// Moves the playhead to frame, as the animation's scripts there move it, and sets the switches they set
		private function enter(target:int):void {
			var events:Vector.<String> = animation.events[target];
			var i:int;

			frame = animation.shows[target];
			if (animation.stops[target]) {
				isPlaying = false;
			}
			if (events) {
				for (i = 0; i < events.length; i += 2) {
					setSwitchState(events[i], events[i + 1]);
				}
			}
		}

		public function Rig(assets_:RigAssets) {
			var count:int;
			var n:int;
			var i:int;
			var rigSwitch:RigSwitch_Definition;

			assets		= assets_;
			definition	= assets.definition;
			count		= definition.names.length;
			pose		= new Vector.<Number>(count * POSE_FLOATS, true);
			world		= new Vector.<Number>(count * WORLD_FLOATS, true);
			nodeColors	= new Vector.<Number>(count * 4, true);
			turns		= new Vector.<Number>(count, true);
			shifts		= new Vector.<Number>(count * 2, true);
			shown		= new Vector.<Boolean>(count, true);
			alphas		= new Vector.<Number>(count, true);
			loopStarts	= new Vector.<int>(count, true);
			maskNodes	= new Vector.<int>(count, true);
			maskClips	= new Vector.<AtlasClip>(count, true);
			isMaskNode	= new Vector.<Boolean>(count, true);
			firstLayers	= new Vector.<int>(count, true);
			layerCounts	= new Vector.<int>(count, true);
			slotLayers	= new Vector.<int>(MAX_QUADS, true);
			slotClips	= new Vector.<AtlasClip>(MAX_QUADS, true);
			slotColors	= new Vector.<uint>(MAX_QUADS, true);
			for (n = 0; n < count; n++) {
				alphas[n] = 1.0;
			}
			for (i = 0; i < nodeColors.length; i++) {
				nodeColors[i] = 1.0;
			}
			for (i = 0; i < pose.length; i++) {
				pose[i] = definition.rest[i];
			}
			for each (rigSwitch in assets.art.switches) {
				switchStates[rigSwitch.name] = rigSwitch.initial;
			}

			vertexData = new VertexData(TilePieceStyle.VERTEX_FORMAT, MAX_QUADS * 4);
			vertexData.premultipliedAlpha = true;
			if (vertexData.vertexSize != VERTEX_SIZE || vertexData.getOffset("texCoords") != 8 || vertexData.getOffset("color") != 16
				|| vertexData.getOffset("materialTexCoords") != 20) {
				trace("Rig.as/Rig() - Error: TilePieceStyle's vertex layout isn't the one Rig writes, so rigs draw garbage");
			}
			indexData = new IndexData(MAX_QUADS * 6);
			for (i = 0; i < MAX_QUADS; i++) {
				indexData.addQuad(i * 4, i * 4 + 1, i * 4 + 2, i * 4 + 3);
			}
			vertexData.numVertices = 0;
			indexData.numIndices = 0;

			dress();
			// The mask sampler reads the same page as the images, so the style takes it before the mesh exists
			style = new TilePieceStyle(art.page);
			style.texture = art.page;
			style.mipBias = MIP_BIAS;
			mesh = new Mesh(vertexData, indexData, style);
			mesh.textureSmoothing = TextureSmoothing.TRILINEAR;
			mesh.touchable = false;
		}

		// Puts on look: rebuilds the images each drawing wears
		public function dress():void {
			var armor:RigArmor_Definition = look.armor != "" ? assets.art.armor[look.armor] : null;
			var worn:RigArt = art;
			var n:int;
			var name:String;
			var drawing:RigDrawing_Definition;
			var styleIndex:int;
			var frames:Vector.<AtlasClip>;
			var key:String;
			var clip:AtlasClip;
			var mask:RigDrawing_Definition;

			if (look.armor != "" && !armor) {
				trace("Rig.as/dress() - Warning: no armour \"" + look.armor + "\", so the rig wears none");
			}
			art = assets.artFor(look);
			if (worn) {
				assets.release(worn);
			}
			if (style) {
				style.texture = art.page;
				style.material = art.page;
			}

			layerFrames		= new Vector.<Vector.<AtlasClip>>();
			layerTints		= new Vector.<String>();
			layerPlacements	= new Vector.<Vector.<Number>>();
			layerLoopFroms	= new Vector.<int>();
			for (n = 0; n < definition.names.length; n++) {
				name = definition.drawings[n];
				drawing = name ? assets.art.drawings[name] : null;
				firstLayers[n] = layerFrames.length;
				layerCounts[n] = 0;
				maskNodes[n] = -1;
				maskClips[n] = null;
				isMaskNode[n] = drawing != null && drawing.isMask;
				if (!drawing || drawing.isMask) { continue; }

				styleIndex = Math.min(look.styleOf(drawing.style), drawing.images.length) - 1;
				if (!drawing.isArmorOnly && !(armor && armor.coversBase.indexOf(name) >= 0) && styleIndex >= 0) {
					frames = new Vector.<AtlasClip>();
					for each (key in drawing.images[styleIndex]) {
						clip = art.clips[key];
						if (clip) {
							frames.push(clip);
						}
						else {
							trace("Rig.as/dress() - Warning: drawing \"" + name + "\" has no image \"" + key + "\"");
						}
					}
					if (frames.length > 0) {
						layerFrames.push(frames);
						layerTints.push(drawing.tint);
						layerPlacements.push(drawing.placements ? drawing.placements[Math.min(styleIndex, drawing.placements.length - 1)] : null);
						layerLoopFroms.push(drawing.loopFrom);
						layerCounts[n]++;
					}
				}
				if (armor && armor.images[name] && art.clips[armor.images[name]]) {
					layerFrames.push(new <AtlasClip>[art.clips[armor.images[name]]]);
					layerTints.push("");
					layerPlacements.push(null);
					layerLoopFroms.push(0);
					layerCounts[n]++;
				}
				if (drawing.maskedBy != "") {
					mask = assets.art.drawings[drawing.maskedBy];
					maskNodes[n] = definition.drawings.indexOf(drawing.maskedBy);
					if (mask && maskNodes[n] >= 0) {
						maskClips[n] = art.clips[mask.images[Math.min(look.styleOf(mask.style), mask.images.length) - 1][0]];
					}
				}
			}
			layerRgbs = new Vector.<uint>(layerFrames.length, true);
			forgetSlots();
			recolor();
			applySwitches();
		}

		// Takes up colors after they change
		public function recolor():void {
			var layer:int;
			var tint:String;

			for (layer = 0; layer < layerTints.length; layer++) {
				tint = layerTints[layer];
				layerRgbs[layer] = tint != "" && colors[tint] !== undefined ? uint(colors[tint]) : 0xFFFFFF;
			}
		}

		// Starts the animation from its first frame, as Flash does when another animation's clip replaces the current one.
		// Asking for the animation already playing changes nothing, unless again is set.
		public function play(name:String, again:Boolean = false):void {
			var next:RigAnimation_Definition = definition.animations[name];
			var rigSwitch:RigSwitch_Definition;
			var n:int;
			var i:int;

			if (!next) {
				trace("Rig.as/play() - Warning: no animation \"" + name + "\"");
				return;
			}
			if (animation == next && !again) { return; }

			// What the last animation moved and coloured goes back to rest
			if (animation) {
				for each (n in animation.nodes) {
					for (i = 0; i < POSE_FLOATS; i++) {
						pose[n * POSE_FLOATS + i] = definition.rest[n * POSE_FLOATS + i];
					}
				}
				for each (n in animation.colorNodes) {
					for (i = 0; i < 4; i++) {
						nodeColors[n * 4 + i] = 1.0;
					}
				}
			}
			animation = next;
			for each (rigSwitch in assets.art.switches) {
				if (rigSwitch.isPerAnimation) {
					switchStates[rigSwitch.name] = rigSwitch.initial;
				}
			}
			for (n = 0; n < loopStarts.length; n++) {
				loopStarts[n] = ticks;
			}
			applySwitches();
			isPlaying = true;
			enter(0);
		}

		// The animation playing, or "" before the first play()
		public function get animationName():String {
			return animation ? animation.name : "";
		}

		public function get totalFrames():int {
			return animation ? animation.frameCount : 0;
		}

		// Moves the playhead to target (counted from 0), playing on from there or holding it. As in Flash, a target past the
		// end goes to the last frame, and going to the frame already shown doesn't run its script again.
		public function goTo(target:int, play:Boolean):void {
			var shown:int;

			if (!animation) { return; }

			if (target < 0) {
				trace("Rig.as/goTo() - Warning: animation \"" + animation.name + "\" has no frame " + target);
				return;
			}
			shown = Math.min(target, animation.frameCount - 1);
			isPlaying = play;
			if (shown != frame) {
				enter(shown);
			}
		}

		// Moves the playhead to a label's frame, playing on from there or holding it
		public function goToLabel(label:String, play:Boolean):void {
			if (!animation) { return; }

			if (animation.labels[label] === undefined) {
				trace("Rig.as/goToLabel() - Warning: animation \"" + animation.name + "\" has no label \"" + label + "\"");
				return;
			}
			goTo(int(animation.labels[label]), play);
		}

		// One game frame: the playhead and the drawings' own loops move on
		public function advance():void {
			var next:int;

			ticks++;
			if (!animation || !isPlaying) { return; }

			next = frame + 1;
			if (next >= animation.frameCount) {
				next = 0;
			}
			enter(next);
		}

		public function setSwitch(name:String, state:String):void {
			setSwitchState(name, state);
		}

		public function getSwitch(name:String):String {
			return switchStates[name];
		}

		// Turns a node by angle (radians, clockwise) on top of the animation's turn; 0 lets it follow the animation again
		public function turn(name:String, angle:Number):void {
			if (definition.byName[name] === undefined) {
				trace("Rig.as/turn() - Warning: no node \"" + name + "\"");
				return;
			}
			turns[definition.byName[name]] = angle;
		}

		// Moves a node by dx, dy from where the animation puts it, in its parent's space
		public function shift(name:String, dx:Number, dy:Number):void {
			var n:int;

			if (definition.byName[name] === undefined) {
				trace("Rig.as/shift() - Warning: no node \"" + name + "\"");
				return;
			}
			n = definition.byName[name];
			shifts[n * 2] = dx;
			shifts[n * 2 + 1] = dy;
		}

		// How opaque a drawing is, wherever it is worn, 0 to 1
		public function setAlpha(drawing:String, alpha:Number):void {
			var n:int;
			var isFound:Boolean = false;

			for (n = 0; n < definition.drawings.length; n++) {
				if (definition.drawings[n] == drawing) {
					alphas[n] = alpha;
					isFound = true;
				}
			}
			if (!isFound) {
				trace("Rig.as/setAlpha() - Warning: no drawing \"" + drawing + "\"");
			}
		}

		// Draws the whole rig through a Flash colour transform, or in its own colours for null
		public function setTint(tint:ColorTransform):void {
			style.tint = tint;
			mesh.setRequiresRedraw();
		}

		// Where a node's origin was on the screen when the rig last rendered
		public function pointOf(name:String, out:Point):Point {
			var w:int = int(definition.byName[name]) * WORLD_FLOATS;

			out.x = world[w + 4];
			out.y = world[w + 5];

			return out;
		}

		// Poses the rig fraction of the way from the shown frame to the next one, and writes its mesh.
		// fraction is 0 when the game renders once per game frame.
		public function render(fraction:Number):void {
			var next:int;

			if (animation) {
				next = frame;
				if (isPlaying && fraction > 0.0) {
					next = frame + 1 < animation.frameCount ? frame + 1 : 0;
					// No blending across a jump: the script's frame shows at once
					if (animation.shows[next] != next) {
						next = frame;
					}
				}
				sample(frame, next, next == frame ? 0.0 : fraction);
			}
			place();
			draw();
		}

		// Hands the look's atlas back; the rig can't be drawn after this
		public function dispose():void {
			mesh.dispose();
			assets.release(art);
			art = null;
		}
	}
}
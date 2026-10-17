package fe.game.rendering.rig {

	import flash.utils.ByteArray;
	import flash.utils.Endian;

	// Reads a glTF 2.0 rig: node transforms, the drawing each node shows, and animations, which it samples once per frame. glTF's y points up, so y and angles flip into the game's y-down space as they are read.
	public class GltfReader {

		private static const FLOAT:int			= 5126;		// glTF's componentType for 32-bit floats
		private static const POSE_FLOATS:int	= 6;		// Per node: x, y, depth, angle, scaleX, scaleY
		private static const KEY_SLACK:Number	= 0.00001;	// Seconds a key may sit past a frame's time and still count as reached -- key times are 32-bit floats
		private static const SAME:Number		= 0.000001;	// Pose values closer than this count as unchanged

		// The accessor's numbers, components flattened in order
		private static function floats(json:Object, bin:ByteArray, index:int):Vector.<Number> {
			var accessor:Object = json.accessors[index];
			var view:Object = json.bufferViews[accessor.bufferView];
			var size:int = {SCALAR: 1, VEC2: 2, VEC3: 3, VEC4: 4}[accessor.type];
			var out:Vector.<Number> = new Vector.<Number>(accessor.count * size, true);
			var i:int;

			if (accessor.componentType != FLOAT) {
				trace("GltfReader.as/floats() - Error: accessor " + index + " isn't floats, so it reads as zeros");
				return out;
			}
			if (view.byteStride && view.byteStride != size * 4) {
				trace("GltfReader.as/floats() - Error: accessor " + index + " is interleaved, which isn't supported, so it reads as zeros");
				return out;
			}

			bin.endian = Endian.LITTLE_ENDIAN;
			bin.position = (view.byteOffset || 0) + (accessor.byteOffset || 0);
			for (i = 0; i < out.length; i++) {
				out[i] = bin.readFloat();
			}

			return out;
		}

		// The angle of a rotation about z, in y-down space
		private static function angle(qz:Number, qw:Number):Number {
			return -2.0 * Math.atan2(qz, qw);
		}

		private static function addOrder(definition:Rig_Definition, node:int, children:Array):void {
			var child:int;

			definition.order.push(node);
			for each (child in children[node]) {
				addOrder(definition, child, children);
			}
		}

		// A channel's keys as pose values: x, y, depth for translation; an angle for rotation, taken nearest the last key so blending turns the short way; x, y for scale
		private static function poseValues(path:String, raw:Vector.<Number>, count:int):Vector.<Number> {
			var values:Vector.<Number> = new Vector.<Number>();
			var k:int;
			var a:Number;

			for (k = 0; k < count; k++) {
				switch (path) {
					case "translation": {
						values.push(raw[k * 3], -raw[k * 3 + 1], raw[k * 3 + 2]);
						break;
					}
					case "rotation": {
						a = angle(raw[k * 4 + 2], raw[k * 4 + 3]);
						if (k > 0) {
							while (a - values[k - 1] > Math.PI) {
								a -= Math.PI * 2.0;
							}
							while (a - values[k - 1] < -Math.PI) {
								a += Math.PI * 2.0;
							}
						}
						values.push(a);
						break;
					}
					default: {
						values.push(raw[k * 3], raw[k * 3 + 1]);
						break;
					}
				}
			}

			return values;
		}

		// Samples every channel once per frame onto the rest pose, and keeps the nodes that move or differ from rest
		private static function readAnimation(json:Object, bin:ByteArray, animation:Object, definition:Rig_Definition):RigAnimation_Definition {
			var result:RigAnimation_Definition = new RigAnimation_Definition();
			var channel:Object;
			var sampler:Object;
			var path:String;
			var times:Vector.<Number>;
			var values:Vector.<Number>;
			var duration:Number = 0.0;
			var channels:Array = [];
			var touched:Object = {};
			var held:Object = {};
			var node:int;
			var nodeKey:String;
			var frames:Vector.<Number>;
			var at:int;
			var stride:int;
			var f:int;
			var k:int;
			var i:int;
			var time:Number;
			var blend:Number;
			var moved:Boolean;

			for each (channel in animation.channels) {
				sampler = animation.samplers[channel.sampler];
				path = channel.target.path;
				if (path != "translation" && path != "rotation" && path != "scale") {
					trace("GltfReader.as/readAnimation() - Warning: animation \"" + animation.name + "\" keys \"" + path + "\", which rigs don't use");
					continue;
				}
				times = floats(json, bin, sampler.input);
				values = poseValues(path, floats(json, bin, sampler.output), times.length);
				channels.push({node: channel.target.node, path: path, times: times, values: values, step: sampler.interpolation == "STEP"});
				duration = Math.max(duration, times[times.length - 1]);
				if (path == "scale" && sampler.interpolation == "STEP") {
					held[channel.target.node] = true;
				}
			}

			result.name = animation.name;
			result.frameCount = Math.round(duration * definition.fps) + 1;

			// Each touched node's pose on every frame, starting from rest
			for each (channel in channels) {
				node = channel.node;
				if (!touched[node]) {
					frames = new Vector.<Number>(result.frameCount * POSE_FLOATS, true);
					for (f = 0; f < result.frameCount; f++) {
						for (i = 0; i < POSE_FLOATS; i++) {
							frames[f * POSE_FLOATS + i] = definition.rest[node * POSE_FLOATS + i];
						}
					}
					touched[node] = frames;
				}
				frames = touched[node];
				at = channel.path == "translation" ? 0 : (channel.path == "rotation" ? 3 : 4);
				stride = channel.path == "translation" ? 3 : (channel.path == "rotation" ? 1 : 2);
				times = channel.times;
				values = channel.values;
				k = 0;
				for (f = 0; f < result.frameCount; f++) {
					time = f / definition.fps;
					while (k < times.length - 1 && times[k + 1] <= time + KEY_SLACK) {
						k++;
					}
					blend = (k < times.length - 1 && !channel.step) ? (time - times[k]) / (times[k + 1] - times[k]) : 0.0;
					blend = Math.max(0.0, Math.min(1.0, blend));
					for (i = 0; i < stride; i++) {
						frames[f * POSE_FLOATS + at + i] = values[k * stride + i] + (blend > 0.0 ? (values[(k + 1) * stride + i] - values[k * stride + i]) * blend : 0.0);
					}
				}
			}

			// Only nodes that move, or sit somewhere other than rest, are kept
			for (nodeKey in touched) {
				node = int(nodeKey);
				frames = touched[nodeKey];
				moved = false;
				for (i = 0; i < frames.length && !moved; i++) {
					moved = Math.abs(frames[i] - definition.rest[node * POSE_FLOATS + i % POSE_FLOATS]) > SAME;
				}
				if (moved) {
					result.nodes.push(node);
				}
			}
			result.nodes.sort(Array.NUMERIC);
			for each (node in result.nodes) {
				result.heldScales.push(held[node] == true);
			}
			result.poses = new Vector.<Number>(result.frameCount * result.nodes.length * POSE_FLOATS, true);
			for (i = 0; i < result.nodes.length; i++) {
				frames = touched[result.nodes[i]];
				for (f = 0; f < result.frameCount; f++) {
					for (k = 0; k < POSE_FLOATS; k++) {
						result.poses[(f * result.nodes.length + i) * POSE_FLOATS + k] = frames[f * POSE_FLOATS + k];
					}
				}
			}

			return result;
		}

		public static function read(json:Object, bin:ByteArray, fps:Number):Rig_Definition {
			var definition:Rig_Definition = new Rig_Definition();
			var children:Array = [];
			var node:Object;
			var i:int;
			var child:int;
			var t:Array;
			var r:Array;
			var s:Array;
			var root:int;
			var animation:Object;

			definition.fps = fps;
			for (i = 0; i < json.nodes.length; i++) {
				node = json.nodes[i];
				t = node.translation || [0.0, 0.0, 0.0];
				r = node.rotation || [0.0, 0.0, 0.0, 1.0];
				s = node.scale || [1.0, 1.0, 1.0];
				if (node.matrix) {
					trace("GltfReader.as/read() - Error: node \"" + node.name + "\" uses a matrix instead of position, rotation and scale, which isn't supported");
				}
				definition.names.push(node.name);
				definition.byName[node.name] = i;
				definition.parents.push(-1);
				definition.rest.push(t[0], -t[1], t[2], angle(r[2], r[3]), s[0], s[1]);
				definition.drawings.push(node.extras && node.extras.drawing ? node.extras.drawing : null);
				children.push(node.children || []);
			}
			for (i = 0; i < json.nodes.length; i++) {
				for each (child in children[i]) {
					definition.parents[child] = i;
				}
			}
			for each (root in json.scenes[json.scene || 0].nodes) {
				addOrder(definition, root, children);
			}

			for each (animation in json.animations || []) {
				definition.animations[animation.name] = readAnimation(json, bin, animation, definition);
			}

			return definition;
		}
	}
}
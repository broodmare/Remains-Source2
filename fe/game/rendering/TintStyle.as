package fe.game.rendering {

	import flash.geom.ColorTransform;

	import starling.rendering.MeshEffect;
	import starling.rendering.RenderState;
	import starling.styles.MeshStyle;

	// Draws a mesh through a Flash colour transform: multipliers that may brighten past 1, and offsets. Each channel is clamped before alpha applies, as Flash does.
	public class TintStyle extends MeshStyle {

		public var tint:ColorTransform;		// null draws the texture's own colours
		public var mipBias:Number = 0.0;	// Shifts which mip level is sampled: below 0 is sharper, at the risk of shimmer

		// Starling also copies from the plain style a mesh had before, which has no tint
		override public function copyFrom(meshStyle:MeshStyle):void {
			var other:TintStyle = meshStyle as TintStyle;

			if (other) {
				tint	= other.tint;
				mipBias	= other.mipBias;
			}
			super.copyFrom(meshStyle);
		}

		override public function createEffect():MeshEffect {
			return new TintEffect();
		}

		override public function updateEffect(effect:MeshEffect, state:RenderState):void {
			TintEffect(effect).tint = tint;
			TintEffect(effect).mipBias = mipBias;
			super.updateEffect(effect, state);
		}

		override public function canBatchWith(meshStyle:MeshStyle):Boolean {
			var other:TintStyle = meshStyle as TintStyle;

			return other != null && other.mipBias == mipBias && isSameTint(other.tint, tint) && super.canBatchWith(meshStyle);
		}

		private static function isSameTint(a:ColorTransform, b:ColorTransform):Boolean {
			if (a == b) { return true; }
			if (!a || !b) { return false; }

			return a.redMultiplier == b.redMultiplier && a.greenMultiplier == b.greenMultiplier && a.blueMultiplier == b.blueMultiplier
				&& a.alphaMultiplier == b.alphaMultiplier && a.redOffset == b.redOffset && a.greenOffset == b.greenOffset
				&& a.blueOffset == b.blueOffset && a.alphaOffset == b.alphaOffset;
		}
	}
}

import flash.display3D.Context3D;
import flash.display3D.Context3DProgramType;
import flash.geom.ColorTransform;

import starling.rendering.MeshEffect;
import starling.rendering.Program;

class TintEffect extends MeshEffect {

	private static const EPSILON:Number = 0.001;		// Keeps unpremultiplying away from a divide by zero
	private static const CHANNEL:Number = 255.0;		// Flash's offsets are in channel steps

	private static var multipliers:Vector.<Number>	= new <Number>[1.0, 1.0, 1.0, 1.0];
	private static var offsets:Vector.<Number>		= new <Number>[0.0, 0.0, 0.0, 0.0];
	private static var math:Vector.<Number>			= new <Number>[EPSILON, 0.0, 0.0, 0.0];

	public var tint:ColorTransform;
	public var mipBias:Number = 0.0;

	// fc0: multipliers, fc1: offsets from 0 to 1, fc2: epsilon
	override protected function createProgram():Program {
		var vertexShader:String = [
			"m44 op, va0, vc0",			// Position to clip space
			"mov v0, va1",				// Texture coordinates
			"mul v1, va2, vc4"			// Vertex colour times the render alpha
		].join("\n");
		var fragmentShader:String = [
			tex("ft0", "v0", 0, texture).replace(">", mipBias != 0.0 ? ", " + mipBias + ">" : ">"),

			// Unpremultiply, transform and clamp, then premultiply again
			"max ft1.w, ft0.w, fc2.x",
			"div ft0.xyz, ft0.xyz, ft1.www",
			"mul ft0, ft0, fc0",
			"add ft0, ft0, fc1",
			"sat ft0, ft0",
			"mul ft0.xyz, ft0.xyz, ft0.www",

			"mul oc, ft0, v1"
		].join("\n");

		return Program.fromSource(vertexShader, fragmentShader);
	}

	override protected function get programVariantName():uint {
		return super.programVariantName | ((int(mipBias * 8.0) & 0xFF) << 16);
	}

	override protected function beforeDraw(context:Context3D):void {
		super.beforeDraw(context);

		multipliers[0]	= tint ? tint.redMultiplier : 1.0;
		multipliers[1]	= tint ? tint.greenMultiplier : 1.0;
		multipliers[2]	= tint ? tint.blueMultiplier : 1.0;
		multipliers[3]	= tint ? tint.alphaMultiplier : 1.0;
		offsets[0]		= tint ? tint.redOffset / CHANNEL : 0.0;
		offsets[1]		= tint ? tint.greenOffset / CHANNEL : 0.0;
		offsets[2]		= tint ? tint.blueOffset / CHANNEL : 0.0;
		offsets[3]		= tint ? tint.alphaOffset / CHANNEL : 0.0;
		context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, multipliers);
		context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 1, offsets);
		context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 2, math);
	}
}
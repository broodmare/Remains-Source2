package fe.game.rendering {

	import flash.geom.ColorTransform;

	import starling.rendering.MeshEffect;
	import starling.rendering.RenderState;
	import starling.styles.MeshStyle;
	import starling.textures.Texture;

	// Draws the room's back wall lit: tinted, blended with the room's light in hard light, then shaded by the room's shadow
	public class WallLightStyle extends MeshStyle {

		public var light:Texture;					// Darkness and light shapes, the same size as the wall
		public var shadow:Texture;					// The room's shadow, the same size as the wall; only its alpha counts
		public var tint:ColorTransform;				// The room's colour, applied to the wall before the light
		public var transparentBack:Boolean;			// The sky shows through gaps in the wall, so light and shadow keep to the wall

		// Starling also copies from the plain style a mesh had before, which has none of these
		override public function copyFrom(meshStyle:MeshStyle):void {
			var other:WallLightStyle = meshStyle as WallLightStyle;

			if (other) {
				light			= other.light;
				shadow			= other.shadow;
				tint			= other.tint;
				transparentBack	= other.transparentBack;
			}
			super.copyFrom(meshStyle);
		}

		override public function createEffect():MeshEffect {
			return new WallLightEffect();
		}

		override public function updateEffect(effect:MeshEffect, state:RenderState):void {
			var wallEffect:WallLightEffect = WallLightEffect(effect);

			wallEffect.light			= light;
			wallEffect.shadow			= shadow;
			wallEffect.tint				= tint;
			wallEffect.transparentBack	= transparentBack;
			super.updateEffect(effect, state);
		}

		// Each room has one wall image, so there is never anything to batch it with
		override public function canBatchWith(meshStyle:MeshStyle):Boolean {
			return false;
		}
	}
}

import flash.display3D.Context3D;
import flash.display3D.Context3DProgramType;
import flash.geom.ColorTransform;

import fe.engine.utils.Numbers;

import starling.rendering.MeshEffect;
import starling.rendering.Program;
import starling.textures.Texture;
import starling.textures.TextureSmoothing;
import starling.utils.RenderUtil;

class WallLightEffect extends MeshEffect {

	private static var tintConstants:Vector.<Number>	= new <Number>[1.0, 1.0, 1.0, 0.0];
	private static var mathConstants:Vector.<Number>	= new <Number>[0.5, 1.0, 2.0, Numbers.EPSILON];
	private static var backConstants:Vector.<Number>	= new <Number>[0.0, 0.0, 0.0, 0.0];

	public var light:Texture;
	public var shadow:Texture;
	public var tint:ColorTransform;
	public var transparentBack:Boolean;

	// fc0: tint, fc1: 0.5, 1, 2, epsilon, fc2: 1 when the back is transparent
	override protected function createProgram():Program {
		var vertexShader:String = [
			"m44 op, va0, vc0",
			"mov v0, va1",
			"mul v1, va2, vc4"
		].join("\n");
		var fragmentShader:String = [
			tex("ft0", "v0", 0, texture),		// Wall
			tex("ft1", "v0", 1, light),			// Light
			tex("ft2", "v0", 2, shadow),		// Shadow

			// Tinted wall colour, unpremultiplied
			"max ft3.w, ft0.w, fc1.w",
			"div ft3.xyz, ft0.xyz, ft3.www",
			"mul ft3.xyz, ft3.xyz, fc0.xyz",
			"sat ft3.xyz, ft3.xyz",

			// Light colour, unpremultiplied
			"max ft4.w, ft1.w, fc1.w",
			"div ft4.xyz, ft1.xyz, ft4.www",

			// Hard light: multiply where the light is under half, screen where it is over
			"mul ft5.xyz, ft4.xyz, ft3.xyz",
			"mul ft5.xyz, ft5.xyz, fc1.zzz",
			"sub ft6.xyz, fc1.yyy, ft4.xyz",
			"sub ft7.xyz, fc1.yyy, ft3.xyz",
			"mul ft6.xyz, ft6.xyz, ft7.xyz",
			"mul ft6.xyz, ft6.xyz, fc1.zzz",
			"sub ft6.xyz, fc1.yyy, ft6.xyz",
			"sge ft7.xyz, ft4.xyz, fc1.xxx",
			"sub ft6.xyz, ft6.xyz, ft5.xyz",
			"mul ft6.xyz, ft6.xyz, ft7.xyz",
			"add ft5.xyz, ft5.xyz, ft6.xyz",

			// Light over the wall: light alone where there is no wall, the blend where both are
			"sub ft6.w, fc1.y, ft0.w",
			"mul ft6.xyz, ft1.xyz, ft6.www",
			"sub ft7.w, fc1.y, ft1.w",
			"mul ft7.w, ft7.w, ft0.w",
			"mul ft7.xyz, ft3.xyz, ft7.www",
			"add ft6.xyz, ft6.xyz, ft7.xyz",
			"mul ft7.w, ft1.w, ft0.w",
			"mul ft5.xyz, ft5.xyz, ft7.www",
			"add ft6.xyz, ft6.xyz, ft5.xyz",
			"add ft6.w, ft1.w, ft0.w",
			"sub ft6.w, ft6.w, ft7.w",

			// Shadow over the lit wall
			"sub ft7.z, fc1.y, ft2.w",
			"mul ft6.xyz, ft6.xyz, ft7.zzz",
			"sub ft7.w, fc1.y, ft6.w",
			"mul ft7.w, ft7.w, ft2.w",
			"add ft6.w, ft6.w, ft7.w",

			// A transparent back keeps the wall's own alpha, so light and shadow never cover the sky
			"sub ft7.x, ft0.w, ft6.w",
			"mul ft7.x, ft7.x, fc2.x",
			"add ft7.x, ft6.w, ft7.x",
			"max ft6.w, ft6.w, fc1.w",
			"div ft6.xyz, ft6.xyz, ft6.www",
			"mul ft6.xyz, ft6.xyz, ft7.xxx",
			"mov ft6.w, ft7.x",

			"mul oc, ft6, v1"
		].join("\n");

		return Program.fromSource(vertexShader, fragmentShader);
	}

	override protected function get programVariantName():uint {
		return super.programVariantName | (RenderUtil.getTextureVariantBits(light) << 8) | (RenderUtil.getTextureVariantBits(shadow) << 12);
	}

	override protected function beforeDraw(context:Context3D):void {
		super.beforeDraw(context);

		tintConstants[0] = tint.redMultiplier;
		tintConstants[1] = tint.greenMultiplier;
		tintConstants[2] = tint.blueMultiplier;
		backConstants[0] = transparentBack ? 1.0 : 0.0;
		context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, tintConstants);
		context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 1, mathConstants);
		context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 2, backConstants);

		RenderUtil.setSamplerStateAt(1, false, textureSmoothing, false);
		RenderUtil.setSamplerStateAt(2, false, TextureSmoothing.BILINEAR, false);	// The shadow is smaller than the wall
		context.setTextureAt(1, light.base);
		context.setTextureAt(2, shadow.base);
	}

	override protected function afterDraw(context:Context3D):void {
		context.setTextureAt(1, null);
		context.setTextureAt(2, null);
		super.afterDraw(context);
	}
}

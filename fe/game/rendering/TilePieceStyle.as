package fe.game.rendering {

	import flash.geom.ColorTransform;

	import starling.rendering.MeshEffect;
	import starling.rendering.RenderState;
	import starling.rendering.VertexDataFormat;
	import starling.styles.MeshStyle;
	import starling.textures.Texture;

	// Draws tile pieces on the GPU: a RepeatingTexture across the room, cut to shape by a mask from a ClipAtlas.
	// Rigs draw with it too, their images and masks on one atlas page.
	public class TilePieceStyle extends MeshStyle {
		public static const VERTEX_FORMAT:VertexDataFormat = MeshStyle.VERTEX_FORMAT.extend("materialTexCoords:float2");

		public var material:Texture;		// A RepeatingTexture's texture, sampled at materialTexCoords
		public var mipBias:Number = 0.0;	// Shifts which mip level the material samples: below 0 is sharper, at the risk of shimmer
		public var tint:ColorTransform;		// A Flash colour transform over the result, applied as TintStyle applies it, or null

		public function TilePieceStyle(material_:Texture = null) {
			material = material_;
		}

		// Starling also copies from the plain style a mesh had before, which has no material
		override public function copyFrom(meshStyle:MeshStyle):void {
			var other:TilePieceStyle = meshStyle as TilePieceStyle;

			if (other) {
				material	= other.material;
				mipBias		= other.mipBias;
				tint		= other.tint;
			}
			super.copyFrom(meshStyle);
		}

		override public function createEffect():MeshEffect {
			return new TilePieceEffect();
		}

		override public function updateEffect(effect:MeshEffect, state:RenderState):void {
			TilePieceEffect(effect).material = material;
			TilePieceEffect(effect).mipBias = mipBias;
			TilePieceEffect(effect).tint = tint;
			super.updateEffect(effect, state);
		}

		override public function canBatchWith(meshStyle:MeshStyle):Boolean {
			var other:TilePieceStyle = meshStyle as TilePieceStyle;

			return other != null && other.material.root == material.root && other.mipBias == mipBias && other.tint == tint
				&& super.canBatchWith(meshStyle);
		}

		override public function get vertexFormat():VertexDataFormat {
			return VERTEX_FORMAT;
		}
	}
}

import flash.display3D.Context3D;
import flash.display3D.Context3DProgramType;
import flash.geom.ColorTransform;

import starling.rendering.MeshEffect;
import starling.rendering.Program;
import starling.rendering.VertexDataFormat;
import starling.textures.Texture;
import starling.textures.TextureSmoothing;
import starling.utils.RenderUtil;

import fe.game.rendering.TilePieceStyle;

class TilePieceEffect extends MeshEffect {

	private static const EPSILON:Number = 0.001;		// Keeps unpremultiplying away from a divide by zero
	private static const CHANNEL:Number = 255.0;		// Flash's offsets are in channel steps

	private static var multipliers:Vector.<Number>	= new <Number>[1.0, 1.0, 1.0, 1.0];
	private static var offsets:Vector.<Number>		= new <Number>[0.0, 0.0, 0.0, 0.0];
	private static var math:Vector.<Number>			= new <Number>[EPSILON, 0.0, 0.0, 0.0];

	public var material:Texture;
	public var mipBias:Number = 0.0;
	public var tint:ColorTransform;

	// With a tint, fc0: multipliers, fc1: offsets from 0 to 1, fc2: epsilon
	override protected function createProgram():Program {
		var vertexShader:String = [
			"m44 op, va0, vc0",			// Position to clip space
			"mov v0, va1",				// Mask coordinates
			"mul v1, va2, vc4",			// Vertex colour times the render alpha
			"mov v2, va3"				// Material coordinates
		].join("\n");
		var fragment:Array = [
			tex("ft0", "v0", 0, texture),
			tex("ft1", "v2", 1, material).replace(">", mipBias != 0.0 ? ", " + mipBias + ">" : ">"),
			"mul ft1, ft1, ft0.wwww",	// Cut the material to the mask
			"mul ft1, ft1, v1"
		];

		if (tint) {
			// Unpremultiply, transform and clamp, then premultiply again
			fragment.push(
				"max ft2.w, ft1.w, fc2.x",
				"div ft1.xyz, ft1.xyz, ft2.www",
				"mul ft1, ft1, fc0",
				"add ft1, ft1, fc1",
				"sat ft1, ft1",
				"mul ft1.xyz, ft1.xyz, ft1.www"
			);
		}
		fragment.push("mov oc, ft1");

		return Program.fromSource(vertexShader, fragment.join("\n"));
	}

	override protected function get programVariantName():uint {
		return super.programVariantName | (RenderUtil.getTextureVariantBits(material) << 8) | ((int(mipBias * 8.0) & 0xFF) << 16)
			| ((tint ? 1 : 0) << 24);
	}

	override protected function beforeDraw(context:Context3D):void {
		super.beforeDraw(context);
		// Quads never cross from one copy of the material to the next, so the texture is clamped rather than repeated
		RenderUtil.setSamplerStateAt(1, material.mipMapping, TextureSmoothing.TRILINEAR, false);
		context.setTextureAt(1, material.base);
		vertexFormat.setVertexBufferAt(3, vertexBuffer, "materialTexCoords");
		if (tint) {
			multipliers[0]	= tint.redMultiplier;
			multipliers[1]	= tint.greenMultiplier;
			multipliers[2]	= tint.blueMultiplier;
			multipliers[3]	= tint.alphaMultiplier;
			offsets[0]		= tint.redOffset / CHANNEL;
			offsets[1]		= tint.greenOffset / CHANNEL;
			offsets[2]		= tint.blueOffset / CHANNEL;
			offsets[3]		= tint.alphaOffset / CHANNEL;
			context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, multipliers);
			context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 1, offsets);
			context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 2, math);
		}
	}

	override protected function afterDraw(context:Context3D):void {
		context.setTextureAt(1, null);
		context.setVertexBufferAt(3, null);
		super.afterDraw(context);
	}

	override public function get vertexFormat():VertexDataFormat {
		return TilePieceStyle.VERTEX_FORMAT;
	}
}
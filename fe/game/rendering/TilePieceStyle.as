package fe.game.rendering {

	import starling.rendering.MeshEffect;
	import starling.rendering.RenderState;
	import starling.rendering.VertexDataFormat;
	import starling.styles.MeshStyle;
	import starling.textures.Texture;

	// Draws tile pieces on the GPU: a RepeatingTexture across the room, cut to shape by a mask from a ClipAtlas
	public class TilePieceStyle extends MeshStyle {
		public static const VERTEX_FORMAT:VertexDataFormat = MeshStyle.VERTEX_FORMAT.extend("materialTexCoords:float2");

		public var material:Texture;		// A RepeatingTexture's texture, sampled at materialTexCoords
		public var mipBias:Number = 0.0;	// Shifts which mip level the material samples: below 0 is sharper, at the risk of shimmer

		public function TilePieceStyle(material_:Texture = null) {
			material = material_;
		}

		// Starling also copies from the plain style a mesh had before, which has no material
		override public function copyFrom(meshStyle:MeshStyle):void {
			var other:TilePieceStyle = meshStyle as TilePieceStyle;

			if (other) {
				material	= other.material;
				mipBias		= other.mipBias;
			}
			super.copyFrom(meshStyle);
		}

		override public function createEffect():MeshEffect {
			return new TilePieceEffect();
		}

		override public function updateEffect(effect:MeshEffect, state:RenderState):void {
			TilePieceEffect(effect).material = material;
			TilePieceEffect(effect).mipBias = mipBias;
			super.updateEffect(effect, state);
		}

		override public function canBatchWith(meshStyle:MeshStyle):Boolean {
			var other:TilePieceStyle = meshStyle as TilePieceStyle;

			return other != null && other.material.root == material.root && other.mipBias == mipBias && super.canBatchWith(meshStyle);
		}

		override public function get vertexFormat():VertexDataFormat {
			return VERTEX_FORMAT;
		}
	}
}

import flash.display3D.Context3D;

import starling.rendering.MeshEffect;
import starling.rendering.Program;
import starling.rendering.VertexDataFormat;
import starling.textures.Texture;
import starling.textures.TextureSmoothing;
import starling.utils.RenderUtil;

import fe.game.rendering.TilePieceStyle;

class TilePieceEffect extends MeshEffect {

	public var material:Texture;
	public var mipBias:Number = 0.0;

	override protected function createProgram():Program {
		var vertexShader:String = [
			"m44 op, va0, vc0",			// Position to clip space
			"mov v0, va1",				// Mask coordinates
			"mul v1, va2, vc4",			// Vertex colour times the render alpha
			"mov v2, va3"				// Material coordinates
		].join("\n");
		var fragmentShader:String = [
			tex("ft0", "v0", 0, texture),
			tex("ft1", "v2", 1, material).replace(">", mipBias != 0.0 ? ", " + mipBias + ">" : ">"),
			"mul ft1, ft1, ft0.wwww",	// Cut the material to the mask
			"mul oc, ft1, v1"
		].join("\n");

		return Program.fromSource(vertexShader, fragmentShader);
	}

	override protected function get programVariantName():uint {
		return super.programVariantName | (RenderUtil.getTextureVariantBits(material) << 8) | ((int(mipBias * 8.0) & 0xFF) << 16);
	}

	override protected function beforeDraw(context:Context3D):void {
		super.beforeDraw(context);
		// Quads never cross from one copy of the material to the next, so the texture is clamped rather than repeated
		RenderUtil.setSamplerStateAt(1, material.mipMapping, TextureSmoothing.TRILINEAR, false);
		context.setTextureAt(1, material.base);
		vertexFormat.setVertexBufferAt(3, vertexBuffer, "materialTexCoords");
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
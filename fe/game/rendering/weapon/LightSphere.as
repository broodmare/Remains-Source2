package fe.game.rendering.weapon {

	import flash.display.Shape;
	import flash.geom.Matrix;

	// A colourless circle path with a radial palette. Keeping the path as vectors lets an atlas choose its density.
	public class LightSphere {

		public static function neutralPalette():Object {
			return {colors: [0xFFFFFF, 0xFFFFFF, 0xFFFFFF, 0xFFFFFF],
				alphas: [1.0, 1.0, 89.0 / 255.0, 0.0], ratios: [43, 67, 101, 255]};
		}

		public static function create(template:Object, colors:Array = null, alphas:Array = null, ratios:Array = null, radius:Number = NaN):Shape {
			var shape:Shape = new Shape();
			var commands:Vector.<int> = new Vector.<int>();
			var points:Vector.<Number> = new Vector.<Number>();
			var gradient:Array = template.gradientMatrix;
			var scale:Number = isNaN(radius) ? 1.0 : radius / template.radius;
			var matrix:Matrix;
			var value:Number;
			var i:int;
			var neutral:Object = neutralPalette();

			colors = colors || neutral.colors;
			alphas = alphas || neutral.alphas;
			ratios = ratios || neutral.ratios;
			if (!isFinite(scale) || scale <= 0.0 || colors.length < 2 || colors.length > 15 ||
				colors.length != alphas.length || colors.length != ratios.length) {
				throw new ArgumentError("Invalid light sphere radius or palette");
			}
			for (i = 0; i < colors.length; i++) {
				if (!isFinite(colors[i]) || colors[i] < 0 || colors[i] > 0xFFFFFF ||
					!isFinite(alphas[i]) || alphas[i] < 0.0 || alphas[i] > 1.0 ||
					!isFinite(ratios[i]) || ratios[i] < 0 || ratios[i] > 255 ||
					(i > 0 && ratios[i] < ratios[i - 1])) {
					throw new ArgumentError("Invalid light sphere gradient stop");
				}
			}
			for each (value in template.commands) { commands.push(int(value)); }
			for each (value in template.points) { points.push(value * scale); }
			matrix = new Matrix(gradient[0], gradient[1], gradient[2], gradient[3], gradient[4], gradient[5]);
			matrix.scale(scale, scale);
			shape.graphics.beginGradientFill("radial", colors, alphas, ratios, matrix,
				template.spread, template.interpolation, template.focal);
			shape.graphics.drawPath(commands, points, template.winding);
			shape.graphics.endFill();
			return shape;
		}
	}
}

attribute vec3 Position;
attribute vec4 Color;
attribute vec2 TexCoord;
attribute vec4 ColorizeIn;
attribute vec3 ColorOffsetIn;
attribute vec2 TextureSize;
attribute float PixelationAmount;
attribute vec3 ClipPlane;

varying vec4 Color0;
varying vec2 TexCoord0;
varying vec4 ColorizeOut;
varying vec3 ColorOffsetOut;
varying vec2 TextureSizeOut;
varying float PixelationAmountOut;
varying vec3 ClipPlaneOut;

varying float PointScaleMultOut;
varying float FadeAmountOut;
varying float SummonAmountOut;

uniform mat4 Transform;

void main(void)
{
	ColorizeOut = ColorizeIn;
	ColorOffsetOut = ColorOffsetIn;
	
	Color0 = Color;
	TextureSizeOut = TextureSize;
	PixelationAmountOut = PixelationAmount;
	ClipPlaneOut = ClipPlane;
	gl_Position = Transform * vec4(Position.xyz, 1.0);
	TexCoord0 = TexCoord;
	
	// look all we get is the colorize to work with atm so we only get 4 variables IM SORRY
	float pointScale = floor(abs(ColorizeIn.b));
	PointScaleMultOut = 2.0 / max(1.0, pointScale);
	FadeAmountOut = max(0.0, abs(min(0.0, ColorizeIn.b)) - pointScale);
	SummonAmountOut = max(0.0, max(0.0, ColorizeIn.b) - pointScale);
}

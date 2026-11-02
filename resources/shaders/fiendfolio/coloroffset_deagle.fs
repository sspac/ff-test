#ifdef GL_ES
precision highp float;
#endif

#if __VERSION__ >= 140

in vec4 Color0;
in vec2 TexCoord0;
in vec4 ColorizeOut;
in vec3 ColorOffsetOut;
in vec2 TextureSizeOut;
in float PixelationAmountOut;
in vec3 ClipPlaneOut;
out vec4 fragColor;

#else

varying vec4 Color0;
varying vec2 TexCoord0;
varying vec4 ColorizeOut;
varying vec3 ColorOffsetOut;
varying vec2 TextureSizeOut;
varying float PixelationAmountOut;
varying vec3 ClipPlaneOut;
#define fragColor gl_FragColor
#define texture texture2D

#endif

uniform sampler2D Texture0;
const vec3 _lum = vec3(0.212671, 0.715160, 0.072169);

vec3 RGB(vec3 c) {
	if (c.y < 0.0001)
		return vec3(c.z);

	float j = c.y * c.z;
	float k = j * (1.0 - abs(mod(c.x / 60.0, 2.0) - 1.0));
	float l = c.z - j;
	
	if (c.x < 60.0)
		return vec3(j + l, k + l, 0.0 + l);
	else if (c.x < 120.0)
		return vec3(k + l, j + l, 0.0 + l);
	else if (c.x < 180.0)
		return vec3(0.0 + l, j + l, k + l);
	else if (c.x < 240.0)
		return vec3(0.0 + l, k + l, j + l);
	else if (c.x < 300.0)
		return vec3(k + l, 0.0 + l, j + l);
	else
		return vec3(j + l, 0.0 + l, k + l);
}

vec3 HSV(vec3 c) {
	float low = min(c.r, min(c.g, c.b));
	float high = max(c.r, max(c.g, c.b));
	float delta = high - low;

	vec3 hsv = vec3(0.0, 0.0, high);
	hsv.y = high == 0.0 ? 0.0 : delta / high;

	if (delta == 0.0)
		hsv.x = 0.0;
	else if (high == c.r)
		hsv.x = (c.g - c.b) / delta;
	else if (high == c.g)
		hsv.x = (c.b - c.r) / delta + 2.0;
	else
		hsv.x = (c.r - c.g) / delta + 4.0;

	hsv.x = mod(hsv.x, 6.0) * 60.0;
	return hsv;
}

vec3 getGoldColor(vec3 origColor, float v, float threshold, float tint, float offset) {
	float value = v * tint + offset;
	bool isWithinThreshold = v < 0.01 || (threshold > 0.0 && v <= threshold) || (threshold < 0.0 && v >= (-1.0 * threshold));
	return isWithinThreshold ? origColor : RGB(vec3(clamp(48.2508 * value + 6.1683, 0.0, 360.0), clamp(-2.3316 * pow(value, 2.0) + 1.4993 * value + 0.5638, 0.0, 1.0), clamp(0.9271 * value + 0.2908, 0.0, 1.0)));
}

void main(void)
{
	// Clip
	if(dot(gl_FragCoord.xy, ClipPlaneOut.xy) < ClipPlaneOut.z)
		discard;
	
	// Pixelate
	vec2 pa = vec2(1.0+PixelationAmountOut, 1.0+PixelationAmountOut) / TextureSizeOut;

	// vec4 Color = Color0 * texture2D(Texture0, TexCoord0);
	vec4 Color = Color0 * texture(Texture0, PixelationAmountOut > 0.0 ? TexCoord0 - mod(TexCoord0, pa) + pa * 0.5 : TexCoord0);
	
	if( Color.a == 0.0 )	discard;
	
	// Undo premultiplied alpha
	Color.rgb /= Color.a;
	
	// Calculate golden color
	vec3 hsv = HSV(Color.rgb);
	vec3 goldColor = getGoldColor(Color.rgb, hsv.z, ColorizeOut.r == 0.0 ? 0.2 : ColorizeOut.r, ColorizeOut.g == 0.0 ? 1.0 : ColorizeOut.g, ColorizeOut.b == 0.0 ? 0.0 : ColorizeOut.b);
	
	// Set gold color and redo premultiplied alpha
	float satMult = ColorizeOut.a == 0.0 ? 1.0 : abs(ColorizeOut.a);
	float lerp = clamp(1.0 - (ColorizeOut.a < 0.0 ? (1.0 - hsv.y * satMult) : (hsv.y * satMult)) * 2.0, 0.0, 1.0);
	Color.rgb = mix(Color.rgb, goldColor, lerp) * Color.a;
	
	//vec3 Colorized = mix(Color.rgb, dot(Color.rgb, _lum) * ColorizeOut.rgb, ColorizeOut.a);
	fragColor = vec4(Color.rgb + ColorOffsetOut * Color.a, Color.a);
	
	fragColor.rgb = mix(fragColor.rgb, fragColor.rgb - mod(fragColor.rgb, 1.0/16.0) + 1.0/32.0, clamp(PixelationAmountOut, 0.0, 1.0));
}

/*
void main(void)
{
	// Pixelate
    ivec2 TexSize = textureSize(Texture0, 0);
	vec2 pa = vec2(2, 2) / vec2(TexSize);
	
	vec4 Color = Color0 * texture2D(Texture0, TexCoord0 - mod(TexCoord0, pa) + pa * 0.5);
	vec3 Colorized = mix(Color.rgb, dot(Color.rgb, _lum) * ColorizeOut.rgb, ColorizeOut.a);
	gl_FragColor = vec4(Colorized + ColorOffsetOut * Color.a, Color.a);
	
	// Apply color reduction
	gl_FragColor.rgb = gl_FragColor.rgb - mod(gl_FragColor.rgb, 1.0/16.0);
}
*/

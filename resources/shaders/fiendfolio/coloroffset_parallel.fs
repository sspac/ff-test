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

/*
void main(void)
{
	vec4 Color = Color0 * texture2D(Texture0, TexCoord0);
	vec3 Colorized = mix(Color.rgb, dot(Color.rgb, _lum) * ColorizeOut.rgb, ColorizeOut.a);
	gl_FragColor = vec4(Colorized + ColorOffsetOut * Color.a, Color.a);
}
*/

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

void main(void)
{
	// Clip
	if(dot(gl_FragCoord.xy, ClipPlaneOut.xy) < ClipPlaneOut.z)
		discard;
	
	// Pixelate
	vec2 pa = vec2(1.0+PixelationAmountOut, 1.0+PixelationAmountOut) / TextureSizeOut;

	// Get color
	vec4 Color = texture(Texture0, PixelationAmountOut > 0.0 ? TexCoord0 - mod(TexCoord0, pa) + pa * 0.5 : TexCoord0);
	
	// Undo premultiplied alpha
	Color.rgb /= Color.a;
	
	// fuck nicalis black all my homies hate nicalis black
	vec3 hsv = HSV(Color.rgb);
	if ( hsv.y >= 0.99 && hsv.z <= 0.05 ) hsv = vec3(0.0, 0.0, 0.0); 
	
	// Flip value
	Color.rgb = RGB(vec3(hsv.x, hsv.y, 1.0 - hsv.z));
	
	// Apply tint and discarding
	Color = Color0 * Color;
	if( Color.a == 0.0 )	discard;
	
	// Redo premultiplied alpha
	Color.rgb *= Color.a;
	
	vec3 Colorized = mix(Color.rgb, dot(Color.rgb, _lum) * ColorizeOut.rgb, ColorizeOut.a);
	fragColor = vec4(Colorized + ColorOffsetOut * Color.a, Color.a);
	
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

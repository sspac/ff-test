#ifndef GL_ES
#  define lowp
#  define mediump
#endif

varying lowp vec4 Color0;
varying mediump vec2 TexCoord0;
varying mediump vec4 ColorizeOut;
varying lowp vec3 ColorOffsetOut;
varying lowp vec2 TextureSizeOut;
varying lowp float PixelationAmountOut;
varying lowp vec3 ClipPlaneOut;

varying mediump float PointScaleMultOut;
varying mediump float FadeAmountOut;
varying mediump float SummonAmountOut;

uniform sampler2D Texture0;

// Credit to Balatro for the code to convert colours between RGB and HSL
float hue(float s, float t, float h)
{
	float hs = mod(h, 1.)*6.;
	if (hs < 1.) return (t-s) * hs + s;
	if (hs < 3.) return t;
	if (hs < 4.) return (t-s) * (4.-hs) + s;
	return s;
}

vec4 RGB(vec4 c)
{
	if (c.y < 0.0001)
		return vec4(vec3(c.z), c.a);

	float t = (c.z < .5) ? c.y*c.z + c.z : -c.y*c.z + (c.y+c.z);
	float s = 2.0 * c.z - t;
	return vec4(hue(s,t,c.x + 1./3.), hue(s,t,c.x), hue(s,t,c.x - 1./3.), c.w);
}

vec4 HSL(vec4 c)
{
	float low = min(c.r, min(c.g, c.b));
	float high = max(c.r, max(c.g, c.b));
	float delta = high - low;
	float sum = high+low;

	vec4 hsl = vec4(.0, .0, .5 * sum, c.a);
	if (delta == .0)
		return hsl;

	hsl.y = (hsl.z < .5) ? delta / sum : delta / (2.0 - sum);

	if (high == c.r)
		hsl.x = (c.g - c.b) / delta;
	else if (high == c.g)
		hsl.x = (c.b - c.r) / delta + 2.0;
	else
		hsl.x = (c.r - c.g) / delta + 4.0;

	hsl.x = mod(hsl.x / 6., 1.);
	return hsl;
}

void main(void)
{
	// Clip
	if(dot(gl_FragCoord.xy, ClipPlaneOut.xy) < ClipPlaneOut.z)
		discard;
	
	// Shader variables
	float distortOriginX = ColorizeOut.r;
	float distortOriginY = ColorizeOut.g;
	float distortTimer = ColorizeOut.a;
	
	// Distort
	vec2 newTexCoord = TexCoord0;
	newTexCoord.x += sin((distortTimer + (gl_FragCoord.x + gl_FragCoord.y - (distortOriginX + distortOriginY)) / 32.0 * PointScaleMultOut) * 3.1415926535) / TextureSizeOut.x * (0.8 - 0.8 * SummonAmountOut);
	
	// Pixelate
	vec2 pa = vec2(1.0+PixelationAmountOut, 1.0+PixelationAmountOut) / TextureSizeOut;
	vec4 Color = texture2D(Texture0, PixelationAmountOut > 0.0 ? newTexCoord - mod(newTexCoord, pa) + pa * 0.5 : newTexCoord);
	
	// Undo premultiplied alpha
	Color.rgb /= Color.a;
	
	// Increase contrast
	float lumMult = pow(clamp(HSL(Color).z / 0.3, 0.0, 1.0), 1.75);
	Color.rgb = (Color.rgb - 0.5) * (1.0 + 0.5 * lumMult) + 0.5;
	
	// Convert color to HSL space
	vec4 hsl = HSL(Color);
	
	// Darken
	hsl.z = (hsl.z + 0.25) / 2.5;
	
	// Hueshift to Void colours
	hsl.x = (328.0 - 37.0 * (hsl.z * 2.0)) / 360.0;
	
	// Void-style saturation
	hsl.y = (21.0 - 6.0 * (hsl.z * 2.0)) / 100.0;
	
	// Convert color to RGB space
	vec3 outColor = RGB(hsl).rgb;
	
	// Apply tint
	outColor *= Color0.rgb;
	
	// Apply color offset and premultiplied alpha (tint RGB is already premultiplied)
	float alpha = Color.a * mix(mix(0.8, 1.0, SummonAmountOut), 0.0, FadeAmountOut);
	gl_FragColor = vec4((outColor + ColorOffsetOut * Color0.a) * alpha, alpha * Color0.a);
	
	// Summon fade to solid color
	gl_FragColor.rgb = mix(gl_FragColor.rgb, vec3(206.0, 137.0, 229.0) / 255.0 * gl_FragColor.a, SummonAmountOut);
	
	// Color reduction
	gl_FragColor.rgb = mix(gl_FragColor.rgb, gl_FragColor.rgb - mod(gl_FragColor.rgb, 1.0/16.0) + 1.0/32.0, clamp(PixelationAmountOut, 0.0, 1.0));
}


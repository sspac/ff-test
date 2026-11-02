#ifndef GL_ES
#  define lowp
#  define mediump
#endif

varying lowp vec4 Color0;
varying mediump vec2 TexCoord0;
varying lowp vec4 ColorizeOut;
varying lowp vec3 ColorOffsetOut;
varying lowp vec2 TextureSizeOut;
varying lowp float PixelationAmountOut;
varying lowp vec3 ClipPlaneOut;

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
	
	// Pixelate
	vec2 pa = vec2(1.0+PixelationAmountOut, 1.0+PixelationAmountOut) / TextureSizeOut;
	vec4 Color = texture2D(Texture0, PixelationAmountOut > 0.0 ? TexCoord0 - mod(TexCoord0, pa) + pa * 0.5 : TexCoord0);
	
	// Undo premultiplied alpha
	Color.rgb /= Color.a;
	
	// Convert color to HSL space
	vec4 hsl = HSL(Color);
	
	// Hueshift towards red
	if (hsl.x > 0.42)
		hsl.x = pow(hsl.x, 0.7 - 0.3 * ((1.0 - hsl.x) / 0.58));
	else
		hsl.x = 1.0 - pow(1.0 - hsl.x, 0.5 - 0.17 * (hsl.x / 0.42));
	
	// Saturate and darken
	hsl.y = 1.0 - pow(clamp(1.0 - hsl.y, 0.0, 1.0), 1.2);
	float satMult = pow(1.0 - hsl.y, 3.0);
	hsl.z = hsl.z - 73.0 / 255.0 * satMult * pow(hsl.z, 0.5);
	
	// Convert color to RGB space and increase contrast
	vec3 outColor = RGB(hsl).rgb;
	float lumMult = pow(clamp(hsl.z / 0.3, 0.0, 1.0), 1.75);
	outColor = (outColor - 0.5) * (1.0 + (0.3 + 0.3 * satMult) * lumMult) + 0.5;
	outColor = clamp(outColor, vec3(0.0, 0.0, 0.0), vec3(1.0, 1.0, 1.0));
	
	// Shimmer
	float t = ColorizeOut.a*-12.0*3.1415926535 + 3.1415926535*sqrt(pow(TexCoord0.x - 16.0 / TextureSizeOut.x, 2.0) + pow(TexCoord0.y - 16.0 / TextureSizeOut.y, 2.0))/0.8;
	float sinT = sin(t);
	float highlightT = floor(pow(max(0.0, sinT), 8.0) * 5.0) / 5.0;
	float baseTint = 0.85 + sinT * 0.15;
	outColor = outColor * vec3(baseTint + highlightT * 0.9, baseTint - highlightT * 0.15, baseTint - highlightT * 0.3) + vec3(40.0/255.0, 5.0/255.0, 5.0/255.0) * highlightT;
	outColor = clamp(outColor, vec3(0.0, 0.0, 0.0), vec3(1.0, 1.0, 1.0));
	
	// Redshift monochrome colours
	outColor = outColor * vec3(1.0 + 0.2 * satMult, 1.0 - 0.2 * satMult, 1.0 - 0.2 * satMult) + vec3(10.0/255.0, 0.0, 0.0) * satMult;
	outColor = clamp(outColor, vec3(0.0, 0.0, 0.0), vec3(1.0, 1.0, 1.0));
	
	// Apply tint
	outColor *= Color0.rgb;
	
	// Apply color offset and premultiplied alpha (tint RGB is already premultiplied)
	gl_FragColor = vec4((outColor + ColorOffsetOut * Color0.a) * Color.a, Color.a * Color0.a);
	
	// Color offset and color reduction
	gl_FragColor = vec4(gl_FragColor.rgb + ColorOffsetOut * Color.a, Color.a);
	
	// Color reduction
	gl_FragColor.rgb = mix(gl_FragColor.rgb, gl_FragColor.rgb - mod(gl_FragColor.rgb, 1.0/16.0) + 1.0/32.0, clamp(PixelationAmountOut, 0.0, 1.0));
}



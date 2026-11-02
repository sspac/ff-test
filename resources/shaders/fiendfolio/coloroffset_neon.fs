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

vec4 getTextureColor(vec2 offset) {
	vec2 pa = vec2(1.0+PixelationAmountOut, 1.0+PixelationAmountOut) / TextureSizeOut;
	return Color0 * texture(Texture0, (PixelationAmountOut > 0.0 ? TexCoord0 - mod(TexCoord0, pa) + pa * 0.5 : TexCoord0) + offset / TextureSizeOut);
}

vec4 getNearbyColor(vec2 offset) {
	vec3 nearbyColors = vec3(0.0, 0.0, 0.0);
	int i = 0;
	
	float outlineThreshold = ColorizeOut.a == 0.0 ? 0.25 : ColorizeOut.a;
	for (float x = -2.0; x <= 2.0; x++) {
		for (float y = -2.0; y <= 2.0; y++) {
			//if (abs(x) + abs(y) <= 3.0) {
				vec4 color = getTextureColor(offset + vec2(x, y));
				if (HSV(color.rgb / color.a).z > outlineThreshold) {
					nearbyColors += color.rgb / color.a;
					i++;
				}
			//}
		}
	}
	if (i == 0) {
		nearbyColors = ColorizeOut.rgb;
	}
	
	return vec4(nearbyColors / max(i, 1), 1.0);
}

vec4 getLightColor(vec2 offset) {
	vec4 color = getTextureColor(offset);
	if (color.a == 0.0)
		return vec4(0.0, 0.0, 0.0, 0.0);
	
	// Test for outline pixels
	float outlineThreshold = ColorizeOut.a == 0.0 ? 0.25 : ColorizeOut.a;
	if (HSV(color.rgb / color.a).z > outlineThreshold) 
		return vec4(0.0, 0.0, 0.0, 0.0);
	
	vec4 nearbyColor = getNearbyColor(offset);
	vec3 hsv = HSV(nearbyColor.rgb);
	return vec4(RGB(vec3(hsv.xy, 1.0)), color.a);
}

vec4 getGlowColor() {
	vec4 color = vec4(0.0, 0.0, 0.0, 0.0);
	float i = 0.0;
	for (float x = -2.0; x <= 2.0; x++) {
		for (float y = -2.0; y <= 2.0; y++) {
			if (abs(x) + abs(y) <= 3.0) {
				vec4 lightColor = getLightColor(vec2(x, y));
				color += vec4(lightColor.rgb * lightColor.a, lightColor.a);
				i++;
			}
		}
	}
	if (color.a == 0.0)
		return vec4(0.0, 0.0, 0.0, 0.0);
	return vec4(color.rgb / color.a, color.a / i);
}

void main(void) {
	// Clip
	if(dot(gl_FragCoord.xy, ClipPlaneOut.xy) < ClipPlaneOut.z)
		discard;
	
	vec4 lightColor = getLightColor(vec2(0.0, 0.0));
	vec4 glowColor = getGlowColor();
	vec4 Color = vec4(lightColor.rgb * lightColor.a + glowColor.rgb * (1.0 - lightColor.a), lightColor.a + glowColor.a * (1 - lightColor.a));
	Color.rgb = Color.rgb * Color.a;
	
	//vec3 Colorized = mix(Color.rgb, dot(Color.rgb, _lum) * ColorizeOut.rgb, ColorizeOut.a);
	fragColor = vec4(Color.rgb + ColorOffsetOut * Color.a, Color.a);
	
	fragColor.rgb = mix(fragColor.rgb, fragColor.rgb - mod(fragColor.rgb, 1.0/16.0) + 1.0/32.0, clamp(PixelationAmountOut, 0.0, 1.0));
}

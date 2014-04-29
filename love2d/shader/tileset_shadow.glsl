extern Image tileset;
extern float grid = 16.0;
extern vec2 size = vec2(256.0, 256.0);
extern float time = 0.0;
extern vec2 lightPosition = vec2(128.0, 128.0);
extern vec4 lightColorRange = vec4(1.0, 0.9, 0.8, 250.0);
extern vec2 screenSize = vec2(512.0, 512.0);
extern float zoom = 1.0;

vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 pixel_coords) {
	vec4 tex = Texel(texture, vec2(texture_coords.x, texture_coords.y));
	vec4 tex2 = vec4(0.0);

	vec2 screenPosition = vec2(screenSize.x * texture_coords.x, screenSize.y * texture_coords.y);
	float dist = distance(vec2(screenPosition.x, screenPosition.y), vec2(lightPosition.x, lightPosition.y));
	float att = max(1 - dist / lightColorRange.a, 0.0);

	if(tex.z == 0) {
		tex2 = Texel(tileset,
			vec2(
				mod(texture_coords.x * (size.x / grid), (1.0 / grid)) + (1.0 / grid) * (tex.x * 255.0),
				mod(texture_coords.y * (size.y / grid), (1.0 / grid)) + (1.0 / grid) * (tex.y * 255.0)
			)
		);
	} else {
		// Animation
		tex2 = Texel(tileset,
			vec2(
				mod(texture_coords.x * (size.x / grid), (1.0 / grid)) + (1.0 / grid) * ((tex.x + mod(time, tex.z * 255) * (1.0 / 255)) * 255.0),
				mod(texture_coords.y * (size.y / grid), (1.0 / grid)) + (1.0 / grid) * (tex.y * 255.0)
			)
		);
	}

	if(tex2.a == 0.0 && dist < lightColorRange.a) {
		vec4 curPoint;
		vec2 pSize = vec2(1.0 / screenSize.x, 1.0 / screenSize.y);
		float dx = lightPosition.x - screenPosition.x;
		float dy = lightPosition.y - screenPosition.y;
		float collAlpha = 0.0;
		dist = dist * zoom;
		float gap = 1.0 / dist;
		for(int i = 0; i < dist; ++i) {
			curPoint = Texel(texture, vec2((texture_coords.x + dx * i * gap * pSize.x), (texture_coords.y + dy * i * gap * pSize.y)));

			vec4 curPoint2 = Texel(tileset,
				vec2(
					mod((texture_coords.x + dx * i * gap * pSize.x) * (size.x / grid), (1.0 / grid)) + (1.0 / grid) * (curPoint.x * 255.0),
					mod((texture_coords.y + dy * i * gap * pSize.y) * (size.y / grid), (1.0 / grid)) + (1.0 / grid) * (curPoint.y * 255.0)
				)
			);

			if(curPoint2.a == 1.0 && curPoint2.r == 0) {
				collAlpha = curPoint2.a;
				break;
			}
		}
		if(collAlpha == 0.0) {
			return vec4(lightColorRange.rgb * att * att, 1.0);
		} else {
			return vec4(0.0);
		}
	} else {
		return vec4(lightColorRange.rgb * att * att, 1.0);
	}

	return vec4(0.0);
}
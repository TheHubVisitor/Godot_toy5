shader_type canvas_item;

uniform vec4 glow_color : source_color = vec4(1.0, 0.95, 0.7, 0.6);
uniform vec4 shadow_color : source_color = vec4(0.0, 0.0, 0.0, 0.6);
uniform float effect_width = 6.0;
uniform bool use_glow = true;

void fragment() {
	vec4 tex_color = texture(TEXTURE, UV);
	vec4 sum = vec4(0.0);

	if (tex_color.a == 0.0) {
		// Create outline/glow/shadow
		for(float x = -effect_width; x <= effect_width; x++) {
			for(float y = -effect_width; y <= effect_width; y++) {
				vec2 offset = vec2(x, y) * 0.0025;
				vec4 neighbor_color = texture(TEXTURE, UV + offset);
				sum.a += neighbor_color.a;
			}
		}
		sum.a = clamp(sum.a, 0.0, 1.0);

		if(use_glow) {
			COLOR = glow_color * sum.a;
		} else {
			// Darker shadow near bottom using UV.y (0 top → 1 bottom)
			float gradient_factor = mix(0.8, 3.0, UV.y); // Adjust these values as desired
			vec4 gradient_shadow = shadow_color;
			gradient_shadow.a *= gradient_factor;
			COLOR = gradient_shadow * sum.a;
		}
	} else {
		COLOR = tex_color;
	}
}

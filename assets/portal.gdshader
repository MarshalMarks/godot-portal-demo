shader_type spatial;
render_mode unshaded, cull_back, depth_draw_opaque, fog_disabled;

uniform sampler2D tex;

void fragment() {
	vec4 color = texture(tex, SCREEN_UV);
	ALBEDO = color.rgb;
	ALPHA = color.a;
}

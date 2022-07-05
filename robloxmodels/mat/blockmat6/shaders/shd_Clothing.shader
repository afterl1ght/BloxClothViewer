// Clothing texture

shader_type spatial;
render_mode blend_mix,depth_draw_opaque,cull_back,diffuse_burley,specular_schlick_ggx,shadows_disabled;
uniform vec4 albedo : hint_color;
uniform float alpha_shirt : hint_range(0,1);
uniform float alpha_pants : hint_range(0,1);
uniform sampler2D texture_shirt : hint_albedo;
uniform sampler2D texture_pants : hint_albedo;
uniform vec3 uv1_scale;
uniform vec3 uv1_offset;
uniform vec3 uv2_scale;
uniform vec3 uv2_offset;


void vertex() {
	if (!OUTPUT_IS_SRGB) {
		COLOR.rgb = mix(pow((COLOR.rgb + vec3(0.055)) * (1.0 / (1.0 + 0.055)), vec3(2.4)), COLOR.rgb * (1.0 / 12.92), lessThan(COLOR.rgb, vec3(0.04045)));
	}
	UV=UV*uv1_scale.xy+uv1_offset.xy;
}




void fragment() {
	vec2 base_uv = UV;
	vec4 shirt_tex = texture(texture_shirt,base_uv);
	vec4 pants_tex = texture(texture_pants,base_uv);
	ALBEDO = (albedo.rgb * (1.0 - shirt_tex.a * alpha_shirt) * (1.0 - pants_tex.a * alpha_pants)) + mix((pants_tex.rgb * pants_tex.a * alpha_pants), (shirt_tex.rgb * shirt_tex.a * alpha_shirt), alpha_shirt * shirt_tex.a);
}

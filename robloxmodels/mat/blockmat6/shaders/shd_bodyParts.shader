// Attempt at improving performance compared to versions from v1.0.0-alpha27 to v1.0.0-alpha30.

shader_type spatial;
render_mode blend_mix,depth_draw_opaque,cull_back,diffuse_burley,specular_schlick_ggx,vertex_lighting,shadows_disabled;
uniform vec4 albedo : hint_color;
uniform float roughness : hint_range(0,1);
uniform float point_size : hint_range(0,128);
uniform vec3 uv1_scale;
uniform vec3 uv1_offset;
uniform vec3 uv2_scale;
uniform vec3 uv2_offset;


void vertex() {
	if (!OUTPUT_IS_SRGB) {
		COLOR.rgb = mix(pow((COLOR.rgb + vec3(0.055)) * (1.0 / (1.0 + 0.055)), vec3(2.4)), COLOR.rgb * (1.0 / 12.92), lessThan(COLOR.rgb, vec3(0.04045)));
	}
	ROUGHNESS=roughness;
	UV=UV*uv1_scale.xy+uv1_offset.xy;
}




void fragment() {
	ALBEDO = albedo.rgb;
	ROUGHNESS = roughness;
}

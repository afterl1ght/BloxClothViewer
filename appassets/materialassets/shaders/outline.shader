shader_type spatial;
render_mode unshaded, cull_front;

uniform float enable = 0;
// outline costumization
uniform float thickness = 0.045;


void vertex() {
	VERTEX += NORMAL * thickness * enable;
}

void fragment() {
	ALBEDO = vec3(0) * enable;
}
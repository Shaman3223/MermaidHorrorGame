shader_type canvas_item;
render_mode skip_vertex_transform,unshaded;

//target resolution
const vec2 target_resolution = vec2(400.0, 300.0);

//grab screen texture
uniform sampler2D screen_texture: hint_screen_texture, filter_nearest;

void fragment() {
	//scale down resolution
	vec2 uv = floor(SCREEN_UV * target_resolution) / target_resolution;
	COLOR = texture(screen_texture, uv);
}
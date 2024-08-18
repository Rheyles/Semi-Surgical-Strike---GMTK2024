shader_type canvas_item;

uniform float offset;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	COLOR.r = texture(SCREEN_TEXTURE,vec2(SCREEN_UV.x + offset, SCREEN_UV.y)).r;
	COLOR.g = texture(SCREEN_TEXTURE,SCREEN_UV).g;
	COLOR.b = texture(SCREEN_TEXTURE,vec2(SCREEN_UV.x - offset * 0.01, SCREEN_UV.y)).b;
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}

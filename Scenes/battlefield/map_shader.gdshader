shader_type canvas_item;
//render_mode unshaded; // optional

// Noise texture
uniform sampler2D noise_texture: repeat_enable, filter_nearest;
// Mix density
uniform float density: hint_range(0.0, 1.0) = 0.25;

uniform vec4 color : source_color;


// Called for every pixel the material is visible on
void fragment() {
	// Sample the noise texture
	float noise = texture(noise_texture, UV).r;
	// Convert the noise from the (0.0, 1.0) range to the (-1.0, 1.0) range
	// and clamp it between 0.0 and 1.0 again
	float fog = clamp(noise * 2.0 - 1.0, 0.0, 1.0);
	// Apply the fog effect
	vec3 darkened_color = mix(color.rgb, COLOR.rgb, fog * density);
	COLOR = vec4(darkened_color, COLOR.a);
	// COLOR *= fog * density;
}
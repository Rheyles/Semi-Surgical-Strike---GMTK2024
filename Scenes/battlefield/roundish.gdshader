shader_type canvas_item;

uniform float curvature: hint_range(-10., 10., .01) = 2.;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec2 uv = UV;
	uv -= vec2(.5,.5);
	uv = uv*1.2*(1./1.2+curvature*uv.x*uv.x*uv.y*uv.y);
	uv += vec2(.5,.5);
	
	COLOR = texture(TEXTURE,uv);
	if (COLOR.a != 0.)
	{
		COLOR.a = 0.6;
	}
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}

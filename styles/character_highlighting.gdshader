shader_type canvas_item;

//the lower the brightness value the brighter it is
uniform float brightness = 0.3;
uniform bool highlighted = true;

void fragment() {
	COLOR = texture(TEXTURE, UV);
	if (!highlighted) {
		COLOR.rgb /= COLOR.a;
		COLOR.rgb -= brightness;
	}
}
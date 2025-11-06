shader_type canvas_item;

uniform float brightness = 0.25;
uniform bool highlighted = true;

void fragment() {
	COLOR = texture(TEXTURE, UV);
	if (!highlighted) {
		COLOR.rgb /= COLOR.a;
		COLOR.rgb -= brightness;
	}
}
shader_type canvas_item;

uniform bool active = false;

void fragment() {
	COLOR = texture(TEXTURE, UV);
	if (active) {

	} else {

	}
}

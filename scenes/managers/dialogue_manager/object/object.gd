extends Control

var id: int = 0

@onready var texture: Node = $Texture

func change_texture(new_texture: String) -> void:
	texture.texture = load(new_texture)
	texture.pivot_offset = Vector2(texture.size.x / 2, texture.size.y / 2)

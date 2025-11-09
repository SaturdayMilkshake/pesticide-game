class_name Character
extends Control

@onready var animation_player: Node = $AnimationPlayer
@onready var texture: Node = $Texture

var character_name: String = ""
var id: int = 0

func _ready() -> void:
	animation_player.play("CharacterIdle")

func change_texture(target: String, new_texture: String) -> void:
	if target == character_name:
		texture.texture = load(new_texture)
		
func change_texture_untargeted(new_texture: String) -> void:
	texture.texture = load(new_texture)
		
func set_saying_status(target: String) -> void:
	if target == character_name:
		highlight_character(true)
	else:
		highlight_character(false)
		
func highlight_character(status: bool) -> void:
	texture.material.set("shader_parameter/highlighted", status)

extends Control

@export var achievement_id: int = 0
@export var achievement_texture: Texture = null
@export var achievement_name: String = ""
@export_multiline var achievement_desc: String = ""

@onready var texture_rect: Node = $TextureRect
@onready var animation_player: Node = $AnimationPlayer

var active: bool = true

var mouse_hovering: bool = false

func _ready() -> void:
	if achievement_texture != null:
		texture_rect.texture = achievement_texture

func _on_mouse_entered() -> void:
	if !mouse_hovering:
		animation_player.play("AchHover")
		mouse_hovering = true

func _on_mouse_exited() -> void:
	if mouse_hovering:
		animation_player.play("AchHoverOut")
		mouse_hovering = false

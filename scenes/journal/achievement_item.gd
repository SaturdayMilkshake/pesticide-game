extends Control

@export var achievement_id: int = 0
@export var achievement_name: String = ""
@export_multiline var achievement_description: String = ""
@export var achievement_texture: Texture = null

@onready var texture: Node = $Texture
@onready var animation_player: Node = $AnimationPlayer

func _ready() -> void:
	pass

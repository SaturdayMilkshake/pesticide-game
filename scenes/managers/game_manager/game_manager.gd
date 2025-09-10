extends Node

@onready var dialogue_manager: Node = $DialogueManager
@onready var log_manager: Node = $LogManager
@export var background: Node = null
@onready var animation_player: Node = $AnimationPlayer

func _on_dialogue_manager_log_showing_requested() -> void:
	log_manager.show_log()

func _on_dialogue_manager_change_background(path: String) -> void:
	background.texture = load(path)

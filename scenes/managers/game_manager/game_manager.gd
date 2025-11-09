extends Node

@onready var dialogue_manager: Node = $DialogueManager
@export var log_manager: Node = null
@export var background: Node = null
@onready var animation_player: Node = $AnimationPlayer

func load_ready() -> void:
	dialogue_manager.process_dialogue_command()

func _on_dialogue_manager_log_showing_requested() -> void:
	log_manager.show_log()

func _on_dialogue_manager_change_background(path: String) -> void:
	if !ResourceLoader.exists(path):
		background.texture = null
	else:
		background.texture = load(path)

func _on_dialogue_manager_dialogue_finished() -> void:
	SignalHandler.emit_signal("scene_manager_change_scene", "res://scenes/stage_select_screen/stage_select_screen.tscn")

func _on_dialogue_manager_dialogue_said(character: String, dialogue: String) -> void:
	log_manager.update_log(character, dialogue)

func _on_back_to_menu_button_pressed() -> void:
	SignalHandler.emit_signal("scene_manager_show_dialog", "option", "return_chapter")

func _on_settings_button_pressed() -> void:
	SignalHandler.emit_signal("scene_manager_show_settings")

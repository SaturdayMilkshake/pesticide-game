extends Node2D

func _ready() -> void:
	pass

func load_ready() -> void:
	pass

func _on_button_pressed() -> void:
	SignalHandler.emit_signal("scene_manager_change_scene", "res://scenes/title_screen/title_screen.tscn")

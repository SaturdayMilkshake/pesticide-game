extends Node2D

func _ready() -> void:
	pass

func load_ready() -> void:
	SignalHandler.emit_signal("scene_manager_show_dialog", "message", "no_save_file")

func _on_button_pressed() -> void:
	SignalHandler.emit_signal("scene_manager_change_scene", "res://scenes/title_screen/title_screen.tscn")

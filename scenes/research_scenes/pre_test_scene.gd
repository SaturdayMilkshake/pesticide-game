extends Node2D

func _ready() -> void:
	pass

func load_ready() -> void:
	SignalHandler.emit_signal("scene_manager_show_dialog", "option", "survey")

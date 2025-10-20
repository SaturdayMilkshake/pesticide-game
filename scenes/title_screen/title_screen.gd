extends Node2D

@onready var animation_player: Node = $AnimationPlayer

func _ready() -> void:
	$UI/Version.text = "Version %s" % ProjectSettings.get_setting("application/config/version")

func _on_settings_pressed() -> void:
	SignalHandler.emit_signal("scene_manager_show_settings")

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_play_pressed() -> void:
	SignalHandler.emit_signal("scene_manager_change_scene", "res://scenes/stage_select_screen/stage_select_screen.tscn")

extends Node2D

@onready var animation_player: Node = $AnimationPlayer
@onready var background_animation: Node = $BackgroundAnimation

func _ready() -> void:
	$UI/Version.text = "Version %s" % ProjectSettings.get_setting("application/config/version")
	background_animation.play("BackgroundAnim")

func load_ready() -> void:
	DataHandler.load_data()

func _on_settings_pressed() -> void:
	SignalHandler.emit_signal("scene_manager_show_settings")

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_play_pressed() -> void:
	SignalHandler.emit_signal("scene_manager_change_scene", "res://scenes/stage_select_screen/stage_select_screen.tscn")

func _on_button_pressed() -> void:
	SignalHandler.emit_signal("scene_manager_change_scene", "res://scenes/credits_screen/credits_screen.tscn")

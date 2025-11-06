extends Control

@onready var animation_player: Node = $AnimationPlayer
@onready var panel: Node = $Panel

var button: Node = null

func _ready() -> void:
	self.global_position = get_viewport_rect().size / 2
	
func show_dialog() -> void:
	animation_player.queue("ShowDialog")

func hide_dialog() -> void:
	animation_player.queue("HideDialog")

func _on_okay_button_pressed() -> void:
	animation_player.play("HideDialog")

func _on_reset_save_file_pressed() -> void:
	SignalHandler.emit_signal("scene_manager_show_dialog", "option", "reset_save_file")

func _on_audio_slider_value_changed(value: float) -> void:
	pass # Replace with function body.

func _on_sound_effects_slider_value_changed(value: float) -> void:
	pass # Replace with function body.

func _on_text_read_speed_slider_value_changed(value: float) -> void:
	DataHandler.game_settings["text_read_speed"] = value

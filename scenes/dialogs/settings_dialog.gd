extends Control

@onready var animation_player: Node = $AnimationPlayer

var button: Node = null

func _ready() -> void:
	self.global_position = get_viewport_rect().size / 2
	
func show_dialog() -> void:
	animation_player.queue("ShowDialog")

func _on_okay_button_pressed() -> void:
	animation_player.play("HideDialog")

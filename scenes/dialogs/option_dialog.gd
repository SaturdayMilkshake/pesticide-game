extends Control

@onready var animation_player: Node = $AnimationPlayer

@onready var dialog_text: Node = $DialogText
@onready var dialog_title: Node = $DialogTitle

var button: Node = null

signal okay_pressed
signal cancel_pressed

func _ready() -> void:
	self.global_position = get_viewport_rect().size / 2
	
func show_dialog(messages: Dictionary = {}) -> void:
	if messages.has("message"):
		dialog_text.text = str(messages["message"])
	if messages.has("title"):
		dialog_title.text = str(messages["title"])
	
	animation_player.play("ShowDialog")

func _on_accept_button_pressed() -> void:
	animation_player.play("HideDialog")

func set_dialog_text(new_text: String) -> void:
	dialog_text.text = new_text

func set_dialog_title(new_text: String) -> void:
	dialog_title.text = new_text

func _on_cancel_button_pressed() -> void:
	animation_player.play("HideDialog")

extends Control

@onready var animation_player: Node = $AnimationPlayer

@onready var dialog_text: Node = $DialogText
@onready var dialog_title: Node = $DialogTitle

var button: Node = null
var current_action: String = ""
var current_action_cancel: String = ""

signal okay_pressed
signal cancel_pressed

func _ready() -> void:
	self.global_position = get_viewport_rect().size / 2
	
func show_dialog(messages: Dictionary = {}) -> void:
	if messages.has("message"):
		dialog_text.text = str(messages["message"])
	if messages.has("title"):
		dialog_title.text = str(messages["title"])
	if messages.has("action"):
		current_action = str(messages["action"])
	if messages.has("cancel"):
		current_action_cancel = str(messages["cancel"])
	
	animation_player.queue("ShowDialog")
	
func hide_dialog() -> void:
	animation_player.play("HideDialog")
	animation_player.clear_queue()

func _on_accept_button_pressed() -> void:
	emit_signal("okay_pressed", current_action)
	current_action = ""
	current_action_cancel = ""
	animation_player.play("HideDialog")

func set_dialog_text(new_text: String) -> void:
	dialog_text.text = new_text

func set_dialog_title(new_text: String) -> void:
	dialog_title.text = new_text

func _on_cancel_button_pressed() -> void:
	emit_signal("cancel_pressed", current_action_cancel)
	current_action = ""
	current_action_cancel = ""
	animation_player.play("HideDialog")

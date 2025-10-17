extends Node2D

@export var root_scene: Node = null

@onready var animation_player: Node = $AnimationPlayer

@onready var message_dialog: Node = $CanvasLayer/MessageDialog
@onready var option_dialog: Node = $CanvasLayer/OptionDialog

func _ready() -> void:
	SignalHandler.connect("scene_manager_change_scene", Callable(self, "change_scene"))
	initialize_scene_manager()
	
func initialize_scene_manager() -> void:
	change_scene("res://scenes/title_screen/title_screen.tscn")
	
func change_scene(path: String) -> void:
	if FileAccess.file_exists(path):
		if root_scene:
			root_scene.queue_free()
		var new_scene: Node = load(path).instantiate()
		add_child(new_scene)
		root_scene = new_scene
		var messages: Messages = Messages.new()
		option_dialog.show_dialog(messages.messages["save_file"])
	else:
		print_debug("Cannot change scene, as %s does not exist." % path)
		message_dialog.show_dialog()

func _on_message_dialog_okay_pressed() -> void:
	pass # Replace with function body.

func _on_option_dialog_okay_pressed() -> void:
	pass # Replace with function body.

func _on_option_dialog_cancel_pressed() -> void:
	pass # Replace with function body.

extends Node

@export_file var starting_scene_override: String = ""
@export var root_scene: Node = null
var root_scene_path: String = ""

@onready var animation_player: Node = $AnimationPlayer

@onready var message_dialog: Node = $CanvasLayer/MessageDialog
@onready var option_dialog: Node = $CanvasLayer/OptionDialog
@onready var settings_dialog: Node = $CanvasLayer/SettingsDialog

@onready var messages: Messages = Messages.new()

var scene_loaded: bool = false

func _ready() -> void:
	SignalHandler.connect("scene_manager_change_scene", Callable(self, "change_scene"))
	SignalHandler.connect("scene_manager_show_dialog", Callable(self, "scene_manager_show_dialog"))
	SignalHandler.connect("scene_manager_show_settings", Callable(self, "scene_manager_show_settings"))
	SignalHandler.connect("scene_manager_process_action", Callable(self, "process_action"))
	if starting_scene_override:
		change_scene(starting_scene_override)
	else:
		change_scene("res://scenes/research_scenes/pre_test_scene.tscn")
			
func add_new_root_scene() -> void:
	var scene_loading_status: int = ResourceLoader.load_threaded_get_status(root_scene_path)
	if scene_loading_status == ResourceLoader.ThreadLoadStatus.THREAD_LOAD_LOADED:
		if !scene_loaded:
			var new_root_scene_resource: Resource = ResourceLoader.load_threaded_get(root_scene_path)
			var new_root_scene: Node = new_root_scene_resource.instantiate()
			add_child(new_root_scene)
			root_scene = new_root_scene
			animation_player.queue("HideLoading")
			scene_loaded = true
			
func check_scene_loading_status() -> void:
	if !scene_loaded:
		animation_player.queue("AnimateLoading")
		add_new_root_scene()
	else:
		animation_player.queue("HideLoading")
		animation_player.clear_queue()
	
func load_scene() -> void:
	if root_scene:
		root_scene.queue_free()
	scene_loaded = false
	ResourceLoader.load_threaded_request(root_scene_path)
	
func change_scene(path: String) -> void:
	if FileAccess.file_exists(path):
		animation_player.play("ShowLoading")
		root_scene_path = path
	else:
		root_scene_path = ""
		print_debug("Cannot change scene, as %s does not exist." % path)
		scene_manager_show_dialog("message", "error_scene")

func _on_message_dialog_okay_pressed(action: String) -> void:
	process_action(action)

func _on_option_dialog_okay_pressed(action: String) -> void:
	process_action(action)

func _on_option_dialog_cancel_pressed(action_cancel: String) -> void:
	process_action_cancel(action_cancel)

func scene_manager_show_dialog(dialog_type: String, message_header: String) -> void:
	if !messages.messages.has(message_header):
		assert(!messages.messages.has(message_header), "Error header is missing!")
		scene_manager_show_dialog("message", "error_header")
	else:
		match dialog_type:
			"message":
				message_dialog.show_dialog(messages.messages[message_header])
			"option":
				option_dialog.show_dialog(messages.messages[message_header])

func process_action(action: String) -> void:
	match action:
		"scene_title":
			change_scene("res://scenes/title_screen/title_screen.tscn")
		"skip_dialogue":
			SignalHandler.emit_signal("skip_dialogue")
		"survey_pre":
			OS.shell_open("https://docs.google.com/forms/d/e/1FAIpQLSdV9vULENCtw_Moc_J189RC0ePo314hT0Sni5v7lnRBig1T-Q/viewform?usp=publish-editor")
			get_tree().root.mode = Window.MODE_MINIMIZED
			scene_manager_show_dialog("message", "survey_pre")
		"survey_post":
			OS.shell_open("https://en.uncyclopedia.co")
			scene_manager_show_dialog("message", "survey_post")
		"reset_save":
			DataHandler.reset_data()
			root_scene.queue_free()
			root_scene = null
			root_scene_path = ""
			settings_dialog.hide_dialog()
			change_scene("res://scenes/research_scenes/pre_test_scene.tscn")
		"return_chapter":
			change_scene("res://scenes/stage_select_screen/stage_select_screen.tscn")
		_:
			pass

func process_action_cancel(action_cancel: String) -> void:
	match action_cancel:
		"scene_title":
			change_scene("res://scenes/title_screen/title_screen.tscn")
		_:
			pass

func scene_manager_show_settings() -> void:
	settings_dialog.show_dialog()

func set_root_scene_load_ready() -> void:
	if root_scene:
		if root_scene.has_method("load_ready"):
			root_scene.load_ready()

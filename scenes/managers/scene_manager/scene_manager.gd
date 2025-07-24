extends Node2D

var root_scene: Node = null

@onready var animation_player: Node = $AnimationPlayer

func ready() -> void:
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
	else:
		print_debug("Cannot change scene, as %s does not exist." % path)

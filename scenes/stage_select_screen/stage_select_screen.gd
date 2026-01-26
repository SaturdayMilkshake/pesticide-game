extends Node2D

@onready var animation_player: Node = $AnimationPlayer

var act_data: Array = [
	{
		"title": "Act I",
		"desc": "The quick brown fox jumps over the lazy dog... Sat, I think this sentence is getting a bit repetitive...",
		"topics": "-Topic 1\n-Topic 2\n-Topic 3",
	},
	{
		"title": "Act II",
		"desc": "The quick brown fox jumps over the lazy dog... Sat, I think this sentence is getting a bit repetitive...",
		"topics": "-Topic 1\n-Topic 2\n-Topic 3",
	},
	{
		"title": "Act III",
		"desc": "The quick brown fox jumps over the lazy dog... Sat, I think this sentence is getting a bit repetitive...",
		"topics": "-Topic 1\n-Topic 2\n-Topic 3",
	},
	{
		"title": "Epilogue",
		"desc": "The quick brown fox jumps over the lazy dog... Sat, I think this sentence is getting a bit repetitive...",
		"topics": "-Topic 1\n-Topic 2\n-Topic 3",
	},
]

var current_act_index: int = 0

func _ready() -> void:
	pass

func load_ready() -> void:
	animation_player.queue("ShowNewAct")

#this is the return to title button i was lazy to rename
func _on_button_pressed() -> void:
	SignalHandler.emit_signal("scene_manager_change_scene", "res://scenes/title_screen/title_screen.tscn")

func _on_previous_act_pressed() -> void:
	change_to_new_act(-1)

func _on_next_act_pressed() -> void:
	change_to_new_act(1)

func change_to_new_act(increment: int) -> void:
	current_act_index += increment
	
	if current_act_index < 0:
		current_act_index = 0
		return
	elif current_act_index >= act_data.size():
		current_act_index = act_data.size() - 1
		return
		
	animation_player.play("HideAct")
	animation_player.queue("ShowNewAct")
	
func change_act_info() -> void:
	var current_act_data: Dictionary = act_data[current_act_index]
	
	$ActDesc/ActTitle.text = current_act_data["title"]
	$ActDesc/ActDesc.text = current_act_data["desc"]
	$ActDesc/TopicDesc.text = current_act_data["topics"]

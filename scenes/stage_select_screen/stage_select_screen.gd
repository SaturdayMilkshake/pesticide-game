extends Node2D

@onready var animation_player: Node = $AnimationPlayer

var act_data: Array = [
	{
		"title": "Act I",
		"desc": "The Human Reproductive System",
		"topics": "-Male Reproductive System\n-Female Reproductive System",
		"image": "res://assets/backgrounds/act1_bg.png",
		"link": "res://scenes/managers/game_manager/game_manager.tscn",
		"arg": "res://dialogue/prologue.csv",
	},
	{
		"title": "Act II",
		"desc": "Human Reproduction",
		"topics": "-Fertilization\n",
		"image": "res://assets/backgrounds/act2_bg.png",
		"link": "res://scenes/managers/game_manager/game_manager.tscn",
		"arg": "res://dialogue/yuri.csv",
	},
	{
		"title": "Act III",
		"desc": "Taking Care of Yourself",
		"topics": "-STIs\n-Teenage Pregnancy\n-Methods to avoid them",
		"image": "res://assets/backgrounds/act3_bg.png",
		"link": "res://scenes/managers/game_manager/game_manager.tscn",
		"arg": "",
	},
]

var current_act_index: int = 0

func _ready() -> void:
	$BGAnim.play("AnimateBG")

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
	$ActBG/ActTexture.texture = load(current_act_data["image"])
	
	if current_act_index <= 0:
		$ActDesc/PreviousAct.disabled = true
	elif current_act_index >= act_data.size() - 1:
		$ActDesc/NextAct.disabled = true
	else:
		$ActDesc/PreviousAct.disabled = false
		$ActDesc/NextAct.disabled = false

func _on_play_act_pressed() -> void:
	var current_act_data: Dictionary = act_data[current_act_index]
	
	animation_player.play("HideAct")
	$AnimationPlayer2.play("HidePlayButton")
	SignalHandler.emit_signal("scene_manager_change_scene", current_act_data["link"], current_act_data["arg"])

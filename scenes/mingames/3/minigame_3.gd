extends Node2D

var game_active: bool = false
var question_active: bool = false

var current_question: int = 0

var score: int = 0

var questions: Array = [
	{
		"question": "Some STDs may not show any symptoms at all.",
		"answer": "T",
	},
	{	
		"question": "HIV can be transmitted through casual contact such as shaking hands.",
		"answer": "F",
	},
	{
		"question": "Sexually transmitted diseases can be spread through sexual contact.",
		"answer": "T",
	},
	{	
		"question": "Not having sexual intercourse is the most effective way to avoid sexually transmitted infections.",
		"answer": "T",
	},
	{
		"question": "Teenage pregnancies carry less health risks than normal.",
		"answer": "F",
	},
]

func _ready() -> void:
	$BGAnim.play("AnimateBG")
	#$GameAnim.play("Intro")

func _on_okay_pressed() -> void:
	$GameAnim.play("HideInstructions")
	
func _on_settings_button_pressed() -> void:
	SignalHandler.emit_signal("scene_manager_show_settings")

func _on_back_to_menu_button_pressed() -> void:
	SignalHandler.emit_signal("scene_manager_show_dialog", "option", "return_minigame")

func start_game() -> void:
	pass
	
func end_game() -> void:
	pass

func start_question() -> void:
	pass

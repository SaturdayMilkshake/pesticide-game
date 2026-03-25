extends Node2D

var game_active: bool = false
var question_active: bool = false

var current_question: int = 0

var score: int = 0

var questions: Array = [
	{
		"question": "Women cannot get pregnant on their period.",
		"answer": "F",
	},
	{	
		"question": "The ovaries release an egg cell into the fallopian tubes every month.",
		"answer": "T",
	},
	{
		"question": "Sexual intercourse always leads to pregnancy.",
		"answer": "F",
	},
	{	
		"question": "Pregnancy occurs when a sperm cell and an egg cell unite and are implanted in the uterus.",
		"answer": "T",
	},
	{
		"question": "Semen is the bodily fluid that contains the sperm cells.",
		"answer": "T",
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

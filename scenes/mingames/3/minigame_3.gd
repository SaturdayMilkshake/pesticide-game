extends Node2D

var game_active: bool = false
var question_active: bool = false

var current_question: int = 0

var score: int = 0

var questions: Array = [
	{
		"question": "",
		"answer": "",
	},
	{	
		"question": "",
		"answer": "",
	}
]

func _ready() -> void:
	$BGAnim.play("AnimateBG")

func _on_okay_pressed() -> void:
	$GameAnim.play("HideInstructions")

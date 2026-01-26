extends Control

@export var word: String = ""

var unlocked: bool = false

func _ready() -> void:
	if !unlocked:
		$Label.text = "???"
	else:
		$Label.text = word

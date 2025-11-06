extends Control

@export var character: Node = null
@export var dialogue: Node = null

func set_log_item_text(character_text: String, dialogue_text: String) -> void:
	character.text = character_text
	dialogue.text = dialogue_text

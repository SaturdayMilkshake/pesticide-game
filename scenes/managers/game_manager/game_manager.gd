extends Node

@onready var dialogue_file_manager: Node = $DialogueFileManager
@onready var dialogue_manager: Node = $DialogueManager
@onready var log_manager: Node = $LogManager

func _on_dialogue_manager_log_showing_requested() -> void:
	log_manager.show_log()

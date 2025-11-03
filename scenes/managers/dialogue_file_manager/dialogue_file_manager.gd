extends Node

@export_file var dialogue_file_path: String = ""

signal dialogue_file_processed(dialogue: Array)

var dialogue: Array = []

func _ready() -> void:
	read_file()

func read_file() -> void:
	var dialogue_file: FileAccess = FileAccess.open(dialogue_file_path, FileAccess.READ)
	if dialogue_file != null:
		dialogue = []
		while !dialogue_file.eof_reached():
			var row_data: PackedStringArray = dialogue_file.get_csv_line(",")
			if !row_data.is_empty():
				var new_dialogue_data: DialogueData = DialogueData.new(row_data)
				dialogue.append(new_dialogue_data)
		emit_signal("dialogue_file_processed", dialogue)
	else:
		print_debug("Error opening dialogue file!")

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
			process_dialogue_line(row_data)
		emit_signal("dialogue_file_processed", dialogue)
	else:
		print_debug("Error opening dialogue file!")

#Gets row data and converts it to a dictionary, then appends it to the dialogue array
func process_dialogue_line(row_data: PackedStringArray) -> void:
	if !row_data.is_empty():
		var dialogue_dictionary: Dictionary = {}
		#Command Types
		match row_data[0]:
			"BG": #Changing and manipulating the background image
				dialogue_dictionary["type"] = "BG"
				dialogue_dictionary["path"] = row_data[1]
			"INIT": #Initialize a new character
				dialogue_dictionary["type"] = "INIT"
				dialogue_dictionary["name"] = row_data[1]
			"SAY": #Make a character say something
				dialogue_dictionary["type"] = "SAY"
				dialogue_dictionary["target"] = int(row_data[1])
				dialogue_dictionary["dialogue"] = row_data[2]
			_:
				return
			
		dialogue.append(dialogue_dictionary)
	else:
		return

class_name DialogueData

var type: String = ""
var parameters: Array = []

#Automatic conversions and other error checking stuff should happen here
#However it is currently not worth the effort right now
#Just add when needed
func _init(initial_data: PackedStringArray) -> void:
	type = initial_data[0]
	
	set_default_parameter_sizes()
	
	var current_parameter_index: int = 0
	for parameter: String in initial_data:
		if parameter == "":
			pass
		elif current_parameter_index == 0:
			pass
		else:
			if current_parameter_index - 1 >= parameters.size():
				pass
			else:
				parameters[current_parameter_index - 1] = parameter
		current_parameter_index += 1

func set_default_parameter_sizes() -> void:
	match type:
		"ACTION", "BG", "WAIT", "MUSIC":
			parameters.resize(1)
		"C_ZOOM":
			parameters.resize(2)
		"C_MOVE", "C_MOVE_R", "OBJ", "SAY":
			parameters.resize(3)
		"CHAR", "C_MAZ", "CHAR_MOVE":
			parameters.resize(4)
		_:
			pass
	
	parameters.fill("")

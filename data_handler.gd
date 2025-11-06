extends Node

var default_game_data: Dictionary = {
	"prologue_done": false,
	"act_1_done": false,
	"act_2_done": false,
	"act_3_done": false,
	"act_4_done": false,
	"act_5_done": false,
	"epilogue_done": false,
	#Mini-games
	"mini_1_score": 0,
	"mini_2_score": 0,
	"mini_3_score": 0,
	"mini_4_score": 0,
	"mini_5_score": 0,
	#Other Achievements
	"secret_1": false,
	"secret_2": false,
	"secret_3": false,
}

var game_data: Dictionary = {}
var game_settings: Dictionary = {
	"music_volume": 80,
	"sound_effects_volume": 80,
	"text_read_speed": 30,
	"research_mode": false,
}

func _ready() -> void:
	game_data = default_game_data

func load_data() -> void:
	if !FileAccess.file_exists("user://save_data.save"):
		SignalHandler.emit_signal("scene_manager_show_dialog", "message", "no_save_file")
		FileAccess.open("user://save_data.save", FileAccess.WRITE)
	else:
		pass
	
func load_settings() -> void:
	pass
	
func save_data() -> void:
	pass

func save_settings() -> void:
	pass

func reset_data() -> void:
	if FileAccess.file_exists("user://save_data.save"):
		FileAccess.open("user://save_data.save", FileAccess.WRITE)
	else:
		load_data()

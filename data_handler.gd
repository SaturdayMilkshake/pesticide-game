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

var default_game_settings: Dictionary = {
	#Audio
	"music_volume": 80,
	"sound_effects_volume": 80,
	#Gameplay
	"text_read_speed": 50,
	"auto_advance_time": 1.6,
	"research_mode": false,
}

var game_data: Dictionary = {}
var game_settings: Dictionary = {}

func _ready() -> void:
	game_data = default_game_data
	game_settings = default_game_settings

func load_data() -> void:
	if !FileAccess.file_exists("user://save_data.save"):
		SignalHandler.emit_signal("scene_manager_show_dialog", "message", "no_save_file")
		var _file: FileAccess = FileAccess.open("user://save_data.save", FileAccess.WRITE)
	else:
		pass
	
func load_settings() -> void:
	var config_file: ConfigFile = ConfigFile.new()
	
	var err: Error = config_file.load("user://user_settings.cfg")
	
	if err != OK:
		return
		
	for setting in config_file.get_sections():
		pass
	
func save_data() -> void:
	var config_file: ConfigFile = ConfigFile.new()
	
	config_file.set_value("audio", "music_volume", game_settings["music_volume"])
	config_file.set_value("audio", "sound_effects_volume", game_settings["sound_effects_volume"])
	
	config_file.set_value("gameplay", "text_read_speed", game_settings["text_read_speed"])
	
	config_file.save("user://user_settings.cfg")

func save_settings() -> void:
	if !FileAccess.file_exists("user://user_settings.cfg"):
		var _settings_file: FileAccess = FileAccess.open("user://user_settings.cfg", FileAccess.WRITE)

func reset_data() -> void:
	game_data = default_game_data
	if FileAccess.file_exists("user://save_data.save"):
		FileAccess.open("user://save_data.save", FileAccess.WRITE)
	else:
		load_data()

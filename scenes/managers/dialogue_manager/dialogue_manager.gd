extends Control

##Controls how many characters are displayed per second.
@export var chars_per_second: int = 30
@export var base_character_position: int = 64

@export var text_label: Node = null
@export var character_label: Node = null
@onready var characters: Node = $Characters
@onready var objects: Node = $Objects

@onready var advance_timer: Node = $CanvasLayer/DialogueBox/AdvanceTimer
@onready var animation_player: Node = $AnimationPlayer
@onready var camera: Node = $Camera
@onready var wait_timer: Node = $WaitTimer
@onready var dialogue_progress: Node = $CanvasLayer/DialogueBox/DialogueProgress

@onready var music_player: Node = $MusicPlayer
@onready var sound_effect_player: Node = $SoundEffectPlayer

@onready var cover: Node = $Cover

var active_characters: Array = []
var active_objects: Array = []

var dialogue: Array = []
var current_dialogue_index: int = 0

var auto_mode_active: bool = false
## Setting whether the player can advance. Mostly used to stop duplicate inputs when dialogue has ended.
var advancing_active: bool = false

enum TextBoxState {
	READY,
	READING,
	FINISHED,
}

var dialogue_tween: Tween = null

var text_box_state: int = TextBoxState.READING

signal log_showing_requested

#Command Signals
signal change_background(path: String)
signal dialogue_said(character: String, dialogue: String)
signal dialogue_finished

func _ready() -> void:
	SignalHandler.connect("skip_dialogue", Callable(self, "skip_dialogue"))

func _physics_process(_delta: float) -> void:
	pass

func advance_dialogue() -> void:
	if current_dialogue_index >= dialogue.size() - 1:
		print_debug("Cannot advance dialogue, index exceeded size!")
		animation_player.play("HideDialogueBox_End")
		var ending_timer: Timer = Timer.new()
		add_child(ending_timer)
		ending_timer.connect("timeout", Callable(self, "_on_ending_timer_timeout"))
		ending_timer.start(3)
		advancing_active = false
	else:
		current_dialogue_index += 1
		process_dialogue_command()
	var dialogue_progress_tween: Tween = create_tween()
	dialogue_progress_tween.tween_property(dialogue_progress, "value", float(current_dialogue_index + 1.0) / dialogue.size(), 0.5)

func _on_ending_timer_timeout() -> void:
	emit_signal("dialogue_finished")

func skip_playing_dialogue() -> void:
	if dialogue_tween:
		dialogue_tween.kill()
	text_label.visible_ratio = 1.0
	if current_dialogue_index >= dialogue.size():
		text_box_state = TextBoxState.FINISHED
	else:
		text_box_state = TextBoxState.READY

	if auto_mode_active:
		advance_timer.start(DataHandler.game_settings["auto_advance_time"])

func dialogue_tween_finished() -> void:
	if current_dialogue_index >= dialogue.size():
		text_box_state = TextBoxState.FINISHED
	else:
		text_box_state = TextBoxState.READY
		
	if auto_mode_active:
		advance_timer.start(DataHandler.game_settings["auto_advance_time"])

func _on_skip_pressed() -> void:
	SignalHandler.emit_signal("scene_manager_show_dialog", "option", "skip_dialogue")

func _on_log_pressed() -> void:
	emit_signal("log_showing_requested")

func _on_text_label_meta_clicked(meta: Variant) -> void:
	var word_definitions: WordDefinitions = WordDefinitions.new()
	if word_definitions.definitions.has(meta):
		prints(word_definitions.definitions[meta]["definition"], word_definitions.definitions[meta]["source"])
	else:
		print("No definition set.")

func _on_auto_toggled(toggled_on: bool) -> void:
	if toggled_on:
		auto_mode_active = true
		match text_box_state:
			TextBoxState.READY:
				advance_dialogue()
			TextBoxState.READING:
				skip_playing_dialogue()
				advance_timer.start(DataHandler.game_settings["auto_advance_time"])
			TextBoxState.FINISHED:
				pass
	else:
		auto_mode_active = false
		advance_timer.stop()

func initialize_new_character() -> void:
	var new_character: Node = load("res://scenes/managers/dialogue_manager/character/character.tscn").instantiate()
	characters.add_child(new_character)
	active_characters.append(new_character)
	
func set_character_portrait(_target: int, _new_texture: String) -> void:
	if active_characters != []:
		pass
	else:
		print_debug("No characters initialized!")

func _on_dialogue_file_manager_dialogue_file_processed(new_dialogue: Array) -> void:
	dialogue = new_dialogue
	advancing_active = true
	process_dialogue_command()

func process_dialogue_command() -> void:
	var current_command: DialogueData = dialogue[current_dialogue_index]
	match current_command.type:
		"ACTION":
			process_dialogue_action(current_command.parameters[0])
			advance_dialogue()
		"ADD_SCENE":
			if ResourceLoader.exists(current_command.parameters[0]):
				var new_game_scene: Node = load(current_command.parameters[0]).instantiate()
				$Scenes.add_child(new_game_scene)
			advance_dialogue()
		"BG":
			if current_command.parameters[0] == "NULL":
				emit_signal("change_background", current_command.parameters[0])
				advance_dialogue()
			elif !ResourceLoader.exists(current_command.parameters[0]):
				advance_dialogue()
			elif current_command.parameters[0].get_extension() != "png":
				advance_dialogue()
			else:
				emit_signal("change_background", current_command.parameters[0])
				advance_dialogue()
		"COVER":
			if current_command.parameters[0] == "TRUE":
				$CoverAnim.play("ShowCover")
			elif current_command.parameters[0] == "FALSE":
				$CoverAnim.play("HideCover")
			advance_dialogue()	
		"C_MAZ":
			advancing_active = false
			var movement_tween: Tween = create_tween()
			movement_tween.tween_property(camera, "global_position", Vector2(float(current_command.parameters[0]) * get_viewport().size.x, float(current_command.parameters[1]) * get_viewport().size.y), float(current_command.parameters[3]))
			
			var zoom_tween: Tween = create_tween()
			zoom_tween.tween_property(camera, "zoom", Vector2(float(current_command.parameters[2]), float(current_command.parameters[2])), float(current_command.parameters[3]))
			zoom_tween.tween_callback(func() -> void: advancing_active = true)
			zoom_tween.tween_callback(func() -> void: advance_dialogue())
		"C_MOVE":
			advancing_active = false
			var tween: Tween = create_tween()
			tween.tween_property(camera, "global_position", Vector2(float(current_command.parameters[0]) * get_viewport().size.x, float(current_command.parameters[1]) * get_viewport().size.y), float(current_command.parameters[2]))
			tween.tween_callback(func() -> void: advancing_active = true)
			tween.tween_callback(func() -> void: advance_dialogue())
		"C_MOVE_R":
			advancing_active = false
			var tween: Tween = create_tween()
			tween.tween_property(camera, "global_position", Vector2(camera.global_position.x + int(current_command.parameters[0]), camera.global_position.y + int(current_command.parameters[1])), float(current_command.parameters[2]))
			tween.tween_callback(func() -> void: advancing_active = true)
			tween.tween_callback(func() -> void: advance_dialogue())
		"C_ZOOM":
			advancing_active = false
			var tween: Tween = create_tween()
			tween.tween_property(camera, "zoom", Vector2(float(current_command.parameters[0]), float(current_command.parameters[0])), float(current_command.parameters[1]))
			tween.tween_callback(func() -> void: advancing_active = true)
			tween.tween_callback(func() -> void: advance_dialogue())
		"CHAR":
			if current_command.parameters[0] != "":
				var new_character: Node = load("res://scenes/managers/dialogue_manager/character/character.tscn").instantiate()
				characters.add_child(new_character)
				active_characters.append(new_character)
				new_character.global_position = Vector2(float(current_command.parameters[1]) * get_viewport().size.x, float(current_command.parameters[2]) * get_viewport().size.y)
				new_character.character_name = current_command.parameters[0]
				new_character.change_texture_untargeted(current_command.parameters[3])
			advance_dialogue()
		"CHAR_MOVE":
			advancing_active = false
			var tween: Tween = create_tween()
			var target_character: Node = null
			for character: Node in get_tree().get_nodes_in_group("characters"):
				if character.character_name == current_command.parameters[0]:
					target_character = character
					break
				
			if target_character:
				tween.tween_property(target_character, "global_position", Vector2(float(current_command.parameters[1]) * get_viewport().size.x, float(current_command.parameters[2]) * get_viewport().size.y), float(current_command.parameters[3]))
				tween.tween_callback(func() -> void: advancing_active = true)
				tween.tween_callback(func() -> void: advance_dialogue())
			else:
				advance_dialogue()
		"DB_HIDE":
			animation_player.play("HideDialogueBox")
		"DB_SHOW":
			animation_player.play("ShowDialogueBox")
		"MUSIC":
			if ResourceLoader.exists(current_command.parameters[0]) && str(current_command.parameters[0]).get_extension() == "ogg":
				music_player.stream = load(current_command.parameters[0])
				music_player.play()
			else:
				music_player.stop()
				music_player.stream = null
			advance_dialogue()
		"OBJ":
			if current_command.parameters[0] != "":
				var new_object: Node = load("res://scenes/managers/dialogue_manager/object/object.tscn").instantiate()
				objects.add_child(new_object)
				active_objects.append(new_object)
				new_object.global_position = Vector2(float(current_command.parameters[1]) * get_viewport().size.x, float(current_command.parameters[2]) * get_viewport().size.y)
				new_object.id = active_objects.size() + 1
				new_object.change_texture(current_command.parameters[2])
			advance_dialogue()
		"OBJ_MOVE":
			advancing_active = false
			var tween: Tween = create_tween()
			
			var target_object: Node = null
			for object: Node in get_tree().get_nodes_in_group("objects"):
				if object.id == int(current_command.parameters[0]):
					target_object = object
					break
				
			if target_object:
				tween.tween_property(target_object, "global_position", Vector2(float(current_command.parameters[1]) * get_viewport().size.x, float(current_command.parameters[2]) * get_viewport().size.y), float(current_command.parameters[3]))
				tween.tween_callback(func() -> void: advancing_active = true)
				tween.tween_callback(func() -> void: advance_dialogue())
			else:
				advance_dialogue()
		"SAY":
			text_box_state = TextBoxState.READING
			text_label.visible_characters = 0

			character_label.text = current_command.parameters[0]
			text_label.text = current_command.parameters[1]
			
			if dialogue_tween:
				dialogue_tween.kill()
			dialogue_tween = create_tween()
			dialogue_tween.connect("finished", dialogue_tween_finished)
			dialogue_tween.tween_property(text_label, "visible_characters", current_command.parameters[1].length(), (1.0 / DataHandler.game_settings["text_read_speed"]) * (text_label.get_total_character_count()))
			dialogue_tween.tween_callback(func() -> void: text_box_state = TextBoxState.READY)
			
			if !ResourceLoader.exists(current_command.parameters[2]):
				pass
			elif current_command.parameters[2].get_extension() != "png":
				pass
			else:
				get_tree().call_group("characters", "change_texture", current_command.parameters[0], current_command.parameters[2])
				
			get_tree().call_group("characters", "set_saying_status", current_command.parameters[0])
				
			emit_signal("dialogue_said", current_command.parameters[0], current_command.parameters[1])
		"SCENE":
			if ResourceLoader.exists(current_command.parameters[0]):
				SignalHandler.emit_signal("scene_manager_change_scene", current_command.parameters[0])
				advancing_active = false
				advance_timer.stop()
			else:
				advance_dialogue()
		"WAIT":
			advancing_active = false
			wait_timer.start(float(current_command.parameters[0]))
		_:
			advance_dialogue()
	
func _on_wait_timer_timeout() -> void:
	advance_dialogue()
	advancing_active = true

func _on_advance_timer_timeout() -> void:
	match text_box_state:
		TextBoxState.READY:
			advance_dialogue()
		TextBoxState.FINISHED:
			pass

func _on_music_player_finished() -> void:
	music_player.play()

func process_dialogue_action(action: String) -> void:
	match action:
		_:
			pass

func skip_dialogue() -> void:
	animation_player.play("HideDialogueBox_End")
	advancing_active = false
	while current_dialogue_index < dialogue.size() - 1:
		if current_dialogue_index >= dialogue.size() - 1:
			pass
		else:
			advance_dialogue()

func set_dialogue(path: String) -> void:
	$DialogueFileManager.dialogue_file_path = path
	$DialogueFileManager.read_file()

func _on_text_label_gui_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("advance_dialogue") && advancing_active:
		match text_box_state:
			TextBoxState.READY:
				advance_dialogue()
			TextBoxState.READING:
				skip_playing_dialogue()
			TextBoxState.FINISHED:
				pass
		
func _on_text_box_background_gui_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("advance_dialogue") && advancing_active:
		match text_box_state:
			TextBoxState.READY:
				advance_dialogue()
			TextBoxState.READING:
				skip_playing_dialogue()
			TextBoxState.FINISHED:
				pass

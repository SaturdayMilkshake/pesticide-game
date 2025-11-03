extends Control

##Controls how many characters are displayed per second.
@export var chars_per_second: int = 30
@export var base_character_position: int = 64

@export var text_label: Node = null
@export var character_label: Node = null
@onready var characters: Node = $Characters

@onready var timer: Node = $CanvasLayer/DialogueBox/Timer
@onready var animation_player: Node = $AnimationPlayer
@onready var camera: Node = $Camera
@onready var wait_timer: Node = $WaitTimer

var example_dialogue: Dictionary = {
	"character": "Magenta",
	"dialogue": "Hello!",
}

var word_definitions: Dictionary = {
	"Test URL": "A basic example of a description.",
}

var active_characters: Array = []

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

func _ready() -> void:
	advance_dialogue()

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept") && advancing_active:
		match text_box_state:
			TextBoxState.READY:
				advance_dialogue()
			TextBoxState.READING:
				skip_playing_dialogue()
			TextBoxState.FINISHED:
				hide_dialogue()

func advance_dialogue() -> void:
	if current_dialogue_index >= dialogue.size() - 1:
		print_debug("Cannot advance dialogue, index exceeded size!")
	else:
		current_dialogue_index += 1
		process_dialogue_command()

func skip_playing_dialogue() -> void:
	if dialogue_tween:
		dialogue_tween.kill()
	text_label.visible_ratio = 1.0
	if current_dialogue_index >= dialogue.size():
		text_box_state = TextBoxState.FINISHED
	else:
		text_box_state = TextBoxState.READY

func dialogue_tween_finished() -> void:
	if current_dialogue_index >= dialogue.size():
		text_box_state = TextBoxState.FINISHED
	else:
		text_box_state = TextBoxState.READY
		
	if auto_mode_active:
		timer.start()

func _on_skip_pressed() -> void:
	text_box_state = TextBoxState.FINISHED
	hide_dialogue()

func _on_log_pressed() -> void:
	emit_signal("log_showing_requested")

func _on_timer_timeout() -> void:
	match text_box_state:
		TextBoxState.READY:
			advance_dialogue()
		TextBoxState.FINISHED:
			hide_dialogue()

func _on_text_label_meta_clicked(meta: Variant) -> void:
	if word_definitions.has(meta):
		print(word_definitions[meta])
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
				timer.start()
			TextBoxState.FINISHED:
				pass
	else:
		auto_mode_active = false

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

func process_dialogue_command() -> void:
	var current_command: DialogueData = dialogue[current_dialogue_index]
	match current_command.type:
		"BG":
			if !ResourceLoader.exists(current_command.parameters[0]):
				advance_dialogue()
			elif !current_command.parameters[0].get_extension() != "png":
				advance_dialogue()
			else:
				emit_signal("change_background", current_command.parameters[0])
				advance_dialogue()
		"C_MOVE":
			advancing_active = false
			var tween: Tween = create_tween()
			tween.tween_property(camera, "global_position", Vector2(int(current_command.parameters[0]), int(current_command.parameters[1])), float(current_command.parameters[2]))
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
			dialogue_tween.tween_property(text_label, "visible_characters", current_command.parameters[1].length(), (1.0 / chars_per_second) * (text_label.get_total_character_count()))
			dialogue_tween.tween_callback(func() -> void: text_box_state = TextBoxState.READY)
		"WAIT":
			advancing_active = false
			wait_timer.start(float(current_command.parameters[0]))
		_:
			advance_dialogue()
	
func _on_wait_timer_timeout() -> void:
	advance_dialogue()
	advancing_active = true

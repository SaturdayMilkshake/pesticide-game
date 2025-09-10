extends Control

##Controls how many characters are displayed per second.
@export var chars_per_second: int = 30
@export var base_character_position: int = 64

@export var text_label: Node = null
@export var character_label: Node = null
@onready var characters: Node = $Characters

@onready var timer: Node = $DialogueBox/Timer
@onready var animation_player: Node = $AnimationPlayer

var example_dialogue: Dictionary = {
	"character": "Magenta",
	"dialogue": "Hello!",
}

var word_definitions: Dictionary = {
	"Test URL": "A basic example of a description.",
}

var active_characters: Array = []

var dialogue: Array = [{"character": "Magenta", "dialogue": "Hello World! [url]Test URL[/url]"}, {"character": "Magenta", "dialogue": "This dialogue system is working now! Neat!"}, {"character": "Blue", "dialogue": "Goodbye!"}]
var current_dialogue_index: int = 0

var auto_mode_active: bool = false
## Setting whether the player can advance. Mostly used to stop duplicate inputs when dialogue has ended.
var advancing_active: bool = false

enum TextBoxState {
	READY,
	READING,
	FINISHED,
}

var dialogue_tween: Tween = create_tween()

var text_box_state: int = TextBoxState.READING

signal log_showing_requested

#Command Signals
signal change_background(path: String)

func _ready() -> void:
	pass

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		match text_box_state:
			TextBoxState.READY:
				advance_dialogue()
			TextBoxState.READING:
				skip_playing_dialogue()
			TextBoxState.FINISHED:
				hide_dialogue()
				
func initiate_dialogue(new_dialogue: Array) -> void:
	dialogue = new_dialogue
	#This requires -1 due to an issue with it not advancing on some commands automatically.
	current_dialogue_index = -1
	advance_dialogue()

func advance_dialogue() -> void:
	if current_dialogue_index >= dialogue.size() - 1:
		print_debug("Cannot advance dialogue, index exceeded size!")
	else:
		current_dialogue_index += 1
		process_dialogue_command()

func skip_playing_dialogue() -> void:
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
				hide_dialogue()
	else:
		auto_mode_active = false

func hide_dialogue() -> void:
	animation_player.play("HideDialogue")

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
	advancing_active = true
	initiate_dialogue(new_dialogue)

func process_dialogue_command() -> void:
	var current_command: Dictionary = dialogue[current_dialogue_index]
	if !current_command.has("type"):
		return
	else:
		match current_command["type"]:
			"BG":
				if !ResourceLoader.exists(current_command["path"]):
					advance_dialogue()
				elif !current_command["path"].get_extension() != "png":
					advance_dialogue()
				emit_signal("change_background", current_command["path"])
				advance_dialogue()
			"INIT":
				advance_dialogue()
			"SAY":
				text_box_state = TextBoxState.READING
				text_label.visible_characters = 0

				#$DialogueBox/CharacterLabel.text = dialogue[current_dialogue_index]["character"]
				text_label.text = dialogue[current_dialogue_index]["dialogue"]
				
				dialogue_tween.kill()
				dialogue_tween = create_tween()
				dialogue_tween.connect("finished", dialogue_tween_finished)
				dialogue_tween.tween_property(text_label, "visible_characters", dialogue[current_dialogue_index]["dialogue"].length(), (1.0 / chars_per_second) * (text_label.get_total_character_count()))
				dialogue_tween.tween_callback(func() -> void: text_box_state = TextBoxState.READY)
			_:
				return
	

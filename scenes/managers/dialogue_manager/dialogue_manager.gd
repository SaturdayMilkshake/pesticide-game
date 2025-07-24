extends Control

##Controls how many characters are displayed per second.
@export var chars_per_second: int = 30

@onready var text_label: Node = $DialogueBox/TextLabel
@onready var character_label: Node = $DialogueBox/CharacterLabel

@onready var timer: Node = $DialogueBox/Timer
@onready var animation_player: Node = $AnimationPlayer

var example_dialogue: Dictionary = {
	"character": "Magenta",
	"dialogue": "Hello!",
}

var word_definitions: Dictionary = {
	"Test URL": "A basic example of a description.",
}

var dialogue: Array[Dictionary] = [{"character": "Magenta", "dialogue": "Hello World! [url]Test URL[/url]"}, {"character": "Magenta", "dialogue": "This dialogue system is working now! Neat!"}, {"character": "Blue", "dialogue": "Goodbye!"}]
var current_dialogue_index: int = 0

var auto_mode_active: bool = false

enum TextBoxState {
	READY,
	READING,
	FINISHED,
}

@onready var dialogue_tween: Tween = create_tween()

var text_box_state: int = TextBoxState.READING

signal log_showing_requested

func _ready() -> void:
	initiate_dialogue(dialogue)
	advance_dialogue()

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		match text_box_state:
			TextBoxState.READY:
				advance_dialogue()
			TextBoxState.READING:
				skip_playing_dialogue()
			TextBoxState.FINISHED:
				animation_player.play("HideDialogue")
				
func initiate_dialogue(_dialogue: Array[Dictionary]) -> void:
	current_dialogue_index = 0

func advance_dialogue() -> void:
	if current_dialogue_index >= dialogue.size():
		print_debug("Cannot advance dialogue, index exceeded size!")
	else:
		text_box_state = TextBoxState.READING
		text_label.visible_characters = 0

		character_label.text = dialogue[current_dialogue_index]["character"]
		text_label.text = dialogue[current_dialogue_index]["dialogue"]
		
		dialogue_tween.kill()
		dialogue_tween = create_tween()
		dialogue_tween.connect("finished", dialogue_tween_finished)
		dialogue_tween.tween_property(text_label, "visible_characters", dialogue[current_dialogue_index]["dialogue"].length(), (1.0 / chars_per_second) * (text_label.get_total_character_count()))
		dialogue_tween.tween_callback(func() -> void: text_box_state = TextBoxState.READY)
		current_dialogue_index += 1

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
		
func activate_auto_mode() -> void:
	pass

func _on_auto_pressed() -> void:
	if !auto_mode_active:
		auto_mode_active = true
		match text_box_state:
			TextBoxState.READY:
				advance_dialogue()
			TextBoxState.READING:
				skip_playing_dialogue()
				timer.start()
	else:
		auto_mode_active = false

func _on_skip_pressed() -> void:
	text_box_state = TextBoxState.FINISHED
	animation_player.play("HideDialogue")

func _on_log_pressed() -> void:
	emit_signal("log_showing_requested")

func _on_timer_timeout() -> void:
	advance_dialogue()

func _on_text_label_meta_clicked(meta: Variant) -> void:
	if word_definitions.has(meta):
		print(word_definitions[meta])
	else:
		print("No definition set.")

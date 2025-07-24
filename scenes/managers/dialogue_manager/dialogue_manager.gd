extends Control

##Controls how many characters are displayed per second.
@export var chars_per_second: int = 30

@onready var text_label: Node = $TextLabel

var dialogue: Array[String] = ["Hello world! bibuihfuihasuicfhuowhdohuoi", "This dialogue system is working now! Neat!", "Goodbye!"]
var current_dialogue_index: int = 0

enum TextBoxState {
	READY,
	READING,
	FINISHED,
}

@onready var dialogue_tween: Tween = create_tween()

var text_box_state: int = TextBoxState.READING

func _ready() -> void:
	initiate_dialogue(dialogue)
	advance_dialogue()

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		match text_box_state:
			TextBoxState.READY:
				text_box_state = TextBoxState.READING
				advance_dialogue()
			TextBoxState.READING:
				skip_playing_dialogue()
				if current_dialogue_index >= dialogue.size():
					text_box_state = TextBoxState.FINISHED
				else:
					text_box_state = TextBoxState.READY
			TextBoxState.FINISHED:
				pass
				
func initiate_dialogue(dialogue: Array[String]) -> void:
	current_dialogue_index = 0

func advance_dialogue() -> void:
	text_label.visible_characters = 0

	text_label.text = dialogue[current_dialogue_index]
	
	dialogue_tween.kill()
	dialogue_tween = create_tween()
	dialogue_tween.connect("finished", dialogue_tween_finished)
	dialogue_tween.tween_property(text_label, "visible_characters", dialogue[current_dialogue_index].length(), (1.0 / chars_per_second) * (text_label.get_total_character_count()))
	dialogue_tween.tween_callback(func() -> void: text_box_state = TextBoxState.READY)
	current_dialogue_index += 1

func skip_playing_dialogue() -> void:
	dialogue_tween.kill()
	text_label.visible_ratio = 1.0

func dialogue_tween_finished() -> void:
	if current_dialogue_index >= dialogue.size():
		text_box_state = TextBoxState.FINISHED
	else:
		text_box_state = TextBoxState.READY

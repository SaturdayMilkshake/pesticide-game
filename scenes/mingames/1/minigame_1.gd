extends Node2D

var game_active: bool = false
var question_active: bool = false
var selection_active: bool = false

var question_time: int = 18

var roulette_items: Array = [
	$GameObjects/Roulette/RouletteItems/RouletteItem,
	$GameObjects/Roulette/RouletteItems/RouletteItem2,
	$GameObjects/Roulette/RouletteItems/RouletteItem3,
	$GameObjects/Roulette/RouletteItems/RouletteItem4,
	$GameObjects/Roulette/RouletteItems/RouletteItem5,
	$GameObjects/Roulette/RouletteItems/RouletteItem6,
]

var current_question: int = 0

var score: int = 0

var questions: Array = [
	{
		"question": "This organ produces the egg cells.",
		"answer": "Ovaries",
		"choices": ["Ovaries", "Testes", "Epididymis", "Uterus", "Vagina", "Cervix"],
	},
	{	
		"question": "The sperm exits through this tube during ejaculation.",
		"answer": "Urethra",
		"choices": ["Cervix", "Urethra", "Epididymis", "Vagina", "Uterus", "Fallopian Tubes"],
	},
	{
		"question": "This is a tube where sperm is stored.",
		"answer": "Epididymis",
		"choices": ["Testes", "Fallopian Tubes", "Epididymis", "Urethra", "Uterus", "Cervix"],
	},
	{	
		"question": "This is a tube that connects the uterus to the outside of the body.",
		"answer": "Vagina",
		"choices": ["Urethra", "Fallopian Tubes", "Testes", "Vagina", "Ovaries", "Cervix"],
	},
	{
		"question": "This organ connects the vagina to the uterus.",
		"answer": "Cervix",
		"choices": ["Fallopian Tubes", "Urethra", "Epididymis", "Ovaries", "Cervix", "Testes"],
	},
	{	
		"question": "These organs produce sperm and the hormone testosterone.",
		"answer": "Testes",
		"choices": ["Ovaries", "Cervix", "Epididymis", "Urethra", "Uterus", "Testes"],
	},
	{
		"question": "This organ is where a baby grows during pregnancy.",
		"answer": "Uterus",
		"choices": ["Vagina", "Cervix", "Uterus", "Fallopian Tubes", "Ovaries", "Testes"],
	},
]

var correct_answer: String = ""

@onready var question_timer: Node = $GameObjects/Timer/Timer
@onready var answer_raycast: Node = $GameObjects/Roulette/RayCast2D

@onready var game_anim: Node = $GameAnim

#yeah i hardcoded a lot of these values what are you gonna do about it huh

func _ready() -> void:
	SignalHandler.connect("retry_game", Callable(self, "retry_game"))
	$BGAnim.play("AnimateBG")
	roulette_items = get_tree().get_nodes_in_group("roulette")
	
func _physics_process(_delta: float) -> void:
	if game_active:
		if question_active:
			$GameObjects/Timer/TextureProgressBar.value = question_timer.time_left
			if selection_active:
				if Input.is_action_just_pressed("advance_dialogue") || Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
					question_active = false
					selection_active = false
					get_tree().call_group("roulette", "stop_items")
					question_timer.stop()
					game_anim.play("ShowAnswerPointer")
					
	if Input.is_action_just_pressed("skip"):
		end_game()

func load_ready() -> void:
	game_anim.play("Intro")

func _on_okay_pressed() -> void:
	game_anim.play("HideInstructions")

func start_game() -> void:
	current_question = 0
	score = 0
	game_active = true
	start_question()
	
func start_question() -> void:
	current_question += 1
	#i love hardcoding values
	if current_question > 7:
		end_game()
		return
	for item: Node in roulette_items:
		item.reset_modulate()
	set_roulette_content()
	$GameObjects/QuestionPanel/QuestionNumber.text = "Question %s / 7:" % current_question
	$GameObjects/QuestionPanel/QuestionData.text = questions[current_question - 1]["question"]
	get_tree().call_group("roulette", "start_items", 2 + (current_question * 1))
	question_active = true
	game_anim.play("ShowTimer")
	var tween: Tween = create_tween()
	tween.tween_property($GameObjects/Timer/TextureProgressBar, "value", 15, 0.5).set_trans(Tween.TRANS_EXPO)
	question_timer.start(question_time)
	
func set_roulette_content() -> void:
	var index: int = 0
	#what a band-aid fix don't do this ever again
	for choice in questions[current_question - 1]["choices"]:
		roulette_items[index].set_item(choice)
		if index >= roulette_items.size():
			return
		index += 1
	
func check_answer() -> void:
	var answer_item: Node = answer_raycast.get_collider()
	
	if answer_item:
		var answer_content: Node = answer_item.get_parent()
		if answer_content.item_content == questions[current_question - 1]["answer"]:
			score += 1
			answer_content.play_anim("Correct")
		else:
			answer_content.play_anim("Wrong")
	else:
		pass

	game_anim.queue("HideRoulette")
	game_anim.queue("HideQuestion")

func activate_selection() -> void:
	selection_active = true

func _on_timer_timeout() -> void:
	question_active = false
	selection_active = false
	game_anim.queue("HideRoulette")
	game_anim.queue("HideQuestion")

func end_game() -> void:
	game_active = false
	SignalHandler.emit_signal("scene_manager_show_dialog", "message", "retry_game", score)

func _on_settings_button_pressed() -> void:
	SignalHandler.emit_signal("scene_manager_show_settings")

func _on_back_to_menu_button_pressed() -> void:
	SignalHandler.emit_signal("scene_manager_show_dialog", "option", "return_minigame")

func retry_game() -> void:
	start_game()

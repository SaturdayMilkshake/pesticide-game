extends Node2D

var game_active: bool = false
var question_active: bool = false
var selection_active: bool = false

var question_time: int = 18

var roulette_items: Array = []

var current_question: int = 0

var score: int = 0

var questions: Array = [
	{
		"question": "This organ produces the egg cells.",
		"answer": "Ovaries",
	},
	{	
		"question": "The sperm exits through this tube during ejaculation.",
		"answer": "Urethra",
	},
	{
		"question": "This is a tube where sperm is stored.",
		"answer": "Epididymis",
	},
	{	
		"question": "This is a tube that connects the uterus to the outside of the body.",
		"answer": "Vagina",
	},
	{
		"question": "This organ connects the vagina to the uterus.",
		"answer": "Cervix",
	},
	{	
		"question": "These organs produce sperm and the hormone testosterone.",
		"answer": "Testes",
	},
	{
		"question": "This organ is where a baby grows during pregnancy.",
		"answer": "Uterus",
	},
]

var correct_answer: String = ""

@onready var question_timer: Node = $GameObjects/Timer/Timer
@onready var answer_raycast: Node = $GameObjects/Roulette/RayCast2D

@onready var game_anim: Node = $GameAnim

#yeah i hardcoded a lot of these values what are you gonna do about it huh

func _ready() -> void:
	$BGAnim.play("AnimateBG")
	game_anim.play("Intro")
	roulette_items = get_tree().get_nodes_in_group("roulette")
	
func _physics_process(delta: float) -> void:
	if game_active:
		pass

	if question_active:
		$GameObjects/Timer/TextureProgressBar.value = question_timer.time_left
		
		if selection_active:
			if Input.is_action_just_pressed("advance_dialogue") || Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
				question_active = false
				selection_active = false
				get_tree().call_group("roulette", "stop_items")
				question_timer.stop()
				game_anim.play("ShowAnswerPointer")

func load_ready() -> void:
	game_anim.play("Intro")

func _on_okay_pressed() -> void:
	game_anim.play("HideInstructions")

func start_game() -> void:
	game_active = true
	start_question()
	
func start_question() -> void:
	current_question += 1
	#i love hardcoding values
	if current_question > 7:
		end_game()
		return
	$GameObjects/QuestionPanel/QuestionNumber.text = "Question %s / 7:" % current_question
	$GameObjects/QuestionPanel/QuestionData.text = questions[current_question]["question"]
	get_tree().call_group("roulette", "start_items", 2 + (current_question * 2))
	question_active = true
	game_anim.play("ShowTimer")
	var tween: Tween = create_tween()
	tween.tween_property($GameObjects/Timer/TextureProgressBar, "value", 15, 0.5).set_trans(Tween.TRANS_EXPO)
	question_timer.start(question_time)
	
func check_answer() -> void:
	var answer_item: Node = answer_raycast.get_collider()
	
	if answer_item:
		var answer_content: Node = answer_item.get_parent()
		var correct: bool = answer_content.item_content == correct_answer
		if correct:
			score += 1
			game_anim.play("AnswerCorrect")
		else:
			game_anim.play("AnswerWrong")
	else:
		game_anim.play("AnswerMissed")

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

func _on_settings_button_pressed() -> void:
	SignalHandler.emit_signal("scene_manager_show_settings")

func _on_back_to_menu_button_pressed() -> void:
	SignalHandler.emit_signal("scene_manager_show_dialog", "option", "return_minigame")

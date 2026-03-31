extends Node2D

var game_active: bool = false
var question_active: bool = false

var selection_active: bool = false

var current_question: int = 0

var score: int = 0

var item_source: Node = null

var questions: Array = [
	{
		"question": "Women cannot get pregnant on their period.",
		"answer": "False",
	},
	{	
		"question": "The ovaries release an egg cell into the fallopian tubes every month.",
		"answer": "True",
	},
	{
		"question": "Sexual intercourse always leads to pregnancy.",
		"answer": "False",
	},
	{	
		"question": "Pregnancy occurs when a sperm cell and an egg cell unite and are implanted in the uterus.",
		"answer": "True",
	},
	{
		"question": "Semen is the bodily fluid that contains the sperm cells.",
		"answer": "True",
	},
]

@onready var roulette_items: Array = [$GameObjects/Options/RouletteItem, $GameObjects/Options/RouletteItem2]

func _ready() -> void:
	$BGAnim.play("AnimateBG")
	
func load_ready() -> void:
	$GameAnim.play("Intro")

func _on_okay_pressed() -> void:
	$GameAnim.play("HideInstructions")
	
func _physics_process(_delta: float) -> void:
	if question_active:
		$GameObjects/Timer/TextureProgressBar.value = $GameObjects/Timer/Timer.time_left
	if Input.is_action_just_pressed("skip"):
		end_game()
	
func _on_settings_button_pressed() -> void:
	SignalHandler.emit_signal("scene_manager_show_settings")

func _on_back_to_menu_button_pressed() -> void:
	SignalHandler.emit_signal("scene_manager_show_dialog", "option", "return_minigame")

func start_game() -> void:
	current_question = 0
	score = 0
	game_active = true
	start_question()
	
func end_game() -> void:
	game_active = false
	SignalHandler.emit_signal("scene_manager_show_dialog", "message", "retry_game", score)

func start_question() -> void:
	if current_question >= 5:
		end_game()
		return
	current_question += 1
	$GameAnim.play("ShowTimer")
	$GameObjects/QuestionPanel/QuestionNumber.text = "Question %s / 5:" % current_question
	$GameObjects/QuestionPanel/QuestionData.text = questions[current_question - 1]["question"]
	$GameObjects/Options/RouletteItem.reset_modulate()
	$GameObjects/Options/RouletteItem2.reset_modulate()
	var tween: Tween = create_tween()
	tween.tween_property($GameObjects/Timer/TextureProgressBar, "value", 15, 0.5).set_trans(Tween.TRANS_EXPO)
	
func start_timer() -> void:
	question_active = true
	$GameObjects/Timer/Timer.start(15)

func check_question(content: String) -> void:
	$GameObjects/Timer/Timer.stop()
	question_active = false
	if content == questions[current_question - 1]["answer"]:
		item_source.play_anim("Correct")
		score += 1
	else:
		item_source.play_anim("Wrong")
	$GameAnim.play("HideOptions")
	$GameAnim.queue("HideQuestion")

func _on_roulette_item_item_selected(source: Node, item_content: String) -> void:
	question_active = false
	selection_active = false
	item_source = source
	check_question(item_content)

func _on_roulette_item_2_item_selected(source: Node, item_content: String) -> void:
	question_active = false
	selection_active = false
	item_source = source
	check_question(item_content)
	
func _on_timer_timeout() -> void:
	question_active = false
	selection_active = false
	$GameAnim.queue("HideQuestion")
	$GameAnim.queue("HideOptions")

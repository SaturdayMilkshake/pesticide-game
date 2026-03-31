extends Node2D

@export var mini_2_item: bool = false
@export var item_content: String = ""
var item_speed: int = 4

var spawn_pos_left: int = -384
var spawn_pos_right: int = 2304


signal item_selected(source: Node, item_content: String)

func _ready() -> void:
	if mini_2_item:
		item_speed = 0
		set_item(item_content)

func _physics_process(_delta: float) -> void:
	self.global_position.x -= item_speed
	
	if self.global_position.x < spawn_pos_left:
		self.global_position.x = spawn_pos_right
	elif self.global_position.x > spawn_pos_right:
		self.global_position.x = spawn_pos_left

func stop_items() -> void:
	item_speed = 0
	
func start_items(speed: int) -> void:
	item_speed = speed
	
func set_item(content: String) -> void:
	item_content = content
	$Label.text = content
	match item_content:
		"Cervix":
			$TextureRect.texture = load("")
		"Epydidymis":
			$TextureRect.texture = load("")
		"Ovaries":
			$TextureRect.texture = load("")
		"Testes":
			$TextureRect.texture = load("")
		"Urethra":
			$TextureRect.texture = load("")
		"Uterus":
			$TextureRect.texture = load("")
		"Vagina":
			$TextureRect.texture = load("")
		"Vas Deferens":
			$TextureRect.texture = load("")
		"":
			$TextureRect.texture = load("")
		_:
			pass

func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if mini_2_item:
		if event.is_action_pressed("advance_dialogue"):
			emit_signal("item_selected", self, item_content)

func play_anim(anim_name: String) -> void:
	$AnimationPlayer.play(anim_name)

func reset_modulate() -> void:
	$Panel.modulate = Color.WHITE

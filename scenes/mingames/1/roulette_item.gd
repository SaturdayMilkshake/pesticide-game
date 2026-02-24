extends Node2D

var item_content: String = ""
var item_speed: int = 4

var spawn_pos_left: int = -384
var spawn_pos_right: int = 2304

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	self.global_position.x -= item_speed
	
	if self.global_position.x < spawn_pos_left:
		self.global_position.x = spawn_pos_right
	elif self.global_position.x > spawn_pos_right:
		self.global_position.x = spawn_pos_left

func stop_items() -> void:
	item_speed = 0
	
func start_items(speed: int) -> void:
	item_speed = speed

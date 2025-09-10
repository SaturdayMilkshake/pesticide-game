extends Control

@onready var scroll_container: Node = $ScrollContainer

func _ready() -> void:
	self.visible = false

func show_log() -> void:
	self.visible = true
	
func hide_log() -> void:
	self.visible = false
	
func reset_log() -> void:
	for log_item: Node in scroll_container.get_children():
		log_item.queue_free()

func update_log() -> void:
	pass

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton && event.button_index == 1:
		hide_log()

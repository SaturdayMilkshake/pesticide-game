extends Control

@export var scroll_container: Node = null
@export var log_item_container: Node = null
func _ready() -> void:
	self.visible = false

func show_log() -> void:
	self.visible = true
	
func hide_log() -> void:
	self.visible = false
	
func reset_log() -> void:
	for log_item: Node in log_item_container.get_children():
		log_item.queue_free()

func update_log(character: String, dialogue: String) -> void:
	var new_log_item: Node = load("res://scenes/managers/log_manager/log_item.tscn").instantiate()
	log_item_container.add_child(new_log_item)
	new_log_item.set_log_item_text(character, dialogue)
	
	if log_item_container.get_child_count() > 50:
		log_item_container.get_child(0).queue_free()
		
	call_deferred("scroll_container_scroll_to_bottom")

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton && event.button_index == 1:
		hide_log()

func scroll_container_scroll_to_bottom() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(scroll_container, "scroll_vertical", log_item_container.size.y, 0.5).set_trans(Tween.TRANS_EXPO)

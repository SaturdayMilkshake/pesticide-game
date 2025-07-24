extends Control

func _ready() -> void:
	self.visible = false

func show_log() -> void:
	self.visible = true
	
func hide_log() -> void:
	self.visible = false

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton && event.button_index == 1:
		hide_log()

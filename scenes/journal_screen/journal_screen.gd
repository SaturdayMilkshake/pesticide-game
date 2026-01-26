extends Node2D

@onready var animation_player: Node = $AnimationPlayer

@onready var toggle_display_button: Node = $ToggleDisplay

enum CurrentJournalDisplay {
	ACHIEVEMENTS,
	SECRET_ACHIEVEMENTS,
	WORD_LIST,
}

var current_journal_display: int = CurrentJournalDisplay.ACHIEVEMENTS

func load_ready() -> void:
	animation_player.play("ShowAchievements")

func _on_back_to_title_pressed() -> void:
	SignalHandler.emit_signal("scene_manager_change_scene", "res://scenes/title_screen/title_screen.tscn")

func _on_toggle_display_pressed() -> void:
	match current_journal_display:
		CurrentJournalDisplay.ACHIEVEMENTS:
			animation_player.queue("HideAchievements")
			animation_player.queue("ShowWordList")
			toggle_display_button.text = "Achievements"
			current_journal_display = CurrentJournalDisplay.WORD_LIST
		CurrentJournalDisplay.SECRET_ACHIEVEMENTS:
			pass
		CurrentJournalDisplay.WORD_LIST:
			animation_player.queue("HideWordList")
			animation_player.queue("ShowAchievements")
			toggle_display_button.text = "Word List"
			current_journal_display = CurrentJournalDisplay.ACHIEVEMENTS

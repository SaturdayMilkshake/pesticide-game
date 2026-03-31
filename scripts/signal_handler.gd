extends Node

# Scene Manager
@warning_ignore("unused_signal")
signal scene_manager_change_scene(path: String)
@warning_ignore("unused_signal")
signal scene_manager_show_dialog(dialog_type: String, message_header: String, score: int)
@warning_ignore("unused_signal")
signal scene_manager_show_settings
@warning_ignore("unused_signal")
signal scene_manager_process_action(action: String)
@warning_ignore("unused_signal")
signal skip_dialogue
@warning_ignore("unused_signal")
signal retry_game

extends Node

# Scene Manager
@warning_ignore("unused_signal")
signal scene_manager_change_scene(path: String)
@warning_ignore("unused_signal")
signal scene_manager_show_dialog(dialog_type: String, message_header: String)
@warning_ignore("unused_signal")
signal scene_manager_show_settings
@warning_ignore("unused_signal")
signal scene_manager_process_action(action: String)

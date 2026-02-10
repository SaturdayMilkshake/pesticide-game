class_name Messages
extends Node

var messages: Dictionary = {
	"return_chapter": {
		"title": "Return to Chapter Select",
		"message": "Are you sure you want to exit the current chapter?",
		"action": "return_chapter",
	},
	"credits": {
		"title": "Credits",
		"message": "A game by Gian Marco Batarilan (SaturdayMilkshake)
		Created for my research subject
		
		Made with Godot 4
		Art created with Krita
		Music composed with LMMS",
		"action": "",
	},
	"error_header": {
		"title": "Message Header Error",
		"message": "Message header not found! Header: ",
		"action": "",
	},
	"error_scene": {
		"title": "Scene Loading Error",
		"message": "Unable to load scene!\nYou will be redirected to the title screen.",
		"action": "scene_title",
	},
	"no_save_file": {
		"title": "Save File Error",
		"message": "No save file detected. A new save file will be created.",
		"action": "new_save",
	},
	"reset_save_file": {
		"title": "Reset Save File?",
		"message": "Are you sure you want to reset your save file? There is no undo!",
		"action": "reset_save",
		"cancel": "",
	},
	"skip_dialogue": {
		"title": "Skip Current Dialogue?",
		"message": "Are you sure you want to skip the current dialogue?",
		"action": "skip_dialogue",
		"cancel": "",
	},
	"survey": {
		"title": "Heads up!",
		"message": "Are you one of the participants of the study? If so, please press Okay to be redirected to the pre-test.",
		"action": "survey_pre",
		"cancel": "scene_title",
	},
	"survey_pre": {
		"title": "Pre-Test Survey",
		"message": "The pre-test survey has been opened in your default web browser. Please press Okay when accomplished.\nThank you for your participation!",
		"action": "scene_title",
	},
	"survey_post": {
		"title": "Post-Test Survey",
		"message": "The post-test survey has been opened in your default web browser. Please press Okay when accomplished.\nThank you for your participation!",
		"action": "",
	},
}

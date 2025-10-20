class_name Messages
extends Node

var messages: Dictionary = {
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
	"save_file": {
		"title": "Save File Error",
		"message": "No save file detected. A new save file will be created.",
		"action": "new_save",
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

var error_messages: Dictionary = {
	
}

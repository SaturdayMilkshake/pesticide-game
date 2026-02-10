extends Node2D

func _ready() -> void:
	$BGAnim.play("AnimateBG")

func load_ready() -> void:
	$GameAnim.play("Part1Intro")

func _on_okay_pressed() -> void:
	$GameAnim.play("Part1HideInstructions")

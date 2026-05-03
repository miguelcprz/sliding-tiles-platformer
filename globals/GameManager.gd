extends Node

var sliding_mode_on : bool = true

func _input(event: InputEvent) -> void:
	if event.is_action("toggle_silder_mode"):
		sliding_mode_on = !sliding_mode_on

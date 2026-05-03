extends Node

var sliding_mode_on : bool = true

signal sliding_mode_changed

func _ready() -> void:
	get_tree().scene_changed.connect(restart)

func restart() -> void:
	sliding_mode_on = true

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_silder_mode"):
		sliding_mode_on = !sliding_mode_on
		sliding_mode_changed.emit(sliding_mode_on)

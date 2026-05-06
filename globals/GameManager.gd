extends Node

var sliding_mode_on : bool = false:
	set(value):
		sliding_mode_on = value
		sliding_mode_changed.emit(value)
		
signal sliding_mode_changed
func _ready() -> void:
	get_tree().scene_changed.connect(_restart)
	
func _restart() -> void:
	sliding_mode_on = false

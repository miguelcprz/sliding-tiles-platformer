extends AnimationPlayer


func _on_animation_finished(_anim_name: StringName) -> void:
	if current_animation_position != 0:
		play_backwards("move_tiles")
	else:
		play("move_tiles")

extends CanvasLayer

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause") and get_tree().paused == false:
		show()
		get_tree().paused = true
	
	elif event.is_action_pressed("pause") and get_tree().paused == true:
		hide()
		get_tree().paused = false

func _on_resume_button_pressed() -> void:
		hide()
		get_tree().paused = false


func _on_quit_button_pressed() -> void:
	get_tree().call_deferred("change_scene_to_file","res://scenes/main_menu.tscn")

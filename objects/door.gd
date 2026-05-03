extends Area2D

func win_game(body : Node2D) -> void:
	if !has_overlapping_areas() and body is Player:
		get_tree().call_deferred("change_scene_to_file","res://scenes/win_screen.tscn")
	

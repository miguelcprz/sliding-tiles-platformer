extends Area2D

@export var fade_color_rect : ColorRect

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.is_knocked = true
		body.velocity = Vector2.ZERO
		var tween = create_tween()
		tween.tween_property(fade_color_rect,"color",Color.WHITE,2.0)
		await tween.finished
		get_tree().call_deferred("change_scene_to_file","res://scenes/main_menu.tscn")

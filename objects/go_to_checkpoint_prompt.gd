extends Sprite2D

func show_checkpoint_prompt(body) -> void:
	if body is Player and visible == false:
		visible = true

class_name PortraitTrigger extends Area2D

@export var portrait : Portrait

func _ready() -> void:
	set_collision_mask_value(1,false)
	set_collision_layer_value(1,false)
	set_collision_mask_value(3,true)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_silder_mode") and has_overlapping_bodies():
		if get_overlapping_bodies()[0] is Player:
			if get_overlapping_bodies()[0].velocity == Vector2.ZERO:
				portrait.sliding_mode_on = !portrait.sliding_mode_on

class_name KnockbackEnemy extends CharacterBody2D

@export var patrol_speed = 20
@export var right_raycast : RayCast2D
@export var left_raycast : RayCast2D
@export var player_detect_area : Area2D

func _ready() -> void:
	velocity = Vector2.RIGHT*patrol_speed
	player_detect_area.body_entered.connect(knock_back)
	ready.connect(left_raycast.force_raycast_update)
	ready.connect(right_raycast.force_raycast_update)
	
func _physics_process(_delta: float) -> void:
	move_and_slide()
	turn_around()
	
func knock_back(body) -> void:
	if body is Player:
		if not body.is_knocked:
			body.get_knocked(self)

func turn_around() -> void:
	if right_raycast.is_colliding() and left_raycast.is_colliding():
		return
	
	elif not right_raycast.is_colliding():
		velocity = Vector2.LEFT*patrol_speed
	
	elif not left_raycast.is_colliding():
		velocity = Vector2.RIGHT*patrol_speed

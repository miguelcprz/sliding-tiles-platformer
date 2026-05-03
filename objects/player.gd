class_name Player extends CharacterBody2D
const GRAVITY = Vector2(0,128)
const SPEED = 32
const JUMP_FORCE = 48

func _physics_process(delta: float) -> void:
	move_and_slide()
	apply_gravity(delta)
	movement_methods(delta)

func movement_methods(_delta:float) -> void:
	if not GameManager.sliding_mode_on:
		move()
		jump()

func apply_gravity(delta:float) -> void:
	if !is_on_floor():
		if velocity.y >= 0:
			velocity.y += 2*GRAVITY.y*delta
		else:
			velocity.y += GRAVITY.y*delta

func move() -> void:
	var direction = Input.get_axis("ui_left","ui_right")
	velocity.x = direction*SPEED
	
func jump() -> void:
	if is_on_floor() and Input.is_action_just_pressed("ui_accept"):
		velocity.y = -JUMP_FORCE
	

class_name Player extends CharacterBody2D
var gravity := 185
var speed := 450
var jump_force := 650

@export var player_sprite : Sprite2D

func _ready() -> void:
	gravity = DevMode.gravity
	speed = DevMode.speed
	jump_force = DevMode.jump_force

func _physics_process(delta: float) -> void:
	move_and_slide()
	apply_gravity(delta)
	movement_methods(delta)

func movement_methods(_delta:float) -> void:
	if not GameManager.sliding_mode_on:
		move()
		jump()
		flip_sprite()

func apply_gravity(delta:float) -> void:
	if !is_on_floor():
		if velocity.y >= 0:
			velocity.y += 2*gravity*delta
		else:
			velocity.y += gravity*delta

func move() -> void:
	var direction = Input.get_axis("ui_left","ui_right")
	velocity.x = direction*speed

func jump() -> void:
	if is_on_floor() and Input.is_action_just_pressed("ui_accept"):
		velocity.y = -jump_force

func flip_sprite() -> void:
	if velocity.x == 0:
		return
		
	if velocity.x > 0:
		player_sprite.flip_h = false
		
	elif velocity.x < 0:
		player_sprite.flip_h = true

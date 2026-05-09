class_name Player extends CharacterBody2D
var gravity := 185
var speed := 450
var jump_force := 650
var is_knocked : bool = true

const KNOCK_FORCE = Vector2(300,-200)

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
	if not GameManager.sliding_mode_on and not is_knocked:
		move()
		jump()
		flip_sprite()

func get_knocked(enemy : KnockbackEnemy) -> void:
		is_knocked = true
		AudioManager.play_knockback()
		if enemy.global_position.x > global_position.x:
			velocity.x = -KNOCK_FORCE.x
			
		else:
			velocity.x = KNOCK_FORCE.x
			
		await get_tree().create_timer(0.8,false).timeout
		create_tween().tween_property(self,"velocity:x",0,0.3)
		is_knocked = false

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
		run_jump_sound_chance()

func run_jump_sound_chance() -> void:
	if 0.5 >= randf_range(0,1):
		AudioManager.play_jump()
	

func flip_sprite() -> void:
	if velocity.x == 0:
		return
		
	if velocity.x > 0:
		player_sprite.flip_h = false
		
	elif velocity.x < 0:
		player_sprite.flip_h = true

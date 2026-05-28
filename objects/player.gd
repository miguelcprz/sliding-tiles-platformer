class_name Player extends CharacterBody2D
var gravity := 750
var speed := 180
var jump_force := 300
var is_coyote_time : bool = true
var is_knocked : bool = true:
	set(value):
		is_knocked = value
		if value == false:
			player_anim.play("idle")

var ignore_gravity : bool = false
const KNOCK_FORCE = Vector2(300,-200)
const COYOTE_TIME = 0.3
const LOOK_DOWN_TIME = 0.8
const CHECKPOINT_TIME = 0.8
var waiting_anim : bool = false
var is_looking_down : bool = false
var last_check_point_position : Vector2
@export var player_anim : AnimatedSprite2D

@export_enum("level_1","level_2","level_3","level_4") var start_location = "level_1"

@export var level_1_marker : Marker2D

@export var level_2_marker : Marker2D

@export var level_3_marker : Marker2D

@export var level_4_marker : Marker2D

@export var coyote_timer : Timer

@export var look_down_timer : Timer

@export var checkpoint_timer : Timer

@export var collision_shape : CollisionShape2D

@export var checkpoint_progress : TextureProgressBar

func _ready() -> void:
	player_anim.animation_changed.connect(func(): player_anim.play())
	set_initial_location()
	checkpoint_progress.max_value = CHECKPOINT_TIME
	
func _physics_process(delta: float) -> void:
	move_and_slide()
	apply_gravity(delta)
	movement_methods(delta)
	manage_animations()
	manage_coyote_timer()
	look_down()
	go_to_checkpoint()

func set_new_checkpoint(checkpoint : Vector2) -> void:
	if checkpoint.y < last_check_point_position.y:
		last_check_point_position = checkpoint

func go_to_checkpoint() -> void:
	if Input.is_action_pressed("go_to_checkpoint") and !GameManager.sliding_mode_on and !is_knocked:
		if Input.is_action_just_pressed("go_to_checkpoint"):
			checkpoint_timer.start(CHECKPOINT_TIME)
			checkpoint_progress.show()
	if Input.is_action_just_released("go_to_checkpoint") and checkpoint_timer.time_left != 0:
		checkpoint_timer.stop()
		checkpoint_progress.hide()
		return
		
	await checkpoint_timer.timeout
	if is_knocked == false:
		checkpoint_progress.hide()
		collision_shape.disabled = true
		is_knocked = true
		var tween =  create_tween()
		tween.tween_property(self,"global_position",last_check_point_position,0.5)
		await tween.finished
		is_knocked = false
		collision_shape.disabled = false

func movement_methods(_delta:float) -> void:
	if not GameManager.sliding_mode_on and not is_knocked:
		move()
		jump()
		flip_sprite()

func manage_animations() -> void:
	if is_knocked or waiting_anim:
		return
		
	if is_on_floor() and velocity == Vector2.ZERO:
		if player_anim.animation == "jump_down":
			player_anim.animation = "land"
			waiting_anim = true
			await  get_tree().create_timer(0.1,false).timeout
			waiting_anim = false
			
		player_anim.animation = "idle"
		
	elif is_on_floor() and velocity != Vector2.ZERO:
		if player_anim.animation == "jump_down":
			player_anim.animation = "land"
			waiting_anim = true
			await  get_tree().create_timer(0.1,false).timeout
			waiting_anim = false
		player_anim.animation = "walk"
		
	elif not is_on_floor() and velocity.y < 0:
		player_anim.animation = "jump_up"
		
	elif not is_on_floor() and velocity.y >= 0:
		player_anim.animation = "jump_down"
	
func get_knocked(enemy : KnockbackEnemy) -> void:
		is_knocked = true
		player_anim.play("hurt")
		AudioManager.play_knockback()
		if enemy.global_position.x > global_position.x:
			velocity.x = -KNOCK_FORCE.x
			
		else:
			velocity.x = KNOCK_FORCE.x
			
		await get_tree().create_timer(0.5,false).timeout
		create_tween().tween_property(self,"velocity:x",0,0.3)
		is_knocked = false

func apply_gravity(delta:float) -> void:
	if !is_on_floor() and !ignore_gravity:
		if velocity.y >= 0:
			velocity.y += 2*gravity*delta
		else:
			velocity.y += gravity*delta

func move() -> void:
	var direction = Input.get_axis("ui_left","ui_right")
	velocity.x = direction*speed

func jump() -> void:
	if Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("ui_up"):
		if is_on_floor() or is_coyote_time:
			velocity.y = -jump_force
			AudioManager.play_jump()
			is_coyote_time = false
			
		if is_looking_down:
			offset_main_camera(Vector2.ZERO)
			is_looking_down = false

func look_down() -> void:
	if Input.is_action_pressed("ui_down") and (
		!GameManager.sliding_mode_on) and (
		!is_looking_down) and (
		global_position.y < level_1_marker.global_position.y-100) and (
		!is_knocked):
		
		if Input.is_action_just_pressed("ui_down"):
			look_down_timer.start(LOOK_DOWN_TIME)
			if  not look_down_timer.timeout.is_connected(offset_main_camera.bind(Vector2(0,100))):
				look_down_timer.timeout.connect(offset_main_camera.bind(Vector2(0,100)),4)
				look_down_timer.timeout.connect(func():is_looking_down = true,4)
			
	if Input.is_action_just_released("ui_down"):
		look_down_timer.stop()
		return
		
		
	elif Input.is_action_pressed("ui_up") and !GameManager.sliding_mode_on and is_looking_down:
		offset_main_camera(Vector2.ZERO)
		is_looking_down = false
		
func offset_main_camera(cam_offset : Vector2) -> void:
	var tween = create_tween()
	tween.tween_property(get_viewport().get_camera_2d(),"offset",cam_offset,0.5)

func set_initial_location() -> void:
	if not OS.has_feature("editor"):
		global_position = level_1_marker.global_position
	
	elif start_location == "level_2":
		global_position = level_2_marker.global_position
	elif start_location == "level_3":
		global_position = level_3_marker.global_position
	elif start_location == "level_4":
		global_position = level_4_marker.global_position
	else:
		global_position = level_1_marker.global_position
	
	last_check_point_position = global_position
	
func flip_sprite() -> void:
	if velocity.x == 0:
		return
		
	if velocity.x > 0:
		player_anim.flip_h = false
		
	elif velocity.x < 0:
		player_anim.flip_h = true

func manage_coyote_timer() -> void:
	if is_on_floor():
		is_coyote_time = true
	if Input.is_action_just_pressed("ui_accept"):
		is_coyote_time = false
	if !is_on_floor() and coyote_timer.time_left == 0:
		coyote_timer.start(COYOTE_TIME)

func _on_coyote_timer_timeout() -> void:
	is_coyote_time = false

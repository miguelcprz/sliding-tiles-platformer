class_name KnockbackEnemy extends CharacterBody2D

@export var patrol_speed = 20
@export var right_raycast : RayCast2D
@export var left_raycast : RayCast2D
@export var right_enemy_ray : RayCast2D
@export var left_enemy_ray : RayCast2D
@export var player_detect_area : Area2D
@onready var hurt_area: Area2D = $HurtArea
@onready var enemy_anim: AnimatedSprite2D = $EnemyAnim
@onready var knocked_progress: TextureProgressBar = $KnockedProgress
const KNOCK_TIME = 2.5
var is_knocked : bool = false

func _ready() -> void:
	knocked_progress.max_value = KNOCK_TIME
	knocked_progress.value = KNOCK_TIME
	velocity = Vector2.RIGHT*patrol_speed
	player_detect_area.body_entered.connect(knock_back)
	hurt_area.body_entered.connect(get_knocked)
	ready.connect(left_raycast.force_raycast_update)
	ready.connect(right_raycast.force_raycast_update)
	
func _physics_process(delta: float) -> void:
	if not is_knocked:
		move_and_slide()
		turn_around()
	
	elif is_knocked:
		knocked_progress.value -= delta

func knock_back(body) -> void:
	if body is Player and not is_knocked:
		body.get_knocked(self)

func turn_around() -> void:
	if not right_raycast.is_colliding() or right_enemy_ray.is_colliding():
		velocity = Vector2.LEFT*patrol_speed
		enemy_anim.flip_h = false
	
	elif not left_raycast.is_colliding() or left_enemy_ray.is_colliding():
		velocity = Vector2.RIGHT*patrol_speed
		enemy_anim.flip_h = true

func get_knocked(body) -> void:
	if body is Player:
		body.velocity.y = -body.jump_force
		AudioManager.play_jump()
	
	if not is_knocked:
		is_knocked = true
		knocked_progress.value = KNOCK_TIME
		knocked_progress.show()
		enemy_anim.play("knocked")
		await get_tree().create_timer(KNOCK_TIME,false).timeout
		is_knocked = false
		knocked_progress.hide()
		enemy_anim.play("default")
		if player_detect_area.has_overlapping_bodies():
			knock_back(player_detect_area.get_overlapping_bodies()[0])

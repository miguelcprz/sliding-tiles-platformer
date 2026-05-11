@tool
class_name MovingPlatform extends AnimatableBody2D

@export var right_displacement_ray : RayCast2D
@export var top_displacement_ray : RayCast2D
@export var collision : CollisionShape2D

@export var show_motion_in_editor : bool = false

@export var horizontal_speed : float
@export var vertical_speed : float
@export var vertical_displacement : float
@export var horizontal_displacement : float

@export var horizontal : bool = false
@export var vertical : bool = false

var is_moving_horizontal : bool = false
var is_moving_vertical : bool = false

var initial_position : Vector2

func _ready() -> void:
	initial_position = global_position
	sync_to_physics = false

func _physics_process(_delta: float) -> void:
	show_predicted_displacement()
	if not Engine.is_editor_hint() or show_motion_in_editor:
		move_horizontal()
		move_vertical()
	

func move_horizontal() -> void:
	if is_moving_horizontal or horizontal == false:
		return
	
	is_moving_horizontal = true
	var final_pos_x : float
	if global_position.x < initial_position.x + horizontal_displacement:
		final_pos_x = initial_position.x + horizontal_displacement
	else:
		final_pos_x = initial_position.x
	
	var tween = create_tween()
	tween.tween_property(self,"global_position:x",final_pos_x,1/horizontal_speed)
	await tween.finished
	set_deferred("is_moving_horizontal",false)

func move_vertical() -> void:
	if is_moving_vertical or vertical == false:
		return
	
	is_moving_vertical = true
	var final_pos_y : float
	if global_position.y > initial_position.y - vertical_displacement:
		final_pos_y = initial_position.y - vertical_displacement
	else:
		final_pos_y = initial_position.y
	
	var tween = create_tween()
	tween.tween_property(self,"global_position:y",final_pos_y,1/vertical_speed)
	await tween.finished
	set_deferred("is_moving_vertical",false)

func show_predicted_displacement() -> void:
	if Engine.is_editor_hint():
		show_right_displacement()
		show_top_displacement()

func show_right_displacement() -> void:
	if right_displacement_ray and collision:
		right_displacement_ray.position.x = collision.shape.size.x/2
		right_displacement_ray.target_position = Vector2(horizontal_displacement,0)

func show_top_displacement() -> void:
	if top_displacement_ray and collision:
		top_displacement_ray.position.y = - collision.shape.size.y/2
		top_displacement_ray.target_position = Vector2(0,-vertical_displacement)

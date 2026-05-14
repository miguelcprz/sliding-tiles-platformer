class_name StageChangeDoor extends Area2D

@export var final_pos_marker : Marker2D
@export var cut_cam : CutSceneCamera
@export var door_sprite : AnimatedSprite2D
@export var is_opened : bool = true

func _ready() -> void:
	set_collision_mask_value(3,true)
	set_collision_mask_value(1,false)
	body_entered.connect(teleport_player)

func teleport_player(body) -> void:
	if body is Player and is_opened:
		cut_cam.call_deferred("play_teleport_cutscene",final_pos_marker)

func _process(_delta: float) -> void:
	if door_sprite:
		manage_door_sprite()
	
	
func manage_door_sprite():
	if is_opened == true:
		door_sprite.play("opened")
	else:
		door_sprite.play("closed")
	pass

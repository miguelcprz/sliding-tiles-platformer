class_name StageChangeDoor extends Area2D

@export var final_pos_marker : Marker2D
@export var cut_cam : CutSceneCamera

func _ready() -> void:
	set_collision_mask_value(3,true)
	set_collision_mask_value(1,false)
	body_entered.connect(teleport_player)

func teleport_player(body) -> void:
	if body is Player:
		cut_cam.call_deferred("play_teleport_cutscene",final_pos_marker)

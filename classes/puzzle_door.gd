class_name PuzzleDoor extends Area2D

@export var exit_marker : Marker2D
@export var this_door_portrait : DoorPortrait

func _ready() -> void:
	monitoring = false
	set_collision_layer_value(1,false)
	set_collision_mask_value(1,false)
	set_collision_mask_value(3,true)
	this_door_portrait.opened.connect(open_door)
	body_entered.connect(teleport)

func open_door() -> void:
	if this_door_portrait.is_opened:
		monitoring = true

func teleport(body) -> void:
	if body is Player:
		call_deferred("change_player_position",body)
		
func change_player_position(player : Player) -> void:
	player.is_knocked = true
	player.hide()
	var tween = create_tween()
	tween.tween_property(player,"global_position",exit_marker.global_position,1.0)
	await tween.finished
	player.is_knocked = false
	player.show()
	
	
	
	

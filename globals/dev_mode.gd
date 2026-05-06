extends Node

var gravity := 750:
	set(value):
		gravity = value
		set_player_gravity(value)

var speed := 180:
	set(value):
		speed = value
		set_player_speed(value)

var jump_force := 310:
	set(value):
		jump_force = value
		set_player_jump_force(value)

var player : Player

func set_player_gravity(value : int) -> void:
	player = get_tree().get_first_node_in_group("player")
	if player:
		player.gravity = value

func set_player_speed(value : int) -> void:
	player = get_tree().get_first_node_in_group("player")
	if player:
		player.speed = value

func set_player_jump_force(value : int) -> void:
	player = get_tree().get_first_node_in_group("player")
	if player:
		player.jump_force = value

class_name CheckpointArea extends Area2D
@export var checkpoint_flower : Sprite2D

func _ready() -> void:
	body_entered.connect(set_player_checkpoint)

func set_player_checkpoint(player : Node2D) ->  void:
	if player is Player and player.last_check_point_position.y > global_position.y:
		player.set_new_checkpoint(global_position)
		var tween = create_tween()
		tween.tween_property(checkpoint_flower,"scale",Vector2(1,1),0.6)

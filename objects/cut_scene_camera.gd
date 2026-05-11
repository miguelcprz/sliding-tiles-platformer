class_name CutSceneCamera extends Camera2D
@export var main_camera : Camera2D
@export var top_block : ColorRect
@export var bottom_block : ColorRect
@export var player : Player

func _ready() -> void:
	await get_tree().create_timer(2.0,false).timeout
	var tween = create_tween()
	tween.tween_property(self,"global_position",main_camera.global_position,12.0).set_trans(Tween.TRANS_CUBIC)
	await tween.finished
	tween = create_tween().set_parallel()
	tween.tween_property(top_block,"position:y",-top_block.size.y,1.0).set_ease(Tween.EASE_OUT)
	tween.tween_property(bottom_block,"position:y",360,1.0).set_ease(Tween.EASE_OUT)
	await tween.finished
	player.is_knocked = false
	main_camera.enabled = true
	main_camera.make_current()


func play_teleport_cutscene(final_pos_marker : Marker2D) -> void:
	player.is_knocked = true
	player.velocity = Vector2.ZERO
	player.ignore_gravity = true
	var tween = create_tween().set_parallel()
	tween.tween_property(player,"modulate",Color.TRANSPARENT,1.0)
	tween.tween_property(top_block,"position:y",0,1.0).set_ease(Tween.EASE_OUT)
	tween.tween_property(bottom_block,"position:y",300,1.0).set_ease(Tween.EASE_OUT)
	await tween.finished
	
	tween = create_tween().set_parallel()
	tween.tween_property(player,"global_position",final_pos_marker.global_position,5.0).set_trans(Tween.TRANS_CUBIC)
	await tween.finished

	tween = create_tween().set_parallel()
	tween.tween_property(player,"modulate",Color.WHITE,1.0)
	tween.tween_property(top_block,"position:y",-top_block.size.y,1.0).set_ease(Tween.EASE_OUT)
	tween.tween_property(bottom_block,"position:y",360,1.0).set_ease(Tween.EASE_OUT)
	await tween.finished
	player.is_knocked = false
	player.ignore_gravity = false

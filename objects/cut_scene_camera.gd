extends Camera2D
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

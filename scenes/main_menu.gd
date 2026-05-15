extends Node2D
@onready var black_out: ColorRect = $BlackOut
@export var menu_tiles : Array[MainMenuButton]

func start_game() -> void:
	black_out.focus_mode = Control.FOCUS_ALL
	black_out.grab_focus()
	black_out.mouse_filter = Control.MOUSE_FILTER_STOP
	AudioManager.switch_song(1)
	var tween = create_tween()
	tween.tween_property(black_out,"modulate",Color.WHITE,3.0)
	await tween.finished
	
	get_tree().paused = false
	get_tree().call_deferred("change_scene_to_file","res://scenes/world.tscn")

func update_all_buttons() -> void:
	for tile in menu_tiles:
		tile.update_neighbors()

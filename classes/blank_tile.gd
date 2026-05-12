class_name BlankTile extends SlidingTile


func _ready() -> void:
	is_locked = true
	this_portrait.sliding_mode_changed.connect(change_focus_mode)
	focus_entered.connect(set_focus_frame_color_and_visibility)
	focus_entered.connect(this_portrait.set_current_tile.bind(self))
	focus_exited.connect(set_focus_frame_color_and_visibility)
		
	position_raycasts = [
		right_raycast,
		blank_right_raycast,
		left_raycast,
		blank_left_raycast,
		top_raycast,
		blank_top_raycast,
		bottom_raycast,
		blank_bottom_raycast,
	]
	
	update_neighbors()

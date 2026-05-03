class_name SlidingTile extends TextureRect

const TILE_SIZE = Vector2i(32,32)

@export var grab_initial_focus : bool
##The portrait which this tile is in.
@export var this_portrait : Portrait
##Represents this tile correct position in the [Portrait] grid.
@export var correct_position : Vector2i
##Represents this tile initial position in the [Portrait] grid.
@export var initial_position : Vector2i

##Identifies the tile's [member neighbor_right].
@export var right_raycast : RayCast2D
##Identifies the tile's [member neighbor_left].
@export var left_raycast : RayCast2D
##Identifies the tile's [member neighbor_top].
@export var top_raycast : RayCast2D
##Identifies the tile's [member neighbor_bottom].
@export var bottom_raycast : RayCast2D

@export var tile_focus_frame : Sprite2D

var position_raycasts : Array[RayCast2D]

##if this is [code]false[/code] this tile can't be moved by the player.
@export var is_locked : bool

@export var player_detector_area : Area2D

##Emiited when [member is_active] is changed to [code]true[/code]. it sends itself
## as an argument.
signal tile_selected
##Emiited when [member is_active] is changed to [code]false[/code]. it sends itself
## as an argument.
signal tile_unselected

##if [code]true[/code], this is the tile being moved by the player.
var is_active : bool = false:
	set(value):
		is_active = value
		set_focus_frame_color_and_visibility()
		if value == true:
			tile_selected.emit(self)
			focus_neighbor_bottom = self.get_path()
			focus_neighbor_top = self.get_path()
			focus_neighbor_left = self.get_path()
			focus_neighbor_right = self.get_path()
			
		elif value == false:
			tile_unselected.emit(self)
			this_portrait.update_tiles_neighbors()

func _ready() -> void:
	player_detector_area.body_entered.connect(lock_block)
	player_detector_area.body_exited.connect(unlock_block)
	GameManager.sliding_mode_changed.connect(change_focus_mode)
	focus_entered.connect(set_focus_frame_color_and_visibility)
	focus_entered.connect(this_portrait.set_current_tile.bind(self))
	focus_exited.connect(set_focus_frame_color_and_visibility)
	if grab_initial_focus == true:
		grab_focus()
		
	position_raycasts = [
		right_raycast,
		left_raycast,
		top_raycast,
		bottom_raycast
	]
	
	update_neighbors()

func move_right() -> void:
	if not right_raycast.is_colliding():
		var tween = create_tween()
		tween.tween_property(self,"position:x",position.x + TILE_SIZE.x,0.3).set_trans(Tween.TRANS_QUART)

func move_left() -> void:
	if not left_raycast.is_colliding():
		var tween = create_tween()
		tween.tween_property(self,"position:x",position.x - TILE_SIZE.x,0.3).set_trans(Tween.TRANS_QUART)

func move_top() -> void:
	if not top_raycast.is_colliding():
		var tween = create_tween()
		tween.tween_property(self,"position:y",position.y - TILE_SIZE.y,0.3).set_trans(Tween.TRANS_QUART)

func move_bottom() -> void:
	if not bottom_raycast.is_colliding():
		var tween = create_tween()
		tween.tween_property(self,"position:y",position.y + TILE_SIZE.y,0.3).set_trans(Tween.TRANS_QUART)

func _input(event: InputEvent) -> void:
	if is_active and GameManager.sliding_mode_on:
		if event.is_action_pressed("ui_right"):
			move_right()
	
		elif event.is_action_pressed("ui_left"):
			move_left()
	
		elif event.is_action_pressed("ui_up"):
			move_top()
	
		elif event.is_action_pressed("ui_down"):
			move_bottom()
	
		elif event.is_action_pressed("ui_accept"):
			is_active = false
			print("is active false")
	
	elif has_focus() and !is_active and !is_locked and GameManager.sliding_mode_on and event.is_action_pressed("ui_accept"):
		is_active = true


func update_right_neighbor() -> void:
	if right_raycast.is_colliding():
		var neighbor_tile = right_raycast.get_collider()
		if neighbor_tile.get_parent() is SlidingTile:
			focus_neighbor_right = neighbor_tile.get_parent().get_path()
		else:
			focus_neighbor_right = self.get_path()
	else:
		focus_neighbor_right = self.get_path()
	
func update_left_neighbor() -> void:
	if left_raycast.is_colliding():
		var neighbor_tile = left_raycast.get_collider()
		if neighbor_tile.get_parent() is SlidingTile:
			focus_neighbor_left = neighbor_tile.get_parent().get_path()
		else:
			focus_neighbor_left = self.get_path()
	else:
		focus_neighbor_left = self.get_path()

func update_top_neighbor() -> void:
	if top_raycast.is_colliding():
		var neighbor_tile = top_raycast.get_collider()
		if neighbor_tile.get_parent() is SlidingTile:
			focus_neighbor_top = neighbor_tile.get_parent().get_path()
		else:
			focus_neighbor_top = self.get_path()
	else:
		focus_neighbor_top = self.get_path()

func update_bottom_neighbor() -> void:
	if bottom_raycast.is_colliding():
		var neighbor_tile = bottom_raycast.get_collider()
		if neighbor_tile.get_parent() is SlidingTile:
			focus_neighbor_bottom = neighbor_tile.get_parent().get_path()
		else:
			focus_neighbor_bottom = self.get_path()
	else:
		focus_neighbor_bottom = self.get_path()

func update_neighbors() -> void:
	for ray:RayCast2D in position_raycasts:
		ray.force_raycast_update()
	
	update_bottom_neighbor()
	update_left_neighbor()
	update_right_neighbor()
	update_top_neighbor()

func change_focus_mode(sliding_mode_on : bool) -> void:
	is_active = false
	if sliding_mode_on == false:
		focus_mode = Control.FOCUS_NONE

	elif sliding_mode_on == true:
		focus_mode = Control.FOCUS_ALL

func set_focus_frame_color_and_visibility() -> void:
	if not has_focus():
		tile_focus_frame.hide()
	
	elif is_locked:
		tile_focus_frame.show()
		tile_focus_frame.modulate = Color.RED
	
	elif has_focus() and is_active:
		tile_focus_frame.show()
		tile_focus_frame.modulate = Color.GREEN
		
	elif has_focus():
		tile_focus_frame.show()
		tile_focus_frame.modulate = Color.WHITE

func lock_block(_body) -> void:
	is_locked = true

func unlock_block(_body) -> void:
	is_locked = false

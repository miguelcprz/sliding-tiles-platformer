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

var position_raycasts : Array[RayCast2D]

##if this is [code]false[/code] this tile can't be moved by the player.
var is_locked : bool = false

##if [code]true[/code], this is the tile being moved by the player.
var is_active : bool = false:
	set(value):
		if value == true:
			focus_neighbor_bottom = self.get_path()
			focus_neighbor_top = self.get_path()
			focus_neighbor_left = self.get_path()
			focus_neighbor_right = self.get_path()
			
		elif value == false:
			update_neighbors()

func _ready() -> void:
	ready.connect(update_neighbors)
	focus_entered.connect(show_focus)
	focus_exited.connect(show_focus)
	
	if grab_initial_focus == true:
		grab_focus()
		
	position_raycasts = [
		right_raycast,
		left_raycast,
		top_raycast,
		bottom_raycast
	]
	
	

func show_focus() -> void:
	if has_focus():
		modulate = Color.GREEN
	else:
		modulate = Color.WHITE

func move_right() -> void:
	if not right_raycast.is_colliding():
		var tween = create_tween()
		tween.tween_property(self,"position:x",position.x + TILE_SIZE.x,0.3).set_trans(Tween.TRANS_QUART)

func move_left() -> void:
	if not right_raycast.is_colliding():
		var tween = create_tween()
		tween.tween_property(self,"position:x",position.x - TILE_SIZE.x,0.3).set_trans(Tween.TRANS_QUART)

func move_top() -> void:
	if not right_raycast.is_colliding():
		var tween = create_tween()
		tween.tween_property(self,"position:y",position.y - TILE_SIZE.y,0.3).set_trans(Tween.TRANS_QUART)

func move_bottom() -> void:
	if not right_raycast.is_colliding():
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
	
	elif has_focus() and !is_active and GameManager.sliding_mode_on and event.is_action_pressed("ui_accept"):
		is_active = true

func update_right_neighbor() -> void:
	if right_raycast.is_colliding():
		var neighbor_tile = right_raycast.get_collider().get_parent() as SlidingTile
		focus_neighbor_right = neighbor_tile.get_path()
		
	else:
		focus_neighbor_right = self.get_path()
	
func update_left_neighbor() -> void:
	if left_raycast.is_colliding():
		var neighbor_tile = left_raycast.get_collider().get_parent() as SlidingTile
		focus_neighbor_left = neighbor_tile.get_path()
		
	else:
		focus_neighbor_left = self.get_path()

func update_top_neighbor() -> void:
	if top_raycast.is_colliding():
		var neighbor_tile = top_raycast.get_collider().get_parent() as SlidingTile
		focus_neighbor_top = neighbor_tile.get_path()
		
	else:
		focus_neighbor_top = self.get_path()

func update_bottom_neighbor() -> void:
	if bottom_raycast.is_colliding():
		var neighbor_tile = bottom_raycast.get_collider().get_parent() as SlidingTile
		focus_neighbor_bottom = neighbor_tile.get_path()
		
	else:
		focus_neighbor_bottom = self.get_path()

func update_neighbors() -> void:
	update_bottom_neighbor()
	update_left_neighbor()
	update_right_neighbor()
	update_top_neighbor()

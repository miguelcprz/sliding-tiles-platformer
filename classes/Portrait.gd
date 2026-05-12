class_name Portrait extends Node2D

@export var tiles : Array[SlidingTile]
@export var blank_tiles : Array[BlankTile]
var all_tiles : Array
@export var portrait_center : Vector2
var current_tile : SlidingTile
##If [code]true[/code], this portrait [SlidingTile]s can be moved.
var sliding_mode_on : bool = false:
	set(value):
		sliding_mode_on = value
		GameManager.sliding_mode_on = value
		var cam = get_viewport().get_camera_2d()
		var tween = create_tween()
		if value == true:
			tween.tween_property(cam,"offset",self.portrait_center + global_position - cam.global_position,0.5)
		elif value == false:
			tween.tween_property(cam,"offset",Vector2.ZERO,0.5)
		sliding_mode_changed.emit(value)

signal sliding_mode_changed
func _ready() -> void:
	all_tiles.append_array(tiles)
	all_tiles.append_array(blank_tiles)
	sliding_mode_changed.connect(give_focus_to_current_tile)
	update_tiles_neighbors()
	shuffle_tiles()
	for tile in tiles:
		if tile.grab_initial_focus:
			current_tile = tile

func update_tiles_neighbors() -> void:
	for tile in all_tiles:
		tile.update_neighbors()

func set_current_tile(tile : SlidingTile) -> void:
	current_tile = tile

func give_focus_to_current_tile(sliding_on : bool) -> void:
	if sliding_on == true and current_tile:
		current_tile.grab_focus()


func shuffle_tiles() -> void:
	var tiles_initial_positions : Array [Vector2]
	
	for tile in tiles:
		tiles_initial_positions.append(tile.position)
	
	tiles_initial_positions.shuffle()
	
	for tile_idx in tiles.size():
		tiles[tile_idx].position = tiles_initial_positions[tile_idx]
	

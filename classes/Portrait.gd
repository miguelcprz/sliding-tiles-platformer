class_name Portrait extends Node2D

@export var tiles : Array[SlidingTile]

var current_tile : SlidingTile

##If [code]true[/code], this portrait [SlidingTile]s can be moved.
var sliding_mode_on : bool = false:
	set(value):
		sliding_mode_on = value
		GameManager.sliding_mode_on = value
		sliding_mode_changed.emit(value)

signal sliding_mode_changed
func _ready() -> void:
	sliding_mode_changed.connect(give_focus_to_current_tile)
	shuffle_tiles()
	for tile in tiles:
		if tile.grab_initial_focus:
			current_tile = tile

func update_tiles_neighbors() -> void:
	for tile in tiles:
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
	
	call_deferred("update_tiles_neighbors")

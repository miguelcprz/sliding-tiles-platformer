class_name Portrait extends Node2D

@export var tiles : Array[SlidingTile]

var current_tile : SlidingTile

func _ready() -> void:
	GameManager.sliding_mode_changed.connect(give_focus_to_current_tile)

func update_tiles_neighbors() -> void:
	for tile in tiles:
		tile.update_neighbors()

func set_current_tile(tile : SlidingTile) -> void:
	current_tile = tile

func give_focus_to_current_tile(sliding_on : bool) -> void:
	if sliding_on == true and current_tile:
		current_tile.grab_focus()

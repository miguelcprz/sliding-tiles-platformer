class_name DoorPortrait extends Portrait

var correct_positions : Array[Vector2]
var player : Player
const DOOR_OPENED_ATLAS = preload("uid://2vfisg8we28c")
const DOOR_LOCKED_ATLAS = preload("uid://bgp7kea6sm6dv")
var is_opened : bool = false:
	set(value):
		is_opened = value
		if value == true:
			opened.emit()

signal opened

func _ready() -> void:
	all_tiles.append_array(tiles)
	all_tiles.append_array(blank_tiles)
	sliding_mode_changed.connect(give_focus_to_current_tile)
	shuffle_tiles()
	update_tiles_neighbors()

	for tile in tiles:
		if tile.grab_initial_focus:
			current_tile = tile
	
	
func shuffle_tiles() -> void:
	add_locked_door_textures()
	connect_tiles_to_open_door()
	for tile in tiles:
		correct_positions.append(tile.position)
	
	var tiles_initial_positions : Array [Vector2]
	
	for tile in tiles:
		tiles_initial_positions.append(tile.position)
	
	tiles_initial_positions.shuffle()
	
	for tile_idx in tiles.size():
		tiles[tile_idx].position = tiles_initial_positions[tile_idx]

func add_locked_door_textures() -> void:
	for idx in tiles.size():
		var atlas_texture := AtlasTexture.new()
		atlas_texture.atlas = DOOR_LOCKED_ATLAS
		tiles[idx].texture = atlas_texture
		tiles[idx].texture.region = Rect2(tiles[idx].position,tiles[idx].size)

func connect_tiles_to_open_door() -> void:
	for tile in tiles:
		tile.moved.connect(try_open_door)

func try_open_door() -> void:

	for idx in tiles.size():
		if tiles[idx].position != correct_positions[idx]:
			return
	
	for tile in tiles:
		tile.texture.atlas = DOOR_OPENED_ATLAS
		is_opened = true
		AudioManager.play_door_open()

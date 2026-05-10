class_name DoorPortrait extends Portrait

var correct_positions : Array[Vector2]
var player : Player
const DOOR_OPENED_ATLAS = preload("uid://2vfisg8we28c")
const DOOR_LOCKED_ATLAS = preload("uid://bgp7kea6sm6dv")
var is_opened : bool = false

func shuffle_tiles() -> void:
	add_locked_door_textures()
	connect_tiles_to_open_door()
	for tile in tiles:
		correct_positions.append(tile.position)

	var shuffled_positions := correct_positions.duplicate()
	shuffled_positions.shuffle()
	
	for idx in tiles.size():
		tiles[idx].position = shuffled_positions[idx]

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

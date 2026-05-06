@tool
class_name SliderTileMap extends TileMapLayer

##The area that can be drawn.
@export var layer_limits : Rect2i = Rect2i(Vector2i.ZERO,Vector2i(3,3))

func _update_cells(_coords: Array[Vector2i], _forced_cleanup: bool) -> void:
	for cell_pos in get_used_cells():
		if not layer_limits.has_point(cell_pos):
			erase_cell(cell_pos)

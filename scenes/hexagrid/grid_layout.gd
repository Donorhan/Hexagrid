extends Resource
class_name GridLayout

const LAYOUT_POINTY : Array = [
	sqrt(3.0), sqrt(3.0) / 2.0, 0.0, 3.0 / 2.0,
	sqrt(3.0) / 3.0, -1.0 / 3.0, 0.0, 2.0 / 3.0,
	0.5
]

const LAYOUT_FLAT : Array = [
	3.0 / 2.0, 0.0, sqrt(3.0) / 2.0, sqrt(3.0),
	2.0 / 3.0, 0.0, -1.0 / 3.0, sqrt(3.0) / 3.0,
	0.0
]

const Cell = preload("./grid_cell.gd")

var orientation : Array = LAYOUT_POINTY
export var origin : Vector2 = Vector2.ZERO
export var cell_size : Vector2 = Vector2(32, 32)
export var use_pointy_cell : bool = true setget pointy_cell, is_using_point_cell

func pointy_cell(value : bool) -> void:
	use_pointy_cell = value
	orientation = LAYOUT_POINTY if value else LAYOUT_FLAT

func is_using_point_cell(): 
	return use_pointy_cell

func cell_to_pixel(cell : Vector3) -> Vector2:
	var x : float = (orientation[0] * cell.x + orientation[1] * cell.z) * cell_size.x
	var y : float = (orientation[2] * cell.x + orientation[3] * cell.z) * cell_size.y

	return Vector2(x + origin.x, y + origin.y)

func cells_to_pixels(cells : PoolVector3Array) -> PoolVector2Array:
	var positions = PoolVector2Array()
	for i in cells:
		positions.push_back(cell_to_pixel(i))

	return positions

func pixel_to_cell(position : Vector2) -> Vector3:
	var pt = Vector2(
		(position.x - origin.x) / cell_size.x,
		(position.y - origin.y) / cell_size.y
	)

	var q = orientation[4] * pt.x + orientation[5] * pt.y;
	var r = orientation[6] * pt.x + orientation[7] * pt.y;

	return Cell.round_cell(Vector3(q, -q - r, r))

func pixels_to_cells(positions : PoolVector2Array) -> PoolVector3Array:
	var cells = PoolVector2Array()
	for i in positions:
		cells.push_back(pixel_to_cell(i))

	return cells

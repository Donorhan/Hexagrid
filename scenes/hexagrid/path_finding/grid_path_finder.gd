extends Node2D
class_name HexaGridPathFinder, "res://scenes/hexagrid/path_finding/icon_grid_path_finder.png"

const Cell = preload("../grid_cell.gd")

export (NodePath) var grid_path : NodePath

onready var astar : AStar2D = AStar2D.new()
onready var grid : HexaGrid = get_node(grid_path)

var cells_ids_path_ids : Dictionary = {}
var current_id : int = 0

func generate_path_finding() -> void:
	astar.clear()
	cells_ids_path_ids = {}

	var used_cells = grid.cells.values()
	_add_points(used_cells)
	_connect_points(used_cells)

func _get_id(cell : Vector3) -> int:
	var cell_id = Cell.id(cell)
	if !cells_ids_path_ids.has(cell_id):
		current_id += 1
		cells_ids_path_ids[cell_id] = current_id

	return cells_ids_path_ids[cell_id]

func _add_points(cells) -> void:
	for cell in cells:
		astar.add_point(_get_id(cell), Cell.offset_from_cube(cell), 1.0)

func get_point_path(start : Vector3, end : Vector3) -> PoolVector3Array:
	var path = PoolVector3Array()
	if start == end:
		return path

	var start_cell_id = _get_id(start)
	var end_cell_id = _get_id(end)
	if !astar.has_point(start_cell_id) or !astar.has_point(end_cell_id):
		return path

	var astar_path = astar.get_point_path(start_cell_id, end_cell_id)
	if astar_path.size():
		astar_path.remove(0)

	for i in astar_path.size():
		path.push_back(Cell.offset_to_cube(astar_path[i]))

	return path

func _connect_points(cells) -> void:
	var directions : Array = Cell.DIRECTIONS
	for cell in cells:
		var cell_id = _get_id(cell)
		for direction in directions:
			var neighbor = cell + direction
			if cells.has(neighbor):
				astar.connect_points(cell_id, _get_id(neighbor), false)

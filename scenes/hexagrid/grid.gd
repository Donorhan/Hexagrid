extends Node2D
class_name HexaGrid, "res://scenes/hexagrid/icon_grid.png"

var Cell = preload("./grid_cell.gd")

signal cell_added(cell)
signal cell_removed(cell)

var cells : Dictionary = {}
export(Resource) var layout

func add_cell(cell : Vector3) -> void:
	cells[Cell.id(cell)] = cell
	emit_signal("cell_added", cell)

func add_cells(p_cells : PoolVector3Array) -> void:
	for cell in p_cells:
		add_cell(cell)

func all_within(cell : Vector3, distance : int, add_cells_outside : bool = false) -> PoolVector3Array:
	var cells_within = Cell.all_within(cell, distance)
	if add_cells_outside:
		return cells_within

	return remove_cells_outside(cells_within)

func cells_from_vectors(cell : Vector3, vectors : Array, add_cells_outside : bool = false) -> PoolVector3Array:
	var cells_vectors = Cell.cells_from_vectors(cell, vectors)
	if add_cells_outside:
		return cells_vectors

	return remove_cells_outside(cells_vectors)

func move_cell(old_cell : Vector3, new_cell : Vector3) -> void:
	var old_cell_id : int = Cell.id(old_cell)
	var new_cell_id : int = Cell.id(new_cell)

	if (cells.has(new_cell_id) or !cells.has(old_cell_id)):
		return

	cells[new_cell_id] = cells[old_cell_id]
	cells.erase(old_cell_id)

func neighbors(cell : Vector3, add_cells_outside : bool = false) -> PoolVector3Array:
	return cells_from_vectors(cell, Cell.DIRECTIONS, add_cells_outside)

func neighbors_diagonal(cell : Vector3, add_cells_outside : bool = false) -> PoolVector3Array:
	return cells_from_vectors(cell, Cell.DIAGONALS, add_cells_outside)

func remove_cell(cell : Vector3) -> bool:
	var removed : bool = cells.erase(Cell.id(cell))
	if removed:
		emit_signal("cell_removed", cell)

	return removed

func remove_cells(p_cells : PoolVector3Array) -> void:
	for cell in p_cells:
		remove_cell(cell)

func remove_cells_outside(p_cells : PoolVector3Array) -> PoolVector3Array:
	var copied_cells = PoolVector3Array()
	for i in p_cells:
		if cells.has(Cell.id(i)):
			copied_cells.push_back(i)

	return copied_cells

func ring(cell : Vector3, distance : int, add_cells_outside : bool = false) -> PoolVector3Array:
	var cells_ring = Cell.ring(cell, distance)
	if add_cells_outside:
		return cells_ring

	return remove_cells_outside(cells_ring)

func spiral(cell : Vector3, radius : int, add_cells_outside : bool = false) -> PoolVector3Array:
	var cells_spiral = Cell.spiral(cell, radius)
	if add_cells_outside:
		return cells_spiral

	return remove_cells_outside(cells_spiral)

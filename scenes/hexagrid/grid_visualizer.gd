extends Node2D
class_name HexaGridVisualizer, "res://scenes/hexagrid/icon_grid_visualizer.png"

const Cell = preload("./grid_cell.gd")

export (NodePath) var grid_path : NodePath
export var mouse_move_update : bool = true
export var cell_color : Color = Color(0.16, 0.62, 0.56)
export var active_cell_color : Color = Color(0.0, 0.47, 0.41)
export var show_cells_outside : bool = false
export var show_neighbors : bool = true
export var cell_neighbors_color : Color = Color(0.91, 0.77, 0.42)
export var show_neighbors_diagonal : bool = true
export var cell_neighbors_diagonal_color : Color = Color(0.96, 0.64, 0.38)
export var all_within : bool = false
export var all_within_color : Color = Color(0.91, 0.44, 0.32)
export var all_within_distance : int = 2
export var ring : bool = false
export var ring_color : Color = Color(0.91, 0.44, 0.32)
export var ring_distance : int = 2
export var spiral : bool = false
export var spiral_color : Color = Color(0.91, 0.44, 0.32)
export var spiral_distance : int = 2
export var show_custom_cells : bool = true
export var custom_cells_color : Color = Color(0.32, 0.91, 0.51)
export var line : bool = false
export var line_color : Color = Color(0.82, 0.70, 0.94)
export var text_color : Color = Color(1, 1, 1)

var active_cell : Vector3 = Vector3.ZERO
var custom_cells : Array = []
onready var defaultFont : Font = Control.new().get_font("font")
onready var grid : HexaGrid = get_node(grid_path)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and mouse_move_update:
		var hovered_cell = grid.layout.pixel_to_cell(get_global_mouse_position())
		active_cell = hovered_cell
		update()

func _draw() -> void:
	# draw all cells
	draw_cells(grid.cells.values(), cell_color, true)

	# draw the active cell as filled
	draw_cell(active_cell, active_cell_color, true)

	if show_neighbors:
		draw_cells(grid.neighbors(active_cell, show_cells_outside), cell_neighbors_color, true)

	if show_neighbors_diagonal:
		draw_cells(grid.neighbors_diagonal(active_cell, show_cells_outside), cell_neighbors_diagonal_color, true)

	if all_within:
		draw_cells(grid.all_within(active_cell, all_within_distance, show_cells_outside), all_within_color, true)

	if ring:
		draw_cells(grid.ring(active_cell, ring_distance, show_cells_outside), ring_color, true)

	if spiral:
		draw_cells(grid.spiral(active_cell, spiral_distance, show_cells_outside), spiral_color, true)

	if line:
		draw_cells(Cell.line(Vector3(0, 0, 0), active_cell), line_color, true)

	if show_custom_cells:
		draw_cells(custom_cells, custom_cells_color, true)

	var position = grid.layout.cell_to_pixel(active_cell)
	draw_string(defaultFont, position + Vector2(-30, 0), var2str(active_cell), text_color)
	draw_string(defaultFont, position + Vector2(-15, 30), var2str(Cell.axial_from_cube(active_cell)), text_color)

func draw_cell(cell : Vector3, color : Color, filled : bool = false) -> void:
	var points = cell_corners(cell)
	if filled:
		draw_polygon(points, [color], PoolVector2Array(), null, null, true)
	else:
		draw_polyline(points, color, 1, true)

func draw_cells(cells : Array, color : Color, filled : bool = false) -> void:
	for i in cells:
		draw_cell(i, color, filled)

func cell_corner_offset(corner : int) -> Vector2:
	var angle = 2.0 * PI * (grid.layout.orientation[8] + corner) / Cell.CORNER_COUNT

	return Vector2(grid.layout.cell_size.x * cos(angle), grid.layout.cell_size.y * sin(angle))

func cell_corners(cell : Vector3) -> Array:
	var corners = []
	var center = grid.layout.cell_to_pixel(cell)

	for i in range(Cell.CORNER_COUNT + 1):
		var offset = cell_corner_offset(i)
		corners.push_back(Vector2(center.x + offset.x,  center.y + offset.y))

	return corners

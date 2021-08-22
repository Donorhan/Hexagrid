extends Node2D

class_name Game

const GridShapeGenerator = preload("res://scenes/hexagrid/grid_shapes_generator.gd")

onready var grid : HexaGrid = $Grid
onready var grid_visualizer : HexaGridVisualizer = $GridVisualizer
onready var grid_path_finder : HexaGridPathFinder = $GridPathFinder

func _ready() -> void:
	var cells = GridShapeGenerator.hexagon(8)
	grid.add_cells(remove_random_cells(cells))
	grid_path_finder.generate_path_finding()
	
func remove_random_cells(cells : PoolVector3Array) -> PoolVector3Array:
	var rng = RandomNumberGenerator.new()
	var new_cells = PoolVector3Array()
	for i in cells:
		if rng.randf_range(0, 100) < 50 or i == Vector3.ZERO:
			new_cells.push_back(i)

	return new_cells

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton && event.button_index == BUTTON_LEFT and event.pressed:
		var clicked_cell = grid.layout.pixel_to_cell(get_global_mouse_position())
		grid_visualizer.custom_cells = grid_path_finder.get_point_path(Vector3(0, 0, 0), clicked_cell)
		grid_visualizer.update()

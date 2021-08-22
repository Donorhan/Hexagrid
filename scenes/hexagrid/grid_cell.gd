const CORNER_COUNT : int = 6

const DIRECTION_N = Vector3(0, 1, -1)
const DIRECTION_NE = Vector3(1, 0, -1)
const DIRECTION_SE = Vector3(1, -1, 0)
const DIRECTION_S = Vector3(0, -1, 1)
const DIRECTION_SW = Vector3(-1, 0, 1)
const DIRECTION_NW = Vector3(-1, 1, 0)

const DIRECTIONS : Array = [
	DIRECTION_N, DIRECTION_NE, 
	DIRECTION_SE, DIRECTION_S, 
	DIRECTION_SW, DIRECTION_NW
]

const DIAGONALS = [
	Vector3( 2, -1, -1), Vector3( 1,  1, -2), Vector3(-1,  2, -1), 
	Vector3(-2,  1,  1), Vector3(-1, -1,  2), Vector3( 1, -2,  1)
]

enum Direction { N = 0, NE = 1, SE = 2, S = 3, SW = 4, NW = 5 }

static func direction(direction : int) -> Vector3:
	assert(direction in Direction.values(), "the function argument is expected to be a Direction value")
	return DIRECTIONS[direction]


static func id(cell : Vector3) -> int:
	var hq : int = int(cell.x)
	var hr : int = int(cell.y)
	var output = hq ^ (hr + 0x9e3779b9 + (hq << 6) + (hq >> 2))

	return output

static func neighbor(cell : Vector3, dir : int) -> Vector3:
	return cell + direction(dir)

static func axial_from_cube(cell : Vector3) -> Vector2:
	return Vector2(cell.x, cell.z)

static func axial_to_cube(cell : Vector2) -> Vector3:
	return Vector3(cell.x, -cell.x - cell.y, cell.y)
	
static func cells_from_vectors(cell : Vector3, vectors : Array) -> PoolVector3Array:
	var cells = PoolVector3Array()
	for vector in vectors:
		cells.push_back(cell + vector)

	return cells

static func all_within(cell : Vector3, distance : int) -> PoolVector3Array:
	var cells = PoolVector3Array()
	for x in range(-distance, distance + 1):
		for y in range(max(-distance, -distance - x), min(distance, distance - x) + 1):
			cells.push_back(cell + Vector3(x, -x-y, y))

	return cells
	
static func line(start_cell : Vector3, end_cell : Vector3) -> PoolVector3Array:
	var cells = PoolVector3Array()

	var distance : float = start_cell.distance_to(end_cell)
	if distance < 1:
		cells.push_back(start_cell)
		return cells

	for i in distance:
		var position = start_cell.linear_interpolate(end_cell, 1.0 / distance * i)
		cells.push_back(round_cell(position))

	return cells

static func ring(cell : Vector3, distance : int) -> PoolVector3Array:
	var cells = PoolVector3Array()

	if distance < 1:
		cells.push_back(cell)
		return cells

	var current_cell = cell + (DIRECTION_N * distance)
	for dir in [DIRECTION_SE, DIRECTION_S, DIRECTION_SW, DIRECTION_NW, DIRECTION_N, DIRECTION_NE]:
		for _step in range(distance):
			cells.push_back(current_cell)
			current_cell = current_cell + dir

	return cells

static func spiral(cell : Vector3, radius : int) -> PoolVector3Array:
	var cells = PoolVector3Array()
	cells.push_back(cell)

	for i in radius + 1:
		cells.append_array(ring(cell, i))

	return cells

static func offset_from_cube(cell : Vector3) -> Vector2:
	var col = cell.x + (cell.z - (int(cell.z) & 1)) / 2
	var row = cell.z

	return Vector2(col, row)

static func offset_to_cube(cell : Vector2) -> Vector3:
	var x : float = cell.x - (cell.y - (int(cell.y) & 1)) / 2
	var z : float = cell.y
	var y : float = -x-z

	return Vector3(x, y, z)

static func reflect_x(cell : Vector3) -> Vector3: 
	return Vector3(cell.x, cell.z, cell.y)

static func reflect_y(cell : Vector3) -> Vector3: 
	return Vector3(cell.z, cell.y, cell.x)

static func reflect_z(cell : Vector3) -> Vector3: 
	return Vector3(cell.y, cell.x, cell.z)

static func rotate_left(cell : Vector3) -> Vector3:
	return Vector3(-cell.z, -cell.x, -cell.y);

static func rotate_right(cell : Vector3) -> Vector3:
	return Vector3(-cell.y, -cell.z, -cell.x);

static func round_cell(cell : Vector3) -> Vector3:
	var rx : float = round(cell.x)
	var ry : float = round(cell.y)
	var rz : float = round(cell.z)

	var x_diff : float = abs(rx - cell.x)
	var y_diff : float = abs(ry - cell.y)
	var z_diff : float = abs(rz - cell.z)

	if x_diff > y_diff and x_diff > z_diff:
		rx = -ry-rz
	elif y_diff > z_diff:
		ry = -rx-rz
	else:
		rz = -rx-ry

	return Vector3(rx, ry, rz)
